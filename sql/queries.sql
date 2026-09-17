-- ============================================================
-- Advanced queries
-- Answering (parts of) our research question: "who is most
-- likely to become a victim of online fraud, and how does the
-- reporting behaviour differ?"
-- ============================================================

-- 1) Total & average financial loss per occupation, highest first.
--    (JOIN + GROUP BY + aggregate functions)
SELECT
    p.Occupation,
    COUNT(fi.Fraud_Incident_ID)            AS incident_count,
    ROUND(SUM(fi.Financial_loss_amount), 2) AS total_loss,
    ROUND(AVG(fi.Financial_loss_amount), 2) AS avg_loss
FROM Person p
JOIN Fraud_Incident fi ON fi.Person_ID = p.Person_ID
GROUP BY p.Occupation
ORDER BY total_loss DESC;


-- 2) Which communication channel has the highest share of incidents
--    that led to BOTH an emotional and a financial consequence?
--    (JOIN + GROUP BY + HAVING + derived percentage)
SELECT
    cc.Channel_kind,
    COUNT(fi.Fraud_Incident_ID) AS total_incidents,
    SUM(CASE WHEN c.Emotional_problem = 1 AND c.Financial_problem = 1 THEN 1 ELSE 0 END) AS both_consequences,
    ROUND(
        100.0 * SUM(CASE WHEN c.Emotional_problem = 1 AND c.Financial_problem = 1 THEN 1 ELSE 0 END)
        / COUNT(fi.Fraud_Incident_ID), 1
    ) AS pct_with_both_consequences
FROM Fraud_Incident fi
JOIN Communication_Channel cc ON cc.Channel_ID = fi.Channel_ID
LEFT JOIN Consequences c ON c.Fraud_Incident_ID = fi.Fraud_Incident_ID
GROUP BY cc.Channel_kind
HAVING COUNT(fi.Fraud_Incident_ID) >= 3
ORDER BY pct_with_both_consequences DESC;


-- 3) Fraud types with more than 5 recorded incidents: average victim
--    age and total loss. (GROUP BY + HAVING, filters on aggregates)
SELECT
    ft.Fraud_kind,
    COUNT(fi.Fraud_Incident_ID)        AS incident_count,
    ROUND(AVG(p.Age), 1)               AS avg_victim_age,
    ROUND(SUM(fi.Financial_loss_amount), 2) AS total_loss
FROM Fraud_Incident fi
JOIN Fraud_Type ft ON ft.Fraud_Type_ID = fi.Fraud_Type_ID
JOIN Person p       ON p.Person_ID = fi.Person_ID
GROUP BY ft.Fraud_kind
HAVING COUNT(fi.Fraud_Incident_ID) > 5
ORDER BY incident_count DESC;


-- 4) Reporting rate per fraud type: what % of incidents of each type
--    were ever reported to an organisation? (subquery + LEFT JOIN)
SELECT
    ft.Fraud_kind,
    COUNT(DISTINCT fi.Fraud_Incident_ID) AS total_incidents,
    COUNT(DISTINCT r.Fraud_Incident_ID)  AS reported_incidents,
    ROUND(
        100.0 * COUNT(DISTINCT r.Fraud_Incident_ID)
        / COUNT(DISTINCT fi.Fraud_Incident_ID), 1
    ) AS pct_reported
FROM Fraud_Incident fi
JOIN Fraud_Type ft ON ft.Fraud_Type_ID = fi.Fraud_Type_ID
LEFT JOIN Report r ON r.Fraud_Incident_ID = fi.Fraud_Incident_ID
GROUP BY ft.Fraud_kind
ORDER BY pct_reported ASC;


-- 5) Rank each victim's incidents by financial loss WITHIN their
--    fraud type, and keep only each person's single biggest loss
--    per fraud type. (window function: RANK() OVER PARTITION BY)
SELECT *
FROM (
    SELECT
        p.Person_ID,
        ft.Fraud_kind,
        fi.Financial_loss_amount,
        RANK() OVER (
            PARTITION BY ft.Fraud_kind
            ORDER BY fi.Financial_loss_amount DESC
        ) AS loss_rank_within_type
    FROM Fraud_Incident fi
    JOIN Person p       ON p.Person_ID = fi.Person_ID
    JOIN Fraud_Type ft  ON ft.Fraud_Type_ID = fi.Fraud_Type_ID
) ranked
WHERE loss_rank_within_type <= 3
ORDER BY Fraud_kind, loss_rank_within_type;
