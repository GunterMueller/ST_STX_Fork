package stx.libjava.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class JUnit4Tests {

	@Test
	public void helloWorld() {
		assertEquals("Is zero equal 5-5 test",0, (5-5));
	}
	
	@Test
	public void stringEquality() {
		assertEquals("String equality test", "hello", "hello");
	}
	
	@Test
	public void helloWorldWillNotPass() {
		/* Make it failing only when running on Smalltalk/X VM */
		if (System.getProperty("java.vm.name").equals("Smalltalk/X")) {
			assertEquals("Is zero equal 5 test", 0, 5);
		}
	}
	
	@Test
	public void assumptionNotHolding() {
		/* Make it failing only when running on Smalltalk/X VM */
		org.junit.Assume.assumeTrue(! System.getProperty("java.vm.name").equals("Smalltalk/X"));			
	}
	
	
	public static void main(String [] args) {
		if (System.getProperty("java.vm.name").equals("Smalltalk/X")) {
			System.out.println("Expected output: 3 run, 1 failed");
		} else {
			System.out.println("Expected output: 3 run, 0 failed");
		}
		Result result = JUnitCore.runClasses(JUnit4Tests.class);
		System.out.println("getRunCount() = " + result.getRunCount());
		System.out.println("getFailureCount() = " + result.getFailureCount());
		for (Failure f : result.getFailures()) {
			System.out.println("Failure: " + f.toString());	
		}
	}
	
	public static Result runAllTests() {		
		return JUnitCore.runClasses(JUnit4Tests.class);			
	}
}
