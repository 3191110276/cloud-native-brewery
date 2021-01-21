from flask import Flask, request
from kubernetes import client, config, utils
import json
import random
import logging
from jinja2 import Environment, FileSystemLoader, select_autoescape
import os
import json
import time

app = Flask(__name__)


env = Environment(
    loader=FileSystemLoader(searchpath='./templates')
)
job_template = env.get_template('job.yaml')


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


def create_random_prod():
    choices = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    val = 'P'
    for i in range(6):
        rnd = random.randint(0, 35)
        val += str(choices[rnd])
        
    return val


@app.route("/", methods = ['POST'])
def handle_order():
    orderid = request.json['orderid']
    weight = int(request.json['products'][0]['amount'])*700
    prodid = create_random_prod()
    
    logging.warning('Received Order with ID {}'.format(orderid))
    
    f = open("job_{}.yaml".format(prodid), "a")
    f.write(
        job_template.render(
            prodid=prodid.lower(),
            registry="mimaurer",
            version="dev",
            orderid=orderid,
            weight=weight
        )
    )
 
    f.close()
    
    ns = load_env_file("NAMESPACE")

    config.load_incluster_config()
    k8s_client = client.ApiClient()
    
    utils.create_from_yaml(k8s_client, './job_{}.yaml'.format(prodid), namespace=ns)
    
    os.remove('./job_{}.yaml'.format(prodid))
    
    
    # SEND REPLY
    reply = {
        'orderid': orderid,
        'prodid': prodid,
        'status': 'success'
    }
    
    time.sleep(random.randint(
        int(load_env_file("MIN_RANDOM")),
        int(load_env_file("MAX_RANDOM"))
    )/1000)
    
    return json.dumps(reply)


@app.route("/healthz")
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0')