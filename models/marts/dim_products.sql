{{ config(materialized='view') }}

select
  p.product_id,
  p.product_name,
  p.brand,
  p.category,
  p.department,
  p.sku,
  p.retail_price,
  p.cost,
  (p.retail_price - p.cost) as unit_margin,
  p.distribution_center_id
from {{ ref('stg__products') }} p
