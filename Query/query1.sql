-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Group song streams over song_id to get "ID of song with its total number of streams"
ops.go(ops.mjoin_ra('a=RAW_global_deaths','b=RAW_global_deaths','country,province','country,province','raw_global_death_pair')); 

-- Match Join all song data to get back "Song with its total number of streams"
-- ops.go(ops.mjoin_ra('song','id_of_song_with_total_streams','song_id','song_id','song_with_total_streams'));

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

select * from raw_global_death_pair where rownum <= 30;
DROP TABLE raw_global_death_pair;
