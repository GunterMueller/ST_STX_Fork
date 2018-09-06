"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#DerivedToParentCasting
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DerivedToParentCasting methodsFor:'casting'!

accept: type and: anotherType
    ^ TypeFactory current isType: type subtypeOf: anotherType.

    "Created: / 07-11-2009 / 17:20:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:19:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

cast: atomicValue to: anotherType
    ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.

    "Created: / 07-11-2009 / 16:51:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:20:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DerivedToParentCasting class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
