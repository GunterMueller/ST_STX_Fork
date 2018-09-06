"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisParent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisParent methodsFor:'filtering'!

createNodeSetFromContext:aContext 
    |parent|

    parent := (aContext documentAdaptor xpathParentOf:aContext node).
    ^parent 
        ifNil:[aContext newNodeSet]
        ifNotNil:[aContext newNodeSetWith:parent]

    "Modified: / 13-10-2006 / 20:42:51 / janfrog"
! !

!XPathAxisParent methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'parent::'

    "Created: / 15-11-2007 / 22:06:03 / janfrog"
! !

!XPathAxisParent methodsFor:'testing'!

isXPathAxisParent
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisParent methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisParent:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisParent class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisParent.st,v 1.5 2007-11-18 08:58:16 vranyj1 Exp $'
! !
