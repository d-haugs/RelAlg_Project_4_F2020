-- @@drop
DROP TABLE death_cases_count_by_country_date_pair;
DROP TABLE confirmed_cases_count_by_country_date_pair;
DROP TABLE confirmed_death_pair_for_country;
SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('RAW_global_deaths','arbitraryID,arbdate,country,province,deathCount','deaths_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_confirmed_cases','arbitraryID,arbdate,country,province,confirmedCount','confirmed_cases_without_lat_longitude'));
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(confirmedCount)','death_cases_count_by_country_date_pair'));

ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_cases_count_by_country_date_pair'));
-- Match join 
-- Match Join all song data to get back "Song with its total number of streams"
ops.go(ops.mjoin_ra('a=confirmed_cases_count_by_country_date_pair','b=death_cases_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmed_death_pair_for_country')); 



END;
/

select * from confirmed_death_pair_for_country where rownum <= 30;