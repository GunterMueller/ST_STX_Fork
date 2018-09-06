"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#ParentToDerivedCasting
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!ParentToDerivedCasting methodsFor:'casting'!

accept: type and: anotherType
    ^ TypeFactory current isType: type supertypeOf: anotherType.

    "Created: / 07-11-2009 / 17:20:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:19:12 / Jan Kurs <kursj1@fel.cvut.cz>"
!

cast: atomicValue to: anotherType
    ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.

    "Created: / 07-11-2009 / 16:51:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:30:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ParentToDerivedCasting class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
