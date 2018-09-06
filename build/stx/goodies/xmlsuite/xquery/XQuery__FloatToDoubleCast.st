"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#FloatToDoubleCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!FloatToDoubleCast methodsFor:'casting'!

cast
    ^ AtomicItem withValue: (atomicValue nodeId) asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:27:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!FloatToDoubleCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
