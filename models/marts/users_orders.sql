select * 
from {{ source('company_data', 'orders') }}
left join {{ source('company_data', 'customerss') }} 
    -- on orders.customer_id = customerss.customer_id
    -- the USING clause is practically the same as on
    using(customer_id)