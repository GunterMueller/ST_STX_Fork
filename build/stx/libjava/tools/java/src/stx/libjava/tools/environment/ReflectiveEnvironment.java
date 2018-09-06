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
package stx.libjava.tools.environment;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.eclipse.jdt.internal.compiler.classfmt.ClassFileReader;
import org.eclipse.jdt.internal.compiler.classfmt.ClassFormatException;
import org.eclipse.jdt.internal.compiler.env.IBinaryType;
import org.eclipse.jdt.internal.compiler.env.INameEnvironment;
import org.eclipse.jdt.internal.compiler.env.NameEnvironmentAnswer;
//import java.util.logging.Level;
//import java.util.logging.Logger;

import stx.libjava.tools.environment.internal.ReflectiveClassLoader;

public class ReflectiveEnvironment implements INameEnvironment {
    
    /* 
    * No, do not log for now. The problem is that on (Open)JDK 7 this trigger
    * some not-yet-implemented natives in java.nio.*. Sad... 
    */
	//private static final Logger LOGGER = Logger.getLogger(ReflectiveEnvironment.class.getName());
	private static final boolean DEBUG_isPackage = false;
	private static Field FIELD_ClassLoader_Classes;
	
	/** 
	 * A ReflectiveClassLoader where to search for classes & packages
	 */
	protected ReflectiveClassLoader classloader;
	
	/**
	 * Internal cache of found/not found packages to speed-up subsequent calls to 
	 * {@link ReflectiveEnvironment#isPackage(char[][], char[])}
	 */
	protected HashMap<String, Boolean> cachedIsPackageResults = new HashMap<String, Boolean>();
	
	public TypeRegistry types;
	
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
			
	public ReflectiveEnvironment() {
		 this(new TypeRegistry(), ClassLoader.getSystemClassLoader() );
	}
	
	public ReflectiveEnvironment(TypeRegistry types) {
		this(types, ClassLoader.getSystemClassLoader());
	}

	public ReflectiveEnvironment(ClassLoader cl) {
		 this(new TypeRegistry(), cl);
	}

	
	public ReflectiveEnvironment(TypeRegistry types, ClassLoader cl) {
		this.types = types;
		this.classloader = ReflectiveClassLoader.forClassLoader(cl);
	}
	
	public ClassLoader getClassLoader() {
		return classloader.getRealClassLoader();
	}

	/**
	 * Find a type with the given compound name.
	 * Answer the binary form of the type if it is known to be consistent.
	 * Otherwise, answer the compilation unit which defines the type
	 * or null if the type does not exist.
	 * Types in the default package are specified as {{typeName}}.
	 *
	 * It is unknown whether the package containing the type actually exists.
	 *
	 * NOTE: This method can be used to find a member type using its
	 * internal name A$B, but the source file for A is answered if the binary
	 * file is inconsistent.
	 */

	public NameEnvironmentAnswer findType(char[][] compoundTypeName) {		
		return findType(concat(compoundTypeName, null));
	}
	
	/** 
	 * Returns a IBinaryType for class with given name or null
	 * if there's no such class. 
	 * @param name
	 * @return binary type or null (if no type is found)
	 */
	protected IBinaryType findTypeForClassNamed(String name) {
		IBinaryType type;
		
		type = types.get(name);
		if (type != null) return type;
		
		try {
			Class<?> c = getClassLoader().loadClass(name);
			IBinaryType ctype = new ReflectiveType(c);
			types.put(name, ctype);
			return ctype;
		} catch (ClassNotFoundException cnfe) {
			return null;
		}		
	}
	
	protected NameEnvironmentAnswer findType(String name) {
		IBinaryType type = findTypeForClassNamed(name);
		if (type != null) {
			return new NameEnvironmentAnswer(type, null);
		} else {
			return null;
		}
	}
	/**
	 * Find a type named <typeName> in the package <packageName>.
	 * Answer the binary form of the type if it is known to be consistent.
	 * Otherwise, answer the compilation unit which defines the type
	 * or null if the type does not exist.
	 * The default package is indicated by char[0][].
	 *
	 * It is known that the package containing the type exists.
	 *
	 * NOTE: This method can be used to find a member type using its
	 * internal name A$B, but the source file for A is answered if the binary
	 * file is inconsistent.
	 */

