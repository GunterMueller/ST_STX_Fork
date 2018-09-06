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

DNSRecord subclass:#UnrecognizedRecord
	instanceVariableNames:'data'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!UnrecognizedRecord class methodsFor:'documentation'!

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

!UnrecognizedRecord methodsFor:'reading/wrinting'!

data
	^ data
!

data: aByteArray
        data := aByteArray
!

readFrom: aStream
        super readFrom: aStream.
        data := aStream next: (aStream nextNumber: 2)
!

writeOn: aStream
	super writeOn: aStream.
	aStream nextNumber: 2 put: data size; nextPutAll: data
! !

!UnrecognizedRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/UnrecognizedRecord.st,v 1.4 2017-01-23 23:57:58 cg Exp $'
! !

