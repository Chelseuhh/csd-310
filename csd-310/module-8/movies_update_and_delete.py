
# Establishing connection to the MySQL database
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

# Function to display films with associated labels
def show_films(cursor, label):
    print(f"\n{label}\n")
    cursor.execute("SELECT f.film_name, f.film_releaseDate, f.film_runtime, f.film_director, s.studio_name, g.genre_name "
                   "FROM film f "
                   "JOIN studio s ON f.studio_id = s.studio_id "
                   "JOIN genre g ON f.genre_id = g.genre_id")
    
    films = cursor.fetchall()
    for film in films:
        print(f"Film Name: {film[0]}")
        print(f"Release Date: {film[1]}")
        print(f"Runtime: {film[2]} minutes")
        print(f"Director: {film[3]}")
        print(f"Studio: {film[4]}")
        print(f"Genre: {film[5]}")
        print("-" * 30)

# Insert a new film record
def insert_film(cursor, connection):
    insert_query = """
        INSERT INTO film(film_name, film_releaseDate, film_runtime, film_director, studio_id, genre_id)
        VALUES (%s, %s, %s, %s, (SELECT studio_id FROM studio WHERE studio_name = %s), (SELECT genre_id FROM genre WHERE genre_name = %s));
    """
    new_film = ('The Matrix', '1999', '136', 'The Wachowskis', 'Warner Bros.', 'SciFi')
    cursor.execute(insert_query, new_film)
    connection.commit()

# Update the genre of the film "Alien"
def update_film_genre(cursor, connection):
    update_query = """
        UPDATE film
        SET genre_id = (SELECT genre_id FROM genre WHERE genre_name = 'Horror')
        WHERE film_name = 'Alien';
    """
    cursor.execute(update_query)
    connection.commit()

# Delete the film "Gladiator"
def delete_film(cursor, connection):
    delete_query = "DELETE FROM film WHERE film_name = 'Gladiator';"
    cursor.execute(delete_query)
    connection.commit()

# Main function to run the tasks
def main():
    connection = connect_to_db()
    cursor = connection.cursor()

    # Display films before any changes
    show_films(cursor, "DISPLAYING FILMS BEFORE CHANGES")

    # Insert a new film
    insert_film(cursor, connection)
    show_films(cursor, "DISPLAYING FILMS AFTER INSERTION")

    # Update the genre of 'Alien' to Horror
    update_film_genre(cursor, connection)
    show_films(cursor, "DISPLAYING FILMS AFTER ALIEN GENRE UPDATE")

    # Delete 'Gladiator' from the database
    delete_film(cursor, connection)
    show_films(cursor, "DISPLAYING FILMS AFTER GLADIATOR DELETION")

    # Close the cursor and connection
    cursor.close()
    connection.close()

if __name__ == "__main__":
    main()
