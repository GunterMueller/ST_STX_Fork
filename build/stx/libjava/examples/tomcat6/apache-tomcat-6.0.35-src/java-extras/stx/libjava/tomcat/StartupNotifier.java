package stx.libjava.tomcat;

import java.util.concurrent.CountDownLatch;

import org.apache.catalina.Lifecycle;
import org.apache.catalina.LifecycleEvent;
import org.apache.catalina.LifecycleListener;

/** 
 * A Tomcat startup notifier. Notifies all waiters once
 * the server is ready for serving. 
 * 
 * @author Jan Vrany
 * @email <jan.vrany [at] fit.cvut.cz>
 */

public class StartupNotifier implements LifecycleListener {
	
	protected static CountDownLatch startupLatch = new CountDownLatch(1); 
	protected static CountDownLatch shutdownLatch = new CountDownLatch(1);

	public void lifecycleEvent(LifecycleEvent event) {
		if (Lifecycle.AFTER_START_EVENT.equals(event.getType())) {
			startupLatch.countDown();
			return;
		}
		if (Lifecycle.AFTER_STOP_EVENT.equals(event.getType())) {
			shutdownLatch.countDown();
			return;
		}		
		
	}
	
	public static void waitUntilStarted() {
		boolean ready = false;
		while (!ready) {
			try {
				startupLatch.await();
				ready = true;
			} catch (InterruptedException e) {
				// pass through
			}
		}		
	}
	
	public static void waitUntilShuttedDown() {
		boolean ready = false;
		while (!ready) {
			try {
				shutdownLatch.await();
			} catch (InterruptedException e) {
				ready = true;
				// pass through
			}
		}		
	}
	

}
