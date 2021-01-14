import requests
import random
import time
import os
import logging
import json
from kubernetes import client, config, utils


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


url = 'http://{}/production'.format(load_env_file("PRODUCTION_SVC"))

data = {
    'orderid': os.getenv('ORDERID'),
    'prodid': os.getenv('PRODID'),
    'weight': os.getenv('WEIGHT')
}


ns = load_env_file("NAMESPACE")
config.load_incluster_config()


api_instance = client.BatchV1Api()
api_response = api_instance.list_namespaced_job(ns)
for item in api_response.items:
    if item.status.succeeded == 1:
        logging.warning('Deleting succeeded Job {}'.format(item.metadata.name))
        try:
            api_instance.delete_namespaced_job(item.metadata.name, ns)
        except Exception as e:
            logging.warning(e)

api_instance = client.CoreV1Api()
api_response = api_instance.list_namespaced_pod(ns)
for item in api_response.items:
    logging.warning(item.metadata)
    logging.warning(item.status.phase)
    if item.status.phase == "Succeeded" or item.status.phase == "Error":
        logging.warning('Deleting Pod {}'.format(item.metadata.name))
        try:
            api_instance.delete_namespaced_pod(item.metadata.name, ns)
        except Exception as e:
            logging.warning(e)


time.sleep(random.randint(int(load_env_file("JOB_MIN")), int(load_env_file("JOB_MAX"))))

logging.info('Starting contact to system')

request_success = False
while request_success == False:
    try:
        logging.warning('Trying to contact system')
        r = requests.post(url=url, json=data)
        request_success = True
        break
    except Exception as e:
        logging.warning('Contact failed, repeating in one minute')
        logging.error(e)
        time.sleep(60)