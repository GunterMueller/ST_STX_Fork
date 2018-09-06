"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisPrecedingSibling
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisPrecedingSibling methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'preceding-sibling::'

    "Created: / 15-11-2007 / 22:05:36 / janfrog"
! !

!XPathAxisPrecedingSibling methodsFor:'testing'!

isXPathAxisPrecedingSibling
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisPrecedingSibling methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisPrecedingSibling:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisPrecedingSibling class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisPrecedingSibling.st,v 1.3 2007-11-18 08:55:17 vranyj1 Exp $'
! !
