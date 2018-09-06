"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DoubleToFloatCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DoubleToFloatCast methodsFor:'casting'!

cast
    ^ AtomicItem withValue: atomicValue value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:30:10 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DoubleToFloatCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
