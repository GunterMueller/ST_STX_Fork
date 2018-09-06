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

import org.eclipse.jdt.internal.compiler.env.ClassSignature;
import org.eclipse.jdt.internal.compiler.env.EnumConstantSignature;
import org.eclipse.jdt.internal.compiler.impl.BooleanConstant;
import org.eclipse.jdt.internal.compiler.impl.ByteConstant;
import org.eclipse.jdt.internal.compiler.impl.CharConstant;
import org.eclipse.jdt.internal.compiler.impl.DoubleConstant;
import org.eclipse.jdt.internal.compiler.impl.FloatConstant;
import org.eclipse.jdt.internal.compiler.impl.IntConstant;
import org.eclipse.jdt.internal.compiler.impl.LongConstant;
import org.eclipse.jdt.internal.compiler.impl.ShortConstant;
import org.eclipse.jdt.internal.compiler.impl.StringConstant;

public class ReflectiveUtils {
	
	/**
	 * For a given object (of class X) returns a XConstant object with the same
	 * value. Works for primitive-wrapper classes (like Byte, Short, Float,...), 
	 * enums, String and arrays of these classes. 
	 * Returns null for any other class.
	 * 
	 * @param value an object to be converted to its constant alternative
	 * @return constant form of the given object or null if the given objects' 
	 * type isn't supported
	 */
	public static Object getXConstant(Object value) {
		if (value == null)
			return null;
		
		if (value.getClass().isArray()) {
			Object[] array = (Object[]) value;
			Object[] arrayConstant = new Object[array.length];
			for (int i = 0; i < array.length; i++) {
				arrayConstant[i] = getXConstant(array[i]);
			}
			return arrayConstant;
		} else if (value instanceof Byte) {
			return ByteConstant.fromValue(((Byte) value).byteValue());
		} else if (value instanceof Short) {
			return ShortConstant.fromValue(((Short) value).shortValue());
		} else if (value instanceof Integer) {
			return IntConstant.fromValue(((Integer) value).intValue());
		} else if (value instanceof Long) {
			return LongConstant.fromValue(((Long) value).longValue());
		} else if (value instanceof Float) {
			return FloatConstant.fromValue(((Float) value).floatValue());
		} else if (value instanceof Double) {
			return DoubleConstant.fromValue(((Double) value).doubleValue());
		} else if (value instanceof Character) {
			return CharConstant.fromValue(((Character) value).charValue());
		} else if (value instanceof Boolean) {
			return BooleanConstant.fromValue(((Boolean) value).booleanValue());
		} else if (value instanceof String) {
			return StringConstant.fromValue((String) value);
		} else if (value.getClass().isEnum()) {
			return new EnumConstantSignature(getSigFromName(value.getClass().getName()).toCharArray(), ((Enum)value).name().toCharArray());
		} else if (value instanceof Class) {
			return new ClassSignature(getSigFromName(((Class) value).getName()).toCharArray());
		}
		
		return null;
	}
	
	/*
	 * Returns FieldDescriptor of the given Class as defined in "4.3.2. Field  
	 * Descriptors" section of the JVM Specification (Java SE 7 Edition). 
	 * FieldDescriptors are useful for method descriptors.
	 * Note that VoidDescriptor (from "4.3.3. Method Descriptors" section) 
	 * is considered to be a FieldDescriptor for the purpose of this method 
	 * as well.
	 */
	
	/**
	 * Returns FieldDescriptor of the given Class as defined in "4.3.2. Field  
	 * Descriptors" section of the JVM Specification (Java SE 7 Edition). 
	 * FieldDescriptors are useful for method descriptors.
	 * Note that VoidDescriptor (from "4.3.3. Method Descriptors" section) 
	 * is considered to be a FieldDescriptor for the purpose of this method 
	 * as well.
	 * 
	 * @param clazz Class to get FieldDescriptor (signature) of.
	 * @return FieldDescriptor (signature) of the given class.
	 */
	public static String getFieldDescriptor(Class<?> clazz) {
		return getSigFromName(clazz.getName());
	}
	
	/**
	 * Returns signature corresponding to the given class name.
	 * The structure of the signature is defined (as "FieldDescriptor")  
	 * in "4.3.2. Field Descriptors" section of the JVM Specification 
	 * (Java SE 7 Edition). 
	 * Note that VoidDescriptor (from "4.3.3. Method Descriptors" section) 
	 * is considered to be a FieldDescriptor for the purpose of this method 
	 * as well.
	 * By class name here the string returned by Class.getName() is meant.
	 * It's basically a reverse operation to the getNameFromSig() method.
	 * 
	 * @param name Class name to be converted to signature.
	 * @return Signature corresponding to the given class name.
	 */
	public static String getSigFromName(String name) {
		if (name.charAt(0) == '[')	
			// an array's name is in a form of FieldDescriptor already
			return name.replace(".", "/");
		
		if (name.equals("int"))
			return "I";
		else if (name.equals("byte"))
			return "B";
		else if (name.equals("short"))
			return "S";
		else if (name.equals("long"))
			return "J";
		else if (name.equals("boolean"))
			return "Z";
		else if (name.equals("char"))
			return "C";
		else if (name.equals("double"))
			return "D";
		else if (name.equals("float"))
			return "F";
		else if (name.equals("void"))
			return "V";
		else {
			return "L" + name.replace(".", "/") + ";";
		}
	}
	
	/**
	 * Returns class name corresponding to the given signature.
	 * The structure of the signature is defined (as "FieldDescriptor")  
	 * in "4.3.2. Field Descriptors" section of the JVM Specification 
	 * (Java SE 7 Edition). 
	 * Note that VoidDescriptor (from "4.3.3. Method Descriptors" section) 
	 * is considered to be a FieldDescriptor for the purpose of this method 
	 * as well.
	 * By class name here the string returned by Class.getName() is meant.
	 * It's basically a reverse operation to the getSigFromName() method.
	 * 
	 * @param sig Signature to be converted to class name.
	 * @return Class name corresponding to the given signature.
	 */
	public static String getNameFromSig(String sig) {
		if (sig.charAt(0) == '[')	
			// an array's FieldDescriptor is in a form of a "class name" already
			// except for dots/slashes
			return sig.replace("/", ".");
		
		if (sig.equals("I"))
			return "int";
		else if (sig.equals("B"))
			return "byte";
		else if (sig.equals("S"))
			return "short";
		else if (sig.equals("J"))
			return "long";
		else if (sig.equals("Z"))
			return "boolean";
		else if (sig.equals("C"))
			return "char";
		else if (sig.equals("D"))
			return "double";
		else if (sig.equals("F"))
			return "float";
		else if (sig.equals("V"))
			return "void";
		else if (sig.charAt(0) == 'L')
			// cut out the initial 'L' and the trailing ';' and replace slashes 
			// with dots
			return sig.substring(1, sig.length() - 1).replace("/", ".");
		
		return null; // this should never actually happen
	}
}
