package stx.libjava.tests.lang;

import org.junit.Test;
import static org.junit.Assert.*;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ThreadJoinTests {

	@Test
	public void testJoiningThreads() {
		NewThread ob1 = new NewThread("One");
		NewThread ob2 = new NewThread("Two");
		NewThread ob3 = new NewThread("Three");
		assertTrue(ob1.t.isAlive());
		assertTrue(ob2.t.isAlive());
		assertTrue(ob3.t.isAlive());
		try {			
			ob1.t.join();
			ob2.t.join();
			ob3.t.join();
		} catch (InterruptedException e) {
			System.out.println("Main thread Interrupted");
		}
		assertFalse(ob1.t.isAlive());
		assertFalse(ob2.t.isAlive());
		assertFalse(ob3.t.isAlive());		
	}

}

class NewThread implements Runnable {
	String name; // name of thread
	Thread t;

	NewThread(String threadname) {
		name = threadname;
		t = new Thread(this, name);		
		t.start(); // Start the thread
	}

	public void run() {
		try {
			for (int i = 5; i > 0; i--) {
				Thread.sleep(1000);
			}
		} catch (InterruptedException e) {
			System.out.println(name + " interrupted.");
		}
	}
}
