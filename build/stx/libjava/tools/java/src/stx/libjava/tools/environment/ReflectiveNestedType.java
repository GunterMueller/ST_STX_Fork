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
package stx.libjava.tools.environment;

import org.eclipse.jdt.internal.compiler.env.IBinaryNestedType;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveNestedType implements IBinaryNestedType {

	Class<?> clazz;
	
	// cached answers:
	char[] enclosingTypeName;
	char[] name;
	
	public ReflectiveNestedType(Class<?> c) {
		clazz = c;
		flushCaches();
	}
	
	public void flushCaches() {
		enclosingTypeName = null;
		name = null;
	}
	
	@Override
	public char[] getEnclosingTypeName() {
		if (enclosingTypeName != null) {
			return enclosingTypeName;
		}
		
		Class<?> ec = clazz.getEnclosingClass();
		if (ec == null)
			return null;
		
		enclosingTypeName =  ec.getName().replace(".", "/").toCharArray();
		return enclosingTypeName;		
	}

	@Override
	public int getModifiers() {
		return clazz.getModifiers();
	}

	@Override
	public char[] getName() {
		if (name != null) {
			return name;
		}
		
		name = clazz.getName().replace(".", "/").toCharArray();
		return name;
	}
	
	public ReflectiveType asReflectiveType() {
		return new ReflectiveType(clazz);
	}

}
