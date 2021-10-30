alter table covid19.covid19.places_cases
    alter column cured drop not null,
    alter column fatal drop not null,
    add column doses integer null,
    add column fully_vaccinated integer null,
    add column booster integer null;