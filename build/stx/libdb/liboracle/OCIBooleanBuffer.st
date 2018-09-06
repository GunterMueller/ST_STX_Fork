"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIStringBuffer subclass:#OCIBooleanBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCIBooleanBuffer class methodsFor:'documentation'!

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

!OCIBooleanBuffer class methodsFor:'constants'!

elementSize
    "the internal representation of boolean values is 1 bytes"

    ^ 1
! !

!OCIBooleanBuffer class methodsFor:'queries'!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_CHR'
! !

!OCIBooleanBuffer methodsFor:'decoding'!

at:index
    "convert an a boolean value"

    |startIndex c|

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    startIndex := ((index-1)*maxElementLen)+1.
    c := buffer at:startIndex.
    ^ 'YJTyjt1' includes:c asCharacter

    "
	|converter|

	converter := self new:2.
	converter at:1 put:true.
	converter at:2 put:false.
	converter at:1.
	converter at:2.
     "
! !

!OCIBooleanBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIBooleanBuffer.st,v 1.5 2010-10-11 12:00:05 cg Exp $'
! !
