create or replace
view covid19.date_diff_cases as
select
  dc.country,
  coalesce(dc.infected - lag(dc.infected) over(partition by dc.country order by dc.date), dc.infected) as infected,
  coalesce(dc.cured - lag(dc.cured) over(partition by dc.country order by dc.date), dc.cured) as cured,
  coalesce(dc.fatal - lag(dc.fatal) over(partition by dc.country order by dc.date), dc.fatal) as fatal,
  dc.date
from
  covid19.date_cases dc;
