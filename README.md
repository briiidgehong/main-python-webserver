## test1
```
docker build -t "fast_api_test1" .
docker run -d -p 8080:8080 <image_name>
```

## WEB SERVER
<img width="768" alt="스크린샷 2022-10-09 오후 3 07 53" src="https://user-images.githubusercontent.com/73451727/194741222-22f25b8d-e14d-47ad-8ccf-28249c7e2b39.png">
- client의 request = "나는 index.html 파일을 원합니다." <br/>
- server의 webserver에서 요청을 받아 index.html file을 꺼내서 response 한다.

### WEB SERVER의 종류에는 apache / iis / nginx 등이 있다.
docker pull nginx
docker images
docker run --name nginx-test -d -p 8080:80 nginx:latest
0.0.0.0:8080
<img width="586" alt="스크린샷 2022-10-09 오후 3 35 56" src="https://user-images.githubusercontent.com/73451727/194741836-11c04eb3-99b0-42ba-a787-e58357d63705.png">

docker ps
docker exec -it e4a3bd1342e5 /bin/bash
/etc/nginx/conf.d/default.conf

```
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

apt-get update
apt-get insatll vim
apt-get python3
python3 --version

vi helloworld.py 
```
a = 3 + 4 + 5
b = a / 3
print(b)
```

./helloworld.py -> err: 실행권한없음
chmod 777 helloworld.py

./helloworld.py -> err: 어떤프로그램으로 실행시켜야하는지 모름
type python3 -> /usr/bin/python3
```
!#/usr/bin/python3
a = 3 + 4 + 5
b = a / 3
print(b)
```
./helloworld.py -> 성공 !



## CGI WSGI ASGI 
CGI (common gateway interface): 웹서버와 python을 연결시켜주는 인터페이스

apache webserver


## 1. EC2 + DOCKER
https://intrepidgeeks.com/tutorial/how-to-use-docker-to-deploy-fastapi-applications-in-aws

## 2. ELASTIC BEANSTALK + DOCKER

  ### 2-1. EB + DOCKER
  ### 2-2. EB + DOCKER

## 3. ECR + FARGATE + DOCKER + CODEPIPELINE

