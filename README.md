# nginx-proxy

An automated nginx proxy for Docker containers.

## Quick Start
```bash
# download repo
git clone https://gitlab.com/saulmendoza/nginx-proxy
cd nginx-proxy

# development mode
make setup build dev

# production mode
make setup build start

# testing
curl -H "Host: whoami.local" localhost
# Example Output: I'm 5b129ab83266
```

## Features (All Automated)
- Update and reload of nginx config
  - certificate creation/renewal
  - containers started/stopped
- SSL certificates of Let's Encrypt (or other ACME CAs) using acme.sh.
- Let's Encrypt / ACME domain validation through `http-01` challenge only.

## Workflow
- The `docker-gen` service of this `docker-compose.yml` is notified of any new or stopped containers to update the nginx config.
- If the new containers have the environment variable `VIRTUAL_HOST` they will be added to the proxy automatically.
- If you want SSL certificates, add these environment variables to the containers: `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL`.

## Practices
- 3 Separated docker containers (`nginx-proxy`, `docker-gen` and `acme-companion`)
- 1 Separated docker volume for storing SSL certificates (`certs`)
- 3 main environments split by **GitLab Runner Tags** (`dev`, `stage`, `master`)
- One .env file per environment, fallback to `env/default.env`
- One .conf file per `VIRTUAL_HOST` configutation
- One file per HTTP Basic Authentication (per `VIRTUAL_HOST`)

## Notes
- LetsEncrypts requires a domain validation for every creation/renewal of certificates
  - Remember to make the DNS records to connect between the server and the domain.
  - Remember to open ports 80 and 443 on the server.

## Configuration
- Let's suppose your domain name is **bar.com**
- [Path-based Routing](https://github.com/nginx-proxy/nginx-proxy#path-based-routing) `VIRTUAL_PATH=/api/v2/service`
- [Multiple Hosts](https://github.com/nginx-proxy/nginx-proxy#multiple-hosts) `VIRTUAL_HOST=foo.bar.com,baz.bar.com,bar.com`
- [Wildcard Hosts](https://github.com/nginx-proxy/nginx-proxy#wildcard-hosts) `VIRTUAL_HOST=*.bar.com`
- [Virtual Ports](https://github.com/nginx-proxy/nginx-proxy#virtual-ports) `VIRTUAL_PORT=3000`
- [Default Host](https://github.com/nginx-proxy/nginx-proxy#default-host) `DEFAULT_HOST=www.bar.com`
- [Custom nginX Configuration](https://github.com/nginx-proxy/nginx-proxy#custom-nginx-configuration)
  - [Global/Proxy Wide](https://github.com/nginx-proxy/nginx-proxy#proxy-wide) `/conf.d/example.conf`
  - [Per VIRTUAL_HOST proxy wide](https://github.com/nginx-proxy/nginx-proxy#per-virtual_host) `/vhost.d/bar.com`
  - [Per VIRTUAL_HOST default](https://github.com/nginx-proxy/nginx-proxy#per-virtual_host-default-configuration) `/vhost.d/default`
  - [Per VIRTUAL_HOST location](https://github.com/nginx-proxy/nginx-proxy#per-virtual_host-location-configuration) `/vhost.d/bar.com_location`
  - [Per VIRTUAL_HOST location default](https://github.com/nginx-proxy/nginx-proxy#per-virtual_host-location-default-configuration) `/vhost.d/default_location`
  - [Per VIRTUAL_PATH location](https://github.com/nginx-proxy/nginx-proxy#per-virtual_path-location-configuration)

## Documentation

### Name & History
Formerly known as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy), renamed to [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy). It all started on 2014 with [this blogspot from Jason Wilder](http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/).

Current Official Repositories:
- [nginx-Proxy](https://github.com/nginx-proxy/nginx-proxy)
- [docker-gen](https://github.com/nginx-proxy/docker-gen)
- [acme-companion](https://github.com/nginx-proxy/acme-companion)

### Updating nginx.tmpl
```bash
curl https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/main/nginx.tmpl > nginx.tmpl
```

### Troubleshooting
```bash
docker-compose exec proxy cat /etc/nginx/conf.d/default.conf
```

## Credits
- [Jason Wilder](https://github.com/jwilder)

## Dependencies
- [Nginx](https://www.nginx.com)
- [LetsEncrypt SSL](http://letsencrypt.org/)
- [Docker](https://docker.com)
- [Docker Compose](https://docs.docker.com/compose)
