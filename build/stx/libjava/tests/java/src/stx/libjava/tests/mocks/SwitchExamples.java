package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class SwitchExamples {

	public int switchChar(char c) {
		switch (c) {
		case 'a':
			return 0;
		case 'b':
			return 1;
		case 'c':
			return 2;
		default:
			return 3;
		}
	}
	
	public int switchInt(int c) {
		switch (c) {
		case 0:
			return 0;
		case 1000:
			return 1;
		case -1000:
			return -1;
		default:
			return 2;
		}
	}

}
