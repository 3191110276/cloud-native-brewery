import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

import org.json.simple.*;
import org.json.simple.parser.*;

import HTTPClient.*;

import com.appdynamics.agent.api.*;

public class Recv {

    private final static String QUEUE_NAME = "prodrequest";

    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("brewery-orderqueue-rabbitmq-client");
        factory.setPort(5672);
        factory.setUsername(System.getenv("username"));
        factory.setPassword(System.getenv("password"));
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        System.out.println(" [*] Waiting for messages");
        
        JSONParser parser = new JSONParser();

        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            Transaction transaction = null;
            String data = null;
            String correlation = null;
            
            String message = new String(delivery.getBody(), "UTF-8");
            try
            {
                JSONObject json = (JSONObject) parser.parse(message);
                correlation = (String) json.get("correlation");
                
                System.out.println(correlation);
                transaction = AppdynamicsAgent.startTransaction("ProdRequest", correlation, EntryTypes.POJO, true);
                
                data = (String) json.get("data");
                System.out.println(" [x] Received '" + data + "'");
                
                HTTPConnection con = new HTTPConnection(System.getenv("PRODUCTION_SVC"));
                HTTPResponse   rsp = con.Post("/request", data);
                if (rsp.getStatusCode() >= 300)
                {
                    System.err.println("Received Error: "+rsp.getReasonLine());
                    System.err.println(rsp.getText());
                }
                else
                    System.out.println("Sent order to production");
            }
            catch (Exception e)
            {
                System.out.println("Error converting: " + e);
                e.printStackTrace();
            }
            
            transaction.end();
        };
        channel.basicConsume(QUEUE_NAME, true, deliverCallback, consumerTag -> { });
    }
}