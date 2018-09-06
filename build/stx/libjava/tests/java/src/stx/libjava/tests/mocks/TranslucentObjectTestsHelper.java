package stx.libjava.tests.mocks;

import java.util.ArrayList;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class TranslucentObjectTestsHelper {
	public ArrayList<Object> createArrayList() {
		return new ArrayList<Object>();
	}
	
	public boolean isEmpty(String s) {
		return s.isEmpty();
	}

}
