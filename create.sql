CREATE TABLE RAW_global_confirmed_cases(
	"date*" DATE,
 	"country*" VARCHAR2(50),
	 "province*" VARCHAR2(50), 
	 "lat" VARCHAR2(50), 
	 "long" VARCHAR2(50), 
	 "count" int
);

CREATE TABLE RAW_global_deaths(
	"date*" DATE,
 	"country*" VARCHAR2(50),
	 "province*" VARCHAR2(50), 
	 "lat" VARCHAR2(50), 
	 "long" VARCHAR2(50), 
	 "count" int
);
CREATE TABLE RAW_us_confirmed_cases(
	"date*" varchar2(10),
 	"Province_State" VARCHAR2(50),
	 "Admin2" VARCHAR2(50), 
	 "UID" VARCHAR2(50), 
	 "iso2" VARCHAR2(50), 
	 "iso3" VARCHAR2(50), 
	 "code3" VARCHAR2(50),
	 "FIPS" VARCHAR2(50),
	  "Country_Region" VARCHAR2(50),
	 "lat" VARCHAR2(50), 
	 "long_" VARCHAR2(50),
	 "Combined_Key" VARCHAR2(50)
);

CREATE TABLE RAW_us_deaths(
	"date*" varchar2(10),
 	"Province_State" VARCHAR2(50),
	 "Admin2" VARCHAR2(50), 
	 "UID" VARCHAR2(50), 
	 "iso2" VARCHAR2(50), 
	 "iso3" VARCHAR2(50), 
	 "code3" VARCHAR2(50),
	 "FIPS" VARCHAR2(50),
	  "Country_Region" VARCHAR2(50),
	 "lat" VARCHAR2(50), 
	 "long_" VARCHAR2(50),
	 "VARCHAR2(50)," VARCHAR2(50),
	 "Population" int
);