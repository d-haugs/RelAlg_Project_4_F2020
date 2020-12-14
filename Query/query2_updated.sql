-- @@drop
DROP TABLE death_count_by_country_date_pair;
DROP TABLE confirmed_count_by_country_date_pair;
DROP TABLE confirmeddeath_pair_for_country;
SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('RAW_global_deaths','arbitraryID,arbdate,country,province,deathCount','deaths_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_confirmed_cases','arbitraryID,arbdate,country,province,confirmedCount','confirmed_cases_without_lat_longitude'));
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(deathCount)','death_count_by_country_date_pair'));

ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_count_by_country_date_pair'));
-- Match join 
-- Match Join all song data to get back "Song with its total number of streams"
ops.go(ops.mjoin_ra('a=confirmed_count_by_country_date_pair','b=death_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmeddeath_pair_for_country')); 
 ops.go(ops.group_ra('confirmeddeath_pair_for_country','country','death_case_count,confirmed_case_count','new_Date=max(arbdate)','latest_date_confirmeddeath_pair'));


END;
/
select count(*) from death_count_by_country_date_pair;
select count(*) from confirmed_count_by_country_date_pair;
select count(*) from confirmeddeath_pair_for_country;