-- drop table raw_global_death_pair;
-- drop table daily_count_global_death;
-- drop table raw_global_death_pair_province_countries;
-- drop table RAW_global_deaths_without_province_countries;
-- drop table raw_global_death_pair_non_province_countries;
drop table cumul_deaths;
drop table cumul_cases;
drop table date_country_pair_w_ccase_and_death;
drop table worst_country_per_day;
drop table short;

--test group
drop table jan_feb_deaths_cumul;


SET SERVEROUTPUT ON
DECLARE
BEGIN


-- ops.go(ops.project_ra('RAW_global_deaths', allbut('RAW_global_deaths','lat,longitude'), 'RAW_global_deaths_without_lat_long'));
ops.go(ops.group_ra('RAW_global_deaths', 'arbdate,country','cumdeathCount=sum(deathCount)', 'cumul_deaths'));
ops.go(ops.group_ra('RAW_global_confirmed_cases', 'arbdate,country', 'cumconfirmedCount=sum(confirmedCount)', 'cumul_cases'));

-- Attempt at grabbing the last day of results. 
--the problem is the date isolation
-- ops.go(ops.group_ra('cumul_deaths','country','cumdeathCount','lastDate=max(arbdate)', 'final_deaths_per_country'));
-- ops.go(ops.group_ra('cumul_cases','country','cumconfirmedCount','lastDate=max(arbdate)', 'final_cases_per_country'));


--match confirmed cases and deaths by same date,country
--WARNING: this is too big for the full dataset. must be broken down to run on that.
--TODO: 
-- ops.go(ops.mjoin_ra('cumul_deaths','cumul_cases','arbdate,country','arbdate,country','date_country_pair_w_ccase_and_death'));
ops.go(ops.mjoin_ra('d=cumul_deaths','c=cumul_cases','arbdate,country','arbdate,country','short'));
--TODO: attempt to do this join as a for loop and unions.
--???How would I drop the generated tables, if I can't drop in a BEGIN-END block?

--TEST
execute immediate 'DROP TABLE cumul_deaths';
execute immediate 'DROP TABLE cumul_cases';

--does not work
-- execute immediate 'select table_name from user_tables';

-- ops.go(ops.mjoin_ra('a=date_country_pair_w_ccase_and_death','b=date_country_pair_w_ccase_and_death','arbdate,country','arbdate+1,country','day_previousday_pair'));
-- PROTOTYPE ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color,arb_date','color,arb_date+1','prev_day_match_both_dates'));
-- ops.go(ops.mjoin_ra('a=short','b=short','arbdate,country','arbdate+1,country','day_previousday_pair'));
-- ops.go(ops.mjoin_ra('a=short','b=short','arbdate,country','arbdate+1,country','arbdate=a_arbdate,country,a_cumdeathCount,b_cumdeathCount,a_cumconfirmedCount,b_cumconfirmedCount','day_previousday_pair'));
ops.go(ops.mjoin_ra('a=short','b=short','arbdate,country','arbdate+1,country','arbdate=a_arbdate,country','day_previousday_pair'));

--group over arbdate, carry country, func: max(death/case)
--TODO; ops.go(ops.group_ra('date_country_pair_w_ccase_and_death','arbdate','country,worst_death=max(cumdeathCount/cumconfirmedCount)','worst_country_per_day'));

--!!!NOTE: do this later
-- Match deaths and confirmed cases with their previous day data per date,country
-- ops.go(ops.mjoin_ra('a=cumul_deaths','b=cumul_deaths','arbdate,country','arbdate - 1,country','raw_global_death_pair_province_countries'));
-- ops.go(ops.mjoin_ra('a=cumul_cases','b=cumul_cases','arbdate,country','arbdate - 1,country','raw_global_c_case_pair_province_countries'));
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

select * from date_country_pair_w_ccase_and_death where rownum <= 7;
select * from day_previousday_pair where rownum <= 7;
select * from short where rownum <= 7;

