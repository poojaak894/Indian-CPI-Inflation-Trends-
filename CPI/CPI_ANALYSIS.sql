CREATE DATABASE CPI;
USE CPI;
CREATE TABLE CPI_DATA(
ID INT PRIMARY KEY,
Month DATE,
Group_Code VARCHAR(10),
Group_name VARCHAR(50),
Rural_Index DECIMAL(10,2),
Urban_Index DECIMAL(10,2),
Combined_Index DECIMAL(10,2),
Rural_Inflation DECIMAL(10,2),
Urban_Inflation DECIMAL(10,2),
Combined_Inflation DECIMAL(10,2));

ALTER TABLE CPI_DATA
MODIFY COLUMN Group_name VARCHAR(100);

SELECT MONTH, GROUP_NAME, RURAL_INDEX, URBAN_INDEX, COMBINED_INDEX,
RURAL_INDEX - LAG(RURAL_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC ) AS RURAL_CHANGE,
URBAN_INDEX - LAG(URBAN_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC ) AS URBAN_CHANGE,
COMBINED_INDEX - LAG(COMBINED_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC) AS COMBINED_CHANGE
FROM CPI_DATA
ORDER BY GROUP_NAME; 

WITH MONTHLY_CHANGE AS(
SELECT MONTH, GROUP_NAME, RURAL_INDEX, URBAN_INDEX, COMBINED_INDEX,
RURAL_INDEX - LAG(RURAL_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC ) AS RURAL_CHANGE,
URBAN_INDEX - LAG(URBAN_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC ) AS URBAN_CHANGE,
COMBINED_INDEX - LAG(COMBINED_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH ASC) AS COMBINED_CHANGE
FROM CPI_DATA)
SELECT MONTH, GROUP_NAME, RURAL_CHANGE,
CASE
	WHEN RURAL_CHANGE IS NULL THEN "No Previous Records"
    WHEN RURAL_CHANGE > 0 THEN "Increased"
    WHEN RURAL_CHANGE < 0 THEN "Decreased"
    ELSE "Unchanged"
END AS RURAL_TREND,
URBAN_CHANGE,
CASE
	WHEN URBAN_CHANGE IS NULL THEN "No Previous Records"
    WHEN URBAN_CHANGE > 0 THEN "Increased"
    WHEN URBAN_CHANGE < 0 THEN "Decreased"
    ELSE "Unchanged"
END AS URBAN_TREND,
COMBINED_CHANGE,
CASE
	WHEN COMBINED_CHANGE IS NULL THEN "No Previous Records"
    WHEN COMBINED_CHANGE > 0 THEN "Increased"
    WHEN COMBINED_CHANGE < 0 THEN "Decreased"
    ELSE "Unchanged"
END AS COMBINED_TREND
FROM MONTHLY_CHANGE
ORDER BY GROUP_NAME, MONTH;

