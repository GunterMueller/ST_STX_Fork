"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#SAXDriver
	instanceVariableNames:'locator'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

SAXDriver comment:'All methods in this class were modified from the orginal Cincom''s class by Roger Whitney whitney@cs.sdsu.edu. 4/2/2000

This class includes supports for the Simple API for XML 2.0 (SAX), an event-driven API for parsing XML documents.
See http://www.megginson.com/SAX/SAX2/ for the Java API defining SAX. The XML 1.0 spec (http://www.w3.org/TR/REC-xml) will also be useful. 

This class is a Smalltalk implementation of the SAX DefaultHandler class. It implemets the SAX interfaces: ContentHandler, DTDHandler, EntityHandler and ErrorHandler, with three exceptions. See below.

To use this class you must create a subclass, and override any method of interest. Nearly all the methods in
this class are empty. Instance creation methods are the same as VWXMLXMLParser. See OXSAXIndenter for an example. Implementation note: All creation methods in the class must eventually call on:beforeScanDo: for the SAX error handling to work.

Instance Variables:
	locator <OXSAXLocator> maintains location of the parser in current XML document

The three methods in the SAX DefaultHandler definition not implemented here are:
ContentHandler>>endPrefixMapping
ContentHandler>>startPrefixMapping
	The parser keeps track of the namespaces, all tags and attributes are passed to theSAX application 
	with namespace information. Hence these methods seemed redundent.

ContentHandler>>skippedEntity
	When the parser is in validating mode is does not skip entities. I could not find were the parser 
	skips entities when in non-validiating mode to implement this method
'
!


!SAXDriver class methodsFor:'initialization'!

initialize

    "load classes I depend on, if not already loaded.
     this loads also MalformedSignal"

    InvalidSignal autoload
! !

!SAXDriver class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

on: aStream 
        ^self on: aStream beforeScanDo: [:parser | ]

    "
     XML::DOM_SAXDriver on:YAXO::XMLTokenizer addressBookXMLWithDTD readStream beforeScanDo: [:parser | parser validate:false ].
     XML::DOM_SAXDriver on:YAXO::XMLTokenizer addressBookXML readStream beforeScanDo: [:parser | parser validate:false ].
    "
!

on: aStream beforeScanDo: aBlock 
        "aBlock: [:aParser | code]. use to send message to the parser before it parses the stream"

        |parser saxBuilder saxDriver handler|

        saxDriver := self new.
        saxBuilder := SAXBuilder driver: saxDriver source: aStream.
        parser := XMLParser new
                     builder:saxBuilder;
                     on: aStream.

        "catch xml signals and sent them to the SAXDriver.
         The SAXDrivers default is to reject these exceptions"

        Smalltalk isSmalltalkX ifTrue:[
            handler := ExceptionHandlerSet new
                       "/ on:WarningSignal   handle:[:signal | saxDriver warning: signal];
                       on:InvalidSignal   handle:[:invalid | saxDriver error: invalid];
                       on:MalformedSignal handle:[:error | saxDriver fatalError: error].
        ] ifFalse:[
            handler := ExceptionHandlerSet new
                       on:WarningSignal   handle:[:signal | saxDriver warning: signal];
                       on:InvalidSignal   handle:[:invalid | saxDriver error: invalid];
                       on:MalformedSignal handle:[:error | saxDriver fatalError: error].
        ].

        [
            aBlock value:parser.
            parser scanDocument
        ] valueWithExceptionHandler:handler.
        ^ saxDriver
!

processDocumentInFilename: aFilename 

	^self processDocumentInFilename: aFilename beforeScanDo: [:parser | ]
!

