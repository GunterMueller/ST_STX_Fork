"
 COPYRIGHT (c) 2005 by eXept Software AG
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

WriteStream subclass:#CharacterWriteStream
	instanceVariableNames:'currentCharacterSize'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!CharacterWriteStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    This is a WriteStream, which automagically changes the underlying collection,
    if a character does not fit into the current collection 
    (i.e. String -> Unicode16String -> Unicode32Sting )

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]
        String Unicode16String Unicode32Sting
"
!

examples
"

                                                                [exBegin]
    |stream|

    stream := CharacterWriteStream on:(String new:32).
    stream nextPutAll:'abc'.
    stream nextPut:(Character value:16r2c00).
    stream contents inspect
                                                                [exEnd]

"
! !

!CharacterWriteStream class methodsFor:'instance creation'!

new
    "I know, that I operate on strings"

    ^ self on:(String uninitializedNew:10)
!

new:count
    "I know, that I operate on strings"

    ^ self on:(String uninitializedNew:count)
! !

!CharacterWriteStream methodsFor:'accessing'!

reset
    "reset the stream, to write again over the existing (or already written) contents.
     See the comment in WriteStream>>contents"

    "start with 8-bit String again"
    collection := String new:collection size.
    currentCharacterSize := collection bitsPerCharacter.
    position := 0.
! !

!CharacterWriteStream methodsFor:'private'!

characterSizeChangedTo:newCharacterSize size:additionalSize
    "change aCollection to fit the size of newCharacterSize"

    |sz newSz|

    currentCharacterSize < newCharacterSize ifTrue:[
        newSz := sz := collection size.
        position + additionalSize >= sz ifTrue:[
            newSz := newSz + additionalSize + 100.          "add some more space, maybe more will be added"
        ].
        collection := ((CharacterArray speciesForCharacterSize:newCharacterSize) new:newSz) 
                        replaceFrom:1 to:position with:collection startingAt:1.
        currentCharacterSize := collection bitsPerCharacter.
    ].
! !

!CharacterWriteStream methodsFor:'private-accessing'!

on:aCollection
    "return a stream for writing into aCollection"
    
    currentCharacterSize := aCollection bitsPerCharacter.
    ^ super on:aCollection.
!

on:aCollection from:start to:stop
    "return a stream for writing into part of aCollection.
     This will position the stream to start writing at start-index,
     and setup a writeLimit at stop-index.
     Contents after stop-index will not be overwritten."

    currentCharacterSize := aCollection bitsPerCharacter.
    ^ super on:aCollection from:start to:stop.

    "notice: only the first 6 characters are overwritten:
    
     |str s|
     str := 'hello world bla'.
     s := CharacterWriteStream on:str from:6 to:11.
     s nextPutAll:'1234567890'.
     str
    "
!

with:aCollection
    "return a stream for writing into aCollection.
     This will position the stream to the end, and append written elements
     after the initial contents.
     I.e. the effect is similar to creating an empty stream first and then write
     aCollection."

    currentCharacterSize := aCollection bitsPerCharacter.
    ^ super with:aCollection.

    "
     |s|
     s := CharacterWriteStream with:'hello'.
     s nextPutAll:'1234567890'.
     s contents
    "
! !

!CharacterWriteStream methodsFor:'writing'!

next:count put:aCharacter
    "append anObject count times to the receiver.
     Redefined to avoid count grows of the underlying collection -
     instead a single grow on the final size is performed."

    |needCharacterSize|

    needCharacterSize := aCharacter characterSize.
    needCharacterSize > currentCharacterSize ifTrue:[
        self characterSizeChangedTo:needCharacterSize size:count.
    ].
    super next:count put:aCharacter
!

nextPut:aCharacter
    "append the argument, aCharacter to the stream.
     Specially tuned for appending to String, Unicode16String and Unicode32String streams."

