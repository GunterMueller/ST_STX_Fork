"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

Object subclass:#UndoSupport
	instanceVariableNames:'actionPerformer transaction undoList redoList
		infoOfCurrentTransaction undoLimit'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

Object subclass:#CompoundAction
	instanceVariableNames:'actions userFriendlyInfo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UndoSupport
!

!UndoSupport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    Framework for undo & redo.
    See concrete usage in EditTextView.

    [author:]
         (cg@betti)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
    See usage in EditTextView
"
! !

!UndoSupport class methodsFor:'instance creation'!

for:anActionPerformer
    ^ self new actionPerformer:anActionPerformer.
!

new
    ^ self basicNew initialize.
! !

!UndoSupport methodsFor:'accessing'!

actionInfo:aString
    infoOfCurrentTransaction := aString
!

undoLimit
    ^ undoLimit
!

undoLimit:something
    undoLimit := something.
! !

!UndoSupport methodsFor:'initialization'!

actionPerformer:something
    actionPerformer := something.
!

initialize
    self resetHistories.
    "/ undoLimit := 1000.
!

resetHistories
    transaction := nil.
    undoList := OrderedCollection new.
    redoList := OrderedCollection new.
! !

!UndoSupport methodsFor:'queries'!

isInTransaction
    ^ transaction notNil

    "Created: / 30-04-2016 / 20:31:04 / cg"
!

transactionNotEmpty
    ^ transaction notEmptyOrNil

    "Created: / 30-04-2016 / 20:47:53 / cg"
! !

!UndoSupport methodsFor:'undo & again'!

addUndo:action
    transaction notNil ifTrue:[
        transaction add:action
    ].
!

addUndoFirst:action
    transaction notNil ifTrue:[
        transaction addFirst:action
    ].

    "Created: / 30-04-2016 / 20:50:53 / cg"
!

closeTransactionAndAddTo:anUndoList
    "at the end of an operation, check the individual undo actions
     and add them to the given undoList.
     (either individually or as a compound undo action).
     Check if the new action(s) can be combined with the previous und action into one
     (this is done for individual keystrokes and character-deletions)"
     
    |anythingToUndo actionToAdd lastAction canCombine|
        
    anythingToUndo := false.
    transaction notEmptyOrNil ifTrue:[
        anythingToUndo := transaction size > 1
                          or:[ transaction first isRestoreSelectionAndCursor not].
    ].                    
    anythingToUndo ifTrue:[
        canCombine := false.
        
        anUndoList isEmpty ifTrue:[
            "/ nothing yet
            transaction size > 2 ifTrue:[ 
                actionToAdd := (CompoundAction new actions:transaction).
                actionToAdd info:infoOfCurrentTransaction.
                anUndoList add: actionToAdd
            ] ifFalse:[
                anUndoList addAll:transaction
            ].
        ] ifFalse:[
            "/ append new actions
            (infoOfCurrentTransaction isNil and:[ transaction size == 1 ]) ifTrue:[
                actionToAdd := transaction first.

                lastAction := anUndoList last.
                canCombine := lastAction perform:#canCombineWithNext: with:actionToAdd ifNotUnderstood:false.
            ] ifFalse:[
                (infoOfCurrentTransaction isNil 
                and:[ transaction size == 2 
                and:[ transaction first isRestoreSelectionAndCursor 
                and:[ undoList contains:[:op | op isRestoreSelectionAndCursor] ]]]) ifTrue:[
                    actionToAdd := transaction second.

                    lastAction := anUndoList last.
                    canCombine := lastAction perform:#canCombineWithNext: with:actionToAdd ifNotUnderstood:false.
                ] ifFalse:[
                    actionToAdd := (CompoundAction new actions:transaction).
                    actionToAdd info:infoOfCurrentTransaction.
                ].
            ].
            canCombine ifTrue:[
                lastAction combineWithNext:actionToAdd.
            ] ifFalse:[
                anUndoList add:actionToAdd.
                (undoLimit notNil and:[anUndoList size > undoLimit]) ifTrue:[
                    Transcript showCR:'forget old undo-action'.
                    anUndoList removeFirst.
                ].
            ].
        ].
    ].
    infoOfCurrentTransaction := nil.
    transaction := nil

    "Modified: / 17-03-2017 / 22:40:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeActionFrom:doList addUndoTo:unDoList
    |action previousTransaction|

    doList notEmptyOrNil ifTrue:[
        action := doList removeLast.

        previousTransaction := transaction.
        [
            transaction := OrderedCollection new.

            action executeIn:actionPerformer.

            self closeTransactionAndAddTo:unDoList.
        ] ensure:[
            transaction := previousTransaction.
        ]
    ]
!

hasRedoAction
    ^ redoList size > 0
!

hasUndoAction
    ^ undoList size > 0
!

lastRedoAction
    ^ redoList removeLast
!

lastUndoAction
    ^ undoList removeLast
!

nonUndoableDo:aBlock
    |prev|

    prev := transaction.
    transaction := nil.
    aBlock 
        ensure:[
            transaction := prev.
        ].
!

redo
    self executeActionFrom:redoList addUndoTo:undoList
!

redoActionInfo
    ^ redoList last info
!

undo
    self executeActionFrom:undoList addUndoTo:redoList
!

undoActionInfo
    ^ undoList last info
!

undoableDo:aBlock
    self undoableDo:aBlock info:nil.
!

undoableDo:aBlock info:aString
    transaction notNil ifTrue:[
        infoOfCurrentTransaction := infoOfCurrentTransaction ? aString.
        aBlock value.
    ] ifFalse:[
        transaction := OrderedCollection new.
        infoOfCurrentTransaction := aString.
        aBlock 
            ensure:[  
                self closeTransactionAndAddTo:undoList.
            ].
    ].
! !

!UndoSupport::CompoundAction methodsFor:'accessing'!

info
    ^ userFriendlyInfo
!

info:aString
    userFriendlyInfo := aString
! !

!UndoSupport::CompoundAction methodsFor:'adding'!

actions:aCollection
    actions := aCollection
!

add:action
    actions isNil ifTrue:[
        actions := OrderedCollection new.
    ].
    actions add:action
! !

!UndoSupport::CompoundAction methodsFor:'execution'!

executeIn:editor 
    actions reverseDo:[:each | each executeIn:editor ]
! !

!UndoSupport::CompoundAction methodsFor:'queries'!

canCombineWithNext:nextAction
    ^ false.
!

isRestoreSelectionAndCursor
    ^ false.
! !

!UndoSupport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

