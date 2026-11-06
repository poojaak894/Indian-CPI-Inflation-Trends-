# Indian-CPI-Inflation-Trends
Project Overview

This project analyses Consumer Price Index (CPI) trends over eight months, from January to August 2026. It examines increases and decreases in CPI indices across groups, compares Rural and Urban inflation, and identifies groups with the highest and lowest average inflation rates.
Project Objectives
1.	Analyse monthly changes in the CPI Index across Rural, Urban, and Combined areas.
2.	Examine monthly inflation trends across CPI groups in Rural, Urban, and Combined areas.
3.	Compare Rural and Urban inflation differences across groups and months.
4.	Identify the groups with the highest and lowest average YoY inflation rates in Rural, Urban, and Combined areas.
Dataset

The dataset covers January to August 2026 and contains 344 records across 43 groups. It includes the following columns:
•	Month
•	Group Code
•	Group Name
•	Rural Index
•	Urban Index
•	Combined Index
•	Rural Inflation
•	Urban Inflation
•	Combined Inflation
The eight monthly datasets were combined using Power Query. The CPI Index uses 2024 as the base year, and the inflation figures represent year-on-year (YoY) changes. The data was collected from the Ministry of Statistics and Programme Implementation (MoSPI).
Tools Used

•	MySQL
•	Tableau
•	Microsoft Excel
Methodology

1.	Data Preparation: Combined the eight monthly datasets using Power Query and prepared the data for analysis.
2.	Database Setup: Created a database and table in MySQL, then imported the combined dataset.
3.	CPI Index Trend Analysis: Examined monthly index changes and classified groups as increasing, decreasing, or unchanged.
4.	Inflation Trend Analysis: Analysed monthly changes in Rural, Urban, and Combined inflation rates.
5.	Group Comparison: Compare Rural and Urban inflation differences across groups and months.
5.	Rural–Urban Comparison: Identify the groups with the highest and lowest average YoY inflation rates in Rural, Urban, and Combined areas.
6.	Visualization: Created a Tableau dashboard to present the trends, comparisons, and key findings.
Key Findings

1.	CPI Index Trends: By August 2026, all 43 groups showed an increase in the CPI Index in Rural and Combined areas, compared with 41 groups in Urban areas.
2.	Inflation Trends: From February to August, groups with increasing inflation generally became more numerous, while those with decreasing inflation declined across Rural, Urban, and    Combined areas. These counts reflect the direction of group-level inflation changes, not necessarily a rise in the overall inflation rate.
3.	Rural–Urban Differences and Group Extremes: Other personal effects recorded the highest average YoY inflation (53.19% Combined), while Purchase of vehicles recorded the lowest (−4.61% Combined). Rural inflation was consistently higher for Other personal effects, whereas Urban inflation was higher for Higher education from March to August.

