"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathAxis subclass:#XPathAxisAncestorOrSelf
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathAxisAncestorOrSelf methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'ancestor-or-self::'

    "Created: / 15-11-2007 / 22:04:03 / janfrog"
! !

!XPathAxisAncestorOrSelf methodsFor:'testing'!

isXPathAxisAncestorOrSelf
    ^ true

    "Created: / 16-11-2007 / 09:26:56 / janfrog"
! !

!XPathAxisAncestorOrSelf methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisAncestorOrSelf:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisAncestorOrSelf class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
