"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathNodePosition
	instanceVariableNames:'attributePosition elementPosition'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathNodePosition methodsFor:'accessing'!

attributePosition
    ^ attributePosition

    "Created: / 13-10-2006 / 18:45:34 / janfrog"
!

attributePosition:something
    attributePosition := something.

    "Created: / 13-10-2006 / 18:45:34 / janfrog"
!

elementPosition
    ^ elementPosition

    "Created: / 13-10-2006 / 18:46:08 / janfrog"
!

elementPosition:something 
    elementPosition := something.

    "Created: / 13-10-2006 / 18:46:16 / janfrog"
! !

!XPathNodePosition class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathNodePosition.st,v 1.1 2006-10-14 05:57:51 vranyj1 Exp $'
! !
