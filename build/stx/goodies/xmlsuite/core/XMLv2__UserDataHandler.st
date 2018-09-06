"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#UserDataHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!UserDataHandler class methodsFor:'DOM3 constants'!

NODE_ADOPTED

    ^5

    "Created: / 25-12-2005 / 09:43:15 / janfrog"
!

NODE_CLONED

    ^1

    "Created: / 25-12-2005 / 09:42:25 / janfrog"
!

NODE_DELETED

    ^3

    "Created: / 25-12-2005 / 09:43:02 / janfrog"
!

NODE_IMPORTED

    ^2

    "Created: / 25-12-2005 / 09:42:32 / janfrog"
!

NODE_RENAMED

    ^4

    "Created: / 25-12-2005 / 09:43:07 / janfrog"
! !

!UserDataHandler methodsFor:'DOM3 interface'!

handleOperation:operation key:key data:userData sourceNode:srcNode destinationNode:dstNode

    ^self subclassResponsibility

    "Created: / 25-12-2005 / 09:45:07 / janfrog"
! !

!UserDataHandler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__UserDataHandler.st,v 1.2 2005-12-25 10:52:12 vranyj1 Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

