ARG FROM_DOCKER_IMAGE="guangie88/spark-custom-addons"
ARG SPARK_VERSION=2.4.3
ARG HADOOP_VERSION=3.1.0
ARG HIVE_TAG_SUFFIX="_hive"
ARG PYSPARK_TAG_SUFFIX="_pyspark"

FROM ${FROM_DOCKER_IMAGE}:${SPARK_VERSION}_hadoop-${HADOOP_VERSION}${HIVE_TAG_SUFFIX}${PYSPARK_TAG_SUFFIX}_debian

ARG PYTHON3_VERSION=3.7
ARG CONDA_HOME=/opt/conda

# PY4J_SRC=`ls ${SPARK_HOME}/python/lib/py4j* | sed -E "s/.+(py4j-.+)/\1/" | tr -d "\n"` to get the py4j source zip file
ARG PY4J_SRC="py4j-0.10.7-src.zip"
ENV PYTHONPATH "${SPARK_HOME}/python:${SPARK_HOME}/python/lib/${PY4J_SRC}"

# Install conda
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p "${CONDA_HOME}" && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Override the system python and uses python / python3 from conda
    # Does not affect the env in Dockerfile
    echo "PATH=${CONDA_HOME}/bin:${PATH}" > /etc/profile.d/conda.sh && \
    :

# Also set for Docker env for docker exec
ENV PATH="${CONDA_HOME}/bin:${PATH}"

# Install required packages for JupyterHub
RUN conda update -y -n base -c defaults conda && \
    conda install -y -c conda-forge \
    configurable-http-proxy \
    jinja2 \
    jupyterlab \
    pip \
    pycurl \
    "python=${PYTHON3_VERSION}" \
    nb_conda_kernels \
    nodejs \
    requests \
    sqlalchemy \
    tornado \
    traitlets \
    && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install oauthenticator && \
    conda clean --all && \
    :

# Original jupyterhub also uses the path below
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

# Custom script to easily allow conda set-up
COPY ./setup-conda-env "${CONDA_HOME}/bin/"

CMD ["jupyterhub"]

