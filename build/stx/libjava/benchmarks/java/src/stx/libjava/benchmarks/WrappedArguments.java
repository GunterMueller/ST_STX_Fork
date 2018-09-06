package stx.libjava.benchmarks;

public class WrappedArguments {

	public WrappedArguments doSmth(Integer i) {
		return this;
	}

	public static void main(String args[]) {		
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
    }

	public static long runBenchmarkJ(int n) {
		WrappedArguments inst = new WrappedArguments();
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			inst.doSmth(i);
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}
