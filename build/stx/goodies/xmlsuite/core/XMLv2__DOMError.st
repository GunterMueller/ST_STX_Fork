"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMError
	instanceVariableNames:'severity message type relatedException relatedData location'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!DOMError class methodsFor:'DOM3 constants'!

SEVERITY_ERROR

    ^2

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

SEVERITY_FATAL_ERROR

    ^3

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

SEVERITY_WARNING

    ^1

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
! !

!DOMError methodsFor:'DOM3 interface'!

location
    ^ location

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

message
    ^ message

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

relatedData
    ^ relatedData

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

relatedException
    ^ relatedException

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

severity
    ^ severity

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

type
    ^ type

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
! !

!DOMError methodsFor:'initialization'!

setSeverity: anInteger

    severity := anInteger

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
! !

!DOMError class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMError.st,v 1.2 2005-12-28 16:18:31 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
