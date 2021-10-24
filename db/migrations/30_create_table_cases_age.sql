CREATE TABLE "covid19"."cases_age" (
    "id" serial NOT NULL PRIMARY KEY,
    "country" character varying(32) NOT NULL,
    "0_1" integer NULL,
    "1_5" integer NULL,
    "6_9" integer NULL,
    "10_14" integer NULL,
    "15_19" integer NULL,
    "0_19" integer NULL,
    "20_29" integer NULL,
    "30_39" integer NULL,
    "40_49" integer NULL,
    "50_59" integer NULL,
    "60_69" integer NULL,
    "70_79" integer NULL,
    "80_89" integer NULL,
    "90" integer NULL,
    "timestamp" timestamp NOT NULL
);

CREATE INDEX "cases_age_timestamp" ON "covid19"."cases_age" ("timestamp");
