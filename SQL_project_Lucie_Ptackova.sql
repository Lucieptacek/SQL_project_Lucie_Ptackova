/*Tvorba finální tabulky pro průměrné mzdy ve sledovaném období v letech 2006 až 2018.*/
CREATE OR REPLACE TABLE Payroll_final_table AS
SELECT 
	cp.payroll_year ,
	cp.industry_branch_code,
	cpib.name AS payroll_name ,
	round(avg(cp.value), 2) AS avg_sallary
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
	WHERE value IS NOT NULL
	AND unit_code = '200'
	AND value_type_code = 5958
	AND calculation_code = '200'
GROUP BY cp.payroll_year, cpib.name
ORDER BY cp.payroll_year, cp.industry_branch_code  ;

SELECT *
FROM payroll_final_table ;


/*Tvorba finální tabulky pro ceny potravin ve sledovaném období v letech 2006 až 2018.*/
CREATE OR REPLACE TABLE Price_category_final_table AS
SELECT
	YEAR (cp.date_from) AS date_from_year,
	cp.category_code,
	cpc.name,
	round(avg(cp.value), 2) AS avg_price,
	cpc.price_value,
	cpc.price_unit 
FROM czechia_price cp
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL 
GROUP BY YEAR (cp.date_from ), cpc.name 
ORDER BY cpc.name, YEAR (cp.date_from );

SELECT *
FROM price_category_final_table ;

/*Tvorba finální PRIMARY tabulky*/
CREATE OR REPLACE TABLE T_Lucie_Ptackova_Project_SQL_primary_Final AS
SELECT
	*
FROM payroll_final_table pft  
JOIN price_category_final_table pcft 
	ON pft.payroll_year = pcft.date_from_year;

SELECT *
FROM t_lucie_ptackova_project_sql_primary_final tlppspf ;


/*Tvorba finální SECONDARY tabulky - pro HDP, Gini, economies, country*/

CREATE OR REPLACE TABLE t_lucie_ptackova_project_SQL_secondary_final AS 
SELECT 
	e.*	
FROM countries c
JOIN economies e 
	ON e.country = c.country
	WHERE c.continent = 'Europe'
	AND e.`year` BETWEEN 2006 AND 2018
;

SELECT * FROM t_lucie_ptackova_project_sql_secondary_final tlppssf ;


/*Výzkumné otázky
Otázka č.1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/


/*Propojení Finální primární tabulky pomocí JOIN samu na sebe. Poté zoobrazení sloupců se všemi odvětvími za jednotlivé roky. 
 * Kde je porovnání průměrného ročního platu starého roku s průměrným ročním platem nového rokem všech odvětví.*/
