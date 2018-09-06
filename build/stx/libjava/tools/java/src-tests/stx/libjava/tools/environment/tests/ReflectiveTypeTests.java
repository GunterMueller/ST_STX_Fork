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

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Arrays;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryField;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;
import org.eclipse.jdt.internal.compiler.env.IBinaryNestedType;
import org.junit.Test;

import stx.libjava.tests.mocks.ArrayValueAnnotation;
import stx.libjava.tests.mocks.ClassWithInnerClasses;
import stx.libjava.tests.mocks.Crate;
import stx.libjava.tests.mocks.HeavilyAnnotatedClass;
import stx.libjava.tests.mocks.SimpleAbstractClass;
import stx.libjava.tests.mocks.SimpleInheritingClass;
import stx.libjava.tests.mocks.SimpleMath;
import stx.libjava.tests.mocks.Weather;
import stx.libjava.tools.environment.ReflectiveNestedType;
import stx.libjava.tools.environment.ReflectiveType;
import stx.libjava.tools.environment.tests.mocks.ClassWithoutMethods;
import stx.libjava.tools.environment.tests.mocks.InnerClasses;
import stx.libjava.tools.environment.tests.mocks.InnerClasses.InnerClass1;
import stx.libjava.tools.text.Highlighter;
import stx.libjava.tools.text.Highlighter.HighlightingScanner;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveTypeTests {

	@Test
	public void test_01() {
		ReflectiveType ro = new ReflectiveType(new Object().getClass());

		char[] em = ro.getEnclosingMethod();
		assertEquals(null, em);

		char[] etn = ro.getEnclosingTypeName();
		assertEquals(null, etn);

		char[] gs = ro.getGenericSignature();
		assertEquals(null, gs);

		char[][] in = ro.getInterfaceNames();
		assertFalse(in != null);

		IBinaryMethod[] m = ro.getMethods();
		assertEquals(13, m.length); // 11 public + 1 private + 1 ctor.
	}

	@Test
	public void regression_01() {
		ReflectiveType type = new ReflectiveType(java.util.ArrayList.class);
		IBinaryMethod[] methods = type.getMethods();

		assertTrue(methods.length >= 3);

		for (int i = 0; i < methods.length; i++) {
			IBinaryMethod m = methods[i];
			if (m.isConstructor()) {
				if (new String(m.getMethodDescriptor())
						.equals("(Ljava/util/Collection;)V")) {
					assertTrue(Arrays.equals(
							"(Ljava/util/Collection<+TE;>;)V".toCharArray(),
							m.getGenericSignature()));
				}
			}
		}
	}

	/**
	 * ReflectiveType.getName() method test.
	 */
	@Test
	public void test_getName() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		assertEquals("stx/libjava/tests/mocks/HeavilyAnnotatedClass",
				new String(type.getName()));
	}

	/**
	 * ReflectiveType.getName() method test.
	 */
	@Test
	public void test_getName1() {
		ReflectiveType type = new ReflectiveType(String.class);
		assertEquals("java/lang/String", new String(type.getName()));
	}

	/**
	 * ReflectiveType.getSourceName() method test.
	 */
	@Test
	public void test_getSourceName() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		assertEquals("HeavilyAnnotatedClass", new String(type.getSourceName()));
	}

	/**
	 * ReflectiveType.getSourceName() method test.
	 */
	@Test
	public void test_getSourceName1() {
		ReflectiveType type = new ReflectiveType(String.class);
		assertEquals("String", new String(type.getSourceName()));
	}

	/**
	 * ReflectiveType.getSuperclassName() method test.
	 */
	@Test
	public void test_getSuperclassName() {
		ReflectiveType type = new ReflectiveType(Object.class);
		assertEquals(null, type.getSuperclassName());
	}

	/**
	 * ReflectiveType.getSuperclassName() method test.
	 */
	@Test
	public void test_getSuperclassName1() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		assertEquals("java/lang/Object", new String(type.getSuperclassName()));
	}

	/**
	 * ReflectiveType.getSuperclassName() method test.
	 */
	@Test
	public void test_getSuperclassName2() {
		ReflectiveType type = new ReflectiveType(SimpleInheritingClass.class);
		assertEquals("stx/libjava/tests/mocks/SimpleAbstractClass", new String(
				type.getSuperclassName()));
	}

	/**
	 * ReflectiveType.getFileName() method test.
	 */
	@Test
	public void test_getFileName() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		// returns always null
		assertEquals(null, type.getFileName());
	}

	/**
	 * ReflectiveType.getFileName1() method test.
	 */
	@Test
	public void test_getFileName1() {
		ReflectiveType type = new ReflectiveType(String.class);
		// returns always null
		assertEquals(null, type.getFileName());
	}

	/**
	 * ReflectiveType.getMemberTypes() method test.
	 */
	@Test
	public void test_getMemberTypes() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryNestedType[] memberTypes = type.getMemberTypes();
		assertNull(memberTypes);
	}

	/**
	 * ReflectiveType.getMemberTypes() method test.
	 */
	@Test
	public void test_getMemberTypes1() {
		ReflectiveType type = new ReflectiveType(ClassWithInnerClasses.class);
		IBinaryNestedType[] memberTypes = type.getMemberTypes();
		assertEquals(2, memberTypes.length);
		assertEquals("stx/libjava/tests/mocks/ClassWithInnerClasses$Inner",
				new String(memberTypes[0].getName()));
		assertEquals(
				"stx/libjava/tests/mocks/ClassWithInnerClasses$InnerStatic",
				new String(memberTypes[1].getName()));
	}

	/**
	 * ReflectiveType.getMethods() method test.
	 */
	@Test
	public void test_getMethods() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);

		// there are 23 regular methods + implicit constructor = 24 methods
		IBinaryMethod[] methods = type.getMethods();
		assertEquals(24, methods.length);

		String[] methodsSelectors = { "add2To2000Expect2002", "addMinus5ToArg",
				"multiply", "power", "powerAcc", "div", "negateInt",
				"bitShiftLeft", "bitShiftRight", "division", "inc2", "dec2",
				"unsignedBitShiftRight", "and", "or", "xor",
				"justUseConstants", "isYourStackCreatedCorrectly",
				"isYourStackCreatedCorrectlyEvenWithDoublesAndLongs",
				"sumArray", "sumArrayOfDoubles", "giveMeArrayOfLongs", "main",
				"<init>", };

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
	 * ReflectiveType.getMethods() method test.
	 */
	@Test
	public void test_getMethods1() {
		ReflectiveType type = new ReflectiveType(ClassWithoutMethods.class);

		// there is just one method - implicit constructor
		IBinaryMethod[] methods = type.getMethods();
		assertEquals(1, methods.length);
	}

	/**
	 * ReflectiveType.getFields() method test.
	 */
	@Test
	public void test_getFields() {
		ReflectiveType type = new ReflectiveType(Crate.class);
		IBinaryField[] fields = type.getFields();
		assertEquals(4, fields.length);

		String[] fieldsNames = { "intVar", "doubleVar", "longVar", "stringVar" };

		int flag;
		for (int i = 0; i < fieldsNames.length; i++) {
			flag = 0;
			for (int j = 0; j < fields.length; j++) {
				if (new String(fields[j].getName()).equals(fieldsNames[i])) {
					flag = 1;
					break;
				}
			}
			if (flag == 0) {
				fail("Field not found.");
			}
		}
	}

	/**
	 * ReflectiveType.getFields() method test.
	 */
	@Test
	public void test_getFields1() {
		ReflectiveType type = new ReflectiveType(ClassWithInnerClasses.class);
		IBinaryField[] fields = type.getFields();
		assertNull(fields);
	}

	/**
	 * ReflectiveType.getEnclosingTypeName() method test.
	 */
	@Test
	public void test_getEnclosingTypeName() {
		HighlightingScanner hs = new HighlightingScanner(true, true, true, 0,
				0, null, null, true);
		ReflectiveType type = new ReflectiveType(hs.getClass());
		char[] enclosingTypeName = type.getEnclosingTypeName();
		assertEquals("stx/libjava/tools/text/Highlighter", new String(
				enclosingTypeName));
	}

	/**
	 * ReflectiveType.getEnclosingTypeName() method test.
	 */
	@Test
	public void test_getEnclosingTypeName1() {
		Highlighter h = new Highlighter();
		ReflectiveType type = new ReflectiveType(h.getClass());
		char[] enclosingTypeName = type.getEnclosingTypeName();
		assertEquals(null, enclosingTypeName);
	}

	/**
	 * ReflectiveType.getEnclosingMethod() method test.
	 */
	@Test
	public void test_getEnclosingMethod() {
		// Method m = InnerClasses.class.getDeclaredMethod("method", null);
		// Class[] classArr = InnerClasses.class.getDeclaredClasses();
		// assertEquals(1, classArr.length);

		/*
		 * ReflectiveType type = new ReflectiveType(is.getClass()); //check
		 * char[] enclosingMethod = type.getEnclosingMethod();
		 * assertEquals("method", new String(enclosingMethod));
		 */
	}

	/**
	 * ReflectiveType.getAnnotations() method test.
	 */
	@Test
	public void test_getAnnotations() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryAnnotation[] annotationsArr = type.getAnnotations();

		assertEquals(5, annotationsArr.length);

		String[] classAnnotations = {
				"Lstx/libjava/tests/mocks/EnumValueAnnotation;",
				"Lstx/libjava/tests/mocks/ArrayValueAnnotation;",
				"Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;",
				"Lstx/libjava/tests/mocks/ClassValueAnnotation;",
				"Lstx/libjava/annotation/Package;" };

		int flag;
		for (int i = 0; i < classAnnotations.length; i++) {
			flag = 0;
			for (int j = 0; j < annotationsArr.length; j++) {
				if (new String(annotationsArr[j].getTypeName())
						.equals(classAnnotations[i])) {
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
	 * ReflectiveType.getAnnotations() method test.
	 */
	@Test
	public void test_getAnnotations1() {
		ReflectiveType type = new ReflectiveType(java.lang.Object.class);
		IBinaryAnnotation[] annotationsArr = type.getAnnotations();
		assertNull(annotationsArr);
	}

	/**
	 * ReflectiveType.getInterfaceNames() method test.
	 */
	@Test
	public void test_getInterfaceNames() {
		ReflectiveType type = new ReflectiveType(SimpleInheritingClass.class);
		char[][] interfacesNames = type.getInterfaceNames();
		assertEquals(1, interfacesNames.length);
		assertEquals("stx/libjava/tests/mocks/SimpleInterface", new String(
				interfacesNames[0]));
	}

	/**
	 * ReflectiveType.getInterfaceNames() method test.
	 */
	@Test
	public void test_getInterfaceNames1() {
		ReflectiveType type = new ReflectiveType(Object.class);
		char[][] interfacesNames = type.getInterfaceNames();
		assertNull(interfacesNames);
	}

	/**
	 * ReflectiveType.isMember() method test.
	 */
	@Test
	public void test_isMember() {
		ReflectiveType type = new ReflectiveType(InnerClass1.class);
		assertTrue(type.isMember());
	}

	/**
	 * ReflectiveType.isMember() method test.
	 */
	@Test
	public void test_isMember1() {
		ReflectiveType type = new ReflectiveType(InnerClasses.class);
		assertFalse(type.isMember());
	}

	/**
	 * ReflectiveType.isBinaryType() method test.
	 */
	@Test
	public void test_isBinaryType() {
		ReflectiveType type = new ReflectiveType(InnerClasses.class);
		assertTrue(type.isBinaryType());
	}

	/**
	 * ReflectiveType.isBinaryType() method test.
	 */
	@Test
	public void test_isBinaryType1() {
		ReflectiveType type = new ReflectiveType(Object.class);
		assertTrue(type.isBinaryType());
	}

	/**
	 * ReflectiveType.isBinaryType() method test.
	 */
	@Test
	public void test_isBinaryType2() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		assertTrue(type.isBinaryType());
	}
	
	/**
	 * ReflectiveType.isAnonymous() method test.
	 */
	@Test
	public void test_isAnonymous() {
		ReflectiveType type = new ReflectiveType((new ActionListener() {
			public void actionPerformed(ActionEvent e) { }
		}).getClass());
		
		assertTrue(type.isAnonymous());
	}

	/**
	 * ReflectiveType.isAnonymous() method test.
	 */
	@Test
	public void test_isAnonymous1() {
		ReflectiveType type = new ReflectiveType(Object.class);
		assertEquals(false, type.isAnonymous());
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		int modifiers = type.getModifiers();

		assertEquals(0x0001, modifiers & 0x0001); // public
		assertEquals(0, modifiers & 0x0010); // final
		assertEquals(0, modifiers & 0x0020); // super
		assertEquals(0, modifiers & 0x0200); // interface
		assertEquals(0, modifiers & 0x0400); // abstract
		assertEquals(0, modifiers & 0x1000); // synthetic
		assertEquals(0, modifiers & 0x2000); // annotation
		assertEquals(0, modifiers & 0x4000); // enum
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers1() {
		ReflectiveType type = new ReflectiveType(ArrayValueAnnotation.class);
		int modifiers = type.getModifiers();

		assertEquals(0x0001, modifiers & 0x0001); // public
		assertEquals(0, modifiers & 0x0010); // final
		assertEquals(0, modifiers & 0x0020); // super
		assertEquals(0x0200, modifiers & 0x0200); // interface
		assertEquals(0x0400, modifiers & 0x0400); // abstract
		assertEquals(0, modifiers & 0x1000); // synthetic
		assertEquals(0x2000, modifiers & 0x2000); // annotation
		assertEquals(0, modifiers & 0x4000); // enum
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers2() {

		// todo chceme testnout NonPublicClass - je privátní, jak k ní
		// přistupovat?
		/*
		 * ReflectiveType type = new ReflectiveType(); int modifiers =
		 * type.getModifiers();
		 * 
		 * assertEquals(0, modifiers & 0x0001); // public assertEquals(0,
		 * modifiers & 0x0010); // final assertEquals(0, modifiers & 0x0020); //
		 * super assertEquals(0, modifiers & 0x0200); // interface
		 * assertEquals(0, modifiers & 0x0400); // abstract assertEquals(0,
		 * modifiers & 0x1000); // synthetic assertEquals(0, modifiers &
		 * 0x2000); // annotation assertEquals(0, modifiers & 0x4000); // enum
		 */
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers3() {
		// todo NonPublicInterface
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers4() {
		ReflectiveType type = new ReflectiveType(SimpleAbstractClass.class);
		int modifiers = type.getModifiers();

		assertEquals(0x0001, modifiers & 0x0001); // public
		assertEquals(0, modifiers & 0x0010); // final
		assertEquals(0, modifiers & 0x0020); // super
		assertEquals(0, modifiers & 0x0200); // interface
		assertEquals(0x0400, modifiers & 0x0400); // abstract
		assertEquals(0, modifiers & 0x1000); // synthetic
		assertEquals(0, modifiers & 0x2000); // annotation
		assertEquals(0, modifiers & 0x4000); // enum
	}

	/**
	 * ReflectiveType.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers5() {
		ReflectiveType type = new ReflectiveType(Weather.class);
		int modifiers = type.getModifiers();

		assertEquals(0x0001, modifiers & 0x0001); // public
		assertEquals(0x0010, modifiers & 0x0010); // final
		assertEquals(0, modifiers & 0x0020); // super
		assertEquals(0, modifiers & 0x0200); // interface
		assertEquals(0, modifiers & 0x0400); // abstract
		assertEquals(0, modifiers & 0x1000); // synthetic
		assertEquals(0, modifiers & 0x2000); // annotation
		assertEquals(0x4000, modifiers & 0x4000); // enum
	}

	/**
	 * ReflectiveType.sourceFileName() method test.
	 * 
	 * returns null because there is no source file representing this type
	 */
	@Test
	public void test_sourceFileName() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		assertNull(type.sourceFileName());
	}

	/**
	 * ReflectiveType.sourceFileName() method test
	 * 
	 * returns null because there is no source file representing this type
	 */
	@Test
	public void test_sourceFileName1() {
		ReflectiveType type = new ReflectiveType(Crate.class);
		assertNull(type.sourceFileName());
	}

	/**
	 * ReflectiveType.sourceFileName() method test.
	 * 
	 * returns null because there is no source file representing this type
	 */
	@Test
	public void test_sourceFileName2() {
		ReflectiveType type = new ReflectiveType(Weather.class);
		assertNull(type.sourceFileName());
	}

	/**
	 * ReflectiveType.getMissingTypeNames() method test.
	 * 
	 * Returns null - this is how it's implemented for now
	 */
	@Test
	public void test_getMissingTypeNames() {
		ReflectiveType type = new ReflectiveType(SimpleMath.class);
		assertNull(type.getMissingTypeNames());
	}

	/**
	 * ReflectiveType.getMissingTypeNames() method test.
	 * 
	 * Returns null - this is how it's implemented for now
	 */
	@Test
	public void test_getMissingTypeNames1() {
		ReflectiveType type = new ReflectiveType(Weather.class);
		assertNull(type.getMissingTypeNames());
	}
}
