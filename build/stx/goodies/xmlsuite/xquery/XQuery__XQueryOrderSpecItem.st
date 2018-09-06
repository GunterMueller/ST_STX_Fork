"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryOrderSpecItem
	instanceVariableNames:'orderValue ascDesc emptyGreatestLeast'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!XQueryOrderSpecItem methodsFor:'accessing'!

ascDesc
    ^ ascDesc

    "Created: / 26-11-2006 / 20:14:57 / ked"
!

ascDesc:something
    ascDesc := something.

    "Created: / 26-11-2006 / 20:14:57 / ked"
!

emptyGreatestLeast
    ^ emptyGreatestLeast

    "Created: / 26-11-2006 / 20:14:57 / ked"
!

emptyGreatestLeast:something
    emptyGreatestLeast := something.

    "Created: / 26-11-2006 / 20:14:58 / ked"
!

orderValue
    ^ orderValue

    "Created: / 26-11-2006 / 20:14:57 / ked"
!

orderValue:something
    orderValue := something.

    "Created: / 26-11-2006 / 20:14:57 / ked"
! !

!XQueryOrderSpecItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
