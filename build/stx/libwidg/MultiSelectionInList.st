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
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

SelectionInList subclass:#MultiSelectionInList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!MultiSelectionInList class methodsFor:'documentation'!

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
    Like a selectionInList, but allows for multiple selected items.
    For use as a model for SelectionInListViews, with multipleSelectOk set to true.

    [author:]
        Claus Gittinger
"
! !

!MultiSelectionInList methodsFor:'accessing-values'!

selection
    "return the selections value (i.e. the entry numbers in the list)"

    |l s|

    (     (l := self list) isNil                                "/ mhmh - no list; what should we do here ?
      or:[(s := selectionIndexHolder value) size == 0]          "/ mhmh - can be nil ?
    ) ifTrue:[
        ^ self zeroIndex
    ].

    ^ s collect:[:index | l at:index ]

    "Created: 26.10.1995 / 16:52:27 / cg"
    "Modified: 20.4.1996 / 13:14:29 / cg"
!

selection:anObjectList 
    "set the selection to be anObjectList."

    |l indizes objList|

    "/
    "/ for your convenience: allow 0 and nil as empty
    "/ selections
    "/
    anObjectList size == 0 ifTrue:[
        (anObjectList isCollection or:[anObjectList isNil]) ifTrue:[
            ^ self selectionIndex:#()
        ].
        objList := Array with:anObjectList
    ] ifFalse:[
        objList := anObjectList
    ].

    l := self list.
    l isNil ifTrue:[^ self].   "/ mhmh - no list; what should we do here ?

    indizes := OrderedCollection new.
    objList do:[:o |
        |idx|

        idx := l indexOf:o ifAbsent:0.
        idx ~~ 0 ifTrue:[
            indizes add:idx
        ].
    ].
    ^ self selectionIndex:indizes

    "Created: 26.10.1995 / 16:40:24 / cg"
    "Modified: 25.4.1996 / 09:07:44 / cg"
!

selectionIndex:indexes
    "set the list of indexes"

    |newIndices|

    indexes size ~~ 0 ifTrue:[
        newIndices := indexes.
    ] ifFalse:[
        indexes isNumber ifTrue:[
            newIndices := OrderedCollection with:indexes    
        ] ifFalse:[
            newIndices := #()
        ].
    ].
    ^ super selectionIndex:newIndices
!

selectionIndexes
    "added for ST-80 compatibility
    "
    ^ self selectionIndex value
!

selectionIndexes:indizes
    "added for ST-80 compatibility
    "
    ^ self selectionIndex:indizes
! !

!MultiSelectionInList methodsFor:'queries'!

numberOfSelections
    "return the number of selected entries
    "
    ^ selectionIndexHolder value size

!

zeroIndex
    "return the selectionIndex returned when nothing is selected.
     Here, an empty collection is returned."

    ^ #()

    "Modified: 20.4.1996 / 13:12:58 / cg"
! !

!MultiSelectionInList methodsFor:'selections'!

clearAll
    "ST80 compatibility"

    self selection:nil.
!

selectAll
    "ST80 compatibility"

    |indizes size|

    (size := listHolder value size) == 0 ifTrue:[
        ^ self clearAll
    ].

    indizes := Array new:size.
    1 to:size do:[:i| indizes at:i put:i].
    self selectionIndex:indizes.
!

selections
    <resource: #obsolete>
    "obsolete - almost the same as selection"

    |selectionIndices|

    self obsoleteMethodWarning.

    selectionIndices := selectionIndexHolder value.
    (selectionIndices isNil
     or:[selectionIndices == 0     
     or:[selectionIndices isEmpty]]) ifFalse:[
        ^ selectionIndices collect:[:index | listHolder value at:index]
    ].
    ^ #()

    "Modified: 25.4.1996 / 09:09:45 / cg"
!

selections:aCollection
    "ST80 compatibility"

    ^ self selection:aCollection

    "Created: / 8.11.1997 / 12:55:23 / cg"
! !

!MultiSelectionInList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

