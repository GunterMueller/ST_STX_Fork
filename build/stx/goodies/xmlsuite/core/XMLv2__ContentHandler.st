"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

AbstractSAX2Handler subclass:#ContentHandler
	instanceVariableNames:'documentLocator'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2'
!


!ContentHandler methodsFor:'Compatibility-VW'!

documentLocator:aLocator

    "self setDocumentLocator:aLocator"

    "Created: / 04-05-2005 / 11:29:11 / janfrog"
    "Modified: / 19-05-2005 / 09:46:06 / masca"
! !

!ContentHandler methodsFor:'SAX2 interface'!

characters:aString

    "Created: / 16-04-2005 / 12:28:20 / janfrog"
!

endDocument

    "Created: / 16-04-2005 / 12:28:31 / janfrog"
!

endDocumentFragment

    "Created: / 10-08-2007 / 09:22:12 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix

    "Created: / 22-04-2005 / 21:41:16 / janfrog"
    "Modified: / 14-05-2005 / 10:03:21 / janfrog"
!

endPrefixMapping:prefix

    "Created: / 16-04-2005 / 12:29:45 / janfrog"
!

ignorableWhitespace:aString

    "Created: / 16-04-2005 / 12:30:04 / janfrog"
!

processingInstruction:target data:data

    "Created: / 16-04-2005 / 12:31:04 / janfrog"
!

setDocumentLocator:aLocator

    documentLocator := aLocator

    "Created: / 16-04-2005 / 12:30:37 / janfrog"
!

skippedEnrity:aString

    "Created: / 16-04-2005 / 12:31:18 / janfrog"
!

startDocument

    "Created: / 16-04-2005 / 12:31:25 / janfrog"
!

startDocumentFragment

    "Created: / 10-08-2007 / 09:22:07 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes

    "Created: / 22-04-2005 / 21:40:32 / janfrog"
    "Modified: / 14-05-2005 / 10:03:04 / janfrog"
!

startPrefix:prefix mappingTo:uri

    "Created: / 17-04-2005 / 08:47:18 / janfrog"
! !

!ContentHandler methodsFor:'SAX2 interface - extensions'!

cDataSection: aString

    "same as characters by default:"
    ^self characters: aString

    "Created: / 28-12-2005 / 16:18:00 / janfrog"
!

comment:aString

    "Created: / 17-04-2005 / 13:27:42 / janfrog"
!

getDocumentLocator

    ^documentLocator

    "Created: / 15-05-2005 / 20:01:21 / janfrog"
! !

!ContentHandler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__ContentHandler.st,v 1.3 2007-08-10 07:32:06 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
