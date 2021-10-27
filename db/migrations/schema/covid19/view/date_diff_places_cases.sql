create or replace
view covid19.date_diff_places_cases as
select
	coalesce(dpc.country, adc.country) as country,
	coalesce(dpc.place_id, adc.place_id) as place_id,
	coalesce(dpc.place, adc.place) as place,
	case
		when dpc.infected is null
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
			p.id as place_id,
			p.name as place,
			0 as infected,
			d::date as date
	from
			generate_series('2020-06-08'::date, current_date, '1 day'::interval) d,
			covid19.places p
	join
			covid19.countries c on
		c.id = p.country_id
	where
			p.name in ('Благоевград', 'Бургас', 'Варна', 'Велико Търново', 'Видин', 'Враца', 'Габрово', 'Добрич', 'Кърджали', 'Кюстендил', 'Ловеч', 'Монтана', 'Пазарджик', 'Перник', 'Плевен', 'Пловдив', 'Разград', 'Русе', 'Силистра', 'Сливен', 'Смолян', 'София', 'София област', 'Стара Загора', 'Търговище', 'Хасково', 'Шумен', 'Ямбол')
	) adc on
	adc.country = dpc.country
	and adc.place = dpc.place
	and adc.date = dpc.date
order by
	adc.country asc,
	adc.place asc,
	adc.date asc;