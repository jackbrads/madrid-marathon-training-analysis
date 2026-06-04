-- =============================================
-- Marathon Training Analytics
-- File: 02_analytical_queries.sql
-- Description: Creates all tables in Snowflake
-- Author: Jack Bradley
-- Date: 2026
-- =============================================


-- High level summary of entire training block
SELECT
    COUNT(*)                        AS total_sessions,
    SUM(planned_km)                 AS total_planned_km,
    SUM(actual_km)                  AS total_actual_km,
    ROUND(SUM(actual_km) - SUM(planned_km), 2) AS total_variance,
    SUM(elevation_gain)             AS total_elevation_gain,
    MIN(date)                       AS first_session,
    MAX(date)                       AS last_session
FROM marathon_analysis.training.training_sessions;

-- Week by week comparison
SELECT
    week_number,
    COUNT(*)                        AS sessions,
    SUM(planned_km)                 AS planned_km,
    SUM(actual_km)                  AS actual_km,
    ROUND(SUM(actual_km) - SUM(planned_km), 2) AS variance,
    SUM(elevation_gain)             AS elevation_gain
FROM marathon_analysis.training.training_sessions
GROUP BY week_number
ORDER BY week_number;

-- How your long runs built over the block
SELECT
    date,
    week_number,
    planned_km,
    actual_km,
    avg_pace,
    avg_hr,
    cadence,
    elevation_gain,
    elapsed_time
FROM marathon_analysis.training.training_sessions
WHERE run_type = 'Long Run'
ORDER BY date;

-- HR trend across all runs
SELECT
    date,
    week_number,
    run_type,
    actual_km,
    avg_pace,
    avg_hr
FROM marathon_analysis.training.training_sessions
WHERE avg_hr IS NOT NULL
ORDER BY date;

-- Average HR per run type across the block
SELECT
    run_type,
    COUNT(*)            AS sessions,
    ROUND(AVG(avg_hr),1) AS avg_hr,
    MIN(avg_hr)         AS min_hr,
    MAX(avg_hr)         AS max_hr
FROM marathon_analysis.training.training_sessions
GROUP BY run_type
ORDER BY avg_hr;

-- Cadence trend over time
SELECT
    date,
    week_number,
    run_type,
    cadence,
    actual_km,
    avg_pace
FROM marathon_analysis.training.training_sessions
WHERE cadence IS NOT NULL
ORDER BY date;

-- Is cadence consistent across session types?
SELECT
    run_type,
    COUNT(*)                AS sessions,
    ROUND(AVG(cadence), 1)  AS avg_cadence,
    MIN(cadence)            AS min_cadence,
    MAX(cadence)            AS max_cadence
FROM marathon_analysis.training.training_sessions
GROUP BY run_type
ORDER BY avg_cadence DESC;

-- Side by side planned vs actual for every km
SELECT
    km,
    planned_pace,
    actual_pace,
    split_pace
FROM marathon_analysis.training.race_splits
ORDER BY km;

-- Compare planned vs actual pace per km
-- Positive variance = ran faster than planned
-- Negative variance = ran slower than planned
SELECT
    km,
    planned_pace,
    actual_pace,
    CASE
        WHEN actual_pace < planned_pace THEN 'Faster Than Planned'
        WHEN actual_pace > planned_pace THEN 'Slower Than Planned'
        ELSE 'On Pace'
    END AS pace_status
FROM marathon_analysis.training.race_splits
ORDER BY km;

-- Performance grouped into 5km bands
SELECT
    CASE
        WHEN km <= 5  THEN '01 - 0-5km'
        WHEN km <= 10 THEN '02 - 5-10km'
        WHEN km <= 15 THEN '03 - 10-15km'
        WHEN km <= 20 THEN '04 - 15-20km'
        WHEN km <= 25 THEN '05 - 20-25km'
        WHEN km <= 30 THEN '06 - 25-30km'
        WHEN km <= 35 THEN '07 - 30-35km'
        WHEN km <= 40 THEN '08 - 35-40km'
        ELSE               '09 - 40-42km'
    END AS split_band,
    COUNT(km) AS km_count,
    MIN(actual_pace) AS fastest_km,
    MAX(actual_pace) AS slowest_km
FROM marathon_analysis.training.race_splits
GROUP BY
    CASE
        WHEN km <= 5  THEN '01 - 0-5km'
        WHEN km <= 10 THEN '02 - 5-10km'
        WHEN km <= 15 THEN '03 - 10-15km'
        WHEN km <= 20 THEN '04 - 15-20km'
        WHEN km <= 25 THEN '05 - 20-25km'
        WHEN km <= 30 THEN '06 - 25-30km'
        WHEN km <= 35 THEN '07 - 30-35km'
        WHEN km <= 40 THEN '08 - 35-40km'
        ELSE               '09 - 40-42km'
    END
ORDER BY split_band;

-- Top 5 fastest km
SELECT
    km,
    actual_pace,
    planned_pace
FROM marathon_analysis.training.race_splits
ORDER BY actual_pace ASC
LIMIT 5;

-- Top 5 slowest km
SELECT
    km,
    actual_pace,
    planned_pace
FROM marathon_analysis.training.race_splits
ORDER BY actual_pace DESC
LIMIT 5;


