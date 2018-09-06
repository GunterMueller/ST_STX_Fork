"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#BooleanToIntegerCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!BooleanToIntegerCast methodsFor:'casting'!

cast
    | value |
    "If ST is xs:boolean, SV is converted to 1 if SV is 1 or true and to 0 
        if SV is 0 or false and the conversion is complete."

    atomicValue nodeId ifTrue:
    [
        value := 1
    ]
    ifFalse:
    [
        value := 0.
    ].

    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 19:27:07 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!BooleanToIntegerCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
