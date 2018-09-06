"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

BinaryTreeNode subclass:#AATreeNode
	instanceVariableNames:'level'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!AATreeNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    I represent nodes in an AA tree, which is a form of balanced tree used for storing and retrieving ordered data efficiently.
    AA trees are named for Arne Andersson, their inventor.
    See details in AATree
"
! !

!AATreeNode class methodsFor:'instance creation'!

data:dataArg level:levelArg
    ^ self basicNew data:dataArg level:levelArg
! !

!AATreeNode methodsFor:'accessing'!

data:dataArg level:levelIntegerArg
    data := dataArg.
    level := levelIntegerArg.
!

level
    ^ level
!

level:anInteger
    level := anInteger.
! !

!AATreeNode methodsFor:'helpers'!

decrease_level
"/    function decrease_level is
"/        input: T, a tree for which we want to remove links that skip levels.
"/        output: T with its level decreased.
"/
"/        should_be = min(level(left(T)), level(right(T))) + 1
"/        if should_be < level(T) then
"/            level(T) := should_be
"/            if should_be < level(right(T)) then
"/                level(right(T)) := should_be
"/            end if
"/        end if
"/        return T
"/    end function

    |shouldBe leftLevel rightLevel|

    leftLevel := leftSubtree isNil ifTrue:[0] ifFalse:[leftSubtree level].
    rightLevel := rightSubtree isNil ifTrue:[0] ifFalse:[rightSubtree level].
    shouldBe := (leftLevel min:rightLevel) + 1.
    shouldBe < level ifTrue:[
        level := shouldBe.
        shouldBe < rightLevel ifTrue:[
            rightSubtree level:shouldBe
        ].
    ].
!

insert:anObject usingSortBlock:sortBlock
"/    function insert is
"/        input: X, the value to be inserted, and T, the root of the tree to insert it into.
"/        output: A balanced version T including X.
"/
"/        Do the normal binary tree insertion procedure.  Set the result of the
"/        recursive call to the correct child in case a new node was created or the
"/        root of the subtree changes.
"/        if nil(T) then
"/            Create a new leaf node with X.
"/            return node(X, 1, Nil, Nil)
"/        else if X < value(T) then
"/            left(T) := insert(X, left(T))
"/        else if X > value(T) then
"/            right(T) := insert(X, right(T))
"/        end if
"/        Note that the case of X == value(T) is unspecified.  As given, an insert
"/        will have no effect.  The implementor may desire different behavior.
"/
"/        Perform skew and then split.  The conditionals that determine whether or
"/        not a rotation will occur or not are inside of the procedures, as given
"/        above.
"/        T := skew(T)
"/        T := split(T)
"/
"/        return T
"/    end function

    (sortBlock value:anObject value:data) ifTrue:[
        leftSubtree isNil ifTrue:[
            leftSubtree := self class data:anObject level:1
        ] ifFalse:[
            leftSubtree := (leftSubtree insert:anObject usingSortBlock:sortBlock)
        ].
    ] ifFalse:[
        rightSubtree isNil ifTrue:[
            rightSubtree := self class data:anObject level:1
        ] ifFalse:[
            rightSubtree := (rightSubtree insert:anObject usingSortBlock:sortBlock)
        ]
    ].

    ^ self skew split.

    "Modified: / 05-08-2012 / 11:40:23 / cg"
!

removeValue:oldValue using:equalSelector sortBlock:sortBlock
    "remove a value - returns a new treeNode, or nil if the value is not in the tree"

    |nextValue prevValue newTop rr thisIsMyNode newLeftSubtree newRightSubtree|

