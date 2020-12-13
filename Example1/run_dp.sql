--@@drop C_id _um_of score

SET SERVEROUTPUT ON
DECLARE
BEGIN


ops.go(ops.group_ra('Play_data','C_id','Sum_score=sum(score)','C_id_um_of score'))


END;
/


select * from C_id_um_of score;