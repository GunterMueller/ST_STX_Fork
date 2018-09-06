package stx.libjava.benchmarks;


/** 
 * Measures performance of native method invocation
 * 
 * @author Jan Vrany
 * @email jan.vrany[at]fit.cvut.cz
 **/
public class Native1 {

	public static void main(String[] args) {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
	}
	
	public static long runBenchmarkJ(int n) {
		long start = System.currentTimeMillis();
		float f = 0.0f;
		for (int i = 1; i <= n; i++) {
			f = Float.intBitsToFloat(i);
		}
		System.out.println(f);
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
		
	}

}
