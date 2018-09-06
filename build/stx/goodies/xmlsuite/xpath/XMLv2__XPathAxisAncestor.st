"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisAncestor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
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

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisAncestor.st,v 1.3 2007-11-18 08:57:15 vranyj1 Exp $'
! !
