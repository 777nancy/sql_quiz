WITH
  product_id_to_accessory_id AS (
    SELECT
      products.product_id,
      products.product_name,
      product_accessories.accessory_id
    FROM
      products
      INNER JOIN product_accessories ON products.product_id = product_accessories.product_id
  ),
  product_type_id_to_accessory_id AS (
    SELECT
      products.product_id,
      products.product_name,
      default_accessories.accessory_id
    FROM
      products
      INNER JOIN default_accessories ON products.product_type_id = default_accessories.product_type_id
  ),
  union_accessory AS (
    SELECT
      product_id,
      product_name,
      accessory_id
    FROM
      product_id_to_accessory_id
    UNION
    SELECT
      product_id,
      product_name,
      accessory_id
    FROM
      product_type_id_to_accessory_id
  ),
  accessory_id_to_accessory_name AS (
    SELECT
      union_accessory.product_id,
      union_accessory.product_name,
      union_accessory.accessory_id,
      accessories.accessory_name
    FROM
      union_accessory
      INNER JOIN accessories ON union_accessory.accessory_id = accessories.accessory_id
  )
SELECT
  products.product_name,
  CASE
    WHEN accessory_id_to_accessory_name.accessory_name IS NULL THEN 'なし'
    ELSE accessory_name
  END
FROM
  products
  LEFT JOIN accessory_id_to_accessory_name ON products.product_id = accessory_id_to_accessory_name.product_id
WHERE
  products.product_name IS NULL
  OR products.product_name IS NULL
ORDER BY
  product_name,
  accessory_id
;