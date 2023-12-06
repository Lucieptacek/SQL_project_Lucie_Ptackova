/*Výzkumná otázka č.1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/

/*Propojení Finální primární tabulky pomocí JOIN samu na sebe. Poté zoobrazení sloupců se všemi odvětvími za jednotlivé roky. 
 * Kde je porovnání průměrného ročního platu starého roku s průměrným ročním platem nového rokem všech odvětví.*/
WITH Final_table_Question1 AS (
	SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		ROUND(((((tlppspf2.avg_sallary) / (tlppspf.avg_sallary))) * 100 - 100),2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.payroll_name, tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name, tlppspf.payroll_year 	
) 
SELECT * 
FROM Final_table_Question1;


/*WITH pomocná tabulka, kde je nastavena podmínka, že se mi zobrazí pouze ty odvětví, kde byl pokles mzdy v následujícím roce.*/
WITH Final_table_Question1 AS (
	SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		ROUND(((((tlppspf2.avg_sallary) / (tlppspf.avg_sallary))) * 100 - 100),2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.payroll_name, tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name, tlppspf.payroll_year 	
) 
SELECT *
FROM Final_table_Question1
WHERE new_yearly_sum_value < old_yearly_sum_value; --- podmínka, že se mi zobrazí pouze ty odvětví, kde byl pokles mzdy v následujícím roce


CREATE OR REPLACE VIEW Final_table_Industry_percentage AS (
SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		ROUND(((((tlppspf2.avg_sallary) / (tlppspf.avg_sallary))) * 100 - 100),2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.payroll_name, tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name, tlppspf.payroll_year);


/*Zobrazení procentuálního vyjádření za jednotlivá odvětví za celé sledované období*/
SELECT 
	payroll_name,
	ROUND(AVG(`%YEARLY_sallary_difference`),2) AS '%Total_sallary_status'
FROM final_table_industry_percentage ftip 
GROUP BY payroll_name
ORDER BY (ROUND(AVG(`%YEARLY_sallary_difference`),2)) DESC;