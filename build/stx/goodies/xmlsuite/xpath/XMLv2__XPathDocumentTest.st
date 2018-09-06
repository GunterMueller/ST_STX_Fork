"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathDocumentTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathDocumentTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'document-node()'

    "Created: / 15-11-2007 / 22:02:52 / janfrog"
! !

!XPathDocumentTest methodsFor:'testing'!

isXPathDocumentTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathDocumentTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathDocumentTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathDocumentTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDocumentTest.st,v 1.3 2007-11-22 21:47:41 vranyj1 Exp $'
! !
