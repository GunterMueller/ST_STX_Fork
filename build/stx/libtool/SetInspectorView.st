"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

InspectorView subclass:#SetInspectorView
	instanceVariableNames:'keys'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!SetInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger / eXept Software AG
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
    A modified inspector for Sets

    [author:]
        Stefan Vogel
"
!

examples
"
    #(a b c d e) asSet inspect
"
! !

!SetInspectorView methodsFor:'menu'!

fieldMenu
    <resource: #programMenu >

    |menu|

    menu := super fieldMenu.
    menu addLabels:#(
                       '-'
                       'Remove element'
                   )
         selectors:#(
                       nil 
                       doRemoveKey
                   ).

    (self keyIndexForLine:selectionIndex) isNil ifTrue:[
        menu disableAll:#(doRemoveKey)
    ].

    ^ menu

    "Modified: / 29.10.1997 / 03:41:47 / cg"
! !

!SetInspectorView methodsFor:'private'!

baseInspectedObjectClass
    (inspectedObject class inheritsFrom:Set) ifTrue:[
        ^ Set
    ].
    ^ Object
!

defaultLabel
    ^ 'Contents'

    "
     (Set with:1 with:2 with:3) inspect
    "

    "Modified: 28.6.1996 / 16:05:42 / cg"
!

derivedFields
    ^ super derivedFields
"/
"/ size is already there
"/    ^ Dictionary new
"/        declareAllNewFrom:(super derivedFields ? #());
"/        add:('-size' -> [ object size ]);
"/        yourself

    "Modified: / 09-10-2006 / 12:27:21 / cg"
!

indexList 
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    inspectedObject size > nShown ifTrue:[
        |coll|

        coll := (SortedCollection new:nShown) sortBlock:[:a :b | a displayString < b displayString].
        inspectedObject do:[:el |
            coll add:el.
            coll size >= nShown ifTrue:[ 
                hasMore := true.
                ^ coll
            ].
        ].
    ].

    ^ inspectedObject asSortedCollection:[:a :b | a displayString < b displayString].
!

indexedFieldList 
    "return a list of indexed-variable names to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    keys := self indexList.
    ^ keys collect:[:k | k displayString].
!

numIndexedFields
    ^ inspectedObject size
!

release 
    "release inspected object"

    keys := nil.
    super release

    "Created: 9.2.1996 / 12:04:30 / stefan"
!

showAllIndexedVarsInFieldList
    ^ true
! !

!SetInspectorView methodsFor:'queries'!

isIndexShown
    ^ false
! !

!SetInspectorView methodsFor:'user interaction'!

doRemoveKey
    "remove selected item from keys"

    |key idx|

    idx := self keyIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        key := keys at:idx.
        (inspectedObject includes:key) ifTrue:[
            listView cursor:(Cursor wait).
            inspectedObject remove:key.
            keys := nil.
            selectionIndex := selectedLine := nil.
            inspectedObject changed.
            listView cursor:(Cursor hand).
            self reinspect.
        ].
    ]


!

indexedValueAtIndex:idx
    ^ keys at:idx
!

indexedValueAtKey:idx
    ^ idx
!

valueAtLine:lineNr put:newValue
    "store newValue;
     For non-named instvars, we add the new value - ignoring the selection"

    |idx|

    idx := self instVarIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        inspectedObject instVarAt:idx put:newValue.
    ] ifFalse:[
        inspectedObject add:newValue.

"/        inspectedObject changed.
        self reinspect.
    ].


! !

!SetInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: SetInspectorView.st 8074 2012-11-30 17:23:39Z vranyj1 $'
! !

