package stx.libjava.tools.environment.tests.mocks;

public class InnerClasses {
	
	public void method() {

		final class ClassInMethod {
			private int aa;
			private int bb;

			public void init(int a, int b) {
				aa = a;
				bb = b;
			}
	
			
		}

		ClassInMethod cim = new ClassInMethod();
		cim.init(1, 2);
	}
	
	
	public class InnerClass1 {
		private int c;
	}
	
	public class InnerClass2 {
		private int d;
	}
	
	
	interface Interface1 {
        public void doSomething();
    }
	
	Interface1 anonymousClass = new Interface1() {
        String name = "anonymous";
        
        public void doSomething() {
            System.out.println("Hello there");
        }
    };
    

	
}
