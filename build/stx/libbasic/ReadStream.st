"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

PositionableStream subclass:#ReadStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!ReadStream primitiveDefinitions!
%{

#include <stdio.h>
#define _STDIO_H_INCLUDED_
#include <stdlib.h>
#include <string.h>
#include <memory.h>

%}
! !

!ReadStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    ReadStream defines protocol for reading streamwise over collections.

    [author:]
	Claus Gittinger

"
! !

!ReadStream class methodsFor:'blocked instance creation'!

with:aCollection
    "with on readStream makes no sense
     - what do you want to read from the end of a collection?"
    <resource:#obsolete>

    self obsoleteMethodWarning:'WARNING: with: should not be used for ReadStreams - use #on:'.
    ^ super with:aCollection
! !

!ReadStream methodsFor:'Compatibility-Squeak'!

next: n into: aCollection startingAt: startIndex
    "Read n objects into the given collection.
     Return aCollection or a partial copy if less than
     n elements have been read."

    | max |

    collection notNil ifTrue:[
        max := (readLimit - position) min: n.
        aCollection
            replaceFrom: startIndex
            to: startIndex+max-1
            with: collection
            startingAt: position+1.
        position := position + max.
        max = n
            ifTrue:[^ aCollection]
            ifFalse:[^ aCollection copyFrom: 1 to: startIndex+max-1].
    ].

    ^ super next:n into:aCollection startingAt:startIndex.


    "Modified: / 12-09-2010 / 13:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!ReadStream methodsFor:'converting'!

readStream
    "return a readStream from the receiver. Since this is already
     a readStream, return self."

    ^ self
!

readStreamOrNil
    "return a readStream from the receiver. Since this is already
     a readStream, return self.

     This method has been defined for protocol copmatibility with Filename"

    ^ self
! !

!ReadStream methodsFor:'emphasis'!

emphasis
    "return the emphasis of the current (i.e. next returned by #next)
     element. Streams on a string will return nil for all elements.
     Streams on collections which nothing at all about emphasises,
     will report an error."

    ^ collection emphasisAt:(position + 1).

    "
     |t s|

     t := 'hello world' asText
		emphasizeFrom:1 to:5 with:#bold;
		emphasizeFrom:7 to:11 with:#italic.

     s := t readStream.
     [s atEnd] whileFalse:[
	Transcript show:(s emphasis); show:' '.
	Transcript show:''''; show:(s next); showCR:''''.
     ].
    "

    "Modified: 15.5.1996 / 17:30:33 / cg"
! !

!ReadStream methodsFor:'queries'!

collectionSize
    "return the overall number of elements in the streamed collection
     (both already read and to be read)."

    ^ collection size

    "Created: / 30-07-2013 / 20:55:51 / cg"
!

copyFrom:beginning to:end
    ^ collection copyFrom:beginning to:end
!

isReadable
    "return true, if reading is supported by the receiver.
     Here, true is always returned."

    ^ true

    "Modified: 4.10.1997 / 17:59:21 / cg"
!

isWritable
    "return true, if writing is supported by the receiver.
     This has to be redefined in concrete subclasses."

    ^ false
!

remainingSize
    "return the number of remaining elements in the streamed collection."

    ^ collection size - position

    "Created: / 30-07-2013 / 20:18:12 / cg"
!

size
    "return the number of remaining elements in the streamed collection."

    "/ will change back soon for VW and Squeak compatibility.
    "/ ^ self collectionSize.
    ^  self remainingSize

    "Modified (comment): / 30-07-2013 / 20:57:23 / cg"
! !

!ReadStream methodsFor:'reading'!

next
    "return the next element; advance read pointer.
     return nil, if there is no next element.
     - tuned for a bit more speed on String/ByteArray/Array-Streams"

    |ret|

