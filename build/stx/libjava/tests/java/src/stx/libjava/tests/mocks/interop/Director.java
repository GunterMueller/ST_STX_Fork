package stx.libjava.tests.mocks.interop;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class Director extends Person {
    public void setTag1(int i) {
        tag1 = new Integer(i + 10);
    }
}
