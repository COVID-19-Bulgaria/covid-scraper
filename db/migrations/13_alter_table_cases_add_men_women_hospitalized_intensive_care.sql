ALTER TABLE "covid19"."cases"
ADD COLUMN men integer,
ADD COLUMN women integer,
ADD COLUMN hospitalized integer,
ADD COLUMN intensive_care integer,
ADD COLUMN medical_staff integer,
ADD COLUMN country_id integer,
ADD FOREIGN KEY ("country_id") REFERENCES "covid19"."countries" ("id");

CREATE INDEX "cases_country_id" ON "covid19"."cases" ("country_id");

