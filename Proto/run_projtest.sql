-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.project_ra('prev_day_match','arbitraryid','prev_day_difference'));
ops.go(ops.project_ra('proto_consec_date','arbitraryid,arb_date','project_proto'));
ops.go(ops.project_ra('proto_consec_date',allbut('count'),'allbut_proto'));




END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

select * from project_proto;
DROP TABLE project_proto;

select * from allbut_proto;
DROP TABLE allbut_proto;