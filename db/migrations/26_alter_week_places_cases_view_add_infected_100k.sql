drop view covid19.week_places_cases;
create or replace
view covid19.week_places_cases as
select
  ddpc.country,
  ddpc.place,
  case
    when date_part('month', ddpc.date::date) = 1 and date_part('week', ddpc.date::date) > 5 then date_part('year', ddpc.date::date) - 1
    else date_part('year', ddpc.date::date)
  end::integer as year,
  date_part('week', ddpc.date::date)::integer as week,
  sum(ddpc.infected) as infected,
  round(sum(ddpc.infected)::decimal / p.population * 100000)::integer as infected_100k
from
  covid19.date_diff_places_cases ddpc
join
  covid19.countries c on c.name = ddpc.country
join
  covid19.places p on p.name = ddpc.place and p.country_id = c.id
group by
  ddpc.country,
  ddpc.place,
  p.population,
  year,
  week
order by
  ddpc.country asc,
  ddpc.place asc,
  year asc,
  week asc;