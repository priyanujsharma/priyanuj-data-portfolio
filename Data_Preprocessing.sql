-- ===============================================================
-- Step 1: Initial Data Exploration: Understanding Table Structure
-- ===============================================================
-- Actions:
-- 	-Review schema and check for:
-- 		- Inconsistent naming or casing
-- 		- Unexpected data types 
-- 		- Placeholder or missing values
-- ===============================================================

DESCRIBE dropoutratio;
SELECT * FROM dropoutratio;
DESCRIBE grossenrollmentratio;
SELECT * FROM grossenrollmentratio;
DESCRIBE schoolswithboystoilet;
SELECT * FROM schoolswithboystoilet;
DESCRIBE schoolswithcomps;
SELECT * FROM schoolswithcomps;
DESCRIBE schoolswithelectric;
SELECT * FROM schoolswithelectric;
DESCRIBE schoolswithgirlstoilet;
SELECT * FROM schoolswithgirlstoilet;
DESCRIBE schoolswithwater;
SELECT * FROM schoolswithwater;

-- ================================================================
-- Step 2: Data Standardization
-- ================================================================
-- Actions: 
-- 	-Standardize column names
-- 	-Replacing placeholder values like 'NR', 'NA' or '' with NULLs
-- 	-Convert string columns to proper numeric types
--  -Standardize key strings across tables
-- ================================================================

UPDATE dropoutratio SET `Upper Primary_Boys` = NULL WHERE TRIM(`Upper Primary_Boys`) IN ('Uppe_r_Primary','NR', 'NA', '');
UPDATE dropoutratio SET `HrSecondary_Girls` = NULL WHERE TRIM(`HrSecondary_Girls`) IN ('NR', 'NA', '');

-- Rename and retype columns to fix spacing and format issues
ALTER TABLE dropoutratio CHANGE COLUMN `Upper Primary_Boys` Upper_Primary_Boys DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `Upper Primary_Girls` Upper_Primary_Girls DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `Upper Primary_Total` Upper_Primary_Total DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `Secondary _Boys` Secondary_Boys DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `Secondary _Girls` Secondary_Girls DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `Secondary _Total` Secondary_Total DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `HrSecondary_Girls` HrSecondary_Girls DOUBLE;
ALTER TABLE dropoutratio CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE dropoutratio CHANGE COLUMN `year` Year VARCHAR(10);

-- Repeat standardization for all other tables
ALTER TABLE grossenrollmentratio CHANGE COLUMN `Higher_Secondary_Boys` HrSecondary_Boys DOUBLE;
ALTER TABLE grossenrollmentratio CHANGE COLUMN `Higher_Secondary_Girls` HrSecondary_Girls DOUBLE;
ALTER TABLE grossenrollmentratio CHANGE COLUMN `Higher_Secondary_Total` HrSecondary_Total DOUBLE;
ALTER TABLE grossenrollmentratio CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE grossenrollmentratio CHANGE COLUMN `year` Year VARCHAR(10);

ALTER TABLE schoolswithboystoilet CHANGE COLUMN `Sec_with_HrSec.` Sec_with_HrSec DOUBLE;
ALTER TABLE schoolswithboystoilet CHANGE COLUMN `All Schools` All_Schools DOUBLE;
ALTER TABLE schoolswithboystoilet CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE schoolswithboystoilet CHANGE COLUMN `year` Year VARCHAR(10);

ALTER TABLE schoolswithcomps CHANGE COLUMN `Sec_with_HrSec.` Sec_with_HrSec DOUBLE;
ALTER TABLE schoolswithcomps CHANGE COLUMN `All Schools` All_Schools DOUBLE;
ALTER TABLE schoolswithcomps CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE schoolswithcomps CHANGE COLUMN `year` Year VARCHAR(10);

ALTER TABLE schoolswithelectric CHANGE COLUMN `Sec_with_HrSec.` Sec_with_HrSec DOUBLE;
ALTER TABLE schoolswithelectric CHANGE COLUMN `All Schools` All_Schools DOUBLE;
ALTER TABLE schoolswithelectric CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE schoolswithelectric CHANGE COLUMN `year` Year VARCHAR(10);

