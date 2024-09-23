#Chelsea Hefferin Module 7 9/22/3024cm

import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "movies_user",
    "password": "popcorn",
    "host": "127.0.0.1",
    "database": "movies",
    "auth_plugin": "mysql_native_password",
    "raise_on_warnings": True
}

def fetch_and_display(query, headers, title):
    cursor.execute(query)
    results = cursor.fetchall()

    print(f"\n-- DISPLAYING {title} --")
    for row in results:
        for header, value in zip(headers, row):
            print(f"{header}: {value}")
        print()

try:
    db = mysql.connector.connect(**config)
    print(f"\nDatabase user {config['user']} connected to MySQL on host {config['host']} with database {config['database']}")
    
    cursor = db.cursor()

    # Queries
    queries = {
        "Studio": ("SELECT studio_id, studio_name FROM studio;", ["Studio ID", "Studio Name"]),
        "Genre": ("SELECT genre_id, genre_name FROM genre;", ["Genre ID", "Genre Name"]),
        "Short Films": ("SELECT film_name, film_runtime FROM film WHERE film_runtime < 120;", ["Film Name", "Film Runtime"]),
        "Directors": ("SELECT film_name, film_director FROM film ORDER BY film_director;", ["Film Name", "Film Director"])
    }

    # Execute each query
    fetch_and_display(*queries["Studio"], "Studio RECORDS")
    fetch_and_display(*queries["Genre"], "Genre RECORDS")
    fetch_and_display(*queries["Short Films"], "Short Film RECORDS")
    fetch_and_display(*queries["Directors"], "Director RECORDS in Order")

    input("\n\nPress any key to continue...")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password are invalid.")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist.")
    else:
        print(err)

finally:
    if 'db' in locals() and db.is_connected():
        db.close()
