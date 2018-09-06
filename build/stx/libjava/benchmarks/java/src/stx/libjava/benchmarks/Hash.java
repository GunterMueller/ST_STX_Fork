// $Id: Hash.java,v 1.5 2015-03-20 12:08:02 vrany Exp $
// http://www.bagley.org/~doug/shootout/

// this program is modified from:
//   http://cm.bell-labs.com/cm/cs/who/bwk/interps/pap.html
// Timing Trials, or, the Trials of Timing: Experiments with Scripting
// and User-Interface Languages</a> by Brian W. Kernighan and
// Christopher J. Van Wyk.

package stx.libjava.benchmarks;

import java.io.*;
import java.util.*;

public class Hash {

	public static void main(String args[]) throws IOException {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
	}

	public static long runBenchmarkJ(int n) {
		@SuppressWarnings("unused")
		int i, c;			
		// the original program used:
		// Hashtable ht = new Hashtable();
		// John Olsson points out that Hashtable is for synchronized access
		// and we should use instead:
		HashMap<String, Integer> ht = new HashMap<String, Integer>();
		long start = System.currentTimeMillis();
		c = 0;
		for (i = 1; i <= n; i++)
			ht.put(Integer.toString(i, 16), new Integer(i));
		for (i = 1; i <= n; i++)
			// The original code converted to decimal string this way:
			// if (ht.containsKey(i+""))
			if (ht.containsKey(Integer.toString(i, 10)))
				c++;
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}

