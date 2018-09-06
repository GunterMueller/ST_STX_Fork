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

import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Field;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryField;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;
import org.eclipse.jdt.internal.compiler.env.IBinaryNestedType;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveType implements org.eclipse.jdt.internal.compiler.env.IBinaryType {

	Class<?> clazz;
	
	final static boolean IGNORE_ANONYMOUS_INNER_CLASSES = true;
	
	final static char[] JAVA_LANG_OBJECT = "java/lang/Object".toCharArray();
	
	// cached answers:
	long tagBits;
	boolean tagBitsValid;
	char[] enclosingMethod;
	char[] enclosingTypeName;
	char[] genericSignature;
	char[] name;
	char[] simpleName;
	char[] superclassName;
	char[][] interfaceNames;
	ReflectiveMethod[] reflMethods;
	ReflectiveNestedType[] reflNestedTypes;
	ReflectiveField[] reflFields;
	ReflectiveAnnotation[] reflAnnotations;
	
	
	public ReflectiveType(Class<?> c) {
		this.clazz = c;
		flushCaches();
	}
	
	public void flushCaches() {
		tagBitsValid = false;
		enclosingMethod = null;
		enclosingTypeName = null;
		genericSignature = null;
		name = null;
		simpleName = null;
		superclassName = null;
		interfaceNames = null;
		reflMethods = null;
		reflNestedTypes = null;
		reflFields = null;
		reflAnnotations = null;
	}

	@Override
	public int getModifiers() {
		return clazz.getModifiers();
	}

	@Override
	public boolean isBinaryType() {
		return true;
	}

	@Override
	public char[] getFileName() {
		// returns null because there is no file representing this type
		return null;
	}

	@Override
	public IBinaryAnnotation[] getAnnotations() {
		if (reflAnnotations != null)
			return reflAnnotations;
		
		Annotation[] annotations = clazz.getDeclaredAnnotations();
		if (annotations.length == 0)
			return null;
		
		reflAnnotations = new ReflectiveAnnotation[annotations.length];
		for (int i = 0; i < annotations.length; i++)
			reflAnnotations[i] = new ReflectiveAnnotation(annotations[i]);
		
		// in order to guarantee consistency between annotations and tag bits
		tagBitsValid = false;
		getTagBits();
		
		return reflAnnotations;
	}

	@Override
	public char[] getEnclosingMethod() {
		if (enclosingMethod != null) {
			return enclosingMethod;
		}
		
		Method em = clazz.getEnclosingMethod();
		Constructor<?> ec = clazz.getEnclosingConstructor();
		
		
		if (em == null && ec == null)
			// this isn't a local or anonymous class within a method/constructor
			return null;
		
		ReflectiveMethod rm;
		if (em != null)
			rm = new ReflectiveMethod(em);
		else 
			rm = new ReflectiveMethod(ec);
		
		char[] sel = rm.getSelector();
		char[] desc = rm.getMethodDescriptor();
		enclosingMethod = new char[sel.length + desc.length];
		System.arraycopy(sel,  0, enclosingMethod,          0, sel.length);
		System.arraycopy(desc, 0, enclosingMethod, sel.length, desc.length);
		return enclosingMethod;
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
	public IBinaryField[] getFields() {
		if (reflFields != null)
			return reflFields;
		
		Field[] fields = clazz.getDeclaredFields();
		if (fields.length == 0)
			return null;
		
		reflFields = new ReflectiveField[fields.length];
		for (int i = 0; i < fields.length; i++)
			reflFields[i] = new ReflectiveField(fields[i]);
		return reflFields;
	}

	@Override
	public char[] getGenericSignature() {
		if (genericSignature != null) {
			return genericSignature;
		}
		
		try {
			Method m = clazz.getClass().getDeclaredMethod("getGenericSignature");
			m.setAccessible(true);
			Object r = m.invoke(clazz);
			if (r == null) {
				return null;
			}
			String signature = (String) r;
			genericSignature = signature.toCharArray();
			return genericSignature;
		} catch (Exception e) {			
			throw new RuntimeException("Unable to get generic signature of "+ clazz.getName() +": " + e.getClass().getName() + ": " + e.getMessage());
		}
	}

	@Override
	public char[][] getInterfaceNames() {
		if (interfaceNames != null) {
			return interfaceNames;
		}
		
		Class<?>[] ifaces = clazz.getInterfaces();
		if (ifaces.length == 0) {
			return null;
		}
		
		interfaceNames = new char[ifaces.length][];
		for (int i = 0; i < ifaces.length; i++) {
			interfaceNames[i] = ifaces[i].getName().replace(".", "/").toCharArray();
		}
		return interfaceNames;
	}

	@Override
	public IBinaryNestedType[] getMemberTypes() {
		if (reflNestedTypes != null)
			return reflNestedTypes;
		
		Class<?>[] nestedTypes = clazz.getDeclaredClasses();
		if (nestedTypes.length == 0)
			return null;
		
		int ignored = 0;
		if (IGNORE_ANONYMOUS_INNER_CLASSES) {
			for (int i = 0; i < nestedTypes.length; i++) {
				if (nestedTypes[i].isAnonymousClass()) {
					nestedTypes[i] = null;
					ignored++;
				}
			}
		}
		
		int nestedTypesToReturn = nestedTypes.length - ignored;
		if (nestedTypesToReturn == 0)
			return null;
		
		reflNestedTypes = new ReflectiveNestedType[nestedTypesToReturn];
		int j = 0;
		for (int i = 0; i < nestedTypes.length; i++) {
			if (nestedTypes[i] != null) {
				reflNestedTypes[j++] = new ReflectiveNestedType(nestedTypes[i]);
			}
		}
		return reflNestedTypes;
	}

	@Override
	public IBinaryMethod[] getMethods() {
		if (reflMethods != null)
			return reflMethods;
		
		Method[] declMethods = clazz.getDeclaredMethods();
		Constructor<?>[] declCtors = clazz.getDeclaredConstructors();
		int methodCnt = declMethods.length;
		int ctorCnt = declCtors.length;
		if (methodCnt == 0 && ctorCnt == 0)
			return null;

		reflMethods = new ReflectiveMethod[methodCnt + ctorCnt];
		for (int i = 0; i < methodCnt; i++) {
			reflMethods[i] = new ReflectiveMethod(declMethods[i]);
		}
		for (int i = 0; i < ctorCnt; i++) {
			reflMethods[methodCnt + i] = new ReflectiveMethod(declCtors[i]);
		}
		return reflMethods;
	}

	@Override
	public char[][][] getMissingTypeNames() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public char[] getName() {
		if (name != null) {
			return name;
		}
		
		name = clazz.getName().replace(".", "/").toCharArray();
		return name;
	}

	@Override
	public char[] getSourceName() {
		if (simpleName != null) {
			return simpleName;
		}
		
		String name = clazz.getSimpleName();
		if (name.equals(""))
			return null;
		simpleName = name.toCharArray();
		return simpleName;
	}

	@Override
	public char[] getSuperclassName() {
		if (superclassName != null) {
			return superclassName;
		}
		
		Class<?> sc = clazz.getSuperclass();
		if (sc == null) {
			if (clazz.getName().equals("java.lang.Object")) {
				return null;
			}
			superclassName = JAVA_LANG_OBJECT;
			return superclassName;
		}			
	
		superclassName = sc.getName().replace(".", "/").toCharArray();
		return superclassName;
	}

	@Override
	public long getTagBits() {
		if (tagBitsValid)
			return tagBits;
		
		tagBits = 0;
		getAnnotations();
		if (reflAnnotations != null) {
			int ignored = 0;
			for (int i = 0; i < reflAnnotations.length; i++) {
				tagBits |= reflAnnotations[i].standardAnnotationTagBits();
				if (reflAnnotations[i].shouldBeIgnored()) {
					reflAnnotations[i] = null;
					ignored++;
				}
			}
		
			if (ignored == reflAnnotations.length) {
				reflAnnotations = null;
			} else if (ignored > 0) {
				ReflectiveAnnotation[] old = reflAnnotations;
				reflAnnotations = new ReflectiveAnnotation[old.length - ignored];
				int iOld = 0;
				for (int iNew = 0; iNew < reflAnnotations.length; iNew++) {
					while (old[iOld] == null)
						iOld++;
					reflAnnotations[iNew] = old[iOld];
				}
			}
		}
		
		tagBitsValid = true;
		return tagBits;
	}

	@Override
	public boolean isAnonymous() {
		return clazz.isAnonymousClass();
	}

	@Override
	public boolean isLocal() {
		return clazz.isLocalClass();
	}

	@Override
	public boolean isMember() {
		return clazz.isMemberClass();
	}

	@Override
	public char[] sourceFileName() {
		// returns null because there is no source file representing this type
		return null;
	}

}
