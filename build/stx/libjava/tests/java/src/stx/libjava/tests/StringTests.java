package stx.libjava.tests;

import org.junit.Test;

import junit.framework.TestCase;


@stx.libjava.annotation.Package("stx:libjava/tests")
public class StringTests extends TestCase {
	
	@Test
	public void test_01() {
	    String s = "\u1FFF";
	    
	    assertEquals(1, s.length());
	    assertEquals(0x1FFF, (int)s.charAt(0));
	    
	}
	
}
