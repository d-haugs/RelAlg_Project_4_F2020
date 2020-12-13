

SET SERVEROUTPUT ON
DECLARE
BEGIN

ops.filter_ra('proto_consec_date','count='2'','filter_test');


END;
/

select * from filter_test;