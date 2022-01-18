#!/bin/bash
DOCKER_USERNAME=
IMAGE=webserver
if [ -z ${DOCKER_USERNAME} ]; then
    echo "Missing DOCKER_USERNAME variable!"
    exit 1
fi

error() {
    if [ $? != 0 ]; then
        echo "Error!"
        exit 122
    fi
}

build() {
    echo "=> Building $IMAGE"
    docker build -t $IMAGE .
    echo "=> Built $IMAGE"
}

tag() {
    echo "=> Tagging $IMAGE"
    docker tag webserver $(echo $DOCKER_USERNAME)/$(echo $IMAGE)
    echo "=> Tagged $IMAGE"
}

push() {
    echo "=> Pushing $IMAGE"
    docker push $(echo $DOCKER_USERNAME)/$(echo $IMAGE)
    echo "=> Pushed $IMAGE"
}

build $IMAGE
error
tag $IMAGE
error
push $IMAGE
error
echo

exit 0