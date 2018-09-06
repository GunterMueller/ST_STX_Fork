package stx.libjava.tests.lang;

import org.junit.Test;
import stx.libjava.tests.mocks.EyeOpeningClassLoader;

import java.io.File;
import java.net.URL;
import java.net.URLClassLoader;

import static org.junit.Assert.*;

@SuppressWarnings("rawtypes")
@stx.libjava.annotation.Package("stx:libjava/tests")
public class ClassLoaderTests {

    @Test
    public void testBootstrapClassLoader() throws Exception {
        Class clazz = Class.forName("java.lang.Object");
        assertTrue(clazz.getClassLoader() == null);
        System.out.println("sun.boot.class.path: " + System.getProperty("sun.boot.class.path"));
        System.out.println("java.ext.dirs: " + System.getProperty("java.ext.dirs"));
        System.out.println("java.class.path: " + System.getProperty("java.class.path"));
    }

    @Test
    public void testSystemClassLoader() throws Exception {
        ClassLoader cl = ClassLoader.getSystemClassLoader();
        Class clazz = cl.loadClass("org.junit.Test");
        assertNotNull(clazz);
        
        /* 
         * On STX:LIBJAVA, junit4 & groovy are in ext dirs so they're loaded
         * by "ext" classloader, unlike on real JVM where those classes are
         * loaded by standard system class loader. Thus this conditional
         * assert
         */
        /* Not any longer - caused problems because Groovy than
         * could not load classes loadable by system classloader.
         */
        //if (System.getProperty("java.vm.name").equals("Smalltalk/X")) { 
        //	// STX:LIBJAVA
        //	assertEquals(cl.getParent(), clazz.getClassLoader());
        //} else {
        	// Any other VM
        	assertEquals(cl, clazz.getClassLoader());
        //}  
    }

