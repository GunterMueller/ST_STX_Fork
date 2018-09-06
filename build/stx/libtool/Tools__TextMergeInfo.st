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

Object subclass:#TextMergeInfo
	instanceVariableNames:'list listInfos'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

Object subclass:#LineInfo
	instanceVariableNames:'line resolution conflict offset'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TextMergeInfo
!

!TextMergeInfo class methodsFor:'documentation'!

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

!TextMergeInfo methodsFor:'* uncategorized *'!

conflictLineText

    ^ '<conflict>' allBold withColor: Color red.

    "Created: / 03-04-2012 / 23:26:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

noSourceLineText

    ^'<no source line>' withColor: Color red.

    "Created: / 03-04-2012 / 23:26:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo methodsFor:'accessing'!

list
    ^ list
!

listInfos
    ^ listInfos
!

text
    ^String  streamContents:[:s|
        list withIndexDo:[:ln :i|
            | info |

            info := listInfos at: i ifAbsent:[nil].
            (info isNil or:[info offset ~~ -1]) ifTrue:[
                ln notNil ifTrue:[
                    s nextPutLine: (list at: i)
                ].
            ]
        ].
    ].

    "Created: / 19-03-2012 / 14:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo methodsFor:'initialization'!

text1: text1 text2: text2 text3: text3

    | t1c t2c  t3c diff3 diffs merges resolution lnr i |

    list := StringCollection new.
    listInfos := OrderedCollection new.

    t1c := (text1 ? #()) asStringCollection.
    t2c := (text2 ? #()) asStringCollection.
    t3c := (text3 ? #()) asStringCollection.


    diff3 := Diff3 new
                    file0: t1c; "/Base version
                    file1: t2c; "/A
                    file2: t3c. "/B\
    diffs := diff3 diffIndices.
    merges := diff3 mergeIndicesDiscardEmpty: false.

    lnr := 1.
    i := 1.
    [ i <= merges size ] whileTrue:[
        | diff merge lines |

        diff := diffs at: i.
        merge := merges at: i.
        diff isChunk ifTrue:[
            lines := merge extractFromDiff: diff3.
            1 to: diff length do:[:j|
                list add: (lines at: j).
                listInfos add: (LineInfo line: lnr resolution: #NoConflict conflict: diff offset: j ).
                lnr := lnr + 1.
            ].
        ].
        diff isConflict ifTrue:[
            1 to: diff length do:[:j|
                merge isConflict ifTrue:[
                    list add: self conflictLineText.
                    listInfos add: (LineInfo line: lnr resolution: #Conflict conflict: diff offset: j).
                ] ifFalse:[
                    lines := merge extractFromDiff: diff3.
                    resolution := merge extractResolution.
                    j <= lines size ifTrue:[
                        list add: (lines at: j).
                        listInfos add: (LineInfo line: lnr resolution: resolution conflict: diff offset: j).
                    ] ifFalse:[
                        list add: self noSourceLineText.
                        listInfos add: (LineInfo line: lnr resolution: resolution conflict: diff offset: -1).
                    ].
                ].
                lnr := lnr + 1.
            ].
        ].
        i := i + 1.
    ].
    "Sanity check:"
    i < diffs size ifTrue:[
        i + 1 to: diffs size do:[:j|
            self assert: (diffs at:j) length == 0.
        ]
    ].

    self changed: #value

    "Created: / 19-03-2012 / 12:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo methodsFor:'merging'!

mergeUsing: text

    list := (text ? #()) asStringCollection.
    listInfos := 
        (1 to: list size) collect:[:lineNr|
            (LineInfo line: lineNr resolution: #Merged )
        ].
    self changed:#resolution

    "Created: / 30-11-2012 / 14:12:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingA: textA

    list := (textA ? #()) asStringCollection.
    listInfos := 
        (1 to: list size) collect:[:lineNr|
            (LineInfo line: lineNr resolution: #MergedUsingA )
        ].
    self changed:#resolution

    "Created: / 21-03-2012 / 12:03:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingA: textA interval: interval
    "Given textA and section interval, merges the section
     using textA."

    | listA offset |
    listA := (textA ? '') asStringCollection.
    offset := 0.
    interval do:[:lineNr|
        | info chunk line |
        info := listInfos at: lineNr.
        chunk := info conflict left.
        offset < chunk length ifTrue:[
            line := listA at: chunk offset + offset.            
            info offset: offset + 1.
        ] ifFalse:[
            line := self noSourceLineText.
            info offset: -1
        ].
        list at: lineNr put: line.
        info resolution: #MergedUsingA.
        offset := offset + 1.
    ].

    self changed:#resolution

    "Created: / 04-04-2012 / 00:51:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingB: textB

    list := (textB ? #())  asStringCollection.
    listInfos := 
        (1 to: list size) collect:[:lineNr|
            (LineInfo line: lineNr resolution: #MergedUsingB )
        ].
    self changed:#resulution

    "Created: / 21-03-2012 / 12:04:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingB: textA interval: interval
    "Given textA and section interval, merges the section
     using textA."

    | listA offset |
    listA := (textA ? #()) asStringCollection.
    offset := 0.
    interval do:[:lineNr|
        | info chunk line |
        info := listInfos at: lineNr.
        chunk := info conflict right.
        offset < chunk length ifTrue:[
            line := listA at: chunk offset + offset.            
            info offset: offset + 1.
        ] ifFalse:[
            line := self noSourceLineText.
            info offset: -1
        ].
        list at: lineNr put: line.
        info resolution: #MergedUsingB.
        offset := offset + 1.
    ].

    self changed:#resolution

    "Created: / 04-04-2012 / 01:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingBase: textBase

    list := (textBase ? #()) asStringCollection.
    listInfos := 
        (1 to: list size) collect:[:lineNr|
            (LineInfo line: lineNr resolution: #MergedUsingBase )
        ].
    self changed:#resulution

    "Created: / 21-03-2012 / 12:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeUsingBase: textA interval: interval
    "Given textA and section interval, merges the section
     using textA."

    | listA offset |
    listA := textA asStringCollection.
    offset := 0.
    interval do:[:lineNr|
        | info chunk line |
        info := listInfos at: lineNr.
        chunk := info conflict original.
        offset < chunk length ifTrue:[
            line := listA at: chunk offset + offset.            
            info offset: offset + 1.
        ] ifFalse:[
            line := self noSourceLineText.
            info offset: -1
        ].
        list at: lineNr put: line.
        info resolution: #MergedUsingBase.
        offset := offset + 1.
    ].

    self changed:#resolution

    "Created: / 04-04-2012 / 01:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo methodsFor:'testing'!

isMerged

    ^listInfos allSatisfy:[:info|info isMergedOrNoConflict].

    "Created: / 19-03-2012 / 15:09:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo::LineInfo class methodsFor:'accessing'!

line:lineArg resolution:resolutionArg
    ^self new line:lineArg resolution:resolutionArg conflict:nil offset: nil

    "Created: / 19-03-2012 / 15:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

line:lineArg resolution:resolutionArg conflict:conflictArg 

    ^self new line:lineArg resolution:resolutionArg conflict:conflictArg

    "Modified: / 19-03-2012 / 15:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

line:lineArg resolution:resolutionArg conflict:conflictArg offset: offsetArg 

    ^self new line:lineArg resolution:resolutionArg conflict:conflictArg offset: offsetArg

    "Modified: / 19-03-2012 / 15:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 20-03-2012 / 20:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo::LineInfo methodsFor:'accessing'!

color

    | color |

    self isMerged ifTrue:[ 
        self isMergedUsingA ifTrue:[ 
            color := Tools::TextDiff3Tool colorA
        ] ifFalse:[self isMergedUsingB ifTrue:[ 
                color := Tools::TextDiff3Tool colorB
        ] ifFalse:[self isMergedUsingBase ifTrue:[ 
            color := Tools::TextDiff3Tool colorBase
        ] ifFalse:[
            color :=  Tools::TextDiff3Tool colorMerged
        ]]].
        offset == -1 ifTrue:[
            color := color lighter.
        ].
    ] ifFalse:[
        self isConflict ifTrue:[ 
            color :=  Tools::TextDiff3Tool colorConflict 
        ].
    ].

    ^color

    "Created: / 19-03-2012 / 15:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

conflict
    ^ conflict
!

line
    ^ line
!

line:lineArg resolution:resolutionArg
    self line:lineArg resolution:resolutionArg conflict:nil offset: nil

    "Created: / 19-03-2012 / 15:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

line:lineArg resolution:resolutionArg conflict:conflictArg offset: offsetArg
    line := lineArg.
    resolution := resolutionArg.
    conflict := conflictArg.
    offset := offsetArg

    "Created: / 20-03-2012 / 20:41:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

offset
    ^ offset
!

offset:something
    offset := something.
!

resolution
    ^ resolution
!

resolution:something
    resolution := something.
! !

!TextMergeInfo::LineInfo methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    self class nameWithoutPrefix printOn:aStream.
    aStream space.
    aStream nextPutAll:'line: '.
    line printOn:aStream.
    aStream space.
    aStream nextPutAll:'resolution: '.
    resolution printOn:aStream.

    "Modified: / 19-03-2012 / 12:30:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 15:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo::LineInfo methodsFor:'testing'!

isConflict

    ^resolution == #Conflict

    "Created: / 19-03-2012 / 15:06:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerged

    ^
     resolution == #Merged
            or:[self isMergedUsingA
                or:[self isMergedUsingB
                    or:[self isMergedUsingBase]]]

    "Created: / 19-03-2012 / 15:06:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMergedOrNoConflict

    ^resolution == #NoConflict or:[self isMerged]

    "Created: / 06-04-2012 / 10:40:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMergedUsingA

    ^resolution == #MergedUsingA

    "Created: / 20-03-2012 / 14:21:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMergedUsingB

    ^resolution == #MergedUsingB

    "Created: / 20-03-2012 / 14:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMergedUsingBase

    ^resolution == #MergedUsingBase

    "Created: / 20-03-2012 / 14:21:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextMergeInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

