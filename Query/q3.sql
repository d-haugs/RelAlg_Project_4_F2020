-- drop table raw_global_death_pair;
-- drop table daily_count_global_death;
-- drop table raw_global_death_pair_province_countries;
-- drop table RAW_global_deaths_without_province_countries;
-- drop table raw_global_death_pair_non_province_countries;
drop table cumul_deaths;
drop table cumul_cases;
drop table date_country_pair_w_ccase_and_death;
drop table worst_country_per_day;
drop table short_name;

--dropping good faith generated tables
drop table single_date_day_previousday_pair;
drop table prev_day_difference;
drop table daily_case_death_datecountry_pair;
drop table daily_data_without_0_cases;
drop table worst_ratio_per_date;
drop table days_count_as_worst_country;
drop table most_days_as_worst_country;

--test group
-- drop table jan_feb_deaths_cumul;


SET SERVEROUTPUT ON
DECLARE
BEGIN


ops.go(ops.group_ra('RAW_global_deaths', 'arbdate,country','cumdeathCount=sum(deathCount)', 'cumul_deaths'));
ops.go(ops.group_ra('RAW_global_confirmed_cases', 'arbdate,country', 'cumconfirmedCount=sum(confirmedCount)', 'cumul_cases'));

--match confirmed cases and deaths by same date,country
--WARNING: this is too big for the full dataset. must be broken down to run on that.
ops.go(ops.mjoin_ra('d=cumul_deaths','c=cumul_cases','arbdate,country','arbdate,country','short_name'));

--does not work
-- execute immediate 'select table_name from user_tables';

ops.go(ops.mjoin_ra('a=short_name','b=short_name','country,arbdate-1','country,arbdate','day_previousday_pair'));

-- ======================================
-- NOTE: following RA operations are written on good faith that the preceding operations have run despite backend problems with an earlier match join
-- ======================================
ops.go(ops.reduce_ra('day_previousday_pair','arbdate=a_arbdate,country','a_cumdeathCount,b_cumdeathCount,a_cumconfirmedCount,b_cumconfirmedCount','single_date_day_previousday_pair'));
ops.go(ops.project_ra('prev_day_match','arbitraryid,arb_date,color,count_change=a_count-b_count','prev_day_difference'));
ops.go(ops.project_ra('single_date_day_previousday_pair','arbdate,country,day_deaths=a_cumdeathCount-b_cumdeathCount,day_cases=a_cumconfirmedCount-b_cumconfirmedCount','daily_case_death_datecountry_pair'));
ops.go(ops.filter_ra('daily_case_death_datecountry_pair','day_cases!=0','daily_data_without_0_cases'));
ops.go(ops.group_ra('daily_data_without_0_cases','arbdate','country','worst_ratio=max(day_death/day_cases)','worst_ratio_per_date'));
ops.go(ops.group_ra('worst_ratio_per_date','country','country_count=count(*)','days_count_as_worst_country'));
ops.go(ops.group_ra('days_count_as_worst_country','country','most_days=max(country_count)','most_days_as_worst_country'));


END;
/

select * from date_country_pair_w_ccase_and_death where rownum <= 7;
select * from day_previousday_pair where rownum <= 7;
select * from short_name where rownum <= 7;

