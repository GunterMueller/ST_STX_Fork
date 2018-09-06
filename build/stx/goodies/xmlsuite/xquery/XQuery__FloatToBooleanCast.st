"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#FloatToBooleanCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!FloatToBooleanCast methodsFor:'casting'!

cast
    | value |
    "If ST is xs:float, xs:double, xs:decimal or xs:integer and SV is 0, +0, -0, 0.0, 0.0E0 or NaN, then TV is false."
    ((atomicValue nodeId = 0) or: [ atomicValue nodeId isNaN]) ifTrue:
    [
        value := false.
    ] 
    ifFalse:
    [
        value := true.
    ].

    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:59:55 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!FloatToBooleanCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
