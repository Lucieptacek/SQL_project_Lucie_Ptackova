/* Výzkumná otázka č. 3:
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/
SELECT 
	tlppspf.date_from_year AS date_from_year,
	tlppspf.name,
	tlppspf.price_value,
	tlppspf.price_unit,
	tlppspf.avg_price AS prumerna_cena_potravin_za_dany_rok
FROM t_lucie_ptackova_project_sql_primary_final tlppspf  
GROUP BY tlppspf.name, tlppspf.date_from_year
ORDER BY tlppspf.name, tlppspf.date_from_year;


/*Přidání sloupec rok-1*/
SELECT 
	tlppspf.date_from_year AS date_from_year,
	tlppspf2.date_from_year AS date_from_year_plus1,
	tlppspf.name,
	tlppspf.price_value,
	tlppspf.price_unit,
	tlppspf.avg_price AS 'prumerna_cena_potravin_za_dany_rok',
	tlppspf2.avg_price AS 'prumerna_cena_potravin_za_dany_rok_plus1',
	ROUND((((tlppspf2.avg_price * 100) / tlppspf.avg_price) - 100),2) AS procentualni_narust_pokles
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2  
	ON tlppspf.date_from_year = tlppspf2.date_from_year -1 	
	AND tlppspf.name = tlppspf2.name 
GROUP BY tlppspf.name, tlppspf.date_from_year 
ORDER BY tlppspf.name;

/*Finální tabulka s meziročním percentuálním poklesem/nárustem za dané potravinové kategorie. Seřazena vzestupně.*/
SELECT * 
FROM (
	SELECT
		ps.name,
		ROUND(AVG(ps.procentualni_narust_pokles),2) AS prumer_final
	FROM (
		SELECT 
			tlppspf.date_from_year AS date_from_year,
			tlppspf2.date_from_year AS date_from_year_plus1,
			tlppspf.name,
			tlppspf.price_value,
			tlppspf.price_unit,
			tlppspf.avg_price AS 'prumerna_cena_potravin_za_dany_rok',
			tlppspf2.avg_price AS 'prumerna_cena_potravin_za_dany_rok_plus1',
			ROUND((((tlppspf2.avg_price * 100) / tlppspf.avg_price) - 100),2) AS procentualni_narust_pokles
		FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
		JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2  
			ON tlppspf.date_from_year = tlppspf2.date_from_year -1
			AND tlppspf.name = tlppspf2.name 
		GROUP BY tlppspf.name, tlppspf.date_from_year 
		ORDER BY tlppspf.name, tlppspf.date_from_year
	) ps
GROUP BY ps.name
) ps2
ORDER BY ps2.prumer_final;