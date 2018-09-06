package stx.libjava.benchmarks;

public class MethodInvocation {

	public MethodInvocation doSmth() {
		return this;
	}

	public static void main(String args[]) {		
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
    }

	public static long runBenchmarkJ(int n) {
		MethodInvocation inst = new MethodInvocation();
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			inst.doSmth();
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}
