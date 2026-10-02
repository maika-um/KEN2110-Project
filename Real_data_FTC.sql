-- Real data: FTC Consumer Sentinel Network Data Book 2024 (United States)
-- Source:    https://www.ftc.gov/reports/consumer-sentinel-network-data-book-2024
-- File:      csn-annual-data-book-2024.pdf (published March 2025)
-- Licence:   Public domain - works of the U.S. federal government are not protected by copyright (17 U.S.C. 105).
--            Free download, no registration.
-- Used:      Appendix B3 (reports per fraud subcategory, 2022-2024), page 12 (reports and losses per contact method, 2024),
--            page 13 (reports and losses per age range, 2024)
-- Rows:      123 report counts + 16 loss statistics
-- Run order: Schema.sql -> Real_Data_CAFC.sql -> Real_Data_FTC.sql  (IDs continue after the CAFC data)
--
-- Schema changes needed before loading (already in Schema.sql):
--   The FTC only publishes totals (e.g. "450,104 reports of Business Imposters in 2024"), not individual reports.
--   These cannot go into Person / Fraud_Incident / Report (those need one person and one incident), so we added:
--   Report_Count   (Organisation, Fraud_type, Report_year, Number_of_reports)
--   Loss_Statistic (Organisation, Report_year, Channel OR Age_range, Number_of_reports, Pct_reporting_loss,
--                   Total_loss, Median_loss, Currency)
--   Channel_kind and Fraud_kind are now UNIQUE COLLATE NOCASE, so the same name with other capitals is not stored twice.
--
-- Cleaning notes:
--   Getting the data: the FTC only publishes a PDF; its text layer is partly broken ("FraudReportsbyPay mentMet hod").
--     Numbers read with pdfplumber, names typed from the PDF, every row checked by hand.
--   Missing data: no codes. Information people did not give is left out: only 45% of fraud reports have an age,
--     58% a contact method. "Other" (contact method) and "Unspecified Reports" are catch-all groups.
--     Losses only count amounts between $1 and $999,999.
--   Dates: only years ("2022", "2023", "2024") as column headers, based on the date of the report (not of the fraud).
--     Stored as Report_year. FTC says recent totals can still change because some partners report late.
--   Duplicates: one report can be counted in several subcategories (e.g. Imposter Scams subcategories add up to
--     879,167 in 2024, the category total is 845,806), so FTC numbers cannot simply be added up.
--     Category and subcategory sometimes have the same name ("Identity Theft / Identity Theft"): only the subcategory
--     level is loaded. Appendix B2 repeats B3 per category, so only B3 is used.
--   Naming: footnote symbols inside names (* = counted as Other, not fraud; † = counted as fraud; ‡ § = renamed)
--     were used to select fraud rows and then removed. "&%" vs "and" differs between levels.
--     Money and percentages are text: "$1,500" -> 1500, "$502M" -> 502000000 (rounded to millions in the source),
--     "25%" -> 25, "30,330 (3%)" -> 30330.
--     FTC names mapped to the CAFC names already in the database (see comments below), e.g. "Text" -> 'Text message',
--     "Romance Scams" -> 'Romance'. Age ranges written like CAFC: "20 - 29" -> '20-29'; "19 and Under" -> '0-19',
--     "80 and Over" -> '80+' (CAFC uses '10-19' and '80-89', so the first and last ranges do not match exactly).
--   Selection: B3 also has non-fraud complaints (cars, debt collection, credit bureaus). Only the 17 FTC fraud categories
--     (Appendix B1) + Identity Theft are loaded: 41 of 99 subcategories (58 skipped).
--   Currency: US dollars (CAFC amounts are Canadian dollars) -> stored in Loss_Statistic.Currency.

-- Organisation
INSERT INTO Organisation (Organisation_ID, Organisation_name, Organisation_type) VALUES (2, 'FTC Consumer Sentinel Network', 'Government');

-- Communication_Channel (new; the other FTC contact methods map to existing CAFC channels)
INSERT INTO Communication_Channel (Channel_ID, Channel_kind) VALUES (15, 'Online ad or pop-up');

