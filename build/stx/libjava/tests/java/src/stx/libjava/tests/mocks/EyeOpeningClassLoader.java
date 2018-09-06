package stx.libjava.tests.mocks;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class EyeOpeningClassLoader extends ClassLoader {
	private static final int BUFFER_SIZE = 8192;

	protected synchronized Class loadClass(String className, boolean resolve)
			throws ClassNotFoundException {
		Class cls = findLoadedClass(className);
		if (cls != null) {
			return cls;
		}
		String clsFile = className.replace('.', '/') + ".class";

		byte[] classBytes = null;
		try {
			InputStream in = getResourceAsStream(clsFile);
			byte[] buffer = new byte[BUFFER_SIZE];
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			int n = -1;
			while ((n = in.read(buffer, 0, BUFFER_SIZE)) != -1) {
				out.write(buffer, 0, n);
			}
			classBytes = out.toByteArray();
		} catch (IOException e) {
			throw new ClassNotFoundException("Cannot load class: " + className);
		}

		if (classBytes == null) {
			throw new ClassNotFoundException("Cannot load class: " + className);
		}

		try {
			cls = defineClass(className, classBytes, 0, classBytes.length);
			if (resolve) {
				resolveClass(cls);
			}
		} catch (SecurityException e) {
			// loading core java classes such as java.lang.String
			// is prohibited, throws java.lang.SecurityException.
			// delegate to parent if not allowed to load class
			//throw new ClassNotFoundException("Cannot load class: " + className + " because of security restrictions");
			throw new ClassNotFoundException("security restriction");
		}

		return cls;
	}
	
	public void tryToLoadString() {
		defineClass("java.lang.String", null, 0, 0);
	}
	
	public void tryToLoadObject() {
		defineClass("java.lang.Object", null, 0, 0);
	}
	
	public void tryToLoadRuntimeException() {
		defineClass("java.lang.RuntimeException", null, 0, 0);
	}
	
	public void tryToLoadMethod() {
		defineClass("java.lang.reflect.Method", null, 0, 0);
	}
	
	public void tryToLoadDatasource() {
		defineClass("javax.sql.DataSource", null, 0, 0);
	}
	
	public void tryToLoadBits() {
		defineClass("java.io.Bits", null, 0, 0);
	}
	
	public void tryToLoadArray() {
		defineClass("java.lang.Array", null, 0, 0);
	}
}
