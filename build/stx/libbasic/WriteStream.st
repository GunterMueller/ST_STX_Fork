"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

PositionableStream subclass:#WriteStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!WriteStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Streams for writing into.
    WriteStreams are especially useful, if big strings are to be constructed
    from pieces - create a writeStream, add the pieces (with #nextPut: or
    #nextPutAll:) and finally fetch the concatenated string via #contents.
    This is much better than constructing the big string by concatenating via
    the comma (,) operator, since less intermediate garbage objects are created.

    This implementation currently DOES change the
    identity of the streamed-upon collection IF it cannot grow easily.
    Collections which cannot grow easily are for example: Array, ByteArray and String.
    Thus it is slightly incompatible to ST-80 since 'aStream contents' does
    not always return the original collection. This may change.

    [caveat:]
        Basing capabilities like readability/writability/positionability/peekability on inheritance makes
        the class hierarchy ugly and leads to strange and hard to teach redefinitions (aka. NonPositionableStream
        below PositionableStream or ExternalReadStream under WriteStream)

    [author:]
        Claus Gittinger

    [see also:]
        CharacterWriteStream (if streaming for a unicode string)
"
!

examples
"
								[exBegin]
     |s|

     s := WriteStream on:''.
     s nextPutAll:'hello';
       space;
       nextPutAll:'world'.

     s contents inspect
								[exEnd]

								[exBegin]
     |s|

     s := WriteStream on:''.
     s nextPutAll:'hello';
       space;
       nextPutAll:'world'.

     Transcript nextPutLine:(s contents)
								[exEnd]

								[exBegin]
     |s|

     s := '' writeStream.
     s nextPutAll:'hello';
       space;
       nextPutAll:'world'.

     Transcript nextPutLine:(s contents)
								[exEnd]
"

! !

!WriteStream methodsFor:'accessing'!

clear
    "for compatibility with Transcript"

    self reset
!

contents
    "return the current contents (a collection) of the stream.
     Currently, this returns the actual collection if possible
     (and reset is implemented to create a new one) in contrast to
     ST80, where contents returns a copy and reset only sets the writePointer.
     The ST/X behavior creates less temporary garbage in the normal case
     (where things are written for the contents only) but may be incompatible
     with some applications. Time will show, if this is to be changed."

    |lastIndex|

    lastIndex := position.
    collection size == lastIndex ifFalse:[
	collection isFixedSize ifTrue:[
	    "
	     grow is expensive - return a copy.
	     (is this what users of writeStream expect ?)
	    "
	    collection := collection copyFrom:1 to:lastIndex
	] ifFalse:[
	    collection grow:lastIndex
	]
    ].
    ^ collection

    "Modified: / 19.2.1997 / 08:57:28 / stefan"
    "Modified: / 30.10.1997 / 16:21:23 / cg"
!

last
    "return the last element - report an error if the stream is empty"

    ^ collection at:position.

    "
     |s|

     s := '' writeStream.
     s nextPut:$a.
     s last.
     s nextPut:$b.
     s last.
     s nextPut:$c.
     s last.
    "
!

last:n
    "return the last n elements as species of the underlying collection;
     Report an error if the stream is empty"

    ^ collection copyFrom:(position - n + 1) to:position.

    "
     |s|

     s := '' writeStream.
     s nextPut:$a.
     s last:1.
     s nextPut:$b.
     s last:1.
     s last:2.
     s nextPut:$c.
     s last:1.
     s last:2.
     s last:3.
    "
!

reset
    "reset the stream; write anew.
     See the comment in WriteStream>>contents"

    collection := collection species new:(collection size).
    position := 0.

    "Modified: 19.2.1997 / 08:57:00 / stefan"
! !

!WriteStream methodsFor:'positioning'!

position:index0Based
    "redefined to allow positioning past the readLimit"

    ((index0Based > collection size) or:[index0Based < 0]) ifTrue: [^ self positionError].
    position := index0Based
!

skip:count
    "redefined to allow positioning back over already written characters"

    self position:(self position + count).
! !

!WriteStream methodsFor:'private'!

growCollection
    "grow the streamed collection to at least 10 elements"

    self growCollection:10

    "Modified: 19.8.1997 / 17:53:28 / cg"
!

growCollection:minNewSize
    "grow the streamed collection to at least minNewSize"

    |oldSize newSize newColl|

    oldSize := collection size.
    (oldSize == 0) ifTrue:[
	newSize := minNewSize
    ] ifFalse:[
	newSize := oldSize * 2.
	(newSize < minNewSize) ifTrue:[newSize := minNewSize].
    ].
    collection isFixedSize ifTrue:[
	newColl := collection species new:newSize.
	newColl replaceFrom:1 to:oldSize with:collection startingAt:1.
	collection := newColl
    ] ifFalse:[
	collection grow:newSize
    ].

    "Modified: 19.8.1997 / 17:53:11 / cg"
! !

!WriteStream methodsFor:'private-accessing'!

on:aCollection
    super on:aCollection.
    readLimit := 0.
!

on:aCollection from:start to:last
    "create and return a new stream for writing onto aCollection, where
     writing is limited to the elements in the range start to last."

    super on:aCollection from:start to:last.
    writeLimit := last.
! !

!WriteStream methodsFor:'queries'!

endsWith:aCollection
    "Answer true, if the contents of the stream ends with aCollection.
     Speedup for upToAll:, throughAll etc."

    |sz start "{ Class: SmallInteger }"|

    collection isNil ifTrue:[
        "only supported for internal streams"
        self shouldNotImplement.
    ].

    sz := aCollection size.
    start := position + 1 - sz.
    ^ start > 0 and:[(collection copyFrom:position+1-sz to:position) endsWith:aCollection].

    "
        (WriteStream with:'abcdef') endsWith:'def'
        (WriteStream with:'def') endsWith:'def'
        (WriteStream with:'abc') endsWith:'def'
        (WriteStream with:'ef') endsWith:'def'
false    "
!

size
    "return the current size"

    ^ position
! !

!WriteStream methodsFor:'reading'!

next
    "catch read access to write stream - report an error"

    self shouldNotImplement
!

peek
    "catch read access to write stream - report an error"

    self shouldNotImplement
! !

!WriteStream methodsFor:'testing'!

isEmpty
    "return true, if the contents of the stream is empty"

    ^ self position == 0

    "Created: 14.10.1997 / 20:44:37 / cg"
!

isReadable
    "return true if the receiver supports reading - that's not true"

    ^ false

    "Created: / 8.11.1997 / 14:06:07 / cg"
!

isWritable
    "return true, if writing is supported by the receiver.
     Always return true here"

    ^ true

    "Modified: 16.5.1996 / 14:44:49 / cg"
! !

!WriteStream methodsFor:'writing'!

next:count put:anObject
    "append anObject count times to the receiver.
     Redefined to avoid count grows of the underlying collection -
     instead a single grow on the final size is performed."

    |final|

    count == 0 ifTrue:[^ self].

    (collection isNil or:[writeLimit notNil]) ifTrue:[
        super next:count put:anObject.
        ^ self.
    ].

    final := position + count.
    (final > collection size) ifTrue:[
        self growCollection:final
    ].

    collection from:position + 1 to:final put:anObject.
    position := position + count.
    (position > readLimit) ifTrue:[readLimit := position].
    "/ ^ anObject -- return self

    "
     '' writeStream next:10 put:$*
    "
!

next:n putAll:aCollection startingAt:pos1
    "append some elements of the argument, aCollection to the stream."

    ^ self nextPutAll:aCollection startingAt:pos1 to:pos1+n-1

    "
     |s|

     s := '' writeStream.
     s nextPutAll:'hello '.
     s next:5 putAll:'1234world012345' startingAt:5.
     s contents
    "

    "Modified: 12.7.1996 / 10:31:36 / cg"
!

nextPut:anObject
    "append the argument, anObject to the stream.
     Specially tuned for appending to String, ByteArray and Array streams."

%{  /* NOCONTEXT */

#ifndef NO_PRIM_STREAM
    REGISTER int pos;
    unsigned ch;
    OBJ coll;
    OBJ p, wL, rL;
    int __readLimit = -1;

    coll = __INST(collection);
    p = __INST(position);

    if (__isNonNilObject(coll) && __isSmallInteger(p)) {
        pos = __intVal(p);
        /* make 1-based */
        pos = pos + 1;
        wL = __INST(writeLimit);

        if ((wL == nil)
         || (__isSmallInteger(wL) && (pos <= __intVal(wL)))) {
            OBJ cls;

            cls = __qClass(coll);

            rL = __INST(readLimit);
            if (__isSmallInteger(rL)) {
                __readLimit = __intVal(rL);
            }

            if (cls == @global(String)) {
                if (__isCharacter(anObject)
                 && ((ch = __intVal(__characterVal(anObject))) <= 255) /* ch is unsigned */
                 && (pos <= __stringSize(coll))) {
                    __StringInstPtr(coll)->s_element[pos-1] = ch;
advancePositionAndReturn: ;
                    if ((__readLimit >= 0) && (pos > __readLimit)) {
                        __INST(readLimit) = __mkSmallInteger(pos);
                    }
                    __INST(position) = __mkSmallInteger(pos);
                    RETURN ( anObject );
                }
            } else if (cls == @global(ByteArray)) {
                if (__isSmallInteger(anObject)
                 && ((ch = __intVal(anObject)) <= 0xFF) /* ch is unsigned */
                 && (pos <= __byteArraySize(coll))) {
                    __ByteArrayInstPtr(coll)->ba_element[pos-1] = ch;
                    goto advancePositionAndReturn;
                }
            } else if (cls == @global(Array)) {
                if (pos <= __arraySize(coll)) {
                     __ArrayInstPtr(coll)->a_element[pos-1] = anObject;
                    __STORE(coll, anObject);
                    goto advancePositionAndReturn;
                }
            } else if (cls == @global(Unicode16String)) {
                if (__isCharacter(anObject)
                 && ((ch = __intVal(__characterVal(anObject))) <= 0xFFFF) /* ch is unsigned */
                 && (pos <= __unicode16StringSize(coll))) {
                     __Unicode16StringInstPtr(coll)->s_element[pos-1] = ch;
                    goto advancePositionAndReturn;
                }
            } else if (cls == @global(Unicode32String)) {
                if (__isCharacter(anObject)
                 && (pos <= __unicode32StringSize(coll))) {
                     __Unicode32StringInstPtr(coll)->s_element[pos-1] = __intVal(__characterVal(anObject));
                    goto advancePositionAndReturn;
                }
            }
        }
    }
#endif
%}.
    (writeLimit isNil
    or:[(position + 1) <= writeLimit]) ifTrue:[
        (position >= collection size) ifTrue:[self growCollection].
        collection at:(position + 1) put:anObject.
        position := position + 1.
        (position > readLimit) ifTrue:[readLimit := position].
    ] ifFalse:[
        WriteError raiseErrorString:'write beyond writeLimit'
    ].
    ^anObject
!

nextPutAll:aCollection
    "append all elements of the argument, aCollection to the stream.
     Redefined to avoid count grows of the underlying collection -
     instead a single grow on the final size is performed."

    |nMore "{ Class: SmallInteger }"
     final "{ Class: SmallInteger }" |

    (collection notNil and:[aCollection isSequenceable]) ifFalse:[
        "/ fallback
        super nextPutAll:aCollection.
        ^ self.
    ].

    nMore := aCollection size.
    nMore == 0 ifTrue:[
        "/ for the programmer..
        aCollection isCollection ifFalse:[
            self error:'invalid argument (not a collection)' mayProceed:true
        ].
    ].

    final := position + nMore.
    (writeLimit notNil
    and:[final > writeLimit]) ifTrue:[
        final := writeLimit.
        nMore := final - position
    ].
    (final > collection size) ifTrue:[
        self growCollection:final
    ].
    collection
        replaceFrom:(position + 1)
        to:final
        with:aCollection
        startingAt:1.

    position := position + nMore.
    (position > readLimit) ifTrue:[readLimit := position].
    "/ ^ aCollection -- self

    "Modified: / 04-09-2011 / 20:03:32 / cg"
!

nextPutAll:aCollection startingAt:pos1 to:pos2
    "append some elements of the argument, aCollection to the stream.
     Redefined to avoid count grows of the underlying collection -
     instead a single grow on the final size is performed."

    |nMore final|

    collection isNil ifTrue:[
        ^ super nextPutAll:aCollection startingAt:pos1 to:pos2
    ].

    nMore := pos2 - pos1 + 1.
    final := position + nMore.
    (writeLimit notNil
    and:[final > writeLimit]) ifTrue:[
        final := writeLimit.
        nMore := final - position
    ].
    (final > collection size) ifTrue:[
        self growCollection:final
    ].

    collection replaceFrom:position + 1
                        to:final
                      with:aCollection
                startingAt:pos1.

    position := position + nMore.
    (position > readLimit) ifTrue:[readLimit := position].
    "/ ^ aCollection -- return self

    "
     |s|

     s := '' writeStream.
     s nextPutAll:'hello '.
     s nextPutAll:'1234world012345' startingAt:5 to:9.
     s contents
    "

    "Modified: 12.7.1996 / 10:31:36 / cg"
!

nextPutAllUnicode:aString
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    "this code is not perfect if you use both #nextPutAll: and #nextPutAllUnicode:
     with the same stream, since 8-bit characters (with the highest bits set)
     are not stored as UTF, so we get some inconsistent string"

    collection isString ifTrue:[
	collection bitsPerCharacter == 16 ifTrue:[
	    self nextPutAllUtf16:aString.
	] ifFalse:[
	    self nextPutAllUtf8:aString.
	].
    ] ifFalse:[
	self nextPutAll:aString
    ].

    "Modified: / 28-09-2011 / 16:15:52 / cg"
!

nextPutByte:anObject
    "append the argument, anObject to the stream.
     Specially tuned for appending to String and ByteArray streams."

%{  /* NOCONTEXT */

#ifndef NO_PRIM_STREAM
    OBJ coll = __INST(collection);
    OBJ p = __INST(position);

    if (__isNonNilObject(coll) && __isSmallInteger(p) && __isSmallInteger(anObject)) {
        OBJ wL  = __INST(writeLimit);
        INT pos = __intVal(p) + 1;    /* make 1-based and usable for update below */
        unsigned int ch = __intVal(anObject);

        if (ch <= 0xFF &&  /* ch is unsigned */
            ((wL == nil) || (__isSmallInteger(wL) && (pos <= __intVal(wL))))) {
            OBJ cls = __qClass(coll);
            OBJ rL = __INST(readLimit);
            INT __readLimit = -1;

            if (__isSmallInteger(rL)) {
                __readLimit = __intVal(rL);
            }

            if (cls == @global(String)) {
                if (pos <= __stringSize(coll)) { 
                    __StringInstPtr(coll)->s_element[pos-1] = ch;
    advancePositionAndReturn: ;
                    if ((__readLimit >= 0) && (pos > __readLimit)) {
                        __INST(readLimit) = __mkSmallInteger(pos);
                    }
                    __INST(position) = __mkSmallInteger(pos);
                    RETURN ( anObject );
                }
            } else if (cls == @global(ByteArray)) {
                if (pos <= __byteArraySize(coll)) { 
                    __ByteArrayInstPtr(coll)->ba_element[pos-1] = ch;
                    goto advancePositionAndReturn;
                }
            }
        }
    }
#endif
%}.
    ((writeLimit isNil or:[(position + 1) <= writeLimit])
      and:[position >= collection size]) ifTrue:[
        self growCollection.
        ^ self nextPutByte:anObject.  "try again"                    
    ] ifFalse:[
        ^ super nextPutByte:anObject
    ].
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start.
     Return the number of bytes written.
     The object must have non-pointer indexed instvars
     (i.e. be a ByteArray, String, Float- or DoubleArray).
     Use with care - non object oriented i/o.
     This is provided for compatibility with externalStream;
     to support binary storage"

    anObject isByteCollection ifTrue:[
	self nextPutAll:anObject startingAt:start to:(start + count - 1).
	^ count.
    ].
    ^ super nextPutBytes:count from:anObject startingAt:start
!

nextPutUnicode:aCharacter
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    "this code is not perfect if you use both #nextPut: and #nextPutUnicode:
     with the same stream, since 8-bit characters (with the highest bits set)
     are not stored as UTF, so we get some inconsistent string"

    collection isString ifTrue:[
	collection bitsPerCharacter == 16 ifTrue:[
	    self nextPutUtf16:aCharacter.
	] ifFalse:[
	    self nextPutUtf8:aCharacter.
	].
    ] ifFalse:[
	self nextPut:aCharacter.
    ].
! !

!WriteStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

