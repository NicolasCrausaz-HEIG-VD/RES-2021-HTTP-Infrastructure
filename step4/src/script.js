// This gets all grades from the API route
async function getGrades () {
   return await fetch('api/grades')
      .then(response => response.json())
      .catch(() => console.log('Error while getting grades'))
}

getGrades()

// Set an interval of 3 seconds that triggers the grade request function
setInterval(() => getGrades(), 3000)