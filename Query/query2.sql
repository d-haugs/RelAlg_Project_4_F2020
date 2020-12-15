-- @@drop
DROP TABLE death_count_by_country_date_pair;
DROP TABLE confirmed_count_by_country_date_pair;
DROP TABLE confirmeddeath_pair_for_country;
DROP TABLE FILTER_CONFIRMEDDEATH_FOR_COUNTRY;
DROP TABLE country_deathToConfirmed_ratio;
DROP TABLE death_confirmed_ratio_WithMaxDate;
DROP TABLE final_confirmeddeath_ratio;
SET SERVEROUTPUT ON
DECLARE
BEGIN
-- Group  on RAW_global_deaths table on arbdate,country get sum of deathCount
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(deathCount)','death_count_by_country_date_pair'));

-- Group  on RAW_global_confirmed_cases table arbdate,country get sum of confirmedCount
ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_count_by_country_date_pair'));

-- Match join both confirmed_count_by_country_date_pair and death_count_by_country_date_pair table on country,arbdate and  got confirmeddeath_pair_for_country table
ops.go(ops.mjoin_ra('a=confirmed_count_by_country_date_pair','b=death_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmeddeath_pair_for_country')); 

-- Filter out confirmed_case_count zero values to avoid divide by 0 issue while doing deathcount/confirmed cases count and got filter_confirmeddeath_for_country table
ops.go(ops.filter_ra('confirmeddeath_pair_for_country','confirmed_case_count!=0','filter_confirmeddeath_for_country'));

--  Project to get deathToConfirmedRatio=death_case_count/confirmed_case_count got country_deathToConfirmed_ratio
ops.go(ops.project_ra('filter_confirmeddeath_for_country','country,arbdate,deathToConfirmedRatio=death_case_count/confirmed_case_count','country_deathToConfirmed_ratio'));

-- Group By country to get Max date and got death_confirmed_ratio_WithMaxDate
ops.go(ops.group_ra('country_deathToConfirmed_ratio','country','new_Date=max(arbdate)','death_confirmed_ratio_WithMaxDate'));

-- MJ  death_confirmed_ratio_WithMaxDate to country_deathToConfirmed_ratio to get final_confirmeddeath_ratio by country
ops.go(ops.mjoin_ra('a=country_deathToConfirmed_ratio','b=death_confirmed_ratio_WithMaxDate','country,arbdate','country,new_Date','country,arbdate,deathToConfirmedRatio','final_confirmeddeath_ratio')); 


END;
/
select count(*) from RAW_global_deaths;
select count(*) from RAW_global_confirmed_cases;
--  to get order from worest to best death to confirmed case ratios
select * from final_confirmeddeath_ratio order By deathToConfirmedRatio DESC;

