package stx.libjava.examples.chat;

import java.util.*;

import org.jivesoftware.smack.*;
import org.jivesoftware.smack.packet.*;
import org.jivesoftware.smack.filter.*;


public class SimpleClient extends java.lang.Object {
    protected XMPPConnection conn;
    protected ArrayList<Message> messages;
    protected Object messagesNotifier = new Object();

    public void connect(String server, String username, String password) {
        ConnectionConfiguration conf = new ConnectionConfiguration(server);
        conf.setSecurityMode(ConnectionConfiguration.SecurityMode.disabled);
        try {
            if (conn != null) {
                disconnect();
            }
            conn = new XMPPConnection(conf);
            conn.connect(); 
            conn.login(username, password, "chat-smack");
            messages = new ArrayList<Message>();
            conn.addPacketListener(new PacketListener() {
                    public void processPacket(Packet p) {
                        synchronized (messages) {
                            messages.add((Message)p);                            
                            synchronized (messagesNotifier) {
                                messagesNotifier.notifyAll();    
                            }                                                        
                        }
                    }
                },
                new PacketTypeFilter(Message.class));
        } catch (XMPPException e) {
            conn = null;
            messages = null;
            throw new RuntimeException(e);
        }
    }

    public void disconnect() {
        conn.disconnect();
        conn = null;
    }

    public void send(Message msg) {
        conn.sendPacket(msg);
    }

    public Message receive(String from) {
        synchronized (messages) {
            for (Message m : messages) {
                if (m.getFrom().equals(from)) {
                    messages.remove(m);
                    return m;
                }
            }
        }
        return null;
    }

    public void await() {
        synchronized (messagesNotifier) {
            try {
                messagesNotifier.wait();
            }  catch (InterruptedException ie) {

            }
        }
    }
    
    
    public static void main(String[] args) {
        String server = args[0];
        String username = args[1];
        String password = args[2];        
        String to = args[3];
        
        SimpleClient client = new SimpleClient();
        try {
            client.connect(server, username, password);
            Message m = new Message();
            m.setTo(to);
            m.setBody("Ping");
            System.out.println("Ping sent, awaiting pong...");
            client.send(m);
            while ((m = client.receive(to)) == null) {                          
                client.await();
            }            
            System.out.println(m.getBody());
        } finally {
            client.disconnect();
        }                 
    }
}