%{  /* NOCONTEXT */

#ifndef NO_PRIM_STREAM
    OBJ coll = __INST(collection);
    OBJ p = __INST(position);

    if (__isNonNilObject(coll) && __isSmallInteger(p) && __isCharacter(aCharacter)) {
        REGISTER int pos = __intVal(p) + 1;      /* make 1-based */
        OBJ wL = __INST(writeLimit);

        if ((wL == nil)
         || (__isSmallInteger(wL) && (pos <= __intVal(wL)))) {
            OBJ cls = __qClass(coll);
            unsigned ch = __intVal(__characterVal(aCharacter));
            OBJ rL = __INST(readLimit);
            int __readLimit = -1;

            if (__isSmallInteger(rL)) {
                __readLimit = __intVal(rL);
            }

            if (cls == @global(String)) {
                if (ch > 0xFF) {
                    goto resize;
                }
                if (pos <= __stringSize(coll)) {
                    __StringInstPtr(coll)->s_element[pos-1] = ch;
                    if ((__readLimit >= 0) && (pos >= __readLimit)) {
                        __INST(readLimit) = __mkSmallInteger(pos);
                    }
                    __INST(position) = __mkSmallInteger(__intVal(__INST(position)) + 1);
                    RETURN ( aCharacter );
                }
            } else if (cls == @global(Unicode16String)) {
                if (ch > 0xFFFF) {
                    goto resize;
                }
                if (pos <= __unicode16StringSize(coll)) {
                     __Unicode16StringInstPtr(coll)->s_element[pos-1] = ch;
                    if ((__readLimit >= 0) && (pos >= __readLimit)) {
                        __INST(readLimit) = __mkSmallInteger(pos);
                    }
                    __INST(position) = __mkSmallInteger(__intVal(__INST(position)) + 1);
                    RETURN ( aCharacter );
                }
            } else if (cls == @global(Unicode32String)) {
                if ((pos <= __unicode32StringSize(coll))) {
                     __Unicode32StringInstPtr(coll)->s_element[pos-1] = ch;
                    if ((__readLimit >= 0) && (pos >= __readLimit)) {
                        __INST(readLimit) = __mkSmallInteger(pos);
                    }
                    __INST(position) = __mkSmallInteger(__intVal(__INST(position)) + 1);
                    RETURN ( aCharacter );
                }
            }
        }
    }
    resize:;
#endif
%}.


    (writeLimit isNil
     or:[(position + 1) <= writeLimit]) ifTrue:[
        |needCharacterSize|

        needCharacterSize := aCharacter characterSize.
        needCharacterSize > currentCharacterSize ifTrue:[
            self characterSizeChangedTo:needCharacterSize size:1.
        ] ifFalse:[
            (position >= collection size) ifTrue:[self growCollection].
        ].
        collection at:(position + 1) put:aCharacter.
        (position >= readLimit) ifTrue:[readLimit := (position + 1)].
        position := position + 1.
    ] ifFalse:[
        WriteError raiseErrorString:'write beyond writeLimit'
    ].
    ^ aCharacter
!

nextPutAll:aCollection
    "append aCollection to the receiver.
     Redefined to convert to a string of the needed charcter size."

    |needCharacterSize|

    needCharacterSize := aCollection characterSize.
    needCharacterSize > currentCharacterSize ifTrue:[
        self characterSizeChangedTo:needCharacterSize size:aCollection size.
    ].
    super nextPutAll:aCollection
!

nextPutAll:aCollection startingAt:start to:stop
    |needCharacterSize|

    needCharacterSize := aCollection characterSize.
    needCharacterSize > currentCharacterSize ifTrue:[
        self characterSizeChangedTo:needCharacterSize size:stop-start+1.
    ].
    ^ super nextPutAll:aCollection startingAt:start to:stop
!

nextPutAllUnicode:aCollection
    ^ self nextPutAll:aCollection
!

nextPutUnicode:aCharacter
    ^ self nextPut:aCharacter
! !

!CharacterWriteStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

