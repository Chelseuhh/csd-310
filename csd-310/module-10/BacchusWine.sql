-- drop database user if exists 
DROP USER IF EXISTS 'wine_user'@'localhost';


-- create wine_user and grant them all privileges to the wine database 
CREATE USER 'wine_user'@'localhost' IDENTIFIED BY 'bringonthebooze';

-- grant all privileges to the movies database to user movies_user on localhost 
GRANT ALL PRIVILEGES ON bacchus_wine.* TO 'wine_user'@'localhost';

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
    quantity_sold INT NOT NULL,
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
('Sam Lake', 40.00, 1),
('Ash Ketchum', 35.50, 2),
('Mash Burnedead', 45.00, 3),
('Harry Potter', 30.00, 4),
('Link Swordsman', 50.00, 5),
('Miles Morales', 38.00, 1);

-- Insert data into Suppliers table
INSERT INTO Suppliers (name) VALUES 
('Corks and Bottles R US'), 
('FedEx Wine and Beer'), 
('Big Ole Tubs');

-- Insert data into Inventory table
INSERT INTO Inventory (supplier_id, component_type, quantity_on_hand, last_updated) VALUES
(1, 'Glass Bottles', 500, '2024-01-15'),
(1, 'Corks', 300, '2024-03-22'),
(2, 'Labels', 1000, '2024-02-10'),
(2, 'Packaging Boxes', 600, '2024-05-12'),
(3, 'Vats', 150, '2024-04-11'),
(3, 'Tubing', 800, '2024-06-01');

-- Insert data into WineInventory table
INSERT INTO WineInventory (wine_type, quantity_on_hand, last_updated) VALUES
('Merlot', 200, '2024-01-20'),
('Cabernet', 150, '2024-02-15'),
('Chablis', 100, '2024-03-10'),
('Chardonnay', 120, '2024-04-05');

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
('2024-01-10', 'Completed', 500.00),
('2024-02-05', 'Processing', 300.00),
('2024-03-15', 'Cancelled', 0.00),
('2024-04-12', 'Completed', 450.00),
('2024-05-08', 'Pending', 600.00),
('2024-06-25', 'Completed', 700.00);

-- Insert data into Sales table
INSERT INTO Sales (order_id, quantity_sold, sale_date, distributor_id, sales_channel) VALUES
(1, 50, '2024-01-12', 1, 'Online'),
(2, 30, '2024-02-07', 2, 'Retail'),
(3, 0, '2024-03-18', 3, 'Cancelled'),
(4, 45, '2024-04-14', 4, 'Online'),
(5, 60, '2024-05-10', 5, 'Retail'),
(6, 70, '2024-06-27', 6, 'Wholesale');

-- Insert data into Delivery table
INSERT INTO Delivery (item_id, expected_delivery_date, status) VALUES
(1, '2024-01-30', 'Delivered'),
(2, '2024-02-25', 'Pending'),
(3, '2024-03-20', 'Delivered'),
(4, '2024-04-25', 'Pending'),
(5, '2024-05-30', 'Delivered'),
(6, '2024-06-20', 'Pending');