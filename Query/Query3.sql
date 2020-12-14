-- drop table raw_global_death_pair;
-- drop table daily_count_global_death;
-- drop table raw_global_death_pair_province_countries;
-- drop table RAW_global_deaths_without_province_countries;
-- drop table raw_global_death_pair_non_province_countries;
drop table RAW_global_deaths_cumul;
drop table RAW_global_confirmed_cases_cumul;
drop table date_country_pair_w_ccase_and_death;
drop table worst_country_per_day;

--test group
drop table jan_feb_deaths_cumul;


SET SERVEROUTPUT ON
DECLARE
BEGIN


-- ops.go(ops.project_ra('RAW_global_deaths', allbut('RAW_global_deaths','lat,longitude'), 'RAW_global_deaths_without_lat_long'));
ops.go(ops.group_ra('RAW_global_deaths', 'arbdate,country','cumdeathCount=sum(deathCount)', 'RAW_global_deaths_cumul'));
ops.go(ops.group_ra('RAW_global_confirmed_cases', 'arbdate,country', 'cumconfirmedCount=sum(confirmedCount)', 'RAW_global_confirmed_cases_cumul'));

-- Proposed idea: use monthly blocks to reduce effective table size for joins.
ops.go(ops.filter_ra('RAW_global_deaths_cumul','arbdate<='TO_DATE('03/01/2020','DD/MM/YYYY'),'jan_feb_deaths_cumul'));



--match confirmed cases and deaths by same date,country
ops.go(ops.mjoin_ra('RAW_global_deaths_cumul','RAW_global_confirmed_cases_cumul','arbdate,country','arbdate,country','date_country_pair_w_ccase_and_death'));

--It appears dropping tables is not allowed in a begin/end block (transaction?)
END;
/

DROP TABLE RAW_global_deaths_cumul;
DROP TABLE RAW_global_confirmed_cases_cumul;
select table_name from user_tables;

DECLARE
BEGIN
--group over arbdate, carry country, func: max(death/case)
ops.go(ops.group_ra('date_country_pair_w_ccase_and_death','arbdate','country,worst_death=max(cumdeathCount/cumconfirmedCount)','worst_country_per_day'));

--!!!NOTE: do this later
-- Match deaths and confirmed cases with their previous day data per date,country
-- ops.go(ops.mjoin_ra('a=RAW_global_deaths_cumul','b=RAW_global_deaths_cumul','arbdate,country','arbdate - 1,country','raw_global_death_pair_province_countries'));
-- ops.go(ops.mjoin_ra('a=RAW_global_confirmed_cases_cumul','b=RAW_global_confirmed_cases_cumul','arbdate,country','arbdate - 1,country','raw_global_c_case_pair_province_countries'));
-- Generate per day counts
-- ops.go(ops.group_ra('raw_global_death_pair_province_countries', 'arbdate,country','daydeathCount=sum(cumdeathCount)', 'daily_death_for_day'));
-- ops.go(ops.group_ra('raw_global_c_case_pair_province_countries', 'arbdate,country','dayconfirmedCount=sum(cumconfirmedCount)', 'daily_ccases_for_day'));






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


