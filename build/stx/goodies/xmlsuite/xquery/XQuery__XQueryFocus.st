"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryFocus
	instanceVariableNames:'contextItem contextPosition contextSize'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Runtime'
!


!XQueryFocus methodsFor:'accessing'!

contextItem
    ^ contextItem

    "Created: / 17-11-2006 / 11:59:42 / ked"
!

contextItem:something
    contextItem := something.

    "Created: / 17-11-2006 / 11:59:42 / ked"
!

contextPosition
    ^ contextPosition ? 0

    "Created: / 17-11-2006 / 11:59:42 / ked"
    "Modified: / 21-03-2007 / 17:22:59 / janfrog"
!

contextPosition:something
    contextPosition := something.

    "Created: / 17-11-2006 / 11:59:42 / ked"
!

contextPositionAdvance
    ^ contextPosition := self contextPosition + 1.

    "Created: / 21-03-2007 / 20:21:36 / janfrog"
!

contextSize
    ^ contextSize

    "Created: / 17-11-2006 / 11:59:42 / ked"
!

contextSize:something
    contextSize := something.

    "Created: / 17-11-2006 / 11:59:42 / ked"
! !

!XQueryFocus class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
