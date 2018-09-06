package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MissingMethodB extends MissingMethodA implements MissingMethodI {
	public int missingVirtual() {
		return 10;
	}
	
	public static int missingStatic() {
		return 20;
	}
	
	public int missingSoecial() {
		return 30;
	}
	
	public int missingInterface() {
		return 40;
	}
	
}
