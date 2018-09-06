"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#AnyAtomicTypeToDoubleCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!AnyAtomicTypeToDoubleCast methodsFor:'casting'!

checkedCast
    | value |
    value := self getValue.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 19:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToDoubleCast methodsFor:'casting - private'!

getValue
    | value |
    value := nil.

    (atomicValue nodeId = 'INF') ifTrue:
    [
        value := Float infinity.
    ].

    (atomicValue nodeId = '-INF') ifTrue:
    [
        value := Float negativeInfinity.
    ].

    (atomicValue nodeId = 'NaN') ifTrue:
    [
        value := Float nan.
    ].

    value ifNil: 
    [
        value := atomicValue nodeId asNumber asDouble 
    ].

    ^ value.

    "Created: / 16-11-2009 / 18:13:10 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToDoubleCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
