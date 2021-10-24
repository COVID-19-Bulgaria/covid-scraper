create or replace
view covid19.date_cases as
select
    ctr.name as country,
    max(c.infected) as infected,
    max(c.cured) as cured,
    max(c.fatal) as fatal,
    max(c.men) as men,
    max(c.women) as women,
    max(c.hospitalized) as hospitalized,
    max(c.intensive_care) as intensive_care,
    max(c.medical_staff) as medical_staff,
    max(c.pcr_tests) as pcr_tests,
    max(c.positive_pcr_tests) as positive_pcr_tests,
    max(c.antigen_tests) as antigen_tests,
    max(c.positive_antigen_tests) as positive_antigen_tests,
    max(c.vaccinated) as vaccinated,
    date(c.timestamp) as date
from
    covid19.cases c
join
    covid19.countries ctr on c.country_id = ctr.id
group by
    ctr.id,
    c.timestamp::date;