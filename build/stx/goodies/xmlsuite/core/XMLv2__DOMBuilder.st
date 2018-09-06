"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XML::DOM_SAXDriver subclass:#DOMBuilder
	instanceVariableNames:'xmlReader domImplementation'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Parser'
!


!DOMBuilder methodsFor:'SAX2 events'!

endPrefixMapping:prefix

    "Created: / 23-04-2005 / 12:30:07 / janfrog"
!

startElement: localName namespace: nameSpace prefix: nameSpacePrefix attributes: atts 
        | elm nodeTag|
        nodeTag := XML::NodeTag new
            qualifier:nameSpacePrefix
            ns:nameSpace
            type:localName.

        stack size = 0 ifTrue: [^self].
        elm := self createElement: nodeTag attributes: atts.
        stack last addNode: elm.
        stack addLast: elm

    "Created: / 23-04-2005 / 12:30:07 / janfrog"
!

startPrefix:prefix mappingTo:namespace

    "Created: / 23-04-2005 / 12:30:07 / janfrog"
! !

!DOMBuilder methodsFor:'SAX2 interface'!

setDocumentLocator:loc

    locator := loc

    "Created: / 18-05-2005 / 10:52:41 / masca"
! !

!DOMBuilder methodsFor:'accessing'!

domImplementation
    ^ domImplementation

    "Created: / 10-04-2007 / 16:23:37 / janfrog"
!

domImplementation:aDOMImplementation
    domImplementation := aDOMImplementation.

    "Created: / 10-04-2007 / 16:23:37 / janfrog"
!

xmlReader
    ^ xmlReader

    "Created: / 14-05-2005 / 22:55:16 / janfrog"
!

xmlReader:aXMLReader
    xmlReader := aXMLReader.

    "Created: / 14-05-2005 / 22:55:16 / janfrog"
! !

!DOMBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMBuilder.st,v 1.2 2007-04-12 11:40:09 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

