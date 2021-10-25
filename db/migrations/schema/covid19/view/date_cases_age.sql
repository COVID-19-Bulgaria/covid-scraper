create or replace
view covid19.date_cases_age as
select
    ctr.name as country,
    max(ca.group_0_1) as group_0_1,
    max(ca.group_1_5) as group_1_5,
    max(ca.group_6_9) as group_6_9,
    max(ca.group_10_14) as group_10_14,
    max(ca.group_15_19) as group_15_19,
    max(ca.group_0_19) as group_0_19,
    max(ca.group_20_29) as group_20_29,
    max(ca.group_30_39) as group_30_39,
    max(ca.group_40_49) as group_40_49,
    max(ca.group_50_59) as group_50_59,
    max(ca.group_60_69) as group_60_69,
    max(ca.group_70_79) as group_70_79,
    max(ca.group_80_89) as group_80_89,
    max(ca.group_90) as group_90,
    date(ca.timestamp) as date
from
    covid19.cases_age ca
    join
    covid19.countries ctr on ca.country_id = ctr.id
group by
    ctr.id,
    ca.timestamp::date;