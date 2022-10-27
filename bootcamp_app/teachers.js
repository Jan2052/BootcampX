const { Pool } = require('pg');

const pool = new Pool({
  user: 'vagrant',
  password: '123',
  host: 'localhost',
  database: 'bootcampx'
});



pool.query(`
SELECT DISTINCT t.name as teacher, c.name as cohort
FROM teachers t
JOIN assistance_requests ON teacher_id = t.id
JOIN students s ON student_id = s.id
JOIN cohorts c ON cohort_id = c.id
WHERE c.name = '${process.argv[2] || 'JUL02'}'
ORDER BY teacher;
`)
.then(res=> {
  res.rows.forEach(row=> {
    console.log(`${row.cohort}: ${row.teacher}`)
  })
})
.catch(err => console.error('query error', err.stack));

