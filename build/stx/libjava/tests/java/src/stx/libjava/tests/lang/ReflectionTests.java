package stx.libjava.tests.lang;

import static org.junit.Assert.*;

import java.lang.reflect.Method;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ReflectionTests {

    public Byte byte2Byte(byte b) {
        return new Byte(b);
    }

    @Test
    public void test_byte2Byte() {
        try {
            Method m;
            m = this.getClass().getMethod("byte2Byte", byte.class);
            assertEquals(m.invoke(this, new Byte((byte) 10)), new Byte(
                    (byte) 10));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Short short2Short(short b) {
        return new Short(b);
    }

    @Test
    public void test_short2Short() {
        try {
            Method m;
            m = this.getClass().getMethod("short2Short", short.class);
            assertEquals(m.invoke(this, new Short((short) 10)), new Short(
                    (short) 10));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Integer int2Integer(int i) {
        return new Integer(i);
    }

    @Test
    public void test_int2Integer() {
        try {
            Method m;
            m = this.getClass().getMethod("int2Integer", int.class);
            assertEquals(m.invoke(this, new Integer(10)), new Integer(10));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Long long2Long(long i) {
        return new Long(i);
    }

    @Test
    public void test_int2Long() {
        try {
            Method m;
            m = this.getClass().getMethod("long2Long", long.class);
            assertEquals(m.invoke(this, new Long(10)), new Long(10));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Float float2Float(float i) {
        return new Float(i);
    }

    @Test
    public void test_float2Float() {
        try {
            Method m;
            m = this.getClass().getMethod("float2Float", float.class);
            assertEquals(m.invoke(this, new Float(10.1)), new Float(10.1));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Double double2double(double i) {
        return new Double(i);
    }

    @Test
    public void test_double2double() {
        try {
            Method m;
            m = this.getClass().getMethod("double2double", double.class);
            assertEquals(m.invoke(this, new Double(10.1)), new Double(10.1));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Boolean boolean2Boolean(boolean i) {
        return new Boolean(i);
    }

    @Test
    public void test_boolean2Boolean() {
        try {
            Method m;
            m = this.getClass().getMethod("boolean2Boolean", boolean.class);
            assertEquals(m.invoke(this, new Boolean(true)), new Boolean(true));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }

    public Character char2Character(char i) {
        return new Character(i);
    }

    @Test
    public void test_char2Character() {
        try {
            Method m;
            m = this.getClass().getMethod("char2Character", char.class);
            assertEquals(m.invoke(this, new Character('a')), new Character('a'));
        } catch (Exception t) {
            t.printStackTrace(System.err);
            assertTrue("Exception", false);
        }
    }
    
    @Test 
    public void test_getCompomentClass_01() {
        byte[]    ba = new byte[1];
        short[]   sa = new short[1];
        int[]     ia = new int[1];
        long[]    la = new long[1];
        float[]   fa = new float[1];
        double[]  da = new double[1];
        boolean[] ta = new boolean[1];
        char[]    ca = new char[1];
        Object[]  oa = new Object[1];
        
        assertEquals(ba.getClass().getComponentType(), Byte.TYPE);
        assertEquals(sa.getClass().getComponentType(), Short.TYPE);
        assertEquals(ia.getClass().getComponentType(), Integer.TYPE);
        assertEquals(la.getClass().getComponentType(), Long.TYPE);
        assertEquals(fa.getClass().getComponentType(), Float.TYPE);
        assertEquals(da.getClass().getComponentType(), Double.TYPE);
        assertEquals(ta.getClass().getComponentType(), Boolean.TYPE);
        assertEquals(ca.getClass().getComponentType(), Character.TYPE);
        assertEquals(oa.getClass().getComponentType(), Object.class);
    }
    
    @Test 
    public void test_getCompomentClass_02() {
        byte[][]    ba = new byte[1][1];
        short[][]   sa = new short[1][1];
        int[][]     ia = new int[1][1];
        long[][]    la = new long[1][1];
        float[][]   fa = new float[1][1];
        double[][]  da = new double[1][1];
        boolean[][] ta = new boolean[1][1];
        char[][]    ca = new char[1][1];
        Object[][]  oa = new Object[1][1];
        
        assertEquals(ba[0].getClass().getComponentType(), Byte.TYPE);
        assertEquals(sa[0].getClass().getComponentType(), Short.TYPE);
        assertEquals(ia[0].getClass().getComponentType(), Integer.TYPE);
        assertEquals(la[0].getClass().getComponentType(), Long.TYPE);
        assertEquals(fa[0].getClass().getComponentType(), Float.TYPE);
        assertEquals(da[0].getClass().getComponentType(), Double.TYPE);
        assertEquals(ta[0].getClass().getComponentType(), Boolean.TYPE);
        assertEquals(ca[0].getClass().getComponentType(), Character.TYPE);
        assertEquals(oa[0].getClass().getComponentType(), Object.class);
    }
    
    public static class NestedClassL1 {
        protected Object o1;
        
        public static class NestedClassL2 {
            
        }
        
        public NestedClassL1() {
            o1 = new Object() { public int hashCode() { return 10; } }; 
        }
        
        public Object getO1() {
            return o1;
        }
        
        public Object getO2() {
            return new Object() { public int hashCode() { return 20; } };
        }
        
        
    }
    
    @Test
    public void test_getEnclosingClass_01() {
        assertEquals(this.getClass(), NestedClassL1.class.getEnclosingClass() );
        assertEquals(NestedClassL1.class, NestedClassL1.NestedClassL2.class.getEnclosingClass() );
    }
    
    @Test
    public void test_getEnclosingClass_02() {
        Object o = new Object() { public int hashCode() { return 10; } };         
        assertEquals(this.getClass(), o.getClass().getEnclosingClass() );        
    }
    
    @Test 
    public void test_getEnclosingMethod_01() {
        Object o1 = (new NestedClassL1()).getO1();
        Object o2 = (new NestedClassL1()).getO2();
        
        assertEquals(null, o1.getClass().getEnclosingMethod());
        try {
            assertEquals(NestedClassL1.class.getDeclaredMethod("getO2", new Class[0]), o2.getClass().getEnclosingMethod());
        } catch (SecurityException e) {
            fail();            
        } catch (NoSuchMethodException e) {
            fail();
        }
    }
    
    @Test 
    public void test_getEnclosingConstructor_01() {
        Object o1 = (new NestedClassL1()).getO1();
        Object o2 = (new NestedClassL1()).getO2();
                
        try {
            assertEquals(NestedClassL1.class.getDeclaredConstructor(new Class[0]), o1.getClass().getEnclosingConstructor());
        } catch (SecurityException e) {
            fail();            
        } catch (NoSuchMethodException e) {
            fail();
        }
        assertEquals(null, o2.getClass().getEnclosingConstructor());
    }
    
    @Test
    public void test_isAnonymous() {
        Object o1 = (new NestedClassL1()).getO1();
        Object o2 = (new NestedClassL1()).getO2();

        assertTrue(o1.getClass().isAnonymousClass());
        assertTrue(o2.getClass().isAnonymousClass());
        assertFalse(this.getClass().isAnonymousClass());
        assertFalse(NestedClassL1.class.isAnonymousClass());
    }
    
    public interface ICompilationUnit {
    	public char[][] getPackageName();
    }
    
    @Test
    public void test_returnType() {
    	try {
			Method m = ICompilationUnit.class.getMethod("getPackageName");
			assertTrue(m.getReturnType().isArray());
			assertTrue(m.getReturnType().getComponentType().isArray());
		    assertEquals(m.getReturnType().getComponentType().getComponentType(), Character.TYPE);		    
		} catch (NoSuchMethodException e) {			
			fail();
		} catch (SecurityException e) {
			fail();
		}
    }
    
}
