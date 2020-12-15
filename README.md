
Testing push
DH, checking in from the Lab.
DH, checking in at home

Create tables using the script:

@create;
@Insert/Limited_RAW_global_confirmed_cases_insert;
@Insert/Limited_RAW_global_deaths_insert;
@format;
Examine some of the data:
select count(*) from RAW_global_deaths;
select count(*) from RAW_global_deaths;
select * from RAW_global_deaths;
select * from RAW_global_deaths WHERE country in ('Canada','US') AND ROWNUM <= 15;;

//
@Query/Query1;
@Query/query2;
@Query/Query3;

@drop;
