drop view covid19.date_diff_places_cases;
create or replace
view covid19.date_diff_places_cases as
select
  dpc.country,
  dpc.place,
  coalesce(dpc.infected - lag(dpc.infected) over(partition by dpc.country, dpc.place order by dpc.date), dpc.infected) as infected,
  dpc.date
from
  covid19.date_places_cases dpc;