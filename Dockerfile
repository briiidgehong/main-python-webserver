FROM python:3.7

USER root

WORKDIR /app/

COPY ./requirements.txt /app/requirements.txt

RUN pip install -r /app/requirements.txt 

COPY . /app/

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]