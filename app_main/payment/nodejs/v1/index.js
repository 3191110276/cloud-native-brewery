const appd = require('appdynamics');
appd.profile({
  controllerHostName: process.env.CONTROLLER_HOST,
  controllerPort: process.env.CONTROLLER_PORT,
  controllerSslEnabled: process.env.CONTROLLER_SSL,
  accountName: process.env.ACCOUNT_NAME,
  accountAccessKey: process.env.ACCESS_KEY,
  appName: process.env.APPD_APP_NAME,
  tierName: process.env.APPD_TIER_NAME,
  nodeName: process.env.HOSTNAME,
  proxyHost: process.env.PROXY_HOST,
  proxyPort: process.env.PROXY_PORT
});


const http = require('http');
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');

// Constants
const PORT = 80;
const HOST = '0.0.0.0';

// App
const app = express();

app.use(bodyParser.json());
app.use(express.json());

app.post('/', (req, res) => {
    console.log('Received request for payment')
    var data = JSON.stringify({
        amount: req.body.payment
    })
    
    var svc = fs.readFileSync('/etc/customization/EXTPAYMENT_SVC', 'utf8');
    console.log(svc)
    
    const options = {
        hostname: fs.readFileSync('/etc/customization/EXTPAYMENT_SVC', 'utf8'),
        port: 80,
        path: '/',
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    }
    
    response = {
        'status': 'success',
        'id': 1
    }
    res.json(response);
    
//    const pay_req = http.request(options, pay_res => {
//        rcvd = ''
//
//        pay_res.on('data', function (chunk) {
//            rcvd += chunk;
//        });
//
//        pay_res.on('end', function () {
//            rcvd_json = JSON.parse(rcvd);
//
//            response = {
//                'status': 'success',
//                'id': rcvd_json['id']
//            }
//            
//            console.log('Finishing payment request')
//
//            res.json(response);
//        });
//    })
//
//    pay_req.on('error', error => {
//      console.log('Encountered error')
//      console.error(error)
//    })
//
//    pay_req.write(data)
//    pay_req.end()    
});

app.get('/healthz', (req, res) => {
  res.send('ok');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

