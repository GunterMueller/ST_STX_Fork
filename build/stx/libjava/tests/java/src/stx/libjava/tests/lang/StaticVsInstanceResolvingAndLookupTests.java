package stx.libjava.tests.lang;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import stx.libjava.tests.mocks.instance_static.InheritInstanceStuff;
import stx.libjava.tests.mocks.instance_static.InheritInstanceStuffWithStatic;
import stx.libjava.tests.mocks.instance_static.MissingInstanceStuff;
import stx.libjava.tests.mocks.instance_static.MissingInstanceStuffWithInterface;
import stx.libjava.tests.mocks.instance_static.StaticInSuperVsInstInSuperSuper;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class StaticVsInstanceResolvingAndLookupTests {
	//when no instance method or field is available
	//but static is, it takes static
	@Test
	public void testMissingInstanceThingy() {
		MissingInstanceStuff s = new MissingInstanceStuff();
		assertTrue(s.staticField == 0);
		assertTrue(s.staticMethod() == 0);
		
	}
	
	//when no instance method or field is available
	//but static in super super and interface in super is, it takes super
	@Test
	public void testSuperVsIfaceFight() {
		MissingInstanceStuffWithInterface s = new MissingInstanceStuffWithInterface();
		assertTrue(s.staticField == 0);
	}
	
	//when no instance method or field is available
	//but there is one in super, it will take it #nosurprise :)
	@Test
	public void testBasicInstanceSuper() {
		InheritInstanceStuff f = new InheritInstanceStuff();
		assertTrue(f.instField == 0);
		assertTrue(f.instMethod() == 0);
	}
	
	//when no instance method or field is available
	//but there is static one in super, and inst in super super
	//it takes inst in super super
	@Test
	public void testStaticInSuperVsInstInSuperSuperFight() {
		StaticInSuperVsInstInSuperSuper f = new StaticInSuperVsInstInSuperSuper();
		assertTrue(f.instField == 1);	
	}
	
	
	
	
	
	//when no instance method or field is available
	//but static and interface is, it takes static
	//will not compile :)
//	@Test()
//	public void testStaticVsInterfaceFight() {
//		try {
//		MissingInstanceStuffWithInterface s = new MissingInstanceStuffWithInterface();
//		assertTrue(s.staticField == 0);
//		fail(); 
//		}
//		catch (Throwable e) {
//			assertTrue(true);
//		}
//	}
}
