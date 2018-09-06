package stx.libjava.benchmarks;

public class Ackerman {
	public static void main(String[] args) {
		int num = Integer.parseInt(args[0]);
		runBenchmarkJ(num);
		long time = runBenchmarkJ(num);
		System.out.println("EXECUTION TIME: " + time);
	}

	public static long runBenchmarkJ(int num) {
		long start = System.currentTimeMillis();
		Ack(3, num);
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}

    public static int Ack(int m, int n) {
		return (m == 0) ? (n + 1) : ((n == 0) ? Ack(m-1, 1) :
				Ack(m-1, Ack(m, n - 1)));
    }
}
