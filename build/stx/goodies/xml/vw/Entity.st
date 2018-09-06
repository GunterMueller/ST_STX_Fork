"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Entity
	instanceVariableNames:'name text systemID publicID'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Entity comment:'An XML document may consist of one or many storage units called entities. All XML entities have content and are idententified by name. 

Entities may be either parsed or unparsed. This class and it''s subclasses GeneralEntity and ParameterEntity represent parsed entities. These entities are invoked by name using entity references and their contents are held in the text instance variable

Entities may also be internal or external. If the content of the entity is given in the declaration (within the document) itself then the entity is called an internal entity. If the entity is not internal to the document and is declared elsewhere it''s called an external entity. 

External entities have a system identifier (systemID instance variable) that is an URI which may be used to retrieve the entity. In addition to a system identifier, an external entity declaration may include a public identifier (publicID instance variable). The XMLParser may use the publicID to try to generate an alternative URI to retrive the entity''s contents.

Subclasses must implement the following messages:
	accessing
		entityType

Instance Variables:
	name    <XML.NodeTag>  
				Identifies the entity in an entity referece
	text    <String>
				The entity''s contents
	systemID        <String | XML.URIResolver>
				URI used to retrieve an external entity''s contents
	publicID        <String | XML.URIResolver>
				name which (theoretically) could be looked up in a catalog to generate a URI. If catalogs are supported, this should be used in preference to the systemID.
'
!


!Entity methodsFor:'accessing'!

entityType

	^self subclassResponsibility
!

externalFrom: anArray

	anArray class == Array
		ifFalse: [self error: 'External ID is expected to be an Array'].
	anArray size = 1
		ifTrue: [systemID := anArray at: 1]
		ifFalse: [anArray size = 2
			ifTrue:
				[publicID := anArray at: 1.
				systemID := anArray at: 2]
			ifFalse:
				[self error: 'External ID has too many or too few identifiers']]
!

name

	^name
!

name: aName

	name := aName
!

publicID
	"Needed for SAX, REW"
	^publicID
!

streamFor: aParser

        (aParser hasExpanded: self)
                ifTrue: [aParser malformed: 'Can''t expand this entity; it is defined recursively'].
        text == nil
                ifTrue:
                        [| uri str uriResolver|
                        uriResolver := aParser uriResolver.
                        uri := uriResolver resolve: systemID from: aParser latestURI.
                        aParser pushSource: (str := StreamWrapper
                                                                stream: (uriResolver openStreamOn: uri)
                                                                protocol: uri key
                                                                name: uri value
                                                                entity: self).
                        str textDeclIn: aParser.
                        aParser getNextChar]
                ifFalse:
                        [aParser pushSource: (StreamWrapper
                                                                stream: text readStream
                                                                protocol: 'internal'
                                                                name: nil
                                                                entity: self).
                        aParser getNextChar].
!

systemID
	"Needed for SAX, REW"
	^systemID
!

text: aString

	text := aString
! !

!Entity methodsFor:'comparing'!

= anXmlEntity
    ^ anXmlEntity isEntity
        and:[self entityType = anXmlEntity entityType
        and:[name = anXmlEntity name
        and:[text = anXmlEntity text
        and:[systemID = anXmlEntity systemID
        and:[publicID = anXmlEntity publicID]]]]]
!

hash
    ^ name hash
! !

!Entity methodsFor:'printing'!

printOn: aStream

	self basicPrintOn: aStream.
	text == nil
		ifTrue: [aStream nextPutAll: '(',systemID,')']
		ifFalse: [aStream nextPutAll: '(',text,')']
! !

!Entity methodsFor:'testing'!

isEntity
    ^ true
!

isExternal

	^publicID notNil or: [systemID notNil]
!

isParsed

	^true
! !

!Entity methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitEntity:self
! !

!Entity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Entity.st,v 1.10 2013-07-03 07:04:19 stefan Exp $'
! !

