package stx.libjava.tests;

import junit.framework.TestCase;

import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class JUnit3Tests extends TestCase {
	
	public final void testSayHi() {       
        assertEquals("hi", sayHi());
    }
    
    private String sayHi() {
        return "hi";
    }
    
    public void testPass() {
    	assertEquals(10,10);
    }
    
    public void testFailure() {
    	/* Make it failing only when running on Smalltalk/X VM */
    	if (System.getProperty("java.vm.name").equals("Smalltalk/X")) {
    		assertEquals(10,0);
    	}
    }
    
    public void testError() {
    	/* Make it error only when running on Smalltalk/X VM */
    	if (System.getProperty("java.vm.name").equals("Smalltalk/X")) {
    		float a = 10 / 0;
    		assertEquals(a, 0.0);
    	}
    }
	
	public static void main(String [] args) {
		System.out.println("Expected output: 4 run, 2 failed");
		Result result = runAllTests();	
		System.out.println("getRunCount() = " + result.getRunCount());
		System.out.println("getFailureCount() = " + result.getFailureCount());
		for (Failure f : result.getFailures()) {
			System.out.println("Failure: " + f.toString());	
		}
	}

	public static Result runAllTests() {		
		return JUnitCore.runClasses(JUnit3Tests.class);			
	}

}
