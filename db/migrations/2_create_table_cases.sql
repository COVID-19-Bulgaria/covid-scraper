CREATE TABLE "covid19"."cases" (
  "id" serial NOT NULL PRIMARY KEY,
  "country" character varying(32) NOT NULL,
  "infected" integer NOT NULL,
  "cured" integer NOT NULL,
  "fatal" integer NOT NULL,
  "sources" text NULL,
  "timestamp" timestamp NOT NULL
);

CREATE INDEX "cases_timestamp" ON "covid19"."cases" ("timestamp");
