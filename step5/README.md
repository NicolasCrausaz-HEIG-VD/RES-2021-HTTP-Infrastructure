# Step 5: Dynamic reverse proxy configuration

docker build -t res/dynamic-proxy .

docker run res/dynamic-proxy

docker run -e STATIC_APP=172.17.0.2:80 -e DYNAMIC_APP=172.17.0.3:3000 res/dynamic-proxy
