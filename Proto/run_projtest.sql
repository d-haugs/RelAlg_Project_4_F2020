-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('prev_day_match','arbitraryid','prev_day_difference'));
ops.go(ops.project_ra('proto_consec_date','arbitraryid,arb_date','project_proto'));


-- Prototype 'full minus' of in congruent relations
-- ops.go(ops.full_minus_ra('proto_consec_date','prev_day_difference','arb_date','arb_date','proto_full_minus'));


END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

select * from project_proto;
DROP TABLE project_proto;