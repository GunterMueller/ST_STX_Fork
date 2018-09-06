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

Object subclass:#DNSRecord
	instanceVariableNames:'name type dclass ttl timestamp'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!DNSRecord class methodsFor:'documentation'!

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

!DNSRecord class methodsFor:'instance creation'!

name: aString type: anInteger class: bInteger
	self subclassesDo: [:each |
		each type = anInteger
			ifTrue: [^ each new name: aString; dclass: bInteger]].
	^ UnrecognizedRecord new name: aString; type: anInteger; dclass: bInteger
!

readFrom: aStream
	^ (self name: (self readNameFrom: aStream) type: (aStream nextNumber: 2) class: (aStream nextNumber: 2)) readFrom: aStream
!

readNameFrom: aStream
	| length outputStream offset pos |
	outputStream _ '' writeStream.
	[(length _ aStream next asInteger) > 0]
		whileTrue:
			[outputStream position = 0 ifFalse: [outputStream nextPut: $.].
			length >= 16rC0
				ifTrue: [offset _ (length bitAnd: 16r3F) * 256 + aStream next asInteger.
						pos _ aStream position.
						aStream position: offset.
						outputStream nextPutAll: (self readNameFrom: aStream).
						aStream position: pos.
						^ outputStream contents]
				ifFalse: [outputStream nextPutAll: (aStream next: length) asString]].
	^ outputStream contents
! !

!DNSRecord class methodsFor:'accessing'!

type
	^ nil
! !

!DNSRecord methodsFor:'accessing'!

dclass
        ^ dclass ? 1
!

dclass: anInteger
        dclass := anInteger
!

name
        ^ name ? ''
!

name: aString
        name := aString
!

ttl
        ^ ttl ? 0
!

type
	^ type ifNil: [self class type]
!

type: anInteger
        type := anInteger
! !

!DNSRecord methodsFor:'printing'!

printOn: aStream
	aStream
		nextPutAll: name; nextPutAll: ': ';
		nextPutAll: (#(A NS MD MF CNAME SOA MB MG MR NULL WKS PTR HINFO MINFO MX) at: self type ifAbsent: [self type printString])
! !

!DNSRecord methodsFor:'reading/writing'!

readFrom: aStream
        ttl := aStream nextNumber: 4.
        timestamp := Time millisecondClockValue
!

writeNameOn: aStream
	(self name findTokens: '.')
		do: [:each |
			each size > 63 ifTrue: [self error: 'invalid name'].
			aStream nextPut: each size; nextPutAll: each asByteArray].
	aStream nextPut: 0
!

writeOn: aStream
	self writeNameOn: aStream.
	aStream nextNumber: 2 put: self type; nextNumber: 2 put: self dclass; nextNumber: 4 put: self ttl
! !

!DNSRecord methodsFor:'testing'!

isAAAARecord
    ^ false
!

isARecord
    ^ false
!

isCNAMERecord
    ^ false
!

timedOut
	^ (Time millisecondsSince: timestamp) // 1000 > ttl
! !

!DNSRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSRecord.st,v 1.6 2017-01-23 23:57:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSRecord.st,v 1.6 2017-01-23 23:57:52 cg Exp $'
! !

