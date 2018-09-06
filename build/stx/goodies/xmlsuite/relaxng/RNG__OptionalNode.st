"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#OptionalNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!OptionalNode methodsFor:'automaton support'!

generateTransitionsIn:aContentModelAutomaton



    super generateTransitionsIn:aContentModelAutomaton.

    "/self children size > 1 ifTrue:[self halt].

    self children do:[:child|
        aContentModelAutomaton
            makeTransitionsFrom:child patternsThatCanBeLast
            to:child patternsThatCanBeNext
    ]

    "Created: / 23-06-2005 / 10:57:47 / masca"
!

patternsThatCanBeFirst
    "Superclass says that I am responsible to implement this method"

    ^self firstChild patternsThatCanBeFirst
        addAll:(self next patternsThatCanBeFirst);
        yourself

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
!

patternsThatCanBeLast
    "Superclass says that I am responsible to implement this method"

    ^self lastChild patternsThatCanBeLast 
        addAll:(self prev patternsThatCanBeLast);
        yourself

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
! !

!OptionalNode methodsFor:'printing'!

groupModifierCharacter
    "Superclass says that I am responsible to implement this method"

    ^$?

    "Created: / 30-04-2005 / 18:58:40 / janfrog"
! !

!OptionalNode methodsFor:'testing'!

canBeEmpty
    ^true

    "Created: / 02-05-2005 / 12:03:40 / janfrog"
!

isOptionalNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!OptionalNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitOptionalNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!OptionalNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__OptionalNode.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
