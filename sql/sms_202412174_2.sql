INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
    (1, 'Private',    1),
    (2, 'Corporal',   2),
    (3, 'Sergeant',   3),
    (4, 'Lieutenant', 4),
    (5, 'Captain',    5),
    (6, 'Major',      6);

-- Does: Inserts the 6 units given in the question.
-- Rows returned: not a SELECT (6 rows inserted)
INSERT INTO units (unit_id, unit_name, location) VALUES
    (1, 'Alpha Company',   'North Camp'),
    (2, 'Bravo Company',   'South Camp'),
    (3, 'Charlie Company', 'East Camp'),
    (4, 'Delta Company',   'West Camp'),
    (5, 'Signals Unit',    'Central Camp'),
    (6, 'Medical Unit',    'Central Camp');

-- Does: Inserts the 5 missions. Ongoing missions (3 and 4) get NULL as end date because "none" means no end date.
-- Rows returned: not a SELECT (5 rows inserted)
INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
    (1, 'Exercise Falcon',     '2025-02-03', '2025-02-28'),
    (2, 'Flood Relief',        '2025-04-14', '2025-05-30'),
    (3, 'Border Patrol',       '2025-07-01', NULL),
    (4, 'Peace Support',       '2025-09-15', NULL),
    (5, 'Field Medical Camp',  '2026-01-12', '2026-01-23');

-- B2 ---------------------------------------------------------------
-- Does: Runs my teacher's file that adds 30 soldiers and their mission assignments.
-- Rows returned: not a SELECT (30 soldiers added)
-- NOTE: run this from the mysql command line. In MySQL Workbench, open soldiers_seed.sql and execute it instead.
SOURCE soldiers_seed.sql;

-- B3 ---------------------------------------------------------------
-- Does: Inserts soldier 31 (me), soldier 32 and soldier 33 (invented). Service numbers use my student number.
--       Soldier 32 rank = ((P+6) mod 6)+1 = 2 ; Soldier 33 unit = ((U+6) mod 6)+1 = 3. All three are Active.
-- Rows returned: not a SELECT (3 rows inserted)
INSERT INTO soldiers
    (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id)
VALUES
    (31, 'ST-2401237',   'Prosper', 'Gibson',  '2004-05-14', '2023-09-01', 'Active', 1, 2),
    (32, 'ST-2401237-2', 'Jean',    'Habimana','2002-11-03', '2022-03-15', 'Active', 2, 2),
    (33, 'ST-2401237-3', 'Aline',   'Uwase',   '2001-07-21', '2021-06-10', 'Active', 2, 3);

-- Does: Assigns soldiers 31 and 32 to mission M = 3 (Border Patrol). Soldier 33 is left out on purpose.
-- Rows returned: not a SELECT (2 rows inserted)
INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
    (31, 3, 'Radio Operator'),
    (32, 3, 'Patrol Leader');


/* =====================================================================
   PART C: RETRIEVE THE DATA (25 marks)
   ===================================================================== */

-- C1 ---------------------------------------------------------------
-- Does: Shows the last 10 soldiers added, newest (highest ID) first.
-- Rows returned: 10
SELECT *
FROM soldiers
ORDER BY soldier_id DESC
LIMIT 10;

-- C2 ---------------------------------------------------------------
-- Does: Takes the same last 10 soldiers (inner query) and re-sorts them from lowest ID to highest ID.
-- Rows returned: 10
SELECT *
FROM (
    SELECT *
    FROM soldiers
    ORDER BY soldier_id DESC
    LIMIT 10
) AS last_ten
ORDER BY soldier_id ASC;

-- C3 ---------------------------------------------------------------
-- Does: Finds the soldiers whose ID is 10, 15 or 20 using IN.
-- Rows returned: 3
SELECT *
FROM soldiers
WHERE soldier_id IN (10, 15, 20);

-- C4 ---------------------------------------------------------------
-- Does: Finds soldiers whose ID is 10+P, 15+P or 20+P using IN. With P = 7 these are 17, 22 and 27.
-- Rows returned: 3
SELECT *
FROM soldiers
WHERE soldier_id IN (10 + 7, 15 + 7, 20 + 7);

-- C5 ---------------------------------------------------------------
-- Does: Shows Active soldiers whose ID is between 10 and 20 (both included) using BETWEEN.
-- Rows returned: ___ (fill in after running; depends on the seed file)
SELECT *
FROM soldiers
WHERE status = 'Active'
  AND soldier_id BETWEEN 10 AND 20;

