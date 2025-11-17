{{ config(materialized='view') }}

with user_base as (
    select
      u.user_id,
      u.first_name,
      u.last_name,
      u.email,
      u.gender,
      u.age,
      u.state,
      u.city,
      u.country,
      u.latitude,
      u.longitude,
      u.traffic_source,
      u.created_at       as user_created_at,
      u.created_date     as user_created_date
    from {{ ref('stg__users') }} u
),

order_behavior as (
    select
      o.user_id,
      min(o.order_date) as first_order_date,
      max(o.order_date) as last_order_date,
      count(*)          as total_orders
    from {{ ref('stg__orders') }} o
    group by o.user_id
)

select
  ub.*,
  ob.first_order_date,
  ob.last_order_date,
  ob.total_orders,
  case when ob.first_order_date is null then true else false end as is_never_buyer
from user_base ub
left join order_behavior ob
  on ub.user_id = ob.user_id
