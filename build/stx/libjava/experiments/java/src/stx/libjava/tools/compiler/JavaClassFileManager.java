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

import java.util.HashMap;
import java.util.Map;
import java.io.IOException;

import javax.tools.FileObject;
import javax.tools.ForwardingJavaFileManager;
import javax.tools.JavaFileObject;
import javax.tools.StandardJavaFileManager;

@stx.libjava.annotation.Package("stx:libjava/experiments")
public class JavaClassFileManager extends ForwardingJavaFileManager {
	protected Map<String, JavaClassFile> classes = new HashMap<String, JavaClassFile>();
	
	public JavaClassFileManager(StandardJavaFileManager sjfm) {       
		super(sjfm);  		
		   
	}   
	public JavaFileObject getJavaFileForOutput(Location location, String name, JavaFileObject.Kind kind, FileObject sibling) throws IOException {       
		JavaClassFile mbc = new JavaClassFile(name);       
		classes.put(name, mbc);       
		return mbc;   
	}

	public ClassLoader getClassLoader(Location location) {       
		return null;   
	}
	
	public Map<String, JavaClassFile> getClasses() {
		return classes;
	}
}
