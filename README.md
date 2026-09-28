# KEN2110-Project: Online Fraud

This is a small database project about online fraud. It stores who was scammed, what kind of scam it was, how it happened, what it did to that person and whether they reported it.

# Why online fraud?

In 2025, about 1 in 6 Dutch people were a victim of online crime, and 1 in 10 were scammed online (CBS, 2026). Many people think they can easily spot a scam, but 4 in 10 overestimate themselves, and people under 34 are the most vulnerable (NOS, 2025). On top of that, only 15% of victims go to the police, so most fraud stays invisible.

With this database we want to find out who is most likely to become a victim and how reporting differs between groups.

# Stakeholders

Our stakeholders are the Ministry of Justice and Security and the police. Our results show them which groups to warn, and which groups rarely report fraud.

# Files in this project

- ERD - Online Fraud.pdf: a drawing of the 7 tables and how they are connected
- Normalization of the ERD.pdf: step-by-step explanation of 1NF, 2NF and 3NF, with before/after examples
- Schema.sql: builds the 7 empty tables
- Mock_Data.sql: fills the tables with made-up example data
- Advanced_Queries.sql: asks which organisation gets the most fraud reports, how the average money lost differs by age group and channel, and which people were victims more than once

# The ERD explained

A database is made of tables, with rows and columns. The centre of our database is Fraud_Incident: one fraud case. Every case is linked to:

- Person: who it happened to (age, occupation, income, education, gender)
- Fraud_Type: what kind of fraud it was, for example phishing
- Communication_Channel: how it reached the person, for example email or social media
- Consequences: what harm it caused (emotional and/or financial)
- Report: whether it was reported, and to which Organisation (for example the police or a bank)

One person can have several fraud cases, and one case can be reported to several organisations. Because everything is linked, we can follow a person from who they are, to what happened, to who they told.

If you delete a fraud case, its reports and consequences are deleted too. But you can't delete a person, fraud type, channel or organisation that is still in use, so no links break by accident.

# How to run it

SQL is a way of giving instructions to a database. We use SQLite: open the program, paste in the code and click a button to run it. Run Schema.sql first, then Mock_Data.sql, then Advanced_Queries.sql.
