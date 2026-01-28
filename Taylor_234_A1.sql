-- Taylor Brackett - SQL File - CSDS 234


-- Optional PostgreSQL starter schema for the structured CSVs
-- Professor said to use sample schema and csvs provided under module
-- Primary keys present for each table
-- There is at least one foreign key and at least one constraint (I added a few of my own constaints)

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name TEXT NOT NULL,
  age INT CHECK (age > 0),
  gender TEXT,
  city TEXT
);

CREATE TABLE visits (
  visit_id INT PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  visit_date DATE NOT NULL,
  provider TEXT
);

CREATE TABLE diagnoses (
  diag_id INT PRIMARY KEY,
  visit_id INT REFERENCES visits(visit_id),
  code TEXT NOT NULL,
  description TEXT
);

CREATE TABLE medications (
  med_id INT PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  drug_name TEXT NOT NULL,
  dose TEXT,
  start_date DATE
);

CREATE TABLE lab_results (
  lab_id INT PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  test_name TEXT NOT NULL,
  value DOUBLE PRECISION,
  unit TEXT,
  test_date DATE
); 

-- INSERT STATEMENTS (3-5 per table) - new tuples for each CSV file
-- User inserts 
INSERT INTO users (user_id, name, age, gender, city) VALUES
(11, 'Bella Becker', 20, 'F', 'Shaker Heights'),
(12, 'Matt Brown', 25, 'M', 'Cleveland Heights'),
(13, 'Ella Lee', 30, 'F', 'Beachwood'),
(14, 'Lucas Adams', 20, 'M', 'Cleveland');

-- Visit inserts
INSERT INTO visits (visit_id, user_id, visit_date, provider) VALUES
(113, 11, '2026-01-02','Dr. Smith'),
(114, 12, '2026-01-03', 'Dr. Patel'),
(115, 13, '2026-02-01', 'Dr. Gomez'),
(116, 14, '2026-01-24', 'Dr. Ahmed');

-- Diagnoses inserts
INSERT INTO diagnoses (diag_id, visit_id, code, description) VALUES
(1013, 113, 'R53', 'Fatigue'),
(1014, 114, 'R53', 'Fatigue'),
(1015, 115, 'R07', 'Chest pain'),
(1016, 116, 'F41', 'Anxiety');

-- Lab results inserts
INSERT INTO lab_results (lab_id, user_id, test_name, value, unit, test_date) VALUES
(3014, 11, 'SleepHours', 5.0, 'hours', '2026-01-04'),
(3015, 12, 'SleepHours', 6.0, 'hours', '2026-01-05'),
(3016, 13, 'BloodPressureSys', 146.0, 'mmHg', '2026-02-01');

-- Medications inserts
INSERT INTO medications (med_id, user_id, drug_name, dose, start_date) VALUES
(2011, 11, 'Melatonin', '3 mg', '2026-01-05'),
(2012, 12, 'Melatonin', '4 mg', '2026-01-06'),
(2013, 13, 'Ibuprofen', '300 mg', '2026-02-02');

-- Select statements
SELECT * FROM users;
SELECT * FROM visits;
SELECT * FROM diagnoses;
SELECT * FROM lab_results;
SELECT * FROM medications;



