{{ config(materialized='view') }}

select
  id                          as order_item_id,
  order_id,
  user_id,
  product_id,
  inventory_item_id,
  status                      as order_item_status,
  sale_price,
  created_at,
  cast(created_at as date)    as order_item_date,
  shipped_at,
  delivered_at,
  returned_at
from {{ source('the_look', 'thelook_order_items') }}
