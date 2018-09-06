package stx.libjava.tests.mocks;


@stx.libjava.annotation.Package("stx:libjava/tests")
public class PublicClass {
	
	private String privateField;
	protected String protectedField;
	public String publicField;
	String packagePrivateField;
	
	private static String privateStaticField;
	protected static String protectedStaticField;
	public static String publicStaticField;
	static String packagePrivateStaticField;
	
	private static String privateStaticMethod() {
		return "privateStatic";
	}
	
	protected static String protectedStaticMethod() {
		return "protectedStatic";
	}
	
	public static String publicStaticMethod() {
		return "publicStatic";
	}
	
	static String packagePrivateStaticMethod() {
		return "packagePrivateStatic";
	}
	
	private String privateMethod() {
		return "private";
	}
	
	protected String protectedMethod() {
		return "protected";
	}
	
	public String publicMethod() {
		return "public";
	}
	
	String packagePrivateMethod() {
		return "packagePrivate";
	}
}
