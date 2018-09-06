"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathCommentTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathCommentTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'comment()'

    "Created: / 15-11-2007 / 22:02:39 / janfrog"
! !

!XPathCommentTest methodsFor:'testing'!

isXPathCommentTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathCommentTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathCommentTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathCommentTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathCommentTest.st,v 1.3 2007-11-22 21:48:42 vranyj1 Exp $'
! !
