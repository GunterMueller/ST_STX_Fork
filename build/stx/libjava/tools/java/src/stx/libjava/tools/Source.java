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
package stx.libjava.tools;

import org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration;
import org.eclipse.jdt.internal.compiler.env.ICompilationUnit;

import stx.libjava.tools.parser.Parser;

/**
 * A default implementation of ICompilationUnit used by STX:LIBJAVA 
 * tools. 
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class Source implements ICompilationUnit {

protected char[] typename;
protected char[][] packagename;

protected char[] contents;

public Source(String contents) {
    this(contents, null);
}

public Source(String contents, String name ) {
    setContents(contents);
    setName(name);

}

/**
 * Answer the contents of the compilation unit.
 *
 * In normal use, the contents are requested twice.
 * Once during the initial lite parsing step, then again for the
 * more detailed parsing step.
 * Implementors must never return null - return an empty char[] instead,
 * CharOperation.NO_CHAR being the candidate of choice.
 */
public char[] getContents() {
    return contents;
}

/**
 * Set the contents of the compilation unit. 
 */
public void setContents(char[] contents) {
    this.contents = contents;
}

/**
 * Set the contents of the compilation unit. 
 */
public void setContents(String contents) {
    this.contents = contents.toCharArray();
}


/**
 * Set fully qualified name of the main type. The name
 * implies package name of this compilation unit.
 * 
 */
public void setName(String qname) {
    if (qname == null) {
        typename = null;
        packagename = null;        
    } else {    
        char[] qnameC = qname.toCharArray();
        int ncomponents = 0;
        int i;
        for (i = 0; i < qnameC.length; i++) {
            if (qnameC[i] == '.') ncomponents++; 
        }
        packagename = new char[ncomponents][];
        int j = 0;
        int ci = 0;
        for (i = 0; i < qnameC.length; i++) {
            if (qnameC[i] == '.') {
                char[] component = new char[i - j];
                packagename[ci++] = component;
                System.arraycopy(qnameC, j, component, 0, i-j);
                j = i+1;
            }
        }
        typename = new char[qnameC.length-j];
        System.arraycopy(qnameC, j, typename, 0, qnameC.length-j);
    }
}

/**
 * Initialises type name and package name from source.
 */
public void setName() {
    Parser p = new Parser();
    CompilationUnitDeclaration cu = p.parse(this, true);         
    if ( cu.types != null && cu.types.length > 0 ) {
        typename = cu.types[0].name;
    } else {
        typename = new char[0];
    }

    if (cu.currentPackage == null) {
        // no package? 
        packagename = new char[0][0];
    } else {
        packagename = cu.currentPackage.tokens;
    }
}

/**
 * Answer the name of the top level public type.
 * For example, {Hashtable}.
 */
public char[] getMainTypeName() {
    return typename;
}
/**
 * Answer the name of the package according to the directory structure
 * or null if package consistency checks should be ignored.
 * For example, {java, lang}.
 */
public char[][] getPackageName() {    
    return packagename;
}
/**
* Answer if optional problems should be ignored for this compilation unit.
* Implementors should return <code>false</code> if there is no preference.
*/
public boolean ignoreOptionalProblems() {
    return false;
}

/**
 * Answer the file name which defines the type.
 *
 * The path part (optional) must be separated from the actual
 * file proper name by a separator suitable for the type (java.io.File.separator for example),
 * e.g.
 *  "c:\\source\\com\\p\\X.java" or
 *  "/com/p/Y.java".
 *
 * The path to the zip or jar file (optional) must be separated
 * from the actual path part by JAR_FILE_ENTRY_SEPARATOR,
 * e.g.
 *  "c:\\lib\\some.jar|/com/p/X.class" or
 *  "/lib/some.zip|/com/q/Y.class".
 *
 * The proper file name includes the suffix extension (e.g.&nbsp;".java")
 * e.g.&nbsp;"c:/org/eclipse/jdt/internal/compileri/env/IDependent.java"
 *
 * Return null if no file defines the type.
 */

public char[] getFileName() {     
    char[] tn = typename != null ? typename : "$$unknown$$".toCharArray();       
    char[] fname = new char[tn.length + 5];
    System.arraycopy(tn, 0, fname, 0, tn.length);
    fname[tn.length]     = '.';
    fname[tn.length + 1] = 'j';
    fname[tn.length + 2] = 'a';
    fname[tn.length + 3] = 'v';
    fname[tn.length + 4] = 'a';
    return fname;
}

}
