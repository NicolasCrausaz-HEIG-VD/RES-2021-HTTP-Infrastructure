cd dyn-cluster

docker run -d -p 8080:8080 -p 80:80 -v $PWD/traefik.yml:/etc/traefik/traefik.yml -v /var/run/docker.sock:/var/run/docker.sock traefik:v2.0

docker run -d --name test containous/whoami