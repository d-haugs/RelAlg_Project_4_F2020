

CREATE TABLE proto_consec_date(
  "date*" DATE,
  "color*" VARCHAR2(50),
  "count" int
);

INSERT INTO proto_consec_date  VALUES('31/01/20','blue',1);
INSERT INTO proto_consec_date  VALUES('01/02/20','blue',2);
INSERT INTO proto_consec_date  VALUES('02/02/20','blue',4);
INSERT INTO proto_consec_date  VALUES('03/02/20','blue',8);

set wrap off
set line 160