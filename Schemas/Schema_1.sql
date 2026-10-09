-- Schema

CREATE TABLE Person (
    Person_ID       INTEGER PRIMARY KEY,
    Age             INTEGER NOT NULL CHECK (Age BETWEEN 0 AND 120),
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
    Fraud_kind    TEXT NOT NULL UNIQUE
);

CREATE TABLE Communication_Channel (
    Channel_ID   INTEGER PRIMARY KEY,
    Channel_kind TEXT NOT NULL UNIQUE
);

CREATE TABLE Fraud_Incident (
    Fraud_incident_ID     INTEGER PRIMARY KEY,
    Fraud_type_ID         INTEGER NOT NULL,
    Person_ID             INTEGER NOT NULL,
    Incident_date         DATE NOT NULL,
    Channel_ID            INTEGER NOT NULL,
    Financial_loss_amount REAL NOT NULL CHECK (Financial_loss_amount >= 0),

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