	public NameEnvironmentAnswer findType(char[] typeName, char[][] packageName) {		
		return findType(concat(packageName, typeName));
		
	}
	/**
	 * Answer whether packageName is the name of a known subpackage inside
	 * the package parentPackageName. A top level package is found relative to null.
	 * The default package is always assumed to exist.
	 *
	 * For example:
	 *      isPackage({{java}, {awt}}, {event});
	 *      isPackage(null, {java});
	 */

	public boolean isPackage(char[][] parentPackageName, char[] subPackageName) {
	    /* First, consult cached value to speed up second and later calls
         * with the same packageName. The cache is per-instance and thus valid
         * only during the compilation. 
         * In theory it may happen that cached value is no longer valid due to
         * changes to classloader paths <em>during</em> single compilation cycle,
         * but we consider this as a trade-off for speed. It seems that compiler itself
         * does not bother to cache results and keeps asking for the same package names
         * over and over. 
         */
	    String packageName = concat(parentPackageName, subPackageName);
        Boolean isPackageB = cachedIsPackageResults.get(packageName);
        if (isPackageB != null) {
            return isPackageB.booleanValue();
        }       
        boolean isPackage;         
        if (Package.getPackage(packageName) != null) {
            isPackage = true;
        } else {
            isPackage = classloader.isPackage(packageName);
        }
        cachedIsPackageResults.put(packageName, isPackage);
        return isPackage;      		
	}
	
	/**
	 * This method cleans the environment. It is responsible for releasing the memory
	 * and freeing resources. Passed that point, the name environment is no longer usable.
	 *
	 * A name environment can have a long life cycle, therefore it is the responsibility of
	 * the code which created it to decide when it is a good time to clean it up.
	 */
	public void cleanup() {
	    types.cleanup();
	}
		
	/**
	 * A registry for binary types. Eventually will do some caching in the future...
	 * 
	 * @author Jan Vrany
	 *
	 */
	public static class TypeRegistry {
	    protected Map<String, IBinaryType> typeMap = new HashMap<String, IBinaryType>();
	    
	    public void cleanup() {
	        typeMap.clear();
	    }
	    
	    public IBinaryType get(String name) {
	        return typeMap.get(name);
	    }
	    
	    public void put(String name, IBinaryType type) {
	        typeMap.put(name,type);
	    }
	        
	    public void put(String name, InputStream classfile) {
	        try {
	            put(name, ClassFileReader.read(classfile, (new String(name).replace('.', '/') + ".class")));
	        } catch (ClassFormatException e) {
	            throw new RuntimeException(e);
	        } catch (IOException e) {
	            throw new RuntimeException(e);
	        }
	    }
	    
	    public void put(String name, byte[] classfile) {
	        put(name, new ByteArrayInputStream(classfile));
	    }
	}
	
	/**
	 * Takes package name as char[][] and class/package name as char[] and returns
	 * Java name of the package/class as one String.
	 *  
	 * @return Java name of the package/class as one String
	 */
	protected static String concat(char[][] pkg, char[] name) {
		StringBuilder sb = new StringBuilder();
		if (pkg != null) {
			if (pkg.length > 1) {
				for (int i = 0; i < pkg.length - 1; i++) {
					sb.append(pkg[i]);
					sb.append('.');
				}		
			}
			if (pkg.length > 0) {
				sb.append(pkg[pkg.length-1]);
			}
		}
		if (name != null) {
		    if (pkg != null && pkg.length != 0) {
		        if (pkg != null) sb.append('.');
		    }
			sb.append(name);
		}
		return sb.toString();			
	}
	
	public static abstract class Library {
	    protected File file;
	    
	   
	    
	    public abstract boolean isPackage(String packageName);
	    
	    public static class Directory extends Library {

            @Override
            public boolean isPackage(String packageName) {
                return false;
            }
	        
	    }
	}
}
