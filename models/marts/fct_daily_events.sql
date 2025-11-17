{{ config(materialized='table') }}

with base as (
    select
      e.event_date          as date,
      e.event_type,
      e.traffic_source,
      e.state,
      e.user_id,
      e.session_id
    from {{ ref('stg__events') }} e
)

select
  date,
  traffic_source,
  state,
  event_type,
  count(*)                 as event_count,
  count(distinct user_id)  as users,
  count(distinct session_id) as sessions
from base
group by
  date,
  traffic_source,
  state,
  event_type
