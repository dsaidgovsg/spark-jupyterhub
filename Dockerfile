ARG BASE_VERSION=v2
ARG SPARK_VERSION=3.3.0
ARG HADOOP_VERSION=3.3.2
ARG SCALA_VERSION=2.13

# Note k8s based images are always officially Alpine-based
FROM dsaidgovsg/spark-k8s-addons:${BASE_VERSION}_${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}

# Require root user to run the service properly
USER root

# Python version can be anything as long as the deps below can be installed
ARG PYTHON_VERSION=3.9
ARG JUPYTERHUB_VERSION=2.3.1

# Install required packages for JupyterHub
RUN conda install -y -p "${CONDA_PREFIX}" \
    configurable-http-proxy \
    jinja2 \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    # labextension below only allow for jupyterlab<3.0.0
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
