# KEN2110-Project: Online Fraud

This is a small database project about online fraud. It stores information about who was scammed, what kind of scam occurred, how it happened, what impact it had on the victim and whether the incident was reported.

# Why online fraud?

In 2025, about 1 in 6 Dutch people were victims of online crime, and 1 in 10 experienced online fraud (CBS, 2026). Many people believe they can easily spot a scam, but 4 in 10 people overestimate their ability to do so, while people under 34 are the most vulnerable (NOS, 2025). In addition, only 15% of victims report fraud to the police, meaning that a large part fraud cases stay invisible.

With this database, we want to investigate which groups are most likely to become victims of online fraud and how reporting behaviour differs between groups.

# Stakeholders

Our main stakeholders are the Ministry of Justice and Security and the police. The results of this project can help them understand which groups to warn, and which groups are less likely to report fraud.

# Files in this project

- ERD - Online Fraud.pdf: A diagram of the tables and how they are connected
- Normalization of the ERD.pdf: A step-by-step explanation of 1NF, 2NF and 3NF, with before/after examples
- Integration of Real Data.pdf: Describes the sources of the real world data and changes made to the original database schema to integrate these datasets.
- Schema.sql: Creates the empty tables 
- Mock_Data.sql: Made-up example data to test the database
- Real Data - CAFC.sql: Real world data adapted from the Canadian Anti-Fraud Centre (CAFC)
- Real_data_FTC.sql: Real world data obtained from the Federal Trade Commission (FTC) 
- Advanced_Queries.sql: Contains queries that investigate which organisation gets the most fraud reports, how the average money lost differs by age group and channel, and which people have been victims more than once

# The ERD explained

A database consists of tables, which contain rows and columns. The centre of our database is the Fraud_Incident table, which represents one fraud case. Each fraud incident is linked to:

- Person: who it happened to (age, occupation, income, education, gender)
- Fraud_Type: what kind of fraud it was, for example phishing
- Communication_Channel: how it reached the person, for example email or social media
- Consequences: what harm it caused (emotional and/or financial)
- Report: whether it was reported, and to which Organisation (for example the police or a bank)

One person can have several fraud cases, and one case can be reported to several organisations. Because everything is linked, we can follow a person from who they are, to what happened, to who they told.

If you delete a fraud case, its reports and consequences are deleted too. But you can't delete a person, fraud type, channel or organisation that is still in use, so no links break by accident.

# Advanced Queries
Organisations ranked by number of reports received (maika-um)
The first query looks at which companies are receiving reports and how the amounts of reports differ between the companies. 

Average loss by age bracket, ranked within each bracket by channel (maika-um)
This query looks at for a given age group, which contact method (e-mail, phone, social media, etc.) tends to cause the biggest financial loss.

Repeat victims: people with more than one incident, total loss (maika-um)
The third query looks at who has been targeted by fraud more than once and what the cumulative financial damage for those people is.

# Limitations
..

# Reflection & future work
..

# How to run it

This project uses SQLite. To run the SQL code, execute the files in the following order:
1. Run Schema.sql
2. Run Real Data - CAFC.sql or Real_dta_FTC.sql
3. Run one of the queries in Advanced_Queries.sql
