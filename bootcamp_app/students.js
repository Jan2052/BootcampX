// const { Client } = require('pg');

// const client = new Client({
//   user: 'vagrant',
//   password: '123',
//   host: 'localhost',
//   database: 'bootcampx'
// });
const { Pool } = require('pg');

const pool = new Pool({
  user: 'vagrant',
  password: '123',
  host: 'localhost',
  database: 'bootcampx'
});

let argvCohort = process.argv[2];
let argvLimit = process.argv[3];
let values = [`${argvCohort}%`, argvLimit];

pool.query(`
SELECT s.id as student_id, s.name as name, c.name as cohort
FROM students s
JOIN cohorts c ON c.id = s.cohort_id
WHERE c.name LIKE $1
LIMIT $2;
`, values)
.then(res => {
  res.rows.forEach(user => {
    console.log(`${user.name} has an id of ${user.student_id} and was in the ${user.cohort} cohort`);
  })
}).catch(err => console.error('ERROR', err.stack))

// pool.query(`
// SELECT students.id as student_id, students.name as name, cohorts.name as cohort
// FROM students
// JOIN cohorts ON cohorts.id = cohort_id
// WHERE cohorts.name LIKE '%${process.argv[2]}%'
// LIMIT ${process.argv[3] || 5};
// `)
// .then(res => {
//   res.rows.forEach(user => {
//     console.log(`${user.name} has an id of ${user.student_id} and was in the ${user.cohort} cohort`);
//   })
// }).catch(err => console.error('query error', err.stack));