FROM python:3.8

WORKDIR /code

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 80

RUN chmod 744 ./startup.sh

ENTRYPOINT ["./startup.sh"]

#ENTRYPOINT ["pyagent", "run", "-c", "appd_config", "--", "gunicorn", "--config", "gunicorn_config.py", "app.wsgi:app"]