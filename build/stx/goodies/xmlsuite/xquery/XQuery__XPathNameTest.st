"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathNodeTest subclass:#XPathNameTest
	instanceVariableNames:'localName prefix'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathNameTest methodsFor:'accessing'!

localName
    ^ localName

    "Created: / 14-11-2007 / 18:04:02 / janfrog"
!

localName:something
    localName := something.

    "Created: / 14-11-2007 / 18:04:02 / janfrog"
!

namespaceURI

    ^prefix

    "Created: / 21-11-2007 / 13:42:25 / janfrog"
!

prefix
    ^ prefix

    "Created: / 14-11-2007 / 18:04:02 / janfrog"
!

prefix:something
    prefix := something.

    "Created: / 14-11-2007 / 18:04:02 / janfrog"
!

qName: aString

    | nodeName |
    nodeName := XMLv2::NodeName fromString: aString.
    nodeName prefix isNilOrEmptyCollection 
        ifFalse:[prefix := nodeName prefix].
    localName := nodeName localName

    "Created: / 17-11-2007 / 14:13:23 / janfrog"
    "Modified: / 17-11-2007 / 15:27:01 / janfrog"
! !

!XPathNameTest methodsFor:'filtering'!

filterNodeSet:aNodeSet 
    | da|

    da := aNodeSet documentAdaptor.
    ^aNodeSet select:
        [:each|
        ((da xpathIsElement:each) or:[da xpathIsAttribute:each]) and:
            [(prefix == #all or:[prefix = (da xpathNamespaceOf:each)]) and:
                [localName == #all or:[localName = (da xpathLocalNameOf: each)]]]]

    "Modified: / 15-11-2007 / 21:52:21 / janfrog"
! !

!XPathNameTest methodsFor:'printing'!

printOn: stream

    (prefix = '*' and:[localName = '*']) ifTrue:[^stream nextPut:$*].

    prefix ifNotNil:
        [stream nextPutAll: prefix; nextPut:$:].
    stream nextPutAll: localName

    "Created: / 15-11-2007 / 22:07:20 / janfrog"
    "Modified: / 18-11-2007 / 09:05:51 / janfrog"
! !

!XPathNameTest methodsFor:'testing'!

isXPathNameTest
    ^ true

    "Created: / 21-11-2007 / 11:06:23 / janfrog"
! !

!XPathNameTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathNameTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathNameTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
