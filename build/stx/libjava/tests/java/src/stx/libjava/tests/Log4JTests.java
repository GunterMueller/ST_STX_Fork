package stx.libjava.tests;

import junit.framework.TestCase;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class Log4JTests extends TestCase {
	
	public void testLoadAndLogSomething() {
		//assertTrue("Test disabled since it crashes the VM (#9 bug)", false);
		/**/
		BasicConfigurator.configure();
		Logger logger = Logger.getRootLogger();
		logger.debug("Sample debug message");
		logger.error("Sample error message");
		logger.fatal("Sample fatal message");
		/**/
		
	}
	
	public static void main(String[] args) {
		Result result = runAllTests();	
		System.out.println("getRunCount() = " + result.getRunCount());
		System.out.println("getFailureCount() = " + result.getFailureCount());
		for (Failure f : result.getFailures()) {
			System.out.println("Failure: " + f.toString());	
		}
		System.out.println("End of output");
	}
	
	public static Result runAllTests() {		
		return JUnitCore.runClasses(Log4JTests.class);			
	}

}

