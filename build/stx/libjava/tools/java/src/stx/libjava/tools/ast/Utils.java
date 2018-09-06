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
package stx.libjava.tools.ast;

import java.lang.reflect.Array;

import org.eclipse.jdt.internal.compiler.ast.AbstractMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class Utils {
    
    public static void addOrReplaceType(TypeDeclaration type, TypeDeclaration inner) {        
        if (type.memberTypes == null || type.memberTypes.length == 0) {
            type.memberTypes = new TypeDeclaration[1];
            type.memberTypes[0] = inner;
            return;
        }                                  
        for (int i = 0; i < type.memberTypes.length; i++) {
            if (ASTNodeComparator.equals(type.memberTypes[i], inner)) {
                type.memberTypes[i] = inner;
                return;
            }
        }
        type.memberTypes = concat(type.memberTypes, inner); 
    }
    
    public static void addOrReplaceMethod(TypeDeclaration type, AbstractMethodDeclaration method) {
        if (type.methods == null || type.memberTypes.length == 0) {
            type.methods = new AbstractMethodDeclaration[1];
            type.methods[0] = method;
            return;
        }                                  
        for (int i = 0; i < type.methods.length; i++) {
            if (ASTNodeComparator.equals(type.methods[i], method)) {
                type.methods[i] = method;
                return;
            }
        }
        type.methods = concat(type.methods, method);         
    }
    
    public static void addOrReplaceField(TypeDeclaration type, FieldDeclaration field) {
        if (type.fields == null || type.fields.length == 0) {
            type.fields = new FieldDeclaration[1];
            type.fields[0] = field;
            return;
        }                                  
        for (int i = 0; i < type.fields.length; i++) {
            if (ASTNodeComparator.equals(type.fields[i], field)) {
                type.fields[i] = field;
                return;
            }
        }
        type.fields = concat(type.fields, field);         
    }

    
    public static <T> T[] concat(T[] array, T element) {
        @SuppressWarnings("unchecked")
        T[] result = (T[])Array.newInstance(array.getClass().getComponentType(), array.length + 1);
        System.arraycopy(array, 0, result, 0, array.length);
        result[array.length] = element;        
        return result;
    }
    
}
