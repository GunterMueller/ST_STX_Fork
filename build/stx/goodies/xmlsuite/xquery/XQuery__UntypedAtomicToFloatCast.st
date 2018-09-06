"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UntypedAtomicToAnyAtomicTypeCast subclass:#UntypedAtomicToFloatCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToFloatCast methodsFor:'casting'!

cast
    self checkLexicalForm.
    ^ (AnyAtomicTypeToFloatCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!UntypedAtomicToFloatCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