with Final_table_Question1 AS (
	SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		round( ((((tlppspf2.avg_sallary)/(tlppspf.avg_sallary)))*100 - 100), 2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	join t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name  = tlppspf2.payroll_name 
	group by tlppspf.payroll_name , tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name , tlppspf.payroll_year 	
) 
select * 
from Final_table_Question1;
	


with Final_table_Question1 AS (
	SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		round( ((((tlppspf2.avg_sallary)/(tlppspf.avg_sallary)))*100 - 100), 2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	join t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name  = tlppspf2.payroll_name 
	group by tlppspf.payroll_name , tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name , tlppspf.payroll_year 	
) 
select * 
from Final_table_Question1;

/*WITH pomocná tabulka, kde je nastavena podmínka, že se mi zobrazí pouze ty odvětví, kde byl pokles mzdy v následujícím roce.*/

with Final_table_Question1 AS (
	SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		round( ((((tlppspf2.avg_sallary)/(tlppspf.avg_sallary)))*100 - 100), 2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	join t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name  = tlppspf2.payroll_name 
	group by tlppspf.payroll_name , tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name , tlppspf.payroll_year 	
) 
select *
from Final_table_Question1
where new_yearly_sum_value < old_yearly_sum_value; --- podmínka, že se mi zobrazí pouze ty odvětví, kde byl pokles mzdy v následujícím roce


CREATE OR REPLACE VIEW Final_table_Industry_percentage AS (
SELECT 
		tlppspf.payroll_name,
		tlppspf.payroll_year AS 'old_payroll_year',
		tlppspf2.date_from_year AS 'new_payroll_year',
		(tlppspf.avg_sallary) AS 'old_yearly_sum_value',
		(tlppspf2.avg_sallary) AS 'new_yearly_sum_value',
		round( ((((tlppspf2.avg_sallary)/(tlppspf.avg_sallary)))*100 - 100), 2) AS '%YEARLY_sallary_difference'
	FROM t_lucie_ptackova_project_sql_primary_final tlppspf
	join t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.payroll_year = tlppspf2.date_from_year -1 
	WHERE tlppspf.payroll_name  = tlppspf2.payroll_name 
	group by tlppspf.payroll_name , tlppspf.payroll_year 
	ORDER BY tlppspf.payroll_name , tlppspf.payroll_year 
);

SELECT *
FROM final_table_industry_percentage ftip;

/*Zobrazení procentuálního vyjádření za jednotlivá odvětví za celé sledované období*/
SELECT 
	payroll_name,
	round( avg( `%YEARLY_sallary_difference` ), 2) AS '%Total_sallary_status'
FROM final_table_industry_percentage ftip 
GROUP BY payroll_name
ORDER BY (round( avg( `%YEARLY_sallary_difference` ), 2)) DESC;

/*Odpověd na výzkumnou otázku č.1:
*Sledované mzdy ve všech odvětvíh mezi lety 2006 až 2018 rostly.
*Objevily se však odvětví, kde v některých letech byl zaznamenán meziroční pokles mezd.
*Největší meziroční pokles zaznamenalo například odvětví Peněžnictví a pojišťovnictví v roce 2013 a to konkrétně pokles mzdy o 8,83%.
*Dále také odvětví Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu též v roce 2013 a to konkrétně o 4,44 %.
**Nejvíce let s poklesem meziroční mzdy mělo odvětví Těžba a dobývání, kde mzda klesla celkem ve čtyřech letech a to v roce 2009, 2013, 2014 a 2016.
*
*Naopak odvětví s největíším meziročním nárustem mzdy je odvětví Těžba  dobývání, kde v roce 2008 byl nárust mzdy o 13,75 %.
*Dále také odvětví Profesní, vědecké a technické činnosti, kde v roce 2008 byl meziroční nárust mzdy o 12,41%.
*
*Největším celkovým nárustem mezd za celé sledované období v letech 2006 až 2018 se pyšní odvětví Zdravotnictví a sociální péče.
*Nejnižším celkovým nárustem mezd za celé sledované období v letech 2006 až 2018 byl v odvětví Peněžnictví a pojišťovnictví.
**/


/*Výzkumná otázka č.2:
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */


SELECT *	
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN (111301, 114201)
ORDER BY pcft.date_from_year, pcft.name  ;


SELECT *	
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN (111301, 114201)
ORDER BY pcft.date_from_year DESC, pcft.name ;


/*Vyfiltrovala jsem si pouze nejnižší možné období - rok 2006, nevyšší možné období - rok 2018 pro Chléb konzumní kmínový a Mléko polotučné pasterované */

SELECT 
	pcft.category_code,
	pcft.date_from_year,
	pcft.category_code ,
	pcft.name,
	pcft.price_value ,
	pcft.price_unit
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN ('111301', '114201')
	AND 	(pcft.date_from_year  = 2006 OR 
		pcft.date_from_year = 2018)
GROUP BY pcft.date_from_year, pcft.category_code  
ORDER by pcft.category_code , pcft.date_from_year;



/*Zjistila jsem si průměrnou mzdu za nejnižší možné období (tzn. 2006) průměrem ze všech odvětví A-S. Průměrná mzda ze všech odvětví v nejnižším možném období činí 21 165,18 Kč.*/
/*Zjistila jsem si průměrnou mzdu za nejvyšší možné období (tzn. 2018) průměrem ze všech odvětví A-S. Průměrná mzda ze všech odvětví v nejvyšším možném období činí 33 091,45 Kč.*/

SELECT
	pft.industry_branch_code ,
	pft.payroll_name ,
	pft.payroll_year,
	round(AVG(pft.avg_sallary), 2) AS průměrná_roční_mzda_ze_vsech_odvetvi
FROM payroll_final_table pft
WHERE pft.payroll_year IN (2006, 2018)
GROUP BY pft.payroll_year
;


/*Ceny mléka a chleba dohromady v jedné tabulce*/

SELECT 	
	pcft.date_from_year,
	pcft.name ,
	pcft.price_value,
	pcft.price_unit ,
	pcft.avg_price AS průmerna_cena
FROM price_category_final_table pcft 
	WHERE pcft.category_code IN ('111301','114201')
	AND pcft.date_from_year IN (2006, 2018)
	GROUP BY pcft.date_from_year , pcft.name   
	ORDER BY pcft.date_from_year, pcft.name ;


/*Propojení tabulek cen a mezd dohromady*/

SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf.name ,
	tlppspf.price_value ,
	tlppspf.price_unit ,
	round(avg(tlppspf.avg_price), 2) AS průměr_cena,
	round(avg(tlppspf.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi,
	round((avg(tlppspf.avg_sallary)/avg(tlppspf.avg_price )),2) AS kolik_muzu_koupit_ks
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	WHERE tlppspf.category_code IN ('111301','114201')
	AND tlppspf.date_from_year  IN (2006, 2018)
	AND tlppspf.payroll_year IN (2006, 2018)
	GROUP BY tlppspf.date_from_year , tlppspf.name 
	ORDER BY tlppspf.name , tlppspf.date_from_year 
	 ;


/*Odpověď na výzkumnou otázku číslo 2: 
 * Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 
Z dostupných dat cen a mezd jsem určila, kolik je možné si zakoupit za průměrnou mzdu v prvním a posledním srovnatelném období množství kilogramů chleba a litrů mléka. 
Pro tento výpočet jsem použila průměrnou mzdu, která byla zprůměrována ze všech odvětví v České republice a poskytuje nám tak informace o tom, 
kolik bylo možné si v daných obdobích zakoupit kilogramů chleba a litrů mléka z průměrného vypočítaného platu.

V roce 2006 bylo za průměrnou cenu chleba 16,12 Kč a průměrnou mzdu 21 165,188 Kč možné nakoupit 1 312,98 kg chleba nebo 1 465,73 litrů mléka za průměrnou cenu 14,44 Kč. 
V roce 2018 bylo za cenu 24,24 Kč a průměrnou mzdu 33 091,45 Kč možné nakoupit 1 365,16 kg chleba nebo 1 669,6 l mléka za průměrnou cenu 19,82 Kč.*/


	
/* Výzkumná otázka č. 3:
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

SELECT 
	tlppspf.date_from_year AS date_from_year ,
	tlppspf.name  ,
	tlppspf.price_value  ,
	tlppspf.price_unit ,
	tlppspf.avg_price AS průmerna_cena_potravin_za_dany_rok
FROM t_lucie_ptackova_project_sql_primary_final tlppspf  
GROUP BY tlppspf.name, tlppspf.date_from_year
ORDER BY tlppspf.name , tlppspf.date_from_year ;


/*Přidání sloupec rok-1*/

SELECT 
	tlppspf.date_from_year AS date_from_year ,
	tlppspf2.date_from_year AS date_from_year_plus1,
	tlppspf.name ,
	tlppspf.price_value ,
	tlppspf.price_unit ,
	tlppspf.avg_price AS 'průmerna_cena_potravin_za_dany_rok',
	tlppspf2.avg_price AS 'průmerna_cena_potravin_za_dany_rok_plus1',
	round((((tlppspf2.avg_price * 100)/tlppspf.avg_price)-100) , 2) AS procentualni_narust_pokles
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2  
	ON tlppspf.date_from_year = tlppspf2.date_from_year -1 	
	AND tlppspf.name = tlppspf2.name 
GROUP BY tlppspf.name, tlppspf.date_from_year 
ORDER BY tlppspf.name  ;

/*Finální tabulka s meziročním percentuálním poklesem/nárustem za dané potravinové kategorie. Seřazena vzestupně. */

select * 
from (
	SELECT
		ps.name,
		round(avg(ps.procentualni_narust_pokles), 2) AS prumer_final
	FROM (
		SELECT 
			tlppspf.date_from_year AS date_from_year ,
			tlppspf2.date_from_year AS date_from_year_plus1,
			tlppspf.name ,
			tlppspf.price_value ,
			tlppspf.price_unit ,
			tlppspf.avg_price AS 'průmerna_cena_potravin_za_dany_rok',
			tlppspf2.avg_price AS 'průmerna_cena_potravin_za_dany_rok_plus1',
			round((((tlppspf2.avg_price * 100)/tlppspf.avg_price)-100) , 2) AS procentualni_narust_pokles
		FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
		JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2  
			ON tlppspf.date_from_year = tlppspf2.date_from_year -1
			AND tlppspf.name = tlppspf2.name 
		GROUP BY tlppspf.name, tlppspf.date_from_year 
		ORDER BY tlppspf.name , tlppspf.date_from_year
	) ps
GROUP BY ps.name
) ps2
order by ps2.prumer_final;


/*Odpověď na výzkumnou otázku č.3:
  *Kategorie potravin, která zdražuje nejpomaleji, ve sledovaném období v letech 2006 až 2018, je kategorie potravin Cukr krystal, jejíž cena se zvyšovala nejméně. 
 *Z dostupných dat jsem zjistila, že cena této kategorie se ve sledovaném období meziročně snížila průměrně o -1,92%. 
 *
 *Naopak největší meziroční nárust kategorie potravin ve sledovaném období je u papriky. Jejichž cena se zvyšovala průměrně o 7,29 %.
 **/



/*Výzkumná otázka č.4:
 * Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/

SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf.name ,
	tlppspf.price_value ,
	tlppspf.price_unit ,
	round(avg(tlppspf.avg_price), 2) AS průměrna_rocni_cena_potravin,
	tlppspf.payroll_name ,
	tlppspf.payroll_year ,
	round(avg(tlppspf.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	GROUP BY tlppspf.date_from_year , tlppspf.name 
	ORDER BY tlppspf.name , tlppspf.date_from_year 
	 ;

/*Napojení tabulky samu na sebe kvůli roku-1 a dosazení sloupečku o posunutý rok směrem nahoru*/
SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf2.date_from_year AS date_from_plus1,
	tlppspf.name ,
	tlppspf.price_value ,
	tlppspf.price_unit ,
	round(avg(tlppspf.avg_price), 2) AS průměrna_rocni_cena_potravin,
	round(avg(tlppspf2.avg_price), 2) AS průměrna_rocni_cena_potravin_PLUS1,
	tlppspf.payroll_name ,
	tlppspf.payroll_year ,
	tlppspf2.payroll_year AS payroll_year_plus1,
	round(avg(tlppspf.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi,
	round(avg(tlppspf2.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi_PLUS1
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year , tlppspf.name 
	ORDER BY tlppspf.name , tlppspf.date_from_year 
	 ;
	 
/*Výpočet procentuálního meziročního nárustu/poklesu cen potravin a mezd.*/

	SELECT
	tlppspf.date_from_year AS date_from,
	tlppspf2.date_from_year AS date_from_plus1,
	tlppspf.name ,
	round(avg(tlppspf.avg_price), 2) AS průměrna_rocni_cena_potravin,
	round(avg(tlppspf2.avg_price), 2) AS průměrna_rocni_cena_potravin_PLUS1,
	round( (((avg(tlppspf2.avg_price)/avg(tlppspf.avg_price)*100)-100)),2) AS procentual_rust_cen,
	tlppspf.payroll_name ,
	tlppspf.payroll_year ,
	tlppspf2.payroll_year AS payroll_year_plus1,
	round(avg(tlppspf.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi,
	round(avg(tlppspf2.avg_sallary), 2) AS průměrná_rocni_mzda_ze_vsech_odvetvi_PLUS1,
	round(((avg(tlppspf2.avg_sallary)/avg(tlppspf.avg_sallary)*100)-100),2) AS procentual_rust_mezd
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year , tlppspf.name 
	ORDER BY tlppspf.name , tlppspf.date_from_year 
	 ;
	
	/*Filtrace pouze sloupců s procentualnim narustem/poklesem cen potravin a mezd*/
		
SELECT
	tlppspf.date_from_year AS old_year,
	tlppspf2.date_from_year AS new_year,
	round( (((avg(tlppspf2.avg_price)/avg(tlppspf.avg_price)*100)-100)),2) AS '%YEARLY_food_price_difference',
	round(((avg(tlppspf2.avg_sallary)/avg(tlppspf.avg_sallary)*100)-100),2) AS '%YEARLY_sallary_difference',
	round( (((avg(tlppspf2.avg_price)/avg(tlppspf.avg_price)*100)-100)),2) - (round(((avg(tlppspf2.avg_sallary)/avg(tlppspf.avg_sallary)*100)-100),2)) AS prices_sallary_difference
FROM t_lucie_ptackova_project_sql_primary_final tlppspf 
	JOIN t_lucie_ptackova_project_sql_primary_final tlppspf2 
		ON tlppspf.date_from_year = tlppspf2.date_from_year -1
		AND tlppspf.name = tlppspf2.name
		AND tlppspf.payroll_year = tlppspf2.payroll_year -1
		AND tlppspf.payroll_name = tlppspf2.payroll_name 
	GROUP BY tlppspf.date_from_year 
	;
	
/*Odpověď na výzkumnou otázku č.4:
 * Ve sledovaném období v letech od roku 2006 až do roku 2018, nepřesáhl meziroční nárůst potravin hranici 10 %. 
 *Největší meziroční nárůst potravin byl v roce 2017, a to ve výši 9,63 %. 
 *Naopak nejnižší meziroční nárust potravin byl v roce 2009, který byl nižší o 6,42%.
 * V roce 2013 byl nejvyšší rozdíl mezi nárůstem cen a mezd, a to ve výši 6,66 %. 
 * Naopak v roce 2009 byl nejnižší rozdíl mezi nárustem cen a mezd, který se snížil o 9,49%.
 * V tomto roce se ceny potravin oproti roku předchozímu zvýšily o 5,1 %, zatímco mzdy poklesly o -1,56 %.*/

	

/*Výzkumná otázka č.5:
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/


/*Tvorba pohledu VIEW pro HDP pro Českou republiku v letech 2006 - 2018*/

CREATE OR REPLACE VIEW v_lucie_ptackova_secondary_gdp_cr_2006_2018 AS
SELECT *
FROM t_lucie_ptackova_project_sql_secondary_final tlppssf 
WHERE country = 'Czech Republic';


SELECT * FROM v_lucie_ptackova_secondary_gdp_cr_2006_2018;

/*Tvorba pohledu VIEW s přidáním sloupečků year +1, HDP +1, procentuální vyjádření rozdílů mezi roky.*/

CREATE OR REPLACE VIEW v_lucie_ptackova_secondary_gdp_cr_2006_2018_plus1 AS
SELECT 
	vlpsgc.`year` AS old_year,
	vlpsgc2.`year` AS new_year,
	vlpsgc.GDP AS old_gdp,
	vlpsgc2.GDP AS new_gdp,
	round( avg(vlpsgc2.GDP - vlpsgc.GDP)/vlpsgc.GDP*100, 2) AS 'GDP_percent_difference' 
FROM v_lucie_ptackova_secondary_gdp_cr_2006_2018 vlpsgc 
	JOIN v_lucie_ptackova_secondary_gdp_cr_2006_2018 vlpsgc2 
		ON vlpsgc.country = vlpsgc2.country 
		AND vlpsgc.year = vlpsgc2.year -1
GROUP BY vlpsgc.`year`;

SELECT *
FROM v_lucie_ptackova_secondary_gdp_cr_2006_2018_plus1;

/*Sloučení předchozího pohledu VIEW vlpsgcp s finální tabulkou z ukolu č. 4*/

SELECT
	tlppspf.date_from_year AS old_year,
	tlppspf2.date_from_year AS new_year,
	vlpsgcp.GDP_percent_difference AS '%YEARLY_GDP_difference',
	round( (((avg(tlppspf2.avg_price)/avg(tlppspf.avg_price)*100)-100)),2) AS '%YEARLY_food_price_difference',
	round(((avg(tlppspf2.avg_sallary)/avg(tlppspf.avg_sallary)*100)-100),2) AS '%YEARLY_sallary_difference'
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
	GROUP BY tlppspf.date_from_year 
	;

/*Odpověď na výzkumnou otázku č.5: * 
 Z výsledků analýzy průměrného růstu cen potravin, mezd a HDP v letech 2006–2018 není patrné, že by byla opakovatelnost nebo spojitost. 
Za výraznější růst považuji růst vyšší jak 5%. K této situaci došlo celkem 3x. 
V roce 2007, kde také došlo k výraznějšímu růstu mezd a potravin v daném i následujcím roce. 
Dále pak v roce 2015, kde ale k výraznému růstu cen potravi a mezd v daném i následujím roce nedošlo. 
Poslední rok s výrazným nárůstem HDP byl rok 2017, kde došlu k výraznému růstu cen potravin a mezd v daném roce, ale v náledujícím již ne.

Dá se tedy řicí, že výrazný růst HDP se pravděpodobně může projevit v cenách potravin a mezd v daném roce.*/  
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

