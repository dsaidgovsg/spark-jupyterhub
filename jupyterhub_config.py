from oauthenticator.github import GitHubOAuthenticator
c.JupyterHub.authenticator_class = GitHubOAuthenticator

# These env vars will be retrieved at runtime
# $OAUTH_CALLBACK_URL: http[s]://[your-host]/hub/oauth_callback
# $OAUTH_CLIENT_ID
# $OAUTH_CLIENT_SECRET
