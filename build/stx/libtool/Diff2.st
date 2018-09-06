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

Object subclass:#Diff2
	instanceVariableNames:'file1 file2'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

Object subclass:#Chunk
	instanceVariableNames:'offset length'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2
!

Diff2 subclass:#HuntMcilroy
	instanceVariableNames:'lcs'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2
!

Object subclass:#Candidate
	instanceVariableNames:'file1index file2index chain'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2::HuntMcilroy
!

Diff2 subclass:#MyersUkkonen
	instanceVariableNames:'lcs'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2
!

Object subclass:#Patch
	instanceVariableNames:'chunks snippets'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2
!

Diff2 comment:'Generic diff/comm utilities. Agnostic as to the longestCommonSubsequence algorithm used.
Instance Variables
	file1:		<SequenceableCollection> One of the two files to compare.
	file2:		<SequenceableCollection> The other of the files to compare.
-- 
Copyright (c) 2008 Tony Garnock-Jones <tonyg@lshift.net>
Copyright (c) 2008 LShift Ltd. <query@lshift.net>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,including without limitation the rights to use, copy, modify, merge,publish, distribute, sublicense, and/or sell copies of the Software,and to permit persons to whom the Software is furnished to do so,subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'
!

!Diff2 class methodsFor:'documentation'!

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
    Generic diff/comm utilities. 
    Agnostic as to the longestCommonSubsequence algorithm used.

    Instance Variables
        file1:          <SequenceableCollection> One of the two files to compare.
        file2:          <SequenceableCollection> The other of the files to compare.

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff2 class methodsFor:'instance creation'!

new
    "I'm abstract, so instantiate some default here"

    ^self == Diff2 ifTrue:[
        HuntMcilroy new
    ] ifFalse:[
        self basicNew initialize
    ]

    "Created: / 16-03-2012 / 20:16:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2 class methodsFor:'accessing'!

HuntMcilroy

    ^HuntMcilroy

    "Created: / 16-03-2012 / 18:54:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

MyersUkkonen

    ^MyersUkkonen

    "Created: / 16-03-2012 / 18:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2 methodsFor:'accessing'!

file1
	^ file1
!

file1: anObject
	file1 := anObject.
	self emptyCaches.
!

file2
	^ file2
!

file2: anObject
	file2 := anObject.
	self emptyCaches.
! !

!Diff2 methodsFor:'diffing'!

comm
	"Returns a collection of similarities and differences between the two files. Each entry in the resulting collection is either (#common -> {...}) or (#different -> ({...} -> {...}))."
	| result common p1 p2 |
	result := OrderedCollection new.
	p1 := 0.
	p2 := 0.
	common := OrderedCollection new.
	self longestCommonSubsequence do: [:entry |
		common := self maybeAddCommonBlock: common to: result
						p1: p1 p2: p2 limit1: entry key limit2: entry value.
		common add: (self file1 at: entry key).
		p1 := entry key.
		p2 := entry value.].
	common := self maybeAddCommonBlock: common to: result
					p1: p1 p2: p2 limit1: file1 size + 1 limit2: file2 size + 1.
	self addCommonBlock: common ifNonEmptyTo: result.
	^ result asArray
!

diff
        "Returns a DiffPatch instance that can be used in future to transform file1 into file2."
        | p |
        p := Diff2::Patch new.
        p initChunks: self diffIndices file1: file1 file2: file2.
        ^ p

    "Modified: / 16-03-2012 / 19:16:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffIndices
	"Returns a collection of (DiffChunk -> DiffChunk) associations mapping differing regions of file1 and file2 onto each other."
	| result p1 p2 |
	result := OrderedCollection new.
	p1 := 0.
	p2 := 0.
	self longestCommonSubsequence do: [:entry |
		self maybeAddDiffChunkTo: result p1: p1 p2: p2 limit1: entry key limit2: entry value.
		p1 := entry key.
		p2 := entry value.].
	self maybeAddDiffChunkTo: result p1: p1 p2: p2 limit1: file1 size + 1 limit2: file2 size + 1.
	^ result asArray
