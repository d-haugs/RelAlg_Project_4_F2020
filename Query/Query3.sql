-- drop table raw_global_death_pair;
-- drop table daily_count_global_death;
-- drop table raw_global_death_pair_province_countries;
-- drop table RAW_global_deaths_without_province_countries;
-- drop table raw_global_death_pair_non_province_countries;
drop table RAW_global_deaths_cum_country_deaths;


SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Project lat,long out of RAW_global_deaths
-- ops.go(ops.project_ra('RAW_global_deaths', allbut('RAW_global_deaths','lat,longitude'), 'RAW_global_deaths_without_lat_long'));
ops.go(ops.group_ra('RAW_global_deaths', 'arbdate,country','cumdeathCount=sum(deathCount)', 'RAW_global_deaths_cum_country_deaths'));

-- Match join RAW_global_deaths with itself on country, province, 1 day difference
-- ops.go(ops.mjoin_ra('a=RAW_global_deaths','b=RAW_global_deaths','country,province,arbdate','country,province,arbdate - 1','raw_global_death_pair_province_countries'));

-- Full Minus the countries with provinces from global
-- ops.go(ops.full_minus_ra('RAW_global_deaths','raw_global_death_pair_province_countries','country,arbdate', 'RAW_global_deaths_without_province_countries')); 

-- Match join RAW_global_deaths_without_province_countries with itself on country, 1 day difference
-- ops.go(ops.mjoin_ra('a=RAW_global_deaths_without_province_countries','b=RAW_global_deaths_without_province_countries','country,province,arbdate','country,province,arbdate - 1','raw_global_death_pair_non_province_countries'));

-- Union 1-day difference countries with provinces and countries without provinces to get global consecutive day pairs
-- ops.go(ops.union_ra('raw_global_death_pair_province_countries','raw_global_death_pair_non_province_countries','raw_global_death_pair'));

-- project out first date and subtract counts
-- ops.go(ops.project_ra('raw_global_death_pair','country, province, arbdate = b_arbdate, daily_death_count = b_deathcount - a_deathcount,a_arbitraryID, b_arbitraryID','daily_count_global_death'));

-- group death counts by country,arbdate
-- ops.go(ops.group_ra('daily_count_global_death','country,arbdate', ''));

-- -- Group by genre to get "Genre with (number of streams for its most-streamed song) data"
-- ops.go(ops.group_ra('song_with_total_streams','genre','max_streams=max(total_streams)','genre_with_max_total_streams'));

-- -- Times, Filter, Reduce to get the most popular song per genre.
-- -- Can this also be a Match Join?
-- -- Is the Reduce dangerous?
-- ops.go(ops.times_ra('S=song_with_total_streams','G=genre_with_max_total_streams','song__genre_max_pair'));
-- ops.go(ops.filter_ra('song__genre_max_pair','total_streams=max_streams','pop_song__genre_max_pair'));
-- ops.go(ops.reduce_ra('pop_song__genre_max_pair','song_id','genre=G_genre,song_title','pop_song_of_genre'));


END;
/

-- select country,province,a_arbdate,a_deathcount,b_arbdate,b_deathcount from raw_global_death_pair where rownum <= 1;
-- select * from daily_count_global_death where rownum <= 1;


