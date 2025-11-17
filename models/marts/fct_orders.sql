{{ config(materialized='table') }}

with items_agg as (
    select
      order_id,
      count(*)                as item_count,
      sum(sale_price)         as items_revenue,
      sum(case when returned_at is not null then sale_price else 0 end) as returned_revenue
    from {{ ref('stg__order_items') }}
    group by order_id
)

select
  o.order_id,
  o.user_id,
  o.order_status,
  o.order_date,
  o.gender,
  o.item_count                 as declared_item_count,
  ia.item_count                as computed_item_count,
  ia.items_revenue,
  ia.returned_revenue,
  o.shipped_at,
  o.delivered_at,
  o.returned_at
from {{ ref('stg__orders') }} o
left join items_agg ia
  on o.order_id = ia.order_id
