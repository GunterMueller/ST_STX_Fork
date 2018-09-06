"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Diff3
	instanceVariableNames:'file1 file0 file2 diffClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

Object subclass:#Chunk
	instanceVariableNames:'offset length side'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff3
!

Object subclass:#Conflict
	instanceVariableNames:'left original right'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff3
!

Diff3 comment:'Diff3 provides a three-way-merge algorithm suitable for performing textual merges, such as are often required as part of source-code version control systems.
Instance Variables
	diffClass:	<Class> Should be a subclass of GenericDiff. Used to resolve changes.
	file0:		<SequenceableCollection> The ancestral file.
	file1:		<SequenceableCollection> The left branch.
	file2:		<SequenceableCollection> The right branch.
-- 
Copyright (c) 2008 Tony Garnock-Jones <tonyg@lshift.net>
Copyright (c) 2008 LShift Ltd. <query@lshift.net>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,including without limitation the rights to use, copy, modify, merge,publish, distribute, sublicense, and/or sell copies of the Software,and to permit persons to whom the Software is furnished to do so,subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'
!

!Diff3 class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    Diff3 provides a three-way-merge algorithm suitable for performing textual merges, 
    such as are often required as part of source-code version control systems.

    Instance Variables
        diffClass:      <Class> Should be a subclass of GenericDiff. Used to resolve changes.
        file0:          <SequenceableCollection> The ancestral file.
        file1:          <SequenceableCollection> The left branch.
        file2:          <SequenceableCollection> The right branch.

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3 methodsFor:'accessing'!

diffClass
    ^ diffClass ? Diff2::HuntMcilroy

    "Modified (format): / 16-03-2012 / 20:27:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffClass: anObject
	diffClass := anObject
!

file0
	^ file0
!

file0: anObject
	file0 := anObject
!

file1
	^ file1
!

file1: anObject
	file1 := anObject
!

file2
	^ file2
!

file2: anObject
	file2 := anObject
!

fileAt: side
    "Given a side (#left, #original or #right), returns the
    corresponding file"

    side == #left       ifTrue:[ ^ file1 ].
    side == #original   ifTrue:[ ^ file0 ].
    side == #right      ifTrue:[ ^ file2 ].

    self error:'Invalid parameter, must be one of #left, #original or #right'.

    "Created: / 03-04-2012 / 23:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3 methodsFor:'merging'!

