{{ config(
    materialized='incremental',
    file_format='parquet',
    incremental_strategy='insert_overwrite',
) }}

SELECT
date(d) AS id,
d AS full_date,
EXTRACT (YEAR FROM d)  AS YEAR,
EXTRACT (WEEK FROM d)  AS year_week,
EXTRACT (DAY FROM d)   AS year_day,
EXTRACT (YEAR FROM  d)  AS fiscal_year,
EXTRACT (QUARTER FROM d) AS fiscal_qtr,
EXTRACT (MONTH FROM d) AS MONTH,
date_format(d, 'MMMM')  AS month_name,
EXTRACT (DOW FROM d)  AS week_day,
date_format(d, 'EEEE')  AS day_name,
(CASE WHEN date_format(d, 'EEEE') NOT IN ('Sunday', 'Saturday') THEN 0 ELSE 1 END) AS day_is_weekday
FROM (SELECT EXPLODE(months) AS d FROM (SELECT SEQUENCE (TO_DATE('2000-01-01'), TO_DATE('2023-01-01'), INTERVAL 1 DAY) AS months))