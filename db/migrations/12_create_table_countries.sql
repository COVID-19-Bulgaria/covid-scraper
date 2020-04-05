CREATE TABLE "covid19"."countries" (
  "id" serial NOT NULL PRIMARY KEY,
  "name" character varying(32) NOT NULL UNIQUE,
  "latitude" double precision NOT NULL,
  "longitude" double precision NOT NULL,
  "zoom" integer NOT NULL
);

INSERT INTO covid19.countries (name, latitude, longitude, zoom)
VALUES ('Bulgaria', 42.748, 25.492, 7);
