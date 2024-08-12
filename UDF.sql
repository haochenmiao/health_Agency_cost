
-- Replacing Null for numerical data
DELIMITER //

CREATE FUNCTION ReplaceNullNumeric (inputValue DOUBLE, defaultValue DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN IFNULL(inputValue, defaultValue);
END //

DELIMITER ;


-- Replacing Null for string data

DELIMITER //

CREATE FUNCTION ReplaceNullString (inputValue VARCHAR(255), defaultValue VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN IFNULL(inputValue, defaultValue);
END //

DELIMITER ;


-- UDF to standardize data format

DELIMITER //

CREATE FUNCTION StandardizeDate (inputDate DATE)
RETURNS DATE
DETERMINISTIC
BEGIN
    RETURN DATE_FORMAT(inputDate, '%Y-%m-%d');
END //

DELIMITER ;

-- Handling Missing String Values to make it Unknown
UPDATE CostReporthha_2020
SET State_Code = ReplaceNullString(State_Code, 'UNKNOWN');

UPDATE CostReporthha_2021
SET State_Code = ReplaceNullString(State_Code, 'UNKNOWN');


-- verify updated data

SELECT State_Code, Net_Income_or_Loss_for_the_period_line_18_plus_line_32, Fiscal_Year_Begin_Date
FROM CostReporthha_2020
LIMIT 10;

SELECT State_Code, Net_Income_or_Loss_for_the_period_line_18_plus_line_32, Fiscal_Year_Begin_Date
FROM CostReporthha_2021
LIMIT 10;

-- UDF to Validate ZIP Code Format

DELIMITER //

CREATE FUNCTION ValidateZIPCode (inputZIP VARCHAR(10))
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    -- Check for valid ZIP code formats: '12345' or '12345-6789'
    IF inputZIP REGEXP '^[0-9]{5}(-[0-9]{4})?$' THEN
        RETURN 1;  -- Valid ZIP Code
    ELSE
        RETURN 0;  -- Invalid ZIP Code
    END IF;
END //

DELIMITER ;


-- UDF to Standardize State Code

DELIMITER //

CREATE FUNCTION StandardizeStateCode (inputState VARCHAR(2))
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    RETURN UPPER(TRIM(inputState));
END //

DELIMITER ;

-- UDF to Standardize Street Abbreviations

DELIMITER //

CREATE FUNCTION StandardizeStreet (inputStreet VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE standardizedStreet VARCHAR(255);
    SET standardizedStreet = TRIM(inputStreet);
    
    SET standardizedStreet = REPLACE(standardizedStreet, 'Street', 'St.');
    SET standardizedStreet = REPLACE(standardizedStreet, 'Avenue', 'Ave.');
    SET standardizedStreet = REPLACE(standardizedStreet, 'Boulevard', 'Blvd.');
    SET standardizedStreet = REPLACE(standardizedStreet, 'Drive', 'Dr.');
    SET standardizedStreet = REPLACE(standardizedStreet, 'Road', 'Rd.');
    SET standardizedStreet = REPLACE(standardizedStreet, 'Lane', 'Ln.');
    
    RETURN standardizedStreet;
END //

DELIMITER ;

-- UDF to Check for Missing Address Components

DELIMITER //

CREATE FUNCTION ValidateAddress (inputStreet VARCHAR(255), inputCity VARCHAR(255), inputState VARCHAR(2), inputZIP VARCHAR(10))
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    -- Return 0 if any component is missing or invalid
    IF inputStreet IS NULL OR inputCity IS NULL OR inputState IS NULL OR inputZIP IS NULL THEN
        RETURN 0;
    ELSEIF ValidateZIPCode(inputZIP) = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;  -- Valid Address
    END IF;
END //

DELIMITER ;

-- UDF to calculate the weighted average

DELIMITER //

CREATE FUNCTION CalculateWeightedAverage (SumProduct DOUBLE, SumWeight DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    IF SumWeight = 0 THEN
        RETURN NULL;  -- Avoid division by zero
    ELSE
        RETURN SumProduct / SumWeight;
    END IF;
END //

DELIMITER ;

SELECT 
    Provider_CCN,
    CalculateWeightedAverage(
        SUM(Total_PPS_Payment_full_episodes_periods_without_outliers * Total_PPS_Payment_PEP_episodes_periods), 
        SUM(Total_PPS_Payment_PEP_episodes_periods)
    ) AS Weighted_Average
FROM 
    CostReporthha_2020
GROUP BY 
    Provider_CCN;

-- UDF to calculate the year to year(yoy) change

DELIMITER //

CREATE FUNCTION CalculateYoYChange (CurrentYearValue DOUBLE, PreviousYearValue DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    IF PreviousYearValue = 0 THEN
        RETURN NULL;  -- Avoid division by zero
    ELSE
        RETURN ((CurrentYearValue - PreviousYearValue) / PreviousYearValue) * 100;
    END IF;
END //

DELIMITER ;

SELECT 
    a.Provider_CCN,
    CalculateYoYChange(
        b.Net_Income_or_Loss_for_the_period_line_18_plus_line_32, 
        a.Net_Income_or_Loss_for_the_period_line_18_plus_line_32
    ) AS Net_Income_YoY_Change
FROM 
    CostReporthha_2020 a
JOIN 
    CostReporthha_2021 b
ON a.Provider_CCN = b.Provider_CCN;


















