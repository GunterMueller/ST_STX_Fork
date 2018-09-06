"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

ContentHandler subclass:#DOM3Builder
	instanceVariableNames:'currentNode document domImplementation autoWrapInDocumentFragment
		documentFactory'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Parser'
!


!DOM3Builder class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 12-04-2007 / 12:00:39 / janfrog"
! !

!DOM3Builder methodsFor:'SAX2 interface'!

characters:aString

    |textNode|

    textNode := self documentFactory createTextNode:aString.

    self currentNode 
            ifNil:[currentNode := textNode]
            ifNotNil:[self currentNode appendChild:textNode]

    "Created: / 04-08-2005 / 13:34:25 / janfrog"
    "Modified: / 21-11-2007 / 13:49:45 / janfrog"
!

endDocument
        | docType |

    self currentNode 
        setStandalone: documentLocator getXmlStandalone;
        setInputEncoding: documentLocator getXmlEncoding;
        setXmlVersion: documentLocator getXmlVersion.
    docType := domImplementation  createDocumentType: (currentNode documentElement nodeName) publicId: (documentLocator getPublicId) systemId: (documentLocator getSystemId).
    "/currentNode setDocumentType: docType.

    "Created: / 28-12-2005 / 16:30:34 / janfrog"
    "Modified: / 07-04-2007 / 15:08:58 / janfrog"
!

endDocumentFragment

    "| docType |

    self currentNode 
        setStandalone: documentLocator getXmlStandalone;
        setInputEncoding: documentLocator getXmlEncoding;
        setXmlVersion: documentLocator getXmlVersion.
    docType := domImplementation  createDocumentType: (currentNode documentElement nodeName) publicId: (documentLocator getPublicId) systemId: (documentLocator getSystemId).
    "
    "/currentNode setDocumentType: docType.

    "Created: / 10-08-2007 / 09:22:53 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix

    currentNode parent ifNotNil:
        [currentNode := currentNode parent]

    "Created: / 04-08-2005 / 13:29:36 / janfrog"
    "Modified: / 14-11-2007 / 14:47:36 / janfrog"
!

ignorableWhitespace:aString

    self characters:aString

    "Created: / 04-08-2005 / 13:34:35 / janfrog"
!

processingInstruction:target data:data

    self currentNode appendChild:
        (ProcessingInstruction new
            target:target;
            data:data)

    "Created: / 04-08-2005 / 13:32:41 / janfrog"
    "Modified: / 10-12-2006 / 20:37:58 / janfrog"
!

startDocument

    currentNode := document := documentFactory := domImplementation createDocument.

    "Created: / 04-08-2005 / 13:24:13 / janfrog"
    "Modified: / 14-11-2007 / 14:46:21 / janfrog"
!

startDocumentFragment

    currentNode := document := documentFactory := domImplementation createDocumentFragment.

    "Created: / 10-08-2007 / 09:22:27 / janfrog"
    "Modified: / 14-11-2007 / 14:46:29 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes

    | element nodeName |

    self currentNode.
    nodeName := NodeName new localName:localName; ns:namespace; prefix:prefix.
    element := self documentFactory createElement: localName ns: namespace.
    element prefix: prefix.
    element setAttributes:attributes.
    "/Element named:nodeName attributes:attributes.
    self currentNode ifNotNil:
        [self currentNode appendChild:element].
    currentNode := element.

    "Created: / 04-08-2005 / 13:29:20 / janfrog"
    "Modified: / 14-11-2007 / 14:47:52 / janfrog"
! !

!DOM3Builder methodsFor:'SAX2 interface - extensions'!

attribute:localName namespace:namespace prefix:prefix value: value

    currentNode := Attr new
                    localName: localName;
                    ns: namespace;
                    prefix: prefix;
                    nodeValue: value

    "Created: / 14-11-2007 / 15:13:33 / janfrog"
!

cDataSection: aString

    self currentNode appendChild:
        (CDATASection new data:aString)

    "Created: / 28-12-2005 / 13:51:31 / janfrog"
    "Modified: / 10-12-2006 / 20:38:11 / janfrog"
!

comment:aString

    self currentNode appendChild:
        (Comment new data:aString)

    "Created: / 04-08-2005 / 13:33:47 / janfrog"
    "Modified: / 10-12-2006 / 20:38:15 / janfrog"
! !

!DOM3Builder methodsFor:'accessing'!

autoWrapInDocumentFragment
    ^ autoWrapInDocumentFragment

    "Created: / 14-11-2007 / 14:39:45 / janfrog"
!

autoWrapInDocumentFragment:aBoolean
    autoWrapInDocumentFragment := aBoolean.

    "Created: / 14-11-2007 / 14:39:45 / janfrog"
!

currentNode

    (currentNode isNil and:[autoWrapInDocumentFragment]) ifTrue:[
        currentNode := self domImplementation createDocumentFragment.
        document := documentFactory := currentNode ownerDocument.
    ].
    ^currentNode

    "Created: / 10-12-2006 / 20:36:28 / janfrog"
    "Modified: / 17-11-2007 / 08:37:17 / janfrog"
!

document

    ^currentNode

    "Created: / 04-08-2005 / 13:35:07 / janfrog"
!

documentFactory

    ^documentFactory

    "Created: / 14-11-2007 / 14:45:07 / janfrog"
!

domImplementation
    ^ domImplementation

    "Created: / 07-04-2007 / 14:58:48 / janfrog"
!

domImplementation:aDOMImplementation
    domImplementation := aDOMImplementation.

    "Created: / 07-04-2007 / 14:58:48 / janfrog"
! !

!DOM3Builder methodsFor:'initialization'!

initialize

    
    domImplementation := DOMImplementationRegistry getDOMImplementation:'+XML 3.0 '.
    autoWrapInDocumentFragment := true.
    documentFactory := self domImplementation createDocumentFragment

    "Created: / 12-04-2007 / 12:00:39 / janfrog"
    "Modified: / 14-11-2007 / 14:45:54 / janfrog"
! !

!DOM3Builder class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOM3Builder.st,v 1.11 2007-11-22 22:18:41 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
