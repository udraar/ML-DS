----------------------------------------------------------------------------------------------------------------------------------
--	Database creation	--
----------------------------------------------------------------------------------------------------------------------------------
CREATE database rg_db_hive_case_study;

----------------------------------------------------------------------------------------------------------------------------------
--	Use the DB	--
----------------------------------------------------------------------------------------------------------------------------------
USE rg_db_hive_case_study;

----------------------------------------------------------------------------------------------------------------------------------
--	Addition of hcatalog jar	--
----------------------------------------------------------------------------------------------------------------------------------

ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-hcatalog-core-1.1.0-cdh5.11.2.jar;

----------------------------------------------------------------------------------------------------------------------------------
--	RAW table creation	--
----------------------------------------------------------------------------------------------------------------------------------

--	Below is the header in the csv file. We will use this header record to create the file even though the column order in this is not matching with that of the data dictionary.
--	 VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount

CREATE EXTERNAL TABLE IF NOT EXISTS rg_db_hive_case_study.raw_taxi_data(
`VendorID` int,
`tpep_pickup_datetime` timestamp,
`tpep_dropoff_datetime` timestamp,
`Passenger_count` int,
`Trip_distance` decimal(10,2),
`RatecodeID` int,
`Store_and_fwd_flag` string,
`PULocationID` int,
`DOLocationID` int,
`Payment_type` int,
`Fare_amount` decimal(10,2),
`Extra` decimal(10,2),
`MTA_tax` decimal(10,2),
`Tip_amount` decimal(10,2),
`Tolls_amount` decimal(10,2),
`Improvement_surcharge` decimal(10,2),
`Total_amount` decimal(10,2)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/common_folder/nyc_taxi_data/'
tblproperties ("skip.header.line.count"="1");

VendorID,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,RatecodeID,store_and_fwd_flag,PULocationID,DOLocationID,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount

--	Basic Sanity Check

SELECT * FROM rg_db_hive_case_study.raw_taxi_data LIMIT 10;

SELECT COUNT(*) as totCnt FROM rg_db_hive_case_study.raw_taxi_data;

--	Output
--	totCnt
--	1174569


----------------------------------------------------------------------------------------------------------------------------------
--	Data Quality Checks --
--	1. How many records has each TPEP provider provided?
----------------------------------------------------------------------------------------------------------------------------------

SELECT VendorID, COUNT(*) as VendorRecCnt
FROM rg_db_hive_case_study.raw_taxi_data
GROUP BY VendorID;

--	Output
--	vendorid	vendorreccnt
--	2			647183
--	1			527386

--	Observations:
--	1. As mentioned in data dictionary, there are only 2 TPEP provider.
--	2. VendorID 1 has 527,386 and 2 has 647,183 number of records.


----------------------------------------------------------------------------------------------------------------------------------
--	Data Quality Checks --
--	2. Date range of the data provided
----------------------------------------------------------------------------------------------------------------------------------

--	Check for any NULL values either for pickup time or dropoff time
SELECT COUNT(*) as rec_cnt FROM rg_db_hive_case_study.raw_taxi_data WHERE tpep_pickup_datetime IS NULL or tpep_dropoff_datetime IS NULL;
--	Output
--	rec_cnt
--	0

--	Check for distribution of data with respect to pickup year and pickup month
SELECT  YEAR(tpep_pickup_datetime) as PickUp_Yr, MONTH(tpep_pickup_datetime) as PickUp_Mon, COUNT(*) as rec_Cnt
FROM rg_db_hive_case_study.raw_taxi_data
GROUP BY YEAR(tpep_pickup_datetime), MONTH(tpep_pickup_datetime)
ORDER BY PickUp_Yr, PickUp_Mon;

--	Output
--	pickup_yr	pickup_mon		rec_cnt
--	2003		1				1
--	2008		12				2
--	2009		1				1
--	2017		10				6
--	2017		11				580300
--	2017		12				594255
--	2018		1				4

--	Check for distribution of data with respect to dropoff year and dropoff month
SELECT  YEAR(tpep_dropoff_datetime) as DropOff_Yr, MONTH(tpep_dropoff_datetime) as DropOff_Mon, COUNT(*) as rec_Cnt
FROM rg_db_hive_case_study.raw_taxi_data
GROUP BY YEAR(tpep_dropoff_datetime), MONTH(tpep_dropoff_datetime)
ORDER BY DropOff_Yr, DropOff_Mon;

--	Output
--	dropoff_yr	dropoff_mon		rec_cnt
--	2003		1				1
--	2008		12				1
--	2009		1				2
--	2017		10				2
--	2017		11				580053
--	2017		12				594399
--	2018		1				110
--	2019		4				1


--	Observations:
--	1. As per the problem statement, data was provided for the months of November and December. Even though most of the records are for these 2 months of 2017, there are many records which do not belong to that time duration.
--	2. Looking at pickup and dropoff data set distribution, there are definitely some inconsistencies. 1 record is having dropoff time on april, 2019 but no pickup time on march, 2019.


--	Check for inconsistencies in trip duration 
SELECT COUNT(*) as rec_cnt, DATEDIFF(tpep_dropoff_datetime, tpep_pickup_datetime) as duration, tpep_dropoff_datetime, tpep_pickup_datetime FROM rg_db_hive_case_study.raw_taxi_data
WHERE DATEDIFF(tpep_dropoff_datetime, tpep_pickup_datetime)>1
GROUP BY DATEDIFF(tpep_dropoff_datetime, tpep_pickup_datetime), tpep_dropoff_datetime, tpep_pickup_datetime;

--	Output
--	rec_cnt		duration	tpep_dropoff_datetime	tpep_pickup_datetime
--	1			526			2019-04-24 19:21:00.0	2017-11-14 13:50:00.0

--	Observations:
--	There are definitely inconsistencies with respect to trip duration at least for 1 record


--	Check if pickup time is equal or later than the dropoff time
SELECT COUNT(*) FROM rg_db_hive_case_study.raw_taxi_data WHERE CAST(tpep_pickup_datetime as TIMESTAMP) >= CAST(tpep_dropoff_datetime as TIMESTAMP);
--	Output
--	rec_cnt
--	6555


--	Observations:
--	1. Data is not consistent for 6555 records. For these records the pickup time is either same or later compared to dropoff time, which is not possible in real world unless there is a time travel :)


