"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisAncestorOrSelf
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
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

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisAncestorOrSelf.st,v 1.3 2007-11-18 08:57:27 vranyj1 Exp $'
! !