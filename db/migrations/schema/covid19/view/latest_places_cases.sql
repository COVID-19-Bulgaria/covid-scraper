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
