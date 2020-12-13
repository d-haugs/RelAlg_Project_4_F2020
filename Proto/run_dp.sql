-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

-- ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color','color','p_mj_cdate'));

ops.go(ops.group_ra('proto_consec_date','color','count_sum=sum(count)','color_plus_count_sum'));

END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

select * from color_plus_count_sum;

DROP TABLE color_plus_count_sum;