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
-- with 'color' as a stand-in for the rest of your real relation's itentifier
-- path operators in the column references are still the value specified, but will match the date that is the result of the math operator.
-- adding to b_arb_date will match b to "tomorrow" for itself, making a the latter date.
ops.go(ops.mjoin_ra('a=proto_consec_date','b=proto_consec_date','color,arb_date','color,arb_date+1','prev_day_match_both_dates'));
-- Prototype 'unifying' my new relation into the desired calculation.
ops.go(ops.reduce_ra('prev_day_match_both_dates','arb_date=a_arb_date,arbitraryid=a_arbitraryid,color,a_count,b_count','prev_day_match'));
ops.go(ops.project_ra('prev_day_match','arb_date,arbitraryid,color,count_change=a_count-b_count','prev_day_difference'));


-- Prototype 'full minus' of in congruent relations
ops.go(ops.full_minus_ra('proto_consec_date','prev_day_difference','arb_date','proto_full_minus'));


END;
/


-- ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

select * from p_mj_cdate;
DROP TABLE p_mj_cdate;

select * from color_plus_count_sum;
DROP TABLE color_plus_count_sum;


select * from prev_day_match_both_dates;
DROP TABLE prev_day_match_both_dates;

select * from prev_day_match;
DROP TABLE prev_day_match;

select * from prev_day_difference;
DROP TABLE prev_day_difference;

select * from proto_full_minus;
DROP TABLE proto_full_minus;