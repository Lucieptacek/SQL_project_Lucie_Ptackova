/*Tvorba finální SECONDARY tabulky - pro HDP, Gini, economies, country*/
CREATE OR REPLACE TABLE t_lucie_ptackova_project_SQL_secondary_final AS 
SELECT 
	c.country,
	e.`year`,
	e.population, 
	e.gini,
	e.GDP	
FROM countries c
JOIN economies e 
	ON e.country = c.country
	WHERE c.continent = 'Europe'
	AND e.`year` BETWEEN 2006 AND 2018;