"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

SAXDriver subclass:#SAXIndenter
	instanceVariableNames:'document elementText indentLevel'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

SAXIndenter comment:'Class Author: Roger Whitney whitney@cs.sdsu.edu
Version 1.0
April 1, 2000

OXSAXIndenter is simple example of using the VWXMLSAXDriver (XML.SAXDriver). Text of the tags is stored in a document. The indentation level of the text is nesting level of the tag. So <a>Hi<b>Mom</b>Bye</a> results in:

Hi
	Mom
Bye

Text in a element (PCDATA) may be reported to a SAX client in multiple calls to the method characters:. Thus one has to collect the text over these calls. This is tricky as the text for one tag could occur on both sides of a nested tag as in: <a>Hi<b>Mom</b>Bye</a>. In this case we want the orginal order of the text. This requires that the method OXSAXIndenter>saveText be called from multiple locations. 

See class methods for examples of use.

Instance Variables:
	document <WriteStream> document being produced
	elementText  <WriteStream> text of the current tag
	indentLevel <Integer>   How far to indent the text'
!


!SAXIndenter class methodsFor:'examples'!

example1
	"SAXIndenter example1"

	| indenter |
	indenter := SAXIndenter processDocumentString: (SAXIndenter simpleXMLDocument ) 
			beforeScanDo:[:parser | parser validate: false.].
	^indenter document.
!

example2
	"SAXIndenter example2"

	| indenter |
	indenter := SAXIndenter processDocumentString: (SAXIndenter simpleXMLDocumentWithDTD ) 
			beforeScanDo:[:parser | parser validate: true.].
	^indenter document.
!

invalidXMLDocument
	^'
<a> This 
is        an           outline
	<b>Second
</a>
'
!

simpleXMLDocument
	^'
<a>        This 
is        an           outline
	<b>Second</b> Me
	<b>Third</b>
	<b>Fourth
		<c>Inner</c>
	</b>
	<b>Ending soon</b>
Careful
</a>
'
!

simpleXMLDocumentWithDTD
	^'
<!!DOCTYPE a [
<!!ELEMENT a (#PCDATA | b)* >
<!!ELEMENT b (#PCDATA | c)*>
<!!ELEMENT c (#PCDATA)>
]><a> This is an outline
	<b>Second</b>
Me
	<b>Third</b>
	<b>Fourth
		<c>Inner</c>
	</b>
	<b>Ending soon</b>
Careful
</a>
'
! !

!SAXIndenter methodsFor:'accessing'!

document
	^document contents
! !

!SAXIndenter methodsFor:'content handler'!

characters: aString
	"If an element's text contains ignorable whitespace than we will
	 receive multiple calls to this method for that text."

	elementText 
		nextPutAll: aString;
		nextPut: Character space.
!

endDocument
	"self saveText"
!

endElement: localName namespace: nameSpace prefix: nameSpacePrefix 
	indentLevel := indentLevel - 1.
	self saveText
!

startDocument
	document := WriteStream on: (String new:30).
	indentLevel := -1.
	elementText := WriteStream on: (String new: 10)
!

startElement: localName namespace: namespace prefix: nameSpacePrefix attributes: attributes
	indentLevel := indentLevel + 1.

	"Prevoius element's text may not be saved yet"
	self saveText. 
	indentLevel timesRepeat:[elementText nextPut: Character tab].
! !

!SAXIndenter methodsFor:'private'!

saveText

	elementText isEmpty 
		ifFalse: 
			[document
				nextPutAll: elementText contents;
				nextPut: Character cr].
	elementText := WriteStream on: (String new: 10)
! !

!SAXIndenter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXIndenter.st,v 1.3 2003-04-23 08:44:17 cg Exp $'
! !