%{  /* NOCONTEXT */

    REGISTER INT pos;
    unsigned ch;
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isNonNilObject(coll) && __bothSmallInteger(p, l)) {
        pos = __intVal(p);
        if (pos >= 0 && pos < __intVal(l)) {
            OBJ cls, ret;

            cls = __qClass(coll);
            if (cls == @global(String) || cls == @global(ImmutableString) || cls == @global(Symbol)) {
                if (pos < __stringSize(coll)) {
                    ch = __stringVal(coll)[pos];
                    ret = __MKCHARACTER(ch);
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            } else if (cls == @global(ByteArray)) {
                if (pos < __byteArraySize(coll)) {
                    ch = __ByteArrayInstPtr(coll)->ba_element[pos];
                    ret = __mkSmallInteger(ch);
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            } else if (cls == @global(Unicode16String)) {
                if (pos < __unicode16StringSize(coll)) {
                    ch = __unicode16StringVal(coll)[pos];
                    ret = __MKUCHARACTER(ch);
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            } else if (cls == @global(Array)) {
                if (pos < __arraySize(coll)) {
                    ret = __ArrayInstPtr(coll)->a_element[pos];
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            }
        }
    }
%}.
    (position >= readLimit) ifTrue:[^ self pastEndRead].
    position := position + 1.
    ret := collection at:position.
    ^ ret
!

next:count
    "return the next count elements of the stream as aCollection,
     which depends on the streams type - (see #contentsSpecies)."

    |answer|

    collection notNil ifTrue:[
        self contentsSpecies == collection class ifTrue:[
            ((position + count) > readLimit) ifFalse:[
                answer := collection copyFrom:position+1 to:position+count.
                position := position+count.
                ^ answer
            ].
        ].
    ].
    ^ super next:count

    "
     #[1 2 3 4 5 6 7 8 9] readStream
        next;
        next:5;
        next.
    "
!

nextAlphaNumericWord
    "read the next word (i.e. up to non letter-or-digit).
     return a string containing those characters.
     Skips any non-alphanumeric chars first.
     - tuned for speed on String-Streams for faster scanning"
%{
    /* speedup, if collection is a string */

    INT pos, limit, sz;
    INT len;
    char quickBuffer[256];
    char *buffer = quickBuffer;
    int bufferSize = sizeof(quickBuffer);
    REGISTER unsigned char *cp;
    REGISTER unsigned ch;
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {
	OBJ retVal;

	pos = __intVal(p);
	/* make 1-based */
	pos = pos + 1;

	limit = __intVal(l);
	sz = __qSize(coll) - OHDR_SIZE;
	if (sz < limit)
	    limit = sz;
	cp = __stringVal(coll) + pos - 1;

	/* skip over non-alphanumeric characters */
	for (;;) {
	    if (pos > limit) break;
	    ch = *cp;

	    if (((ch >= 'a') && (ch <= 'z')) ||
		((ch >= 'A') && (ch <= 'Z')) ||
		((ch >= '0') && (ch <= '9')))
		break;
	    cp++;
	    pos++;
	}

	/* collect non-alphanumeric characters */
	len = 0;
	for (;;) {
	    if (pos > limit) break;
	    ch = *cp & 0xFF;

	    if (! (((ch >= 'a') && (ch <= 'z')) ||
		   ((ch >= 'A') && (ch <= 'Z')) ||
		   ((ch >= '0') && (ch <= '9'))))
		break;
	    buffer[len++] = ch;
	    if (len >= (bufferSize-1)) {
		int newBufferSize = bufferSize * 2;

		if (buffer == quickBuffer) {
		    buffer = (char *)malloc(newBufferSize);
		    memcpy(buffer, quickBuffer, bufferSize);
		} else {
		    buffer = (char *)realloc(buffer, newBufferSize);
		}
		bufferSize = newBufferSize;
	    }
	    pos++;
	    cp++;
	}

	pos = pos - 1;
	__INST(position) = __mkSmallInteger(pos);
	buffer[len] = '\0';
	if (len == 0) {
	    RETURN (nil);
	}
	retVal = __MKSTRING_L(buffer, len);
	if (buffer != quickBuffer) {
	    free((void *)buffer);
	}
	RETURN ( retVal );
    }
%}
.
    ^ super nextAlphaNumericWord
!

nextByte
    "return the next element as an integer between 0 and 255; advance read pointer.
     - tuned for a bit more speed on String/ByteArray/Array-Streams"

    |ret|

%{  /* NOCONTEXT */

    REGISTER INT pos;
    unsigned ch;
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isNonNilObject(coll) && __bothSmallInteger(p, l)) {
        pos = __intVal(p);
        if (pos >= 0 && pos < __intVal(l)) {
            OBJ cls, ret;

            cls = __qClass(coll);
            if (cls == @global(String) || cls == @global(ImmutableString) || cls == @global(Symbol)) {
                if (pos < __stringSize(coll)) {
                    ch = __stringVal(coll)[pos];
                    ret = __mkSmallInteger(ch);
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            } else if (cls == @global(ByteArray)) {
                if (pos < __byteArraySize(coll)) {
                    ch = __ByteArrayInstPtr(coll)->ba_element[pos];
                    ret = __mkSmallInteger(ch);
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            } else if (cls == @global(Array)) {
                if (pos < __arraySize(coll)) {
                    ret = __ArrayInstPtr(coll)->a_element[pos];
                    if (!__isSmallInteger(ret) || __intVal(ret) > 255) goto out;
                    __INST(position) = __mkSmallInteger(pos+1);
                    RETURN ( ret );
                }
            }
        }
    }
out:;
%}.
    (position >= readLimit) ifTrue:[^ self pastEndRead].
    ret := (collection at:(position + 1)) asInteger.
    ret > 255 ifTrue:[
        ret := ConversionError
            raiseRequestWith:self
            errorString:' - #nextByte trying to read a non-byte'.
    ].
    position := position + 1.
    ^ ret
!

nextOrNil
    "return the next element; advance read pointer.
     return nil, if there is no next element.
     - tuned for a bit more speed on String/ByteArray/Array-Streams"

    |ret|

%{  /* NOCONTEXT */

    REGISTER INT pos;
    unsigned ch;
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isNonNilObject(coll) && __bothSmallInteger(p, l)) {
        pos = __intVal(p);
        if (pos >= 0) {
            OBJ cls, ret;

            if (pos >= __intVal(l)) {
                RETURN(nil);
            }

            cls = __qClass(coll);
            if (cls == @global(String) || cls == @global(ImmutableString) || cls == @global(Symbol)) {
                if (pos < __stringSize(coll)) {
                    ch = __stringVal(coll)[pos];
                    ret = __MKCHARACTER(ch);
                    __INST(position) = __mkSmallInteger(pos + 1);
                    RETURN ( ret );
                }
            } else if (cls == @global(ByteArray)) {
                if (pos < __byteArraySize(coll)) {
                    ch = __ByteArrayInstPtr(coll)->ba_element[pos];
                    ret = __mkSmallInteger(ch);
                    __INST(position) = __mkSmallInteger(pos + 1);
                    RETURN ( ret );
                }
            } else if (cls == @global(Unicode16String)) {
                if (pos < __unicode16StringSize(coll)) {
                    ch = __unicode16StringVal(coll)[pos];
                    ret = __MKUCHARACTER(ch);
                    __INST(position) = __mkSmallInteger(pos + 1);
                    RETURN ( ret );
                }
            } else if (cls == @global(Array)) {
                if (pos < __arraySize(coll)) {
                    ret = __ArrayInstPtr(coll)->a_element[pos];
                    __INST(position) = __mkSmallInteger(pos + 1);
                    RETURN ( ret );
                }
            }
        }
    }
%}.
    position := position + 1.
    ret := collection at:position.
    ^ ret
!

nextPeek
    "advance read pointer return the peek element.
     this is equivalent to (self next; peek).
     - tuned for speed on String-Streams for faster scanning"

%{  /* NOCONTEXT */
    OBJ coll = __INST(collection);
    OBJ p = __INST(position);
    OBJ l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {
        REGISTER INT pos  = __intVal(p) + 1;

        if ((pos > 0) && (pos < __intVal(l)) && (pos < __stringSize(coll))) {
            unsigned int ch = __stringVal(coll)[pos];
            __INST(position) = __mkSmallInteger(pos);
            RETURN ( __MKCHARACTER(ch) );
        }
    }
%}.
    (position >= readLimit) ifTrue:[^ self pastEndRead].
    position := position + 1.
    (position >= readLimit) ifTrue:[^ self pastEndRead].
    ^ collection at:(position + 1)
!

nextPeekOrNil
    "advance read pointer return the peek element.
     this is equivalent to (self next; peekOrNil).
     - tuned for speed on String-Streams for faster scanning"

%{  /* NOCONTEXT */
    OBJ coll = __INST(collection);
    OBJ p = __INST(position);
    OBJ l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {
        REGISTER INT pos  = __intVal(p) + 1;

        if ((pos > 0) && (pos < __intVal(l)) && (pos < __stringSize(coll))) {
            unsigned int ch = __stringVal(coll)[pos];
            __INST(position) = __mkSmallInteger(pos);
            RETURN ( __MKCHARACTER(ch) );
        }
    }
%}.
    (position >= readLimit) ifTrue:[^ nil].
    position := position + 1.
    (position >= readLimit) ifTrue:[^ nil].
    ^ collection at:(position + 1)
!

nextUnicode16CharacterMSB:msb
    ^ Character value:(self nextUnsignedInt16MSB:msb)

    "
     #[16r00 16r51] readStream nextUnicode16CharacterMSB:true
     #[16r00 16r51] readStream nextUnicode16CharacterMSB:false
    "
!

nextUnicode16Characters:count MSB:msb
    "easily tuned, if heavily used"
    
    ^ (1 to:count) 
        collect:[:i | self nextUnicode16CharacterMSB:msb]
        as:Unicode16String

    "
     #[16r00 16r51] readStream nextUnicode16Characters:1 MSB:true
     #[16r00 16r51] readStream nextUnicode16Characters:1 MSB:false
    "
!

peek
    "return the next element; do NOT advance read pointer.
     return nil, if there is no next element.
     - tuned for a bit more speed on String/ByteArray/Array-Streams"

%{  /* NOCONTEXT */

    REGISTER INT pos;
    unsigned ch;
    OBJ coll;
    OBJ cls, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isNonNilObject(coll) && __bothSmallInteger(p, l)) {

        pos = __intVal(p);
        if ((pos < __intVal(l)) && (pos >= 0)) {
            cls = __qClass(coll);
            if (cls == @global(String) || cls == @global(ImmutableString) || cls == @global(Symbol)) {
                if (pos < __stringSize(coll)) {
                    ch = __stringVal(coll)[pos];
                    RETURN ( __MKCHARACTER(ch) );
                }
            } else if (cls == @global(ByteArray)) {
                if (pos < __byteArraySize(coll)) {
                    ch = __ByteArrayInstPtr(coll)->ba_element[pos];
                    RETURN ( __mkSmallInteger(ch) );
                }
            } else if (cls == @global(Unicode16String)) {
                if (pos < __unicode16StringSize(coll)) {
                    ch = __unicode16StringVal(coll)[pos];
                    RETURN(__MKUCHARACTER(ch));
                }
            } else if (cls == @global(Array)) {
                if (pos < __arraySize(coll)) {
                    RETURN ( __ArrayInstPtr(coll)->a_element[pos]);
                }
            }
        }
    }
%}.
    (position >= readLimit) ifTrue:[^ self pastEndRead].
    ^ collection at:(position + 1)
!

peekOrNil
    "return the next element; do NOT advance read pointer.
     return nil, if there is no next element.
     This is much like #peek -
     However, unlike #peek, this does not raise an atEnd-query signal - even
     if handled. Instead, nil is returned immediately."

%{  /* NOCONTEXT */

    REGISTER INT pos;
    unsigned ch;
    OBJ coll;
    OBJ cls, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isNonNilObject(coll) && __bothSmallInteger(p, l)) {
        pos = __intVal(p);
        if ((pos < __intVal(l)) && (pos >= 0)) {
            cls = __qClass(coll);
            if (cls == @global(String) || cls == @global(ImmutableString) || cls == @global(Symbol)) {
                if (pos < __stringSize(coll)) {
                    ch = __stringVal(coll)[pos];
                    RETURN ( __MKCHARACTER(ch) );
                }
                RETURN ( nil );
            } else if (cls == @global(ByteArray)) {
                if (pos < __byteArraySize(coll)) {
                    ch = __ByteArrayInstPtr(coll)->ba_element[pos];
                    RETURN ( __mkSmallInteger(ch) );
                }
                RETURN ( nil );
            } else if (cls == @global(Unicode16String)) {
                if (pos < __unicode16StringSize(coll)) {
                    ch = __unicode16StringVal(coll)[pos];
                    RETURN(__MKUCHARACTER(ch));
                }
                RETURN ( nil );
            } else if (cls == @global(Array)) {
                if (pos < __arraySize(coll)) {
                    RETURN ( __ArrayInstPtr(coll)->a_element[pos]);
                }
                RETURN ( nil );
            }
        }
    }
%}.
    (position >= readLimit) ifTrue:[^ nil].
    ^ collection at:(position + 1)
!

skipSeparators
    "skip all whitespace; next will return next non-white-space element.
     Return the peeked character or nil, if the end-of-stream was reached.
     - reimplemented for speed on String-Streams for faster scanning"

%{  /* NOCONTEXT */
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {
	REGISTER unsigned char *chars;
	REGISTER unsigned ch;
	REGISTER INT pos;
	INT limit;
	INT sz;

	pos = __intVal(p);
	/* make 1-based */
	pos++;
	if (pos <= 0) {
	    RETURN ( nil );
	}

	limit = __intVal(l);
	sz = __qSize(coll) - OHDR_SIZE;
	if (limit > sz) {
	    limit = sz;
	}

	chars = (unsigned char *)(__stringVal(coll) + pos - 1);
	while (pos <= limit) {
	    ch = *chars++;
	    if ((ch > 0x20)
	     || ((ch != ' ')
		 && (ch != '\t')
		 && (ch != '\r')
		 && (ch != '\n')
		 && (ch != '\f')
		 && (ch != 0x0B))) {
		__INST(position) = __mkSmallInteger(pos-1);
		RETURN ( __MKCHARACTER(ch) );
	    }
	    pos++;
	}
	pos--;
	__INST(position) = __mkSmallInteger(pos);
	RETURN ( nil );
    }
%}.
    ^ super skipSeparators

    "
     |s|

     s := '     hello     world    ' readStream.
     s skipSeparators.
     s next.
    "
!

skipSeparatorsExceptCR
    "skip all whitespace except newlines;
     next will return next non-white-space element.
     - reimplemented for speed on String-Streams for faster scanning"

%{  /* NOCONTEXT */

    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {
	REGISTER unsigned char *chars;
	REGISTER unsigned ch;
	REGISTER INT pos;
	INT limit;
	INT sz;

	pos = __intVal(p);
	/* make 1-based */
	pos = pos + 1;
	if (pos <= 0) {
	    RETURN ( nil );
	}

	limit = __intVal(l);
	sz = __qSize(coll) - OHDR_SIZE;
	if (limit > sz)
	    limit = sz;

	chars = (unsigned char *)(__stringVal(coll) + pos - 1);
	while (pos <= limit) {
	    ch = *chars++;
	    if (((int)ch > 0x20)
	     || (
		 (ch != ' ')
		 && (ch != '\t')
		 && (ch != '\f')
		 && (ch != '\b')
		 && (ch != 0x0B))) {
		pos--;
		__INST(position) = __mkSmallInteger(pos);
		RETURN ( __MKCHARACTER(ch) );
	    }
	    pos++;
	}
	pos--;
	__INST(position) = __mkSmallInteger(pos);
	RETURN ( nil );
    }
%}
.
    ^ super skipSeparatorsExceptCR
!

skipThrough:anObject
    "skip all objects up-to and including anObject.
     Return the receiver if skip was successful,
     otherwise (i.e. if not found) return nil and leave the stream positioned at the end.
     On success, the next read operation will return the element after anObject.
     - reimplemented for speed on String-Streams for faster scanning"

%{  /* NOCONTEXT */
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isStringLike(coll)
     && __isCharacter(anObject)
     && __bothSmallInteger(p, l)) {
	REGISTER unsigned char *chars;
	REGISTER INT pos, limit;
	unsigned ch;
	INT sz;

	ch = __intVal(__characterVal(anObject));
	if (ch <= 0xFF) {
	    pos = __intVal(p);
	    pos = pos + 1;
	    if (pos <= 0) {
		RETURN ( nil );
	    }

	    limit = __intVal(l);
	    sz = __stringSize(coll);
	    if (limit > sz) limit = sz;

	    chars = (unsigned char *)(__stringVal(coll) + pos - 1);
	    while (pos < limit) {
		if (*chars == ch) {
		    ch = *++chars;
		    __INST(position) = __mkSmallInteger(pos);
		    RETURN ( self );
		}
		chars++;
		pos++;
	    }
	    __INST(position) = __mkSmallInteger(pos);
	    RETURN ( nil );
	}
    }
%}.
    ^ super skipThrough:anObject
!

upTo:anObject
%{
    OBJ _collection = __INST(collection);

    if (__isString(_collection)
     && __isCharacter(anObject)) {
	unsigned int ch = __intVal(__characterVal(anObject));

	if (ch <= 0xFF) {
	    int _startPos = __intVal(__INST(position));
	    int _endIndex;
	    char *startPtr = __stringVal(_collection) + _startPos;
	    char *foundPtr;
	    OBJ rslt;
	    int nMax;

	    _endIndex = __stringSize(_collection);
	    if (__isInteger(__INST(readLimit))) {
		int _readLimit = __intVal(__INST(readLimit));

		if (_readLimit < _endIndex) _endIndex = _readLimit;
	    }

	    nMax = _endIndex-_startPos;
	    foundPtr = (char *)memchr( startPtr, ch, (long)nMax);
	    if (foundPtr == 0) {
		// not found
		rslt = __MKEMPTYSTRING(nMax);
		// refetch - may GC
		_collection = __INST(collection);
		memcpy((void *)__stringVal(rslt), (void *)(__stringVal(_collection) + _startPos), (size_t)nMax);
		__INST(position) = __mkSmallInteger(_endIndex);
	    } else {
		// found at foundPtr
		int n = foundPtr-startPtr;

		rslt = __MKEMPTYSTRING(n);
		// refetch - may GC
		_collection = __INST(collection);
		memcpy((void *)__stringVal(rslt), (void *)(__stringVal(_collection) + _startPos), (size_t)n);
		__INST(position) = __mkSmallInteger(_startPos + n + 1);
	    }
	    RETURN (rslt);
	}
    }
%}.
    ^ super upTo:anObject
! !

!ReadStream methodsFor:'reading-numbers'!

nextDecimalInteger
    "read the next integer in radix 10.
     Does NOT skip initial whitespace.
     The streams elements should be characters.

     Be careful - this method returns 0 if not positioned on a digit intitially
     or if the end of the stream is encountered.

     Tuned for speed on String-Streams for faster scanning"

    |value nextOne|
%{
    INT pos, limit, sz;
    REGISTER unsigned char *cp;
    REGISTER unsigned ch;
    INT val = 0;
    OBJ coll, p, l;

    coll = __INST(collection);
    p = __INST(position);
    l = __INST(readLimit);

    if (__isStringLike(coll) && __bothSmallInteger(p, l)) {

	pos = __intVal(p);
	/* make 1-based */
	pos++;
	limit = __intVal(l);
	sz = __qSize(coll) - OHDR_SIZE;
	if (sz < limit)
	    limit = sz;
	cp = __stringVal(coll) + pos - 1;

	for (;;) {
	    if (pos > limit) break;
	    ch = *cp;

	    if ((ch < '0') || (ch > '9')) break;
	    val = val * 10 + (ch - '0');
	    pos++;
	    if (val > (_MAX_INT / 10)) goto oops;
	    cp++;
	}
	pos--;
	__INST(position) = __mkSmallInteger(pos);
	RETURN (__mkSmallInteger(val));
    }
oops:
    value = __mkSmallInteger(val);
%}
.
    "fall-back for non-string streams - we have to continue where
     above primitive left off, in case of a large integer ...
     (instead of doing a super nextDecimalInteger)"

    nextOne := self peek.
    [nextOne notNil and:[nextOne isDigitRadix:10]] whileTrue:[
	value := (value * 10) + nextOne digitValue.
	nextOne := self nextPeek
    ].
    ^ value
! !

!ReadStream methodsFor:'writing'!

nextPut:anElement
    "catch write access to readstreams - report an error"

    self shouldNotImplement
! !

!ReadStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

