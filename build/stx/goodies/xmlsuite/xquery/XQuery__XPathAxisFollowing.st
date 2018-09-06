"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathAxis subclass:#XPathAxisFollowing
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathAxisFollowing methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'following::'

    "Created: / 15-11-2007 / 22:05:10 / janfrog"
! !

!XPathAxisFollowing methodsFor:'testing'!

isXPathAxisFollowing
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisFollowing methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisFollowing:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisFollowing class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
