"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisDescendantOrSelf
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisDescendantOrSelf methodsFor:'filtering'!

createNodeSetFromContext:aContext

    ^aContext newNodeSetWithAll:(aContext documentAdaptor xpathDescendantOrSelfOf:aContext node)

    "Modified: / 13-10-2006 / 20:43:35 / janfrog"
! !

!XPathAxisDescendantOrSelf methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'descendant-or-self::'

    "Created: / 15-11-2007 / 22:04:54 / janfrog"
! !

!XPathAxisDescendantOrSelf methodsFor:'testing'!

isXPathAxisDescendantOrSelf
    ^ true

    "Created: / 16-11-2007 / 09:27:08 / janfrog"
! !

!XPathAxisDescendantOrSelf methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisDescendantOrSelf:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisDescendantOrSelf class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisDescendantOrSelf.st,v 1.5 2007-11-18 08:58:02 vranyj1 Exp $'
! !
