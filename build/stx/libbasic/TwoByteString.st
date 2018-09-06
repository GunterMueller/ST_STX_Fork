"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

CharacterArray variableWordSubclass:#TwoByteString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!TwoByteString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    TwoByteStrings are like strings, but storing 16bits per character.
    The integration of them into the system is not completed ....

    [author:]
        Claus Gittinger

    [see also:]
        Text JISEncodedString
        StringCollection
"
! !

!TwoByteString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords)

    "
     TwoByteString initialize
    "

    "Modified: 22.4.1996 / 16:14:14 / cg"
! !

!TwoByteString class methodsFor:'instance creation'!

basicNew:anInteger
    "return a new empty string with anInteger characters"

    ^ (super basicNew:anInteger) atAllPut:(Character space)

    "Modified: 26.2.1996 / 14:38:47 / cg"
!

uninitializedNew:anInteger
    "return a new empty string with anInteger characters"

    ^ super basicNew:anInteger

    "
        self uninitializedNew:10
    "
! !

!TwoByteString methodsFor:'accessing'!

basicAt:index
    "return the character at position index, an Integer
     - reimplemented here since we return 16-bit characters"

    |val|

    val := super basicAt:index.
    ^ Character value:val

    "Modified: 26.2.1996 / 17:02:16 / cg"
!

basicAt:index put:aCharacter
    "store the argument, aCharacter at position index, an Integer.
     Returns aCharacter (sigh).
     - reimplemented here since we store 16-bit characters"

    super basicAt:index put:aCharacter codePoint.
    ^ aCharacter

    "Modified: 19.4.1996 / 11:16:22 / cg"
!

unsignedShortAt:index
    "return the short at position index, an Integer"

    ^ super basicAt:index.
! !

!TwoByteString methodsFor:'filling and replacing'!

replaceFrom:start to:stop with:aString startingAt:repStart
    "replace the characters starting at index start, anInteger and ending
     at stop, anInteger with characters from aString starting at repStart.
     Return the receiver.

     - reimplemented here for speed"

%{  /* NOCONTEXT */

#ifndef NO_PRIM_STRING
    if (__bothSmallInteger(start, stop)) {
        int len;
        int index1 = __intVal(start);
        int index2 = __intVal(stop);
        int count = index2 - index1 + 1;

        if (count <= 0) {
             RETURN (self);
        }
        len = __twoByteStringSize(self);
        if ((index2 <= len) && (index1 > 0)) {
            int repIndex = __intVal(repStart);

            if (__isStringLike(aString)) {
                int repLen = __stringSize(aString);
                if ((repIndex > 0) && ((repIndex + count - 1) <= repLen)) {
                    REGISTER unsigned char *srcp = __stringVal(aString) + repIndex - 1;
                    REGISTER unsigned short *dstp  = __twoByteStringVal(self) + index1 - 1;

                    while (count-- > 0) {
                        *dstp++ = *srcp++;
                    }
                    RETURN (self);
                }
            } else  if (__isTwoByteString(aString) || __isUnicode16String(aString)) {
                int repLen = __twoByteStringSize(aString);
                if ((repIndex > 0) && ((repIndex + count - 1) <= repLen)) {
                    REGISTER unsigned short *srcp  = __twoByteStringVal(aString) + repIndex - 1;
                    REGISTER unsigned short *dstp = __twoByteStringVal(self) + index1 - 1;

                    if (aString == self) {
                        /* take care of overlapping copy */
                        memmove(dstp, srcp, count*sizeof(short));
                        RETURN (self);
                    }
                    if (count > 5) {
                        memcpy(dstp, srcp, count*sizeof(short));
                    } else {
                        while (count-- > 0) {
                            *dstp++ = *srcp++;
                        }
                    }
                    RETURN (self);
                }
            }
        }
    }
#endif
%}.
    "/ arrive here if any index arg is out o range, or the source is neither a string,
    "/ nor a two-byte string.
    ^ super replaceFrom:start to:stop with:aString startingAt:repStart

    "
     'hello world' asUnicode16String replaceFrom:1 to:5 with:'123456' startingAt:2
     'hello world' asUnicode16String replaceFrom:1 to:5 with:'123456' asUnicode16String startingAt:2
     'hello world' asUnicode16String replaceFrom:1 to:0 with:'123456' startingAt:2
     'hello' asUnicode16String replaceFrom:1 to:6 with:'123456' startingAt:2
     'hello world' asUnicode16String replaceFrom:1 to:1 with:'123456' startingAt:2
    "
! !

!TwoByteString methodsFor:'queries'!

