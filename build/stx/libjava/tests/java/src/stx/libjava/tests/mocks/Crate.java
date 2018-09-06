package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class Crate {

	private int intVar;
	private double doubleVar;
	private long longVar;
	private String stringVar;



	public int getIntVar() {

		return intVar;
	}
	public void setIntVar(int intVar) {
		this.intVar = intVar;
	}
	public double getDoubleVar() {
		return doubleVar;
	}
	public void setDoubleVar(double doubleVar) {
		this.doubleVar = doubleVar;
	}
	public long getLongVar() {
		return longVar;
	}
	public void setLongVar(long longVar) {
		this.longVar = longVar;
	}
	public String getStringVar() {
		return stringVar;
	}
	public void setStringVar(String stringVar) {
		this.stringVar = stringVar;
	}

	public void throwSomeException(int i) throws InterruptedException, IllegalArgumentException {
	    if (i < 0) {
		throw new InterruptedException();
	    } else {
		throw new IllegalArgumentException();
	    }
	}
}
