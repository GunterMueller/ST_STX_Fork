package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

/*
 * Test for B/I/L signed/unsigned SHift Left/Right
 */
@stx.libjava.annotation.Package("stx:libjava/tests")
public class XSHX {

	private final byte[] cafebabe = { (byte) 0xCA, (byte) 0xFE, (byte) 0xBA, (byte) 0xBE, (byte) 0xCA, (byte) 0xFE, (byte) 0xBA, (byte) 0xBE };
	
	@Test
	public void testShiftingLong() {
		byte[] buffer = new byte[8];		
		long v = readLong(cafebabe);
		
		writeLong(v, buffer);
        
        for (int i = 0; i < cafebabe.length; i++) {
        	assertTrue(cafebabe[i] == buffer[i]);
        }
	}
	
	@Test	
	public void test_IUSHR_01() {
	    int ival = 1234567890;
	    byte[] bval = new byte[4];
	    
	    bval[0] = (byte) ((ival >>> 24) & 0xFF);
	    bval[1] = (byte) ((ival >>> 16) & 0xFF);
        bval[2] = (byte) ((ival >>> 8) & 0xFF);
        bval[3] = (byte) (ival & 0xFF);
        
        assertEquals(73, bval[0]);
        assertEquals(-106, bval[1]);
        assertEquals(2, bval[2]);
        assertEquals(-46, bval[3]);
        
        
        ival = -1062730440;
        
        bval[0] = (byte) ((ival >>> 24) & 0xFF);
        bval[1] = (byte) ((ival >>> 16) & 0xFF);
        bval[2] = (byte) ((ival >>> 8) & 0xFF);
        bval[3] = (byte) (ival & 0xFF);
        
        assertEquals(-64, bval[0]);
        assertEquals(-88, bval[1]);
        assertEquals(5, bval[2]);
        assertEquals(56, bval[3]);
        
        ival = -1407778526;
        
        bval[0] = (byte) ((ival >>> 24) & 0xFF);
        bval[1] = (byte) ((ival >>> 16) & 0xFF);
        bval[2] = (byte) ((ival >>> 8) & 0xFF);
        bval[3] = (byte) (ival & 0xFF);
        
       
        assertEquals(-84, bval[0]);
        assertEquals(23, bval[1]);
        assertEquals(1, bval[2]);
        assertEquals(34, bval[3]);
	}
	
	public final void writeLong(long v, byte[] writeBuffer) {
		writeBuffer[0] = (byte)(v >>> 56);
        writeBuffer[1] = (byte)(v >>> 48);
        writeBuffer[2] = (byte)(v >>> 40);
        writeBuffer[3] = (byte)(v >>> 32);
        writeBuffer[4] = (byte)(v >>> 24);
        writeBuffer[5] = (byte)(v >>> 16);
        writeBuffer[6] = (byte)(v >>>  8);
        writeBuffer[7] = (byte)(v >>>  0);
	}
	
	public final long readLong(byte[] readBuffer) {        
        return (((long)readBuffer[0] << 56) +
                ((long)(readBuffer[1] & 255) << 48) +
                ((long)(readBuffer[2] & 255) << 40) +
                ((long)(readBuffer[3] & 255) << 32) +
                ((long)(readBuffer[4] & 255) << 24) +
                ((readBuffer[5] & 255) << 16) +
                ((readBuffer[6] & 255) <<  8) +
                ((readBuffer[7] & 255) <<  0));
    }
}
