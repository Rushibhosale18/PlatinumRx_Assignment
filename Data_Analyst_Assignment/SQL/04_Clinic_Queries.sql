-- 04_Clinic_Queries.sql
-- Solutions for Clinic Management System

-- 1. Find the revenue we got from each sales channel in a given year (e.g. 2021)
-- Logic: Group by sales_channel and sum amount for the year 2021.
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- 2. Find top 10 the most valuable customers for a given year (e.g. 2021)
-- Logic: The value of a customer is determined by the total revenue they generated. Sum amounts and order descending.
SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_value
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY c.uid, c.name
ORDER BY total_value DESC
LIMIT 10;


-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year (e.g. 2021)
-- Logic: Calculate monthly revenue and monthly expenses. Join both, then calculate profit and status.
WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS billing_month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
),
MonthlyExpenses AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS billing_month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
)
SELECT 
    COALESCE(r.billing_month, e.billing_month) AS month,
    COALESCE(r.total_revenue, 0) AS revenue,
    COALESCE(e.total_expense, 0) AS expense,
    COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) AS profit,
    CASE 
        WHEN (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)) >= 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM MonthlyRevenue r
LEFT JOIN MonthlyExpenses e ON r.billing_month = e.billing_month
UNION
SELECT 
    COALESCE(r.billing_month, e.billing_month) AS month,
    COALESCE(r.total_revenue, 0) AS revenue,
    COALESCE(e.total_expense, 0) AS expense,
    COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) AS profit,
    CASE 
        WHEN (COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0)) >= 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM MonthlyRevenue r
RIGHT JOIN MonthlyExpenses e ON r.billing_month = e.billing_month;


-- 4. For each city find the most profitable clinic for a given month (e.g. 2021-09)
-- Logic: Find clinic profits in a month, then rank them inside each city partition.
WITH ClinicProfit AS (
    SELECT 
        c.cid,
        c.clinic_name,
        c.city,
        (IFNULL(SUM(cs.amount), 0) - IFNULL(SUM(e.amount), 0)) AS total_profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid AND DATE_FORMAT(cs.datetime, '%Y-%m') = '2021-09'
    LEFT JOIN expenses e ON c.cid = e.cid AND DATE_FORMAT(e.datetime, '%Y-%m') = '2021-09'
    GROUP BY c.cid, c.clinic_name, c.city
), 
RankedProfits AS (
    SELECT 
        cid,
        clinic_name,
        city,
        total_profit,
        RANK() OVER(PARTITION BY city ORDER BY total_profit DESC) as rnk
    FROM ClinicProfit
)
SELECT city, clinic_name, total_profit
FROM RankedProfits
WHERE rnk = 1;


-- 5. For each state find the second least profitable clinic for a given month (e.g. 2021-09)
-- Logic: Same as above but order ascending and pick rank 2 by state.
WITH ClinicProfit AS (
    SELECT 
        c.cid,
        c.clinic_name,
        c.state,
        (IFNULL(SUM(cs.amount), 0) - IFNULL(SUM(e.amount), 0)) AS total_profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid AND DATE_FORMAT(cs.datetime, '%Y-%m') = '2021-09'
    LEFT JOIN expenses e ON c.cid = e.cid AND DATE_FORMAT(e.datetime, '%Y-%m') = '2021-09'
    GROUP BY c.cid, c.clinic_name, c.state
), 
RankedProfits AS (
    SELECT 
        cid,
        clinic_name,
        state,
        total_profit,
        DENSE_RANK() OVER(PARTITION BY state ORDER BY total_profit ASC) as rnk
    FROM ClinicProfit
)
SELECT state, clinic_name, total_profit
FROM RankedProfits
WHERE rnk = 2;
