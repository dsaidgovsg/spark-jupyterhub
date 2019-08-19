from oauthenticator.github import LocalGitHubOAuthenticator
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator

# Allows creation of users `adduser` when /home/xxx is not present
c.LocalAuthenticator.create_system_users = True

# Use JupyterLab by default
c.Spawner.default_url = '/lab'

# To prevent default kernel from appearing
c.KernelSpecManager.ensure_native_kernel = False

# These env vars will be retrieved at runtime
# $OAUTH_CALLBACK_URL: http[s]://[your-host]/hub/oauth_callback
# $OAUTH_CLIENT_ID
# $OAUTH_CLIENT_SECRET
