Object subclass:#NewsGroup
	instanceVariableNames:'name articleCount moderated readRange articleRange subscribed'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-NewsTool'
!


!NewsGroup methodsFor:'accessing'!

articleCount
    "return articleCount"

    ^ articleCount

    "Created: 9.5.1996 / 18:22:29 / cg"
!

articleCount:something
    "set articleCount"

    articleCount := something.

    "Created: 9.5.1996 / 18:22:29 / cg"
!

articleRange
    "return articleRange"

    ^ articleRange

    "Created: 9.5.1996 / 18:22:29 / cg"
!

articleRange:something
    "set articleRange"

    articleRange := something.

    "Created: 9.5.1996 / 18:22:29 / cg"
!

moderated
    "return moderated"

    ^ moderated

    "Created: 9.5.1996 / 18:22:29 / cg"
!

moderated:something
    "set moderated"

    moderated := something.

    "Created: 9.5.1996 / 18:22:29 / cg"
!

name
    "return name"

    ^ name

    "Created: 9.5.1996 / 18:40:51 / cg"
!

name:something
    "set name"

    name := something.

    "Created: 9.5.1996 / 18:40:51 / cg"
!

readRange
    "return readRange"

    ^ readRange

    "Created: 9.5.1996 / 18:22:29 / cg"
!

readRange:something
    "set readRange"

    readRange := something.

    "Created: 9.5.1996 / 18:22:29 / cg"
!

subscribed
    "return subscribed"

    ^ subscribed

    "Created: 9.5.1996 / 18:22:29 / cg"
!

subscribed:something
    "set subscribed"

    subscribed := something.

    "Created: 9.5.1996 / 18:22:30 / cg"
! !

!NewsGroup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/NewsTool/NewsGroup.st,v 1.2 1996-05-10 13:46:12 cg Exp $'
! !
