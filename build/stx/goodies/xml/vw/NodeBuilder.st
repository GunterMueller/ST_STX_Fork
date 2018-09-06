"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLNodeBuilder subclass:#NodeBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

NodeBuilder comment:'This class along with it''s superclass XMLNodeBuilder is used by the XMLParser to distill an XML document into it''s component elements. This NodeBuilder class in particular is used to create instances of the various XML elements that are included in the scanned-in XML document or document string.'
!


!NodeBuilder methodsFor:'building'!

attribute: name value: value

	^Attribute name: name value: value
!

comment: aText

	^Comment new text: aText
!

makeText: text

	^Text text: text
!

notation: name value: val

	^Notation new name: name identifiers: val
!

pi: nm text: text

	^PI new name: nm text: text
!

tag: tag attributes: attributes elements: elements position: p stream: stream

	^Element tag: tag attributes: attributes elements: elements
! !

!NodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NodeBuilder.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
