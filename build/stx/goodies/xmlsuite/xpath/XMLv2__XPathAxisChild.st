"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisChild
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisChild methodsFor:'filtering'!

createNodeSetFromContext:aContext 

    ^aContext newNodeSetWithAll:(aContext documentAdaptor xpathChildOf:aContext node)

    "Modified: / 13-10-2006 / 20:44:32 / janfrog"
! !

!XPathAxisChild methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'child::'

    "Created: / 15-11-2007 / 22:04:30 / janfrog"
! !

!XPathAxisChild methodsFor:'testing'!

isXPathAxisChild
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisChild methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisChild:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisChild class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisChild.st,v 1.5 2007-11-18 08:57:36 vranyj1 Exp $'
! !
