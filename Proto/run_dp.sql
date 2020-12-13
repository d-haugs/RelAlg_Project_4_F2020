-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color','color','p_mj_cdate'));
ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color','color','a.arbitraryID,b.arbitraryID,a.date,b.date,color,a.count,b.count','p_mj_cdate'));

-- ops.go(ops.group_ra('color',))

END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));
