FROM python:3.8

WORKDIR /code

COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc \
    && apt-get install -y default-libmysqlclient-dev \
    && pip install -r requirements.txt \
    && apt-get purge -y --auto-remove gcc

EXPOSE 80

RUN chmod 744 ./startup.sh

ENTRYPOINT ["./startup.sh"]
