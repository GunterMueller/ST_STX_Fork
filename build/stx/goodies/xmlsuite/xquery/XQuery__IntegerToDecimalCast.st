"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#IntegerToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!IntegerToDecimalCast methodsFor:'casting'!

cast
    | value |
    value := atomicValue value asDouble.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:36:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!IntegerToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
