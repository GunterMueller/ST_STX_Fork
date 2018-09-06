/* 
 * Copyright (c) 2017 Jan Vrany
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
 * Definition of XKeysymToUnicode(). To be included in X11 client code
 */

#ifndef _XKEYSYMTOUNICODE_H_
#define _XKEYSYMTOUNICODE_H_

#include "xkeysymtounicodetable.h"

/**
 * The `XKeysymToUnicode` function translates given `KeySym` to corresponding
 * Unicode code point. If given `KeySym` has no codepoint associated (for 
 * example,`XK_Num_Lock` or `XK_Left`) then 0 (zero) is returned.  
 */
static uint16_t XKeysymToUnicode(KeySym ks) {
    /*
     * Luckily, for some most commonly used characters (more or less ASCII ones) 
     * the `KeySym` value is the same as its Unicode codepoint. For these we dont
     * need to bother looking them up. This speeds up this function in common 
     * cases.
     */
    if ( (XKEYSYMTOUNICODE_DIRECT_LO <= ks) && (ks <= XKEYSYMTOUNICODE_DIRECT_HI) ) {
        return (uint16_t)ks;
    } else {
        /*
         * So the `KeySym` value is different from its Unicode codepoint.
         * Do a binary search in the table...
         */
        int first = 0;
        int last = xkeysymtounicode_table_size - 1;
        int middle;
        while ( first <= last ) {
            middle = (first + last) / 2;        
            if ( xkeysymtounicode_table[middle].keysym < ks) {
                first = middle + 1;
            } else if ( xkeysymtounicode_table[middle].keysym > ks) {
                last = middle - 1;                
            } else {
                return xkeysymtounicode_table[middle].codepoint;
            }
        }
        /* 
         * If not found, retrun 0 to indicate there's no Unicode character
         * associated with given `KeySym` (such as `XK_Num_Lock` and alike)  
         */
        return (uint16_t)0;
    }
}


#endif//_XKEYSYMTOUNICODE_H_




