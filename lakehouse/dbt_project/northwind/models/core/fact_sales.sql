{{ config(
    materialized='incremental',
    file_format='parquet',
    incremental_strategy='insert_overwrite',
    partition_by=['year','month']
  )
}}


SELECT
    od.order_id,
    od.product_id,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    od.quantity,
    od.unit_price,
    od.discount,
    od.status_id,
    od.date_allocated,
    od.purchase_order_id,
    od.inventory_id,
    date(o.order_date) as order_date,
    o.shipped_date,
    o.paid_date,
    dm.id as date_id,
    dm.year,
    dm.month
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_order_details') }} od
on od.order_id = o.id
LEFT JOIN {{ ref('dim_date') }} dm
on o.order_date = dm.id
WHERE od.order_id is not null;