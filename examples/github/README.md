# Spark-JupyterHub GitHub Example

## Prerequisites

- `docker` + `docker-compose`
- GitHub account (must be able to add OAuth app)

## Steps

### Set up OAuth application in GitHub

Follow the official GitHub instructions to add OAuth application:
<https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/>

Two of the fields are mandatory and are fixed for this example to work:

- `"Homepage URL"`: `http://localhost:8000/`
- `"Authorization callback URL"`: `http://localhost:8000/hub/oauth_callback`

The rest of the fields are optional and you can enter whatever values you like.

Register the application, and you should obtain both the **Client ID** and
**Client Secret**.

Amend the `docker-compose.yml` as follow:

- Paste the **Client ID** value into the environment value `OAUTH_CLIENT_ID`.
- Paste the **Client Secret** value into the environment value
`OAUTH_CLIENT_SECRET`.

Always remember to keep these values in secret. If accidentally leaked, you may
choose to reset the client secret in the same GitHub OAuth application setting
page.

### Run `docker-compose`

With the above modified `docker-compose.yml`, run the following:

```bash
docker-compose up --build
```

### Run the web application

In your web browser, open the URL `http://localhost:8000/`.

You should be greeted with a button to `"Sign in with GitHub"`.

Click on the button and log into GitHub with your credentials.

Once completely, you should automatically be redirected to the JupyterLab
launcher.

## Optional additional steps

Without Conda environment, all users cannot install any additional packages.
As such, the following describes the steps on installing the new default Conda
environment for each user, and also on how to install packages.

### Create default Conda environment

This set-up contains additional `setup-conda-env` script located in `PATH` by
default. It is meant to allow ease of setting up default and additional Conda
environment.

You are recommended to run the script in the following way.

Following the above steps, in your JupyterHub launcher, click on `Terminal` to
launch a shell terminal under your login.

In the terminal, run `setup-conda-env`. It should automatically install all the
relevant packages that is required to set up the new environment.

If you need a particular `python` version to start with, then run the script in
this way instead, for e.g. `setup-conda-env python=2.7`. Otherwise it will
install the host version of Python instead.

Once the script has completed, close the terminal (CTRL-D).

You should be back at the launcher screen. Wait for around a minute or two, and
your Conda environment should appear as both the `Notebook` and `Console`. If it
doesn't, force refresh your browser page.

### Installing packages

To install more packages in your created environment, click on `Console` of that
environment.

As an example, to install `numpy`, run the following in the Python shell

```python
!conda install -y numpy
```

This will install `numpy` within the Conda environment.

To test that it is working, close the terminal and open up `Notebook` in the
same Conda environment.

In the new notebook, run:

```python
import numpy as np
a = np.arange(15).reshape(3, 5)
a
```

You should see an array of increasing values.

As a side note, `conda-forge` package repository is added by default, which
generally simplifies most of the `conda install` commands.
