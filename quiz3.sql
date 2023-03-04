SELECT
  basket_number
FROM
  baskets
GROUP BY
  basket_number
HAVING
  COUNT(1) = 3
  AND SUM(
    CASE
      WHEN fruit IN ('りんご', 'バナナ', 'ぶどう') THEN 1
      ELSE 0
    END
  ) = 3