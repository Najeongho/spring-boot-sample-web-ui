#!/bin/bash

docker build --no-cache --build-arg APP_VERSION=v1 -f Dockerfile-nginx  -t spring-boot/nginx:v1 .