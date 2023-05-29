{{ config(
    materialized='incremental',
    file_format='hudi',
    incremental_strategy='merge',
    unique_key='product_id',
    options={
       'type': 'cow',
       'primaryKey': 'product_id',
       'precombineKey': 'updated_at',
   },
  )
}}


WITH
product AS (
    SELECT
        id as product_id,
        product_code,
        product_name,
        description,
        standard_cost,
        list_price,
        reorder_level,
        target_level,
        quantity_per_unit,
        discontinued,
        minimum_reorder_quantity,
        category,
        attachments,
        supplier_ids
    FROM {{ ref('stg_products') }}

    {% if is_incremental() %}
        WHERE date(updated_at) = current_date()
    {% endif %}

)


SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    p.description,
    s.company as supplier_company,
    p.standard_cost,
    p.list_price,
    p.reorder_level,
    p.target_level,
    p.quantity_per_unit,
    p.discontinued,
    p.minimum_reorder_quantity,
    p.category,
    p.attachments
from product p
left join {{ ref('stg_suppliers') }} s
on s.id = p.supplier_ids