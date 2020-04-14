This is a docker image that pulls the official docker images for nextcloud, then adds plugins on top of it, then makes the plugin directory read only so it can't be updated from the website.

# Usage #

## Building the image ##

1. Update your conf.yaml (Optional)
2. make generate
3. make build REGISTRY=yourname
4. make push REGISTRY=yourname # (Optional)

## Running ##

1. You'll either need to build the image or pull `halkeye/nextcloud`.
2. Run it `docker run -d -m 1g -p 127.0.0.1:9000:80 --name="nextcloud" -v /var/nextcloud/data:/var/www/nextcloud/data -v /var/nextcloud/config:/var/www/nextcloud/config halkeye/nextcloud`
3. Setup a reverse proxy to it

```
server {
	     listen 80;
	     server_name nextcloud.example.com;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name nextcloud.example.com;
	ssl on;
        ssl_certificate /etc/ssl/private/example_com.cert;
        ssl_certificate_key /etc/ssl/private/example_com.key;
        location / {
		proxy_pass http://127.0.0.1:9000;
		proxy_redirect off;
		proxy_buffering off;
		proxy_set_header 	Host	$host;
		proxy_set_header 	X-Real-IP	$remote_addr;
		proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
	}
}```