processDocumentInFilename: aFilename beforeScanDo: aBlock
	"aBlock: [:aParser | code]. use to send message to the parser before it parses the document"
	| stream |
	stream := (aFilename asFilename withEncoding: #UTF_8) readStream.
	stream lineEndTransparent.
	^self on: stream beforeScanDo: aBlock
!

processDocumentString: aString

	^self processDocumentString: aString beforeScanDo: [:parser | ]
!

processDocumentString: aString beforeScanDo: aBlock
	"aBlock: [:aParser | code]. use to send message to the parser before it parses the string"
	^self on: aString readStream beforeScanDo: aBlock
! !

!SAXDriver methodsFor:'content handler'!

characters: aString

	"This method is used report character data of an entity.
	Character data with ignorable whitespace of a single entity is divided into parts. Each
	part is reported by its own call to this method. The ignorableWhitespace method is sent
	called between calls to this method. All white space separating parts of the text is passed
	to the ignorableWhitespace method.
	aString does not have any leading or trailing white space. "
!

characters: aString from: start to: stop
    "cg: added for twoFlower compatibility with newer XMLParser framework"

    ^self characters: (aString copyFrom: start to: stop)
!

comment: aString

        "Receive notification of comment in element content. 

      Parameters:
            aString - the comment"
!

documentLocator: anORSAXLocator
	"There is no need to override this method"

	locator := anORSAXLocator.
!

endDocument
	"Indicates that the parser has finished the document"
!

endElement: localName namespace: nameSpace prefix: nameSpacePrefix
	"indicates the end of an element. See startElement"
!

ignorableWhitespace: aString

	"Receive notification of ignorable whitespace in element content. 

	ignorable white space is any contiguous occurance of 2 or more white space characters
	(space, cr, tab, line feed, null , or form feed) or any white space character except space.
    
	All contiguous whitespace is sent in one call to this method.

      Parameters:
	    aString - the white space"
!

processingInstruction: targetString data: dataString
!

startDocument
	"Indicates the start of a document"
!

startElement: localName namespace: namespace prefix: nameSpacePrefix attributes: attributes

	"Receive notification of the beginning of an element. 

      Parameters:
	    localName <String> - The local name of the element(without prefix)
	    namespace <String> The Namespace URI, Nil if the element has no Namespace URI
	    prefix <String> Prefix of the tag name used to indicate a namespace. Nil if absent
	    attributes <OrderedCollection of Attribute (XML::Attribute)> The attributes attached to the element.

	Example (note two single quotes were used instead of a double quote char)
		<doc xmlns=''http://www.doc.org/'' xmlns:other=''http://www.other.com/''>
			<a>A text</a>
			<other:b>BA text</other:b>
			<c other:cat=''meow''>C text</c>
			<d xmlns=''http:/nested/''></d>
		</doc>

	Parameter values to this method for each element of the above XML:

	local name: 'doc'       namespace: 'http://www.doc.org/'        prefix: ''
	local name: 'a'         namespace: 'http://www.doc.org/'        prefix: ''
	local name: 'b'         namespace: 'http://www.other.com/'      prefix: 'other'
	local name: 'c'         namespace: 'http://www.doc.org/'        prefix: ''
	local name: 'd'         namespace: 'http:/nested/'      prefix: ''

	Note the attribute object also have namespaces
"
! !

!SAXDriver methodsFor:'dtd handler'!

notation: nameString publicID: publicIDString systemID: systemIDString
	"Receive notification of a notation declaration event. 

      It is up to the application to record the notation for later reference, if necessary.

      If a system identifier is present, and it is a URL, the SAX parser must resolve it fully before passing
      it to the application. (I do not know if the parser does resolve the URL. REW)"
!

unparsedEntity: nameString pubicID: publicIDString systemID: systemIDString
	"Note SAX 2.0 documentation also has notation name for the entity. 
	 Does not seem to be available from parser, and should be the same as nameString

	An unparsed entity is an external entity with ndata. See section 4.2.2 of the XML 1.0 spec"
! !

!SAXDriver methodsFor:'entity resolver'!

resolveEntity: anEntityNode
	"Called when the parser can not resolve an external entity. 
	 Currently the parser only resolves external entities that refer to files.

	 anEntityNode is an instance of GeneralEntity (XML::GeneralEntity)

	Set the text for the entity (anEntityNode text: aString) so the compiler can 
	expand all references in the XML document to the entity. 

	Use the methods  publicID and systemID to get the nodes IDs to determine how
	to resolve the entity.  

	Currently there is no support for obtaining the location of the document source from the 
	parser to resolve relative references. "
! !

!SAXDriver methodsFor:'error handler'!

error: anInvalidExceptionOrString
    "Called when a validating is on and parser reaches invalid XML. Is resumable.
     Subclasses may catch these exceptions.

     It may also be called, if one of our subclasses' methods sends error:aString"

    anInvalidExceptionOrString isException ifTrue:[
        anInvalidExceptionOrString reject.
    ].
    
    "normal beavior inherited from Object"
    ^ super error: anInvalidExceptionOrString
!

fatalError:aMalformedException 
    "The XML parsers malformed signal is sent to this method.
     Subclasses may redefine this method and catch these errors.
     The error is rejected by default."
    
    aMalformedException reject.
!

warning: aWarningException
    "in Smalltalk/X, this is never used.
     Maybe this will sometimes be used, to catch warnings while doing SAX building"

    "unhandled Warnings will proceed..."
    aWarningException reject
! !

!SAXDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXDriver.st,v 1.16 2013-04-11 08:36:34 stefan Exp $'


!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXDriver.st,v 1.16 2013-04-11 08:36:34 stefan Exp $'
! !


SAXDriver initialize!
