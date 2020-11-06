/* DB Schmea creation */

CREATE DATABASE `assignment`;
USE `assignment`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Required Table Creation */

/* Table to store raw data of Bajaj Auto */
DROP TABLE IF EXISTS `assignment`.`bajaj_auto`;
CREATE TABLE `assignment`.`bajaj_auto` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/* Table to store raw data of Eicher Motors */
DROP TABLE IF EXISTS `assignment`.`eicher_motors`;
CREATE TABLE `assignment`.`eicher_motors` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/* Table to store raw data of Hero Motocorp */
DROP TABLE IF EXISTS `assignment`.`hero_motocorp`;
CREATE TABLE `assignment`.`hero_motocorp` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/* Table to store raw data of Infosys */
DROP TABLE IF EXISTS `assignment`.`infosys`;
CREATE TABLE `assignment`.`infosys` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/* Table to store raw data of TCS */
DROP TABLE IF EXISTS `assignment`.`tcs`;
CREATE TABLE `assignment`.`tcs` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/* Table to store raw data of TVS Motors */
DROP TABLE IF EXISTS `assignment`.`tvs_motors`;
CREATE TABLE `assignment`.`tvs_motors` (
  `date` text,
  `Open Price` double DEFAULT NULL,
  `High Price` double DEFAULT NULL,
  `Low Price` double DEFAULT NULL,
  `Close Price` double DEFAULT NULL,
  `WAP` double DEFAULT NULL,
  `No.of Shares` int(11) DEFAULT NULL,
  `No. of Trades` int(11) DEFAULT NULL,
  `Total Turnover (Rs.)` double DEFAULT NULL,
  `Deliverable Quantity` int(11) DEFAULT NULL,
  `% Deli. Qty to Traded Qty` double DEFAULT NULL,
  `Spread High-Low` double DEFAULT NULL,
  `Spread Close-Open` double DEFAULT NULL
) DEFAULT CHARSET=utf8mb4;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Table to store moving average data of Bajaj Auto */
DROP TABLE IF EXISTS `assignment`.`bajaj1`;
CREATE TABLE `assignment`.`bajaj1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Table to store moving average data of TCS */
DROP TABLE IF EXISTS `assignment`.`TCS1`;
CREATE TABLE `assignment`.`TCS1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Table to store moving average data of TVS Motors */
DROP TABLE IF EXISTS `assignment`.`TVS1`;
CREATE TABLE `assignment`.`TVS1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Table to store moving average data of Infosys */
DROP TABLE IF EXISTS `assignment`.`Infosys1`;
CREATE TABLE `assignment`.`Infosys1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Table to store moving average data of Eicher Motors */
DROP TABLE IF EXISTS `assignment`.`Eicher1`;
CREATE TABLE `assignment`.`Eicher1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Table to store moving average data of Hero Motocorp */
DROP TABLE IF EXISTS `assignment`.`Hero1`;
CREATE TABLE `assignment`.`Hero1` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `20 Day MA` double DEFAULT NULL,
  `50 Day MA` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Master table to store closing stock price data for all the 6 stocks */
DROP TABLE IF EXISTS `assignment`.`master`;
CREATE TABLE `assignment`.`master` (
  `date` date NOT NULL,
  `Bajaj` double DEFAULT NULL,
  `TCS` double DEFAULT NULL,
  `TVS` double DEFAULT NULL,
  `Infosys` double DEFAULT NULL,
  `Eicher` double DEFAULT NULL,
  `Hero` double DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Buy and Sell signal Table for Bajaj */
DROP TABLE IF EXISTS `assignment`.`bajaj2`;
CREATE TABLE `assignment`.`bajaj2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Buy and Sell signal Table for Eicher */
DROP TABLE IF EXISTS `assignment`.`eicher2`;
CREATE TABLE `assignment`.`eicher2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Buy and Sell signal Table for Hero */
DROP TABLE IF EXISTS `assignment`.`hero2`;
CREATE TABLE `assignment`.`hero2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Buy and Sell signal Table for Infosys */
DROP TABLE IF EXISTS `assignment`.`infosys2`;
CREATE TABLE `assignment`.`infosys2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Buy and Sell signal Table for TCS */
DROP TABLE IF EXISTS `assignment`.`tcs2`;
CREATE TABLE `assignment`.`tcs2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/* Buy and Sell signal Table for TVS */
DROP TABLE IF EXISTS `assignment`.`tvs2`;
CREATE TABLE `assignment`.`tvs2` (
  `date` date NOT NULL,
  `Close Price` double DEFAULT NULL,
  `Signal` text DEFAULT NULL,
  PRIMARY KEY (`Date`)
) DEFAULT CHARSET=utf8mb4;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* RAW Data Ingestion:
   1) Raw data can be ingested directly into the tables using the import wizard as an one time activity.
   2) Raw data ingestion process can be automated using the following script if required.
   
	LOAD DATA LOCAL INFILE 'Bajaj Auto.csv' 
	INTO TABLE `assignment`.`bajaj_auto` 
	FIELDS TERMINATED BY ',' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
   
   In this case data was ingested using the import data wizard option of MySQL Workbench,
   as we had limited number of source files for which we were mainly required to do analysis of stock price.
