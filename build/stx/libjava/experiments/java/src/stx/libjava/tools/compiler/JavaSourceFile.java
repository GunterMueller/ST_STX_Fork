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
/**
 * 
 */
package stx.libjava.tools.compiler;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import javax.tools.SimpleJavaFileObject;


/**
 * @author Jan Vrany
 *
 */
@stx.libjava.annotation.Package("stx:libjava/experiments")
public class JavaSourceFile extends SimpleJavaFileObject {
	private String src;   
	
	public JavaSourceFile(String name, String src) {       
		super(URI.create("file:///" + name + ".java"), Kind.SOURCE);       
		this.src = src;  
	}   
	public CharSequence getCharContent(boolean ignoreEncodingErrors) {       
		return src;   
	}   
	public OutputStream openOutputStream() {       
		throw new IllegalStateException();   
	}   
	public InputStream openInputStream() {       
		return new ByteArrayInputStream(src.getBytes());   
	}
}
