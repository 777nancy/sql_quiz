with product_id_to_accessory_id as(
  select
    products.product_id,
    products.product_name,
    product_accessories.accessory_id
  from
    products
  inner join
    product_accessories
  on
    products.product_id=product_accessories.product_id
)
, product_type_id_to_accessory_id as(
  select
    products.product_id,
    products.product_name,
    default_accessories.accessory_id
  from
    products
  inner join
    default_accessories
  on
    products.product_type_id=default_accessories.product_type_id
)
, union_accessory as(
  select
    product_id,
    product_name,
    accessory_id
  from
    product_id_to_accessory_id
  union
  select
    product_id,
    product_name,
    accessory_id
  from
    product_type_id_to_accessory_id
 )
 , accessory_id_to_accessory_name as(
  select
    union_accessory.product_id,
    union_accessory.product_name,
    union_accessory.accessory_id,
    accessories.accessory_name
  from
    union_accessory
  inner join
    accessories
  on
    union_accessory.accessory_id=accessories.accessory_id
)
select
  products.product_name,
  case when accessory_id_to_accessory_name.accessory_name is null then 'なし' else accessory_name end
from
  products
left join
  accessory_id_to_accessory_name
on
  products.product_id=accessory_id_to_accessory_name.product_id
order by
  product_name,
  accessory_id
;