!

longestCommonSubsequence
	"The longestCommonSubsequence (LCS) algorithm is at the heart of a diff/comm algorithm."
	self subclassResponsibility.
! !

!Diff2 methodsFor:'private'!

addCommonBlock: aSubCollection ifNonEmptyTo: aCollection
        aSubCollection isEmpty ifTrue:[
            ^ aSubCollection
        ] ifFalse: [
            aCollection add: #common -> aSubCollection asArray. 
            ^ OrderedCollection new.
        ]
!

emptyCaches
	"Subclasses should implement this to clear any cached state they may have built up."
!

maybeAddCommonBlock: common to: result p1: p1 p2: p2 limit1: limit1 limit2: limit2
	"For internal use by comm."
	((p1 + 1 ~= limit1) or: [p2 + 1 ~= limit2])
			ifTrue: [| newCommon |
					newCommon := self addCommonBlock: common ifNonEmptyTo: result.
					result add: #different -> ((file1 copyFrom: p1 + 1 to: limit1 - 1) ->
											(file2 copyFrom: p2 + 1 to: limit2 - 1)).
					^ newCommon]
			ifFalse: [^ common].
!

maybeAddDiffChunkTo: result p1: p1 p2: p2 limit1: limit1 limit2: limit2
        "For internal use by diffIndices."
        ((p1 + 1 ~= limit1) or: [p2 + 1 ~= limit2])
                        ifTrue: [result add: ((Diff2::Chunk offset: p1 + 1 length: limit1 - p1 - 1) ->
                                                                (Diff2::Chunk offset: p2 + 1 length: limit2 - p2 - 1))].

    "Modified: / 16-03-2012 / 19:13:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2::Chunk class methodsFor:'as yet unclassified'!

negativeSize: s
	"Returns a pseudo-chunk with *negative* length, useful as a kind of zero for destructiveMergeWith: operations intended to build up coverage over some set of chunks."
	^ self new offset: s + 1; length: s negated
!

offset: o length: l
	^ self new offset: o; length: l
! !

!Diff2::Chunk class methodsFor:'documentation'!

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
    A DiffChunk represents a span of items within a collection (e.g. a collection of lines representing a text file).

    Instance Variables
        length:                 <Integer> Count of lines within the chunk; 0 is permitted
        offset:                 <Integer> Index of first line within the chunk; 1-based

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff2::Chunk methodsFor:'accessing'!

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

printOn: aStream
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' offset: ';
		nextPutAll: self offset asString;
		nextPutAll: ' length: ';
		nextPutAll: self length asString;
		nextPut: $).
! !

!Diff2::Chunk methodsFor:'as yet unclassified'!

extractFrom: aCollection
	"Extracts a subcollection from aCollection corresponding to my offset and length."
	^ aCollection copyFrom: offset to: offset + length - 1.
!

extractSafeFrom: aCollection
    "Extracts a subcollection from aCollection corresponding to my offset and length.
     Returns nil if extraction fails (out of bounds)"
    ^((offset <= aCollection size) and:[(offset + length - 1) <= aCollection size]) ifTrue:[
        aCollection copyFrom: offset to: offset + length - 1
    ] ifFalse:[
        nil
    ].

    "Created: / 06-04-2012 / 12:37:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2::Chunk methodsFor:'comparing'!

< aDiffChunk
	"Used to sort changed chunks during three-way merge; see Diff3"
	^ self offset < aDiffChunk offset
!

= otherChunk
        ^ (otherChunk isKindOf: Diff2::Chunk) and:
        [(self offset = otherChunk offset) and:
        [(self length = otherChunk length)]]

    "Modified: / 16-03-2012 / 19:13:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2::HuntMcilroy class methodsFor:'documentation'!

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
    A HuntMcilroyDiff provides a longestCommonSubsequence algorithm following Hunt and McIlroy 1976 for use by the methods on GenericDiff.

    J. W. Hunt and M. D. McIlroy, An algorithm for differential file comparison, Bell Telephone Laboratories CSTR #41 (1976).
    http://www.cs.dartmouth.edu/~doug/

    Instance Variables
        lcs:            cached longest common subsequence

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff2::HuntMcilroy methodsFor:'accessing'!

