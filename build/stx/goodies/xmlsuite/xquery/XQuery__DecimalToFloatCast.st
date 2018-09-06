"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DecimalToFloatCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DecimalToFloatCast methodsFor:'casting'!

cast
    | value |
    value := atomicValue value.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:32:02 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DecimalToFloatCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
