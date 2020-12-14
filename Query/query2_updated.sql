-- @@drop
DROP TABLE death_count_by_country_date_pair;
DROP TABLE confirmed_count_by_country_date_pair;
DROP TABLE confirmeddeath_pair_for_country;
DROP TABLE FILTER_CONFIRMEDDEATH_FOR_COUNTRY;
DROP TABLE country_deathToConfirmed_ratio;
DROP TABLE death_confirmed_pair;
DROP TABLE final_confirmeddeath_ratio;
SET SERVEROUTPUT ON
DECLARE
BEGIN

ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(deathCount)','death_count_by_country_date_pair'));

ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_count_by_country_date_pair'));
-- Match join 

ops.go(ops.mjoin_ra('a=confirmed_count_by_country_date_pair','b=death_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmeddeath_pair_for_country')); 

ops.go(ops.filter_ra('confirmeddeath_pair_for_country','confirmed_case_count!=0','filter_confirmeddeath_for_country'));
--  Proejct to get death to confirmed ratio
ops.go(ops.project_ra('filter_confirmeddeath_for_country','country,arbdate,deathToConfirmedRatio=death_case_count/confirmed_case_count','country_deathToConfirmed_ratio'));

-- Group By country 
ops.go(ops.group_ra('country_deathToConfirmed_ratio','country','new_Date=max(arbdate)','death_confirmed_pair'));

-- MJ 
ops.go(ops.mjoin_ra('a=country_deathToConfirmed_ratio','b=death_confirmed_pair','country,arbdate','country,new_Date','deathToConfirmedRatio,country,arbdate','final_confirmeddeath_ratio')); 


END;
/
select count(*) from death_count_by_country_date_pair;
select count(*) from confirmed_count_by_country_date_pair;
select count(*) from confirmeddeath_pair_for_country;
select * from final_confirmeddeath_ratio order By deathToConfirmedRatio DESC;

