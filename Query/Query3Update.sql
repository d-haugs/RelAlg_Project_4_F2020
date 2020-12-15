-- @@drop
DROP TABLE death_count_by_country_date_pair;
DROP TABLE confirmed_count_by_country_date_pair;
DROP TABLE confirmeddeath_pair_for_country;
DROP TABLE day_previousday_pair;

SET SERVEROUTPUT ON
DECLARE
BEGIN


-- Group  on RAW_global_deaths table on arbdate,country get sum of deathCount
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(deathCount)','death_count_by_country_date_pair'));

-- Group  on RAW_global_confirmed_cases table arbdate,country get sum of confirmedCount
ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_count_by_country_date_pair'));


-- Match join both confirmed_count_by_country_date_pair and death_count_by_country_date_pair table on country,arbdate and  got confirmeddeath_pair_for_country table
ops.go(ops.mjoin_ra('a=confirmed_count_by_country_date_pair','b=death_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmeddeath_pair_for_country')); 


-- Match join both confirmed_count_by_country_date_pair and death_count_by_country_date_pair table on country,arbdate and  got confirmeddeath_pair_for_country table
ops.go(ops.mjoin_ra('a=confirmeddeath_pair_for_country','b=confirmeddeath_pair_for_country','country,arbdate','country,arbdate+1','day_previousday_pair')); 



END;
/
select count(*) from RAW_global_deaths;
select count(*) from RAW_global_confirmed_cases;
select count(*) from day_previousday_pair;
--  to get order from worest to best death to confirmed case ratios
-- select * from day_previousday_pair order By deathToConfirmedRatio DESC;

