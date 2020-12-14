-- @@drop
-- DROP TABLE RAW_global_deaths_without_lat_longitude;
-- DROP TABLE RAW_global_confirmed_cases_without_lat_longitude;
DROP TABLE raw_global_confirmed_death_pair;
-- DROP TABLE confirmed_death_cases_count_by_country_date_pair;
-- DROP TABLE latest_date_confirmed_death_cases_count_by_country_date_pair;
SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('RAW_global_deaths',ops.allbut('lat,longitude'),'RAW_global_deaths_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_confirmed_cases',ops.allbut('lat,longitude'),'RAW_global_confirmed_cases_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_deaths','arbitraryID,arbdate,country,province,deathCount','RAW_global_deaths_without_lat_longitude'));
-- ops.go(ops.project_ra('RAW_global_confirmed_cases','arbitraryID,arbdate,country,province,confirmedCount','RAW_global_confirmed_cases_without_lat_longitude'));
-- ops.go(ops.mjoin_ra('a=RAW_global_deaths_without_lat_longitude','b=RAW_global_confirmed_cases_without_lat_longitude','country,province,arbdate','country,province,arbdate','country,province,arbdate,confirmedCount,deathCount','raw_global_confirmed_death_pair')); 
-- Match join 
-- Match Join all song data to get back "Song with its total number of streams"
--ops.go(ops.mjoin_ra('a=RAW_global_deaths','b=RAW_global_confirmed_cases','country,province,arbdate','country,province,arbdate','country,province,arbdate,confirmedCount,deathCount','raw_global_confirmed_death_pair')); 

ops.go(ops.ojoin_left_ra('a=RAW_global_deaths','b=RAW_global_confirmed_cases','country,province,arbdate','country,province,arbdate','country,province,arbdate,confirmedCount,deathCount','raw_global_confirmed_death_pair')); 

-- -- Group by genre to get "Genre with (number of streams for its most-streamed song) data"
ops.go(ops.group_ra('raw_global_confirmed_death_pair','arbdate,country','by_country_confirmed_case_count=sum(confirmedCount),by_country_death_case_count=sum(deathCount)','confirmed_death_cases_count_by_country_date_pair'));
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

select country,province,arbdate,deathCount,confirmedCount from raw_global_confirmed_death_pair where rownum <= 30;


-- select country,arbdate,by_country_death_case_count,by_country_confirmed_case_count from confirmed_death_cases_count_by_country_date_pair where rownum <= 30;
-- select country,new_Date,by_country_death_case_count,by_country_confirmed_case_count from latest_date_confirmed_death_cases_count_by_country_date_pair where rownum <= 30;