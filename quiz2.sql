--user_id=52
WITH RECURSIVE
  recursive_departments (
    department_id,
    department_name,
    parent_department_id
  ) AS (
    SELECT
      department_id,
      department_name,
      parent_department_id
    FROM
      departments
    WHERE
      department_id = (
        SELECT
          department_id
        FROM
          users
        WHERE
          user_id = 52
      )
    UNION
    SELECT
      departments.department_id,
      departments.department_name,
      departments.parent_department_id
    FROM
      departments
      INNER JOIN recursive_departments ON departments.department_id = recursive_departments.parent_department_id
  ),
  approval_users AS (
    SELECT
      user_id,
      user_name,
      department_id,
      position_name
    FROM
      users
    WHERE
      position_name IN ('課長', '部長')
      AND user_id != 52
  )
SELECT
  ROW_NUMBER() OVER (
    ORDER BY
      recursive_departments.department_id desc
  ) AS approval_order,
  departments.department_name,
  approval_users.user_name,
  approval_users.position_name
FROM
  recursive_departments
  INNER JOIN approval_users ON recursive_departments.department_id = approval_users.department_id
  INNER JOIN departments ON recursive_departments.department_id = departments.department_id
ORDER BY
  approval_order