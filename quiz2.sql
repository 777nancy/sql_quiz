--user_id=52
with recursive recursive_departments(
  department_id, 
  department_name,
  parent_department_id
) as (
  select
    department_id, 
    department_name,
    parent_department_id
  from
    departments
  where
    department_id=(select department_id from users where user_id=52)
  union
  select
    departments.department_id, 
    departments.department_name,
    departments.parent_department_id
  from
    departments
  inner join
    recursive_departments
  on
    departments.department_id=recursive_departments.parent_department_id
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
    user_id!=52
)
select
 row_number() over(order by recursive_departments.department_id desc) as approval_order,
 departments.department_name,
 approval_users.user_name,
 approval_users.position_name
from
  recursive_departments
inner join
  approval_users
on
  recursive_departments.department_id=approval_users.department_id
inner join
  departments
on
  recursive_departments.department_id=departments.department_id
order by 
  approval_order