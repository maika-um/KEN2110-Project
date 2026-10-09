-- Real world data sampled from the Canadian Anti-Fraud Centre (CAFC) Reporting Data, Open Government Portal (Canada)
-- Source:    https://open.canada.ca/data/en/dataset/6a09c998-cddb-4a22-beff-4dca67ab892f
-- File:      cafc-open-gouv-database-2021-01-01-to-2025-09-30-extracted-2025-10-01.csv (data last updated 2025-10-02; first published 2023-07-10)
-- Licence:   Open Government Licence - Canada
-- Sample:    200 random reports (pandas sample, random_state=42) out of 227,397 reports with Complaint Type = 'Victim' and 1 victim (file: 350,361 reports)
-- Schema changes needed before loading (edits in Schema_2.sql):
--   Person.Age            INTEGER CHECK (Age BETWEEN 0 AND 120)          -- no longer needed, source only has age ranges
--   Person.Age_range      TEXT                                            -- new column
--   Fraud_Incident.Financial_loss_amount  REAL CHECK (Financial_loss_amount >= 0)   -- no longer NOT NULL
-- Mapping notes:
--   Incident_date and Report_date both = 'Date Received' (the source has no separate incident date).
--   Financial_loss_amount is originally in CAD, converted to USD according to Bank of Canada annual average rate for the year of Date Received (CAD per 1 USD): 2021 1.2535, 2022 1.3013, 2023 1.3497,
--   2024 1.3698, 2025 1.3978 (https://www.bankofcanada.ca/rates/exchange/annual-average-exchange-rates/), rounded to 2 decimals.
--   The original CAD amount is kept in the comment at the end of each Fraud_Incident line. NULL stays NULL; 0.00 stays 0.00.
-- NULL for Identity Fraud, Personal Info and Phishing: CAFC states loss is not determinable there (always $0 in the source).
--   Age_range NULL = 'Not Available' or 'Deceased'; Gender NULL = 'Not Available' or 'Unknown'.
--   Not in the source: Occupation, Income, Education_level, Consequences.

-- Fraud_Type
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (1, 'Bank Investigator');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (2, 'Charity / Donation');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (3, 'Collection Agency');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (4, 'Counterfeit Merchandise');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (5, 'Credit Card');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (6, 'Directory');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (7, 'Emergency (Jail, Accident, Hospital, Help)');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (8, 'Extortion');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (9, 'False Billing');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (10, 'Foreign Money Offer');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (11, 'Fraudulent Cheque');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (12, 'Grant');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (13, 'Health');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (14, 'Identity Fraud');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (15, 'Incomplete');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (16, 'Investments');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (17, 'Job');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (18, 'Loan');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (19, 'Merchandise');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (20, 'Modem-Hijacking');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (21, 'Office Supplies');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (22, 'Other');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (23, 'Personal Info');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (24, 'Phishing');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (25, 'Prize');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (26, 'Psychics');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (27, 'Pyramid');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (28, 'Recovery Pitch');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (29, 'Romance');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (30, 'Service');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (31, 'Spear Phishing');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (32, 'Spoofing');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (33, 'Survey');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (34, 'Telecom Fraud');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (35, 'Timeshare');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (36, 'Unauthorized Charge');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (37, 'Unknown');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (38, 'Vacation');
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (39, 'Vendor Fraud');

-- Communication_Channel
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (1, 'Direct call');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (2, 'Door to door/in person');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (3, 'Email');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (4, 'Fax');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (5, 'Internet');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (6, 'Internet-social network');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (7, 'Mail');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (8, 'Not Available');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (9, 'Other/unknown');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (10, 'Print');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (11, 'Radio');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (12, 'Television');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (13, 'Text message');
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (14, 'Video Call');

-- Organisation
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (1, 'Canadian Anti-Fraud Centre', 'Law Enforcement');

-- Person
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (1, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (2, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (3, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (4, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (5, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (6, '10-19', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (7, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (8, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (9, '10-19', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (10, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (11, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (12, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (13, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (14, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (15, NULL, 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (16, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (17, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (18, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (19, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (20, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (21, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (22, '10-19', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (23, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (24, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (25, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (26, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (27, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (28, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (29, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (30, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (31, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (32, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (33, '50-59', NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (34, '70-79', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (35, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (36, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (37, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (38, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (39, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (40, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (41, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (42, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (43, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (44, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (45, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (46, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (47, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (48, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (49, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (50, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (51, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (52, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (53, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (54, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (55, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (56, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (57, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (58, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (59, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (60, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (61, '70-79', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (62, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (63, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (64, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (65, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (66, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (67, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (68, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (69, '80-89', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (70, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (71, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (72, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (73, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (74, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (75, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (76, '10-19', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (77, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (78, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (79, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (80, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (81, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (82, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (83, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (84, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (85, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (86, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (87, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (88, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (89, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (90, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (91, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (92, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (93, NULL, 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (94, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (95, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (96, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (97, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (98, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (99, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (100, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (101, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (102, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (103, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (104, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (105, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (106, NULL, 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (107, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (108, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (109, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (110, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (111, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (112, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (113, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (114, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (115, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (116, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (117, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (118, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (119, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (120, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (121, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (122, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (123, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (124, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (125, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (126, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (127, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (128, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (129, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (130, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (131, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (132, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (133, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (134, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (135, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (136, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (137, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (138, '10-19', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (139, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (140, '40-49', NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (141, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (142, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (143, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (144, '60-69', NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (145, '70-79', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (146, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (147, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (148, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (149, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (150, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (151, '60-69', NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (152, '1-9', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (153, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (154, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (155, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (156, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (157, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (158, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (159, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (160, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (161, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (162, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (163, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (164, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (165, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (166, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (167, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (168, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (169, '30-39', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (170, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (171, '60-69', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (172, '40-49', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (173, '70-79', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (174, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (175, '10-19', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (176, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (177, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (178, '50-59', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (179, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (180, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (181, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (182, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (183, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (184, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (185, '20-29', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (186, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (187, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (188, '10-19', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (189, '70-79', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (190, '60-69', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (191, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (192, '50-59', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (193, NULL, NULL);
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (194, NULL, 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (195, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (196, '30-39', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (197, '70-79', 'Female');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (198, '20-29', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (199, '40-49', 'Male');
INSERT INTO Person (Person_ID, Age_range, Gender) VALUES (200, NULL, NULL);

-- Fraud_Incident
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (1, 14, 1, '2021-01-12', 9, NULL); -- CAFC report 2548
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (2, 11, 2, '2021-01-14', 2, 6332.67); -- CAFC report 3035 (CAD 7938.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (3, 14, 3, '2021-02-08', 9, NULL); -- CAFC report 12170
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (4, 23, 4, '2021-02-09', 6, NULL); -- CAFC report 12487
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (5, 23, 5, '2021-02-09', 1, NULL); -- CAFC report 12556
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (6, 14, 6, '2021-02-10', 9, NULL); -- CAFC report 13221
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (7, 8, 7, '2021-02-11', 1, 0.00); -- CAFC report 13736 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (8, 14, 8, '2021-02-19', 9, NULL); -- CAFC report 16669
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (9, 14, 9, '2021-02-23', 9, NULL); -- CAFC report 18092
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (10, 14, 10, '2021-03-02', 9, NULL); -- CAFC report 20426
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (11, 14, 11, '2021-03-02', 9, NULL); -- CAFC report 20806
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (12, 4, 12, '2021-03-03', 8, 79.78); -- CAFC report 21048 (CAD 100.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (13, 14, 13, '2021-03-17', 9, NULL); -- CAFC report 25322
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (14, 14, 14, '2021-03-18', 9, NULL); -- CAFC report 26175
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (15, 30, 15, '2021-03-19', 1, 16702.70); -- CAFC report 26771 (CAD 20936.83)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (16, 14, 16, '2021-03-19', 9, NULL); -- CAFC report 26841
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (17, 24, 17, '2021-03-22', 3, NULL); -- CAFC report 27840
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (18, 14, 18, '2021-03-29', 9, NULL); -- CAFC report 30182
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (19, 23, 19, '2021-03-29', 9, NULL); -- CAFC report 30475
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (20, 14, 20, '2021-04-06', 9, NULL); -- CAFC report 32103
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (21, 14, 21, '2021-04-09', 9, NULL); -- CAFC report 33463
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (22, 14, 22, '2021-04-25', 9, NULL); -- CAFC report 37942
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (23, 30, 23, '2021-04-30', 5, 398.88); -- CAFC report 40247 (CAD 500.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (24, 23, 24, '2021-05-04', 5, NULL); -- CAFC report 41172
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (25, 14, 25, '2021-05-05', 9, NULL); -- CAFC report 41333
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (26, 14, 26, '2021-05-19', 8, NULL); -- CAFC report 45466
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (27, 14, 27, '2021-05-26', 9, NULL); -- CAFC report 46908
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (28, 14, 28, '2021-06-07', 8, NULL); -- CAFC report 50644
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (29, 14, 29, '2021-06-10', 9, NULL); -- CAFC report 52209
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (30, 35, 30, '2021-06-17', 1, 319106.50); -- CAFC report 53863 (CAD 400000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (31, 19, 31, '2021-06-29', 5, 39.89); -- CAFC report 57023 (CAD 50.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (32, 14, 32, '2021-07-12', 9, NULL); -- CAFC report 60019
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (33, 14, 33, '2021-07-14', 9, NULL); -- CAFC report 60596
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (34, 14, 34, '2021-07-16', 9, NULL); -- CAFC report 61524
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (35, 24, 35, '2021-07-27', 3, NULL); -- CAFC report 64669
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (36, 14, 36, '2021-07-31', 8, NULL); -- CAFC report 66313
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (37, 14, 37, '2021-08-09', 9, NULL); -- CAFC report 68450
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (38, 1, 38, '2021-08-10', 3, 0.00); -- CAFC report 68769 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (39, 4, 39, '2021-08-14', 8, 61.43); -- CAFC report 70055 (CAD 77.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (40, 14, 40, '2021-08-16', 9, NULL); -- CAFC report 70442
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (41, 8, 41, '2021-08-25', 1, 0.00); -- CAFC report 72919 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (42, 19, 42, '2021-09-07', 5, 2074.19); -- CAFC report 76471 (CAD 2600.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (43, 30, 43, '2021-10-05', 5, 107.16); -- CAFC report 84287 (CAD 134.33)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (44, 14, 44, '2021-10-26', 9, NULL); -- CAFC report 89951
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (45, 17, 45, '2021-10-28', 1, 2233.75); -- CAFC report 90616 (CAD 2800.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (46, 14, 46, '2021-11-23', 9, NULL); -- CAFC report 98230
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (47, 16, 47, '2021-11-27', 6, 2393.30); -- CAFC report 99569 (CAD 3000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (48, 17, 48, '2021-11-28', 6, 108637.42); -- CAFC report 99612 (CAD 136177.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (49, 29, 49, '2021-11-29', 6, 12266.45); -- CAFC report 99945 (CAD 15376.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (50, 14, 50, '2021-11-30', 9, NULL); -- CAFC report 100459
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (51, 1, 51, '2021-12-06', 1, 8104.37); -- CAFC report 102136 (CAD 10158.83)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (52, 31, 52, '2021-12-14', 3, 35123.25); -- CAFC report 104195 (CAD 44027.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (53, 8, 53, '2021-12-16', 1, 0.00); -- CAFC report 105052 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (54, 14, 54, '2021-12-22', 9, NULL); -- CAFC report 106234
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (55, 14, 55, '2022-01-09', 9, NULL); -- CAFC report 109952
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (56, 22, 56, '2022-01-14', 1, 0.00); -- CAFC report 111875 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (57, 14, 57, '2022-01-17', 9, NULL); -- CAFC report 112593
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (58, 8, 58, '2022-01-17', 1, 0.00); -- CAFC report 112638 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (59, 23, 59, '2022-02-03', 1, NULL); -- CAFC report 116668
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (60, 8, 60, '2022-02-06', 6, 0.00); -- CAFC report 117107 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (61, 23, 61, '2022-02-14', 1, NULL); -- CAFC report 118814
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (62, 39, 62, '2022-02-21', 5, 614.77); -- CAFC report 120672 (CAD 800.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (63, 14, 63, '2022-03-02', 9, NULL); -- CAFC report 123185
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (64, 4, 64, '2022-03-08', 8, 248.21); -- CAFC report 125000 (CAD 323.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (65, 19, 65, '2022-03-10', 5, 699.30); -- CAFC report 125717 (CAD 910.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (66, 14, 66, '2022-03-22', 9, NULL); -- CAFC report 128704
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (67, 23, 67, '2022-03-29', 9, NULL); -- CAFC report 130583
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (68, 4, 68, '2022-04-01', 8, 65.32); -- CAFC report 131671 (CAD 85.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (69, 14, 69, '2022-04-13', 9, NULL); -- CAFC report 135792
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (70, 30, 70, '2022-04-20', 1, 0.00); -- CAFC report 137419 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (71, 4, 71, '2022-04-26', 8, 99.13); -- CAFC report 139053 (CAD 129.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (72, 14, 72, '2022-04-27', 9, NULL); -- CAFC report 139435
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (73, 14, 73, '2022-05-05', 9, NULL); -- CAFC report 141792
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (74, 14, 74, '2022-05-06', 9, NULL); -- CAFC report 142072
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (75, 14, 75, '2022-05-09', 9, NULL); -- CAFC report 142578
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (76, 24, 76, '2022-05-11', 13, NULL); -- CAFC report 143295
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (77, 24, 77, '2022-05-30', 5, NULL); -- CAFC report 148208
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (78, 30, 78, '2022-05-31', 5, 599.40); -- CAFC report 148721 (CAD 780.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (79, 4, 79, '2022-06-23', 6, 115.27); -- CAFC report 154704 (CAD 150.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (80, 14, 80, '2022-06-26', 9, NULL); -- CAFC report 155252
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (81, 14, 81, '2022-06-29', 9, NULL); -- CAFC report 156204
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (82, 14, 82, '2022-06-30', 6, NULL); -- CAFC report 156560
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (83, 18, 83, '2022-07-05', 5, 0.00); -- CAFC report 157540 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (84, 17, 84, '2022-07-06', 6, 384.23); -- CAFC report 157743 (CAD 500.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (85, 14, 85, '2022-07-11', 9, NULL); -- CAFC report 158998
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (86, 31, 86, '2022-07-25', 3, 70775.38); -- CAFC report 162635 (CAD 92100.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (87, 14, 87, '2022-07-28', 8, NULL); -- CAFC report 163510
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (88, 30, 88, '2022-07-28', 5, 18443.10); -- CAFC report 163743 (CAD 24000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (89, 14, 89, '2022-07-29', 9, NULL); -- CAFC report 164006
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (90, 14, 90, '2022-08-03', 2, NULL); -- CAFC report 164882
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (91, 25, 91, '2022-08-08', 5, 67.25); -- CAFC report 166235 (CAD 87.51)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (92, 24, 92, '2022-08-15', 13, NULL); -- CAFC report 167656
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (93, 4, 93, '2022-08-19', 8, 92.22); -- CAFC report 168779 (CAD 120.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (94, 14, 94, '2022-08-22', 9, NULL); -- CAFC report 169286
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (95, 30, 95, '2022-08-24', 5, 0.00); -- CAFC report 169968 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (96, 31, 96, '2022-09-08', 3, 0.00); -- CAFC report 173317 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (97, 30, 97, '2022-09-16', 1, 0.00); -- CAFC report 175278 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (98, 4, 98, '2022-09-17', 8, 101.44); -- CAFC report 175458 (CAD 132.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (99, 16, 99, '2022-09-17', 5, 298954.71); -- CAFC report 175475 (CAD 389029.77)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (100, 24, 100, '2022-10-17', 13, NULL); -- CAFC report 181927
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (101, 24, 101, '2022-10-19', 3, NULL); -- CAFC report 182610
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (102, 14, 102, '2022-10-21', 9, NULL); -- CAFC report 183013
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (103, 14, 103, '2022-11-04', 9, NULL); -- CAFC report 186616
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (104, 23, 104, '2022-11-09', 13, NULL); -- CAFC report 187820
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (105, 24, 105, '2022-11-24', 13, NULL); -- CAFC report 191377
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (106, 8, 106, '2022-12-05', 1, 1191.12); -- CAFC report 193664 (CAD 1550.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (107, 14, 107, '2022-12-07', 9, NULL); -- CAFC report 194788
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (108, 14, 108, '2022-12-11', 9, NULL); -- CAFC report 195732
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (109, 23, 109, '2022-12-12', 3, NULL); -- CAFC report 196053
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (110, 4, 110, '2022-12-29', 5, 260.87); -- CAFC report 200424 (CAD 339.47)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (111, 31, 111, '2023-01-05', 3, 440844.63); -- CAFC report 201788 (CAD 595008.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (112, 29, 112, '2023-01-05', 6, 7112.69); -- CAFC report 201986 (CAD 9600.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (113, 4, 113, '2023-01-09', 8, 64.46); -- CAFC report 202953 (CAD 87.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (114, 14, 114, '2023-01-13', 2, NULL); -- CAFC report 204083
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (115, 1, 115, '2023-01-20', 1, 0.00); -- CAFC report 205697 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (116, 30, 116, '2023-01-21', 1, 0.00); -- CAFC report 205858 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (117, 14, 117, '2023-02-09', 9, NULL); -- CAFC report 210140
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (118, 14, 118, '2023-02-22', 9, NULL); -- CAFC report 212808
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (119, 19, 119, '2023-03-07', 6, 111.14); -- CAFC report 215042 (CAD 150.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (120, 8, 120, '2023-03-27', 1, 0.00); -- CAFC report 218722 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (121, 19, 121, '2023-03-30', 6, 39.90); -- CAFC report 219851 (CAD 53.85)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (122, 16, 122, '2023-04-05', 6, 13336.30); -- CAFC report 220866 (CAD 18000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (123, 14, 123, '2023-04-12', 9, NULL); -- CAFC report 221846
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (124, 23, 124, '2023-04-12', 9, NULL); -- CAFC report 221935
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (125, 24, 125, '2023-05-05', 3, NULL); -- CAFC report 224656
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (126, 39, 126, '2023-05-09', 6, 222.27); -- CAFC report 225248 (CAD 300.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (127, 19, 127, '2023-06-06', 3, 31.00); -- CAFC report 230062 (CAD 41.84)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (128, 30, 128, '2023-06-13', 5, 0.00); -- CAFC report 231195 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (129, 14, 129, '2023-06-16', 3, NULL); -- CAFC report 231795
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (130, 4, 130, '2023-06-16', 8, 123.73); -- CAFC report 231855 (CAD 167.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (131, 4, 131, '2023-06-28', 8, 70.39); -- CAFC report 234055 (CAD 95.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (132, 14, 132, '2023-06-29', 9, NULL); -- CAFC report 234476
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (133, 14, 133, '2023-07-12', 9, NULL); -- CAFC report 237529
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (134, 23, 134, '2023-07-20', 9, NULL); -- CAFC report 239308
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (135, 14, 135, '2023-07-21', 9, NULL); -- CAFC report 239691
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (136, 23, 136, '2023-09-07', 6, NULL); -- CAFC report 247136
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (137, 23, 137, '2023-09-08', 1, NULL); -- CAFC report 247334
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (138, 39, 138, '2023-09-19', 6, 443.60); -- CAFC report 249220 (CAD 598.73)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (139, 1, 139, '2023-09-21', 1, 0.00); -- CAFC report 249674 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (140, 30, 140, '2023-09-29', 1, 0.00); -- CAFC report 251409 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (141, 16, 141, '2023-10-12', 1, 26672.59); -- CAFC report 253718 (CAD 36000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (142, 29, 142, '2023-10-17', 5, 2222.72); -- CAFC report 254252 (CAD 3000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (143, 16, 143, '2023-12-02', 3, 3704.82); -- CAFC report 261033 (CAD 5000.40)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (144, 16, 144, '2023-12-27', 5, 45479.00); -- CAFC report 264497 (CAD 61383.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (145, 16, 145, '2023-12-27', 6, 1731.87); -- CAFC report 264509 (CAD 2337.50)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (146, 29, 146, '2024-01-03', 6, 29201.34); -- CAFC report 265425 (CAD 40000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (147, 8, 147, '2024-01-06', 6, 146.01); -- CAFC report 265854 (CAD 200.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (148, 30, 148, '2024-01-19', 3, 0.00); -- CAFC report 267778 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (149, 14, 149, '2024-02-08', 9, NULL); -- CAFC report 270216
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (150, 24, 150, '2024-02-25', 13, NULL); -- CAFC report 272266
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (151, 16, 151, '2024-03-22', 5, 9344.43); -- CAFC report 275880 (CAD 12800.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (152, 23, 152, '2024-03-28', 3, NULL); -- CAFC report 276609
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (153, 29, 153, '2024-04-08', 6, 4380.20); -- CAFC report 278388 (CAD 6000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (154, 19, 154, '2024-05-13', 13, 1861.59); -- CAFC report 283527 (CAD 2550.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (155, 30, 155, '2024-05-22', 6, 343.12); -- CAFC report 284821 (CAD 470.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (156, 19, 156, '2024-05-23', 3, 730.03); -- CAFC report 284837 (CAD 1000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (157, 14, 157, '2024-06-17', 9, NULL); -- CAFC report 287926
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (158, 8, 158, '2024-06-21', 3, 0.00); -- CAFC report 288477 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (159, 39, 159, '2024-06-28', 3, 7212.73); -- CAFC report 289536 (CAD 9880.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (160, 19, 160, '2024-07-02', 6, 167.00); -- CAFC report 289847 (CAD 228.75)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (161, 19, 161, '2024-07-22', 5, 90.90); -- CAFC report 292385 (CAD 124.51)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (162, 14, 162, '2024-07-30', 9, NULL); -- CAFC report 293183
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (163, 14, 163, '2024-08-13', 9, NULL); -- CAFC report 294973
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (164, 14, 164, '2024-08-15', 9, NULL); -- CAFC report 295234
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (165, 23, 165, '2024-09-09', 1, NULL); -- CAFC report 299102
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (166, 19, 166, '2024-09-13', 6, 36.50); -- CAFC report 299654 (CAD 50.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (167, 19, 167, '2024-09-17', 5, 374.78); -- CAFC report 300180 (CAD 513.37)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (168, 1, 168, '2024-09-18', 1, 730.03); -- CAFC report 300621 (CAD 1000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (169, 14, 169, '2024-09-26', 9, NULL); -- CAFC report 302003
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (170, 17, 170, '2024-10-07', 5, 0.00); -- CAFC report 303672 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (171, 30, 171, '2024-11-07', 5, 14451.01); -- CAFC report 308373 (CAD 19795.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (172, 14, 172, '2024-11-30', 9, NULL); -- CAFC report 311745
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (173, 23, 173, '2024-12-03', 9, NULL); -- CAFC report 312351
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (174, 19, 174, '2024-12-04', 6, 51.25); -- CAFC report 312389 (CAD 70.20)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (175, 8, 175, '2024-12-08', 3, 0.00); -- CAFC report 313131 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (176, 16, 176, '2024-12-12', 5, 3437.38); -- CAFC report 313842 (CAD 4708.52)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (177, 14, 177, '2024-12-23', 9, NULL); -- CAFC report 315678
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (178, 19, 178, '2025-01-03', 5, 873.79); -- CAFC report 316989 (CAD 1221.38)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (179, 17, 179, '2025-01-11', 9, 21383.60); -- CAFC report 318234 (CAD 29890.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (180, 19, 180, '2025-01-31', 6, 164.54); -- CAFC report 321095 (CAD 230.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (181, 18, 181, '2025-02-11', 3, 0.00); -- CAFC report 322500 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (182, 14, 182, '2025-02-17', 9, NULL); -- CAFC report 323171
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (183, 14, 183, '2025-02-24', 9, NULL); -- CAFC report 324072
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (184, 16, 184, '2025-02-25', 5, 0.00); -- CAFC report 324311 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (185, 14, 185, '2025-02-28', 9, NULL); -- CAFC report 324890
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (186, 14, 186, '2025-03-05', 9, NULL); -- CAFC report 325744
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (187, 14, 187, '2025-03-09', 9, NULL); -- CAFC report 326318
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (188, 14, 188, '2025-03-25', 9, NULL); -- CAFC report 328930
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (189, 7, 189, '2025-05-01', 2, 795.54); -- CAFC report 333867 (CAD 1112.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (190, 16, 190, '2025-05-23', 9, 4292.46); -- CAFC report 336649 (CAD 6000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (191, 16, 191, '2025-07-01', 5, 101097.44); -- CAFC report 341427 (CAD 141314.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (192, 7, 192, '2025-07-04', 1, 0.00); -- CAFC report 341826 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (193, 16, 193, '2025-07-07', 13, 10015.74); -- CAFC report 341975 (CAD 14000.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (194, 1, 194, '2025-07-16', 1, 4094.79); -- CAFC report 343005 (CAD 5723.70)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (195, 16, 195, '2025-07-29', 5, 11233.37); -- CAFC report 344469 (CAD 15702.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (196, 14, 196, '2025-08-05', 9, NULL); -- CAFC report 345187
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (197, 14, 197, '2025-09-03', 8, NULL); -- CAFC report 348356
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (198, 17, 198, '2025-09-17', 3, 0.00); -- CAFC report 349445 (CAD 0.00)
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (199, 14, 199, '2025-09-19', 9, NULL); -- CAFC report 349601
INSERT INTO Fraud_Incident (Fraud_incident_ID, Fraud_type_ID, Person_ID, Incident_date, Channel_ID, Financial_loss_amount) VALUES (200, 17, 200, '2025-09-23', 13, 146112.98); -- CAFC report 349926 (CAD 204236.72)

-- Report
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (1, 1, 1, '2021-01-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (2, 2, 1, '2021-01-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (3, 3, 1, '2021-02-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (4, 4, 1, '2021-02-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (5, 5, 1, '2021-02-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (6, 6, 1, '2021-02-10');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (7, 7, 1, '2021-02-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (8, 8, 1, '2021-02-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (9, 9, 1, '2021-02-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (10, 10, 1, '2021-03-02');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (11, 11, 1, '2021-03-02');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (12, 12, 1, '2021-03-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (13, 13, 1, '2021-03-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (14, 14, 1, '2021-03-18');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (15, 15, 1, '2021-03-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (16, 16, 1, '2021-03-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (17, 17, 1, '2021-03-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (18, 18, 1, '2021-03-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (19, 19, 1, '2021-03-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (20, 20, 1, '2021-04-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (21, 21, 1, '2021-04-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (22, 22, 1, '2021-04-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (23, 23, 1, '2021-04-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (24, 24, 1, '2021-05-04');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (25, 25, 1, '2021-05-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (26, 26, 1, '2021-05-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (27, 27, 1, '2021-05-26');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (28, 28, 1, '2021-06-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (29, 29, 1, '2021-06-10');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (30, 30, 1, '2021-06-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (31, 31, 1, '2021-06-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (32, 32, 1, '2021-07-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (33, 33, 1, '2021-07-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (34, 34, 1, '2021-07-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (35, 35, 1, '2021-07-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (36, 36, 1, '2021-07-31');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (37, 37, 1, '2021-08-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (38, 38, 1, '2021-08-10');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (39, 39, 1, '2021-08-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (40, 40, 1, '2021-08-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (41, 41, 1, '2021-08-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (42, 42, 1, '2021-09-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (43, 43, 1, '2021-10-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (44, 44, 1, '2021-10-26');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (45, 45, 1, '2021-10-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (46, 46, 1, '2021-11-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (47, 47, 1, '2021-11-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (48, 48, 1, '2021-11-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (49, 49, 1, '2021-11-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (50, 50, 1, '2021-11-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (51, 51, 1, '2021-12-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (52, 52, 1, '2021-12-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (53, 53, 1, '2021-12-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (54, 54, 1, '2021-12-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (55, 55, 1, '2022-01-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (56, 56, 1, '2022-01-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (57, 57, 1, '2022-01-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (58, 58, 1, '2022-01-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (59, 59, 1, '2022-02-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (60, 60, 1, '2022-02-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (61, 61, 1, '2022-02-14');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (62, 62, 1, '2022-02-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (63, 63, 1, '2022-03-02');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (64, 64, 1, '2022-03-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (65, 65, 1, '2022-03-10');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (66, 66, 1, '2022-03-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (67, 67, 1, '2022-03-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (68, 68, 1, '2022-04-01');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (69, 69, 1, '2022-04-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (70, 70, 1, '2022-04-20');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (71, 71, 1, '2022-04-26');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (72, 72, 1, '2022-04-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (73, 73, 1, '2022-05-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (74, 74, 1, '2022-05-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (75, 75, 1, '2022-05-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (76, 76, 1, '2022-05-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (77, 77, 1, '2022-05-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (78, 78, 1, '2022-05-31');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (79, 79, 1, '2022-06-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (80, 80, 1, '2022-06-26');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (81, 81, 1, '2022-06-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (82, 82, 1, '2022-06-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (83, 83, 1, '2022-07-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (84, 84, 1, '2022-07-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (85, 85, 1, '2022-07-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (86, 86, 1, '2022-07-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (87, 87, 1, '2022-07-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (88, 88, 1, '2022-07-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (89, 89, 1, '2022-07-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (90, 90, 1, '2022-08-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (91, 91, 1, '2022-08-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (92, 92, 1, '2022-08-15');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (93, 93, 1, '2022-08-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (94, 94, 1, '2022-08-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (95, 95, 1, '2022-08-24');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (96, 96, 1, '2022-09-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (97, 97, 1, '2022-09-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (98, 98, 1, '2022-09-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (99, 99, 1, '2022-09-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (100, 100, 1, '2022-10-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (101, 101, 1, '2022-10-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (102, 102, 1, '2022-10-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (103, 103, 1, '2022-11-04');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (104, 104, 1, '2022-11-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (105, 105, 1, '2022-11-24');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (106, 106, 1, '2022-12-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (107, 107, 1, '2022-12-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (108, 108, 1, '2022-12-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (109, 109, 1, '2022-12-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (110, 110, 1, '2022-12-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (111, 111, 1, '2023-01-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (112, 112, 1, '2023-01-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (113, 113, 1, '2023-01-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (114, 114, 1, '2023-01-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (115, 115, 1, '2023-01-20');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (116, 116, 1, '2023-01-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (117, 117, 1, '2023-02-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (118, 118, 1, '2023-02-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (119, 119, 1, '2023-03-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (120, 120, 1, '2023-03-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (121, 121, 1, '2023-03-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (122, 122, 1, '2023-04-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (123, 123, 1, '2023-04-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (124, 124, 1, '2023-04-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (125, 125, 1, '2023-05-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (126, 126, 1, '2023-05-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (127, 127, 1, '2023-06-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (128, 128, 1, '2023-06-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (129, 129, 1, '2023-06-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (130, 130, 1, '2023-06-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (131, 131, 1, '2023-06-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (132, 132, 1, '2023-06-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (133, 133, 1, '2023-07-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (134, 134, 1, '2023-07-20');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (135, 135, 1, '2023-07-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (136, 136, 1, '2023-09-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (137, 137, 1, '2023-09-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (138, 138, 1, '2023-09-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (139, 139, 1, '2023-09-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (140, 140, 1, '2023-09-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (141, 141, 1, '2023-10-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (142, 142, 1, '2023-10-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (143, 143, 1, '2023-12-02');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (144, 144, 1, '2023-12-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (145, 145, 1, '2023-12-27');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (146, 146, 1, '2024-01-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (147, 147, 1, '2024-01-06');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (148, 148, 1, '2024-01-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (149, 149, 1, '2024-02-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (150, 150, 1, '2024-02-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (151, 151, 1, '2024-03-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (152, 152, 1, '2024-03-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (153, 153, 1, '2024-04-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (154, 154, 1, '2024-05-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (155, 155, 1, '2024-05-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (156, 156, 1, '2024-05-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (157, 157, 1, '2024-06-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (158, 158, 1, '2024-06-21');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (159, 159, 1, '2024-06-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (160, 160, 1, '2024-07-02');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (161, 161, 1, '2024-07-22');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (162, 162, 1, '2024-07-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (163, 163, 1, '2024-08-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (164, 164, 1, '2024-08-15');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (165, 165, 1, '2024-09-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (166, 166, 1, '2024-09-13');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (167, 167, 1, '2024-09-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (168, 168, 1, '2024-09-18');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (169, 169, 1, '2024-09-26');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (170, 170, 1, '2024-10-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (171, 171, 1, '2024-11-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (172, 172, 1, '2024-11-30');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (173, 173, 1, '2024-12-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (174, 174, 1, '2024-12-04');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (175, 175, 1, '2024-12-08');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (176, 176, 1, '2024-12-12');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (177, 177, 1, '2024-12-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (178, 178, 1, '2025-01-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (179, 179, 1, '2025-01-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (180, 180, 1, '2025-01-31');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (181, 181, 1, '2025-02-11');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (182, 182, 1, '2025-02-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (183, 183, 1, '2025-02-24');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (184, 184, 1, '2025-02-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (185, 185, 1, '2025-02-28');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (186, 186, 1, '2025-03-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (187, 187, 1, '2025-03-09');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (188, 188, 1, '2025-03-25');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (189, 189, 1, '2025-05-01');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (190, 190, 1, '2025-05-23');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (191, 191, 1, '2025-07-01');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (192, 192, 1, '2025-07-04');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (193, 193, 1, '2025-07-07');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (194, 194, 1, '2025-07-16');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (195, 195, 1, '2025-07-29');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (196, 196, 1, '2025-08-05');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (197, 197, 1, '2025-09-03');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (198, 198, 1, '2025-09-17');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (199, 199, 1, '2025-09-19');
INSERT INTO Report (Report_ID, Fraud_incident_ID, Organisation_ID, Report_date) VALUES (200, 200, 1, '2025-09-23');

-- Consequences: not available in the CAFC data
