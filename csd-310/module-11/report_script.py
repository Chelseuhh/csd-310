# Group 2
# Authors: Chelsea Hefferin, Miqueas Herrera, Jacob Isdell, Jimmy Jones
# Date: 09/27/2024
# Assignment: Module 10
# Description: Python script to display all the table information of the wine database

import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "wine_user",
    "password": "bringonthebooze",
    "host": "127.0.0.1",
    "database": "bacchus_wine",
    "raise_on_warnings": True,
}

try:
    db = mysql.connector.connect(**config)
    print(
        "\n Database user {} connected to MySQL on host {} with database {}".format(
            config["user"], config["host"], config["database"]
        )
    )
    input("\n\n Press any key to continue... \n")

    cursor = db.cursor()

    # Sales Report
    cursor.execute(
        "SELECT w.wine_type as 'Wine Type', SUM(ow.quantity) AS 'Total Sold', d.name AS 'Distributor Name' FROM Sales s JOIN OrderWines ow ON s.order_id = ow.order_id JOIN WineInventory w ON ow.wine_id = w.id JOIN Distributor d ON s.distributor_id = d.id GROUP BY w.wine_type, d.name ORDER BY SUM(ow.quantity) DESC;"
    )
    sales = cursor.fetchall()
    print("-- Sales Report --")
    for sale in sales:
        print(
            "Wine Type: {}\nTotal Wine Type Sold at Distributor: {}\nDistributor: {}\n".format(
                sale[0], sale[1], sale[2]
            )
        )

    input("\n Press any key to continue... \n")

    # Hours Report
    cursor.execute(
        "SELECT e.name, e.hours, r.role_name FROM Employees e JOIN Role r ON r.id = e.role_id ORDER BY e.hours DESC;"
    )
    employees = cursor.fetchall()
    print("-- Weekly Hours Report --")
    for employee in employees:
        print(
            "Employee Name: {}\nHours: {}\nRole: {}\n".format(
                employee[0], employee[1], employee[2]
            )
        )

    input("\n Press any key to continue... \n")

    # Supplies Report
    cursor.execute(
        "SELECT s.name AS supplier_name, i.component_type, i.quantity_on_hand, i.last_updated, d.expected_delivery_date, d.status FROM Delivery d JOIN Inventory i ON d.item_id = i.id JOIN Suppliers s ON i.supplier_id = s.id WHERE d.status != 'Delivered' ORDER BY d.expected_delivery_date DESC;"
    )
    deliveries = cursor.fetchall()
    print("-- Supplies Report --")
    for delivery in deliveries:
        print(
            "Supplier: {}\nComponent: {}\nOn Hand: {}\nLast Delivery: {}\nExpected Delivery: {}\nStatus: {}\n".format(
                delivery[0],
                delivery[1],
                delivery[2],
                delivery[3],
                delivery[4],
                delivery[5],
            )
        )

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist")
    else:
        print(err)
finally:
    db.close()