--	Check for records in total that do not fall in the desired time duration
--	In ideal scenario, pickup time should be in November-2017 and December-2017 and dropoff time should be in November-2017, December-2017 and January-2018 (in case the trip starts on 31st December-2017 but ends in 1st January-2018)
SELECT COUNT(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  CAST(tpep_pickup_datetime AS TIMESTAMP) < CAST('2017-11-01 00:00:00' AS TIMESTAMP)
        OR CAST(tpep_dropoff_datetime AS TIMESTAMP) >= CAST('2018-01-02 00:00:00' AS TIMESTAMP)
        OR CAST(tpep_dropoff_datetime AS TIMESTAMP) <= CAST(tpep_pickup_datetime AS TIMESTAMP);

--	Output
--	rec_cnt
--	6566

--	Observations:
--	Data is not consistent with respect to pickup and dropoff time for all together 6566 records

----------------------------------------------------------------------------------------------------------------------------------
--	Data Quality Checks --
--	3. Comparision of vendor with respect to quality of data
----------------------------------------------------------------------------------------------------------------------------------

------------------------------------------
--	Passenger count checks
------------------------------------------
SELECT vendorid, passenger_count, count(*) rec_cnt FROM rg_db_hive_case_study.raw_taxi_data
GROUP BY vendorid, passenger_count
ORDER BY passenger_count, vendorid;

--	Output
--	vendorid	passenger_count		rec_cnt
--	1			0					6813
--	2			0					11
--	1			1					415346
--	2			1					412153
--	1			2					74640
--	2			2					102232
--	1			3					18710
--	2			3					31983
--	1			4					11310
--	2			4					13641
--	1			5					361
--	2			5					54207
--	1			6					205
--	2			6					32941
--	1			7					1
--	2			7					11
--	2			8					3
--	2			9					1


--	Observations:
--	1. There are more than 6k records with passenger count as 0. Passenger count 0 is unusual and vendor id 1(Creative Mobile Technologies, LLC) does a poor job in handling this.
--	2. There are records where passenger count is 7, 8 and 9, which too is unusual considering this data is for taxi service. Even though number of such records are low, all of these records came from vendor id 2(VeriFone Inc).

------------------------------------------
--	Trip distance checks
------------------------------------------
SELECT vendorid, max(trip_distance) as max, min(trip_distance) as min, avg(trip_distance) as avg
FROM rg_db_hive_case_study.raw_taxi_data
GROUP BY vendorid;

--	Output
--	vendorid	max			min		avg
--	2			126.41		0		2.949732
--	1			102.4		0		2.774791

--	Observations:
--	1. There are records for which the trip distance is 0. This is inconsistent data. We will check further to determine which vendor id doing bad in handling such data.
--	2. There are records for which the trip distance is more than 40 miles. This is unusual as average trip distance is around 3 miles and radius of New York City is 20 miles.

--	Additional checks for trip distance 0 miles or trip distance more than 40 miles
SELECT t.vendorid as vendorid, t.trip_distance_catg as trip_distance, COUNT(*) as rec_cnt
FROM   (SELECT vendorid,
               CASE
                 WHEN trip_distance = 0 THEN '0'
                 WHEN trip_distance > 40 THEN '40+'
                 ELSE 'Normal'
               END AS trip_distance_catg
        FROM   rg_db_hive_case_study.raw_taxi_data
        WHERE  trip_distance = 0 OR trip_distance > 40) t
GROUP  BY t.vendorid, t.trip_distance_catg
ORDER BY t.trip_distance_catg, t.vendorid;

--	Output
--	vendorid	trip_distance	rec_cnt
--	1			0				4217
--	2			0				3185
--	1			40+				43
--	2			40+				65

-- Observations:
--	1. Both the vendor did almost equally poor job in handling inconsistencies in trip distance
--	2. Vendor 1(Creative Mobile Technologies, LLC) did bad job in handling records with trip distance 0 whereas vendor 2(VeriFone Inc) did bad job in handling records with trip distance more than 40 miles

------------------------------------------
--	PickUp/DropOff Location checks
------------------------------------------
SELECT vendorid, count(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  pulocationid IS NULL
GROUP  BY vendorid;

--	Output
--	No records

SELECT vendorid, count(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  dolocationid IS NULL
GROUP  BY vendorid;

--	Output
--	No records

--	Check for non-integer value
SELECT COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  pulocationid- CAST(pulocationid AS INT) != 0;
--	Output
--	rec_cnt
--	0

SELECT COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  dolocationid - CAST(dolocationid AS INT) != 0;
--	Output
--	rec_cnt
--	0

--	Observations:
--	Both pickup and dropoff location id looks fine from the initial analysis


------------------------------------------
--	RatecodeID checks
------------------------------------------
SELECT vendorid, ratecodeid, COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid, ratecodeid
ORDER  BY ratecodeid, vendorid;

--	Output
--	Nonconformity in RatecodeID column

SELECT vendorid, ratecode, COUNT(*) AS rec_cnt
FROM   (SELECT vendorid,
               CASE
                 WHEN ratecodeid IN ( 1, 2, 3, 4, 5, 6 ) THEN '1-6'
                 ELSE 'Others'
               END AS RateCode
        FROM   rg_db_hive_case_study.raw_taxi_data)t
GROUP  BY t.vendorid, t.ratecode
ORDER  BY t.ratecode, t.vendorid;

-- Output
--	vendorid	ratecode	rec_cnt
--	1			1-6			527378
--	2			1-6			647182
--	1			Others		8
--	2			Others		1

--	Observations:
--	1. As per data dictionary, allowed values for the column are 1,2,3,4,5,6. But from the analysis we can see there 9 records for which the values do not follow the restriction
--	2. vendor 2(VeriFone Inc) does a poorer job in handling this(8 records)


------------------------------------------
--	Store_and_fwd_flag checks
------------------------------------------
SELECT vendorid, store_and_fwd_flag, COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid, store_and_fwd_flag
ORDER  BY vendorid;

--	Output
--	VendorID	Store_and_fwd_flag	rec_cnt
--	1			N					523435
--	1			Y					3951
--	2			N					647183

--	Observations:
--	1. Vendor 2 does not have any Y value for the column.
--	2. Either vendor 2 served the areas where network connectivty always good or vendor 1 used devices that may have malfunctioned and lost connectivty with the server

------------------------------------------
--	Payment_type checks
------------------------------------------
SELECT vendorid, payment_type, COUNT(*) AS rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid, payment_type
ORDER  BY payment_type, vendorid;

--	Output
--	vendorid	Payment_type	rec_cnt
--	1			1				353034
--	2			1				437222
--	1			2				166970
--	2			2				209404
--	1			3				5861
--	2			3				413
--	1			4				1521
--	2			4				144

--	Observations:
--	1. vendor 2 has more number credit card payment and very less number of disputes justifying the observations made in Store_and_fwd_flag checks
--	2. Vendor 1 had a significant number of trips ended in "No Charge" - Payment_type 3 signifying vendor 1 maye have given a high number of offers or coupon during the time


------------------------------------------
--	Fare_amount checks
------------------------------------------
SELECT vendorid,
       Max(fare_amount) AS max,
       Min(fare_amount) AS min,
       Avg(fare_amount) AS avg
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid;

--	Output
--	VendorID	max		min		avg
--	1			650		0		12.770913
--	2			488.5	-200	13.178338

SELECT vendorid,
       COUNT(*)         AS rec_cnt,
       Max(fare_amount) AS max,
       Min(fare_amount) AS min,
       Avg(fare_amount) AS avg
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  fare_amount < 0
GROUP  BY vendorid;

--	Output
--	VendorID	rec_cnt		max		min		avg
--	2			558			-2.5	-200	-8.812509

--	Observations:
--	1. There are around 558 records for which the fare_amount is negative which is a clear sign of data inconsistency.
--	2. All of the inconsistent records with respect to fare_amount are from vendor 2

------------------------------------------
--	Extra checks
------------------------------------------

--	As per data dictionary, the only possible values for this column are 0(no extra charges), $0.5 and $1
--	We will check for any other values as data inconsistencies
SELECT vendorid, extra, COUNT(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  extra NOT IN ( 0, 0.5, 1 )
GROUP  BY vendorid, extra
ORDER BY extra, vendorid;

--	Output
--	VendorID	extra	rec_cnt
--	1			-10.6	1
--	2			-4.5	5
--	2			-1		87
--	2			-0.5	193
--	2			0.3		36
--	2			0.8		15
--	2			1.3		13
--	1			1.5		2
--	1			2		1
--	1			4.5		1819
--	2			4.5		2683
--	2			4.8		1

--	Observations:
--	1. There are many records with inconsistent values in the column. Most of the inconsistent records are for vendor 2.
--	2. There are records for which the extra amounts are -1 and -0.5 which can be due error in data entry and can be corresponding to actual correct amounts 1 and 0.5 respectively.

------------------------------------------
--	MTA_tax checks
------------------------------------------
 
-- As per the data dictionary, the only possible values for this column are 0 and $0.5, all other values for the column will be teated as non-conformities.
SELECT vendorid, mta_tax, COUNT(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  mta_tax NOT IN ( 0, 0.5 )
GROUP  BY vendorid, mta_tax
ORDER  BY mta_tax, vendorid;

--	Output
--	VendorID	MTA_tax		rec_cnt
--	2			-0.5		544
--	2			3			3
--	1			11.4		1

--	Observations:
--	1. Vendor 1 has only one erroneous record
--	2. Vendor 2 has around 547 erroneous records


------------------------------------------
--	Improvement_surcharge checks
------------------------------------------

--	As per data dictionary, Improvement_surcharge can only have the values $0.3 and 0. We will treat all other values as non-conformities
SELECT vendorid, improvement_surcharge, COUNT(*) rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  improvement_surcharge NOT IN ( 0, 0.3 )
GROUP  BY vendorid, improvement_surcharge
ORDER  BY improvement_surcharge, vendorid;

--	Output
--	VendorID	Improvement_surcharge	rec_cnt
--	2			-0.3					558
--	2			1						4

--	Observations:
--	1. Vendor 1 did a really good job for this column. They do not have any erroneous value for this column
--	2. Vendor 2 have around 562 erroneous records of which 558 records are having the value -0.3 which can be due error while doing the data entry corresponding to the correct value of $0.3


------------------------------------------
--	Tip_amount checks
------------------------------------------
SELECT vendorid,
       Max(tip_amount) AS max,
       Min(tip_amount) AS min,
       Avg(tip_amount) AS avg
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid;

--	Output
--	VendorID	max		min		avg
--	1			265		0		1.808485
--	2			450		-1.16	1.8895

SELECT vendorid, COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  fare_amount < tip_amount
GROUP  BY vendorid;

--	Output
--	VendorID	rec_cnt
--	1			440
--	2			1110

--	Observations:
--	1. Query 1 output shows that there are records for which the tip amounts are negative, which is definitely erroneous.
--	2. Also the max tip amount values are also quite high for a tip.
--	3. The max values leads us to check if fare_amount is less than the tip_amount which very unusual and we can see that there are almost 1550 such unusual records most of which came from vendor 2.


------------------------------------------
--	Tolls_amount checks
------------------------------------------
SELECT vendorid,
       Max(tolls_amount) AS max,
       Min(tolls_amount) AS min,
       Avg(tolls_amount) AS avg
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid;

--	Output
--	VendorID	max		min		avg
--	1			895.89	0		0.307928
--	2			90		-5.76	0.343316

--	Observations:
--	1. There are records from vendor 2 for which the tolls_amount is negative which is erroneous.
--	2. The max values of the tolls_amount are also really high compared to the average tolls_amount.

------------------------------------------
--	Total_amount checks
------------------------------------------

SELECT vendorid,
       Max(total_amount) AS max,
       Min(total_amount) AS min,
       Avg(total_amount) AS avg
FROM   rg_db_hive_case_study.raw_taxi_data
GROUP  BY vendorid;

--	Output
--	VendorID	max		min		avg
--	1			928.19	0		16.004557
--	2			490.3	-200.8	16.533236

SELECT vendorid,
       Max(total_amount) AS max,
       Min(total_amount) AS min,
       Avg(total_amount) AS avg,
       COUNT(*) as rec_cnt
FROM   rg_db_hive_case_study.raw_taxi_data
WHERE  total_amount < 0
GROUP  BY vendorid;

--	Output
--	VendorID	max		min		avg			rec_cnt
--	2			-3.3	-200.8	-10.00638	558

--	Observations:
--	1. There are around 558 records from vendor 2 for which the total_amount charged is negative which is erroneous.
--	2. Max values of records seems too high for taxi trip in a city.


----------------------------------------------------------------------------------------------------------------------------------
--	Curated table creation --
----------------------------------------------------------------------------------------------------------------------------------

-- We will filter out all the erroneous records identified during data quality checks and create a curated table
CREATE TABLE rg_db_hive_case_study.curated_taxi_data AS
  SELECT *
  FROM   rg_db_hive_case_study.raw_taxi_data
  WHERE  CAST(tpep_pickup_datetime AS TIMESTAMP) >= CAST('2017-11-01 00:00:00' AS TIMESTAMP)
		 AND CAST(tpep_pickup_datetime AS TIMESTAMP) < CAST('2018-01-01 00:00:00' AS TIMESTAMP)
         AND CAST(tpep_dropoff_datetime AS TIMESTAMP) < CAST('2018-01-02 00:00:00' AS TIMESTAMP)
         AND CAST(tpep_dropoff_datetime AS TIMESTAMP) > CAST(tpep_pickup_datetime AS TIMESTAMP)
-- Filter for data error in PickUp/DropOff time columns
         AND passenger_count NOT IN ( 0, 7, 8, 9 )
-- Filter for passenger count
         AND trip_distance != 0 AND trip_distance <= 40
-- Filter for trip distance		 
         AND ratecodeid IN ( 1, 2, 3, 4, 5, 6 )
-- Filter for RateCodeID
         AND fare_amount > 0
-- Filter for fare amount
         AND extra IN ( 0, 0.5, 1 )
-- Filter for extra
         AND mta_tax IN ( 0, 0.5 )
-- Filter for mta_tax
         AND improvement_surcharge IN ( 0, 0.3 )
-- Filter for improvement_surcharge
         AND tip_amount >= 0 AND tip_amount <= fare_amount
-- Filter for tip amount
         AND tolls_amount >= 0
-- Filter for toll amount
         AND total_amount >= 0;
-- Filter for total_amount

----------------------------------------------------------------------------------------------------------------------------------
--	Vendor data accuracy calculation --
----------------------------------------------------------------------------------------------------------------------------------
SELECT Round(t3.v1_curat_cnt * 100 / t3.v1_orig_cnt,2) AS v1_accuracy,
       Round(t3.v2_curat_cnt * 100 / t3.v2_orig_cnt,2) AS v2_accuracy
FROM   (SELECT Sum(CASE
                     WHEN t1.vendorid = 1 THEN t1.vendorreccnt
                     ELSE 0
                   END) AS v1_orig_cnt,
               Sum(CASE
                     WHEN t2.vendorid = 1 THEN t2.vendorreccnt
                     ELSE 0
                   END) AS v1_curat_cnt,
               Sum(CASE
                     WHEN t1.vendorid = 2 THEN t1.vendorreccnt
                     ELSE 0
                   END) AS v2_orig_cnt,
               Sum(CASE
                     WHEN t2.vendorid = 2 THEN t2.vendorreccnt
                     ELSE 0
                   END) AS v2_curat_cnt
        FROM   (SELECT vendorid, COUNT(*) AS VendorRecCnt
                FROM   rg_db_hive_case_study.raw_taxi_data
                GROUP  BY vendorid) t1
               JOIN (SELECT vendorid, COUNT(*) AS VendorRecCnt
                     FROM   rg_db_hive_case_study.curated_taxi_data
                     GROUP  BY vendorid)t2
                 ON t1.vendorid = t2.vendorid)t3 

--	Output
--	v1_accuracy		v2_accuracy
--	97.34			98.81

--	Observations:
--	Overall We can see vendor 2 did a better job in providing accurate data. They have nearly 99% accuracy in raw data while vendor 1 had 97% accuracy


------------------------------------------
--	Setting Partition Parameters
------------------------------------------
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.exec.max.dynamic.partitions = 1000;
SET hive.exec.max.dynamic.partitions.pernode = 1000;

------------------------------------------
--	Choosing partition key
------------------------------------------

--	1. There are few analysis pointer for which we need to compare between the two months data. So months can be a candidate for partition keys. Year is not required as we have data for 2017 only.
--	2. We can choose VendorID as secondary partition key column to improve the query performance for which we want to compare the vendors

------------------------------------------
--	Partitioned table creation
------------------------------------------

CREATE TABLE IF NOT EXISTS rg_db_hive_case_study.partitioned_taxi_data(
`tpep_pickup_datetime` timestamp,
`tpep_dropoff_datetime` timestamp,
`Passenger_count` int,
`Trip_distance` decimal(10,2),
`RatecodeID` int,
`Store_and_fwd_flag` string,
`PULocationID` int,
`DOLocationID` int,
`Payment_type` int,
`Fare_amount` decimal(10,2),
`Extra` decimal(10,2),
`MTA_tax` decimal(10,2),
`Tip_amount` decimal(10,2),
`Tolls_amount` decimal(10,2),
`Improvement_surcharge` decimal(10,2),
`Total_amount` decimal(10,2)
)
PARTITIONED BY (mon int, VendorID int)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

------------------------------------------
--	Data insertion into Partitioned table
------------------------------------------
INSERT OVERWRITE TABLE rg_db_hive_case_study.partitioned_taxi_data PARTITION(mon, VendorID)
SELECT 
`tpep_pickup_datetime`,
`tpep_dropoff_datetime`,
`Passenger_count`,
`Trip_distance`,
`RatecodeID`,
`Store_and_fwd_flag`,
`PULocationID`,
`DOLocationID`,
`Payment_type`,
`Fare_amount`,
`Extra`,
`MTA_tax`,
`Tip_amount`,
`Tolls_amount`,
`Improvement_surcharge`,
`Total_amount`,
month(`tpep_pickup_datetime`) mon,
`VendorID`
FROM  rg_db_hive_case_study.curated_taxi_data;


----------------------------------------------------------------------------------------------------------------------------------
--	Analysis-I --
----------------------------------------------------------------------------------------------------------------------------------

------------------------------------------
--	1. Compare the overall average fare per trip for November and December
------------------------------------------

SELECT mon,
       Round(Avg(total_amount), 2),
       Round(Avg(fare_amount), 2)
FROM   rg_db_hive_case_study.partitioned_taxi_data
GROUP  BY mon;

--	Output
--	mon		tot_fare_amt_avg	fare_amt_avg
--	12		15.87				12.69
--	11		16.17				12.89

--	Observations:
--	1. Month of Novemeber seems to be better comparing both the fare columns
--	2. For the month of November, the average total fare is more than that of December compared to fare amount. This may have happen due to higher amount in tax and surcharges in November

------------------------------------------
--	2. Explore the 'number of passengers per trip' - how many trips are made by each level of 'Passenger_count'? Do most people travel solo or with other people?
------------------------------------------
SELECT t1.passenger_count,
       t1.trip_cnt,
       Round(t1.trip_cnt * 100 / t2.tot_cnt, 2) trip_perct
FROM   (SELECT passenger_count, COUNT(*) AS trip_cnt
        FROM   rg_db_hive_case_study.partitioned_taxi_data
        GROUP  BY passenger_count)t1
       CROSS JOIN
	   (SELECT COUNT(*) tot_cnt
	    FROM   rg_db_hive_case_study.partitioned_taxi_data)t2
ORDER  BY 3 desc;

--	Output
--	passenger_count		trip_cnt	trip_perct
--	1					816476		70.82
--	2					174674		15.15
--	5					53993		4.68
--	3					50147		4.35
--	6					32865		2.85
--	4					24666		2.14

--	Observations:
--	Above analysis shows that most people travel solo. 2nd most popular travel pattern is travelling in pair or as couple.


------------------------------------------
--	3. Which is the most preferred mode of payment?
------------------------------------------
SELECT t1.Payment_type,
       t1.type_cnt,
       Round(t1.type_cnt * 100 / t2.tot_cnt, 2) payment_type_perct
FROM   (SELECT Payment_type, COUNT(*) AS type_cnt
        FROM   rg_db_hive_case_study.partitioned_taxi_data
        GROUP  BY Payment_type)t1
       CROSS JOIN
	   (SELECT COUNT(*) tot_cnt
	    FROM   rg_db_hive_case_study.partitioned_taxi_data)t2
ORDER  BY 3 desc;

--	Output
--	Payment_type	type_cnt	payment_type_perct
--	1				778399		67.52
--	2				368635		31.98
--	3				4487		0.39
--	4				1300		0.11

--	Observations:
--	1. Above analysis shows that payment type 1 i.e. payment via credit card is the most preferred payment option - nearly 68%
--	2. 2nd most preferred payment option is payment by cash - nearly 32%


------------------------------------------
--	4. What is the average tip paid per trip?
------------------------------------------
SELECT Percentile_approx(tip_amount, Array(0.25, 0.5, 0.75, 1)) AS
       percentile_tip,
       Avg(tip_amount) as avg
FROM   rg_db_hive_case_study.partitioned_taxi_data;

--	Output
--	percentile_tip		avg
--	[0,1.36,2.45,130]	1.816848

--	Observations:
--	1. The 25th, 50th and 75th percentile of tip amount of are $0, $1.36 and $2.45 respectively.
--	2. The average tip amount is $1.82
--	3. The tip amount values are highly skewed. More than 25% values are 0 with the median value(50th percentile) is 1.36.
--	4. Max tip amount($130) is clearly an outlier as it is really high compared to the median and explains why average is much higher than the median
--	5. We can easily draw the conclusion that 'average tip' is not a true representative statistic as it got pulled towards the higher side coz of the outlier on the higher side.
--	6. The median value or the 50th percentile value is more suitable representative statistic of 'tip amount paid'.


------------------------------------------
--	5. Explore the 'Extra' (charge) variable - what fraction of total trips have an extra charge is levied?
------------------------------------------

SELECT t1.extra_applied_cnt, Round(t1.extra_applied_cnt * 100 / t2.tot_cnt, 2) AS extra_applied_perct,
       t1.extra_levied_cnt, Round(t1.extra_levied_cnt * 100 / t2.tot_cnt, 2)  AS extra_levied_perct
FROM   (SELECT Sum(CASE WHEN extra > 0 THEN 1 ELSE 0 END) AS extra_applied_cnt,
               Sum(CASE WHEN extra = 0 THEN 1 ELSE 0 END) AS extra_levied_cnt
        FROM   rg_db_hive_case_study.partitioned_taxi_data)t1
       CROSS JOIN
	   (SELECT COUNT(*) tot_cnt FROM   rg_db_hive_case_study.partitioned_taxi_data)t2 

--	Output
--	extra_applied_cnt	extra_applied_perct		extra_levied_cnt	extra_levied_perct
--	531955				46.14					620866				53.86

--	Observations:
--	1. Around 54% of total trip had extra charge levied
--	2. Distribution of data with extra levied and with extra charges applied are nearly even



----------------------------------------------------------------------------------------------------------------------------------
--	Analysis-II --
----------------------------------------------------------------------------------------------------------------------------------

------------------------------------------
--	1. What is the correlation between the number of passengers on any given trip, and the tip paid per trip?
------------------------------------------

SELECT round(corr(passenger_count, tip_amount), 4) as corr
FROM   rg_db_hive_case_study.partitioned_taxi_data; 

--	Output
--	corr
--	-0.0055

--	Observations:
--	1. Passenger count and tip amount has a correlation value of negative .0055 which is very low.
--	2. We can say that passenger count and tip amount are 2 unrelated column and hence its not possible to draw any conclusion whether multiple travellers tip more compared to solo travellers.

--	Lets check if the relationship changes if we only consider the records when there was a tip amount
SELECT Round(Corr(t.passenger_count, t.tip_amount), 4) AS corr
FROM   (SELECT * FROM   rg_db_hive_case_study.partitioned_taxi_data WHERE  tip_amount > 0) t 

--	Output
--	corr
--	0.0122

--	Observations:
--	1. Now passenger count and tip amount has a correlation value of positive 0.0122 which is also very low.
--	2. Even though the correlation value is higher than the previous case its not good enough to draw any strong relationship between the two columns. They are not related.

------------------------------------------
--	2. Segregate the data into five segments of 'tip paid': [0-5), [5-10), [10-15) , [15-20) and >=20. Calculate the percentage share of each bucket
------------------------------------------

SELECT t1.tip_bucket, Round(t1.bucket_cnt * 100 / t2.tot_cnt, 2) AS bucket_perct
FROM   (SELECT t.tip_bucket AS tip_bucket, COUNT(*) AS bucket_cnt
        FROM   (SELECT CASE
                         WHEN tip_amount >= 0 AND tip_amount < 5 THEN '[0-5)'
                         WHEN tip_amount >= 5 AND tip_amount < 10 THEN '[5-10)'
                         WHEN tip_amount >= 10 AND tip_amount < 15 THEN '[10-15)'
                         WHEN tip_amount >= 15 AND tip_amount < 20 THEN '[15-20)'
                         WHEN tip_amount >= 20 THEN '>=20'
                       END AS tip_bucket
                FROM   rg_db_hive_case_study.partitioned_taxi_data)t
        GROUP  BY t.tip_bucket)t1
       CROSS JOIN
	   (SELECT COUNT(*) tot_cnt FROM   rg_db_hive_case_study.partitioned_taxi_data)t2
ORDER  BY 2 desc

--	Output
--	tip_bucket	bucket_perct
--	[0-5)		92.46
--	[5-10)		5.62
--	[10-15)		1.67
--	[15-20)		0.18
--	>=20		0.07

--	Observations:
--	1. Above analysis shows that the bucket [0-5) has the maximum share, more than 92%
--	2. 2nd best share is for the next bucket i.e. [5-10)
--	3. This analysis also validates our conclusion of tip amount being highly skewed in Analysis-I


------------------------------------------
--	3. Which month has a greater average 'speed' - November or December? 
------------------------------------------
SELECT mon, concat(cast(Round(Avg(trip_distance / ( ( Unix_timestamp(tpep_dropoff_datetime) - Unix_timestamp(tpep_pickup_datetime) )/ 3600 )), 2) as STRING), ' mph') avg_speed
FROM   rg_db_hive_case_study.partitioned_taxi_data
GROUP  BY mon
ORDER  BY mon;

--	Output
--	mon		avg_speed
--	11		10.96 mph
--	12		11.05 mph

--	Observations:
--	1. Above analysis shows that average speed was a little higher in the month of December compared to that of November


------------------------------------------
--	4. Analyse the average speed of the most happening days of the year, i.e. 31st December (New year's eve) and 25th December (Christmas) and compare it with the overall average
------------------------------------------

SELECT t1.dy,
       t1.avg_speed,
       Round(( t1.avg_speed - t2.avg_speed ) * 100 / t2.avg_speed, 2)
       perct_increase
FROM   (SELECT t.dy AS dy,
               Round(Avg(t.trip_distance / ((Unix_timestamp(t.tpep_dropoff_datetime) - Unix_timestamp(t.tpep_pickup_datetime))/3600 )), 2) avg_speed
        FROM   (SELECT Day(tpep_pickup_datetime) dy, trip_distance, tpep_pickup_datetime, tpep_dropoff_datetime
                FROM   rg_db_hive_case_study.partitioned_taxi_data
                WHERE  mon = 12)t
        WHERE  dy IN ( 25, 31 )
        GROUP  BY dy)t1
       CROSS JOIN
	   (SELECT Round(Avg(trip_distance /((Unix_timestamp(tpep_dropoff_datetime) - Unix_timestamp(tpep_pickup_datetime))/3600 )), 2) avg_speed FROM rg_db_hive_case_study.partitioned_taxi_data)t2
ORDER  BY 1

--	Output
--	dy	avg_speed	perct_increase
--	25	15.26		38.6
--	31	13.24		20.25


--	Observations
--	1. Average speed on the most happening days of the year are much higher compared to overall average
--	2. Average speed on Christmas is nearly 39% higher and on New year’s eve it's more than 21% higher compared to overall average