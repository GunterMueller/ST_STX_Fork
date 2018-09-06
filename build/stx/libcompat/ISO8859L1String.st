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
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

String variableByteSubclass:#ISO8859L1String
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!ISO8859L1String class methodsFor:'documentation'!

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
!

documentation
"
    This is a dummy stub - only present to provide a superclass for
    some VW Public Domain code (which subclass or add loose code to ISO8859L1String).
"
! !

!ISO8859L1String class methodsFor:'marshalling'!

marshallID
	" answer the ID for this class used for (un)marshalling "

	^ 7
!

unmarshallBinaryFrom: aStream marshaller: aCatRMMarshall

	| length new |
	length := aCatRMMarshall loadCoastVersion major >= 4
		ifTrue: [ aStream nextCoastStringLength ]
		ifFalse: [ aStream oldNextCoastStringLength ].
	new := self new: length.
	1 to: length do:
		[:i |
		new byteAt: i put: aStream next].
	^new
! !

!ISO8859L1String methodsFor:'marshalling'!

isCoastPrimitiveValue

	^ true
!

marshallBinaryTo: aStream marshaller: aCatRMMarshall

	aStream nextPut: self class marshallID.
	aStream nextCoastStringPut: self.
! !

!ISO8859L1String class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ISO8859L1String.st,v 1.2 2017-01-23 22:36:46 cg Exp $'
! !

