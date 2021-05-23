FROM python:3.8

WORKDIR /code

COPY . .

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN chmod +x ./kubectl

RUN mv ./kubectl /usr/local/bin/kubectl

RUN pip install -r requirements.txt

RUN chmod 744 ./startup.sh

EXPOSE 80

ENTRYPOINT ["./startup.sh"]
