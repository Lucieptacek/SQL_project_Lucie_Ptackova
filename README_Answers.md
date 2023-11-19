# Odpovědi na výzkumné otázky

## Výzkumná otázka č.1:
## Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

*(SQL – řádek 72)*

Sledované mzdy ve všech odvětví mezi lety 2006 až 2018 rostly.
Objevily se však odvětví, kde v některých letech byl zaznamenán meziroční pokles mezd.
Největší meziroční pokles zaznamenalo například odvětví Peněžnictví a pojišťovnictví v roce 2013 a to konkrétně pokles mzdy o 8,83%.
Dále také odvětví Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu též v roce 2013 a to konkrétně o 4,44 %.
Nejvíce let s poklesem meziroční mzdy mělo odvětví Těžba a dobývání, kde mzda klesla celkem ve čtyřech letech a to v roce 2009, 2013, 2014 a 2016.

Naopak odvětví s největším meziročním nárustem mzdy je odvětví Těžba  dobývání, kde v roce 2008 byl nárust mzdy o 13,75 %.
Dále také odvětví Profesní, vědecké a technické činnosti, kde v roce 2008 byl meziroční nárust mzdy o 12,41%.

Největším celkovým nárustem mezd za celé sledované období v letech 2006 až 2018 se pyšní odvětví Zdravotnictví a sociální péče.
Nejnižším celkovým nárustem mezd za celé sledované období v letech 2006 až 2018 byl v odvětví Peněžnictví a pojišťovnictví.


## Výzkumná otázka č.2:
## Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 

*(SQL – řádek 180)*

Z dostupných dat cen a mezd jsem určila, kolik je možné si zakoupit za průměrnou mzdu v prvním a posledním srovnatelném období množství kilogramů chleba a litrů mléka. 
Pro tento výpočet jsem použila průměrnou mzdu, která byla zprůměrována ze všech odvětví v České republice a poskytuje nám tak informace o tom, 
kolik bylo možné si v daných obdobích zakoupit kilogramů chleba a litrů mléka z průměrného vypočítaného platu.

V roce 2006 bylo za průměrnou cenu chleba 16,12 Kč a průměrnou mzdu 21 165,188 Kč možné nakoupit 1 312,98 kg chleba nebo 1 465,73 litrů mléka za průměrnou cenu 14,44 Kč. 
V roce 2018 bylo za cenu 24,24 Kč a průměrnou mzdu 33 091,45 Kč možné nakoupit 1 365,16 kg chleba nebo 1 669,6 l mléka za průměrnou cenu 19,82 Kč.


## Výzkumná otázka č. 3:
## Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

*(SQL – řádek 274)*

Kategorie potravin, která zdražuje nejpomaleji, ve sledovaném období v letech 2006 až 2018, je kategorie potravin Cukr krystal, jejíž cena se zvyšovala nejméně. 
 Z dostupných dat jsem zjistila, že cena této kategorie se ve sledovaném období meziročně snížila průměrně o -1,92%. 
 
 Naopak největší meziroční nárust kategorie potravin ve sledovaném období je u papriky. Jejichž cena se zvyšovala průměrně o 7,29 %.


## Výzkumná otázka č.4:
## Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

*(SQL – řádek 344)*

Ve sledovaném období v letech od roku 2006 až do roku 2018, nepřesáhl meziroční nárůst potravin hranici 10 %. 
 Největší meziroční nárůst potravin byl v roce 2017, a to ve výši 9,63 %. 
 Naopak nejnižší meziroční nárust potravin byl v roce 2009, který byl nižší o 6,42%.
 V roce 2013 byl nejvyšší rozdíl mezi nárůstem cen a mezd, a to ve výši 6,66 %. 
 Naopak v roce 2009 byl nejnižší rozdíl mezi nárustem cen a mezd, který se snížil o 9,49%.
 V tomto roce se ceny potravin oproti roku předchozímu zvýšily o 5,1 %, zatímco mzdy poklesly o -1,56 %.

## Výzkumná otázka č.5:
## Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

*(SQL – řádek 437)*

Z výsledků analýzy průměrného růstu cen potravin, mezd a HDP v letech 2006–2018 není patrné, že by byla opakovatelnost nebo spojitost. 
Za výraznější růst považuji růst vyšší jak 5%. K této situaci došlo celkem 3x. 
V roce 2007, kde také došlo k výraznějšímu růstu mezd a potravin v daném i následujícím roce. 
Dále pak v roce 2015, kde ale k výraznému růstu cen potravin a mezd v daném i následujícím roce nedošlo. 
Poslední rok s výrazným nárůstem HDP byl rok 2017, kde došlu k výraznému růstu cen potravin a mezd v daném roce, ale v následujícím již ne.

Dá se tedy říci, že výrazný růst HDP se pravděpodobněji může projevit v cenách potravin a mezd v daném roce.

