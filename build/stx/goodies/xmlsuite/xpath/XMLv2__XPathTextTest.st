"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathTextTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathTextTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'text()'

    "Created: / 15-11-2007 / 22:03:18 / janfrog"
! !

!XPathTextTest methodsFor:'testing'!

isXPathTextTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathTextTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathTextTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathTextTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathTextTest.st,v 1.3 2007-11-22 21:43:17 vranyj1 Exp $'
! !
