--user_id=52
with input_user_id(user_id) as(
  values(52)
)
, target_user as(
  select
    user_id,
    department_id
  from
    users
  where
    user_id =(select user_id from input_user_id)
)
, parent_department as(
  select
    parent_department_id as department_id
  from
    departments
  inner join
    target_user
  on
    departments.department_id=target_user.department_id
)
, approval_departments as (
  select
    department_id
  from
    target_user
  union
  select
    department_id
  from
    parent_department
)
, approval_users as (
  select
    user_id,
    user_name,
    department_id,
    position_name
  from
    users
  where
    position_name in ('課長','部長')
    and
    user_id!=(select user_id from input_user_id)
)
select
 row_number() over(order by approval_departments.department_id desc) as approval_order,
 departments.department_name,
 approval_users.user_name,
 approval_users.position_name
from
  approval_departments
inner join
  approval_users
on
  approval_departments.department_id=approval_users.department_id
inner join
  departments
on
  approval_departments.department_id=departments.department_id
order by 
  approval_order