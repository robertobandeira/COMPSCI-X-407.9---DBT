{{ config(materialized='table') }}

with base as (
    select
      oi.order_item_date                    as date,
      oi.order_item_id,
      oi.order_id,
      oi.user_id,
      oi.product_id,
      oi.sale_price,
      u.traffic_source,
      u.country,
      u.state,
      p.category,
      p.department,
      dc.distribution_center_name,
      p.cost
    from {{ ref('stg__order_items') }} oi
    left join {{ ref('stg__orders') }} o
      on oi.order_id = o.order_id
    left join {{ ref('stg__users') }} u
      on oi.user_id = u.user_id
    left join {{ ref('stg__products') }} p
      on oi.product_id = p.product_id
    left join {{ ref('stg__distribution_centers') }} dc
      on p.distribution_center_id = dc.distribution_center_id
)

select
  date,
  traffic_source,
  country,
  state,
  category,
  department,
  distribution_center_name,
  count(distinct order_id)    as orders,
  count(distinct user_id)     as customers,
  count(order_item_id)        as item_count,
  sum(sale_price)             as gross_revenue,
  sum(sale_price - cost)      as gross_margin
from base
group by
  date,
  traffic_source,
  country,
  state,
  category,
  department,
  distribution_center_name
