ARG FROM_DOCKER_IMAGE="guangie88/spark-k8s-addons"
ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=3.1.0

# Note k8s based images are always officially Alpine-based
FROM ${FROM_DOCKER_IMAGE}:${SPARK_VERSION}_hadoop-${HADOOP_VERSION}

# Require root user to run the service properly
USER root

# PY4J_SRC=`ls ${SPARK_HOME}/python/lib/py4j* | sed -E "s/.+(py4j-.+)/\1/" | tr -d "\n"` to get the py4j source zip file
ARG PY4J_SRC="py4j-0.10.7-src.zip"
ENV PYTHONPATH "${SPARK_HOME}/python:${SPARK_HOME}/python/lib/${PY4J_SRC}"

ARG JUPYTERHUB_VERSION=1.0.0

# Install required packages for JupyterHub
RUN conda install -y -c conda-forge \
    configurable-http-proxy \
    jinja2 \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    jupyterlab \
    pycurl \
    nb_conda_kernels \
    nodejs \
    oauthenticator \
    requests \
    sqlalchemy \
    tornado \
    traitlets \
    && \
    conda clean -a -y && \
    # Required to resolve the weird jupyterhub undefined symbol: pam_strerror linking
    apk add --no-cache binutils linux-pam-dev; \
    :

# Original jupyterhub also uses the path below
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

# Custom script to easily allow conda set-up
COPY ./setup-conda-env "${CONDA_HOME}/bin/"

CMD ["jupyterhub"]
