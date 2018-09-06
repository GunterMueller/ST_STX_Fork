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
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import java.lang.reflect.Field;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.impl.Constant;
import org.junit.Test;

import stx.libjava.tests.mocks.HeavilyAnnotatedClass;
import stx.libjava.tests.mocks.PublicClass;
import stx.libjava.tools.environment.ReflectiveField;
import stx.libjava.tools.environment.ReflectiveType;
import stx.libjava.tools.environment.tests.mocks.ClassWithoutMethods;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveFieldTests {
	/**
	 * Just for testing purposes
	 */
	public char[][] charArray2;

	/**
	 * ReflectiveField.getConstant() method test.
	 * This method always returns Constant.NotAConstant (for details see 
	 * the comment in the method's source).
	 */
	@Test
	public void test_getConstant() {
		ReflectiveType reflString = new ReflectiveType(new String().getClass());
		ReflectiveField[] reflFields = (ReflectiveField[]) reflString.getFields();
		
		for (ReflectiveField rf : reflFields) {
			Constant rfConst = rf.getConstant();
			assertEquals(Constant.NotAConstant, rfConst);
		}
	}
	
	/**
	 * ReflectiveField.getModifiers() method test.
	 */
	@Test
	public void test_getModifiers() {
		String str = new String();
		Field[] fields = str.getClass().getFields();
		
		for (Field f : fields) {
			ReflectiveField rf = new ReflectiveField(f);
			assertEquals(f.getModifiers(), rf.getModifiers());
		}
	}

	/**
	 * ReflectiveField.getName() method test.
	 */
	@Test
	public void test_getName() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		assertEquals(1, fields.length);
		
		ReflectiveField refField = new ReflectiveField(fields[0]);
		assertEquals("heavilyAnnotatedField", new String(refField.getName()));
	}
	
	/**
	 * ReflectiveField.getName() method test.
	 */
	@Test
	public void test_getName1() {
		Field[] fields = ClassWithoutMethods.class.getFields();
		assertEquals(1, fields.length);
		
		ReflectiveField refField = new ReflectiveField(fields[0]);
		assertEquals("c", new String(refField.getName()));
	}
	
	/**
	 * ReflectiveField.getTypeName() method test.
	 */
	@Test
	public void test_getTypeName() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		assertEquals("Ljava/lang/String;", new String(refField.getTypeName()));
	}
	
	/**
	 * ReflectiveField.getTypeName() method test.
	 */
	@Test
	public void test_getTypeName1() {
		Field field = null;
		try {
			field = String.class.getDeclaredField("hash");
		} catch (Exception e) {
			fail("An exception shouldn't be thrown");
		} 
		ReflectiveField refField = new ReflectiveField(field);
		assertEquals("I", new String(refField.getTypeName()));
	}	
	
	/**
	 * ReflectiveField.getTypeName() method test.
	 */
	@Test
	public void test_getTypeName2() {
		Field field = null;
		try {
			field = String.class.getDeclaredField("value");
		} catch (Exception e) {
			fail("An exception shouldn't be thrown");
		} 
		ReflectiveField refField = new ReflectiveField(field);
		assertEquals("[C", new String(refField.getTypeName()));
	}	
	
	/**
	 * ReflectiveField.getTypeName() method test.
	 */
	@Test
	public void test_getTypeName3() {
		Field field = null;
		try {
			field = ReflectiveField.class.getDeclaredField("tagBitsValid");
		} catch (Exception e) {
			fail("An exception shouldn't be thrown");
		} 
		ReflectiveField refField = new ReflectiveField(field);
		assertEquals("Z", new String(refField.getTypeName()));
	}	
	
	/**
	 * ReflectiveField.getTypeName() method test.
	 */
	@Test
	public void test_getTypeName4() {
		Field field = null;
		try {
			field = ReflectiveField.class.getDeclaredField("tagBits");
		} catch (Exception e) {
			fail("An exception shouldn't be thrown");
		} 
		ReflectiveField refField = new ReflectiveField(field);
		assertEquals("J", new String(refField.getTypeName()));
	}	

	@Test
	public void test_getTypeName05() {
		Field field = null;
		try {
			field = this.getClass().getDeclaredField("charArray2");
		} catch (Exception e) {
			fail("An exception shouldn't be thrown");
		} 
		ReflectiveField refField = new ReflectiveField(field);
		assertEquals("[[C", new String(refField.getTypeName()));
	}	

	
	
	/**
	 * ReflectiveField.getAnnotations() method test.
	 */
	@Test
	public void test_getAnnotations() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();
		assertEquals(4, annotationsArr.length);
		
		String[] fieldAnnotations= {		
				"Lstx/libjava/tests/mocks/EnumValueAnnotation;",
				"Lstx/libjava/tests/mocks/ArrayValueAnnotation;",
				"Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;",
				"Lstx/libjava/tests/mocks/ClassValueAnnotation;",
				};
				
		int flag;
		for (int i = 0; i < fieldAnnotations.length; i++){
			flag = 0;
			for (int j = 0; j < annotationsArr.length; j++){
				if (new String(annotationsArr[j].getTypeName()).equals(fieldAnnotations[i])){
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
	 * ReflectiveField.getAnnotations() method test.
	 */
	@Test
	public void test_getAnnotations1() {
		Field[] fields = PublicClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();
		assertNull(annotationsArr);
	}
	
	
}
