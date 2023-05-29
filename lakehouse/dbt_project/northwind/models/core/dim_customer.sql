{{ config(
    materialized='incremental',
    file_format='hudi',
    incremental_strategy='merge',
    unique_key='customer_id',
    options={
       'type': 'cow',
       'primaryKey': 'customer_id',
       'precombineKey': 'updated_at',
   },
  )
}}

SELECT  
    id as customer_id,
    company,
    last_name,
    first_name,
    email_address,
    job_title,
    business_phone,
    home_phone,
    mobile_phone,
    fax_number,
    address,
    city,
    state_province,
    zip_postal_code,
    country_region,
    web_page,
    notes,
    attachments,
    created_at,
    updated_at

FROM {{ ref('stg_customer') }} 

{% if is_incremental() %}
    WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}