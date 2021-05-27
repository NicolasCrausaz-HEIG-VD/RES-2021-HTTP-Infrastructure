docker compose up -d reverse-proxy

docker-compose up -d static
docker-compose up -d --scale static=2

docker-compose up -d static
docker-compose up -d --scale static=2

docker compose up -d dynamic
docker-compose up -d --scale dynamic=3