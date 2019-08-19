#!/usr/bin/env bash
set -euo pipefail

docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
docker push "${DOCKER_IMAGE}:${SPARK_VERSION}_hadoop-${HADOOP_VERSION}"
