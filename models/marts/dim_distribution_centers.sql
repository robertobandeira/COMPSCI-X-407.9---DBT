{{ config(materialized='view') }}

select
  distribution_center_id,
  distribution_center_name,
  latitude,
  longitude
from {{ ref('stg__distribution_centers') }}
