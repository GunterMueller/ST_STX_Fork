"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#CincomDOMXMLReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!


!CincomDOMXMLReader class methodsFor:'accessing'!

concreteClass

    ^self

    "Created: / 21-12-2005 / 17:41:18 / janfrog"
! !

!CincomDOMXMLReader class methodsFor:'testing'!

isSpecial

    ^true

    "Created: / 29-10-2006 / 22:43:25 / janfrog"
! !

!CincomDOMXMLReader methodsFor:'SAX2 events'!

getColumnNumber

    ^nil

    "Created: / 21-12-2005 / 17:22:44 / janfrog"
!

getLineNumber

    ^nil

    "Created: / 21-12-2005 / 17:22:44 / janfrog"
!

parseFragmentStream:aStream

    "I read Cincom DOM tree, not stream"

    self shouldNotImplement

    "Modified: / 21-12-2005 / 17:23:30 / janfrog"
!

parseNode:aDocument 
    aDocument acceptVisitor:self

    "Created: / 10-12-2006 / 13:49:55 / janfrog"
!

parseStream:aStream 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 21-12-2005 / 17:22:44 / janfrog"
!

visitComment:aComment

    contentHandler comment: aComment text

    "Created: / 21-12-2005 / 17:22:37 / janfrog"
!

visitDocument:aDocument

    contentHandler startDocument.
    aDocument children do:
        [:child|child acceptVisitor: self].
    contentHandler endDocument

    "Created: / 21-12-2005 / 17:22:37 / janfrog"
!

visitElement:anElement

    | ns localName prefix attrs |
    ns := anElement tag namespace.
    localName := anElement tag type.
    prefix := anElement tag qualifier.
    attrs := Attributes new:(anElement attributes size).
    anElement attributes do:
        [:oldAttr | attrs add: (Attr fromCincomAttribute: oldAttr)].


    contentHandler 
        startElement: localName 
        namespace: ns
        prefix: prefix
        attributes: attrs.

    anElement children do:
        [:child| child acceptVisitor:self].

    contentHandler 
        endElement: localName 
        namespace: ns
        prefix: prefix

    "Modified: / 30-05-2005 / 16:30:11 / masca"
    "Created: / 21-12-2005 / 17:22:37 / janfrog"
!

visitPI:aPI

    contentHandler processingInstruction:aPI name data:aPI text

    "Created: / 21-12-2005 / 17:22:37 / janfrog"
!

visitText:aText

    contentHandler characters: aText text

    "Created: / 21-12-2005 / 17:22:37 / janfrog"
! !

!CincomDOMXMLReader class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xmlreaderimpl/XMLv2__CincomDOMXMLReader.st,v 1.4 2006-12-12 13:53:47 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

