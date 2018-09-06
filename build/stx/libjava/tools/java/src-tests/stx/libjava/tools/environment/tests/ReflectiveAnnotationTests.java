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
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.eclipse.jdt.internal.compiler.env.ClassSignature;
import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryElementValuePair;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;
import org.eclipse.jdt.internal.compiler.impl.DoubleConstant;
import org.eclipse.jdt.internal.compiler.impl.IntConstant;
import org.eclipse.jdt.internal.compiler.impl.StringConstant;
import org.junit.Test;

import stx.libjava.tests.mocks.EnumValueAnnotation;
import stx.libjava.tests.mocks.HeavilyAnnotatedClass;
import stx.libjava.tools.environment.ReflectiveAnnotation;
import stx.libjava.tools.environment.ReflectiveField;
import stx.libjava.tools.environment.ReflectiveType;

public class ReflectiveAnnotationTests {

	/**
	 * ReflectiveAnnotation.getTypeName() method test.
	 * Check class annotations
	 */
	@Test
	public void test_getTypeName() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryAnnotation[] annotationsArr = type.getAnnotations();
		assertEquals(5, annotationsArr.length);

		String[] classAnnotations= {		
				"Lstx/libjava/tests/mocks/EnumValueAnnotation;",
				"Lstx/libjava/tests/mocks/ArrayValueAnnotation;",
				"Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;",
				"Lstx/libjava/tests/mocks/ClassValueAnnotation;",
				"Lstx/libjava/annotation/Package;"
				};
				
