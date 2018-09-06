"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#ChoiceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!ChoiceNode methodsFor:'automaton support'!

generateTransitionsIn:aContentModelAutomaton

    super generateTransitionsIn:aContentModelAutomaton.

    self children do:[:child|
        aContentModelAutomaton
            makeTransitionsFrom:child patternsThatCanBeLast
            to:self patternsThatCanBeNext
    ]

    "Created: / 30-04-2005 / 21:13:49 / janfrog"
!

patternsThatCanBeFirst
    "Superclass says that I am responsible to implement this method"

    ^self children 
        inject:Set new
        into:[:set :child| set addAll:(child patternsThatCanBeFirst). set]

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
!

patternsThatCanBeLast
    "Superclass says that I am responsible to implement this method"

    ^self children 
        inject:Set new
        into:[:set :child| set addAll:(child patternsThatCanBeLast). set]

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
! !

!ChoiceNode methodsFor:'printing'!

groupModifierCharacter
    "Superclass says that I am responsible to implement this method"

    ^Character space

    "Created: / 30-04-2005 / 18:58:09 / janfrog"
!

printChildrenOn:aStream

    self firstChild isTerminatorNode ifTrue:[
        ^aStream nextPut:$e.
    ].
    self children 
        do:[:childNode | childNode printOn:aStream ]
        separatedBy:[
            aStream
                space
                nextPut:$|;
                space
        ]

    "Created: / 30-04-2005 / 18:58:04 / janfrog"
! !

!ChoiceNode methodsFor:'testing'!

isChoiceNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!ChoiceNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitChoiceNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!ChoiceNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ChoiceNode.st,v 1.1.1.1 2005-11-01 22:07:12 vranyj1 Exp $'
! !
