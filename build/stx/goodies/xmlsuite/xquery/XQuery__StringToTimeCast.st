"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToTimeCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToTimeCast methodsFor:'casting'!

cast
    | value |
    self normalizeWhitespaces.
    self checkLexicalForm.
    value := Time readFrom: atomicValue nodeId.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:06:27 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToTimeCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
