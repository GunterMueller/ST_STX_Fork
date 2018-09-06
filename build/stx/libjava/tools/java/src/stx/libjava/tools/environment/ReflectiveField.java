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
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryField;
import org.eclipse.jdt.internal.compiler.impl.Constant;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveField implements IBinaryField {

	Field field;
	
	// cached answers:
	long tagBits;
	boolean tagBitsValid;
	char[] genericSignature;
	char[] name;
	char[] typeName;
	ReflectiveAnnotation[] reflAnnotations;
	
	public ReflectiveField(Field f) {
		field = f;
		flushCaches();
	}
	
	public void flushCaches() {
		tagBitsValid = false;
		name = null;
		typeName = null;
		genericSignature = null;
		reflAnnotations = null;
	}
	
	@Override
	public int getModifiers() {
		return field.getModifiers();
	}

	@Override
	public IBinaryAnnotation[] getAnnotations() {
		if (reflAnnotations != null)
			return reflAnnotations;
		
		Annotation[] annotations = field.getDeclaredAnnotations();
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
	public Constant getConstant() {
		/* As we have no .class file ready and as Java reflection we have no other
		 * chance than to return NotAConstant.
		 * 
		 * An obvious solution to look at value of static final fields and return
		 * this does not work for some static final fields are assigned in static
		 * initializer (such as String.HASHING_SEED).		 
		 */
		return Constant.NotAConstant;
	}

	@Override
	public char[] getGenericSignature() {	
		if (genericSignature != null) {
			return null;
		}
		
		try {
			Method m = field.getClass().getDeclaredMethod("getGenericSignature");
			m.setAccessible(true);
			Object r = m.invoke(field);
			if (r == null) {
				return null;
			}
			String signature = (String) r;
			genericSignature = signature.toCharArray();
			return genericSignature;
		} catch (Exception e) {
			throw new RuntimeException("Unable to get generic signature.");
		}
	}

	@Override
	public char[] getName() {
		if (name != null)
			return name;
		
		name = field.getName().toCharArray();
		return name;
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
	public char[] getTypeName() {
		if (typeName != null)
			return typeName;
		
		Class<?> type = field.getType();
		typeName = ReflectiveUtils.getFieldDescriptor(type).toCharArray();
		return typeName;
	}
}
