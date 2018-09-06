package stx.libjava.tests.mocks.instance_static;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class InheritInstanceStuffWithStatic extends SuperWithInstance{

	public static int instField = 1;
	//cannot override method with the same name+selector
	//nobody cares about static :)
//	public static int instMethod() {
//		return 1;
//	}	
}
