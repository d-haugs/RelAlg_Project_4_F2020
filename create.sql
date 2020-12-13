CREATE TABLE RAW_global_confirmed_cases(
	"arbitoryID" VARCHAR2(32),
	"date" DATE,
 	"country" VARCHAR2(50),
	 "province" VARCHAR2(50), 
	 "lat" VARCHAR2(50), 
	 "long" VARCHAR2(50), 
	 "count" int
);

CREATE TABLE RAW_global_deaths(
	"arbitoryID" VARCHAR2(32),
	"date" DATE,
 	"country" VARCHAR2(50),
	 "province" VARCHAR2(50), 
	 "lat" VARCHAR2(50), 
	 "long" VARCHAR2(50), 
	 "count" int
);
