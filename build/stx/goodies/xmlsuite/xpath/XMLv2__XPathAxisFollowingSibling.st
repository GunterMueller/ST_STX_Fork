"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathAxis subclass:#XPathAxisFollowingSibling
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxisFollowingSibling methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'following-sibling::'

    "Created: / 15-11-2007 / 22:05:21 / janfrog"
! !

!XPathAxisFollowingSibling methodsFor:'testing'!

isXPathAxisFollowingSibling
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisFollowingSibling methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisFollowingSibling:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisFollowingSibling class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxisFollowingSibling.st,v 1.4 2007-11-26 23:22:20 beyrk1 Exp $'
! !