*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Data Analysis */

/* Date range analysis in each raw data source.
   Though it is mentioned that data is present for the range 1-Jan-2015 to 31-July-2018, let us confirm the same for each raw table.
*/

/* Date range for Bajaj Auto data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM bajaj_auto;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Date range for Eicher Motors data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM eicher_motors;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Date range for Hero Motocorp data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM hero_motocorp;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Date range for TVS Motors data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM tvs_motors;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Date range for Infosys data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM infosys;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Date range for TCS data */
SELECT MIN(STR_TO_DATE(date,'%d-%M-%Y')) AS min_date, MAX(STR_TO_DATE(date,'%d-%M-%Y')) AS max_date, count(*) AS row_cnt FROM tcs;
/* Output */
-- 2015-01-01	2018-07-31	888

/* Observation:
	1) All the raw source are having data for the same date range as mentioned in the problem statement i.e. 1-Jan-2015 to 31-July-2018
	2) All the raw source are having number of rows
*/

/* Number of days in the date range */
SELECT DATEDIFF(MAX(STR_TO_DATE(date,'%d-%M-%Y')), MIN(STR_TO_DATE(date,'%d-%M-%Y')))+1 AS NoOfDays FROM bajaj_auto;
/* Output */
-- 1308

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Observation:
	1) Even though number of rows in each source is 888, there are altogether 1308 days within the max and min date
	2) There are few dates for which we dont have any stock price data
	3) We need to create another table with all the date values in the range. This table will be used as reference for calculation of moving average
*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Calendar table creation. This table will have all the reference dates. */
CREATE TABLE `assignment`.`calendar` (dt DATE NOT NULL PRIMARY KEY);

/* Calendar reference data creation */
INSERT INTO `assignment`.`calendar`
WITH Intvl(i) AS (
SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
)
SELECT DATE('2015-01-01') + INTERVAL a.i*1000 + b.i*100 + c.i*10 + d.i DAY FROM Intvl a JOIN Intvl b JOIN Intvl c JOIN Intvl d
WHERE (a.i*1000 + b.i*100 + c.i*10 + d.i) < 1308 ORDER BY 1;

/* Sample output from Calendar table */
SELECT MIN(dt), MAX(dt), COUNT(*) FROM `assignment`.`calendar`;
/* Output */
-- 2015-01-01	2018-07-31	1308


/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/


/* Moving average data population */