ALTER TABLE schoolswithgirlstoilet CHANGE COLUMN `Sec_with_HrSec.` Sec_with_HrSec DOUBLE;
ALTER TABLE schoolswithgirlstoilet CHANGE COLUMN `All Schools` All_Schools DOUBLE;
ALTER TABLE schoolswithgirlstoilet CHANGE COLUMN `State_UT` State_UT VARCHAR(100);
ALTER TABLE schoolswithgirlstoilet CHANGE COLUMN `year` Year VARCHAR(10);

ALTER TABLE schoolswithwater CHANGE COLUMN `Sec_with_HrSec.` Sec_with_HrSec DOUBLE;
ALTER TABLE schoolswithwater CHANGE COLUMN `All Schools` All_Schools DOUBLE;
ALTER TABLE schoolswithwater CHANGE COLUMN `State/UT` State_UT VARCHAR(100);
ALTER TABLE schoolswithwater CHANGE COLUMN `Year` Year VARCHAR(10);

-- Standardization of state names
CREATE TABLE state_name_map (
    original_name VARCHAR(100),
    standard_name VARCHAR(100)
);
INSERT INTO state_name_map (original_name, standard_name) VALUES
('A & N Islands', 'Andaman & Nicobar Islands'),
('Arunachal  Pradesh', 'Arunachal Pradesh'),
('Tamil  Nadu', 'Tamil Nadu'),
('MADHYA PRADESH', 'Madhya Pradesh'),
('Jammu And Kashmir', 'Jammu & Kashmir'),
('Pondicherry', 'Puducherry'),
('Uttaranchal', 'Uttarakhand'),
('Orissa', 'Odisha'),
('Dadra & Nagar Haveli', 'Dadra and Nagar Haveli'),
('Daman & Diu', 'Daman and Diu');

UPDATE dropoutratio dr
JOIN state_name_map s ON dr.State_UT = s.original_name
SET dr.State_UT = s.standard_name;

UPDATE grossenrollmentratio g
JOIN state_name_map s ON g.State_UT = s.original_name
SET g.State_UT = s.standard_name;

UPDATE schoolswithboystoilet bt
JOIN state_name_map s ON bt.State_UT = s.original_name
SET bt.State_UT = s.standard_name;

UPDATE schoolswithcomps c
JOIN state_name_map s ON c.State_UT = s.original_name
SET c.State_UT = s.standard_name;

UPDATE schoolswithelectric e
JOIN state_name_map s ON e.State_UT = s.original_name
SET e.State_UT = s.standard_name;

UPDATE schoolswithgirlstoilet gt
JOIN state_name_map s ON gt.State_UT = s.original_name
SET gt.State_UT = s.standard_name;

UPDATE schoolswithwater w
JOIN state_name_map s ON w.State_UT = s.original_name
SET w.State_UT = s.standard_name;

-- ================================================================
-- Step 3: Checking for Duplicates
-- ================================================================

SELECT State_UT, Year, COUNT(*) as count FROM dropoutratio GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM grossenrolmentratio GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM schoolswithboystoilet GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM schoolswithcomps GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM schoolswithelectric GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM schoolswithgirlstoilet GROUP BY State_UT, Year HAVING COUNT(*) > 1;
SELECT State_UT, Year, COUNT(*) as count FROM schoolswithwater GROUP BY State_UT, Year HAVING COUNT(*) > 1;

-- No duplicates found based on State_UT and Year

-- ================================================================
-- Step 4: NULL Value Checks and Imputation
-- ================================================================

