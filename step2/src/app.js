const express = require('express')
const Chance = require('chance')()
const app = express()
const port = 3000
const data = require('./data/units')

/**
 * API Main endpoint
 */
app.get('/', (req, res) => {
   res.send('Hello, this is the main endpoint')
})

/**
 * Send a random grade for each available unit
 */
app.get('/grades', (req, res) => {
   res.send(generateGrades())
})

/**
 * Sends the random grade of a wished unit
 */
app.get('/grade/:unit', (req, res) => {
   if (data.units.includes(req.params.unit.toUpperCase())) {
      res.send({
         unit: req.params.unit.toUpperCase(),
         grade: randGrade()
      })
   }
   else res.status(404).send('This unit does not exist');
})

/**
 * Send one random unith with random grade
 */
app.get('/one', (req, res) => {
   res.send({
      unit: Chance.pickone(data.units),
      grade: Chance.integer({ min: 1, max: 6 })
   })
})

/**
 * Start server listen
 */
app.listen(port, () => {
   console.log(`Listening at http://localhost:${port}`)
})

const generateGrades = () => {
   return data.units.map(u => {
      return {
         unit: u,
         grade: randGrade()
      }
   })
}

const randGrade = () => Chance.integer({ min: 1, max: 6 })