-- Fraud_Type (new FTC fraud types; FTC category in the comment)
-- Mapped to existing CAFC types: Advance-Fee Credit -> 'Loan'; Job Scams & Employment Agencies -> 'Job'; Pyramids & Multi-Level Marketing -> 'Pyramid'; Charitable Solicitations -> 'Charity / Donation'; Fake Check Scams -> 'Fraudulent Cheque'; Foreign Money & Inheritance Scams -> 'Foreign Money Offer'; Non-Educational Grants -> 'Grant'; Identity Theft -> 'Identity Fraud'; Romance Scams -> 'Romance'; Miscellaneous Investments & Investment Advice -> 'Investments'; Office Supplies & Services -> 'Office Supplies'; Online Shopping -> 'Merchandise'; Prizes, Sweepstakes & Lotteries -> 'Prize'; Vacation & Travel -> 'Vacation'
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (40, 'Credit Repair'); -- Advance Payments for Credit Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (41, 'Business & Work-at-Home Opportunities'); -- Business and Job Opportunities
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (42, 'Invention Promotion'); -- Business and Job Opportunities
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (43, 'Scholarships & Educational Grants'); -- Grants
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (44, 'Diet Products, Plans & Centers'); -- Health Care
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (45, 'Medical Insurance & Discount Plans'); -- Health Care
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (46, 'Medical Treatments & Cures'); -- Health Care
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (47, 'Business Imposters'); -- Imposter Scams
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (48, 'Family & Friend Imposters'); -- Imposter Scams
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (49, 'Government Imposters'); -- Imposter Scams
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (50, 'Tech Support Scams'); -- Imposter Scams
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (51, 'Online Payment Services'); -- Internet Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (52, 'Social Networking Services'); -- Internet Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (53, 'Website Content'); -- Internet Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (54, 'Website Design & Promotion'); -- Internet Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (55, 'Stocks & Commodity Futures Trading'); -- Investment Related
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (56, 'Books & Magazines'); -- Magazines and Books
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (57, 'Credit & Debt Counseling'); -- Mortgage Foreclosure Relief and Debt Management
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (58, 'Mortgage Modification & Foreclosure Relief'); -- Mortgage Foreclosure Relief and Debt Management
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (59, 'Office Directory Listings & Ad Space'); -- Office Supplies and Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (60, 'Malware & Computer Exploits'); -- Privacy, Data Security, and Cyber Threats
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (61, 'Tax Preparers'); -- Tax Preparers
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (62, 'Phone Billing'); -- Telephone and Mobile Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (63, 'Phone Devices, Accessories & Services'); -- Telephone and Mobile Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (64, 'Prepaid Phone Cards'); -- Telephone and Mobile Services
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (65, 'Timeshare Resales'); -- Travel, Vacations and Timeshare Plans
INSERT INTO Fraud_Type (Fraud_type_ID, Fraud_kind) VALUES (66, 'Timeshare Sales'); -- Travel, Vacations and Timeshare Plans

