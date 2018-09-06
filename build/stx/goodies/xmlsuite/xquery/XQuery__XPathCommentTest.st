"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathKindTest subclass:#XPathCommentTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
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

version_SVN
    ^ '$Id$'
! !
