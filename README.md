# RES 2021 - Infrastracture HTTP

> Par Alec Berney & Nicolas Crausaz

# Introduction

Ce laboratoire fait partie du cours RES-2021 de l'HEIG-VD.

Il permet de mettre en pratique l'utilisation de Docker et les interactions avec HTTP.

Les outils utilisés tout au long de ce laboratoire sont:

- Docker + WSL (Windows)
- Node.js v14.16
- php v7.4
- apache
- JQuery

# Step 1: Static HTTP server with apache httpd

Cette étape consiste à mettre en place un serveur apache et de modifier
le contenu servi par le serveur HTTP. Pour ce faire, nous avons créer une image Docker.

Nous avons récupéré un template issu du framework CSS [Bulma](https://bulma.io/).

## Docker

Notre image docker est construite sur la base d'une image php (v7.4) + apache, nous ajoutons simplement notre
site statique (src/) dans le dossier apache par défaut.

```dockerfile
FROM php:7.4-apache

COPY src/ /var/www/html/
```

Pour construire notre image et démarrer le container, il faut exécuter les commandes suivantes:

- `cd ./step1`

- `docker build -t res/static-apache .`

- `docker run -d --name static_apache -p 9090:80 res/static-apache`

Notre site est ainsi accessible sur [http://localhost:9090/](http://localhost:9090/)

# Step 2: Dynamic HTTP server with express.js

Cette application prédit votre note dans des unités d'enseignement de l'HEIG-VD. Il s'agit d'une application Node.js avec le module express.js, permettant de construire des API HTTP. 

## Docker

Notre image docker est construite sur la base d'une image Node.js (v14.16).

Nous copions le contenu de notre application vers notre container (/opt/app), puis démarrons notre application node.

```dockerfile
FROM node:14.16

COPY src/ /opt/app

CMD ["node", "/opt/app/app.js"]
```

Pour mettre en place cette application, il faut exécuter les commandes suivantes:

- `cd step2/src`

- `npm install`

- `cd ..`

- `docker build -t res/node-express .`

- `docker run -d --name express_dynamic -p 8282:3000 res/node-express`

Notre API est maintenant accessible sur sur [http://localhost:8282/](http://localhost:8282/).

## Utilisation

Cette API dispose de 4 routes:

- [http://localhost:8282/](http://localhost:8282/)

   Une requête HTTP sur cette URL retournera un simple message texte:

   ```
   Hello, this is the main endpoint
   ```

- [http://localhost:8282/grades](http://localhost:8282/grades)

   Une requête HTTP sur cette URL retournera la liste de toutes les unités
   avec une note aléatoire pour chacune de celles-ci.

   ```json
   [
      {"unit":"RES", "grade":5},
      {"unit":"PCO", "grade":6},
      {"unit":"ASD", "grade":1},
      {"unit":"ISD", "grade":4},
      {"unit":"MAT1", "grade":1},
               ...
      {"unit":"TIB", "grade":4}
   ]
   ```


- [http://localhost:8282/grade/(unit)](http://localhost:8282/grade/<unit>)

   Une requête HTTP sur cette URL retournera une note pour l'unité passée en paramètre, la liste des unités disponibles se trouve [ici](./step2/src/data/units.js).

   ```json
   [
      {"unit":"RES", "grade":6},
   ]
   ```

- [http://localhost:8282/one](http://localhost:8282/one)

    Une requête HTTP sur cette URL retournera une note pour une unité aléatoire.

   ```json
   [
      {"unit":"SYE", "grade":6}
   ]
   ```

# Step 3: Reverse proxy with apache (static configuration)

Cette étape consite à mettre en place un reverse proxy avec apache, en utilisant une configuration statique.

Nous avons créer un vHost faisant office de reverse proxy, il est chargé de rediriger une requête HTTP vers le bon serveur en fonction de l'URL de cette requête.

Dans cette étape la configuration est faite de manière statique, ce qui n'est pas optimal car on doit reconfigurer nos fichiers de configuration et reconstruire notre image si les adresses IP de nos containers ont changer.

Notre configuration est donc:

```
<VirtualHost *:80>
   ServerName reverse.res.ch

   # Routes for api requests (random grades)
   ProxyPass "/api/" "http://172.17.0.2:3000/"
   ProxyPassReverse "/api/" "http://172.17.0.2:3000/"

   # Routes for static website
   ProxyPass "/" "http://172.17.0.3:80/"
   ProxyPassReverse "/" "http://172.17.0.3:80/"

</VirtualHost>
```

TODO: AJOUTER UN SHEMA DE L'INFRA

## Docker

Notre image docker est construite sur la base d'une image php (v7.4) + apache, nous ajoutons nos fichiers de configuration (vHosts) dans le dossier sites-available de apache.

Nous activons le module apache proxy et proxy_http grâce à la commande `a2enmod`, puis actions nos hôtes virtuels grâce à la commande `a2ensite`.

```dockerfile
FROM php:7.4-apache

COPY conf/ /etc/apache2

RUN a2enmod proxy proxy_http
RUN a2ensite 000-* 001-*
```

You are able to explain why the static configuration is fragile and needs to be improved.
You have documented your configuration in your report.

# Step 4: AJAX requests with JQuery

See documentation [here](./step4/README.md)

# Step 5: Dynamic reverse proxy configuration

See documentation [here](./step5/README.md)