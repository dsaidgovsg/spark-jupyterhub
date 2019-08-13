FROM jupyterhub/jupyterhub:1.0
RUN conda install -y jupyterlab && conda clean --all
RUN python -m pip install oauthenticator
