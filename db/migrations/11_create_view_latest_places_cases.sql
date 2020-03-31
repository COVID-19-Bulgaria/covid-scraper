create or replace
view covid19.latest_places_cases as
select
  distinct on
  (pc.place_id) p.name,
  p.latitude,
  p.longitude,
  pc.infected,
  pc.cured,
  pc.fatal,
  pc.timestamp
from
  covid19.places_cases pc
join covid19.places p on
  pc.place_id = p.id
order by
  pc.place_id,
  pc.timestamp desc;