/* Data population for bajaj1 */
INSERT INTO `assignment`.`bajaj1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`Bajaj_Auto` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/* Data population for eicher1 */
INSERT INTO `assignment`.`eicher1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`eicher_motors` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/* Data population for hero1 */
INSERT INTO `assignment`.`hero1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`hero_motocorp` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/* Data population for infosys1 */
INSERT INTO `assignment`.`infosys1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`infosys` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/* Data population for tcs1 */
INSERT INTO `assignment`.`tcs1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`tcs` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/* Data population for tvs1 */
INSERT INTO `assignment`.`tvs1`
WITH curated_data (date, close_price) AS (
    SELECT c.dt AS date,`Close Price` AS close_price FROM `assignment`.`tvs_motors` b RIGHT JOIN `assignment`.`calendar` c ON STR_TO_DATE(b.date,'%d-%M-%Y') = c.dt
) 
SELECT date, close_price,
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 19 PRECEDING AND 0 FOLLOWING),2),
ROUND(AVG(close_price) OVER (ORDER BY date ASC ROWS BETWEEN 49 PRECEDING AND 0 FOLLOWING),2)
FROM curated_data;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Master table population */
INSERT INTO `assignment`.`master`(date, Bajaj, TCS, TVS, Infosys, Eicher, Hero)
SELECT c.dt, b.`Close Price` AS Bajaj, tc.`Close Price` AS TCS, tv.`Close Price` AS TVS, i.`Close Price` AS Infosys, e.`Close Price` AS Eicher, h.`Close Price` AS Hero
FROM `assignment`.`calendar` c
LEFT JOIN `assignment`.`bajaj1` b ON c.dt = b.date
LEFT JOIN `assignment`.`eicher1` e  ON c.dt = e.date
LEFT JOIN `assignment`.`hero1` h ON c.dt = h.date
LEFT JOIN `assignment`.`infosys1` i ON c.dt = i.date
LEFT JOIN `assignment`.`tcs1` tc ON c.dt = tc.date
LEFT JOIN `assignment`.`tvs1` tv ON c.dt = tv.date;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Bajaj2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`bajaj2`
SELECT date, `Close Price`,
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`bajaj1`;

/* Eicher2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`eicher2`
SELECT date, `Close Price`, 
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`eicher1`;

/* Hero2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`hero2`
SELECT date, `Close Price`, 
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`hero1`;

/* Infosys2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`infosys2`
SELECT date, `Close Price`, 
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`infosys1`;

/* TCS2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`tcs2`
SELECT date, `Close Price`, 
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`tcs1`;

/* TVS2 table population - Buy and Sell signal */
INSERT INTO `assignment`.`tvs2`
SELECT date, `Close Price`, 
CASE
    WHEN `20 Day MA` > `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) < lag(`50 Day MA`,1) over(order by date) THEN "BUY"
    WHEN `20 Day MA` < `50 Day MA` and lag(`20 Day MA`, 1) over(order by date) > lag(`50 Day MA`,1) over(order by date) THEN "SELL"
    ELSE "HOLD"
END AS `Signal`
FROM `assignment`.`tvs1`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* User defined functions for determining Signal of Bajaj Stock */
DELIMITER $$
CREATE FUNCTION BajajStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`bajaj2` WHERE date = dt);    
END; $$
DELIMITER ;

/* User defined functions for determining Signal of Eicher Stock */
DELIMITER $$
CREATE FUNCTION EicherStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`eicher2` WHERE date = dt);    
END; $$
DELIMITER ;

/* User defined functions for determining Signal of Hero Stock */
DELIMITER $$
CREATE FUNCTION HeroStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`hero2` WHERE date = dt);    
END; $$
DELIMITER ;

/* User defined functions for determining Signal of Infosys Stock */
DELIMITER $$
CREATE FUNCTION InfosysStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`infosys2` WHERE date = dt);    
END; $$
DELIMITER ;

/* User defined functions for determining Signal of TCS Stock */
DELIMITER $$
CREATE FUNCTION TCSStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`tcs2` WHERE date = dt);    
END; $$
DELIMITER ;

/* User defined functions for determining Signal of TVS Stock */
DELIMITER $$
CREATE FUNCTION TVSStockSignal(dt Date)
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN	
	RETURN(SELECT `signal` FROM `assignment`.`tvs2` WHERE date = dt);    
END; $$
DELIMITER ;
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/