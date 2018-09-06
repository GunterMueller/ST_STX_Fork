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
package stx.libjava.tools.environment.internal;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URISyntaxException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * A specialized {@link ReflectiveClassLoader} to reflect upon {@link URLClassLoader}.
 * In addition to checks done in {@link ReflectiveClassLoader}, it looks along the class
 * path for classes and packages available in order to provide more accurate answers.
 *
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
public class ReflectiveURLClassLoader extends ReflectiveClassLoader {
    protected URL[] classpath;
    protected URL[] pending;
    protected int   pendingStart;
    protected Library[] libraries;
    protected int librariesCount;

    /**
     * A shared cache of already created libraries. Some libraries are huge
     * so it pays off to cache them. Especially for .jar files which are
     * costly to open and scan (specially under stx:libjava!)
     */
    protected static Map<File, Library> LIBRARIES = new HashMap<File, Library>();


    protected ReflectiveURLClassLoader(URLClassLoader loader) {
        this(loader, loader.getURLs());
    }

    protected ReflectiveURLClassLoader(URLClassLoader loader, URL[] classpath) {
        super(loader);
        this.classpath = classpath;
        this.pending = new URL[classpath.length];
        System.arraycopy(classpath, 0, pending, 0, classpath.length);
        pendingStart = 0;
        libraries = new ReflectiveURLClassLoader.Library[classpath.length];
        librariesCount = 0;
    }

    public boolean isPackage(String packageName, String packageNameSlashed) {
        // Try parent class loader, consult classes field....
        if (super.isPackage(packageName, packageNameSlashed)) {
            return true;
        }

        // Look along already opened and scanned libraries...
        for (int i = 0; i < librariesCount; i++) {
            Library l = libraries[i];
            if (l != null && l.isPackage(packageNameSlashed)) {
                return true;
            }
        }
        // OK, no library already opened contains the package,
        // so open more if there is more...
        while (pendingStart < pending.length) {
            try {
                File f = new File(pending[pendingStart].toURI());
                Library l = LIBRARIES.get(f);
                if (l == null && f.exists()) {
                    if (f.isDirectory()) {
                        l = new Dir(f);
                        LIBRARIES.put(f, l);
                    } else {
                        if (! f.getPath().endsWith("so") && ! f.getPath().endsWith("dll") ) {
                            l = new Jar(f);
                            LIBRARIES.put(f, l);
                        }
                    }
                }
                libraries[librariesCount] = l;
                pendingStart++;
                librariesCount++;
                if (l != null && l.isPackage(packageNameSlashed)) {
                    return true;
                }
            } catch (URISyntaxException use) {
                System.err.println("Failed to conver file URL to URI !?!: " + use.getMessage());
            }
        }
        // Package not found...
        return false;
    }

    protected static abstract class Library {
        public abstract boolean isPackage(String packageName);
    }

    protected static class Jar extends ReflectiveURLClassLoader.Library {
        protected File file;
        protected long fileLastModified;
        protected Set<String> packages;

        protected Jar(File file) {
            this.file = file;
        }

        public boolean isPackage(String packageNameSlashed) {
            if (packages == null || file.lastModified() > fileLastModified ) {
                scan();
            }
            boolean isPackage = packages.contains(packageNameSlashed);
            return isPackage;
        }

        protected void scan() {
            ZipFile zip = null;
            packages = new HashSet<String>();
            try {
                zip = new ZipFile(file);
                Enumeration<? extends ZipEntry> entries = zip.entries();
                while (entries.hasMoreElements()) {
                    String entryName = entries.nextElement().getName();
                    if (entryName.endsWith(".class")) {
                        int slash = entryName.indexOf('/');
                        while (slash != -1) {
                            String packageName = entryName.substring(0, slash);
                            packages.add(packageName);
                            slash = entryName.indexOf('/', slash + 1);
                        }
                    }
                }
            } catch (IOException e) {
                /*
                 * No, do not log for now. The problem is that on (Open)JDK 7 this trigger
                 * some not-yet-implemented natives in java.nio.*. Sad...
                 */
                // LOGGER.log(Level.INFO, "Failed to open .jar file: " + url.getPath() , e);
                System.err.println("Failed to open .jar file: " + file.getPath());
            } finally {
                if (zip != null) {
                    try {
                        zip.close();
                    } catch (IOException e) {
                        /*
                         * No, do not log for now. The problem is that on (Open)JDK 7 this trigger
                         * some not-yet-implemented natives in java.nio.*. Sad...
                         */
                        // LOGGER.log(Level.INFO, "Failed to open .jar file: " + url.getPath() , e);
                        System.err.println("Failed to close .jar file: " + file.getPath());                                        }
                }
                fileLastModified = file.lastModified();
            }
        }
    }

    protected static class Dir extends ReflectiveURLClassLoader.Library  {
        protected File directory;

        protected Dir(File file) {
            directory = file;
        }

        public boolean isPackage(String packageNameSlashed) {
            return new File(directory, packageNameSlashed).isDirectory();
        }
    }
}
