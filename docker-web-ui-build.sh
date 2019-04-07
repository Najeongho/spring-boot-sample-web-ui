#!/bin/bash

set -e

if (( $# != 1 ))
then
    echo "Usage : docker-web-ui-build.sh [version]" 1>&2
    exit 1
fi


VERSION=$1
echo ${VERSION}


docker build --no-cache --build-arg APP_VERSION=${VERSION} -f Dockerfile-web-ui -t spring-boot/web-ui:${VERSION} .