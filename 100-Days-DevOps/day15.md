### Task Description

The system admins team of xFusionCorp Industries needs to deploy a new application on App Server 3 in Stratos Datacenter. They have some pre-requites to get ready that server for application deployment. Prepare the server as per requirements shared below:



1. Install and configure nginx on App Server 3.


2. On App Server 3 there is a self signed SSL certificate and key present at location /tmp/nautilus.crt and /tmp/nautilus.key. Move them to some appropriate location and deploy the same in Nginx.


3. Create an index.html file with content Welcome! under Nginx document root.


4. For final testing try to access the App Server 3 link (either hostname or IP) from jump host using curl command. 

<hr>

### Task Solution

- First thing I did was ssh into stapp03 server. 

```
ssh tony@stapp03
```

- Then I installed nginx using yum command

```
sudo yum install nginx -y
```

- Before starting the nginx server, I first made necessary configurations. 

```
# Creating directory for SSL certificate and key in nginx directory

sudo mkdir -p /etc/nginx/ssl

# Moving SSL certificate and key to nginx directory
mv /tmp/nautilus.crt /etc/nginx/ssl
mv /tmp/nautilus.crt /etc/nginx/ssl

# Creating index.html file with content Welcome! under Nginx document root
echo "Welcome!" > /usr/share/nginx/html/index.html

# Creating config file for nginx under conf.d directory
 
 sudo vi /etc/nginx/conf.d/ssl.conf

# After making changes in the config file I check that the syntax is correct

sudo nginx -t

# Enable nginx service

sudo systemctl enable nginx

# Start nginx service

sudo systemctl start nginx

# Check the status of nginx servic

sudo systemctl status nginx

# Check that its listening on port 443

sudo ss -tulnp | grep :443


```

- Now that everything is working I proceeded with the curl test using https which was succesful.

```
thor@jumphost ~$ curl -Ik https://stapp03
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Sat, 18 Oct 2025 21:22:27 GMT
Content-Type: text/html
Content-Length: 9
Last-Modified: Sat, 18 Oct 2025 21:19:28 GMT
Connection: keep-alive
ETag: "68f40460-9"
Accept-Ranges: bytes

```

<details><summary>NGINX Config</summary>

```
server {
    listen 80;
    server_name stapp03;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name stapp03;

    ssl_certificate     /etc/nginx/ssl/nautilus.crt;
    ssl_certificate_key /etc/nginx/ssl/nautilus.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}


```

</details>