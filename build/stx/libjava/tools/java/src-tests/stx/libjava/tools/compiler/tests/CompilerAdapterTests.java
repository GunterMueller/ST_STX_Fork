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
package stx.libjava.tools.compiler.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.reflect.InvocationTargetException;

import org.eclipse.jdt.internal.compiler.ClassFile;
import org.junit.Test;

import stx.libjava.tools.compiler.CompileError;
import stx.libjava.tools.compiler.CompilerAdapter;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class CompilerAdapterTests {
	
	protected class ClassLoader extends java.lang.ClassLoader {
		
		public ClassLoader() {
			this(ClassLoader.getSystemClassLoader());			
		}
		
		public ClassLoader(java.lang.ClassLoader parent) {
			super(parent);			
		}
		
		@SuppressWarnings("deprecation")
		public Class<?> load(byte[] classfile) {
			return this.defineClass(classfile, 0, classfile.length);
		}
	}

	/**
	 * Tests compilation of an incomplete class
	 */
	@Test
	public void test_02() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
		
				
		c.compile("package test.pkg; public class Foo { public void f() { g(); } }");		
		ClassFile[] classfiles = c.getResult().getClassFiles();
		
		assertEquals(1, classfiles.length);
		
		Class<?> fooClass = l.load(classfiles[0].getBytes());
		
		assertEquals("test.pkg.Foo" , fooClass.getName());
		assertEquals(1, fooClass.getDeclaredMethods().length);
		
		try {
			fooClass.getMethod("f").invoke(fooClass.newInstance());
			fail();		
		} catch (InvocationTargetException ite) {
			assertTrue(ite.getCause() instanceof Error);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail();		
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail();		
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail();		
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail();		
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail();		
		}
	}

	/**
	 * Tests compilation of depending classes
	 */
	@Test
	public void test_03() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("package test.pkg; public class Foo { public void f() {  } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		
		c.compile("package test.pkg; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		
	}

	@Test
	public void test_04() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("package test.pkg; import static java.lang.System.*; public class Foo {}");
		
		assertFalse(c.getResult().hasErrors());
		
		ClassFile[] classfiles = c.getResult().getClassFiles();
		
		assertEquals(1, classfiles.length);
		
		Class<?> clazz = l.load(classfiles[0].getBytes());
		
		assertEquals("test.pkg.Foo" , clazz.getName());
	}
	
	/**
	 * Tests compilation of depending classes
	 */
	@Test
	public void test_03b() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c1 = new CompilerAdapter(l);
				
		c1.compile("package test.pkg; public class Foo { public void f() {  } }");
		assertEquals(1, c1.getClassFiles().length);
		assertFalse(c1.getResult().hasErrors());
		l.load(c1.getResult().getClassFiles()[0].getBytes());
		
		CompilerAdapter c2 = new CompilerAdapter(l);
		c2.compile("package test.pkg; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c2.getClassFiles().length);
		assertFalse(c2.getResult().hasErrors());
		
	}

	@Test
	public void test_05() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c1 = new CompilerAdapter(l);
				
		c1.compile("public class Foo { public int f() { return");
		assertEquals(1, c1.getClassFiles().length);
		assertTrue(c1.getResult().hasSyntaxError);
	}
	
	@Test
    public void test_06() {
        ClassLoader l = new ClassLoader();
        CompilerAdapter c = new CompilerAdapter(l);
                
        c.compile("public class Foo { public int f() { return Dummy.getInt(); } }");
        assertEquals(1, c.getClassFiles().length);
        assertEquals(1, c.getResult().problemCount);
        assertTrue(c.getResult().problems[0].getMessage().contains("Dummy"));
        
        Class<?> clazz = l.load(c.getResult().getClassFiles()[0].getBytes());
        try {
            clazz.getMethod("f", new Class[0]).invoke(clazz.newInstance());
            fail();
        } catch (IllegalArgumentException e) {
        	fail();
        } catch (SecurityException e) {
        	fail();
        } catch (IllegalAccessException e) {
        	fail();
        } catch (InvocationTargetException e) {
            assertEquals(CompileError.class, e.getTargetException().getClass());
        } catch (NoSuchMethodException e) {
        	fail();
        } catch (InstantiationException e) {
        	fail();
        } catch (java.lang.Error e) {
        	fail();
        }
                 
    }
	
	
	/**
	 * Tests compilation of depending classes in packages with capital class name 
	 */
	@Test
	public void test_07a() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("package test.Pkg; public class Foo { public void f() {  } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		l.load(c.getClassFiles()[0].getBytes());
		
		c.compile("package test.Pkg; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		
	}
	
	/**
	 * Tests compilation of depending classes in packages with capital class name 
	 */
	@Test
	public void test_07b() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("package test.Pkg.A; public class Foo { public void f() {  } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		l.load(c.getClassFiles()[0].getBytes());
		
		c.compile("package test.Pkg.B; public class Bar { public void f() { new test.Pkg.A.Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		l.load(c.getClassFiles()[0].getBytes());
		
		c.compile("package test.Pkg.C; import test.Pkg.A.*; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		l.load(c.getClassFiles()[0].getBytes());
		
		c.compile("package test.Pkg.D; import test.Pkg.A.Foo; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
		l.load(c.getClassFiles()[0].getBytes());
		
		c.compile("package test.Pkg.E; import test.Pkg.X.*; public class Bar { public void f() { new Foo(); } }");
		assertEquals(1, c.getClassFiles().length);
		assertTrue(c.getResult().hasErrors());
		
	}
	
	/**
	 * Regression tests - test compilation of class using ArrayList. 
	 * There used to be an error in IBinaryMethod#getGenericSignature(). 
	 */
	@Test
	public void test_08a() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("package test08; import java.util.ArrayList; public class Foo { public void f() { ArrayList<String> l = new ArrayList<String>(10); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
	}
	
	/**
	 * Regression test - test compilation of class using ArrayList. 
	 * There used to be an error in IBinaryMethod#getGenericSignature(). 
	 */
	@Test
	public void test_08b() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
				
		c.compile("import java.util.ArrayList; public class Foo { public void f() { ArrayList<String> l = new ArrayList<String>(10); } }");
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
	}
	
	/**
	 * Regression test - test compilation of an annotation with retention
	 * RUNTIME. There used to be a bug causing the annotation to be
	 * runtime invisible.
	 */
	@Test
    public void test_09() {
        ClassLoader l = new ClassLoader();
        CompilerAdapter c = new CompilerAdapter(l);
        
                
        c.compile("package test.pkg; " +
                  "@java.lang.annotation.Retention(java.lang.annotation.RetentionPolicy.RUNTIME)" + 
        		  "public @interface Foo {}");
        
        assertFalse(c.getResult().hasErrors());
        
        ClassFile[] classfiles = c.getResult().getClassFiles();
        
        assertEquals(1, classfiles.length);
        
        Class<?> clazz = l.load(classfiles[0].getBytes());
        Retention retention = clazz.getAnnotation(Retention.class);
        
        assertNotNull(retention);
        assertEquals(RetentionPolicy.RUNTIME, retention.value());
        
    }
	
	@Test
	public void test_10() {
        ClassLoader l = new ClassLoader();
        CompilerAdapter c = new CompilerAdapter(l);
                
        c.compile("public class Foo { public void f() {  } }");
        assertEquals(1, c.getClassFiles().length);
        assertFalse(c.getResult().hasErrors());
        l.load(c.getClassFiles()[0].getBytes());
        
        c.compile("public class Bar { public void f() { new Foo(); } }");
        assertEquals(1, c.getClassFiles().length);
        assertFalse(c.getResult().hasErrors());
	}

	/**
	 * Tests compilation of depending classes
	 */
	@Test
	public void test_regression_org_junit_Test_annotation_defaults() {
		ClassLoader l = new ClassLoader();
		CompilerAdapter c = new CompilerAdapter(l);
		String source = "package stx.libjava.tests.vm;import org.junit.Test;public class X {@Test public void xestShiftingLong() { } }"; 

				
		c.compile(source);
		assertEquals(1, c.getClassFiles().length);
		assertFalse(c.getResult().hasErrors());
				
	}
}
