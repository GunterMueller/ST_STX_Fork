"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

DiffCodeView2 subclass:#Diff3CodeView2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

Object subclass:#Diff3Data
	instanceVariableNames:'text1 list1 text2 list2 text3 list3 inserted1 inserted2 inserted3
		deleted changed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff3CodeView2
!

!Diff3CodeView2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!Diff3CodeView2 class methodsFor:'defaults'!

numberOfViews
    "return the number of the synced subViews.
     Usually redefined in subclasses"

    ^ 3

    "Created: / 16-03-2012 / 12:56:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3CodeView2 methodsFor:'accessing'!

computeDiffDataForText1:t1 text2:t2 text3: t3

    ^Diff3Data new
        computeDiffDataForText1:t1 text2:t2 text3: t3;
        yourself

    "Created: / 16-03-2012 / 20:49:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

text1:t1 text2:t2 text3: t3
    |data|

    data := self computeDiffDataForText1:t1 text2:t2 text3: t3.

    (textViews at:1) 
        list:(data list1);
        deletedLines:#();
        changedLines:(data changed);
        insertedLines:(data inserted1);    
        originDiffText:t1;
        emptyLines:#().

    (textViews at:2) 
        list:(data list2);
        deletedLines:#();
        changedLines:(data changed);
        insertedLines:(data inserted2);
        originDiffText:t2;
        emptyLines:#().

    (textViews at:3) 
        list:(data list3);
        deletedLines:#();
        changedLines:(data changed);
        insertedLines:(data inserted3);
        originDiffText:t3;
        emptyLines:#().

    "Modified: / 22-06-2010 / 21:36:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 16-03-2012 / 12:58:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3CodeView2::Diff3Data methodsFor:'accessing'!

changed

    ^changed copy

    "Modified: / 02-05-2010 / 19:31:18 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 16-07-2010 / 09:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changed:something
    changed := something.
!

deleted
    ^ deleted
!

deleted:something
    deleted := something.
!

inserted1
    ^ inserted1
!

inserted2
    ^ inserted2
!

inserted3
    ^ inserted3
!

list1
    ^ list1
!

list1:something
    list1 := something.
!

list2
    ^ list2
!

list2:something
    list2 := something.
!

list3
    ^ list3
!

list3:something
    list3 := something.
!

text1
    ^ text1
!

text1:something
    text1 := something.
!

text2
    ^ text2
!

text2:something
    text2 := something.
!

text3
    ^ text3
!

text3:something
    text3 := something.
! !

!Diff3CodeView2::Diff3Data methodsFor:'computing'!

addLines: total from: src to: dst chunk: chunk

    ^chunk isSequenceable ifTrue:[
        dst addAll: chunk.
        (total - chunk size) timesRepeat: [
            dst add: nil.
        ]
    ] ifFalse:[
        self addLines: total from: src to: dst offset: chunk offset length: chunk length.
    ]

    "Created: / 09-04-2012 / 11:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addLines: total from: src to: dst offset: offset length: len
    | start stop |

    start := offset max:1.
    stop  := (offset + (len max:0) - 1).


    start to: (stop min: src size) do:[:i|                     
        (src size >= i) ifTrue:[
            dst add: (src at: i).
        ] ifFalse:[
            src add: nil.
        ]
    ].


    (total - ((stop min: src size) - start + 1)) timesRepeat: [ dst add: nil ].

    "Created: / 16-03-2012 / 22:20:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeDiffDataForText1:t1 text2:t2 text3: t3
    | t1c t2c  t3c  diff3chunks lnr |

    list1 := StringCollection new.
    list2 := StringCollection new.
    list3 := StringCollection new.
    changed := OrderedCollection new.
    inserted1 := OrderedCollection new.
    inserted2 := OrderedCollection new.
    inserted3 := OrderedCollection new.

