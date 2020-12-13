

CREATE TABLE proto_consec_date(
  "arbitraryID" VARCHAR(32) primary key,
  "date" DATE,
  "color" VARCHAR2(50),
  "count" int
);

INSERT INTO proto_consec_date  VALUES(sys_guid(),TO_DATE('31/01/2020','DD/MM/YYYY'),'blue',1);
INSERT INTO proto_consec_date  VALUES(sys_guid(),TO_DATE('01/02/2020','DD/MM/YYYY'),'blue',2);
INSERT INTO proto_consec_date  VALUES(sys_guid(),TO_DATE('02/02/2020','DD/MM/YYYY'),'blue',4);
INSERT INTO proto_consec_date  VALUES(sys_guid(),TO_DATE('03/02/2020','DD/MM/YYYY'),'blue',8);

set wrap off
set line 160