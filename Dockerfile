ARG BASE_VERSION=v4
ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=3.2.0
ARG SCALA_VERSION=2.12
ARG PYTHON_VERSION=3.8

# Note k8s based images are always officially Alpine-based
FROM dsaidgovsg/spark-k8s-addons:${BASE_VERSION}_${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}_python-${PYTHON_VERSION}

# Require root user to run the service properly
USER root

# This directory will hold all the default bins and libs installed via conda
ARG CONDA_HOME=/opt/conda
ENV CONDA_HOME="${CONDA_HOME}"
ARG CONDA_PREFIX=/opt/conda/default
ENV CONDA_PREFIX="${CONDA_PREFIX}"

# The conda3 version shouldn't matter much, can just take the latest
ARG MINICONDA3_VERSION="py38_4.8.2"

# Install wget for to get external deps
RUN set -euo pipefail && \
    apt-get update; \
    apt-get install -y wget; \
    rm -rf /var/lib/apt/lists/*; \
    :

RUN set -euo pipefail && \
    ## Install conda via installer
    wget "https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh"; \
    bash "Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh" -b -p "${CONDA_HOME}"; \
    rm "Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh"; \
    ## Create the basic configuration for installation later
    ## Do not put any packages in create because this seems to pin the packages to the given versions
    ## Use conda install for that instead
    "${CONDA_HOME}/bin/conda" config --add channels conda-forge; \
    "${CONDA_HOME}/bin/conda" create -y -p "${CONDA_PREFIX}"; \
    "${CONDA_HOME}/bin/conda" clean -a -y; \
    :

# We set conda with higher precedence on purpose here to handle all Python
# related packages over the system package manager
ENV PATH="${CONDA_PREFIX}/bin:${CONDA_HOME}/bin:${SPARK_HOME}/bin:${PATH}"

# Python version can be anything as long as the deps below can be installed
ARG PYTHON_VERSION=3.8
ARG JUPYTERHUB_VERSION=1.1.0

# Install required packages for JupyterHub
RUN conda install -y -p "${CONDA_PREFIX}" \
    configurable-http-proxy \
    jinja2 \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    jupyterlab \
    pycurl \
    "python=${PYTHON_VERSION}" \
    nb_conda_kernels \
    nodejs \
    oauthenticator \
    requests \
    sqlalchemy \
    tornado \
    traitlets \
    && \
    conda clean -a -y && \
    :

# Original jupyterhub also uses the path below
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

# Custom script to easily allow conda set-up
COPY ./setup-conda-env "${CONDA_HOME}/bin/"

# The default profile will weaken the PATH for new user, so need to add back the
# relevant conda paths
COPY ./conda.sh "/etc/profile.d/"

CMD ["jupyterhub"]
