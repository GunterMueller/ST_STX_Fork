"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToDecimalCast methodsFor:'casting'!

cast
    self normalizeWhitespaces.
    self checkLexicalForm.
    ^ (AnyAtomicTypeToDecimalCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:03:27 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
