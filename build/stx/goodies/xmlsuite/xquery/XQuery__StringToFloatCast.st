"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToFloatCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToFloatCast methodsFor:'casting'!

cast
    self normalizeWhitespaces.
    self checkLexicalForm.
    ^ (AnyAtomicTypeToFloatCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:06:18 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToFloatCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
