

CREATE TABLE Play_data(
  "C_id	" VARCHAR(32) primary key,
  "S_code" VARCHAR2(50),
  "Score" int
);

INSERT INTO Play_data  VALUES(1,'A',1);
INSERT INTO Play_data  VALUES(1,'E',3);
INSERT INTO Play_data  VALUES(1,'Z',1);
INSERT INTO Play_data  VALUES(2,'A',3);
INSERT INTO Play_data  VALUES(3,'A',2);
INSERT INTO Play_data  VALUES(3,'Z',2);
INSERT INTO Play_data  VALUES(4,'E',2);
INSERT INTO Play_data  VALUES(5,'Z',3);
INSERT INTO Play_data  VALUES(6,'Z',3);
INSERT INTO Play_data  VALUES(7,'E',3);
INSERT INTO Play_data  VALUES(8,'O',1);

set wrap off
set line 400