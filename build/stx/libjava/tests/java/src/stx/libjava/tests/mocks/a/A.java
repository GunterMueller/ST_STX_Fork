package stx.libjava.tests.mocks.a;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class A {
	String method1() {
		return "A.method1()";
	}
	
	public static String callMethod1(A obj) {
		return obj.method1();
	}
	
	public static String callMethod1ViaReflection(A obj) {
		Method m = null;
		try {
			m = A.class.getDeclaredMethod("method1", null);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		try {
			return (String)m.invoke(obj, null);
		} catch (IllegalArgumentException e) {
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			throw new RuntimeException(e);
		}		
	}
}
