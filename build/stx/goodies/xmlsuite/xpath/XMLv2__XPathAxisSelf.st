"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisSelf
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisSelf methodsFor:'filtering'!

createNodeSetFromContext:aContext
    ^ aContext newNodeSetWith:aContext node

    "Modified: / 13-10-2006 / 20:42:29 / janfrog"
! !

!XPathAxisSelf methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'self::'

    "Created: / 15-11-2007 / 22:06:16 / janfrog"
! !

!XPathAxisSelf methodsFor:'testing'!

isXPathAxisSelf
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisSelf methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisSelf:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisSelf class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisSelf.st,v 1.5 2007-11-18 08:54:28 vranyj1 Exp $'
! !
