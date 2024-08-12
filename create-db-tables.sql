-- Active: 1723074327809@@127.0.0.1@3306
CREATE DATABASE CostReports DEFAULT CHARACTER SET = 'utf8mb4';
USE CostReports;

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

-- Since it is running with the secure-file-priv so I need to turn on the local-infile

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/haochenmiao/Documents/Data_Sciecne_Projects/BI Projects/health_Agency_cost/data/Home Health Agency Cost Report/2020/CostReporthha_Final_20_update.csv'
INTO TABLE CostReporthha_2020
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rpt_rec_num, Provider_CCN, HHA_Name, Street_Address, City, State_Code, Zip_Code, Type_of_Control, Fiscal_Year_Begin_Date, Fiscal_Year_End_Date, Net_Income_or_Loss_for_the_period_line_18_plus_line_32, Total_PPS_Payment_full_episodes_periods_without_outliers, Total_PPS_Payment_full_episodes_periods_with_outliers, Total_PPS_Payment_LUPA_episodes_periods, Total_PPS_Payment_PEP_episodes_periods, Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers, Total_PPS_Outlier_Payment_PEP_episodes_periods, Allowable_Bad_Debts, Adjusted_Reimbursable_Bad_Debts, Total_Hospice_Expenses);

SELECT * FROM CostReporthha_2020;

LOAD DATA LOCAL INFILE '/Users/haochenmiao/Documents/Data_Sciecne_Projects/BI Projects/health_Agency_cost/data/Home Health Agency Cost Report/2021/CostReporthha_Final_21.csv'
INTO TABLE CostReporthha_2021
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rpt_rec_num, Provider_CCN, HHA_Name, Street_Address, City, State_Code, Zip_Code, Type_of_Control, Fiscal_Year_Begin_Date, Fiscal_Year_End_Date, Net_Income_or_Loss_for_the_period_line_18_plus_line_32, Total_PPS_Payment_full_episodes_periods_without_outliers, Total_PPS_Payment_full_episodes_periods_with_outliers, Total_PPS_Payment_LUPA_episodes_periods, Total_PPS_Payment_PEP_episodes_periods, Total_PPS_Outlier_Payment_full_episodes_periods_with_outliers, Total_PPS_Outlier_Payment_PEP_episodes_periods, Allowable_Bad_Debts, Adjusted_Reimbursable_Bad_Debts, Total_Hospice_Expenses);