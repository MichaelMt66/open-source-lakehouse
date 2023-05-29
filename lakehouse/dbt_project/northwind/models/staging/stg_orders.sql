{% set table_exists=this  is not none %}

{{ config(
    materialized='incremental',
    file_format='hudi',
    incremental_strategy='merge',
    unique_key='id',
    options={
       'type': 'mor',
       'primaryKey': 'id',
       'precombineKey': 'updated_at',
   },
    pre_hook=[
                """
                    {% if table_exists %}

                    DELETE FROM {{ this }} WHERE id IN 
                    (
                        SELECT id FROM {{ source('source', 'orders') }} 
                        WHERE deleted_at IS NOT NUll
                        {% if is_incremental() %}
                            AND updated_at > (SELECT MAX(updated_at) FROM {{ this }})
                        {% endif %}
                    );

                    {% endif %}

                """
            ],    
  )
}}

SELECT * FROM {{ source('source', 'orders') }} 

{% if is_incremental() %}
    WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
