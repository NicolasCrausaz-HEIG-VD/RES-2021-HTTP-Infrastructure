# Step 3: Reverse proxy with apache (static configuration)

cd step3

Changer le fichier host:

localhost reverse.res.ch

docker build -t res/reverseproxy .

docker run -d -p 8080:80 --name reverse_proxy  res/reverseproxy 

