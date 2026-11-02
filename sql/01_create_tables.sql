-- Schema for NYC restaurant inspection data
-- Safe to re-run: existing tables are dropped first (in reverse dependency order)

DROP TABLE IF EXISTS violations;
DROP TABLE IF EXISTS inspections;
DROP TABLE IF EXISTS restaurants;


CREATE TABLE restaurants (
    camis               INTEGER PRIMARY KEY,
    dba                 TEXT,
    boro                TEXT CHECK (boro IN ('Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island')),
    building            TEXT,
    street              TEXT,
    zipcode             TEXT,
    phone               TEXT,
    cuisine_description TEXT,
    latitude            DOUBLE PRECISION,
    longitude           DOUBLE PRECISION,
    community_board     TEXT,
    council_district    TEXT,
    census_tract        TEXT,
    nta                 TEXT,
    boro_imputed        BOOLEAN NOT NULL,
    never_inspected     BOOLEAN NOT NULL
);


CREATE TABLE inspections (
    inspection_id        INTEGER PRIMARY KEY,
    camis                INTEGER NOT NULL REFERENCES restaurants (camis),
    inspection_date      DATE NOT NULL,
    inspection_type      TEXT NOT NULL,
    inspection_program   TEXT,
    inspection_stage     TEXT,
    action               TEXT,
    score                INTEGER CHECK (score >= 0),
    grade                TEXT,
    grade_date           DATE,
    in_scope             BOOLEAN NOT NULL,
    grade_score_mismatch BOOLEAN NOT NULL,
    n_violations         INTEGER NOT NULL,
    n_critical           INTEGER NOT NULL,
    UNIQUE (camis, inspection_date, inspection_type)
);


CREATE TABLE violations (
    violation_id          INTEGER PRIMARY KEY,
    inspection_id         INTEGER NOT NULL REFERENCES inspections (inspection_id),
    violation_code        TEXT NOT NULL,
    violation_description TEXT,
    critical_flag         TEXT,
    violation_category    TEXT,
    UNIQUE (inspection_id, violation_code)
);