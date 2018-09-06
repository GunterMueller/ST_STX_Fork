"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCASTUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Support'
!


!PPCASTUtilities methodsFor:'checks'!

checkNodeIsFunctional: anRBBlockNode inClass: aClaas
    "Check whether the given node is purely functional or not. 
     If no, raise an erorr. If not, this method is noop.

     A block is purely functional if and only if:
       (i) it does not refer to any instance or class variable or non-local variable
      (ii) all self-sends within the block are to 'purely-functional' methods
           (transitively)
     (iiI) contains no super-sends.
    "
    | allDefinedVarNames allInstVarNames allClassVarNames cls |

    allDefinedVarNames := anRBBlockNode allDefinedVariables.
    allInstVarNames := Set new.
    allClassVarNames := Set new.
    cls := aClaas.
    [ cls notNil ] whileTrue:[ 
        | instanceVariables classVariables |
                
        instanceVariables := cls instanceVariables.
        classVariables := cls classVariables.
        instanceVariables notNil ifTrue:[
            allInstVarNames addAll: instanceVariables.
        ]. 
        classVariables notNil ifTrue:[
            allClassVarNames addAll: classVariables.
        ].
        cls := cls superclass.
    ].

    self withAllVariableNodesOf: anRBBlockNode  do: [ :node | 
        (allDefinedVarNames includes: node name) ifFalse:[ 
            (allInstVarNames includes: node name) ifTrue:[
                PPCCompilationError new signal: 'code refers to an instance variable named `',node name,'`'.
                ^ self.
            ].
            (allClassVarNames includes: node name) ifTrue:[
                PPCCompilationError new signal: 'code refers to a class variable named `',node name,'`'.
                ^ self.
            ].
            (Smalltalk includesKey: node name asSymbol) ifFalse:[ 
                PPCCompilationError new signal: 'code refers to an unknown variable named `',node name,'`'.
                ^ self.                    
            ].
        ]
    ].
    self withAllMessageNodesOf: anRBBlockNode sentToSelfDo:[:node |
        | method |
        
        method := aClaas lookupSelector: node selector.
        method isNil ifTrue:[
            PPCCompilationError new signal: 'code contains self-send to non-existent method'.        
            ^ self
        ].
        self checkNodeIsFunctional: method parseTree inClass: method methodClass.
    ].      
    self withAllSuperNodesOf: anRBBlockNode do: [ :node | 
        PPCCompilationError new signal: 'code contains a super-send'.
        ^ self
    ].

    "Created: / 27-07-2015 / 12:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 02:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCASTUtilities methodsFor:'enumerating'!

withAllMessageNodesOf: anRBProgramNode do: aBlock
    "Enumerate all chilren of `anRBProgramNode` (including itself)
     and evaluate `aBlock` for each message node."

    self withAllNodesOf: anRBProgramNode suchThat: [ :node | node isMessage ] do: aBlock.

    "Created: / 18-06-2015 / 22:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2015 / 11:26:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllMessageNodesOf: anRBProgramNode sentToSelfDo: aBlock
    "Enumerate all chilren of `anRBProgramNode` (including itself)
     and evaluate `aBlock` for each message node which sends a message
     to self (i.e., for self-sends)."

    self withAllNodesOf: anRBProgramNode suchThat: [ :node | node isMessage and:[node receiver isSelf ] ] do: aBlock.

    "Created: / 27-07-2015 / 14:41:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllNodesOf: node suchThat: predicate do: action
    "Enumerate all chilren of `node` (including itself)
     and evaluate `aBlock` for each node for which `predicate` returns true."

    (predicate value: node) ifTrue:[ 
        action value: node.
    ].
    node children do:[:each | 
        self withAllNodesOf: each suchThat: predicate do: action
    ].

    "Created: / 18-06-2015 / 22:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2015 / 11:26:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllSelfNodesOf: anRBProgramNode do: aBlock
    "Enumerate all chilren of `anRBProgramNode` (including itself)
     and evaluate `aBlock` for each `self` node."

    self withAllNodesOf: anRBProgramNode suchThat: [ :node | node isSelf ] do: aBlock.

    "Created: / 18-06-2015 / 22:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2015 / 11:26:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllSuperNodesOf: anRBProgramNode do: aBlock
    "Enumerate all chilren of `anRBProgramNode` (including itself)
     and evaluate `aBlock` for each `super` node."

    self withAllNodesOf: anRBProgramNode suchThat: [ :node | node isSuper ] do: aBlock.

    "Created: / 27-07-2015 / 14:42:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllVariableNodesOf: anRBProgramNode do: aBlock
    "Enumerate all chilren of `anRBProgramNode` (including itself)
     and evaluate `aBlock` for each variable node.
     This is a replacement for Smalltalk/X's RBProgramNode>>variableNodesDo:
     which is not present in Pharo"

    self withAllNodesOf: anRBProgramNode suchThat: [ :node | node isVariable and:[node isSelf not and:[node isSuper not]]] do: aBlock.

    "Created: / 18-06-2015 / 22:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2015 / 11:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCASTUtilities class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

