"""
populate_data.py
-----------------
Fills the (already created) database with realistic, internally
consistent mock data using only Python's standard library — no
extra packages to install.

Run:
    python scripts/db_connection.py     # creates the schema
    python scripts/populate_data.py     # fills it with mock data
"""

import random
from datetime import date, timedelta

from db_connection import get_connection

random.seed(42)  # reproducible mock data

OCCUPATIONS = [
    "Student", "Teacher", "Nurse", "Retired", "Software Developer",
    "Accountant", "Shop Assistant", "Unemployed", "Construction Worker",
    "Police Officer", "Freelancer", "Administrative Assistant",
]

EDUCATION_LEVELS = ["Primary", "Secondary", "MBO", "HBO", "WO/University", "Other"]
GENDERS = ["Female", "Male", "Non-binary", "Prefer not to say"]

FRAUD_TYPES = [
    "Phishing", "Identity Theft", "Investment Scam", "Romance Scam",
    "Tech Support Scam", "Marketplace Scam", "Parcel Delivery Scam",
]

CHANNELS = ["Email", "Phone", "SMS", "Social Media", "Website", "WhatsApp"]

ORGANISATIONS = [
    ("Police Netherlands", "Police"),
    ("Fraud Help Desk", "Consumer organisation"),
    ("ABN AMRO", "Bank"),
    ("ING", "Bank"),
    ("ACM (Authority for Consumers & Markets)", "Government"),
    ("Consumentenbond", "Consumer organisation"),
]

START_DATE = date(2024, 1, 1)
END_DATE = date(2026, 9, 17)


def random_date(start, end):
    delta_days = (end - start).days
    return start + timedelta(days=random.randint(0, delta_days))


def populate():
    conn = get_connection()
    cur = conn.cursor()

    # --- lookup tables -------------------------------------------------
    cur.executemany("INSERT INTO Fraud_Type (Fraud_kind) VALUES (?)", [(f,) for f in FRAUD_TYPES])
    cur.executemany("INSERT INTO Communication_Channel (Channel_kind) VALUES (?)", [(c,) for c in CHANNELS])
    cur.executemany(
        "INSERT INTO Organisation (Organisation_name, Organisation_type) VALUES (?, ?)",
        ORGANISATIONS,
    )
    conn.commit()

    fraud_type_ids = [r[0] for r in cur.execute("SELECT Fraud_Type_ID FROM Fraud_Type")]
    channel_ids = [r[0] for r in cur.execute("SELECT Channel_ID FROM Communication_Channel")]
    organisation_ids = [r[0] for r in cur.execute("SELECT Organisation_ID FROM Organisation")]

    # --- Person ----------------------------------------------------------
    person_ids = []
    for _ in range(60):
        age = random.randint(16, 90)
        occupation = random.choice(OCCUPATIONS)
        # loosely correlate income with age/occupation, just for realism
        base_income = random.randint(0, 20000) if occupation in ("Student", "Unemployed", "Retired") else random.randint(22000, 75000)
        education = random.choice(EDUCATION_LEVELS)
        gender = random.choice(GENDERS)

        cur.execute(
            "INSERT INTO Person (Age, Occupation, Income, Education_level, Gender) VALUES (?, ?, ?, ?, ?)",
            (age, occupation, base_income, education, gender),
        )
        person_ids.append(cur.lastrowid)
    conn.commit()

    # --- Fraud_Incident ----------------------------------------------------
    incident_ids = []
    for person_id in person_ids:
        # most people have 0-2 incidents, a few have more (matches real skew)
        n_incidents = random.choices([0, 1, 2, 3], weights=[30, 40, 20, 10])[0]
        for _ in range(n_incidents):
            fraud_type_id = random.choice(fraud_type_ids)
            channel_id = random.choice(channel_ids)
            incident_date = random_date(START_DATE, END_DATE)
            loss = round(random.choice([0, 0, 50, 150, 300, 750, 1500, 4000, 9000]) * random.uniform(0.8, 1.2), 2)

            cur.execute(
                """
                INSERT INTO Fraud_Incident (Person_ID, Fraud_Type_ID, Channel_ID, Incident_date, Financial_loss_amount)
                VALUES (?, ?, ?, ?, ?)
                """,
                (person_id, fraud_type_id, channel_id, incident_date.isoformat(), loss),
            )
            incident_ids.append(cur.lastrowid)
    conn.commit()

    # --- Report (not every incident gets reported — realistic under-reporting) ---
    for incident_id in incident_ids:
        if random.random() < 0.65:  # ~65% of incidents get reported at least once
            n_reports = random.choices([1, 2], weights=[85, 15])[0]
            reported_to = random.sample(organisation_ids, k=min(n_reports, len(organisation_ids)))
            # fetch the incident date so the report date is never before the incident
            incident_date_str = cur.execute(
                "SELECT Incident_date FROM Fraud_Incident WHERE Fraud_Incident_ID = ?", (incident_id,)
            ).fetchone()[0]
            incident_date = date.fromisoformat(incident_date_str)
            for org_id in reported_to:
                report_date = incident_date + timedelta(days=random.randint(0, 30))
                if report_date > END_DATE:
                    report_date = END_DATE
                cur.execute(
                    "INSERT INTO Report (Fraud_Incident_ID, Organisation_ID, Report_date) VALUES (?, ?, ?)",
                    (incident_id, org_id, report_date.isoformat()),
                )
    conn.commit()

    # --- Consequences (one-to-one: at most one row per incident) ---
    for incident_id in incident_ids:
        if random.random() < 0.55:  # not every incident leads to a recorded consequence
            emotional = 1 if random.random() < 0.6 else 0
            financial = 1 if random.random() < 0.7 else 0
            cur.execute(
                "INSERT INTO Consequences (Fraud_Incident_ID, Emotional_problem, Financial_problem) VALUES (?, ?, ?)",
                (incident_id, emotional, financial),
            )
    conn.commit()
    conn.close()

    print(f"Inserted {len(person_ids)} persons and {len(incident_ids)} fraud incidents, "
          f"plus matching reports and consequences.")


if __name__ == "__main__":
    populate()
