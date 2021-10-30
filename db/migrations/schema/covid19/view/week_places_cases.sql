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