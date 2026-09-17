"""
advanced_queries.py
--------------------
Runs the advanced SQL queries from sql/queries.sql against the
populated database and prints the results. This is what you'd
demo to show off your SQL skills for task 6.

Run:
    python scripts/advanced_queries.py
"""

import os

from db_connection import get_connection

QUERIES_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "sql", "queries.sql")


def load_queries():
    """Split queries.sql into individual (comment_title, sql) pairs on the blank-line-separated blocks."""
    with open(QUERIES_PATH, "r") as f:
        content = f.read()

    blocks = [b.strip() for b in content.split("\n\n") if b.strip() and not b.strip().startswith("-- ====")]
    queries = []
    for block in blocks:
        lines = block.splitlines()
        title_lines = [l[3:].strip() for l in lines if l.strip().startswith("--")]
        sql = "\n".join(l for l in lines if not l.strip().startswith("--")).strip()
        if sql:
            title = title_lines[0] if title_lines else "Query"
            queries.append((title, sql))
    return queries


def run_all():
    conn = get_connection()
    for title, sql in load_queries():
        print("\n" + "=" * 70)
        print(title)
        print("=" * 70)
        rows = conn.execute(sql).fetchall()
        if not rows:
            print("(no rows)")
            continue
        headers = rows[0].keys()
        print(" | ".join(headers))
        for row in rows:
            print(" | ".join(str(row[h]) for h in headers))
    conn.close()


if __name__ == "__main__":
    run_all()
