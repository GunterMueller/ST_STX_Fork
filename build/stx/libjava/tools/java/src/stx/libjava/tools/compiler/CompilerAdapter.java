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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.eclipse.jdt.internal.compiler.ClassFile;
import org.eclipse.jdt.internal.compiler.CompilationResult;
import org.eclipse.jdt.internal.compiler.DefaultErrorHandlingPolicies;
import org.eclipse.jdt.internal.compiler.ICompilerRequestor;
import org.eclipse.jdt.internal.compiler.IErrorHandlingPolicy;
import org.eclipse.jdt.internal.compiler.IProblemFactory;
import org.eclipse.jdt.internal.compiler.env.INameEnvironment;
import org.eclipse.jdt.internal.compiler.env.NameEnvironmentAnswer;
import org.eclipse.jdt.internal.compiler.impl.CompilerOptions;
import org.eclipse.jdt.internal.compiler.problem.DefaultProblemFactory;

import stx.libjava.tools.Source;
import stx.libjava.tools.environment.ReflectiveEnvironment;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class CompilerAdapter implements ICompilerRequestor {
	protected ReflectiveEnvironment environment;
	protected CompilationResult result;
	
	static {
	    // Just to make sure a static initialiser of CompilerError runs.
	    // Use reflection to avoid direct references from constant pool so
	    // this class is not falsely recognized as class with compilation errors
	    try {
            Class.forName("stx.libjava.tools.compiler.CompileError").newInstance();
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize CompilerError class: "+e.getMessage(), e);
        } 	   	    
	}
		
	public CompilerAdapter() {
		this(ClassLoader.getSystemClassLoader());
	}
	
	public CompilerAdapter(ClassLoader cl) {
		environment = new ReflectiveEnvironment(cl);	
	}
	
	public CompilationResult getResult() {
		return result;
	}

	public ClassLoader getClassLoader() {
		return environment.getClassLoader();
	}
	
	/**
	 * Compiles classes in given source. The resulting .class files are added
	 * to an internal list which can be later retrieved by getClassFiles().
	 * 
	 * @param source source code of the class as String.   
	 * @return true, if compilation succeeded, false otherwise.
	 */
	public boolean compile(String source) {
	    return compile(source, true);
	}
	
	/**
     * Compiles classes in given source. The resulting .class files are added
     * to an internal list which can be later retrieved by getClassFiles() - 
     * but only if @param generate is true. 
     * 
     * @param source source code of the class as String.
     * @param generate if false, .class files are not generated (used to check source for errors)   
     * @return true, if compilation succeeded, false otherwise.
     */
	public boolean compile(String source, boolean generate) {
	    CompilerOptions options = getDefaultCompilerOptions();
		ICompilerRequestor requestor = this;
		IErrorHandlingPolicy policy = DefaultErrorHandlingPolicies.exitAfterAllProblems();
	    IProblemFactory problemFactory = new DefaultProblemFactory(Locale.getDefault());
	    Source[] units = new Source[1];
	    units[0] = new Source(source);
	    units[0].setName();		
	    options.generateClassFiles = generate;	    
		org.eclipse.jdt.internal.compiler.Compiler compiler = new org.eclipse.jdt.internal.compiler.Compiler(
				new CompilerAdapterEnvironment(environment, units[0]), 
				policy, options, requestor, problemFactory);
		
		compiler.compile(units);
		return getResult().hasErrors();
	}
	
	/**
	 * Same as compile(String), for compatibility with old interface
	 * 
	 * @deprecated
	 */
	public boolean compile(String name, String source) {
	    return compile(source);
	}
	
	/**
	 * Returns a list of JavaClassFiles that contains results of the compilation. 
	 * 
	 * @return resulting class files
	 */
	public ClassFile[] getClassFiles() {
		return getResult().getClassFiles();
	}
	
	public static Map<String, Object> getDefaultCompilerSettings() {
		String javaSpecVersion = System.getProperty("java.specification.version");
        Map<String, Object> settings = new HashMap<String, Object>();
        settings.put(CompilerOptions.OPTION_Source, javaSpecVersion);
        settings.put(CompilerOptions.OPTION_TargetPlatform, javaSpecVersion);
        settings.put(CompilerOptions.OPTION_ReportDeprecation, CompilerOptions.IGNORE);
        return settings;
	}

    public static CompilerOptions getDefaultCompilerOptions() {
    	return new CompilerOptions(getDefaultCompilerSettings());
    }

	@Override
	public void acceptResult(CompilationResult result) {
		this.result = result;
		for (ClassFile cf : this.result.getClassFiles()) {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < cf.getCompoundName().length; i++) {
				sb.append(cf.getCompoundName()[i]);
				if (i < cf.getCompoundName().length - 1) {
					sb.append('.');
				}
			}
			environment.types.put(sb.toString(), cf.getBytes());
		}
	}
	
	protected static class CompilerAdapterEnvironment implements INameEnvironment {
		ReflectiveEnvironment env;
		Source source; 
		
		public CompilerAdapterEnvironment(ReflectiveEnvironment env, Source source) {
			this.env = env;
			this.source = source;
		}
		
		@Override
		public NameEnvironmentAnswer findType(char[][] compoundTypeName) {
			return env.findType(compoundTypeName);
		}

		@Override
		public NameEnvironmentAnswer findType(char[] typeName,
				char[][] packageName) {
			return env.findType(typeName, packageName);
		}

		@Override
		public boolean isPackage(char[][] parentPackageName, char[] packageName) {
			char[][] sourcePackageName = source.getPackageName();
			char[]   sourceClassName   = source.getMainTypeName();
			
			//return ! Character.isUpperCase(packageName[0]);
			
			if (Arrays.equals(packageName, sourceClassName)) {
				if (((parentPackageName == null) && (sourcePackageName == null)) ||
					((parentPackageName != null) && (sourcePackageName != null) 
							&& (parentPackageName.length == sourcePackageName.length))) {
						for (int i = 0; i < parentPackageName.length; i++) {
							if (! Arrays.equals(parentPackageName[i], sourcePackageName[i] ) ) {
								return env.isPackage(parentPackageName, packageName);
							}
						}	
						return false;
					}
			} else if ( (parentPackageName == null) && (sourcePackageName.length == 1) ) {
				if (Arrays.equals(packageName, sourcePackageName[0])) {
					return true;
				}
			} else if ( (parentPackageName != null) && (parentPackageName.length == sourcePackageName.length - 1) ) {
				if (! Arrays.equals(packageName, sourcePackageName[0])) {
					return env.isPackage(parentPackageName, packageName);
				} else {
					for (int i = 0; i < parentPackageName.length; i++) {
						if (! Arrays.equals(parentPackageName[i], sourcePackageName[i] ) ) {
							return env.isPackage(parentPackageName, packageName);
						}
					}
					return true;
				}
			}	
			return env.isPackage(parentPackageName, packageName);
			
		}

		@Override
		public void cleanup() {
			env.cleanup();
		}
		
	}
	

}
