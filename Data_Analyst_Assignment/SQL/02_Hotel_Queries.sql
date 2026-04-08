-- 02_Hotel_Queries.sql
-- Solutions for Hotel Management System

-- 1. For every user in the system, get the user_id and last booked room_no
-- Logic: We use ROW_NUMBER() over partitioning by user_id and ordering by booking_date descending.
WITH RankedBookings AS (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
)
SELECT user_id, room_no AS last_booked_room_no
FROM RankedBookings
WHERE rn = 1;


-- 2. Get booking_id and total billing amount of every booking created in November, 2021
-- Logic: Join bookings with booking_commercials and items, calculate total as quantity * rate. Wait, we filter on booking_date directly.
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;


-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
-- Logic: Filter on bill_date in October, calculate amount, use HAVING for > 1000.
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- 4. Determine the most ordered and least ordered item of each month of year 2021
-- Logic: We need the sum of quantities by month and item. Then use MIN and MAX or Window Functions per month.
WITH MonthlyStats AS (
    SELECT 
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS billing_month,
        i.item_name,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), i.item_name
), RankedItems AS (
    SELECT 
        billing_month,
        item_name,
        total_quantity,
        RANK() OVER(PARTITION BY billing_month ORDER BY total_quantity DESC) as rank_desc,
        RANK() OVER(PARTITION BY billing_month ORDER BY total_quantity ASC) as rank_asc
    FROM MonthlyStats
)
SELECT 
    billing_month,
    MAX(CASE WHEN rank_desc = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_asc = 1 THEN item_name END) AS least_ordered_item
FROM RankedItems
GROUP BY billing_month;


-- 5. Find the customers with the second highest bill value of each month of year 2021
-- Logic: Sum bill values per month and customer, rank them descending, pick Rank = 2.
WITH MonthlyBills AS (
    SELECT 
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS billing_month,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS total_bill_value
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), b.user_id
), RankedBills AS (
    SELECT 
        billing_month,
        user_id,
        total_bill_value,
        DENSE_RANK() OVER(PARTITION BY billing_month ORDER BY total_bill_value DESC) as bill_rank
    FROM MonthlyBills
)
SELECT 
    billing_month,
    user_id,
    total_bill_value
FROM RankedBills
WHERE bill_rank = 2;
