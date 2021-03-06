#!/bin/bash

set -e

echo "Blue-Green Deployment is started!"


echo "Route to green application (web-ui2)"
cat conf/nginx/nginx.green.conf > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
	docker exec -it $cid nginx -s reload
done

sleep 10


echo "Deploy new application to blue application (web-ui1)"
docker stack deploy -c docker-compose.blue.yml --resolve-image=changed spring-boot
sleep 60

echo "Route to blue application (web-ui1)"
cat conf/nginx/nginx.blue.conf > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
	docker exec -it $cid nginx -s reload
done

sleep 10


echo "Deploy new application to green application (web-ui2)"
docker stack deploy -c docker-compose.green.yml --resolve-image=changed spring-boot
sleep 60

echo "Route round robin (web-ui1 <-> web-ui2)"
cat conf/nginx/nginx.round-robin.conf > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
	docker exec -it $cid nginx -s reload
done


echo "Blue-Green Deployment is finished!"