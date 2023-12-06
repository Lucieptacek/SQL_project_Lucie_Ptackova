/*Výzkumná otázka č.2:
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */

/*Vyhledání prvního a posledního srovnatelného období v dostupných datech cen a mezd*/
SELECT *	
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN (111301, 114201)
ORDER BY pcft.date_from_year, pcft.name;

SELECT *	
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN (111301, 114201)
ORDER BY pcft.date_from_year DESC, pcft.name;


/*Vyfiltrovala jsem si pouze nejnižší možné období - rok 2006, nevyšší možné období - rok 2018 pro Chléb konzumní kmínový a Mléko polotučné pasterované */
SELECT 
	pcft.category_code,
	pcft.date_from_year,
	pcft.category_code,
	pcft.name,
	pcft.price_value,
	pcft.price_unit
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN ('111301', '114201')
	AND 	(pcft.date_from_year = 2006 OR 
		pcft.date_from_year = 2018)
GROUP BY pcft.date_from_year, pcft.category_code  
ORDER by pcft.category_code, pcft.date_from_year;


/*Zjistila jsem si průměrnou mzdu za nejnižší možné období (tzn. rok 2006) průměrem ze všech odvětví A-S. Průměrná mzda ze všech odvětví v nejnižším možném období činí 21 165,18 Kč.*/
/*Zjistila jsem si průměrnou mzdu za nejvyšší možné období (tzn. rok 2018) průměrem ze všech odvětví A-S. Průměrná mzda ze všech odvětví v nejvyšším možném období činí 33 091,45 Kč.*/
SELECT
	pft.industry_branch_code,
	pft.payroll_name,
	pft.payroll_year,
	ROUND(AVG(pft.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi
FROM payroll_final_table pft
WHERE pft.payroll_year IN (2006, 2018)
GROUP BY pft.payroll_year;


/*Ceny mléka a chleba dohromady v jedné tabulce*/
SELECT 	
	pcft.date_from_year,
	pcft.name,
	pcft.price_value,
	pcft.price_unit,
	pcft.avg_price AS průmerna_cena
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN ('111301','114201')
	AND pcft.date_from_year IN (2006, 2018)
	GROUP BY pcft.date_from_year, pcft.name   
	ORDER BY pcft.date_from_year, pcft.name ;


/*Propojení tabulek cen a mezd dohromady*/
SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf.name,
	tlppspf.price_value,
	tlppspf.price_unit,
	ROUND(AVG(tlppspf.avg_price),2) AS prumer_cena,
	ROUND(AVG(tlppspf.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi,
	ROUND((AVG(tlppspf.avg_sallary) / AVG(tlppspf.avg_price)),2) AS kolik_muzu_koupit_ks
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	WHERE tlppspf.category_code IN ('111301','114201')
	AND tlppspf.date_from_year IN (2006, 2018)
	AND tlppspf.payroll_year IN (2006, 2018)
	GROUP BY tlppspf.date_from_year, tlppspf.name 
	ORDER BY tlppspf.name, tlppspf.date_from_year;