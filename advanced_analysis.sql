-- How do the financial metrics compare across different states or regions?
SELECT 
    State_Code,
    COUNT(Provider_CCN) AS Number_of_Providers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income,
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_PPS_Payment_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_PPS_Payment_Without_Outliers,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_PPS_Payment_Without_Outliers,
    SUM(Total_PPS_Payment_LUPA_episodes_periods) AS Total_PPS_Payment_LUPA,
    AVG(Total_PPS_Payment_LUPA_episodes_periods) AS Average_PPS_Payment_LUPA,
    STDDEV(Total_PPS_Payment_LUPA_episodes_periods) AS StdDev_PPS_Payment_LUPA,
    SUM(Total_PPS_Payment_PEP_episodes_periods) AS Total_PPS_Payment_PEP,
    AVG(Total_PPS_Payment_PEP_episodes_periods) AS Average_PPS_Payment_PEP,
    STDDEV(Total_PPS_Payment_PEP_episodes_periods) AS StdDev_PPS_Payment_PEP
FROM 
    CostReporthha_2020
GROUP BY 
    State_Code
ORDER BY 
    Total_Net_Income DESC;


SELECT 
    State_Code,
    COUNT(Provider_CCN) AS Number_of_Providers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income,
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_PPS_Payment_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_PPS_Payment_Without_Outliers,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_PPS_Payment_Without_Outliers,
    SUM(Total_PPS_Payment_LUPA_episodes_periods) AS Total_PPS_Payment_LUPA,
    AVG(Total_PPS_Payment_LUPA_episodes_periods) AS Average_PPS_Payment_LUPA,
    STDDEV(Total_PPS_Payment_LUPA_episodes_periods) AS StdDev_PPS_Payment_LUPA,
    SUM(Total_PPS_Payment_PEP_episodes_periods) AS Total_PPS_Payment_PEP,
    AVG(Total_PPS_Payment_PEP_episodes_periods) AS Average_PPS_Payment_PEP,
    STDDEV(Total_PPS_Payment_PEP_episodes_periods) AS StdDev_PPS_Payment_PEP
FROM 
    CostReporthha_2021
GROUP BY 
    State_Code
ORDER BY 
    Total_Net_Income DESC;

SELECT 
    DATE_FORMAT(Fiscal_Year_End_Date, '%Y-%m') AS Month,  -- Format date to 'YYYY-MM'
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_Payments_Without_Outliers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income
FROM 
    CostReporthha_2020
GROUP BY 
    DATE_FORMAT(Fiscal_Year_End_Date, '%Y-%m')  -- Group by year-month
ORDER BY 
    Month ASC;


SELECT 
    DATE_FORMAT(Fiscal_Year_End_Date, '%Y-%m') AS Month,  -- Format date to 'YYYY-MM'
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_Payments_Without_Outliers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income
FROM 
    CostReporthha_2021
GROUP BY 
    DATE_FORMAT(Fiscal_Year_End_Date, '%Y-%m')  -- Group by year-month
ORDER BY 
    Month ASC;

SELECT 
    CONCAT(YEAR(Fiscal_Year_End_Date), '-Q', QUARTER(Fiscal_Year_End_Date)) AS Quarter,
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Average_Payments_Without_Outliers,
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Average_Net_Income
FROM 
    CostReporthha_2020
GROUP BY 
    CONCAT(YEAR(Fiscal_Year_End_Date), '-Q', QUARTER(Fiscal_Year_End_Date))
ORDER BY 
    Quarter ASC;

-- Are there any providers with exceptionally high or low payments or net income?

SELECT 
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Mean_Payments_Without_Outliers,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Mean_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income
FROM 
    CostReporthha_2020;

SELECT 
    Provider_CCN,
    Total_PPS_Payment_full_episodes_periods_without_outliers,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32
FROM 
    CostReporthha_2020
WHERE 
    Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
    OR
    Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
ORDER BY 
    Provider_CCN;


SELECT 
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Mean_Payments_Without_Outliers,
    STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) AS StdDev_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Mean_Net_Income,
    STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS StdDev_Net_Income
FROM 
    CostReporthha_2021;


SELECT 
    Provider_CCN,
    Total_PPS_Payment_full_episodes_periods_without_outliers,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32
FROM 
    CostReporthha_2021
WHERE 
    Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
    OR
    Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
ORDER BY 
    Provider_CCN;


-- What could be the potential reasons for these outliers?

SELECT 
    Provider_CCN,
    Type_of_Control,
    State_Code,
    Total_PPS_Payment_full_episodes_periods_without_outliers,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32
FROM 
    CostReporthha_2020
WHERE 
    Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
    OR
    Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
ORDER BY 
    Provider_CCN;


SELECT 
    Provider_CCN,
    Type_of_Control,
    State_Code,
    Total_PPS_Payment_full_episodes_periods_without_outliers,
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32
FROM 
    CostReporthha_2021
WHERE 
    Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
    OR
    Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
    OR
    Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
ORDER BY 
    Provider_CCN;

-- explore the type of control analysis for 2020
SELECT 
    Type_of_Control,
    COUNT(Provider_CCN) AS Number_of_Providers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income
FROM 
    CostReporthha_2020
