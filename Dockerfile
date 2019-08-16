# FROM jupyterhub/jupyterhub:1.0
# RUN conda install -y jupyterlab && conda clean --all
# RUN python -m pip install oauthenticator

FROM guangie88/spark-custom-addons:2.4.3_hadoop-3.1.0_k8s_hive_pyspark_debian

ARG CONDA_HOME=/opt/conda

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p "${CONDA_HOME}" && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    rm -rf /var/lib/apt/lists/* && \
    :

ENV CONDA_HOME="${CONDA_HOME}"
ENV PATH="${CONDA_HOME}/bin:${PATH}"

RUN conda install -y -c conda-forge \
    python=3.6 sqlalchemy tornado jinja2 traitlets requests pip pycurl \
    nodejs configurable-http-proxy jupyterlab && \
    pip install --upgrade pip && \
    pip install oauthenticator && \
    :

# RUN conda install -y -c conda-forge jupyterhub && jupyterhub -h && configurable-http-proxy -h
# RUN conda install -y -c conda-forge jupyterlab
# RUN conda install -y notebook
# RUN conda upgrade -y -c conda-forge jupyter_core
RUN conda clean --all

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends python3-pip python3-setuptools && \
#     rm -rf /var/lib/apt/lists/* && \
#     :

# RUN python3 -m pip install oauthenticator

# Original jupyterhub also uses the path below
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000


# `ls ${SPARK_HOME}/python/lib/py4j* | sed -E "s/.+(py4j-.+)/\1/" | tr -d "\n"` to get the py4j source zip file
ARG PY4J_SRC="py4j-0.10.7-src.zip"
ENV PYTHONPATH "${SPARK_HOME}/python:${SPARK_HOME}/python/lib/${PY4J_SRC}"

CMD ["jupyterhub"]
