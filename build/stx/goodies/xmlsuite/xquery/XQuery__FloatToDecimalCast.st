"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#FloatToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!FloatToDecimalCast methodsFor:'casting'!

cast
    ^ (AnyAtomicTypeToDecimalCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:25:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!FloatToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
