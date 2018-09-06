"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIBuffer subclass:#OCIDateBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCIDateBuffer class methodsFor:'documentation'!

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

!OCIDateBuffer class methodsFor:'constants'!

elementSize
    "the internal representation of date values is 7 bytes"

    ^ 7
! !

!OCIDateBuffer class methodsFor:'queries'!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_DAT'
! !

!OCIDateBuffer methodsFor:'decoding'!

at:index
    "convert an internal Oracle DATE to a Timestamp value"

    |startIndex|

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    startIndex := ((index-1)*maxElementLen)+1.

    ^ Timestamp year:((buffer at:startIndex)-100)*100 + ((buffer at:startIndex+1) - 100)
		   month:(buffer at:startIndex+2)
		   day:(buffer at:startIndex+3)
		   hour:(buffer at:startIndex+4)-1
		   minute:(buffer at:startIndex+5)-1
		   second:(buffer at:startIndex+6)-1.
     "
	|now converter|

	now := Timestamp now.
	converter := self new.
	converter at:1 put:now.
	converter at:1
     "
! !

!OCIDateBuffer methodsFor:'encoding'!

visitTimestamp:absoluteTime with:index

    |startIndex year|

    self alenAt:index put:maxElementLen.
    startIndex := ((index-1)*maxElementLen)+1.
    year := absoluteTime year.
    buffer at:startIndex put:(year quo:100) + 100.
    buffer at:startIndex+1 put:(year rem:100) + 100.
    buffer at:startIndex+2 put:absoluteTime month.
    buffer at:startIndex+3 put:absoluteTime day.
    buffer at:startIndex+4 put:absoluteTime hour + 1.
    buffer at:startIndex+5 put:absoluteTime minute + 1.
    buffer at:startIndex+6 put:absoluteTime second + 1.
! !

!OCIDateBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIDateBuffer.st,v 1.6 2016-10-13 00:15:08 cg Exp $'
! !
