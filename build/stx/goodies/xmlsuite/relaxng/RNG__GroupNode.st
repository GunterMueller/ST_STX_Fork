"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#GroupNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!GroupNode methodsFor:'automaton support'!

generateTransitionsIn:aContentModelAutomaton

    super generateTransitionsIn:aContentModelAutomaton.

    self children do:[:child|
        aContentModelAutomaton
            makeTransitionsFrom:child patternsThatCanBeLast
            to:child patternsThatCanBeNext
    ]

    "Created: / 30-04-2005 / 21:16:01 / janfrog"
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

!GroupNode methodsFor:'printing'!

groupModifierCharacter

    ^Character space

    "Created: / 30-04-2005 / 18:54:38 / janfrog"
!

printGroupModifierOn:aStream

    "no modifier"

    "Created: / 30-04-2005 / 17:48:16 / janfrog"
! !

!GroupNode methodsFor:'testing'!

isGroupNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!GroupNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitGroupNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!GroupNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__GroupNode.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
