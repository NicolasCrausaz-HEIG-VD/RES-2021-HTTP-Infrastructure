const express = require('express')
const Chance = require('chance')()
const app = express()
const port = 3000

const data = require('./data/units')

console.log()

/**
 * API Main endpoint
 */
app.get('/', (req, res) => {
   res.send('Hello, this is the main endpoint')
})

/**
 * Send a grade for each available unit
 */
app.get('/grades', (req, res) => {
   res.send(generateGrades())
   //res.send(Chance.address)
})

/**
 * Sends the grade of a wished unit
 */
app.get('/grade/:module', (req, res) => {
   if (data.units.includes(req.params.module.toUpperCase())) {
      res.send({
         unit: Chance.pickone(data.units),
         grade: Chance.integer({ min: 1, max: 6 })
      })
   }
   else res.status(404).send('This unit does not exist');
})

/**
 * Start server listen
 */
app.listen(port, () => {
   console.log(`Listening at http://localhost:${port}`)
})

function generateGrades () {
   return data.units.map(u => {
      return {
         unit: u,
         grade: Chance.integer({ min: 1, max: 6 })
      }
   })
}
