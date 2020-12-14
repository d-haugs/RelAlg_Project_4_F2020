--@create;
--@Insert/DENORMALIZED_RAW_global_deaths_insert

SET SERVEROUTPUT ON
DECLARE
BEGIN

ops.go(ops.project_ra('RAW_global_deaths','country,province,arbdate,deathCount,arbitraryID','raw_global_death_no_lat_long'));

ops.go(ops.group_ra('raw_global_death_no_lat_long','country,arbdate','country_death_count=sum(deathCount)','global_death_by_country'));

ops.go(ops.mjoin_ra('a=global_death_by_country','b=global_death_by_country','country,arbdate','country,arbdate-1','global_daily_death_by_country'));

ops.go(ops.reduce_ra('global_daily_death_by_country','country,arbdate=b_arbdate','b_country_death_count,a_country_death_count','r_global_daily_death_by_country'));

ops.go(ops.project_ra('r_global_daily_death_by_country','country,arbdate,country_daily_death_count = b_country_death_count - a_country_death_count','daily_death_count_by_country'));

ops.go(ops.group_ra('daily_death_count_by_country','country','worst_count=max(country_daily_death_count)','worst_daily_death_count_by_country'));

ops.go(ops.mjoin_ra('o=daily_death_count_by_country','w=worst_daily_death_count_by_country','country,country_daily_death_count','country,worst_count','worst_daily_death_count_by_country_with_date'));

END;
/

drop table raw_global_death_no_lat_long;
drop table global_death_by_country;
drop table global_daily_death_by_country;
drop table r_global_daily_death_by_country;
drop table daily_death_count_by_country;
drop table worst_daily_death_count_by_country;
select * from worst_daily_death_count_by_country_with_date where rownum <= 30;
drop table worst_daily_death_count_by_country_with_date;