"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DecimalToBooleanCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DecimalToBooleanCast methodsFor:'casting'!

cast
    | value |
    "If ST is xs:float, xs:double, xs:decimal or xs:integer and SV is 0, +0, -0, 0.0, 0.0E0 or NaN, then TV is false."
    ((atomicValue value = 0) or: [ atomicValue value isNaN]) ifTrue:
    [
        value := false.
    ] 
    ifFalse:
    [
        value := true.
    ].

    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:29:32 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DecimalToBooleanCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
