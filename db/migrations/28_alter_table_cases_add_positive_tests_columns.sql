ALTER TABLE "covid19"."cases"
ADD COLUMN positive_pcr_tests integer,
ADD COLUMN positive_antigen_tests integer;

drop view covid19.week_cases;
drop view covid19.date_active_cases;
drop view covid19.date_positive_tests;
drop view covid19.date_diff_cases;
drop view covid19.date_cases;

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

create or replace
view covid19.date_active_cases as
select
    dc.country,
    (dc.infected - dc.cured - dc.fatal) as active,
    dc.date
from covid19.date_cases dc
order by
    dc.date asc;

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

create or replace
view covid19.week_cases as
select
    ddc.country,
    case
        when date_part('month', ddc.date::date) = 1 and date_part('week', ddc.date::date) > 5 then date_part('year', ddc.date::date) - 1
        else date_part('year', ddc.date::date)
    end::integer as year,
    date_part('week', ddc.date::date)::integer as week,
    sum(ddc.infected) as infected,
    sum(ddc.cured) as cured,
    sum(ddc.fatal) as fatal,
    sum(case when ddc.hospitalized > 0 then ddc.hospitalized else 0 end) as hospitalized,
    sum(case when ddc.intensive_care > 0 then ddc.intensive_care else 0 end) as intensive_care,
    sum(ddc.medical_staff) as medical_staff,
    sum(ddc.pcr_tests) as pcr_tests,
    sum(ddc.positive_pcr_tests) as positive_pcr_tests,
    sum(ddc.antigen_tests) as antigen_tests,
    sum(ddc.positive_antigen_tests) as positive_antigen_tests,
    sum(ddc.vaccinated) as vaccinated
from
    covid19.date_diff_cases ddc
group by
    ddc.country,
    year,
    week
order by
    ddc.country asc,
    year asc,
    week asc;