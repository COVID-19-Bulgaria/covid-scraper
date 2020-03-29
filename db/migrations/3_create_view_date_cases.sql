create or replace
view covid19.date_cases as
select
  c.country,
  max(c.infected) as infected,
  max(c.cured) as cured,
  max(c.fatal) as fatal,
  date(c.timestamp) as date
from
  covid19.cases c
group by
  c.country,
  c.timestamp::date;
