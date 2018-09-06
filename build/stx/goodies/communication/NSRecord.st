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

DNSRecord subclass:#NSRecord
	instanceVariableNames:'ns'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!NSRecord class methodsFor:'documentation'!

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

!NSRecord class methodsFor:'accessing'!

type
	^ 2
! !

!NSRecord methodsFor:'accessing'!

ns
	^ ns
! !

!NSRecord methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: name; nextPutAll: ': NS '; nextPutAll: ns
! !

!NSRecord methodsFor:'reading/writing'!

readFrom: aStream
        super readFrom: aStream.
        aStream skip: 2.
        ns := self class readNameFrom: aStream
! !

!NSRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/NSRecord.st,v 1.4 2017-01-23 23:58:16 cg Exp $'
! !

