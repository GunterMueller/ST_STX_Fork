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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.eclipse.jdt.internal.compiler.env.ClassSignature;
import org.eclipse.jdt.internal.compiler.env.EnumConstantSignature;
import org.eclipse.jdt.internal.compiler.impl.BooleanConstant;
import org.eclipse.jdt.internal.compiler.impl.ByteConstant;
import org.eclipse.jdt.internal.compiler.impl.CharConstant;
import org.eclipse.jdt.internal.compiler.impl.DoubleConstant;
import org.eclipse.jdt.internal.compiler.impl.FloatConstant;
import org.eclipse.jdt.internal.compiler.impl.IntConstant;
import org.eclipse.jdt.internal.compiler.impl.LongConstant;
import org.eclipse.jdt.internal.compiler.impl.ShortConstant;
import org.eclipse.jdt.internal.compiler.impl.StringConstant;
import org.junit.Test;

import stx.libjava.tests.mocks.SimpleMath;
import stx.libjava.tests.mocks.Weather;
import stx.libjava.tools.environment.ReflectiveUtils;

public class ReflectiveUtilsTests {

	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant() {
		Object obj = ReflectiveUtils.getXConstant(new Byte((byte) 42));
		assertNotNull(obj);
		assertTrue(obj instanceof ByteConstant);
		ByteConstant objAsBC = (ByteConstant) obj;
		assertEquals(42, objAsBC.byteValue());
	}
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant1() {
		Object obj = ReflectiveUtils.getXConstant(new Short((short) 42));
		assertNotNull(obj);
		assertTrue(obj instanceof ShortConstant);
		ShortConstant objAsSC = (ShortConstant) obj;
		assertEquals(42, objAsSC.shortValue());
	}
		
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant3() {
		Object obj = ReflectiveUtils.getXConstant(new Integer((int) 42));
		assertNotNull(obj);
		assertTrue(obj instanceof IntConstant);
		IntConstant objAsIC = (IntConstant) obj;
		assertEquals(42, objAsIC.intValue());
	}		
		
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant4() {
		Object obj = ReflectiveUtils.getXConstant(new Long((long) 42));
		assertNotNull(obj);
		assertTrue(obj instanceof LongConstant);
		LongConstant objAsLC = (LongConstant) obj;
		assertEquals(42, objAsLC.longValue());
	}		
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant5() {
		Object obj = ReflectiveUtils.getXConstant(new Float((float) 42.42));
		assertNotNull(obj);
		assertTrue(obj instanceof FloatConstant);
		FloatConstant objAsFC = (FloatConstant) obj;
		assertEquals(42.42, objAsFC.floatValue(), 0.00002);
	}	
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant6() {
		Object obj = ReflectiveUtils.getXConstant(new Double((double) 42.42));
		assertNotNull(obj);
		assertTrue(obj instanceof DoubleConstant);
		DoubleConstant objAsDC = (DoubleConstant) obj;
		assertEquals(42.42, objAsDC.doubleValue(), 0.00002);
	}	
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant7() {
		Object obj = ReflectiveUtils.getXConstant(new Character((char) 'a'));
		assertNotNull(obj);
		assertTrue(obj instanceof CharConstant);
		CharConstant objAsCC = (CharConstant) obj;
		assertEquals('a', objAsCC.charValue());
	}
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant8() {
		Object obj = ReflectiveUtils.getXConstant(new Boolean((boolean) true));
		assertNotNull(obj);
		assertTrue(obj instanceof BooleanConstant);
		BooleanConstant objAsBC = (BooleanConstant) obj;
		assertEquals(true, objAsBC.booleanValue());
	}
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant9() {
		Object obj = ReflectiveUtils.getXConstant(new String("hello"));
		assertNotNull(obj);
		assertTrue(obj instanceof StringConstant);
		StringConstant objAsSC = (StringConstant) obj;
		assertEquals("hello", objAsSC.stringValue());
	}
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant10() {
	
		
		Object obj = ReflectiveUtils.getXConstant(Weather.SUNNY);
		assertNotNull(obj);
		assertTrue(obj instanceof EnumConstantSignature);
		
		EnumConstantSignature objAsECS = (EnumConstantSignature) obj;
		assertEquals("Lstx/libjava/tests/mocks/Weather;", new String(objAsECS.getTypeName()));
		assertEquals("SUNNY", new String(objAsECS.getEnumConstantName()));
		
	}
	
