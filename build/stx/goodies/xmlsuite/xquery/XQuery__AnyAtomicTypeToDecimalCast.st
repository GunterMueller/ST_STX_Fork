"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#AnyAtomicTypeToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!AnyAtomicTypeToDecimalCast methodsFor:'casting'!

checkedCast
    " cast from numeric types "
    | value |
    value := self getValue.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:44:32 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:31:08 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToDecimalCast methodsFor:'casting - private'!

getValue
    ^ atomicValue nodeId asNumber

    "Created: / 16-11-2009 / 18:13:10 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:50:37 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
