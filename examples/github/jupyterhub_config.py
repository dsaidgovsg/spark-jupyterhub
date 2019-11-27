from oauthenticator.github import LocalGitHubOAuthenticator
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator

# Allows creation of users `adduser` when /home/xxx is not present
c.LocalAuthenticator.create_system_users = True

# If home directory of user already exists, use back the same uid and gid for the re-creation
# Original cmd: https://jupyterhub.readthedocs.io/en/stable/api/auth.html#jupyterhub.auth.LocalAuthenticator.add_user_cmd
# Note that the code always append additional '<username>' at the end, but subsequent args in /bin/bash -c "cmd" "..." are ignored
c.LocalAuthenticator.add_user_cmd = [
    '/bin/bash', '-c',
    # Try get uid and gid of given user name in /home/USERNAME
    '[ -d /home/USERNAME ] && uid=$(stat -c "%u" /home/USERNAME 2>/dev/null) gid=$(stat -c "%g" /home/USERNAME 2>/dev/null)'
    # If uid and gid exists (i.e. username was created before), recreate user with back the same uid and gid
    ' && addgroup -g $gid USERNAME && adduser -s /bin/bash -g "" -D -u $uid -G USERNAME USERNAME'
    # Else list out all uids/gids and +1 to the largest uid/gid found to form the next uid/gid
    # use 1000 as default if no uid/gid was found
    ' || ('
    ' uids=$(ls -nl /home/ | sed "s/\s\s*/ /g" | cut -d " " -f3)'
    ' && sorted_uids=$(for uid in $uids; do case $uid in [0-9][0-9]*) echo $uid ;; esac; done | uniq | sort -r)'
    ' && largest_uid=$(echo $sorted_uids | cut -d " " -f1)'
    ' && next_uid=$(if [ ! -z "$largest_uid" ]; then echo "$((largest_uid + 1))"; else echo 1000; fi)'
    ' && gids=$(ls -nl /home/ | sed "s/\s\s*/ /g" | cut -d " " -f3)'
    ' && sorted_gids=$(for gid in $gids; do case $gid in [0-9][0-9]*) echo $gid ;; esac; done | uniq | sort -r)'
    ' && largest_gid=$(echo $sorted_gids | cut -d " " -f1)'
    ' && next_gid=$(if [ ! -z "$largest_gid" ]; then echo "$((largest_gid + 1))"; else echo 1000; fi)'
    ' && addgroup -g $next_gid USERNAME && adduser -s /bin/bash -g "" -D -u $next_gid -G USERNAME USERNAME'
    ' )'
]

# Use JupyterLab by default
c.Spawner.default_url = '/lab'

# IP and port
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = 8000

# These env vars will be retrieved at runtime
# OAUTH_CALLBACK_URL: http[s]://[your-host]/hub/oauth_callback
# OAUTH_CLIENT_ID
# OAUTH_CLIENT_SECRET
