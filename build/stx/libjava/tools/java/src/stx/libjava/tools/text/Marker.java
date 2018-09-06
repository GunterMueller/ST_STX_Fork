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
package stx.libjava.tools.text;

@stx.libjava.annotation.Package("stx:libjava/tools")
public abstract class Marker {

    /*
     * !!! IMPORTANT !!!
     *
     * When changing / adding constants, make sure they
     * are in sync with those defined in Smaltalk
     * JavaSourceHighlighter::Marker !!!
     *
     */
    public static final int MARK_KEYWORD        = 1;
    public static final int MARK_NUMBER         = 2;
    public static final int MARK_STRING         = 3;
    public static final int MARK_CHARACTER      = 4;
    public static final int MARK_COMMENT        = 5;
    public static final int MARK_JAVADOC        = 6;
    public static final int MARK_KEYWORD_FLOW   = 7;
    public static final int MARK_SELECTOR       = 8;
    public static final int MARK_FIELD          = 9;
    public static final int MARK_FIELD_ASSIGNED = 10;
    public static final int MARK_LOCAL          = 11;
    public static final int MARK_CLASS          = 12;
    

    public void mark(int kind, int from, int to) {}
}
