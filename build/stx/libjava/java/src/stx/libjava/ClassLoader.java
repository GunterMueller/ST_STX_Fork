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
package stx.libjava;

/**
 * A specialised ClassLoader to load Smalltalk classes.
 * 
 * @author Jan Vrany
 *
 */

@stx.libjava.annotation.Package("stx:libjava")
public class ClassLoader extends java.lang.ClassLoader {
	
	protected Class<?> findClass(String name) throws ClassNotFoundException {
		if (runningOnStX) 
			return findClassS(name);
		else 
			throw new ClassNotFoundException(name);
	}
	
	protected native Class<?> findClassS(String name) throws ClassNotFoundException;
	
	public static java.lang.ClassLoader getSmalltalkClassLoader() {
		return scl;
	}
	
	protected static boolean runningOnStX = (System.getProperty("java.vm.name").equals("Smalltalk/X"));
	
	protected static ClassLoader scl = new stx.libjava.ClassLoader();
	
	

}
