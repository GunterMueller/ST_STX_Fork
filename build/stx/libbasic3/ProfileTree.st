"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ProfileTree
	instanceVariableNames:'receiver selector class leafTally totalTally called isBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!ProfileTree class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This is is used as a companion to MessageTally.
    Instances of it are used to represent a calling chain.
    (MessageTally could have used the contexts themself, but these
     may create more overhead)

    [author:]
        Claus Gittinger

    [see also:]
        MessageTally CallChain
        MessageTracer
        AbstractTime
"
! !

!ProfileTree methodsFor:'accessing'!

called
    "return the trees of the called methods/blocks"

    ^ called

    "Modified: 18.5.1996 / 19:00:59 / cg"
!

called:aCollection
    "set the trees of the called methods/blocks"

    called := aCollection

    "Modified: 18.5.1996 / 19:01:08 / cg"
!

isBlock 
    "return true, if this is a tree for a block-context"

    ^ isBlock

    "Modified: 18.5.1996 / 18:59:12 / cg"
!

leafTally
    "return true, if this is a leaf"

    ^ leafTally

    "Modified: 18.5.1996 / 19:01:27 / cg"
!

methodClass 
    "return the contexts methods class"

    ^ class

    "Modified: 18.5.1996 / 19:01:40 / cg"
!

receiver
    "return the contexts receiver"

    ^ receiver

    "Modified: 18.5.1996 / 19:01:45 / cg"
!

receiver:r selector:s class:cls isBlock:blk
    "private tally interface - set receiver, selector, class
     and the block flag."

    receiver := r.
    selector := s.
    class := cls.
    isBlock := blk.
    leafTally := totalTally := 0.

    "Modified: 20.3.1997 / 20:46:19 / cg"
!

selector 
    "return the contexts selector"

    ^ selector

    "Modified: 18.5.1996 / 19:02:04 / cg"
!

totalTally
    "return the total tally counter"

    ^ totalTally

    "Modified: 18.5.1996 / 19:02:15 / cg"
! !

!ProfileTree methodsFor:'adding info'!

addChain:aCallChain
    "{ Pragma: +optSpeed }"

    "merge a chain into the receiver's tree"

    |node found subTree chain called|

    node := self.
    chain := aCallChain.

    [chain notNil] whileTrue:[
        node incrementTotalTally.

        found := false.
        (called := node called) notNil ifTrue:[
            called do:[:subTree |
                found ifFalse:[
                    (chain = subTree) ifTrue:[
                        node := subTree.
                        chain := chain rest.
                        found := true
                    ].
                ].
            ].
        ] ifFalse:[
            node called:(called := OrderedCollection new)
        ].
        found ifFalse:[
            subTree := ProfileTree new.
            subTree receiver:chain receiver
                    selector:chain selector
                       class:chain methodClass
                     isBlock:chain isBlock.

            called add:subTree.
            node := subTree.
            chain := chain rest
        ]
    ].

    node incrementTotalAndLeafTally.

    "Modified: 20.3.1997 / 20:45:50 / cg"
!

computePercentage:total
    "compute percentages"

    totalTally := (totalTally / total * 1000) rounded / 10.0.
    leafTally notNil ifTrue:[
        leafTally := (leafTally / total * 1000) rounded / 10.0
    ].

    called notNil ifTrue:[
        called do:[:subTree |
            subTree computePercentage:total
        ]
    ].

    "Modified: 20.3.1997 / 21:32:01 / cg"
!

incrementLeafTally
    "{ Pragma: +optSpeed }"

    "count as leaf"

    leafTally := leafTally + 1.

    "Modified: 20.3.1997 / 20:46:27 / cg"
!

incrementTotalAndLeafTally
    "{ Pragma: +optSpeed }"

    "count as leaf and total"

    leafTally := leafTally + 1.
    totalTally := totalTally + 1.

    "Modified: 20.3.1997 / 20:46:36 / cg"
!

incrementTotalTally
    "{ Pragma: +optSpeed }"

    "count"

    totalTally := totalTally + 1.

    "Modified: 20.3.1997 / 20:46:41 / cg"
!

leafTally:aCount
    "set the leafTally count"

    leafTally := aCount

    "Modified: 18.5.1996 / 19:03:22 / cg"
!

totalTally:aCount
    "set the totalTally count"

    totalTally := aCount

    "Modified: 18.5.1996 / 19:03:30 / cg"
! !

!ProfileTree methodsFor:'prettyPrinting'!

printLeafsOn:aStream
    "print all leafNodes statistics on aStream"

    |leafNodes|

    leafNodes := OrderedCollection new.
    self addLeafNodesTo:leafNodes.
    leafNodes := leafNodes asSortedCollection:[:a :b |
                                        a leafTally < b leafTally].
    leafNodes do:[:aNode |
        aNode leafTally ~= 0 ifTrue:[
            aNode printSingleLeafOn:aStream.
            aStream cr.
        ]
    ].

    "Modified: 20.3.1997 / 21:08:09 / cg"
!

printMethodLeafsOn:aStream
    "print all method leafNodes statistics on aStream"

    |leafNodes|

    leafNodes := OrderedCollection new.
    self addMethodLeafNodesTo:leafNodes.
    leafNodes := leafNodes asSortedCollection:[:a :b |
                                        a leafTally < b leafTally].
    leafNodes do:[:aNode |
        aNode leafTally ~= 0 ifTrue:[
            aNode printSingleMethodLeafOn:aStream.
            aStream cr.
        ].
    ].

    "Created: 19.3.1997 / 12:19:31 / cg"
    "Modified: 20.3.1997 / 21:07:39 / cg"
!

