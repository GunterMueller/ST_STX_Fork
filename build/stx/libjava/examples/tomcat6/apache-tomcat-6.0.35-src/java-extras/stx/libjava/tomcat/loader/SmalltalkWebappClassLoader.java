package stx.libjava.tomcat.loader;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.apache.catalina.loader.WebappClassLoader;

/**
 * @author Jan Vrany
 *
 */
public class SmalltalkWebappClassLoader extends WebappClassLoader {

	ClassLoader stcl;

	public SmalltalkWebappClassLoader() {
		init();
	}

	public SmalltalkWebappClassLoader(ClassLoader parent) {
		super(parent);
		init();
	}

	protected void init() {
		try {
			Class sclClass = (Class) Class.forName("stx.libjava.ClassLoader");
			Method m = sclClass.getMethod("getSmalltalkClassLoader", new Class[0]);
			stcl = (ClassLoader) m.invoke(null, new Object[0]);
		} catch (ClassNotFoundException e1) {
			// Not running under stx:libjava?
			stcl = null;
		} catch (IllegalArgumentException e) {
			throw new RuntimeException(
					"Cannot initialize smalltalk classloader", e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException(
					"Cannot initialize smalltalk classloader", e);
		} catch (InvocationTargetException e) {
			throw new RuntimeException(
					"Cannot initialize smalltalk classloader", e);
		} catch (SecurityException e) {
			throw new RuntimeException(
					"Cannot initialize smalltalk classloader", e);
		} catch (NoSuchMethodException e) {
			throw new RuntimeException(
					"Cannot initialize smalltalk classloader", e);
		}

	}

	public Class findClass(String name) throws ClassNotFoundException {
		if ((stcl != null) && (name.startsWith("SMALLTALK."))) {
			return stcl.loadClass(name);
		} else {
			return super.findClass(name);
		}
	}

}
