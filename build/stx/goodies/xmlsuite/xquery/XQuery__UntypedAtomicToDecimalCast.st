"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UntypedAtomicToAnyAtomicTypeCast subclass:#UntypedAtomicToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToDecimalCast methodsFor:'casting'!

cast
    self checkLexicalForm.
    ^ (AnyAtomicTypeToDecimalCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!UntypedAtomicToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
