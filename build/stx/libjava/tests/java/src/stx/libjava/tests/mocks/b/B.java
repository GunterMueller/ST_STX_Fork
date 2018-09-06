package stx.libjava.tests.mocks.b;

import stx.libjava.tests.mocks.a.A;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class B extends A {
    public String method1() {
        return "B.method1()";
    }

}