-- Report_Count (Appendix B3)
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (1, 2, 18, 2022, 30604); -- Advance-Fee Credit
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (2, 2, 18, 2023, 26362); -- Advance-Fee Credit
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (3, 2, 18, 2024, 23395); -- Advance-Fee Credit
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (4, 2, 40, 2022, 4282); -- Credit Repair
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (5, 2, 40, 2023, 4105); -- Credit Repair
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (6, 2, 40, 2024, 4162); -- Credit Repair
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (7, 2, 41, 2022, 15258); -- Business & Work-at-Home Opportunities
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (8, 2, 41, 2023, 16197); -- Business & Work-at-Home Opportunities
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (9, 2, 41, 2024, 14809); -- Business & Work-at-Home Opportunities
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (10, 2, 42, 2022, 438); -- Invention Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (11, 2, 42, 2023, 365); -- Invention Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (12, 2, 42, 2024, 355); -- Invention Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (13, 2, 17, 2022, 71562); -- Job Scams & Employment Agencies
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (14, 2, 17, 2023, 85533); -- Job Scams & Employment Agencies
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (15, 2, 17, 2024, 104946); -- Job Scams & Employment Agencies
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (16, 2, 27, 2022, 8735); -- Pyramids & Multi-Level Marketing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (17, 2, 27, 2023, 6797); -- Pyramids & Multi-Level Marketing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (18, 2, 27, 2024, 6283); -- Pyramids & Multi-Level Marketing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (19, 2, 2, 2022, 10236); -- Charitable Solicitations
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (20, 2, 2, 2023, 9976); -- Charitable Solicitations
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (21, 2, 2, 2024, 11019); -- Charitable Solicitations
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (22, 2, 11, 2022, 38451); -- Fake Check Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (23, 2, 11, 2023, 29144); -- Fake Check Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (24, 2, 11, 2024, 13616); -- Fake Check Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (25, 2, 10, 2022, 2890); -- Foreign Money & Inheritance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (26, 2, 10, 2023, 3053); -- Foreign Money & Inheritance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (27, 2, 10, 2024, 5061); -- Foreign Money & Inheritance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (28, 2, 12, 2022, 2265); -- Non-Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (29, 2, 12, 2023, 2144); -- Non-Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (30, 2, 12, 2024, 2011); -- Non-Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (31, 2, 43, 2022, 299); -- Scholarships & Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (32, 2, 43, 2023, 210); -- Scholarships & Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (33, 2, 43, 2024, 236); -- Scholarships & Educational Grants
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (34, 2, 44, 2022, 22342); -- Diet Products, Plans & Centers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (35, 2, 44, 2023, 18722); -- Diet Products, Plans & Centers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (36, 2, 44, 2024, 18294); -- Diet Products, Plans & Centers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (37, 2, 45, 2022, 8030); -- Medical Insurance & Discount Plans
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (38, 2, 45, 2023, 8996); -- Medical Insurance & Discount Plans
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (39, 2, 45, 2024, 10147); -- Medical Insurance & Discount Plans
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (40, 2, 46, 2022, 46564); -- Medical Treatments & Cures
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (41, 2, 46, 2023, 47475); -- Medical Treatments & Cures
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (42, 2, 46, 2024, 50361); -- Medical Treatments & Cures
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (43, 2, 14, 2022, 1107004); -- Identity Theft
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (44, 2, 14, 2023, 1036855); -- Identity Theft
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (45, 2, 14, 2024, 1135291); -- Identity Theft
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (46, 2, 47, 2022, 399753); -- Business Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (47, 2, 47, 2023, 475110); -- Business Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (48, 2, 47, 2024, 450104); -- Business Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (49, 2, 48, 2022, 37340); -- Family & Friend Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (50, 2, 48, 2023, 33759); -- Family & Friend Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (51, 2, 48, 2024, 34377); -- Family & Friend Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (52, 2, 49, 2022, 197496); -- Government Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (53, 2, 49, 2023, 228202); -- Government Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (54, 2, 49, 2024, 265975); -- Government Imposters
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (55, 2, 29, 2022, 69582); -- Romance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (56, 2, 29, 2023, 65717); -- Romance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (57, 2, 29, 2024, 59490); -- Romance Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (58, 2, 50, 2022, 89593); -- Tech Support Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (59, 2, 50, 2023, 91234); -- Tech Support Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (60, 2, 50, 2024, 69221); -- Tech Support Scams
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (61, 2, 51, 2022, 68711); -- Online Payment Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (62, 2, 51, 2023, 60162); -- Online Payment Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (63, 2, 51, 2024, 69670); -- Online Payment Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (64, 2, 52, 2022, 12637); -- Social Networking Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (65, 2, 52, 2023, 13034); -- Social Networking Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (66, 2, 52, 2024, 14173); -- Social Networking Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (67, 2, 53, 2022, 31716); -- Website Content
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (68, 2, 53, 2023, 28596); -- Website Content
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (69, 2, 53, 2024, 29672); -- Website Content
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (70, 2, 54, 2022, 4109); -- Website Design & Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (71, 2, 54, 2023, 4473); -- Website Design & Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (72, 2, 54, 2024, 4765); -- Website Design & Promotion
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (73, 2, 16, 2022, 105041); -- Miscellaneous Investments & Investment Advice
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (74, 2, 16, 2023, 107990); -- Miscellaneous Investments & Investment Advice
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (75, 2, 16, 2024, 116071); -- Miscellaneous Investments & Investment Advice
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (76, 2, 55, 2022, 2926); -- Stocks & Commodity Futures Trading
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (77, 2, 55, 2023, 2664); -- Stocks & Commodity Futures Trading
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (78, 2, 55, 2024, 2897); -- Stocks & Commodity Futures Trading
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (79, 2, 56, 2022, 6777); -- Books & Magazines
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (80, 2, 56, 2023, 5679); -- Books & Magazines
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (81, 2, 56, 2024, 5435); -- Books & Magazines
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (82, 2, 57, 2022, 23859); -- Credit & Debt Counseling
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (83, 2, 57, 2023, 25610); -- Credit & Debt Counseling
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (84, 2, 57, 2024, 32955); -- Credit & Debt Counseling
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (85, 2, 58, 2022, 992); -- Mortgage Modification & Foreclosure Relief
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (86, 2, 58, 2023, 1034); -- Mortgage Modification & Foreclosure Relief
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (87, 2, 58, 2024, 1205); -- Mortgage Modification & Foreclosure Relief
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (88, 2, 59, 2022, 2319); -- Office Directory Listings & Ad Space
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (89, 2, 59, 2023, 1649); -- Office Directory Listings & Ad Space
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (90, 2, 59, 2024, 1339); -- Office Directory Listings & Ad Space
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (91, 2, 21, 2022, 2134); -- Office Supplies & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (92, 2, 21, 2023, 2305); -- Office Supplies & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (93, 2, 21, 2024, 2186); -- Office Supplies & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (94, 2, 19, 2022, 367177); -- Online Shopping
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (95, 2, 19, 2023, 379690); -- Online Shopping
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (96, 2, 19, 2024, 383441); -- Online Shopping
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (97, 2, 60, 2022, 51724); -- Malware & Computer Exploits
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (98, 2, 60, 2023, 63043); -- Malware & Computer Exploits
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (99, 2, 60, 2024, 89432); -- Malware & Computer Exploits
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (100, 2, 25, 2022, 148570); -- Prizes, Sweepstakes & Lotteries
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (101, 2, 25, 2023, 158102); -- Prizes, Sweepstakes & Lotteries
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (102, 2, 25, 2024, 97350); -- Prizes, Sweepstakes & Lotteries
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (103, 2, 61, 2022, 8824); -- Tax Preparers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (104, 2, 61, 2023, 6220); -- Tax Preparers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (105, 2, 61, 2024, 5317); -- Tax Preparers
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (106, 2, 62, 2022, 18305); -- Phone Billing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (107, 2, 62, 2023, 17600); -- Phone Billing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (108, 2, 62, 2024, 16499); -- Phone Billing
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (109, 2, 63, 2022, 89691); -- Phone Devices, Accessories & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (110, 2, 63, 2023, 79062); -- Phone Devices, Accessories & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (111, 2, 63, 2024, 75680); -- Phone Devices, Accessories & Services
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (112, 2, 64, 2022, 1712); -- Prepaid Phone Cards
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (113, 2, 64, 2023, 1725); -- Prepaid Phone Cards
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (114, 2, 64, 2024, 1170); -- Prepaid Phone Cards
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (115, 2, 65, 2022, 2660); -- Timeshare Resales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (116, 2, 65, 2023, 1872); -- Timeshare Resales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (117, 2, 65, 2024, 1525); -- Timeshare Resales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (118, 2, 66, 2022, 10944); -- Timeshare Sales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (119, 2, 66, 2023, 8265); -- Timeshare Sales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (120, 2, 66, 2024, 9741); -- Timeshare Sales
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (121, 2, 38, 2022, 55719); -- Vacation & Travel
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (122, 2, 38, 2023, 47021); -- Vacation & Travel
INSERT INTO Report_Count (Report_count_ID, Organisation_ID, Fraud_type_ID, Report_year, Number_of_reports) VALUES (123, 2, 38, 2024, 47184); -- Vacation & Travel

