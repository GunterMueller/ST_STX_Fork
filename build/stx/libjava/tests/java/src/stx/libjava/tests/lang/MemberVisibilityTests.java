package stx.libjava.tests.lang;

import static org.junit.Assert.assertEquals;

import org.junit.Ignore;
import org.junit.Test;

import stx.libjava.tests.mocks.a.A;
import stx.libjava.tests.mocks.b.B;


@stx.libjava.annotation.Package("stx:libjava/tests")
public class MemberVisibilityTests {

	// Package private methods are not yet correctly supported by stx:libjava
	@Test @Ignore
	public void testPackagePrivateNormal() {
		String result;
		result = A.callMethod1(new A());
		assertEquals(result , "A.method1()");
		
		result = A.callMethod1(new B());
		assertEquals(result , "A.method1()"); //!!!!!!!!		
	}
	
	// Package private methods are not yet correctly supported by stx:libjava	
	@Test @Ignore
	public void testPackagePrivateReflection() {
		String result;
		result = A.callMethod1ViaReflection(new A());
		assertEquals(result , "A.method1()");
		
		result = A.callMethod1ViaReflection(new B());
		assertEquals(result , "A.method1()");				
	}


}
