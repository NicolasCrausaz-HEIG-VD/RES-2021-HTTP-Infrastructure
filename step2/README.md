# Step 2: Dynamic HTTP server with express.js

Cette application prédit votre note dans des unités d'enseignement de l'HEIG-VD.

## Docker

- `docker build -t res/node-express .`

- `docker run -d -p 8282:3000 res/node-express`

## Utilisation

- http://localhost:8282/grades
- http://localhost:8282/grade/res (ou une autre unité)
- http://localhost:8282/one

