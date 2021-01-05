import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

import org.json.simple.*;
import org.json.simple.parser.*;

import com.appdynamics.agent.api.*;


public class Recv {
    private final static String QUEUE_NAME = "notifications";

    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("brewery-orderqueue-rabbitmq");
        factory.setPort(5672);
//        factory.setUsername(System.getenv("username"));
//        factory.setPassword(System.getenv("password"));
        factory.setUsername("guest");
        factory.setPassword("guest");
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        System.out.println("[*] Waiting for messages");
        
        JSONParser parser = new JSONParser();

        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            Transaction transaction = null;
            String data = null;
            String correlation = null;
            
            String message = new String(delivery.getBody(), "UTF-8");
            try
            {
                JSONObject json = (JSONObject) parser.parse(message);
                data = (String) json.get("data");
                correlation = (String) json.get("correlation");
            }
            catch (Exception e)
            {
                System.out.println("Error converting: " + e);
                e.printStackTrace();
            }
            System.out.println(correlation);
            transaction = AppdynamicsAgent.startTransaction("Notification", correlation, EntryTypes.POJO, true);
            System.out.println("[x] Received new message to distribute:");
            System.out.println("-----------------------------------------");
            System.out.println(data);
            System.out.println("-----------------------------------------");
            System.out.println();
            transaction.end();
        };
        channel.basicConsume(QUEUE_NAME, true, deliverCallback, consumerTag -> { });
    }
}