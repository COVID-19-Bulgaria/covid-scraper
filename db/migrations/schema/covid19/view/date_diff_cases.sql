create or replace
view covid19.date_diff_cases as
select
    dc.country,
    coalesce(dc.infected - lag(dc.infected) over(partition by dc.country order by dc.date), dc.infected) as infected,
    coalesce(dc.cured - lag(dc.cured) over(partition by dc.country order by dc.date), dc.cured) as cured,
    coalesce(dc.fatal - lag(dc.fatal) over(partition by dc.country order by dc.date), dc.fatal) as fatal,
    coalesce(dc.men - lag(dc.men) over(partition by dc.country order by dc.date), dc.men) as men,
    coalesce(dc.women - lag(dc.women) over(partition by dc.country order by dc.date), dc.women) as women,
    coalesce(dc.hospitalized - lag(dc.hospitalized) over(partition by dc.country order by dc.date), dc.hospitalized) as hospitalized,
    coalesce(dc.intensive_care - lag(dc.intensive_care) over(partition by dc.country order by dc.date), dc.intensive_care) as intensive_care,
    coalesce(dc.medical_staff - lag(dc.medical_staff) over(partition by dc.country order by dc.date), dc.medical_staff) as medical_staff,
    coalesce(dc.pcr_tests - lag(dc.pcr_tests) over(partition by dc.country order by dc.date), dc.pcr_tests) as pcr_tests,
    coalesce(dc.positive_pcr_tests - lag(dc.positive_pcr_tests) over(partition by dc.country order by dc.date), dc.positive_pcr_tests) as positive_pcr_tests,
    coalesce(dc.antigen_tests - lag(dc.antigen_tests) over(partition by dc.country order by dc.date), dc.antigen_tests) as antigen_tests,
    coalesce(dc.positive_antigen_tests - lag(dc.positive_antigen_tests) over(partition by dc.country order by dc.date), dc.positive_antigen_tests) as positive_antigen_tests,
    coalesce(dc.vaccinated - lag(dc.vaccinated) over(partition by dc.country order by dc.date), dc.vaccinated) as vaccinated,
    dc.date
from
    covid19.date_cases dc;