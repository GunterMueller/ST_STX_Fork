"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathAxis subclass:#XPathAxisAncestor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathAxisAncestor methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'ancestor::'

    "Created: / 15-11-2007 / 22:03:50 / janfrog"
! !

!XPathAxisAncestor methodsFor:'testing'!

isXPathAxisAncestor
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisAncestor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisAncestor:self

    "Created: / 17-11-2007 / 15:31:51 / janfrog"
! !

!XPathAxisAncestor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
