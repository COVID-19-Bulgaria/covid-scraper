drop view covid19.week_places_cases;
drop view covid19.date_diff_places_cases;

create or replace
view covid19.date_diff_places_cases as
select
  coalesce(dpc.country, adc.country) as country,
  coalesce(dpc.place, adc.place) as place,
  case when dpc.infected is null
  	then adc.infected
  	else coalesce(dpc.infected - coalesce(lag(dpc.infected) over(partition by dpc.country, dpc.place order by dpc.date), dpc.infected), dpc.infected)
  end as infected,
  coalesce(dpc.date, adc.date) as date
from
  covid19.date_places_cases dpc
right join
  (
  	select
			c.name as country,
			p.name as place,
			0 as infected,
			d::date as date
		from
			generate_series('2020-06-08'::date, current_date, '1 day'::interval) d,
			covid19.places p
		join
			covid19.countries c on c.id = p.country_id
		where
			p.name in ('Благоевград', 'Бургас', 'Варна', 'Велико Търново', 'Видин', 'Враца', 'Габрово', 'Добрич', 'Кърджали', 'Кюстендил', 'Ловеч', 'Монтана', 'Пазарджик', 'Перник', 'Плевен', 'Пловдив', 'Разград', 'Русе', 'Силистра', 'Сливен', 'Смолян', 'София', 'Стара Загора', 'Търговище', 'Хасково', 'Шумен', 'Ямбол')
	) adc on adc.country = dpc.country and adc.place = dpc.place and adc.date = dpc.date
order by
	adc.country asc,
	adc.place asc,
	adc.date asc;

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
  round(avg(ddpc.infected))::integer as infected_avg,
  round(sum(ddpc.infected)::decimal / p.population * 100000)::integer as infected_100k,
  round(avg(ddpc.infected)::decimal * 7 / p.population * 100000)::integer as infected_avg_100k
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