package stx.libjava.tests.lib.java.util.jar;

import static org.junit.Assert.*;

import java.io.IOException;
import java.io.InputStream;
import java.security.CryptoPrimitive;
import java.security.cert.Certificate;
import java.util.Collections;
import java.util.EnumSet;
import java.util.Enumeration;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.junit.Test;

import sun.security.util.DisabledAlgorithmConstraints;

/**
 * Regression tests for JarFile 
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tests")
public class JarFileTests {
    
    /**
     * This test tests signed JAR files. As of 2013-09-06, it works
     * in interpreted mode but fails when JIT is on. 
     */     
    @Test    
    public void signed_jar_01() {
    	/* 
    	 * Test file is signed using MD5withRSA algorithm that has been disabled
    	 * in some versions of OpenJDK (and possibly elsewhere too - namely 
    	 * OpenJDK 7 update 111, Debian 2.7.2 has it disabled. In that case this 
    	 * test fail. 
    	 * 
    	 * So first check if MD5withRSA enabled and if not, skip the test. See
    	 * sun.security.pkcs.SignerInfo, line ~ 389. However, we need to be careful
    	 * here - some old JDKs have no CryptoPrimitive class and so on (older JDK 6)
    	 * So, catch ClassNotFoundException and eventually proceed, assuming old JDKs
    	 * have "MD5withRSA" enabled. Sigh, so hacky.
    	 */
    	try {
    		Set<CryptoPrimitive> sigset = Collections.unmodifiableSet(EnumSet.of(CryptoPrimitive.SIGNATURE));
    		DisabledAlgorithmConstraints constraints = new DisabledAlgorithmConstraints("jdk.jar.disabledAlgorithms");
    		org.junit.Assume.assumeTrue(constraints.permits(sigset, "MD5withRSA", null));    	
    	} catch (Exception e) {
    		if (!(e instanceof ClassNotFoundException)) {
    			/* 
    			 * Some class has not been found when executing the code above.
    			 * This could mean we're running on an oldish JDK, in that case
    			 * proceed. Otherwise, re-throw. 
    			 */
    			throw e;
    		}
    	}

        String jarfile = System.getProperty("libjava.tests.dir", "..") + "/mauve/java/src/gnu/testlet/java/util/jar/JarFile/jfaceSmall.jar";        
        try {
        	JarFile jar = new JarFile(jarfile);
        	try {
	            for (Enumeration<JarEntry> entries = jar.entries(); entries.hasMoreElements();) {
	                JarEntry entry = entries.nextElement();
	                if (entry.isDirectory()) {
	                    continue;
	                }
	                InputStream stream = null;
	                try {
	                    stream = jar.getInputStream(entry);
	                    byte[] ba = new byte[8192];
	                    int n;
	                    while ((n = stream.read(ba)) >= 0)
	                  /* keep reading */;
	                } finally {
	                    if (stream != null) {
	                        try {
	                            stream.close();
	                        } catch (IOException ignored) {
	                        }
	                    }
	                }
	                Certificate[] certs = entry.getCertificates();
	                if (certs == null || certs.length == 0) // No certificate
	                {
	                    if (!entry.getName().startsWith("META-INF")) {
	                        assertTrue("Entry " + entry.getName() + " in jar file "
	                              + jarfile + " does not have a certificate", false);                        
	                    }
	                }
	            }
        	} finally {
        		jar.close();
        	}                       
        } catch (IOException e) {            
            e.printStackTrace();
            assertTrue(e.getMessage(), false);
        }

    }

}
