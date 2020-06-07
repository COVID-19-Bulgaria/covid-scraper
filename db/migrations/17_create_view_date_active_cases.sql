create or replace
view covid19.date_active_cases as
select
  dc.country,
  (dc.infected - dc.cured - dc.fatal) as active,
  dc.date
from covid19.date_cases dc
order by
  dc.date asc;
