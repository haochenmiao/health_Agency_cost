-- Active: 1723074327809@@127.0.0.1@3306@CostReports

-- I want to know what are the primary columns and their data types in the 2020 data file

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CostReporthha_2020'
    AND TABLE_SCHEMA = 'CostReports';

-- What if I want to know about the year 2021

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CostReporthha_2021'
    AND TABLE_SCHEMA = 'CostReports';

-- Checking for null values (year 2020)

SELECT 
    SUM(CASE WHEN rpt_rec_num IS NULL THEN 1 ELSE 0 END) AS rpt_rec_num_nulls,
    SUM(CASE WHEN Provider_CCN IS NULL THEN 1 ELSE 0 END) AS Provider_CCN_nulls,
    SUM(CASE WHEN HHA_Name IS NULL THEN 1 ELSE 0 END) AS HHA_Name_nulls,
    SUM(CASE WHEN Street_Address IS NULL THEN 1 ELSE 0 END) AS Street_Address_nulls,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_nulls,
    SUM(CASE WHEN State_Code IS NULL THEN 1 ELSE 0 END) AS State_Code_nulls,
    SUM(CASE WHEN Zip_Code IS NULL THEN 1 ELSE 0 END) AS Zip_Code_nulls,
    SUM(CASE WHEN Type_of_Control IS NULL THEN 1 ELSE 0 END) AS Type_of_Control_nulls,
    SUM(CASE WHEN Fiscal_Year_Begin_Date IS NULL THEN 1 ELSE 0 END) AS Fiscal_Year_Begin_Date_nulls,
    SUM(CASE WHEN Fiscal_Year_End_Date IS NULL THEN 1 ELSE 0 END) AS Fiscal_Year_End_Date_nulls,
    SUM(CASE WHEN Net_Income_or_Loss_for_the_period_line_18_plus_line_32 IS NULL THEN 1 ELSE 0 END) AS Net_Income_or_Loss_nulls,
    SUM(CASE WHEN Total_PPS_Payment_full_episodes_periods_without_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_Without_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Payment_full_episodes_periods_with_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_With_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Payment_LUPA_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_LUPA_nulls,
    SUM(CASE WHEN Total_PPS_Payment_PEP_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_PEP_nulls,
    SUM(CASE WHEN Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Outlier_Payment_With_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Outlier_Payment_PEP_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Outlier_Payment_PEP_nulls,
    SUM(CASE WHEN Allowable_Bad_Debts IS NULL THEN 1 ELSE 0 END) AS Allowable_Bad_Debts_nulls,
    SUM(CASE WHEN Adjusted_Reimbursable_Bad_Debts IS NULL THEN 1 ELSE 0 END) AS Adjusted_Reimbursable_Bad_Debts_nulls,
    SUM(CASE WHEN Total_Hospice_Expenses IS NULL THEN 1 ELSE 0 END) AS Total_Hospice_Expenses_nulls
FROM 
    CostReporthha_2020;

-- checking for anomalies (e.g. negative values)

SELECT 
    COUNT(*) AS Negative_Net_Income_or_Loss,
    COUNT(*) AS Negative_Total_PPS_Payment_Without_Outliers,
    COUNT(*) AS Negative_Total_PPS_Payment_With_Outliers,
    COUNT(*) AS Negative_Total_PPS_Payment_LUPA,
    COUNT(*) AS Negative_Total_PPS_Payment_PEP,
    COUNT(*) AS Negative_Total_PPS_Outlier_Payment_With_Outliers,
    COUNT(*) AS Negative_Total_PPS_Outlier_Payment_PEP,
    COUNT(*) AS Negative_Allowable_Bad_Debts,
    COUNT(*) AS Negative_Adjusted_Reimbursable_Bad_Debts,
    COUNT(*) AS Negative_Total_Hospice_Expenses
FROM 
    CostReporthha_2020
WHERE 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < 0
    OR Total_PPS_Payment_full_episodes_periods_without_outliers < 0
    OR Total_PPS_Payment_full_episodes_periods_with_outliers < 0
    OR Total_PPS_Payment_LUPA_episodes_periods < 0
    OR Total_PPS_Payment_PEP_episodes_periods < 0
    OR Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers < 0
    OR Total_PPS_Outlier_Payment_PEP_episodes_periods < 0
    OR Allowable_Bad_Debts < 0
    OR Adjusted_Reimbursable_Bad_Debts < 0
    OR Total_Hospice_Expenses < 0;

-- Checking for outliers (year 2020)

SELECT 
    Provider_CCN, 
    HHA_Name, 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32, 
    Total_PPS_Payment_full_episodes_periods_without_outliers
FROM 
    CostReporthha_2020
WHERE 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 3 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
    OR Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 3 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020);


-- Checking for null values (year 2021)

SELECT 
    SUM(CASE WHEN rpt_rec_num IS NULL THEN 1 ELSE 0 END) AS rpt_rec_num_nulls,
    SUM(CASE WHEN Provider_CCN IS NULL THEN 1 ELSE 0 END) AS Provider_CCN_nulls,
    SUM(CASE WHEN HHA_Name IS NULL THEN 1 ELSE 0 END) AS HHA_Name_nulls,
    SUM(CASE WHEN Street_Address IS NULL THEN 1 ELSE 0 END) AS Street_Address_nulls,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_nulls,
    SUM(CASE WHEN State_Code IS NULL THEN 1 ELSE 0 END) AS State_Code_nulls,
    SUM(CASE WHEN Zip_Code IS NULL THEN 1 ELSE 0 END) AS Zip_Code_nulls,
    SUM(CASE WHEN Type_of_Control IS NULL THEN 1 ELSE 0 END) AS Type_of_Control_nulls,
    SUM(CASE WHEN Fiscal_Year_Begin_Date IS NULL THEN 1 ELSE 0 END) AS Fiscal_Year_Begin_Date_nulls,
    SUM(CASE WHEN Fiscal_Year_End_Date IS NULL THEN 1 ELSE 0 END) AS Fiscal_Year_End_Date_nulls,
    SUM(CASE WHEN Net_Income_or_Loss_for_the_period_line_18_plus_line_32 IS NULL THEN 1 ELSE 0 END) AS Net_Income_or_Loss_nulls,
    SUM(CASE WHEN Total_PPS_Payment_full_episodes_periods_without_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_Without_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Payment_full_episodes_periods_with_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_With_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Payment_LUPA_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_LUPA_nulls,
    SUM(CASE WHEN Total_PPS_Payment_PEP_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Payment_PEP_nulls,
    SUM(CASE WHEN Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Outlier_Payment_With_Outliers_nulls,
    SUM(CASE WHEN Total_PPS_Outlier_Payment_PEP_episodes_periods IS NULL THEN 1 ELSE 0 END) AS Total_PPS_Outlier_Payment_PEP_nulls,
    SUM(CASE WHEN Allowable_Bad_Debts IS NULL THEN 1 ELSE 0 END) AS Allowable_Bad_Debts_nulls,
    SUM(CASE WHEN Adjusted_Reimbursable_Bad_Debts IS NULL THEN 1 ELSE 0 END) AS Adjusted_Reimbursable_Bad_Debts_nulls,
    SUM(CASE WHEN Total_Hospice_Expenses IS NULL THEN 1 ELSE 0 END) AS Total_Hospice_Expenses_nulls
FROM 
    CostReporthha_2021;


-- checking for anomalies (e.g. negative values) (year 2021)

SELECT 
    COUNT(*) AS Negative_Net_Income_or_Loss,
    COUNT(*) AS Negative_Total_PPS_Payment_Without_Outliers,
    COUNT(*) AS Negative_Total_PPS_Payment_With_Outliers,
    COUNT(*) AS Negative_Total_PPS_Payment_LUPA,
    COUNT(*) AS Negative_Total_PPS_Payment_PEP,
    COUNT(*) AS Negative_Total_PPS_Outlier_Payment_With_Outliers,
    COUNT(*) AS Negative_Total_PPS_Outlier_Payment_PEP,
    COUNT(*) AS Negative_Allowable_Bad_Debts,
    COUNT(*) AS Negative_Adjusted_Reimbursable_Bad_Debts,
    COUNT(*) AS Negative_Total_Hospice_Expenses
FROM 
    CostReporthha_2021
WHERE 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < 0
    OR Total_PPS_Payment_full_episodes_periods_without_outliers < 0
    OR Total_PPS_Payment_full_episodes_periods_with_outliers < 0
    OR Total_PPS_Payment_LUPA_episodes_periods < 0
    OR Total_PPS_Payment_PEP_episodes_periods < 0
    OR Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers < 0
    OR Total_PPS_Outlier_Payment_PEP_episodes_periods < 0
    OR Allowable_Bad_Debts < 0
    OR Adjusted_Reimbursable_Bad_Debts < 0
    OR Total_Hospice_Expenses < 0;


-- Checking for outliers (year 2021)

SELECT 
    Provider_CCN, 
    HHA_Name, 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32, 
    Total_PPS_Payment_full_episodes_periods_without_outliers
FROM 
    CostReporthha_2021
WHERE 
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 3 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
    OR Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 3 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021);

-- I want to find out the distribution of Total_PPS_Payment for year 2020

SELECT 
    MIN(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Min_PPS_Payment_2020,
    MAX(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Max_PPS_Payment_2020,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_PPS_Payment_2020,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_PPS_Payment_2020,
    COUNT(*) AS Count_PPS_Payment_2020
FROM 
    CostReporthha_2020;

-- I want to find out the Net income for year 2020

SELECT 
    MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Min_Net_Income_2020,
    MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Max_Net_Income_2020,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income_2020,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income_2020,
    COUNT(*) AS Count_Net_Income_2020
FROM 
    CostReporthha_2020;

-- Distribution of Total_PPS_Payment for year 2021

SELECT 
    MIN(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Min_PPS_Payment_2021,
    MAX(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Max_PPS_Payment_2021,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_PPS_Payment_2021,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_PPS_Payment_2021,
    COUNT(*) AS Count_PPS_Payment_2021
FROM 
    CostReporthha_2021;


-- Distribution of net income for year 2021

SELECT 
    MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Min_Net_Income_2021,
    MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Max_Net_Income_2021,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income_2021,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income_2021,
    COUNT(*) AS Count_Net_Income_2021
FROM 
    CostReporthha_2021;


-- indetify duplicate records for year 2020

SELECT 
    Provider_CCN, 
    HHA_Name, 
    Fiscal_Year_End_Date, 
    COUNT(*) AS DuplicateCount
FROM 
    CostReporthha_2020
GROUP BY 
    Provider_CCN, 
    HHA_Name, 
    Fiscal_Year_End_Date
HAVING 
    COUNT(*) > 1;

-- identify duplicates records for year 2021

SELECT 
    Provider_CCN, 
    HHA_Name, 
    Fiscal_Year_End_Date, 
    COUNT(*) AS DuplicateCount
FROM 
    CostReporthha_2021
GROUP BY 
    Provider_CCN, 
    HHA_Name, 
    Fiscal_Year_End_Date
HAVING 
    COUNT(*) > 1;

-- I want to now ensure the data integrity and data consistency

SHOW KEYS FROM CostReporthha_2020 WHERE Key_name = 'PRIMARY';

SELECT a.rpt_rec_num, a.Provider_CCN AS Provider_CCN_2020, b.Provider_CCN AS Provider_CCN_2021
FROM CostReporthha_2020 a
JOIN CostReporthha_2021 b ON a.rpt_rec_num = b.rpt_rec_num
WHERE a.Provider_CCN <> b.Provider_CCN;

SELECT a.rpt_rec_num, a.State_Code AS State_Code_2020, b.State_Code AS State_Code_2021
FROM CostReporthha_2020 a
JOIN CostReporthha_2021 b ON a.rpt_rec_num = b.rpt_rec_num
WHERE a.State_Code <> b.State_Code;

-- both returns empty result sets, meaning good data consistency across these fields for the two years.


-- Now I want to check if I need to transform any columns, such as date formats or categorical encoding

-- Check the data type of date columns in the 2020 table
DESCRIBE CostReporthha_2020;

-- Check the data type of date columns in the 2021 table
DESCRIBE CostReporthha_2021;


-- Check unique values in the State_Code column in the 2020 table
SELECT DISTINCT State_Code FROM CostReporthha_2020;

-- Check unique values in the State_Code column in the 2021 table
SELECT DISTINCT State_Code FROM CostReporthha_2021;

-- Check unique values in the Type_of_Control column in the 2020 table
SELECT DISTINCT Type_of_Control FROM CostReporthha_2020;

-- Check unique values in the Type_of_Control column in the 2021 table
SELECT DISTINCT Type_of_Control FROM CostReporthha_2021;

-- Check unique values in the Provider_CCN column in the 2020 table
SELECT DISTINCT Provider_CCN FROM CostReporthha_2020;

-- Check unique values in the Provider_CCN column in the 2021 table
SELECT DISTINCT Provider_CCN FROM CostReporthha_2021;


-- Standardize State_Code in the 2020 table
UPDATE CostReporthha_2020
SET State_Code = UPPER(State_Code)
WHERE LENGTH(State_Code) = 2;

-- Standardize State_Code in the 2021 table
UPDATE CostReporthha_2021
SET State_Code = UPPER(State_Code)
WHERE LENGTH(State_Code) = 2;

-- Standardizing Type_of_Control in the 2020 table, assuming it should be numeric
UPDATE CostReporthha_2020
SET Type_of_Control = CASE
    WHEN Type_of_Control = 1 THEN 1 -- 'Public'
    WHEN Type_of_Control = 2 THEN 2 -- 'Private'
    WHEN Type_of_Control = 3 THEN 3 -- 'Non-Profit'
    ELSE NULL -- Handle unexpected values
END;

-- Standardizing Type_of_Control in the 2021 table
UPDATE CostReporthha_2021
SET Type_of_Control = CASE
    WHEN Type_of_Control = 1 THEN 1 -- 'Public'
    WHEN Type_of_Control = 2 THEN 2 -- 'Private'
    WHEN Type_of_Control = 3 THEN 3 -- 'Non-Profit'
    ELSE NULL -- Handle unexpected values
END;

-- Normalize Net_Income_or_Loss for the 2020 table

-- Declare variables to hold the minimum and maximum values
SET @min_value := (SELECT MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020);
SET @max_value := (SELECT MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020);

-- Normalize the Net_Income_or_Loss column
UPDATE CostReporthha_2020
SET Net_Income_or_Loss_for_the_period_line_18_plus_line_32 =
    (Net_Income_or_Loss_for_the_period_line_18_plus_line_32 - @min_value) /
    (@max_value - @min_value);

UPDATE CostReporthha_2021
SET Net_Income_or_Loss_for_the_period_line_18_plus_line_32 =
    (Net_Income_or_Loss_for_the_period_line_18_plus_line_32 - @min_value) /
    (@max_value - @min_value);


-- want to find out the Mean, Standard Deviation, and Range

SELECT 
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Mean_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income,
    MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Min_Net_Income,
    MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Max_Net_Income,
    (MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32)) AS Range_Net_Income
FROM 
    CostReporthha_2020;


SELECT 
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Mean_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income,
    MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Min_Net_Income,
    MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Max_Net_Income,
    (MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32)) AS Range_Net_Income
FROM 
    CostReporthha_2021;

-- How many unique providers are there in the dataset?

SELECT COUNT(DISTINCT Provider_CCN) AS Unique_Providers
FROM CostReporthha_2020;

SELECT COUNT(DISTINCT Provider_CCN) AS Unique_Providers
FROM CostReporthha_2021;

-- What are the total and average payments by state?

SELECT 
    State_Code,  -- Select the state code
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments,  -- Calculate total payments
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_Payments  -- Calculate average payments
FROM 
    CostReporthha_2020  -- Specify the table name
GROUP BY 
    State_Code  -- Group the results by state code
ORDER BY 
    Total_Payments DESC;  -- Optional: Order by total payments in descending order

SELECT 
    State_Code,
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) + 
    SUM(Total_PPS_Payment_LUPA_episodes_periods) + 
    SUM(Total_PPS_Payment_PEP_episodes_periods) AS Total_Payments,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 
    AVG(Total_PPS_Payment_LUPA_episodes_periods) + 
    AVG(Total_PPS_Payment_PEP_episodes_periods) AS Average_Payments
FROM 
    CostReporthha_2020
GROUP BY 
    State_Code
ORDER BY 
    Total_Payments DESC;

SELECT 
    State_Code,
    SUM(COALESCE(Total_PPS_Payment_full_episodes_periods_without_outliers, 0)) AS Total_Payments,
    AVG(COALESCE(Total_PPS_Payment_full_episodes_periods_without_outliers, 0)) AS Average_Payments
FROM 
    CostReporthha_2020
GROUP BY 
    State_Code
ORDER BY 
    Total_Payments DESC;


SELECT 
    State_Code,  -- Select the state code
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments,  -- Calculate total payments
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_Payments  -- Calculate average payments
FROM 
    CostReporthha_2021  -- Specify the table name
GROUP BY 
    State_Code  -- Group the results by state code
ORDER BY 
    Total_Payments DESC;  -- Optional: Order by total payments in descending order


SELECT 
    State_Code,
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) + 
    SUM(Total_PPS_Payment_LUPA_episodes_periods) + 
    SUM(Total_PPS_Payment_PEP_episodes_periods) AS Total_Payments,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 
    AVG(Total_PPS_Payment_LUPA_episodes_periods) + 
    AVG(Total_PPS_Payment_PEP_episodes_periods) AS Average_Payments
FROM 
    CostReporthha_2021
GROUP BY 
    State_Code
ORDER BY 
    Total_Payments DESC;

SELECT 
    State_Code,
    SUM(COALESCE(Total_PPS_Payment_full_episodes_periods_without_outliers, 0)) AS Total_Payments,
    AVG(COALESCE(Total_PPS_Payment_full_episodes_periods_without_outliers, 0)) AS Average_Payments
FROM 
    CostReporthha_2021
GROUP BY 
    State_Code
ORDER BY 
    Total_Payments DESC;

-- How does the net income vary across different types of control?

SELECT 
    Type_of_Control,
    COUNT(Provider_CCN) AS Number_of_Providers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income
FROM 
    CostReporthha_2020
GROUP BY 
    Type_of_Control
ORDER BY 
    Total_Net_Income DESC;

SELECT 
    Type_of_Control,
    COUNT(Provider_CCN) AS Number_of_Providers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income
FROM 
    CostReporthha_2021
GROUP BY 
    Type_of_Control
ORDER BY 
    Total_Net_Income DESC;






