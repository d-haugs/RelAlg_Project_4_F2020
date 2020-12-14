--drop table daily_count_global_death;


SET SERVEROUTPUT ON
DECLARE
BEGIN

ops.go(ops.project_ra('RAW_global_deaths','country,province,arbdate,deathCount,arbitraryID','raw_global_death_no_lat_long'));
-- Outer join RAW_global_deaths with itself on country, province, 1 day difference
ops.go(ops.cjoin_ra('a=raw_global_death_no_lat_long','b=raw_global_death_no_lat_long','a.country=b.country and decode(a.province,b.province,1,0)=1 and a.arbdate=b.arbdate-1','raw_global_death_pair'));


-- project out first date and subtract counts
--ops.go(ops.project_ra('raw_global_death_pair','country, province, arbdate = b_arbdate, daily_death_count = b_deathcount - a_deathcount,a_arbitraryID, b_arbitraryID','daily_count_global_death'));

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

select country,province,a_arbdate,a_deathcount,b_arbdate,b_deathcount from raw_global_death_pair where rownum <= 1;
drop table raw_global_death_no_lat_long;
drop table raw_global_death_pair;
--select * from daily_count_global_death where rownum <= 1;
