# CHANGELOG

## v1

- Basic Docker implementation. Supports only Spark 2.4.4.
- Alpine-based due to usage of Kubernetes supported base image. This will be
  changed to Debian once Spark 3.y is stable, since the Spark repository has
  already switched to the more reliable Debian (slim) set-up both for Java and
  Python.
- Comes with `/opt/conda/bin/setup-conda-env` that is useful for creating new
  Conda environment and automagically allow the JupyterHub launcher to detect
  new environments (wait for about a minute).
