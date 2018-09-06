package stx.libjava.tests.mocks;

interface NonPublicInterface {


		public String publicMethod();

		abstract String abstractMethod();
		
		public abstract String publicAbstractMethod();	
		
		String packagePrivateMethod();
}
