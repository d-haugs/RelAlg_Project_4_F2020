--Testing push DH, checking in from the Lab. DH, checking in at home

--Create tables using the script:

@create; 
@Insert/Limited_RAW_global_confirmed_cases_insert; 
@Insert/Limited_RAW_global_deaths_insert; 
@format; 

--Examine some of the data: 
select count() from RAW_global_deaths; 
select count() from RAW_global_deaths; 
select * from RAW_global_deaths; 
select * from RAW_global_deaths WHERE country in ('Canada','US') AND ROWNUM <= 15;

// 
@Query/Query1; 
@Query/query2; 
@Query/Query3;

@drop;



--Query1
SET SERVEROUTPUT ON
DECLARE
BEGIN

--Project off latitude, longitude
ops.go(ops.project_ra('RAW_global_deaths','country,province,arbdate,deathCount,arbitraryID','raw_global_death_no_lat_long'));

--Group by country to sum possible province data
ops.go(ops.group_ra('raw_global_death_no_lat_long','country,arbdate','country_death_count=sum(deathCount)','global_death_by_country'));

--match join global death with itself on country and date-1 to get consecutive day counts
ops.go(ops.mjoin_ra('a=global_death_by_country','b=global_death_by_country','country,arbdate','country,arbdate-1','global_daily_death_by_country'));

--reduce identifier to only need the later date
ops.go(ops.reduce_ra('global_daily_death_by_country','country,arbdate=b_arbdate','b_country_death_count,a_country_death_count','r_global_daily_death_by_country'));

--project the counts as the differences of each other
ops.go(ops.project_ra('r_global_daily_death_by_country','country,arbdate,country_daily_death_count = b_country_death_count - a_country_death_count','daily_death_count_by_country'));

--find worst death total for a singular day for a country
ops.go(ops.group_ra('daily_death_count_by_country','country','worst_count=max(country_daily_death_count)','worst_daily_death_count_by_country'));

--match join back with the previous result to bring the date back in (better than carry on previous fucntion as no risk of non-relational data
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


--query2
DROP TABLE death_count_by_country_date_pair;
DROP TABLE confirmed_count_by_country_date_pair;
DROP TABLE confirmeddeath_pair_for_country;
DROP TABLE FILTER_CONFIRMEDDEATH_FOR_COUNTRY;
DROP TABLE country_deathToConfirmed_ratio;
DROP TABLE death_confirmed_ratio_WithMaxDate;
DROP TABLE final_confirmeddeath_ratio;
SET SERVEROUTPUT ON
DECLARE
BEGIN
-- Group  on RAW_global_deaths table on arbdate,country get sum of deathCount
ops.go(ops.group_ra('RAW_global_deaths','arbdate,country','death_case_count=sum(deathCount)','death_count_by_country_date_pair'));

-- Group  on RAW_global_confirmed_cases table arbdate,country get sum of confirmedCount
ops.go(ops.group_ra('RAW_global_confirmed_cases','arbdate,country','confirmed_case_count=sum(confirmedCount)','confirmed_count_by_country_date_pair'));

-- Match join both confirmed_count_by_country_date_pair and death_count_by_country_date_pair table on country,arbdate and  got confirmeddeath_pair_for_country table
ops.go(ops.mjoin_ra('a=confirmed_count_by_country_date_pair','b=death_count_by_country_date_pair','country,arbdate','country,arbdate','country,arbdate,death_case_count,confirmed_case_count','confirmeddeath_pair_for_country')); 

-- Filter out confirmed_case_count zero values to avoid divide by 0 issue while doing deathcount/confirmed cases count and got filter_confirmeddeath_for_country table
ops.go(ops.filter_ra('confirmeddeath_pair_for_country','confirmed_case_count!=0','filter_confirmeddeath_for_country'));

--  Project to get deathToConfirmedRatio=death_case_count/confirmed_case_count got country_deathToConfirmed_ratio
ops.go(ops.project_ra('filter_confirmeddeath_for_country','country,arbdate,deathToConfirmedRatio=death_case_count/confirmed_case_count','country_deathToConfirmed_ratio'));

-- Group By country to get Max date and got death_confirmed_ratio_WithMaxDate
ops.go(ops.group_ra('country_deathToConfirmed_ratio','country','new_Date=max(arbdate)','death_confirmed_ratio_WithMaxDate'));

-- MJ  death_confirmed_ratio_WithMaxDate to country_deathToConfirmed_ratio to get final_confirmeddeath_ratio by country
ops.go(ops.mjoin_ra('a=country_deathToConfirmed_ratio','b=death_confirmed_ratio_WithMaxDate','country,arbdate','country,new_Date','country,arbdate,deathToConfirmedRatio','final_confirmeddeath_ratio')); 


END;
/
select count(*) from RAW_global_deaths;
select count(*) from RAW_global_confirmed_cases;
--  to get order from worest to best death to confirmed case ratios
select arbdate,country,deathToConfirmedRatio from final_confirmeddeath_ratio order By deathToConfirmedRatio DESC;


--q3
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


SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Generate RAW_deaths_per_country
ops.go(ops.group_ra('RAW_global_deaths', 'arbdate,country','cumdeathCount=sum(deathCount)', 'cumul_deaths'));
-- Generate RAW_confirmed_cases_per_country
ops.go(ops.group_ra('RAW_global_confirmed_cases', 'arbdate,country', 'cumconfirmedCount=sum(confirmedCount)', 'cumul_cases'));

--match confirmed cases and deaths by same date,country
--WARNING: this is too big for the full dataset. must be broken down to run on that.
--Generate Matched date-country pair with confirmed cases and deaths
ops.go(ops.mjoin_ra('d=cumul_deaths','c=cumul_cases','arbdate,country','arbdate,country','short_name'));

--Generate date and previous date matched date-country pair with confirmed cases and deaths
ops.go(ops.mjoin_ra('a=short_name','b=short_name','country,arbdate-1','country,arbdate','day_previousday_pair'));

-- ======================================
-- NOTE: following RA operations are written on good faith that the preceding operations have run despite backend problems with an earlier match join
-- ======================================
-- Generate date and previous date matched date-country pair with confirmed cases and deaths with 'a_' 'b_' dates removed
ops.go(ops.reduce_ra('day_previousday_pair','arbdate=a_arbdate,country','a_cumdeathCount,b_cumdeathCount,a_cumconfirmedCount,b_cumconfirmedCount','single_date_day_previousday_pair'));
-- Generate Daily cases and deaths of date-country pair
ops.go(ops.project_ra('single_date_day_previousday_pair','arbdate,country,day_deaths=a_cumdeathCount-b_cumdeathCount,day_cases=a_cumconfirmedCount-b_cumconfirmedCount','daily_case_death_datecountry_pair'));
-- Generate Daily cases and deaths of date-country pair without case=0
ops.go(ops.filter_ra('daily_case_death_datecountry_pair','day_cases!=0','daily_data_without_0_cases'));
-- Generate Worst ratio Per date with country
ops.go(ops.group_ra('daily_data_without_0_cases','arbdate','country','worst_ratio=max(day_death/day_cases)','worst_ratio_per_date'));
-- Generate Day count as worst country
ops.go(ops.group_ra('worst_ratio_per_date','country','country_count=count(*)','days_count_as_worst_country'));
-- Generate Most Days as worst ratio of country
ops.go(ops.group_ra('days_count_as_worst_country','country','most_days=max(country_count)','most_days_as_worst_country'));


END;
/

select * from date_country_pair_w_ccase_and_death where rownum <= 7;
select * from day_previousday_pair where rownum <= 7;
select * from short_name where rownum <= 7;
