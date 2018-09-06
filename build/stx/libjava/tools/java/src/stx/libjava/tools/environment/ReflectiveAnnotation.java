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
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryElementValuePair;
import org.eclipse.jdt.internal.compiler.lookup.TagBits;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveAnnotation implements IBinaryAnnotation {

	Annotation annotation;
	
	// cached answers:
	char[] typeName;	
	ReflectiveElementValuePair[] elementValuePairs;
	
	// for every element-value pair an Annotation.annotationType() has a method
	// but there are also methods that don't represent an element-value
	// pair (the inherited methods equals(), toString(), hashCode() and 
	// annotationType()) and these should be ignored:
	static final List<String> METHODS_TO_IGNORE = 
			Arrays.asList("equals", "toString", "hashCode", "annotationType");
	
	static final boolean IGNORE_STD_ANNOTATIONS = true;
	
	// annotations with supported tag bits:
	// (annotations not mentioned here don't have any tag bits set and used)
	static final HashMap<Class<? extends Annotation>, Long> ANNOTATIONTYPE2TAGBITS_MAP;	
	static {
		ANNOTATIONTYPE2TAGBITS_MAP = new HashMap<Class<? extends Annotation>, Long>();
		
		ANNOTATIONTYPE2TAGBITS_MAP.put(java.lang.Deprecated.class, TagBits.AnnotationDeprecated);		
		ANNOTATIONTYPE2TAGBITS_MAP.put(java.lang.Override.class, TagBits.AnnotationOverride);		
		ANNOTATIONTYPE2TAGBITS_MAP.put(java.lang.SuppressWarnings.class, TagBits.AnnotationSuppressWarnings);
		
		try {
			Class<? extends Annotation> klass = (Class<? extends Annotation>) Class.forName("java.lang.SafeVarargs");
			ANNOTATIONTYPE2TAGBITS_MAP.put(klass, TagBits.AnnotationSafeVarargs);
		} catch (ClassNotFoundException cnfe) {
			// Ignore it, perhaps running on JDK6 which has no SafeVarags
		}
		
		ANNOTATIONTYPE2TAGBITS_MAP.put(java.lang.annotation.Documented.class, TagBits.AnnotationDocumented);
		ANNOTATIONTYPE2TAGBITS_MAP.put(java.lang.annotation.Inherited.class, TagBits.AnnotationInherited);
	}
	
	public ReflectiveAnnotation(Annotation annot) {
		annotation = annot;
		flushCaches();
	}
	
	public void flushCaches() {
		typeName = null;
		elementValuePairs = null;
	}
	
	@Override
	public char[] getTypeName() {
		if (typeName != null)
			return typeName;
		
		Class<? extends Annotation> c = annotation.annotationType();		
		typeName = ReflectiveUtils.getFieldDescriptor(c).toCharArray();
		return typeName;
	}

	@Override
	public IBinaryElementValuePair[] getElementValuePairs() {
		if (elementValuePairs != null) 
			return elementValuePairs;
		
		// for every element-value pair there is a method
		Method[] annotMethods = annotation.annotationType().getMethods();	
		// some methods are supposed to be ignored though since they don't
		// represent any annotation's element - these are in METHODS_TO_IGNORE
		int pairsCnt = annotMethods.length - METHODS_TO_IGNORE.size();
		elementValuePairs = new ReflectiveElementValuePair[pairsCnt];

		int pairIndex = 0;
		for (Method annotationMethod : annotMethods) {	
			String name = annotationMethod.getName();
			if (METHODS_TO_IGNORE.contains(name))
				continue;
			
			Object value;
			try {
				// get the method (representing an element-value pair) from the proxy class
				Class<?> proxy = annotation.getClass();
				Method methodToInvoke = proxy.getMethod(name);
				
				// get the value and if it doesn't have its default value, add the pair 
				value = methodToInvoke.invoke(annotation);
				Object defaultValue = annotation.annotationType().getMethod(name).getDefaultValue();
				if (!value.equals(defaultValue)) {
					// convert value to its constant form if possible
					Object valueConstant = ReflectiveUtils.getXConstant(value);
					if (valueConstant != null)
						value = valueConstant;
					
					// the name of the method corresponds with the name of the element
					elementValuePairs[pairIndex++] = 
							new ReflectiveElementValuePair(name.toCharArray(), value);
				}
			} catch (Exception e) {
				throw new RuntimeException("Couldn't get value for " + name);
			}
		}
		if (pairIndex <= pairsCnt) {
			ReflectiveElementValuePair[] elementValuePairsWithoutDefaults = new ReflectiveElementValuePair[pairIndex];
			System.arraycopy(elementValuePairs, 0, elementValuePairsWithoutDefaults, 0, pairIndex);
			elementValuePairs = elementValuePairsWithoutDefaults;
		}
		return elementValuePairs;
	}
	
	/**
	 * Returns standard annotation tag bits for this annotation. 
	 * 
	 * Some annotations have a tag bits value assigned. This method returns 
	 * the tag bits if this ReflectiveAnnotation type has a value assigned and 
	 * is supported. Returns 0 (no bits set) otherwise.
	 * 
	 * It seems that eclipse compiler relies on those bits, so we have to return
	 * them correctly. 
	 */
	public long standardAnnotationTagBits() {		
		long tagBits = 0;
		if (ANNOTATIONTYPE2TAGBITS_MAP.containsKey(annotation.annotationType())) {
			tagBits |= ANNOTATIONTYPE2TAGBITS_MAP.get(annotation.annotationType());
		}
		// A special hack for java.lang.annotation.Retention annotation...  		 
		if (annotation.annotationType() == Retention.class) {
			switch (((Retention)annotation).value()) {
			case CLASS:
				tagBits |= TagBits.AnnotationClassRetention;
				break;
			case RUNTIME:
				tagBits |= TagBits.AnnotationRuntimeRetention;
				break;
			case SOURCE:
				tagBits |= TagBits.AnnotationSourceRetention;
				break;
			default:
				break;				
			}
		}
		// A special hack for java.lang.annotation.Target annotation...  		 
		if (annotation.annotationType() == Target.class) {
			ElementType[] targets = ((Target)annotation).value();
			if (targets.length > 0) {
				for (ElementType target : targets) {
					switch (target) {
					case ANNOTATION_TYPE:
						tagBits |= TagBits.AnnotationForAnnotationType;
						break;
					case CONSTRUCTOR:
						tagBits |= TagBits.AnnotationForConstructor;
						break;
					case FIELD:
						tagBits |= TagBits.AnnotationForField;
						break;
					case LOCAL_VARIABLE:
						tagBits |= TagBits.AnnotationForLocalVariable;
						break;
					case METHOD:
						tagBits |= TagBits.AnnotationForMethod;
						break;
					case PACKAGE:
						tagBits |= TagBits.AnnotationForPackage;
						break;
					case PARAMETER:
						tagBits |= TagBits.AnnotationForParameter;
						break;
					case TYPE:
						tagBits |= TagBits.AnnotationForType;
						break;
					default:
						break;
					}
				}	
			} else {
				// when the annotation can't be used on any target (@Target({}))
				tagBits |= TagBits.AnnotationTarget;
			}
		}		
		// Another hack for java.lang.invoke.MethodHandle$PolymorphicSignature which 
		// is private ant thus cannot be accessed normally...
		if (annotation.annotationType().getName().equals("java.lang.invoke.MethodHandle$PolymorphicSignature")) {
			tagBits |= TagBits.AnnotationPolymorphicSignature;
		}
		return tagBits;
	}
	
	public boolean shouldBeIgnored() {
		return IGNORE_STD_ANNOTATIONS && (standardAnnotationTagBits() != 0);
	}
}
