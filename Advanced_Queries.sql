-- Advanced Queries

-- 1. Organisations ranked by number of reports received
SELECT
            o.Organisation_name,
            o.Organisation_type,
            COUNT(r.Report_ID) AS reports_handled
        FROM Organisation o
        LEFT JOIN Report r ON r.Organisation_ID = o.Organisation_ID
        GROUP BY o.Organisation_ID
        ORDER BY reports_handled DESC;

-- 2. Average loss by age bracket, ranked within each bracket by channel
WITH bracketed AS (
            SELECT
                fi.Fraud_incident_ID,
                fi.Financial_loss_amount,
                cc.Channel_kind,
                CASE
                    WHEN p.Age < 30 THEN 'Under 30'
                    WHEN p.Age BETWEEN 30 AND 49 THEN '30-49'
                    WHEN p.Age BETWEEN 50 AND 64 THEN '50-64'
                    ELSE '65+'
                END AS age_bracket
            FROM Fraud_Incident fi
            JOIN Person p ON p.Person_ID = fi.Person_ID
            JOIN Communication_Channel cc ON cc.Channel_ID = fi.Channel_ID
        ),
        channel_avg AS (
            SELECT
                age_bracket,
                Channel_kind,
                ROUND(AVG(Financial_loss_amount), 2) AS avg_loss,
                COUNT(*) AS incident_count
            FROM bracketed
            GROUP BY age_bracket, Channel_kind
        )
        SELECT
            age_bracket,
            Channel_kind,
            incident_count,
            avg_loss,
            RANK() OVER (PARTITION BY age_bracket ORDER BY avg_loss DESC) AS loss_rank
        FROM channel_avg
        ORDER BY age_bracket, loss_rank;

-- 3. Repeat victims: people with more than one incident, total loss
SELECT
            p.Person_ID,
            p.Occupation,
            p.Age,
            COUNT(fi.Fraud_incident_ID)               AS incident_count,
            ROUND(SUM(fi.Financial_loss_amount), 2)   AS total_loss
        FROM Person p
        JOIN Fraud_Incident fi ON fi.Person_ID = p.Person_ID
        GROUP BY p.Person_ID
        HAVING COUNT(fi.Fraud_incident_ID) > 1
        ORDER BY total_loss DESC;

