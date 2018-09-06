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
package stx.libjava.tools.compiler;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import javax.tools.SimpleJavaFileObject;

/**
 * Simple in-memory representation of .class file. Used by 
 * JavaCompilerAdapter. 
 * 
 * @author Jan Vrany
 *
 */
@stx.libjava.annotation.Package("stx:libjava/experiments")
public class JavaClassFile extends SimpleJavaFileObject {
	private ByteArrayOutputStream bytes; 
	
	public JavaClassFile(String name) {       
		super(URI.create("byte:///" + name + ".class"), Kind.CLASS);   
	}   
	public CharSequence getCharContent(boolean ignoreEncodingErrors) {       
		throw new IllegalStateException();   
	}   
	public OutputStream openOutputStream() {       
		bytes = new ByteArrayOutputStream();       
		return bytes;   
	}   
	public InputStream openInputStream() {       
		throw new IllegalStateException();   
	}   
	public byte[] getBytes() {       
		return bytes.toByteArray();   
	}
}
