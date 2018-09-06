"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToDoubleCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToDoubleCast methodsFor:'casting'!

cast
    self normalizeWhitespaces.
    self checkLexicalForm.
    ^ (AnyAtomicTypeToDoubleCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:05:49 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToDoubleCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