"/    function delete is
"/        input: X, the value to delete, and T, the root of the tree from which it should be deleted.
"/        output: T, balanced, without the value X.
"/
"/        if X > value(T) then
"/            right(T) := delete(X, right(T))
"/        else if X < value(T) then
"/            left(T) := delete(X, left(T))
"/        else
"/            If we're a leaf, easy, otherwise reduce to leaf case. 
"/            if leaf(T) then
"/                return Nil
"/            else if nil(left(T)) then
"/                L := successor(T)
"/                right(T) := delete(L, right(T))
"/                value(T) := L
"/            else
"/                L := predecessor(T)
"/                left(T) := delete(L, left(T))
"/                value(T) := L
"/            end if
"/        end if
"/
"/        Rebalance the tree.  Decrease the level of all nodes in this level if
"/        necessary, and then skew and split all nodes in the new level.
"/        T := decrease_level(T)
"/        T := skew(T)
"/        right(T) := skew(right(T))
"/        right(right(T)) := skew(right(right(T)))
"/        T := split(T)
"/        right(T) := split(right(T))
"/        return T
"/    end function

    "/ speed hack - avoids message sends (and also better inline caching)
    equalSelector == #== ifTrue:[
        thisIsMyNode := (data == oldValue).
    ] ifFalse:[
        equalSelector == #= ifTrue:[
            thisIsMyNode := (data = oldValue).
        ] ifFalse:[
            thisIsMyNode := data perform:equalSelector with:oldValue.
        ].
    ].

    thisIsMyNode ifTrue:[
        leftSubtree isNil ifTrue:[
            rightSubtree isNil ifTrue:[
                ^ nil
            ].
            nextValue := rightSubtree leftMostNode data.
            rightSubtree := (rightSubtree removeValue:nextValue using:equalSelector sortBlock:sortBlock).
            data := nextValue.
        ] ifFalse:[
            prevValue := leftSubtree rightMostNode data.
            leftSubtree := (leftSubtree removeValue:prevValue using:equalSelector sortBlock:sortBlock).
            data := prevValue.
        ].
    ] ifFalse:[
        (sortBlock value:oldValue value:data) ifTrue:[
            "/ the value should be in the left part.
            leftSubtree isNil ifTrue:[
                ^ nil.
            ].
            newLeftSubtree := leftSubtree removeValue:oldValue using:equalSelector sortBlock:sortBlock.
            newLeftSubtree isNil ifTrue:[
                (leftSubtree data perform:equalSelector with:oldValue) ifFalse:[
                    ^ nil
                ].
            ].
            leftSubtree := newLeftSubtree.
        ] ifFalse:[
            "/ the value should be in the right part.
            rightSubtree isNil ifTrue:[
                ^ nil.
            ].
            newRightSubtree := rightSubtree removeValue:oldValue using:equalSelector sortBlock:sortBlock.
            newRightSubtree isNil ifTrue:[
                (rightSubtree data perform:equalSelector with:oldValue) ifFalse:[
                    ^ nil
                ].
            ].
            rightSubtree := newRightSubtree.
        ].
    ].

    self decrease_level.
    newTop := self skew.
    (rr := newTop rightSubtree) notNil ifTrue:[
        newTop rightSubtree:(rr skew).
        (rr := newTop rightSubtree rightSubtree) notNil ifTrue:[
            newTop rightSubtree rightSubtree:(rr skew).
        ].
    ].
    newTop := newTop split.
    (rr := newTop rightSubtree) notNil ifTrue:[
        newTop rightSubtree:(rr split).
    ].
    ^ newTop
!

skew
    |oldLeft|

"/    function skew is
"/        input: T, a node representing an AA tree that needs to be rebalanced.
"/        output: Another node representing the rebalanced AA tree.
"/
"/        if nil(T) then
"/            return Nil
"/        else if level(left(T)) == level(T) then
"/            Swap the pointers of horizontal left links.
"/            L = left(T)
"/            left(T) := right(L)
"/            right(L) := T
"/            return L
"/        else
"/            return T
"/        end if
"/    end function

    leftSubtree isNil ifTrue:[^ self].
    leftSubtree level == level ifTrue:[
        oldLeft := leftSubtree.
        leftSubtree := (oldLeft rightSubtree).
        oldLeft rightSubtree:self.
        ^ oldLeft
    ].
    ^ self
!

split
    |oldRight oldRightRight|

"/    function split is
"/        input: T, a node representing an AA tree that needs to be rebalanced.
"/        output: Another node representing the rebalanced AA tree.
"/
"/        if nil(T) then
"/            return Nil
"/        else if level(T) == level(right(right(T))) then
"/            We have two horizontal right links.  Take the middle node, elevate it, and return it.
"/            R = right(T)
"/            right(T) := left(R)
"/            left(R) := T
"/            level(R) := level(R) + 1
"/            return R
"/        else
"/            return T
"/        end if
"/    end function

    rightSubtree isNil ifTrue:[^ self].
    oldRightRight := rightSubtree rightSubtree.
    oldRightRight isNil ifTrue:[^ self].
    level == oldRightRight level ifTrue:[
        oldRight := rightSubtree.
        rightSubtree := oldRight leftSubtree.
        oldRight leftSubtree:self.
        oldRight level:(oldRight level + 1).
        ^ oldRight
    ].
    ^ self
! !

!AATreeNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

