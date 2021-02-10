FROM python:3.8

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN chmod +x ./kubectl

RUN mv ./kubectl /usr/local/bin/kubectl

WORKDIR /code

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 80

RUN chmod 744 ./startup.sh

ENTRYPOINT ["./startup.sh"]