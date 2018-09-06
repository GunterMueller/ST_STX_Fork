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

import static org.junit.Assert.assertTrue;

import org.eclipse.jdt.internal.compiler.env.INameEnvironment;
import org.junit.Before;
import org.junit.Test;

import stx.libjava.tools.environment.ReflectiveEnvironment;

public class ReflectiveEnvironmentTests {
	public INameEnvironment env;
	
	@Before
	public void setUp() {
		env = new ReflectiveEnvironment();
	}

	@Test
	public void test_isPackage_01() {
		assertTrue(env.isPackage(new char[][] {{'j', 'a', 'v' , 'a'}}, new char[] {'s', 'q' , 'l'} ));
	}

}
