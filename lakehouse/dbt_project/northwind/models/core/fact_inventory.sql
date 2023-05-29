{{ config(
    materialized='incremental',
    file_format='parquet',
    incremental_strategy='insert_overwrite',
    partition_by=['year','month']
  )
}}



SELECT
    it.id as inventory_id,
    it.transaction_type,
    date(it.transaction_created_date) as transaction_created_date,
    it.transaction_modified_date,
    it.product_id,
    it.quantity,
    it.purchase_order_id,
    it.customer_order_id,
    it.comments,
    dm.id as date_id,
    dm.year,
    dm.month
FROM {{ ref('stg_inventory_transactions') }} it
LEFT JOIN {{ ref('dim_date') }} dm
on it.transaction_created_date = dm.id
WHERE it.id is not null;