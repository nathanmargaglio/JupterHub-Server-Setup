map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}
 
server {
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
 
    server_name godel.margagl.io;
 
    # Config for JupyterHub
    location / {
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:8000;
 
        # websocket headers
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}