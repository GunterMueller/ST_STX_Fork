"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2004 by eXept Software AG
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

XML::SAXDriver subclass:#XMLStandardDecoder
	instanceVariableNames:'idToObjectMapping object aspect version stack characterStream
		needWhitespace useSend'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-Presentation'
!

Object subclass:#AbstractConverter
	instanceVariableNames:'id storeSpecification elementClass'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#Base64Converter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#CharacterConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#ContainedObject
	instanceVariableNames:'object'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::ContainedObject subclass:#ContainedSequence
	instanceVariableNames:'currentIndex'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#NumberConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#StringConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

XMLStandardDecoder::AbstractConverter subclass:#SymbolConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XMLStandardDecoder
!

!XMLStandardDecoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    XMLStandardDecoder is used to decode the XML representation of objects encoded
    with XMLStandardCoder

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        idToObjectMapping   <Collection> Mapping from object ids to objects
        object              <Object>     The decoded object
        aspect              <String|nil> The aspect used to encode
        version             <String|nil> The version provided by the encoder
        stack               <Stack>      Stack of nested objects
        characterStream     <WriteStream>Stream to collect character data
        needWhitespace      <Bool>       true, when whitespace should be preserved for the
                                         current element
        useSend             <Bool>       If true, use #perform: instead of
                                         #instvarNamed:put: to build objects


    [class variables:]

    [see also:]
        ObjectCoder
        XMLCoder
        XMLStandardCoder

"
!

examples
    "Look at examples in XMLStandardCoder"
! !

!XMLStandardDecoder class methodsFor:'instance creation'!

on:readStream
    "redefine to switch off validation"

    ^ super 
        on:readStream 
        beforeScanDo:[:parser| parser validate:false]
!

on:readStream beforeScanDo:aBlock
    "redefine to switch off validation"

    ^ super 
        on:readStream 
        beforeScanDo:[:parser| 
            parser validate:false. 
            aBlock value:parser builder driver
        ]
! !

!XMLStandardDecoder methodsFor:'accessing'!

aspect
    "return the value of the instance variable 'aspect' (automatically generated)"

    ^ aspect
!

next
    "answer the next object from the stream.
     Notice: VALID xml files contain only a single object."

    ^ object
!

object
    ^ object
!

useSend
    ^ useSend
!

useSend:aBoolean
    "if aBoolean is true, the decoder uses a message send to set the values of an object.
     If aBoolean is false, the instance variables are set directly"

    useSend := aBoolean.
!

version
    "return the value of the instance variable 'version' (automatically generated)"

    ^ version
! !

!XMLStandardDecoder methodsFor:'building'!

add:newObj toParent:parentObjectContainer with:currentObjectContainer
    "add an object to its parent object"

    |instVarOffset storeSpecification parentObject|

    storeSpecification := currentObjectContainer storeSpecification.
    storeSpecification isNil ifTrue:[
        "neither index nor name, may be a set or dense collection"
        parentObjectContainer add:newObj.
        ^ self.
    ].

    storeSpecification isInteger ifTrue:[
        "explicit index"
        parentObjectContainer at:storeSpecification put:newObj.
        ^ self
    ].

    "named element"
    parentObject := parentObjectContainer object.
    useSend ifTrue:[
        parentObject perform:(storeSpecification , ':') asSymbol with:newObj.
    ] ifFalse:[
        instVarOffset := parentObject class instVarIndexFor:storeSpecification.
        instVarOffset isNil ifTrue:[
            "/ mhmh - that instance variable seems to be gone;
            "/ what should we do here ?
            "/ better use useSend in this case.
            (XMLChangedInstanceLayoutException new
                    parent:parentObject instVarName:storeSpecification valueToBeStored:newObj;
                    messageText:'missing instance variable: ', storeSpecification) raiseRequest.
            "/ if proceeded, assume the handler fixed it.
        ] ifFalse:[
            parentObject instVarAt:instVarOffset put:newObj.
        ]
    ].

    "Modified: / 09-11-2007 / 14:46:25 / cg"
!

remember:obj as:id
    "map an object id to an object.
     We know here that object ids are consecutive integers starting at 1.
     If this changes, we have to use a Dictionary instead of an OrderedCollection"

    idToObjectMapping size < id ifTrue:[
        idToObjectMapping isNil ifTrue:[
            idToObjectMapping := OrderedCollection new:100.
        ].
        idToObjectMapping grow:id.
    ].
    idToObjectMapping at:id put:obj
