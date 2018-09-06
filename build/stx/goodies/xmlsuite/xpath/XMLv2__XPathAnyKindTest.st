"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathAnyKindTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathAnyKindTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'node()'

    "Created: / 15-11-2007 / 22:00:57 / janfrog"
! !

!XPathAnyKindTest methodsFor:'testing'!

isXPathAnyKindTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathAnyKindTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAnyKindTest:self

    "Created: / 17-11-2007 / 15:31:51 / janfrog"
! !

!XPathAnyKindTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAnyKindTest.st,v 1.4 2007-11-22 21:50:07 vranyj1 Exp $'
! !
