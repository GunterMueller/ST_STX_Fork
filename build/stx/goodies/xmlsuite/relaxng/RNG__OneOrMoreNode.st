"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#OneOrMoreNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!OneOrMoreNode methodsFor:'automaton support'!

generateTransitionsIn:aContentModelAutomaton

    super generateTransitionsIn:aContentModelAutomaton.

    aContentModelAutomaton
        makeTransitionsFrom:self lastChild patternsThatCanBeLast
        to:self patternsThatCanBeFirst.

    self children do:[:child|
        aContentModelAutomaton
            makeTransitionsFrom:child patternsThatCanBeLast
            to:child patternsThatCanBeNext
        ]

    "Created: / 30-04-2005 / 21:16:56 / janfrog"
    "Modified: / 02-05-2005 / 11:53:28 / janfrog"
!

patternsThatCanBeFirst
    "Superclass says that I am responsible to implement this method"

    ^self firstChild patternsThatCanBeFirst

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
!

patternsThatCanBeLast
    "Superclass says that I am responsible to implement this method"

    ^self lastChild patternsThatCanBeLast

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
! !

!OneOrMoreNode methodsFor:'printing'!

groupModifierCharacter
    "Superclass says that I am responsible to implement this method"

    ^$+

    "Created: / 30-04-2005 / 18:59:12 / janfrog"
! !

!OneOrMoreNode methodsFor:'testing'!

isOneOrMoreNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isRepeatingNode

    ^true

    "Created: / 14-05-2005 / 21:30:21 / janfrog"
! !

!OneOrMoreNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitOneOrMoreNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!OneOrMoreNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__OneOrMoreNode.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
