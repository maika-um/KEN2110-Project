-- ============================================================
-- Online Fraud Victimization Database — Relational Schema
-- Converted from the Week 2 ERD (3NF) into SQL DDL.
--
-- Engine: SQLite (zero setup, built into Python's standard
-- library). The syntax below is close to standard SQL, so if
-- your course specifically requires MySQL, see the "Porting to
-- MySQL" note in the README — only a handful of lines change
-- (AUTOINCREMENT -> AUTO_INCREMENT, etc.).
--
-- Note on one modelling choice: the ERD's relationship list
-- states Fraud_Incident -> Consequences is one-to-one, but the
-- prose above it says "a fraud incident can have MULTIPLE
-- consequences". We went with one-to-one (as the relationship
-- list defines it) and enforced it with a UNIQUE constraint on
-- Consequences.Fraud_Incident_ID. If your group actually wants
-- one-to-many, just delete that UNIQUE constraint.
-- ============================================================

PRAGMA foreign_keys = ON;

-- Drop tables if they already exist, in FK-safe order, so this
-- script can be re-run cleanly.
DROP TABLE IF EXISTS Consequences;
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS Fraud_Incident;
DROP TABLE IF EXISTS Organisation;
DROP TABLE IF EXISTS Communication_Channel;
DROP TABLE IF EXISTS Fraud_Type;
DROP TABLE IF EXISTS Person;

-- ------------------------------------------------------------
-- Person: the (mock) individuals a fraud incident can happen to
-- ------------------------------------------------------------
CREATE TABLE Person (
    Person_ID       INTEGER PRIMARY KEY AUTOINCREMENT,
    Age             INTEGER NOT NULL CHECK (Age BETWEEN 0 AND 120),
    Occupation      TEXT    NOT NULL,
    Income          INTEGER NOT NULL CHECK (Income >= 0),          -- annual gross income in euros
    Education_level TEXT    NOT NULL CHECK (Education_level IN
                        ('Primary', 'Secondary', 'MBO', 'HBO', 'WO/University', 'Other')),
    Gender          TEXT    NOT NULL CHECK (Gender IN
                        ('Female', 'Male', 'Non-binary', 'Prefer not to say'))
);

-- ------------------------------------------------------------
-- Fraud_Type: lookup table of fraud categories
-- ------------------------------------------------------------
CREATE TABLE Fraud_Type (
    Fraud_Type_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Fraud_kind    TEXT NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- Communication_Channel: lookup table of channels used
-- ------------------------------------------------------------
CREATE TABLE Communication_Channel (
    Channel_ID   INTEGER PRIMARY KEY AUTOINCREMENT,
    Channel_kind TEXT NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- Organisation: entities that fraud can be reported to
-- ------------------------------------------------------------
CREATE TABLE Organisation (
    Organisation_ID   INTEGER PRIMARY KEY AUTOINCREMENT,
    Organisation_name TEXT NOT NULL,
    Organisation_type TEXT NOT NULL CHECK (Organisation_type IN
                        ('Police', 'Bank', 'Government', 'Consumer organisation', 'Other'))
);

-- ------------------------------------------------------------
-- Fraud_Incident: the central fact table
-- Person 1--N Fraud_Incident, Fraud_Type 1--N Fraud_Incident,
-- Communication_Channel 1--N Fraud_Incident
-- ------------------------------------------------------------
CREATE TABLE Fraud_Incident (
    Fraud_Incident_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Person_ID              INTEGER NOT NULL,
    Fraud_Type_ID           INTEGER NOT NULL,
    Channel_ID              INTEGER NOT NULL,
    Incident_date           DATE    NOT NULL,
    Financial_loss_amount   NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (Financial_loss_amount >= 0),
    FOREIGN KEY (Person_ID)     REFERENCES Person (Person_ID)         ON DELETE CASCADE,
    FOREIGN KEY (Fraud_Type_ID) REFERENCES Fraud_Type (Fraud_Type_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Channel_ID)    REFERENCES Communication_Channel (Channel_ID) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- Report: Fraud_Incident 1--N Report, Organisation 1--N Report
-- ------------------------------------------------------------
CREATE TABLE Report (
    Report_ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    Fraud_Incident_ID  INTEGER NOT NULL,
    Organisation_ID    INTEGER NOT NULL,
    Report_date        DATE    NOT NULL,
    FOREIGN KEY (Fraud_Incident_ID) REFERENCES Fraud_Incident (Fraud_Incident_ID) ON DELETE CASCADE,
    FOREIGN KEY (Organisation_ID)   REFERENCES Organisation (Organisation_ID)     ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- Consequences: Fraud_Incident 1--1 Consequences
-- ------------------------------------------------------------
CREATE TABLE Consequences (
    Consequence_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Fraud_Incident_ID  INTEGER NOT NULL UNIQUE,   -- UNIQUE enforces the 1-to-1 relationship
    Emotional_problem  INTEGER NOT NULL DEFAULT 0 CHECK (Emotional_problem IN (0, 1)),  -- boolean flag
    Financial_problem  INTEGER NOT NULL DEFAULT 0 CHECK (Financial_problem IN (0, 1)),  -- boolean flag
    FOREIGN KEY (Fraud_Incident_ID) REFERENCES Fraud_Incident (Fraud_Incident_ID) ON DELETE CASCADE
);

-- Helpful indexes for the joins the advanced queries rely on
CREATE INDEX idx_incident_person  ON Fraud_Incident (Person_ID);
CREATE INDEX idx_incident_type    ON Fraud_Incident (Fraud_Type_ID);
CREATE INDEX idx_incident_channel ON Fraud_Incident (Channel_ID);
CREATE INDEX idx_report_incident  ON Report (Fraud_Incident_ID);
CREATE INDEX idx_report_org       ON Report (Organisation_ID);
