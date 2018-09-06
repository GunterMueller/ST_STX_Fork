"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

MessageNode subclass:#CascadeNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!CascadeNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    node for parse-trees, representing cascade message sends
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!CascadeNode methodsFor:'*VMMaker-C translation'!

asTranslatorNodeIn: aTMethod
        "make a CCodeGenerator equivalent of me"

        ^Squeak::TStmtListNode new
                setArguments: #()
                statements:
                        (Array streamContents:
                                [:s| | receiverNode |
                                receiverNode := self realReceiver "receiver" asTranslatorNodeIn: aTMethod.   
                                receiverNode isLeaf ifFalse:
                                        [| varNode |

                                         varNode := aTMethod newCascadeTempFor: receiverNode.
                                         s nextPut: (Squeak::TAssignmentNode new
                                                                setVariable: varNode
                                                                expression: receiverNode).
                                        receiverNode := varNode].
                                self messages do:
                                        [ :msg | s nextPut: ((msg asTranslatorNodeIn: aTMethod) receiver: receiverNode)]]);
                comment: ((comments ? #()) firstIfEmpty:nil)

    "Modified: / 14-09-2011 / 10:41:14 / cg"
!

realReceiver
    "return the real receiver
     (sigh; ST/X encodes things differently)"

    |r|

    r := receiver.
    [r isCascade] whileTrue:[
        r := r receiver.
    ].
    ^ r receiver

    "Created: / 12-09-2011 / 10:01:48 / cg"
! !

!CascadeNode methodsFor:'code generation'!

codeForCascadeOn:aStream inBlock:b for:aCompiler
    "the old code could lead to a recursion error with
     long cascades;
     the new code does not."

    "/ old
    "/ receiver codeForCascadeOn:aStream inBlock:b for:aCompiler.
    "/ aStream nextPut:#dup.
    "/ self codeSendOn:aStream inBlock:b valueNeeded:false for:aCompiler

    "/ new
    |leftMostExpression sequence|

    leftMostExpression := receiver.
    sequence := OrderedCollection new.
    [ leftMostExpression isCascade ] whileTrue:[
        sequence addFirst:leftMostExpression.
        leftMostExpression := leftMostExpression receiver.
    ].
    
    leftMostExpression codeForCascadeOn:aStream inBlock:b for:aCompiler.
    sequence do:[:eachCascade |
        aStream nextPut:#dup.
        eachCascade codeSendOn:aStream inBlock:b valueNeeded:false for:aCompiler.
    ].
    aStream nextPut:#dup.
    self codeSendOn:aStream inBlock:b valueNeeded:false for:aCompiler.

    "Modified: / 08-08-2017 / 18:04:48 / cg"
!

codeOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    receiver codeForCascadeOn:aStream inBlock:b for:aCompiler.
    self codeSendOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
! !

!CascadeNode methodsFor:'enumerating'!

messages
    "helper for parse tree walking"

    "/ sigh; ST/X encodes things differently ...

    |r nd msgs|

    msgs := OrderedCollection new.

    r := receiver.
    [r isCascade] whileTrue:[
        r := r receiver.
    ].
    r := r receiver.

    nd := self.
    [nd isCascade] whileTrue:[
        msgs addFirst:(MessageNode receiver:r selector:nd selector args:nd args lineno:nd lineNumber).
        nd := nd receiver.
    ].
    msgs addFirst:(MessageNode receiver:r selector:nd selector args:nd args lineno:nd lineNumber).

    ^ msgs

    "Created: / 12-09-2011 / 10:04:31 / cg"
    "Modified: / 26-03-2018 / 15:36:30 / stefan"
!

nodeDo:anEnumerator
    "helper for parse tree walking"

    "/ sigh; ST/X encodes things differently ...

    |r nd msgs|

    msgs := OrderedCollection new.

    r := receiver.
    [r isCascade] whileTrue:[
        r := r receiver.
    ].
    r := r receiver.

    nd := self.
    [nd isCascade] whileTrue:[
        msgs addFirst:(MessageNode receiver:r selector:nd selector args:nd args lineno:nd lineNumber).
        nd := nd receiver.
    ].
    msgs addFirst:(MessageNode receiver:r selector:nd selector args:nd args lineno:nd lineNumber).

    ^ anEnumerator doCascade:self receiver:r messages:msgs

    "Created: / 19-06-1997 / 16:39:17 / cg"
    "Modified: / 26-03-2018 / 15:37:12 / stefan"
! !

!CascadeNode methodsFor:'evaluation'!

evaluateForCascadeIn:anEnvironment
    |t argValueArray leftMostExpression sequence|

    selector := selector asSymbol.

    receiver isSuper ifTrue:[
        ^ super evaluateForCascadeIn:anEnvironment
    ].

    "/ new code: avoids recursion error for long cascades
    leftMostExpression := receiver.
    sequence := OrderedCollection new.
    [leftMostExpression isCascade] whileTrue:[
        sequence addFirst:leftMostExpression.
        leftMostExpression := leftMostExpression receiver.
    ].
    
    t := leftMostExpression evaluateForCascadeIn:anEnvironment. 
    sequence do:[:eachCascadeMessage |
        |eachSelector eachArgArray eachArgValueArray|
        
        eachSelector := eachCascadeMessage selector.
        eachArgArray := eachCascadeMessage arguments.
        eachArgArray size == 0 ifTrue:[
            t perform:eachSelector.
        ] ifFalse:[
            eachArgValueArray := eachArgArray collect:[:arg | arg evaluateIn:anEnvironment]. 
            t perform:eachSelector withArguments:eachArgValueArray.
        ].    
    ].
    
    "/ old code
"/    t := receiver evaluateForCascadeIn:anEnvironment.

    argArray isNil ifTrue:[
        t perform:selector.
        ^ t
    ].
    argValueArray := argArray collect:[:arg | arg evaluateIn:anEnvironment]. 
    t perform:selector withArguments:argValueArray.
    ^ t

    "Modified: / 08-08-2017 / 18:18:09 / cg"
!

evaluateIn:anEnvironment
    |t argValueArray|

    selector := selector asSymbol.

    receiver isSuper ifTrue:[
        ^ super evaluateIn:anEnvironment
    ].

    t := receiver evaluateForCascadeIn:anEnvironment.
    argArray isNil ifTrue:[
        ^ t perform:selector.
        "/ t perform:selector. ^ t
    ].
    argValueArray := argArray collect:[:arg | arg evaluateIn:anEnvironment].
    ^ t perform:selector withArguments:argValueArray
! !

!CascadeNode methodsFor:'printing & storing'!

printMessagePartOn:aStream indent:i 
    |selectorParts|

    selectorParts := selector asCollectionOfSubstringsSeparatedBy:$:.
    selectorParts last isEmpty ifTrue:[selectorParts := selectorParts copyButLast:1].

    argArray size == 0 ifTrue:[
        selector printOn:aStream
    ] ifFalse:[
        argArray 
            with:selectorParts
            do:[:arg :selPart | 
                aStream 
                    space;
                    nextPutAll:selPart;
                    nextPutAll:': '.
                arg 
                    printOn:aStream 
                    indent:i + 4 
                    parenthized:(arg precedence <= self precedence).
            ]
    ]

    "Created: / 08-08-2017 / 18:24:11 / cg"
!

printOn:aStream indent:i 
    |leftMostExpression sequence|

    "/ new code:

    leftMostExpression := receiver.
    sequence := OrderedCollection new.
    [leftMostExpression isCascade] whileTrue:[
        sequence addFirst:leftMostExpression.
        leftMostExpression := leftMostExpression receiver.
    ].

    leftMostExpression printOn:aStream indent:i.
    aStream nextPutAll:'; '.

    sequence do:[:eachCascadeMessage |
        eachCascadeMessage printMessagePartOn:aStream indent:i.
        aStream nextPutAll:'; '.
    ].
    self printMessagePartOn:aStream indent:i

    "/ old code:
    
    "/ receiver printOn:aStream indent:i.
    "/ aStream nextPutAll:'; '.
    "/ self printMessagePartOn:aStream indent:i

    "Modified: / 08-08-2017 / 18:27:21 / cg"
! !

!CascadeNode methodsFor:'testing'!

isCascade
    ^ true

    "Created: / 16.7.1998 / 20:03:51 / cg"
! !

!CascadeNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitCascadeNode:self
! !

!CascadeNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

