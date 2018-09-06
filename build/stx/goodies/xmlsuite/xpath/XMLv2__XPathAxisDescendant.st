"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisDescendant
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisDescendant methodsFor:'filtering'!

createNodeSetFromContext:aContext 

    ^aContext newNodeSetWithAll:
        (aContext documentAdaptor xpathDescendantOf: aContext node)

    "Modified: / 13-10-2006 / 20:43:47 / janfrog"
! !

!XPathAxisDescendant methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'descendant::'

    "Created: / 15-11-2007 / 22:04:40 / janfrog"
! !

!XPathAxisDescendant methodsFor:'testing'!

isXPathAxisDescendant
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisDescendant methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisDescendant:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisDescendant class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisDescendant.st,v 1.5 2007-11-18 08:57:53 vranyj1 Exp $'
! !