WHERE 
    Provider_CCN IN (
        SELECT Provider_CCN
        FROM 
            CostReporthha_2020
        WHERE 
            Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
            OR
            Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
    )
GROUP BY 
    Type_of_Control;

-- explore the type of control analysis for 2021

SELECT 
    Type_of_Control,
    COUNT(Provider_CCN) AS Number_of_Providers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income
FROM 
    CostReporthha_2021
WHERE 
    Provider_CCN IN (
        SELECT Provider_CCN
        FROM 
            CostReporthha_2021
        WHERE 
            Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
            OR
            Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
    )
GROUP BY 
    Type_of_Control;


-- Explore the state/region analysis for 2020

SELECT 
    State_Code,
    COUNT(Provider_CCN) AS Number_of_Providers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income
FROM 
    CostReporthha_2020
WHERE 
    Provider_CCN IN (
        SELECT Provider_CCN
        FROM 
            CostReporthha_2020
        WHERE 
            Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
            OR
            Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2020)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2020)
    )
GROUP BY 
    State_Code;


--  Explore the State/Region Analysis for 2021

SELECT 
    State_Code,
    COUNT(Provider_CCN) AS Number_of_Providers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_Payments_Without_Outliers,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income
FROM 
    CostReporthha_2021
WHERE 
    Provider_CCN IN (
        SELECT Provider_CCN
        FROM 
            CostReporthha_2021
        WHERE 
            Total_PPS_Payment_full_episodes_periods_without_outliers > (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) + 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
            OR
            Total_PPS_Payment_full_episodes_periods_without_outliers < (SELECT AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) - 2 * STDDEV(Total_PPS_Payment_full_episodes_periods_without_outliers) FROM CostReporthha_2021)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 > (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) + 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
            OR
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32 < (SELECT AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) - 2 * STDDEV(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) FROM CostReporthha_2021)
    )
GROUP BY 
    State_Code;



-- I want to know What are the key performance indicators (KPIs) for home health agencies in 2020
-- Total Revenue and Payments
SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Total_Payments_Without_Outliers,
    AVG(Total_PPS_Payment_full_episodes_periods_without_outliers) AS Avg_Payments_Without_Outliers
FROM 
    CostReporthha_2020;

--Net Income and Net Income Margin
SELECT 
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Total_Net_Income,
    AVG(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Avg_Net_Income,
    (SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) / SUM(Total_PPS_Payment_full_episodes_periods_without_outliers)) * 100 AS Net_Income_Margin
FROM 
    CostReporthha_2020;

-- Patient Volume Metrics for episodes

SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods) / COUNT(*) AS Avg_Payment_per_Episode
FROM 
    CostReporthha_2020; 

-- Operating Margin

SELECT 
    (SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) / 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods)) * 100 AS Operating_Margin
FROM 
    CostReporthha_2020;

-- Number of Episodes of Care:
SELECT 
    COUNT(*) AS Number_of_Episodes
FROM 
    CostReporthha_2020; 

-- Average Cost per Episode

SELECT 
    (
        SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
            Total_PPS_Payment_LUPA_episodes_periods + 
            Total_PPS_Payment_PEP_episodes_periods - 
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32)
    ) / COUNT(*) AS Avg_Cost_per_Episode
FROM 
    CostReporthha_2020;

-- Total Revenue

SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods) AS Total_Revenue
FROM 
    CostReporthha_2020;


-- what are the key performance indicators (KPIs) for home health agencies in 2021

-- total revenues

SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods) AS Total_Revenue
FROM 
    CostReporthha_2021;


-- Net Income

SELECT 
    SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) AS Net_Income
FROM 
    CostReporthha_2021; 


-- Average Payment per Episode

SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods) / COUNT(*) AS Avg_Payment_per_Episode
FROM 
    CostReporthha_2021;


-- Operating Margin

SELECT 
    (SUM(Net_Income_or_Loss_for_the_period_line_18_plus_line_32) / 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods)) * 100 AS Operating_Margin
FROM 
    CostReporthha_2021;


-- Number of Episodes of Care

SELECT 
    COUNT(*) AS Number_of_Episodes
FROM 
    CostReporthha_2021;


-- Average Cost per Episode

SELECT 
    (
        SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
            Total_PPS_Payment_LUPA_episodes_periods + 
            Total_PPS_Payment_PEP_episodes_periods - 
            Net_Income_or_Loss_for_the_period_line_18_plus_line_32)
    ) / COUNT(*) AS Avg_Cost_per_Episode
FROM 
    CostReporthha_2021;

-- Total Revenue in 2021

SELECT 
    SUM(Total_PPS_Payment_full_episodes_periods_without_outliers + 
        Total_PPS_Payment_LUPA_episodes_periods + 
        Total_PPS_Payment_PEP_episodes_periods) AS Total_Revenue
FROM 
    CostReporthha_2021;


-- How can we measure efficiency and effectiveness based on the available data?

SELECT 
    (COUNT(b.Provider_CCN) - COUNT(a.Provider_CCN)) / 
    COUNT(a.Provider_CCN) * 100 AS Episode_Growth_Rate
FROM 
    CostReporthha_2020 a, CostReporthha_2021 b;
