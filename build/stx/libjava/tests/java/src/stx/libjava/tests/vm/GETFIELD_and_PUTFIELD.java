package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class GETFIELD_and_PUTFIELD {

    @Test
    public void test_getfield_01a() {
        Fields f = new Fields();
        int field1 = Fields.getField1Of(f);        
        assertEquals(-1, field1);
    }
    
    public void test_getfield_01b() {
        test_getfield_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_getfield_02() {
        Fields f = null;
        try {
            int field1 = Fields.getField1Of(f);
            assertTrue(false);            
        } catch (NullPointerException npe) {
            // OK, NPE should be thrown
        }
    }

    
    @Test
    public void test_putfield_01a() {
        Fields f = new Fields();
        Fields.setField1Of(f, 100);
        int field1 = f.getField1();        
        assertEquals(100, field1);
    }
    
    public void test_putfield_01b() {
        test_putfield_01a();
    }
    
    @Test
    public void test_putfield_02() {
        Fields f = null;
        try {
            Fields.setField1Of(f, 1);
            assertTrue(false);            
        } catch (NullPointerException npe) {
            // OK, NPE should be thrown
        }
    }
    
    

    public static class Fields {
        public int field1 = -1;
        
        public int getField1() {
            return field1;
        }
        
        public static int getField1Of(Fields f) {
            return f.field1;
        }
        
        public static void setField1Of(Fields f, int v ) {
            f.field1 = v;
        }

    }
    
}
