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
package stx.libjava.tools.environment.internal;

import java.io.File;
import java.lang.reflect.Field;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.Vector;


/**
 * <code>ReflectiveClassLoader</code> is a simple wrapper on a {@link java.lang.ClassLoader} that provides
 * reflective features standard {@link java.lang.ClassLoader} doesn't.
 * In particular, it provides {@link #isPackage(String)} which is used
 * by {@link stx.libjava.tools.environment.ReflectiveEnvironment}.
 * 
 * The way {@link java.lang.ClassLoader} accesses and loads classes differ
 * so specialised subclasses exists for individual {@link java.lang.ClassLoader}
 * instances in order to provide more accurate answers. Therefore use method 
 * {@link #forClassLoader(ClassLoader)} to create an instance of a 
 * <code>ReflectiveClassLoader</code> 
 *  
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class ReflectiveClassLoader {
    /** 
     * Shared cached {@link ReflectiveClassLoader} representing primordial class loader. 
     * Primordial class loader is not to change during the life-span of a JVM, so it can be
     * safely cached.  
     * 
     */
    protected static ReflectiveClassLoader PRIMORDIAL = new ReflectiveURLClassLoader(null, sun.misc.Launcher.getBootstrapClassPath().getURLs());

    /**
     * Cached {@link Field} to access normally inaccessible field {@link java.lang.ClassLoader#classes}. 
     * On OpenJDK based libraries, this field contains a list of loaded classes. This list is used
     * to check for loaded classes as a short-circuit (or as the only way for generic class loaders) 
     */
    protected static Field FIELD_ClassLoader_Classes;
    
    /**
     * A real {@link ClassLoader} this {@link ReflectiveClassLoader} reflects on. 
     * For primordial class loader the value is <code>null</code>.
     */
    protected ClassLoader realClassLoader;
    
    /**
     * A cached {@link ReflectiveClassLoader} representing a parent class loader of
     * this object. For primordial class loader the value is <code>null</code>.
     */
    protected ReflectiveClassLoader parent;
    
    protected ReflectiveClassLoader(ClassLoader loader) {
        realClassLoader = loader;
    }
    
    static {
        try {
            FIELD_ClassLoader_Classes = ClassLoader.class.getDeclaredField("classes");
            FIELD_ClassLoader_Classes.setAccessible(true);
        } catch (NoSuchFieldException e) {
            FIELD_ClassLoader_Classes = null;
        } catch (SecurityException e) {
            FIELD_ClassLoader_Classes = null;
        }
    }
        
    /**
     * Returns a suitable {@link ReflectiveClassLoader} for given (real) {@link ClassLoader}.
     * 
     * @param loader a {@link ClassLoader} on which to reflect.
     * @return a {@link ReflectiveClassLoader} for given @param loader. 
     */
    public static ReflectiveClassLoader forClassLoader(ClassLoader loader) {
        if (loader == null) {
            return PRIMORDIAL;
        }
        /* This is kind of ugly, we should provide a way to register custom subclasses,
         * but for now, keep it simple. We'll see if this machinery proves usable at all. 
         */
        if (loader instanceof java.net.URLClassLoader) {
            return new ReflectiveURLClassLoader((java.net.URLClassLoader)loader);
        }
        return new ReflectiveClassLoader(loader);
    }
    
    public ReflectiveClassLoader getParent() {
        if (realClassLoader == null) return null;
        if (parent == null) {
            parent = ReflectiveClassLoader.forClassLoader(realClassLoader.getParent());
        }
        return parent;
    }
    
    /** 
     * Return <code>true</code> is package with name @param packageNameDotted exists under
     * this class loader, <code>false</code> otherwise.  
     * 
     * A package is considered to exist if there's at least one class in that package. 
     * However, individual {@link ReflectiveClassLoader}s may extend the definition of
     * {@link #isPackage(String)} For example {@link ReflectiveURLClassLoader} may return
     * <code>true</code> if a directory exists along it's class path.  
     * 
     * @param packageNameDotted a name of the package (with dots as separator)
     * @return <code>true</code> if such package exists, <code>false</code> otherwise
     */
    public boolean isPackage(String packageNameDotted) {
    	String packageNameSlashed = packageNameDotted.replace('.', '/');
    	return isPackage(packageNameDotted, packageNameSlashed);
    }
    
    /**
     * Return <code>true</code> is package with name @param packageNameDotted exists under
     * this class loader, <code>false</code> otherwise.  
     * 
     * A package is considered to exist if there's at least one class in that package. 
     * However, individual {@link ReflectiveClassLoader}s may extend the definition of
     * {@link #isPackage(String)} For example {@link ReflectiveURLClassLoader} may return
     * <code>true</code> if a directory exists along it's class path.  
     * 
     * @param packageNameDotted a name of the package (with dots as separator)
     * @param packageNameSlashed a name of the package (with slashes as separator)
     * @return <code>true</code> if such package exists, <code>false</code> otherwise
     */
    public boolean isPackage(String packageNameDotted, String packageNameSlashed) {
        // First, check parent class loader
        if (realClassLoader != null) {
            if (realClassLoader.getParent() == null) {
                if (PRIMORDIAL.isPackage(packageNameDotted, packageNameSlashed)) {
                    return true;
                }
            } else {
                if (getParent().isPackage(packageNameDotted, packageNameSlashed)) {
                    return true;
                }
            }
        }
        // Second, consult list of already loaded classes.
        if (realClassLoader != null && FIELD_ClassLoader_Classes != null) {
            int packageNameLen = packageNameDotted.length();
            Vector<Class<?>> classes;
            try {
                classes = (Vector<Class<?>>)FIELD_ClassLoader_Classes.get(realClassLoader);
                if (classes.size() > 0) {
                	/* 
                	 * Iterate over all classes registered in a class loader,
                	 * if class in probed package is found, return true. 
                	 * If class with the same name as probed package, return false. 
                	 *	
                	 * If the vector of classes is modified during the search, restart. 
                	 * This may happen as other threads may load classes using the same
                	 * class loader and thus modify the classes vector. 
                	 */
                	do {
                		try {
		                    Iterator<Class<?>> i = classes.iterator();
		                    while (i.hasNext()) {                    
		                        String className = i.next().getName();
		                        int classNameLen = className.length();                  
		                        if ((classNameLen > packageNameLen) &&
		                            (className.charAt(packageNameLen) == '.') &&
		                            (className.startsWith(packageNameDotted))) {
		                            return true;
		                        } else if ((classNameLen == packageNameLen) &&
		                                    className.equals(packageNameDotted)) {
		                            return false;
		                        }
		                    }
                		} catch (ConcurrentModificationException cme) {
                			/* Oops, classes vector has ben modified by some other thread, 
                			 * restart.
                			 */
                			continue;
                		}
                	} while (false);
                }
            } catch (IllegalArgumentException e) {
                // If we're for whatever reason forbidden access to classes field,
                // well, just ignore it. 
            } catch (IllegalAccessException e) {
                // same as above. 
            }
        }
        // Last, we don't know. For generic ClassLoader, there's no other way
        // to figure out what packages are there or not. So be conservative...
        return false;
    }
    
    public ClassLoader getRealClassLoader() {
        return realClassLoader;
    }

}
