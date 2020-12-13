

CREATE TABLE proto_consec_date(
  "date*" DATE,
  "color*" VARCHAR2(50),
  "count" int
);

INSERT INTO proto_consec_date('1/31/20','blue',1);
INSERT INTO proto_consec_date('2/1/20','blue',2);
INSERT INTO proto_consec_date('2/2/20','blue',4);
INSERT INTO proto_consec_date('2/3/20','blue',8);

set wrap off
set line 160