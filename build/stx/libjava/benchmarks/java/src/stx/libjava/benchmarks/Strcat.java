// $Id: Strcat.java,v 1.5 2015-03-20 12:08:02 vrany Exp $
// http://www.bagley.org/~doug/shootout/
// Pelle Nilsson suggested we also illustrate StringBuffer
// since it is the preferred method for concatenating 
// strings in Java

package stx.libjava.benchmarks;

import java.io.IOException;

public class Strcat {
	public static long runBenchmarkJ(int n) {
		String hello = "hello\n";
		StringBuffer stringBuffer = new StringBuffer(32);
		long start = System.currentTimeMillis();
		for (int i=0; i<n; i++) {
			stringBuffer.append(hello);
		}
		long end = System.currentTimeMillis();
		return end - start;		
	}
	
	public static void main(String args[]) throws IOException {		
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
	}
}
