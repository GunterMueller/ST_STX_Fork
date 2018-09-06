/*
 * COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
 * COPYRIGHT (c) 2014-2015 by Tomas Heger
 *                            SWING Research Group, Czech Technical University in Prague
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice. This software may not
 * be provided or otherwise made available to, or used by, any
 * other person. No title to or ownership of the software is
 * hereby transferred.
 */
package stx.libjava.tools.environment.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import stx.libjava.tools.environment.ReflectiveType;
import stx.libjava.tools.environment.tests.mocks.InnerClasses.InnerClass1;
import stx.libjava.tools.text.Highlighter;
import stx.libjava.tools.text.Highlighter.HighlightingScanner;

public class ReflectiveNestedTypeTests {

	/**
	 * ReflectiveNestedType.getName() method test.
	 */
	@Test
	public void test_getName() {
		ReflectiveType type = new ReflectiveType(InnerClass1.class);
		assertEquals(
				"stx/libjava/tools/environment/tests/mocks/InnerClasses$InnerClass1",
				new String(type.getName()));
	}

	/**
	 * ReflectiveNestedType.getName() method test.
	 */
	@Test
	public void test_getName1() {
		HighlightingScanner hs = new HighlightingScanner(true, true, true, 0,
				0, null, null, true);
		ReflectiveType type = new ReflectiveType(hs.getClass());
		assertEquals("stx/libjava/tools/text/Highlighter$HighlightingScanner",
				new String(type.getName()));
	}

	/**
	 * ReflectiveNestedType.getEnclosingTypeName() method test.
	 */
	@Test
	public void test_getEnclosingTypeName() {
		ReflectiveType type = new ReflectiveType(InnerClass1.class);
		char[] enclosingTypeName = type.getEnclosingTypeName();
		assertEquals("stx/libjava/tools/environment/tests/mocks/InnerClasses",
				new String(enclosingTypeName));
	}

	/**
	 * ReflectiveNestedType.getEnclosingTypeName() method test.
	 */
	@Test
	public void test_getEnclosingTypeName1() {
		HighlightingScanner hs = new HighlightingScanner(true, true, true, 0,
				0, null, null, true);
		ReflectiveType type = new ReflectiveType(hs.getClass());
		char[] enclosingTypeName = type.getEnclosingTypeName();
		assertEquals("stx/libjava/tools/text/Highlighter", new String(
				enclosingTypeName));
	}

	/**
	 * ReflectiveNestedType.getEnclosingTypeName() method test.
	 */
	@Test
	public void test_getEnclosingTypeName2() {
		Highlighter h = new Highlighter();
		ReflectiveType type = new ReflectiveType(h.getClass());
		char[] enclosingTypeName = type.getEnclosingTypeName();
		assertEquals(null, enclosingTypeName);
	}

}
