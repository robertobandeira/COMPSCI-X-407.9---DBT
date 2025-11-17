{{ config(materialized='view') }}

select
  id               as product_id,
  name             as product_name,
  brand,
  category,
  department,
  sku,
  retail_price,
  cost,
  distribution_center_id
from {{ source('the_look', 'thelook_products') }}
