ALTER TABLE "covid19"."cases"
ADD COLUMN pcr_tests integer;

drop view covid19.date_diff_cases;
drop view covid19.date_cases;

create or replace
view covid19.date_cases as
select
  ctr.name as country,
  max(c.infected) as infected,
  max(c.cured) as cured,
  max(c.fatal) as fatal,
  max(c.men) as men,
  max(c.women) as women,
  max(c.hospitalized) as hospitalized,
  max(c.intensive_care) as intensive_care,
  max(c.medical_staff) as medical_staff,
  max(c.pcr_tests) as pcr_tests,
  date(c.timestamp) as date
from
  covid19.cases c
join
  covid19.countries ctr on c.country_id = ctr.id
group by
  ctr.id,
  c.timestamp::date;

create or replace
view covid19.date_diff_cases as
select
  dc.country,
  coalesce(dc.infected - lag(dc.infected) over(partition by dc.country order by dc.date), dc.infected) as infected,
  coalesce(dc.cured - lag(dc.cured) over(partition by dc.country order by dc.date), dc.cured) as cured,
  coalesce(dc.fatal - lag(dc.fatal) over(partition by dc.country order by dc.date), dc.fatal) as fatal,
  coalesce(dc.men - lag(dc.men) over(partition by dc.country order by dc.date), dc.men) as men,
  coalesce(dc.women - lag(dc.women) over(partition by dc.country order by dc.date), dc.women) as women,
  coalesce(dc.hospitalized - lag(dc.hospitalized) over(partition by dc.country order by dc.date), dc.hospitalized) as hospitalized,
  coalesce(dc.intensive_care - lag(dc.intensive_care) over(partition by dc.country order by dc.date), dc.intensive_care) as intensive_care,
  coalesce(dc.medical_staff - lag(dc.medical_staff) over(partition by dc.country order by dc.date), dc.medical_staff) as medical_staff,
  coalesce(dc.pcr_tests - lag(dc.pcr_tests) over(partition by dc.country order by dc.date), dc.pcr_tests) as pcr_tests,
  dc.date
from
  covid19.date_cases dc;
