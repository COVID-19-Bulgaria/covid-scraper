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