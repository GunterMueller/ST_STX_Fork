/*
 * COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
 * COPYRIGHT (c) 2014-2015 by Tomas Heger
 *                            SWING Research Group, Czech Technical University in Prague
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice. This software may not
 * be provided or otherwise made available to, or used by, any
 * other person. No title to or ownership of the software is
 * hereby transferred.
 */
package stx.libjava.tools.environment.tests;

import static org.junit.Assert.*;

import org.eclipse.jdt.internal.compiler.env.EnumConstantSignature;
import org.eclipse.jdt.internal.compiler.impl.BooleanConstant;
import org.eclipse.jdt.internal.compiler.impl.StringConstant;
import org.junit.Test;

import stx.libjava.tools.environment.ReflectiveElementValuePair;

public class ReflectiveElementValuePairTests {

	/**
	 * ReflectiveElementValuePair.getName() method test
	 */
	@Test
	public void test_getName() {
		String name = "name";
		ReflectiveElementValuePair revp;
		revp = new ReflectiveElementValuePair(name.toCharArray(), new Object());
		char[] retName = revp.getName();
		assertEquals(name, new String(retName));		
	}

	/**
	 * ReflectiveElementValuePair.getValue() method test.
	 * This test addresses compile-time constants of primitive types and String 
	 * literals.
	 */
	@Test
	public void test_getValue() {
		char[] name = "name".toCharArray();
		ReflectiveElementValuePair revp;
		Object retValue;
		
		// EnumConstantSignature
		EnumConstantSignature ecs;
		ecs = new EnumConstantSignature("typename".toCharArray(), "constname".toCharArray());
		revp = new ReflectiveElementValuePair(name, ecs);
		retValue = revp.getValue();
		assertTrue(retValue instanceof EnumConstantSignature);
		assertEquals(new EnumConstantSignature("typename".toCharArray(), "constname".toCharArray()), retValue);
		
		// BooleanConstant
		BooleanConstant bc;
		bc = (BooleanConstant) BooleanConstant.fromValue(true);
		revp = new ReflectiveElementValuePair(name, bc);
		retValue = revp.getValue();
		assertTrue(retValue instanceof BooleanConstant);
		assertEquals(BooleanConstant.fromValue(true), retValue);
		
		// StringConstant
		StringConstant sc;
		sc = (StringConstant) StringConstant.fromValue("value");
		revp = new ReflectiveElementValuePair(name, sc);
		retValue = revp.getValue();
		assertTrue(retValue instanceof StringConstant);
		assertEquals(StringConstant.fromValue("value"), retValue);
		
		// Object[] containing instances of StringConstant
		Object[] objArray = new Object[2];
		objArray[0] = StringConstant.fromValue("value");
		objArray[1] = StringConstant.fromValue("value");
		revp = new ReflectiveElementValuePair(name, objArray);
		retValue = revp.getValue();
		assertTrue(retValue.getClass().isArray());
		assertEquals("java.lang.Object", retValue.getClass().getComponentType().getName());
		assertEquals(2, ((Object[]) retValue).length);
		assertEquals(StringConstant.fromValue("value"), ((Object[]) retValue)[0]);
		assertEquals(StringConstant.fromValue("value"), ((Object[]) retValue)[1]);
		
		// an empty Object[]
		objArray = new Object[0];
		revp = new ReflectiveElementValuePair(name, objArray);
		retValue = revp.getValue();
		assertTrue(retValue.getClass().isArray());
		assertEquals("java.lang.Object", retValue.getClass().getComponentType().getName());
		assertEquals(0, ((Object[]) retValue).length);
	}
}
