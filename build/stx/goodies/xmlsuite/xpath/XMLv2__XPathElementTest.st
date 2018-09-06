"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathElementTest
	instanceVariableNames:'elementName'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathElementTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'attribute('.
    elementName ifNotNil:[stream nextPutAll: elementName].
    stream nextPut:$)

    "Created: / 15-11-2007 / 22:02:22 / janfrog"
! !

!XPathElementTest methodsFor:'testing'!

isXPathElementTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathElementTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathElementTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathElementTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathElementTest.st,v 1.3 2007-11-22 21:47:55 vranyj1 Exp $'
! !
