package stx.libjava.tests.lib.java.net;

import static org.junit.Assert.*;

import java.net.InetAddress;
import java.net.UnknownHostException;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class InetAddressTests {

    @Test
    public void test() {
        try {
            InetAddress addr = InetAddress.getLocalHost();
            addr.getAddress();
        } catch (UnknownHostException e) {
            // TODO Auto-generated catch block
            assertTrue(false);
        }
        
    }

}
