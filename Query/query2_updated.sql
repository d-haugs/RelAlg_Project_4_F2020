-- @@drop
DROP TABLE death_cases_count_by_country_date_pair;
DROP TABLE confirmed_cases_count_by_country_date_pair;
DROP TABLE confirmed_death_cases_count_by_country_date_pair;
SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('RAW_global_deaths','arbitraryID,arbdate,country,province,deathCount','deaths_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_confirmed_cases','arbitraryID,arbdate,country,province,confirmedCount','confirmed_cases_without_lat_longitude'));
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(confirmedCount)','death_cases_count_by_country_date_pair'));

ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_cases_count_by_country_date_pair'));
-- Match join 
-- Match Join all song data to get back "Song with its total number of streams"
ops.go(ops.mjoin_ra('a=confirmed_cases_count_by_country_date_pair','b=death_cases_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmed_death_pair_for_country_with_province')); 

-- ops.go(ops.full_minus_ra('deaths_without_lat_longitude','confirmed_cases_without_lat_longitude','country,province','country,province','confirmed_cases_for_country_without_province')); 

-- ops.go(ops.full_minus_ra('RAW_global_confirmed_cases_without_lat_longitude','confirmed_death_pair_for_country_with_province','country,province','country,province','death_cases_for_country_without_province')); 

-- ops.go(ops.mjoin_ra('a=confirmed_cases_for_country_without_province','b=death_cases_for_country_without_province','country,arbdate','country,arbdate','country,arbdate,confirmedCount,deathCount','confirmed_death_pair_for_country_without_province')); 


-- -- Group by genre to get "Genre with (number of streams for its most-streamed song) data"
-- ops.go(ops.group_ra('raw_global_confirmed_death_pair','arbdate,country','by_country_confirmed_case_count=sum(confirmedCount),by_country_death_case_count=sum(deathCount)','confirmed_death_cases_count_by_country_date_pair'));
-- Group Max date
-- ops.go(ops.group_ra('confirmed_death_cases_count_by_country_date_pair','country','by_country_confirmed_case_count,by_country_death_case_count','new_Date=max(arbdate)','latest_date_confirmed_death_cases_count_by_country_date_pair'));


END;
/
-- select * from deaths_without_lat_longitude where rownum <= 30;
-- select * from confirmed_cases_without_lat_longitude where rownum <= 30;
-- select * from confirmed_death_pair_for_country_with_province where rownum <= 30;
-- select * from confirmed_cases_for_country_without_province where rownum <= 30;
-- -- select country,province,arbdate,deathCount,confirmedCount from confirmed_death_pair_for_country_with_province where rownum <= 30;


-- -- select country,arbdate,by_country_death_case_count,by_country_confirmed_case_count from confirmed_death_cases_count_by_country_date_pair where rownum <= 30;
-- -- select country,new_Date,by_country_death_case_count,by_country_confirmed_case_count from latest_date_confirmed_death_cases_count_by_country_date_pair where rownum <= 30;

-- -- select * from RAW_global_deaths_without_lat_longitude where rownum <= 30;

-- DROP TABLE deaths_without_lat_longitude;
-- DROP TABLE confirmed_cases_without_lat_longitude;
-- DROP TABLE confirmed_death_pair_for_country_with_province;
-- DROP TABLE confirmed_cases_for_country_without_province;
select * from confirmed_death_cases_count_by_country_date_pair where rownum <= 30;