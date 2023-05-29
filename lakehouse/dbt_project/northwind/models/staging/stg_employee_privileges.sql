{% set table_exists=this  is not none %}

{{ config(
    materialized='incremental',
    file_format='hudi',
    incremental_strategy='merge',
    unique_key='employee_id,privilege_id',
    options={
       'type': 'mor',
       'primaryKey': 'employee_id,privilege_id',
       'precombineKey': 'updated_at',
   },
    pre_hook=[
                """
                    {% if table_exists %}

                    DELETE FROM {{ this }} WHERE id IN 
                    (
                        SELECT id FROM {{ source('source', 'employee_privileges') }} 
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

SELECT * FROM {{ source('source', 'employee_privileges') }} 

{% if is_incremental() %}
    WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
