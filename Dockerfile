ARG BASE_VERSION=v5
ARG SPARK_VERSION=3.4.1
ARG HADOOP_VERSION=3.3.4
ARG SCALA_VERSION=2.13
ARG JAVA_VERSION=8
ARG PYTHON_VERSION=3.9

FROM dsaidgovsg/spark-k8s-addons:${BASE_VERSION}_${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}_java-${JAVA_VERSION}_python-${PYTHON_VERSION}

# Require root user to run the service properly
USER root

ARG JUPYTERHUB_VERSION=2.3.1

# This directory will hold all the default bins and libs installed via conda
ARG CONDA_HOME=/opt/conda
ENV CONDA_HOME="${CONDA_HOME}"
ENV PATH="${CONDA_HOME}/bin:${PATH}"

# Install wget for to get external deps
RUN set -euo pipefail && \
    apt-get update; \
    apt-get install -y wget; \
    rm -rf /var/lib/apt/lists/*; \
    :

ARG MINICONDA3_VERSION="py39_4.12.0"

RUN set -euo pipefail && \
    ## Install conda via installer
    wget "https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh"; \
    bash "Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh" -b -p "${CONDA_HOME}"; \
    rm "Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh"; \
    ## Create the basic configuration for installation later
    ## Do not put any packages in create because this seems to pin the packages to the given versions
    ## Use conda install for that instead
    conda config --add channels conda-forge; \
    conda clean -a -y; \
    :

# Install required packages for JupyterHub
RUN conda install -y \
    configurable-http-proxy \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    # labextension below only allow for jupyterlab<3.0.0
    jupyterlab \
    nb_conda_kernels \
    oauthenticator \
    && \
    conda clean -a -y && \
    conda init bash && \
    :

RUN jupyter labextension install @jlab-enhanced/launcher && \
    jupyter labextension disable @jupyterlab/launcher-extension && \
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
