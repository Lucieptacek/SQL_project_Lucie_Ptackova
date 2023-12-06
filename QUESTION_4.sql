/*Výzkumná otázka č.4:
 * Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/
SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf.name,
	tlppspf.price_value,
	tlppspf.price_unit,
	ROUND(AVG(tlppspf.avg_price),2) AS prumerna_rocni_cena_potravin,
	tlppspf.payroll_name,
	tlppspf.payroll_year,
	ROUND(AVG(tlppspf.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	GROUP BY tlppspf.date_from_year, tlppspf.name 
	ORDER BY tlppspf.name, tlppspf.date_from_year;

/*Napojení tabulky samu na sebe kvůli roku-1 a dosazení sloupečku o posunutý rok směrem nahoru*/
SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf2.date_from_year AS date_from_plus1,
	tlppspf.name,
	tlppspf.price_value,
	tlppspf.price_unit,
	ROUND(AVG(tlppspf.avg_price),2) AS prumerna_rocni_cena_potravin,
	ROUND(AVG(tlppspf2.avg_price),2) AS prumerna_rocni_cena_potravin_PLUS1,
	tlppspf.payroll_name,
	tlppspf.payroll_year,
	tlppspf2.payroll_year AS payroll_year_plus1,
	ROUND(AVG(tlppspf.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi,
	ROUND(AVG(tlppspf2.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi_PLUS1
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year, tlppspf.name 
	ORDER BY tlppspf.name, tlppspf.date_from_year;
	 
/*Výpočet procentuálního meziročního nárustu/poklesu cen potravin a mezd.*/
	SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf2.date_from_year AS date_from_plus1,
	tlppspf.name,
	ROUND(AVG(tlppspf.avg_price),2) AS prueěrna_rocni_cena_potravin,
	ROUND(AVG(tlppspf2.avg_price),2) AS prumerna_rocni_cena_potravin_PLUS1,
	ROUND((((AVG(tlppspf2.avg_price) / AVG(tlppspf.avg_price) * 100) - 100)),2) AS procentual_rust_cen,
	tlppspf.payroll_name,
	tlppspf.payroll_year,
	tlppspf2.payroll_year AS payroll_year_plus1,
	ROUND(AVG(tlppspf.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi,
	ROUND(AVG(tlppspf2.avg_sallary),2) AS prumerna_rocni_mzda_ze_vsech_odvetvi_PLUS1,
	ROUND(((AVG(tlppspf2.avg_sallary) / AVG(tlppspf.avg_sallary) * 100) - 100),2) AS procentual_rust_mezd
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year, tlppspf.name 
	ORDER BY tlppspf.name, tlppspf.date_from_year;
	
/*Filtrace pouze sloupců s procentualnim narustem/poklesem cen potravin a mezd*/
SELECT
	tlppspf.date_from_year AS old_year,
	tlppspf2.date_from_year AS new_year,
	ROUND((((AVG(tlppspf2.avg_price) / AVG(tlppspf.avg_price) * 100) - 100)),2) AS '%YEARLY_food_price_difference',
	ROUND(((AVG(tlppspf2.avg_sallary) / AVG(tlppspf.avg_sallary) * 100) - 100),2) AS '%YEARLY_sallary_difference',
	ROUND((((AVG(tlppspf2.avg_price) / AVG(tlppspf.avg_price) * 100) - 100)),2) - (ROUND(((AVG(tlppspf2.avg_sallary) / AVG(tlppspf.avg_sallary) * 100) - 100),2)) AS prices_sallary_difference
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year;