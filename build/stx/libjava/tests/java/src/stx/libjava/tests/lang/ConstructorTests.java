package stx.libjava.tests.lang;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ConstructorTests {
	
	public static class A {
		public int f;
			
		public A(int i, int j) {
			f = i + j;
		}
		
		public A(int i) {
			this(i, 10);
		}
		
		public A() {
			this(10);
		}
		
		public A(Integer i) {
			this(i.intValue());
		}
	}
	
	public static class B extends A {
		public B(int i, int j) {
			f = i - j;
		}
		
		public B(int i) {
			super(i);
		}
		
		public B() {
			this(10);
		}		
	}
	
	public static class C extends B {
		public C(Integer i) {
			super(new Integer(i.intValue() + 1000));
		}
	}
	
	
	public static class X {
		public int f = -1;
		public X() {
			f = 1;
		}
	}
	
	public static class Y extends X {
	}
	
	public static class Z extends Y {
		public Z() {
			super();
		}
	}
	
	public static class W extends X {
	}

	@Test
	public void test_01() {
		B b = new B();
		assertEquals(20, b.f);
	}

	@Test
	public void test_02() {
		B b = new B(10, 10);
		assertEquals(0, b.f);
	}

	@Test
	public void test_03() {
		C c = new C(new Integer(10));
		assertEquals(1020, c.f);
	}
	
	@Test
	public void test_04() {
		Z z = new Z();
		assertEquals(1, z.f);
		
		Y y = new Y();
		assertEquals(1, y.f);
		
		W w = new W();
		assertEquals(1, w.f);

	}
}
