--@create;
--@Insert/DENORMALIZED_RAW_global_deaths_insert

drop table raw_global_death_no_lat_long;
drop table global_death_by_country;
drop table global_death_by_country_1;
drop table global_daily_death_by_country;
drop table r_global_daily_death_by_country;
drop table daily_death_count_by_country;
drop table worst_daily_death_count_by_country;
drop table worst_daily_death_count_by_country_with_date;

SET SERVEROUTPUT ON
DECLARE
BEGIN

--Project off latitude, longitude
ops.go(ops.project_ra('RAW_global_deaths','country,province,arbdate,deathCount,arbitraryID','raw_global_death_no_lat_long'));

--Group by country to sum possible province data
ops.go(ops.group_ra('raw_global_death_no_lat_long','country,arbdate','country_death_count=sum(deathCount)','global_death_by_country'));

ops.go(ops.project_ra('global_death_by_country','country,arbdate=arbdate-1,country_death_count','global_death_by_country_1'));

--match join global death with itself on country and date-1 to get consecutive day counts
ops.go(ops.mjoin_ra('a=global_death_by_country','b=global_death_by_country_1','country,arbdate','country,arbdate','global_daily_death_by_country'));

--reduce identifier to only need the later date
--ops.go(ops.reduce_ra('global_daily_death_by_country','country,arbdate=b_arbdate','b_country_death_count,a_country_death_count','r_global_daily_death_by_country'));

--project the counts as the differences of each other
ops.go(ops.project_ra('global_daily_death_by_country','country,arbdate,country_daily_death_count = b_country_death_count - a_country_death_count','daily_death_count_by_country'));

--find worst death total for a singular day for a country
ops.go(ops.group_ra('daily_death_count_by_country','country','worst_count=max(country_daily_death_count)','worst_daily_death_count_by_country'));

--match join back with the previous result to bring the date back in (better than carry on previous fucntion as no risk of non-relational data
ops.go(ops.mjoin_ra('o=daily_death_count_by_country','w=worst_daily_death_count_by_country','country,country_daily_death_count','country,worst_count','worst_daily_death_count_by_country_with_date'));

END;
/


select * from worst_daily_death_count_by_country_with_date where rownum <= 30;