	/**
	 * ReflectiveUtils.getXConstant() method test.
	 */
	@Test
	public void test_getXConstant11() {
	
		Object obj = ReflectiveUtils.getXConstant(SimpleMath.class);
		assertNotNull(obj);
		assertTrue(obj instanceof ClassSignature);
		
		ClassSignature objAsCS = (ClassSignature) obj;
		assertEquals("Lstx/libjava/tests/mocks/SimpleMath;", new String(objAsCS.getTypeName()));
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName() {
		String sig = ReflectiveUtils.getSigFromName("int");
		assertNotNull(sig);
		assertEquals("I", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName1() {
		String sig = ReflectiveUtils.getSigFromName("byte");
		assertNotNull(sig);
		assertEquals("B", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName2() {
		String sig = ReflectiveUtils.getSigFromName("short");
		assertNotNull(sig);
		assertEquals("S", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName3() {
		String sig = ReflectiveUtils.getSigFromName("long");
		assertNotNull(sig);
		assertEquals("J", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName4() {
		String sig = ReflectiveUtils.getSigFromName("boolean");
		assertNotNull(sig);
		assertEquals("Z", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName5() {
		String sig = ReflectiveUtils.getSigFromName("char");
		assertNotNull(sig);
		assertEquals("C", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName6() {
		String sig = ReflectiveUtils.getSigFromName("double");
		assertNotNull(sig);
		assertEquals("D", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName7() {
		String sig = ReflectiveUtils.getSigFromName("float");
		assertNotNull(sig);
		assertEquals("F", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName8() {
		String sig = ReflectiveUtils.getSigFromName("void");
		assertNotNull(sig);
		assertEquals("V", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName9() {
		String sig = ReflectiveUtils.getSigFromName("java.lang.Object");
		assertNotNull(sig);
		assertEquals("Ljava/lang/Object;", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName10() {
		String sig = ReflectiveUtils.getSigFromName("stx.libjava.tests.mocks.ArrayValueAnnotation");
		assertNotNull(sig);
		assertEquals("Lstx/libjava/tests/mocks/ArrayValueAnnotation;", sig);
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName11() {
		String sig = ReflectiveUtils.getSigFromName("[I");
		assertNotNull(sig);
		assertEquals("[I", sig);	
	}
	
	/**
	 * ReflectiveUtils.getSigFromName() method test.
	 */
	@Test
	public void test_getSigFromName12() {
		String sig = ReflectiveUtils.getSigFromName("[[Ljava.lang.Object;");
		assertNotNull(sig);
		assertEquals("[[Ljava/lang/Object;", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor() {
		String sig = ReflectiveUtils.getFieldDescriptor(int.class);
		assertNotNull(sig);
		assertEquals("I", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor1() {
		String sig = ReflectiveUtils.getFieldDescriptor(byte.class);
		assertNotNull(sig);
		assertEquals("B", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor2() {
		String sig = ReflectiveUtils.getFieldDescriptor(short.class);
		assertNotNull(sig);
		assertEquals("S", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor3() {
		String sig = ReflectiveUtils.getFieldDescriptor(long.class);
		assertNotNull(sig);
		assertEquals("J", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor4() {
		String sig = ReflectiveUtils.getFieldDescriptor(boolean.class);
		assertNotNull(sig);
		assertEquals("Z", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor5() {
		String sig = ReflectiveUtils.getFieldDescriptor(char.class);
		assertNotNull(sig);
		assertEquals("C", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor6() {
		String sig = ReflectiveUtils.getFieldDescriptor(double.class);
		assertNotNull(sig);
		assertEquals("D", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor7() {
		String sig = ReflectiveUtils.getFieldDescriptor(float.class);
		assertNotNull(sig);
		assertEquals("F", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor8() {
		String sig = ReflectiveUtils.getFieldDescriptor(void.class);
		assertNotNull(sig);
		assertEquals("V", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor9() {
		String sig = ReflectiveUtils.getFieldDescriptor(java.lang.Object.class);
		assertNotNull(sig);
		assertEquals("Ljava/lang/Object;", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor10() {
		String sig = ReflectiveUtils.getFieldDescriptor(stx.libjava.tests.mocks.ArrayValueAnnotation.class);
		assertNotNull(sig);
		assertEquals("Lstx/libjava/tests/mocks/ArrayValueAnnotation;", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor11() {
		String sig = ReflectiveUtils.getFieldDescriptor((new int[5]).getClass());
		assertNotNull(sig);
		assertEquals("[I", sig);	
	}
	
	/**
	 * ReflectiveUtils.getFieldDescriptor() method test.
	 */
	@Test
	public void test_getFieldDescriptor12() {
		String sig = ReflectiveUtils.getFieldDescriptor((new Object[5]).getClass());
		assertNotNull(sig);
		assertEquals("[Ljava/lang/Object;", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig() {
		String sig = ReflectiveUtils.getNameFromSig("I");
		assertNotNull(sig);
		assertEquals("int", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig1() {
		String sig = ReflectiveUtils.getNameFromSig("B");
		assertNotNull(sig);
		assertEquals("byte", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig2() {
		String sig = ReflectiveUtils.getNameFromSig("S");
		assertNotNull(sig);
		assertEquals("short", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig3() {
		String sig = ReflectiveUtils.getNameFromSig("J");
		assertNotNull(sig);
		assertEquals("long", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig4() {
		String sig = ReflectiveUtils.getNameFromSig("Z");
		assertNotNull(sig);
		assertEquals("boolean", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig5() {
		String sig = ReflectiveUtils.getNameFromSig("C");
		assertNotNull(sig);
		assertEquals("char", sig);	
	}
	
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig6() {
		String sig = ReflectiveUtils.getNameFromSig("D");
		assertNotNull(sig);
		assertEquals("double", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig7() {
		String sig = ReflectiveUtils.getNameFromSig("F");
		assertNotNull(sig);
		assertEquals("float", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig8() {
		String sig = ReflectiveUtils.getNameFromSig("V");
		assertNotNull(sig);
		assertEquals("void", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig9() {
		String sig = ReflectiveUtils.getNameFromSig("Lstx/libjava/tests/mocks/ArrayValueAnnotation;");
		assertNotNull(sig);
		assertEquals("stx.libjava.tests.mocks.ArrayValueAnnotation", sig);	
	}
	
	/**
	 * ReflectiveUtils.getNameFromSig() method test.
	 */
	@Test
	public void test_getNameFromSig10() {
		String sig = ReflectiveUtils.getNameFromSig("[Lstx/libjava/tests/mocks/ArrayValueAnnotation;");
		assertNotNull(sig);
		assertEquals("[Lstx.libjava.tests.mocks.ArrayValueAnnotation;", sig);	
	}
}
