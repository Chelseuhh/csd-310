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

    # Roles table
    cursor.execute("SELECT id, role_name, description FROM role")
    roles = cursor.fetchall()
    print("-- Role --")
    for role in roles:
        print(
            "Role ID: {}\nRole Name: {}\nDescription: {}\n".format(
                role[0], role[1], role[2]
            )
        )

    # Employees table
    cursor.execute("SELECT id, name, hours, role_id FROM Employees")
    employees = cursor.fetchall()
    print("-- Employees --")
    for employee in employees:
        print(
            "Employee ID: {}\nName: {}\nHours (Quarterly): {}\nRole ID: {}\n".format(
                employee[0], employee[1], employee[2], employee[3]
            )
        )

    # Suppliers table
    cursor.execute("SELECT id, name FROM Suppliers")
    suppliers = cursor.fetchall()
    print("-- Suppliers --")
    for supplier in suppliers:
        print("Supplier ID: {}\nSupplier Name: {}\n".format(supplier[0], supplier[1]))

    # Inventory table
    cursor.execute(
        "SELECT id, supplier_id, component_type, quantity_on_hand, last_updated FROM Inventory"
    )
    inventory = cursor.fetchall()
    print("-- Inventory --")
    for item in inventory:
        print(
            "Inventory ID: {}\nSupplier ID: {}\nComponent Type: {}\nQuantity on Hand: {}\nLast Updated: {}\n".format(
                item[0], item[1], item[2], item[3], item[4]
            )
        )

    # Wine Inventory table
    cursor.execute(
        "SELECT id, wine_type, quantity_on_hand, last_updated FROM WineInventory"
    )
    wine_inventory = cursor.fetchall()
    print("-- Wine Inventory --")
    for wine in wine_inventory:
        print(
            "Wine ID: {}\nWine Type: {}\nQuantity on Hand: {}\nLast Updated: {}\n".format(
                wine[0], wine[1], wine[2], wine[3]
            )
        )

    # Distributor table
    cursor.execute("SELECT id, name FROM Distributor")
    distributors = cursor.fetchall()
    print("-- Distributors --")
    for distributor in distributors:
        print(
            "Distributor ID: {}\nDistributor Name: {}\n".format(
                distributor[0], distributor[1]
            )
        )

    # Orders table
    cursor.execute("SELECT id, order_date, status, total_amount FROM Orders")
    orders = cursor.fetchall()
    print("-- Orders --")
    for order in orders:
        print(
            "Order ID: {}\nOrder Date: {}\nStatus: {}\nTotal Amount: {}\n".format(
                order[0], order[1], order[2], order[3]
            )
        )

    # Sales table
    cursor.execute(
        "SELECT id, order_id, quantity_sold, sale_date, distributor_id, sales_channel FROM Sales"
    )
    sales = cursor.fetchall()
    print("-- Sales --")
    for sale in sales:
        print(
            "Sales ID: {}\nOrder ID: {}\nQuantity Sold: {}\nSale Date: {}\nDistributor ID: {}\nSales Channel: {}\n".format(
                sale[0], sale[1], sale[2], sale[3], sale[4], sale[5]
            )
        )

    # Delivery table
    cursor.execute("SELECT id, item_id, expected_delivery_date, status FROM Delivery")
    deliveries = cursor.fetchall()
    print("-- Deliveries --")
    for delivery in deliveries:
        print(
            "Delivery ID: {}\nItem ID: {}\nExpected Delivery Date: {}\nStatus: {}\n".format(
                delivery[0], delivery[1], delivery[2], delivery[3]
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
