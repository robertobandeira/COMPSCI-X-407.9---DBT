{{ config(materialized='view') }}

select
  order_id,
  user_id,
  status                      as order_status,
  gender,
  num_of_item                 as item_count,
  created_at,
  cast(created_at as date)    as order_date,
  shipped_at,
  delivered_at,
  returned_at
from {{ source('the_look', 'thelook_orders') }}
