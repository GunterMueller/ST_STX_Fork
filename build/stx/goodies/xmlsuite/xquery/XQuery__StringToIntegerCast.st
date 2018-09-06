"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToIntegerCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToIntegerCast methodsFor:'casting'!

cast
    self normalizeWhitespaces.
    self checkLexicalForm.
    ^ AtomicItem withValue: (atomicValue value) asNumber asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:03:49 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToIntegerCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
