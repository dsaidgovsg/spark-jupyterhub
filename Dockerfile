# FROM jupyterhub/jupyterhub:1.0
# RUN conda install -y jupyterlab && conda clean --all
# RUN python -m pip install oauthenticator

FROM guangie88/spark-custom-addons:2.4.3_hadoop-3.1.0_k8s_hive_pyspark_debian

ARG MINICONDA3_HOME=/opt/miniconda3

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p "${MINICONDA3_HOME}" && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    rm -rf /var/lib/apt/lists/* && \
    :

ENV MINICONDA3_HOME="${MINICONDA3_HOME}"
ENV PATH="${PATH}:${MINICONDA3_HOME}/bin"

RUN conda install -y -c conda-forge jupyterhub && jupyterhub -h && configurable-http-proxy -h
# RUN conda install -y -c conda-forge jupyterlab
RUN conda install -y notebook
# RUN conda upgrade -y -c conda-forge jupyter_core
RUN conda clean --all

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip python3-setuptools && \
    rm -rf /var/lib/apt/lists/* && \
    :

RUN python3 -m pip install oauthenticator

# Original jupyterhub also uses the path below
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

CMD ["jupyterhub"]
