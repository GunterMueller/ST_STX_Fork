"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#PI
	instanceVariableNames:'name text'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

PI comment:'This class represents the XML Processing Instruction element. Processing instructions allow XML documents to contain instructions for applications. The ''name'' instance variable represents the target of this processing instruction and is used to identify the application to which this processing instruction is directed.

 XML processing instructions are delimited by the start-tag ''<?'' and the end-tag ''?>''. 

According to the XML 1.0 specification, the target names "XML", "xml" and so on are reserved for standardization


Instance Variables:
	name    <XML.NodeTag>   the target of this processing instruction, used to identify the application to which this processing instruction is directed.
	text            <String>                        the processing instructions themselves'
!


!PI class methodsFor:'instance creation'!

name: nm text: aString

	^self new name: nm text: aString
! !

!PI methodsFor:'accessing'!

name

	^name
!

text
	^text
!

xPath
    ^ parent xPath
!

xpathStringData
    ^self text
! !

!PI methodsFor:'comparing'!

= anXmlPI
    ^ anXmlPI isProcessingInstruction 
        and:[name = anXmlPI name
        and:[text = anXmlPI text]].
!

hash
    ^ name hash
! !

!PI methodsFor:'initialization'!

name: nm text: aString

	name := nm.
	text := aString
! !

!PI methodsFor:'printing'!

prettyPrintOn: aStream depth: indent

        aStream nextPutAll: '<?', name, ' ', text, '?>'
!

printCanonicalOn: aStream

	aStream nextPutAll: '<?', name, ' ', text, '?>'
!

printHTMLOn: aStream

	aStream nextPutAll: '<?', name, ' ', text, '?>'
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock

	aStream nextPutAll: '<?', name, ' ', text, '?>'
!

printOn: aStream

        aStream nextPutAll: '<?', name, ' ', text, '?>'
! !

!PI methodsFor:'testing'!

isLike: aNode

	^self class == aNode class
		and: [self name isLike: aNode name]
!

isProcessingInstruction

	^true
! !

!PI methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitPI:self
! !

!PI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/PI.st,v 1.11 2013-07-03 07:04:27 stefan Exp $'
! !