-- Checking for NULLs
SELECT
  SUM(CASE WHEN `Primary_Boys` IS NULL THEN 1 ELSE 0 END) AS Primary_Boys_NULLs,
  SUM(CASE WHEN `Primary_Girls` IS NULL THEN 1 ELSE 0 END) AS Primary_Girls_NULLs,
  SUM(CASE WHEN `Primary_Total` IS NULL THEN 1 ELSE 0 END) AS Primary_Total_NULLs,
  SUM(CASE WHEN `Upper_Primary_Boys` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Boys_NULLs,
  SUM(CASE WHEN `Upper_Primary_Girls` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Girls_NULLs,
  SUM(CASE WHEN `Upper_Primary_Total` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Total_NULLs,
  SUM(CASE WHEN `Secondary_Boys` IS NULL THEN 1 ELSE 0 END) AS Secondary_Boys_NULLs,
  SUM(CASE WHEN `Secondary_Girls` IS NULL THEN 1 ELSE 0 END) AS Secondary_Girls_NULLs,
  SUM(CASE WHEN `Secondary_Total` IS NULL THEN 1 ELSE 0 END) AS Secondary_Total_NULLs,
  SUM(CASE WHEN `HrSecondary_Boys` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Boys_NULLs,
  SUM(CASE WHEN `HrSecondary_Girls` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Girls_NULLs,
  SUM(CASE WHEN `HrSecondary_Total` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Total_NULLs
FROM dropoutratio;


SELECT
  SUM(CASE WHEN `Primary_Boys` IS NULL THEN 1 ELSE 0 END) AS Primary_Boys_NULLs,
  SUM(CASE WHEN `Primary_Girls` IS NULL THEN 1 ELSE 0 END) AS Primary_Girls_NULLs,
  SUM(CASE WHEN `Primary_Total` IS NULL THEN 1 ELSE 0 END) AS Primary_Total_NULLs,
  SUM(CASE WHEN `Upper_Primary_Boys` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Boys_NULLs,
  SUM(CASE WHEN `Upper_Primary_Girls` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Girls_NULLs,
  SUM(CASE WHEN `Upper_Primary_Total` IS NULL THEN 1 ELSE 0 END) AS Upper_Primary_Total_NULLs,
  SUM(CASE WHEN `Secondary_Boys` IS NULL THEN 1 ELSE 0 END) AS Secondary_Boys_NULLs,
  SUM(CASE WHEN `Secondary_Girls` IS NULL THEN 1 ELSE 0 END) AS Secondary_Girls_NULLs,
  SUM(CASE WHEN `Secondary_Total` IS NULL THEN 1 ELSE 0 END) AS Secondary_Total_NULLs,
  SUM(CASE WHEN `HrSecondary_Boys` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Boys_NULLs,
  SUM(CASE WHEN `HrSecondary_Girls` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Girls_NULLs,
  SUM(CASE WHEN `HrSecondary_Total` IS NULL THEN 1 ELSE 0 END) AS HrSecondary_Total_NULLs
FROM grossenrollmentratio;


SELECT
  SUM(CASE WHEN `Primary_Only` IS NULL THEN 1 ELSE 0 END) AS Primary_Only_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_HrSec_NULLs,
  SUM(CASE WHEN `U_Primary_Only` IS NULL THEN 1 ELSE 0 END) AS U_Primary_Only_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_HrSec_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_NULLs,
  SUM(CASE WHEN `Sec_Only` IS NULL THEN 1 ELSE 0 END) AS Sec_Only_NULLs,
  SUM(CASE WHEN `Sec_with_HrSec` IS NULL THEN 1 ELSE 0 END) AS Sec_with_HrSec_NULLs,
  SUM(CASE WHEN `HrSec_Only` IS NULL THEN 1 ELSE 0 END) AS HrSec_Only_NULLs,
  SUM(CASE WHEN `All_Schools` IS NULL THEN 1 ELSE 0 END) AS All_Schools_NULLs
FROM schoolswithboystoilet;
	
SELECT
  SUM(CASE WHEN `Primary_Only` IS NULL THEN 1 ELSE 0 END) AS Primary_Only_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_HrSec_NULLs,
  SUM(CASE WHEN `U_Primary_Only` IS NULL THEN 1 ELSE 0 END) AS U_Primary_Only_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_HrSec_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_NULLs,
  SUM(CASE WHEN `Sec_Only` IS NULL THEN 1 ELSE 0 END) AS Sec_Only_NULLs,
  SUM(CASE WHEN `Sec_with_HrSec` IS NULL THEN 1 ELSE 0 END) AS Sec_with_HrSec_NULLs,
  SUM(CASE WHEN `HrSec_Only` IS NULL THEN 1 ELSE 0 END) AS HrSec_Only_NULLs,
  SUM(CASE WHEN `All_Schools` IS NULL THEN 1 ELSE 0 END) AS All_Schools_NULLs
FROM schoolswithcomps;

SELECT
  SUM(CASE WHEN `Primary_Only` IS NULL THEN 1 ELSE 0 END) AS Primary_Only_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_HrSec_NULLs,
  SUM(CASE WHEN `U_Primary_Only` IS NULL THEN 1 ELSE 0 END) AS U_Primary_Only_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_HrSec_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_NULLs,
  SUM(CASE WHEN `Sec_Only` IS NULL THEN 1 ELSE 0 END) AS Sec_Only_NULLs,
  SUM(CASE WHEN `Sec_with_HrSec` IS NULL THEN 1 ELSE 0 END) AS Sec_with_HrSec_NULLs,
  SUM(CASE WHEN `HrSec_Only` IS NULL THEN 1 ELSE 0 END) AS HrSec_Only_NULLs,
  SUM(CASE WHEN `All_Schools` IS NULL THEN 1 ELSE 0 END) AS All_Schools_NULLs
FROM schoolswithelectric;

SELECT
  SUM(CASE WHEN `Primary_Only` IS NULL THEN 1 ELSE 0 END) AS Primary_Only_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_HrSec_NULLs,
  SUM(CASE WHEN `U_Primary_Only` IS NULL THEN 1 ELSE 0 END) AS U_Primary_Only_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_HrSec_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_NULLs,
  SUM(CASE WHEN `Sec_Only` IS NULL THEN 1 ELSE 0 END) AS Sec_Only_NULLs,
  SUM(CASE WHEN `Sec_with_HrSec` IS NULL THEN 1 ELSE 0 END) AS Sec_with_HrSec_NULLs,
  SUM(CASE WHEN `HrSec_Only` IS NULL THEN 1 ELSE 0 END) AS HrSec_Only_NULLs,
  SUM(CASE WHEN `All_Schools` IS NULL THEN 1 ELSE 0 END) AS All_Schools_NULLs
FROM schoolswithgirlstoilet;

SELECT
  SUM(CASE WHEN `Primary_Only` IS NULL THEN 1 ELSE 0 END) AS Primary_Only_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_HrSec_NULLs,
  SUM(CASE WHEN `U_Primary_Only` IS NULL THEN 1 ELSE 0 END) AS U_Primary_Only_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec_HrSec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_HrSec_NULLs,
  SUM(CASE WHEN `Primary_with_U_Primary_Sec` IS NULL THEN 1 ELSE 0 END) AS Primary_with_U_Primary_Sec_NULLs,
  SUM(CASE WHEN `U_Primary_With_Sec` IS NULL THEN 1 ELSE 0 END) AS U_Primary_With_Sec_NULLs,
  SUM(CASE WHEN `Sec_Only` IS NULL THEN 1 ELSE 0 END) AS Sec_Only_NULLs,
  SUM(CASE WHEN `Sec_with_HrSec` IS NULL THEN 1 ELSE 0 END) AS Sec_with_HrSec_NULLs,
  SUM(CASE WHEN `HrSec_Only` IS NULL THEN 1 ELSE 0 END) AS HrSec_Only_NULLs,
  SUM(CASE WHEN `All_Schools` IS NULL THEN 1 ELSE 0 END) AS All_Schools_NULLs
FROM schoolswithwater;

-- Nulls were only found in table dropoutratio - 5 in column Upper_Primary_Boys and 3 in column HrSecondary_Girls
-- Since these are state-level aggregates and the missing rate is very low, 
-- we impute missing values using national-level yearly averages to maintain comparability 

CREATE TEMPORARY TABLE avg_upper_primary_boys AS
SELECT Year, AVG(Upper_Primary_Boys) AS avg_val
FROM dropoutratio
WHERE Upper_Primary_Boys IS NOT NULL
GROUP BY Year;

CREATE TEMPORARY TABLE avg_hrsecondary_girls AS
SELECT Year, AVG(HrSecondary_Girls) AS avg_val
FROM dropoutratio
WHERE HrSecondary_Girls IS NOT NULL
GROUP BY Year;

UPDATE dropoutratio dr
JOIN avg_upper_primary_boys avg
ON dr.Year = avg.Year
SET dr.Upper_Primary_Boys = avg.avg_val
WHERE dr.Upper_Primary_Boys IS NULL;

UPDATE dropoutratio dr
JOIN avg_hrsecondary_girls avg
ON dr.Year = avg.Year
SET dr.HrSecondary_Girls = avg.avg_val
WHERE dr.HrSecondary_Girls IS NULL;

-- Final Status: Tables are cleaned, standardized, and missing values imputed appropriately

-- ================================================================
-- Step 5: Create Master Table for EDA
-- ================================================================

-- List of all distinct State-Year combinations from all datasets

CREATE TABLE all_state_years AS
SELECT DISTINCT State_UT, Year FROM dropoutratio
UNION
SELECT DISTINCT State_UT, Year FROM grossenrollmentratio
UNION
SELECT DISTINCT State_UT, Year FROM schoolswithboystoilet
UNION
SELECT DISTINCT State_UT, Year FROM schoolswithgirlstoilet
UNION
SELECT DISTINCT State_UT, Year FROM schoolswithcomps
UNION
SELECT DISTINCT State_UT, Year FROM schoolswithelectric
UNION
SELECT DISTINCT State_UT, Year FROM schoolswithwater;

-- Joining all cleaned datasets on State_UT and Year

CREATE TABLE education_master_table AS
SELECT 
    sy.State_UT,
    sy.Year,

    -- Dropout Ratio
    d.Primary_Boys,
    d.Primary_Girls,
    d.Primary_Total,
    d.Upper_Primary_Boys,
    d.Upper_Primary_Girls,
    d.Upper_Primary_Total,
    d.Secondary_Boys,
    d.Secondary_Girls,
    d.Secondary_Total,
    d.HrSecondary_Boys,
    d.HrSecondary_Girls,
    d.HrSecondary_Total,

    -- GER
    g.Primary_Boys AS GER_Primary_Boys,
    g.Primary_Girls AS GER_Primary_Girls,
    g.Primary_Total AS GER_Primary_Total,
    g.Upper_Primary_Boys AS GER_Upper_Primary_Boys,
    g.Upper_Primary_Girls AS GER_Upper_Primary_Girls,
    g.Upper_Primary_Total AS GER_Upper_Primary_Total,
    g.Secondary_Boys AS GER_Secondary_Boys,
    g.Secondary_Girls AS GER_Secondary_Girls,
    g.Secondary_Total AS GER_Secondary_Total,
    g.HrSecondary_Boys AS GER_HrSecondary_Boys,
    g.HrSecondary_Girls AS GER_HrSecondary_Girls,
    g.HrSecondary_Total AS GER_HrSecondary_Total,

    -- Infra
    bt.All_Schools AS Schools_With_Boys_Toilet,
    gt.All_Schools AS Schools_With_Girls_Toilet,
    c.All_Schools AS Schools_With_Computer,
    e.All_Schools AS Schools_With_Electricity,
    w.All_Schools AS Schools_With_Water

FROM all_state_years sy
LEFT JOIN dropoutratio d ON d.State_UT = sy.State_UT AND d.Year = sy.Year
LEFT JOIN grossenrollmentratio g ON g.State_UT = sy.State_UT AND g.Year = sy.Year
LEFT JOIN schoolswithboystoilet bt ON bt.State_UT = sy.State_UT AND bt.Year = sy.Year
LEFT JOIN schoolswithgirlstoilet gt ON gt.State_UT = sy.State_UT AND gt.Year = sy.Year
LEFT JOIN schoolswithcomps c ON c.State_UT = sy.State_UT AND c.Year = sy.Year
LEFT JOIN schoolswithelectric e ON e.State_UT = sy.State_UT AND e.Year = sy.Year
LEFT JOIN schoolswithwater w ON w.State_UT = sy.State_UT AND w.Year = sy.Year;

-- ================================================================
-- Step 6: Exporting Files
-- ================================================================
-- creating separate tables of cleaned data for clarity

CREATE TABLE dropoutratio_cleaned AS SELECT * FROM dropoutratio;
CREATE TABLE grossenrollmentratio_cleaned AS SELECT * FROM grossenrollmentratio;
CREATE TABLE schoolswithboystoilet_cleaned AS SELECT * FROM schoolswithboystoilet;
CREATE TABLE schoolswithcomps_cleaned AS SELECT * FROM schoolswithcomps;
CREATE TABLE schoolswithelectric_cleaned AS SELECT * FROM schoolswithelectric;
CREATE TABLE schoolswithgirlstoilet_cleaned AS SELECT * FROM schoolswithgirlstoilet;
CREATE TABLE schoolswithwater_cleaned AS SELECT * FROM schoolswithwater;

SELECT * FROM dropoutratio_cleaned;
SELECT * FROM grossenrollmentratio_cleaned;
SELECT * FROM schoolswithboystoilet_cleaned;
SELECT * FROM schoolswithcomps_cleaned;
SELECT * FROM schoolswithelectric_cleaned;
SELECT * FROM schoolswithgirlstoilet_cleaned;
SELECT * FROM schoolswithwater_cleaned;
SELECT * FROM education_master_table;

-- these tables will be exported as CSV files for EDA