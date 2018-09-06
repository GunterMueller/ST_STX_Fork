package stx.libjava.examples;

import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.io.IOException;
import java.io.Reader;
import java.io.InputStreamReader;
import java.io.Writer;
import java.io.OutputStreamWriter;


import stx.libjava.annotation.Package;

@Package("stx:libjava/examples")
public class Echo extends java.lang.Object {
    public static int DEFAULT_PORT = 30001;

    public static Server newServer() {
        return new Server();
    }

    public static Server newServer(int port) {
        return new Server(port);
    }


    public static class Server {

        protected int port;
        protected boolean shuttingdown = false;
        protected ServerSocket socket;
        protected Thread worker;

        public Server() {
            this(DEFAULT_PORT);
        }

        public Server(int port) {
            this.port = port;
        }

        public void start() throws IOException {            
            socket = new ServerSocket(port);
            worker = new Thread(new Runnable() {
               public void run() {
                    try {
                        shuttingdown = false;
                        while ( ! shuttingdown ) {                                            
                            Socket client = socket.accept();
                            try {
                                Reader reader = new InputStreamReader(client.getInputStream());
                                Writer writer = new OutputStreamWriter(client.getOutputStream());                    
                                int c;
                                do {                            
                                    StringBuffer buffer = new StringBuffer();
                                    while ( ( ( c = reader.read() ) != -1 ) && (c != '\n') && (c != '\r') ) {
                                        buffer.append((char)c);
                                    }
                                    buffer.append('\n');
                                    writer.write(buffer.toString());
                                    writer.flush();
                                } while ( c != -1 );
                                //reader.close();
                                //writer.close();
                            } catch ( IOException ioe) {
                                System.err.println("Error handling client: " + ioe.getMessage());
                                ioe.printStackTrace();
                            } finally {
                                client.close();
                            }
                        }
                    } catch ( SocketException se ) {
                        if ( ! ( shuttingdown && socket.isClosed()) ) {
                            System.err.println("Error listening for a connection: " + se.getMessage());
                            se.printStackTrace();
                        }
                    } catch (IOException ioe) {
                        System.err.println("Error listening for a connection: " + ioe.getMessage());
                        ioe.printStackTrace();
                    } finally {
                        socket = null;
                        worker = null;
                        shuttingdown = false;
                    }
               }
            });
            worker.start();
        }

        public void shutdown() {
            if (  socket != null && ! socket.isClosed() ) {
                shuttingdown = true;
                try {
                    socket.close();
                } catch ( IOException ioe ) {
                    System.err.println("Error closing server socket:" + ioe.getMessage());
                    ioe.printStackTrace();   
                }

            }
        }

    }

    public static Client newClient() {
        return new Client();
    }

    public static class Client {
        protected Socket socket;

        public void connect(String host) throws IOException {
            connect(host, DEFAULT_PORT);
        }

        public void connect(String host, int port) throws IOException {
            socket = new Socket(host, port);
        }

        public void disconnect() {
            if ( socket != null) {
                try {
                    socket.close();
                } catch ( IOException ioe) {
                    System.err.println("Error disconnecting:" + ioe.getMessage());
                    ioe.printStackTrace();   
                }
            }
        }

        public String echo(String echo) throws IOException  {
            Reader reader = new InputStreamReader(socket.getInputStream());
            Writer writer = new OutputStreamWriter(socket.getOutputStream());       
            writer.write(echo);
            writer.write('\n');
            writer.flush();
            int c;
            StringBuffer buffer = new StringBuffer();
            while ( ( ( c = reader.read() ) != -1 ) && (c != '\n') && (c != '\r') ) {
                buffer.append((char)c);
            }
            return buffer.toString();            
        }
    }

}
