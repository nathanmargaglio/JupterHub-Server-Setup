c.JupyterHub.admin_access = True
c.Spawner.default_url = '/lab'
c.Spawner.cmd = ['jupyter-labhub']
c.Authenticator.admin_users = {'nathan'} c.LocalAuthenticator.create_system_users = True