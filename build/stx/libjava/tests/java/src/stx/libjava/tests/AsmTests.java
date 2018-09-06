package stx.libjava.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.junit.Test;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.ClassVisitor;

import org.objectweb.asm.Opcodes;

import stx.libjava.tests.mocks.asm.AddFieldAdapter;
import stx.libjava.tests.mocks.asm.HelloWorldGenerator;
import stx.libjava.tests.mocks.Crate;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class AsmTests implements Opcodes {

	@Test
	public void testGeneratingHelloWorldClass() throws Exception {
		byte[] generatedClass = HelloWorldGenerator.generate();
		Class loadedClass = loadClass("HelloWorld", generatedClass);
		Object instance = loadedClass.getConstructor(String.class).newInstance("MH");
		Method m = loadedClass.getDeclaredMethod("getHello", null);
		Object resultObj = m.invoke(instance, null);
		String expectedResult = "Hello World from MH";
		String result =(String) resultObj;
		assertEquals(expectedResult, result);	
	}
	
	@Test
	public void testAddingFieldToCrate() throws Exception {
		ClassReader cr = new ClassReader("stx.libjava.tests.mocks.Crate");
		ClassWriter cw = new ClassWriter(0);
		AddFieldAdapter added = new AddFieldAdapter(cw, ACC_PUBLIC, "addedField", "Ljava/lang/String;");
		cr.accept((ClassVisitor)added, 0);
		byte[] generatedClass = cw.toByteArray();
		Class loadedClass = loadClass("stx.libjava.tests.mocks.Crate", generatedClass);
		assertNotNull("testing updated class not null",loadedClass);
		boolean addedFieldPresent = false;
		for (Field f : loadedClass.getDeclaredFields()) {
			if (f.getName().equals("addedField")) {
				addedFieldPresent = true;
			}
		}
		assertTrue("testing correct updated class creation",addedFieldPresent);
		addedFieldPresent = false;
		for (Field f : Crate.class.getDeclaredFields()) {
			if (f.getName().equals("addedField")) {
				addedFieldPresent = true;
			}
		}
		assertTrue("testing hot redeploy of changed class",addedFieldPresent);
	}

	private Class loadClass(String name, byte[] b) {
		// override classDefine (as it is protected) and define the class.
		Class clazz = null;
		try {
			ClassLoader loader = ClassLoader.getSystemClassLoader();
			Class cls = Class.forName("java.lang.ClassLoader");
			Method method = cls.getDeclaredMethod("defineClass", new Class[] {
					String.class, byte[].class, int.class, int.class });

			// protected method invocaton
			method.setAccessible(true);
			try {
				Object[] args = new Object[] { name, b, new Integer(0),
						new Integer(b.length) };
				clazz = (Class) method.invoke(loader, args);
			} finally {
				method.setAccessible(false);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
		return clazz;
	}

}