diffIndices
    "Returns an Array of Diff3Chunks (representing clean merges) or Diff3Conflicts 
     (containing DiffChunks, representing conflicts), together representing the 
     results of a three-way merge between file1/file0/file2. Does not detect 
     'false conflicts', and can return two Diff3Chunks next to each other in 
     the result."

    | result commonOffset hunks lastOverlapHunkIndex hunk firstHunkIndex |

    hunks := self computeHunks.
    result := OrderedCollection new.
    commonOffset := 1.
    firstHunkIndex := 1.
    [firstHunkIndex <= hunks size] whileTrue: [
        | conflict |

        hunk := hunks at: firstHunkIndex.
        self addCommonChunkTo: result between: commonOffset and: hunk oldChunk offset.
        lastOverlapHunkIndex := self findOverlapStartingAt: firstHunkIndex in: hunks.

        (firstHunkIndex = lastOverlapHunkIndex)"false" ifTrue: [
            conflict := self computeConflictFromCleanMerge: hunk.
            result add: conflict.
            commonOffset := (hunks at: lastOverlapHunkIndex) oldChunk lastIndex + 1.
        ] ifFalse: [ 

            conflict := self computeConflictFrom: firstHunkIndex
                                            to: lastOverlapHunkIndex
                                            hunks: hunks.
            result add: conflict.
            commonOffset := conflict original lastIndex + 1.
        ].

        firstHunkIndex := lastOverlapHunkIndex + 1
    ].
    self addCommonChunkTo: result between: commonOffset and: file0 size + 1.
    ^ result asArray

    "Created: / 20-03-2012 / 18:27:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merge
    "Returns an Array of (#ok -> {...}) or (#conflict -> Diff3Conflict 
     of collections) instances representing the results of a three-way 
     merge between file1/file0/file2. Does not optimistically treat 
     'false conflicts' as clean merges (see the class comment for 
     Diff3InclusiveVisitor)."

    ^ self merge: false

    "Modified (comment): / 16-03-2012 / 20:26:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeClean
    "Returns an Array of (#ok -> {...}) or (#conflict -> Diff3Conflict of 
     collections) instances representing the results of a three-way merge 
     between file1/file0/file2. Optimistically treats 'false conflicts' 
     as clean merges (see the class comment for Diff3ExclusiveVisitor)."

    ^ self merge: true

    "Modified (format): / 16-03-2012 / 20:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeIndices
    "Returns an Array of Diff3Chunks (representing clean merges) or Diff3Conflicts 
     (containing DiffChunks, representing conflicts), together representing the 
     results of a three-way merge between file1/file0/file2. Does not detect 
     'false conflicts', and can return two Diff3Chunks next to each other in 
     the result."

    ^self mergeIndicesDiscardEmpty: true

    "Modified: / 09-04-2012 / 16:26:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeIndicesDiscardEmpty: discardEmpty
    "Returns an Array of Diff3Chunks (representing clean merges) or Diff3Conflicts 
     (containing DiffChunks, representing conflicts), together representing the 
     results of a three-way merge between file1/file0/file2. Does not detect 
     'false conflicts', and can return two Diff3Chunks next to each other in 
     the result.

    If discard empty is true, empty clean merge chunks are not included
     "

    | result commonOffset hunks lastOverlapHunkIndex hunk firstHunkIndex |

    hunks := self computeHunks.
    result := OrderedCollection new.
    commonOffset := 1.
    firstHunkIndex := 1.
    [firstHunkIndex <= hunks size] whileTrue: [

        hunk := hunks at: firstHunkIndex.
        self addCommonChunkTo: result between: commonOffset and: hunk oldChunk offset.
        lastOverlapHunkIndex := self findOverlapStartingAt: firstHunkIndex in: hunks.

        (firstHunkIndex = lastOverlapHunkIndex) ifTrue: [
            (discardEmpty and:[hunk newChunk length == 0]) ifTrue:[
                "/Empty chunk...
            ] ifFalse:[
                result add: (Diff3::Chunk side: hunk side chunk: hunk newChunk)
            ].
            commonOffset := (hunks at: lastOverlapHunkIndex) oldChunk lastIndex + 1.
        ] ifFalse: [ 
            | conflict |
            conflict := self computeConflictFrom: firstHunkIndex
                                            to: lastOverlapHunkIndex
                                            hunks: hunks.
            result add: conflict.
            commonOffset := conflict original lastIndex + 1.
        ].

        firstHunkIndex := lastOverlapHunkIndex + 1
    ].
    self addCommonChunkTo: result between: commonOffset and: file0 size + 1.
    ^ result asArray

    "Created: / 09-04-2012 / 16:25:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3 methodsFor:'private'!

