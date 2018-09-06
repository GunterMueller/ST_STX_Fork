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
import java.util.ArrayList;

import org.eclipse.jdt.internal.compiler.classfmt.ClassFileConstants;
import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveMethod implements IBinaryMethod {
	
	Method method;
	Constructor<?> constructor;
	
	static final char[][] NO_EXCEPTIONS = new char[0][];
	
	// cached answers:
	long tagBits;
	boolean tagBitsValid;
	char[] genericSignature;
	char[] descriptor;
	char[] selector;
	char[][] exceptionTypeNames;
	ReflectiveAnnotation[] reflAnnotations;
	ReflectiveAnnotation[][] parameterAnnotations;
	int accessFlags;

	public ReflectiveMethod(Method m){
		this.method = m;
		this.constructor = null;
		this.flushCaches();
	}
	
	public ReflectiveMethod(Constructor<?> c){
		this.method = null;
		this.constructor = c;
		this.flushCaches();
	}
	
	public void flushCaches() {
		tagBitsValid = false;
		genericSignature = null;
		descriptor = null;
		selector = null;
		reflAnnotations = null;
		parameterAnnotations = null;
		accessFlags = -1;
	}
	
	@Override
	public int getModifiers() {
		if (accessFlags == -1) {
			if (method != null)
				accessFlags = method.getModifiers();
			else
				accessFlags = constructor.getModifiers();
		}
		/*
		 * Must add some attribute-related extra modifiers, see 
		 * MethodInfo#readModifierRelatedAttributes(). 
		 * 
		 * Especially, without properly set AnnotationDefaultName the
		 * compiler is unable to compile annotations with parameters
		 * correctly. See test @class CompilerAdapterTests#test_regression_org_junit_Test_annotation_defaults() 
		 */
		if (method != null) {
			if (method.getDefaultValue() != null) {
				accessFlags |= ClassFileConstants.AccAnnotationDefault;
			}
			if (method.isVarArgs()) {
				accessFlags |= ClassFileConstants.AccVarargs;
			}
		}
		return accessFlags;
	}

	@Override
	public boolean isConstructor() {
		return (this.constructor != null);
	}

	@Override
	public char[][] getArgumentNames() {
		// argument names aren't available -> returning null (complying 
		// with the IGenericMethod.getArgumentNames() method's description)
		return null;
	}

	@Override
	public IBinaryAnnotation[] getAnnotations() {
		if (reflAnnotations != null)
			return reflAnnotations;
		
		Annotation[] annotations;
		if (method != null)
			annotations = method.getDeclaredAnnotations();
		else
			annotations = constructor.getDeclaredAnnotations();
		
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
	public Object getDefaultValue() {
		if (method != null) {
			Object defaultValue =  method.getDefaultValue();
			Object defaultValueConstant = ReflectiveUtils.getXConstant(defaultValue);
			if (defaultValueConstant != null)
				defaultValue = defaultValueConstant;
			return defaultValue;
		}
		return null;	// constructors don't have default value
	}

	@Override
	public char[][] getExceptionTypeNames() {
		if (exceptionTypeNames != null) {
			return exceptionTypeNames;
		}
		
		Class<?>[] exceptionTypes;
		if (method != null) {
			exceptionTypes = method.getExceptionTypes();
		} else {
			exceptionTypes = constructor.getExceptionTypes();
		}
		
		if (exceptionTypes.length == 0) {
			exceptionTypeNames = NO_EXCEPTIONS;
			/*
			 * The comment (in the IBinaryMethod interface source file) 
			 * describing the expected behavior of implementations of this 
			 * method states that it should return null if the array of 
			 * the exceptions is empty. However, class 
			 * org.eclipse.jdt.internal.compiler.classfmt.MethodInfo's (that 
			 * implements IBinaryMethod as well) getExceptionTypeNames() method
			 * returns an empty char[][] instead of null. 
			 * This implementation was adjusted to the same behavior to avoid
			 * inconsistency.
			 */
		} else {
			exceptionTypeNames = new char[exceptionTypes.length][];
			for (int i = 0; i < exceptionTypes.length; i++) {
				exceptionTypeNames[i] = exceptionTypes[i].getName().replace(".", "/").toCharArray();
			}
		}
		return exceptionTypeNames;
	}

	@Override
	public char[] getGenericSignature() {
		if (genericSignature != null) {
			return genericSignature;
		}
		
		Method m;
		Object result;
		
		if (method != null) {
			try {
				m = method.getClass().getDeclaredMethod("getGenericSignature");
				m.setAccessible(true);
				result = m.invoke(method);
			} catch (Exception e) {
				throw new RuntimeException("Unable to get generic signature.");
			}
		} else if (constructor != null) { 						
			try {
				m = constructor.getClass().getDeclaredMethod("getSignature");
				m.setAccessible(true);
				result = m.invoke(constructor);
			} catch (Exception e) {
				throw new RuntimeException("Unable to get generic signature.");
			}

		} else {
			result = null;
		}
			
		if (result == null) {
			return null;
		}
		String signature = (String) result;
		genericSignature = signature.toCharArray();
		return genericSignature;
	}
	
	@Override
	public char[] getMethodDescriptor() {
		if (descriptor != null) { 
			return descriptor;
		}
		
		String desc = "(";
		Class<?>[] paramTypes = method != null ? method.getParameterTypes() : constructor.getParameterTypes(); 
		for (Class<?> paramType : paramTypes) {
			desc += ReflectiveUtils.getFieldDescriptor(paramType);
		}
		desc += ")";
		desc += method != null ? ReflectiveUtils.getFieldDescriptor(method.getReturnType()) : 'V';
		descriptor = desc.toCharArray();
		return descriptor;
	}

	/*
	 * Retrieve and store the parameters' annotations. They're stored to 
	 * paramAnnots in declaration order. However, parameters without 
	 * annotations are omitted. Therefore this will result to an empty array
	 * for a method/constructor with no parameters annotated.
	 */
	private void getParameterAnnotations() {
		if (parameterAnnotations != null)
			return;
		
		Annotation[][] paramAnnots;
		if (method != null)
			paramAnnots = method.getParameterAnnotations();
		else
			paramAnnots = constructor.getParameterAnnotations();
		
		ArrayList<ReflectiveAnnotation[]> reflAnnotArrList = 
				new ArrayList<ReflectiveAnnotation[]>();
		for (Annotation[] pa : paramAnnots) {
			if (pa.length == 0)	// not annotated parameter
				continue;
			ReflectiveAnnotation[] ra = new ReflectiveAnnotation[pa.length];
			for (int i = 0; i < pa.length; i++) {
				ra[i] = new ReflectiveAnnotation(pa[i]);
			}
			reflAnnotArrList.add(ra);
		}
		parameterAnnotations = new ReflectiveAnnotation[reflAnnotArrList.size()][];
		parameterAnnotations = reflAnnotArrList.toArray(parameterAnnotations);
	}
	
	@Override
	public IBinaryAnnotation[] getParameterAnnotations(int index) {
		getParameterAnnotations();
		return parameterAnnotations[index];
	}

	@Override
	public int getAnnotatedParametersCount() {
		getParameterAnnotations();
		return parameterAnnotations.length;
	}

	@Override
	public char[] getSelector() {
		if (selector != null) {
			return selector;
		}
		
		if (method != null) 
			selector = method.getName().toCharArray();
		else {
			//String classnm = constructor.getName();
			//int i = classnm.lastIndexOf('.');
			//selector = classnm.substring(i + 1).toCharArray();
			selector = "<init>".toCharArray();
		}
		return selector;
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
	public boolean isClinit() {
		char[] selector = getSelector();
		// if the selector starts with '<', it can only be <init> or <clinit>
		return (selector[0] == '<' && selector[1] == 'c');
	}
}
