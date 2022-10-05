FROM python:3.7

USER root

WORKDIR /app/


COPY requirements.txt /app/
RUN pip install -r requirements.txt 
COPY . /app/


CMD uvicorn --host=0.0.0.0 --port 8000 main:app