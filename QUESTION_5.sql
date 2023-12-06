/*Výzkumná otázka č.5:
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/

/*Tvorba pohledu VIEW pro HDP pro Českou republiku v letech 2006 - 2018*/
CREATE OR REPLACE VIEW v_lucie_ptackova_secondary_gdp_cr_2006_2018 AS
SELECT *
FROM t_lucie_ptackova_project_sql_secondary_final tlppssf 
WHERE country = 'Czech Republic';

/*Tvorba pohledu VIEW s přidáním sloupečků year +1, HDP +1, procentuální vyjádření rozdílů mezi roky.*/
CREATE OR REPLACE VIEW v_lucie_ptackova_secondary_gdp_cr_2006_2018_plus1 AS
SELECT 
	vlpsgc.`year` AS old_year,
	vlpsgc2.`year` AS new_year,
	vlpsgc.GDP AS old_gdp,
	vlpsgc2.GDP AS new_gdp,
	ROUND(AVG(vlpsgc2.GDP - vlpsgc.GDP) / vlpsgc.GDP * 100,2) AS 'GDP_percent_difference' 
FROM v_lucie_ptackova_secondary_gdp_cr_2006_2018 vlpsgc 
	JOIN v_lucie_ptackova_secondary_gdp_cr_2006_2018 vlpsgc2 
		ON vlpsgc.country = vlpsgc2.country 
		AND vlpsgc.year = vlpsgc2.year -1
GROUP BY vlpsgc.`year`;

/*Sloučení předchozího pohledu VIEW vlpsgcp s finální tabulkou z ukolu č. 4*/
SELECT
	tlppspf.date_from_year AS old_year,
	tlppspf2.date_from_year AS new_year,
	vlpsgcp.GDP_percent_difference AS '%YEARLY_GDP_difference',
	ROUND((((AVG(tlppspf2.avg_price) / AVG(tlppspf.avg_price) * 100) - 100)),2) AS '%YEARLY_food_price_difference',
	ROUND(((AVG(tlppspf2.avg_sallary) / AVG(tlppspf.avg_sallary) * 100) - 100),2) AS '%YEARLY_sallary_difference'
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
	JOIN v_lucie_ptackova_secondary_gdp_cr_2006_2018_plus1 vlpsgcp  
		ON tlppspf.payroll_year = vlpsgcp.old_year 
	JOIN v_lucie_ptackova_secondary_gdp_cr_2006_2018_plus1 vlpsgcp2 
		ON vlpsgcp.old_year = vlpsgcp2.old_year 
		AND tlppspf2.payroll_year = vlpsgcp.new_year 
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year;