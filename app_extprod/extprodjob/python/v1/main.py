import requests
import random
import time
import os
import logging
import json


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


url = 'http://{}/production'.format(load_env_file("PRODUCTION_SVC"))

data = {
    'orderid': os.getenv('ORDERID'),
    'prodid': os.getenv('PRODID'),
    'weight': os.getenv('WEIGHT')
}

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
        logging.error(e.message)
        time.sleep(60)