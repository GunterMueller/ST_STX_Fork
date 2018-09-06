"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UntypedAtomicToAnyAtomicTypeCast subclass:#UntypedAtomicToDoubleCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToDoubleCast methodsFor:'casting'!

cast
    self checkLexicalForm.
    ^ (AnyAtomicTypeToDoubleCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:11:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!UntypedAtomicToDoubleCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
