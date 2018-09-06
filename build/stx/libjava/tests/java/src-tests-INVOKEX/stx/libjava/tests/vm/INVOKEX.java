package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.internal.TextListener;
import org.junit.runner.JUnitCore;

import stx.libjava.tests.mocks.MissingMethodA;
import stx.libjava.tests.mocks.AbstractMethod;
import stx.libjava.tests.mocks.MissingMethodB;
import stx.libjava.tests.mocks.MissingMethodI;

public class INVOKEX {
	MissingMethodA a = new MissingMethodA();
	MissingMethodB b = new MissingMethodB();
	
	@Test
	public void invokevirtual() {
		b.missingVirtual();
		try {
			invokevirtual(a);
			fail();
		} catch (Throwable e) {
			assertTrue(e instanceof NoSuchMethodError);
		}
		try {
			invokevirtual(b);
			fail();
		} catch (Throwable e) {
			assertTrue(e instanceof NoSuchMethodError);
		}

	}
	public void invokevirtual(MissingMethodA x) {
		x.missingVirtual();
	}

	@Test
	public void invokestatic() {
		try {
			MissingMethodA.missingStatic();
			fail();
		} catch (Throwable e) {
			assertTrue(e instanceof NoSuchMethodError);
		}
	}
	
	@Test
	public void invokespecial() {
		try {
			invokespecial(b);
			fail();
		} catch (Throwable e) {
			assertTrue(e instanceof NoSuchMethodError);
		}
	}
	public void invokespecial(MissingMethodA x) {
		x.missingSoecial();
	}

	@Test
	public void invokeinterfacel() {
		invokeinterfacel(b);
		try {
			invokeinterfacel(a);
			fail();
		} catch (Throwable e) {
			assertTrue(e instanceof AbstractMethodError);
		}
	}
	
	public void invokeinterfacel(MissingMethodI x) {
		x.missingInterface();
	}

	@Test
	public void invokevirtualabstract() {
		AbstractMethod _abstract = new MissingMethodA();
		try {
			_abstract.abstractVirtual();
			fail();
		} catch (Throwable e) {			
			assertTrue(e instanceof AbstractMethodError);
		}
	}
	
	public static void main(String[] args) {
		JUnitCore runner = new JUnitCore();
		runner.addListener(new TextListener(System.out));
		runner.run(INVOKEX.class);
	}
	
	
	

}
