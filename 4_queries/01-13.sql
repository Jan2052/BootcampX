-- Total Teacher Assistance Requests
-- Get the total number of assistance_requests for a teacher.
-- Select the teacher's name and the total assistance requests.
-- Since this query needs to work with any specific teacher name, use 'Waylon Boehm' for the teacher's name here.

SELECT COUNT(assistance_requests.*) as total_assistance, teachers.name
FROM assistance_requests
JOIN teachers ON teachers.id = teacher_id
WHERE name = 'Waylon Boehm'
GROUP BY teachers.name;


-- Total Student Assistance Requests
-- Get the total number of assistance_requests for a student.
-- Select the student's name and the total assistance requests.
-- Since this query needs to work with any specific student name, use 'Elliot Dickinson' for the student's name here.

SELECT COUNT(assistance_requests.*) as total_assistance, students.name
FROM assistance_requests
JOIN students ON students.id = student_id
WHERE name = 'Elliot Dickinson'
GROUP BY students.name;


-- Assistance Requests Data
-- Get important data about each assistance request.
-- Select the teacher's name, student's name, assignment's name, and the duration of each assistance request.
-- Subtract completed_at by started_at to find the duration.
-- Order by the duration of the request.

SELECT t.name as teacher, s.name as student, a.name as assignment, (completed_at-started_at) as duration
FROM assistance_requests
JOIN assignments a ON a.id = assignment_id
JOIN students s ON s.id = student_id
JOIN teachers t ON t.id = teacher_id
ORDER BY duration;


-- Average Assistance Time
-- Get the average time of an assistance request.
-- Select just a single row here and name it average_assistance_request_duration
-- In Postgres, we can subtract two timestamps to find the duration between them. (timestamp1 - timestamp2)

SELECT avg(completed_at - started_at) as average_assistance_request_duration
FROM assistance_requests;


-- Average Cohort Assistance Time
-- Get the average duration of assistance requests for each cohort.
-- Select the cohort's name and the average assistance request time.
-- Order the results from shortest average to longest.

-- SELECT c.name, avg(completed_at - started_at) as average_assistance_time
-- FROM cohorts c
-- JOIN students s ON c.id = cohort_id
-- JOIN assistance_requests ON s.id = student_id
-- GROUP BY c.name
-- ORDER BY average_assistance_time;

SELECT cohorts.name, avg(completed_at - started_at) as average_assistance_time
FROM assistance_requests 
JOIN students ON students.id = assistance_requests.student_id
JOIN cohorts ON cohorts.id = cohort_id
GROUP BY cohorts.name
ORDER BY average_assistance_time;


-- Cohort With Longest Assistances
-- Get the cohort with the longest average duration of assistance requests.
-- The same requirements as the previous query, but only return the single row with the longest average.

SELECT cohorts.name, avg(completed_at - started_at) as average_assistance_time
FROM assistance_requests 
JOIN students ON students.id = assistance_requests.student_id
JOIN cohorts ON cohorts.id = cohort_id
GROUP BY cohorts.name
ORDER BY average_assistance_time DESC
LIMIT 1;


-- Average Assistance Request Wait Time
-- Calculate the average time it takes to start an assistance request.
-- Return just a single column here.

SELECT avg(started_at - created_at) as average_wait_time
FROM assistance_requests;


-- Total Cohort Assistance Duration
-- Get the total duration of all assistance requests for each cohort.
-- Select the cohort's name and the total duration the assistance requests.
-- Order by total_duration.
-- Look at the ERD to see how to join the tables.

SELECT day, count(*) as number_of_assignments, SUM(duration) as duration
FROM assignments
GROUP BY day
ORDER BY day;


-- Name of Teachers That Assisted
-- Get the name of all teachers that performed an assistance request during a cohort.
-- Select the instructor's name and the cohort's name.
-- Don't repeat the instructor's name in the results list.
-- Order by the instructor's name.
-- This query needs to select data for a cohort with a specific name, use 'JUL02' for the cohort's name here.

SELECT DISTINCT t.name as teacher, c.name as cohort
FROM teachers t
JOIN assistance_requests ON teacher_id = t.id
JOIN students s ON student_id = s.id
JOIN cohorts c ON cohort_id = c.id
WHERE c.name = 'JUL02'
ORDER BY teacher;


-- Name of Teachers and Number of Assistances
-- We need to know which teachers actually assisted students during any cohort, and how many assistances they did for that cohort.
-- Perform the same query as before, but include the number of assistances as well.

SELECT t.name as teacher, c.name as cohort, count(assistance_requests) as total_assistances
FROM teachers t
JOIN assistance_requests ON teacher_id = t.id
JOIN students s ON student_id = s.id
JOIN cohorts c ON cohort_id = c.id
WHERE c.name = 'JUL02'
GROUP BY t.name, c.name
ORDER BY teacher;