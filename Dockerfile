ARG SPARK_VERSION=2.4.5
ARG HADOOP_VERSION=3.1.0

# Note k8s based images are always officially Alpine-based
FROM guangie88/spark-k8s-addons:${SPARK_VERSION}_hadoop-${HADOOP_VERSION}

# Require root user to run the service properly
USER root

# Python version can be anything as long as the deps below can be installed
ARG PYTHON_VERSION=3.7
ARG JUPYTERHUB_VERSION=1.1.0

# Install required packages for JupyterHub
RUN conda install -y -c conda-forge \
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

CMD ["jupyterhub"]
