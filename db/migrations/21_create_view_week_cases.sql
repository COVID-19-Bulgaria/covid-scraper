drop view covid19.week_cases;
create or replace
view covid19.week_cases as
select
  ddc.country,
  case
    when date_part('month', ddc.date::date) = 1 and date_part('week', ddc.date::date) > 5 then date_part('year', ddc.date::date) - 1
    else date_part('year', ddc.date::date)
  end as year,
  date_part('week', ddc.date::date) as week,
  sum(ddc.infected) as infected,
  sum(ddc.cured) as cured,
  sum(ddc.fatal) as fatal,
  sum(case when ddc.hospitalized > 0 then ddc.hospitalized else 0 end) as hospitalized,
  sum(case when ddc.intensive_care > 0 then ddc.intensive_care else 0 end) as intensive_care,
  sum(ddc.medical_staff) as medical_staff,
  sum(ddc.pcr_tests) as pcr_tests,
  sum(ddc.antigen_tests) as antigen_tests,
  sum(ddc.vaccinated) as vaccinated
from
  covid19.date_diff_cases ddc
group by
  ddc.country,
  year,
  week
order by
  ddc.country asc,
  year asc,
  week asc;

create or replace
view covid19.date_places_cases as
select
  p.name as place,
  max(pc.infected) as infected,
  date(pc.timestamp) as date
from
  covid19.places_cases pc
join
  covid19.places p on pc.place_id = p.id
group by
  p.id,
  pc.timestamp::date
order by
  p.name asc,
  pc.timestamp::date asc;

create or replace
view covid19.date_diff_places_cases as
select
  dpc.place,
  coalesce(dpc.infected - lag(dpc.infected) over(partition by dpc.place order by dpc.date), dpc.infected) as infected,
  dpc.date
from
  covid19.date_places_cases dpc;

create or replace
view covid19.week_places_cases as
select
  ddpc.place,
  case
    when date_part('month', ddpc.date::date) = 1 and date_part('week', ddpc.date::date) > 5 then date_part('year', ddpc.date::date) - 1
    else date_part('year', ddpc.date::date)
  end as year,
  date_part('week', ddpc.date::date) as week,
  sum(ddpc.infected) as infected
from
  covid19.date_diff_places_cases ddpc
group by
  ddpc.place,
  year,
  week
order by
  ddpc.place asc,
  year asc,
  week asc;