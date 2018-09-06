package stx.libjava.examples;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jdt.internal.compiler.ClassFile;

import stx.libjava.tools.compiler.CompilerAdapter;



/**
 * This example demonstrates how to use OpenJDK/Oracle javac compiler
 * from Java. Contrary to JavacExample, in this case the source code is taken
 * from memory. It uses stx.libjava.toosl.compiler.JavaCompilerAdapter. 
 * 
 * @author Jan Vrany
 *
 */
@stx.libjava.annotation.Package("stx:libjava/examples")
public class JavacExample2 {
	public static String source = 
						   "public class HelloWorld {\n" +
						   "  public static void main(String[] args) {\n" +
						   "    System.out.println(\"Hello World\");\n" +
						   "  }\n" +
						   "}";
	

    public static void main(String[] args) {
    	//JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();    	
    	CompilerAdapter compilerAdapter = new CompilerAdapter();
    	
    	compilerAdapter.compile(source);
    	
    	Loader loader = new Loader();
    	for (ClassFile f : compilerAdapter.getResult().getClassFiles()) {
    		
    		loader.getClasses().put(new String(f.fileName()), f.getBytes());
    	}
    
    	try {
	    	Class<?> helloClass = loader.findClass("HelloWorld");
	    	Class<?>[] params = { String[].class };
	    	Method main = helloClass.getMethod("main", params);
	    	main.invoke(null, new Object[1]);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
       	
    }
    
    protected static class Loader extends ClassLoader {
    	protected Map<String, byte[]> classes = new HashMap<String, byte[]>(); 
    	
    	public Map<String, byte[]> getClasses() {
    		return classes;
    	}
    
    	protected Class<?> findClass(String name) throws ClassNotFoundException {       
    		byte[] mbc = null;
    		if (classes != null) {
    			mbc = classes.get(name); 
    		};       
    		if (mbc==null){           
    			mbc = classes.get("/" + name.replace(".","/") + ".class");           
    			if (mbc==null){               
    				return super.findClass(name);           
    			}       
    		}       
    		return defineClass(name, mbc, 0, mbc.length);   
    	}
    	
    	
    }

}
