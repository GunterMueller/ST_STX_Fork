package stx.libjava.tests.lang;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ArrayTests {

    @Test
    public void test_01() {        
        String[] sa = new String[3];
        Object[] oa = (Object[])sa;
        boolean gotASE = false;
        try {
            oa[0] = new Integer(1);                
        } catch (ArrayStoreException ase) {
            gotASE = true;
        } catch (Throwable t) {
            t.printStackTrace();
            
        }
        assertTrue(gotASE);
    }
    
    // ArrayIndexOutOfBoundsException - under
    @Test
    public void test_02a() {        
        String[] sa = new String[3];        
        boolean gotAIOB = false;
        try {
            sa[-1] = "XXX";                 
        } catch (ArrayIndexOutOfBoundsException aiob) {
            gotAIOB = true;
        } catch (Throwable t) {
            t.printStackTrace();
            
        }
        assertTrue(gotAIOB);
    }

    // ArrayIndexOutOfBoundsException - over
    @Test
    public void test_02b() {        
        String[] sa = new String[3];        
        boolean gotAIOB = false;
        try {
            sa[3] = "XXX";                 
        } catch (ArrayIndexOutOfBoundsException aiob) {
            gotAIOB = true;
        } catch (Throwable t) {
            t.printStackTrace();
            
        }
        assertTrue(gotAIOB);
    }
    
 // ArrayIndexOutOfBoundsException - over
    @Test
    public void test_02c() {        
        String[] sa = new String[3];        
        boolean gotAIOB = false;
        try {
            sa[0] = "XXX";                 
            sa[1] = "XXX";
            sa[2] = "XXX";
        } catch (ArrayStoreException ase) {
            gotAIOB = true;
        } catch (Throwable t) {
            t.printStackTrace();
            
        }
        assertFalse(gotAIOB);
    }


}