		int flag;
		for (int i = 0; i < classAnnotations.length; i++){
			flag = 0;
			for (int j = 0; j < annotationsArr.length; j++){
				if (new String(annotationsArr[j].getTypeName()).equals(classAnnotations[i])){
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
	 * ReflectiveAnnotation.getTypeName() method test.
	 * Check method annotations
	 */
	@Test
	public void test_getTypeName1() {
		ReflectiveType type = new ReflectiveType(HeavilyAnnotatedClass.class);
		IBinaryMethod[] methodsArr = type.getMethods();
		
		String methodName = "heavilyAnnotatedMethod";
		for (int k = 0; k < methodsArr.length; k++){
			if (new String(methodsArr[k].getSelector()).equals(methodName)){
					IBinaryAnnotation[] annotationsArr = methodsArr[k].getAnnotations();
					assertEquals(4, annotationsArr.length);
					
					String[] methodAnnotations= {		
							"Lstx/libjava/tests/mocks/EnumValueAnnotation;",
							"Lstx/libjava/tests/mocks/ArrayValueAnnotation;",
							"Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;",
							"Lstx/libjava/tests/mocks/ClassValueAnnotation;",
							};
							
					int flag;
					for (int i = 0; i < methodAnnotations.length; i++){
						flag = 0;
						for (int j = 0; j < annotationsArr.length; j++){
							if (new String(annotationsArr[j].getTypeName()).equals(methodAnnotations[i])){
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
	 * ReflectiveAnnotation.getTypeName() method test.
	 * Check field annotations
	 */
	@Test
	public void test_getTypeName2() {
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
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 */
	@Test
	public void test_getElementValuePairs() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();
		assertEquals(4, annotationsArr.length);
	}
		
	/**
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 * Check "@EnumValueAnnotation(Weather.CLOUDY)" annotation
	 */
	@Test
	public void test_getElementValuePairs1() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();

		int flag = 0;
		for (int i = 0; i < annotationsArr.length; i++){
			flag = 0;
			if (new String(annotationsArr[i].getTypeName()).equals("Lstx/libjava/tests/mocks/EnumValueAnnotation;")){
				flag = 1;
				IBinaryElementValuePair[] evp = annotationsArr[i].getElementValuePairs();
				assertEquals("value", new String(evp[0].getName()));
				assertEquals("Lstx/libjava/tests/mocks/Weather;.CLOUDY", evp[0].getValue().toString());
				break;
			}
		}
		if (flag == 0) {
			fail("Annotation not found.");
		}
	}
	
	/**
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 * Check "@ArrayValueAnnotation(whatILikeInSTX = "Changeset")" annotation
	 */
	@Test
	public void test_getElementValuePairs2() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();

		int flag = 0;
		for (int i = 0; i < annotationsArr.length; i++){
			flag = 0;
			if (new String(annotationsArr[i].getTypeName()).equals("Lstx/libjava/tests/mocks/ArrayValueAnnotation;")){
				flag = 1;
			
				IBinaryElementValuePair[] evpArr = annotationsArr[i].getElementValuePairs();
				assertEquals("whatILikeInSTX", new String(evpArr[0].getName()));
				assertTrue(evpArr[0].getValue().getClass().isArray());			
				Object[] valueAsArray = (Object[]) evpArr[0].getValue();			
				assertEquals(1, valueAsArray.length);
				assertEquals(StringConstant.class, valueAsArray[0].getClass());		
				assertEquals(StringConstant.fromValue("Changeset"), valueAsArray[0]);
				break;
			}
		}
		if (flag == 0) {
			fail("Annotation not found.");
		}
	}
	
	/**
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 * Check "@PrimitiveValueAnnotation(ratio = 5.5, size = 5, value = "Hello world")" annotation
	 */
	@Test
	public void test_getElementValuePairs3() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();
		int count = 0;
		
		for (int i = 0; i < annotationsArr.length; i++){
			if (new String(annotationsArr[i].getTypeName()).equals("Lstx/libjava/tests/mocks/PrimitiveValueAnnotation;")){
				IBinaryElementValuePair[] evpArr = annotationsArr[i].getElementValuePairs();
								
				for (int j = 0; j < evpArr.length; j++){
					if (new String(evpArr[j].getName()).equals("ratio")) {
						count++;
						assertEquals("ratio", new String(evpArr[j].getName()));
						assertEquals(DoubleConstant.class, evpArr[j].getValue().getClass());		
						assertEquals(DoubleConstant.fromValue(5.5), evpArr[j].getValue());
					}
					else if (new String(evpArr[j].getName()).equals("size")) {
						count++;
						assertEquals("size", new String(evpArr[j].getName()));
						assertEquals(IntConstant.class, evpArr[j].getValue().getClass());		
						assertEquals(IntConstant.fromValue(5), evpArr[j].getValue());
					}
					else if (new String(evpArr[j].getName()).equals("value")) {
						count++;
						assertEquals("value", new String(evpArr[j].getName()));	
						assertEquals(StringConstant.class, evpArr[j].getValue().getClass());		
						assertEquals(StringConstant.fromValue("Hello world"), evpArr[j].getValue());
					}
				}
			}
		}
		if (count != 3) {
			fail("Annotation not found.");
		}
	}
	
	/**
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 * Check "@ClassValueAnnotation(myFavouriteJavaLangClass = java.lang.String.class)" annotation
	 */
	@Test
	public void test_getElementValuePairs4() {
		Field[] fields = HeavilyAnnotatedClass.class.getFields();
		ReflectiveField refField = new ReflectiveField(fields[0]);
		
		IBinaryAnnotation[] annotationsArr = refField.getAnnotations();

		int flag = 0;
		for (int i = 0; i < annotationsArr.length; i++){
			flag = 0;
			if (new String(annotationsArr[i].getTypeName()).equals("Lstx/libjava/tests/mocks/ClassValueAnnotation;")){
				flag = 1;
				IBinaryElementValuePair[] evpArr = annotationsArr[i].getElementValuePairs();
				assertEquals("myFavouriteJavaLangClass", new String(evpArr[0].getName()));
				assertEquals(new ClassSignature("Ljava/lang/String;".toCharArray()), evpArr[0].getValue());
				break;
			}
		}
		if (flag == 0) {
			fail("Annotation not found.");
		}
	}
	
	/**
	 * ReflectiveAnnotation.getElementValuePairs() method test.
	 */
	@Test
	public void test_getElementValuePairs5() {
		Method meth = null;
		
		try {
			meth = HeavilyAnnotatedClass.class.getDeclaredMethod("heavilyAnnotatedMethod", String.class);
		} catch (Exception e) {
			fail();
		}
		
		Annotation annot = meth.getAnnotation(EnumValueAnnotation.class);
		ReflectiveAnnotation refAnnot = new ReflectiveAnnotation(annot);
		assertEquals(0, refAnnot.getElementValuePairs().length);
	}
	
	/**
	 * ReflectiveAnnotation.shouldBeIgnored() method test.
	 * 
	 * This test assumes that we want to ignore the "standard" annotations 
	 * (i.e. the ReflectiveAnnotation's static variable IGNORE_STD_ANNOTATIONS
	 * is set to true) which seems to be the correct implementation since
	 * ClassFileReader behaves the same way.
	 * 
	 */
	/*@Test
	public void test_shouldBeIgnored() {
		ReflectiveType rt = new ReflectiveType(ClassWithStdAnnotations.class);
		
		ReflectiveAnnotation[] raArr = (ReflectiveAnnotation[]) rt.getAnnotations();
		
		assertNotNull(raArr);
		assertEquals(2, raArr.length);
		for (ReflectiveAnnotation ra : raArr){
			assertTrue(ra.shouldBeIgnored());
		}
	}
	*/
}

