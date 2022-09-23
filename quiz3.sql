select
  basket_number
from
  baskets
group by
  basket_number
having
  count(1)=3
  and
  sum(
    case when fruit in ('りんご', 'バナナ', 'ぶどう') then 1 else 0 end
  )=3