!

valueForElementName:elementName class:classGiven size:sizeGiven
    "answer an object for a XML element name.
     Only some primitive elements or containers may be resolved immediately.
     Others need the elements text available only when the end tag is
     being processed. In this case push a converter onto the stack and return 0"

    |class newObject|

    characterStream reset.
    needWhitespace := false.

    classGiven notNil ifTrue:[
        "/ some special cases ...
        class := Smalltalk classNamed:classGiven.
        class isNil ifTrue:[
            XML::InvalidSignal raiseRequestWith:classGiven errorString:' - cannot resolve class: ', classGiven.
            "continue from exception to ignore non-existent explicit class"
       ].
    ].
    
    elementName = 'integer' ifTrue:[
        class isNil ifTrue:[class := Integer].
        stack push:(NumberConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'string' ifTrue:[
        needWhitespace := true.
        stack push:(StringConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'true' ifTrue:[
        ^ true
    ].
    elementName = 'false' ifTrue:[
        ^ false
    ].
    elementName = 'nil' ifTrue:[
        ^ nil
    ].
    elementName = 'float' ifTrue:[
        class isNil ifTrue:[class := Float].
        stack push:(NumberConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'number' ifTrue:[
        class isNil ifTrue:[class := Number]. 
        stack push:(NumberConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'symbol' ifTrue:[
        needWhitespace := true.
        stack push:(SymbolConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'char' ifTrue:[
        stack push:(CharacterConverter new elementClass:class).
        ^ 0.
    ].
    elementName = 'bytes' ifTrue:[
        class isNil ifTrue:[class := ByteArray].
        stack push:(Base64Converter new elementClass:class).
        ^ 0.
    ].
    elementName = 'dictionary' ifTrue:[
        class isNil ifTrue:[class := Dictionary].
        ^ (sizeGiven isNil ifTrue:[class new] ifFalse:[class new:sizeGiven]).
    ].
    elementName = 'sequence' ifTrue:[
        class isNil ifTrue:[class := Array].
        sizeGiven isNil ifTrue:[
            newObject := class new
        ] ifFalse:[
            newObject := class new:sizeGiven.
            "/ be careful with OrderedCollection: #new: does not allocate it!!
            newObject size = sizeGiven ifFalse:[
                newObject grow:sizeGiven
            ]
        ].
        stack push:(ContainedSequence on:newObject).
        ^ 0.
    ].
    elementName = 'collection' ifTrue:[
        class isNil ifTrue:[class := Set].
        ^ (sizeGiven isNil ifTrue:[class new] ifFalse:[class new:sizeGiven]).
    ].
    elementName = 'object' ifTrue:[
        class isNil ifTrue:[
            XML::InvalidSignal raiseRequestWith:elementName errorString:' - unknown element: ', elementName.
            ^ nil
        ].
        class isMeta ifTrue:[
            ^ class theNonMetaclass
        ].
        (class isVariable and:[sizeGiven notNil]) ifTrue:[
            ^ class basicNew:sizeGiven.
        ].
        ^ class new.
    ].

    XML::InvalidSignal raiseRequestWith:elementName errorString:' - unknown non-primitive element: ', elementName.
    ^ nil

    "Modified: / 03-11-2007 / 11:07:14 / cg"
! !

!XMLStandardDecoder methodsFor:'content handler'!

characters:aString
    "process xml character data.
     If characters are separated by ignorable whitespace, this may
     be called more than once for a single element"

    characterStream nextPutAll:aString.
!

endElement:localName namespace:nameSpace prefix:nameSpacePrefix
    "end of xml element.
     If stack is empty, this is the single top element.
     Otherwise this is a subordinate element, that will be added
     to its containing object"

    |currentObjectContainer obj id|

    currentObjectContainer := stack pop.
    currentObjectContainer isContainedObject ifTrue:[
        obj := currentObjectContainer object.
    ] ifFalse:[
        "this is a delayed element. Now, that I know the elements text,
         pop the converter from the stack and create the element"
        obj := currentObjectContainer convertText:characterStream contents.
    ].
    "/ cg: moved out of the ifFalse branch
    id := currentObjectContainer id.
    id notNil ifTrue:[
        (idToObjectMapping notNil
         and:[ (idToObjectMapping at:id ifAbsent:[nil]) notNil
         and:[ (idToObjectMapping at:id) ~~ obj ]]) ifTrue:[
            XML::InvalidSignal raiseRequestWith:obj errorString:' - duplicate id: ', id asString 
        ].
        self remember:obj as:id
    ].
    
    localName = 'object' ifTrue:[
        obj postDecodeFrom:self aspect:aspect
    ].

    stack size == 0 ifTrue:[
        "this is the top xml object"
        object := obj.
    ] ifFalse:[
        "this is a subordinate object"
        self add:obj toParent:stack top with:currentObjectContainer.
    ].
!

ignorableWhitespace:aString
    "got white space. We need all white space in strings and symbols"

    needWhitespace ifTrue:[
        characterStream nextPutAll:aString.
    ] ifFalse:[
        characterStream nextPut:Character space
    ].
!

startDocument

    stack := Stack new.
    characterStream := '' writeStream.
!

startElement:localName namespace:namespace prefix:nameSpacePrefix attributes:attributes

    |id class nameOrIndex idRef size obj|

    attributes do:[:eachAttribute |
        |type|

        type := eachAttribute tag type.

        type = 'ID' ifTrue:[
            id := Integer readFrom:eachAttribute value.
        ] ifFalse:[type = 'CLASS' ifTrue:[
            class := eachAttribute value.
        ] ifFalse:[type = 'NAME' ifTrue:[
            nameOrIndex := eachAttribute value.
        ] ifFalse:[type = 'INDEX' ifTrue:[
            nameOrIndex := Integer readFrom:eachAttribute value.
        ] ifFalse:[type = 'IDREF' ifTrue:[
            idRef := Integer readFrom:eachAttribute value.
        ] ifFalse:[type = 'SIZE' ifTrue:[
            size := Integer readFrom:eachAttribute value.
        ] ifFalse:[type = 'ASPECT' ifTrue:[
            "aspect may be present only in the start element"
            aspect := eachAttribute value.
        ] ifFalse:[type = 'VERSION' ifTrue:[
            "version may be present only in the start element"
            version := eachAttribute value.
        ] ifFalse:[
            XML::InvalidSignal raiseRequestWith:type errorString:' - unknown attribute: ', type asString.
            "continue from exception to disregard the attribute"
        ]]]]]]]]
    ].

    "/ the element's value ...
    idRef notNil ifTrue:[
        obj := idToObjectMapping at:idRef ifAbsent:[].
        "there is never a reference to a literal"
        obj isNil ifTrue:[
            XML::InvalidSignal raiseRequestWith:idRef errorString:' - unresolved reference: ', idRef 
            "continue from exception to ignore the unresolvable reference"
        ].
    ] ifFalse:[
        obj := self valueForElementName:localName class:class size:size.
        obj == 0 ifTrue:[
            "could not resolve object, because I don't know the text yet.
             Delay until #endElement.
             Converter is on top of stack. Converter is used to remember attributes"
            stack top id:id storeSpecification:nameOrIndex.
            (id notNil and:[stack top isContainedObject]) ifTrue:[
                "object may have been referenced. Remember by ID-attribute"
                self remember:stack top object as:id
            ].
            ^ self
        ].
        id notNil ifTrue:[
            "object may have been referenced. Remember by ID-attribute"
            self remember:obj as:id
        ].
    ].
    stack push:(ContainedObject new storeSpecification:nameOrIndex object:obj).
! !

!XMLStandardDecoder methodsFor:'error handler'!

error: anInvalidSignal
        "Called when a validating is on and parser reaches invalid XML. Is resumable
         Also called when a class does not exist"

        anInvalidSignal reject.
!

fatalError: anXMLSignal
        "The XML parsers malformed and invalid signals are sent to this method"

        anXMLSignal reject
!

warning: aWarningSignal

        aWarningSignal resume
! !

!XMLStandardDecoder methodsFor:'initialization'!

initialize
    super initialize.
    useSend := false.
! !

!XMLStandardDecoder::AbstractConverter class methodsFor:'documentation'!

documentation
"
    Converters are used to convert the xml text representation to objects.
    The attributes needed to create the object are known, when the start tag is
    processed, the xml text is known, when the end tag is read.


    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        id                                      The unique id of the object in the
                                                xml document (used to detect references)
        storeSpecification  (Integer|Symbol)    The index or name of the object in the
                                                parent Object.
        elementClass        (Class|nil)         The class of the element. Nil if default
                                                class specified by converter.

    [class variables:]

    [see also:]

"
! !

!XMLStandardDecoder::AbstractConverter methodsFor:'accessing'!

elementClass
    ^ elementClass
!

elementClass:something
    elementClass := something.
!

id
    "return the value of the instance variable 'id' (automatically generated)"

    ^ id
!

id:idArg storeSpecification:storeSpecificationArg 
    "set instance variables (automatically generated)"

    id := idArg.
    storeSpecification := storeSpecificationArg.
!

storeSpecification
    "return the value of the instance variable 'storeSpecification' (automatically generated)"

    ^ storeSpecification
! !

!XMLStandardDecoder::AbstractConverter methodsFor:'converting'!

convertText:aString
    "convert the text to the internal smalltalk representation"

    ^ self subclassResponsibility
! !

!XMLStandardDecoder::AbstractConverter methodsFor:'testing'!

isContainedObject
    "answer true, if i already know the final object"

    ^ false
! !

!XMLStandardDecoder::Base64Converter methodsFor:'converting'!

convertText:aString
    "convert the text to a symbol"

    |bytes|

    bytes := (Base64Coder on:aString readStream) upToEnd.

    elementClass notNil ifTrue:[
        |object size|

        elementClass == bytes class ifTrue:[
            ^ bytes
        ].

        size := bytes size.
        object := elementClass new:size.
        object replaceBytesFrom:1 to:size with:bytes startingAt:1.
        ^ object.
   ].
    
    ^ bytes
! !

!XMLStandardDecoder::CharacterConverter methodsFor:'converting'!

convertText:aString
    "convert the text to a character"

    ^ Character value:(Integer readFrom:aString)
! !

!XMLStandardDecoder::ContainedObject methodsFor:'accessing'!

object
    "return the value of the instance variable 'object' (automatically generated)"

    ^ object
!

object:something
    "set the value of the instance variable 'object' (automatically generated)"

    object := something.
!

storeSpecification:storeSpecificationArg object:objectArg 
    "set instance variables (automatically generated)"

    storeSpecification := storeSpecificationArg.
    object := objectArg.
! !

!XMLStandardDecoder::ContainedObject methodsFor:'collection access'!

add:newObject
    ^ object add:newObject.
!

at:anIndex put:newObject
    ^ object at:anIndex put:newObject.
! !

!XMLStandardDecoder::ContainedObject methodsFor:'testing'!

isContainedObject
    "answer true, if i already know the final object"

    ^ true
! !

!XMLStandardDecoder::ContainedSequence class methodsFor:'instance creation'!

on:anArray
    ^ self basicNew on:anArray
! !

!XMLStandardDecoder::ContainedSequence methodsFor:'collection access'!

add:newObject
    currentIndex := currentIndex + 1.
    ^ object at:currentIndex put:newObject.
!

at:anIndex put:newObject
    "next element without explicit index goes to anIndex+1"

    currentIndex := anIndex.
    anIndex > object size ifTrue:[
        "/ must be done, because (OrderedCollection new:sz) does not really
        "/ make the collection of size sz.
        object grow:anIndex
    ].
    ^ object at:anIndex put:newObject.
! !

!XMLStandardDecoder::ContainedSequence methodsFor:'initialization'!

on:anArray
    object := anArray.
    currentIndex := 0.      "next element goes to currentIndex+1"
! !

!XMLStandardDecoder::NumberConverter methodsFor:'converting'!

convertText:aString
    "convert the text to a number"

    ^ elementClass readFromString:aString
! !

!XMLStandardDecoder::StringConverter methodsFor:'converting'!

convertText:aString
    "convert the text to a string"

    ^ aString
! !

!XMLStandardDecoder::SymbolConverter methodsFor:'converting'!

convertText:aString
    "convert the text to a symbol"

    ^ aString asSymbol
! !

!XMLStandardDecoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLStandardDecoder.st,v 1.36 2018-02-02 16:38:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLStandardDecoder.st,v 1.36 2018-02-02 16:38:56 cg Exp $'
! !

