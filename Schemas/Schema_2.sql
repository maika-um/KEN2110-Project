-- Schema

CREATE TABLE Person (
    Person_ID       INTEGER PRIMARY KEY,
    Age_range       TEXT CHECK (Age_range GLOB '[0-9]*'), 
    Occupation      TEXT,
    Income          REAL CHECK (Income >= 0),
    Education_level TEXT,
    Gender          TEXT
);

CREATE TABLE Organisation (
    Organisation_ID   INTEGER PRIMARY KEY,
    Organisation_name TEXT NOT NULL,
    Organisation_type TEXT
);

CREATE TABLE Fraud_Type (
    Fraud_type_ID INTEGER PRIMARY KEY,
    Fraud_kind    TEXT NOT NULL UNIQUE COLLATE NOCASE
);

CREATE TABLE Communication_Channel (
    Channel_ID   INTEGER PRIMARY KEY,
    Channel_kind TEXT NOT NULL UNIQUE COLLATE NOCASE
);

CREATE TABLE Fraud_Incident (
    Fraud_incident_ID     INTEGER PRIMARY KEY,
    Fraud_type_ID         INTEGER NOT NULL,
    Person_ID             INTEGER NOT NULL,
    Incident_date         DATE NOT NULL,
    Channel_ID            INTEGER NOT NULL,
    Financial_loss_amount REAL CHECK (Financial_loss_amount >= 0),

    FOREIGN KEY (Fraud_type_ID) REFERENCES Fraud_Type(Fraud_type_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Channel_ID) REFERENCES Communication_Channel(Channel_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Report (
    Report_ID         INTEGER PRIMARY KEY,
    Fraud_incident_ID INTEGER NOT NULL,
    Organisation_ID   INTEGER NOT NULL,
    Report_date       DATE NOT NULL,

    FOREIGN KEY (Fraud_incident_ID) REFERENCES Fraud_Incident(Fraud_incident_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Organisation_ID) REFERENCES Organisation(Organisation_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Consequences (
    Consequence_ID    INTEGER PRIMARY KEY,
    Fraud_incident_ID INTEGER NOT NULL,
    Emotional_problem TEXT,
    Financial_problem TEXT,

    FOREIGN KEY (Fraud_incident_ID) REFERENCES Fraud_Incident(Fraud_incident_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Report_Count (
    Report_count_ID   INTEGER PRIMARY KEY,
    Organisation_ID   INTEGER NOT NULL,
    Fraud_type_ID     INTEGER NOT NULL,
    Report_year       INTEGER NOT NULL CHECK (Report_year BETWEEN 1990 AND 2100),
    Number_of_reports INTEGER NOT NULL CHECK (typeof(Number_of_reports) = 'integer' AND Number_of_reports >= 0),

    UNIQUE (Organisation_ID, Fraud_type_ID, Report_year),
    FOREIGN KEY (Organisation_ID) REFERENCES Organisation(Organisation_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Fraud_type_ID) REFERENCES Fraud_Type(Fraud_type_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Loss_Statistic (
    Loss_statistic_ID  INTEGER PRIMARY KEY,
    Organisation_ID    INTEGER NOT NULL,
    Report_year        INTEGER NOT NULL CHECK (Report_year BETWEEN 1990 AND 2100),
    Channel_ID         INTEGER,     -- filled for numbers per contact method
    Age_range          TEXT,        -- filled for numbers per age range (same format as Person.Age_range)
    Number_of_reports  INTEGER NOT NULL CHECK (Number_of_reports >= 0),
    Pct_reporting_loss REAL CHECK (Pct_reporting_loss BETWEEN 0 AND 100),
    Total_loss         REAL CHECK (typeof(Total_loss) IN ('integer', 'real', 'null') AND Total_loss >= 0),
    Median_loss        REAL CHECK (typeof(Median_loss) IN ('integer', 'real', 'null') AND Median_loss >= 0),
    Currency           TEXT NOT NULL CHECK (Currency IN ('USD', 'CAD', 'EUR', 'GBP')),

    CHECK ((Channel_ID IS NULL) <> (Age_range IS NULL)),   -- exactly one of the two
    UNIQUE (Organisation_ID, Report_year, Channel_ID, Age_range),
    FOREIGN KEY (Organisation_ID) REFERENCES Organisation(Organisation_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Channel_ID) REFERENCES Communication_Channel(Channel_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
