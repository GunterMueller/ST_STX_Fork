"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#Schema
	instanceVariableNames:'rootPattern defines readTimestamp rootSource sources'
	classVariableNames:'SchemaSearchPath'
	poolDictionaries:''
	category:'Relax NG'
!


!Schema class methodsFor:'instance creation'!

fromFile:aStringOrFilename

    ^self fromURI:(URI fromString:'file://',aStringOrFilename asString)

    "Created: / 30-04-2005 / 14:57:19 / janfrog"
    "Modified: / 07-06-2005 / 15:27:22 / masca"
!

fromStream:aStream

    ^(SchemaParser schemaFromStream:aStream)

    "Modified: / 03-05-2005 / 11:13:40 / janfrog"
!

fromURI:anURI


    ^ SchemaParser schemaFromURI:anURI

    "Created: / 30-04-2005 / 14:57:19 / janfrog"
    "Modified: / 07-06-2005 / 15:26:40 / masca"
!

new
    ^ self basicNew initialize.

    "Created: / 02-05-2005 / 13:36:36 / janfrog"
! !

!Schema class methodsFor:'accessing'!

schemaSearchPath
    SchemaSearchPath ifNil:[ SchemaSearchPath := OrderedCollection new ].
    ^ SchemaSearchPath

    "Created: / 12-05-2005 / 11:03:32 / masca"
!

schemaSearchPath:sCollection
    SchemaSearchPath  := sCollection asOrderedCollection

    "Created: / 22-06-2005 / 15:07:43 / masca"
! !

!Schema class methodsFor:'utilities'!

findFileWithName:href 
    |file|

    href asFilename exists ifTrue:[
        file := href
    ] ifFalse:[
        Schema schemaSearchPath 
            detect:[:dir |(file := (dir asFilename construct:href) asFilename) exists ]
            ifNone:[
                SchemaParsingError 
                    raiseErrorString:'Cannot found file to be included: ' , href 
                            , '. Check schema search dir'
            ]
    ].
    ^ file

    "Created: / 12-05-2005 / 10:42:24 / masca"
    "Modified: / 07-06-2005 / 10:54:37 / masca"
! !

!Schema methodsFor:'accessing'!

defaultDataTypeLibrary

    ^DataTypeLibrary xs

    "Created: / 30-04-2005 / 17:32:54 / janfrog"
!

rootPattern
    rootPattern ifNil:[
        rootPattern := (PatternNode for:ComplexTypePattern new) pattern.
        rootPattern name:'###rootpattern###'.
    ].
    ^ rootPattern

    "Created: / 01-05-2005 / 15:59:46 / janfrog"
    "Modified: / 14-05-2005 / 18:16:57 / janfrog"
! !

!Schema methodsFor:'defines'!

define:aString as:aContentModelNode

    defines at:aString put:aContentModelNode

    "Created: / 02-05-2005 / 13:47:27 / janfrog"
!

defineFor:aString

    ^defines at:aString ifAbsent:[nil]

    "Created: / 02-05-2005 / 13:53:24 / janfrog"
! !

!Schema methodsFor:'initialization'!

finishLoading

    readTimestamp := Timestamp now

    "Created: / 07-06-2005 / 11:07:03 / masca"
!

initialize

    defines := Dictionary new.
    sources := Set new.

    "Created: / 02-05-2005 / 13:37:03 / janfrog"
    "Modified: / 07-06-2005 / 11:32:40 / masca"
!

reload

    ^self class fromURI:rootSource.

    "Created: / 07-06-2005 / 12:15:43 / masca"
!

resolveReferencesFrom:refs 

    refs do:[:ref | 
        |node|
        node := self defineFor:ref name.
        node ifNil:[
                SchemaParsingError 
                    raiseErrorString:'Unresolved reference to: ' , ref name
            ] ifNotNil:[|copy|
                copy := node copy.
                ref referencedNode:copy
            ]
    ].

    "Created: / 07-06-2005 / 11:04:28 / masca"
! !

!Schema methodsFor:'instance creation'!

fromStream:aStream

    ^Schema := (SchemaParser schemaFromStream:aStream)

    "Created: / 03-05-2005 / 11:11:56 / janfrog"
! !

!Schema methodsFor:'operations'!

serialize:anObject toFile:aStringOrFilename

    self serialize:anObject toFile:aStringOrFilename idMappingsTo:nil

    "Created: / 06-05-2005 / 10:53:06 / janfrog"
    "Modified: / 30-05-2005 / 15:31:25 / masca"
!

