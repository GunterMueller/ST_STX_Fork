"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#AnyAtomicTypeToStringCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!AnyAtomicTypeToStringCast methodsFor:'casting'!

cast
    | value |
    value := atomicValue stringValue.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 16-11-2009 / 18:58:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 22:38:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AnyAtomicTypeToStringCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
