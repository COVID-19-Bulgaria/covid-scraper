CREATE TABLE "covid19"."places_cases" (
  "id" serial NOT NULL PRIMARY KEY,
  "place_id" integer NOT NULL,
  "infected" integer NOT NULL,
  "cured" integer NOT NULL,
  "fatal" integer NOT NULL,
  "sources" text NULL,
  "timestamp" timestamp NOT NULL
);

CREATE INDEX "places_cases_place_id" ON "covid19"."places_cases" ("place_id");
CREATE INDEX "places_cases_timestamp" ON "covid19"."places_cases" ("timestamp");

ALTER TABLE "covid19"."places_cases"
ADD FOREIGN KEY ("place_id") REFERENCES "covid19"."places" ("id");
