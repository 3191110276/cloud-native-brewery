from flask import Flask
import json
import random
import time
import logging

app = Flask(__name__)

logging.basicConfig(stream=sys.stdout, level=logging.INFO)


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


def create_random_payment():
    choices = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    val = ''
    for i in range(12):
        rnd = random.randint(0, 35)
        val += str(choices[rnd])
        
    return val

@app.route("/", methods = ['POST'])
def payment():
    logging.info('Payment request received')
    
    payment = {
        'id': create_random_payment(),
        'status': 'success'
    }
    
    processing_time = random.randint(
        int(load_env_file("MIN_RANDOM_DELAY")),
        int(load_env_file("MAX_RANDOM_DELAY"))
    )
    
    if random.randint(1, 1000) == float(load_env_file("LAGSPIKE_PERCENTAGE"))*100:
        processing_time += 1500
        
    logging.info('Processing time set to {}'.format(processing_time))
    
    time.sleep(processing_time/1000)
    
    logging.info('Replying to payment request')
    
    return json.dumps(payment)


@app.route("/healthz")
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0')