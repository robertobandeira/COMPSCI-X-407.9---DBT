{{ config(materialized='view') }}

select
  id                          as event_id,
  user_id,
  sequence_number,
  session_id,
  created_at                  as event_time,
  cast(created_at as date)    as event_date,
  ip_address,
  city,
  state,
  postal_code,
  browser,
  traffic_source,
  uri,
  event_type
from {{ source('the_look', 'thelook_events') }}
