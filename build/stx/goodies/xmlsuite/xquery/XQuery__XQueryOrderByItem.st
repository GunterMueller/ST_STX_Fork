"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryOrderByItem
	instanceVariableNames:'orderSpecItems returnValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!XQueryOrderByItem methodsFor:'accessing'!

orderSpecItems
    ^ orderSpecItems

    "Created: / 26-11-2006 / 20:40:10 / ked"
!

orderSpecItems:something
    orderSpecItems := something.

    "Created: / 26-11-2006 / 20:40:10 / ked"
!

returnValue
    ^ returnValue

    "Created: / 26-11-2006 / 20:40:11 / ked"
!

returnValue:something
    returnValue := something.

    "Created: / 26-11-2006 / 20:40:11 / ked"
! !

!XQueryOrderByItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
