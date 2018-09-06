"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

SAXDriver subclass:#DOM_SAXDriver
	instanceVariableNames:'stack document'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

DOM_SAXDriver comment:'This class represents a specialized type of SAX (Simple API for XML) processor that follows the ''object model'' for processing XML documents to build a Document Object Model (DOM) tree from the processed XML document.

Note: This class implementation is not yet complete

Instance Variables:
	stack   <OrderedCollection>
	document        <XML.Document>
'
!


!DOM_SAXDriver methodsFor:'characters'!

characters: aString

	stack last addNode: (Text text: aString)
! !

!DOM_SAXDriver methodsFor:'document events'!

document

	^document
!

endDocument

        document := stack removeLast.
        document isDocument ifFalse: [XML::MalformedSignal raiseErrorString:' - End of Document not expected'].
        stack isEmpty ifFalse: [XML::MalformedSignal raiseErrorString:' - End of Document not expected'].
!

endDocumentFragment

        document := stack removeLast.
        document isDocument ifFalse: [XML::MalformedSignal raiseErrorString:' - End of Document not expected'].
        stack isEmpty ifFalse: [XML::MalformedSignal raiseErrorString:' - End of Document not expected'].
!

startDocument

	stack := OrderedCollection with: Document new
!

startDocumentFragment

	stack := OrderedCollection with: Document new
! !

!DOM_SAXDriver methodsFor:'elements'!

endElement: localName namespace: nameSpace prefix: nameSpacePrefix

	stack size = 0 ifTrue: [^self].
	stack removeLast condenseList
!

startElement: localName namespace: nameSpace prefix: nameSpacePrefix attributes: atts 
	| elm |
	stack size = 0 ifTrue: [^self].
	elm := self createElement: localName attributes: atts.
	stack last addNode: elm.
	stack addLast: elm
! !

!DOM_SAXDriver methodsFor:'other'!

comment: data

	stack last addNode: (Comment new text: data)
!

processingInstruction: target data: data

	stack last addNode: (PI new name: target text: data)
! !

!DOM_SAXDriver methodsFor:'private'!

createElement: name attributes: attr

	^Element tag: name attributes: attr elements: OrderedCollection new
! !

!DOM_SAXDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/DOM_SAXDriver.st,v 1.7 2005-02-23 09:23:30 stefan Exp $'


! !
