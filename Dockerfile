FROM nginxproxy/docker-gen

# Settings Proxy Wide
COPY conf.d /etc/nginx/conf.d

# Settings per VIRTUAL_HOST
COPY vhost.d /etc/nginx/vhost.d

# HTTP Basic Authentication
COPY htpasswd /etc/nginx/htpasswd

# Template file for nginX
COPY nginx.tmpl /etc/docker-gen/templates/nginx.tmpl
