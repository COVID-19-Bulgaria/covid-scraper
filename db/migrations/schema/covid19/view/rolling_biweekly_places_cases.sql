create or replace
view covid19.rolling_biweekly_places_cases as
select
	ddpc.country as country,
	p.id as place_id,
	ddpc.place as place,
	sum(ddpc.infected) as infected,
	round(avg(ddpc.infected)::decimal * 14 / p.population * 100000)::integer as infected_avg_100k,
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