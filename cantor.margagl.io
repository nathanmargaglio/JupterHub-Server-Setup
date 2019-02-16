map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    server_name cantor.margagl.io;

    # Config for JupyterHub
    location / {
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://192.168.0.111:8000;
 
        # websocket headers
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/cantor.margagl.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/cantor.margagl.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}


server {
    if ($host = cantor.margagl.io) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name cantor.margagl.io;
    return 404; # managed by Certbot


}