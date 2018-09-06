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

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;

/**
 * Simple Java compiler adapter to compile classes completely in memory. 
 * @author Jan Vrany
 *
 */
@stx.libjava.annotation.Package("stx:libjava/experiments")
public class JavaCompilerAdapter {
	protected List<String> options = Collections.emptyList();
	protected JavaCompiler compiler;
	protected JavaClassFileManager classFileManager;
	
	public JavaCompilerAdapter() {
		this(ToolProvider.getSystemJavaCompiler());
	}
	
	public JavaCompilerAdapter(JavaCompiler compiler) {
		this.setCompiler(compiler);
	}
	
	public void setCompiler(JavaCompiler compiler) {
		this.compiler = compiler;
		this.classFileManager = new JavaClassFileManager(compiler.getStandardFileManager(null, null, null));
	}
	
	
	
	public Collection<JavaClassFile> getClassFiles() {
		return classFileManager.getClasses().values();
	}
	
	/**
	 * Compiles classes in given source. The resulting .class files are added
	 * to an internal list which can be later retrieved by getClassFiles().
	 * 
	 * @param name unqualified name of class being compiled. 
	 * @param source source code of the class as String.   
	 * @return true, if compilation succeeded, false otherwise.
	 */
	
	public boolean compile(String name, String source) {
		List units = Arrays.asList(new JavaSourceFile(name, source));		
		JavaCompiler.CompilationTask task = compiler.getTask(new PrintWriter(System.err), classFileManager, null, options, null, units);
		return task.call();
	}

}
