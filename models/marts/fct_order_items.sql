{{ config(materialized='table') }}

with base as (
    select
      oi.order_item_id,
      oi.order_id,
      oi.user_id,
      oi.product_id,
      oi.inventory_item_id,
      oi.order_item_status,
      oi.sale_price,
      oi.created_at           as order_item_created_at,
      oi.order_item_date,
      oi.shipped_at,
      oi.delivered_at,
      oi.returned_at,
      o.order_status,
      o.order_date,
      o.item_count            as order_item_count_header
    from {{ ref('stg__order_items') }} oi
    left join {{ ref('stg__orders') }} o
      on oi.order_id = o.order_id
),

with_inventory as (
    select
      b.*,
      ii.product_category,
      ii.product_name            as inventory_product_name,
      ii.product_brand,
      ii.product_retail_price,
      ii.product_department,
      ii.product_sku,
      ii.product_distribution_center_id
    from base b
    left join {{ ref('stg__inventory_items') }} ii
      on b.inventory_item_id = ii.inventory_item_id
),

with_product as (
    select
      wi.*,
      p.brand                    as product_brand_master,
      p.product_name             as product_name_master,
      p.category                 as product_category_master,
      p.department               as product_department_master,
      p.retail_price             as product_retail_price_master,
      p.cost                     as product_cost_master
    from with_inventory wi
    left join {{ ref('stg__products') }} p
      on wi.product_id = p.product_id
),

with_distribution_center as (
    select
      wp.*,
      dc.distribution_center_name,
      dc.latitude   as dc_latitude,
      dc.longitude  as dc_longitude
    from with_product wp
    left join {{ ref('stg__distribution_centers') }} dc
      on wp.product_distribution_center_id = dc.distribution_center_id
)

select * from with_distribution_center
