# Step 5: Dynamic reverse proxy configuration

docker build -t res/dynamic-proxy .

docker run res/dynamic-proxy

docker run -e STATIC_APP=172.17.0.2:80 -e DYNAMIC_APP=172.17.0.3:3000 res/dynamic-proxy

## test de l'infra
docker build -t res/static-apache ./step4

3 fois:
docker run -d res/static-apache
docker run -d --name apache_static res/static-apache

docker build -t res/express ./step2

2 fois:
docker run -d res/express
docker run -d --name express_dynamic res/express

docker ps
vérifier qu'ils sont tous lancés

pleins de containers pour des adresses ip différentes

docker inspect express_dynamic | grep -i ipaddress
docker inspect apache_static | grep -i ipaddress

Résultats:
"SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.6",
                    "IPAddress": "172.17.0.6",
                    
"SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.5",
                    "IPAddress": "172.17.0.5",

docker build -t res/dynamic_proxy ./step5

docker run -d -e STATIC_APP=172.17.0.5:80 -e DYNAMIC_APP=172.17.0.6:3000 --name dynamic_proxy -p 8080:80 res/dynamic_proxy

docker ps pour vérifier qu'il s'est bien lancé

docker logs dynamic_proxy

tester dans le navigateur à l'addresse:
http://reverse.res.ch:8080/
vérifier si tout fonctionne comme prévu
vérifier dans le mode développeur du navigateur si les requêtes GET de grades sont bien reçues

TODO: vérfier si les noms correspondent bien entre toutes les étapes du readme et unifié