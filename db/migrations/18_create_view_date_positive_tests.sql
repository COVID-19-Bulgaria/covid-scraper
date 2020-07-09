create or replace
view covid19.date_positive_tests as
select
  dc.country,
  round(dc.infected::decimal / dc.pcr_tests * 100, 2) as positive_percentage,
  dc.date
from covid19.date_diff_cases dc
where
  dc.pcr_tests is not null
and
  dc.date > '2020-06-06'
order by
  dc.date asc;
