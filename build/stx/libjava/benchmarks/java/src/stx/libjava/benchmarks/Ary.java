// $Id: Ary.java,v 1.5 2015-03-20 12:08:02 vrany Exp $
// http://www.bagley.org/~doug/shootout/

// this program is modified from:
//   http://cm.bell-labs.com/cm/cs/who/bwk/interps/pap.html
// Timing Trials, or, the Trials of Timing: Experiments with Scripting
// and User-Interface Languages</a> by Brian W. Kernighan and
// Christopher J. Van Wyk.

package stx.libjava.benchmarks;

public class Ary {
	public static void main(String args[]) {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
    }

	public static long runBenchmarkJ(int n) {
		int i;
		int j;
		int k;
		int x[] = new int[n];
		int y[] = new int[n];

		long start = System.currentTimeMillis();
		for (i = 0; i < n; i++)
			x[i] = i + 1;
		for (k = 0; k < 1000; k++ )
			for (j = n-1; j >= 0; j--)
				y[j] += x[j];
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}
