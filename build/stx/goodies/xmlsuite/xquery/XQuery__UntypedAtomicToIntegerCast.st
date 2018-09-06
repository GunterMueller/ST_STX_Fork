"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UntypedAtomicToAnyAtomicTypeCast subclass:#UntypedAtomicToIntegerCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToIntegerCast methodsFor:'casting'!

cast
    self checkLexicalForm.
    ^ AtomicItem withValue: atomicValue value asNumber asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:40:51 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!UntypedAtomicToIntegerCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
