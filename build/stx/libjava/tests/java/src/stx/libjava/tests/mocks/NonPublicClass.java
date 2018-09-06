package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
class NonPublicClass {
	
	private String privateField;
	protected String protectedField;
	public String publicField;
	
	private static String privateStaticField;
	protected static String protectedStaticField;
	public static String publicStaticField;
	
	private static String privateStaticMethod() {
		return "privateStatic";
	}
	
	protected static String protectedStaticMethod() {
		return "protectedStatic";
	}
	
	public static String publicStaticMethod() {
		return "publicStatic";
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
}
