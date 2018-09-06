package stx.libjava.tests.lang;

import org.junit.Test;
import static org.junit.Assert.*;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ThreadOrderingTests extends Thread {

	private String flag;
	private final static String manager = "Manager was last to set the flag";
	private final static String thread = "Thread was last to set the flag";

	public void run() {
		synchronized (this) {
			setTheFlag(thread);
		}
	}

	private synchronized void setTheFlag(String code) {
		flag = code;
	}

	@Test
	public void testOrdering() {
		try {
		ThreadOrderingTests t = new ThreadOrderingTests();
		t.start();
		setTheFlag(manager);
		t.join();
		assertTrue(manager.equals(flag));
		} catch (InterruptedException ignored) {}
	}
}
