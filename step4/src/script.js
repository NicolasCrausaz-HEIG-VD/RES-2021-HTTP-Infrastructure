// This gets all grades from the API route
async function getAndWriteGrades () {
   const data = await fetch('api/grades')
      .then(response => { return response.json() })
      .catch(() => console.log('Error while getting grades'))

   document.getElementById("gradesTable").innerHTML = ''

   data.forEach(grade => {
      document.getElementById("gradesTable").innerHTML += `<tr><td>${grade.unit}</td><td>${grade.grade}</td></tr>`
   })
}

getAndWriteGrades()

setInterval(() => getAndWriteGrades(), 3000)