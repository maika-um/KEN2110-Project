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
                    WHEN p.Age_range IN ('1-9', '10-19', '20-29')  THEN 'Under 30'
                    WHEN p.Age_range IN ('30-39', '40-49')         THEN '30-49'
                    WHEN p.Age_range IN ('50-59', '60-69')         THEN '50-69'
                    WHEN p.Age_range IN ('70-79', '80-89')         THEN '70+'                         
                    ELSE 'Unknown'
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
            p.Age_range,
            COUNT(fi.Fraud_incident_ID)               AS incident_count,
            ROUND(SUM(fi.Financial_loss_amount), 2)   AS total_loss
        FROM Person p
        JOIN Fraud_Incident fi ON fi.Person_ID = p.Person_ID
        GROUP BY p.Person_ID
        HAVING COUNT(fi.Fraud_incident_ID) > 1
        ORDER BY total_loss DESC;

-- 4. Canada vs United States: share of reports per fraud type (CAFC sample vs FTC 2024), only types in both datasets
WITH cafc AS (
    SELECT
        fi.Fraud_type_ID,
        COUNT(*) AS cafc_reports
    FROM Fraud_Incident fi
    GROUP BY fi.Fraud_type_ID
),
ftc AS (
    SELECT
        rc.Fraud_type_ID,
        SUM(rc.Number_of_reports) AS ftc_reports
    FROM Report_Count rc
    WHERE rc.Report_year = 2024
    GROUP BY rc.Fraud_type_ID
),
shared AS (
    SELECT
        ft.Fraud_kind,
        c.cafc_reports,
        f.ftc_reports,
        ROUND(100.0 * c.cafc_reports / SUM(c.cafc_reports) OVER (), 1) AS cafc_share_pct,
        ROUND(100.0 * f.ftc_reports  / SUM(f.ftc_reports)  OVER (), 1) AS ftc_share_pct
    FROM Fraud_Type ft
    JOIN cafc c ON c.Fraud_type_ID = ft.Fraud_type_ID
    JOIN ftc  f ON f.Fraud_type_ID = ft.Fraud_type_ID
)
SELECT
    Fraud_kind,
    cafc_reports,
    cafc_share_pct,
    RANK() OVER (ORDER BY cafc_share_pct DESC) AS canada_rank,
    ftc_reports,
    ftc_share_pct,
    RANK() OVER (ORDER BY ftc_share_pct DESC)  AS us_rank,
    ROUND(cafc_share_pct - ftc_share_pct, 1)   AS share_difference_pct
FROM shared
ORDER BY ABS(cafc_share_pct - ftc_share_pct) DESC;

