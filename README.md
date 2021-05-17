# RES 2021 - Infrastracture HTTP

# Step 1: Static HTTP server with apache httpd

Cette étape consite à mettre en place un serveur apache et de modifier
le contenu servi par le serveur HTTP.

## Docker

- `cd step1`

- `docker build -t res/static-apache .`

- `docker run -d --name static_apache -p 9090:80 res/static-apache`



TODO: 
Acceptance criteria
You have a GitHub repo with everything needed to build the Docker image.
You can do a demo, where you build the image, run a container and access content from a browser.
You have used a nice looking web template, different from the one shown in the webcast.
You are able to explain what you do in the Dockerfile.
You are able to show where the apache config files are located (in a running container).
You have documented your configuration in your report.

# Step 2: Dynamic HTTP server with express.js

Cette application prédit votre note dans des unités d'enseignement de l'HEIG-VD.

## Docker

- `cd step2/src`

- `npm install`

- `cd ..`

- `docker build -t res/node-express .`

- `docker run -d --name express_dynamic -p 8282:3000 res/node-express`

## Utilisation

- http://localhost:8282/grades
- http://localhost:8282/grade/res (ou une autre unité)
- http://localhost:8282/one


TODO:

Acceptance criteria
You have a GitHub repo with everything needed to build the Docker image.
You can do a demo, where you build the image, run a container and access content from a browser.
You generate dynamic, random content and return a JSON payload to the client.
You cannot return the same content as the webcast (you cannot return a list of people).
You don't have to use express.js; if you want, you can use another JavaScript web framework or event another language.
You have documented your configuration in your report.

# Step 3: Reverse proxy with apache (static configuration)

Cette étape consite à mettre en place un reverse proxy avec apache, en utilisant une
configuration statique.

## Docker


TODO:
Acceptance criteria
You have a GitHub repo with everything needed to build the Docker image for the container.
You can do a demo, where you start from an "empty" Docker environment (no container running) and where you start 3 containers: static server, dynamic server and reverse proxy; in the demo, you prove that the routing is done correctly by the reverse proxy.
You can explain and prove that the static and dynamic servers cannot be reached directly (reverse proxy is a single entry point in the infra).
You are able to explain why the static configuration is fragile and needs to be improved.
You have documented your configuration in your report.

# Step 4: AJAX requests with JQuery

See documentation [here](./step4/README.md)

# Step 5: Dynamic reverse proxy configuration

See documentation [here](./step5/README.md)