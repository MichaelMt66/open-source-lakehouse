{{ config(
    materialized='incremental',
    file_format='parquet',
    incremental_strategy='insert_overwrite',
    options={
       'primaryKey': 'customer_id,employee_id,purchase_order_id,product_id,inventory_id,supplier_id,date_id',
    },
    partition_by=['year','month']
  )
}}


SELECT
    c.id as customer_id,
    e.id as employee_id,
    pod.purchase_order_id,
    pod.product_id,
    pod.quantity,
    pod.unit_cost,
    pod.date_received,
    pod.posted_to_inventory,
    pod.inventory_id,
    po.supplier_id,
    po.created_by,
    po.submitted_date,
    date(po.creation_date) as creation_date,
    po.status_id,
    po.expected_date,
    po.shipping_fee,
    po.taxes,
    po.payment_date,
    po.payment_amount,
    po.payment_method,
    po.notes,
    po.approved_by,
    po.approved_date,
    po.submitted_by,
    dm.id as date_id,
    dm.year,
    dm.month
FROM {{ ref('stg_purchase_orders') }} po
LEFT JOIN {{ ref('stg_purchase_order_details') }} pod
on pod.purchase_order_id = po.id
LEFT JOIN {{ ref('stg_products') }} p
on p.id = pod.product_id
LEFT JOIN {{ ref('stg_order_details') }} od
on od.product_id = p.id
LEFT JOIN {{ ref('stg_orders') }} o
on o.id = od.order_id
LEFT JOIN {{ ref('stg_employees') }} e
on e.id = po.created_by
LEFT JOIN {{ ref('stg_customer') }} c
on c.id = o.customer_id
LEFT JOIN {{ ref('dim_date') }} dm
on po.creation_date= dm.id
where o.customer_id is not null
