create or replace
view covid19.date_positive_tests as
select
    dc.country,
    dc.pcr_tests,
    dc.antigen_tests,
    round(dc.infected::decimal / (dc.pcr_tests + coalesce(dc.antigen_tests, 0)) * 100, 2) as positive_percentage,
    dc.positive_pcr_tests,
    case
        when dc.positive_pcr_tests is null then null
        else round(dc.positive_pcr_tests::decimal / dc.pcr_tests * 100, 2)
        end as pcr_positive_percentage,
    dc.positive_antigen_tests,
    case
        when dc.positive_antigen_tests is null then null
        else round(dc.positive_antigen_tests::decimal / dc.antigen_tests * 100, 2)
        end as antigen_positive_percentage,
    dc.date
from covid19.date_diff_cases dc
where
    dc.pcr_tests is not null
and
    dc.date > '2020-06-06'
order by
    dc.date asc;
