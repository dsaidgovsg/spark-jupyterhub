ARG BASE_VERSION=v2
ARG SPARK_VERSION=2.4.5
ARG HADOOP_VERSION=3.1.0
ARG SCALA_VERSION=2.12

# Note k8s based images are always officially Alpine-based
FROM dsaidgovsg/spark-k8s-addons:${BASE_VERSION}_${SPARK_VERSION}_hadoop-${HADOOP_VERSION}_scala-${SCALA_VERSION}

# Require root user to run the service properly
USER root

# Python version can be anything as long as the deps below can be installed
ARG PYTHON_VERSION=3.7
ARG JUPYTERHUB_VERSION=1.1.0

# Install required packages for JupyterHub
RUN conda install -y -p "${CONDA_PREFIX}" \
    configurable-http-proxy \
    jinja2 \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    # labextension below only allow for jupyterlab<3.0.0
    jupyterlab=2.2 \
    pycurl \
    "python=${PYTHON_VERSION}" \
    nb_conda_kernels \
    nodejs \
    oauthenticator \
    requests \
    sqlalchemy \
    tornado \
    traitlets \
    pip \
    && \
    conda clean -a -y && \
    :

RUN pip install sparkmonitor && \
    jupyter nbextension install sparkmonitor --py && \
    jupyter nbextension enable  sparkmonitor --py && \
    jupyter serverextension enable --py --system sparkmonitor # this should happen automatically && \
    jupyter lab build && \
    jupyter labextension install @jlab-enhanced/launcher && \
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
COPY ./entrypoint.sh "./entrypoint.sh"

ENTRYPOINT [ "./entrypoint.sh" ]
