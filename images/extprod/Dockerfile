FROM python:3.8-slim

WORKDIR /code

COPY . .

RUN apt-get update \
    && apt-get install curl \
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && pip install -r requirements.txt \
    && chmod 744 ./startup.sh

EXPOSE 80

ENTRYPOINT ["./startup.sh"]
