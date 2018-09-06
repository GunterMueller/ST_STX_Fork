"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisAttribute
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisAttribute methodsFor:'filtering'!

createNodeSetFromContext:aContext

    ^aContext newNodeSetWithAll:(aContext documentAdaptor xpathAttributeOf:aContext node)

    "Modified: / 13-10-2006 / 20:44:45 / janfrog"
! !

!XPathAxisAttribute methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'attribute::'

    "Created: / 15-11-2007 / 22:04:20 / janfrog"
! !

!XPathAxisAttribute methodsFor:'testing'!

isXPathAxisAttribute
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisAttribute methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisAttribute:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisAttribute class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisAttribute.st,v 1.5 2007-11-18 08:54:33 vranyj1 Exp $'
! !
