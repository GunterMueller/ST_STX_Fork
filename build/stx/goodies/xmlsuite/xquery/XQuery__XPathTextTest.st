"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathKindTest subclass:#XPathTextTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
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

version_SVN
    ^ '$Id$'
! !
