package stx.libjava.tests;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;

/**
 * A testharness implementation of testlet Harness. Meant to be run
 * under Smalltalk/X STX:LIBJAVA. 
 * 
 * @author Marcel Hlopko
 * @author Jan Vrany
 *
 */
public class TestHarness extends gnu.testlet.TestHarness {
	
	/** 
	 * A slot that keeps reference to Smalltalk
	 * class TestletTestCaseProxy. Set by the proxy
	 * when instantiating harness. See smalltalk code in
	 * TestletTestCaseProxy>>createHarness. 
	 * In Java, proxy is initialized to a Java implementation
	 * of the proxy. so things works even if not used from Smalltalk 
	 * proxy. 
	 */
	protected Proxy proxy;
	
	protected String checkPoint;
	
	@Override
	public void check(boolean result) {
		proxy.check(result);
	}

	@Override
	public void checkPoint(String name) {
		checkPoint = name;
	}

	@Override
	public void debug(String message) {
		debug(message, true);
	}

	@Override
	public void debug(String message, boolean newline) {
		if (newline) {
			proxy.message(message, Proxy.MSG_DBG);
		} else {
			proxy.message(message + "...", Proxy.MSG_DBG);
		}
	}

	@Override
	public void debug(Throwable ex) {
		StringWriter s = new StringWriter();
		ex.printStackTrace(new PrintWriter(s));
		debug("An exception occured:\n" + s.toString());
	}

	@Override
	public void debug(Object[] o, String desc) {
		StringWriter s = new StringWriter();
		for (int i = 0; i < o.length; i++ ) {
			s.append(o.toString());
			if (i != o.length) s.append(", ");
		}
		debug(desc + "(objects: " + s.toString() + ")");				
	}
	

	@Override
	public File getResourceFile(String name) {
		String filename = proxy.directory(Proxy.DIR_RES) + name.replace('#', File.separatorChar);
		return new File(filename);		
	}
	
	@Override
	public String getMailHost () {
	    return "relay.fit.cvut.cz";
	}

	@Override
	public Reader getResourceReader(String name) {		
		try {
			return new FileReader(getResourceFile(name));
		} catch (FileNotFoundException e) {			
			e.printStackTrace();
			proxy.message("Cannot get resource reader for " + name, Proxy.MSG_ERR);
			return null;			
		}
	
	}

	
	
	
	@Override
	public InputStream getResourceStream(String name) {		
		try {
			return new FileInputStream(getResourceFile(name));
		} catch (FileNotFoundException e) {			
			e.printStackTrace();
			proxy.message("Cannot get resource stream for " + name, Proxy.MSG_ERR);
			return null;			
		}
	
	}

	
	/**
	 * Provide a directory name for writing temporary files.
	 *
	 * @return The temporary directory name.
	 */
	public String getTempDirectory () {
		return proxy.directory(Proxy.DIR_TMP);
	}
	
	public String getSourceDirectory () {
		return proxy.directory(Proxy.DIR_SRC);
	}

	public String getBuildDirectory () {
		return proxy.directory(Proxy.DIR_BLD);
	}


	@Override
	public void verbose(String message) {
		proxy.message(message, Proxy.MSG_INF);		
	}
	
	class Proxy {
		
		public static final int MSG_DBG = 1;
		public static final int MSG_INF = 2;
		public static final int MSG_ERR = 3;
		
		public static final int DIR_TMP = 1;
		public static final int DIR_SRC = 2;
		public static final int DIR_RES = 3;
		public static final int DIR_BLD = 4;

		public void check(boolean result) {
			assert result;
		}

		public String directory(int type) {
			return null;
		}

		public void message(String message, int type) {
			
		}

	
	}

}
