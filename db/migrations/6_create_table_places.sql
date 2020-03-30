CREATE TABLE "covid19"."places" (
  "id" serial NOT NULL PRIMARY KEY,
  "name" character varying(32) NOT NULL UNIQUE,
  "longitude" double precision NOT NULL,
  "latitude" double precision NOT NULL
);
