package stx.libjava.benchmarks;

public class OverloadedMethods {

	public OverloadedMethods doSmth(int i) {
		return this;
	}

	public OverloadedMethods doSmth(char c) {
		return this;
	}

	public OverloadedMethods doSmth(Object o) {
		return this;
	}

	public static void main(String args[]) {	
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
    }

	public static long runBenchmarkJ(int n) {
		OverloadedMethods inst = new OverloadedMethods();
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			inst.doSmth(0);
			inst.doSmth('c');
			inst.doSmth(inst);
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}
