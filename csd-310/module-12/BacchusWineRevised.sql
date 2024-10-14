-- drop database user if exists 
DROP USER IF EXISTS 'wine_user'@'localhost';


-- create wine_user and grant them all privileges to the wine database 
CREATE USER 'wine_user'@'localhost' IDENTIFIED BY 'bringonthebooze';

-- grant all privileges to the movies database to user movies_user on localhost 
GRANT ALL PRIVILEGES ON bacchus_wine.* TO 'wine_user'@'localhost';

DROP DATABASE IF EXISTS bacchus_wine;

CREATE DATABASE bacchus_wine;

USE bacchus_wine;

-- Drop existing tables if they exist (to avoid conflict)
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Distributor;
DROP TABLE IF EXISTS WineInventory;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS OrderWines;


-- Create the tables

CREATE TABLE Role (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE Employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    hours DECIMAL(5, 2) NOT NULL,
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE Suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    component_type VARCHAR(100),
    quantity_on_hand INT NOT NULL,
    last_updated DATE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(id)
);

CREATE TABLE WineInventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    wine_type VARCHAR(100) NOT NULL,
    quantity_on_hand INT NOT NULL,
    last_updated DATE
);

CREATE TABLE Distributor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    status VARCHAR(50),
    total_amount DECIMAL(10, 2)
);

CREATE TABLE Sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    sale_date DATE,
    distributor_id INT,
    sales_channel VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (distributor_id) REFERENCES Distributor(id)
);

CREATE TABLE Delivery (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT,
    expected_delivery_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (item_id) REFERENCES Inventory(id)
);

CREATE TABLE OrderWines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    wine_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (wine_id) REFERENCES WineInventory(id)
);

-- Insert data into Role table 
INSERT INTO Role (role_name, description) VALUES 
('Sales', 'Handles sales and customer interactions'),
('Payroll', 'Handles payments and payroll'),
('Distribution', 'Manages the distribution of products'),
('Marketing', 'Handles marketing and promotion activities'),
('Production', 'Oversees the production of goods'),
('Inventory', 'Manages stock levels and restocking');

-- Insert data into Employees table
INSERT INTO Employees (name, hours, role_id) VALUES
('Stan Bacchus', 60.00, 1),
('Davis Bacchus', 60.00, 1),
('Janet Collins', 35.50, 2),
('Maria Costanza', 45.00, 3),
('Roz Murphy', 30.00, 4),
('Henry Doyle', 50.00, 5),
('Bob Ulrich', 38.00, 4);

-- Insert data into Suppliers table
INSERT INTO Suppliers (name) VALUES 
('Corks and Bottles R US'), 
('FedEx Wine and Beer'), 
('Big Ole Tubs');

-- Insert data into Inventory table
INSERT INTO Inventory (supplier_id, component_type, quantity_on_hand, last_updated) VALUES
(1, 'Glass Bottles', 500, '2024-09-30'),
(1, 'Corks', 300, '2024-08-22'),
(2, 'Labels', 1000, '2024-09-20'),
(2, 'Packaging Boxes', 600, '2024-08-12'),
(3, 'Vats', 150, '2024-08-31'),
(3, 'Tubing', 800, '2024-09-01');

-- Insert data into WineInventory table
INSERT INTO WineInventory (wine_type, quantity_on_hand, last_updated) VALUES
('Merlot', 200, '2024-09-20'),
('Cabernet', 150, '2024-08-15'),
('Chablis', 100, '2024-09-10'),
('Chardonnay', 120, '2024-09-05');

-- Insert data into Distributor table
INSERT INTO Distributor (name) VALUES 
('Target'),
('WalMart'),
('Kroger'),
('Publix'),
('Hy-Vee'),
('HEB');

-- Insert data into Orders table
INSERT INTO Orders (order_date, status, total_amount) VALUES
('2024-09-10', 'Completed', 500.00),
('2024-09-05', 'Processing', 300.00),
('2024-08-15', 'Completed', 50.00),
('2024-09-12', 'Completed', 450.00),
('2024-09-08', 'Pending', 600.00),
('2024-09-25', 'Completed', 700.00);

-- Insert data into Sales table
INSERT INTO Sales (order_id, quantity_sold, sale_date, distributor_id, sales_channel) VALUES
(1, '2024-09-12', 1, 'B2B'),
(2, '2024-08-07', 2, 'B2B'),
(3, '2024-07-18', NULL, 'Online'),
(4, '2024-09-14', 4, 'B2B'),
(5, '2024-08-10', 3, 'B2B'),
(6, '2024-06-27', 4, 'B2B');

-- Insert data into Delivery table
INSERT INTO Delivery (item_id, expected_delivery_date, status) VALUES
(1, '2024-09-30', 'Delivered'),
(2, '2024-10-10', 'Pending'),
(3, '2024-09-20', 'Delivered'),
(4, '2024-10-09', 'Pending'),
(5, '2024-08-31', 'Delivered'),
(6, '2024-10-08', 'Pending');

-- Insert data into OrderWines table to establish the relationship
INSERT INTO OrderWines (order_id, wine_id, quantity) VALUES
(1, 1, 10),  -- Order 1 contains 10 units of Merlot
(1, 2, 5),   -- Order 1 also contains 5 units of Cabernet
(2, 3, 8),   -- Order 2 contains 8 units of Chablis
(3, 4, 12),  -- Order 3 contains 12 units of Chardonnay
(4, 1, 7),   -- Order 4 contains 7 units of Merlot
(5, 2, 10),  -- Order 5 contains 10 units of Cabernet
(6, 2, 10);  -- Order 6 contains 8 units of Cabernet