-- Mock data

-- Fraud_Type
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (1, 'Phishing');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (2, 'Identity Theft');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (3, 'Investment Scam');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (4, 'Romance Scam');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (5, 'Credit Card Fraud');

-- Communication_Channel
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (1, 'Email');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (2, 'Phone Call');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (3, 'SMS');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (4, 'Social Media');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (5, 'Website');

-- Organisation
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (1, 'National Fraud Reporting Centre', 'Government');
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (2, 'SecureBank plc', 'Bank');
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (3, 'Consumer Protection Bureau', 'Government');
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (4, 'City Police Department', 'Law Enforcement');
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (5, 'Better Business Bureau', 'Non-profit');

-- Person
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (1, 38, 'Teacher', 114525.86, 'Master', 'Non-binary');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (2, 21, 'Nurse', 22605.81, 'Doctorate', 'Female');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (3, 41, 'Retired', 76192.74, 'Doctorate', 'Female');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (4, 20, 'Software Engineer', 24024.46, 'Master', 'Female');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (5, 33, 'Accountant', 24524.87, 'Master', 'Female');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (6, 70, 'Student', 74372.64, 'Some College', 'Non-binary');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (7, 58, 'Sales Representative', 76214.67, 'High School', 'Non-binary');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (8, 55, 'Small Business Owner', 56651.45, 'Some College', 'Female');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (9, 53, 'Electrician', 105139.19, 'Bachelor', 'Male');
INSERT INTO Person (Person_ID, Age, Occupation, Income, Education_level, Gender) VALUES (10, 27, 'Consultant', 71772.02, 'Doctorate', 'Male');

-- Fraud_Incident
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (1, 5, 3, '2024-04-15', 5, 8610.95);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (2, 2, 6, '2024-04-09', 5, 10710.45);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (3, 5, 1, '2025-09-25', 2, 7496.58);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (4, 5, 7, '2024-11-17', 4, 8824.87);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (5, 4, 6, '2024-11-02', 2, 11936.25);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (6, 2, 2, '2025-08-11', 3, 7925.43);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (7, 3, 8, '2024-10-21', 5, 14704.61);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (8, 1, 9, '2025-03-04', 2, 11381.4);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (9, 2, 8, '2025-03-07', 1, 14434.08);
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (10, 1, 9, '2025-08-09', 3, 5167.82);

-- Report
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (1, 6, 5, '2025-05-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (2, 10, 4, '2024-03-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (3, 2, 3, '2025-04-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (4, 2, 1, '2025-12-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (5, 5, 5, '2025-11-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (6, 8, 3, '2025-01-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (7, 6, 1, '2025-04-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (8, 6, 2, '2025-09-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (9, 2, 4, '2024-03-01');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (10, 4, 3, '2024-05-12');

-- Consequences
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (1, 4, 'Stress', 'Unable to pay bills');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (2, 7, 'Depression', 'Credit score damage');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (3, 9, NULL, 'Unable to pay bills');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (4, 8, 'Loss of trust', 'Unable to pay bills');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (5, 10, 'Stress', 'Savings depleted');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (6, 1, 'Anxiety', 'Savings depleted');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (7, 2, 'Stress', 'Savings depleted');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (8, 6, NULL, 'Savings depleted');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (9, 3, 'Anxiety', 'Unable to pay bills');
INSERT INTO Consequences (Consequence_ID, Fraud_incident_ID, Emotional_problem, Financial_problem) VALUES (10, 5, 'Depression', 'Savings depleted');
