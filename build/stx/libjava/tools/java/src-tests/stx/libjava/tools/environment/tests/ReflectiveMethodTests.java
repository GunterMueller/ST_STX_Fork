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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;
import org.junit.Test;

import stx.libjava.tests.mocks.Crate;
import stx.libjava.tests.mocks.HeavilyAnnotatedClass;
import stx.libjava.tests.mocks.SimpleMath;
import stx.libjava.tools.environment.ReflectiveType;
import stx.libjava.tools.environment.tests.mocks.ClassWithoutMethods;

public class ReflectiveMethodTests {

	/**
	 * ReflectiveMethod.getSelector() method test.
	 */
	@Test
	public void test_getSelector() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methods = type.getMethods();
		assertEquals(24, methods.length);

		String[] methodsSelectors = { "add2To2000Expect2002", "addMinus5ToArg",
				"multiply", "power", "powerAcc", "div", "negateInt",
				"bitShiftLeft", "bitShiftRight", "division", "inc2", "dec2",
				"unsignedBitShiftRight", "and", "or", "xor",
				"justUseConstants", "isYourStackCreatedCorrectly",
				"isYourStackCreatedCorrectlyEvenWithDoublesAndLongs",
				"sumArray", "sumArrayOfDoubles", "giveMeArrayOfLongs", "main",
				"<init>" };

