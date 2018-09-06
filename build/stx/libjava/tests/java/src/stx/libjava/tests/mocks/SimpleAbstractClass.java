package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public abstract class SimpleAbstractClass {

	public final static String name ="SimpleAbstractClass";
	
	public String foo() {
		return "foo";
	}
	
	public abstract String bar();
	
}
