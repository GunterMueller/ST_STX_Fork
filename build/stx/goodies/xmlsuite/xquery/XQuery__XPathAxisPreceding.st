"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathAxis subclass:#XPathAxisPreceding
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathAxisPreceding methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'preceding::'

    "Created: / 15-11-2007 / 22:05:49 / janfrog"
! !

!XPathAxisPreceding methodsFor:'testing'!

isXPathAxisPreceding
    ^ true

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxisPreceding methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathAxisPreceding:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathAxisPreceding class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
