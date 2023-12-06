/*Tvorba finální tabulky pro průměrné mzdy ve sledovaném období v letech 2006 až 2018.*/
CREATE OR REPLACE TABLE Payroll_final_table AS
SELECT 
	cp.payroll_year,
	cp.industry_branch_code,
	cpib.name AS payroll_name,
	ROUND(AVG(cp.value),2) AS avg_sallary
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
	WHERE value IS NOT NULL
	AND unit_code = '200'
	AND value_type_code = 5958
	AND calculation_code = '200'
GROUP BY cp.payroll_year, cpib.name
ORDER BY cp.payroll_year, cp.industry_branch_code;


/*Tvorba finální tabulky pro ceny potravin ve sledovaném období v letech 2006 až 2018.*/
CREATE OR REPLACE TABLE Price_category_final_table AS
SELECT
	YEAR(cp.date_from) AS date_from_year,
	cp.category_code,
	cpc.name,
	ROUND(AVG(cp.value),2) AS avg_price,
	cpc.price_value,
	cpc.price_unit 
FROM czechia_price cp
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL 
GROUP BY YEAR(cp.date_from), cpc.name 
ORDER BY cpc.name, YEAR(cp.date_from);

/*Tvorba finální PRIMARY tabulky*/
CREATE OR REPLACE TABLE T_Lucie_Ptackova_Project_SQL_primary_Final AS
SELECT
	*
FROM payroll_final_table pft  
JOIN price_category_final_table pcft 
	ON pft.payroll_year = pcft.date_from_year;