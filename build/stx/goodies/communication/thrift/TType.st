"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Misc'
!


!TType class methodsFor:'as yet unclassified'!

bool
	^ 2
!

byte
	^ 3
!

codeOf: aTypeName
	self typeMap do: [:each | each first = aTypeName ifTrue: [^ each second]].
	^ nil
!

double
	^ 4
!

i16
	^ 6
!

i32
	^ 8
!

i64
	^ 10
!

list
	^ 15
!

map
	^ 13
!

nameOf: aTypeCode
	self typeMap do: [:each | each second = aTypeCode ifTrue: [^ each first]].
	^ nil
!

set
	^ 14
!

stop
	^ 0
!

string
	^ 11
!

struct
	^ 12
!

typeMap
	^ #((bool 2) (byte 3) (double 4) (i16 6) (i32 8) (i64 10) (list 15)
	   (map 13) (set 15) (stop 0) (string 11) (struct 12) (void 1))
!

void
	^ 1
! !

!TType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TType.st,v 1.1 2013-03-19 14:48:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TType.st,v 1.1 2013-03-19 14:48:06 cg Exp $'
! !

