"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#FunctionParam
	instanceVariableNames:'name type'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Functions'
!


!FunctionParam methodsFor:'accessing'!

name
    ^ name

    "Created: / 28-12-2006 / 14:10:44 / janfrog"
!

name:something
    name := something.

    "Created: / 28-12-2006 / 14:10:44 / janfrog"
!

type
    ^ type

    "Created: / 28-12-2006 / 14:10:44 / janfrog"
!

type:something
    type := something.

    "Created: / 28-12-2006 / 14:10:44 / janfrog"
! !

!FunctionParam class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
