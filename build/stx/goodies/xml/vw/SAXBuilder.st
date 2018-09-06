"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

NodeBuilder subclass:#SAXBuilder
	instanceVariableNames:'attributes saxDriver hasPendingTag'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

SAXBuilder comment:'Author: Roger Whitney whitney@cs.sdsu.edu
Version: 1.0  
Date: 4/2/2000

ORSAXBuilder is a bridge between an VWXMLXMLParser and an VWXMLSAXDriver. It intercepts calls from the parser 
and sends the proper message to the SAXDriver. 

Implementation notes: The XML parser uses the builder in building a tree structure for a document.
The final tree structure is not used by ORSAXBuilder because the final tree does not contain the
processing instructions. So the ORSAXBuilder intercepts build calls to infer the document structure. 
It must cache attribute calls and the current tag as the Parser provides the separately, while the SAXDrvier
wants the tag will all the attributes in one call. The hard part of ths class is determing when we have all the attributes
for the current tag.

Instance Variables:
	attributes      <Collection>    builds up list of attribures for the current tag
	pendingTag      <VWXMLNodeTag>  The current we are collecting the attributes for. nil value indicates
											that we are between tags.
	saxDriver       <VWXMLSAXDriver> 
'
!


!SAXBuilder class methodsFor:'instance creation'!

driver: aVWXMLSAXDriver source: aStream 
	^super new initializeDriver: aVWXMLSAXDriver source: aStream
! !

!SAXBuilder methodsFor:'accessing'!

driver
	^saxDriver
!

pushTag: tag whileDoing: aBlock 
	"Starting a new tag. aBlock may call this method"

	| xmlElement |

	"if tag has no attributes, content is another tag, & method is now handling inner tag,
	  saxDrive needs to be informed of the start of the outer tag"
	hasPendingTag  ifTrue: [self notifyClientStartElement: tagStack last tag].
	hasPendingTag := true.
	xmlElement := super pushTag: tag whileDoing: aBlock.

	"if the tag does not have attributes or content, client has not been informed of 
	 the tag "
	hasPendingTag  ifTrue: [self notifyClientStartElement: xmlElement tag].
	self notifyClientEndElement: xmlElement tag.
	tagStack isEmpty ifTrue: [saxDriver endDocument].
	^xmlElement
! !

!SAXBuilder methodsFor:'building'!

attribute: name value: value
        "Accumulate all attributes for a single start tag"
        | anAttribute |
        anAttribute := super attribute: name value: value.
        attributes isNil ifTrue:[
            attributes := OrderedCollection new.
        ].
        attributes add: anAttribute.
        ^anAttribute
!

comment: text 
        "Handle the comment of a tag"
        hasPendingTag ifTrue: [self notifyClientStartElement: tagStack last tag].
        saxDriver comment: text.
        ^super comment: text
!

externalGeneralEntity: nameString id: arrayIDs ndata: ndata uri: anURI 
	| entity |
	entity := super 
				externalGeneralEntity: nameString
				id: arrayIDs
				ndata: ndata
				uri: anURI.
	saxDriver resolveEntity: entity.
	entity isParsed 
		ifFalse: 
			[saxDriver 
				unparsedEntity: entity name
				pubicID: entity publicID
				systemID: entity systemID].
	^entity
!

externalParameterEntity: nameString id: arrayIDs 
	| entity |
	entity := super externalParameterEntity: nameString id: arrayIDs. 
	saxDriver resolveEntity: entity.
	^entity
!

makeText: text 
	"Handle the text content of a tag"
	hasPendingTag ifTrue: [self notifyClientStartElement: tagStack last tag].
	self separateIgnorableWhitespaceAndText: text.
	^super makeText: text
!

notation: name value: val
	| notation |
	notation := super notation: name value: val.
	saxDriver 
		notation: notation name 
		publicID: notation publicID
		systemID: notation systemID.
	^ notation
!

pi: nm text: text 
	saxDriver processingInstruction: nm data: text.
	^super pi: nm text: text
! !

!SAXBuilder methodsFor:'initialization'!

initializeDriver: aVWXMLSAXDriver source: aStream 
        saxDriver := aVWXMLSAXDriver.
        saxDriver
                documentLocator: (SAXLocator on: aStream);
                startDocument.
        hasPendingTag := false.
        super initialize
! !

!SAXBuilder methodsFor:'private'!

char: aChar startsSkipableWhiteSpaceIn: aStream
	"used to determine if whitespace is skipable"
	aChar isSeparator ifFalse:[^false].
	aStream atEnd ifTrue:[^true]. 
	aChar ~= Character space ifTrue: [^true].
	^aStream peek isSeparator
!

collectTextIn: aStream 
        "collects text from current position upto ignorable whitespace "
        | text |

        text := CharacterWriteStream on:(String new:5).

        aStream do: 
                        [:char | 
                        (self char: char startsSkipableWhiteSpaceIn: aStream) 
                                ifTrue: 
                                        [aStream skip: -1.
                                        ^text contents].
                        text nextPut: char].
        ^text contents

    "Modified: / 03-11-2014 / 11:34:04 / sr"
    "Modified (format): / 04-11-2014 / 13:23:27 / sr"
!

collectWhitespaceIn: aStream
        "collects contigous whitespace from current position"
        | whitespace |        

        whitespace := CharacterWriteStream on:(String new:5).

        aStream do: [:char | 
                char isSeparator ifFalse:
                        [aStream skip: -1.
                        ^whitespace contents].
                whitespace nextPut: char].

        ^whitespace contents

    "Modified: / 03-11-2014 / 11:33:58 / sr"
    "Modified (format): / 04-11-2014 / 13:23:19 / sr"
!

notifyClientEndElement: currentTag

	saxDriver 
		endElement: currentTag type
		namespace: currentTag namespace
		prefix: currentTag qualifier.
	hasPendingTag := false
!

notifyClientStartElement: currentTag
        |passedAttributes|

        attributes isNil ifTrue:[
            passedAttributes := #().
        ] ifFalse:[
            passedAttributes := attributes.
            attributes := nil.
        ].

        saxDriver 
                startElement: currentTag type
                namespace: currentTag namespace
                prefix: currentTag qualifier
                attributes: passedAttributes.

        hasPendingTag := false
!

separateIgnorableWhitespaceAndText: aString 
	| allText whitespace text |
	allText := ReadStream on: aString.
	[allText atEnd] whileFalse: 
			[whitespace := self collectWhitespaceIn: allText.
			whitespace size > 0 ifTrue: [saxDriver ignorableWhitespace: whitespace].
			text := self collectTextIn: allText.
			text size > 0 ifTrue: [saxDriver characters: text]]
! !

!SAXBuilder methodsFor:'queries'!

isTreeBuilding
    "answer true, if our builder wants the XML parser to build
     a tree of elements.
     We do not need the tree, so answer false"

    ^ false
! !

!SAXBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXBuilder.st,v 1.8 2014-11-04 12:24:03 sr Exp $'
! !

