#!/usr/bin/env bash

set -e
export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo $TRAVIS_PULL_REQUEST_BRANCH; fi)
export DOCKER_IMAGE_TAG=$(if [ "$BRANCH" == "master" ]; then echo "latest"; else echo "$BRANCH-latest"; fi)
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use
docker buildx build --progress plain --platform linux/amd64,linux/arm64,linux/arm/v7 -t $DOCKER_USERNAME/pai:$DOCKER_IMAGE_TAG . --push