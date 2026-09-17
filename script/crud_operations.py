"""
crud_operations.py
-------------------
Basic SQL operations (Create, Read, Update, Delete) against the
fraud database, demonstrated on the Person and Fraud_Incident tables.

Run this file directly for a small live demo:
    python scripts/crud_operations.py
"""

from db_connection import get_connection


# ---------------------------------------------------------------
# CREATE
# ---------------------------------------------------------------
def add_person(age, occupation, income, education_level, gender):
    """Insert a new person and return their new Person_ID."""
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO Person (Age, Occupation, Income, Education_level, Gender)
        VALUES (?, ?, ?, ?, ?)
        """,
        (age, occupation, income, education_level, gender),
    )
    conn.commit()
    new_id = cur.lastrowid
    conn.close()
    return new_id


def add_fraud_incident(person_id, fraud_type_id, channel_id, incident_date, financial_loss_amount):
    """Insert a new fraud incident and return its new Fraud_Incident_ID."""
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO Fraud_Incident (Person_ID, Fraud_Type_ID, Channel_ID, Incident_date, Financial_loss_amount)
        VALUES (?, ?, ?, ?, ?)
        """,
        (person_id, fraud_type_id, channel_id, incident_date, financial_loss_amount),
    )
    conn.commit()
    new_id = cur.lastrowid
    conn.close()
    return new_id


# ---------------------------------------------------------------
# READ
# ---------------------------------------------------------------
def get_person(person_id):
    conn = get_connection()
    row = conn.execute("SELECT * FROM Person WHERE Person_ID = ?", (person_id,)).fetchone()
    conn.close()
    return dict(row) if row else None


def get_all_incidents_for_person(person_id):
    conn = get_connection()
    rows = conn.execute(
        """
        SELECT fi.Fraud_Incident_ID, ft.Fraud_kind, cc.Channel_kind,
               fi.Incident_date, fi.Financial_loss_amount
        FROM Fraud_Incident fi
        JOIN Fraud_Type ft ON ft.Fraud_Type_ID = fi.Fraud_Type_ID
        JOIN Communication_Channel cc ON cc.Channel_ID = fi.Channel_ID
        WHERE fi.Person_ID = ?
        ORDER BY fi.Incident_date
        """,
        (person_id,),
    ).fetchall()
    conn.close()
    return [dict(r) for r in rows]


# ---------------------------------------------------------------
# UPDATE
# ---------------------------------------------------------------
def update_person_income(person_id, new_income):
    conn = get_connection()
    conn.execute("UPDATE Person SET Income = ? WHERE Person_ID = ?", (new_income, person_id))
    conn.commit()
    changed = conn.total_changes
    conn.close()
    return changed


def update_incident_loss_amount(fraud_incident_id, new_amount):
    conn = get_connection()
    conn.execute(
        "UPDATE Fraud_Incident SET Financial_loss_amount = ? WHERE Fraud_Incident_ID = ?",
        (new_amount, fraud_incident_id),
    )
    conn.commit()
    changed = conn.total_changes
    conn.close()
    return changed


# ---------------------------------------------------------------
# DELETE
# ---------------------------------------------------------------
def delete_person(person_id):
    """Deletes a person. ON DELETE CASCADE also removes their incidents/reports/consequences."""
    conn = get_connection()
    conn.execute("DELETE FROM Person WHERE Person_ID = ?", (person_id,))
    conn.commit()
    changed = conn.total_changes
    conn.close()
    return changed


def delete_fraud_incident(fraud_incident_id):
    conn = get_connection()
    conn.execute("DELETE FROM Fraud_Incident WHERE Fraud_Incident_ID = ?", (fraud_incident_id,))
    conn.commit()
    changed = conn.total_changes
    conn.close()
    return changed


# ---------------------------------------------------------------
# Small live demo
# ---------------------------------------------------------------
if __name__ == "__main__":
    print("=== CRUD demo ===")

    # CREATE
    new_id = add_person(29, "Teacher", 38000, "HBO", "Female")
    print(f"Added new person with Person_ID={new_id}")

    # READ
    print("Read back:", get_person(new_id))

    # UPDATE
    update_person_income(new_id, 41000)
    print("After income update:", get_person(new_id))

    # DELETE
    deleted = delete_person(new_id)
    print(f"Deleted {deleted} row(s); person now gone:", get_person(new_id))