"/    t1 isNil ifTrue:[ ^self ].
"/    t2 isNil ifTrue:[ ^self ].
"/    t3 isNil ifTrue:[ ^self ].


    t1c := (text1 := t1 ? #()) asStringCollection.
    t2c := (text2 := t2 ? #()) asStringCollection.
    t3c := (text3 := t3 ? #()) asStringCollection.

    
    diff3chunks := Diff3 new
                    file0: t1c; "/Base version
                    file1: t2c; "/A
                    file2: t3c; "/B
                    diffIndices.
    lnr := 1.
    diff3chunks do:[:chunk|
        | len |

        len := chunk length.
        chunk isConflict ifTrue:[
            self addLines: len from: t1c to: list1 chunk: chunk original.
            self addLines: len from: t2c to: list2 chunk: chunk left.
            self addLines: len from: t3c to: list3 chunk: chunk right.
            chunk isInsertionInOriginal ifTrue:[
                lnr to:(lnr + len -1) do:[:i|inserted1 add: i].
            ] ifFalse:[chunk isInsertionInLeft ifTrue:[
                lnr to:(lnr + len -1) do:[:i|inserted2 add: i].
            ] ifFalse:[chunk isInsertionInRight ifTrue:[
                lnr to:(lnr + len -1) do:[:i|inserted3 add: i].
            ] ifFalse:[
                lnr to:(lnr + len -1) do:[:i|changed add: i].
            ]]]
        ].
        chunk isChunk ifTrue:[
            chunk side == #original ifTrue:[
                self addLines: len from: t1c to: list1 offset: chunk offset length: len.
                self addLines: len from: t1c to: list2 offset: chunk offset length: len.
                self addLines: len from: t1c to: list3 offset: chunk offset length: len.
            ].
            chunk side == #left ifTrue:[
                self breakPoint: #jv info: 'Should no longer happen'.
                self addLines: len from: t1c to: list1 offset: chunk offset length: 0"len".
                self addLines: len from: t2c to: list2 offset: chunk offset length: len.
                self addLines: len from: t3c to: list3 offset: chunk offset length: 0"len".
                lnr to:(lnr + len - 1) do:[:i| "changed"inserted2 add:i ].
            ].
            chunk side == #right ifTrue:[
                self breakPoint: #jv info: 'Should no longer happen'.
                self addLines: len from: t1c to: list1 offset: chunk offset length: 0"len".
                self addLines: len from: t2c to: list2 offset: chunk offset length: 0"len".
                self addLines: len from: t3c to: list3 offset: chunk offset length: len.
                lnr to:(lnr + len - 1) do:[:i|"changed"inserted3 add: i].
            ]
        ].
        lnr := lnr + len.
    ].

    "Created: / 16-03-2012 / 22:07:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

old_computeDiffDataForText1:t1 text2:t2 text3: t3
    | t1c t2c  t3c  diff3chunks lnr |

    list1 := StringCollection new.
    list2 := StringCollection new.
    list3 := StringCollection new.
    changed := OrderedCollection new.
    inserted1 := OrderedCollection new.
    inserted2 := OrderedCollection new.
    inserted3 := OrderedCollection new.

    t1 isNil ifTrue:[ ^self ].
    t2 isNil ifTrue:[ ^self ].
    t3 isNil ifTrue:[ ^self ].


    t1c := (text1 := t1) asStringCollection.
    t2c := (text2 := t2) asStringCollection.
    t3c := (text3 := t3) asStringCollection.

    
    diff3chunks := Diff3 new
                    file0: t1c; "/Base version
                    file1: t2c; "/A
                    file2: t3c; "/B
                    mergeIndices.
    lnr := 1.
    diff3chunks do:[:chunk|
        | len |

        len := chunk length.
        chunk isConflict ifTrue:[
            self addLines: len from: t1c to: list1 offset: chunk original offset length: chunk original length.
            self addLines: len from: t2c to: list2 offset: chunk left     offset length: chunk left     length.
            self addLines: len from: t3c to: list3 offset: chunk right    offset length: chunk right    length.
"/            chunk isInsertionInOriginal ifTrue:[
"/                lnr to:(lnr + len -1) do:[:i|inserted1 add: i].
"/            ] ifFalse:[chunk isInsertionInLeft ifTrue:[
"/                lnr to:(lnr + len -1) do:[:i|inserted2 add: i].
"/            ] ifFalse:[chunk isInsertionInRight ifTrue:[
"/                lnr to:(lnr + len -1) do:[:i|inserted3 add: i].
"/            ] ifFalse:[
                lnr to:(lnr + len -1) do:[:i|changed add: i].
"/            ]]]
        ].
        chunk isChunk ifTrue:[
            chunk side == #original ifTrue:[
                self addLines: len from: t1c to: list1 offset: chunk offset length: len.
                self addLines: len from: t1c to: list2 offset: chunk offset length: len.
                self addLines: len from: t1c to: list3 offset: chunk offset length: len.
            ].
            chunk side == #left ifTrue:[
                self addLines: len from: t1c to: list1 offset: chunk offset length: 0"len".
                self addLines: len from: t2c to: list2 offset: chunk offset length: len.
                self addLines: len from: t3c to: list3 offset: chunk offset length: 0"len".
                lnr to:(lnr + len - 1) do:[:i| "changed"inserted2 add:i ].
            ].
            chunk side == #right ifTrue:[
                self addLines: len from: t1c to: list1 offset: chunk offset length: 0"len".
                self addLines: len from: t2c to: list2 offset: chunk offset length: 0"len".
                self addLines: len from: t3c to: list3 offset: chunk offset length: len.
                lnr to:(lnr + len - 1) do:[:i|"changed"inserted3 add: i].
            ]
        ].
        lnr := lnr + len.
    ].

    "Created: / 20-03-2012 / 17:42:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3CodeView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Diff3CodeView2.st,v 1.1 2014-02-05 18:58:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Diff3CodeView2.st,v 1.1 2014-02-05 18:58:05 cg Exp $'
! !

