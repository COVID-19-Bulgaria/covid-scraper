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
    case
        when dpc.doses is null
            then null
        else coalesce(dpc.doses - coalesce(lag(dpc.doses) over(partition by dpc.country, dpc.place order by dpc.date), dpc.doses), dpc.doses)
    end as doses,
    case
        when dpc.fully_vaccinated is null
            then null
        else coalesce(dpc.fully_vaccinated - coalesce(lag(dpc.fully_vaccinated) over(partition by dpc.country, dpc.place order by dpc.date), dpc.fully_vaccinated), dpc.fully_vaccinated)
    end as fully_vaccinated,
    case
        when dpc.booster is null
            then null
        else coalesce(dpc.booster - coalesce(lag(dpc.booster) over(partition by dpc.country, dpc.place order by dpc.date), dpc.booster), dpc.booster)
    end as booster,
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
            0 as doses,
            0 as fully_vaccinated,
            0 as booster,
			d::date as date
	from
			generate_series('2020-06-08'::date, current_date + 1, '1 day'::interval) d,
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