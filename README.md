# Spark JupyterHub

![CI Status](https://img.shields.io/github/workflow/status/guangie88/spark-jupyterhub/CI/master?label=CI&logo=github&style=for-the-badge)

Opinionated set-up to build Docker image with Spark + JupyterHub.

This also comes with custom script to easily set up multi-user Conda
environments.

## Prerequisites

- Docker

### How to build

Example Docker build command:

```bash
docker build . -t spark-jupyterhub
```

It is more effective to check out how to run examples instead, especially the
one for GitHub OAuth.

### How to run

Follow the examples listed here:

- [GitHub OAuth](examples/github)

## Changelogs

All self-versioned change logs are listed in [`CHANGELOG.md`](CHANGELOG.md).
