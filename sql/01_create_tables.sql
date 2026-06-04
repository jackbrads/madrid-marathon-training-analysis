-- =============================================
-- Marathon Training Analytics
-- File: 01_create_tables.sql
-- Description: Creates all tables in Snowflake
-- Author: Your Name
-- Date: 2026
-- =============================================
CREATE DATABASE marathon_analysis;
USE DATABASE marathon_analysis;
CREATE SCHEMA training;
USE SCHEMA training;

CREATE TABLE training_sessions (
    session_id    INTEGER AUTOINCREMENT PRIMARY KEY,
    date          DATE,
    week_number   INTEGER,
    run_type      VARCHAR(50),
    planned_km    DECIMAL(5,2),
    actual_km     DECIMAL(5,2),
    avg_pace      VARCHAR(10),
    avg_hr        INTEGER,
    cadence       INTEGER,
    elapsed_time  VARCHAR(10)
);

CREATE TABLE race_splits (
    split_id     INTEGER AUTOINCREMENT PRIMARY KEY,
    km           INTEGER,
    planned_pace VARCHAR(10),
    actual_pace  VARCHAR(10),
    split_pace   VARCHAR(10)
);

CREATE OR REPLACE TABLE RUNNING_ACTIVITIES (
    DATE                  DATE,
    MONTH                 VARCHAR(10),
    DISTANCE_KM           FLOAT,
    DURATION_MIN          FLOAT,
    AVG_PACE_MIN_PER_KM   FLOAT,
    AVG_HR                FLOAT,
    MAX_HR                FLOAT,
    VO2MAX                FLOAT,
    TRAINING_LOAD         FLOAT,
    TRAINING_EFFECT_LABEL VARCHAR(30),
    CALORIES              INTEGER,
    AVG_CADENCE_SPM       INTEGER,
    AVG_STRIDE_LENGTH_CM  FLOAT,
    ELEVATION_GAIN_M      FLOAT
);
