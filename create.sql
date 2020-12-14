CREATE TABLE RAW_global_confirmed_cases(
	arbitraryID VARCHAR2(32) primary key,
	arbdate DATE,
 	country VARCHAR2(50),
	province VARCHAR2(50), 
	lat VARCHAR2(50), 
	longitude VARCHAR2(50), 
	confirmedCount int
);

CREATE TABLE RAW_global_deaths(
	arbitraryID VARCHAR2(32) primary key,
	arbdate DATE,
 	country VARCHAR2(50),
	province VARCHAR2(50), 
	lat VARCHAR2(50), 
	longitude VARCHAR2(50), 
	deathCount int
);
