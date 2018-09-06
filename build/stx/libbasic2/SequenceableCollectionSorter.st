"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

Object subclass:#SequenceableCollectionSorter
	instanceVariableNames:'collection atSelector putSelector sizeSelector sortBlock'
	classVariableNames:'DefaultSortBlock'
	poolDictionaries:''
	category:'Collections-Support'
!

!SequenceableCollectionSorter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    a SequenceableCollectionSorter allows for anything which responds to
    keyed at/atPut messages to be sorted just like a SequenceableCollection.
    Since the access messages can be customized, even non collections
    (or collection simulators, models etc.) can be sorted with these sorters.
    (use #atSelector: / #putSelector: and #sizeSelector: for customization).

    As with collection sorting, the sortBlock can be specified and defaults to
    a block which compares using #< messages.
"
!

examples
"
    |a sorter|

    a := #(10 5 2 17 5 99 -5).
    sorter := SequenceableCollectionSorter on:a.
    sorter sort.
    Transcript showCR:a printString
"
! !

!SequenceableCollectionSorter class methodsFor:'initialization'!

initialize
    DefaultSortBlock := [:a :b | a <= b]

    "
     SequenceableCollectionSorter initialize
    "

    "Modified: 6.2.1996 / 15:47:48 / cg"
! !

!SequenceableCollectionSorter class methodsFor:'instance creation'!

on:aCollection
    ^ self new collection:aCollection; sortBlock:DefaultSortBlock

    "Created: 6.2.1996 / 15:39:09 / cg"
    "Modified: 6.2.1996 / 16:07:36 / cg"
!

on:aCollection using:aTwoArgBlock
    ^ self new collection:aCollection; sortBlock:aTwoArgBlock

    "Created: 6.2.1996 / 15:39:32 / cg"
!

sort:aCollection
    (self new collection:aCollection; sortBlock:DefaultSortBlock) sort

    "Created: 6.2.1996 / 15:40:04 / cg"
    "Modified: 6.2.1996 / 16:07:42 / cg"
!

sort:aCollection using:aTwoArgBlock
    (self new collection:aCollection; sortBlock:aTwoArgBlock) sort

    "Created: 6.2.1996 / 15:39:58 / cg"
! !

!SequenceableCollectionSorter methodsFor:'accessing'!

atSelector:aSymbol
    "set the selector to access elements.
     If nil (the default), elements are accessed via #at:"

    atSelector := aSymbol

    "Created: 6.2.1996 / 15:35:49 / cg"
!

collection
    "return the collections being sorted."

    ^ collection

    "Created: 6.2.1996 / 15:37:02 / cg"
!

collection:aCollection
    "set the collections being sorted."

    collection := aCollection

    "Created: 6.2.1996 / 15:37:20 / cg"
!

putSelector:aSymbol
    "set the selector to access elements.
     If nil (the default), elements are accessed via #at:put:"

    putSelector := aSymbol

    "Created: 6.2.1996 / 15:36:14 / cg"
!

sizeSelector:aSymbol
    "set the selector to get the collections size.
     If nil (the default), elements are accessed via #size"

    sizeSelector := aSymbol

    "Created: 6.2.1996 / 15:36:33 / cg"
!

sortBlock
    "return the sortBlock which is used to compare two elements.
     The default sortBlock compares elements by sending the #< message."

    ^ sortBlock

    "Created: 6.2.1996 / 15:38:32 / cg"
!

sortBlock:aTwoArgBlock 
    "set the sortBlock which is used to compare two elements.
     The default sortBlock compares elements by sending the #< message."

    sortBlock := aTwoArgBlock

    "Created: 6.2.1996 / 15:38:20 / cg"
! !

!SequenceableCollectionSorter methodsFor:'sorting'!

defaultSort:inBegin to:inEnd
    "actual sort worker for sorting when the sortBlock is nil (or the default)
     and default atSelector/putSelectors are to be used.
     This will execute slightly faster, since no #perform-indirection is needed."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     b       "{ Class: SmallInteger }"
     e       "{ Class: SmallInteger }"
     middleElement temp1 temp2 |

    begin := inBegin.   "/ this also does a type-check
    end := inEnd.

    b := begin.
    e := end.
    middleElement := collection at:((b + e) // 2).

    [b < e] whileTrue:[
        [b < end and:[(collection at:b) <= middleElement]] whileTrue:[b := b + 1].
        [e > begin and:[middleElement <= (collection at:e)]] whileTrue:[e := e - 1].

        (b <= e) ifTrue:[
            (b == e) ifFalse:[
                temp1 := collection at:b. temp2 := collection at:e. 
                collection at:b put:temp2. collection at:e put:temp1
            ].
            b := b + 1.
            e := e - 1
        ]
    ].
    (begin < e) ifTrue:[self defaultSort:begin to:e].
    (b < end) ifTrue:[self defaultSort:b to:end]

    "Created: 6.2.1996 / 15:44:37 / cg"
    "Modified: 6.2.1996 / 18:06:23 / cg"
!

nonDefaultSort3:inBegin to:inEnd with:p
    "actual sort worker for sorting when a non default sortBlock
     with 3 args (stringSort) is used."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     b       "{ Class: SmallInteger }"
     e       "{ Class: SmallInteger }"
     middleElement temp1 temp2 
     atSel putSel|

    atSel := atSelector ? #at:.
    putSel := putSelector ? #at:put:.

    begin := inBegin.   "/ this also does a type-check
    end := inEnd.

    b := begin.
    e := end.
    middleElement := collection perform:atSel with:((b + e) // 2).

    [b < e] whileTrue:[
        [b < end 
        and:[sortBlock 
                value:p
                value:(collection perform:atSel with:b)
                value:middleElement]] 
        whileTrue:[b := b + 1].
        [e > begin 
        and:[sortBlock
                value:p
                value:middleElement
                value:(collection perform:atSel with:e)]] 
        whileTrue:[e := e - 1].

        (b <= e) ifTrue:[
            (b == e) ifFalse:[
                temp1 := (collection perform:atSel with:b). 
                temp2 := (collection perform:atSel with:e). 
                collection perform:putSel with:b with:temp2. 
                collection perform:putSel with:e with:temp1.
            ].
            b := b + 1.
            e := e - 1
        ]
    ].
    (begin < e) ifTrue:[self nonDefaultSort3:begin to:e with:p].
    (b < end) ifTrue:[self nonDefaultSort3:b to:end with:p]

    "Modified: / 27.10.1997 / 04:52:41 / cg"
    "Created: / 27.10.1997 / 18:54:54 / cg"
!

nonDefaultSort:inBegin to:inEnd
    "actual sort worker for sorting when a non default sortBlock
     or nonNil access selectors are used."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     b       "{ Class: SmallInteger }"
     e       "{ Class: SmallInteger }"
     middleElement temp1 temp2 
     atSel putSel|

    atSel := atSelector ? #at:.
    putSel := putSelector ? #at:put:.

    begin := inBegin.   "/ this also does a type-check
    end := inEnd.

    b := begin.
    e := end.
    middleElement := collection perform:atSel with:((b + e) // 2).

    [b < e] whileTrue:[
        [b < end 
        and:[sortBlock 
                value:(collection perform:atSel with:b)
                value:middleElement]] 
        whileTrue:[b := b + 1].
        [e > begin 
        and:[sortBlock
                value:middleElement
                value:(collection perform:atSel with:e)]] 
        whileTrue:[e := e - 1].

        (b <= e) ifTrue:[
            (b == e) ifFalse:[
                temp1 := (collection perform:atSel with:b). 
                temp2 := (collection perform:atSel with:e). 
                collection perform:putSel with:b with:temp2. 
                collection perform:putSel with:e with:temp1.
            ].
            b := b + 1.
            e := e - 1
        ]
    ].
    (begin < e) ifTrue:[self nonDefaultSort:begin to:e].
    (b < end) ifTrue:[self nonDefaultSort:b to:end]

    "Created: / 6.2.1996 / 16:06:46 / cg"
    "Modified: / 27.10.1997 / 04:52:41 / cg"
!

sort
    |sz|

    sizeSelector isNil ifTrue:[
        sz := collection size
    ] ifFalse:[
        sz := collection perform:sizeSelector
    ].
    self sort:1 to:sz

    "Created: 6.2.1996 / 15:41:21 / cg"
!

sort:from to:to 
    "actual sort worker for sort-messages"

    (atSelector isNil
    and:[putSelector isNil
    and:[sortBlock isNil or:[sortBlock == DefaultSortBlock]]]) ifTrue:[
        self defaultSort:from to:to 
    ] ifFalse:[
        sortBlock numArgs == 3 ifTrue:[
            self nonDefaultSort3:from to:to with:nil "p"
        ] ifFalse:[
            self nonDefaultSort:from to:to
        ]
    ].

    "Modified: / 27.10.1997 / 18:55:48 / cg"
! !

!SequenceableCollectionSorter class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


SequenceableCollectionSorter initialize!
