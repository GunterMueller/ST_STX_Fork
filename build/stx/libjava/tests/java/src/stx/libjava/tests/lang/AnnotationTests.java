package stx.libjava.tests.lang;

import org.junit.Test;
import stx.libjava.tests.mocks.EnumValueAnnotation;
import stx.libjava.tests.mocks.HeavilyAnnotatedClass;
import stx.libjava.tests.mocks.Weather;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URLClassLoader;
import java.util.List;

import javax.xml.bind.annotation.XmlElement; // get some nice annotations
import javax.xml.bind.annotation.XmlElements;// get some nice annotations

import static org.junit.Assert.assertTrue;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class AnnotationTests {

    @Test
    public void testClassAnnotations() {
        Annotation[] annotations = HeavilyAnnotatedClass.class.getAnnotations();
        for (Annotation a : annotations) {
            System.out.println(a.annotationType());
        }
        assertTrue(annotations.length == 5);
    }

    @Test
    public void testFieldAnnotations() throws Exception {
        Field field = new HeavilyAnnotatedClass().getClass().getDeclaredField("heavilyAnnotatedField");
        Annotation[] annotations = field.getAnnotations();
        for (Annotation a : annotations) {
            System.out.println(a.annotationType());
        }
        assertTrue(annotations.length == 4);
    }

    @Test
    public void testMethodAnnotations() throws Exception {
        Method method = new HeavilyAnnotatedClass().getClass().getDeclaredMethod("heavilyAnnotatedMethod", String.class);
        Annotation[] annotations = method.getAnnotations();
        for (Annotation a : annotations) {
            System.out.println(a.annotationType());
        }
        assertTrue(annotations.length == 4);
    }

    @Test
    public void testConstructorAnnotations() throws Exception {
        Constructor ctor = new HeavilyAnnotatedClass().getClass().getDeclaredConstructor(String.class);
        Method method = ctor.getClass().getDeclaredMethod("getRawParameterAnnotations");
        method.setAccessible(true);
        byte[] rawParamAnnotations = (byte[]) method.invoke(ctor);
        assertTrue(rawParamAnnotations.length == 14);
    }

    @Test
    public void testConstructorParamAnnotations() throws Exception {
        Constructor ctor = new HeavilyAnnotatedClass().getClass().getDeclaredConstructor(String.class);
        Annotation[][] parameterAnnotations = ctor.getParameterAnnotations();
        Class[] parameterTypes = ctor.getParameterTypes();

        int i = 0;
        for (Annotation[] annotations : parameterAnnotations) {
            Class parameterType = parameterTypes[i++];
            for (Annotation annotation : annotations) {
                assertTrue(annotation instanceof EnumValueAnnotation);
                EnumValueAnnotation myAnnotation = (EnumValueAnnotation) annotation;
                assertTrue(myAnnotation.value().equals(Weather.SUNNY));
            }
        }
    }

    @Test
    public void testMethodParamAnnotations() throws Exception {
        Method method = new HeavilyAnnotatedClass().getClass().getDeclaredMethod("heavilyAnnotatedMethod", String.class);
        Annotation[][] parameterAnnotations = method.getParameterAnnotations();
        Class[] parameterTypes = method.getParameterTypes();

        int i = 0;
        for (Annotation[] annotations : parameterAnnotations) {
            Class parameterType = parameterTypes[i++];

            for (Annotation annotation : annotations) {
                assertTrue(annotation instanceof EnumValueAnnotation);
                EnumValueAnnotation myAnnotation = (EnumValueAnnotation) annotation;
                assertTrue(myAnnotation.value().equals(Weather.SUNNY));
            }
        }
    }

    @Test
    public void testNestedAnnotations() {
    	/* Load the class from different directory - because if classreader
    	 * broken, then the test suite will fail to load, which should be avoided
    	 */
    	try {
    		ClassLoader cl = new URLClassLoader(ClassLoaderTests.getTestClassesDirectory());
    		Class classWithNestedAnnotations = cl.loadClass("ClassWithNestedAnnotations");
    		assertTrue(true); // at least, it reads
    	} catch (Exception e) {
    		e.printStackTrace();
    		assertTrue("Got exception: " + e.getMessage(), false);
    	}



    }



}
