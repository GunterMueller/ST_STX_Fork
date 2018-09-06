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

Object subclass:#DNSQuery
	instanceVariableNames:'name type dclass'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!DNSQuery class methodsFor:'documentation'!

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

!DNSQuery class methodsFor:'instance creation'!

name: aString type: anInteger class: bInteger
	^ self new name: aString; type: anInteger; dclass: bInteger
!

readFrom: aStream
	^ self name: (DNSRecord readNameFrom: aStream) type: (aStream nextNumber: 2) class: (aStream nextNumber: 2)
! !

!DNSQuery methodsFor:'accessing'!

dclass
	^ dclass
!

dclass: anInteger
        dclass := anInteger
!

name
	^ name
!

name: aString
        name := aString
!

type
	^ type
!

type: anInteger
        type := anInteger
! !

!DNSQuery methodsFor:'comparing'!

= aDNSQuery
	^ type = aDNSQuery type and: [name = aDNSQuery name and: [dclass = aDNSQuery dclass]]
!

hash
	^ name hash + type + dclass
! !

!DNSQuery methodsFor:'printing'!

printOn: aStream
        aStream
                nextPutAll: name; nextPutAll: ': ';
                nextPutAll: (#(A NS MD MF CNAME SOA MB MG MR NULL WKS PTR HINFO MINFO MX TXT RP AFSDB X25 ISDN RT NSAP #'NSAP-PTR' SIG KEY PX GPOS AAAA) at: type ifAbsent: [type printString]);
                nextPut: $?
! !

!DNSQuery methodsFor:'reading/writing'!

writeNameOn: aStream
	(name findTokens: '.')
		do: [:each |
			each size > 63 ifTrue: [self error: 'invalid name'].
			aStream nextPut: each size; nextPutAll: each asByteArray].
	aStream nextPut: 0
!

writeOn: aStream
	self writeNameOn: aStream.
	aStream nextNumber: 2 put: type; nextNumber: 2 put: dclass
! !

!DNSQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSQuery.st,v 1.5 2017-01-23 23:58:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSQuery.st,v 1.5 2017-01-23 23:58:10 cg Exp $'
! !

