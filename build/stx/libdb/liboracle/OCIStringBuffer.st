"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIBuffer subclass:#OCIStringBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCIStringBuffer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!OCIStringBuffer class methodsFor:'queries'!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_CHR'
! !

!OCIStringBuffer methodsFor:'decoding'!

at:index
    "decode the contents of the buffer"

    |len startIndex|

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    len := self alenAt:index.
    (nElements == 1 and:[buffer isString]) ifTrue:[ |sz buf|
	sz := buffer size.
	sz == len ifTrue:[
	    buf := buffer.
	    buffer := buffer copyEmpty:sz.
	    ^ buf.
	].
    ].
    startIndex := ((index-1)*maxElementLen)+1.
    ^ buffer stringAt:startIndex size:len.
! !

!OCIStringBuffer methodsFor:'encoding'!

visitBoolean:aBoolean with:index

    |val|

    self alenAt:index put:1.
    val := aBoolean ifTrue:[$Y] ifFalse:[$N].
    buffer at:maxElementLen*(index-1)+1 put:val asciiValue.

    "
     |b|

     b := self elements:2 withSize:1.
     true acceptVisitor:b with:1.
     false acceptVisitor:b with:2.
     b inspect
    "
!

visitCharacter:aCharacter with:index

    self alenAt:index put:1.
    buffer at:maxElementLen*(index-1)+1 put:aCharacter asciiValue.
!

visitObject:anObject with:index

    ^ self visitString:anObject printString with:index
!

visitString:aString with:index

    |len startIndex|

    len := aString size.
    self alenAt:index put:len.
    startIndex := maxElementLen*(index-1)+1.
    buffer replaceBytesFrom:startIndex to:startIndex+len-1 with:aString startingAt:1.
! !

!OCIStringBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIStringBuffer.st,v 1.6 2010-10-11 12:00:05 cg Exp $'
! !
