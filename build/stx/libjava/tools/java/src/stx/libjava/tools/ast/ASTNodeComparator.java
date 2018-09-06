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

import java.util.Arrays;

import org.eclipse.jdt.core.compiler.CharOperation;
import org.eclipse.jdt.internal.compiler.ast.AbstractMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeReference;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class ASTNodeComparator {
    
    public static boolean equals(TypeDeclaration t1, TypeDeclaration t2) {
        return CharOperation.equals(t1.name, t2.name);
    }
    
    public static boolean equals(FieldDeclaration f1, FieldDeclaration f2) {
        return CharOperation.equals(f1.name, f2.name);
    }


    public static boolean equals(
            AbstractMethodDeclaration m1,
            AbstractMethodDeclaration m2) {
        if (! CharOperation.equals(m1.selector, m2.selector) ) return false;
        if (m1.arguments == null || m2.arguments == null) return m1.arguments == m2.arguments;
        if (m1.arguments.length != m2.arguments.length) return false;
        
        for (int i = 0; i < m1.arguments.length; i++) {
            if (! equals( m1.arguments[i].type, m2.arguments[i].type ) ) return false; 
        }        
        return true;
    }

    private static boolean equals(TypeReference t1, TypeReference t2) {
        char[][] n1 = t1.getTypeName();
        char[][] n2 = t2.getTypeName();
        
        return Arrays.equals(n1[n1.length - 1],n2[n2.length - 2]); 
        
    }
    
}
