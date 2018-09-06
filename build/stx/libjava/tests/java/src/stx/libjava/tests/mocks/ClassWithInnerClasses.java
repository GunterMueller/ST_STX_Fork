package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ClassWithInnerClasses {

	class Inner {
		public String helloWorldFromInner() {
			return "hello world from inner";
		}
	};
	
	static class InnerStatic {
		public String helloWorldFromInnerStatic() {
			return "hello world from inner static";
		}
	};
	
	public static InnerStatic getInnerStatic() {
		return new InnerStatic();
	}
	
	public Inner getInner() {
		return new Inner();
	}
}
