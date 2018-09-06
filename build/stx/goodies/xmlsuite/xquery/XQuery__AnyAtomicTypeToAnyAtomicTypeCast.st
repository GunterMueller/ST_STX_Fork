"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#AnyAtomicTypeToAnyAtomicTypeCast
	instanceVariableNames:'atomicValue anotherType'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!AnyAtomicTypeToAnyAtomicTypeCast methodsFor:'accessing'!

anotherType
    ^ anotherType
!

anotherType:something
    anotherType := something.
!

atomicValue
    ^ atomicValue
!

atomicValue: anAtomicValue
    atomicValue := anAtomicValue.

    "Modified: / 08-11-2009 / 14:16:18 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToAnyAtomicTypeCast methodsFor:'casting'!

cast
    atomicValue typeName = anotherType typeName ifTrue:
    [
        | value |
        value := atomicValue nodeId.
        ^ AtomicItem withValue: value asType: anotherType typeName.
    ]
    ifFalse:
    [
        AtomicItemError raiseErrorString: 'cast from ', atomicValue typeName, ' to ', anotherType typeName, ' not supported'.
    ].
"/    (TypeFactory isType: anotherType typeName subtypeOf: 'xs:integer') ifTrue: [
"/        "see: 17.1.3.4 Casting to xs:integer on http://www.w3.org/TR/xpath-functions"
"/        (atomicValue isSubtypeOf: 'xs:integer') ifTrue: [
"/            ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.
"/        ].
"/        (atomicValue isSubtypeOf: 'xs:decimal' or: 'xs:float' or: 'xs:double') ifTrue: [
"/            ^ AtomicItem withValue: (atomicValue nodeId truncated) asType: anotherType typeName.
"/        ].
"/        (atomicValue isSubtypeOf: 'xs:boolean') ifTrue: [
"/            atomicValue nodeId ifTrue: [
"/                ^ AtomicItem withValue: 0 asType: anotherType typeName.
"/            ] ifFalse: [
"/                ^ AtomicItem withValue: 0 asType: anotherType typeName.
"/            ]
"/        ].
"/    ].
"/
"/
"/    "TODO - this is only HOT FIX - see XQuery Types for more information"
"/    (TypeFactory isType: anotherType typeName subtypeOf: 'xs:decimal') ifTrue: [
"/        ^ AtomicItem withValue: atomicValue nodeId asNumber asType: anotherType typeName.
"/    ].
"/
"/"/    (TypeFactory isType: anotherType typeName subtypeOf: 'xs:double') ifTrue: [
"/"/        ^ AtomicItem withValue: atomicValue nodeId asNumber asDouble asType: anotherType typeName.
"/"/    ].
"/
"/
"/    ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.

    "Created: / 08-11-2009 / 14:15:02 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 14:33:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToAnyAtomicTypeCast methodsFor:'error reporting'!

raiseError: errorType
    AtomicItemError raiseErrorString: 'Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:20:46 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:14:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseError: errorType withMessage: message
    AtomicItemError raiseErrorString: message, ' Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:21:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:14:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToAnyAtomicTypeCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
