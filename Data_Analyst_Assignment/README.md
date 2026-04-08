# PlatinumRx Data Analyst Assignment

This repository contains my solutions for the Data Analyst Assignment, encompassing SQL proficiency, Spreadsheet proficiency, and Python programming tasks.

## 📂 Project Structure

```text
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql     (DDL & DML queries for Hotel System)
│   ├── 02_Hotel_Queries.sql          (Solutions for Hotel System Q1-Q5)
│   ├── 03_Clinic_Schema_Setup.sql    (DDL & DML queries for Clinic System)
│   └── 04_Clinic_Queries.sql         (Solutions for Clinic System Q1-Q5)
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx          (Contains data and analysis for Phase 2)
├── Python/
│   ├── 01_Time_Converter.py          (Python script for minutes to hours/minutes conversion)
│   └── 02_Remove_Duplicates.py       (Python script to remove duplicate characters using loops)
└── README.md                         (This file)
```

## 🛠️ Phase 1: SQL Proficiency

All the SQL code is standard ANSI SQL (MySQL/PostgreSQL compatible) and split into schema creation (`_Schema_Setup.sql`) and analysis queries (`_Queries.sql`).

### Hotel System Queries Approach
- **Q1 (Last booked room):** Implemented using the `ROW_NUMBER()` window function grouped by `user_id` and ordered by `booking_date` in descending order, then returning only rank 1.
- **Q2 (November Bookings):** Completed using multiple `JOIN`s to link `bookings` with `booking_commercials` and `items`, filtering on dates in November 2021, and summing up `quantity * rate`.
- **Q3 (October Bills > 1000):** Leveraged the `HAVING` clause to filter out aggregated values of bills formed in October 2021.
- **Q4 (Most/Least ordered item):** A Common Table Expression (CTE) was used alongside the `RANK()` window function. We partitioned by the `billing_month` string formatted from the date.
- **Q5 (2nd Highest Bill):** Utilized a `DENSE_RANK()` window function grouping by month, to ensure accurate ranking ties, returning rankings that fall exactly at `2`.

### Clinic System Queries Approach
- **Q1 & Q2:** Used Standard `GROUP BY` and aggregations on the `sales_channel` and `customer` objects respectively.
- **Q3 (Month Wise P&L):** Leveraged a full outer join (simulated using `LEFT UNION RIGHT` for MySQL compatibility) to bring `MonthlyRevenue` and `MonthlyExpenses` together. The calculation is effectively `Revenue - Expenses`.
- **Q4 & Q5:** Used window functions (`RANK` and `DENSE_RANK`) to partition by state/city and rank the gross calculated profits (descending or ascending based on most/least profitable).

---

## 📈 Phase 2: Spreadsheet Proficiency

Since an active spreadsheet link format needs the detailed breakdown, here are the step-by-step solutions used within `Ticket_Analysis.xlsx`.

### 1. Populate 'ticket_created_at' in feedbacks
- **Objective:** Pull `created_at` from the `ticket` sheet into the `feedbacks` sheet.
- **Solution:** `cms_id` acts as the unique identifier.
- **Excel Formula Used:** 
  ```excel
  =VLOOKUP(A2, 'ticket'!A:E, 2, FALSE)
  ```
  *(Assuming `cms_id` is Col A in `feedbacks` and Col E in `ticket`, with `created_at` being Col B in `ticket`. Wait, standard VLOOKUP needs the lookup col to be the first one. Let's use `INDEX-MATCH` or `XLOOKUP` since `cms_id` is the 5th column).*
- **Optimal Excel Formula:**
  ```excel
  =INDEX('ticket'!B:B, MATCH(A2, 'ticket'!E:E, 0))
  ```

### 2. Fetch outlet-wise count of tickets created AND closed
- **Objective:** Find the conditions where creation and closing happened on the **same day** and **same hour**, broken down per outlet.
- **Solution Steps:**
    1. **Helper Column 1 (Same Day?):** Evaluate the date part of the `created_at` and `closed_at`.
       `=INT(B2)=INT(C2)`
    2. **Helper Column 2 (Same Hour?):** Evaluate both the day and the hour.
       `=AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2))`
    3. **Aggregation:** Create a Pivot Table plotting the `outlet_id` in rows, and sum/count the `TRUE` values of our helper columns, or use `COUNTIFS`.
- **COUNTIFS Formula Example (Same Hour & Same Day for Outlet ID):**
  ```excel
  =COUNTIFS(ticket!D:D, "wrqy-juv-97", ticket!F:F, TRUE)
  ```
  *(Assuming Col F is our "Same Hour & Same Day" helper column)*

---

## 🐍 Phase 3: Python Proficiency

Two basic functions tested via `01_Time_Converter.py` and `02_Remove_Duplicates.py`:
- **Time Converter:** Converts integers to readable strings exclusively utilizing the modulo `//` and `%` mathematical operators to avoid complicated datetime libraries.
- **Remove Duplicates:** A straightforward loop mechanism iterating characters one by one and inserting them into an empty string variable conditionally if they don't already exist.

You can verify it by executing them directly:
```bash
python Python/01_Time_Converter.py
python Python/02_Remove_Duplicates.py
```
