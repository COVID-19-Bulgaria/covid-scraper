drop view covid19.week_places_cases;
drop view covid19.latest_places_cases;
drop view covid19.rolling_biweekly_places_cases;
drop view covid19.date_diff_places_cases;
drop view covid19.date_places_cases;

create or replace
view covid19.date_places_cases as
select
	c.name as country,
	p.id as place_id,
	p.name as place,
	max(pc.infected) as infected,
	max(pc.doses) as doses,
	max(pc.fully_vaccinated) as fully_vaccinated,
	max(pc.booster) as booster,
	date(pc.timestamp) as date
from
	covid19.places_cases pc
join
  covid19.places p on
	pc.place_id = p.id
join
  covid19.countries c on
	p.country_id = c.id
group by
	c.id,
	p.id,
	pc.timestamp::date
order by
	c.name asc,
	p.name asc,
	pc.timestamp::date asc;

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

create or replace
view covid19.week_places_cases as
select
	ddpc.country,
	ddpc.place_id,
	ddpc.place,
	case
		when date_part('month', ddpc.date::date) = 1
		and date_part('week', ddpc.date::date) > 5 then date_part('year', ddpc.date::date) - 1
		else date_part('year', ddpc.date::date)
	end::integer as year,
	date_part('week', ddpc.date::date)::integer as week,
	sum(ddpc.infected) as infected,
	round(avg(ddpc.infected))::integer as infected_avg,
	round(sum(ddpc.infected)::decimal / p.population * 100000)::integer as infected_100k,
	round(avg(ddpc.infected)::decimal * 7 / p.population * 100000)::integer as infected_avg_100k,
    sum(ddpc.doses) as doses,
    round(avg(ddpc.doses))::integer as doses_avg,
    sum(ddpc.fully_vaccinated) as fully_vaccinated,
    round(avg(ddpc.fully_vaccinated))::integer as fully_vaccinated_avg,
    sum(ddpc.booster) as booster,
    round(avg(ddpc.booster))::integer as booster_avg
from
	covid19.date_diff_places_cases ddpc
join
  covid19.places p on
	p.id = ddpc.place_id
join
  covid19.countries c on
	c.id = p.country_id
group by
	ddpc.country,
	ddpc.place_id,
	ddpc.place,
	p.population,
	year,
	week
order by
	ddpc.country asc,
	ddpc.place asc,
	year asc,
	week asc;

create or replace
view covid19.rolling_biweekly_places_cases as
select
	ddpc.country as country,
	p.id as place_id,
	ddpc.place as place,
	sum(ddpc.infected) as infected,
    round(avg(ddpc.infected))::integer as infected_avg,
	round(avg(ddpc.infected)::decimal * 14 / p.population * 100000)::integer as infected_avg_100k,
	sum(ddpc.doses) as doses,
    round(avg(ddpc.doses))::integer as doses_avg,
    sum(ddpc.fully_vaccinated) as fully_vaccinated,
    round(avg(ddpc.fully_vaccinated))::integer as fully_vaccinated_avg,
    sum(ddpc.booster) as booster,
    round(avg(ddpc.booster))::integer as booster_avg,
	max(ddpc.date) as date
from
	(
	select
		ddpc.*,
		date_bin('14 day',
		ddpc.date - interval '14 DAY',
		(
		select
			max(date)
		from
			covid19.date_diff_places_cases)) as grp
	from
		covid19.date_diff_places_cases ddpc
) ddpc
join
  covid19.countries c on
	c.name = ddpc.country
join
  covid19.places p on
	p.name = ddpc.place
	and p.country_id = c.id
group by
	ddpc.country,
	ddpc.place,
	ddpc.grp,
	p.id,
	p.population
order by
	ddpc.country asc,
	ddpc.place asc,
	max(ddpc.date) asc;

create or replace
view covid19.latest_places_cases as
select
	distinct on
	(pc.place_id) pc.place_id,
	p.name,
	p.country_id,
	p.latitude,
	p.longitude,
	pc.infected,
	ddpc.infected as newly_infected,
	rbpc.infected_avg_100k as infected_14d_100k,
    pc.doses,
    ddpc.doses as new_doses,
    pc.fully_vaccinated,
    ddpc.fully_vaccinated as new_fully_vaccinated,
    pc.booster,
    ddpc.booster as new_booster,
	pc.timestamp
from
	covid19.places_cases pc
join covid19.places p on
	pc.place_id = p.id
join (
	select
		distinct on
		(ddpc.place_id) ddpc.*
	from
		covid19.date_diff_places_cases ddpc
	order by
		ddpc.place_id,
		ddpc.date desc) ddpc on
	ddpc.place_id = pc.place_id
join (
	select
		distinct on
		(rbpc.place_id) rbpc.*
	from
		covid19.rolling_biweekly_places_cases rbpc
	order by
		rbpc.place_id,
		rbpc.date desc) rbpc on
	rbpc.place_id = pc.place_id
order by
	pc.place_id,
	pc.timestamp desc;
