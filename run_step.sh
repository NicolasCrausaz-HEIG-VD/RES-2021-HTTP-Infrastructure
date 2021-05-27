#!/bin/bash

function step1 {
   if [ $OMIT_BUILD = false ]
   then
      eval "docker build -t res/static-apache ./step1";
   fi
   eval "docker run -d --name static_apache -p 9090:80 res/static-apache";
}

function step2 {
   if [ $OMIT_BUILD = false ]
   then
   eval "cd step2/src";
   eval "npm install";
   eval "cd ..";
   eval "cd ..";
   eval "docker build -t res/node-express ./step2";
   fi
   eval "docker run -d --name express_dynamic -p 8282:3000 res/node-express";
}

if [ "$1" = "" ]; then
  echo "Invalid step";
  exit;
fi

if [ "$1" = "purge" ]; then
  eval `docker kill $(docker ps -q)`;

      if [ "$2" = "-rm" ]; then
         eval `docker rm $(docker ps -a -q)`;
      fi
  exit;
fi
  #eval `docker rm $(docker ps -a -q)`;
  exit;
fi

# Flag to omit build
if [ "$2" = "--nobuild" ]; then
   OMIT_BUILD=true
else
   OMIT_BUILD=false
fi

echo "Specified step: $1";

case "$1" in

   1 ) 
      # Step 1: Static HTTP server with apache httpd
      step1;
      ;;

   2 ) 
      # Step 2: Dynamic HTTP server with express.js
      step2;
      ;;

   3 ) 
      # Step 3: Reverse proxy with apache (static configuration)
      step2;
      step1;
      if [ $OMIT_BUILD = false ]
      then
         eval "docker build -t res/reverseproxy ./step3"
      fi
      eval "docker run -d -p 8080:80 --name reverse_proxy res/reverseproxy"
   ;;

   4 )
      # Step 4: AJAX requests
      if [ $OMIT_BUILD = false ]
      then
         eval "docker build -t res/static-ajax ./step4"
      fi
      eval "docker run -d --name static_ajax -p 9090:80 res/static-ajax"
      ;;

   5 )
      # Step 5: Dynamic reverse proxy configuration

      if [ $OMIT_BUILD = false ]
      then
         eval "docker build -t res/node-express ./step2";
         eval "docker build -t res/static-ajax ./step4";
         eval "docker build -t res/dynamic-proxy ./step5"
      fi

      id=$(eval "docker run -d res/static-ajax")
      staticIP=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":80";
      id=$(eval "docker run -d res/node-express")
      APIIP=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":3000";

      eval "docker run -p 8080:80 -d -e STATIC_APP=$staticIP -e DYNAMIC_APP=$APIIP res/dynamic-proxy";
      ;;

   6 )
      # Additional steps: Load balancing: multiple server nodes
      # Creates 3 static containers & 3 API containers
      # Gets theirs IP to run the reverse proxy

      if [ $OMIT_BUILD = false ]
      then
         eval "docker build -t res/node-express ./step2";
         eval "docker build -t res/static-ajax ./step4";
         eval "docker build -t res/load-balancing ./loadBalancing"
      fi

      staticNodes=''
      APINodes=''

      for i in {0..2}
      do
         id=$(eval "docker run -d res/static-ajax")
         staticNodes+=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":80";
         if [ $i != 2 ]; then
            staticNodes+=",";
         fi
      done

      for i in {0..2}
      do
         id=$(eval "docker run -d res/node-express")
         APINodes+=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":3000";
         if [ $i != 2 ]; then
            APINodes+=",";
         fi
      done
      
      eval "docker run -p 8080:80 -d -e STATIC_APP=$staticNodes -e DYNAMIC_APP=$APINodes res/load-balancing";
      ;;

   7 )
      # Additional steps: Load balancing: round-robin vs sticky sessions
      if [ $OMIT_BUILD = false ]
      then
         eval "docker build -t res/node-express ./step2";
         eval "docker build -t res/static-ajax ./step4";
         eval "docker build -t res/round-sticky ./round-sticky"
      fi

      staticNodes=''
      APINodes=''

      for i in {0..2}
      do
         id=$(eval "docker run -d res/static-ajax")
         staticNodes+=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":80";
         if [ $i != 2 ]; then
            staticNodes+=",";
         fi
      done

      for i in {0..2}
      do
         id=$(eval "docker run -d res/node-express")
         APINodes+=$(eval "docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id")":3000";
         if [ $i != 2 ]; then
            APINodes+=",";
         fi
      done
      
      eval "docker run -p 8080:80 -d -e STATIC_APP=$staticNodes -e DYNAMIC_APP=$APINodes res/round-sticky";
      ;;

   8 )
      # Additional steps: Dynamic cluster management

      if [ $OMIT_BUILD = false ]
      then
         echo "todo";
      fi
      ;;

   9 )
      # Additional steps: Management UI
      echo "This step cannot be executed with the script, please run";
      echo "docker volume create portainer_data";
      echo "docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce";
      ;;

   * )
      echo "Invalid step";
      exit;
      ;;
esac

sleep 10