addCommonChunkTo: result between: commonOffset and: targetOffset
        targetOffset > commonOffset ifTrue: [
                result add: (Diff3::Chunk new
                                                side: #original;
                                                offset: commonOffset;
                                                length: targetOffset - commonOffset)].
        ^ targetOffset

    "Modified: / 16-03-2012 / 19:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeConflictChunk: side fromCleanMerge: hunk old: old new: new into: conflict

    side == hunk side ifTrue:[
        conflict at: side put: hunk newChunk.
        ^self
    ].
    "Hmm....we have to compare"


    (hunk newChunk extractSafeFrom: (self fileAt: side)) = new ifTrue:[
        conflict at: side put: hunk newChunk.
    ] ifFalse:[
        conflict at: side put: hunk oldChunk.
    ]

    "Created: / 06-04-2012 / 12:31:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeConflictFrom: i1 to: i2 hunks: hunks
        | hunk conflict l o r lo ro chunk chunkOrig |
        conflict := Diff3::Conflict new.
        conflict left: (l := Diff2::Chunk negativeSize: file1 size).
        conflict original: (o := Diff2::Chunk negativeSize: file0 size).
        conflict right: (r := Diff2::Chunk negativeSize: file2 size).
        lo := o copy.
        ro := o copy.

        i1 to: i2 do: [:index |
                hunk := hunks at: index.
                (hunk side = #left)
                        ifTrue: [chunk := l. chunkOrig := lo.]
                        ifFalse: [chunk := r. chunkOrig := ro.].
                o destructiveMergeWith: hunk oldChunk.
                chunk destructiveMergeWith: hunk newChunk.
                chunkOrig destructiveMergeWith: hunk oldChunk].

        l correctForSkewFrom: lo to: o.
        r correctForSkewFrom: ro to: o.

        ^ conflict

    "Modified: / 16-03-2012 / 19:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeConflictFromCleanMerge: hunk
    | conflict old new |

    conflict := Conflict new.

    old := hunk oldChunk extractFrom: file0.
    new := hunk newChunk extractFrom: (self fileAt: hunk side).

    conflict left: old.
    conflict original: old.
    conflict right: old.
    conflict instVarNamed:hunk side put: hunk newChunk.

    ^conflict.

    "Created: / 06-04-2012 / 12:13:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeHunks
        | diff2 diff1 hunks |
        diff1 := self diffClass new file1: file0; file2: file1; diffIndices.
        diff2 := self diffClass new file1: file0; file2: file2; diffIndices.
        hunks := OrderedCollection new.
        diff1 do: [ :entry | hunks add: (Diff3Hunk side: #left entry: entry) ].
        diff2 do: [ :entry | hunks add: (Diff3Hunk side: #right entry: entry) ].
        ^ hunks asSortedCollection:[:a :b|a <= b].

    "Modified: / 16-03-2012 / 20:29:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMap
	| files |
	files := Dictionary new.
	files at: #left put: file1.
	files at: #original put: file0.
	files at: #right put: file2.
	^ files
!

findOverlapStartingAt: startIndex in: hunks
        | nextRegionLhs hunk |
        nextRegionLhs := (hunks at: startIndex) oldChunk lastIndex + 1.
        startIndex + 1 to: hunks size do: [:index |
                hunk := hunks at: index.
                hunk oldChunk offset > nextRegionLhs ifTrue: [ 
                    ^ index - 1
                ].
                nextRegionLhs := nextRegionLhs max: hunk oldChunk lastIndex + 1
        ].
        ^ hunks size.

    "Modified (format): / 20-03-2012 / 18:04:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merge: excludeFalseConflicts
	| visitor |
	visitor := excludeFalseConflicts
		ifTrue: [Diff3ExclusiveVisitor new]
		ifFalse: [Diff3InclusiveVisitor new].
	visitor files: self fileMap.
	self mergeIndices do: [:each | each accept: visitor].
	^ visitor result
! !

!Diff3::Chunk class methodsFor:'as yet unclassified'!

negativeSize: s
	"Returns a pseudo-chunk with *negative* length, useful as a kind of zero for destructiveMergeWith: operations intended to build up coverage over some set of chunks."
	^ self new offset: s + 1; length: s negated
!

offset: o length: l
	^ self new offset: o; length: l
!

side: aSelector chunk: aChunk
	^ self new side: aSelector; offset: aChunk offset; length: aChunk length
! !

!Diff3::Chunk class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    A Diff3Chunk is a subclass of DiffChunk that also knows which side of a three-way merge it represents.

    Instance Variables
        side:           <Symbol> One of #left, #original or #right

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3::Chunk methodsFor:'accessing'!

correctForSkewFrom: smallerChunk to: biggerChunk
	"Given a biggerChunk that definitely contains smallerChunk but might have an extra head or tail, updates the receiver to include such an extra head or tail."
	| headSize tailSize |
	headSize := smallerChunk offset - biggerChunk offset.
	tailSize := biggerChunk lastIndex - smallerChunk lastIndex.
	offset := offset - headSize.
	length := length + headSize + tailSize.
!

destructiveMergeWith: aChunk
	| newLastIndex |
	newLastIndex := self lastIndex max: aChunk lastIndex.
	offset := offset min: aChunk offset.
	length := newLastIndex - offset + 1.
!

lastIndex
	"Returns the rightmost index contained in my range. (Offset is the leftmost index.) If my length is zero, will return an index lower than my offset."
	^ offset + length - 1
!

length
	^ length
!

length: anObject
	length := anObject
!

offset
	^ offset
!

offset: anObject
	offset := anObject
!

side
	^ side
!

side: anObject
	side := anObject
! !

!Diff3::Chunk methodsFor:'as yet unclassified'!

= otherChunk

        ^ (otherChunk isKindOf: self class) and:
        [(self offset = otherChunk offset) and:
        [(self length = otherChunk length)]]

    "Modified: / 16-03-2012 / 19:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

accept: aVisitor
	^ aVisitor side: side chunk: self
!

extractFrom: aCollection
	"Extracts a subcollection from aCollection corresponding to my offset and length."
	^ aCollection copyFrom: offset to: offset + length - 1.
!

extractFrom: aCollection offset: lineOffset
    "Given a text and lineOffset withing a chunk, return the line"
    ^ aCollection at: offset + lineOffset - 1

    "Created: / 04-04-2012 / 00:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractFromDiff: diff

    ^self extractFrom: (diff fileAt: side)

    "Created: / 03-04-2012 / 23:33:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractResolution

    side == #left     ifTrue:[ ^ #MergedUsingA ].
    side == #original ifTrue:[ ^ #MergedUsingBase ].
    side == #right    ifTrue:[ ^ #MergedUsingB ].

    self error:'Should not be reached'

    "Created: / 04-04-2012 / 00:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn: aStream
        aStream nextPut: $(.
        super printOn: aStream.
        aStream
                nextPutAll: ' side: ';
                nextPutAll: side printString;
                nextPutAll: ' off: ';
                nextPutAll: offset printString;
                nextPutAll: ' len: ';
                nextPutAll: length printString;


                nextPut: $).

    "Modified: / 20-03-2012 / 17:08:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3::Chunk methodsFor:'comparing'!

< aDiffChunk
	"Used to sort changed chunks during three-way merge; see Diff3"
	^ self offset < aDiffChunk offset
! !

!Diff3::Chunk methodsFor:'testing'!

isChunk
    ^true

    "Created: / 16-03-2012 / 22:02:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isConflict
    ^false

    "Created: / 16-03-2012 / 22:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3::Conflict class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    A Diff3Conflict represents a merge conflict.

    Instance Variables
        left:           Either a SequenceableCollection or a Diff3Chunk representing the left variant.
        original:       Either a SequenceableCollection or a Diff3Chunk representing the original variant.
        right:          Either a SequenceableCollection or a Diff3Chunk representing the right variant.

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3::Conflict methodsFor:'accessing'!

at: side

    "Given a side (#left, #original or #right), returns the
    corresponding chunk"

    side == #left       ifTrue:[ ^ left ].
    side == #original   ifTrue:[ ^ original ].
    side == #right      ifTrue:[ ^ right ].

    self error:'Invalid parameter, must be one of #left, #original or #right'.

    "Created: / 06-04-2012 / 12:26:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: side put: chunk

    "Given a side (#left, #original or #right), sets the
    corresponding chunk"

    side == #left       ifTrue:[ left := chunk. ^ self].
    side == #original   ifTrue:[ original := chunk. ^ self ].
    side == #right      ifTrue:[ right := chunk. ^ self ].

    self error:'Invalid parameter, must be one of #left, #original or #right'.

    "Created: / 06-04-2012 / 12:26:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

left
	^ left
!

left: anObject
	left := anObject
!

leftAt: index

    ^(index between: 1 and: left size) ifTrue:[
        left at: index
    ] ifFalse:[
        nil
    ]

    "Created: / 20-03-2012 / 20:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

length

    ^left length max: (original length max: right length)

    "Created: / 16-03-2012 / 22:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

original
	^ original
!

original: anObject
	original := anObject
!

originalAt: index

    ^(index between: 1 and: original size) ifTrue:[
        original at: index
    ] ifFalse:[
        nil
    ]

    "Created: / 20-03-2012 / 20:49:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

right
	^ right
!

right: anObject
	right := anObject
!

rightAt: index

    ^(index between: 1 and: right size) ifTrue:[
        right at: index
    ] ifFalse:[
        nil
    ]

    "Created: / 20-03-2012 / 20:48:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3::Conflict methodsFor:'as yet unclassified'!

= otherConflict
        ^ (otherConflict isKindOf: Diff3::Conflict) and:
                [(left = otherConflict left) and:
                [(original = otherConflict original) and:
                [(right = otherConflict right)]]]

    "Modified: / 16-03-2012 / 19:20:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

accept: aVisitor
	^ aVisitor left: left original: original right: right.
!

printOn: aStream
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' new left: '.
	left printOn: aStream.
	aStream nextPutAll: '; original: '.
	original printOn: aStream.
	aStream nextPutAll: '; right: '.
	right printOn: aStream.
	aStream nextPut: $).
! !

!Diff3::Conflict methodsFor:'testing'!

isChunk
    ^false

    "Created: / 16-03-2012 / 22:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isConflict
    ^true

    "Created: / 16-03-2012 / 22:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInsertionInLeft
    ^left length > 0
        and:[original length <= 0
            and:[right length <= 0]]

    "Created: / 20-03-2012 / 18:37:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInsertionInOriginal
    ^original length > 0
        and:[left length <= 0
            and:[right length <= 0]]

    "Created: / 20-03-2012 / 18:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInsertionInRight
    ^right length > 0
        and:[original length <= 0
            and:[left length <= 0]]

    "Created: / 20-03-2012 / 18:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

