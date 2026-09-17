"""
db_connection.py
-----------------
Single place that knows how to open a connection to the database.
Uses SQLite (Python's built-in sqlite3 module) so the whole project
runs with zero installation beyond Python itself.

If your course requires MySQL instead, see the "Porting to MySQL"
section in the README — you'd mainly replace this file's contents
with a mysql-connector-python connection.
"""

import os
import sqlite3

# The .db file lives at the project root, one level up from /scripts
DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "fraud_database.db")


def get_connection():
    """Return a sqlite3 connection with foreign key enforcement turned on."""
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    conn.row_factory = sqlite3.Row  # lets us access columns by name
    return conn


def run_schema():
    """(Re)build the database from sql/schema.sql. Destructive: drops and recreates all tables."""
    schema_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "sql", "schema.sql")
    with open(schema_path, "r") as f:
        schema_sql = f.read()

    conn = get_connection()
    conn.executescript(schema_sql)
    conn.commit()
    conn.close()
    print(f"Database created/reset at {DB_PATH}")


if __name__ == "__main__":
    run_schema()
