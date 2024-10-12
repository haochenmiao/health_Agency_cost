# Home Health Agency Cost Report Analysis

## Overview
This project focuses on analyzing financial metrics from Home Health Agency Cost Reports for the years 2020 and 2021. The analysis involves setting up a MySQL database, loading data, performing data manipulation, and generating insights through advanced SQL queries. This README provides a detailed guide on setting up the environment, loading data, running analyses, and utilizing custom UDFs (User Defined Functions) to enhance data processing.

## Table of Contents

* Prerequisites
* Database Setup
* Creating the Database and Tables
* Loading Data
* Data Manipulation
* Checking Data Integrity
* Handling Missing and Anomalous Data
* Standardizing and Normalizing Data
* Advanced Analysis
* State and Region Analysis
* Outlier Detection
* Key Performance Indicators (KPIs)
* User Defined Functions (UDFs)
* UDF for Data Replacement and Validation
* UDF for Calculations
* Data Visualization
* Contact

## Prerequisites
Before you begin, ensure you have the following installed:

* MySQL Server
* MySQL Workbench or any SQL client
* Git (for version control)
* A command-line interface (CLI) like Bash or Terminal
## Database Setup
Here we are going to focus on query for year 2020 for simplicity
### Creating the Database and Tables
First, create the CostReports database and the necessary tables for 2020 and 2021 data. You can execute the create-db-tables.sql script to set up your environment.

```sql
-- Create the database and switch to it
CREATE DATABASE CostReports DEFAULT CHARACTER SET = 'utf8mb4';
USE CostReports;

-- Create tables for 2020 data
CREATE TABLE CostReporthha_2020 (
    rpt_rec_num INT PRIMARY KEY,
    Provider_CCN VARCHAR(10),
    HHA_Name VARCHAR(255),
    Street_Address VARCHAR(255),
    City VARCHAR(255),
    State_Code VARCHAR(2),
    Zip_Code VARCHAR(10),
    Type_of_Control FLOAT,
    Fiscal_Year_Begin_Date DATE,
    Fiscal_Year_End_Date DATE,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 FLOAT,
    Total_PPS_Payment_full_episodes_periods_without_outliers FLOAT,
    Total_PPS_Payment_full_episodes_periods_with_outliers FLOAT,
    Total_PPS_Payment_LUPA_episodes_periods FLOAT,
    Total_PPS_Payment_PEP_episodes_periods FLOAT,
    Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers FLOAT,
    Total_PPS_Outlier_Payment_PEP_episodes_periods FLOAT,
    Allowable_Bad_Debts FLOAT,
    Adjusted_Reimbursable_Bad_Debts FLOAT,
    Total_Hospice_Expenses FLOAT
);

-- Create tables for 2021 data
CREATE TABLE CostReporthha_2021 (
    rpt_rec_num INT PRIMARY KEY,
    Provider_CCN VARCHAR(10),
    HHA_Name VARCHAR(255),
    Street_Address VARCHAR(255),
    City VARCHAR(255),
    State_Code VARCHAR(2),
    Zip_Code VARCHAR(10),
    Type_of_Control FLOAT,
    Fiscal_Year_Begin_Date DATE,
    Fiscal_Year_End_Date DATE,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 FLOAT,
    Total_PPS_Payment_full_episodes_periods_without_outliers FLOAT,
    Total_PPS_Payment_full_episodes_periods_with_outliers FLOAT,
    Total_PPS_Payment_LUPA_episodes_periods FLOAT,
    Total_PPS_Payment_PEP_episodes_periods FLOAT,
    Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers FLOAT,
    Total_PPS_Outlier_Payment_PEP_episodes_periods FLOAT,
    Allowable_Bad_Debts FLOAT,
    Adjusted_Reimbursable_Bad_Debts FLOAT,
    Total_Hospice_Expenses FLOAT
);
```

### Loading Data
After creating the tables, load the data from CSV files into the corresponding tables. Ensure that local_infile is enabled on your MySQL server to load data locally.