emptyCaches
	lcs := nil.
! !

!Diff2::HuntMcilroy methodsFor:'diffing'!

longestCommonSubsequence
        | equivalenceClasses candidates |
        lcs ifNotNil: [ ^ lcs ].
        equivalenceClasses := self computeEquivalenceClasses.
        candidates := OrderedCollection with: (Candidate new 
                        file1index: 0
                        file2index: 0
                        chain: nil).
        file1 withIndexDo: 
                [ :line :file1index | 
                self 
                        mergeCandidates: candidates
                        file1index: file1index
                        file2indices: (equivalenceClasses 
                                        at: line
                                        ifAbsent: #()) ].
        lcs := self postprocessCandidateChain: candidates.
        ^ lcs

    "Modified: / 16-03-2012 / 19:14:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff2::HuntMcilroy methodsFor:'private'!

computeEquivalenceClasses
	| result |
	result := Dictionary new.
	file2 withIndexDo: 
		[ :line :index | 
		(result 
			at: line
			ifAbsentPut: [ OrderedCollection new ]) add: index ].
	^ result
!

findCandidateFrom: candidates forLine: file2index startingAt: lowIndex
        "Find the index k in the given subrange of candidates where file2index falls strictly between the file2indexes of the kth and k+1th candidates. If no such k exists, return 0."
        lowIndex to: candidates size do: [ :k |
                (candidates at: k) file2index >= file2index ifTrue: [^ 0].
                (k = candidates size or: [ (candidates at: k + 1) file2index > file2index ])
                        ifTrue: [^ k] ].
        ^ 0
!

mergeCandidates: candidates file1index: file1index file2indices: file2indices 
        | r c s newCandidate |
        r := 1.
        c := candidates at: r.
        file2indices do: 
                [ :file2index | 
                s := self findCandidateFrom: candidates forLine: file2index startingAt: r.
                s > 0 ifTrue: 
                        [ newCandidate := Candidate new   
                                file1index: file1index
                                file2index: file2index
                                chain: (candidates at: s).
                        self storeCandidate: c at: r in: candidates.
                        c := newCandidate.
                        r := s + 1.
                        "optimise by leaving early if s was the end of the candidates list, since none of the subsequent file2indices will have a place to go"
                        s = candidates size ifTrue: 
                                [ self storeCandidate: c at: r in: candidates. ^ self ] ] ].
        self storeCandidate: c at: r in: candidates.

    "Modified (format): / 16-03-2012 / 19:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postprocessCandidateChain: candidates 
	| result c |
	result := OrderedCollection new.
	c := candidates at: candidates size.
	[ c chain notNil ] whileTrue: 
		[ result add: c file1index -> c file2index.
		c := c chain ].
	^ result reversed.
!

storeCandidate: c at: r in: candidates
	r > candidates size ifTrue: [candidates add: c] ifFalse: [candidates at: r put: c].
! !

!Diff2::HuntMcilroy::Candidate class methodsFor:'documentation'!

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
    HuntMcilroyDiffCandidate is used internally by HuntMcilroyDiff.

    [author:]
        Tony Garnock-Jones <tonyg@kcbbs.gen.nz>

    [instance variables:]
        chain:                  Link to next candidate in chain.
        file1index:             Position in file1.
        file2index:             Position in file2.
    [class variables:]

    [see also:]

"
! !

!Diff2::HuntMcilroy::Candidate methodsFor:'accessing'!

chain
	^ chain
!

file1index
	^ file1index
!

file2index
	^ file2index
! !

!Diff2::HuntMcilroy::Candidate methodsFor:'as yet unclassified'!

file1index: f1 file2index: f2 chain: c
	file1index := f1.
	file2index := f2.
	chain := c.
! !

!Diff2::MyersUkkonen class methodsFor:'documentation'!

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
    I implement a modified version of Myers' greedy lcs algorithm described in http://xmailserver.org/diff2.pdf. 
    A similar version written in C can be found here http://research.janelia.org/myers/Papers/file.comparison.pdf. 
    Ukkonen's version can be found here http://www.cs.helsinki.fi/u/ukkonen/InfCont85.PDF.

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff2::MyersUkkonen methodsFor:'accessing'!

emptyCaches

	lcs := nil
! !

!Diff2::MyersUkkonen methodsFor:'diffing'!

longestCommonSubsequence
	
	^lcs ifNil: [ 
		lcs := (Array streamContents: [ :stream |
			| list |
			list := self calculateLcs.
			[ list == nil ] whileFalse: [
				stream nextPut: (list at: 1) -> (list at: 2).
				list := list at: 3 ] ]) reverse ]
! !

!Diff2::MyersUkkonen methodsFor:'private'!

calculateLcs
	"I find one of the longest common subsequences of my the arguments. I assume that none of my arguments are empty. I return nil or an Array which represents a list. The first two elements are the matching line numbers, the last is the next node in the list or nil if there are no more elements. The list containts the longest common subsequence. I'm a modified version of the greedy lcs algorithm from the 6th page of 'An O(ND) Difference Algorithm and Its Variations (1986)' by Eugene W. Myers"

    | n m v lcss max |
    n := file1 size.
    m := file2 size.
    max := m + n.
    v := Array new: 2 * max + 1.
    v at: max + 2 put: 0.
    lcss := Array new: 2 * max + 1.
    0 to: max do: [ :d |
	d negated to: d by: 2 do: [ :k |
	    | index chain x y |
	    (k + d = 0 or: [ k ~= d and: [ (v at: max + k ) < (v at: max + k + 2) ] ])
				ifTrue: [ 
					index := max + k + 2.
					x := v at: index ]
				ifFalse: [ 
					index := max + k.
					x := (v at: index) + 1 ].
			chain := lcss at: index.
			y := x - k.
			[ x < n and: [ y < m and: [ (file1 at: x + 1) = (file2 at: y + 1) ] ] ] whileTrue: [
			    chain := Array with: (x := x + 1) with: (y := y + 1) with: chain.
			].
			(x >= n and: [ y >= m ]) ifTrue: [
				^chain ].
			v at: max + k + 1 put: x.
			lcss at: max + k + 1 put: chain ] ].
	self error
! !

!Diff2::Patch class methodsFor:'documentation'!

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
    A DiffPatch has a collection of DiffChunks, and a collection of corresponding 
    SequenceableCollection snippets. It can be used to patch a file (= SequenceableCollection) 
    forwards or backwards.


    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]
        chunks:         <SequenceableCollection of DiffChunk->DiffChunk>
        snippets:       <SequenceableCollection of SequenceableCollection->SequenceableCollection>

    [class variables:]

    [see also:]

"
! !

!Diff2::Patch methodsFor:'accessing'!

applyTo: file
	"Applies this patch to the given collection. Makes no sanity checks on the contents of the collection - simply blindly applies the chunks and snippets to its argument."
	| result commonOffset |
	result := OrderedCollection new.
	commonOffset := 1.
	chunks with: snippets do: [:chunk :snippet |
		result addAll: (file copyFrom: commonOffset to: chunk key offset - 1).
		result addAll: (snippet value).
		commonOffset := chunk key offset + chunk key length].
	result addAll: (file copyFrom: commonOffset to: file size).
	^ result as: file species.
! !

!Diff2::Patch methodsFor:'as yet unclassified'!

initChunks: c file1: f1 file2: f2
	chunks := c.
	snippets := c collect: [:entry | (entry key extractFrom: f1) -> (entry value extractFrom: f2)].
! !

!Diff2::Patch methodsFor:'selecting'!

invert
	"Causes this patch to invert itself; if previously it represented the changes from file1 to file2, after being sent #invert, it will represent the changes from file2 to file1. After inversion, calling #applyTo: on file2 will yield file1, rather than the other way around."
	chunks do: [:entry | entry key: entry value value: entry key].
	snippets do: [:entry | entry key: entry value value: entry key].
! !

!Diff2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

