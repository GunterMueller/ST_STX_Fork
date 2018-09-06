package stx.libjava.examples;

import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.StandardJavaFileManager;
import javax.tools.ToolProvider;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * This example demonstrates how to use OpenJDK/Oracle javac compiler
 * from Java. 
 * 
 * @author Jan Vrany
 *
 */
@stx.libjava.annotation.Package("stx:libjava/examples")
public class JavacExample {

    public static void main(String[] args) {
        //Get an instance of java compiler
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();

        //Get a new instance of the standard file manager implementation
        StandardJavaFileManager fileManager = compiler.
                getStandardFileManager(null, null, null);

        // Get the list of java file objects, in this case we have only 
        // one file, TestClass.java
        List<File> files = new ArrayList<File>();
        files.add(new File("/tmp/HelloWorld.java"));

        Iterable<? extends JavaFileObject> compilationUnits1 =
                fileManager.getJavaFileObjectsFromFiles(files);

        // Create the compilation task
        JavaCompiler.CompilationTask task = compiler.getTask(null, fileManager, null,
                null, null, compilationUnits1);

        // Perform the compilation task.
        boolean result = task.call();
        assert(result);
    }

}
