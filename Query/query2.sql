-- @@drop

DROP TABLE confirmed_death_pair_for_country_with_province;
DROP TABLE confirmed_death_pair_for_country_without_province;
DROP TABLE confirmed_cases_for_country_without_province;
DROP TABLE death_cases_for_country_without_province;
-- DROP TABLE confirmed_death_cases_count_by_country_date_pair;
-- DROP TABLE latest_date_confirmed_death_cases_count_by_country_date_pair;
SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Match join 
-- Match Join all song data to get back "Song with its total number of streams"
ops.go(ops.mjoin_ra('a=RAW_global_deaths','b=RAW_global_confirmed_cases','country,province,arbdate','country,province,arbdate','country,province,arbdate,confirmedCount,deathCount','confirmed_death_pair_for_country_with_province')); 

ops.go(ops.full_minus_ra('RAW_global_deaths','confirmed_death_pair_for_country_with_province','country,province','country,province','confirmed_cases_for_country_without_province')); 

-- ops.go(ops.full_minus_ra('a=RAW_global_confirmed_cases','b=confirmed_death_pair_for_country_with_province','country,province','country,province','death_cases_for_country_without_province')); 

-- ops.go(ops.mjoin_ra('a=confirmed_cases_for_country_without_province','b=death_cases_for_country_without_province','country,arbdate','country,arbdate','country,arbdate,confirmedCount,deathCount','confirmed_death_pair_for_country_without_province')); 


-- -- Group by genre to get "Genre with (number of streams for its most-streamed song) data"
-- ops.go(ops.group_ra('raw_global_confirmed_death_pair','arbdate,country','by_country_confirmed_case_count=sum(confirmedCount),by_country_death_case_count=sum(deathCount)','confirmed_death_cases_count_by_country_date_pair'));
-- Group Max date
-- ops.go(ops.group_ra('confirmed_death_cases_count_by_country_date_pair','country','by_country_confirmed_case_count,by_country_death_case_count','new_Date=max(arbdate)','latest_date_confirmed_death_cases_count_by_country_date_pair'));

-- -- Times, Filter, Reduce to get the most popular song per genre.
-- -- Can this also be a Match Join?
-- -- Is the Reduce dangerous?
-- ops.go(ops.times_ra('S=song_with_total_streams','G=genre_with_max_total_streams','song__genre_max_pair'));
-- ops.go(ops.filter_ra('song__genre_max_pair','total_streams=max_streams','pop_song__genre_max_pair'));
-- ops.go(ops.reduce_ra('pop_song__genre_max_pair','song_id','genre=G_genre,song_title','pop_song_of_genre'));

END;
/

select country,province,arbdate,deathCount,confirmedCount from confirmed_death_pair_for_country_with_province where rownum <= 30;


-- select country,arbdate,by_country_death_case_count,by_country_confirmed_case_count from confirmed_death_cases_count_by_country_date_pair where rownum <= 30;
-- select country,new_Date,by_country_death_case_count,by_country_confirmed_case_count from latest_date_confirmed_death_cases_count_by_country_date_pair where rownum <= 30;