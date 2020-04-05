ALTER TABLE "covid19"."places"
ADD COLUMN country_id integer,
ADD FOREIGN KEY ("country_id") REFERENCES "covid19"."countries" ("id");

CREATE INDEX "places_country_id" ON "covid19"."places" ("country_id");

update covid19.places set country_id = 1;

drop view covid19.latest_places_cases;

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
