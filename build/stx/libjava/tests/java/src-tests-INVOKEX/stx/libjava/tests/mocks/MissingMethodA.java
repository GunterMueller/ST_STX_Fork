package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MissingMethodA extends AbstractMethod implements MissingMethodI {
	public int missingVirtual() {
		return 1;
	}
	
	public static int missingStatic() {
		return 2;
	}
	
	public int missingSoecial() {
		return 3;
	}

	public int missingInterface() {
		return 4;
	}
	
	public int abstractVirtual() {
		return 5;
	}
}
