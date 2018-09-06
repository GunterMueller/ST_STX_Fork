"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#Parser
	instanceVariableNames:'stream reader domImplementation'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Parser'
!


!Parser class methodsFor:'instance creation'!

forDOM1

    ^self withDOMFeatures:'XML 1.0'

    "Created: / 04-08-2005 / 13:36:05 / janfrog"
!

forDOM3

    ^self withDOMFeatures:'XML 3.0'

    "Created: / 04-08-2005 / 13:36:01 / janfrog"
!

forXSLTFO

    ^self withDOMFeatures:'XML 3.0 XSLT-FO 1.0'

    "Created: / 07-04-2007 / 14:51:29 / janfrog"
!

new
    ^self withDOMFeatures:'XML 1.0'

    "Modified: / 04-08-2005 / 12:47:38 / janfrog"
!

withDOMFeatures:featureString

    ^self basicNew initializeWithFeatures:featureString

    "Created: / 04-08-2005 / 12:47:23 / janfrog"
! !

!Parser methodsFor:'initialization'!

initializeWithFeatures:featureString

    domImplementation := 
        DOMImplementationRegistry 
            getDOMImplementation:featureString.
    domImplementation ifNil:[
        DOMException raiseErrorString:'No implementation found'
    ].
    reader := XMLReader new.

    "Created: / 04-08-2005 / 12:50:05 / janfrog"
!

on:aStream

    stream := aStream binary

    "Created: / 23-04-2005 / 12:33:06 / janfrog"
! !

!Parser methodsFor:'settings'!

isEncodeChecking:aBoolean

    "Created: / 23-04-2005 / 13:04:19 / janfrog"
!

validate:aBoolean

    "Created: / 23-04-2005 / 13:03:58 / janfrog"
! !

!Parser methodsFor:'utilities - parsing'!

ensureStreamIsBinary


    stream isBinary ifFalse:
        [stream isExternalStream
            ifTrue:
                [stream binary]
            ifFalse:
                [stream := stream collection asByteArray readStream]]

    "Created: / 02-10-2006 / 17:32:27 / janfrog"
    "Modified: / 06-10-2006 / 09:42:08 / janfrog"
!

parse: aString

    ^self processDocumentString: aString beforeScanDo: [:p | p isEncodeChecking: false. p validate: false.]

    "Modified: / 23-04-2005 / 13:03:31 / janfrog"
!

processDocumentInFilename: aFilename 

	^self processDocumentInFilename: aFilename beforeScanDo: [:parser | ]

    "Created: / 23-04-2005 / 13:02:46 / janfrog"
!

processDocumentInFilename: aFilename beforeScanDo: aBlock

        | str |
        str := (aFilename asFilename withEncoding: #UTF_8) readStream.
        ^self processDocumentInStream: str beforeScanDo: aBlock

    "Created: / 23-04-2005 / 13:02:46 / janfrog"
    "Modified: / 11-11-2006 / 10:01:26 / janfrog"
!

processDocumentInStream: aStream 

        ^self processDocumentInStream: aStream beforeScanDo: [:parser | ]

    "Created: / 11-11-2006 / 10:00:40 / janfrog"
!

processDocumentInStream: aStream beforeScanDo: aBlock

        | p |
        stream := aStream.
        stream lineEndTransparent.
        p := self on: stream.
        aBlock value: p.
        ^p scanDocument

    "Created: / 11-11-2006 / 10:00:45 / janfrog"
!

processDocumentString: aString

	^self processDocumentString: aString beforeScanDo: [:parser | ]

    "Created: / 23-04-2005 / 13:02:46 / janfrog"
!

processDocumentString: aString beforeScanDo: aBlock

        | p  |
        p := self on: aString "asByteArray" readStream.
        aBlock value: p.
        ^p scanDocument

    "Created: / 23-04-2005 / 13:02:46 / janfrog"
    "Modified: / 15-05-2005 / 20:49:38 / janfrog"
    "Modified: / 18-05-2005 / 10:57:19 / masca"
!

scanDocument
    "Returns parsed document, i.e. it's Document node"

    | contentHandler |

    stream ifNil:[ParseError raiseErrorString:'No stream'. ^nil].
    self ensureStreamIsBinary.
    contentHandler := domImplementation saxContentHandler.
    reader setContentHandler:contentHandler.
    [
        reader parseInputSource:(XMLv2::InputSource onStream:stream)
    ] on: SAXError do:[:ex|
        ParseError raiseErrorString:ex errorString.
        ^nil.
    ].
    ^contentHandler document

    "Created: / 23-04-2005 / 12:39:18 / janfrog"
    "Modified: / 06-10-2006 / 09:42:08 / janfrog"
! !

!Parser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Parser.st,v 1.7 2007-04-10 08:33:15 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
