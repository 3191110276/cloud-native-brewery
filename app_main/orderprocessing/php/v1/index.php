<?php

# IMPORTS
require_once __DIR__ . '/../vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

require '/../../appdynamics/php-agent/appdynamics-php-agent-linux_x64/appdynamics_api_header.php';


# GET MQ SVC
$mq_svc = file_get_contents('/etc/customization/INITQUEUE_SVC');


# GET REQUEST DATA
$data = file_get_contents('php://input');


# AMQP SERVER CONNECTION
$connection = new AMQPStreamConnection('brewery-orderqueue-rabbitmq-client', 5672, getenv("username"), getenv("password"));


#######################################################
# PRODREQUEST
#######################################################

# START APPD EXIT CALL
$properties = array(
    'HOST' => $mq_svc,
    'PORT' => 5672,
    'EXCHANGE' => 'exchange',
    'ROUTING KEY' => 'prodrequest'
);
$exitcall_fulfil = appdynamics_begin_exit_call(AD_EXIT_RABBITMQ, "ProdRequest", $properties, $exclusive=false);
$corrHeader_fulfil = $exitcall_fulfil->getCorrelationHeader();


# CREATE AND OPEN CHANNEL
$channel = $connection->channel();
$channel->queue_declare('fulfillment', false, false, false, false);


# PUSH AMQP MESSAGE TO CHANNEL
$data1 = json_encode(array(
"data" => "$data",
"correlation" => "$corrHeader_fulfil"
));
$msg = new AMQPMessage($data1);
$channel->basic_publish($msg, '', 'prodrequest');


# AMQP CLOSE CHANNEL
$channel->close();


# END APPD EXIT CALL
appdynamics_end_exit_call($exitcall_fulfil);


#######################################################
# NOTIFICATION
#######################################################

$base_msg = file_get_contents('./msg_template.txt');

$formatted_order = $data;

$finalized_msg = str_replace("ORDERID", $data, $base_msg);
$finalized_msg = str_replace("ORDER", $data, $base_msg);
#TODO: finish string replacement

# START APPD EXIT CALL
$properties = array(
    'HOST' => $mq_svc,
    'PORT' => 5672,
    'EXCHANGE' => 'exchange',
    'ROUTING KEY' => 'notifications'
);
$exitcall_notif = appdynamics_begin_exit_call(AD_EXIT_RABBITMQ, "Notifications", $properties, $exclusive=false);
$corrHeader_notif = $exitcall_notif->getCorrelationHeader();


# CREATE AND OPEN CHANNEL
$channel = $connection->channel();
$channel->queue_declare('notifications', false, false, false, false);


# PUSH AMQP MESSAGE TO CHANNEL
$data2 = json_encode(array(
"data" => "$finalized_msg",
"correlation" => "$corrHeader_notif"
));
$msg = new AMQPMessage($data2);
$channel->basic_publish($msg, '', 'notifications');


# AMQP CLOSE CHANNEL
$channel->close();


# END APPD EXIT CALL
appdynamics_end_exit_call($exitcall_notif);


# AMQP CLOSE CONNECTION
$connection->close();


# SEND RESPONSE FOR REQUEST
$response = array('success' => true);
header('Content-Type: application/json');
echo json_encode($response);
?>