    @Test
    public void testSystemClassLoader2() throws Exception {
        Class clazz = Class.forName("org.hamcrest.Factory");
        assertTrue(clazz.getClassLoader().equals(ClassLoader.getSystemClassLoader()));
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromRT() throws Exception {
        Class clazz = Class.forName("javax.sql.DataSource");
        assertTrue(clazz.getClassLoader() == null);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromRT2() throws Exception {
        Class clazz = Class.forName("org.xml.sax.Parser");
        assertTrue(clazz.getClassLoader() == null);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease() throws Exception {
        Class clazz = Class.forName("sun.io.CharToByteDoubleByte");
        assertTrue(clazz.getClassLoader() == null);
    }

    @Test
    public void testBootstrapCLLoadsNOTEverythingFromJavaRelease2() throws Exception {
        Class clazz = Class.forName("sun.net.spi.nameservice.dns.DNSNameService");
        ClassLoader expected = ClassLoader.getSystemClassLoader();
        ClassLoader real = clazz.getClassLoader();
        assertEquals(expected.getParent(), real);
        //WEIRD..
        assertNotSame(expected, real);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease3() throws Exception {
        Class clazz = Class.forName("javax.net.SocketFactory");
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease4() throws Exception {
        Class clazz = Class.forName("com.sun.net.ssl.TrustManager");
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease5() throws Exception {
        Class clazz = Class.forName("javax.crypto.Cipher");
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease6() throws Exception {
        Class clazz = Class.forName("sun.security.internal.spec.TlsKeyMaterialParameterSpec");
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }

    @Test
    public void testBootstrapCLLoadsEverythingFromJavaRelease7() throws Exception {
        Class clazz = Class.forName("java.lang.Thread");
        assertTrue(clazz.getClassLoader() == null);
    }

    @Test
    public void testSystemClassLoaderClassLoader() throws Exception {
        Class clazz = ClassLoader.getSystemClassLoader().getClass();
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }

    @Test
    public void testSystemClassLoaderParentClassLoader() throws Exception {
        Class clazz = ClassLoader.getSystemClassLoader().getParent().getClass();
        ClassLoader real = clazz.getClassLoader();
        assertNull(real);
    }


    @Test
    public void testWeirdDNSClassLoader() throws Exception {
        Class clazz = Class.forName("sun.net.spi.nameservice.dns.DNSNameService");
        ClassLoader real = clazz.getClassLoader().getParent();
        assertNull(real);
    }


    @Test
    public void testSystemClassLoaderLoadingRTClass() throws Exception {
        ClassLoader cl = ClassLoader.getSystemClassLoader();
        Class clazz = cl.loadClass("java.util.ArrayList");
        assertNotNull(clazz);
        assertNull(clazz.getClassLoader());
    }

    @Test
    public void testNiceClassLoaderDelegation() throws Exception {
        URL[] urls = new URL[1];
        File file = new File("foos");
        urls[0] = file.toURL();
        URLClassLoader cl = new URLClassLoader(urls);
        Class result = Class.forName("org.junit.Test", true, cl);
        
        /* 
         * On STX:LIBJAVA, junit4 & groovy are in ext dirs so they're loaded
         * by "ext" classloader, unlike on real JVM where those classes are
         * loaded by standard system class loader. Thus this conditional
         * assert
         */
        /* Not any longer - caused problems because Groovy than
         * could not load classes loadable by system classloader.
         */
        //if (System.getProperty("java.vm.name").equals("Smalltalk/X")) { 
        //	// STX:LIBJAVA
        //	assertEquals(result.getClassLoader(), ClassLoader.getSystemClassLoader().getParent());
        //} else {
        //	// Any other VM
        	assertEquals(result.getClassLoader(), ClassLoader.getSystemClassLoader());
        //}
    }

    @Test
    public void testNiceClassLoaderSelfLoading() throws Exception {
        URLClassLoader cl = new URLClassLoader(getTestClassesDirectory());
        Class result = Class.forName("Foo", true, cl);
        assertEquals(cl, result.getClassLoader());
    }

    @Test
    public void testEyeOpeningClassLoaderLoadObject() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadObject();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testEyeOpeningClassLoaderLoadRuntimeException()
            throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadRuntimeException();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testEyeOpeningClassLoaderLoadMethod() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadMethod();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testEyeOpeningClassLoaderLoadString() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadString();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testEyeOpeningClassLoaderLoadDatasource() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadDatasource();
            // no exception should be raised
        } catch (NullPointerException e) {
            // it will fail on internals, but we only care about security
            // exception
        }
        assertTrue(true);
    }

    @Test
    public void testEyeOpeningClassLoaderLoadBits() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadBits();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testEyeOpeningClassLoaderLoadArray() throws Exception {
        try {
            EyeOpeningClassLoader cl = new EyeOpeningClassLoader();
            cl.tryToLoadArray();
            assertTrue(false);
        } catch (SecurityException e) {
            assertTrue(true);
        }
    }

    @Test
    public void testParentOfSystemClassLoader() {
        ClassLoader parent = ClassLoader.getSystemClassLoader().getParent();
//		system->sun.misc.Launcher$AppClassLoader@16f0472
//		parent->sun.misc.Launcher$ExtClassLoader@18d107f
        assertNull(parent.getParent());
    }

    @Test
    public void testNiceClassLoaderSelfLoading2() throws Exception {
        URLClassLoader cl = new URLClassLoader(getTestClassesDirectory());
        Class result = Class.forName("Foo", true, cl);
        assertEquals(cl, result.getClassLoader());
        assertEquals(cl, result.getSuperclass().getClassLoader());
        assertNull(result.getDeclaredField("baz").getClass().getClassLoader());
    }

    @Test
    public void testNiceClassLoaderSelfLoadingWithPreCaching() throws Exception {
        URL[] urls = getTestClassesDirectory();
        URLClassLoader cl = new URLClassLoader(urls);
        Class result = Class.forName("Foo", true, cl);
        assertNull(result.getDeclaredField("baz").getClass().getClassLoader());
    }

    @Test
    public void testTwoSameClassesInDifferentCLsAreDifferent() throws Exception {
        URL[] urls = getTestClassesDirectory();
        URLClassLoader cl1 = new URLClassLoader(urls);
        URLClassLoader cl2 = new URLClassLoader(urls);
        Class result1 = Class.forName("Foo", true, cl1);
        Class result2 = Class.forName("Foo", true, cl2);
        assertNotSame(result1, result2);
    }

    public static URL[] getTestClassesDirectory() throws Exception {
        String[] paths = {"classloader-tests-classes/bin",
                System.getProperty("libjava.tests.dir") + "/java/classloader-tests-classes/bin"};
        URL[] result = new URL[paths.length];
        for (int i = 0; i < paths.length; i++) {
            result[i] = new File(paths[i]).toURL();
        }
        return result;
    }
}