-- Loss_Statistic (page 12: per contact method, page 13: per age range)
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (1, 2, 2024, 3, NULL, 371651, 11, 502000000, 600, 'USD'); -- FTC: Email
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (2, 2, 2024, 1, NULL, 284659, 19, 948000000, 1500, 'USD'); -- FTC: Phone call
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (3, 2, 2024, 13, NULL, 246784, 11, 470000000, 1000, 'USD'); -- FTC: Text
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (4, 2, 2024, 6, NULL, 186826, 70, 1858000000, 409, 'USD'); -- FTC: Social Media
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (5, 2, 2024, 5, NULL, 186663, 68, 976000000, 200, 'USD'); -- FTC: Website or Apps
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (6, 2, 2024, 9, NULL, 148288, 40, 1072000000, 633, 'USD'); -- FTC: Other
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (7, 2, 2024, 7, NULL, 42108, 13, 90000000, 990, 'USD'); -- FTC: Mail
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (8, 2, 2024, 15, NULL, 42023, 62, 246000000, 180, 'USD'); -- FTC: Online Ad or Pop-up
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (9, 2, 2024, NULL, '0-19', 30330, 51, 55000000, 189, 'USD'); -- FTC: 19 and Under
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (10, 2, 2024, NULL, '20-29', 155346, 44, 430000000, 417, 'USD'); -- FTC: 20 - 29
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (11, 2, 2024, NULL, '30-39', 203764, 40, 810000000, 450, 'USD'); -- FTC: 30 - 39
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (12, 2, 2024, NULL, '40-49', 191508, 38, 971000000, 500, 'USD'); -- FTC: 40 - 49
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (13, 2, 2024, NULL, '50-59', 175898, 35, 1006000000, 520, 'USD'); -- FTC: 50 - 59
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (14, 2, 2024, NULL, '60-69', 208896, 29, 1180000000, 691, 'USD'); -- FTC: 60 - 69
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (15, 2, 2024, NULL, '70-79', 159550, 24, 887000000, 1000, 'USD'); -- FTC: 70 - 79
INSERT INTO Loss_Statistic (Loss_statistic_ID, Organisation_ID, Report_year, Channel_ID, Age_range, Number_of_reports, Pct_reporting_loss, Total_loss, Median_loss, Currency) VALUES (16, 2, 2024, NULL, '80+', 51713, 21, 319000000, 1650, 'USD'); -- FTC: 80 and Over
  
