"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

DNSRecord subclass:#MXRecord
	instanceVariableNames:'priority mx'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!MXRecord class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    no warranty; provided AS-IS
    code ported from squeak
"

    "Created: / 22-11-2006 / 12:48:56 / cg"
! !

!MXRecord class methodsFor:'accessing'!

type
	^ 15
! !

!MXRecord methodsFor:'accessing'!

mx
	^ mx
!

priority
	^ priority
! !

!MXRecord methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: name; nextPutAll: ': MX '; nextPutAll: mx; nextPutAll: ' ('; print: priority; nextPut: $)
! !

!MXRecord methodsFor:'reading/writing'!

readFrom: aStream
        super readFrom: aStream.
        aStream skip: 2.
        priority := aStream nextNumber: 2.
        mx := self class readNameFrom: aStream
! !

!MXRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/MXRecord.st,v 1.4 2017-01-23 23:58:13 cg Exp $'
! !

