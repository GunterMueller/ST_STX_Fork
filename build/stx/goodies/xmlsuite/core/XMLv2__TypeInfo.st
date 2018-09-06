"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#TypeInfo
	instanceVariableNames:'typeName typeNamespace'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!TypeInfo class methodsFor:'DOM3 constants'!

DERIVATION_EXTENSION

    ^16r02

    "Created: / 24-12-2005 / 11:10:03 / janfrog"
!

DERIVATION_LIST

    ^16r08

    "Created: / 24-12-2005 / 11:10:18 / janfrog"
!

DERIVATION_RESTRICTION

    ^16r01

    "Created: / 24-12-2005 / 11:09:53 / janfrog"
!

DERIVATION_UNION

    ^16r04

    "Created: / 24-12-2005 / 11:10:12 / janfrog"
! !

!TypeInfo methodsFor:'DOM3 interface'!

isDerivedFromNS: anotherTypeNamespace name: anotherTypeName method: derivationMethod

    false

    "Created: / 24-12-2005 / 11:11:18 / janfrog"
!

typeName
    ^ typeName

    "Created: / 24-12-2005 / 11:08:58 / janfrog"
!

typeNamespace
    ^ typeNamespace

    "Created: / 24-12-2005 / 11:08:58 / janfrog"
! !

!TypeInfo class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__TypeInfo.st,v 1.1 2005-12-25 10:55:30 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
