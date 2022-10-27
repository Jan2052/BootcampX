const { Pool } = require('pg');

const pool = new Pool({
  user: 'vagrant',
  password: '123',
  host: 'localhost',
  database: 'bootcampx'
});

let argv1 = process.argv[2];
let values = [`${argv1}%`];

pool.query(`
SELECT DISTINCT t.name as teacher, c.name as cohort
FROM teachers t
JOIN assistance_requests ON teacher_id = t.id
JOIN students s ON student_id = s.id
JOIN cohorts c ON cohort_id = c.id
WHERE c.name = '${argv1 || 'JUL02'}'
ORDER BY teacher;
`, values)
.then(res=> {
  res.rows.forEach(row=> {
    console.log(`${row.cohort}: ${row.teacher}`)
  })
})
.catch(err => console.error('query error', err.stack));

