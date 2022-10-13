# INDEX 
> 1. [WEB SERVER](#1-web-server)
> 2. [요청에따른 웹서버(NGINX)의 처리방식](#2-요청에따른-웹서버nginx의-처리방식)
> 3. [NGINX CGI(FCGI) ASGI WSGI](#3-nginx-cgifcgi-asgi-wsgi)
>> 3-1. [NGINX - FastCGI - PYTHON](#3-1-nginx---fastcgi---python) <br/>
>> 3-2. [NGINX - GUNICORN(WSGI) - DJANGO](#3-2-nginx---gunicornwsgi---django) <br/>
>> 3-3. [NGINX - UVICORN(ASGI) - FASTAPI](#3-3-nginx---uvicornasgi---fastapi) <br/>
>> 3-4. [WAS + JAVA 진영과의 비교](#3-4-was--java-진영과의-비교)
> 4. [환경 구성](#4-환경-구성)
>> 4-1. [EC2 + FASTAPI](#4-1-ec2--fastapi)
>> 4-2. [ELASTIC BEANSTALK + DOCKER(FASTAPI)](#4-2-elastic-beanstalk--dockerfastapi)
>> 4-3. [ECS + FARGATE + DOCKER(FASTAPI) + CODEPIPELINE](#4-3-ecs--fargate--dockerfastapi--codepipeline)


## 1. WEB SERVER
<img width="768" alt="스크린샷 2022-10-09 오후 3 07 53" src="https://user-images.githubusercontent.com/73451727/194741222-22f25b8d-e14d-47ad-8ccf-28249c7e2b39.png">
- client의 request = "나는 index.html 파일을 원합니다." <br/>
- server의 webserver에서 요청을 받아 index.html file을 꺼내서 response 한다.

### WEB SERVER의 종류에는 apache / iis / nginx 등이 있다.
#### - NGINX
docker pull nginx <br/>
docker images <br/>
docker run --name nginx-test -d -p 8080:80 nginx:latest <br/>
0.0.0.0:8080 <br/>
<img width="586" alt="스크린샷 2022-10-09 오후 3 35 56" src="https://user-images.githubusercontent.com/73451727/194741836-11c04eb3-99b0-42ba-a787-e58357d63705.png">

docker ps <br/>
docker exec -it e4a3bd1342e5 /bin/bash <br/>
find / -name "*.conf*" # root 및 그 하위 directory에서 검색 <br/>
/etc/nginx/conf.d/default.conf <br/>

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

## 2. 요청에따른 웹서버(NGINX)의 처리방식
#### 정적콘텐츠 요청 -> NGINX -> 정적콘텐츠 반환
#### 동적콘텐츠 요청 -> NGINX -> CGI -> python application -> CGI -> NGINX -> 동적콘텐츠 반환
<img width="619" alt="스크린샷 2022-10-11 오후 2 41 52" src="https://user-images.githubusercontent.com/73451727/195006011-73503b40-a971-4dbd-aed1-3e23ece85919.png">
<img width="828" alt="스크린샷 2022-10-11 오후 2 37 10" src="https://user-images.githubusercontent.com/73451727/195006060-c0e30efc-6421-41e0-b126-1fcbc83c5d7d.png">


## 3. NGINX CGI(FCGI) ASGI WSGI
rf) https://show-me-the-money.tistory.com/entry/CGI%EC%99%80-WSGI%EC%9D%84-%ED%8C%8C%ED%97%A4%EC%B9%98%EB%8B%A4 <br/>
rf) https://velog.io/@ryu_log/CGI-WSGI-ASGI <br/>
rf) https://jellybeanz.medium.com/cgi-wsgi-asgi-%EB%9E%80-cgi-wsgi-asgi-bc0ba75fa5cd <br/>

#### - CGI (Common Gateway Interface)
- CGI는 Common Gateway Interface의 약자로 웹서버와 외부 프로그램을 연결해주는 표준화된 프로토콜이다. 웹이 처음 등장했을 때는 HTML과 이미지를 전달해주는 웹서버밖에 없었다. 하지만 웹에 대한 수요가 증가함에 따라서 정적인 HTML만을 가지고 정보를 제공하는 것에 한계가 생겼고, 이를 극복하기 위해서 등장한 기술이 CGI다. 웹서버로 요청이 들어왔을 때 그것이 웹서버가 처리할 수 없는 정보일 때 그 정보를 처리할 수 있는 외부 프로그램을 호출해서 외부 프로그램이 처리한 결과를 웹서버가 받아서 브라우저로 전송하는 것이다.
즉, 웹서버에서 처리할수 없는 요청을 python application에게 요청하고 받아오는 중간의 인터페이스가 CGI(=웹서버와 python을 연결시켜주는 인터페이스)
<img width="887" alt="스크린샷 2022-10-12 오후 2 40 57" src="https://user-images.githubusercontent.com/73451727/195259399-05a77f6b-77c7-4c63-b69f-6259881af7a4.png">

#### - FastCGI
<img width="922" alt="스크린샷 2022-10-12 오후 2 41 07" src="https://user-images.githubusercontent.com/73451727/195259408-f839662c-28d8-4377-84e6-17116e536c6c.png">

#### - WSGI (Web Server Gateway Interface)
<img width="691" alt="스크린샷 2022-10-12 오후 12 09 45" src="https://user-images.githubusercontent.com/73451727/195241024-231f39c9-23ad-4024-b87b-baed19495664.png">

#### - ASGI (Asynchronous Server Gateway Interface)
<img width="744" alt="스크린샷 2022-10-12 오후 12 09 54" src="https://user-images.githubusercontent.com/73451727/195241036-9828143e-05f0-483c-bd9f-bbca20fd2433.png">
<img width="1197" alt="스크린샷 2022-10-12 오후 5 32 41" src="https://user-images.githubusercontent.com/73451727/195292816-c9c0fa80-a291-4dc9-99a0-0878dda774cf.png">
rf) https://breezymind.com/start-asgi-framework/


##### CGI vs FastCGI
- CGI vs FastCGI
CGI는 요청이 있을때마다 프로세스를 새로 띄워 요청을 처리하고 죽는다. FastCGI는 요청을 처리하는 프로세스들을 미리 띄워놓고 요청이 있을때마다 프로세스에게 할당한다. CGI와는 달리 이 프로세스는 웹서버가 아닌 Fast CGI서버가 관리

##### WSGI vs ASGI
WSGI는 비동기처리 불가, ASGI는 비동기 처리 가능하다. 그러나 ASGI 를 쓰면서 DB 처리 또한 비동기화 되어야 성능을 비약적으로 올릴수 있다.


### 3-1. NGINX - FastCGI - PYTHON
rf) https://techexpert.tips/nginx/python-cgi-nginx/ <br/>
rf) https://www.youtube.com/watch?v=FQ0lOhIKfOI&t=29s <br/>

```
# on ubuntu server

# dependency install
apt-get update
apt-get upgrade

apt-get install nginx fcgiwrap python3 python3-pip vim
service  --status-all

# /cgi-bin/ 경로로 들어올때 nginx에서 fast cgi 사용해서 처리하도록 세팅
cp /usr/share/doc/fcgiwrap/examples/nginx.conf /etc/nginx/fcgiwrap.conf
location /cgi-bin/ {
  gzip off;
  root  /usr/lib;
  fastcgi_pass  unix:/var/run/fcgiwrap.socket;
  include /etc/nginx/fastcgi_params;
  fastcgi_param SCRIPT_FILENAME  /usr/lib$fastcgi_script_name;
}

vi /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
include fcgiwrap.conf;
}

service nginx restart

# test.py 스크립트 작성
mkdir /usr/lib/cgi-bin -p
cd /usr/lib/cgi-bin 

type python3
vi test.py
#!/usr/bin/python3
from art import *
Art=text2art("TEST",font='block',chr_ignore=True)
print('Content-Type: text/plain')
print('')
print('This is my test!')
print(Art)

chmod 777 (-R) test.py
```

http://35.78.124.62/cgi-bin/test.py <br/>
<img width="655" alt="스크린샷 2022-10-12 오전 10 50 19" src="https://user-images.githubusercontent.com/73451727/195230349-4167fb2d-c6f2-4879-bfae-8994d8e8f70e.png"> <br/>

### 3-2. NGINX - GUNICORN(WSGI) - DJANGO
rf) https://soyoung-new-challenge.tistory.com/62

#### - 요약 (80: nginx / 8000: gunicorn)
```
server {
    listen 80;
    server_name 13.230.6.223;

    charset utf-8;

    location / {
        include proxy_params;
        proxy_pass http://13.230.6.223:8000;

    }
```

```
# install conda
wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh -> enter / yes
source ~/.bashrc
conda --version

conda create --name "django-gunicorn-env" python=3.5.6
conda env list
conda activate django-gunicorn-env

pip install upgrade pip
pip install django djangorestframework

django-admin startproject rest_api_project
python manage.py runserver 0.0.0.0:8000

setting.py
DEBUG = True
ALLOWED_HOSTS = ['*']

# install gunicorn
pip install gunicorn
gunicorn --bind 0.0.0.0:8000 rest_api_project.wsgi:application
13.230.6.223:8000

# gunicorn into daemon
sudo vi /etc/systemd/system/gunicorn.service

[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=/home/ubuntu/RESTproject
ExecStart=/home/ubuntu/anaconda3/envs/django-env/bin/gunicorn --bind 0.0.0.0:8000 RESTproject.wsgi:application

[Install]
WantedBy=multi-user.target

sudo systemctl start gunicorn
sudo systemctl enable gunicorn
sudo systemctl status gunicorn.service

# install nginx
sudo apt-get update
sudo apt-get install nginx

service nginx start
service nginx status

sudo vi /etc/nignx/sites-enabled/rest_api_project

server {
    listen 80;
    server_name 13.230.6.223;

    charset utf-8;

    location / {
        include proxy_params;
        proxy_pass http://13.230.6.223:8000;

    }
    
service nginx restart
13.230.6.223:80 -> 성공 !
```

### 3-3. NGINX - UVICORN(ASGI) - FASTAPI
rf) https://soyoung-new-challenge.tistory.com/81?category=890342 <br/>

```
pip install fastapi uvicorn
main.py

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
	return { "message" : "Hello World" }

uvicorn main:app --reload --host=0.0.0.0 --port=8888

sudo vi /etc/nignx/sites-enabled/rest_api_project

server {
    listen 80;
    server_name 13.230.6.223;

    charset utf-8;

    location / {
        include proxy_params;
        proxy_pass http://13.230.6.223:8000;

    }
    
service nginx restart
13.230.6.223:80 -> 성공 !
```

### 3-4. WAS + JAVA 진영과의 비교
WAS (Web Application Server)
웹서버가 동적으로 기능하면 WAS이다. 즉, Web Server + CGI가 WAS이다.

<img width="829" alt="스크린샷 2022-10-12 오후 5 36 52" src="https://user-images.githubusercontent.com/73451727/195293782-1d2a3144-3bb3-4a37-abcf-b9e576a82cad.png">

## 4. 환경 구성
### 4-1. EC2 + FASTAPI

### 4-2. ELASTIC BEANSTALK + DOCKER(FASTAPI)

### 4-3. ECS + FARGATE + DOCKER(FASTAPI) + CODEPIPELINE