-- C6 ---------------------------------------------------------------
-- Does: Shows each soldier's ID and name with their rank name, highest rank level first, then by last name.
-- Rows returned: 33
SELECT s.soldier_id,
       s.first_name,
       s.last_name,
       r.rank_name
FROM soldiers AS s
INNER JOIN ranks AS r ON r.rank_id = s.rank_id
ORDER BY r.rank_level DESC, s.last_name ASC;

-- C7 ---------------------------------------------------------------
-- Does: Shows Active soldiers in unit U = 2 with first name, last name, rank name, unit name and location.
-- Rows returned: ___ (fill in after running)
SELECT s.first_name,
       s.last_name,
       r.rank_name,
       u.unit_name,
       u.location
FROM soldiers AS s
INNER JOIN ranks AS r ON r.rank_id = s.rank_id
INNER JOIN units AS u ON u.unit_id = s.unit_id
WHERE s.status = 'Active'
  AND s.unit_id = 2;

-- C8 ---------------------------------------------------------------
-- Does: Shows everyone on mission M = 3 with mission name, soldier name, role and unit name.
-- Rows returned: ___ (fill in after running)
SELECT m.mission_name,
       CONCAT(s.first_name, ' ', s.last_name) AS soldier_name,
       sm.mission_role,
       u.unit_name
FROM soldier_missions AS sm
INNER JOIN missions AS m ON m.mission_id = sm.mission_id
INNER JOIN soldiers AS s ON s.soldier_id = sm.soldier_id
INNER JOIN units    AS u ON u.unit_id    = s.unit_id
WHERE sm.mission_id = 3;

-- C9 ---------------------------------------------------------------
-- Does: Finds soldiers who were never assigned to any mission (LEFT JOIN and keep rows with no match).
-- Rows returned: ___ (fill in after running; soldier 33 must appear)
SELECT s.soldier_id,
       s.first_name,
       s.last_name
FROM soldiers AS s
LEFT JOIN soldier_missions AS sm ON sm.soldier_id = s.soldier_id
WHERE sm.soldier_id IS NULL;

-- C10 --------------------------------------------------------------
-- Does: Shows each unit's name and how many soldiers it has, largest unit first. LEFT JOIN keeps empty units too.
-- Rows returned: 6
SELECT u.unit_name,
       COUNT(s.soldier_id) AS number_of_soldiers
FROM units AS u
LEFT JOIN soldiers AS s ON s.unit_id = u.unit_id
GROUP BY u.unit_id, u.unit_name
ORDER BY number_of_soldiers DESC;


/* =====================================================================
   PART D: CREATE AN INDEX AND A VIEW (10 marks)
   ===================================================================== */

-- D1 (a) -----------------------------------------------------------
-- Does: Shows how MySQL searches for last name Mugisha BEFORE any index exists.
-- Rows returned: 1 (the EXPLAIN plan row)
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';

-- D1 (b) -----------------------------------------------------------
-- Does: Creates an index on last_name so MySQL can jump straight to matching names.
-- Rows returned: not a SELECT
CREATE INDEX idx_soldiers_last_name ON soldiers (last_name);

-- D1 (c) -----------------------------------------------------------
-- Does: Runs the same EXPLAIN again AFTER creating the index.
-- Rows returned: 1 (the EXPLAIN plan row)
-- WHAT CHANGED: Before the index, type = ALL (full table scan) and key = NULL (no index used).
--               After the index, type = ref (direct index lookup) and key = idx_soldiers_last_name.
--               MySQL now reads only the matching rows instead of every row.
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';

-- D2 ---------------------------------------------------------------
-- Does: Creates a view that joins soldiers, ranks and units and builds full_name from first and last name.
-- Rows returned: not a SELECT
CREATE VIEW v_soldier_profile AS
SELECT s.soldier_id,
       CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       r.rank_name,
       u.unit_name,
       u.location,
       s.status
FROM soldiers AS s
INNER JOIN ranks AS r ON r.rank_id = s.rank_id
INNER JOIN units AS u ON u.unit_id = s.unit_id;

-- D3 ---------------------------------------------------------------
-- Does: Uses my view to show every soldier in unit U = 2 (Bravo Company), ordered by full name.
-- Rows returned: ___ (fill in after running)
SELECT *
FROM v_soldier_profile
WHERE unit_name = 'Bravo Company'
ORDER BY full_name;
