create database portfolio_projects;
use portfolio_projects;

SELECT * FROM coral;

# DATA ANALYSIS
  
# 1. Total Bleaching Events by Region
SELECT 
    Country_Name, 
    Ecoregion_Name, 
    COUNT(*) AS Total_Bleaching_Events
FROM coral
WHERE Percent_Bleaching > 0
GROUP BY Country_Name, Ecoregion_Name
ORDER BY Total_Bleaching_Events DESC; 
 

# 2. Average Temperature During Bleaching Events

SELECT 
    AVG(Temperature_Kelvin) AS Avg_Temperature_During_Bleaching
FROM coral
WHERE Percent_Bleaching > 0;

# 3. Correlation Between SSTA and Bleaching
 
 SELECT 
    CASE 
        WHEN SSTA < -2 THEN 'Low (-2 or below)'
        WHEN SSTA BETWEEN -2 AND 0 THEN 'Moderate (-2 to 0)'
        WHEN SSTA BETWEEN 0 AND 2 THEN 'High (0 to 2)'
        ELSE 'Extreme (Above 2)'
    END AS SSTA_Category,
    AVG(Percent_Bleaching) AS Avg_Bleaching
FROM coral
GROUP BY SSTA_Category
ORDER BY SSTA_Category;
 
 # 4. Top 10 Most Affected Locations
  
  SELECT Ocean_Name,
    Latitude_Degrees, 
    Longitude_Degrees, 
    MAX(Percent_Bleaching) AS Max_Bleaching
FROM coral
GROUP BY Ocean_Name, Latitude_Degrees, Longitude_Degrees
ORDER BY Max_Bleaching DESC
LIMIT 10;

# 5.  Temporal Analysis of Bleaching Events
  
SELECT 
    Date_Year, 
    COUNT(*) AS Bleaching_Events
FROM coral
WHERE Percent_Bleaching > 0
GROUP BY Date_Year
ORDER BY Date_Year DESC;

 # 6. Seasonal Bleaching Trends
  
  SELECT 
    Date_Month, 
    AVG(Percent_Bleaching) AS Avg_Bleaching
FROM coral
GROUP BY Date_Month
ORDER BY Date_Month;
 
 # 7.  Environmental Factors' Impact on Bleaching
  
   SELECT 
    AVG(Windspeed) AS Avg_Windspeed,
    AVG(Turbidity) AS Avg_Turbidity,
    AVG(Temperature_Kelvin) AS Avg_Temperature
FROM coral
WHERE Percent_Bleaching > 0;

SELECT 
    AVG(Windspeed) AS Avg_Windspeed,
    AVG(Turbidity) AS Avg_Turbidity,
    AVG(Temperature_Kelvin) AS Avg_Temperature
FROM coral
WHERE Percent_Bleaching = 0;

# 8. High-Risk Temperature Threshold

SELECT 
    Temperature_Kelvin, 
    AVG(Percent_Bleaching) AS Avg_Bleaching
FROM coral
GROUP BY Temperature_Kelvin
ORDER BY Avg_Bleaching desc ;

# 9. Geographical Distribution of Bleaching

SELECT 
    ROUND(Latitude_Degrees, 1) AS Latitude,
    ROUND(Longitude_Degrees, 1) AS Longitude,
    COUNT(*) AS Bleaching_Events
FROM coral
WHERE Percent_Bleaching > 0
GROUP BY ROUND(Latitude_Degrees, 1), ROUND(Longitude_Degrees, 1)
ORDER BY Bleaching_Events DESC;