bitsPerCharacter
    "return the number of bits each character has.
     Here, 16 is returned (storing double byte characters)."

    ^ 16

    "Modified: 20.4.1996 / 23:08:38 / cg"
!

bytesPerCharacter
    "return the number of bytes each character has.
     Here, 2 is returned (storing double byte characters)."

    ^ 2
!

characterSize
    "answer the size in bits of my largest character (actually only 7, 8 or 16)"

%{  /* NOCONTEXT */

    REGISTER unsigned short *sp = __twoByteStringVal(self);
    REGISTER unsigned short *last = sp + __twoByteStringSize(self);
    OBJ cls = __qClass(self);
    int has8BitChars = 0;

    if (cls != Unicode16String && cls != TwoByteString) {
        sp += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars)) / 2;
    }

#if __POINTER_SIZE__ == 8
    if (sizeof(unsigned INT) == 8) {
        if (!has8BitChars) {
            for ( ; (sp+4) <= last; sp += 4) {
                if (*(unsigned INT *)sp & 0xFF80FF80FF80FF80) {
                    /* there are at least 8-bit chars - check for more */
                    has8BitChars = 1;
                    break;
                }
            }
        }
        for ( ; (sp+4) <= last; sp += 4) {
            if (*(unsigned INT *)sp & 0xFF00FF00FF00FF00) {
                RETURN(__mkSmallInteger(16));
            }
        }
    }
#endif
    if (sizeof(unsigned int) == 4) {
        if (!has8BitChars) {
            for ( ; (sp+2) <= last; sp += 2) {
                if (*(unsigned int *)sp & 0xFF80FF80) {
                    /* there are at least 8-bit chars - check for more */
                    has8BitChars = 1;
                    break;
                }
            }
        }
        for ( ; (sp+2) <= last; sp += 2) {
            if (*(unsigned int *)sp & 0xFF00FF00) {
                RETURN(__mkSmallInteger(16));
            }
        }
    }
    if (!has8BitChars) {
        for ( ; sp < last; sp++) {
            if (*sp & 0xFF80) {
                /* there are at least 8-bit chars - check for more */
                has8BitChars = 1;
                break;
            }
        }
    }
    for ( ; sp < last; sp++) {
        if (*sp & 0xFF00) {
            RETURN(__mkSmallInteger(16));
        }
    }
    RETURN (__mkSmallInteger(has8BitChars ? 8 : 7));
%}.

    "
     'hello world' asUnicode16String characterSize
     'hello worldüäö' asUnicode16String characterSize
     'a' asUnicode16String characterSize
     'ü' asUnicode16String characterSize
     'aa' asUnicode16String characterSize
     'aü' asUnicode16String characterSize
     'aaa' asUnicode16String characterSize
     'aaü' asUnicode16String characterSize
     'aaaü' asUnicode16String characterSize
     'aaaa' asUnicode16String characterSize
     'aaaaü' asUnicode16String characterSize
    "
!

containsNon7BitAscii
    "return true, if the underlying string contains 8BitCharacters (or widers)
     (i.e. if it is non-ascii)"

%{  /* NOCONTEXT */

    REGISTER unsigned short *sp = __twoByteStringVal(self);
    REGISTER unsigned short *last = sp + __twoByteStringSize(self);
    OBJ cls = __qClass(self);

    if ( cls != Unicode16String && cls != TwoByteString) {
        sp += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars)) / 2;
    }
#if __POINTER_SIZE__ == 8
    if (sizeof(unsigned INT) == 8) {
        for ( ; (sp+4) <= last; sp += 4) {
            if (*(unsigned INT *)sp & 0xFF80FF80FF80FF80) {
                RETURN ( true );
            }
        }
    }
#endif
    if (sizeof(unsigned int) == 4) {
        for ( ; (sp+2) <= last; sp += 2) {
            if (*(unsigned int *)sp & 0xFF80FF80) {
                RETURN ( true );
            }
        }
    }
    for ( ; sp < last; sp++) {
        if (*sp & 0xFF80) {
            RETURN ( true );
        }
    }
    RETURN (false);
%}.

    "
     'hello world' asUnicode16String containsNon7BitAscii
     'hello worldüäö' asUnicode16String containsNon7BitAscii
     'ü' asUnicode16String containsNon7BitAscii
     'aü' asUnicode16String containsNon7BitAscii
     'aaü' asUnicode16String containsNon7BitAscii
     'aaaü' asUnicode16String containsNon7BitAscii
     'aaaaü' asUnicode16String containsNon7BitAscii
     'aaaaa' asUnicode16String containsNon7BitAscii
    "
!

isWideString
    "true if I require more than one byte per character"

    ^ true
! !

!TwoByteString class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


TwoByteString initialize!
