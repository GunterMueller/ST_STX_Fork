public class CrossLangInvocation2 {

	public CrossLangInvocation2 doSmth(Object o) {
		return this;
	}

        public CrossLangInvocation2 doSmth(int i) {
                return this;
        }


	public static void main(String args[]) {
		CrossLangInvocation2 inst = new CrossLangInvocation2();
		int n = Integer.parseInt(args[0]);
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			inst.doSmth(inst);
                        inst.doSmth(1);
		}
		long end = System.currentTimeMillis();
		System.out.println("EXECUTION TIME: " + (end - start));
    }
}
