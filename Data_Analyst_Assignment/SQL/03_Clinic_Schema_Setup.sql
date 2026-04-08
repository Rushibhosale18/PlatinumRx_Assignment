-- 03_Clinic_Schema_Setup.sql
-- Setup script for Clinic Management System

-- Create Clinics table
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Insert sample data for Clinics
INSERT INTO clinics (cid, clinic_name, city, state, country)
VALUES
('cnc-0100001', 'XYZ clinic', 'lorem', 'ipsum', 'dolor'),
('cnc-0100002', 'ABC clinic', 'lorem', 'ipsum', 'dolor'),
('cnc-demo2', 'City Clinic', 'Metropolis', 'NY', 'USA');


-- Create Customer table
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

-- Insert sample data for Customer
INSERT INTO customer (uid, name, mobile)
VALUES 
('bk-09f3e-95hj', 'Jon Doe', '97XXXXXXXX'),
('usr-002', 'Jane Smith', '98XXXXXXXX');


-- Create Clinic_Sales table
CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Insert sample data for Clinic Sales
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel)
VALUES 
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999.00, '2021-09-23 12:03:22', 'sodat'),
('ord-002', 'usr-002', 'cnc-0100002', 15000.00, '2021-09-24 14:00:00', 'online'),
('ord-003', 'bk-09f3e-95hj', 'cnc-demo2', 5000.00, '2021-09-25 10:00:00', 'sodat');


-- Create Expenses table
CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description TEXT,
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Insert sample data for Expenses
INSERT INTO expenses (eid, cid, description, amount, datetime)
VALUES 
('exp-0100-00100', 'cnc-0100001', 'first-aid supplies', 557.00, '2021-09-23 07:36:48'),
('exp-002', 'cnc-0100002', 'rent', 10000.00, '2021-09-01 00:00:00'),
('exp-003', 'cnc-demo2', 'utilities', 2000.00, '2021-09-05 00:00:00');
