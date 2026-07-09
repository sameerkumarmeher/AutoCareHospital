-- Q1 Total Discharges
SELECT COUNT(*) AS Total_Discharges
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE'


-- Q2 Average Daily Discharge Rate
-- It is total discharges divided by the total lenght of stay
SELECT (SELECT COUNT(*) AS Total_Discharges
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE')/(SELECT SUM(DURATION_OF_STAY) FROM HospitalAdmission_VW) AS Avg_DailyDischargeRate
-- Casting
SELECT 
	CAST(
		CAST((SELECT COUNT(*) AS Total_Discharges
		FROM HospitalAdmission_VW
		WHERE OUTCOME = 'DISCHARGE') AS FLOAT)
		/CAST((SELECT SUM(DURATION_OF_STAY) FROM HospitalAdmission_VW) AS FLOAT)
	AS DECIMAL(10,2) )* 100 AS Avg_DailyDischargeRate
-- Avoiding Subsquery
SELECT
	ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
	SUM(DURATION_OF_STAY), 2) * 100 AS Avg_DischargeRate
FROM HospitalAdmission_VW
	

--Q3 Average Length of Stay (ALOS)
-- It is Total length of stay divide by Total Discharges. 
-- Basically reversing calculation of Q2.
SELECT 
	SUM(DURATION_OF_STAY)/SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1 ELSE 0 END) AS Avg_length_of_Stay
FROM HospitalAdmission_VW


--Q4 Distribution of discharges by Age Group
-- <16 Paediatric
-- <65 Adult
-- >= 65 Senior Citizen
SELECT 
	CASE 
		WHEN AGE < 16 THEN 'Paediatric'
		WHEN AGE < 65 THEN 'Adult'
		WHEN AGE >= 65 THEN 'Senior Citizen'
		ELSE 'Unknown'
	END AS Age_Group, COUNT(*) AS Distribution
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE'
GROUP BY CASE 
		WHEN AGE < 16 THEN 'Paediatric'
		WHEN AGE < 65 THEN 'Adult'
		WHEN AGE >= 65 THEN 'Senior Citizen'
		ELSE 'Unknown'
	END
ORDER BY 2 DESC

--Q5 Distribution of discharges by Gender Discharges 
SELECT GENDER, COUNT(*) AS Distribution
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER
ORDER BY 2 DESC

--Q6 Distribution of discharges by day of the week
SELECT DATEPART(WEEKDAY,D_O_D) AS Day_of_Week, COUNT(*) AS Distribution
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE'
GROUP BY DATEPART(WEEKDAY,D_O_D)
ORDER BY 2 DESC

--Using Format to get day of the week name

SELECT FORMAT(D_O_D, 'ddd') AS Day_of_Week, COUNT(*) AS Distribution
FROM HospitalAdmission_VW
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D, 'ddd')
ORDER BY 2 DESC