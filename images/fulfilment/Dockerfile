FROM python:3.8-slim

WORKDIR /code

COPY . .

RUN apt-get install -y libmysqlclient-dev

RUN pip install -r requirements.txt

EXPOSE 80

RUN chmod 744 ./startup.sh

ENTRYPOINT ["./startup.sh"]
