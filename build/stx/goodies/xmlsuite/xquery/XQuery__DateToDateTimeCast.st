"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DateToDateTimeCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DateToDateTimeCast methodsFor:'casting'!

cast
    | value |
    value := Timestamp readFrom: atomicValue stringValue.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 16-11-2009 / 18:58:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 19:21:30 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DateToDateTimeCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
