/*This is the process to update our dimensional model*/
/*Set foreign keys to 0, truncate tables*/
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE TABLE Stock_Covid19.date_dim;
TRUNCATE TABLE Stock_Covid19.unemp_dim;
TRUNCATE TABLE Stock_Covid19.location_dim;
TRUNCATE TABLE Stock_Covid19.fact_table;
TRUNCATE TABLE Stock_Covid19.covid19_dim;

/*First populate the date dimension*/
INSERT INTO Stock_Covid19.date_dim(Date_String, Day, Week, Month, Year, Quarter, Week_Ending) 

SELECT  distinct
str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')  AS 'Date_String',
Day(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')) as Day,
Week(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')) as Week,
Month(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')) as Month,
YEAR(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')) as Year,
Quarter(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d')) as Quarter,
date_add(date_add(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d'), interval  -WEEKDAY(str_to_date(stock_data.date_table.date_string,'%Y-%m-%d'))-1 day), interval 6 day) as 'Week_Ending'
FROM stock_data.date_table
ORDER BY Week_Ending;

SELECT * FROM Stock_Covid19.date_dim;

/*Next update the S&P 500 dimension, called sp_dim*/
INSERT INTO Stock_Covid19.sp_dim(date_string, day_performance, week_end) 

SELECT  distinct
stock_data.sp_data.DATE AS 'date_string',
stock_data.sp_data.sp500 AS 'day_performance',
stock_data.sp_data.week_ending AS 'week_end'
FROM stock_data.sp_data
ORDER by date DESC;

/*Now update the coronavirus information weekly by state into covid19_dim*/
INSERT INTO Stock_Covid19.covid19_dim(case_number, deaths, state, week_ending) 

SELECT  distinct
MAX(stock_data.corona_cases.cases) AS 'case_number',
MAX(stock_data.corona_cases.deaths) AS 'deaths',
stock_data.corona_cases.state AS 'state',
stock_data.corona_cases.week_ending AS 'week_ending'
FROM stock_data.corona_cases
GROUP BY week_ending, state
ORDER by week_ending DESC;

SELECT * FROM Stock_Covid19.covid19_dim;

/*Update the location dimension*/
INSERT INTO Stock_Covid19.location_dim(state) 

SELECT  distinct
stock_data.loc_table.state_name AS 'state'
FROM stock_data.loc_table;

SELECT * FROM Stock_Covid19.location_dim;

/*Update the unemployment dimension with weekly state numbers*/
INSERT INTO Stock_Covid19.unemp_dim(state, Week_End, Initial_Claims, Unemp_Rate, Total_Claims) 

SELECT  distinct
stock_data.unemployment.State_Name AS 'state',
stock_data.unemployment.Week_End_Formatted AS 'Week_End',
MAX(stock_data.unemployment.Initial_Claims) AS 'Initial_Claims',
MAX(stock_data.unemployment.Unemp_Rate) AS 'Unemp_Rate',
MAX(stock_data.unemployment.Total_Continued_Claims) AS 'Total_Claims'
FROM stock_data.unemployment
GROUP BY Week_End, state
ORDER by Week_End DESC;
SELECT * FROM Stock_Covid19.unemp_dim;

/*Now update the fact table*/
INSERT INTO Stock_Covid19.fact_table(date_key, location_key, covid19_key, unemp_key, sp_key, Week_Ending, state, Initial_Claims, Total_Unemp, case_number, death_number, avg_performance) 

SELECT  distinct
Stock_Covid19.date_dim.date_key AS date_key,
Stock_Covid19.location_dim.location_id AS location_key,
Stock_Covid19.covid19_dim.covid_key AS covid19_key,
Stock_Covid19.unemp_dim.unemp_id AS unemp_key,
Stock_Covid19.sp_dim.sp_id AS sp_key,
Stock_Covid19.date_dim.Week_Ending AS Week_Ending,
Stock_Covid19.location_dim.state AS state,
Stock_Covid19.unemp_dim.Initial_Claims AS Initial_Claims,
Stock_Covid19.unemp_dim.Total_Claims AS Total_Unemp,
Stock_Covid19.covid19_dim.case_number AS case_number,
Stock_Covid19.covid19_dim.deaths AS death_number,
AVG(Stock_Covid19.sp_dim.day_performance) AS avg_performance
FROM Stock_Covid19.covid19_dim
LEFT JOIN Stock_Covid19.date_dim ON Stock_Covid19.date_dim.Week_Ending = Stock_Covid19.covid19_dim.week_ending
LEFT JOIN Stock_Covid19.unemp_dim ON Stock_Covid19.date_dim.Week_Ending = Stock_Covid19.unemp_dim.Week_End 
LEFT JOIN Stock_Covid19.location_dim ON Stock_Covid19.covid19_dim.state = Stock_Covid19.location_dim.state AND Stock_Covid19.unemp_dim.state = Stock_Covid19.location_dim.state
LEFT JOIN Stock_Covid19.sp_dim ON Stock_Covid19.date_dim.Week_Ending = Stock_Covid19.sp_dim.week_end
GROUP BY Week_Ending, state
ORDER BY Week_Ending DESC;

/*Check our results and reset foreign key checks to 1*/
SELECT * FROM Stock_Covid19.fact_table;
SET FOREIGN_KEY_CHECKS = 1; 