```sql
-- Enable loading data locally
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- Load data into the 2020 table
LOAD DATA LOCAL INFILE '/path/to/CostReporthha_Final_20_update.csv'
INTO TABLE CostReporthha_2020
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load data into the 2021 table
LOAD DATA LOCAL INFILE '/path/to/CostReporthha_Final_21.csv'
INTO TABLE CostReporthha_2021
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

## Data Manipulation
### Checking Data Integrity
To ensure data consistency and integrity across the two years, compare key fields such as Provider_CCN and State_Code.

```sql
-- Check for differences in Provider_CCN across years
SELECT a.rpt_rec_num, a.Provider_CCN AS Provider_CCN_2020, b.Provider_CCN AS Provider_CCN_2021
FROM CostReporthha_2020 a
JOIN CostReporthha_2021 b ON a.rpt_rec_num = b.rpt_rec_num
WHERE a.Provider_CCN <> b.Provider_CCN;

-- Check for differences in State_Code across years
SELECT a.rpt_rec_num, a.State_Code AS State_Code_2020, b.State_Code AS State_Code_2021
FROM CostReporthha_2020 a
JOIN CostReporthha_2021 b ON a.rpt_rec_num = b.rpt_rec_num
WHERE a.State_Code <> b.State_Code;
```

### Handling Missing and Anomalous Data
Identify and handle null values and anomalies (e.g., negative values) within the dataset.

```sql
-- Check for null values in 2020
SELECT 
    SUM(CASE WHEN rpt_rec_num IS NULL THEN 1 ELSE 0 END) AS rpt_rec_num_nulls,
    -- Additional checks for each column
    SUM(CASE WHEN Total_Hospice_Expenses IS NULL THEN 1 ELSE 0 END) AS Total_Hospice_Expenses_nulls
FROM CostReporthha_2020;

-- Check for negative values in 2020
SELECT 
    COUNT(*) AS Negative_Net_Income_or_Loss
FROM CostReporthha_2020
WHERE Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < 0;
```

### Standardizing and Normalizing Data
Standardize categorical data (e.g., State_Code, Type_of_Control) and normalize financial metrics for consistent analysis.

```sql
-- Standardize State_Code in 2020
UPDATE CostReporthha_2020
SET State_Code = UPPER(State_Code)
WHERE LENGTH(State_Code) = 2;

-- Normalize Net_Income_or_Loss in 2020
SET @min_value := (SELECT MIN(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020);
SET @max_value := (SELECT MAX(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020);

UPDATE CostReporthha_2020
SET Net_Income_or_Loss_for_the_period_line_18_plus_line_32 =
    (Net_Income_or_Loss_for_the_period_line_18_plus_line_32 - @min_value) /
    (@max_value - @min_value);
```

## Advanced Analysis
### State and Region Analysis
Analyze financial metrics across different states or regions to identify trends and outliers.

```sql
-- Compare financial metrics by state for 2020
SELECT 
    State_Code,
    COUNT(Provider_CCN) AS Number_of_Providers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income
FROM CostReporthha_2020
GROUP BY State_Code
ORDER BY Total_Net_Income DESC;
```

### Outlier Detection
Identify providers with exceptionally high or low payments or net income to explore potential outliers.

```sql
-- Detect outliers in 2020 data
SELECT 
    Provider_CCN,
    Total_PPS_Payment_full_episodes_periods_without_outliers,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32
FROM CostReporthha_2020
WHERE Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
    OR Net_Income_or_Loss_for_the_period_line_18_plus
```

## Data Visualization
Here is the PDF for the Power BI Visualization

[Link to PDF](./Home%20Health%20Agency%20Cost.pdf)

## Publishment
Here is the Medium Link for the Power BI in depth explanation
[Medium](https://medium.com/@miaohaochen0423/unlocking-insights-from-home-healthcare-cost-revenue-and-visit-analysis-for-2020-2021-with-0d2a3753e3bc)




