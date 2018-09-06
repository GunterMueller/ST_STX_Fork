package stx.libjava.tests.lang;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MonitorTests {
    /** An arbitrary token. Methods may assign
     *  a value which may be asserted then
     */
    int token = 0;

    public void syncAndAbort(Object obj) {
	    synchronized (obj) {
		    abort();
	    }
    }

    @Test
    public void test01() {
    	/* Do not run this test on real JVM as there is no native
    	 * abort()
    	 */
    	if (System.getProperty("java.vm.name").equals("Smalltalk/X")) { 
    		Object obj = new Object();	    
    		syncAndAbort(obj);
    		syncAndAbort(obj);
    	}
    }

    public native void abort();


    /** Not a test standalone, called by
     *  JavaMonitorTests>>test_releasing_01
     */
    public void test_releasing_01 () {
		try {
			token = 1;
			test_releasing_01_finally();
			token += 10;
		} catch (Exception e) {
			token += 100;
		}

		try {
			test_releasing_01_no_exception();
			token += 1000000;
		} catch (Exception e) {
			token += 10000000;
		}
    }

    public synchronized void test_releasing_01_finally_with_no_exception() {
		try {
			test_releasing_01_no_exception();
		} finally {
			token += 10000;
		}
    }

    public void test_releasing_01_finally() {
		try {
			test_releasing_01_throw_indirect();
		} finally {
			token += 1000;
		}
    }

    public synchronized void test_releasing_01_throw_indirect() {
		test_releasing_01_throw();
    }

	public synchronized void test_releasing_01_no_exception() {
		token += 100000;
	}

    public void test_releasing_01_throw() {
		throw new RuntimeException("thrown in JavaMinitorTests#test_releasing_01_throw()");
    }
}
