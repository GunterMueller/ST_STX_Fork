package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class SimpleInheritingClass extends SimpleAbstractClass implements SimpleInterface {

	@Override
	public String bar() {
		return "bar";
	}
}
