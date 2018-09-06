"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathAttributeTest
	instanceVariableNames:'attribName'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathAttributeTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'attribute('.
    attribName ifNotNil:[stream nextPutAll: attribName].
    stream nextPut:$)

    "Created: / 15-11-2007 / 22:02:02 / janfrog"
! !

!XPathAttributeTest methodsFor:'testing'!

isXPathAttributeTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathAttributeTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAttributeTest:self

    "Created: / 17-11-2007 / 15:31:51 / janfrog"
! !

!XPathAttributeTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAttributeTest.st,v 1.3 2007-11-22 21:48:46 vranyj1 Exp $'
! !
