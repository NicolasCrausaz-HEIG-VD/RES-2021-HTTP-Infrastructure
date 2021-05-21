# Step 4: AJAX requests

Pour cette étape, il s'agit de se familiariser avec les requêtes AJAX (Asynchronous JavaScript and XML).
Pour se faire nous avons utilisé l'API native javascript *fetch*.

docker build -t res/static-ajax ./step4

docker run -d --name static_ajax -p 9090:80 res/static-ajax

Reverse proxy obligatoire car pas le même domaine (CORS)

TODO: Inserer une capture des notes