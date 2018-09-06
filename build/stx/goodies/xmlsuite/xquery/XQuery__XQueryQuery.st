"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Script subclass:#XQueryQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Runtime'
!


!XQueryQuery methodsFor:'accessing'!

contextSize

    ^0 "variables are stored in a dictionary"

    "Created: / 18-09-2008 / 17:06:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

name

    ^'<top query>'

    "Created: / 18-09-2008 / 18:30:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryQuery class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
