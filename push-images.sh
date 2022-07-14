#!/usr/bin/env bash
set -euo pipefail

echo "${DOCKER_PASSWORD}" | docker login -u="${DOCKER_USERNAME}" --password-stdin

IMAGE_NAME=${IMAGE_NAME:-spark-jupyterhub}

TAG_NAME="${SELF_VERSION}_${JUPYTERHUB_VERSION}_spark-${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}_java-${JAVA_VERSION}"
docker tag "${IMAGE_NAME}:${TAG_NAME}" "${IMAGE_ORG}/${IMAGE_NAME}:${TAG_NAME}"
docker push "${IMAGE_ORG}/${IMAGE_NAME}:${TAG_NAME}"

ALT_TAG_NAME="${JUPYTERHUB_VERSION}_spark-${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}_java-${JAVA_VERSION}"
docker tag "${IMAGE_NAME}:${TAG_NAME}" "${IMAGE_ORG}/${IMAGE_NAME}:${ALT_TAG_NAME}"
docker push "${IMAGE_ORG}/${IMAGE_NAME}:${ALT_TAG_NAME}"
