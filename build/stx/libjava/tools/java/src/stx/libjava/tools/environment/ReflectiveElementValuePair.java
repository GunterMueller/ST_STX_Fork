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

import org.eclipse.jdt.internal.compiler.env.ClassSignature;
import org.eclipse.jdt.internal.compiler.env.EnumConstantSignature;
import org.eclipse.jdt.internal.compiler.env.IBinaryElementValuePair;
import org.eclipse.jdt.internal.compiler.impl.BooleanConstant;
import org.eclipse.jdt.internal.compiler.impl.ByteConstant;
import org.eclipse.jdt.internal.compiler.impl.CharConstant;
import org.eclipse.jdt.internal.compiler.impl.Constant;
import org.eclipse.jdt.internal.compiler.impl.DoubleConstant;
import org.eclipse.jdt.internal.compiler.impl.FloatConstant;
import org.eclipse.jdt.internal.compiler.impl.IntConstant;
import org.eclipse.jdt.internal.compiler.impl.LongConstant;
import org.eclipse.jdt.internal.compiler.impl.ShortConstant;
import org.eclipse.jdt.internal.compiler.impl.StringConstant;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveElementValuePair implements IBinaryElementValuePair {

	char[] name;
	Object value;	
	
	public ReflectiveElementValuePair(char[] n, Object v) {
		name = n;
		value = v;		
	}
	
	@Override
	public char[] getName() {
		return name;
	}

	@Override
	public Object getValue() {
		// * Return {@link IBinaryAnnotation} for annotation type.
		if (value instanceof Annotation) return new ReflectiveAnnotation((Annotation) value);	
		
		// * Return {@link ClassSignature} for a Class {@link java.lang.Class}.
		if (value instanceof Class) return new ClassSignature(((Class<?>)value).getName().toCharArray());
		if (value instanceof ClassSignature) return value;
		
		// * Return {@link EnumConstantSignature} if value is an enum constant.
		if (value instanceof EnumConstantSignature) return value;			
		
		Class<?> type = value.getClass();
		
		// * Return {@link org.eclipse.jdt.internal.compiler.impl.Constant} for compile-time constant of primitive type, as well as String literals.
		if (value instanceof Constant) return value;
		if (type == Boolean.TYPE) return BooleanConstant.fromValue((Boolean) value);
		if (type == Byte.TYPE) return ByteConstant.fromValue((Byte) value);
		if (type == Short.TYPE) return ShortConstant.fromValue((Short) value);
		if (type == Integer.TYPE) return IntConstant.fromValue((Integer) value);
		if (type == Long.TYPE) return LongConstant.fromValue((Long) value);
		if (type == Float.TYPE) return FloatConstant.fromValue((Float) value);
		if (type == Double.TYPE) return DoubleConstant.fromValue((Double) value);
		if (type == Character.TYPE) return CharConstant.fromValue((Character) value);
		if (type == String.class) return StringConstant.fromValue((String) value);
				
			
		// * Return {@link Object}[] for array type.
		if (type.isArray()) return value;
		
		throw new RuntimeException("Unknown annotation element type / value");
	}

}
