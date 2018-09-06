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
package stx.libjava;

/**
 * Alien class represent 'alien' objects in system supporting
 * Translucent Objects. Not used in normally. 
 * 
 * @author Jan Vrany
 *
 */

@stx.libjava.annotation.Package("stx:libjava")
public class Alien {
	
	private static native void markAsAlienClass(Class<?> klass);
	
	static {
		Alien.markAsAlienClass(Alien.class);
	}

}
