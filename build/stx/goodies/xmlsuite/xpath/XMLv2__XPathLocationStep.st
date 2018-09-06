"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Perseus::ASTNode subclass:#XPathLocationStep
	instanceVariableNames:'axis nodeTest predicates'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathLocationStep methodsFor:'accessing'!

axis
    ^ axis
!

axis:something
    axis := something.
!

nodeTest
    ^ nodeTest
!

nodeTest:something
    nodeTest := something.
!

predicates

   ^predicates ? #()

    "Modified: / 15-11-2007 / 23:14:05 / janfrog"
!

predicates: aCollection

   aCollection isNilOrEmptyCollection 
        ifFalse:[predicates := aCollection]

    "Created: / 15-11-2007 / 23:14:39 / janfrog"
! !

!XPathLocationStep methodsFor:'printing'!

printOn: stream

    axis printOn: stream.
    nodeTest printOn: stream.
    self predicates do:[:predicate|predicate printOn: stream]

    "Created: / 15-11-2007 / 22:55:20 / janfrog"
! !

!XPathLocationStep methodsFor:'queries'!

hasPredicates

    ^predicates isNilOrEmptyCollection not

    "Created: / 05-12-2007 / 10:30:11 / janfrog"
! !

!XPathLocationStep methodsFor:'testing'!

isChildWithNameTestStep

    ^axis isXPathAxisChild
        and:[nodeTest isXPathNameTest]

    "Created: / 21-11-2007 / 11:10:42 / janfrog"
!

isDescendantOrSelfWithAnyKindTestStepAndWithoutPredicates

    ^axis isXPathAxisDescendantOrSelf 
        and:[nodeTest isXPathAnyKindTest 
            and:[predicates isNilOrEmptyCollection]]

    "Created: / 21-11-2007 / 11:10:50 / janfrog"
! !

!XPathLocationStep methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathLocationStep:self

    "Created: / 17-11-2007 / 15:10:28 / janfrog"
! !

!XPathLocationStep class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathLocationStep.st,v 1.6 2007-12-05 11:26:38 vranyj1 Exp $'
! !
