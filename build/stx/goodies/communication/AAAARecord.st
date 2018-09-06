"
 COPYRIGHT (c) 2010 by eXept Software AG
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

DNSRecord subclass:#AAAARecord
	instanceVariableNames:'address'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!AAAARecord class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!AAAARecord class methodsFor:'accessing'!

documentation
"
    no warranty; provided AS-IS
    code ported from squeak
"

    "Created: / 22-11-2006 / 12:48:56 / cg"
!

type
        ^ 28
! !

!AAAARecord methodsFor:'accessing'!

address
	^ address
!

address: aByteArray
        address := aByteArray
! !

!AAAARecord methodsFor:'printing'!

printOn: aStream
        aStream nextPutAll: name; nextPutAll: ': AAAA '; print: address
! !

!AAAARecord methodsFor:'reading/writing'!

readFrom: aStream
        super readFrom: aStream.
        address := (aStream next: (aStream nextNumber: 2)) asByteArray
!

writeOn: aStream
	super writeOn: aStream.
	aStream
		nextNumber: 2 put: address size;
		nextPutAll: address
! !

!AAAARecord methodsFor:'testing'!

isAAAARecord
    ^ true
! !

!AAAARecord class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/AAAARecord.st,v 1.3 2017-01-23 23:58:03 cg Exp $'
! !

