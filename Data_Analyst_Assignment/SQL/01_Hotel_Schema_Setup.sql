-- 01_Hotel_Schema_Setup.sql
-- Setup script for Hotel Management System

-- Create Users table
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);

-- Insert sample data for Users
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address)
VALUES 
('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City');


-- Create Bookings table
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert sample data for Bookings
INSERT INTO bookings (booking_id, booking_date, room_no, user_id)
VALUES 
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
-- Adding a few extra records to adequately test the queries (dates in Oct, Nov)
('bk-nov-001', '2021-11-15 10:00:00', 'rm-101', '21wrcxuy-67erfn'),
('bk-oct-002', '2021-10-05 14:00:00', 'rm-102', '21wrcxuy-67erfn');


-- Create Items table
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10, 2)
);

-- Insert sample data for Items
INSERT INTO items (item_id, item_name, item_rate)
VALUES 
('itm-a9e8-q8fu', 'Tawa Paratha', 18.00),
('itm-a07vh-aer8', 'Mix Veg', 89.00),
('itm-w978-23u4', 'Paneer Butter Masala', 120.00);


-- Create Booking Commercials table
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert sample data for Booking Commercials
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES 
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
-- Additional record added to make queries easier to test
('134lr-oyfo8-3qk4', 'bk-nov-001', 'bl-34qhd-r7h8', '2021-11-15 12:05:37', 'itm-w978-23u4', 0.5),
('bl-oct-item1', 'bk-oct-002', 'bl-oct-123', '2021-10-06 10:00:00', 'itm-w978-23u4', 10);
