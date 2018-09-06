"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

CharacterData subclass:#Text
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Text methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

logicallyAdjacentTextNodes

    | siblings myIdx idx adjacentNodes |
    adjacentNodes := NodeList new.
    siblings := self parent childNodes.
    myIdx := siblings identityIndexOf:self.
    idx := myIdx.
    idx ~= 1 ifTrue:[
        [ (siblings at:idx - 1) isText ] whileTrue:[
            idx := idx - 1
        ]
    ].
    [ (siblings at:idx) isText ] whileTrue:[
        adjacentNodes add:(siblings at:idx).
        idx := idx + 1
    ].
    ^adjacentNodes

    "Created: / 18-06-2005 / 21:43:36 / janfrog"
!

textContentOn:aStream 
    "Superclass says that I am responsible to implement this method"

    aStream nextPutAll:data

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
    "Modified: / 18-10-2005 / 14:53:04 / janfrog"
!

wholeTextOn:aStream

    self logicallyAdjacentTextNodes do:[:text|
        aStream nextPutAll:text data.
    ].

    "Created: / 18-06-2005 / 21:41:54 / janfrog"
! !

!Text methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

isElementContentWhitespace

    ^self data allSatisfy:[:c|c isXMLWhiteSpace]

    "Created: / 18-06-2005 / 21:32:38 / janfrog"
!

lookupNamespaceURI:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeName

    ^'#text'

    "Created: / 17-06-2005 / 11:35:05 / janfrog"
!

nodeType

    ^Node TEXT_NODE

    "Created: / 17-06-2005 / 11:45:32 / janfrog"
!

nodeValue

    ^self data

    "Created: / 28-12-2005 / 16:56:43 / janfrog"
!

normalize

    "Nothing to do for now"

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
    "Modified: / 23-12-2005 / 20:54:31 / janfrog"
!

replaceWholeText:newText

    self logicallyAdjacentTextNodes do:[:text|
        text == self ifFalse:[self parent removeChild:text]
    ].
    self data:newText.

    "Created: / 18-06-2005 / 21:47:47 / janfrog"
!

splitText:offset

    | before after newText |
    before := self data copyTo:offset.
    after := self data copyFrom:offset + 1.
    self data:before.
    newText := Text new data:after.
    self parent insertChild:newText after:self.
    ^newText

    "Created: / 18-06-2005 / 21:49:05 / janfrog"
!

wholeText

    | s |
    s := UnicodeString new writeStream.
    self wholeTextOn:s.
    ^s contents

    "Created: / 18-06-2005 / 21:37:24 / janfrog"
! !

!Text methodsFor:'accessing'!

data
    ^data

    "Created: / 18-06-2005 / 21:32:52 / janfrog"
!

data:aString
    data := aString

    "Created: / 18-06-2005 / 21:33:13 / janfrog"
! !

!Text methodsFor:'testing'!

isIgnorableText

    ^self data allSatisfy:[:c|c isXMLWhiteSpace]

    "Created: / 12-12-2006 / 10:31:35 / janfrog"
!

isText
    ^ true

    "Created: / 05-08-2005 / 14:28:08 / janfrog"
! !

!Text methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitText:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Text class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Text.st,v 1.5 2007-01-03 19:58:33 stillj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
