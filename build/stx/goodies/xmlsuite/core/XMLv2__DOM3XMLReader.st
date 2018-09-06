"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#DOM3XMLReader
	instanceVariableNames:'namespacePrefixMapping'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!


!DOM3XMLReader class methodsFor:'accessing'!

concreteClass

    ^self

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
! !

!DOM3XMLReader class methodsFor:'testing'!

isSpecial

    ^true

    "Created: / 11-11-2006 / 19:26:14 / janfrog"
! !

!DOM3XMLReader methodsFor:'SAX2 events'!

getColumnNumber

    ^nil

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

getLineNumber

    ^nil

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

parseFragmentStream:aStream

    "I read DOM3 tree, not stream"

    self shouldNotImplement

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

parseStream:aStream 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
! !

!DOM3XMLReader methodsFor:'initialization'!

initialize

    super initialize.
    namespacePrefixMapping := Dictionary new

    "Created: / 11-11-2006 / 12:01:36 / janfrog"
! !

!DOM3XMLReader methodsFor:'visiting'!

parseNode:aDocument 
    aDocument acceptVisitor:self

    "Created: / 10-12-2006 / 13:49:55 / janfrog"
!

readDOMNode:aDocument 
    aDocument acceptVisitor:self

    "Created: / 23-12-2005 / 20:26:04 / janfrog"
!

visitAttr:anAttr

    contentHandler 
        startElement: 'fakeNode'
        namespace: ''
        prefix: ''
        attributes: (Attributes with:anAttr).


    contentHandler 
        endElement: 'fakeNode' 
        namespace: ''
        prefix: ''

    "Modified: / 25-12-2005 / 11:16:25 / janfrog"
!

visitCDATASection:aCDATASection

    (contentHandler respondsTo:#cDataSection:)
        ifTrue:[contentHandler cDataSection:aCDATASection data]
        ifFalse:[contentHandler characters:aCDATASection data]

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

visitComment:aComment

    contentHandler comment: aComment data

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

visitDocument:aDocument

    contentHandler startDocument.
    aDocument childNodes do:
        [:child|child acceptVisitor: self].
    contentHandler endDocument

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

visitDocumentFragment:aDocumentFragment


    aDocumentFragment childNodes do:
        [:child|child acceptVisitor: self].

    "Created: / 24-12-2005 / 10:55:01 / janfrog"
!

visitDocumentType:aDocumentType
    "nothing to do"

    "Created: / 07-04-2007 / 15:03:59 / janfrog"
!

visitElement:anElement

    | ns localName prefix attrs |
    ns := anElement namespaceURI.
    localName := anElement localName.
    prefix := anElement prefix.
    attrs := anElement attributes.

    contentHandler 
        startElement: localName 
        namespace: ns
        prefix: prefix
        attributes: attrs.

    anElement childNodes do:
        [:child| child acceptVisitor:self].

    contentHandler 
        endElement: localName 
        namespace: ns
        prefix: prefix

    "Modified: / 30-05-2005 / 16:30:11 / masca"
    "Created: / 23-12-2005 / 20:06:28 / janfrog"
!

visitProcessingInstruction: aPI

    contentHandler processingInstruction:aPI nodeName data:aPI nodeValue

    "Created: / 23-12-2005 / 20:10:36 / janfrog"
!

visitText:aText

    aText isElementContentWhitespace ifFalse:
        [contentHandler characters: aText data]

    "Created: / 23-12-2005 / 20:06:28 / janfrog"
! !

!DOM3XMLReader class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOM3XMLReader.st,v 1.1 2005-12-28 11:57:02 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
