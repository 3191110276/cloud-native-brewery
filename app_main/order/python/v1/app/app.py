from flask import Flask, request
import json
import requests
import logging
import sys
import MySQLdb

app = Flask(__name__)

logging.basicConfig(stream=sys.stdout, level=logging.INFO)


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


@app.route("/order", methods = ['POST'])
def handle_order():
    logging.info('Received request')
    logging.info(request.form)
    
    # SAVE ORDER TO ORDERS DB
    logging.info('Saving Order')
    conn = MySQLdb.connect(
        host=load_env_file("INVENTORYDB_SVC"),
        port=80,
        user="root",
        passwd="root",
        db="ordering"
    )
    
    cursor = conn.cursor()
    
    cursor.execute("""INSERT INTO orders (customer) VALUES ('undefined')""")
    orderid = cursor.lastrowid
    
    cursor.execute("""INSERT INTO order_prod (details,quantity,order_id) VALUES (%s,%s,%s)""",(request.form['product'],request.form['quantity'],orderid))
    
    conn.commit()
    
    
    # PROCESS PAYMENT
    logging.info('Sending to Payment')
    to_pay = int(request.form['quantity'])*2
    r = requests.post(
        'http://{}/'.format(load_env_file("PAYMENT_SVC")),
        json = {'payment':to_pay}
    )
    
    logging.info('Received Response from Payment')
#    payment = r.json()
    payment = {
         'id': 1
    }
    logging.info(payment)
#    
    logging.info('Saving payment to database')
    cursor.execute("""INSERT INTO payment (provider_id,paytype,order_id) VALUES (%s,%s,%s)""",(payment['id'],'creditcard',orderid))
    
    
    # CLOSE CONNECTION
    conn.commit()
    
    cursor.close()
    conn.close()
    
    
    # INITIATE ORDER PROCESSING
    logging.info('Sending to OrderProcessing')
    r = requests.post(
        'http://{}/orderprocessing'.format(load_env_file("ORDERPROCESSING_SVC")),
        json = {
            'orderid':orderid,
            'products': [{
                    'configuration': request.form['product'],
                    'amount': request.form['quantity']
                }]
    })

    
    # SEND REPLY
    logging.info('Closing Order request - sending reply')
    reply = {
        'id': orderid,
        'status': 'success'
    }
    
    return json.dumps(reply)


@app.route("/healthz")
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0')