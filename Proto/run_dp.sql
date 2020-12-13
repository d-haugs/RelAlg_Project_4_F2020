-- @@drop

SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Prototype using mjoin
ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color','color','p_mj_cdate'));

--Prototype use of group
ops.go(ops.group_ra('proto_consec_date','color','count_sum=sum(count)','color_plus_count_sum'));

--Incomplete attempt to subtract previous day from today
-- ops.go(ops.group_ra('proto_consec_date','color','count_sum=sum(count)','color_plus_count_sum'));

-- Prototype using mjoin to match consecutive values of date (for getting to difference from yesterday)
ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color,arb_date','color,arb_date-1','prev_day_match'));



END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

select * from p_mj_cdate;

DROP TABLE p_mj_cdate;


select * from color_plus_count_sum;

DROP TABLE color_plus_count_sum;

select * from prev_day_match;

DROP TABLE prev_day_match;