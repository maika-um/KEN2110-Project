# KEN2110-Project: Online Fraud

This is a small database project about fraud reports. It stores who was scammed, what kind of scam it was, how it happened and what it did to that person.

# What is SQL? 

SQL is a way of giving instructions to a database. Every file in this project is written in SQL. You open the program, paste the code in and click a botton to run it. 

# What is inside the database?

A database is made of tables, with rows and columns. This database has 7 tables: 
- Person: one row per person who was affected by fraud
- Organisation: places you can report fraud to
- Fraud_type: the kind of fraud
- Communication_channel: how he fraud reached the person
- Fraud_incident: who it happened to, what kind it was and how
- Report: a record of a fraud incident being reported to an organisation
- Consequences: what harm the fraud caused

# Files in this project

- Schema.sql: builds the 7 empty tables
- Mock_data.sql: fills those tables with example data
- Advanced_queries.sql: asks which organisation gets the most fraud reports, how the average money lost differs by age group and channel and which people were victems more than once

# How the tables are connected

Some tables point to other tables. For example, every Fraud_Incident row points to one Person, one Fraud_Type, and one Communication_Channel. That is how the database knows who it happened to, what kind it was and how. 

If you delete a Fraud_Incident, its related Report and Consequences rows get deleted automatically too, since they don't make sense without it.

But you can't delete a Person, Fraud_Type, Channel, or Organisation if it's still being used somewhere in the data, because the database blocks that on purpose, so you don't accidentally break a link.
