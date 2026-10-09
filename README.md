# KEN2110-Project: Online Fraud

This is a small database project about online fraud. It stores information about who was scammed, what kind of scam occurred, how it happened, what impact it had on the victim and whether the incident was reported.

# Why online fraud?

In 2025, about 1 in 6 Dutch people were victims of online crime, and 1 in 10 experienced online fraud (CBS, 2026). Many people believe they can easily spot a scam, but 4 in 10 people overestimate their ability to do so, while people under 34 are the most vulnerable (NOS, 2025). In addition, only 15% of victims report fraud to the police, meaning that a large part fraud cases stay invisible.

With this database, we want to investigate which groups are most likely to become victims of online fraud and how reporting behaviour differs between groups.

# Stakeholders

Our main stakeholders are the Ministry of Justice and Security and the police. The results of this project can help them understand which groups to warn, and which groups are less likely to report fraud.

# Files in this project

**Data folder:**
- Mock_Data.sql: Made-up example data to test the database, this is made to run specifically for Schema_1.sql
- Real_data_CAFC.sql: Real world data adapted from the Canadian Anti-Fraud Centre (CAFC), can be ran with Schema_2.sql.
- Real_data_FTC.sql: Real world data obtained from the Federal Trade Commission (FTC), can be ran with Schema_2.sql.

**Schema folder:**
- Schema_1.sql: Creates the empty tables, according to our ERD.
- Schema_2.sql: Updated version of schema_1.sql, adjusted to accommodate the real world data.

**Other files:**
- Advanced_Queries.sql: Contains multiple queries that investigate different aspects of online fraud, offering new and specific insights from the datasets. The different queries are explained in the README.
- ERD - Online Fraud.pdf: A diagram of the tables and how they are connected.
- Normalization of the ERD.pdf: A step-by-step explanation of 1NF, 2NF and 3NF, with before/after examples.
- Video Presentation - Online Fraud.MOV: A video presentation that introduces our societal challenge (online fraud), explains what our database stores/its organisation, demonstrated questions it can answer and describes limitations/future work. To play the video press "View raw".
- Integration of Real Data.pdf: Describes the sources of the real world data and changes made to the original database schema (created Schema_2.sql) to integrate these datasets. 


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
**Organisations ranked by number of reports received** (maika-um)
- Checks which companies are receiving reports and how the amounts of reports differ between the companies.
- *Relevance to the societal problem*: Currently, no organisation sees the full scale of the impact of online fraud, as reports are split across banks, police and consumer organizations. This query shows where victims are actually going, which matters for deciding where prevention campaigns or victim-support resources should be concentrated.

**Average loss by age bracket, ranked within each bracket by channel** (maika-um)
- Analyses for a given age group, which contact method (e-mail, phone, social media, etc.) tends to cause the biggest financial loss.
- *Relevance to the societal problem*: The query shows which contact methods cause the biggest losses within each age group. This makes it possible to target fraud prevention messaging at specific groups and channels, as opposed to a general "be careful online" message.

**Repeat victims: people with more than one incident, total loss** (maika-um)
- Looks at who has been targeted by fraud more than once and what the cumulative financial damage for those people is.
- *Relevance to the societal problem*: A person who has already been a victim to online fraud once, is often more vulnerable to being targeted again. The combined financial harm is invisible if you only look at one incident at a time. Identifying repeat victims allows for more targeted protection for people at a higher risk.

**Losing money by age group: Canada vs United States** (LoraJacobs)
- Compares per age range how often a fraud report includes a money loss and how big the loss is, in the CAFC and FTC data.
- *Relevance to the societal problem*: In the US data younger people lose money more often, but older people lose more when they do. So both groups need a warning, but a different one. This helps the Ministry and police decide which message to give to which age group.

**Most harmful contact methods: Canada vs United States** (LoraJacobs)
- Compares per contact method how often fraud leads to a money loss and how big the loss is, in the CAFC and FTC data.
- *Relevance to the societal problem*: In both countries fraud through social media and websites most often leads to a money loss, while email and text messages are reported a lot but less often lead to a loss. This shows which channels warnings should focus on.

# Limitations
- The FTC data only has yearly totals, not individual reports. Because of this it can't be linked to a person or incident, and it had to be stored in separate tables (Report_Count and Loss_Statistic).
- The CAFC data is a sample of 200 reports, so averages per group are based on few cases and one large loss can change them a lot.
- Both datasets come from Canada and the US. We have no Dutch data, while our societal problem and stakeholders are Dutch.
- Both datasets only contain fraud that was reported. Fraud that people never report, which is a big part of our problem, is not in the data.
- The age groups are not the same in both datasets ("0-19" and "80+" in FTC, "10-19" and "80-89" in CAFC), so these can't be compared.

# Reflection & future work

Adding real data showed that our schema was made for individual cases, while a lot of open data only has totals. We had to add two new tables for the FTC data and change how age is stored.

The results fit our societal problem and the stakeholder video: fraud is not only a problem for older people. Younger people lose money more often, older people lose more per case, and fraud through social media most often leads to a money loss. This can help the Ministry of Justice and Security and the police decide who to warn and through which channel.

Future work:
- Add Dutch data, for example from CBS or the police, so the results apply to the Netherlands.
- Add data on people who did not report fraud, so we can actually answer how reporting differs between groups.
- Make the age groups the same in all data, so they can be compared.

# How to run it

This project uses SQLite. To run the SQL code, execute the files in the following order:
1. Run Schema_2.sql
2. Run Real Data; first run the Real_data_CAFC.sql file, followed by Real_data_FTC.sql
3. Run one of the queries in Advanced_Queries.sql
