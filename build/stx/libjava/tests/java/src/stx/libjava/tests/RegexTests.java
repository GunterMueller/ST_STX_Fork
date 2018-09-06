package stx.libjava.tests;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import junit.framework.Assert;
import junit.framework.TestCase;

import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class RegexTests extends TestCase {

	public void testSimpleRegex() {
		Assert.assertTrue("Simple text matching","foo@foo.org".matches("[a-z]*@[a-z]*.[a-z]*"));
	}
	
	public void testNotSoSimpleRegex() {
		Pattern p = Pattern.compile("[a-z]*@[a-z]*.[a-z]*");
		Matcher m = p.matcher("foo@foo.org");
		Assert.assertTrue("Not so simple text matching",m.matches());
	}
	
	public static void main(String[] args) {
		System.out.println("Expected output: 2 run, 0 failed");
		Result result = runAllTests();		
		System.out.println("getRunCount() = " + result.getRunCount());
		System.out.println("getFailureCount() = " + result.getFailureCount());
		for (Failure f : result.getFailures()) {
			System.out.println("Failure: " + f.toString());	
		}
	}
	
	public static Result runAllTests() {		
		return JUnitCore.runClasses(RegexTests.class);			
	}
	
}
