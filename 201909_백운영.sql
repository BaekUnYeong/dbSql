-- ����(�ǽ� 8��)
SELECT * FROM countries;
SELECT * FROM regions;

SELECT regions.region_id, regions.region_name, country_name
FROM countries, regions
WHERE regions.region_id = countries.region_id
AND region_name = 'Europe';

-- ����(�ǽ� 9��)
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;

SELECT regions.region_id, regions.region_name, country_name, city
FROM countries, regions, locations
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND region_name = 'Europe';

-- ����(�ǽ� 10��)
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM departments;

SELECT regions.region_id, regions.region_name, country_name, city, department_name
FROM countries, regions, locations, departments
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND region_name = 'Europe';

-- ����(�ǽ� 11��)
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM departments;
SELECT * FROM employees;

SELECT regions.region_id, regions.region_name, country_name, city, department_name, CONCAT(first_name,last_name)name
FROM countries, regions, locations, departments, employees
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND departments.department_id = employees.department_id
AND region_name = 'Europe';

-- ����(�ǽ� 12��)
SELECT * FROM jobs;
SELECT * FROM employees;

SELECT employee_id, CONCAT(first_name,last_name)name, jobs.job_id, job_title
FROM jobs, employees
WHERE jobs.job_id = employees.job_id;

-- ����(�ǽ� 13��)
SELECT * FROM jobs;
SELECT * FROM employees;

SELECT e.manager_id, CONCAT(m.first_name,m.last_name) mgr_name, e.employee_id, CONCAT(e.first_name,e.last_name)name, jobs.job_id, job_title
FROM jobs, employees m, employees e
WHERE e.manager_id = m.employee_id
AND jobs.job_id = e.job_id;