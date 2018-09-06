"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#ZeroOrMoreNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!ZeroOrMoreNode methodsFor:'automaton support'!

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

    "Created: / 30-04-2005 / 21:17:48 / janfrog"
    "Modified: / 02-05-2005 / 11:53:14 / janfrog"
!

patternsThatCanBeFirst
    "Superclass says that I am responsible to implement this method"

    ^self firstChild patternsThatCanBeFirst 
        addAll:self next patternsThatCanBeFirst;
        yourself

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
    "Modified: / 13-05-2005 / 10:54:38 / masca"
!

patternsThatCanBeLast
    "Superclass says that I am responsible to implement this method"

    ^self lastChild patternsThatCanBeLast 
        addAll:(self prev patternsThatCanBeLast);
        yourself

    "Created: / 30-04-2005 / 21:04:04 / janfrog"
    "Modified: / 02-05-2005 / 11:52:02 / janfrog"
! !

!ZeroOrMoreNode methodsFor:'checking'!

checkContents

    (self parent isPatternNode and:[self parent isPatternNodeForList])
        ifTrue:[
            self children allSatisfy:[:child|
                (child isRefNode not and:
                    [child isPatternNode and:[child isPatternNodeForPCData]])
                        ifFalse:[
                            self invalidContentError:'Can contain only <data> or <text> patterns'.
                        ]
            ]                        
        ]

    "Created: / 14-05-2005 / 20:53:49 / janfrog"
    "Modified: / 16-05-2005 / 13:46:54 / masca"
! !

!ZeroOrMoreNode methodsFor:'printing'!

groupModifierCharacter
    "Superclass says that I am responsible to implement this method"

    ^$*

    "Created: / 30-04-2005 / 18:59:12 / janfrog"
! !

!ZeroOrMoreNode methodsFor:'testing'!

isRepeatingNode

    ^true

    "Created: / 14-05-2005 / 21:30:14 / janfrog"
!

isZeroOrMoreNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!ZeroOrMoreNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitZeroOrMoreNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!ZeroOrMoreNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ZeroOrMoreNode.st,v 1.1.1.1 2005-11-01 22:07:17 vranyj1 Exp $'
! !
