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
package stx.libjava.tools.text;

import org.eclipse.jdt.internal.compiler.ast.AbstractMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.LocalDeclaration;
import org.eclipse.jdt.internal.compiler.ast.MessageSend;
import org.eclipse.jdt.internal.compiler.ast.Reference;
import org.eclipse.jdt.internal.compiler.ast.TypeReference;


@stx.libjava.annotation.Package("stx:libjava/tools")
public abstract class Indexer {

    /**
     * Add given @param node to the index. 
     *  
     * @param node node to add to the index.
     * @param from start position of the node (its relevant part for highlighting/navigation)
     * @param to stop position of the node (its relevant part for highlighting/navigation)
     *   
     */
    public void addFieldDeclaration(FieldDeclaration node, int from, int to) {}
    
    /**
     * Same as {@link #addFieldDeclaration(FieldDeclaration, int, int)} but for local variables
     * (temporaries and arguments) 
     */
    public void addLocalDeclaration(LocalDeclaration node, int from, int to) {}

    
    /**
     * Same as {@link #addFieldDeclaration(FieldDeclaration, int, int)} but for types 
     */
    public void addTypeReference(TypeReference node, int from, int to) {}

    /**
     * Same as {@link #addFieldDeclaration(FieldDeclaration, int, int)} but for name references
     * (variables, fields)
     */
    public void addVariableReference(Reference node, int from, int to) {}
    
    /**
     * Same as {@link #addFieldDeclaration(FieldDeclaration, int, int)} but for method
     * invocations
     */
    public void addMessageSend(MessageSend node, int from, int to) {}       
        
    /**
     * Called whenever a method is entered, i.e., before its arguments and
     * statements are visited.   
     */
    public void methodEnter(AbstractMethodDeclaration method) {}
    
    /**
     * Called whenever a method is left, i.e., after all its arguments and 
     * statements are visited.   
     */
    public void methodLeave(AbstractMethodDeclaration method) {}
    

}
