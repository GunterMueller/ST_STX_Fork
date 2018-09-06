"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathKindTest subclass:#XPathProcessingInstructionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Node tests'
!


!XPathProcessingInstructionTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'processing-instruction()'

    "Created: / 15-11-2007 / 22:03:07 / janfrog"
! !

!XPathProcessingInstructionTest methodsFor:'testing'!

isXPathProcessingInstructionTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathProcessingInstructionTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathProcessingInstructionTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathProcessingInstructionTest class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathProcessingInstructionTest.st,v 1.5 2007-11-22 21:43:22 vranyj1 Exp $'
! !
