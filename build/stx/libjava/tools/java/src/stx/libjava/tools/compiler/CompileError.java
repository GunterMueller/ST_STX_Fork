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

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;

import org.eclipse.jdt.internal.compiler.codegen.ConstantPool;

/**
 * The CompilerError exception is thrown whenever a Java code enters a method
 * which could not be compiled cleanly because of missing/unresolved types,
 * methods and fields. 
 * 
 * Originally, the Eclipse Compiler for Java throws plain java.lang.Error. 
 * The problem is that this generic error is thrown in other cases as well
 * and having custom error thrown allows for easy detection of places with
 * compilation problems. This is very useful for class reloading, where we
 * simply recompile all classes with compilation problems once we detect
 * a possible fix. In other words, this custom exception class serves as
 * a marker for JavaClassReloader.   
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class CompileError extends Error {
   
    private static final long serialVersionUID = 1434524020109220251L;

    static {
        /* Here's the hack - modify ConstantPool.JavaLangErrorConstantPoolName field value
         * to point CompilerError rather than to java.lang.Error. THis way, ECJ will throw
         * CompilerError rather than java.lang.Error for all unresolved problems.
         *   
         * Since the field is final, we have to mess up with reflection and access bits
         * to cheat Java. What a lovely language, isn't it?         
         */        
        
        try {
            Field field = ConstantPool.class.getField("JavaLangErrorConstantPoolName");
            Field modifiersField = Field.class.getDeclaredField("modifiers");
            modifiersField.setAccessible(true);
            modifiersField.setInt(field, field.getModifiers() & ~Modifier.FINAL);
            
            field.set(null, "stx/libjava/tools/compiler/CompileError".toCharArray());
        } catch (SecurityException e) {
            throw new RuntimeException("Failed to modify ConstantPool.JavaLangErrorConstantPoolName field!",e);            
        } catch (NoSuchFieldException e) {
            throw new RuntimeException("Failed to modify ConstantPool.JavaLangErrorConstantPoolName field!",e);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Failed to modify ConstantPool.JavaLangErrorConstantPoolName field!",e);
        } catch (IllegalAccessException e) {
            throw new RuntimeException("Failed to modify ConstantPool.JavaLangErrorConstantPoolName field!",e);
        }
        
        if (! (new String(ConstantPool.JavaLangErrorConstantPoolName)).equals("stx/libjava/tools/compiler/CompileError")) {
            throw new RuntimeException("Failed to modify ConstantPool.JavaLangErrorConstantPoolName field!");
        }
    }

    
    public CompileError() {        
    }

    public CompileError(String message) {
        super(message);
    }

    public CompileError(Throwable cause) {
        super(cause);
    }

    public CompileError(String message, Throwable cause) {
        super(message, cause);
    }

}
