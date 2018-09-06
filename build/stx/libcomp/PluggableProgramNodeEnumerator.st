"{ Package: 'stx:libcomp' }"

ProgramNodeEnumerator subclass:#PluggableProgramNodeEnumerator
	instanceVariableNames:'plugs'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!


!PluggableProgramNodeEnumerator methodsFor:'configuration'!

nodesForWhich:aCheckBlock do:actionBlock
    plugs isNil ifTrue:[
        plugs := OrderedCollection new.
    ].
    plugs add:{ aCheckBlock. actionBlock. }.
! !

!PluggableProgramNodeEnumerator methodsFor:'enumeration callbacks'!

doAssignment:aNode variable:var value:val
    self evaluatePlugsFor:aNode.
    self doNode:val.
!

doBlock:aNode arguments:args body:seq
    self evaluatePlugsFor:aNode.
    seq notNil ifTrue:[
        self doNode:seq.
    ]
!

doCascade:aNode receiver:rcvr messages:msgs
    self evaluatePlugsFor:aNode.
    msgs do:[:eachMessage | 
        self doNode:eachMessage
    ].
!

doLiteral:aNode value:lit
    self evaluatePlugsFor:aNode.
!

doMessage:aNode receiver:rcvr selector:sel arguments:args
    self evaluatePlugsFor:aNode.
    self doNode:rcvr.
    args do:[:eachArg |
        self doNode:eachArg
    ].
!

doMethod:aNode selector:sel primitive:prim block:block
    self evaluatePlugsFor:aNode.
!

doPrimitive:aNode code:code primitiveIndex:primNumber
    self evaluatePlugsFor:aNode.
!

doReturn:aNode value:value
    self evaluatePlugsFor:aNode.
    self doNode:value
!

doVariable:aNode name:nameString
    self evaluatePlugsFor:aNode.
! !

!PluggableProgramNodeEnumerator methodsFor:'private'!

evaluatePlugsFor:aNode
    plugs do:[:eachPair |
        |check action|
        
        check := eachPair first.
        action := eachPair second.
        (check value:aNode) ifTrue:[
            action value:aNode.
        ].
    ].
! !

!PluggableProgramNodeEnumerator class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/PluggableProgramNodeEnumerator.st,v 1.1 2009-10-09 13:10:15 cg Exp $'
! !
