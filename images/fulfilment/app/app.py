from flask import Flask, request
import json
import logging
import MySQLdb
import sys
import threading
import time
import requests
import random


logging.basicConfig(stream=sys.stdout, level=logging.INFO)

app = Flask(__name__)


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


def create_tracking_id():
    choices = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    val = 'P'
    for i in range(20):
        rnd = random.randint(0, 35)
        val += str(choices[rnd])
        
    return val


@app.route("/", methods = ['POST'])
def handle_production():
    
    orderid = request.json['orderid']
    prodid = request.json['prodid']
    weight = request.json['weight']
    
    trackingid = create_tracking_id()
        
    conn = MySQLdb.connect(
        host=load_env_file("INVENTORYDB_SVC"),
        port=80,
        user="root",
        passwd="root",
        db="ordering"
    )

    cursor = conn.cursor()
    cursor.execute("""INSERT INTO fulfilment (order_id, tracking_id) VALUES (%s,%s)""",(orderid,trackingid))
    cursor.close()
    conn.close()
    
    
    return {
        "status": "success",
        "trackingid": trackingid
    }


@app.route("/healthz")
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0')