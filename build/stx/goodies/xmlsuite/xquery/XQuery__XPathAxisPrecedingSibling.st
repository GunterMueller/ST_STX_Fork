"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathAxis subclass:#XPathAxisPrecedingSibling
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
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

version_SVN
    ^ '$Id$'
! !
