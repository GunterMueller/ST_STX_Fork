"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpConstants
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpConstants class methodsFor:'typecodes'!

array16
	^16rDC
!

array32
	^16rDD
!

bin16
	^16rC5
!

bin32
	^16rC6
!

bin8
	^16rC4
!

boolFalse
	^16rC2
!

boolTrue
	^16rC3
!

double
	^16rCB
!

ext16
	^16rC8
!

ext32
	^16rC9
!

ext8
	^16rC7
!

fixext1
	^16rD4
!

fixext16
	^16rD8
!

fixext2
	^16rD5
!

fixext4
	^16rD6
!

fixext8
	^16rD7
!

float
	^16rCA
!

int16
	^16rD1
!

int32
	^16rD2
!

int64
	^16rD3
!

int8
	^16rD0
!

map16
	^16rDE
!

map32
	^16rDF
!

str16
	^16rDA
!

str32
	^16rDB
!

str8
	^16rD9
!

uint16
	^16rCD
!

uint32
	^16rCE
!

uint64
	^16rCF
!

uint8
	^16rCC
!

undefinedNil
	^16rC0
! !

!MpConstants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpConstants.st,v 1.2 2018-05-08 11:01:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpConstants.st,v 1.2 2018-05-08 11:01:25 cg Exp $'
! !

