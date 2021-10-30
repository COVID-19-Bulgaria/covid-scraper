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