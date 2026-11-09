/* soldiers_seed_with_tables.sql: SELF-CONTAINED. Creates database, all tables, B1 data, then adds the 30 practice soldiers and assignments. Run once on its own. */


DROP DATABASE IF EXISTS sms_202520487;
CREATE DATABASE sms_202521120;
USE sms_20241217;

CREATE TABLE ranks (
    rank_id     INT          NOT NULL,
    rank_name   VARCHAR(50)  NOT NULL,
    rank_level  INT          NOT NULL,
    CONSTRAINT pk_ranks PRIMARY KEY (rank_id),
    CONSTRAINT uq_ranks_name UNIQUE (rank_name),
    CONSTRAINT ck_ranks_level CHECK (rank_level BETWEEN 1 AND 6)
);

CREATE TABLE units (
    unit_id    INT          NOT NULL,
    unit_name  VARCHAR(80)  NOT NULL,
    location   VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_units PRIMARY KEY (unit_id),
    CONSTRAINT uq_units_name UNIQUE (unit_name)
);

CREATE TABLE missions (
    mission_id    INT          NOT NULL,
    mission_name  VARCHAR(100) NOT NULL,
    start_date    DATE         NOT NULL,
    end_date      DATE         NULL,
    CONSTRAINT pk_missions PRIMARY KEY (mission_id),
    CONSTRAINT uq_missions_name UNIQUE (mission_name),
    CONSTRAINT ck_missions_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE soldiers (
    soldier_id       INT          NOT NULL,
    service_number   VARCHAR(30)  NOT NULL,
    first_name       VARCHAR(50)  NOT NULL,
    last_name        VARCHAR(50)  NOT NULL,
    date_of_birth    DATE         NOT NULL,
    enlistment_date  DATE         NOT NULL,
    status           VARCHAR(10)  NOT NULL DEFAULT 'Active',
    rank_id          INT          NOT NULL,
    unit_id          INT          NOT NULL,
    CONSTRAINT pk_soldiers PRIMARY KEY (soldier_id),
    CONSTRAINT uq_soldiers_service UNIQUE (service_number),
    CONSTRAINT ck_soldiers_status CHECK (status IN ('Active', 'On Leave', 'Retired')),
    CONSTRAINT ck_soldiers_dates CHECK (enlistment_date > date_of_birth),
    CONSTRAINT fk_soldiers_rank FOREIGN KEY (rank_id) REFERENCES ranks (rank_id),
    CONSTRAINT fk_soldiers_unit FOREIGN KEY (unit_id) REFERENCES units (unit_id)
);

CREATE TABLE soldier_missions (
    soldier_id    INT          NOT NULL,
    mission_id    INT          NOT NULL,
    mission_role  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_soldier_missions PRIMARY KEY (soldier_id, mission_id),
    CONSTRAINT fk_sm_soldier FOREIGN KEY (soldier_id) REFERENCES soldiers (soldier_id),
    CONSTRAINT fk_sm_mission FOREIGN KEY (mission_id) REFERENCES missions (mission_id)
);

-- B1: reference data that the soldiers depend on
INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
    (1, 'Private', 1), (2, 'Corporal', 2), (3, 'Sergeant', 3),
    (4, 'Lieutenant', 4), (5, 'Captain', 5), (6, 'Major', 6);

INSERT INTO units (unit_id, unit_name, location) VALUES
    (1, 'Alpha Company',   'North Camp'),
    (2, 'Bravo Company',   'South Camp'),
    (3, 'Charlie Company', 'East Camp'),
    (4, 'Delta Company',   'West Camp'),
    (5, 'Signals Unit',    'Central Camp'),
    (6, 'Medical Unit',    'Central Camp');

INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
    (1, 'Exercise Falcon',    '2025-02-03', '2025-02-28'),
    (2, 'Flood Relief',       '2025-04-14', '2025-05-30'),
    (3, 'Border Patrol',      '2025-07-01', NULL),
    (4, 'Peace Support',      '2025-09-15', NULL),
    (5, 'Field Medical Camp', '2026-01-12', '2026-01-23');


INSERT INTO soldiers
    (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id)
VALUES
    ( 1, 'SVC-1001', 'Eric',      'Nkurunziza', '1990-03-12', '2010-06-01', 'Active',   5, 1),
    ( 2, 'SVC-1002', 'Jean',      'Mugisha',    '1995-07-23', '2015-02-10', 'Active',   3, 1),
    ( 3, 'SVC-1003', 'Alice',     'Uwimana',    '1998-11-05', '2018-09-15', 'Active',   2, 2),
    ( 4, 'SVC-1004', 'Patrick',   'Habimana',   '2000-01-30', '2020-03-01', 'Active',   1, 2),
    ( 5, 'SVC-1005', 'Grace',     'Mukamana',   '1992-05-17', '2012-08-20', 'On Leave', 4, 3),
    ( 6, 'SVC-1006', 'David',     'Ndayisaba',  '1988-09-09', '2008-01-12', 'Retired',  6, 4),
    ( 7, 'SVC-1007', 'Claudine',  'Ingabire',   '1999-02-14', '2019-07-01', 'Active',   1, 5),
    ( 8, 'SVC-1008', 'Emmanuel',  'Niyonzima',  '1996-12-01', '2016-05-05', 'Active',   2, 5),
    ( 9, 'SVC-1009', 'Sandrine',  'Uwase',      '1997-04-22', '2017-10-10', 'Active',   3, 6),
    (10, 'SVC-1010', 'Olivier',   'Bizimana',   '1994-08-08', '2014-03-03', 'Active',   3, 2),
    (11, 'SVC-1011', 'Diane',     'Mutesi',     '2001-06-19', '2021-01-18', 'Active',   1, 3),
    (12, 'SVC-1012', 'Samuel',    'Kamanzi',    '1993-10-27', '2013-11-11', 'On Leave', 2, 3),
    (13, 'SVC-1013', 'Josiane',   'Umutoni',    '1999-03-03', '2019-04-04', 'Active',   1, 4),
    (14, 'SVC-1014', 'Theogene',  'Rutayisire', '1991-01-15', '2011-02-02', 'Retired',  5, 6),
    (15, 'SVC-1015', 'Beatrice',  'Mukeshimana','1996-09-30', '2016-06-06', 'Active',   2, 2),
    (16, 'SVC-1016', 'Felix',     'Gasana',     '2000-07-07', '2020-08-08', 'Active',   1, 1),
    (17, 'SVC-1017', 'Aline',     'Iradukunda', '1997-11-11', '2017-12-12', 'Active',   3, 4),
    (18, 'SVC-1018', 'Moses',     'Mugisha',    '1989-02-25', '2009-05-15', 'Active',   4, 5),
    (19, 'SVC-1019', 'Vestine',   'Nyirahabimana','1998-06-16','2018-07-17','Active',   2, 6),
    (20, 'SVC-1020', 'Innocent',  'Hakizimana', '1995-12-20', '2015-09-09', 'Active',   3, 2),
    (21, 'SVC-1021', 'Chantal',   'Uwamahoro',  '2002-04-04', '2022-02-22', 'Active',   1, 3),
    (22, 'SVC-1022', 'Pascal',    'Ntaganda',   '1990-08-18', '2010-10-01', 'On Leave', 4, 1),
    (23, 'SVC-1023', 'Yvonne',    'Mukandayisenga','1999-01-09','2019-03-13','Active',  1, 5),
    (24, 'SVC-1024', 'Jacques',   'Ruzindana',  '1993-03-28', '2013-04-14', 'Active',   2, 4),
    (25, 'SVC-1025', 'Clemence',  'Uwingabire', '2001-10-10', '2021-11-21', 'Active',   1, 6),
    (26, 'SVC-1026', 'Anselme',   'Munyaneza',  '1987-05-05', '2007-06-06', 'Retired',  6, 2),
    (27, 'SVC-1027', 'Esperance', 'Niyomugabo', '1996-02-12', '2016-03-23', 'Active',   3, 3),
    (28, 'SVC-1028', 'Daniel',    'Sibomana',   '2000-09-21', '2020-10-30', 'Active',   2, 1),
    (29, 'SVC-1029', 'Marie',     'Nyiramana',  '1998-12-12', '2018-01-05', 'Active',   2, 5),
    (30, 'SVC-1030', 'Laurent',   'Karangwa',   '1992-07-01', '2012-09-19', 'Active',   4, 4);

INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
    ( 1, 1, 'Commander'),
    ( 1, 3, 'Commander'),
    ( 2, 1, 'Sergeant Major'),
    ( 2, 3, 'Patrol Leader'),
    ( 3, 2, 'Logistics'),
    ( 4, 1, 'Rifleman'),
    ( 4, 3, 'Rifleman'),
    ( 5, 2, 'Team Leader'),
    ( 5, 4, 'Observer'),
    ( 6, 1, 'Commander'),
    ( 8, 4, 'Radio Operator'),
    ( 9, 5, 'Medic'),
    (10, 2, 'Driver'),
    (10, 3, 'Scout'),
    (11, 3, 'Rifleman'),
    (12, 2, 'Engineer'),
    (13, 4, 'Rifleman'),
    (15, 2, 'Logistics'),
    (16, 1, 'Rifleman'),
    (17, 4, 'Signaller'),
    (18, 4, 'Communications Officer'),
    (19, 5, 'Nurse'),
    (20, 3, 'Patrol Leader'),
    (21, 2, 'Rifleman'),
    (22, 1, 'Platoon Leader'),
    (23, 4, 'Signaller'),
    (24, 4, 'Driver'),
    (26, 1, 'Advisor'),
    (27, 5, 'Medical Assistant'),
    (28, 1, 'Rifleman'),
    (29, 4, 'Radio Operator'),
    (30, 3, 'Squad Leader');

-- Quick checks after running:
-- SELECT COUNT(*) FROM soldiers;          -- expect 30
-- SELECT COUNT(*) FROM soldier_missions;  -- expect 32
-- Soldiers 7, 14 and 25 have no mission, so they appear in C9.

SELECT COUNT(*) AS soldiers_loaded FROM soldiers;
SELECT COUNT(*) AS assignments_loaded FROM soldier_missions;
