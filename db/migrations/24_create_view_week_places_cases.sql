drop view covid19.week_places_cases;
create or replace
view covid19.week_places_cases as
select
  ddpc.country,
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
  ddpc.country,
  ddpc.place,
  year,
  week
order by
  ddpc.country asc,
  ddpc.place asc,
  year asc,
  week asc;