printOn:aStream
    "print statistics on aStream"

    |s|

"/    self printOn:aStream indent:0
    s := WriteStream on:''.
    self printOn:s indent:0.

    aStream nextPutAll:s contents

    "Modified: 18.5.1996 / 19:03:55 / cg"
!

printOn:aStream indent:i
    "print statistics indented on aStream"

    selector notNil ifTrue:[
        aStream spaces:i.
        self printSingleOn:aStream.
        aStream cr.
    ].

    called notNil ifTrue:[
        called do:[:sub|
            sub printOn:aStream indent:(i + 1)
        ].
    ].

    "Modified: 18.5.1996 / 19:04:12 / cg"
!

printSingleLeafOn:aStream
    "print a single nodes statistic on aStream"

    selector notNil ifTrue:[
        isBlock == true ifTrue:[
            '[] in ' printOn:aStream
        ].
        receiver name printOn:aStream.
        (class notNil and:[class ~~ receiver]) ifTrue:[
            '>>' printOn:aStream.
            class name printOn:aStream
        ].
        aStream space.
        selector printOn:aStream.
        aStream space.

        leafTally notNil ifTrue:[
            aStream nextPutAll:'('.
            leafTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ] ifFalse:[
            aStream nextPutAll:'(total '.
            totalTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ].
    ].

    "Created: 19.3.1997 / 19:10:13 / cg"
    "Modified: 19.3.1997 / 19:17:05 / cg"
!

printSingleMethodLeafOn:aStream
    "print a single nodes statistic on aStream"

    |cls|

    selector notNil ifTrue:[
        isBlock == true ifTrue:[
            '[] in ' printOn:aStream
        ].
        (class notNil and:[class ~~ receiver]) ifTrue:[
            cls := class
        ] ifFalse:[
            cls := receiver.
        ].
        cls name printOn:aStream.
        aStream space.
        selector printOn:aStream.
        aStream space.

        leafTally notNil ifTrue:[
            aStream nextPutAll:'('.
            leafTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ] ifFalse:[
            aStream nextPutAll:'(total '.
            totalTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ]
    ].

    "Created: 19.3.1997 / 19:10:32 / cg"
    "Modified: 19.3.1997 / 19:17:13 / cg"
!

printSingleOn:aStream
    "print a single nodes statistic on aStream"

    selector notNil ifTrue:[
        isBlock == true ifTrue:[
            '[] in ' printOn:aStream
        ].
        receiver name printOn:aStream.
        (class notNil and:[class ~~ receiver]) ifTrue:[
            '>>' printOn:aStream.
            class name printOn:aStream
        ].
        aStream space.
        selector printOn:aStream.
        aStream space.

        (leafTally isNil or:[leafTally ~= totalTally]) ifTrue:[
            aStream nextPutAll:'(total '.
            totalTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ].

        leafTally notNil ifTrue:[
            aStream nextPutAll:'(here '.
            leafTally printOn:aStream.
            aStream nextPutAll:'%)'.
        ].
    ].

    "Modified: 19.3.1997 / 19:14:32 / cg"
! !

!ProfileTree methodsFor:'private'!

= aProfileTreeNode
    "return true, if the argument tree is for the same method invocation"

    selector ~~ aProfileTreeNode selector ifTrue:[^ false].
    class ~~ aProfileTreeNode methodClass ifTrue:[^ false].
    receiver ~= aProfileTreeNode receiver ifTrue:[^ false].
    ^ true

    "Modified: 19.3.1997 / 12:23:41 / cg"
!

addLeafNodesTo:aCollection
    "add all leaf nodes to aCollection"

    |idx|

    leafTally notNil ifTrue:[
        idx := aCollection indexOf:self.
        idx == 0 ifTrue:[
            aCollection add:self copy
        ] ifFalse:[
            |nd|

            nd := aCollection at:idx.
            nd leafTally:(nd leafTally + leafTally).
            nd totalTally:(nd totalTally max: totalTally)
        ]
    ].
    called notNil ifTrue:[
        called do:[:aNode |
            aNode addLeafNodesTo:aCollection
        ]
    ]

    "Modified: 19.3.1997 / 12:23:49 / cg"
!

addMethodLeafNodesTo:aCollection
    "add all method leaf nodes to aCollection"

    |idx|

    leafTally notNil ifTrue:[
        idx := aCollection findFirst:[:el | el sameMethodAsIn:self].
        idx == 0 ifTrue:[
            aCollection add:self copy
        ] ifFalse:[
            |nd|

            nd := aCollection at:idx.
            nd leafTally:(nd leafTally + leafTally).
            nd totalTally:(nd totalTally max: totalTally)
        ]
    ].
    called notNil ifTrue:[
        called do:[:aNode |
            aNode addMethodLeafNodesTo:aCollection
        ]
    ]

    "Modified: 19.3.1997 / 12:26:05 / cg"
!

hash
    "return true, if the argument tree is for the same method invocation"

    class notNil ifTrue:[
        ^ selector identityHash bitXor: class identityHash
    ].
    ^ selector identityHash bitXor: receiver identityHash

    "Created: 20.3.1997 / 20:27:15 / cg"
    "Modified: 21.3.1997 / 14:02:27 / cg"
!

sameMethodAsIn:aProfileTreeNode
    "return true, if the argument tree is for the same method invocation"

    selector ~~ aProfileTreeNode selector ifTrue:[^ false].
    class ~~ aProfileTreeNode methodClass ifTrue:[^ false].
    ^ true

    "Created: 19.3.1997 / 12:23:24 / cg"
! !

!ProfileTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id: ProfileTree.st 1909 2012-03-31 00:14:49Z vranyj1 '
! !

