"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1999 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/xml/stx' }"

"{ NameSpace: Smalltalk }"

ObjectCoder subclass:#XMLCoder
	instanceVariableNames:'version maxLevel prettyPrint level objectToIdMapping
		lastIsElement'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-Presentation'
!

!XMLCoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



!

documentation
"
    Outputs Objects in XML format to a stream

    [author:]
        Stefan Vogel

    [see also:]

    [instance variables:]
        level (Integer)         Level do descent into the object tree
        indent (Integer)        Current indent depth for pretty-printing
        aspect (Object)         Aspect to be coded

    [class variables:]
"
!

examples
"
    Usually you implement your XML coding as a visitor (see XMLStandardCoder).
    But you can as well encode something manually:


								   [exBegin]
    |coder|

    String streamContents:[:stream |
	coder := XMLCoder on:stream.
	coder prettyPrint:true.

	coder putElement:'TOP'
	      attributes:nil
	      contents:[:coder|
		  coder putElement:'FIRST'
			attributes:(Dictionary withKeysAndValues:#(att1 val1 att2 nil att3 'complex value :<&>'))
			contents:[:coder| coder quoteString:'hello world'].
		  coder putElement:'SECOND'
			attributes:(Dictionary withKeysAndValues:#(s1 val1 s2 nil s3 val3))
			contents:[:coder| coder quoteString:'second element'].
	      ]
    ].
									[exEnd]
"
! !

!XMLCoder class methodsFor:'instance creation'!

new

    ^ self basicNew initialize
! !

!XMLCoder methodsFor:'accessing'!

level
    "answer the current nesting level in the object/xml tree"

    ^ level
!

level:something

    level := something.
!

prettyPrint
    ^ prettyPrint
!

prettyPrint:something
    "set to true, to enable prettyPrinting (indentation) of XML text"

    prettyPrint := something.
!

version
    "return the value of the instance variable 'version' (automatically generated)"

    ^ version
! !

!XMLCoder methodsFor:'blocked'!

next
    ^ self shouldNotImplement
! !

!XMLCoder methodsFor:'helpers'!

indent
    "indent line, if prettyPrinting is enabled"

    prettyPrint ifTrue:[
       stream spaces:level*2
    ]
!

nextObject
    "this is sent, when an object has been encoded"

    stream cr.
!

putObject:anObject element:elementName name:nameOrIndex class:className value:aBlock
    "write anObject to the encoder.
     It is named nameOrIndex. Evaluate aBlock to encode its contents"

    |oldId id size|

    self indent.
    stream nextPut:$<; nextPutAll:elementName.
    level == 0 ifTrue:[
        "first element, output aspect and version if set"
        aspect size ~~ 0 ifTrue:[
            self putAttribute:'ASPECT' with:aspect.
        ].
        (version size ~~ 0 or:[version isNumber]) ifTrue:[
            self putAttribute:'VERSION' with:version.
        ]
    ].

    nameOrIndex notNil ifTrue:[
        nameOrIndex isInteger ifTrue:[
            self putAttribute:'INDEX' with:nameOrIndex.
        ] ifFalse:[
            self putAttribute:'NAME' with:nameOrIndex.
        ].
    ].

    (self possiblyReferenced:anObject) ifTrue:[
        oldId := self rememberedIdFor:anObject.
        oldId notNil ifTrue:[
            "this is a reference to an already stored object"
            self putAttribute:'IDREF' with:oldId.
            stream nextPutAll:'/>'.
            ^ self
        ].
        className notNil ifTrue:[
            self putAttribute:'CLASS' with:className.
        ].
        "add size not for string, symbol)"
        size := anObject size.
        (size ~~ 0 and:[className notNil or:[anObject isNonByteCollection]]) ifTrue:[
            self putAttribute:'SIZE' with:size.
        ].
        "get a unique id for this object"
        id := self newIdFor:anObject.
        self putAttribute:'ID' with:id.
    ].

    aBlock isNil ifTrue:[
        "no element value, close element"
        stream nextPutAll:'/>'.
    ] ifFalse:[
        stream nextPut:$>.
        aBlock value.
        stream nextPutAll:'</'; nextPutAll:elementName; nextPut:$>.
    ].

    "Modified: / 17-02-2017 / 09:51:35 / stefan"
! !

!XMLCoder methodsFor:'initialization'!

emptyWriteStream
    "answer an empty stream. We represent encoded material as String"

    ^ CharacterWriteStream new:64
!

initialize

    super initialize.
    prettyPrint := false.
    lastIsElement := false.
    level := 0.
    maxLevel := nil.  "no limit"
!

reset
    "reset the encoder to initial state"

    level := 0.
    objectToIdMapping := nil.
! !

!XMLCoder methodsFor:'registration'!

newId
    "answer a unique id.
     The id must be registered with: #remember:as: in order to make the id persistent.
     The default here is to simply count the remembered objects starting at 1"

    ^ objectToIdMapping size + 1.
!

newIdFor:anObject 
    "register anObject and return anObject's id"

    |id|

    id := self newId.
    self remember:anObject as:id.
    ^ id.
!

remember:anObject as:id
    "register an object with a given id"

    objectToIdMapping isNil ifTrue:[
        objectToIdMapping := IdentityDictionary new
    ].
    objectToIdMapping at:anObject put:id.
!

rememberedIdFor:anObject
    "return anObject's id, if registered, nil if anObject has not been registered"

    objectToIdMapping notNil ifTrue:[
        ^ objectToIdMapping at:anObject ifAbsent:nil.
    ].
    ^ nil
!

version:something
    "set the version of the current xml output.
     If not nil, it is stored as an attribute of the top element"

    version := something.
! !

!XMLCoder methodsFor:'representing'!

possiblyReferenced:anObject
    "return true, if anObject is subject to being referenced more than once.
     If true, an ID is generated, and followup references are stored
     as IDREFs, allowing for cyclic or self referencing structures to be
     stored."

    ^ anObject class hasSharedInstances not.
! !

!XMLCoder methodsFor:'testing'!

isDecoder
    "allows an xmlSpec to provide different spec-entries"

    ^ false
!

isEncoder
    "allows an xmlSpec to provide different spec-entries"

    ^ true
! !

!XMLCoder methodsFor:'xml output'!

putAttribute:anAttributeNameString with:anObject
    "output an attribute to stream.
     There are no attributes without attributeValue in
     well-formed xml documents"

    stream space;
           nextPutAll:anAttributeNameString;
           nextPutAll:'="'.
    anObject notNil ifTrue:[
        anObject printString printXmlQuotedOn:stream.
    ].
    stream nextPut:$"
!

putElement:anElementName attributes:attributeDictionary contents:aOneArgContentsBlock
    "write anObject to the encoder.
     It is named nameOrIndex. Evaluate aBlock to encode its contents"

    level ~~ 0 ifTrue:[
        stream cr.
    ].
    self indent.
    lastIsElement := false.
    stream nextPut:$<; nextPutAll:anElementName.

    level == 0 ifTrue:[
        "first element, output aspect and version if set"
        aspect size ~~ 0 ifTrue:[
            self putAttribute:'ASPECT' with:aspect.
        ].
        (version size ~~ 0 or:[version isNumber]) ifTrue:[
            self putAttribute:'VERSION' with:version.
        ]
    ].

    attributeDictionary size ~~ 0 ifTrue:[
        attributeDictionary keysAndValuesDo:[:eachAttributeName :eachAttributeValue|
            self putAttribute:eachAttributeName with:eachAttributeValue.
        ].
    ].

    aOneArgContentsBlock isNil ifTrue:[
        stream nextPutAll:'/>'.
    ] ifFalse:[
        |oldLevel pos|

        stream nextPut:$>.
        oldLevel := level.
        stream isPositionable ifTrue:[
            pos := stream position.
        ].
        level := level + 1.
        aOneArgContentsBlock value:self.
        level := oldLevel.
        (pos notNil and:[pos = stream position]) ifTrue:[
            stream
                backStep;
                nextPutAll:'/>'.
        ] ifFalse:[
            prettyPrint & lastIsElement ifTrue:[
                stream cr.
                self indent.
            ].
            stream nextPutAll:'</'; nextPutAll:anElementName; nextPut:$>.
        ].
    ].
    lastIsElement := true.
!

putEndTag:tagString
    level := level - 1.
    lastIsElement := true.
    stream nextPutAll:'</'; nextPutAll:tagString; nextPut:$>; cr
!

putStartEndTag:tagString
    stream nextPut:$<; nextPutAll:tagString; nextPutAll:'/>'; cr
!

putStartTag:tagString
    stream nextPut:$<; nextPutAll:tagString; nextPut:$>.
    level := level + 1.
!

putXmlHeader
    "write an xml standard header"

    stream nextPutAll:'<?xml version="1.0" encoding="utf8"?>'
!

quoteString:aString
    "convert aString to a valid XML string and write it into stream."

    aString printXmlTextQuotedOn:stream.
    lastIsElement := false.
! !

!XMLCoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLCoder.st,v 1.24 2017-05-23 10:33:31 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLCoder.st,v 1.24 2017-05-23 10:33:31 stefan Exp $'
! !

