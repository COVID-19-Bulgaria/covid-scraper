CREATE TABLE "covid19"."cases_age" (
    "id" serial NOT NULL PRIMARY KEY,
    "country_id" character varying(32) NOT NULL,
    "group_0_1" integer NULL,
    "group_1_5" integer NULL,
    "group_6_9" integer NULL,
    "group_10_14" integer NULL,
    "group_15_19" integer NULL,
    "group_0_19" integer NULL,
    "group_20_29" integer NULL,
    "group_30_39" integer NULL,
    "group_40_49" integer NULL,
    "group_50_59" integer NULL,
    "group_60_69" integer NULL,
    "group_70_79" integer NULL,
    "group_80_89" integer NULL,
    "group_90" integer NULL,
    "timestamp" timestamp NOT NULL
);

CREATE INDEX "cases_age_timestamp" ON "covid19"."cases_age" ("timestamp");
