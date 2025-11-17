{{ config(materialized='view') }}

select
  id          as distribution_center_id,
  name        as distribution_center_name,
  latitude,
  longitude
from {{ source('the_look', 'thelook_distribution_centers') }}
