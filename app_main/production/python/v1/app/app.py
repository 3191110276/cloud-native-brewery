from flask import Flask, request
import json
import logging
import MySQLdb
import sys
import requests

logging.basicConfig(stream=sys.stdout, level=logging.INFO)

app = Flask(__name__)


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


@app.route("/request", methods = ['POST'])
def handle_request():
    logging.info('New order received')
    
    logging.warning(request.headers)
    
    req_json = request.get_json(force=True)
    logging.warning(req_json)
    
    r = requests.post('http://{}'.format(load_env_file("EXTPROD_SVC")), json = {
        'orderid': req_json['orderid'],
        'products': req_json['products']
    })
    
    logging.warning('decoding json')
    
    logging.warning(r.text)
    
    import time
    time.sleep(1)
    
    return json.dumps({'status': 'success'})


#@app.route("/production", methods = ['POST'])
#def handle_production():
#    logging.info('Input received from production')
#    
#    orderid = request.json['orderid']
#    prodid = request.json['prodid']
#    weight = request.json['weight']
#
#    
#    # WRITE NEW PRODUCTS TO DB AND CALL FULFILMENT
#    conn = MySQLdb.connect(
#        host=load_env_file("INVENTORYDB_SVC"),
#        port=80,
#        user="root",
#        passwd="root",
#        db="ordering"
#    )
#    
#    try:
#        cursor = conn.cursor()
#        cursor.execute("""INSERT INTO production (id,order_id,weight) VALUES (%s,%s,%s)""",(prodid,orderid,weight))
#        cursor.close()
#        conn.close()
#    except Exception as e:
#        logging.error('DB Error')
#        logging.error(e)
#        
#    r = requests.post('http://{}/'.format(load_env_file("FULFILMENT_SVC")), json = {
#        'orderid': orderid,
#        'prodid': prodid,
#        'weight': weight
#    })
#        
#    return json.dumps({'status': 'success'})
    

@app.route("/healthz")
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0')