WITH MONTHLY_CHANGE AS(
SELECT MONTH, GROUP_NAME, RURAL_INDEX, URBAN_INDEX, COMBINED_INDEX,
RURAL_INDEX - LAG(RURAL_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS RURAL_CHANGE,
URBAN_INDEX - LAG(URBAN_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS URBAN_CHANGE,
COMBINED_INDEX - LAG(COMBINED_INDEX) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS COMBINED_CHANGE
FROM CPI_DATA)
SELECT MONTH,
SUM(CASE WHEN RURAL_CHANGE > 0 THEN 1 ELSE 0 END) AS RURAL_INCREASED,
SUM(CASE WHEN RURAL_CHANGE < 0 THEN 1 ELSE 0 END) AS RURAL_DECREASED,
SUM(CASE WHEN RURAL_CHANGE = 0 THEN 1 ELSE 0 END) AS RURAL_UNCHANGED,

SUM(CASE WHEN URBAN_CHANGE > 0 THEN 1 ELSE 0 END) AS URBAN_INCREASED,
SUM(CASE WHEN URBAN_CHANGE < 0 THEN 1 ELSE 0 END) AS URBAN_DECREASED,
SUM(CASE WHEN URBAN_CHANGE = 0 THEN 1 ELSE 0 END) AS URBAN_UNCHANGED,

SUM(CASE WHEN COMBINED_CHANGE > 0 THEN 1 ELSE 0 END) AS COMBINED_INCREASED,
SUM(CASE WHEN COMBINED_CHANGE < 0 THEN 1 ELSE 0 END) AS COMBINED_DECREASED,
SUM(CASE WHEN COMBINED_CHANGE = 0 THEN 1 ELSE 0 END) AS COMBINED_UNCHANGED
FROM MONTHLY_CHANGE
GROUP BY MONTH
ORDER BY MONTH;

/*
- 	Rural areas: In February, 31 groups showed an increase in the CPI Index, 11 groups showed a decrease, and 1 group remained unchanged. 
    In March, the number of groups showing an increase rose to 36, while the number showing a decrease fell to 7. 
    From February to April, most groups showed an increase. From May to July, 41 groups showed an increase each month. 
    In August, all 43 groups showed an increase, with no decreases or unchanged values.
-	Urban areas: In February, 34 groups showed an increase, 7 showed a decrease, and 2 remained unchanged. 
    From February to May, the number of groups showing an increase was generally higher in urban areas than in rural areas. 
    In June and July, 41 groups showed an increase and 2 showed a decrease. The same pattern continued in August, with 41 groups showing an increase and 2 showing a decrease.
- 	Combined areas: In February, 32 groups showed an increase, 9 showed a decrease, and 2 remained unchanged. 
    In March, 38 groups showed an increase and 4 showed a decrease. In April, 39 groups showed an increase and 4 showed a decrease. 
    From May to July, 40–41 groups showed an increase, while 1–2 groups showed a decrease. In August, all 43 groups showed an increase, with no decreases or unchanged values.
- 	Overall observation: From February to August, the number of groups showing an increase generally rose, while the number showing a decrease generally fell. 
    These results describe changes in the CPI Index across categories, not the size of price increases.*/
    
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, COMBINED_INFLATION,
RURAL_INFLATION - LAG(RURAL_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS RURAL_CHANGE,
URBAN_INFLATION - LAG(URBAN_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS URBAN_CHANGE,
COMBINED_INFLATION - LAG(COMBINED_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS COMBINED_CHANGE
FROM CPI_DATA;

WITH MONTHLY_CHANGE AS(
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, COMBINED_INFLATION,
RURAL_INFLATION - LAG(RURAL_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS RURAL_INFLATION_CHANGE,
URBAN_INFLATION - LAG(URBAN_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS URBAN_INFLATION_CHANGE,
COMBINED_INFLATION - LAG(COMBINED_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS COMBINED_INFLATION_CHANGE
FROM CPI_DATA)
SELECT MONTH, GROUP_NAME,
CASE
	WHEN RURAL_INFLATION_CHANGE > 0 THEN 'Inflation increased'
    WHEN RURAL_INFLATION_CHANGE < 0 THEN 'Inflation decreased'
    WHEN RURAL_INFLATION_CHANGE IS NULL THEN 'No Previous Month'
    ELSE 'unchanged'
END AS RURAL_TREND,
CASE
	WHEN URBAN_INFLATION_CHANGE > 0 THEN 'Inflation increased'
    WHEN URBAN_INFLATION_CHANGE < 0 THEN 'Inflation decreased'
	WHEN URBAN_INFLATION_CHANGE IS NULL THEN 'No Previous Month'
    ELSE 'unchanged'
END AS URBAN_TREND,
CASE
	WHEN COMBINED_INFLATION_CHANGE > 0 THEN 'Inflation increased'
    WHEN COMBINED_INFLATION_CHANGE < 0 THEN 'Inflation decreased'
	WHEN COMBINED_INFLATION_CHANGE IS NULL THEN 'No Previous Month'
    ELSE 'unchanged'
END AS COMBINED_TREND
FROM MONTHLY_CHANGE
ORDER BY MONTH, GROUP_NAME;

WITH MONTHLY_CHANGE AS(
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, COMBINED_INFLATION,
RURAL_INFLATION - LAG(RURAL_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS RURAL_INFLATION_CHANGE,
URBAN_INFLATION - LAG(URBAN_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS URBAN_INFLATION_CHANGE,
COMBINED_INFLATION - LAG(COMBINED_INFLATION) OVER(PARTITION BY GROUP_NAME ORDER BY MONTH) AS COMBINED_INFLATION_CHANGE
FROM CPI_DATA)
SELECT MONTH,
SUM(CASE WHEN RURAL_INFLATION_CHANGE > 0 THEN 1 ELSE 0 END) AS RURAL_INCREASED,
SUM(CASE WHEN RURAL_INFLATION_CHANGE < 0 THEN 1 ELSE 0 END) AS RURAL_DECREASED,
SUM(CASE WHEN RURAL_INFLATION_CHANGE = 0 THEN 1 ELSE 0 END) AS RURAL_UNCHANGED,

SUM(CASE WHEN URBAN_INFLATION_CHANGE > 0 THEN 1 ELSE 0 END) AS URBAN_INCREASED,
SUM(CASE WHEN URBAN_INFLATION_CHANGE < 0 THEN 1 ELSE 0 END) AS URBAN_DECREASED,
SUM(CASE WHEN URBAN_INFLATION_CHANGE = 0 THEN 1 ELSE 0 END) AS URBAN_UNCHANGED,

SUM(CASE WHEN COMBINED_INFLATION_CHANGE > 0 THEN 1 ELSE 0 END) AS COMBINED_INCREASED,
SUM(CASE WHEN COMBINED_INFLATION_CHANGE < 0 THEN 1 ELSE 0 END) AS COMBINED_DECREASED,
SUM(CASE WHEN COMBINED_INFLATION_CHANGE = 0 THEN 1 ELSE 0 END) AS COMBINED_UNCHANGED
FROM MONTHLY_CHANGE
GROUP BY MONTH
ORDER BY MONTH;

/* 
 Monthly Inflation Trends (February–August 2026)
Rural areas: The number of groups with increasing inflation generally rose from 18 in February to 30 in August, although it fluctuated during the period. 
The number of groups with decreasing inflation fell from 23 in February to 10 in August. Only a few groups showed no change in their inflation rates.

Urban areas: The number of groups with increasing inflation rose from 11 in February to 30 in August. The number of groups with decreasing inflation fell from 30 to 13. 
Compared with rural areas, urban areas generally had fewer groups with increasing inflation and more groups with decreasing inflation during this period, 
although the difference varied by month.

Combined areas: The number of groups with increasing inflation rose from 13 in February to 32 in August.
Meanwhile, the number of groups with decreasing inflation fell from 27 to 11. The number of groups with unchanged inflation remained low throughout the period.

Overall observation: From February to August 2026, the number of groups with increasing inflation generally rose, while the number with decreasing inflation generally fell.
This shows changes in the direction of inflation rates across groups; it does not necessarily mean that the overall inflation rate increased.*/

SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, (RURAL_INFLATION - URBAN_INFLATION) AS Rural_Urban_inflation_differences
FROM CPI_DATA
ORDER BY MONTH;


WITH CHANGE_INFLATION AS(
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, (RURAL_INFLATION - URBAN_INFLATION) AS Rural_Urban_inflation_differences
FROM CPI_DATA)
SELECT MONTH, GROUP_NAME,
CASE
	WHEN Rural_Urban_inflation_differences > 0 THEN 'Rural inflation is higher'
    WHEN Rural_Urban_inflation_differences < 0 THEN 'Urban inflation is higher'
    WHEN Rural_Urban_inflation_differences = 0 THEN 'Both inflation rates are equal'
    END AS RURAL_URBAN_INFLATION_STATUS
FROM CHANGE_INFLATION 
ORDER BY MONTH, GROUP_NAME;

WITH CHANGE_INFLATION AS(
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, (RURAL_INFLATION - URBAN_INFLATION) AS Rural_Urban_inflation_differences
FROM CPI_DATA)
SELECT MONTH,
SUM(CASE WHEN Rural_Urban_inflation_differences > 0 THEN 1 else 0 END) AS RURAL_INFLATION_HIGHER_COUNT,
SUM( CASE WHEN Rural_Urban_inflation_differences < 0 THEN 1 else 0 END) AS URBAN_INFLATION_HIGHER_COUNT,
SUM(CASE WHEN Rural_Urban_inflation_differences = 0 THEN 1 else 0 END) AS EQUAL_INFLATION_COUNT
FROM CHANGE_INFLATION 
GROUP BY MONTH
ORDER BY MONTH;

/* During the first two months (February and March), more groups had higher Urban inflation than Rural inflation. 
From April onward, more groups had higher Rural inflation than Urban inflation.*/

WITH GROUP_DIFF AS (
SELECT MONTH, GROUP_NAME, RURAL_INFLATION, URBAN_INFLATION, RURAL_INFLATION - URBAN_INFLATION AS RURAL_URBAN_INFLATION_DIFFERENCE
FROM CPI_DATA)
SELECT MONTH, MAX(RURAL_URBAN_INFLATION_DIFFERENCE) AS MAX_INFLATION_DIFFERENCE,
			  MIN(RURAL_URBAN_INFLATION_DIFFERENCE) AS MIN_INFLATION_DIFFERENCE
FROM GROUP_DIFF
GROUP BY MONTH
ORDER BY MONTH;

WITH GROUP_DIFF AS(
SELECT MONTH, GROUP_NAME, RURAL_INFLATION - URBAN_INFLATION AS RURAL_URBAN_INFLATION_DIFFERENCE
FROM CPI_DATA),
MONTHLY_EXTREMES AS(
SELECT MONTH, MAX(RURAL_URBAN_INFLATION_DIFFERENCE) AS MAX_DIFFRENECE,
              MIN(RURAL_URBAN_INFLATION_DIFFERENCE) AS MIN_DIFFRENECE
FROM GROUP_DIFF
GROUP BY MONTH)
SELECT G.MONTH, G.GROUP_NAME, G.RURAL_URBAN_INFLATION_DIFFERENCE
FROM GROUP_DIFF G
JOIN MONTHLY_EXTREMES M USING(MONTH)
WHERE G.RURAL_URBAN_INFLATION_DIFFERENCE = M.MAX_DIFFRENECE
OR G.RURAL_URBAN_INFLATION_DIFFERENCE = M.MIN_DIFFRENECE
ORDER BY G.MONTH, G.GROUP_NAME;

/*Rural–Urban Inflation Differences: Key Findings

The analysis compares Rural and Urban inflation rates across CPI groups from January to August 2026.

- Urban inflation was higher for Garden products and pets in January and February, with differences of −3.63 and −3.50 percentage points, respectively.
- From March to August, Higher education consistently had the largest negative Rural–Urban inflation difference, ranging from −3.21 to −3.67 percentage points. 
  This indicates that inflation was higher in Urban areas for this group.
- Rural inflation was higher for Other personal effects throughout the entire period, with positive differences ranging from 6.72 to 10.18 percentage points.
- The positive difference for Other personal effects was largest in February (10.18 percentage points), 
  while the negative difference for Higher education was largest in August (−3.67 percentage points) among the months shown for that group.

  Overall, Other personal effects consistently showed a higher inflation rate in Rural areas, while the group with the greatest Urban inflation difference shifted from 
  Garden products and pets in January–February to Higher education from March onward.*/
  
SELECT GROUP_NAME, ROUND(AVG(RURAL_INFLATION),2) AS AVG_RURAL_INFLATION,
                   ROUND(AVG(URBAN_INFLATION),2) AS AVG_URBAN_INFLATION,
                   ROUND(AVG(COMBINED_INFLATION),2) AS AVG_COMBINED_INFLATION
FROM CPI_DATA
GROUP BY GROUP_NAME
ORDER BY GROUP_NAME;

WITH GROUP_AVG AS(
SELECT GROUP_NAME, ROUND(AVG(RURAL_INFLATION),2) AS AVG_RURAL_INFLATION,
                   ROUND(AVG(URBAN_INFLATION),2) AS AVG_URBAN_INFLATION,
                   ROUND(AVG(COMBINED_INFLATION),2) AS AVG_COMBINED_INFLATION
FROM CPI_DATA
GROUP BY GROUP_NAME)
SELECT
    MAX(AVG_RURAL_INFLATION) AS MAX_RURAL_AVG,
    MIN(AVG_RURAL_INFLATION) AS MIN_RURAL_AVG,
    MAX(AVG_URBAN_INFLATION) AS MAX_URBAN_AVG,
    MIN(AVG_URBAN_INFLATION) AS MIN_URBAN_AVG,
    MAX(AVG_COMBINED_INFLATION) AS MAX_COMBINED_AVG,
    MIN(AVG_COMBINED_INFLATION) AS MIN_COMBINED_AVG
FROM GROUP_AVG;


WITH GROUP_AVG AS (
    SELECT
        GROUP_NAME,
        ROUND(AVG(RURAL_INFLATION), 2) AS AVG_RURAL_INFLATION,
        ROUND(AVG(URBAN_INFLATION), 2) AS AVG_URBAN_INFLATION,
        ROUND(AVG(COMBINED_INFLATION), 2) AS AVG_COMBINED_INFLATION
    FROM CPI_DATA
    GROUP BY GROUP_NAME
),
HIGHEST_AND_LOWEST_AVG AS (
    SELECT
        MAX(AVG_RURAL_INFLATION) AS MAX_RURAL_AVG,
        MIN(AVG_RURAL_INFLATION) AS MIN_RURAL_AVG,
        MAX(AVG_URBAN_INFLATION) AS MAX_URBAN_AVG,
        MIN(AVG_URBAN_INFLATION) AS MIN_URBAN_AVG,
        MAX(AVG_COMBINED_INFLATION) AS MAX_COMBINED_AVG,
        MIN(AVG_COMBINED_INFLATION) AS MIN_COMBINED_AVG
    FROM GROUP_AVG
)
SELECT
    G.GROUP_NAME,
    G.AVG_RURAL_INFLATION,
    G.AVG_URBAN_INFLATION,
    G.AVG_COMBINED_INFLATION
FROM GROUP_AVG G
CROSS JOIN HIGHEST_AND_LOWEST_AVG H
WHERE G.AVG_RURAL_INFLATION IN (H.MAX_RURAL_AVG, H.MIN_RURAL_AVG)
   OR G.AVG_URBAN_INFLATION IN (H.MAX_URBAN_AVG, H.MIN_URBAN_AVG)
   OR G.AVG_COMBINED_INFLATION IN (H.MAX_COMBINED_AVG, H.MIN_COMBINED_AVG)
ORDER BY G.GROUP_NAME;

/*  Highest and Lowest Average YoY Inflation by group

From January to August 2026, Other personal effects recorded the highest average year-on-year (YoY) inflation among the identified groups. 
The average inflation rate was 56.93% in Rural areas, 48.46% in Urban areas, and 53.19% for the Combined area (Rural and Urban together). 
The average rate was 8.47 percentage points higher in Rural areas than in Urban areas.

In contrast, Purchase of vehicles recorded the lowest average YoY inflation among the identified groups. The average rate was −4.44% in Rural areas, 
−4.77% in Urban areas, and −4.61% for the Combined area. These negative averages indicate that prices in this group were lower, 
on average, than in the corresponding months of the previous year.

Overall, Other personal effects showed the highest average inflation, 
while Purchase of vehicles showed the lowest average inflation among the groups identified in this analysis.*/