serialize:anObject toFile:aStringOrFilename idMappingsTo:aDictionary

    | stream |
    [        
        stream := aStringOrFilename asFilename writeStream.
        self serialize:anObject toStream:stream idMappingsTo:aDictionary.
    ] ensure:[            
        stream close.
    ]

    "Created: / 30-05-2005 / 15:31:09 / masca"
!

serialize:anObject toStream:aStream

    ^self serialize:anObject toStream:aStream idMappingsTo:nil.

    "Created: / 26-05-2005 / 13:35:36 / masca"
    "Modified: / 30-05-2005 / 15:30:28 / masca"
!

serialize:anObject toStream:aStream idMappingsTo:aDictionary

    | dom |
    dom := self serializeToDOM:anObject idMappingsTo:aDictionary.
    XMLv2::OldXMLWriter write:dom on:aStream.

    "Created: / 30-05-2005 / 15:29:53 / masca"
    "Modified: / 25-10-2005 / 15:36:58 / janfrog"
!

serializeToDOM:anObject

    ^self serializeToDOM:anObject idMappingsTo:nil.

    "Created: / 02-05-2005 / 16:47:40 / janfrog"
    "Modified: / 30-05-2005 / 15:29:29 / masca"
!

serializeToDOM:anObject idMappingsTo:aDictionary

    | serializator document |
    serializator := Serializator for:self.
    document := serializator serialize:anObject.
    aDictionary ifNotNil:[
        serializator idMapping associationsDo:[:assoc|
            aDictionary at:assoc value put:assoc key
        ]
    ].
    ^document

    "Created: / 30-05-2005 / 15:29:00 / masca"
!

validateAndBindDOM:aDocument

    ^self validateDOM:aDocument usingValidator:(Binder for:self)

    "Created: / 15-05-2005 / 12:50:10 / janfrog"
!

validateAndBindFile:aStringOrFilename

    ^self validateAndBindStream:aStringOrFilename asFilename readStream

    "Created: / 02-05-2005 / 14:56:23 / janfrog"
!

validateAndBindStream:aStream

    ^self validateStream:aStream usingValidator:(Binder for:self)

    "Created: / 02-05-2005 / 14:56:11 / janfrog"
    "Modified: / 14-05-2005 / 11:06:14 / janfrog"
!

validateDOM:aDocument

    ^self validateDOM:aDocument usingValidator:(Validator for:self)

    "Created: / 15-05-2005 / 12:49:51 / janfrog"
!

validateDOM:aDocument usingValidator:validator

    [
        XMLv2::DOMXMLReader new
            setContentHandler:validator;
            parseDocument:aDocument
    ] on:RNG::Error do:[:ex|
        ex  
            "errorLine:validator getCurrentLine;
            errorCol:validator getCurrentColumn;"
            pass.
    ].
    ^validator result.

    "Created: / 15-05-2005 / 12:49:01 / janfrog"
!

validateFile:aStringOrFilename

    ^self validateStream:aStringOrFilename asFilename readStream

    "Created: / 01-05-2005 / 15:52:23 / janfrog"
!

validateStream:aStream

    ^self validateStream:aStream usingValidator:(Validator for:self)

    "Modified: / 14-05-2005 / 11:05:55 / janfrog"
!

validateStream:stream usingValidator:validator

    [
        XMLv2::XMLReader new
            setContentHandler:validator;
            parseInputSource:(XMLv2::InputSource onStream:stream)
    ] on:RNG::Error do:[:ex|
        validator getDocumentLocator notNil
            ifTrue:[
                ex  
                    errorLine:validator getDocumentLocator getLineNumber;
                    errorCol:validator getDocumentLocator getColumnNumber.
            ].
        ex pass.

    ].
    ^validator result.

    "Created: / 14-05-2005 / 11:04:45 / janfrog"
    "Modified: / 19-05-2005 / 09:45:42 / masca"
    "Modified: / 04-08-2005 / 10:55:37 / janfrog"
! !

!Schema methodsFor:'queries'!

anySourceModified

    ^sources anySatisfy:[:sourceURI|
        sourceURI isRemote or:[
            (sourceURI path asFilename modificationTime) > readTimestamp
        ]
    ]

    "Created: / 07-06-2005 / 12:15:21 / masca"
! !

!Schema methodsFor:'schema source'!

addSource:anURI

    (sources includes:anURI)
        ifTrue:[CircularSchemaInclusion 
                    raiseErrorString:'circular inclusion - '
                        , anURI asString 
                            , ' already included'
        ] ifFalse:[
            sources add:anURI
        ]

    "Created: / 07-06-2005 / 11:32:08 / masca"
!

rootSource:anURI

    sources add:(rootSource := anURI).

    "Created: / 07-06-2005 / 11:32:30 / masca"
! !

!Schema class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Schema.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !
