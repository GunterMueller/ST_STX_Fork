package  stx.libjava.tests.mocks;
/**
 * This class is used from Smalltalk test JavaExceptionTests
 */

import  java.lang.IllegalArgumentException;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class JavaExceptionTestsHelper {

    public int token = 0;

    public void throw_me(boolean flag) {
	if (flag)
	    throw new IllegalArgumentException();
    }

    public void call(boolean flag) {
	this.call(new ThrowCaller(), flag);
    }

    public void test_03(boolean do_throw) {
	try {
	    token = 1;
	    if (do_throw)
		throw new IllegalArgumentException();
	    token = 2;
	} finally {
	    token = 3;
	}
    }

    public void test_04(ThrowCaller thrower, boolean do_throw) {
	try {
	    token = 1;
	    thrower.call(this, do_throw);
	    token = 2;
	} finally {
	    token = 3;
	}
    }

    public void call(ThrowCaller caller, boolean flag) {
	caller.call(this, flag);
    }

    class ThrowCaller {
	public void call(JavaExceptionTestsHelper inst, boolean flag) {
	    inst.throw_me(flag);
	}
    };
}
