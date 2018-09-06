"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#XMLGenerator
	instanceVariableNames:'minDepth maxDepth minChildElements maxChildElements minAttributes
		maxAttributes availableElementNames availableAttributeNames
		availableWords'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Generator'
!

!XMLGenerator class methodsFor:'documentation'!

example1

    | generator dom3Builder |
    dom3Builder := DOM3Builder new.
    generator := XMLGenerator new
                    setContentHandler: dom3Builder.
    generator parse.
    ^dom3Builder document.
! !

!XMLGenerator class methodsFor:'instance creation'!

new

    ^self basicNew initialize

    "Created: / 20-03-2008 / 21:52:30 / janfrog"
! !

!XMLGenerator methodsFor:'SAX2 interface - Locator'!

getColumnNumber
    "Superclass says that I am responsible to implement this method"

    ^nil

    "Created: / 20-03-2008 / 21:18:54 / janfrog"
!

getLineNumber
    "Superclass says that I am responsible to implement this method"

    ^nil

    "Created: / 20-03-2008 / 21:18:54 / janfrog"
!

getPublicId

    ^'Random Document'

    "Created: / 20-03-2008 / 21:57:20 / janfrog"
!

getSystemId

    ^'/dev/zero'

    "Created: / 20-03-2008 / 21:57:33 / janfrog"
! !

!XMLGenerator methodsFor:'accessing'!

availableAttributeNames
    ^ availableAttributeNames

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

availableAttributeNames:something
    "set the value of the instance variable 'availableAttributeNames' and send a change notification (automatically generated)"

    (availableAttributeNames ~~ something) ifTrue:[
        availableAttributeNames := something.
        self changed:#availableAttributeNames.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

availableElementNames
    ^ availableElementNames

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

availableElementNames:something
    "set the value of the instance variable 'availableElementNames' and send a change notification (automatically generated)"

    (availableElementNames ~~ something) ifTrue:[
        availableElementNames := something.
        self changed:#availableElementNames.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

availableWords
    ^ availableWords

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

availableWords:something
    "set the value of the instance variable 'availableWords' and send a change notification (automatically generated)"

    (availableWords ~~ something) ifTrue:[
        availableWords := something.
        self changed:#availableWords.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxAttributes
    ^ maxAttributes

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxAttributes:something
    "set the value of the instance variable 'maxAttributes' and send a change notification (automatically generated)"

    (maxAttributes ~~ something) ifTrue:[
        maxAttributes := something.
        self changed:#maxAttributes.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxChildElements
    ^ maxChildElements

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxChildElements:something
    "set the value of the instance variable 'maxChildElements' and send a change notification (automatically generated)"

    (maxChildElements ~~ something) ifTrue:[
        maxChildElements := something.
        self changed:#maxChildElements.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxDepth
    ^ maxDepth

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

maxDepth:something
    "set the value of the instance variable 'maxDepth' and send a change notification (automatically generated)"

    (maxDepth ~~ something) ifTrue:[
        maxDepth := something.
        self changed:#maxDepth.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minAttributes
    ^ minAttributes

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minAttributes:something
    "set the value of the instance variable 'minAttributes' and send a change notification (automatically generated)"

    (minAttributes ~~ something) ifTrue:[
        minAttributes := something.
        self changed:#minAttributes.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minChildElements
    ^ minChildElements

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minChildElements:something
    "set the value of the instance variable 'minChildElements' and send a change notification (automatically generated)"

    (minChildElements ~~ something) ifTrue:[
        minChildElements := something.
        self changed:#minChildElements.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minDepth
    ^ minDepth

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
!

minDepth:something
    "set the value of the instance variable 'minDepth' and send a change notification (automatically generated)"

    (minDepth ~~ something) ifTrue:[
        minDepth := something.
        self changed:#minDepth.
     ].

    "Created: / 20-03-2008 / 21:22:36 / janfrog"
! !

!XMLGenerator methodsFor:'initialization'!

initialize

    super initialize.
    minDepth := 2.
    maxDepth := 4.

    minChildElements := 3.
    maxChildElements := 9.
    minAttributes := 0.
    maxAttributes := 3.

    availableElementNames := #('e1' 'e2' 'e3' 'e4' 'e5').
    availableAttributeNames := #('a1' 'a2' 'a3' 'a4' 'a5').

    availableWords := #('Lorem' 'ypsum')

    "Created: / 20-03-2008 / 21:23:13 / janfrog"
! !

!XMLGenerator methodsFor:'private'!

parse

    contentHandler setDocumentLocator: self locator.
    self generateDocument

    "Created: / 20-03-2008 / 21:19:43 / janfrog"
!

parseFragmentStream:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement

    "Created: / 20-03-2008 / 21:18:54 / janfrog"
!

parseStream:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement

    "Created: / 20-03-2008 / 21:18:54 / janfrog"
! !

!XMLGenerator methodsFor:'private - generating'!

generateAttributeName

    ^self availableAttributeNames atRandom

    "Created: / 20-03-2008 / 21:39:34 / janfrog"
!

generateAttributeValue

    | valueStream |
    valueStream := (String new: 10) writeStream.
    (Random nextIntegerBetween: 1 and: 3)
        timesRepeat:
            [valueStream nextPutAll: self generateWord; space].
    ^valueStream contents

    "Created: / 20-03-2008 / 21:41:31 / janfrog"
!

generateAttributes

    | nAttrs attrs |
    nAttrs := Random nextIntegerBetween: minAttributes and: maxAttributes.
    attrs := Attributes new: nAttrs.
    nAttrs timesRepeat:
        [attrs add:
            (Attr new
                localName: self generateAttributeName;
                ns:'';
                prefix:'';
                value: self generateAttributeValue)].
    ^attrs

    "Created: / 20-03-2008 / 21:34:00 / janfrog"
!

generateDocument

    contentHandler startDocument.
    self generateElement: 0.
    contentHandler endDocument.

    "Created: / 20-03-2008 / 21:27:27 / janfrog"
!

generateElement: depth

    | elementName attrs |
    depth > (Random nextIntegerBetween: minChildElements and: maxChildElements)
        ifTrue:[^self].
    elementName := self generateElementName.
    attrs := self generateAttributes.
    contentHandler
        startElement: elementName namespace: '' prefix: '' attributes: attrs.
    (Random nextIntegerBetween: minChildElements and: maxChildElements)
        timesRepeat:
            [#(true false) atRandom
                ifTrue:[self generateElement: depth + 1]
                ifFalse:[self generateText]].
    contentHandler
            endElement: elementName namespace: '' prefix: ''

    "Created: / 20-03-2008 / 21:28:54 / janfrog"
!

generateElementName

    ^self availableElementNames atRandom

    "Created: / 20-03-2008 / 21:39:43 / janfrog"
!

generateText

    | textStream |
    textStream := (String new: 10) writeStream.
    (Random nextIntegerBetween: 5 and: 30)
        timesRepeat:
            [textStream nextPutAll: self generateWord; space].
    ^contentHandler characters: textStream contents.

    "Created: / 20-03-2008 / 21:42:44 / janfrog"
!

generateWord

    ^self availableWords atRandom

    "Created: / 20-03-2008 / 21:42:47 / janfrog"
! !

!XMLGenerator class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_SVN
    ^ '$Id$'
! !