		int flag;
		for (int i = 0; i < methodsSelectors.length; i++) {
			flag = 0;
			for (int j = 0; j < methods.length; j++) {
				if (new String(methods[j].getSelector())
						.equals(methodsSelectors[i])) {
					flag = 1;
					break;
				}
			}
			if (flag == 0) {
				fail("Method not found.");
			}
		}
	}

	/**
	 * ReflectiveMethod.MethodDescriptor() method test.
	 */
	@Test
	public void test_getMethodDescriptor() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methods = type.getMethods();

		String[] methodsSelectors = { "add2To2000Expect2002", "addMinus5ToArg",
				"multiply", "power", "powerAcc", "div", "negateInt",
				"bitShiftLeft", "bitShiftRight", "division", "inc2", "dec2",
				"unsignedBitShiftRight", "and", "or", "xor",
				"justUseConstants", "isYourStackCreatedCorrectly",
				"isYourStackCreatedCorrectlyEvenWithDoublesAndLongs",
				"sumArray", "sumArrayOfDoubles", "giveMeArrayOfLongs", "main",
				"<init>" };

		String[] methodsDescriptors = { "()I", "(I)I", "(II)I", "(II)I",
				"(III)I", "(II)I", "(I)I", "(II)I", "(II)I", "(II)I", "(I)I",
				"(I)I", "(II)I", "(II)I", "(II)I", "(II)I", "()V", "()I",
				"()D", "([I)I", "([D)D", "()[J", "([Ljava/lang/String;)V",
				"()V", };

		int flag;
		for (int i = 0; i < methodsSelectors.length; i++) {
			flag = 0;
			for (int j = 0; j < methods.length; j++) {
				if (new String(methods[j].getSelector())
						.equals(methodsSelectors[i])) {
					flag = 1;
					assertEquals(methodsDescriptors[i],
							new String(methods[j].getMethodDescriptor()));
					break;
				}
			}
			if (flag == 0) {
				fail("Method not found.");
			}
		}
	}

	/**
	 * ReflectiveMethod.getAnnotations() method test.
	 */
	@Test
	public void test_getAnnotations() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "heavilyAnnotatedMethod";
		for (int k = 0; k < methodsArr.length; k++) {
			if (new String(methodsArr[k].getSelector()).equals(methodName)) {
				IBinaryAnnotation[] annotationsArr = methodsArr[k]
						.getAnnotations();
				assertEquals(4, annotationsArr.length);

				String[] methodAnnotations = {
						"Lstx/libjava/tests/mocks/EnumValueAnnotation;",
						"Lstx/libjava/tests/mocks/ArrayValueAnnotation;",
						"Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;",
						"Lstx/libjava/tests/mocks/ClassValueAnnotation;", };

				int flag;
				for (int i = 0; i < methodAnnotations.length; i++) {
					flag = 0;
					for (int j = 0; j < annotationsArr.length; j++) {
						if (new String(annotationsArr[j].getTypeName())
								.equals(methodAnnotations[i])) {
							flag = 1;
							break;
						}
					}
					if (flag == 0) {
						fail("Method not found.");
					}
				}
			}
		}
	}

	/**
	 * ReflectiveMethod.getParameterAnnotations() method test.
	 */
	@Test
	public void test_getParameterAnnotations() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "heavilyAnnotatedMethod";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				assertEquals(1, methodsArr[i].getAnnotatedParametersCount());
				IBinaryAnnotation[] annotationsArr = methodsArr[i]
						.getParameterAnnotations(0);
				assertEquals(1, annotationsArr.length);
				assertEquals("Lstx/libjava/tests/mocks/EnumValueAnnotation;",
						new String(annotationsArr[0].getTypeName()));
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getParameterAnnotations() method test.
	 */
	@Test
	public void test_getParameterAnnotations1() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "div";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				assertEquals(0, methodsArr[i].getAnnotatedParametersCount());
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getAnnotatedParametersCount() method test.
	 */
	@Test
	public void test_getAnnotatedParametersCount() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "heavilyAnnotatedMethod";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				int count = methodsArr[i].getAnnotatedParametersCount();
				assertEquals(1, count);
			}
			if (flag == 0) {
				fail("Method not found");
			}
		}
	}

	/**
	 * ReflectiveMethod.getAnnotatedParametersCount() method test.
	 */
	@Test
	public void test_getAnnotatedParametersCount1() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "or";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				int count = methodsArr[i].getAnnotatedParametersCount();
				assertEquals(0, count);
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.isConstructor() method test.
	 */
	@Test
	public void test_isConstructor() {
		ReflectiveType type = new ReflectiveType(ClassWithoutMethods.class);
		IBinaryMethod[] methodsArr = type.getMethods();
		assertTrue(methodsArr[0].isConstructor());
	}

	/**
	 * ReflectiveMethod.isConstructor() method test.
	 * 
	 */
	@Test
	public void test_isConstructor1() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "or";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				assertFalse(methodsArr[i].isConstructor());
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getArgumentNames() method test.
	 * 
	 * Argument names aren't available -> returning null
	 */
	@Test
	public void test_getArgumentNames() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "and";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				assertNull(methodsArr[i].getArgumentNames());
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getArgumentNames() method test.
	 * 
	 * Argument names aren't available -> returning null
	 */
	@Test
	public void test_getArgumentNames1() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "powerAcc";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				assertNull(methodsArr[i].getArgumentNames());
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getModifiers() method test.
	 */
	/*
	 * @Test public void test_getModifiers() { ReflectiveType type = new
	 * ReflectiveType(SimpleMath.class); IBinaryMethod[] methodsArr =
	 * type.getMethods();
	 * 
	 * String methodName = "add2To2000Expect2002"; for (int i = 0; i <
	 * methodsArr.length; i++){ if (new
	 * String(methodsArr[i].getSelector()).equals(methodName)){ int modifiers =
	 * methodsArr[i].getModifiers();
	 * 
	 * assertEquals(0x0001, modifiers & 0x0001); // public assertEquals(0,
	 * modifiers & 0x0010); // final assertEquals(0, modifiers & 0x0020); //
	 * super assertEquals(0, modifiers & 0x0200); // interface assertEquals(0,
	 * modifiers & 0x0400); // abstract assertEquals(0, modifiers & 0x1000); //
	 * synthetic assertEquals(0, modifiers & 0x2000); // annotation
	 * assertEquals(0, modifiers & 0x4000); // enum } } }
	 */

	/**
	 * ReflectiveMethod.getModifiers() method test.
	 */
	/*
	 * @Test public void test_getModifiers1() { ReflectiveType type = new
	 * ReflectiveType(SimpleMath.class); IBinaryMethod[] methodsArr =
	 * type.getMethods();
	 * 
	 * String methodName = "heavilyAnnotatedMethod"; for (int i = 0; i <
	 * methodsArr.length; i++){ if (new
	 * String(methodsArr[i].getSelector()).equals(methodName)){ int modifiers =
	 * methodsArr[i].getModifiers();
	 * 
	 * assertEquals(0x0001, modifiers & 0x0001); // public assertEquals(0,
	 * modifiers & 0x0010); // final assertEquals(0, modifiers & 0x0020); //
	 * super assertEquals(0, modifiers & 0x0200); // interface assertEquals(0,
	 * modifiers & 0x0400); // abstract assertEquals(0, modifiers & 0x1000); //
	 * synthetic assertEquals(0, modifiers & 0x2000); // annotation
	 * assertEquals(0, modifiers & 0x4000); // enum } } }
	 */

	/**
	 * ReflectiveMethod.getExceptionTypeNames() method test.
	 */
	@Test
	public void test_getExceptionTypeNames() {
		ReflectiveType type = new ReflectiveType(Crate.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "throwSomeException";
		String firstEx = "java/lang/InterruptedException";
		String secondEx = "java/lang/IllegalArgumentException";
		boolean foundFirst = false;
		boolean foundSecond = false;

		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (new String(methodsArr[i].getSelector()).equals(methodName)) {
				flag = 1;
				char[][] exceptions = methodsArr[i].getExceptionTypeNames();
				assertEquals(2, exceptions.length);

				for (int j = 0; j < exceptions.length; j++) {
					if (new String(exceptions[j]).equals(firstEx)) {
						foundFirst = true;
					}
				}

				for (int j = 0; j < exceptions.length; j++) {
					if (new String(exceptions[j]).equals(secondEx)) {
						foundSecond = true;
					}
				}
			}
		}
		if (foundFirst == false || foundSecond == false || flag == 0) {
			fail();
		}
	}

	/**
	 * ReflectiveMethod.getExceptionTypeNames() method test.
	 */
	@Test
	public void test_getExceptionTypeNames1() {
		ReflectiveType type = new ReflectiveType(Crate.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "setLongVar";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (methodName.equals(new String(methodsArr[i].getSelector()))) {
				flag = 1;
				assertEquals(0, methodsArr[i].getExceptionTypeNames().length);
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}

	/**
	 * ReflectiveMethod.getDefaultValue() method test.
	 */
	@Test
	public void test_getDefaultValue() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		IBinaryMethod[] methodsArr = type.getMethods();

		String methodName = "or";
		int flag = 0;
		for (int i = 0; i < methodsArr.length; i++) {
			if (methodName.equals(new String(methodsArr[i].getSelector()))) {
				flag = 1;
				assertNull(methodsArr[i].getDefaultValue());
			}
		}
		if (flag == 0) {
			fail("Method not found");
		}
	}
}
