# Installation portainer

Source: https://documentation.portainer.io/v2.0/deploy/ceinstalldocker/ (Docker on Windows WSL / Docker Desktop)
https://documentation.portainer.io/v2.0/deploy/initial/

## Installation:

1. docker volume create portainer_data

2. docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

Attention: bien se rappeler du username + password

username par défaut = admin

todo: images première connexion (incription)

## Réutilisation:

1. docker container restart portainer
2. todo: images connexion

## Visite de l'UI
Lancer le navigateur avec l'URL: http://localhost:9000/

## Quitter l'UI
1. Quitter la page internet
2. docker kill portainer

## Réutilisation
Le but est de ne pas suppriemer le container créé et de ré-utiliser le même.