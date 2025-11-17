{{ config(materialized='view') }}

select
  id              as user_id,
  first_name,
  last_name,
  email,
  age,
  gender,
  state,
  street_address,
  postal_code,
  city,
  country,
  latitude,
  longitude,
  traffic_source,
  created_at,
  cast(created_at as date) as created_date
from {{ source('the_look', 'thelook_users') }}
