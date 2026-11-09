# Solider-Management-SQL
SQL Database Assignment-Solider Management System

Soldier Management System (SMS): Army Training School Database
1. Project Title
Soldier Management System (SMS)
Item	Detail
Course	SQL Databases (Year 2)
Institution	Kigali Independent University (ULK)
Instructor	Eric Maniraguha
Group size	Two students
Category	Military training administration (fictional data)
Database system	MySQL 8.0.16 or newer
Development interface	MySQL command line / MySQL Workbench
Database name	sms_202520487_sms_2025521120_sms_202412174
GitHub username	Gibsonprosper200415
Repository	Solider Management System
2. Group Members
Member name	Student number	Role
John Prosper  Gibson	202520487	Leader
Shem Mongar	202412174	Member
	          202521120   	Member
		
		
3. Introduction
This academic project implements a relational database for an army training school. It records soldiers, their ranks, the units they belong to, and the missions they serve on. The design uses five related tables with constraints that keep the data consistent.
Scope and Data Limitations
•	All data is fictional. Names, service numbers, dates and missions are invented for coursework.
•	The model covers five entities: ranks, units, missions, soldiers and soldier-mission assignments.
•	Each soldier holds exactly one rank, belongs to exactly one unit, and has one role per mission.
•	Training records, equipment, salaries, medical data and security clearances are outside the scope.
•	Rows are not deleted in this prototype, so no delete rules beyond the default restriction are defined.
4. Problem Statement
A training school that tracks soldiers in a flat list risks inconsistent rank names, soldiers assigned to units that do not exist, duplicate mission assignments, and impossible dates (for example, enlistment before birth). This project separates ranks, units, missions and soldiers into related tables and uses primary keys, foreign keys, UNIQUE, NOT NULL and CHECK constraints to prevent those errors.
5. Objectives
1.	Design an ER diagram with five tables, showing primary keys, foreign keys and relationship types.
2.	Create the tables with the exact names and columns required, enforcing every business rule in the database.
3.	Load the reference data and a 30-soldier seed file, then add three new soldiers.
4.	Answer ten reporting questions with filtering, IN, BETWEEN, joins, LEFT JOIN, grouping and sorting.
5.	Compare query plans with EXPLAIN before and after creating an index.
6.	Create and query a reporting view that combines soldier, rank and unit data.
7.	Comment every statement and be ready to explain and modify any query in the oral defence.
6. Research and Key Concepts
Concept	Application in this project
Relational design	Separate tables for ranks, units, missions and soldiers reduce repeated data.
Primary keys	Every table has one. soldier_missions uses a composite key (soldier_id, mission_id).
Foreign keys	Soldiers must reference an existing rank and unit; assignments must reference an existing soldier and mission.
Integrity constraints	NOT NULL, UNIQUE, CHECK and DEFAULT enforce required fields, unique names, valid ranges and the default status.
Many-to-many relationship	Soldiers and missions are linked through the junction table soldier_missions.
Joins	INNER JOIN combines related tables; LEFT JOIN finds missing matches and keeps empty groups.
Indexing	A B-tree index on last_name turns a full table scan into an index lookup.
Views	v_soldier_profile stores a reusable joined query.
7. Technical Approach
The work follows this order: paper ER design, table creation, data insertion, retrieval queries, then index and view creation.
Personal Values
Each student's questions depend on their student number.
Value	Formula	Example (2401237)
P	Last digit of the student number	7
U	((last two digits + 6) mod 6) + 1	2
M	((P + 5) mod 5) + 1	3
Soldier 32 rank_id	((P + 6) mod 6) + 1	2
Soldier 33 unit_id	((U + 6) mod 6) + 1	3
Queries
The ten retrieval queries (C1 to C10) demonstrate:
•	ORDER BY ... DESC with LIMIT, and a subquery to re-sort the same ten rows
•	IN and BETWEEN filters
•	Multi-table INNER JOIN with sorting by rank level then last name
•	LEFT JOIN ... IS NULL to find soldiers with no mission
•	GROUP BY with COUNT to rank units by size
Indexing
The index idx_soldiers_last_name is created on soldiers(last_name). EXPLAIN is run on a search for last name Mugisha before and after. The expected change is type: ALL, key: NULL becoming type: ref, key: idx_soldiers_last_name. The observed output should be recorded in the evidence section.
Reporting View
v_soldier_profile exposes soldier_id, full_name, rank_name, unit_name, location and status, building full_name from first and last name.
8. Database Design and Diagrams
Tables
Table	Purpose
ranks	Rank names and levels (1 to 6)
units	Unit names and camp locations
missions	Mission names with start and optional end dates
soldiers	Soldier personal data, status, rank and unit
soldier_missions	Links soldiers to missions with a role
Relationships
•	One rank can be held by many soldiers (1:M).
•	One unit has many soldiers (1:M).
•	A soldier can serve on many missions, and a mission has many soldiers (M:N), resolved by soldier_missions.
Entity Relationship Diagram
erDiagram
    ranks ||--o{ soldiers : "held by"
    units ||--o{ soldiers : "contains"
    soldiers ||--o{ soldier_missions : "serves"
    missions ||--o{ soldier_missions : "includes"

    ranks {
        int rank_id PK
        varchar rank_name UK
        int rank_level
    }
    units {
        int unit_id PK
        varchar unit_name UK
        varchar location
    }
    missions {
        int mission_id PK
        varchar mission_name UK
        date start_date
        date end_date
    }
    soldiers {
        int soldier_id PK
        varchar service_number UK
        varchar first_name
        varchar last_name
        date date_of_birth
        date enlistment_date
        varchar status
        int rank_id FK
        int unit_id FK
    }
    soldier_missions {
        int soldier_id PK, FK
        int mission_id PK, FK
        varchar mission_role
    }
The hand-drawn paper ER diagram should be photographed and stored in diagrams/.
Integrity Rules
Table	Rules enforced
ranks	Primary key; name required and unique; level between 1 and 6
units	Primary key; name required and unique; location required
missions	Primary key; name required and unique; end date may be empty (ongoing); end date not before start date
soldiers	Auto-numbered primary key; unique service number; all columns required; status limited to Active, On Leave or Retired with default Active; enlistment after birth; rank and unit must exist
soldier_missions	Composite primary key prevents duplicate assignment; soldier and mission must exist; role required
Reference Dataset
Table	Records
ranks	6
units	6
missions	5 (two ongoing: Border Patrol, Peace Support)
soldiers	33 (30 from the teacher's seed file plus 3 added)
9. SQL Implementation
Implementation file: sql/sms_<student_number>.sql
The first statement of the file is required by the assignment:
SELECT DATABASE(), CURRENT_USER(), NOW();
Run Order
1.	Start MySQL 8.0.16 or newer (older versions ignore CHECK constraints).
2.	Place soldiers_seed.sql in the same folder and start the client from that folder.
3.	Run the file in order: 
o	Part A: create the five tables
o	Part B: insert ranks, units and missions; run the seed file; insert soldiers 31 to 33 and their assignments
o	Part C: run queries C1 to C10
o	Part D: run EXPLAIN, create the index, run EXPLAIN again, create the view, query the view
4.	Record the number of rows each SELECT returns in its comment.
Execution Notes
•	The script starts with DROP DATABASE IF EXISTS, so it is meant for a clean rebuild of the student's own database only.
•	In MySQL Workbench, open soldiers_seed.sql and execute it instead of using SOURCE.
•	Every statement carries a comment in this format:
-- Does: <what the statement does in simple words>
-- Rows returned: <number for SELECT statements>
10. Practical Demonstration and Results
Demonstration	Result and evidence
Table creation	Five tables created; SHOW TABLES screenshot: <pending>
Reference data	6 ranks, 6 units, 5 missions inserted: <pending>
Seed file	30 soldiers loaded: <pending>
New soldiers	Soldiers 31, 32, 33 inserted; 31 and 32 on mission M; 33 on none: <pending>
Queries C1 to C10	Row counts recorded in comments: <pending>
Index comparison	Before: type = ALL, key = NULL. After: type = ref, key = idx_soldiers_last_name: <pending, paste your actual EXPLAIN output>
View	v_soldier_profile created and queried for unit U: <pending>
Validation and Evidence Limits
•	Row counts and EXPLAIN results depend on the instructor's seed data and must come from the student's own run.
•	On a very small table, MySQL may still choose a full scan, so the actual plan output must be reported as observed.
•	Constraint rejection tests (for example, an invalid status or an end date before the start date) can be added as extra evidence.
11. Real-World Applications
With verified data and proper access control, a design like this could support personnel records, unit strength reports, mission rosters, and identifying unassigned personnel. These are potential applications only. This prototype uses fictional data and is not a deployed system.
12. Challenges and Recommendations
Challenge identified	Response or recommendation
Personal values differ per student	Compute P, U, M first and keep a table of them in the file header.
Ongoing missions have no end date	Store NULL instead of the text "none" and allow it in the CHECK.
Soldiers with no mission must still appear	Use LEFT JOIN with IS NULL, not INNER JOIN.
Units with zero soldiers must still be counted	Use LEFT JOIN from units before grouping.
CHECK constraints ignored on old MySQL	Use MySQL 8.0.16 or newer.
Re-sorting a limited result	Wrap the LIMIT query in a subquery, then apply the second ORDER BY.
13. Future Improvements
Possible extensions, not implemented features:
•	Training courses and certifications per soldier
•	Rank promotion history with effective dates
•	Role-based access using database users and privileges
•	Audit logging for changes to soldier records
•	A reporting dashboard built on the view
14. References
•	MySQL 8.0 Reference Manual: CREATE TABLE and CHECK constraints
•	MySQL 8.0 Reference Manual: EXPLAIN output format
•	MySQL 8.0 Reference Manual: CREATE INDEX
•	MySQL 8.0 Reference Manual: CREATE VIEW
•	Course material: SQL Databases, Eric Maniraguha, ULK
15. Presentation Link (Google Drive)
https://forms.gle/roUHktP6oiR2oFSu5 
Presentation: Monday, in front of the class.
16. Group Contributions
Member	Assigned responsibility	Expected deliverable
Prosper Gibson	<e.g. Parts A and B, ER diagram, README>	Table scripts, inserts, documentation
<Partner name>	<e.g. Parts C and D, comments, presentation>	Queries, index, view, slides
Final Submission Checklist
•	[ ] Paper ER diagram handed in
•	[ ] Each member's sms_<student_number>.sql uploaded to the repository
•	[ ] File starts with SELECT DATABASE(), CURRENT_USER(), NOW();
•	[ ] Every statement commented with Does and Rows returned
•	[ ] Personal values P, U, M checked for each student
•	[ ] Index EXPLAIN before and after captured
•	[ ] README completed and placeholders replaced
•	[ ] Presentation uploaded and linked in Section 15
•	[ ] Submission Google Form sent before the deadline
•	[ ] Both members prepared for the oral defence
Repository Files
<repository-name>/
├── README.md
├── sql/
│   ├── sms_<student_number_1>.sql
│   └── sms_<student_number_2>.sql
├── seed/
│   └── soldiers_seed.sql
├── diagrams/
│   └── er_diagram (hand-drawn photo and exported image)
└── docs/
    └── screenshots/

