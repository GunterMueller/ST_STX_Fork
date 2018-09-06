package stx.libjava.tests.mocks;

/**
 * A helper class for tests for issue #182
 * 
 * @see https://swing.fit.cvut.cz/projects/stx-jv/ticket/182
 */
public class Issue182 {
	public void loopFor(int secs) {
		long deadline = System.currentTimeMillis() + (long)secs * 1000;
		while ( System.currentTimeMillis() < deadline) {
			loopIteration();
		}
	}
	
	public void loopIteration() {
		try {
			Integer.class.hashCode();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
