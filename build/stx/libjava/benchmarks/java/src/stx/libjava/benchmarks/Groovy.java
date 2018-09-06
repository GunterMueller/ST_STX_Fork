package stx.libjava.benchmarks;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;


public class Groovy {

	public static void main(String[] args) {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);

	}

	public static long runBenchmarkJ(int n) {
		Binding binding = new Binding();		
		GroovyShell shell = new GroovyShell(binding);

		long start = System.currentTimeMillis();
		
		for (int i = 0; i < n; i++) {
			shell.evaluate("3 + 4");
		}
		
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}

}