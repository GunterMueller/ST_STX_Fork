"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#SequenceableCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Abstract'
!

!SequenceableCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    SequenceableCollections have ordered elements which can be accessed via a numeric index.
    SequenceableCollection is an abstract class - there are no direct instances of it in the system.

    The methods found here assume that implementations of (at least)
    #at:/#at:put: are implemented (which are always found in Object for indexable objects).

    For performance, some subclasses redefine more methods, 
    knowing the detail of how elements are stored.

    Especially, bulk data manipulation (i.e. #replaceFrom:to:with:startingAt:)
    and search methods (i.e. #indexOf:startingAt:) are good candidates for this kind of tuneup.

    The most heavily used SequentialCollections in the system are probably Array, String, ByteArray
    OrderedCollection and SortedCollection.

    [author:]
        Claus Gittinger

    [see also:]
        Array ByteArray OrderedCollection SortedCollection 
        CharacterArray String
"
! !

!SequenceableCollection class methodsFor:'initialization'!

initialize
"/ now a class based exception
"/ method here left as a comment for a while.
"/ will go away soon...
"/    MissingClassInLiteralArrayErrorSignal isNil ifTrue:[
"/        MissingClassInLiteralArrayErrorSignal := Error newSignalMayProceed:true.
"/        MissingClassInLiteralArrayErrorSignal nameClass:self message:#missingClassInLiteralArrayErrorSignal.
"/        MissingClassInLiteralArrayErrorSignal notifierString:'Missing class in literal encoding'.
"/    ]

    "Created: / 18.5.1999 / 14:49:51 / cg"
! !

!SequenceableCollection class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray.
     Redefined for faster creation."

    |collection
     sz "{ Class: SmallInteger }"|

    sz := anArray size.
    collection := self mutableClass newWithSize:sz-1.
    2 to:sz do:[:idx| collection at:idx-1 put:(anArray at:idx) decodeAsLiteralArray].
    ^ collection

    "
     Array decodeFromLiteralArray:#(Array 1 2 3)
    "
!

new:size withAll:element
    "return a new collection of size, where all elements are
     initialized to element."

    |newCollection|

    newCollection := self new:size.
    newCollection atAllPut:element.
    ^ newCollection
!

newWithConcatenationOfAll:aCollectionOfCollections
    "this creates and returns a new collection consisting
     of the concatenation of all elements of the argument.
     I.e. it has the same effect as concatenating all elements
     of the argument using #, ,but is implemented more efficiently,
     by avoiding repeated garbage allocations.
     This is an O runtime algorithm, in contrast to the #, loop, which is O*O"

    |totalSize newColl idx|

    totalSize := aCollectionOfCollections
			inject:0
			into:[:sumSoFar :el | sumSoFar + el size].
    newColl := self new:totalSize.
    idx := 1.
    aCollectionOfCollections do:[:el |
	|sz|

	sz := el size.
	newColl replaceFrom:idx to:(idx+sz-1) with:el startingAt:1.
	idx := idx + sz
    ].
    ^ newColl

    "
     this method optimizes the following (common) operation:

	 |s|

	 s := ''.
	 #('hello' ' ' 'world' ' ' 'this is ' 'ST/X') do:[:e|
	    s := s , e.
	 ].
	 s

     String
	newWithConcatenationOfAll:#('hello' ' ' 'world' ' ' 'this is ' 'ST/X')

     String
	newWithConcatenationOfAll:#()

     Array
	newWithConcatenationOfAll:#( (1 2 3 4) (5 6 7 8) (9 10 11 12) )

     timing:
     -------
     speed-break-even is at around 5 elements for strings;
     for more elements, #newWithConcatenationOfAll: is much faster.

     |arr1 arr2 arr3 t|

     arr1 := #('hello' ' ' 'world' ' ' 'this is ' 'ST/X').
     arr2 := Array new:1000 withAll:'hello'.
     arr3 := Array new:10000 withAll:'hello'.

     (Array with:arr1 with:arr2 with:arr3) with:#(10000 100 10) do:[:arr :cnt |
	 t := Time millisecondsToRun:[
	    cnt timesRepeat:[
		String
		    newWithConcatenationOfAll:arr
	    ]
	 ].
	 Transcript showCR:(arr size printString , ' elements - time for #newWithConcatenationOfAll :' , (t/cnt) asFloat printString , 'mS').
	 Transcript endEntry.

	 t := Time millisecondsToRun:[
	    cnt timesRepeat:[
		 |s|

		 s := ''.
		 arr do:[:e|
		    s := s , e.
		 ].
		 s
	    ]
	 ].
	 Transcript showCR:(arr size printString , ' elements - time for loop over #, :' , (t/cnt) asFloat printString , 'mS').
	 Transcript endEntry.
     ]
    "
!

newWithSize:size
    "return a new collection of size.
     For variable size collections, this is different from #new:,
     in that #new: creates an empty collection with preallocated size,
     while #withSize: creates a non empty one."

    ^ (self new:size) grow:size.

    "
     (OrderedCollection new:10) inspect.
     (OrderedCollection withSize:10) inspect.
     (Array new:10) inspect.
     (Array withSize:10) inspect.
    "
! !

!SequenceableCollection class methodsFor:'Signal constants'!

missingClassInLiteralArrayErrorSignal
    "raised when decoding a literal array spec,
     when a non-existing class is encountered
     (i.e. a spec-element of the form (ClassNameSymbol args...),
      where ClassNameSymbol refers to a non-existing class)"
      
    "/ now a class based exception.
    "/ method here will vanish sometime..
    ^ MissingClassInLiteralArrayErrorSignal

    "Created: / 18.5.1999 / 14:50:04 / cg"
! !

!SequenceableCollection class methodsFor:'instance creation-multiDimensional'!

_at:nIndices
    "this is a synthetic selector, generated by the compiler,
     if a construct of the form expr[idx...] is parsed.
     I.e.
	Array[n]
     generates
	Array _at: n
    "

    ^ self new:nIndices
!

_at:dim1 at:dim2
    "this is a synthetic selector, generated by the compiler,
     if a construct of the form expr[idx...] is parsed.
     I.e.
        Array[n,m]
     generates
        Array _at:n at:m
    "

    |data|

    data := self newWithSize:(dim1 * dim2).
    ^ MultiDimensionalArrayAccessor
        collection:data
        dimensions:(Array with:dim1 with:dim2)
!

_at:dim1 at:dim2 at:dim3
    "this is a synthetic selector, generated by the compiler,
     if a construct of the form expr[idx...] is parsed.
     I.e.
        Array[n,m,o]
     generates
        Array _at:n at:m at:o
    "

    |data|

    data := self newWithSize:(dim1 * dim2 * dim3).
    ^ MultiDimensionalArrayAccessor
        collection:data
        dimensions:(Array with:dim1 with:dim2 with:dim3)
! !

!SequenceableCollection class methodsFor:'instance creation-streaming'!

new:newSize streamContents:blockWithArg 
    "create a write-stream on an instance of the receiver-class with initial size,
     evaluate blockWithArg, passing that stream,
     extract and return the streams contents."

    |stream|

    stream := WriteStream on:(self new:newSize).
    blockWithArg value:stream.
    ^ stream contents
!

new:initialSize withCollectedContents:blockWithArg
    "create an instance of the receiver-class,
     evaluate blockWithArg, passing that instance,
     return the instance.
     Similar to streamContents, but passes the collection to the block,
     instead of a stream."

    |inst|

    inst := self new:initialSize.
    blockWithArg value:inst.
    ^ inst

    "
     |rslt|

     rslt := OrderedCollection new:10 withCollectedContents:[:c | c add:'hello'; add:'world']
    "
!

streamContents:blockWithArg
    "create a write-stream on an instance of the receiver-class,
     evaluate blockWithArg, passing that stream,
     extract and return the streams contents."

    |stream|

    stream := self writeStream.
    blockWithArg value:stream.
    ^ stream contents

    "
     |rslt|

     rslt := String streamContents:[:s | s nextPutAll:'hello'; space; nextPutAll:'world']
    "

    "Modified: / 29-03-2007 / 15:20:20 / cg"
!

streamContents:blockWithArg limitedTo:limit
    "create a limited write-stream on an instance of the receiver-class,
     evaluate blockWithArg, passing that stream,
     extract and return the streams contents (possibly truncated)."

    |stream|

    stream := self writeStream.
    stream writeLimit:limit.
    blockWithArg value:stream.
    ^ stream contents

    "Created: / 04-06-2007 / 17:22:38 / cg"
!

streamContentsEnumerating:aReceiver using:enumeratorSelector
    "create a write-stream on an instance of the receiver-class,
     enumerate on aReceiver using enumeratorSelector as a do-block-selector,
     and return the collected values. Especially useful, if you have a do-like
     enumerator somewhere, and you want this as a collection."

    |stream|

    stream := self writeStream.
    aReceiver perform:enumeratorSelector with:[:each |stream nextPut:each].
    ^ stream contents

    "
     String streamContentsEnumerating:'hello' using:#reverseDo:
     Array streamContentsEnumerating:Method using:#allInstancesDo:
    "

    "Created: / 29-03-2007 / 15:21:12 / cg"
!

streamContentsOf:aReceiver enumerator:enumeratorSelector
    "create a write-stream on an instance of the receiver-class,
     enumerate on aReceiver using enumeratorSelector as a do-block-selector,
     and return the collected values. Especially useful, if you have a do-like
     enumerator somewhere, and you want this as a collection."

    |stream|

    stream := self writeStream.
    aReceiver perform:enumeratorSelector with:[:each |stream nextPut:each].
    ^ stream contents

    "
     String streamContentsOf:'hello' enumerator:#reverseDo:
     Array streamContentsOf:Method enumerator:#allInstancesDo:
    "

    "Created: / 29-03-2007 / 15:05:30 / cg"
!

withCollectedContents:blockWithArg
    "create an instance of the receiver-class,
     evaluate blockWithArg, passing that instance,
     return the instance.
     Similar to streamContents, but passes the collection to the block,
     instead of a stream."

    |inst|

    inst := self new.
    blockWithArg value:inst.
    ^ inst

    "
     |rslt|

     rslt := OrderedCollection withCollectedContents:[:c | c add:'hello'; add:'world']
    "
!

writeStream
    "create a write-stream on an instance of the receiver-class"

    ^ self writeStreamClass on:(self new:50).

    "
     OrderedCollection writeStream
     Text writeStream
    "

    "Modified: / 09-01-2011 / 10:37:35 / cg"
!

writeStreamWithInitialSize:l
    "create a write-stream on an instance of the receiver-class"

    ^ self writeStreamClass on:(self new:l).

    "
     OrderedCollection writeStream
    "

    "Created: / 09-01-2011 / 10:36:28 / cg"
! !

!SequenceableCollection class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for SequenceableCollection here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == SequenceableCollection
! !


!SequenceableCollection methodsFor:'Compatibility-Squeak'!

allButFirst
    "Return a copy of the receiver containing all but the first element.
     Returns an empty collection if there are not at least two elements.
     Differs from #copyButFirst in its error behavior."

    ^ self allButFirst:1

    "
     '1234567890' allButFirst
     'ab' allButFirst
     'a' allButFirst
     '' allButFirst

     '' copyButFirst
    "
!

allButFirst:n
    "Return a copy of the receiver containing all but the first n elements.
     Returns a short (or empty) collection if there are not enough elements.
     Differs from #copyButFirst: in its error behavior."

    n > self size ifTrue:[^ self copyEmpty].
    ^ self copyFrom:n+1

    "
     '1234567890' allButFirst:5 
     '123456' allButFirst:5       
     '12345' allButFirst:5       
     '1234' allButFirst:5       

     '1234' copyButFirst:5       
    "
!

allButLast
    "Return a copy of the receiver containing all but the last element.
     Returns an empty collection if there are not at least two elements.
     Differs from #copyButFirst: in its error behavior."

    ^ self allButLast:1

    "
     '1234567890' allButLast
     'ab' allButLast
     '0' allButLast
     '' allButLast

     '' copyButLast
    "

    "Modified: / 13.11.2001 / 13:36:36 / cg"
!

allButLast:n
    "Return a copy of the receiver containing all but the last n elements.
     Returns a short (or empty) collection if there are not enough elements.
     Differs from #copyButFirst: in its error behavior."

    |mySize|

    mySize := self size.
    n >= mySize ifTrue:[^ self copyEmpty].
    ^ self copyFrom: 1 to: (mySize - n)

    "
     '1234567890' allButLast:5
     '12345' allButLast:5
     '123' allButLast:5
     { 1 . 2 . 3 . 4 . 5 . 6 . 7} asOrderedCollection allButLast:5
     { 1 . 2 . 3 . 4 . 5} asOrderedCollection allButLast:5
     { 1 . 2 . 3 } asOrderedCollection allButLast:5
     '' allButLast:5

     '' copyButLast:5
    "

    "Modified: / 13.11.2001 / 13:36:28 / cg"
!

atPin: index
    "Return the index'th element of me if possible.
     Return the first or last element if index is out of bounds."

    index < 1 ifTrue:[^ self first].
    index > self size ifTrue:[^ self last].
    ^ self at:index

    "
     #(1 2 3) atPin:4
     #(1 2 3) atPin:0
     #(1 2 3) atPin:1
     #(1 2 3) atPin:3
    "
!

atRandom
    "Return any random element from the receiver"

    ^ self atRandom:Random

    "
     #(1 2 3) atRandom
    "
!

atRandom:aRandomGenerator
    "Return any random element from the receiver"

    |max idx|

    (max := self size) == 0 ifTrue:[
	self emptyCollectionError
    ].
    idx := aRandomGenerator nextIntegerBetween:1 and:max.
    ^ self at:idx

    "
     #(1 2 3) atRandom:(Random new)
    "
!

atWrap:index
    "Return the index'th element of me if possible.
     Wrap the index modulu the receiver's size if it is out of bounds."

    ^ self at:((index - 1) \\ (self size)) + 1

    "
     #(1 2 3) atWrap:1
     #(1 2 3) atWrap:2
     #(1 2 3) atWrap:3
     #(1 2 3) atWrap:4
     #(1 2 3) atWrap:5
     #(1 2 3) atWrap:6
     #(1 2 3) atWrap:7
     #(1 2 3) atWrap:0
     #(1 2 3) atWrap:-1
    "
!

collect:aBlock from:startIndex to:stopIndex
    "squeak uses a different naming here - sigh.
     Notice, that the squeak name is actually wrong and misleading, as it suggests
     collecting first and then taking the subcollection; this is wrong, as conceptually,
     this method first takes a slice (from:to:) and then collects over that.
     I.e. it is equivalent to:
	(self startIndex to:stopIndex) collect:aBlock"

    ^ self from:startIndex to:stopIndex collect:aBlock
!

copyUpToLast:element
    "return a copy of the receiver up to (but excluding) the last occurrence
     of element; uses = for comparison"

    |idx|

    idx := self lastIndexOf:element.
    idx == 0 ifTrue:[idx := self size + 1].
    ^ self copyTo:idx - 1

    "
     'hello world' copyUpToLast:$l
     '123456123456' copyUpToLast:$2
     #(1 2 3 4 1 2 3 3 4 5 6) copyUpToLast:3
     #(1 2 3 4 2 3 3 4 5 6) copyUpToLast:1
     #(1 2 3 4 1 2 3 3 4 5 6) copyUpToLast:7
    "
!

copyWithoutAll:elementsToSkip
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to any in elementsToSkip are left out.
     No error is reported, if any in elementsToSkip is not in the collection."

    |n         "{ Class: SmallInteger }"
     sz        "{ Class: SmallInteger }"
     srcIndex  "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"
     skipIndex "{ Class: SmallInteger }"
     copy l|

    "the code below may look like overkill,
     however, for big collections its better to move data
     around in big chunks"

    n := self occurrencesOfAny:elementsToSkip.
    n == 0 ifTrue:[^ self copyFrom:1].

    sz := self size.
    copy := self copyEmptyAndGrow:(sz - n).

    srcIndex := 1.
    dstIndex := 1.

    n timesRepeat:[
        skipIndex := self indexOfAny:elementsToSkip startingAt:srcIndex.
        l := skipIndex - srcIndex.
        l ~~ 0 ifTrue:[
            copy replaceFrom:dstIndex to:(dstIndex + l - 1)
                        with:self startingAt:srcIndex.
            dstIndex := dstIndex + l
        ].
        srcIndex := skipIndex + 1
    ].
    l := sz - srcIndex.
    copy replaceFrom:dstIndex to:(dstIndex + l)
                with:self startingAt:srcIndex.
    ^ copy

    "
     #($a $b $c $d $e $f $g) copyWithoutAll:#($d $b $f)
     'abcdefghi' copyWithoutAll:'hai'
     #(90 80 70 80 60 45 80 50) copyWithoutAll:#(80 70 45)
    "
!

copyWithoutFirst
    "An alias for copyButFirst: for squeak compatibility.
     Raises an error, if the receiver is empty."

    self isEmpty ifTrue:[ self notEnoughElementsError ].
    ^ self copyFrom:2

    "
     'foo' copyWithoutFirst
     'f' copyWithoutFirst
     '' copyWithoutFirst
    "
!

joinWith:separatingElement
    "return a collection generated by concatenating my elements
     and embedding separatingElement in between.
     Similar to asStringWith:, but not specifically targeted towards collections of strings."

    ^ self
        joinWithAll:(Array with:separatingElement)
        from:1 to:(self size) as:nil

    "
     #('hello' 'world' 'foo' 'bar' 'baz') joinWith:$;   
     #('hello' 'world' 'foo' 'bar' 'baz') joinWith:$|
     #('hello' 'world' 'foo' 'bar' 'baz') joinWithAll:'; '
    "                                     
!

shuffled
    "return a randomly shuffled copy of the receiver"

    ^ self shuffledBy:Random

    "
     #(1 2 3 4 5 6 7 8 9) shuffled.
     #(1 2 3 4 5 6 7 8 9) shuffled. 
    "
!

shuffledBy:aRandom
    "return a randomly shuffled copy of the receiver, using the given random generator"

    |copy|

    copy := self shallowCopy.
    copy size to: 1 by: -1 do:[:i | 
        copy swap: i with: (aRandom nextIntegerBetween:1 and:i)
    ].
    ^ copy

    "
     #(1 2 3 4 5 6 7 8 9) shuffledBy:(Random new).
     #(1 2 3 4 5 6 7 8 9) shuffledBy:(Random new). 
    "
!

sortBy:aBlock
    "Sort inplace - destructive"

    self sort:aBlock

    "Created: / 22-10-2008 / 21:25:35 / cg"
! !

!SequenceableCollection methodsFor:'Compatibility-V''Age'!

replaceFrom:start to:end withObject:anObject
    "Replace the elements from start to end with anObject.
     Return the receiver."

    self from:start to:end put:anObject.
    ^ self.

    "
     |a|

     a := Array new: 10.
     a replaceFrom:3 to:7 withObject:999.
     a
    "

    "Created: / 16-05-2012 / 11:13:55 / cg"
! !

!SequenceableCollection methodsFor:'Compatibility-VW'!

replaceElementsFrom:start to:stop withArray:anArray startingAt:repStart
    ^ self replaceFrom:start to:stop with:anArray startingAt:repStart
! !


!SequenceableCollection methodsFor:'accessing'!

after:anObject
    "return the element, after anObject.
     If anObject is not in the receiver, report an error;
     if anObject is the last in the receiver, return nil.
     This depends on #after:ifAbsent: being implemented in a concrete class."

    ^ self after:anObject ifAbsent:[self errorValueNotFound:anObject]

    "
     #(4 3 2 1) asOrderedCollection after:3.
     #(4 3 2 1) asOrderedCollection after:5
     #(4 3 2 1) asOrderedCollection after:1
    "

    "Created: 10.5.1996 / 13:59:29 / cg"
    "Modified: 10.5.1996 / 14:03:33 / cg"
!

after:anObject ifAbsent:exceptionBlock
    "return the element, after anObject.
     If anObject is the last in the receiver, return nil.
     If there is no such element (anObject is not found),
     return the value from exceptionBlock."

    |idx|

    idx := self indexOf:anObject.
    idx ~~ 0 ifTrue:[
	idx == self size ifTrue:[^ nil].
	^ self at:(idx + 1).
    ].
    ^ exceptionBlock value

    "
     #(4 3 2 1) after:3 ifAbsent:nil.
     (2 to:10 by:2) after:4 ifAbsent:nil.
     #(4 3 2 1) asOrderedCollection after:5 ifAbsent:nil.
     (2 to:10 by:2) after:5 ifAbsent:nil.
    "
!

anElement
    "return any element from the collection,
     report an error if there is none.
     Use this to fetch the some element from a collection which is non-indexed or which
     has a non-numeric index. I.e. if someone gets an arbitrary collection which might be either indexable
     or not, anElement is a save way to access some element without a need to check for a proper key."

    ^ self at:1

    "
     #() anElement            -> Error
     #(1 2 3) anElement       -> 1
     #(1 2 3) asSet anElement -> any one (undefined which one)
    "
!

at:index ifAbsent:exceptionBlock
    "return the element at index if valid.
     If the index is invalid, return the result of evaluating
     the exceptionblock.
     NOTICE:
	in ST-80, this message is only defined for Dictionaries,
	however, having a common protocol with indexed collections
	often simplifies things."

    (index between:1 and:self size) ifFalse:[
	^ exceptionBlock value
    ].
    ^ self at:index

    "
     #(1 2 3) at:4 ifAbsent:['no such index']
     #(1 2 3) asOrderedCollection at:4 ifAbsent:['no such index']
     #(1 2 3) at:4 ifAbsent:['no such index']

     (Dictionary with:(#foo -> #bar)
		 with:(#frob -> #baz))
	 at:#foobar ifAbsent:['no such index']
    "
!

atAllIndices:indexCollection
    "return the elements at each index from indexCollection."

    ^ indexCollection collect:[:eachIdx | self at:eachIdx].

    "
     'abcdefghijklmnopqrstuvwxyz' atAllIndices:#( 8 5 12 12 15) 
     'abcdefghijklmnopqrstuvwxyz' atAllIndices:( 5 to: 10) 
    "

    "Created: / 08-08-2010 / 01:15:06 / cg"
!

atIndex:index
    "return an element at a given index. This allows for seqentialCollections
     and orderedDictionaries to be both accessed via a numeric index."

    ^ self at:index

    "Created: / 08-08-2010 / 00:50:10 / cg"
!

atIndex:index ifAbsent:absentBlock
    "return an element at a given index. This allows for seqenveableCollections
     and orderedDictionaries to be both accessed via a numeric index."

    ^ self at:index ifAbsent:absentBlock
!

atIndex:index put:newValue
    "return an element at a given index. This allows for seqentialCollections
     and orderedDictionaries to be both accessed via a numeric index."

    ^ self at:index put:newValue

    "Created: / 08-08-2010 / 00:50:27 / cg"
!

before:anObject
    "return the element before the argument, anObject.
     If anObject is not in the receiver, report an error;
     if anObject is the first in the receiver, return nil.
     This depends on #before:ifAbsent: being implemented in a concrete class."

    ^ self before:anObject ifAbsent:[self errorValueNotFound:anObject]

    "
     #(4 3 2 1) asOrderedCollection before:3.
     #(4 3 2 1) asOrderedCollection before:4
     #(4 3 2 1) asOrderedCollection before:0
    "

    "Created: 10.5.1996 / 14:03:27 / cg"
    "Modified: 10.5.1996 / 14:03:44 / cg"
!

before:anObject ifAbsent:exceptionBlock
    "return the element, before anObject.
     If anObject is the first in the receiver, return nil.
     If there is no such element (anObject is not found),
     return the value from exceptionBlock."

    |idx|

    idx := self indexOf:anObject.
    idx ~~ 0 ifTrue:[
	idx == 1 ifTrue:[^ nil].
	^ self at:(idx - 1).
    ].
    ^ exceptionBlock value

    "
     #(4 3 2 1) asOrderedCollection before:3 ifAbsent:nil.
     #(4 3 2 1) asOrderedCollection before:5 ifAbsent:nil.
     #(4 3 2 1) asOrderedCollection before:5.
     #(4 3 2 1) asOrderedCollection before:4 ifAbsent:nil.
     #(4 3 2 1) asOrderedCollection before:4.
     (2 to:10 by:2) before:4 ifAbsent:nil.
     (2 to:10 by:2) before:5 ifAbsent:nil.
    "

!

first
    "return the first element;
     report an error, if the collection is empty."

    self isEmpty ifTrue:[^ self emptyCollectionError].
    ^ self at:1

    "
     args:
     returns: firstElement <object>
    "

    "Modified: / 20.5.1998 / 14:50:25 / cg"
!

first:n
    "return the n first elements of the collection.
     No longer raises an error if there are not enough elements;
     instead, returns what is there"

    n < 0 ifTrue:[self error:'bad (negative) argument'].

    "/ OLD:
    "/ "error if collection has not enough elements"
    "/ n > self size ifTrue:[
    "/     ^ self notEnoughElementsError
    "/ ].

    "/ NEW:
    "/ return what we have - no error if not enough elements
    ^ self copyFirst:(n min:self size)

    "
     #(1 2 3 4 5) first:3
     #(1 2 3 4 5) first:6
     #(1 2 3 4 5) asSet first:3
     'hello world' first:5
    "
!

indexOfNth:n occurrenceOf:what
    "return the index of the nTh occurrence of a value, or 0 if there are not that many"

    |idx cnt|

    n > self size ifTrue:[^ 0].
    cnt := 0.
    idx := 0.
    [
        idx := self indexOf:what startingAt:idx+1.
        idx == 0 ifTrue:[^ 0].
        cnt := cnt + 1.
        cnt = n ifTrue:[ ^ idx].
    ] loop.

    "  1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6
     #(1 2 3 4 1 2 3 1 9 8 7 1 7 8 9 0) indexOfNth:3 occurrenceOf:1
     #(1 2 3 4 1 2 3 1 9 8 7 1 7 8 9 0) indexOfNth:2 occurrenceOf:7
     #(1 2 3 4 1 2 3 1 9 8 7 1 7 8 9 0) indexOfNth:3 occurrenceOf:9
    "
!

keyAtEqualValue:value
    "return the index of a value.
     This is normally not used (use indexOf:), but makes the
     protocol more compatible with dictionaries."

    ^ self indexOf:value
!

keyAtEqualValue:value ifAbsent:exceptionBlock
    "return the index of a value.
     This is normally not used (use indexOf:), but makes the
     protocol more compatible with dictionaries."

    ^ self indexOf:value ifAbsent:exceptionBlock
!

keyAtValue:value
    "return the index of a value.
     This is normally not used (use indexOf:), but makes the
     protocol more compatible with dictionaries."

    ^ self identityIndexOf:value
!

keyAtValue:value ifAbsent:exceptionBlock
    "return the index of a value.
     This is normally not used (use indexOf:), but makes the
     protocol more compatible with dictionaries."

    ^ self identityIndexOf:value ifAbsent:exceptionBlock
!

last
    "return the last element;
     report an error, if the collection is empty."

    |sz|

    (sz := self size) == 0 ifFalse:[
	^ self at:sz
    ].
    "error if collection is empty"
    ^ self emptyCollectionError

    "
     #(1 2 3 4 5) last
     #() last
    "
!

last:n
    "return the n last elements of the collection.
     No longer raises an error if there are not enough elements;
     instead, returns what is there."

    n < 0 ifTrue:[self error:'bad (negative) argument'].
    "/ OLD:
    "/ n > self size ifTrue:[^ self notEnoughElementsError].

    ^ self copyLast:(n min:self size)

    "
     #(1 2 3 4 5) last:3
     #(1 2 3 4 5) last:6
     #(1 2 3 4 5) asSet last:3
     'hello world' last:5
     'hello' last:10
    "
!

nth:n
    "return the nth element;
     report an error, if the collections size is smaller than n."

    ^ self at:n

    "
     args:
     returns: nth element <object>
    "

    "
     #(10 20 30 40 50) nth:4
     #(10 20 30 40 50) nth:6
     #() nth:1
    "

!

order
    "the order is the set of keys "

    ^ 1 to:self size
!

second
    "return the second element;
     report an error, if the collections size is smaller than 2."

    ^ self at:2

    "
     args:
     returns: secondElement <object>
    "

    "Modified: / 20.5.1998 / 14:50:25 / cg"
!

secondLast
    "return the second last element;
     report an error, if the collection does not contain at least
     2 elements."

    |sz|

    (sz := self size) > 1 ifTrue:[
        ^ self at:(sz-1)
    ].
    "error if collection does not contain at least 2 elments"
    ^ self notEnoughElementsError

    "
     #(1 2 3 4 5) secondLast
     #(1) secondLast
     #() secondLast
    "
!

swap:index1 with:index2
    "exchange two elements"

    |t|

    t := self at:index1.
    self at:index1 put:(self at:index2).
    self at:index2 put:t

    "Modified: 15.10.1997 / 19:27:08 / cg"
! !

!SequenceableCollection methodsFor:'adding & removing'!

add:anObject
    "append the argument, anObject to the collection.
     Return the argument, anObject.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |newSize|

    newSize := self size + 1.
    self grow:newSize.
    self at:newSize put:anObject.
    ^ anObject

    "
     |a|
     a := #(1 2 3 4 5 6 7 8).
     a add:'hello'.
     a
    "
    "
     |c|
     c := #(1 2 3 4 5 6 7 8) asOrderedCollection.
     c add:'hello'.
     c
    "
!

add:anElement beforeIndex:index
    "insert the first argument, anObject into the collection before slot index.
     Return the receiver (sigh - ST-80 compatibility).

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |newSize|

    newSize := self size + 1.
    self grow:newSize.
    self replaceFrom:index + 1 to:newSize with:self startingAt:index.
    self at:index put:anElement

    "
     #(1 2 3 4 5 6 7 8) add:'hello' beforeIndex:5
    "
!

addAll:aCollection beforeIndex:index
    "insert all elements of the argument, anObject to become located at index.
     The collection may be unordered, but then order of the sliced-in elements
     is undefined.
     Return the receiver."

    |idx|

    idx := index.
    aCollection do:[:element |
        self add:element beforeIndex:idx.
        idx := idx + 1.
    ].

    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:3   
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c removeFirst.
     c addAll:'here' beforeIndex:3   
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:1    
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:5     
    "

    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:('hello' asSet) beforeIndex:3
    "

    "Modified: 15.4.1997 / 12:43:59 / cg"
!

addFirst:anObject
    "prepend the argument, anObject to the collection.
     Return the argument, anObject.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |newSize|

    newSize := self size + 1.
    self grow:newSize.
    self replaceFrom:2 to:newSize with:self startingAt:1.
    self at:1 put:anObject.
    ^ anObject

    "
     |a|
     a:= #(1 2 3 4 5 6 7 8).
     a addFirst:'hello'.
     a
    "
    "
     |c|
     c := #(1 2 3 4 5 6 7 8) asOrderedCollection.
     c addFirst:'hello'.
     c
    "
!

remove:anElement ifAbsent:aBlock
    "search for the first occurrence of object
     (i.e. which is equal to anElement)
     If found remove and return it;
     if not, return the value from evaluating aBlock.
     Use equality compare (=) to search for an occurrence.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |any foundElement
     dstIndex "{ Class: SmallInteger }"
     sz       "{ Class: SmallInteger }"|

    any := false.
    sz := self size.
    1 to:sz do:[:srcIndex |
        any ifFalse:[
            "/ still searching
            (anElement = (foundElement := self at:srcIndex)) ifTrue:[
                any := true.
                dstIndex := srcIndex.
            ]
        ] ifTrue:[
            "/ already copying
            self at:dstIndex put:(self at:srcIndex).
            dstIndex := dstIndex + 1
        ]
    ].
    any ifTrue:[
        self grow:dstIndex - 1.
        ^ foundElement
    ].
    ^ aBlock value

    "
     #(1 2 3 4 5 6 7 8 9 0) remove:3 ifAbsent:[Transcript showCR:'no']
     #(1 2 3 4 5 6 7 8 9 0) remove:99 ifAbsent:[#oops]
     #(1.0 2.0 3.0 4.0 5.0) remove:5 ifAbsent:[#oops]
     #(1.0 2.0 3.0 4.0 5.0) removeIdentical:5 ifAbsent:[#oops]

     |a|
     a := #(1 2 3 1 2 3 1 2 3).
     a remove:3.
     a

     |a|
     a := #(1 2 3 1 2 3 1 2 3) asOrderedCollection.
     a remove:3.
     a
    "

    "Modified: 1.2.1997 / 11:49:01 / cg"
!

removeAllSuchThat:aBlock
    "remove all elements that meet a test criteria as specified in aBlock.
     The argument, aBlock is evaluated for successive elements and all those,
     for which it returns true, are removed.
     Return a collection containing the removed elements."

    "/ this is a q&d implementation (possibly slow).

    |runIndex removed element stop|

    removed := self species new.

    runIndex := 1.
    stop := self size.
    [runIndex <= stop] whileTrue:[
        element := self at:runIndex.
        (aBlock value:element) ifTrue:[
            removed add:element.
            self removeAtIndex:runIndex.
            stop := self size. "/ could probably go along with stop := stop - 1
        ] ifFalse:[
            runIndex := runIndex + 1
        ]
    ].
    ^ removed

    "
     |coll|

     coll := OrderedCollection withAll:(1 to:10).
     Transcript showCR:(coll removeAllSuchThat:[:el | el even]).
     Transcript showCR:coll
    "

    "Created: 11.5.1996 / 09:49:30 / cg"
!

removeAtIndex:anIndex
    "remove the element stored at anIndex. Return the removed object.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |element|

    element := self at:anIndex.
    self removeFromIndex:anIndex toIndex:anIndex.
    ^ element

    "
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeAtIndex:3
     #(1 2 3 4 5) asOrderedCollection removeAtIndex:6
     #($a $b $c $d $e $f $g) removeAtIndex:3
    "
!

removeFirst
    "remove the first element of the receiver and return it.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    ^ self removeAtIndex:1

    "
     |a|
     a := #(1 2 3 4 5 6).
     a removeFirst.
     a
    "
!

removeFromIndex:startIndex
    "remove the elements stored at indexes from startIndex to the end.
     Return the receiver.
     Returning the receiver is a historic leftover - it may at one
     time return a collection of the removed elements.

     Notice that this modifies the receiver, NOT a copy;
     therefore any other users of the receiver will also see this change.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    ^ self removeFromIndex:startIndex toIndex:(self size)

    "
     #(1 2 3 4 5 6 7 8 9 0) asOrderedCollection removeFromIndex:3
     #(1 2 3 4 5 6 7 8 9 0) removeFromIndex:3
    "

    "Modified: 28.1.1997 / 12:35:20 / cg"
!

removeFromIndex:startIndex toIndex:endIndex
    "remove the elements stored at indexes between startIndex and endIndex.
     Return the receiver.

     Notice that this modifies the receiver, NOT a copy;
     therefore any other users of the receiver will also see this change.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |size newSize|

    (endIndex >= (size := self size)) ifTrue:[
        self grow:(startIndex - 1)
    ] ifFalse:[
        newSize := size - endIndex + startIndex - 1.
        self replaceFrom:startIndex to:newSize with:self startingAt:(endIndex + 1).
        self grow:newSize
    ]

"/    |newSize|
"/
"/    newSize := self size - endIndex + startIndex - 1.
"/    newSize <= 0 ifTrue:[
"/        self grow:0
"/    ] ifFalse:[
"/        self replaceFrom:startIndex to:newSize with:self startingAt:(endIndex + 1).
"/        self grow:newSize
"/    ]

    "
     #(1 2 3 4 5 6 7 8 9 0) asOrderedCollection removeFromIndex:3 toIndex:5
     #(1 2 3 4 5 6 7 8 9 0) removeFromIndex:3 toIndex:5
     #(1 2 3 4 5 6 7 8 9 0) asOrderedCollection removeFromIndex:1 toIndex:10
     #(1 2 3 4 5 6 7 8 9 0) removeFromIndex:1 toIndex:10
    "
!

removeIdentical:anElement ifAbsent:aBlock
    "search for an object which is identical to anElement;
     if found remove and return it; if not, return the value from evaluating aBlock.
     Uses identity compare (==) to search for an occurrence.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    |any
     dstIndex "{ Class: SmallInteger }"
     sz       "{ Class: SmallInteger }"|

    any := false.
    sz := self size.
    1 to:sz do:[:srcIndex |
        any ifFalse:[
            "/ still searching
            (anElement == (self at:srcIndex)) ifTrue:[
                any := true.
                dstIndex := srcIndex.
            ]    
        ] ifTrue:[
            "/ already copying
            self at:dstIndex put:(self at:srcIndex).
            dstIndex := dstIndex + 1
        ]
    ].
    any ifTrue:[
        self grow:dstIndex - 1.
        ^ anElement
    ].
    ^ aBlock value

    "
     #(1.0 2.0 3.0 4.0 5.0) remove:5 ifAbsent:[#oops]
     #(1.0 2.0 3.0 4.0 5.0) removeIdentical:5 ifAbsent:[#oops]
    "

    "Modified: 8.2.1997 / 16:26:49 / cg"
!

removeIndex:index
    "remove the argument stored at index. Return the receiver.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    self removeFromIndex:index toIndex:index

    "
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeIndex:3
     #(1 2 3 4 5) asOrderedCollection removeIndex:6
     #($a $b $c $d $e $f $g) removeIndex:3
    "
!

removeLast
    "remove the last element of the receiver and return it.

     Notice that this modifies the receiver, NOT a copy.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    ^ self removeAtIndex:(self size)

    "
     |a|
     a := #(1 2 3 4 5 6).
     a removeLast.
     a
    "
!

removeToIndex:index
    "remove the elements stored at indexes from 1 to index to the beginning.
     Return the receiver.

     Notice that this modifies the receiver, NOT a copy;
     therefore any other users of the receiver will also see this change.
     Also note that it may be a slow operation for some collections,
     due to the grow:-message, which is inefficient for fixed size
     collections (i.e. for Strings and Arrays it is not recommended)."

    ^ self removeFromIndex:1 toIndex:index

    "
     |t|
     t := #(1 2 3 4 5 6 7 8 9 0) asOrderedCollection.
     t removeToIndex:3.
     t
    "
! !

!SequenceableCollection methodsFor:'combinatoric'!

combinationsDo: aBlock
    "Repeatly evaluate aBlock with all combinations of elements from the receiver's elements. 
     The receiver's elements must be collections of the individuals to be taken for the combinations"

    self combinationsStartingAt:1 prefix:#() do:aBlock

    "
     (Array 
            with:($a to:$d)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
    "
     (Array 
            with:($a to:$d)
            with:(1 to: 4)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
    "
     will print a1, a2, a3, a4, b1, ... , d1, d2, d3, d4
    "
    "all combinations of two letters are generated with:
     (Array 
            with:($a to:$z)
            with:($a to:$z)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
    "
     (Array 
            with:#(1 2 3 4 5 6 7 8 9)
            with:#(A)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
!

combinationsStartingAt:anInteger prefix:prefix do:aBlock
    "a helper for combinationsDo:"

    |loopedElement|

    loopedElement := self at:anInteger.

    anInteger == self size ifTrue:[
        loopedElement do:[:el | aBlock value:(prefix copyWith:el)].
        ^ self.
    ].

    loopedElement do:[:el |
        |newPrefix|

        newPrefix := (prefix copyWith:el).
        self combinationsStartingAt:anInteger+1 prefix:newPrefix do:aBlock
    ].

    "
     (Array 
            with:($a to:$d)
            with:(1 to: 4)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
    "
     (Array 
            with:#(1 2 3 4 5 6 7 8 9)
            with:#(A)) 
        combinationsDo:[:eachCombination | Transcript showCR: eachCombination]
    "
!

lexicographicPermutationsDo:aBlock
    "Repeatly evaluate aBlock with a single copy of the receiver. 
     Reorder the copy so that aBlock is presented all (self size factorial) possible 
     permutations in lexicographical order (i.e. sorted by size).

     Notice, that the swapping occurs within a buffered copy, so the block will receive
     the identical same collection (but with different contents) every time.
     This non-functional kludge was done for performance, as we had to generate huge amounts
     of permuted copies. The user of this function must be careful in the block, 
     to copy the argument, if it has to be stored somewhere."

    self shallowCopy lexicographicPermutationsStartingAt:1 do:aBlock

    "
     (1 to: 4) asArray lexicographicPermutationsDo:[:each | Transcript showCR: each printString]
    "
!

lexicographicPermutationsStartingAt:anInteger do:aBlock
    "a helper for lexicographicPermutationsDo:"

    |mySize values indices|

    mySize := self size.
    anInteger > mySize ifTrue: [^ self].
    anInteger = mySize ifTrue: [^ aBlock value: self].
    values := self copyFrom:anInteger to:mySize.
    indices := (anInteger to:mySize) asArray.
    values sortWith:indices.
    indices do:[:i |
        self swap: anInteger with: i.
        self lexicographicPermutationsStartingAt:(anInteger + 1) do: aBlock.
        self swap: anInteger with: i
    ]

    "
     #(1 2 3 4 5) lexicographicPermutationsDo: [:each | Transcript showCR: each]
    "
!

permutationsDetect:aBlock
    "Repeatly evaluate aBlock with a single copy of the receiver. 
     Reorder the copy so that aBlock is presented all (self size factorial) possible permutations.
     Return the first permutation for which aBlock returns true, nil if there is none.

     Notice, that the swapping occurs within a buffered copy, so the block will receive
     the identical same collection (but with different contents) every time.
     This non-functional kludge was done for performance, as we had to generate huge amounts
     of permuted copies. The user of this function must be careful in the block, 
     to copy the argument, if it has to be stored somewhere."

    self permutationsDo:[:p | (aBlock value:p) ifTrue:[^ p]].
    ^ nil.
!

permutationsDo:aBlock
    "Repeatly evaluate aBlock with a single copy of the receiver. 
     Reorder the copy so that aBlock is presented all (self size factorial) possible permutations.

     Notice, that the swapping occurs within a buffered copy, so the block will receive
     the identical same collection (but with different contents) every time.
     This non-functional kludge was done for performance, as we had to generate huge amounts
     of permuted copies. The user of this function must be careful in the block, 
     to copy the argument, if it has to be stored somewhere."

    self shallowCopy permutationsStartingAt:1 do:aBlock

    "
     (1 to: 4) asArray permutationsDo:[:each | Transcript showCR: each printString]
    "

    "Modified: / 13.11.2001 / 13:37:35 / cg"
!

permutationsStartingAt: anInteger do: aBlock
    "a helper for permutationsDo:"

    |mySize|

    mySize := self size.
    anInteger > mySize ifTrue: [^ self].
    anInteger = mySize ifTrue: [^ aBlock value: self].
    anInteger to:mySize do:[:i |
        self swap: anInteger with: i.
        self permutationsStartingAt:(anInteger + 1) do: aBlock.
        self swap: anInteger with: i
    ]

    "
     #(1 2 3 4 5) permutationsDo: [:each | Transcript showCR: each]

    notice the copy - Transcript simply buffers incoming strings !!!!!!
     'hello' permutationsDo: [:each | Transcript showCR: each copy]
    "

    "Modified: / 22-10-2007 / 13:51:12 / cg"
!

permutationsStartingAt:anInteger with:anotherCollection do:aBlock
    "a helper for permutationsDo:"

    |mySize|

    mySize := self size.
    anInteger > mySize ifTrue: [^ self].
    anInteger = mySize ifTrue: [^ aBlock value:self value:anotherCollection].
    anInteger to:mySize do:[:i |
        self swap: anInteger with:i.
        anotherCollection swap: anInteger with:i.
        self permutationsStartingAt:(anInteger + 1) with:anotherCollection do:aBlock.
        self swap:anInteger with: i.
        anotherCollection swap:anInteger with:i.
    ]

    "
     #(1 2 3 4 5) permutationsDo: [:each | Transcript showCR: each]

    notice the copy - Transcript simply buffers incoming strings !!!!!!
     'hello' permutationsDo: [:each | Transcript showCR: each copy]
    "

    "Modified: / 22-10-2007 / 13:51:12 / cg"
!

permutationsWith:anotherCollection do:aBlock
    "Repeatly evaluate aBlock with a single copy of the receiver. 
     Reorder the copy so that aBlock is presented all (self size factorial) possible permutations.

     Notice, that the swapping occurs within a buffered copy, so the block will receive
     the identical same collection (but with different contents) every time.
     This non-functional kludge was done for performance, as we had to generate huge amounts
     of permuted copies. The user of this function must be careful in the block, 
     to copy the argument, if it has to be stored somewhere."

    self shallowCopy permutationsStartingAt:1 with:anotherCollection shallowCopy do:aBlock

    "
     (1 to: 4) asArray permutationsWith:'abcd' 
        do:[:each1 :each2 | Transcript showCR: each2 copy]
    "

    "Modified: / 13.11.2001 / 13:37:35 / cg"
! !

!SequenceableCollection methodsFor:'comparing'!

< aCollection
    "compare two sequenceable collections"

    |size               "{ Class: SmallInteger }"
     aCollectionSize    "{ Class: SmallInteger }"
     min                "{ Class: SmallInteger }"
     v1 v2|

    size := self size.
    aCollectionSize := aCollection size.
    aCollectionSize == 0 ifTrue:[
        aCollection isSequenceable ifFalse:[
            self error:'cannot compare non-(sequenceable) collection'.
        ].
    ].

    size < aCollectionSize ifTrue:[
        min := size
    ] ifFalse:[
        min := aCollectionSize
    ].

    1 to: min do: [:i|
        v1 := self at: i.
        v2 := aCollection at: i.
        (v1 == v2 or:[v1 = v2]) ifFalse:[^ v1 < v2]
    ].
    ^ size < aCollectionSize

    "
      #(1 2 3) < #(1)
      #(1 2 3) < #(2)
      #(1 2 3) < #()
      #(1 2 3) < #(1 2 3)

      |a b|

      a := 'hello world'.
      b := a copy.
      Time millisecondsToRun:[
        1000000 timesRepeat:[
            a < b
        ]
      ]

      |a b|

      a := CharacterArray fromString:'hello world'.
      b := a copy.
      Time millisecondsToRun:[
        1000000 timesRepeat:[
            a < b
        ]
      ]

      |a b|

      a := #[1 2 3 4 5 6 7 8 9 10 11].
      b := a copy.
      Time millisecondsToRun:[
        1000000 timesRepeat:[
           a < b
        ]
      ]
    "

    "Modified: / 04-08-2006 / 11:45:10 / cg"
!

<= aCollection
    "Compare the receiver with the argument and return true if the
     receiver is less than or equal to the argument. Otherwise return false"

    ^ (aCollection < self) not
!

= aCollection
    "return true if the receiver and aCollection represent collections
     with equal contents, and if they are of the same species."

    | stop "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^true].
    (aCollection isSequenceable) ifFalse:[^false].
    (aCollection species = self species) ifFalse:[^false].

    stop := self size.
    stop == (aCollection size) ifFalse:[^false].

    1 to:stop do:[:index|
        (self at:index) = (aCollection at:index) ifFalse:[^false].
    ].
    ^ true

    "
     #(1 2 3 4 5) = #(1 2 3 4 5)
     #($1 $2 $3 $4 $5) = #(1 2 3 4 5)
     #($1 $2 $3 $4 $5) = '12345'
     #($1 $2 $3 $4 $5) = '54321' asSortedCollection
    "
!

> aCollection
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument.
     Otherwise return false."

    ^ aCollection < self
!

>= aCollection
    "Compare the receiver with the argument and return true if the
     receiver is greater than or equal to the argument.
     Otherwise return false."

    ^ (self < aCollection) not
!

beginsWith:aCollection
    "Squeak & VW compatibility: similar to #startsWith: but returns false for an empty argument - sigh"

    ^ (self startsWith:aCollection) and:[aCollection notEmpty]

    "Modified: / 13.11.2001 / 13:49:18 / cg"
!

commonElementsWith:otherCollection
    "Answer whether the receiver's size is the same as otherCollection's size,
     and each of the receiver's elements equal the corresponding element of otherCollection.
     This should probably replace the current definition of #= ."

    |size otherSize commonSize "{ Class: SmallInteger }" commonElements|

    (otherCollection == self) ifTrue:[^ self].
    otherCollection isSequenceable ifFalse: [^ self error:'not sequenceable'].
    size := self size.
    otherSize := otherCollection size.
    commonSize := size min:otherSize.

    commonElements := self species new:commonSize.

    1 to:commonSize do:[:index |
        |el|
        el := self at:index.
        el = (otherCollection at: index) ifTrue:[
            commonElements at:index put:el.
        ]
    ].
    ^ commonElements

    "
        #(1 2 3) commonElementsWith:#(4 2 3 4)
    "
!

commonPrefixWith:aCollection
    "return the common prefix of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    ^ self commonPrefixWith:aCollection ignoreCase:false

    "
     'hello' commonPrefixWith:'hello'
     'hello' commonPrefixWith:'hElLo'
     'hello' commonPrefixWith:'hello world'
     'hello' commonPrefixWith:'hElLo WoRlD'

     'hello world' commonPrefixWith:'hello'
     'hello WoRlD' commonPrefixWith:'hElLo'

     'abcd' commonPrefixWith:'bcde'

     'abcd' commonPrefixWith:'abab'
     'abcd' commonPrefixWith:'ab'
     'abcd' commonPrefixWith:'ababab'
     'abcd' commonPrefixWith:'abcdef'

     'abab' commonPrefixWith:'abcd'
     'ab'   commonPrefixWith:'abcd'
     'ababab' commonPrefixWith:'abcd'
     'abcdef' commonPrefixWith:'abcd'
    "
!

commonPrefixWith:aCollection caseSensitive:caseSensitive
    "return the common prefix of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    |matchLen|

    matchLen := self size min:aCollection size.
    1 to:matchLen do:[:idx |
        |elHere elThere same|

        elHere := self at:idx.
        elThere := aCollection at:idx.

        caseSensitive ifFalse:[
            same := elHere sameAs:elThere
        ] ifTrue:[
            same := elHere = elThere
        ].
        same ifFalse:[
            ^ self copyTo:(idx - 1).
        ]
    ].

    ^ self copyTo:matchLen

    "
     'hello' commonPrefixWith:'hello' caseSensitive:false
     'hello' commonPrefixWith:'hElLo' caseSensitive:false
     'hello' commonPrefixWith:'hello world' caseSensitive:false
     'hello' commonPrefixWith:'hElLo WoRlD' caseSensitive:false

     'hello world' commonPrefixWith:'hello' caseSensitive:false
     'hello WoRlD' commonPrefixWith:'hElLo' caseSensitive:false

     'abcd' commonPrefixWith:'bcde' caseSensitive:false

     'abcd' commonPrefixWith:'abab' caseSensitive:false
     'abcd' commonPrefixWith:'aBAb' caseSensitive:false
     'abcd' commonPrefixWith:'ab'   caseSensitive:false
     'abcd' commonPrefixWith:'ababab'   caseSensitive:false
     'abcd' commonPrefixWith:'abcdef'   caseSensitive:false

     'abab' commonPrefixWith:'abcd' caseSensitive:false
     'ab'   commonPrefixWith:'abcd'   caseSensitive:false
     'ababab' commonPrefixWith:'abcd'   caseSensitive:false
     'abcdef' commonPrefixWith:'abcd'   caseSensitive:false
    "
!

commonPrefixWith:aCollection ignoreCase:ignoreCase
    <resource: #obsolete>
    "return the common prefix of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    ^ self commonPrefixWith:aCollection caseSensitive:ignoreCase not

    "
     'hello' commonPrefixWith:'hello' ignoreCase:true
     'hello' commonPrefixWith:'hElLo' ignoreCase:true
     'hello' commonPrefixWith:'hello world' ignoreCase:true
     'hello' commonPrefixWith:'hElLo WoRlD' ignoreCase:true

     'hello world' commonPrefixWith:'hello' ignoreCase:true
     'hello WoRlD' commonPrefixWith:'hElLo' ignoreCase:true

     'abcd' commonPrefixWith:'bcde' ignoreCase:true

     'abcd' commonPrefixWith:'abab' ignoreCase:true
     'abcd' commonPrefixWith:'ab'   ignoreCase:true
     'abcd' commonPrefixWith:'ababab'   ignoreCase:true
     'abcd' commonPrefixWith:'abcdef'   ignoreCase:true

     'abab' commonPrefixWith:'abcd' ignoreCase:true
     'ab'   commonPrefixWith:'abcd'   ignoreCase:true
     'ababab' commonPrefixWith:'abcd'   ignoreCase:true
     'abcdef' commonPrefixWith:'abcd'   ignoreCase:true
    "
!

commonSuffixWith:aCollection
    "return the common suffix (tail) of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    ^ self commonSuffixWith:aCollection ignoreCase:false

    "
     'hello' commonSuffixWith:'hello'
     'hello' commonSuffixWith:'hElLo'
     'hello' commonSuffixWith:'hello world'
     'hello' commonSuffixWith:'hElLo WoRlD'
     'hello2 world' commonSuffixWith:'hello world'
     'hello2 world' commonSuffixWith:'hElLo WoRlD'

     'hello world' commonSuffixWith:'world'
     'hello WoRlD' commonSuffixWith:'world'

     'dcba' commonSuffixWith:'edcb'

     'dcba' commonSuffixWith:'baba'
     'dcba' commonSuffixWith:'ba'
     'dcba' commonSuffixWith:'bababa'
     'dcba' commonSuffixWith:'fdcba'

     'baba' commonSuffixWith:'dcba'
     'ba'   commonSuffixWith:'dcba'
     'bababa' commonSuffixWith:'dcba'
     'fdcba' commonSuffixWith:'dcba'
    "
!

commonSuffixWith:aCollection caseSensitive:caseSensitive
    "return the common suffix (tail) of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    |matchLen l1 l2|

    l1 := self size.
    l2 := aCollection size.
    matchLen := l1 min:l2.
    1 to:matchLen do:[:idx |
        |elHere elThere same|

        elHere := self at:(l1 - idx + 1).
        elThere := aCollection at:(l2 - idx + 1).

        caseSensitive ifFalse:[
            same := elHere sameAs:elThere
        ] ifTrue:[
            same := elHere = elThere
        ].
        same ifFalse:[
            ^ self copyFrom:(l1 - idx + 2).
        ]
    ].

    ^ self copyFrom:(l1 - matchLen + 1)

    "
     'hello' commonSuffixWith:'hello' caseSensitive:false
     'hello' commonSuffixWith:'hElLo' caseSensitive:false
     'hello' commonSuffixWith:'hello world' caseSensitive:false
     'hello' commonSuffixWith:'hElLo WoRlD' caseSensitive:false
     'hello2 world' commonSuffixWith:'hello world' caseSensitive:false
     'hello2 world' commonSuffixWith:'hElLo WoRlD' caseSensitive:false

     'hello world' commonSuffixWith:'world' caseSensitive:false
     'hello WoRlD' commonSuffixWith:'world' caseSensitive:false

     'dcba' commonSuffixWith:'edcb' caseSensitive:false

     'dcba' commonSuffixWith:'baba' caseSensitive:false
     'dcba' commonSuffixWith:'ba'   caseSensitive:false
     'dcba' commonSuffixWith:'bababa'   caseSensitive:false
     'dcba' commonSuffixWith:'fdcba'   caseSensitive:false

     'baba' commonSuffixWith:'dcba' caseSensitive:false
     'ba'   commonSuffixWith:'dcba'   caseSensitive:false
     'bababa' commonSuffixWith:'dcba'   caseSensitive:false
     'fdcba' commonSuffixWith:'dcba'   caseSensitive:false
    "
!

commonSuffixWith:aCollection ignoreCase:ignoreCase
    <resource: #obsolete>
    "return the common suffix (tail) of myself and the argument, aCollection.
     If there is none, an empty collection is returned."

    ^ self commonSuffixWith:aCollection caseSensitive:ignoreCase not

    "
     'hello' commonSuffixWith:'hello' ignoreCase:true
     'hello' commonSuffixWith:'hElLo' ignoreCase:true
     'hello' commonSuffixWith:'hello world' ignoreCase:true
     'hello' commonSuffixWith:'hElLo WoRlD' ignoreCase:true
     'hello2 world' commonSuffixWith:'hello world' ignoreCase:true
     'hello2 world' commonSuffixWith:'hElLo WoRlD' ignoreCase:true

     'hello world' commonSuffixWith:'world' ignoreCase:true
     'hello WoRlD' commonSuffixWith:'world' ignoreCase:true

     'dcba' commonSuffixWith:'edcb' ignoreCase:true

     'dcba' commonSuffixWith:'baba' ignoreCase:true
     'dcba' commonSuffixWith:'ba'   ignoreCase:true
     'dcba' commonSuffixWith:'bababa'   ignoreCase:true
     'dcba' commonSuffixWith:'fdcba'   ignoreCase:true

     'baba' commonSuffixWith:'dcba' ignoreCase:true
     'ba'   commonSuffixWith:'dcba'   ignoreCase:true
     'bababa' commonSuffixWith:'dcba'   ignoreCase:true
     'fdcba' commonSuffixWith:'dcba'   ignoreCase:true
    "
!

compareWith:aSequenceableCollection
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument."

    |mySize    "{ Class: SmallInteger }"
     otherSize "{ Class: SmallInteger }"
     n         "{ Class: SmallInteger }"
     e1 e2|

    mySize := self size.
    otherSize := aSequenceableCollection size.
    n := mySize min:otherSize.

    1 to:n do:[:index |
        e1 := self at:index.
        e2 := aSequenceableCollection at:index.
        e1 ~~ e2 ifTrue:[
            "identity compare is faster"    
            e1 > e2 ifTrue:[^ 1].
            e1 < e2 ifTrue:[^ -1].
        ].
    ].
    mySize > otherSize ifTrue:[^ 1].
    mySize < otherSize ifTrue:[^ -1].
    ^ 0
!

deepSameContentsAs:aCollection
    "return true, if the receiver and the arg have the same contents
     in both the named instance vars and any indexed instVars.
     This method descends into referenced objects, where #sameContentsAs: does not descend.

     Redefinded, so that SequenceableCollections are equivalent, especially OrderedCollections with
     unused space"

    |index "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^true].
    (aCollection isSequenceable) ifFalse:[^false].

    stop := self size.
    stop == (aCollection size) ifFalse:[^false].

    index := 1.
    [index <= stop] whileTrue:[
	((self at:index) deepSameContentsAs:(aCollection at:index)) ifFalse:[^false].
	index := index + 1
    ].
    ^ true

    "
     #(1 2 3 4 5) deepSameContentsAs: #(1 2 3 4 5)
     #($1 $2 $3 $4 $5) deepSameContentsAs: #(1 2 3 4 5)
     #($1 $2 $3 $4 $5) deepSameContentsAs: '12345'
     #($1 $2 $3 $4 $5) deepSameContentsAs: '54321' asSortedCollection
    "
!

endsWith:aCollection
    "return true, if the receiver's last elements match those of aCollection.
     If aCollection is empty, true is returned (incompatible to some other dialect's endsWith.)"

    |index1 "{ Class: SmallInteger }"
     index2 "{ Class: SmallInteger }"
     stop   "{ Class: SmallInteger }"
     sz     "{ Class: SmallInteger }"|

    (aCollection == self) ifTrue:[^ true].
    (aCollection isSequenceable) ifFalse:[^ false].

    stop := aCollection size.
    sz := self size.
    stop > sz ifTrue:[^false].

    index1 := sz.
    index2 := stop.
    [index2 > 0] whileTrue:[
        (self at:index1) = (aCollection at:index2) ifFalse:[^ false].
        index1 := index1 - 1.
        index2 := index2 - 1
    ].
    ^ true

    "
     'abcde' endsWith:#($d $e)
     #[1 2 3 4] endsWith:#(3 4)
     #(1 2 3 4) asOrderedCollection endsWith:#(3 4)
    "
!

endsWithAnyOf:aCollectionOfCollections
    "return true, if the receiver endswith any in aCollection"

    ^ aCollectionOfCollections contains:[:eachTriedEnd | self endsWith:eachTriedEnd]

    "
     'abcde' endsWithAnyOf:#('DE' 'de')
     'abcde' endsWithAnyOf:#('DF' 'df')
     #[1 2 3 4] endsWithAnyOf:#( #(3 5) #(2 4))
     #[1 2 3 4] endsWithAnyOf:#( #(3 4) #(2 4))
    "
!

hasEqualElements: otherCollection
    "Answer whether the receiver's size is the same as otherCollection's
     size, and each of the receiver's elements equal the corresponding 
     element of otherCollection.
     This should probably replace the current definition of #= ."

    ^ self isSameSequenceAs:otherCollection
!

hash
    "return a hash key for the receiver"

    "this hash is stupid - but for larger collections, the hashing
     time can become much bigger than the time lost in added probing.
     Time will show ..."

    |mySize h|

    mySize := self size.
    mySize == 0 ifTrue:[^ 0].

    h := (self at:1) hash.
    h := h bitAnd:16r01FFFFFF.
    h := (h bitShift:5) + (self at:mySize) hash.
    h := h bitAnd:16r01FFFFFF.
    h := (h bitShift:5) + mySize.
    ^ h bitAnd:16r3FFFFFFF.

    "/ cg: the code below may lead to largeInteger arithmetic, which was slow...
    "/     ^ ((((self first hash bitShift:5) + self last hash) bitShift:5) + self size hash) bitAnd:16r3FFFFFFF.

    "
     #(1 2 3 4 5 6) hash
     (1 to:6) hash

     #(1 2 3 4 5 6.0) asOrderedCollection hash
     #[1 2 3 4 5 6] hash
    "

    "Modified: / 27.3.1998 / 17:33:49 / cg"
!

isSameSequenceAs:otherCollection
    "Answer whether the receiver's size is the same as otherCollection's size,
     and each of the receiver's elements equal the corresponding element of otherCollection.
     This should probably replace the current definition of #= ."

    | size |

    (otherCollection == self) ifTrue:[^ true].
    (size := self size) = otherCollection size ifFalse: [^ false].
    otherCollection isSequenceable ifFalse: [^ false].

    1 to:size do:[:index |
        (self at: index) = (otherCollection at: index) ifFalse: [^ false]
    ].
    ^ true
!

sameContentsAs:aCollection
    "return true, if the receiver and the arg have the same contents.

     Redefinded, so that SequenceableCollections are equivalent, 
     especially OrderedCollections with unused space"

    |stop  "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^ true].
    (aCollection isSequenceable) ifFalse:[
        aCollection isNil ifTrue:[^ false].
        ^ aCollection sameContentsAs:self.
    ].

    stop := self size.
    stop ~~ (aCollection size) ifTrue:[^ false].

    1 to:stop do:[:index|
        ((self at:index) ~= (aCollection at:index)) ifTrue:[^ false].
    ].
    ^ true

    "
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5) copy
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4) 
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5) asSet
     #(1 2 3 4 5) asSet sameContentsAs: #(1 2 3 4 5) copy
     #($1 $2 $3 $4 $5) sameContentsAs: #(1 2 3 4 5) 
     #($1 $2 $3 $4 $5) sameContentsAs: '12345'      
     #($1 $2 $3 $4 $5) sameContentsAs: '54321' asSortedCollection 
     #(1 2 3 4 5) sameContentsAs: nil 
    "

    "Created: / 09-07-2010 / 12:44:28 / sr"
!

sameContentsAs:aCollection whenComparedWith:compareBlock
    "return true if the receiver and aCollection represent collections
     with the same contents, using compareSelector to compare elements.
     This is a generic version of #= or #identicalContentsAs:;
     i.e. #= is the same as #sameContentsAs:whenComparedUsing:#=
     and #identicalContentsAs: is the same as #sameContentsAs:whenComparedUsing:#==.
    "

    |stop  "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^ true].
    (aCollection size == self size) ifFalse:[^ false].
    (aCollection isSequenceable) ifFalse:[
        ^ aCollection sameContentsAs:self whenComparedWith:compareBlock
    ].

    stop := self size.
    stop == (aCollection size) ifFalse:[^ false].

    1 to:stop do:[:index|
        (compareBlock value:(self at:index) value:(aCollection at:index)) ifFalse:[^ false].
    ].
    ^ true

    "
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5)     whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5) asSet whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5)     whenComparedWith:[:a :b | a == b]
     #(1 2 3 4 5) sameContentsAs: #(1.0 2 3 4.0 5) whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) sameContentsAs: #(1.0 2 3 4.0 5) whenComparedWith:[:a :b | a == b]

     #('Hello' 'ABC' 'worlD') sameContentsAs: #('Hello' 'ABC' 'worlD') whenComparedWith:[:a :b | a sameAs:b]
    "

    "Created: / 31.10.2001 / 11:29:38 / cg"
    "Modified: / 31.10.2001 / 11:30:32 / cg"
!

sameContentsFrom:start1 to:stop1 as:aCollection startingAt:start2
    "return true, if the receiver's slice from start to stop
     has the same contents as aCollection's slice starting at startIndex.
     The argument, aCollection must be sequenceable."

    |index1  "{ Class: SmallInteger }"
     index2  "{ Class: SmallInteger }"
     nSlice  "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^true].

    nSlice := stop1-start1+1.
    start2 + nSlice - 1 > (aCollection size) ifTrue:[^false].

    index1 := start1.
    index2 := start2.
    [index1 <= stop1] whileTrue:[
        ((self at:index1) = (aCollection at:index2)) ifFalse:[^false].
        index1 := index1 + 1.
        index2 := index2 + 1.
    ].
    ^ true

    "
     #(1 2 3 4 5) sameContentsFrom:2 to:4 as:#(10 20 2 3 4 50) startingAt:3
     #(1 2 3 4 5) sameContentsFrom:2 to:4 as:#(10 20 2 30 4 50) startingAt:3
     #($1 $2 $3 $4 $5) sameContentsFrom:2 to:4 as:'54321234987' startingAt:6 
    "
!

startsWith:aCollection
    "return true, if the receiver's first elements match those
     of aCollection
     If the argument is empty, true is returned.
     Notice, that this is similar to, but slightly different from VW's and Squeak's beginsWith:,
     which are both inconsistent w.r.t. an empty argument."

    |index "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }" |

    (aCollection == self) ifTrue:[^true].
    (aCollection isSequenceable) ifFalse:[^false].

    stop := aCollection size.
    stop > self size ifTrue:[^false].

    index := 1.
    [index <= stop] whileTrue:[
        (self at:index) = (aCollection at:index) ifFalse:[^false].
        index := index + 1
    ].
    ^ true

    "
     'abcde' startsWith:#($a $b $c)
     'abcde' startsWith:'abc'
     'abcd' startsWith:'abcde'
     'abcde' startsWith:'abd'
     #[1 2 3 4] startsWith:#(1 2 3)
     #(1 2 3 4) asOrderedCollection startsWith:#(1 2 3)
     #(1 2 3 4) asOrderedCollection startsWith:#()
    "
!

startsWithAnyOf:aCollectionOfCollections
    "return true, if the receiver starts with any in aCollection"

    ^ aCollectionOfCollections contains:[:eachTriedEnd | self startsWith:eachTriedEnd]

    "
     'abcde' startsWithAnyOf:#('AB' 'ab')
     'abcde' startsWithAnyOf:#('AC' 'ac')
     #[1 2 3 4] startsWithAnyOf:#( #(1 3) #(1 4))
     #[1 2 3 4] startsWithAnyOf:#( #(1 3) #(1 2))
    "
!

with:aCollection findFirst:aBlock 
    "return the index of the first element for which aTwoArgBlock returns true
     against corresponding elements of aCollection. 
     If any collection is smaller, the size of the smaller plus one is returned"

    |mySize otherSize minSize|

    mySize := self size.
    otherSize := aCollection size.
    minSize := mySize min:otherSize.

    self from:1 to:minSize with:aCollection doWithIndex:[:el1 :el2 :i |
        (aBlock value:el1 value:el2) ifTrue:[ ^ i].
    ].

    mySize ~= otherSize ifTrue:[
        ^ minSize + 1
    ].
    ^ 0

    "
     'hello' with:'helLo' findFirst:[:a :b | a ~= b] 
     'hello' with:'hello' findFirst:[:a :b | a ~= b]   
     'hello' with:'hello1' findFirst:[:a :b | a ~= b]   
     'hello1' with:'hello' findFirst:[:a :b | a ~= b]   
    "

    "Created: / 08-01-2012 / 17:12:00 / cg"
! !

!SequenceableCollection methodsFor:'converting'!

asCollectionOfSubCollectionsOfSize:pieceSize
    "slice into pieces; return a collection containing pieces of size pieceSize from the receiver.
     The last piece may be smaller, if the receiver's size is not a multiple of pieceSize."

    |pieces
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     mySize "{ Class:SmallInteger }"|

    pieces := self speciesForSubcollection new.
    start := 1. stop := start + pieceSize - 1.
    mySize := self size.
    [stop <= mySize] whileTrue:[
        pieces add:(self copyFrom:start to:stop).
        start := start + pieceSize.
        stop := stop + pieceSize.
    ].
    (start <= mySize) ifTrue:[
        pieces add:(self copyFrom:start to:mySize).
    ].
    ^ pieces

    "
     '123123123123123123' asCollectionOfSubCollectionsOfSize:3 
     '12312312312312312312' asCollectionOfSubCollectionsOfSize:3 
    "

    "Modified: / 24-01-2017 / 18:55:07 / stefan"
!

asCollectionOfSubCollectionsSeparatedBy:anElement
    "return a collection containing the subcollections (separated by anElement)
     of the receiver. If anElement occurs multiple times in a row,
     the result will contain empty collections.
     This algorithm uses equality-compare to detect the element."

    |cols myClass
     mySize        "{ Class:SmallInteger }" startIndex    "{ Class:SmallInteger }"
     stopIndex     "{ Class:SmallInteger }" |

    cols := self speciesForSubcollection new.
    myClass := self species.
    mySize := self size.

    startIndex := 1.
    [ startIndex <= mySize ] whileTrue:[
        stopIndex := self indexOf:anElement startingAt:startIndex.
        stopIndex == 0 ifTrue:[
            stopIndex := mySize
        ] ifFalse: [
            stopIndex := stopIndex - 1.
        ].

        (stopIndex < startIndex) ifTrue: [
            cols add:(myClass new:0)
        ] ifFalse: [
            cols add:(self copyFrom:startIndex to:stopIndex)
        ].
        startIndex := stopIndex + 2
    ].
    ^ cols

    "
     '1 one:2 two:3 three:4 four:5 five' withCRs asCollectionOfSubCollectionsSeparatedBy:$:
     '1 one 2 two 3 three 4 four 5 five' withCRs asCollectionOfSubCollectionsSeparatedBy:Character space
     #(a b c d e f g h) asCollectionOfSubCollectionsSeparatedBy: #d. 
     #(a b c d e f d d g h) asCollectionOfSubCollectionsSeparatedBy: #d.
     'foo-bar-baz' asCollectionOfSubCollectionsSeparatedBy: $-.
     'foobarbaz' asCollectionOfSubCollectionsSeparatedBy: $-. 
     '' asCollectionOfSubCollectionsSeparatedBy: $-. 
    "

    "Modified (format): / 24-01-2017 / 18:55:53 / stefan"
!

asCollectionOfSubCollectionsSeparatedBy:anElement do:aBlock
    "evaluate aBlock for each subcollection generated by separating elements
     of the receiver by anElement.
     If anElement occurs multiple times in a row,
     the block will be invoked with empty collections as argument.
     This algorithm uses equality-compare to detect the element."

    |subCollection
     endIndex      "{ Class:SmallInteger }"
     startIndex    "{ Class:SmallInteger }"
     stopIndex     "{ Class:SmallInteger }" |

    startIndex := 0.
    endIndex := self size.

    [startIndex <= endIndex] whileTrue:[
        stopIndex := self indexOf:anElement startingAt:startIndex+1.
        stopIndex == 0 ifTrue:[
            stopIndex := self size
        ] ifFalse: [
            stopIndex := stopIndex - 1.
        ].

        (stopIndex < startIndex) ifTrue: [
            subCollection := self species new:0
        ] ifFalse: [
            subCollection := self copyFrom:startIndex+1 to:stopIndex
        ].
        aBlock value:subCollection.
        startIndex := stopIndex + 1
    ].

    "
     '' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     '1 one' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     '1 one:2 two:3 three:4 four:5 five' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     'a::b' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     ':' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     ':a' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]

     'a:' 
        asCollectionOfSubCollectionsSeparatedBy:$: do:[:each | Transcript showCR:each storeString]
    "
!

asCollectionOfSubCollectionsSeparatedByAll:aSeparatorCollection
    "return a collection containing the subcollections (separated by aSeparatorCollection)
     of the receiver. If aSeparatorCollection occurs multiple times in a row,
     the result will contain empty strings.
     Uses equality-compare when searching for aSeparatorCollection."

    |items done myClass
     startIndex    "{ Class:SmallInteger }"
     stopIndex     "{ Class:SmallInteger }" |

    items := self speciesForSubcollection new.
    myClass := self species.

    startIndex := 1.
    done := false.
    [done] whileFalse:[
        stopIndex := self indexOfSubCollection:aSeparatorCollection startingAt:startIndex.
        stopIndex == 0 ifTrue:[
            stopIndex := self size.
            done := true.
        ] ifFalse: [
            stopIndex := stopIndex - 1.
        ].

        (stopIndex < startIndex) ifTrue: [
            items add:(myClass new:0)
        ] ifFalse: [
            items add:(self copyFrom:startIndex to:stopIndex)
        ].
        startIndex := stopIndex + (aSeparatorCollection size) + 1.
    ].
    ^ items

    "
     '1::2::3::4::5::' asCollectionOfSubCollectionsSeparatedByAll:'::'
     #(1 2 3 1 2 3 4 3 1 1 2 3 1 4 5) asCollectionOfSubCollectionsSeparatedByAll:#(3 1)
     'hello+#world+#here' asCollectionOfSubCollectionsSeparatedByAll:'+#'
    "

    "Modified (comment): / 24-01-2017 / 18:57:03 / stefan"
!

asCollectionOfSubCollectionsSeparatedByAny:aCollectionOfSeparators
    "return a collection containing the subCollection
     (separated by any from aCollectionOfSeparators) of the receiver.
     This allows breaking up strings using a number of elements as separator.
     Uses equality-compare when searching for separators."

    ^ self asCollectionOfSubCollectionsSeparatedByAnyForWhich:[:el | aCollectionOfSeparators includes:el]

    "
     'hello:world:isnt:this nice' asCollectionOfSubCollectionsSeparatedByAny:#($:)
     'hello:world:isnt:this nice' asCollectionOfSubCollectionsSeparatedByAny:':'
     'hello:world:isnt:this nice' asCollectionOfSubCollectionsSeparatedByAny:(Array with:$: with:Character space)
     'hello:world:isnt:this nice' asCollectionOfSubCollectionsSeparatedByAny:': '
     'h1e2l3l4o' asCollectionOfSubCollectionsSeparatedByAny:($1 to: $9)
     #(1 9 2 8 3 7 4 6 5 5) asCollectionOfSubCollectionsSeparatedByAny:#(1 2 3)
    "
!

asCollectionOfSubCollectionsSeparatedByAnyForWhich:aBlock
    "return a collection containing the subCollection
     (separated by elements for which aBlock evaluates to true) of the receiver.
     This allows breaking up strings using an arbitrary condition."

    |words
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     mySize "{ Class:SmallInteger }"|

    words := self speciesForSubcollection new.
    start := 1.
    mySize := self size.
    [start <= mySize] whileTrue:[
        "skip multiple separators"
        [ aBlock value:(self at:start)] whileTrue:[
            start := start + 1 .
            start > mySize ifTrue:[
                ^ words
            ].
        ].

        stop := self findFirst:aBlock startingAt:start.
        stop == 0 ifTrue:[
            words add:(self copyFrom:start to:mySize).
            ^ words
        ].
        words add:(self copyFrom:start to:(stop - 1)).
        start := stop
    ].
    ^ words

    "
     'hello:world:isnt:this nice' asCollectionOfSubCollectionsSeparatedByAnyForWhich:[:ch | ch = $:]
     'h1e2l3l4o' asCollectionOfSubCollectionsSeparatedByAnyForWhich:[:ch | ch isDigit]
     #(1 9 2 8 3 7 4 6 5 5) asCollectionOfSubCollectionsSeparatedByAnyForWhich:[:n | n odd]
    "

    "Modified (format): / 24-01-2017 / 18:57:57 / stefan"
!

asSequenceableCollection
    "return myself as a SequenceableCollection.
     I am already a SequenceableCollection."

    ^ self


!

asStringCollection
    "return a new string collection containing the elements;
     these ought to be strings. (i.e. String or Text instances)"

    |newColl sz|

    sz := self size.
    newColl := StringCollection newWithSize:sz.
    newColl replaceFrom:1 to:sz with:self startingAt:1.
    ^ newColl

    "Created: 18.5.1996 / 13:53:55 / cg"
    "Modified: 18.5.1996 / 14:00:16 / cg"
!

asStringWith:sepCharOrString
    "return a string generated by concatenating my elements
     (which must be strings or nil) and embedding sepCharOrString characters in between.
     The argument sepCharOrString may be a character, a string or nil.
     Nil entries and empty strings are counted as empty lines.
     Similar to joinWith:, but specifically targeted towards collections of strings."

    ^ self
        from:1 to:(self size)
        asStringWith:sepCharOrString
        compressTabs:false
        final:nil

    "
     #('hello' 'world' 'foo' 'bar' 'baz') asStringWith:$;
     #('hello' 'world' 'foo' 'bar' 'baz') asStringWith:'|'
     'hello|world|foo|bar|baz' asCollectionOfSubstringsSeparatedBy:$|
    "

    "Modified: / 10-07-2010 / 22:59:29 / cg"
!

asStringWith:sepCharacterOrString from:firstLine to:lastLine
    "return part of myself as a string with embedded sepCharacters.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     The argument sepCharOrString may be a character, a string or nil.
     Similar to joinWith:, but specifically targeted towards collections of strings."

    ^ self
        from:firstLine to:lastLine
        asStringWith:sepCharacterOrString
        compressTabs:false
        final:nil
    "
     creating entries for searchpath:

     #('foo' 'bar' 'baz' '/foo/bar') asStringWith:$;

     #('foo' 'bar' 'baz' '/foo/bar') asStringWith:$: from:1 to:3
    "

    "Modified: 23.2.1996 / 15:28:55 / cg"
!

asStringWith:sepCharacterOrString from:firstLine to:lastLine compressTabs:compressTabs final:endCharacterOrString
    "return part of myself as a string or text with embedded sepCharacters.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     The arguments sepCharacterOrString and endCharacterOrString may be nil, a character or a string.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs). The last line is followed by a final
     character (if non-nil).
     Similar to joinWith:, but specifically targeted towards collections of strings."

    ^ self
        from:firstLine to:lastLine
        asStringWith:sepCharacterOrString
        compressTabs:compressTabs
        final:endCharacterOrString
        withEmphasis:true

    "Modified: / 17.6.1998 / 12:31:19 / cg"
!

asStringWith:sepCharacterOrString from:firstLine to:lastLine compressTabs:compressTabs final:endCharacterOrString withEmphasis:withEmphasis
    "return part of myself as a string or text with embedded sepCharacters
     and followup endCharacter.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     The arguments sepCharacterOrString and endCharacterOrString may be nil, a character or a string.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs). The last line is followed by a final
     character (if non-nil).
     The withEmphais argument controls if the returned string should preserve
     any emphasis. If false, a plain string is returned.
     This method is tuned for big collections, in not creating many
     intermediate strings (has linear runtime). For very small collections
     and small strings, it may be faster to use the comma , operation.
     Similar to joinWith:, but specifically targeted towards collections of strings."

    ^ self
        from:firstLine to:lastLine
        asStringWith:sepCharacterOrString
        compressTabs:compressTabs
        final:endCharacterOrString
        withEmphasis:withEmphasis
!

asStringWithCRs
    "return a string generated by concatenating my elements
     (which must be strings or nil) and embedding cr characters in between.
     Nil entries and empty strings are counted as empty lines."

    ^ self asStringWithCRsFrom:1 to:(self size)

    "
     #('hello' 'world' 'foo' 'bar' 'baz') asStringWithCRs

     (OrderedCollection new
	add:'hello';
	add:'world';
	add:'foo';
	add:('bar' asText allBold);
	yourself) asStringWithCRs

     Transcript showCR:
	 (OrderedCollection new
	    add:'hello';
	    add:'world';
	    add:'foo';
	    add:('bar' asText allBold);
	    yourself) asStringWithCRs
    "

    "Modified: 18.5.1996 / 16:43:47 / cg"
!

asStringWithCRsFrom:firstLine to:lastLine
    "return a string generated by concatenating some of my elements
     (which must be strings or nil) and embedding cr characters in between.
     Nil entries and empty strings are counted as empty lines."

    ^ self asStringWithCRsFrom:firstLine to:lastLine compressTabs:false withCR:true

    "
     #('hello' 'world' 'foo' 'bar' 'baz') asStringWithCRsFrom:2 to:4

    "

    "Modified: 18.5.1996 / 16:50:55 / cg"
!

asStringWithCRsFrom:firstLine to:lastLine compressTabs:compressTabs
    "return part of myself as a string with embedded cr's.
     My elements must be strings or nil.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs).
     Nil entries and empty strings are taken as empty lines."

    ^ self asStringWithCRsFrom:firstLine to:lastLine compressTabs:compressTabs withCR:true
!

asStringWithCRsFrom:firstLine to:lastLine compressTabs:compressTabs withCR:withCR
    "return part of myself as a string with embedded cr's.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs). WithCR controls whether the last line
     should be followed by a cr or not."

    ^ self 
        asStringWith:(Character cr)
        from:firstLine to:lastLine
        compressTabs:compressTabs
        final:(withCR ifTrue:[Character cr] ifFalse:[nil])
!

decodeAsLiteralArray
    "given a literalEncoding in the receiver,
     create & return the corresponding object.
     The inverse operation to #literalArrayEncoding."

    |clsName cls|

    self size == 0 ifTrue:[
        ^ self.
    ].

    clsName := self at:1.
    clsName isSymbol ifFalse:[
        ^ MissingClassInLiteralArrayErrorSignal
                raiseRequestWith:clsName
                errorString:('non-symbol className in literalArray-spec: ', clsName printString)
    ].
    cls := Smalltalk classNamed:clsName.
    cls isNil ifTrue:[
        ^ MissingClassInLiteralArrayErrorSignal
                raiseRequestWith:clsName
                errorString:('unknown class in literalArray-spec: ' , clsName)
    ].

    ^ cls decodeFromLiteralArray:self.

    "
     #(10 20) literalArrayEncoding 
     #(Array 10 20) decodeAsLiteralArray 
     #() literalArrayEncoding   
     #(Array) decodeAsLiteralArray 
    "

    "Modified: / 26-03-2007 / 13:57:10 / cg"
!

decodeAsLiteralArrayCollection
    "given an array of literalEncodings in the receiver,
     create & return the corresponding collection object."

    ^ self collect:[:each | each decodeAsLiteralArray]

    "
     #(
        #(Point 10 20) 
        #(Point 20 30) 
        #(Point 30 40) 
        #(Point 40 50) 
     ) decodeAsLiteralArrayCollection 
    "

    "Modified: / 26-03-2007 / 13:57:10 / cg"
!

from:firstLine to:lastLine asStringWith:sepCharacterOrString
    "return part of myself as a string with embedded sepCharacterOrStrings.
     The argument sepCharacterOrString may be a character, a string or nil.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines."

    ^ self
        from:firstLine
        to:lastLine
        asStringWith:sepCharacterOrString
        compressTabs:false
        final:nil
    "
     creating entries for searchpath:

     #('foo' 'bar' 'baz' '/foo/bar') asStringWith:$;

     #('foo' 'bar' 'baz' '/foo/bar') from:1 to:3 asStringWith:$:

     (#('foo' 'bar' 'baz' '/foo/bar') copyFrom:1 to:3) asStringWith:$:
    "

    "Modified: 23.2.1996 / 15:28:55 / cg"
!

from:firstLine to:lastLine asStringWith:sepCharacterOrString compressTabs:compressTabs final:endCharacterOrString
    "return part of myself as a string or text with embedded sepCharacters.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     The arguments sepCharacterOrString and endCharacterOrString may be characters,
     strings or nil.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs). 
     The last line is followed by a final character (if non-nil)."

    ^ self
        from:firstLine
        to:lastLine
        asStringWith:sepCharacterOrString 
        compressTabs:compressTabs
        final:endCharacterOrString 
        withEmphasis:true

    "Modified: / 17.6.1998 / 12:31:19 / cg"
!

from:firstLine to:lastLine asStringWith:sepCharacterOrString compressTabs:compressTabs final:endCharacterOrString withEmphasis:withEmphasis
    "return part of myself as a string or text with embedded sepCharacterOrString
     and followup endCharacterOrString.
     My elements must be strings or nil; nil entries and empty strings are
     taken as empty lines.
     sepCharacterOrString and endCharacterOrString may be nil, a character or a string.
     If the argument compressTabs is true, leading spaces are converted
     to tab-characters (8col tabs). The last line is followed by a final
     character (if non-nil).
     The withEmphais argument controls if the returned string should preserve
     any emphasis. If false, a plain string is returned.
     This method is tuned for big collections, in not creating many
     intermediate strings (has linear runtime). For very small collections
     and small strings, it may be faster to use the comma , operation."

    |idx1        "{ Class:SmallInteger }"
     idx2        "{ Class:SmallInteger }"
     totalLength "{ Class:SmallInteger }"
     pos         "{ Class:SmallInteger }"
     sepCnt      "{ Class:SmallInteger }"
     newString lineString spaces idx nTabs
     maxBitsPerCharacter stringClass needEmphasis newRuns c
     thisLen anyTab|

    "
     first accumulate the size of the string, to avoid
     countless reallocations. If tabs are compressed,
     the size computed is not exact, but gives an upper bound ...
     On the fly, look if a 16bit string or emphasized text is needed.
    "
    needEmphasis := false.
    maxBitsPerCharacter := 8.

    totalLength := 0.
    sepCharacterOrString isNil ifTrue:[
        sepCnt := 0
    ] ifFalse:[
        sepCharacterOrString isCharacter ifTrue:[
            sepCnt := 1
        ] ifFalse:[
            sepCnt := sepCharacterOrString size
        ]
    ].

    idx1 := firstLine.
    idx2 := lastLine.
    idx1 to:idx2 do:[:lineIndex |
        lineString := self at:lineIndex.

        lineString notNil ifTrue:[
            withEmphasis ifTrue:[
                lineString hasChangeOfEmphasis ifTrue:[
                    needEmphasis := true
                ].
            ].
            maxBitsPerCharacter := maxBitsPerCharacter max:(lineString bitsPerCharacter).
            totalLength := totalLength + lineString size
        ].
        totalLength := totalLength + sepCnt
    ].
    totalLength := totalLength - sepCnt.

    maxBitsPerCharacter > 8 ifTrue:[
        maxBitsPerCharacter > 16 ifTrue:[
            stringClass := Unicode32String.
        ] ifFalse:[
            stringClass := Unicode16String.
        ]
    ] ifFalse:[
        stringClass := String.
    ].

    endCharacterOrString notNil ifTrue:[
        endCharacterOrString isCharacter ifTrue:[
            totalLength := totalLength + 1
        ] ifFalse:[
            totalLength := totalLength + endCharacterOrString size
        ].
    ].
    totalLength <= 0 ifTrue:[^ ''].

    spaces := '        '.
    newString := stringClass new:totalLength.

    needEmphasis ifTrue:[
        newRuns := RunArray new.
    ].

    "
     now, replace ...
     Be careful with runArrays:
        replacing individual elements is VERY expensive.
        Therefore, create a new runArray from scratch.
    "
    pos := 1.
    idx1 to:idx2 do:[:lineIndex |
        lineString := self at:lineIndex.
        thisLen := lineString size.
        thisLen ~~ 0 ifTrue:[
            withEmphasis ifFalse:[
                lineString := lineString string.
            ].

            (anyTab := compressTabs) ifTrue:[
                "
                 mhmh: could use withTabs from String-class here,
                 but we should avoid creating too many temporary strings
                 (especially, since this method is typically used when converting
                 big texts such as when saving in the filebrowser ...).
                 Therefore, we convert tabs inline here doing a direct replace
                 in newString."

                idx := lineString findFirst:[:c | (c ~~ Character space)].
                nTabs := (idx-1) // 8.
                anyTab := (nTabs > 0)
            ].
            anyTab ifTrue:[
                "any tabs"

                idx := nTabs * 8 + 1.   "/ index of first copied character in string

                newString atAll:(pos to:pos+nTabs-1) put:(Character tab).
                newRuns notNil ifTrue:[
                    newRuns add:nil withOccurrences:nTabs
                ].
                pos := pos + nTabs.

                newString replaceFrom:pos with:lineString startingAt:idx.
                newRuns notNil ifTrue:[
                    lineString hasChangeOfEmphasis ifTrue:[
                        idx to:lineString size do:[:pos |
                            newRuns add:(lineString emphasisAt:pos)
                        ]
                    ] ifFalse:[
                        newRuns add:nil withOccurrences:(lineString size - idx + 1)
                    ]
                ].
                pos := pos + thisLen - (nTabs * 8).
            ] ifFalse:[
                newString replaceFrom:pos with:lineString.

                newRuns notNil ifTrue:[
                    lineString hasChangeOfEmphasis ifTrue:[
                        newRuns addAll:(lineString emphasis)
                    ] ifFalse:[
                        newRuns add:nil withOccurrences:lineString size
                    ]
                ].
                pos := pos + thisLen.
            ].
        ].

        lineIndex ~~ lastLine ifTrue:[
            c := sepCharacterOrString
        ] ifFalse:[
            c := endCharacterOrString
        ].

        c notNil ifTrue:[
            c isCharacter ifTrue:[
                newString at:pos put:c.
                newRuns notNil ifTrue:[
                    newRuns add:nil.
                ].
                pos := pos + 1
            ] ifFalse:[
                newString replaceFrom:pos with:c.
                newRuns notNil ifTrue:[
                    newRuns add:nil withOccurrences:c size
                ].
                pos := pos + c size
            ]
        ].
    ].

    "
     in case of tab compression, the result has to be
     cut to size ... sorry
    "
    pos ~~ totalLength ifTrue:[
        newString := newString copyTo:(pos - 1)
    ].

    newRuns notNil ifTrue:[
        newString := Text string:newString runs:newRuns.
    ].

    ^ newString

    "
     creating entries for searchpath:

       #('foo' 'bar' 'baz' '/foo/bar')
          asStringWith:$:
          from:1 to:4
          compressTabs:false
          final:nil

     with trailing colon:

       #('foo' 'bar' 'baz' '/foo/bar')
          asStringWith:$:
          from:1 to:4
          compressTabs:false
          final:$:

     concatenating elements (nil sepChars and nil endChars):

       #('foo' 'bar' 'baz')
          asStringWith:nil
          from:1 to:3
          compressTabs:false
          final:nil

     creating a string from a collection of lines:

       #('foo' 'bar' 'baz')
          asStringWith:(Character cr)
          from:1 to:3
          compressTabs:false
          final:(Character cr)

     creating a text from a collection of mixed texts and strings:

       (Array
            with:'foo'
            with:('bar' asText allBold)
            with:'baz'
            with:('baz2' asText emphasizeAllWith:#italic)
       )
          asStringWith:(Character cr)
          from:1 to:4
          compressTabs:false
          final:(Character cr)

     can also use strings as separating characters:

       #('foo' 'bar' 'baz')
          asStringWith:'__'
          from:1 to:3
          compressTabs:false
          final:nil

     and as final characters:

       #('foo' 'bar' 'baz')
          asStringWith:'__'
          from:1 to:3
          compressTabs:false
          final:'***'

    "

    "Created: / 17.6.1998 / 12:30:32 / cg"
    "Modified: / 17.6.1998 / 12:31:59 / cg"
!

joinWithAll:separatingCollection
    "return a collection generated by concatenating my elements
     and slicing separatingCollection in between.
     Similar to asStringWith:, but not specifically targeted towards collections of strings."

    ^ self
        joinWithAll:separatingCollection
        from:1 to:(self size) as:nil

    "
     #('hello' 'world' 'foo' 'bar' 'baz') joinWithAll:' ; '   
     #('hello' 'world' 'foo' 'bar' 'baz') joinWithAll:' | '
    "
!

joinWithAll:separatingCollection from:startIndex to:endIndex as:speciesOrNil 
    "extract parts of myself as a new collection with optional embedded separator.
     Separator may be nil, or a collection of elements to be sliced in between.
     SpeciesOrNil specifies the species of the resultig object, allowing for Arrays to be converted
     as OrderedCollection or vice versa on the fly. If nil is passed in, the species of the first non-nil
     element is used.
     This counts the overall size first, then allocates the new collection once and replaces elements
     via bulk copies. For very small collections, it may be faster to use the comma , operation.
     Similar to asStringWith:, but not specifically targeted towards string handling."

    |totalLength "{ Class:SmallInteger }"
     pos         "{ Class:SmallInteger }"
     sepCnt      "{ Class:SmallInteger }"
     subColl newColl 
     species|

    startIndex = endIndex ifTrue:[ ^ self at:startIndex ].

    species := speciesOrNil.

    "
     first accumulate the size of the result, 
     to avoid countless reallocations.
    "
    totalLength := 0.
    sepCnt := separatingCollection size.

    startIndex to:endIndex do:[:index |
        subColl := self at:index.
        totalLength := totalLength + subColl size.
        species isNil ifTrue:[
            subColl notNil ifTrue:[
                species := subColl species
            ]
        ]
    ].
    totalLength := totalLength + ((endIndex - startIndex) * sepCnt).
    newColl := species newWithSize:totalLength.

    pos := 1.
    startIndex to:endIndex do:[:index |
        subColl := self at:index.
        subColl size ~~ 0 ifTrue:[
            newColl replaceFrom:pos with:subColl startingAt:1.
            pos := pos + subColl size.
        ].
        ((sepCnt ~~ 0) and:[index ~~ endIndex]) ifTrue:[
            newColl replaceFrom:pos to:(pos+sepCnt-1) with:separatingCollection startingAt:1.
            pos := pos + sepCnt.
        ].
    ].

    ^ newColl

    "
     #( 'aa' 'bb' '' 'cc' ) joinWith:'|' from:1 to:4 as:String  
     #( 'aa' 'bb' '' 'cc' ) joinWith:nil from:1 to:4 as:String  
     #( 'aa' 'bb' '' 'cc' ) joinWith:'|' from:1 to:4 as:Array   
     #( (1 2 3) (4 5 6) (7 6 8) ) joinWith:#(nil) from:1 to:3 as:OrderedCollection  
     #( (1 2 3) (4 5 6) (7 6 8) ) joinWith:nil from:1 to:3 as:nil                
    "

    "Created: / 17.6.1998 / 12:30:32 / cg"
    "Modified: / 17.6.1998 / 12:31:59 / cg"
!

splitBy:anElement
    "return a collection containing the subcollections (separated by anElement)
     of the receiver. If anElement occurs multiple times in a row,
     the result will contain empty collections.
     This algorithm uses equality-compare to detect the element.
     Same as asCollectionOfSubCollectionsSeparatedBy: for Squeak compatibility"

    ^ self asCollectionOfSubCollectionsSeparatedBy:anElement

    "
     '1 one:2 two:3 three:4 four:5 five' withCRs splitBy:$:
     '1 one 2 two 3 three 4 four 5 five' withCRs splitBy:Character space
     #(a b c d e f g h) splitBy: #d.
     #(a b c d e f d d g h) splitBy: #d.
    "
!

splitBy:anElement do:aBlock
    "evaluate aBlock for each subcollection generated by separating elements
     of the receiver by anElement.
     If anElement occurs multiple times in a row,
     the block will be invoked with empty collections as argument.
     This algorithm uses equality-compare to detect the element."

    ^ self asCollectionOfSubCollectionsSeparatedBy:anElement do:aBlock

    "
     '' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     '1 one' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     '1 one:2 two:3 three:4 four:5 five' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     'a::b' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     ':' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     ':a' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]

     'a:' 
        splitBy:$: do:[:each | Transcript showCR:each storeString]
    "
!

splitByAll:aSeparatorCollection
    "return a collection containing the subcollections (separated by aSeparatorCollection)
     of the receiver. If aSeparatorCollection occurs multiple times in a row,
     the result will contain empty strings.
     Uses equality-compare when searching for aSeparatorCollection."

    ^ self asCollectionOfSubCollectionsSeparatedByAll:aSeparatorCollection

    "
     '1::2::3::4::5::' splitByAll:'::'
     #(1 2 3 1 2 3 4 3 1 1 2 3 1 4 5) splitByAll:#(3 1)
    "
!

splitByAny:aCollectionOfSeparators
    "return a collection containing the subCollection
     (separated by any from aCollectionOfSeparators) of the receiver.
     This allows breaking up strings using a number of elements as separator.
     Uses equality-compare when searching for separators."

    ^ self asCollectionOfSubCollectionsSeparatedByAny:aCollectionOfSeparators

    "
     'hello:world:isnt:this nice' splitByAny:#($:)
     'hello:world:isnt:this nice' splitByAny:':'
     'hello:world:isnt:this nice' splitByAny:(Array with:$: with:Character space)
     'hello:world:isnt:this nice' splitByAny:#( $: $ ) 
     'hello:world:isnt:this nice' splitByAny:{ $: . $ }
     'hello:world:isnt:this nice' splitByAny:': '
     'h1e2l3l4o' splitByAny:($1 to: $9)
     #(1 9 2 8 3 7 4 6 5 5) splitByAny:#(1 2 3)
    "
!

splitByAnyForWhich:aBlock
    "return a collection containing the subCollection
     (separated by elements for which aBlock evaluates to true) of the receiver.
     This allows breaking up strings using an arbitrary condition."
    
    ^ self asCollectionOfSubCollectionsSeparatedByAnyForWhich:aBlock      

    "
     'hello:world:isnt:this nice' splitByAnyForWhich:[:ch | ch = $:]
     'h1e2l3l4o' splitByAnyForWhich:[:ch | ch isDigit]
     #(1 9 2 8 3 7 4 6 5 5 1 2 9) splitByAnyForWhich:[:n | n odd]
    "

    "Modified (format): / 29-05-2018 / 13:24:06 / svestkap"
!

splitForSize:pieceSize
    "slice into pieces; return a collection containing pieces of size pieceSize from the receiver.
     The last piece may be smaller, if the receiver's size is not a multiple of pieceSize."

    ^ self asCollectionOfSubCollectionsOfSize:pieceSize

    "
     '123123123123123123' splitForSize:3 
     '12312312312312312312' splitForSize:3 
    "
!

subCollections:aBlock 
    "Answser an ordered collection of ordered collections
     where each subcollection is delimited by an element of the receiver
     for which the given block evaluates to true."
    
    |str answer current e|

    str := self readStream.
    answer := OrderedCollection new.
    current := OrderedCollection new.
    [ str atEnd ] whileFalse:[
        e := str next.
        current add:e.
        (aBlock value:e) ifTrue:[
            answer add:current.
            current := OrderedCollection new
        ]
    ].
    current notEmpty ifTrue:[
        answer add:current
    ].
    ^ answer

    "
     #( 1 2 3 nil 4 5 6 nil 7 8 9 nil ) subCollections:[:el | el isNil].
    "
! !

!SequenceableCollection methodsFor:'converting-reindexed'!

from:startIndex
    "Create a ReindexedCollection from the receiver.
     The new collection represents the elements starting at startIndex to the end.
     (i.e. logically it represents the receiver copyFrom:startIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:startIndex
        to:self size
        by:1

    "
     #(1 2 3 4 5 6 7) from:3
     ( #(1 2 3 4 5 6 7) from:3 ) first
     ( #(1 2 3 4 5 6 7) from:3 ) last
     ( #(1 2 3 4 5 6 7) from:3 ) size
    "
!

from:startIndex by:step
    "Create a ReindexedCollection from the receiver.
     The new collection represents the elements starting at startIndex to the end.
     (i.e. logically it represents the receiver copyFrom:startIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:startIndex
        to:(step > 1
            ifTrue: [self size]
            ifFalse: [1])
        by:step

    "
     #(1 2 3 4 5 6 7) from:3 by:2
     ( #(1 2 3 4 5 6 7) from:3 by:2) first
     ( #(1 2 3 4 5 6 7) from:3 by:2) last
     ( #(1 2 3 4 5 6 7) from:3 by:2) size
    "
!

from:startIndex count:numberOfElements
    "return a sub-collection consisting of numberOfElements elements
     in the receiver starting at index start (i.e. reference to a slice).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:startIndex
        to:(startIndex + numberOfElements - 1)

    "
     #($a $b $c $d $e $f $g) from:2 count:3
     '1234567890' from:2 count:5
    "

    "
     |coll slice|

     coll := #(1 2 3 4 5 6 7 8 9 10) copy.
     slice := coll from:3 to:7.
     slice.
     coll at:4 put:40.
     slice.
    "

    "
     |coll slice|

     coll := #(1 2 3 4 5 6 7 8 9 10) copy.
     slice := coll from:3 to:7.
     slice.
     slice at:1 put:40.
     slice.
    "
!

from:startIndex count:numberOfElements put:newElement
    "replace numberOfElements elements from startIndex of the collection
     by the argument, newElement.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
        from:startIndex
        to:(startIndex + numberOfElements - 1)
        put:newElement

    "
     #($a $b $c $d $e $f $g) copy from:2 count:3 put:nil
     '1234567890' copy from:2 count:5 put:$*
     '1234567890' copy from:2 count:20 put:$* -> error
    "
!

from:startIndex to:endIndex
    "Create a ReindexedCollection from the receiver.
     The new collection represents the elements starting at startIndex to endIndex.
     (i.e. logically it represents the receiver copyFrom:startIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:startIndex
        to:endIndex
        by: (startIndex <= endIndex
            ifTrue: [1]
            ifFalse: [-1])

    "
     #(1 2 3 4 5 6 7) from:3 to:6
     ( #(1 2 3 4 5 6 7) from:3 to:6) first
     ( #(1 2 3 4 5 6 7) from:3 to:6) last
     ( #(1 2 3 4 5 6 7) from:3 to:6) size
    "
!

from:startIndex to:endIndex by:step
    "Create a ReindexedCollection from the receiver.
     The new collection represents the receiver's elements up to endIndex.
     (i.e. logically it represents the receiver copyTo:endIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ ReindexedCollection
        on:self
        from:startIndex
        to:endIndex
        by:step

    "
     #(1 2 3 4 5 6 7) from:3 to:7 by:2
     ( #(1 2 3 4 5 6 7) from:3 to:7 by:2) first
     ( #(1 2 3 4 5 6 7) from:3 to:7 by:2) last
     ( #(1 2 3 4 5 6 7) from:3 to:7 by:2) size
    "
!

to:endIndex
    "Create a ReindexedCollection from the receiver.
     The new collection represents the receiver's elements up to endIndex.
     (i.e. logically it represents the receiver copyTo:endIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:1
        to:endIndex
        by:1

    "
     #(1 2 3 4 5 6 7) to:4
     ( #(1 2 3 4 5 6 7) to:4) first
     ( #(1 2 3 4 5 6 7) to:4) last
     ( #(1 2 3 4 5 6 7) to:4) size
    "
!

to:endIndex by:step
    "Create a ReindexedCollection from the receiver.
     The new collection represents the receiver's elements up to endIndex.
     (i.e. logically it represents the receiver copyTo:endIndex,
     however, physically, no copy is made).
     Warning:
        The slice SHARES the memory for the element-data with the original,
        this means that any modifications in the original are visible in the slice
        and vice versa."

    ^ self
        from:(step > 0
            ifTrue: [1]
            ifFalse: [self size])
        to:endIndex
        by:step

    "
     #(1 2 3 4 5 6 7) to:4 by:2
     ( #(1 2 3 4 5 6 7) to:4 by:2) first
     ( #(1 2 3 4 5 6 7) to:4 by:2) last
     ( #(1 2 3 4 5 6 7) to:4 by:2) size
    "
! !

!SequenceableCollection methodsFor:'copying'!

++ aCollection
    "This is just syntactic sugar for javascript.
     Return a new collection formed from concatenating the receiver with
     the argument. The class of the new collection is determined by the
     receiver's class, so mixing classes is possible, if the second collections
     elements can be stored into instances of the receiver's class."

    ^ self , aCollection

    "
     #($a $b $c) ++ #(1 2 3)
     #($a $b $c) ++ '123'
     'abc' ++ '123'
     'abc' ++ #($q $w $e $r $t $y) asSortedCollection
     'abc' ++ #(1 2 3 4 5)"  "-- will fail, since strings cannot store integers
     'abc' asArray ++ #(1 2 3 4 5)
    "

    "Modified (comment): / 14-02-2012 / 14:17:11 / cg"
!

, aCollection
    "return a new collection formed from concatenating the receiver with the argument. 
     The class of the new collection is determined by the
     receiver's class, so mixing classes is possible, if the second collection's
     elements can be stored into instances of the receiver's class."

    |newCollection
     mySize    "{ Class: SmallInteger }"
     newSize   "{ Class: SmallInteger }"
     otherSize "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"|

    mySize := self size.
    otherSize := aCollection size.
    newSize := mySize + otherSize.

    newCollection := self copyEmptyAndGrow:newSize.   "must grow, otherwise replace fails"

    newCollection replaceFrom:1 to:mySize with:self startingAt:1.
    dstIndex := mySize + 1.
    aCollection isSequenceable ifTrue:[
        "
         yes, aCollection has indexed elements
        "
        newCollection replaceFrom:dstIndex to:newSize with:aCollection startingAt:1.
    ] ifFalse:[
        "
         no, enumerate aCollection
        "
        aCollection do:[:element |
            newCollection at:dstIndex put:element.
            dstIndex := dstIndex + 1
        ]
    ].
    ^ newCollection

    "
     #($a $b $c) , #(1 2 3)
     #($a $b $c) , '123'
     'abc' , '123'
     'abc' , #($q $w $e $r $t $y) asSortedCollection
     'abc' , #(1 2 3 4 5)"  "-- will fail, since strings cannot store integers
     'abc' asArray , #(1 2 3 4 5)
    "

    "Modified (comment): / 01-04-2012 / 13:17:56 / cg"
!

,* n
    "return a new collection formed from concatenating the receiver n times,
     with 0 returning an empty collection, 1 returning the receiver, etc." 

    ^ self repeatedConcatenation:n

    "
     #($a $b $c) ,* 3
     'abc' ,* 5
     'abc' ,* 0
     'abc' ,* 1
     'a' ,* 50
     (1 to:4) ,* 5  
    "
!

concatenate:string1 and:string2
    "return the concatenation of myself and the arguments, string1 and string2.
     This is equivalent to self , string1 , string2
     - generated by stc compiler when such a construct is detected and the receiver
     is known to be a string."

    ^ self , string1 , string2
!

concatenate:string1 and:string2 and:string3
    "return the concatenation of myself and the string arguments.
     This is equivalent to self , string1 , string2 , string3
     - generated by stc compiler when such a construct is detected and the receiver
     is known to be a string."

    ^ self , string1 , string2 , string3
!

copyAfter: anElement
    "Answer a copy of the receiver from after the first occurrence
    of anElement up to the end. If no such element exists, answer
    an empty copy."

    |idx|

    idx := self indexOf:anElement.
    idx == 0 ifTrue:[idx := self size].
    ^ self copyFrom:idx + 1

    "
     'hello world' copyAfter:$l
     '123456123456' copyAfter:$2
     #(1 2 3 4 1 2 3 3 4 5 6) copyAfter:3
     #(1 2 3 4 2 3 3 4 5 6) copyAfter:1
     #(1 2 3 4 1 2 3 3 4 5 6) copyAfter:7
    "
!

copyAfterLast:element
    "return a copy of the receiver from (but excluding) the last occurrence
     of element to the end; uses = for comparison"

    |idx|

    idx := self lastIndexOf:element.
    idx == 0 ifTrue:[idx := self size].
    ^ self copyFrom:idx + 1

    "
     'hello world' copyAfterLast:$l
     '123456123456' copyAfterLast:$2
     #(1 2 3 4 1 2 3 3 4 5 6) copyAfterLast:3
     #(1 2 3 4 2 3 3 4 5 6) copyAfterLast:1
     #(1 2 3 4 1 2 3 3 4 5 6) copyAfterLast:7
    "
!

copyButFirst
    "return a new collection consisting of the receiver's elements
     except for the first element.
     Raises an error if the receiver is empty.
     Differs from #allButFirst in its error behavior."

    self isEmpty ifTrue:[self notEnoughElementsError].
    ^ self copyFrom:2

    "
     #($a $b $c $d $e $f $g) copyButFirst
     '1234567890' copyButFirst
     '1' copyButFirst
     '' copyButFirst

     '' allButFirst
    "
!

copyButFirst:count
    "return a new collection consisting of the receiver's elements
     except for the first count elements
     Raises an error if the receiver is empty.
     Differs from #allButFirst: in its error behavior."

    self size < count ifTrue:[self notEnoughElementsError].
    ^ self copyFrom:(count + 1)

    "
     #($a $b $c $d $e $f $g) copyButFirst:2
     '1234567890' copyButFirst:2
     '12' copyButFirst:2
     '' copyButFirst:2

     '' allButFirst:2
    "
!

copyButLast
    "return a new collection consisting of the receiver's elements
     except for the last element.
     Raises an error if the receiver is empty.
     Differs from #allButLast in its error behavior."

    self isEmpty ifTrue:[self notEnoughElementsError].
    ^ self copyTo:(self size - 1)

    "
     #($a $b $c $d $e $f $g) copyButLast
     '1234567890' copyButLast
     '1' copyButLast
     '' copyButLast

     '' allButLast
    "
!

copyButLast:count
    "return a new collection consisting of the receiver's elements
     except for the last count elements.
     Raises an error if there are not at least count elements.
     Differs from #allButLast: in its error behavior."

    count > self size ifTrue:[self notEnoughElementsError].
    ^ self copyTo:(self size - count)

    "
     #($a $b $c $d $e $f $g) copyButLast:2
     '1234567890' copyButLast:2
     '12' copyButLast:2
     '1' copyButLast:2

     '1' allButLast:2
    "
!

copyFirst:count
    "return a new collection consisting of the receiver's first count elements.
     Raises an error if there are not enough elements.
     Differs from #first: in its error behavior."

    count > self size ifTrue:[self notEnoughElementsError].
    ^ self copyFrom:1 to:count

    "
     #($a $b $c $d $e $f $g) copyFirst:5
     '1234567890' copyFirst:4
     '1234' copyFirst:4
     '12' copyFirst:4

     '1234567890' first:4
     '123' first:4
     '' first:4
    "
!

copyFrom:startIndex
    "return a new collection consisting of receiver's elements from startIndex to the end of the collection.
     Return an empty collection, if startIndex is beyond the receiver's size."

    ^ self copyFrom:startIndex to:(self size)

    "
     #($a $b $c $d $e $f $g) copyFrom:2
     '1234567890' copyFrom:2
     (10 to:19) copyFrom:5
    "
!

copyFrom:startIndex count:numberOfElements
    "return a new collection consisting of numberOfElements elements
     extracted from the receiver starting at index start
     (i.e. extract a slice).
     Returns an empty collection if startIndex is beyond the receiver's size.
     Raise an error, if stopIndex is out of range."

    ^ self
        copyFrom:startIndex
        to:(startIndex + numberOfElements - 1)

    "
     #($a $b $c $d $e $f $g) copyFrom:2 count:3
     '1234567890' copyFrom:2 count:5
    "

    "Modified: 20.2.1997 / 14:23:01 / cg"
!

copyFrom:startIndex to:stopIndex
    "return a new collection consisting of receiver's elements
     between start and stop.
     Returns an empty collection if startIndex is beyond the receiver's size.
     Raise an error, if stopIndex is out of range."

    |newCollection newSize|

    newSize := stopIndex - startIndex + 1.
    newSize <= 0 ifTrue:[
        ^ self copyEmpty:0.
    ].
    newCollection := self copyEmptyAndGrow:newSize.
    newCollection replaceFrom:1 to:newSize with:self startingAt:startIndex.

    ^ newCollection

    "
     #($a $b $c $d $e $f $g) copyFrom:2 to:5
     '1234567890' copyFrom:2 to:5
     (1 to:10) copyFrom:2 to:5

     '1234567890' copyFrom:2 to:15
     (1 to:10) copyFrom:12 to:1
    "
!

copyLast:count
    "return a new collection consisting of the receiver's last count elements.
     Raises an error if there are not enough elements.
     Differs from #last: in its error behavior."

    |sz|

    sz := self size.
    ^ self copyFrom:(sz - count + 1) to:sz

    "
     #($a $b $c $d $e $f $g) copyLast:5
     '1234567890' copyLast:4
     '12345' copyLast:4
     '1234' copyLast:4
     '123' copyLast:4
     '' copyLast:4

     '123' last:4
     '' last:4
    "
!

copyMapping:map
    "return a copy, where elements all replaced via the given mapping.
     If the element is present as key in map, it is replaced by a corresponding value from the map.
     Otherwise, it is left unchanged."

    |s|

    s := WriteStream on:self species new.
    self do:[:el |
        s nextPut:(map at:el ifAbsent:el)
    ].
    ^ s contents

    "
     |map|

     map := Dictionary new
                at:1 put:'one';
                at:2 put:'two';
                yourself.

     #(1 2 3 4 1 2 3 4) copyMapping:map
    "
!

copyMappingFrom:inMap to:outMap
    "return a copy, where elements all replaced via the given mapping.
     If the element is present in inmap, it is replaced by a corresponding value from outmap.
     Otherwise, it is left unchanged."

    |d|

    d := Dictionary new.
    inMap keysAndValuesDo:[:k :i | d at:i put:(outMap at:k)].
    ^ self copyMapping:d

    "
     #(1 2 3 4 1 2 3 4) copyMappingFrom:#(1 2) to:#('one' 'two')  
     'hello' copyMappingFrom:'eo' to:'**'    
    "
!

copyReplaceAll:oldElement with:newElement
    "return a copy of the receiver, where all elements equal to oldElement
     have been replaced by newElement."

"/    'Warning: #copyReplaceAll:with: will change semantics as defined in ANSI soon' errorPrintCR.
    ^ (self copyFrom:1) replaceAll:oldElement with:newElement

    "
     #(1 2 1 2 1 2 1 2 1 2) copyReplaceAll:1 with:99
     'hello world' copyReplaceAll:$l with:$*
    "

    "Modified: / 18.7.1998 / 22:52:17 / cg"
!

copyReplaceAll:oldElement with:newElement ifNone:valueIfNoneFound
    "return a copy of the receiver, where all elements equal to oldElement
     have been replaced by newElement.
     If none is found, return valueIfNoneFound.
     Usually this is used as:
        foo copyReplaceAll:oldElement with:newElement ifNone:foo"

    "/ 'Warning: #copyReplaceAll:with: will change semantics as defined in ANSI soon' errorPrintCR.
    (self includes:oldElement) ifFalse:[ ^ valueIfNoneFound value ].
    ^ self copyReplaceAll:oldElement with:newElement

    "
     #(1 2 1 2 1 2 1 2 1 2) copyReplaceAll:1 with:99 ifNone:nil
     'hello world' copyReplaceAll:$l with:$* ifNone:'oops'
     'hello world' copyReplaceAll:$x with:$* ifNone:'oops' 
    "
!

copyReplaceAll:oldObject withAll:aCollection
    "return a copy, where all oldObjects are replaced by all
     elements from aCollection (i.e. sliced in).
     Non-destructive; returns a new collection.
     The implementation here is a general-purpose one;
     and should be redefined in String, if heavily used."

    |s|

"/    'Warning: #copyReplaceAll:withAll: will change semantics as defined in ANSI soon' errorPrintCR.

    s := WriteStream on:self species new.
    self do:[:el |
        el = oldObject ifTrue:[
            s nextPutAll:aCollection
        ] ifFalse:[
            s nextPut:el
        ]
    ].
    ^ s contents

    "
     args:    oldObject  : <object>
              newObject  : <collection>

     returns: newCollection
    "

    "
     '123123abc123' copyReplaceAll:$1 withAll:'one' 
     #(1 2 3 4 1 2 3 4) copyReplaceAll:1 withAll:#(9 9 9) 
     #(1 2 3 4 1 2 3 4) copyReplaceAll:1 withAll:'one' 
    "

    "Modified (comment): / 16-11-2016 / 21:35:36 / cg"
!

copyReplaceAny:collectionOfOldElements with:newElement
    "return a copy of the receiver, where all elements equal to any in collectionOfOldElements
     have been replaced by newElement."

    ^ (self copyFrom:1) replaceAny:collectionOfOldElements with:newElement

    "
     #(1 2 3 1 2 3 1 2 3 4 1 2 3 1 2 3) copyReplaceAny:#(1 2) with:99
     'hello world' copyReplaceAny:'eo' with:$*
    "
!

copyReplaceFrom:startIndex to:endIndex with:aCollection
    "return a copy of the receiver, where the elements from startIndex to
     endIndex have been replaced by the elements of aCollection.
     Returns a plain copy, if startIndex is beyond the receiver's size"

    |newColl sz mySize replSize|

    mySize := self size.
    startIndex > mySize ifTrue:[^ self copyFrom:1].

    replSize := aCollection size.
    sz := mySize - (endIndex - startIndex + 1) + replSize.
    newColl := self copyEmptyAndGrow:sz.
    newColl replaceFrom:1 to:(startIndex - 1) with:self.
    newColl replaceFrom:startIndex with:aCollection.
    newColl replaceFrom:(startIndex + replSize) with:self startingAt:(endIndex + 1).
    ^ newColl

    "
     #(1 2 3 4 5 6 7 8 9 0) copyReplaceFrom:3 to:6 with:#(a b c d e f g h i j k)
     'hello world' copyReplaceFrom:6 to:6 with:' there, '
     'one two three' copyReplaceFrom:5 to:7 with:'zwei'

    the following is something we want, not an unexpected side feature:
     '12345' copyReplaceFrom:5 to:4 with:'xxx'
    "

    "Modified (comment): / 27-07-2012 / 16:39:17 / cg"
!

copyReplaceFrom:startIndex to:endIndex withObject:anObject
    "return a copy of the receiver, where the elements from startIndex to
     endIndex have been replaced by anObject.
     Returns a plain copy, if startIndex is beyond the receiver's size"

    |newColl mySize|

    mySize := self size.
    startIndex > mySize ifTrue:[^ self copyFrom:1].

    newColl := self copyEmptyAndGrow:mySize.
    newColl replaceFrom:1 to:(startIndex - 1) with:self.
    newColl from:startIndex to:endIndex put:anObject.
    newColl replaceFrom:(endIndex + 1) with:self startingAt:(endIndex + 1).
    ^ newColl

    "
     #(1 2 3 4 5 6 7 8 9 0) copyReplaceFrom:3 to:6 withObject:#foo
     'hello world' copyReplaceFrom:1 to:5 withObject:$*
     'hello world' copyReplaceFrom:6 to:8 withObject:$*
    "
!

copyReplaceFrom:startIndex with:aCollection
    "return a copy of the receiver, where the elements from startIndex to
     the end have been replaced by the elements of aCollection"

    ^ self copyReplaceFrom:startIndex to:(self size) with:aCollection

    "
     #(1 2 3 4 5 6 7 8 9 0) copyReplaceFrom:3 with:#(a b c)
     'hello world' copyReplaceFrom:7 with:'smalltalk fan'
    "
!

copyReplacing:oldElement withObject:newElement
    "return a copy of the receiver, where all elements equal to oldElement
     have been replaced by newElement.
     ANSI version of what used to be #copyReplaceAll:with:"

    ^ (self copyFrom:1) replaceAll:oldElement with:newElement

    "
     #(1 2 1 2 1 2 1 2 1 2) copyReplacing:1 withObject:99
     'hello world' copyReplacing:$l withObject:$*
    "
!

copyThrough:element
    "return a new collection consisting of the receiver elements
     up-to (AND including) the first occurrence of element."

    |idx|

    idx := self indexOf:element.
    idx == 0 ifTrue:[^ nil].    "question: is this ok?"
    ^ self copyFrom:1 to:idx

    "
     #($a $b $c $d $e $f $g) copyThrough:$d
     '1234567890' copyThrough:$5
     '1234567890' copyThrough:$a
     '1234567890' copyThrough:$1
    "
!

copyTo:stopIndex
    "Return a new collection consisting of receiver's elements from 1 up to (including) stopIndex.
     Raise an error, if stopIndex is out of range."

    ^ self copyFrom:1 to:stopIndex

    "
     #($a $b $c $d $e $f $g) copyTo:5
     '1234567890' copyTo:4
    "
!

copyToMax:stop
    "return a new collection consisting of receiver's elements
     from 1 up to (including) index stop, or up to the receiver's end,
     whichever is smaller (i.e. like copyTo:, but do not err if receiver is smaller"

    ^ self copyFrom:1 to:(self size min:stop)

    "
     #($a $b $c $d $e $f $g) copyTo:10  - raises an error
     #($a $b $c $d $e $f $g) copyToMax:10
    "
!

copyTransliterating:oldElements to:newElements
    "return a copy, where elements all transliterated via the given mapping.
     The transiteraion works like perl's tr operator.

     Transliterates all occurrences of the characters found in the search list with the 
     corresponding character in the replacement list. 
     A character range may be specified with a hyphen, so /A-J/0-9/ does the same replacement as 
     /ACEGIBDFHJ/0246813579/. The hyphen may be escaped with a backslash as in /0\-1).

     Note that tr does not do other character escapes such as \n. 
     If you want to map strings between lower/upper cases, see asUpperCase and asLowerCase.

     Note also that the whole range idea is rather unportable between character sets,
     and even within character sets they may cause results you probably didn't expect. 
     A sound principle is to use only ranges that begin from and end at either alphabets of equal 
     case (a-e, A-E), or digits (0-4). 
     Anything else is unsafe. If in doubt, spell out the character sets in full.
    "

    ^ self
        copyTransliterating:oldElements to:newElements
        complement:false squashDuplicates:false

    "
     'abcdefghijkl1234567890' copyTransliterating:'b-g' to:'B-G'  
     'abcdefghijkl1234567890' copyTransliterating:'69' to:'96'      
     'abcdefghijkl1234567890' copyTransliterating:'a' to:'b'        
     'abcdefghijkl1234567890' copyTransliterating:'aeiou' to:'AEIOU' 
     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'QERTYUIOPX' 

     can also be used to remove character:
     'abcdefghijkl1234567890' copyTransliterating:'aeiou' to:''

     'abcdefg
hijkl1
234567890' copyTransliterating:(Array with:Character cr) to:''        

    "
!

copyTransliterating:oldElements to:newElements 
        complement:complement squashDuplicates:squashDuplicates

    "return a copy, where elements all transliterated via the given mapping.
     The transiteraion works like perl's tr operator.

     Transliterates all occurrences of the characters found in the search list with the 
     corresponding character in the replacement list. It returns the number of characters replaced 
     or deleted.
     A character range may be specified with a hyphen, so /A-J/0-9/ does the same replacement as 
     /ACEGIBDFHJ/0246813579/. The hyphen may be escaped with a backslash as in /0\-1).

     Note that tr does not do other character escapes such as \n. 
     If you want to map strings between lower/upper cases, see asUpperCase and asLowerCase.

     Note also that the whole range idea is rather unportable between character sets,
     and even within character sets they may cause results you probably didn't expect. 
     A sound principle is to use only ranges that begin from and end at either alphabets of equal 
     case (a-e, A-E), or digits (0-4). 
     Anything else is unsafe. If in doubt, spell out the character sets in full.

     If complement is true, non-matching chars are affected.
     If squashDuplicates is true, translated duplicates are squashed (but not non-matches)
    "

    ^ self 
        copyTransliterating:oldElements to:newElements rawMap:false
        complement:complement squashDuplicates:squashDuplicates

    "
     'abcdefghijkl1234567890' copyTransliterating:'b-g' to:'B-G'    
     'abcdefghij-kl1234567890' copyTransliterating:'b\-g' to:'B+G'               
     'abcdefghijkl1234567890' copyTransliterating:'69' to:'96'      
     'abcdefghijkl1234567890' copyTransliterating:'a' to:'b'        
     'abcdefghijkl1234567890' copyTransliterating:'aeiou' to:'AEIOU'  
     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'QERTYUIOPX'  
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'b-za'  
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'c-zab'  
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'z-a'  

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A'
                              complement:false squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A'
                              complement:false squashDuplicates:true

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*'
                              complement:false squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*'
                              complement:true squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' '
                              complement:true squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' '
                              complement:false squashDuplicates:false

     - delete all a-zA-Z
     'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:''
                              complement:false squashDuplicates:false            

     - delete all except a-zA-Z
     'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:''
                              complement:true squashDuplicates:false  

     - squash multiple spaces
     'abcd   efghij kl112234  5678999 0abbb cccc deeeef ghijkl' copyTransliterating:' ' to:' '
                              complement:false squashDuplicates:true         

     - squash multiple digits
     'abcd   efghij kl112234  5678999 0abbb cccc deeeef ghijkl' copyTransliterating:'0-9' to:'0-9'
                              complement:false squashDuplicates:true         
    "
!

copyTransliterating:oldElements to:newElements rawMap:rawMap
        complement:complement squashDuplicates:squashDuplicates

    "return a copy, where elements all transliterated via the given mapping.

     The transiteraion works like perl's tr operator, unless rawMap is true;
     otherwise, elements from oldElements and newElements are treated without any processing,
     which makes this easier to use, if special characters (such as '-', '[' etc. are to be transliterated).

     Transliterates all occurrences of the characters found in the search list with the 
     corresponding character in the replacement list. It returns the number of characters replaced 
     or deleted.
     A character range may be specified with a hyphen, so /A-J/0-9/ does the same replacement as 
     /ACEGIBDFHJ/0246813579/. The hyphen may be escaped with a backslash as in /0\-1).

     Note that tr does not do other character escapes such as \n. 
     If you want to map strings between lower/upper cases, see asUpperCase and asLowerCase.

     Note also that the whole range idea is rather unportable between character sets,
     and even within character sets they may cause results you probably didn't expect. 
     A sound principle is to use only ranges that begin from and end at either alphabets of equal 
     case (a-e, A-E), or digits (0-4). 
     Anything else is unsafe. If in doubt, spell out the character sets in full.

     If complement is true, non-matching chars are affected.
     If squashDuplicates is true, translated duplicates are squashed (but not non-matches)
    "

    |map s1 s2 range1 range2 c1 c2 outStream prevXlated last inc rslt willDeleteChars|

    willDeleteChars := false.
    map := Dictionary new.

    rawMap ifTrue:[
        1 to:(oldElements size min:newElements size) do:[:i |
            map at:(oldElements at:i) put:(newElements at:i)
        ].
        "/ remaining are filled with last from newElements
        newElements size+1 to:oldElements size do:[:i |
            map at:(oldElements at:i) put:(newElements last)
        ].
    ] ifFalse:[
        s1 := oldElements readStream.
        s2 := newElements readStream.
        range1 := range2 := nil.
        [
            (range1 notNil and:[range1 atEnd]) ifTrue:[range1 := nil]. 
            range1 notNil or:[ s1 atEnd not ]
        ] whileTrue:[
            range1 notNil ifTrue:[
                c1 := range1 next.
                range1 atEnd ifTrue:[range1 := nil]. 
            ] ifFalse:[
                c1 := s1 next.
                s1 peek == $\ ifTrue:[
                    s1 next.
                ] ifFalse:[
                    s1 peek == $- ifTrue:[
                        s1 next.
                        last := s1 next.
                        inc := c1 < last ifTrue:[1] ifFalse:[-1].
                        range1 := (c1 to:last by:inc) readStream.
                        c1 := range1 next.
                        range1 atEnd ifTrue:[range1 := nil]. 
                    ].
                ].
            ].
            range2 notNil ifTrue:[
                c2 := range2 next.
                range2 atEnd ifTrue:[range2 := nil]. 
            ] ifFalse:[
                s2 atEnd ifTrue:[
                    "/ keep c2
                ] ifFalse:[
                    c2 := s2 next.
                    s2 peek == $\ ifTrue:[
                        s1 next.
                    ] ifFalse:[
                        s2 peek == $- ifTrue:[
                            s2 next.
                            last := s2 next.
                            inc := c2 < last ifTrue:[1] ifFalse:[-1].
                            range2 := (c2 to:last by:inc) readStream.
                            c2 := range2 next.
                            range2 atEnd ifTrue:[range2 := nil]. 
                        ].
                    ].
                ].
            ].
            map at:c1 put:c2.
            c2 isNil ifTrue:[
                willDeleteChars := true.
            ].
        ].
    ].

    (squashDuplicates not and:[complement not and:[willDeleteChars not]]) ifTrue:[
        "/ use a faster algorithm
        rslt := self species new:self size.
        1 to:self size do:[:i |
            |in|

            in := self at:i.
            rslt at:i put:(map at:in ifAbsent:in).
        ].
    ] ifFalse:[
        outStream := WriteStream on:(self species new).
        self do:[:in |
            |xLated out|

            complement ifTrue:[
                (map includesKey:in) ifTrue:[
                    xLated := out := in.
                ] ifFalse:[
                    out := newElements at:1 ifAbsent:nil.
                ].
            ] ifFalse:[
                (map includesKey:in) ifTrue:[
                    xLated := out := map at:in.
                ] ifFalse:[
                    out := in.
                ].
            ].
            out notNil ifTrue:[
                (squashDuplicates and:[prevXlated notNil and:[prevXlated = xLated]]) ifTrue:[
                    "/ ignore
                ] ifFalse:[
                    outStream nextPut:out.
                ].
                prevXlated := out.
            ].
        ].
        rslt := outStream contents
    ].
    ^ rslt.

    "
     'abcdefghijkl1234567890' copyTransliterating:'b-g' to:'B-G'    
     'abcdefghij-kl1234567890' copyTransliterating:'b\-g' to:'B+G'               
     'abcdefghijkl1234567890' copyTransliterating:'69' to:'96'      
     'abcdefghijkl1234567890' copyTransliterating:'a' to:'b'        
     'abcdefghijkl1234567890' copyTransliterating:'aeiou' to:'AEIOU'  
     'abcdefghijkl1234567890' copyTransliterating:'aeiou' to:'*'  
     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'QERTYUIOPX'   
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'b-za'  
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'c-zab'  
     'abcdefghijkl1234567890' copyTransliterating:'a-z' to:'z-a'  

     'abcdefghijkl12345678--90' copyTransliterating:'-abcz' to:'z-' rawMap:true complement:false squashDuplicates:false  

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A'
                              complement:false squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A'
                              complement:false squashDuplicates:true

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*'
                              complement:false squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*'
                              complement:true squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' '
                              complement:true squashDuplicates:false

     'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' '
                              complement:false squashDuplicates:false

     - delete all a-zA-Z
     'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:''
                              complement:false squashDuplicates:false            

     - delete all except a-zA-Z
     'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:''
                              complement:true squashDuplicates:false  

     - squash multiple spaces
     'abcd   efghij kl112234  5678999 0abbb cccc deeeef ghijkl' copyTransliterating:' ' to:' '
                              complement:false squashDuplicates:true         

     - squash multiple digits
     'abcd   efghij kl112234  5678999 0abbb cccc deeeef ghijkl' copyTransliterating:'0-9' to:'0-9'
                              complement:false squashDuplicates:true         
    "
!

copyTransliteratingRaw:oldElements to:newElements
    "return a copy, where elements all transliterated via the given mapping"

    ^ self
        copyTransliterating:oldElements to:newElements
        rawMap:true
        complement:false squashDuplicates:false

    "
     'abcdefghijkl1234567890' copyTransliteratingRaw:'abc' to:'*'  
     'abcdefghijkl---1234567890' copyTransliteratingRaw:'-' to:'*'      
    "
!

copyUpThrough:element
    "return a new collection consisting of the receiver elements
     up-to (and including) the first occurrence of element;
     or to the end, if element is not included"

    |idx|

    idx := self indexOf:element.
    idx == 0 ifTrue:[^ self copyFrom:1].    "question: is this ok?"
    ^ self copyFrom:1 to:idx

    "
     #($a $b $c $d $e $f $g) copyUpThrough:$d
     '1234567890' copyUpThrough:$5
     '1234567890' copyUpThrough:$a
     '1234567890' copyUpThrough:$1
     '123456789' copyUpThrough:$0
    "

    "Created: / 14-09-2011 / 16:28:16 / cg"
!

copyUpTo:element
    "return a new collection consisting of the receiver elements
     up-to (but excluding) the first occurrence of element;
     or to the end, if element is not included"

    |idx|

    idx := self indexOf:element.
    idx == 0 ifTrue:[^ self copyFrom:1].    "question: is this ok?"
    idx == 1 ifTrue:[^ self copyEmpty].
    ^ self copyFrom:1 to:(idx-1)

    "
     #($a $b $c $d $e $f $g) copyUpTo:$d
     '1234567890' copyUpTo:$5
     '1234567890' copyUpTo:$a
     '1234567890' copyUpTo:$1
     '123456789' copyUpTo:$0
    "
!

copyWith:newElement
    "return a new collection containing the receiver's elements
     and the single new element, newElement.
     This is different from concatentation, which expects another collection
     as argument, but equivalent to copy-and-addLast."

    |newCollection mySize newSize|

    mySize := self size.
    newSize := mySize + 1.
    newCollection := self copyEmptyAndGrow:newSize.
    newCollection replaceFrom:1 to:mySize with:self startingAt:1.
    newCollection at:newSize put:newElement.
    ^newCollection

    "
     #(1 2 3 4 5) copyWith:$a
     'abcdefg' copyWith:$h
     'abcdefg' copyWith:'123'   -- will fail: string cannot be stored into string
     'abcdefg' copyWith:1       -- will fail: integer cannot be stored into string
    "
!

copyWith:newElement insertedAfterIndex:index
    "return a new collection with newElement inserted after index.
     With a 0 index, newElement is prepended;  
     if index is my size, it is appended.
     The receiver remains unchanged"

    ^ ((self copyTo:index) copyWith:newElement),(self copyFrom:index+1).

    "
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedAfterIndex:1  
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedAfterIndex:0
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedAfterIndex:14
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedAfterIndex:15  --> error
    "
!

copyWith:newElement insertedBeforeIndex:index
    "return a new collection with newElement inserted after index.
     With a 0 index, newElement is prepended;  
     if index is my size, it is appended.
     The receiver remains unchanged"

    ^ self copyWith:newElement insertedAfterIndex:index-1

    "
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedBeforeIndex:1  
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedBeforeIndex:0  --> error
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedBeforeIndex:14
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedBeforeIndex:15 
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWith:#a insertedBeforeIndex:16  --> error
    "
!

copyWithAll:aCollection insertedAfterIndex:index
    "return a new collection with aCollection sliced in after index.
     With a 0 index, aString is prepended;  
     if index is my size, it is appended.
     The receiver remains unchanged"

    "/ tuning only;
    "/ the code below would work as well (but create a garbage copy of the receiver)
    index == 0 ifTrue:[ ^ aCollection, self].
    index == self size ifTrue:[ ^ self,aCollection].

    ^ (self copyTo:index),aCollection,(self copyFrom:index+1).

    "
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedAfterIndex:1  
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedAfterIndex:0
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedAfterIndex:14
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedAfterIndex:15  --> error
    "
!

copyWithAll:aCollection insertedBeforeIndex:index
    "return a new collection with aCollection sliced in before index.
     With a 1 index, aString is prepended;  
     if index is my size+1, it is appended.
     The receiver remains unchanged"

    ^ self copyWithAll:aCollection insertedAfterIndex:index-1

    "
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedBeforeIndex:1  
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedBeforeIndex:0  --> error
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedBeforeIndex:14
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedBeforeIndex:15 
     #(1 2 3 4 5 6 7 8 9 0 1 2 3 4) copyWithAll:#(a b c) insertedBeforeIndex:16  --> error
    "
!

copyWithFirst:newFirstElement
    "return a new collection containing the receiver's elements
     and the single new element, newElement up front.
     This is different from concatentation, which expects two collections
     as argument, but equivalent to copy-and-addFirst."

    |newCollection mySize newSize|

    mySize := self size.
    newSize := mySize + 1.
    newCollection := self copyEmptyAndGrow:newSize.
    newCollection replaceFrom:2 to:mySize+1 with:self startingAt:1.
    newCollection at:1 put:newFirstElement.
    ^newCollection

    "
     #(1 2 3 4 5) copyWithFirst:$a  
     'abcdefg' copyWithFirst:$h
     'abcdefg' copyWithFirst:'123'   -- will fail: string cannot be stored into string
     'abcdefg' copyWithFirst:1       -- will fail: integer cannot be stored into string
    "
!

copyWithout:elementToSkip
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to elementToSkip are left out.
     No error is reported, if elementToSkip is not in the collection."

    |n         "{ Class: SmallInteger }"
     sz        "{ Class: SmallInteger }"
     srcIndex  "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"
     skipIndex "{ Class: SmallInteger }"
     copy l|

    "the code below may look like overkill,
     however, for big collections its better to move data
     around in big chunks"

    n := self occurrencesOf:elementToSkip.
    n == 0 ifTrue:[^ self copyFrom:1].

    sz := self size.
    copy := self copyEmptyAndGrow:(sz - n).

    srcIndex := 1.
    dstIndex := 1.

    n timesRepeat:[
        skipIndex := self indexOf:elementToSkip startingAt:srcIndex.
        l := skipIndex - srcIndex.
        l ~~ 0 ifTrue:[
            copy replaceFrom:dstIndex to:(dstIndex + l - 1)
                        with:self startingAt:srcIndex.
            dstIndex := dstIndex + l
        ].
        srcIndex := skipIndex + 1
    ].
    l := sz - srcIndex.
    copy replaceFrom:dstIndex to:(dstIndex + l)
                with:self startingAt:srcIndex.
    ^ copy

    "
     #($a $b $c $d $e $f $g) copyWithout:$d
     #($a $b $c $d $e $f $g) copyWithout:$a
     #($a $b $c $d $e $f $g) copyWithout:$g
     'abcdefghi' copyWithout:$h
     'abcdefg' copyWithout:$h
     #($a $b $c $a $a $d $e $a $f $g) copyWithout:$a
     #($a $b $c $d $e $f $g) copyWithout:$x
     #(90 80 70 60 50) copyWithout:70
     #(90 80 70 80 60 45 80 50) copyWithout:80
    "
!

copyWithoutFirst:elementToSkip
    "return a new collection consisting of a copy of the receiver's elements
     without the first elementToSkip, if it was present.
     No error is reported, if elementToSkip is not in the collection.
     Do not confuse this with copyButFirst:"

    |copy skipIndex sz|

    skipIndex := self indexOf:elementToSkip startingAt:1.
    (skipIndex == 0) ifTrue:[^ self copyFrom:1].

    sz := self size - 1.
    copy := self copyEmptyAndGrow:sz.
    copy replaceFrom:1 to:(skipIndex - 1) with:self startingAt:1.
    copy replaceFrom:skipIndex to:sz with:self startingAt:(skipIndex + 1).
    ^ copy

    "
     #($a $b $c $d $e $f $g) copyWithoutFirst:$d
     #($a $b $c $d $e $f $g) copyWithoutFirst:$x
     #(90 80 70 60 50) copyWithoutFirst:70
     #(90 80 70 80 60 45 80 50) copyWithoutFirst:80
    "
!

copyWithoutIdentical:elementToSkip
    "return a new collection consisting of a copy of the receiver, with
     ALL elements identical to elementToSkip are left out.
     No error is reported, if elementToSkip is not in the collection."

    |n         "{ Class: SmallInteger }"
     sz        "{ Class: SmallInteger }"
     srcIndex  "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"
     skipIndex "{ Class: SmallInteger }"
     copy l|

    "the code below may look like overkill,
     however, for big collections its better to move data
     around in big chunks"

    n := self count:[:el | el == elementToSkip].
    n == 0 ifTrue:[^ self copyFrom:1].

    sz := self size.
    copy := self copyEmptyAndGrow:(sz - n).

    srcIndex := 1.
    dstIndex := 1.

    n timesRepeat:[
        skipIndex := self identityIndexOf:elementToSkip startingAt:srcIndex.
        l := skipIndex - srcIndex.
        l ~~ 0 ifTrue:[
            copy replaceFrom:dstIndex to:(dstIndex + l - 1)
                        with:self startingAt:srcIndex.
            dstIndex := dstIndex + l
        ].
        srcIndex := skipIndex + 1
    ].
    l := sz - srcIndex.
    copy replaceFrom:dstIndex to:(dstIndex + l)
                with:self startingAt:srcIndex.
    ^ copy

    "
     #(#a #b #c 'a' #e #f #g) copyWithoutIdentical:#a
     #(#a #b #c 'a' #e #f #g) copyWithout:#a
    "
!

copyWithoutIndex:omitIndex
    "return a new collection consisting of receiver's elements
     without the argument stored at omitIndex"

    |copy sz|

    sz := self size - 1.
    copy := self copyEmptyAndGrow:sz.
    copy replaceFrom:1 to:(omitIndex - 1) with:self startingAt:1.
    copy replaceFrom:omitIndex to:sz with:self startingAt:(omitIndex + 1).
    ^ copy

    "
     #(1 2 3 4 5 6 7 8 9 0) copyWithoutIndex:3
     'abcdefghijkl' copyWithoutIndex:5
    "
!

copyWithoutIndex:firstIndex toIndex:lastIndex
    "return a new collection consisting of receiver's elements
     without the arguments elements stored from firstIndex to lastIndex"

    |copy sz|

    sz := self size - (lastIndex-firstIndex + 1).
    copy := self copyEmptyAndGrow:sz.
    copy replaceFrom:1 to:(firstIndex - 1) with:self startingAt:1.
    copy replaceFrom:firstIndex to:sz with:self startingAt:(lastIndex + 1).
    ^ copy

    "
     #(1 2 3 4 5 6 7 8 9 0) copyWithoutIndex:3 toIndex:5
     'abcdefghijkl' copyWithoutIndex:5 toIndex:5
    "
!

copyWithoutLast:count
    "return a new collection consisting of the receiver's elements
     except the last count elements.
     That is the same as copyButLast: and badly named (for compatibility),
     because the name may confuse users with the copyWithoutFirst: functionality.
     Please use copyButLast:."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #copyButLast:'.
    ^ self copyButLast:count.

    "
     #($a $b $c $d $e $f $g) copyWithoutLast:5
     '1234567890' copyWithoutLast:4
    "
!

repeatedConcatenation:nTimes
    "return a new collection consisting of nTimes the concatenation of the receiver"

    |newColl idx|

    newColl := self species newWithSize:(self size * nTimes).
    idx := 1.
    nTimes timesRepeat:[
        newColl replaceFrom:idx with:self startingAt:1.
        idx := idx + self size.
    ].
    ^ newColl

    "
     'hello' repeatedConcatenation:5 
     ' ' repeatedConcatenation:100   
     #[1 2 3] repeatedConcatenation:3
     #(1 2 3) repeatedConcatenation:1
     #(1 2 3) repeatedConcatenation:0
    "
!

restAfter:anElement
    "return a new collection consisting of the receiver's elements after
     (but excluding) anElement.
     If anElement is not in the receiver, the returned collection
     will be empty.
     See also #upTo:."

    |pos|

    pos := self indexOf:anElement.
    pos == 0 ifTrue:[^ self copyEmpty].

    ^ self copyFrom:(pos + 1)

    "
     #(1 2 3 4 5 6 7 8 9) upTo:5
     #(1 2 3 4 5 6 7 8 9) restAfter:5
     'hello world' upTo:Character space
     'hello world' restAfter:Character space
     '1234.5678' upTo:$.
     '1234.5678' restAfter:$.
    "
!

trimForWhich:aCheckBlock
    "return a copy of myself without leading and trailing elements,
     for which aCheckBlock returns true.
     Normally, this is mostly used with string receivers."

    |startIndex "{ Class: SmallInteger }"
     endIndex   "{ Class: SmallInteger }"
     sz|

    sz := self size.
    startIndex := 1.
    endIndex := sz.

    [(startIndex <= endIndex) and:[aCheckBlock value:(self at:startIndex)]] whileTrue:[
        startIndex := startIndex + 1
    ].
    [(endIndex > 1) and:[aCheckBlock value:(self at:endIndex)]] whileTrue:[
        endIndex := endIndex - 1
    ].
    startIndex > endIndex ifTrue:[
        ^ self class new
    ].
    ((startIndex == 1) and:[endIndex == sz]) ifTrue:[
        ^ self
    ].
    ^ self copyFrom:startIndex to:endIndex

    "
     '    foo    ' trimForWhich:[:ch | ch isSeparator]  
     '           ' trimForWhich:[:ch | ch isSeparator]  
     #(0 0 0 1 2 3 0 0 0) trimForWhich:[:e | e = 0]
    "
!

upTo:anElement
    "return a new collection consisting of the receiver's elements upTo
     (but excluding) anElement.
     If anElement is not in the receiver, the returned collection
     will consist of all elements of the receiver.
     See also #restAfter:  , #copyFrom:index."

    |pos|

    pos := self indexOf:anElement.
    pos == 0 ifTrue:[^ self copyFrom:1].

    ^ self copyFrom:1 to:(pos - 1)

    "
     #(1 2 3 4 5 6 7 8 9) upTo:5
     'hello world' upTo:Character space
     #(9 8 7 6 5 4 3 2 1) asSortedCollection upTo:5
     '1234.5678' upTo:$.
     '1234'      upTo:$.
     '.'      upTo:$.


     raises an error:

     (Dictionary new
        at:#foo put:'foo';
        at:#bar put:'bar';
        at:#baz put:'baz';
        yourself) upTo:#bar

    "

    "Modified: 11.5.1996 / 11:14:05 / cg"
!

upTo:anElement count:count
    "return a new collection consisting of the receiver's elements upTo
     (but excluding) count found anElements, i.e. the first found count-1
     elements are included in the returned collection; if count < 0 the
     procedure is done from the end of the collection backwards.
     If anElement is not in the receiver, the returned collection
     will consist of all elements of the receiver"

    |startPos endPos pos found|

    (count == 0 or: [count == 1]) ifTrue:[
        ^ self upTo:anElement
    ].

    startPos := 1.
    endPos   := self size.
    found    := 0.

    count > 1 ifTrue:[
        pos := 0.
        [pos < self size and: [found < count]]
            whileTrue: [pos := pos + 1. (self at: pos) == anElement ifTrue: [found := found + 1]].
        found == count ifTrue:[
            endPos   := pos - 1
        ]
    ].

    count < 0 ifTrue:[
        pos := self size + 1.
        [pos > 1 and: [found < count abs]]
            whileTrue: [pos := pos - 1. (self at: pos) == anElement ifTrue: [found := found + 1]].
        found == count abs ifTrue:[
            startPos := pos + 1
        ]
    ].

    ^ self copyFrom: startPos to: endPos

    "
     'hello1_hello2_hello3' upTo:$_ count:  2     returns first two 'hellos'
     'hello1_hello2_hello3' upTo:$_ count: -1     returns last 'hello'
     'hello1_hello2_hello3' upTo:$_ count: 0      returns first 'hello1'
     'hello1_hello2_hello3' upTo:$_ count: 1      returns first 'hello1'
     'hello1_hello2_hello3' upTo:$_               same; returns first 'hello1'
    "
!

upToAll:aSubCollection
    "return a new collection consisting of the receiver's elements upTo
     (but excluding) the first occurrence of a subcollection.
     If none of aCollectionOfObjects is found in the receiver, the returned collection
     will consist of all elements of the receiver.
     See also #upTo:"

    |pos|

    pos := self indexOfSubCollection:aSubCollection.
    pos == 0 ifTrue:[^ self copyFrom:1].

    ^ self copyFrom:1 to:(pos - 1)

    "
     'hello world' upToAll:'wo'
     'hello world' upToAll:'bla'
     #(1 2 3 4 5 6 7 8) upToAll:#(5)
     #(1 2 3 4 5 6 7 8) upToAll:#()
     #(1 3 4 2 3 4 5 6 7 8) upToAll:#(3 4 5 6)
     #(1 3 4 2 3 4 5 6 7 8) upToAll:#(3 5 6)
    "
!

upToAny:aCollectionOfObjects
    "return a new collection consisting of the receiver's elements upTo
     (but excluding) any in aCollectionOfObjects.
     If none of aCollectionOfObjects is found in the receiver, the returned collection
     will consist of all elements of the receiver.
     See also #upTo:"

    |pos|

    pos := self indexOfAny:aCollectionOfObjects.
    pos == 0 ifTrue:[^ self copyFrom:1].

    ^ self copyFrom:1 to:(pos - 1)

    "
     'hello world' upToAny:#($/ $:)
     'hello:world' upToAny:#($/ $:)
     'hello/world' upToAny:#($/ $:)
    "
!

upToElementForWhich:aBlock
    "return a new collection consisting of the receiver's elements 
     upTo (but excluding) the first element for which aBlock returns true.
     If none is found, a copy of whole collection is returned.
     See also #upTo:"

    |pos|

    pos := self findFirst:aBlock.
    pos == 0 ifTrue:[^ self copyFrom:1].

    ^ self copyFrom:1 to:(pos - 1)

    "
     'hello world' upToElementForWhich:[:c | c isSeparator]
     'hello:world' upToElementForWhich:[:c | c isSeparator]
    "
!

upToMatching:aBlock
    "Return the next elements up to but not including the next element
     for which aBlock returns true. 
     If none is found, a copy of whole collection is returned."

    ^ self upToElementForWhich:aBlock

    "
     #(1 2 3 4 5 6 7 8 9) upToMatching:[:el | el even and:[el >= 5]]
     'hello world' upToMatching:[:ch | ch isSeparator]
    "
!

upToSeparator
    "Return the next elements up to but not including the next separator.
     The next read will return the separator.
     If no separator is encountered, the contents up to the end is returned.
     The elements are supposed to understand #isSeparator 
     (i.e. the receiver is supposed to be a character-stream)."

    ^ self upToElementForWhich:[:ch | ch isSeparator]

    "
     'hello world' upToSeparator
    "
!

withoutLeadingForWhich:aCheckBlock
    "return a copy of myself without leading elements for which aCheckBlock returns true.
     Returns an empty collection, if the receiver consist only of matching elements.
     Normally, this is mostly used with string receivers."

    |index sz|

    sz := self size.
    index := 1.
    [index <= sz] whileTrue:[
        (aCheckBlock value:(self at:index)) ifFalse:[
            index == 1 ifTrue:[^ self].
            ^ self copyFrom:index
        ].
        index := index + 1
    ].
    ^ self class new

    "
     '****foo****' withoutLeadingForWhich:[:ch | ch isLetter not]     
     #( 0 0 0 1 2 3 4 0 0 0) withoutLeadingForWhich:[:e | e = 0]     
    "
!

withoutTrailingForWhich:aCheckBlock
    "return a copy of myself without trailing characters for which aCheckBlock returns true.
     Returns an empty collection, if the receiver consist only of matching chars."

    |index sz|

    index := sz := self size.
    [index ~~ 0] whileTrue:[
        (aCheckBlock value:(self at:index)) ifFalse:[
            index == sz ifTrue:[^ self].
            ^ self copyTo:index
        ].
        index := index - 1
    ].
    ^ self class new

    "
     '    foo....' withoutTrailingForWhich:[:ch | ch isLetter not]. 
     #( 0 0 0 1 2 3 4 0 0 0) withoutTrailingForWhich:[:e | e = 0]     
    "
! !

!SequenceableCollection methodsFor:'enumerating'!

collect:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of the results"

    |newCollection
     sz  "{ Class:SmallInteger }"|

    sz := self size.
    newCollection := self copyEmptyAndGrow:sz.
    1 to:sz do:[:index |
	newCollection at:index put:(aBlock value:(self at:index)).
    ].
    ^ newCollection

    "
     #(one two three four five six) collect:[:element | element asUppercase]
     #(1 2 3 4 5 6 7 8 9) collect:[:element | element factorial]
     (1 to:9) collect:[:element | element * element]
    "
!

do:aBlock
    "evaluate the argument, aBlock for every element in the collection."

    |stop "{ Class:SmallInteger }"|

    stop := self size.
    1 to:stop do:[:index |
	aBlock value:(self at:index).
    ]

    "
     #(one two three four five six) do:[:element | Transcript showCR:element]
    "
!

do:aBlock separatedBy:sepBlock
    "evaluate the argument, aBlock for every element in the collection.
     Between each element (i.e. not before the first element and not after the
     last element), evaluate sepBlock.
     This supports printing of collections with elements separated by some string."

    |stop "{ Class:SmallInteger }"|

    "/ redefined to use an inlinable to:do:
    "/ to avoid creation of another block

    stop := self size.
    stop < 1 ifTrue:[^ self].
    aBlock value:(self at:1).
    2 to:stop do:[:index |
        sepBlock value.
        aBlock value:(self at:index)
    ].

    "
     #(one two three four five six)
        do:[:each | Transcript show:each]
        separatedBy:[Transcript show:' , ']
    "
!

from:start collect:aBlock
    "evaluate the argument, aBlock for the elements starting at start
     to the end and return a collection of the results"

    ^ self from:start to:self size collect:aBlock

    "
     #(one two three four five six)
	from:2
	collect:[:element | element asUppercase]
    "

    "Created: / 30.1.2000 / 01:02:28 / cg"
!

from:start conform:aOneArgBlock
    "return true, if the elements starting at the start-index conform to some condition.
     I.e. return false, if aBlock returns false for any of those elements;
     true otherwise."

    self from:start to:(self size) do:[:element | 
        (aOneArgBlock value:element) ifFalse:[^ false]
    ].
    ^ true

    "Created: / 25-05-2012 / 14:02:13 / cg"
!

from:startIndex do:aBlock
    "evaluate the argument, aBlock for the elements starting with the
     element at startIndex to the end."

    ^ self from:startIndex to:self size do:aBlock

    "
     #(one two three four five six)
	from:3
	do:[:element | Transcript showCR:element]
    "
!

from:startIndex doWithExit:aBlock
    "evaluate the argument, aBlock for the elements starting with the
     element at startIndex to the end. Passes an additional exitBlock as second
     argument, which can be used to exit the loop early."

    ^ self from:startIndex to:self size doWithExit:aBlock

    "
     #(one two three four five six)
        from:3
        doWithExit:[:element :exit | 
            Transcript showCR:element.
            element = 'four' ifTrue:[ exit value:nil ]
        ]
    "

    "Created: / 28-07-2013 / 22:37:28 / cg"
!

from:startIndex keysAndValuesDo:aBlock
    "evaluate the argument, aBlock for the elements and indices starting with the
     element at startIndex to the end."

    ^ self from:startIndex to:self size keysAndValuesDo:aBlock

    "
     #(one two three four five six)
	from:3
	keysAndValuesDo:[:element :idx | Transcript showCR:(idx -> element) ]
    "
!

from:index1 to:index2 by:stepArg do:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to index2 stepping by step in the collection"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
     step  "{ Class:SmallInteger }" |

    start := index1. "/ these assignments force type checking...
    stop := index2.  "/ and guarantee inline loop code below.
    step := stepArg.

    start to:stop by:step do:[:index |
	aBlock value:(self at:index).
    ]

    "
     #(one two three four five six seven eight nine ten)
	from:2
	to:10
	by:2
	do:[:element | Transcript showCR:element]
    "
!

from:start to:stop collect:aBlock
    "evaluate the argument, aBlock for the elements indexed by start
     to stop in the collection and return a collection of the results"

    |newCollection sz
     idx  "{ Class:SmallInteger }"|

    sz := stop - start + 1.
    newCollection := self copyEmptyAndGrow:sz.
    idx := 1.
    start to:stop do:[:index |
	newCollection at:idx put:(aBlock value:(self at:index)).
	idx := idx + 1
    ].
    ^ newCollection

    "
     #(one two three four five six)
	from:2
	to:4
	collect:[:element | element asUppercase]
    "
!

from:start to:end conform:aOneArgBlock
    "return true, if the elements from start-index to end-index conform to some condition.
     I.e. return false, if aBlock returns false for any of those elements;
     true otherwise."

    self from:start to:end do:[:element | 
        (aOneArgBlock value:element) ifFalse:[^ false]
    ].
    ^ true

    "
     #(1 2 3 4 5) from:2 to:2 conform:[:el | el even]     
     #(1 2 2 4 5) from:2 to:4 conform:[:el | el even]               
     #(1 2 2 4 5) from:2 to:5 conform:[:el | el even]               
     #(2 4 6 8 10) conform:[:el | el even]    
    "

    "Modified: / 13-09-2006 / 11:19:03 / cg"
    "Created: / 25-05-2012 / 14:00:50 / cg"
!

from:index1 to:index2 do:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to
     index2 in the collection"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := index1. "/ these assignments force type checking...
    stop := index2.  "/ and guarantee inline loop code below.

    start to:stop do:[:index |
        aBlock value:(self at:index).
    ]

    "
     #(one two three four five six)
        from:3 to:5 do:[:element | Transcript showCR:element]
    "

    "Modified: / 02-06-2011 / 13:23:06 / cg"
!

from:index1 to:index2 doWithExit:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to
     index2 in the collection. Pass an additional exitBlock as second argument,
     which can be used to exit the loop early."

    |exitBlock|

    exitBlock := [:value | ^ value].
    ^ self from:index1 to:index2 do:[:el |
        aBlock value:el value:exitBlock
    ].

    "
     #(one two three four five six)
        from:3 to:5 doWithExit:[:element :exit | 
            Transcript showCR:element.
            element = 'four' ifTrue:[ exit value:nil].
        ]
    "

    "Created: / 28-07-2013 / 22:40:06 / cg"
!

from:index1 to:index2 doWithIndex:aBlock
    "Squeak/V'Age compatibility; 
     like keysAndValuesDo:, but passes the index as second argument."

    self from:index1 to:index2 keysAndValuesDo:[:index :el | aBlock value:el value:index].

    "Created: / 29-02-2012 / 11:47:48 / cg"
!

from:index1 to:index2 keysAndValuesDo:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to
     index2 in the collection; pass both index and value."

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := index1. "/ these assignments force type checking...
    stop := index2.  "/ and guarantee inline loop code below.

    start to:stop do:[:index |
	aBlock value:index value:(self at:index).
    ]

    "
     #(one two three four five six)
	from:3
	to:5
	keysAndValuesDo:[:idx :element | Transcript show:idx; space; showCR:element]
    "
!

from:index1 to:index2 orEndDo:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to
     index2 or the end (whichever comes first) in the collection"

    self from:index1 to:(index2 min:self size) do:aBlock

    "
     #(one two three four five six)
        from:3 to:10 orEndDo:[:element | Transcript showCR:element]
    "

    "Created: / 02-06-2011 / 13:21:32 / cg"
!

from:index1 to:index2 reverseDo:aBlock
    "evaluate the argument, aBlock for the elements with index index1 to
     index2 in the collection. Step in reverse order"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := index1. "/ these assignments force type checking...
    stop := index2.  "/ and guarantee inline loop code below.

    stop to:start by:-1 do:[:index |
	aBlock value:(self at:index).
    ]

    "
     #(one two three four five six)
	from:3
	to:5
	reverseDo:[:element | Transcript showCR:element]
    "
!

from:startIndex to:stopIndex select:aBlock
    "evaluate the argument, aBlock for the elements at startIndex..stopIndex
     and return a collection of those elements for which the block return true."

    |element newColl species needCopy
     sz  "{ Class:SmallInteger }"|

    sz := stopIndex - startIndex + 1.
    species := self species.
    species growIsCheap ifTrue:[
        newColl := self copyEmpty:sz.
        needCopy := false
    ] ifFalse:[
        sz == 0 ifTrue:[
            ^ (species new:0) postCopyFrom:self.
        ].
        newColl := self speciesForAdding new:sz.
        needCopy := true
    ].
    startIndex to:stopIndex do:[:index |
        element := self at:index.
        (aBlock value:element) ifTrue:[
            newColl add:element
        ].
    ].
    needCopy ifTrue:[
        newColl := (species withAll:newColl) postCopyFrom:self
    ].
    ^ newColl

    "
     #(faba one two three four five six)
        from:2 to:5 select:[:element | element startsWith:'f']
    "
!

from:startArg to:stopArg with:aSequenceableCollection doWithIndex:aThreeArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     aBlock must be a three-argument block, which get elements from either collection and
     the index as arguments.
     The collection argument must implement access via a numeric key."

    |start  "{ Class: SmallInteger }" 
     stop  "{ Class: SmallInteger }" |

    start := startArg.
    stop := stopArg.
    start to:stop do:[:index |
        aThreeArgBlock 
            value:(self at:index) 
            value:(aSequenceableCollection at:index)
            value:index.
    ]

    "
     #(one two three four five six) 
        from:2 to:5
        with:(1 to:10)
        doWithIndex:[:el1 :el2 :idx| Transcript show:idx; space; show:el1; space; showCR:el2]
    "

    "Created: / 08-01-2012 / 17:18:34 / cg"
!

inGroupsOf:n collect:anNArgBlock
    "evaluate the argument, anNArgBlock for every group of n elements in the collection,
     and collect the results.
     The block is called with n arguments for group of n consecutive elements in the receiver.
     An error will be reported, if the number of elements in the receiver
     is not a multiple of n."

    |stop "{ Class:SmallInteger }" newCollection dstIdx argVector rslt|

    stop := self size.
    newCollection := self copyEmptyAndGrow:stop // n.
    dstIdx := 1.

    "/ the reason for inlining the cases for 2/3 args is to avoid the temporary object creation, and to    
    "/ allow for the compiler (jitter) to generate better code for the block-call
    n == 2 ifTrue:[
        1 to:stop by:n do:[:index |
            rslt := anNArgBlock value:(self at:index) value:(self at:index+1).
            newCollection at:dstIdx put:rslt.
            dstIdx := dstIdx + 1.
        ].
        ^ newCollection.
    ].
    n == 3 ifTrue:[
        1 to:stop by:n do:[:index |
            rslt := anNArgBlock value:(self at:index) value:(self at:index+1) value:(self at:index+2).
            newCollection at:dstIdx put:rslt.
            dstIdx := dstIdx + 1.
        ].
        ^ newCollection.
    ].

    argVector := Array new:n.
    1 to:stop by:n do:[:index |
        argVector replaceFrom:1 to:n with:self startingAt:index.
        rslt := anNArgBlock valueWithArguments:argVector.
        newCollection at:dstIdx put:rslt.
        dstIdx := dstIdx + 1.
    ].
    ^ newCollection

    "for groups of 2, this is the same as:
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         pairWiseCollect:[:num :sym | num->sym]

     #(1 one 2 two 3 three 4 four 5 five 6 six)
         inGroupsOf:2 collect:[:num :sym | num->sym]

     #( 1 2 3 4 5    6 7 8 9 10   11 12 13 14 15   16 17 18 19 20 )
         inGroupsOf:5 collect:[:a :b :c :d :e | Array with:a with:b with:c with:d with:e]
    "

    "Modified: / 27-10-2006 / 10:07:02 / cg"
!

inGroupsOf:n do:anNArgBlock
    "evaluate the argument, anNArgBlock for every group of n elements in the collection.
     The block is called with n arguments for group of n consecutive elements in the receiver.
     An error will be reported, if the number of elements in the receiver
     is not a multiple of n."

    |stop "{ Class:SmallInteger }" argVector|

    stop := self size.

    "/ the reason for inlining the cases for 2-4 args is to avoid the temporary object creation, and to    
    "/ allow for the compiler (jitter) to generate better code for the block-call
    n == 2 ifTrue:[
        1 to:stop by:n do:[:index |
            anNArgBlock value:(self at:index) value:(self at:index+1).
        ].
        ^ self.
    ].
    n == 3 ifTrue:[
        1 to:stop by:n do:[:index |
            anNArgBlock value:(self at:index) value:(self at:index+1) value:(self at:index+2).
        ].
        ^ self.
    ].
    n == 4 ifTrue:[
        1 to:stop by:n do:[:index |
            anNArgBlock value:(self at:index) value:(self at:index+1) value:(self at:index+2) value:(self at:index+3).
        ].
        ^ self.
    ].

    argVector := Array new:n.

    1 to:stop by:n do:[:index |
        argVector replaceFrom:1 to:n with:self startingAt:index.
        anNArgBlock valueWithArguments:argVector.
    ].

    "for groups of 2, this is the same as:
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         pairWiseDo:[:num :sym | Transcript show:num; show:' is: '; showCR:sym]

     #(1 one 2 two 3 three 4 four 5 five 6 six)
         inGroupsOf:2 do:[:num :sym | Transcript show:num; show:' is: '; showCR:sym]

     #( 1 2 3 4 5    6 7 8 9 10   11 12 13 14 15   16 17 18 19 20 )
         inGroupsOf:5 do:[:a :b :c :d :e | Transcript show:a;space;show:b;space;show:c;space;show:d;space;showCR:e]
    "

    "Modified: / 27-10-2006 / 10:07:55 / cg"
!

keysAndValuesCollect:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments.
     Collect the returned values and return them."

    |sz newCollection|

    sz := self size.
    newCollection := self copyEmptyAndGrow:sz.
    1 to:sz do:[:index |
        newCollection at:index put:(aTwoArgBlock value:index value:(self at:index)).
    ].

    ^ newCollection

    "
     #(one two three four five six)
        keysAndValuesCollect:[:key :element |
                            key even ifTrue:element ifFalse:[element asUppercase]]


     |d|

     d := Dictionary new.
     d at:'a' put:'A'.
     d at:'b' put:'B'.
     d at:'c' put:'C'.
     d at:'d' put:'D'.
     d at:'e' put:'E'.
     d keysAndValuesCollect:[:key :element |
                            key first codePoint even
                                ifTrue:element
                                ifFalse:[element asLowercase]]
    "
!

keysAndValuesConform:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments.
     Return false if any such evaluation returns false, true otherwise."

    self keysAndValuesDo:[:index :el | 
        (aTwoArgBlock value:index value:el) ifFalse:[^  false].
    ].
    ^  true

    "
     #(10 20 30 40) keysAndValuesConform:[:key :element | element = (key * 10) ]. 
     #(10 20 30 33 40) keysAndValuesConform:[:key :element | element = (key * 10) ]. 
    "
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments."

    |stop  "{ Class:SmallInteger }"|

    stop := self size.
    1 to:stop do:[:index |
        aTwoArgBlock value:index value:(self at:index).
    ]

    "
     #(one two three four five six)
        keysAndValuesDo:[:key :element |
                            Transcript show:key; space; showCR:element
                        ]
    "
!

keysAndValuesReverseDo:aTwoArgBlock
    "evaluate the argument, aBlock in reverse order, for every element
     in the collection, passing both index and element as arguments."

    |stop  "{ Class:SmallInteger }"|

    stop := self size.
    stop to:1 by:-1 do:[:index |
	aTwoArgBlock value:index value:(self at:index).
    ]

    "
     #(one two three four five six)
	keysAndValuesReverseDo:[:key :element |
				    Transcript show:key; space; showCR:element
			       ]
    "

    "Modified: 9.5.1996 / 00:57:23 / cg"
!

keysDo:aBlock
    "evaluate the argument, aBlock for every key in the collection.
     That is: enumerate the indices.
     Here mostly for protocol compatibility."

    1 to:(self size) do:aBlock

    "
     #(one two three four five six)
        keysDo:[:key | Transcript show:key; space; showCR:element
     ]
    "

    "Created: / 24-08-2010 / 10:11:23 / cg"
!

nonNilElementsDo:aBlock
    "evaluate the argument, aBlock for every non-nil element in the collection."

    |stop "{ Class:SmallInteger }"
     element|

    stop := self size.
    1 to:stop do:[:index |
	(element := self at:index) notNil ifTrue:[
	    aBlock value:element.
	]
    ]
    "
     #(one nil three nil five nil seven) nonNilElementsDo:[:element | Transcript showCR:element]
    "
!

overlappingPairsCollect: aTwoArgBlock 
    "Answer the result of evaluating aBlock with all of the overlapping pairs of my elements.
     Returns an array, because the block may return any object
     (eg, if applied to a string, the returned collection could contain anything)"

    | mySize "{ Class: SmallInteger }" retval |

    mySize := self size.
    retval := Array ofSize: mySize - 1.
    1 to: mySize - 1 do: [:i | 
        retval at: i put: (aTwoArgBlock value: (self at: i) value: (self at: i + 1)) 
    ].
    ^ retval

    "
     #(1 2 3 4) overlappingPairsCollect: [:a :b | a->b]

     'hello world how nice' overlappingPairsCollect: [:a :b | a,b]

     (('hello worlld aa bb' overlappingPairsCollect: [:a :b | a,b]) 
        asBag select:[:p | p asSet size = 1])
             valuesSortedByCounts first
    "
!

overlappingPairsDo: aTwoArgBlock 
    "Evaluate aBlock with all of the overlapping pairs of my elements."

    |mySize "{ Class: SmallInteger }" |

    mySize := self size.
    1 to: mySize-1 do: [:idx | 
        aTwoArgBlock value: (self at: idx) value: (self at: idx + 1)
    ]

    "
     #(1 2 3 4) overlappingPairsDo: [:a :b | Transcript show:a; show:' '; showCR:b]
    "
!

overlappingPairsWithIndexDo: aThreeArgBlock 
    "Evaluate aBlock with all of the overlapping pairs of my elements plus the index."

    |mySize "{ Class: SmallInteger }" |

    mySize := self size.
    1 to: mySize - 1 do: [:idx | 
        aThreeArgBlock value: (self at: idx) value: (self at: idx + 1) value: idx
    ]

    "
     #(1 2 3 4) overlappingPairsWithIndexDo: [:a :b :idx | 
                    Transcript show:idx; show:': '; show:a; show:' '; showCR:b
                ]
    "
!

pairWiseCollect:aTwoArgBlock
    "evaluate the argument, aTwoArgBlock for every pair of elements in the collection.
     The block is called with 2 arguments for each 2 elements in the receiver.
     An error will be reported, if the number of elements in the receiver
     is not a multiple of 2.
     Collect the results and return a new collection containing those."

    ^ self inGroupsOf:2 collect:aTwoArgBlock

    "
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         pairWiseCollect:[:num :sym | sym->num]


     #(1 1  1 2  1 3  1 4  1 5)
         pairWiseCollect:[:x :y | x@y]
    "

    "Modified: / 27-10-2006 / 10:05:24 / cg"
!

pairWiseDo:aTwoArgBlock
    "evaluate the argument, aTwoArgBlock for every group of 2 elements in the collection.
     An error will be reported, if the number of elements in the receiver 
     is not a multiple of 2.
     CONFUSION ATTACK: 
        this is different from pairsDo:.
        but the Squeak-pairsDo: does the same as our pairWiseDo: 
        (sigh: but we were first, so they should have adapted...)"

    ^ self inGroupsOf:2 do:aTwoArgBlock

    "
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         pairWiseDo:[:num :sym | Transcript show:num; show:' is: '; showCR:sym]


     #(1 1  1 2  1 3  1 4  1 5)
         pairWiseDo:[:x :y | Transcript showCR:x@y]
    "

    "Modified: / 11-02-2007 / 09:31:29 / cg"
!

reverseDo:aBlock
    "evaluate the argument, aBlock for every element in the collection
     in reverse order"

    |sz  "{ Class:SmallInteger }"|

    sz := self size.
    sz to:1 by:-1 do:[:index |
	aBlock value:(self at:index).
    ]

    "
     #(one two three four five six) reverseDo:[:element | Transcript showCR:element]
    "
!

select:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of all elements for which the block return
     true"

    |element newColl species needCopy
     sz  "{ Class:SmallInteger }"|

    sz := self size.
    species := self species.
    species growIsCheap ifTrue:[
        newColl := self copyEmpty:sz.
        needCopy := false
    ] ifFalse:[
        sz == 0 ifTrue:[
            ^ (species new:0) postCopyFrom:self.
        ].
        newColl := self speciesForAdding new:sz.
        needCopy := true
    ].
    1 to:sz do:[:index |
        element := self at:index.
        (aBlock value:element) ifTrue:[
            newColl add:element
        ].
    ].
    needCopy ifTrue:[
        newColl := (species withAll:newColl) postCopyFrom:self
    ].
    ^ newColl

    "
     #(one two three four five six) select:[:element | element startsWith:'f']
     #(1 2 3 4 5 6 7 8 9) select:[:element | element odd]
     #() select:[:element | element odd]
     (#(17 12 1 98 51) asSortedCollection:[:a :b | b < a]) select:[:element | element odd]
     (1 to:9) select:[:element | element odd]
     (Smalltalk allClasses) select:[:class | class name startsWith:'S']
    "
!

slicesOf:n collect:aOneArgBlock
    "evaluate the argument, aOneArg for every slice of n elements of the collection,
     and collect the results as instances of targetContainerClass.
     The block is called with n element subcollections for groups of n consecutive elements in the receiver.
     If the number of elements in the receiver is not a multiple of n, the last block evaluation will
     get a short slice as argument"

    |out|

    out := self species writeStream.
    self slicesOf:n do:[:slice | out nextPut:(aOneArgBlock value:slice)].
    ^ out contents.

    ":
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         slicesOf:2 collect:[:slice | slice map:#asString]

     #( 1 2 3 4 5    6 7 8 9 10   11 12 13 14 15   16 17 18 19 20 )
         slicesOf:5 collect:[:slice | slice map:#asString]
    "
!

slicesOf:n do:aOneArgBlock
    "evaluate the argument, aOneArg for every slice of n elements of the collection.
     The block is called with n element subcollections for groups of n consecutive elements in the receiver.
     If the number of elements in the receiver is not a multiple of n, the last block evaluation will
     get a short slice as argument"

    |i stop|

    i := 1. stop := self size.
    [i <= stop ] whileTrue:[
        aOneArgBlock value:(self copyFrom:i to:(i+n-1 min:stop)).
        i := i + n.
    ].

    ":
     #(1 one 2 two 3 three 4 four 5 five 6 six)
         slicesOf:2 do:[:slice | Transcript showCR:slice]

     #( 1 2 3 4 5    6 7 8 9 10   11 12 13 14 15   16 17 18 19 20 )
         slicesOf:5 do:[:slice | Transcript showCR:slice]

     bad size:
     #( 1 2 3 4 5    6 7 8 9 10   11 12 13 14 15   16 17 18 19 20   21)
         slicesOf:5 do:[:slice | Transcript showCR:slice]
    "
!

with:aSequenceableCollection do:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     The second argument, aBlock must be a two-argument block.
     The collection argument must implement access via a numeric key 
     and the sizes must be the same (this is a new check!!)."

    |stop  "{ Class: SmallInteger }" |

    stop := self size.
    aSequenceableCollection size == stop ifFalse:[
        NotEnoughElementsSignal raiseRequestErrorString:'collections must be of the same size'.
    ].

    1 to:stop do:[:index |
        aTwoArgBlock value:(self at:index) value:(aSequenceableCollection at:index).
    ]

    "
     #(one two three four five six)
        with:(1 to:6)
        do:[:el1 :el2 | Transcript show:el1; space; showCR:el2]
    "

    "Modified (Format): / 30-06-2011 / 17:39:59 / cg"
!

with:aSequenceableCollection doWithIndex:aThreeArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     aBlock must be a three-argument block, which get elements from either collection and
     the index as arguments.
     The collection argument must implement access via a numeric key.
     and the sizes must be the same (this is a new check!!)."

    |stop  "{ Class: SmallInteger }" |

    stop := self size.
    aSequenceableCollection size == stop ifFalse:[
        NotEnoughElementsSignal raiseRequestErrorString:'collections must be of the same size'.
    ].
    1 to:stop do:[:index |
        aThreeArgBlock 
            value:(self at:index) 
            value:(aSequenceableCollection at:index)
            value:index.
    ]

    "
     #(one two three four five six)
        with:(1 to:10)
        doWithIndex:[:el1 :el2 :idx| Transcript show:idx; space; show:el1; space; showCR:el2]
    "

    "Created: / 05-07-2006 / 18:07:11 / fm"
    "Modified (comment): / 08-01-2012 / 17:18:59 / cg"
!

with:collection2 with:collection3 do:aThreeArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the collection arguments.
     The last argument, aBlock must be a three-argument block.
     The collection arguments must implement access via a numeric key 
     and the sizes must be the same."

    |stop  "{ Class: SmallInteger }" |

    stop := self size.
    (collection2 size == stop and:[collection3 size == stop])  ifFalse:[
        NotEnoughElementsSignal raiseRequestErrorString:'collections must be of the same size'.
    ].

    1 to:stop do:[:index |
        aThreeArgBlock 
            value:(self at:index) 
            value:(collection2 at:index)
            value:(collection3 at:index).
    ]

    "
     #(one two three four five six)
        with:(1 to:6)
        with:(100 to:600 by:100)
        do:[:el1 :el2 :el3 | Transcript show:el1; space; show:el2; space; showCR:el3]
    "

    "Modified (Format): / 30-06-2011 / 17:39:59 / cg"
! !

!SequenceableCollection methodsFor:'filling & replacing'!

atAllPut:anObject
    "replace all elements of the collection by the argument, anObject.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    self from:1 to:(self size) put:anObject

    "
     args:    anObject : <object>

     returns: self
    "

    "
     (Array new:10) atAllPut:1
     (String new:10) atAllPut:$a
    "

    "Modified: / 20.5.1998 / 15:14:11 / cg"
!

from:index1 to:index2 put:anObject
    "replace the elements from index1 to index2 of the collection
     by the argument, anObject.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |index "{ Class: SmallInteger }"
     end   "{ Class: SmallInteger }"|

    index := index1.
    end := index2.
    [index <= end] whileTrue:[
	self at:index put:anObject.
	index := index + 1
    ]

    "
     args:    index1    : <integer>
	      index2    : <integer>
	      anObject  : <object>

     returns: self
    "

    "
     #(1 2 3 4 5 6 7 8 9 0) from:3 to:6 put:$X
     'abcdefghijkl' from:3 to:6 put:$X
    "

    "Modified: / 20.5.1998 / 15:16:52 / cg"
!

replaceAll:oldObject by:newObject
    "backward ST/X compatibility: an alias for #replaceAll:with:.
     Pleace do no longer use this one;
     instead use #replaceAll:with: for ST-80 compatibility."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #replaceAll:with:'.
    ^ self replaceAll:oldObject with:newObject

    "
     args:    oldObject  : <object>
	      newObject  : <object>

     returns: self
    "

    "Modified: / 20.5.1998 / 15:16:28 / cg"
!

replaceAll:oldObject by:newObject from:startIndex to:stopIndex
    "backward ST/X compatibility: an alias for #replaceAll:with:from:to:.
     Please do no longer use this one;
     instead use #replaceAll:with:from:to: for ST-80 compatibility."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #replaceAll:with:from:to:'.
    ^ self replaceAll:oldObject with:newObject from:startIndex to:stopIndex

    "
     args:    oldObject  : <object>
	      newObject  : <object>
	      startIndex : <integer>
	      stopIndex  : <integer>

     returns: self
    "

    "Modified: / 20.5.1998 / 15:16:02 / cg"
!

replaceAll:oldObject with:newObject
    "replace all oldObjects by newObject in the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceAll:oldObject
	with:newObject
	from:1
	to:self size

    "
     args:    oldObject  : <object>
	      newObject  : <object>

     returns: self
    "

    "
     '123123abc123' replaceAll:$1 with:$*
     #(1 2 3 4 1 2 3 4) copy replaceAll:1 with:'one'
    "

    "Modified: / 20.5.1998 / 15:26:10 / cg"
!

replaceAll:oldObject with:newObject from:startIndex to:stopIndex
    "replace all oldObjects found between startIndex and endIndex,
     by newObject in the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    startIndex to:stopIndex do:[:index |
	(self at:index) = oldObject ifTrue:[
	    self at:index put:newObject
	]
    ]

    "
     args:    oldObject  : <object>
	      newObject  : <object>
	      startIndex : <integer>
	      stopIndex  : <integer>

     returns: self
    "

    "
     '123123abc123' replaceAll:$1 with:$*
     '123123abc123' replaceAll:$1 with:$* from:1 to:6
     #(1 2 3 4 1 2 3 4) replaceAll:1 with:'one' from:1 to:4
    "

    "Modified: / 20.5.1998 / 15:23:10 / cg"
!

replaceAllForWhich:aConditionBlock with:newObject
    "replace all elements for which aConditionBlock returns true
     between startIndex and endIndex, by newObject in the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    self
	replaceAllForWhich:aConditionBlock with:newObject
	from:1 to:(self size)

    "
     args:    aConditionBlock  : <block>
	      newObject        : <object>

     returns: self
    "
!

replaceAllForWhich:aConditionBlock with:newObject from:startIndex to:stopIndex
    "replace all elements for which aConditionBlock returns true
     between startIndex and endIndex, by newObject in the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    startIndex to:stopIndex do:[:index |
	(aConditionBlock value:(self at:index)) ifTrue:[
	    self at:index put:newObject
	]
    ]

    "
     args:    aConditionBlock  : <block>
	      newObject        : <object>
	      startIndex       : <integer>
	      stopIndex        : <integer>

     returns: self
    "
!

replaceAllIdentical:oldObject with:newObject
    "replace all oldObjects by newObject in the receiver.
     This is like #replaceAll:with:from:to:, but uses an identity compare.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceAllIdentical:oldObject
	with:newObject
	from:1
	to:self size

    "
     args:    oldObject  : <object>
	      newObject  : <object>

     returns: self
    "

    "
     #(1 2 3 4 1.0 2.0 3.0 4.0) copy replaceAll:1 with:'one'
     #(1 2 3 4 1.0 2.0 3.0 4.0) copy replaceAllIdentical:1 with:'one'
    "

!

replaceAllIdentical:oldObject with:newObject from:startIndex to:stopIndex
    "replace all oldObjects found between startIndex and endIndex,
     by newObject in the receiver.
     This is like #replaceAll:with:from:to:, but uses an identity compare.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    startIndex to:stopIndex do:[:index |
	(self at:index) == oldObject ifTrue:[
	    self at:index put:newObject
	]
    ]

    "
     args:    oldObject  : <object>
	      newObject  : <object>
	      startIndex : <integer>
	      stopIndex  : <integer>

     returns: self
    "

    "
     #(1 2 3 4 1 2 3 4) replaceAll:1 with:'one' from:1 to:8
     #(1 2 3 4 1.0 2.0 3.0 4.0) replaceAll:1 with:'one' from:1 to:8
     #(1 2 3 4 1.0 2.0 3.0 4.0) replaceAllIdentical:1 with:'one' from:1 to:8
    "
!

replaceAny:aCollection by:newObject
    "backward ST/X compatibility; alias for #replaceAny:with:.
     Pleace do no longer use this one;
     instead use #replaceAny:with: for naming consistence."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #replaceAny:with:'.
    ^ self replaceAny:aCollection with:newObject from:1 to:self size

    "
     args:    aCollection    : <colleciton of <object> >
	      newObject      : <object>

     returns: self
    "

    "
     '123123abc123' replaceAny:#($1 $2) with:$*
     #('foo' 'bar' 'foo' 'baz' foo 1 2 3) replaceAny:#(foo 1) with:'*'
    "

    "Modified: / 20.5.1998 / 15:17:51 / cg"
!

replaceAny:aCollection by:newObject from:startIndex to:stopIndex
    "backward ST/X compatibility; alias for #replaceAny:with:from:to:.
     Pleace do no longer use this one;
     instead use #replaceAny:with:from:to: for naming consistence."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #replaceAny:with:from:to:'.
    ^ self replaceAny:aCollection with:newObject from:startIndex to:stopIndex

    "
     args:    aCollection    : <colleciton of <object> >
	      newObject      : <object>
	      startIndex     : <integer>
	      stopIndex     : <integer>

     returns: self
    "

    "
     '123123abc123' replaceAny:#($1 $2) with:$* from:1 to:6
     #('foo' 'bar' 'foo' 'baz' foo 1 2 3) replaceAny:#(foo 1) with:'*'
    "

    "Modified: / 20.5.1998 / 15:18:16 / cg"
!

replaceAny:aCollection with:newObject
    "replace all elements, which are in aCollection, by newObject.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
        replaceAny:aCollection
        with:newObject
        from:1
        to:self size

    "
     #(1 2 3 4 5 6 7 1 2 3 4 5 6 7) copy replaceAny:#(1 3 5 9) with:99
     'abcdefgabcdefg' copy replaceAny:'abx' with:$_  
    "

    "Modified: / 06-03-2007 / 17:01:01 / cg"
!

replaceAny:aCollection with:newObject from:startIndex to:stopIndex
    "replace all elements within a range,
     which are in contained in aCollection by newObject.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |start "{ Class: SmallInteger }"
     stop "{ Class: SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    startIndex to:stopIndex do:[:index |
	(aCollection includes:(self at:index)) ifTrue:[
	    self at:index put:newObject
	]
    ]

    "
     args:    aCollection    : <colleciton of <object> >
	      newObject      : <object>
	      startIndex     : <integer>
	      stopIndex      : <integer>

     returns: self
    "

    "
     '123123abc123' replaceAny:#($1 $2) with:$* from:1 to:6
     #('foo' 'bar' 'foo' 'baz' foo 1 2 3) replaceAny:#(foo 1) with:'*'
    "

    "Modified: / 20.5.1998 / 15:22:43 / cg"
!

replaceFrom:startIndex count:numberOfElements with:replacementCollection
    "replace numberOfElements elements in the receiver from startIndex,
     with elements taken from replacementCollection starting at 1.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceFrom:startIndex
	to:(startIndex + numberOfElements - 1)
	with:replacementCollection
	startingAt:1

    "
     '1234567890' replaceFrom:5 count:3 with:'abcdef'
     #($a $b $c $d $e) replaceFrom:2 count:2 with:'12345'
    "

    "Modified: / 20.5.1998 / 15:25:46 / cg"
!

replaceFrom:startIndex count:numberOfElementsToReplace with:replacementCollection startingAt:repStartIndex
    "replace numberOfElementsToReplace elements in the receiver from startIndex,
     with elements taken from replacementCollection starting at repStartIndex.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceFrom:startIndex
	to:(startIndex + numberOfElementsToReplace - 1)
	with:replacementCollection
	startingAt:repStartIndex

    "
     '1234567890' replaceFrom:5 count:3 with:'abcdef' startingAt:3
     #($a $b $c $d $e) replaceFrom:2 count:3 with:'12345' startingAt:4
     #($a $b $c $d $e) asOrderedCollection replaceFrom:2 count:3 with:'12345' startingAt:4
    "

    "Modified: / 20.5.1998 / 15:22:22 / cg"
!

replaceFrom:startIndex to:stopIndex with:replacementCollection
    "replace elements in the receiver between index startIndex and stopIndex,
     with elements taken from replacementCollection starting at 1.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceFrom:startIndex
	to:stopIndex
	with:replacementCollection
	startingAt:1

    "
     args:    startIndex            : <integer>
	      stopIndex             : <integer>
	      replacementCollection : <colleciton of <object> >

     returns: self
    "

    "
     '1234567890' replaceFrom:5 to:7 with:'abcdef'
     #($a $b $c $d $e) replaceFrom:2 to:3 with:'12345'
    "

    "Modified: / 20.5.1998 / 15:25:37 / cg"
!

replaceFrom:startIndex to:stopIndex with:replacementCollection startingAt:repStartIndex
    "replace elements in the receiver between index startIndex and stopIndex,
     with elements  taken from replacementCollection starting at repStartIndex.
     Return the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     end      "{ Class: SmallInteger }" |

    replacementCollection == self ifTrue:[
        repStartIndex == startIndex ifTrue:[ "noting to copy" ^ self ].

        "beware the overlapping copy"
        (repStartIndex < startIndex) ifTrue:[
            " must do reverse copy "
            srcIndex := repStartIndex + (stopIndex - startIndex).
            dstIndex := stopIndex.
            end := startIndex.
            [dstIndex >= end] whileTrue:[
                self at:dstIndex put:(replacementCollection at:srcIndex).
                srcIndex := srcIndex - 1.
                dstIndex := dstIndex - 1
            ].
            ^ self
        ].
    ].

    srcIndex := repStartIndex.
    dstIndex := startIndex.
    end := stopIndex.
    [dstIndex <= end] whileTrue:[
        self at:dstIndex put:(replacementCollection at:srcIndex).
        srcIndex := srcIndex + 1.
        dstIndex := dstIndex + 1
    ]

    "
     args:    startIndex            : <integer>
              stopIndex             : <integer>
              replacementCollection : <colleciton of <object> >
              repStartIndex         : <integer>

     returns: self
    "

    "
     '1234567890' replaceFrom:5 to:7 with:'abcdef' startingAt:3
     #($a $b $c $d $e) replaceFrom:2 to:3 with:'12345' startingAt:4
     #($a $b $c $d $e) asOrderedCollection replaceFrom:2 to:3 with:'12345' startingAt:4

     |c|
     c := #($a $b $c $d $e) asOrderedCollection.
     c replaceFrom:2 to:3 with:c startingAt:4

     |c|
     c := #($a $b $c $d $e) asOrderedCollection.
     c replaceFrom:4 to:5 with:c startingAt:2
    "

    "Modified: / 08-05-2012 / 13:23:51 / cg"
!

replaceFrom:startIndex with:replacementCollection
    "replace elements in the receiver starting at startIndex,
     with elements taken from replacementCollection starting at 1
     to the end of replacementCollection.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceFrom:startIndex
	to:(startIndex + replacementCollection size - 1)
	with:replacementCollection
	startingAt:1

    "
     args:    startIndex            : <integer>
	      replacementCollection : <colleciton of <object> >

     returns: self
    "

    "
     '1234567890' replaceFrom:5 with:'abc'
     #($a $b $c $d $e) replaceFrom:2 with:'123'
    "

    "Modified: / 20.5.1998 / 15:25:27 / cg"
!

replaceFrom:startIndex with:replacementCollection startingAt:repStartIndex
    "replace elements in the receiver starting at startIndex,
     with elements taken from replacementCollection starting at repStartIndex
     to the end of replacementCollection.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    ^ self
	replaceFrom:startIndex
	to:(startIndex + replacementCollection size - repStartIndex)
	with:replacementCollection
	startingAt:repStartIndex

    "
     args:    startIndex            : <integer>
	      replacementCollection : <colleciton of <object> >
	      offset                : <integer>

     returns: self
    "

    "
     '1234567890' replaceFrom:5 with:'abcdef' startingAt:3
     #($a $b $c $d $e) replaceFrom:2 with:'12345' startingAt:4
    "

    "Modified: / 20.5.1998 / 15:25:18 / cg"
!

replaceLast:count with:replacementCollection
    "replace the last count elements elements in the receiver
     with elements taken from replacementCollection.
     Return the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    self replaceLast:count with:replacementCollection startingAt:1

    "
     '1234567890' replaceLast:5 with:'abcdef'
    "
!

replaceLast:count with:replacementCollection startingAt:repStartIndex
    "replace the last count elements elements in the receiver
     with elements taken from replacementCollection starting at repStartIndex.
     Return the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |sz|

    sz := self size.
    self replaceFrom:(sz - count + 1) to:sz with:replacementCollection startingAt:repStartIndex

    "
     '1234567890' replaceLast:5 with:'abcdef' startingAt:1
    "
!

startingAt:sourceStart replaceElementsIn:destColl from:destStartIndex to:destEndIndex
    "replace elements in destColl with elements from the receiver.

     Notice: This operation modifies the destination collection, NOT a copy;
     therefore the change may affect all others referencing this object."

    destColl
	replaceFrom:destStartIndex
	to:destEndIndex
	with:self
	startingAt:sourceStart

    "
     |s|
     s := 'abcdefghijklmnop'.
     '1234567890' startingAt:1 replaceElementsIn:s from:1 to:3.
     s'123defghijklmnop'
    "

    "Modified: / 20.5.1998 / 15:25:08 / cg"
! !

!SequenceableCollection methodsFor:'obsolete'!

randomizedQuickSortFrom:inBegin to:inEnd sortBlock:sortBlock with:aCollection
    "actual randomizedQuicksort worker for sort:with:-message.
     This exchanges a random element within the partition, to avoid
     the worst case O-square situation of quickSort.

     Notice, that this method has a much worse best- and average case
     runTime, due to the random number generation.
     The worst case of quickSort is encountered, if the choosen pivot
     element lies at either end of the partition, so that a split
     creates partitions of size 1 and (n-1).
     Since the middle element is choosen, this worst case is very unlikely
     to be encountered."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use quickSortFrom:to:sortBlock:with:'.

    "/ code was never used - use regular sort for backward compatibility
    ^ self quickSortFrom:inBegin to:inEnd sortBlock:sortBlock with:aCollection


"/    |begin   "{ Class: SmallInteger }"
"/     end     "{ Class: SmallInteger }"
"/     b       "{ Class: SmallInteger }"
"/     e       "{ Class: SmallInteger }"
"/     rnd     "{ Class: SmallInteger }"
"/     middleElement temp1 temp2 |
"/
"/    begin := inBegin.   "/ this also does a type-check
"/    end := inEnd.
"/
"/    b := begin.
"/    e := end.
"/
"/    "/ randomize that partition
"/    "/ by exchanging the first element with any random
"/    "/ element.
"/    rnd := Random nextIntegerBetween:b and:e.
"/    temp1 := self at:b. temp2 := self at:rnd.
"/    self at:b put:temp2. self at:rnd put:temp1.
"/    aCollection notNil ifTrue:[
"/        temp1 := aCollection at:b. temp2 := aCollection at:rnd.
"/        aCollection at:b put:temp2. aCollection at:rnd put:temp1
"/    ].
"/
"/    "/
"/    "/ now proceed as usual
"/    "/
"/    middleElement := self at:((b + e) // 2).
"/
"/    [b < e] whileTrue:[
"/        [b < end and:[sortBlock value:(self at:b) value:middleElement]] whileTrue:[b := b + 1].
"/        [e > begin and:[sortBlock value:middleElement value:(self at:e)]] whileTrue:[e := e - 1].
"/
"/        (b <= e) ifTrue:[
"/            (b == e) ifFalse:[
"/                temp1 := self at:b. temp2 := self at:e.
"/                self at:b put:temp2. self at:e put:temp1.
"/                aCollection notNil ifTrue:[
"/                    temp1 := aCollection at:b. temp2 := aCollection at:e.
"/                    aCollection at:b put:temp2. aCollection at:e put:temp1
"/                ].
"/            ].
"/            b := b + 1.
"/            e := e - 1
"/        ]
"/    ].
"/    (begin < e) ifTrue:[self randomizedQuickSortFrom:begin to:e sortBlock:sortBlock with:aCollection].
"/    (b < end) ifTrue:[self randomizedQuickSortFrom:b to:end sortBlock:sortBlock with:aCollection]
!

randomizedQuickSortFrom:inBegin to:inEnd with:aCollection
    "actual randomizedQuicksort worker for randomizedSort:-message.
     This exchanges a random element within the partition, to avoid
     the worst case O-square situation of quickSort.

     Notice, that this method has a much worse best- and average case
     runTime, due to the random number generation.
     The worst case of quickSort is encountered, if the choosen pivot
     element lies at either end of the partition, so that a split
     creates partitions of size 1 and (n-1).
     Since the middle element is choosen, this worst case is very unlikely
     to be encountered."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use quickSortFrom:to:with:'.
    "/ code was never used - use regular sort for backward compatibility
    ^ self quickSortFrom:inBegin to:inEnd with:aCollection


"/    |begin   "{ Class: SmallInteger }"
"/     end     "{ Class: SmallInteger }"
"/     b       "{ Class: SmallInteger }"
"/     e       "{ Class: SmallInteger }"
"/     rnd     "{ Class: SmallInteger }"
"/     middleElement temp1 temp2 |
"/
"/    begin := inBegin.   "/ this also does a type-check
"/    end := inEnd.
"/
"/    b := begin.
"/    e := end.
"/
"/    "/ randomize that partition
"/    "/ by exchanging the first element with any random
"/    "/ element.
"/    rnd := Random nextIntegerBetween:b and:e.
"/    temp1 := self at:b. temp2 := self at:rnd.
"/    self at:b put:temp2. self at:rnd put:temp1.
"/    aCollection notNil ifTrue:[
"/        temp1 := aCollection at:b. temp2 := aCollection at:rnd.
"/        aCollection at:b put:temp2. aCollection at:rnd put:temp1
"/    ].
"/
"/    "/
"/    "/ now proceed as usual
"/    "/
"/    middleElement := self at:((b + e) // 2).
"/
"/    [b < e] whileTrue:[
"/        [b < end and:[(self at:b) < middleElement]] whileTrue:[b := b + 1].
"/        [e > begin and:[middleElement < (self at:e)]] whileTrue:[e := e - 1].
"/
"/        (b <= e) ifTrue:[
"/            (b == e) ifFalse:[
"/                temp1 := self at:b. temp2 := self at:e.
"/                self at:b put:temp2. self at:e put:temp1.
"/                aCollection notNil ifTrue:[
"/                    temp1 := aCollection at:b. temp2 := aCollection at:e.
"/                    aCollection at:b put:temp2. aCollection at:e put:temp1
"/                ].
"/            ].
"/            b := b + 1.
"/            e := e - 1
"/        ]
"/    ].
"/    (begin < e) ifTrue:[self randomizedQuickSortFrom:begin to:e with:aCollection].
"/    (b < end) ifTrue:[self randomizedQuickSortFrom:b to:end with:aCollection]
"/
"/    "Modified: 21.8.1997 / 18:30:19 / cg"
"/    "Created: 21.8.1997 / 18:34:23 / cg"
!

randomizedSort
    <resource: #obsolete>
    "sort the collection inplace. The elements are compared using
     '<' i.e. they should offer a magnitude-like protocol.

     This uses the randomized quicksort algorithm,
     which has a better worstCase behavior than quickSort
     (bit worse bestCase & averageCase behavior).
     See: Knuth or Cormen,Leiserson,Rivest pg. 163"

"/    |stop|
"/
"/    stop := self size.
"/    (stop > 1) ifTrue:[
"/        self randomizedQuickSortFrom:1 to:stop sortBlock:[:a :b | a < b] with:nil
"/    ]

    "/ code was never used - use regular sort for backward compatibility
    ^ self sort

!

randomizedSort:sortBlock
    <resource: #obsolete>
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. This allows any sort criteria to be implemented.

     This uses the randomized quicksort algorithm,
     which has a better worstCase behavior than quickSort
     (bit worse bestCase & averageCase behavior).
     See: Knuth or Cormen,Leiserson,Rivest pg. 163"

"/    |stop|
"/
"/    stop := self size.
"/    (stop > 1) ifTrue:[
"/        self randomizedQuickSortFrom:1 to:stop sortBlock:sortBlock with:nil
"/    ]

    "/ code was never used - use regular sort for backward compatibility
    ^ self sort:sortBlock

!

randomizedSort:sortBlock with:aCollection
    <resource: #obsolete>
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. Also reorder the elements in aCollection.
     Use this, when you have a key collection to sort some other collection with.

     This uses the randomized quicksort algorithm,
     which has a better worstCase behavior than quickSort
     (bit worse bestCase & averageCase behavior).
     See: Knuth or Cormen,Leiserson,Rivest pg. 163"

"/    |stop|
"/
"/    stop := self size.
"/    (stop > 1) ifTrue:[
"/        self randomizedQuickSortFrom:1 to:stop sortBlock:sortBlock with:aCollection
"/    ]

    "/ code was never used - use regular sort for backward compatibility
    ^ self sort:sortBlock with:aCollection

!

randomizedSortWith:aCollection
    <resource: #obsolete>
    "sort the receiver collection inplace, using '<' to compare elements.
     Also, the elements of aCollection are reordered with it.
     Use this, when you have a key collection to sort another collection with.

     This uses the randomized quicksort algorithm,
     which has a better worstCase behavior than quickSort
     (bit worse bestCase & averageCase behavior).
     See: Knuth or Cormen,Leiserson,Rivest pg. 163"

"/    |stop|
"/
"/    stop := self size.
"/    (stop > 1) ifTrue:[
"/        self randomizedQuickSortFrom:1 to:stop sortBlock:[:a :b | a < b] with:aCollection
"/    ]

    "/ code was never used - use regular sort for backward compatibility
    ^ self sortWith:aCollection

! !

!SequenceableCollection methodsFor:'padded copying'!

leftPaddedTo:size with:padElement
    "return a new collection of length size, which contains the receiver
     right-adjusted (i.e. padded on the left).
     Elements on the left are filled with padElement.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged."

    |len s|

    len := self size.
    (len < size) ifTrue:[
        s := self species new:size withAll:padElement.
        s replaceFrom:(size - len + 1) with:self.
        ^ s
    ].
    ^ self

    "
     'foo' leftPaddedTo:10 with:$.
     'fooBar' leftPaddedTo:5 with:$.
     123 printString leftPaddedTo:10 with:$.
     (' ' , 123 printString) leftPaddedTo:10 with:$.
     (Float pi printString) leftPaddedTo:15 with:(Character space)
     (Float pi printString) leftPaddedTo:15 with:$-
     (' ' , Float pi class name) leftPaddedTo:15 with:$.
     #[1 2 3 4] leftPaddedTo:6 with:0
     #[1 2 3 4] leftPaddedTo:10 with:99
     #(1 2 3 4) leftPaddedTo:8 with:nil
    "
!

paddedTo:newSize with:padElement
    "return a new collection consisting of the receiver's elements,
     plus pad elements up to length.
     If the receiver's size is equal or greater than the length argument,
     the original receiver is returned unchanged."

    |s len|

    len := self size.
    len < newSize ifTrue:[
        s := self species new:newSize withAll:padElement.
        s replaceFrom:1 to:len with:self.
        ^ s
    ]

    "
     'foo' paddedTo:10 with:$.
     123 printString paddedTo:10 with:$*
     (Float pi printString) paddedTo:15 with:(Character space)
     (Float pi printString) paddedTo:15 with:$-
     (Float pi class name , ' ') paddedTo:15 with:$.
     #[1 2 3 4] paddedTo:6 with:0
     #[1 2 3 4] paddedTo:10 with:99
     #(1 2 3 4) paddedTo:8 with:nil
    "
!

paddedToMultipleOf:sizeModulu with:padElement
    |mySize mod numPad|

    mySize := self size.
    mod := (mySize \\ sizeModulu).
    mod == 0 ifTrue:[^ self].

    numPad := sizeModulu - mod.
    ^ self , (self species new:numPad withAll:padElement).

    "
     #[] paddedToMultipleOf:3 with:0
     #[1] paddedToMultipleOf:3 with:0
     #[1 2] paddedToMultipleOf:3 with:0
     #[1 2 3] paddedToMultipleOf:3 with:0
     #[1 2 3 4] paddedToMultipleOf:3 with:0

     #() paddedToMultipleOf:3 with:nil
     #(1) paddedToMultipleOf:3 with:nil
     #(1 2) paddedToMultipleOf:3 with:nil
     #(1 2 3) paddedToMultipleOf:3 with:nil
     #(1 2 3 4) paddedToMultipleOf:3 with:nil

     '' paddedToMultipleOf:3 with:Character space
     'a' paddedToMultipleOf:3 with:Character space
     'ab' paddedToMultipleOf:3 with:Character space
     'abc' paddedToMultipleOf:3 with:Character space
     'abcd' paddedToMultipleOf:3 with:Character space
    "
! !

!SequenceableCollection methodsFor:'printing & storing'!

printOn:aStream withSeparator:aSeparatorStringOrCharacter
    self do:[:eachElement|
        eachElement printOn:aStream.
    ] separatedBy:[
        aSeparatorStringOrCharacter printOn:aStream
    ].

    "
      #[1 2 3 4 10 17] printOn:Transcript withSeparator:$.
    "
!

printStringWithSeparator:aSeparatorStringOrCharacter
    |s|

    s := CharacterWriteStream on:''.
    self printOn:s withSeparator:aSeparatorStringOrCharacter.
    ^ s contents.

    "
      #[1 2 3 4 10 17] printStringWithSeparator:$.
    "
! !

!SequenceableCollection methodsFor:'private-sorting helpers'!

mergeFirst:first middle:middle last:last into:dst by:aBlock 
    "Private!!
     Merge the sorted ranges [first..middle] and [middle+1..last] of the receiver into the range [first..last] of dst."
    
    |i1 i2 val1 val2 out|

    i1 := first.
    out := first.
    i2 := middle + 1.
    val1 := self at:i1.

    i2 <= last ifTrue:[
        val2 := self at:i2.
        "select 'lower' half of the elements based on comparator"
        [(i1 <= middle) and:[i2 <= last]] whileTrue:[
            "this is stable if #< or #> ist used for comparison (and not #<= or #>=)"
            (aBlock value:val2 value:val1) ifTrue:[
                dst at:out put:val2.
                i2 := i2 + 1.
                i2 <= last ifTrue:[
                    val2 := self at:i2
                ]
            ] ifFalse:[
                dst at:out put:val1.
                i1 := i1 + 1.
                val1 := self at:i1.
            ].
            out := out + 1.
        ].
    ].

    "copy the remaining elements"
    i1 <= middle ifTrue:[
        dst 
            replaceFrom:out
            to:last
            with:self
            startingAt:i1
    ] ifFalse:[
        dst 
            replaceFrom:out
            to:last
            with:self
            startingAt:i2
    ].
!

mergeSortFrom: first to: last by: aBlock
    "Private!! Split the range to be sorted in half, sort each half, and merge the two half-ranges into dst."

    |size chunkSize idx nextIdx finished temp src dst|

    size := last-first + 1.
    size <= 1 ifTrue:[^ self].

    "size of the base chunks"
    chunkSize := 12.
    idx := first.
    finished := false.
    [finished] whileFalse:[
        nextIdx := idx + chunkSize.
        nextIdx > last ifTrue:[
            nextIdx := last+1.
            finished := true.
        ].
        self insertionSort:aBlock from:idx to:nextIdx-1.
        idx := nextIdx.
    ].

    chunkSize < size ifTrue:[
        "now merge the chunks"
        dst := Array new:self size.
        src := self.

        [chunkSize < size] whileTrue:[
            "merge pairs of adjecant chunks"
            idx := first.
            finished := false.
            [finished] whileFalse:[
                nextIdx := idx + (2*chunkSize).
                nextIdx > last ifTrue:[
                    nextIdx := last+1.
                    finished := true.
                ].
                src
                    mergeFirst:idx 
                    middle:idx+chunkSize-1 
                    last:nextIdx-1 
                    into:dst
                    by:aBlock.
                idx := nextIdx.
            ].

            chunkSize := chunkSize * 2.

            "merged chunks are in dst. Swap source and destination for next step"
            temp := dst.
            dst := src.
            src := temp.
        ].
        "note, the latest dst is now src (see above)"
        src ~~ self ifTrue:[
            self replaceFrom:first to:last with:src startingAt:first.
        ].
    ].
!

quickSortFrom:inBegin to:inEnd
    "actual quicksort worker for sort-message.
     Simulates recursion in a stack, to avoid recursion overflow
     with degenerated collections.

     The algorithm has been extended to introSort, which is quickSort with fallBack
     when we find out, that we have a worst case quick sort with O(n*n).

     Use #< for element comparisons, since this is the (fastest) base
     method in Magnitude, and the others may be defined by sending #<."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     bRun    "{ Class: SmallInteger }"
     eRun    "{ Class: SmallInteger }"
     m       "{ Class: SmallInteger }"
     prevIdx "{ Class: SmallInteger }"
     elB elM elE temp stack depthLimit|

    inEnd <= inBegin ifTrue:[
        "nothing to sort"
        ^ self.
    ].

    depthLimit := (1 + inEnd-inBegin) integerLog2 * 2.

    stack := OrderedCollection new:depthLimit*2.
    begin := inBegin.
    end := inEnd.

    [
        "do not sort small chunks,
         instead do an insertion sort over the whole range at the end, which is faster"
        end - begin > 12 ifTrue:[
            "ok, her we do the real quickSort..."
            depthLimit <= 0 ifTrue:[
                "this is apparently a degenerated quickSort 
                 - abort the quicksort and fall back to heapSort
                 which has O(n * log n) complexity in the worst case"
                self heapSortFrom:begin to:end.
                begin := end+1.
            ] ifFalse:[
                elB := self at:begin.
                elE := self at:end.
                m := (begin + end) // 2.
                elM := self at:m.
                "take the median of three as pivot (elM)"
                (elM < elB) ifTrue:[
                    temp := self at:begin put:elM.
                    elM := self at:m put:elB.
                    elB := temp.
                ].
                (elE < elB) ifTrue:[
                    self at:begin put:elE.
                    elE := self at:end put:elB.
                ].
                (elE < elM) ifTrue:[
                    self at:end put:elM.
                    elM := self at:m put:elE.
                ].

                bRun := begin.
                eRun := end.
                "use simple expressions without additional statements in whileXXX: conditions,
                 so STC can optimize"
                [bRun < eRun] whileTrue:[
                     [(bRun := bRun+1) <= eRun and:[(self at:bRun) < elM]] whileTrue.
                     [bRun <= (eRun := eRun-1) and:[elM < (self at:eRun)]] whileTrue.

                     (bRun < eRun) ifTrue:[
                         temp := self at:bRun.
                         self at:bRun put:(self at:eRun). 
                         self at:eRun put:temp.
                     ].
                 ].
                 (bRun < end) ifTrue:[
                     "remember right part for later processing"
                     stack add:end.
                     stack add:depthLimit-1.
                 ].

                "now sort the left part from begin .. new end"
                depthLimit := depthLimit - 1.      
                end := eRun.                
            ].
        ] ifFalse:[
            stack isEmpty ifTrue:[
                "we are done.
                 Do a final insertion sort over all the elements,
                 to eventually sort the small, unsorted chunks"
                begin := inBegin.
                bRun := begin + 1.
                end := inEnd.
                bRun to:end do:[:idx|
                    temp := self at:idx.
                    prevIdx := idx-1.
                    [prevIdx >= begin and:[temp < (self at:prevIdx)]] whileTrue:[
                        self at:prevIdx+1 put:(self at:prevIdx).
                        prevIdx := prevIdx - 1.
                    ].
                    (prevIdx+1) ~~ idx ifTrue:[
                        self at:prevIdx+1 put:temp.
                    ].
                ].
                ^ self
            ].
            begin := end + 1.
            depthLimit := stack removeLast.
            end := stack removeLast.
        ].
    ] loop.
!

quickSortFrom:inBegin to:inEnd sortBlock:sortBlock
    "actual quicksort worker for sort-message.
     Simulates recursion in a stack, to avoid recursion overflow
     with degenerated collections.

     The algorithm has been extended to introSort, which is quickSort with fallBack
     when we find out, that we have a worst case quick sort with O(n*n).

     Use sortBlock for element comparisons."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     bRun    "{ Class: SmallInteger }"
     eRun    "{ Class: SmallInteger }"
     m       "{ Class: SmallInteger }"
     prevIdx "{ Class: SmallInteger }"
     elB elM elE temp stack depthLimit|

    inEnd <= inBegin ifTrue:[
        "nothing to sort"
        ^ self.
    ].

    depthLimit := (1 + inEnd-inBegin) integerLog2 * 2.

    stack := OrderedCollection new:depthLimit*2.
    begin := inBegin.
    end := inEnd.

    [
        "do not sort small chunks,
         instead do an insertion sort over the whole range at the end, which is faster"
        end - begin > 12 ifTrue:[
            "ok, her we do the real quickSort..."
            depthLimit <= 0 ifTrue:[
                "this is apparently a degenerated quickSort 
                 - abort the quicksort and fall back to heapSort
                 which has O(n * log n) complexity in the worst case"
                self heapSort:sortBlock from:begin to:end.
                begin := end+1.
            ] ifFalse:[
                elB := self at:begin.
                elE := self at:end.
                m := (begin + end) // 2.
                elM := self at:m.
                "take the median of three as pivot (elM)"
                (sortBlock value:elM value:elB) ifTrue:[
                    temp := self at:begin put:elM.
                    elM := self at:m put:elB.
                    elB := temp.
                ].
                (sortBlock value:elE value:elB) ifTrue:[
                    self at:begin put:elE.
                    elE := self at:end put:elB.
                ].
                (sortBlock value:elE value:elM) ifTrue:[
                    self at:end put:elM.
                    elM := self at:m put:elE.
                ].

                bRun := begin.
                eRun := end.
                "use simple expressions without additional statements in whileXXX: conditions,
                 so STC can optimize"
                [bRun < eRun] whileTrue:[
                     [(bRun := bRun+1) <= eRun and:[sortBlock value:(self at:bRun) value:elM]] whileTrue.
                     [bRun <= (eRun := eRun-1) and:[sortBlock value:elM value:(self at:eRun)]] whileTrue.

                     (bRun < eRun) ifTrue:[
                         temp := self at:bRun.
                         self at:bRun put:(self at:eRun). 
                         self at:eRun put:temp.
                     ].
                 ].
                 (bRun < end) ifTrue:[
                     "remember right part for later processing"
                     stack add:end.
                     stack add:depthLimit-1.
                 ].

                "now sort the left part from begin .. new end"
                depthLimit := depthLimit - 1.      
                end := eRun.                
            ]
        ] ifFalse:[
            stack isEmpty ifTrue:[
                "we are done.
                 Do a final insertion sort over all the elements,
                 to eventually sort the small, unsorted chunks"
                begin := inBegin.
                bRun := begin + 1.
                end := inEnd.
                bRun to:end do:[:idx|
                    temp := self at:idx.
                    prevIdx := idx-1.
                    [prevIdx >= begin and:[sortBlock value:temp value:(self at:prevIdx)]] whileTrue:[
                        self at:prevIdx+1 put:(self at:prevIdx).
                        prevIdx := prevIdx - 1.
                    ].
                    (prevIdx+1) ~~ idx ifTrue:[
                        self at:prevIdx+1 put:temp.
                    ].
                ].
                ^ self
            ].
            begin := end + 1.
            depthLimit := stack removeLast.
            end := stack removeLast.
        ].
    ] loop.
!

quickSortFrom:inBegin to:inEnd sortBlock:sortBlock policy:policy
    "actual quicksort worker for sort-message.
     Simulates recursion in a stack, to avoid recursion overflow
     with degenerated collections.

     Use sortBlock for element comparisons."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     bRun    "{ Class: SmallInteger }"
     eRun    "{ Class: SmallInteger }"
     m       "{ Class: SmallInteger }"
     prevIdx "{ Class: SmallInteger }"
     elB elM elE temp stack depthLimit policySortBlock|

    inEnd <= inBegin ifTrue:[
        "nothing to sort"
        ^ self.
    ].

    depthLimit := (1 + inEnd-inBegin) integerLog2 * 2.

    stack := OrderedCollection new:depthLimit*2.
    begin := inBegin.
    end := inEnd.

    [
        "do not sort small chunks,
         instead do an insertion sort over the whole range at the end, which is faster"
        end - begin > 12 ifTrue:[
            "ok, her we do the real quickSort..."
            depthLimit <= 0 ifTrue:[
                "this is apparently a degenerated quickSort 
                 - abort the quicksort and fall back to heapSort
                 which has O(n * log n) complexity in the worst case"
                policySortBlock := [:arg1 :arg2| sortBlock value:policy value:arg1 value:arg2].
                self heapSort:policySortBlock from:begin to:end.
                begin := end+1.
            ] ifFalse:[
               elB := self at:begin.
               elE := self at:end.
               m := (begin + end) // 2.
               elM := self at:m.
               "take the median of three as pivot (elM)"
               (sortBlock value:policy value:elM value:elB) ifTrue:[
                   temp := self at:begin put:elM.
                   elM := self at:m put:elB.
                   elB := temp.
               ].
               (sortBlock value:policy value:elE value:elB) ifTrue:[
                   self at:begin put:elE.
                   elE := self at:end put:elB.
               ].
               (sortBlock value:policy value:elE value:elM) ifTrue:[
                   self at:end put:elM.
                   elM := self at:m put:elE.
               ].

               bRun := begin.
               eRun := end.
               "use simple expressions without additional statements in whileXXX: conditions,
                so STC can optimize"
               [bRun < eRun] whileTrue:[
                    [(bRun := bRun+1) <= eRun and:[sortBlock value:policy value:(self at:bRun) value:elM]] whileTrue.
                    [bRun <= (eRun := eRun-1) and:[sortBlock value:policy value:elM value:(self at:eRun)]] whileTrue.

                    (bRun < eRun) ifTrue:[
                        temp := self at:bRun.
                        self at:bRun put:(self at:eRun). 
                        self at:eRun put:temp.
                    ].
                ].
                 (bRun < end) ifTrue:[
                     "remember right part for later processing"
                     stack add:end.
                     stack add:depthLimit-1.
                 ].

                "now sort the left part from begin .. new end"
                depthLimit := depthLimit - 1.      
                end := eRun.                
            ].
        ] ifFalse:[
            stack isEmpty ifTrue:[
                "we are done.
                 Do a final insertion sort over all the elements,
                 to eventually sort the small, unsorted chunks"
                begin := inBegin.
                bRun := begin + 1.
                end := inEnd.
                bRun to:end do:[:idx|
                    temp := self at:idx.
                    prevIdx := idx-1.
                    [prevIdx >= begin and:[sortBlock value:policy value:temp value:(self at:prevIdx)]] whileTrue:[
                        self at:prevIdx+1 put:(self at:prevIdx).
                        prevIdx := prevIdx - 1.
                    ].
                    (prevIdx+1) ~~ idx ifTrue:[
                        self at:prevIdx+1 put:temp.
                    ].
                ].
                ^ self
            ].
            begin := end + 1.
            depthLimit := stack removeLast.
            end := stack removeLast.
        ].
    ] loop.
!

quickSortFrom:inBegin to:inEnd sortBlock:sortBlock with:aCollection
    "actual quicksort worker for sort-message.
     Simulates recursion in a stack, to avoid recursion overflow
     with degenerated collections.

     Use sortBlock for element comparisons."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     bRun    "{ Class: SmallInteger }"
     eRun    "{ Class: SmallInteger }"
     m       "{ Class: SmallInteger }"
     prevIdx "{ Class: SmallInteger }"
     elB elM elE temp temp1 stack depthLimit|

    inEnd <= inBegin ifTrue:[
        "nothing to sort"
        ^ self.
    ].

    depthLimit := (1 + inEnd-inBegin) integerLog2 * 2.

    stack := OrderedCollection new:depthLimit*2.
    begin := inBegin.
    end := inEnd.

    [
        "do not sort small chunks,
         instead do an insertion sort over the whole range at the end, which is faster"
        end - begin > 12 ifTrue:[
            "ok, her we do the real quickSort..."
            "/ heapSort does not support ...with: yet
            "depthLimit <= 0" false ifTrue:[
                "this is apparently a degenerated quickSort 
                 - abort the quicksort and fall back to heapSort
                 which has O(n * log n) complexity in the worst case"
                self heapSort:sortBlock from:begin to:end.
                begin := end+1.
            ] ifFalse:[
                elB := self at:begin.
                elE := self at:end.
                m := (begin + end) // 2.
                elM := self at:m.
                "take the median of three as pivot (elM)"
                (sortBlock value:elM value:elB) ifTrue:[
                    temp := self at:begin put:elM.
                    elM := self at:m put:elB.
                    elB := temp.

                    temp := aCollection at:begin.  
                    aCollection at:begin put:(aCollection at:m).  
                    aCollection at:m put:temp.  
                ].
                (sortBlock value:elE value:elB) ifTrue:[
                    self at:begin put:elE.
                    elE := self at:end put:elB.

                    temp := aCollection at:end.  
                    aCollection at:end put:(aCollection at:begin).  
                    aCollection at:begin put:temp. 
                ].
                (sortBlock value:elE value:elM) ifTrue:[
                    self at:end put:elM.
                    elM := self at:m put:elE.

                    temp := aCollection at:end.  
                    aCollection at:end put:(aCollection at:m).  
                    aCollection at:m put:temp.  
                ].

                bRun := begin.
                eRun := end.
                "use simple expressions without additional statements in whileXXX: conditions,
                 so STC can optimize"
                [bRun < eRun] whileTrue:[
                     [(bRun := bRun+1) <= eRun and:[sortBlock value:(self at:bRun) value:elM]] whileTrue.
                     [bRun <= (eRun := eRun-1) and:[sortBlock value:elM value:(self at:eRun)]] whileTrue.

                     (bRun < eRun) ifTrue:[
                         temp := self at:bRun.
                         self at:bRun put:(self at:eRun). 
                         self at:eRun put:temp.

                         temp := aCollection at:bRun.
                         aCollection at:bRun put:(aCollection at:eRun).
                         aCollection at:eRun put:temp.
                     ].
                 ].
                 (bRun < end) ifTrue:[
                     "remember right part for later processing"
                     stack add:end.
                     stack add:depthLimit-1.
                 ].

                "now sort the left part from begin .. new end"
                depthLimit := depthLimit - 1.      
                end := eRun.                
            ]
        ] ifFalse:[
            stack isEmpty ifTrue:[
                "we are done.
                 Do a final insertion sort over all the elements,
                 to eventually sort the small, unsorted chunks"
                begin := inBegin.
                bRun := begin + 1.
                end := inEnd.
                bRun to:end do:[:idx|
                    temp := self at:idx.
                    temp1 := aCollection at:idx.
                    prevIdx := idx-1.
                    [prevIdx >= begin and:[sortBlock value:temp value:(self at:prevIdx)]] whileTrue:[
                        self at:prevIdx+1 put:(self at:prevIdx).
                        aCollection at:prevIdx+1 put:(aCollection at:prevIdx).
                        prevIdx := prevIdx - 1.
                    ].
                    (prevIdx+1) ~~ idx ifTrue:[
                        self at:prevIdx+1 put:temp.
                        aCollection at:prevIdx+1 put:temp1.
                    ].
                ].
                ^ self
            ].
            begin := end + 1.
            depthLimit := stack removeLast.
            end := stack removeLast.
        ].
    ] loop.
!

quickSortFrom:inBegin to:inEnd with:aCollection
    "actual quicksort worker for sort-message.
     Simulates recursion in a stack, to avoid recursion overflow
     with degenerated collections.

     Use #< for element comparisons, since this is the (fastest) base
     method in Magnitude, and the others may be defined by sending #<."

    |begin   "{ Class: SmallInteger }"
     end     "{ Class: SmallInteger }"
     bRun    "{ Class: SmallInteger }"
     eRun    "{ Class: SmallInteger }"
     m       "{ Class: SmallInteger }"
     prevIdx "{ Class: SmallInteger }"
     elB elM elE temp temp1 stack depthLimit|

    inEnd <= inBegin ifTrue:[
        "nothing to sort"
        ^ self.
    ].

    depthLimit := (1 + inEnd-inBegin) integerLog2 * 2.

    stack := OrderedCollection new:depthLimit*2.
    begin := inBegin.
    end := inEnd.

    [
        "do not sort small chunks,
         instead do an insertion sort over the whole range at the end, which is faster"
        end - begin > 12 ifTrue:[
            "ok, her we do the real quickSort..."
            "/ heapSort does not support ...with: yet
            "depthLimit <= 0" false ifTrue:[
                "this is apparently a degenerated quickSort 
                 - abort the quicksort and fall back to heapSort
                 which has O(n * log n) complexity in the worst case"
                self heapSortFrom:begin to:end.
                begin := end+1.
            ] ifFalse:[
                elB := self at:begin.
                elE := self at:end.
                m := (begin + end) // 2.
                elM := self at:m.
                "take the median of three as pivot (elM)"
                (elM < elB) ifTrue:[
                    temp := self at:begin put:elM.
                    elM := self at:m put:elB.
                    elB := temp.

                    temp := aCollection at:begin.  
                    aCollection at:begin put:(aCollection at:m).  
                    aCollection at:m put:temp.  
                ].
                (elE < elB) ifTrue:[
                    self at:begin put:elE.
                    elE := self at:end put:elB.

                    temp := aCollection at:end.  
                    aCollection at:end put:(aCollection at:begin).  
                    aCollection at:begin put:temp. 
                ].
                (elE < elM) ifTrue:[
                    self at:end put:elM.
                    elM := self at:m put:elE.

                    temp := aCollection at:end.  
                    aCollection at:end put:(aCollection at:m).  
                    aCollection at:m put:temp.  
                ].

                bRun := begin.
                eRun := end.
                "use simple expressions without additional statements in whileXXX: conditions,
                 so STC can optimize"
                [bRun < eRun] whileTrue:[
                     [(bRun := bRun+1) <= eRun and:[(self at:bRun) < elM]] whileTrue.
                     [bRun <= (eRun := eRun-1) and:[elM < (self at:eRun)]] whileTrue.

                     (bRun < eRun) ifTrue:[
                         temp := self at:bRun.
                         self at:bRun put:(self at:eRun). 
                         self at:eRun put:temp.

                         temp := aCollection at:bRun.
                         aCollection at:bRun put:(aCollection at:eRun).
                         aCollection at:eRun put:temp.
                     ].
                 ].
                 (bRun < end) ifTrue:[
                     "remember right part for later processing"
                     stack add:end.
                     stack add:depthLimit-1.
                 ].

                "now sort the left part from begin .. new end"
                depthLimit := depthLimit - 1.      
                end := eRun.                
            ]
        ] ifFalse:[
            stack isEmpty ifTrue:[
                "we are done.
                 Do a final insertion sort over all the elements,
                 to eventually sort the small, unsorted chunks"
                begin := inBegin.
                bRun := begin + 1.
                end := inEnd.
                bRun to:end do:[:idx|
                    temp := self at:idx.
                    temp1 := aCollection at:idx.
                    prevIdx := idx-1.
                    [prevIdx >= begin and:[temp < (self at:prevIdx)]] whileTrue:[
                        self at:prevIdx+1 put:(self at:prevIdx).
                        aCollection at:prevIdx+1 put:(aCollection at:prevIdx).
                        prevIdx := prevIdx - 1.
                    ].
                    (prevIdx+1) ~~ idx ifTrue:[
                        self at:prevIdx+1 put:temp.
                        aCollection at:prevIdx+1 put:temp1.
                    ].
                ].
                ^ self
            ].
            begin := end + 1.
            depthLimit := stack removeLast.
            end := stack removeLast.
        ].
    ] loop.
! !

!SequenceableCollection methodsFor:'queries'!

firstIndex
    "return the first elements index"

    ^ 1
!

isSequenceable
    "return true, if the receiver is some kind of sequenceableCollection"

    ^ true
!

isSorted
    "return true. if my elements are sorted (already)"

    |lastEl el|

    lastEl := self first.
    2 to:self size do:[:i |
	el := self at:i.
	el >= lastEl ifFalse: [^ false].
	lastEl := el
    ].
    ^ true

    "
     #(1 2 3 5 10 100) isSorted
     #(1 2 3 5 100 10) isSorted
    "
!

isSortedBy:aBlock
    "return true, if my elements are sorted (already) by the given criterion (sortBlock)"

    |lastEl el|

    lastEl := self first.
    2 to:self size do:[:i |
	el := self at:i.
	(aBlock value:lastEl value:el) ifFalse: [^ false].
	lastEl := el
    ].
    ^ true

    "
     #(1 2 3 5 10 100) isSortedBy:[:a :b | a <= b]
     #(1 2 3 5 100 10) isSortedBy:[:a :b | a <= b]
     #(100 10 5 3 2 1) isSortedBy:[:a :b | a <= b]
     #(100 10 5 3 2 1) isSortedBy:[:a :b | a > b]
    "

!

keys
    "return a collection with all keys in the Smalltalk dictionary"

    |sz|

    sz := self size.
    sz == 0 ifTrue:[
	^ #()
    ].
    ^ 1 to:sz
!

lastIndex
    "return the last elements index"

    ^ self size
!

size
    "return the number of elements in the collection.
     concrete implementations must define this"

    ^ self subclassResponsibility
!

speciesForSubcollection
    "answer the class, when splitting instances into subcollections"

    ^ OrderedCollection

    "Created: / 24-01-2017 / 18:53:44 / stefan"
!

zeroIndex
    "return the index value which is returned when nothing
     is found in an indexOf* kind of search.
     ST-compatibility"

    ^ 0

    "Created: 14.2.1997 / 16:13:03 / cg"
! !

!SequenceableCollection methodsFor:'searching'!

detect:aBlock startingAt:startIndex
    "find the first element, for which evaluation of the argument, aBlock returns true.
     Start the search at startIndex.
     If none does so, report an error"

    ^ self detect:aBlock startingAt:startIndex ifNone:[self errorNotFound]

    "
     #(11 12 13 14) detect:[:n | n odd] startingAt:3
     #(12 14 16 18) detect:[:n | n odd] startingAt:3
    "

    "Created: / 21.10.1998 / 18:47:28 / cg"
!

detect:aBlock startingAt:startIndex ifNone:exceptionBlock
    "find the first element, for which evaluation of the argument, aBlock returns true.
     Start the search at startIndex.
     If none does so, return the evaluation of exceptionBlock"

    |stop|

    stop := self size.
    self from:startIndex to:stop do:[:el |
        (aBlock value:el) ifTrue:[
            ^ el
        ].
    ].
    ^ exceptionBlock value

    "
     #(11 12 13 14) detect:[:n | n odd] startingAt:3 ifNone:['sorry']
     #(12 14 16 18) detect:[:n | n odd] startingAt:3 ifNone:['sorry']
    "

    "Created: / 21.10.1998 / 18:46:01 / cg"
!

detectLast:aBlock
    "find the last element, for which evaluation of the argument, aBlock returns true.
     If none does so, report an error"

    ^ self detectLast:aBlock startingAt:self size ifNone:[self errorNotFound]

    "
     #(11 12 13 14) detectLast:[:n | n odd] 
     #(12 14 16 18) detectLast:[:n | n odd] ifNone:'sorry' 
    "
!

detectLast:aBlock startingAt:startIndex
    "find the last element, for which evaluation of the argument, aBlock returns true.
     Start the backward search at startIndex.
     If none does so, report an error"

    ^ self detectLast:aBlock startingAt:startIndex ifNone:[self errorNotFound]

    "
     #(11 12 13 14) detectLast:[:n | n odd] startingAt:3
     #(12 14 16 18) detectLast:[:n | n odd] startingAt:3
    "

    "Created: / 21.10.1998 / 18:47:28 / cg"
!

detectLast:aBlock startingAt:startIndex ifNone:exceptionBlock
    "find the last element, for which evaluation of the argument, aBlock returns true.
     Start the backward search at startIndex.
     If none does so, return the evaluation of exceptionBlock"

    self from:startIndex to:1 by:-1 do:[:el |
        (aBlock value:el) ifTrue:[
            ^ el
        ].
    ].
    ^ exceptionBlock value

    "
     #(11 12 13 14) detectLast:[:n | n odd] startingAt:3 ifNone:['sorry']
     #(12 14 16 18) detectLast:[:n | n odd] startingAt:3 ifNone:['sorry']
    "
!

findFirst:aBlock ifNone:exceptionalValue
    "find the index of the first element, for which evaluation of the argument, aBlock returns true.
     Return its index or the value from exceptionalValue if none detected.
     This is much like #detect, however, here an INDEX is returned,
     while #detect returns the element."

    |stop  "{ Class: SmallInteger }" |

    stop := self size.
    1 to:stop do:[:index |
        (aBlock value:(self at:index)) ifTrue:[^ index].
    ].
    ^ exceptionalValue value

    "
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 3)] ifNone:0
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 7)] ifNone:nil
    "
!

findFirst:aBlock startingAt:startIndex
    "find the first element, for which evaluation of the argument, aBlock returns true.
     Start the search at startIndex.
     Return its index or 0 if none detected.
     This is much like #detect:startingAt:, however, here an INDEX is returned,
     whereas #detect: returns the element."

    |start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }" |

    start := startIndex. "/ as a compiler hint
    stop := self size.
    start to:stop do:[:index |
        (aBlock value:(self at:index)) ifTrue:[^ index].
    ].
    ^ 0

    "
     #(1 4 3 4 3 6) findFirst:[:x | (x > 3)] startingAt:4
     'one.two.three' findFirst:[:c | (c == $.)] startingAt:5
    "

    "Modified: / 21.10.1998 / 18:48:22 / cg"
!

findLast:aBlock ifNone:exceptionalValue
    "find the last element, for which evaluation of the argument, aBlock returns true.
     Return its index or the value from exceptionValue if none detected."

    |start "{ Class: SmallInteger }"|

    start := self size.
    start to:1 by:-1 do:[:index |
        (aBlock value:(self at:index)) ifTrue:[^ index].
    ].
    ^ exceptionalValue value

    "notice: these are bad examples, use indexOf/lastIndexOf to search for an equal element.

     #(1 99 3 99 5 6) findLast:[:x | (x == 99)] ifNone:-1
     #(1 99 3 99 5 6) findLast:[:x | (x == 100)] ifNone:-1
     'one.two.three' findLast:[:c | (c == $.)] ifNone:-1
     'one.two.three' findLast:[:c | (c == $:)] ifNone:-1
    "
!

findLast:aBlock startingAt:startIndex
    "find the last element, for which evaluation of the argument, aBlock returns true. 
     Start the backward search at startIndex.
     Return its index or 0 if none detected."

    |start "{ Class: SmallInteger }"|

    start := startIndex.
    start to:1 by:-1 do:[:index |
        (aBlock value:(self at:index)) ifTrue:[^ index].
    ].
    ^ 0

    "
     #(1 99 3 99 5 6) findLast:[:x | (x == 99)] startingAt:3
     'one.two.three' findLast:[:c | (c == $.)] startingAt:7
    "
!

findLast:aBlock startingAt:startIndex endingAt:endIndex
    "find the last element, for which evaluation of the argument, aBlock returns true. 
     Start the search at startIndex.
     End the search at endIndex or when an element is found.
     Return its index or 0 if none detected."

    |start "{ Class: SmallInteger }" 
     end "{ Class: SmallInteger }"|

    start := startIndex.
    end := endIndex.
    start to:end by:-1 do:[:index |
        (aBlock value:(self at:index)) ifTrue:[^ index].
    ].
    ^ 0

    "
     #(1 99 3 99 5 6) findLast:[:x | (x == 99)] startingAt:3
     #(1 99 3 99 3 5 6) findLast:[:x | (x == 3)] startingAt:7 endingAt:6
     #(1 99 3 99 3 5 6) findLast:[:x | (x == 3)] startingAt:7 endingAt:5
     'one.two.three' findLast:[:c | (c == $.)] startingAt:7
    "
!

indexOfSubCollection:aCollection
    "find a subcollection. If found, return the index; if not found, return 0."

    ^ self indexOfSubCollection:aCollection startingAt:1 ifAbsent:[0]

    "
     #(1 2 3 4 5 6 7) indexOfSubCollection:#()
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(1)
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(1 2 3 4)
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(2 3 5)
     #(1 2 3 2 3 4 5) indexOfSubCollection:#(2 3 4)
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(5 6 7)
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(5 6 8)
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(5 6 7 8)
     'foobarbaz' indexOfSubCollection:'bar'
    "

    "Modified: / 20-04-2011 / 19:11:20 / cg"
!

indexOfSubCollection:aCollection ifAbsent:exceptionBlock
    "find a subcollection. If found, return the index;
     if not found, return the result of evaluating exceptionBlock."

    ^ self indexOfSubCollection:aCollection startingAt:1 ifAbsent:exceptionBlock
!

indexOfSubCollection:aCollection startingAt:startIndex
    "find a subcollection starting at index.
     If found, return the index; if not found, return 0."

    ^ self indexOfSubCollection:aCollection startingAt:startIndex ifAbsent:[0]
!

indexOfSubCollection:aCollection startingAt:startIndex endingAt:endIndex ifAbsent:exceptionBlock
    "find a subcollection, starting at index. If found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    |same first lastIndex checkIndex "{Class: SmallInteger }"
     cmpIndex   "{Class: SmallInteger }"
     sz         "{Class: SmallInteger }"|

    sz := aCollection size.
    sz == 0 ifTrue:[^ exceptionBlock value].
    first := aCollection at:1.

    lastIndex := self size.
    (endIndex notNil and:[endIndex < lastIndex]) ifTrue:[
        lastIndex := endIndex.
    ].

    checkIndex := startIndex - 1.
    [
        checkIndex := self indexOf:first startingAt:checkIndex+1 endingAt:lastIndex.
        checkIndex == 0 ifTrue:[^ exceptionBlock value].

        (checkIndex + sz - 1) > lastIndex ifTrue:[
            ^ 0
        ].
        same := true.
        cmpIndex := 1.
        [same and:[cmpIndex <= sz]] whileTrue:[
            (self at:checkIndex + cmpIndex - 1) = (aCollection at:cmpIndex) ifFalse:[
                same := false
            ] ifTrue:[
                cmpIndex := cmpIndex + 1
            ]
        ].
        same ifTrue:[^ checkIndex].
    ] loop.

    "
     #(1 2 3 4 5 6 7) indexOfSubCollection:#()  startingAt:2 endingAt:nil ifAbsent:0
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(1) startingAt:2 endingAt:nil ifAbsent:0
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2 3) startingAt:2 endingAt:nil ifAbsent:0
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2 3) startingAt:2 endingAt:6 ifAbsent:0
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:2 endingAt:nil ifAbsent:0
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:3 endingAt:nil ifAbsent:0
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:4 endingAt:nil ifAbsent:0
    "
!

indexOfSubCollection:aCollection startingAt:startIndex ifAbsent:exceptionBlock
    "find a subcollection, starting at index. If found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    |same first
     mySize     "{Class: SmallInteger }"
     checkIndex "{Class: SmallInteger }"
     cmpIndex   "{Class: SmallInteger }"
     sz         "{Class: SmallInteger }"|

    mySize := self size.
    sz := aCollection size.
    sz == 0 ifTrue:[^ exceptionBlock value].
    first := aCollection at:1.

    checkIndex := startIndex - 1.
    [
        checkIndex := self indexOf:first startingAt:checkIndex+1.
        checkIndex == 0 ifTrue:[^ exceptionBlock value].

        (checkIndex + sz - 1) > mySize ifTrue:[
            ^ 0
        ].
        same := true.
        cmpIndex := 1.
        [same and:[cmpIndex <= sz]] whileTrue:[
            (self at:checkIndex + cmpIndex - 1) = (aCollection at:cmpIndex) ifFalse:[
                same := false
            ] ifTrue:[
                cmpIndex := cmpIndex + 1
            ]
        ].
        same ifTrue:[^ checkIndex].
    ] loop.

    "
     #(1 2 3 4 5 6 7) indexOfSubCollection:#()  startingAt:2
     #(1 2 3 4 5 6 7) indexOfSubCollection:#(1) startingAt:2
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2 3) startingAt:2
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:2
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:3
     #(1 2 1 2 1 2 3) indexOfSubCollection:#(1 2)   startingAt:4
    "
!

lastIndexOfSubCollection:aCollection
    "find a subcollection from the end.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aCollection startingAt:self size ifAbsent:0

    "Created: / 16.5.1998 / 20:08:55 / cg"
    "Modified: / 16.5.1998 / 20:12:37 / cg"
!

lastIndexOfSubCollection:aCollection ifAbsent:exceptionBlock
    "find a subcollection from the end. If found, return the index;
     if not found, return the result of evaluating exceptionBlock."

    ^ self lastIndexOfSubCollection:aCollection startingAt:self size ifAbsent:exceptionBlock

    "Created: / 16.5.1998 / 20:09:08 / cg"
    "Modified: / 16.5.1998 / 20:12:39 / cg"
!

lastIndexOfSubCollection:aCollection startingAt:startIndex
    "find a subcollection from the end starting at index.
     If found, return the index; if not found, return 0."

    ^ self lastIndexOfSubCollection:aCollection startingAt:startIndex ifAbsent:0

    "Created: / 16.5.1998 / 20:09:23 / cg"
!

lastIndexOfSubCollection:aCollection startingAt:startIndex ifAbsent:exceptionBlock
    "find a subcollection from the end, starting at index. If found, return the index;
     if not found, return the result of evaluating exceptionBlock.
     This is a q&d hack - not very efficient"

    |same last
     mySize     "{Class: SmallInteger }"
     checkIndex "{Class: SmallInteger }"
     cmpIndex   "{Class: SmallInteger }"
     sz         "{Class: SmallInteger }"|

    mySize := self size.
    sz := aCollection size.
    sz == 0 ifTrue:[^ exceptionBlock value].
    last := aCollection at:sz.

    checkIndex := startIndex + sz.
    checkIndex >  mySize ifTrue:[
        checkIndex := mySize + 1
    ].
    [
        checkIndex := self lastIndexOf:last startingAt:checkIndex-1.
        checkIndex == 0 ifTrue:[^ exceptionBlock value].

        (checkIndex - sz + 1) < 1 ifTrue:[
            ^ 0
        ].
        same := true.
        cmpIndex := 1.
        [same and:[cmpIndex <= sz]] whileTrue:[
            (self at:checkIndex - sz + cmpIndex) = (aCollection at:cmpIndex) ifFalse:[
                same := false
            ] ifTrue:[
                cmpIndex := cmpIndex + 1
            ]
        ].
        same ifTrue:[^ checkIndex - sz + 1].
    ] loop.

    "
     #(1 2 3 4 5 6 7) lastIndexOfSubCollection:#()  startingAt:2
     #(1 2 3 4 5 6 7) lastIndexOfSubCollection:#(1)
     #(1 2 3 4 5 6 7) lastIndexOfSubCollection:#(1) startingAt:4
     #(1 3 1 2 1 3 3) lastIndexOfSubCollection:#(1 2 3)
     #(1 2 1 2 1 2 3) lastIndexOfSubCollection:#(1 2 3) startingAt:2
     #(1 2 1 2 1 2 3) lastIndexOfSubCollection:#(1 2 3)
     #(1 2 1 2 1 2 3) lastIndexOfSubCollection:#(1 2)
     #(1 2 1 2 1 2 3) lastIndexOfSubCollection:#(1 2)   startingAt:5
     #(1 2 1 2 1 2 3) lastIndexOfSubCollection:#(1 2)   startingAt:4
    "

    "Modified: / 16.5.1998 / 20:21:46 / cg"
!

map:values at:key ifAbsent:exceptionValue
    "the receiver is interpreted as a collection of keys;
     find key in the receiver and return the corresponding value
     from the valuesCollection argument."

    |idx|

    idx := self indexOf:key.
    idx == 0 ifTrue:[^ exceptionValue value].
    ^ values at:idx

    "
     #(16 32 128 256 512 1024) 
        map: #('ipc4' 'ipc5' 'ic07' 'ic08' 'ic09' 'ic10')
        at:128 ifAbsent:nil 

     #(16 32 128 256 512 1024) 
        map: #('ipc4' 'ipc5' 'ic07' 'ic08' 'ic09' 'ic10')
        at:64 ifAbsent:nil 
    "
! !

!SequenceableCollection methodsFor:'searching-equality'!

includes:anElement
    "return true if the collection contains anElement; false otherwise.
     Comparison is done using equality compare (i.e. =).
     See #includesIdentical: if identity is asked for."

    ^ (self indexOf:anElement startingAt:1) ~~ 0

    "
     args:    anElement : <object>

     returns: true  - if found
              false - if not found
    "

    "
     #(10 20 30 40 50 60 70) includes:99
     #(10 20 30 40 50 60 70) includes:40
     #(10 20 30 40 50 60 70) includes:40.0
    "

    "Modified: / 20.5.1998 / 15:00:23 / cg"
!

indexOf:anElement
    "search the collection for anElement;
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    ^ self indexOf:anElement startingAt:1

    "
     args:    anElement : <object>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 50 60 70) indexOf:40
     #(10 20 30 40 50 60 70) indexOf:40.0
    "

    "Modified: / 20.5.1998 / 14:59:55 / cg"
!

indexOf:anElement ifAbsent:exceptionBlock
    "search the collection for anElement;
     if found, return the index; otherwise return the value of the exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self indexOf:anElement startingAt:1.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
              exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
              exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) indexOf:40   ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) indexOf:40.0 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) indexOf:35   ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 14:57:35 / cg"
!

indexOf:elementToFind replaceWith:replacement startingAt:start stoppingAt:stop
    "search for the first occurrence of elementToFind starting at start,
     stopping the search at stop. If found, replace the element by replacement
     and return the index. If not found, return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |idx|

    idx := self indexOf:elementToFind startingAt:start.
    ((idx > 0) and:[idx <= stop]) ifTrue:[
        self at:idx put:replacement.
        ^ idx
    ].
    ^ 0

    "
     args:    elementToFind : <object>
              replacement   : <integer>
              start         : <integer>
              stop          : <integer>

     returns: elementIndex - if found (and replaced)
              0            - if not found
    "

    "
     |a|

     a := #(10 20 30 40 50 60 70).
     (a indexOf:30 replaceWith:nil startingAt:1 stoppingAt:7) printNL.
     a printNL.
    "

    "Modified: / 20-05-1998 / 14:59:30 / cg"
    "Modified (comment): / 23-05-2012 / 13:29:18 / cg"
!

indexOf:anElement startingAt:start
    "search the collection for anElement, starting the search at index start;
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"
     stop       "{ Class: SmallInteger }" |

    startIndex := start.
    stop := self size.
    startIndex to:stop do:[:index |
	anElement = (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
	      start     : <integer>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) indexOf:40   startingAt:5
     #(10 20 30 40 10 20 30 40) indexOf:40.0 startingAt:5
    "

    "Modified: / 20.5.1998 / 14:58:49 / cg"
!

indexOf:anElement startingAt:start endingAt:stop
    "search the collection for anElement, starting the search at index start;
     ending at stop.
     If found (within the range), return the index, otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"
     stopIndex  "{ Class: SmallInteger }" |

    startIndex := start.
    stopIndex := self size min:stop.
    startIndex to:stopIndex do:[:index |
	anElement = (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement      : <object>
	      start          : <integer>
	      stop           : <integer>

     returns: elementIndex         - if found
	      exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) indexOf:40   startingAt:3 endingAt:99
     #(10 20 30 40 10 20 30 40) indexOf:40   startingAt:3 endingAt:5
     #(10 20 30 40 10 20 30 40) indexOf:40   startingAt:1 endingAt:3
     #(10 20 30 40 10 20 30 40) indexOf:40.0 startingAt:5
    "

    "Created: / 12.4.1996 / 17:37:13 / cg"
    "Modified: / 20.5.1998 / 14:58:28 / cg"
!

indexOf:anElement startingAt:start ifAbsent:exceptionBlock
    "search the collection for anElement starting the search at index start;
     if found, return the index otherwise return the value of the
     exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self indexOf:anElement startingAt:start.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
	      start          : <integer>
	      exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
	      exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) indexOf:40   startingAt:5 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) indexOf:40.0 startingAt:5 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) indexOf:35   startingAt:5 ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 14:58:05 / cg"
!

indexOfAny:aCollection
    "search the collection for an element in aCollection.
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test).

     Notice, that for big collections, the runtime of this search
     grows proportional to size(receiver) * size(aCollection).
     You may think about using other mechanisms (Sets, Dictionaries etc)."

    ^ self indexOfAny:aCollection startingAt:1

    "
     #(10 20 30 40 50 60 70) indexOfAny:#(40 30 50)
     #(10 20 30 40 50 60 70) indexOfAny:#(40.0 30.0 50)
    "
!

indexOfAny:aCollection startingAt:start
    "search the collection for an element in aCollection,
     starting the search at index start;
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test).

     Notice, that for big collections, the runtime of this search
     grows proportional to size(receiver) * size(aCollection).
     You may think about using other mechanisms (Sets, Dictionaries etc)."


    |startIndex "{ Class: SmallInteger }"
     stop       "{ Class: SmallInteger }" |

    startIndex := start.
    stop := self size.
    startIndex to:stop do:[:index |
	(aCollection includes:(self at:index)) ifTrue:[^ index].
    ].
    ^ 0
    "
     #(10 20 30 40 10 20 30 40) indexOfAny:#(40 50 30) startingAt:5
     #(10 20 30 40 10 20 30 40) indexOfAny:#(40.0 50 30.0) startingAt:5
    "
!

indexOfAny:aCollection startingAt:start ifAbsent:exceptionBlock
    "search the collection for an element in aCollection,
     starting the search at index start;
     if found, return the index. If not, return the value returned by exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test).

     Notice, that for big collections, the runtime of this search
     grows proportional to size(receiver) * size(aCollection).
     You may think about using other mechanisms (Sets, Dictionaries etc)."


    |val|

    val := self indexOfAny:aCollection startingAt:start .
    val == 0 ifTrue:[^ exceptionBlock value].
    ^ val.

    "
     #(10 20 30 40 10 20 30 40) indexOfAny:#(40 50 30) startingAt:5 ifAbsent:-1
     #(10 20 30 40 10 20 30 40) indexOfAny:#(40.0 50 30.0) startingAt:5 ifAbsent:-1
     #(10 20 30 40 10 20 30 40) indexOfAny:#(99 88 77) startingAt:5 ifAbsent:['oops']
    "
!

indexOfAnyOf:aCollection
    "squeak compatibility: same as #indexOfAny:"

    ^ self indexOfAny:aCollection

    "
     #(10 20 30 40 50 60 70) indexOfAnyOf:#(40 30 50)
     #(10 20 30 40 50 60 70) indexOfAnyOf:#(40.0 30.0 50)
     'abcdefg' indexOfAnyOf:(CharacterSet newFrom:'cef')
    "

    "Modified: / 28-01-2011 / 18:03:14 / cg"
!

indexOfAnyOf:aCollection startingAt:start
    "squeak compatibility: same as #indexOfAny:startingAt:"

    ^ self indexOfAny:aCollection startingAt:start

    "
     #(10 20 30 40 50 60 70) indexOfAnyOf:#(40 30 50)     startingAt:2
     #(10 20 30 40 50 60 70) indexOfAnyOf:#(40.0 30.0 50) startingAt:2
    "
!

indexOfAnyOf:aCollection startingAt:start ifAbsent:exceptionBlock
    "squeak compatibility: same as #indexOfAny:startingAt:ifAbsent:"

    ^ self indexOfAny:aCollection startingAt:start ifAbsent:exceptionBlock

!

lastIndexOf:anElement
    "search the collection backwards for anElement;
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    ^ self lastIndexOf:anElement startingAt:self size

    "
     args:    anElement      : <object>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 50 60 70) lastIndexOf:40
     #(10 20 30 40 50 60 70) lastIndexOf:40.0
     #(10 20 30 40 50 60 70) lastIndexOf:35
     #(10 20 30 40 50 60 70) lastIndexOf:10
    "

    "Modified: / 20.5.1998 / 15:02:10 / cg"
!

lastIndexOf:anElement ifAbsent:exceptionBlock
    "search the collection backwards for anElement;
     if found, return the index otherwise return the value of the
     exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self lastIndexOf:anElement startingAt:self size.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     #(10 20 30 40 10 20 30 40) lastIndexOf:40   ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:40.0 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:35   ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:10   ifAbsent:['none']
    "
!

lastIndexOf:anElement startingAt:start
    "search the collection backwards for anElement, starting the search at index start;
     if found, return the index otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"|

    startIndex := start.
    startIndex to:1 by:-1 do:[:index |
	anElement = (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     #(10 20 30 40 10 20 30 40) lastIndexOf:40   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIndexOf:40.0 startingAt:8
     #(10 20 30 40 10 20 30 40) lastIndexOf:35   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIndexOf:10   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIndexOf:10   startingAt:4
    "
!

lastIndexOf:anElement startingAt:start ifAbsent:exceptionBlock
    "search the collection backwards for anElement starting the search at
     index start; if found, return the index
     otherwise return the value of the exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self lastIndexOf:anElement startingAt:start.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     #(10 20 30 40 10 20 30 40) lastIndexOf:40   startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:40.0 startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:35   startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIndexOf:10   startingAt:8 ifAbsent:['none']
    "
!

lastIndexOfAny:aCollection
    "search the collection backwards for any in aCollection;
     if found, return the index, otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    ^ self lastIndexOfAny:aCollection startingAt:self size

    "
     args:    aCollection    : <collection>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 50 60 70) lastIndexOfAny:#(40 60)
     #(10 20 30 40 50 60 70) lastIndexOfAny:#(40.0 60)
     #(10 20 30 40 50 60 70) lastIndexOfAny:#(35 40)
     #(10 20 30 40 50 60 70) lastIndexOfAny:#(15 35)
    "

    "Modified: / 20.5.1998 / 15:02:10 / cg"
!

lastIndexOfAny:aCollection startingAt:start
    "search the collection backwards for any in aCollection, starting the search at index start;
     if found, return the index, otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"|

    startIndex := start.
    startIndex to:1 by:-1 do:[:index |
	(aCollection includes:(self at:index)) ifTrue:[^ index].
    ].
    ^ 0

    "
     #(10 20 30 40 10 20 30 40) lastIndexOfAny:#(40 60)   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIndexOfAny:#(40 60)   startingAt:7
    "
!

nextIndexOf:anElement from:start to:stop
    "search the collection for anElement, 
     starting the search at index start, stopping at:stop.
     If found, return the index; otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"
     stopIndex  "{ Class: SmallInteger }" |

    startIndex := start.
    stopIndex :=  stop.
    startIndex to:stop do:[:index |
        anElement = (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
              start     : <integer>
              stop      : <integer>

     returns: elementIndex - if found
              nil          - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) nextIndexOf:40   from:2 to:6
     #(10 20 30 40 10 20 30 40) nextIndexOf:40.0 from:2 to:6
     #(10 20 30 40 10 20 30 40) nextIndexOf:35   from:2 to:6
    "

    "Modified: / 23-09-2011 / 14:03:05 / cg"
    "Modified (comment): / 19-11-2016 / 13:04:56 / cg"
!

nextIndexOf:anElement from:start to:stop ifAbsent:exceptionBlock
    "search the collection for anElement, starting the search at index start
     and stopping at stop;
     if found, return the index otherwise return the value of the exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self nextIndexOf:anElement from:start to:stop.
    index == 0 ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
              start          : <integer>
              stop           : <integer>
              exceptionBlock : <valueImplementor>

     returns: elementIndex           - if found
              valueImplementor value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) nextIndexOf:40   from:2 to:6 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) nextIndexOf:40.0 from:2 to:6 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) nextIndexOf:35   from:2 to:6 ifAbsent:['none']
    "

    "Modified: / 23-09-2011 / 14:03:36 / cg"
    "Modified (comment): / 23-05-2012 / 13:29:42 / cg"
!

prevIndexOf:anElement from:startSearchIndex to:endSearchIndex
    "search the collection for anElement, starting the search at index start;
     ending at stop, going in reverse direction.
     If found (within the range), return the index, otherwise return 0.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |startIndex "{ Class: SmallInteger }"
     stopIndex  "{ Class: SmallInteger }" |

    startIndex := startSearchIndex.
    stopIndex := endSearchIndex max:1.
    startIndex to:stopIndex by:-1 do:[:index |
        anElement = (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
              start     : <integer>
              stop      : <integer>

     returns: elementIndex - if found
              nil          - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) prevIndexOf:40   from:7 to:2
     #(10 20 30 40 10 20 30 40) prevIndexOf:40.0 from:7 to:2
     #(10 20 30 40 10 20 30 40) prevIndexOf:35   from:7 to:5
    "

    "Modified: / 23-09-2011 / 14:02:36 / cg"
!

prevIndexOf:anElement from:start to:stop ifAbsent:exceptionBlock
    "search the collection for anElement, starting the search at index start
     and stopping at stop, doing a reverse search;
     if found, return the index otherwise return the value of the
     exceptionBlock.
     The comparison is done using =
     (i.e. equality test - not identity test)."

    |index|

    index := self prevIndexOf:anElement from:start to:stop.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
	      start          : <integer>
	      stop           : <integer>
	      exceptionBlock : <valueImplementor>

     returns: elementIndex           - if found
	      valueImplementor value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) prevIndexOf:40   from:7 to:2 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) prevIndexOf:40.0 from:7 to:2 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) prevIndexOf:35   from:7 to:5 ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 15:13:05 / cg"
! !

!SequenceableCollection methodsFor:'searching-identity'!

identityIndexOf:anElement
    "search the collection for anElement using identity compare (i.e. ==);
     if found, return the index otherwise return 0."

    ^ self identityIndexOf:anElement startingAt:1

    "
     args:    anElement : <object>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 50 60 70) identityIndexOf:40
     #(10 20 30 40 50 60 70) identityIndexOf:40.0
     #(10 20 30 40 50 60 70) indexOf:40.0

    be careful:

     #(10 20 30 40.0 50 60 70) indexOf:40.0
     #(10 20 30 40.0 50 60 70) identityIndexOf:40.0

    "

    "Modified: / 20.5.1998 / 14:57:14 / cg"
!

identityIndexOf:anElement ifAbsent:exceptionBlock
    "search the collection for anElement using identity compare (i.e. ==);
     if found, return the index otherwise return the value of the
     exceptionBlock."

    |index|

    index := self identityIndexOf:anElement startingAt:1.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
	      exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
	      exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 50 60 70) identityIndexOf:40  ifAbsent:['none']
     #(10 20 30 40 50 60 70) identityIndexOf:35  ifAbsent:['none']
     #(10 20 30 40 50 60 70) identityIndexOf:40.0 ifAbsent:['none']
     #(10 20 30 40 50 60 70) indexOf:40.0         ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 14:57:31 / cg"
!

identityIndexOf:anElement or:anotherElement
    "search the collection for anElement and anotherElement using identity compare (i.e. ==);
     if any is found, return the index otherwise return 0."

    ^ self identityIndexOf:anElement or:anotherElement startingAt:1

    "
     args:    anElement : <object>
	      anotherElement : <object>

     returns: elementIndex - if found
	      0            - if not found
    "
!

identityIndexOf:anElement or:anotherElement startingAt:start
    "search the collection for anElement and anotherElement, starting search at index start
     using identity compare  (i.e. ==);
     if any is found, return the index otherwise return 0."

    |startIndex "{ Class: SmallInteger }"
     stop       "{ Class: SmallInteger }"
     el |

    startIndex := start.
    stop := self size.
    startIndex to:stop do:[:index |
	el := self at:index.
	anElement == el ifTrue:[^ index].
	anotherElement == el ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
	      anotherElement : <object>
	      start     : <integer>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) identityIndexOf:40 or:30  startingAt:2
    "
!

identityIndexOf:anElement startingAt:start
    "search the collection for anElement, starting search at index start
     using identity compare  (i.e. ==);
     if found, return the index otherwise return 0."

    |startIndex "{ Class: SmallInteger }"
     stop       "{ Class: SmallInteger }" |

    startIndex := start.
    stop := self size.
    startIndex to:stop do:[:index |
	anElement == (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
	      start     : <integer>

     returns: elementIndex - if found
	      0            - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) identityIndexOf:40   startingAt:5
     #(10 20 30 40 10 20 30 40) identityIndexOf:40.0 startingAt:5
     #(10 20 30 40 10 20 30 40) indexOf:40.0         startingAt:5
    "

    "Modified: / 20.5.1998 / 14:57:09 / cg"
!

identityIndexOf:anElement startingAt:start endingAt:stop
    "search the collection for anElement, starting the search at index start;
     ending at stop.
     If found (within the range), return the index, otherwise return 0.
     The comparison is done using ==
     (i.e. identity test - not equality test)."

    |startIndex "{ Class: SmallInteger }"
     stopIndex  "{ Class: SmallInteger }" |

    startIndex := start.
    stopIndex := self size min:stop.
    startIndex to:stopIndex do:[:index |
        anElement == (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement : <object>
              start     : <integer>
              stop      : <integer>

     returns: elementIndex - if found
              0            - if not found
    "

    "Created: / 12-04-1996 / 18:23:07 / cg"
    "Modified: / 20-05-1998 / 15:00:50 / cg"
    "Modified (comment): / 23-05-2012 / 13:28:21 / cg"
!

identityIndexOf:anElement startingAt:start ifAbsent:exceptionBlock
    "search the collection for anElement, starting search at index start;
     if found, return the index otherwise return the value of the
     exceptionBlock.
     This one searches for identical objects (i.e. ==)."

    |index|

    index := self identityIndexOf:anElement startingAt:start.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
	      start          : <integer>
	      exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
	      exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10) identityIndexOf:10 startingAt:3 ifAbsent:['none']
     #(10 20 30 40 10) identityIndexOf:35 startingAt:3 ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 15:01:23 / cg"
!

includesIdentical:anElement
    "return true if the collection contains anElement; false otherwise.
     Comparison is done using identity compare (i.e. ==).
     See #includes: if equality is asked for."

    ^ (self identityIndexOf:anElement startingAt:1) ~~ 0

    "
     args:    anElement : <object>

     returns: true  - if found
              false - if not found
    "

    "
     #(10 20 30 40 50 60 70) includesIdentical:40
     #(10 20 30 40 50 60 70) includesIdentical:40.0
     #(10 20 30 40 50 60 70) includes:40
     #(10 20 30 40 50 60 70) includes:40.0

     be careful:

     #(10 20 30 40.0 50 60 70) includes:40.0
     #(10 20 30 40.0 50 60 70) includesIdentical:40.0
    "

    "Modified: / 20.5.1998 / 15:00:16 / cg"
!

lastIdentityIndexOf:anElement
    "search the collection backwards for anElement;
     if found, return the index, otherwise return 0.
     The comparison is done using ==
     (i.e. identity test - not equality test)."

    ^ self lastIdentityIndexOf:anElement startingAt:self size

    "
     args:    anElement      : <object>

     returns: elementIndex - if found
              0            - if not found
    "

    "
     #(10 20 30 40 50 60 70) lastIdentityIndexOf:40
     #(10 20 30 40 50 60 70) lastIdentityIndexOf:40.0
     #(10 20 30 40 50 60 70) lastIdentityIndexOf:35
     #(10 20 30 40 50 60 70) lastIdentityIndexOf:10
    "

    "Created: / 20.5.1998 / 15:03:06 / cg"
!

lastIdentityIndexOf:anElement ifAbsent:exceptionBlock
    "search the collection backwards for anElement;
     if found, return the index, 
     otherwise return the value of the exceptionBlock.
     The comparison is done using ==
     (i.e. identity test - not equality test)."

    |index|

    index := self lastIdentityIndexOf:anElement startingAt:self size.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
              exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
              exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40   ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40.0 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:35   ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:10   ifAbsent:['none']
    "

    "Created: / 20.5.1998 / 15:04:46 / cg"
    "Modified: / 20.5.1998 / 15:05:53 / cg"
!

lastIdentityIndexOf:anElement startingAt:start
    "search the collection backwards for anElement, starting the search at index start;
     if found, return the index, otherwise return 0.
     The comparison is done using ==
     (i.e. identity test - not equality test)."

    |startIndex "{ Class: SmallInteger }"|

    startIndex := start.
    startIndex to:1 by:-1 do:[:index |
        anElement == (self at:index) ifTrue:[^ index].
    ].
    ^ 0

    "
     args:    anElement      : <object>
              start          : <integer>

     returns: elementIndex - if found
              0            - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40.0 startingAt:8
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:35   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:10   startingAt:8
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:10   startingAt:4
    "

    "Modified: / 20.5.1998 / 15:06:04 / cg"
!

lastIdentityIndexOf:anElement startingAt:start ifAbsent:exceptionBlock
    "search the collection backwards for anElement starting the search at
     index start; if found, return the index
     otherwise return the value of the exceptionBlock.
     The comparison is done using ==
     (i.e. identity test - not equality test)."

    |index|

    index := self lastIdentityIndexOf:anElement startingAt:start.
    (index == 0) ifTrue:[^ exceptionBlock value].
    ^ index

    "
     args:    anElement      : <object>
	      start          : <integer>
	      exceptionBlock : <valueImplementor>

     returns: elementIndex         - if found
	      exceptionBlock value - if not found
    "

    "
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40   startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:40.0 startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:35   startingAt:8 ifAbsent:['none']
     #(10 20 30 40 10 20 30 40) lastIdentityIndexOf:10   startingAt:8 ifAbsent:['none']
    "

    "Modified: / 20.5.1998 / 15:06:21 / cg"
    "Created: / 20.5.1998 / 15:07:42 / cg"
! !

!SequenceableCollection methodsFor:'sorting & reordering'!

detectFirstInOrder:sortBlock
    "find the first element of the collection sorted with sortBlock"

    |selectedForNow start|

    start := true.
    self do:[:element|
	start ifTrue:[
	    start := false.
	    selectedForNow := element.
	] ifFalse:[
	    (sortBlock value:element value:selectedForNow) ifTrue:[
		selectedForNow := element.
	    ].
	].
    ].

    ^ selectedForNow

    "
     #(1 16 7 98 3 19 4 0) detectFirstInOrder:[:a :b | a < b]
     #(1 16 7 98 3 19 4 0) detectFirstInOrder:[:a :b | a > b]
     #(1 -1 16 -16 7 -7 98 -98) detectFirstInOrder:[:a :b | a < b]
     #(1 -1 16 -16 7 -7 98 -98) detectFirstInOrder:[:a :b | a abs < b abs]
    "
!

randomShuffle
    "random shuffle my elements in place.
     This is a destructive algorithm.
     Moses, Oakford, Durstenfeld, Knuth algorithm.
     See 'The Art of Computer Programming'."

    self size to:2 by:-1 do:[:endIndex |
        |rndIndex t|

        rndIndex := Random nextIntegerBetween:1 and:endIndex.
        "/ exchange
        t := self at:rndIndex.
        self at:rndIndex put:(self at:endIndex).
        self at:endIndex put:t.
    ].

    "
     (1 to:10) asOrderedCollection randomShuffle

     |c| c := (1 to:100) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
     |c| c := (1 to:1000) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
     |c| c := (1 to:10000) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
     |c| c := (1 to:100000) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
     |c| c := (1 to:1000000) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
     |c| c := (1 to:10000000) asOrderedCollection . TimeDuration toRun:[ c randomShuffle ] 
    "

    "how random are we ? (should all be around 1000000/24.0 i.e. 41666.6):

     |a score|

     a := 'abcd'.
     score := DictionaryWithDefault newWithDefaultValue:0.

     1000000 times do:[
         |sorted|
         sorted := a copy randomShuffle.
         score at:sorted put:(score at:sorted)+1.
     ].

     score keys asSortedCollection do:[:k |
         Transcript showCR:('%1: %2' bindWith:k with:(score at:k)).
     ].
    "

    "Modified: / 22-10-2008 / 15:37:48 / cg"
!

removeAndAddFirst:anElement
    "if the anElement is in the receiver collection, remove it (compare by equality);
     then add it to the beginning.
     Effectively moving the element to the beginning if it is already present,
     or adding it to the beginning if not already there"
     
    self remove:anElement ifAbsent:[].
    self addFirst:anElement.
!

removeAndAddLast:anElement
    "if the anElement is in the receiver collection, remove it (compare by equality);
     then add it to the end.
     Effectively moving the element to the end if it is already present,
     or adding it to the end if not already there"
     
    self remove:anElement ifAbsent:[].
    self addLast:anElement.
!

reverse
    "destructively reverse the order of the elements inplace.
     WARNING: this is a destructive operation, which modifies the receiver.
              Please use reversed (with a d) for a functional version."

    |lowIndex "{ Class: SmallInteger }"
     hiIndex  "{ Class: SmallInteger }"
     t1 t2|

    hiIndex := self size.
    lowIndex := 1.
    [lowIndex < hiIndex] whileTrue:[
        t1 := self at:lowIndex.  t2 := self at:hiIndex.
        self at:lowIndex put:t2.  self at:hiIndex put:t1.

        lowIndex := lowIndex + 1.
        hiIndex := hiIndex - 1
    ]

    "
     #(4 5 6 7 7) reverse
     #(1 4 7 10 2 5) asOrderedCollection reverse
    "
!

reversed
    "return a copy with elements in reverse order"

    ^ (self copyFrom:1) reverse

    "
     #(4 5 6 7 7) reversed    
     #(1 4 7 10 2 5) asOrderedCollection reversed
     #foo reversed 
    "
!

sort
    "sort the collection inplace. The elements are compared using
     '<' i.e. they should offer a magnitude-like protocol.
     WARNING: this is a destructive operation, which modifies the receiver.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior)."

    self quickSort

    "
     #(1 16 7 98 3 19 4 0) sort

     |data|
     data := Random new next:100000.
     Transcript show:'sort random  '; showCR:(Time millisecondsToRun:[data sort]).
     Transcript show:'sort sorted  '; showCR:(Time millisecondsToRun:[data sort]).
     data reverse.
     Transcript show:'sort reverse '; showCR:(Time millisecondsToRun:[data sort]).
    "

    "Modified: 21.8.1997 / 18:31:52 / cg"
!

sort:sortBlock
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. This allows any sort criteria to be implemented.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior)."

    self quickSort:sortBlock

    "
     #(1 16 7 98 3 19 4 0) sort:[:a :b | a < b]
     #(1 16 7 98 3 19 4 0) sort:[:a :b | a > b]
     #(1 -1 16 -16 7 -7 98 -98) sort:[:a :b | a < b]
     #(1 -1 16 -16 7 -7 98 -98) sort:[:a :b | a abs < b abs]
    "

    "Modified: / 27.10.1997 / 20:03:22 / cg"
!

sort:sortBlock with:aCollection
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. Also reorder the elements in aCollection.
     Use this, when you have a key collection to sort some other collection with.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior)."

    self quickSort:sortBlock with:aCollection

    "
     |c1 c2|
     c1 := #(1 16 7 9).
     c2 := #('one' 'sixteen' 'seven' 'nine').
     c1 sort:[:a :b | a > b] with:c2.
     c1 printNL.
     c2 printNL
    "

    "Modified: 21.8.1997 / 18:32:11 / cg"
!

sortByApplying:aBlock
    "Sort my contents inplace based on the value of what aBlock returns for each element.
     Similar to, but even more flexible than sortBySelector."

    ^ self sort:[:a :b | (aBlock value:a) < (aBlock value:b)]

    "
     replace all uses of sort as in:
        ... sort:[:a :b | a foo < b foo]
     by:
        ... sortByApplying:[:each | each foo]
    "
!

sortBySelector:aSelector
    "Sort my contents inplace based on the value of what aSelector returns when sent to my
     elements. Sorting by a selector is so common, that its worth a separate utility"

    ^ self sort:[:a :b | (a perform:aSelector) < (b perform:aSelector)]

    "
     replace all uses of sort as in:
        ... sort:[:a :b | a foo < b foo]
     by:
        ... sortBySelector:#foo

     find these by searching for code matching (code-search in the browsers method list):
        `@e sort:[:a :b | a `@msg < b `@msg ]
    "
!

sortWith:aCollection
    "sort the receiver collection inplace, using '<' to compare elements.
     Also, the elements of aCollection are reordered with it.
     Use this, when you have a key collection to sort another collection with.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior)."

    self quickSortWith:aCollection

    "
     |indices names|

     names := #('nine' 'five' 'eight' 'one' 'four' 'two') copy.
     indices := #(9 5 8 1 4 2) copy.
     indices sortWith:names.
     names.
     indices     
    "

    "Modified (comment): / 18-01-2012 / 11:30:01 / cg"
!

stableSort
    "sort the collection inplace. The elements are compared using
     '<=' i.e. they should offer a magnitude-like protocol.

     Use a stable sort algorithm - i.e. elements having an equal key will keep
     their previous order."

    self mergeSort

    "
     #(1 16 7 98 3 19 4 0) stableSort

     |data|
     data := Random new next:100000.
     Transcript show:'sort random  '; showCR:(Time millisecondsToRun:[data stableSort]).
     Transcript show:'sort sorted  '; showCR:(Time millisecondsToRun:[data stableSort]).
     data reverse.
     Transcript show:'sort reverse '; showCR:(Time millisecondsToRun:[data stableSort]).
    "
!

stableSort:sortBlock
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. This allows any sort criteria to be implemented.

     Use a stable sort algorithm - i.e. elements having an equal key will keep
     their previous order.

     NOTE: the sort algorithm will be stable, if the sortblock uses #< or #> for comparison!!
           Do not use #<= of #>= if you want stable behavior."

    self mergeSort:sortBlock

    "
     The 4@bla points keep their order:
         {(4@1). (8@2). (4@2). (3@3). (4@3). (-1@4). (17@17). (19@19).
          (12 @ 12). (13@13). (14@14). (15@15). (10@10). (8@8).} stableSort:[:a :b | a x < b x]
        
     But not with quickSort:
         {(4@1). (8@2). (4@2). (3@3). (4@3). (-1@4). (17@17). (19@19).
          (12 @ 12). (13@13). (14@14). (15@15). (10@10). (8@8).} sort:[:a :b | a x < b x]
    "
!

topologicalSort:sortBlock
    "sort the collection inplace using a sloooow sort algorithm.
     This algorithm has O-square runtime behavior and should be used only
     in special situations.
     It compares all elements, thus can be used when a>b, b>c does NOT imply
     a>c (for example, to sort classes by inheritance)

     In all other situations, use #sort; which implements the quicksort algorithm.

     If there are cycles, this algorithm may loop endless!!   
     Note: consider using Collection>>#topologicalSort, which is faster and does not do endless loop.
    "

    |smallestIndex "{ Class: SmallInteger }"
     end           "{ Class: SmallInteger }"
     index2        "{ Class: SmallInteger }"
     smallest thisOne|

    "this is just a q&d hack - there must be better implementations for this ;-)"

    end := self size.
    1 to:end-1 do:[:index |
        smallest := self at:index.
        smallestIndex := index.

        index2 := index + 1.
        [
            thisOne := self at:index2.
            (index2 ~~ smallestIndex
            and:[sortBlock value:thisOne value:smallest]) ifTrue:[
                smallestIndex := index2.
                smallest := thisOne.
                index2 := index + 1.
            ] ifFalse:[
                index2 := index2 + 1.
            ].
        ] doWhile:[index2 <= end].

"/        (index + 1) to:end do:[:index2 |
"/            thisOne := self at:index2.
"/            (sortBlock value:thisOne value:smallest) ifTrue:[
"/                smallestIndex := index2.
"/                smallest := thisOne
"/            ].
"/        ].

        (smallestIndex ~~ index) ifTrue:[
            thisOne := self at:index.
            self at:index put:smallest.
            self at:smallestIndex put:thisOne
        ].
    ]

    "
     #(1 16 7 98 3 19 4 0) topologicalSort:[:a :b | a < b]
     #(1 16 7 98 3 19 4 0) sort:[:a :b | a < b]
     Smalltalk allClasses asArray topologicalSort:[:a :b | a == b superclass]
     Smalltalk allClasses asArray topologicalSort:[:a :b | b isSubclassOf:a]
     Smalltalk allClasses asArray sort:[:a :b | b isSubclassOf:a]
    "

    "Modified: 21.8.1997 / 18:30:49 / cg"
! !

!SequenceableCollection methodsFor:'sorting algorithms'!

heapSort
    "sort the collection inplace. The elements are compared using
     '<' i.e. they should offer a magnitude-like protocol.

     Heap sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the heapsort algorithm, which has a complexity
     of O(n*log(n)) for both average and worst case."

    self heapSortFrom:1 to:self size

    "
     'franz jagt im komplett verwahrlosten taxi quer durch deutschland' copy heapSort
     #( 1 2 3 4 5 6 7 8 9) heapSort
     #( 1 2 3 4 5 6 7 8 9) reversed heapSort

     |data|
     data := Random new next:500000.
     Transcript show:'heap random  '; showCR:(Time millisecondsToRun:[data heapSort]).
     data inject:0 into:[:lastElement :each | lastElement > each ifTrue:[self halt]. each].
     Transcript show:'heap sorted  '; showCR:(Time millisecondsToRun:[data heapSort]).
     data inject:0 into:[:lastElement :each | lastElement > each ifTrue:[self halt]. each].
     data reverse.
     Transcript show:'heap reverse '; showCR:(Time millisecondsToRun:[data heapSort]).
     data inject:0 into:[:lastElement :each | lastElement > each ifTrue:[self halt]. each].
    "
!

heapSort:sortBlock
    "sort the collection inplace. The elements are compared using
     sortBlock.

     Heap sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the heapsort algorithm, which has a complexity
     of O(n*log(n)) for both average and worst case."

    self heapSort:sortBlock from:1 to:self size
!

heapSort:sortBlock from:begin to:end
    "sort the collection inplace. The elements are compared using
     the sortBlock.

     Heap sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the heapsort algorithm, which has a complexity
     of O(n*log(n)) for average and worst case."

    |cRun  "{Class: SmallInteger}"
     parent     "{Class: SmallInteger}"
     child      "{Class: SmallInteger}"
     eRun       "{Class: SmallInteger}"
     childE childERight temp done size|

    eRun := end.
    size := eRun+1-begin.
    size <= 1 ifTrue:[
        ^ self.
    ].

    cRun := size // 2 + 1.                      "position of the last parent node"

    [
        cRun > begin ifTrue:[               "Phase 1: do the heap creation"
            cRun := cRun - 1.
            temp := self at:cRun.           "parent value is in temp"
        ] ifFalse:[                             "Phase 2: heap selection"
            temp := self at:eRun.               "save the last value on the heap"
            self at:eRun put:(self at:begin).   "put the largest value so far to the end of the heap"
            eRun := eRun - 1.                   "make new heap smaller"
            eRun == begin ifTrue:[
                "the heap is empty - we are done"
                self at:begin put:temp.
                ^ self.
            ].
        ].

        parent := cRun.
        child := parent * 2.                    "parents left child"

        "Sift operation - push temp down the heap"
        done := false.
        [done not and:[child <= eRun]] whileTrue:[
            childE := self at:child.
            "choose the largest child"
            (child < eRun and:[sortBlock value:childE value:(childERight := self at:child+1)]) ifTrue:[
                child := child + 1.             "the right child is larger"
                childE := childERight.
            ].
            (sortBlock value:temp value:childE) ifTrue:[
                self at:parent put:childE.      "move the largest child up"
                parent := child.                "make child the new parent"
                child := parent * 2.            "get next child"
            ] ifFalse:[
                done := true.                   "now we know where to put temp"
            ].
        ].
        self at:parent put:temp.                "save temp in heap"    
    ] loop.
!

heapSortFrom:begin to:end
    "sort the collection inplace. The elements are compared using
     '<' i.e. they should offer a magnitude-like protocol.

     Heap sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the heapsort algorithm, which has a complexity
     of O(n*log(n)) for average and worst case."

    |cRun  "{Class: SmallInteger}"
     parent     "{Class: SmallInteger}"
     child      "{Class: SmallInteger}"
     eRun       "{Class: SmallInteger}"
     childE childERight temp done size|

    eRun := end.
    size := eRun+1-begin.
    size <= 1 ifTrue:[
        ^ self.
    ].

    cRun := size // 2 + 1.                      "position of the last parent node"

    [
        cRun > begin ifTrue:[               "Phase 1: do the heap creation"
            cRun := cRun - 1.
            temp := self at:cRun.           "parent value is in temp"
        ] ifFalse:[                             "Phase 2: heap selection"
            temp := self at:eRun.               "save the last value on the heap"
            self at:eRun put:(self at:begin).   "put the largest value so far to the end of the heap"
            eRun := eRun - 1.                   "make new heap smaller"
            eRun == begin ifTrue:[
                "the heap is empty - we are done"
                self at:begin put:temp.
                ^ self.
            ].
        ].

        parent := cRun.
        child := parent * 2.                    "parents left child"

        "Sift operation - push temp down the heap"
        done := false.
        [done not and:[child <= eRun]] whileTrue:[
            childE := self at:child.
            "choose the largest child"
            (child < eRun and:[childE < (childERight := self at:child+1)]) ifTrue:[
                child := child + 1.             "the right child is larger"
                childE := childERight.
            ].
            temp < childE ifTrue:[
                self at:parent put:childE.      "move the largest child up"
                parent := child.                "make child the new parent"
                child := parent * 2.            "get next child"
            ] ifFalse:[
                done := true.                   "now we know where to put temp"
            ].
        ].
        self at:parent put:temp.                "save temp in heap"    
    ] loop.


    "
     'franz jagt im komplett verwahrlosten taxi quer durch deutschland' copy heapSort
     #( 1 2 3 4 5 6 7 8 9) copy heapSort
     #( 1 2 3 4 5 6 7 8 9) reversed heapSort

     |data|
     data := Random new next:500000.
     Transcript show:'heap random  '; showCR:(Time millisecondsToRun:[data heapSortFrom:1 to:data size]).
     Transcript show:'heap sorted  '; showCR:(Time millisecondsToRun:[data heapSortFrom:1 to:data size]).
     data reverse.
     Transcript show:'heap reverse '; showCR:(Time millisecondsToRun:[data heapSortFrom:1 to:data size]).
    "
!

insertionSort
    "sort the collection using a insertionSort algorithm.
     The elements are compared using'#<'
     i.e. they should offer a magnitude-like protocol.

     Insertion sort sort is a stable sorting algorithm, i.e. elements with the same sort key
     keep their order (if you use e.g. #<) for comparison.

     The implementation uses the insertionSort algorithm, 
     which is slow for large collections O(n*n), but good for small or
     almost sorted collections O(N).

     See also #quickSort for other sort algorithms
     with different worst- and average case behavior)"

    self insertionSort:[:a :b | a < b]
!

insertionSort:sortBlock
    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        self insertionSort:sortBlock from:1 to:stop
    ].
!

insertionSort:sortBlock from:inBegin to:inEnd
    "binary insertion sort.
     The implementation uses the insertionSort algorithm, 
     which is slow for large collections O(n*n), but good for small or
     almost sorted collections O(N)."

    |begin      "{Class: SmallInteger}"
     end        "{Class: SmallInteger}"
     prevIdx    "{Class: SmallInteger}"
     temp|

    begin := inBegin+1.
    end := inEnd.
    begin to:end do:[:idx|
        temp := self at:idx.
        prevIdx := idx-1.
        "this is stable if #< or #> ist used for comparison (and not #<= or #>=)"
        [prevIdx >= inBegin and:[sortBlock value:temp value:(self at:prevIdx)]] whileTrue:[
            self at:prevIdx+1 put:(self at:prevIdx).
            prevIdx := prevIdx - 1.
        ].
        (prevIdx+1) ~~ idx ifTrue:[
            self at:prevIdx+1 put:temp.
        ].
    ].

    "
     |data|
     data := Random new next:1000.
     Transcript show:'merge random  '; showCR:(Time millisecondsToRun:[data mergeSort]).
     Transcript show:'merge sorted  '; showCR:(Time millisecondsToRun:[data mergeSort]).
     data reverse.
     Transcript show:'merge reverse '; showCR:(Time millisecondsToRun:[data mergeSort]).

     data := Random new next:1000.
     Transcript show:'insert random  '; showCR:(Time millisecondsToRun:[data insertionSort]).
     Transcript show:'insert sorted  '; showCR:(Time millisecondsToRun:[data insertionSort]).
     data reverse.
     Transcript show:'insert reverse '; showCR:(Time millisecondsToRun:[data insertionSort]).
    "
!

mergeSort
    "sort the collection using a mergeSort algorithm.
     The elements are compared using '#<'
     i.e. they should offer a magnitude-like protocol.

     Merge sort is a stable sorting algorithm, i.e. elements with the same sort key
     keep their order.

     The implementation uses the mergesort algorithm, which may not be
     the best possible for all situations
     See also #quickSort for other sort algorithms
     with different worst- and average case behavior)"

    self mergeSort:[:a :b | a < b]

    "
     #(1 16 7 98 3 19 4 0) mergeSort
     #(1 16 7 98 7 3 19 4 0) mergeSort 

     |random data|

     random := Random new next:500000.

     data := random copy.
     Transcript show:'merge random  '; showCR:(Time millisecondsToRun:[data mergeSort]).
     Transcript show:'merge sorted  '; showCR:(Time millisecondsToRun:[data mergeSort]).
     data := data reverse.
     Transcript show:'merge reverse '; showCR:(Time millisecondsToRun:[data mergeSort]).

     data := random copy.
     Transcript show:'quick block random  '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a < b]]).
     Transcript show:'quick block sorted  '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a < b]]).
     data := data reverse.
     Transcript show:'quick block reverse '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a < b]]).

     data := random copy.
     Transcript show:'quick random  '; showCR:(Time millisecondsToRun:[data quickSort]).
     Transcript show:'quick sorted  '; showCR:(Time millisecondsToRun:[data quickSort]).
     data := data reverse.
     Transcript show:'quick reverse '; showCR:(Time millisecondsToRun:[data quickSort]).
    "
!

mergeSort:sortBlock
    "sort the collection using a mergeSort algorithm.
     The elements are compared using sortBlock
     i.e. they should offer a magnitude-like protocol.

     Merge sort is a stable sorting algorithm, i.e. elements with the same sort key
     keep their order (if you use e.g. #< for comparison).

     The implementation uses the mergesort algorithm, which may not be
     the best possible for all situations
     See also #quickSort for other sort algorithms
     with different worst- and average case behavior)"

    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        self mergeSort:sortBlock from:1 to:stop
    ].

    "
     |random data|

     random := Random new next:500000.

     data := random copy.
     Transcript show:'merge block random  '; showCR:(Time millisecondsToRun:[data mergeSort:[:a :b| a <= b]]).
     Transcript show:'merge block sorted  '; showCR:(Time millisecondsToRun:[data mergeSort:[:a :b| a <= b]]).
     data := data reverse.
     Transcript show:'merge block reverse '; showCR:(Time millisecondsToRun:[data mergeSort:[:a :b| a <= b]]).

     data := random copy.
     Transcript show:'quick block random  '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a <= b]]).
     Transcript show:'quick block sorted  '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a <= b]]).
     data := data reverse.
     Transcript show:'quick block reverse '; showCR:(Time millisecondsToRun:[data quickSort:[:a :b| a <= b]]).
   "
!

mergeSort:aBlock from:startIndex to:stopIndex 
    "Sort the given range of indices using the mergesort algorithm.
     Mergesort is a worst-case O(N log N) sorting algorithm that usually does only half
     as many comparisons as heapsort or quicksort.

     Merge sort is a stable sorting algorithm, i.e. elements with the same sort key
     keep their order (if you use e.g. #< or #> for comparison)."

    "Details: recursively split the range to be sorted into two halves,
     mergesort each half, then merge the two halves together.
     An extra copy of the data is used as temporary storage and successive merge phases copy data back
     and forth between the receiver and this copy.
     The recursion is set up so that the final merge is performed into the receiver,
     resulting in the receiver being completely sorted."
    
    |mySize|

    mySize := self size.
    mySize <= 1 ifTrue:[
        ^ self
    ].
    startIndex = stopIndex ifTrue:[
        ^ self
    ].
    (startIndex >= 1 and:[ startIndex < stopIndex ]) ifFalse:[
        self error:'bad start index'
    ].
    stopIndex > mySize ifTrue:[
        self error:'bad stop index'
    ].
    self
        mergeSortFrom:startIndex
        to:stopIndex
        by:aBlock.
!

quickSort
    "sort the collection inplace. The elements are compared using
     '<' i.e. they should offer a magnitude-like protocol.

     Quick sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior). See also #randomizedSort for a version with better
     worstCase behavior (but worse average & bestCase behavior)"

    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        self quickSortFrom:1 to:stop
    ]

    "
     #(1 16 7 98 3 19 4 0) sort

     |data|
     data := Random new next:500001.
     Transcript show:'quick random  '; showCR:(Time millisecondsToRun:[data quickSort]).
     data inject:0 into:[:lastElement :each | lastElement > each ifTrue:[self halt]. each].
     Transcript show:'quick sorted  '; showCR:(Time millisecondsToRun:[data quickSort]).
     data reverse.
     Transcript show:'quick reverse '; showCR:(Time millisecondsToRun:[data quickSort]).

     |data rg|  
     rg := Random new.
     data := Array new:500001.
     1 to:data size do:[:i |
        data at:i put:(rg nextIntegerBetween:1 and:100).
     ].
     Transcript show:'quick random  '; showCR:(Time millisecondsToRun:[data quickSort]).
     data inject:0 into:[:lastElement :each | lastElement > each ifTrue:[self halt]. each].
     Transcript show:'quick sorted  '; showCR:(Time millisecondsToRun:[data quickSort]).
     data reverse.
     Transcript show:'quick reverse '; showCR:(Time millisecondsToRun:[data quickSort]).
    "

    "Modified: 21.8.1997 / 18:31:52 / cg"
!

quickSort:sortBlock
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. This allows any sort criteria to be implemented.

     Quick sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior). See also #randomizedSort: for a version with better
     worstCase behavior (but worse average & bestCase behavior)"

    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        sortBlock numArgs == 3 ifTrue:[
            "/ TODO: pass a collating policy to aBlock
            self quickSortFrom:1 to:stop sortBlock:sortBlock policy:(StringCollationPolicy new)
        ] ifFalse:[
            self quickSortFrom:1 to:stop sortBlock:sortBlock
        ]
    ]

    "
     #(1 16 7 98 3 19 4 0) sort:[:a :b | a < b]
     #(1 16 7 98 3 19 4 0) sort:[:a :b | a > b]
     #(1 -1 16 -16 7 -7 98 -98) sort:[:a :b | a < b]
     #(1 -1 16 -16 7 -7 98 -98) sort:[:a :b | a abs < b abs]
    "

    "Modified: / 27.10.1997 / 20:03:22 / cg"
!

quickSort:sortBlock with:aCollection
    "sort the collection inplace using the 2-arg block sortBlock
     for comparison. Also reorder the elements in aCollection.
     Use this, when you have a key collection to sort some other collection with.

     Quick sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior). See also #randomizedSort: for a version with better
     worstCase behavior (but worse average & bestCase behavior)"

    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        self quickSortFrom:1 to:stop sortBlock:sortBlock with:aCollection
    ]

    "
     |c1 c2|
     c1 := #(1 16 7 9).
     c2 := #('one' 'sixteen' 'seven' 'nine').
     c1 sort:[:a :b | a > b] with:c2.
     Transcript showCR:c1; showCR:c2.
    "

    "Modified: 21.8.1997 / 18:32:11 / cg"
!

quickSortWith:aCollection
    "sort the receiver collection inplace, using '<' to compare elements.
     Also, the elements of aCollection are reordered with it.
     Use this, when you have a key collection to sort another collection with.

     Quick sort is an unstable sorting algorithm, i.e. elements with the same sort key
     don't keep their order.

     The implementation uses the quicksort algorithm, which may not be
     the best possible for all situations (quickSort has O-square worst
     case behavior)."

    |stop|

    stop := self size.
    (stop > 1) ifTrue:[
        self quickSortFrom:1 to:stop with:aCollection
    ]

    "Modified: 21.8.1997 / 18:32:21 / cg"
!

sortSmallSized
    "for small sizes, specialized sorts with minimum number
     of comparisons are used.
     This is mostly useful if many small collections are to be sorted."

    |n e1 e2 e3 e4 t middle1 middle2|

    n := self size.
    n <= 1 ifTrue:[
        ^ self
    ].

    e1 := self at:1.
    e2 := self at:2.

    n == 2 ifTrue:[
        e2 < e1 ifTrue:[
            self at:1 put:e2.
            self at:2 put:e1.
        ].
        ^ self.
    ].

    e3 := self at:3.
    n == 3 ifTrue:[
        e2 < e1 ifFalse:[
            e3 < e2 ifTrue:[
                e1 < e3 ifFalse:[
                    self at:1 put:e3.
                    self at:2 put:e1.
                ] ifTrue:[
                    self at:1 put:e1.
                    self at:2 put:e3.
                ].
                self at:3 put:e2.
            ].
            ^ self.
        ].
        e3 < e1 ifTrue:[
            e2 < e3 ifTrue:[
                self at:1 put:e2.
                self at:2 put:e3.
            ] ifFalse:[
                self at:1 put:e3.
            ].
            self at:3 put:e1.
            ^ self.
        ].
        self at:1 put:e2.
        self at:2 put:e1.
        ^ self.
    ].

    e4 := self at:4.
    n == 4 ifTrue:[
        e1 < e2 ifFalse:[
            t := e1.
            e1 := e2.
            e2 := t.
        ].
        e3 < e4 ifFalse:[
            t := e3.
            e3 := e4.
            e4 := t.
        ].
        e1 < e3 ifTrue:[ 
            middle1 := e3.
        ] ifFalse:[
            t := e1.
            e1 := e3.
            middle1 := t.
        ].
        e4 < e2 ifTrue:[
            t := e4.
            e4 := e2.
            middle2 := t.
        ] ifFalse:[
            middle2 := e2.
        ].
        self at:1 put:e1.
        middle1 < middle2 ifTrue:[
            self at:2 put:middle1.
            self at:3 put:middle2.
        ] ifFalse:[
            self at:2 put:middle2.
            self at:3 put:middle1.
        ].
        self at:4 put:e4.
        ^ self.
    ].

    self quickSortFrom:1 to:n

    "
     self assert: {1 . 2} sortSmallSized      = #(1 2)  
     self assert: {2 . 1} sortSmallSized      = #(1 2) 
     self assert: {1 . 1.0} sortSmallSized    = #(1 1.0) 
     self assert: {1.0 . 1} sortSmallSized    = #(1.0 1) 

     #( 1 2 3) permutationsDo:[:p |
        self assert: p copy sortSmallSized    = #(1 2 3) 
     ].
     #( 1 2 3 4) permutationsDo:[:p |
        self assert: p copy sortSmallSized    = #(1 2 3 4) 
     ].
    "

    "
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 } quickSort   
        ]
     ].   
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 } sortSmallSized   
        ]
     ].   

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 . 3} quickSort   
        ]
     ].   
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 . 3} sortSmallSized   
        ]
     ].   

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 . 3 . 4} quickSort   
        ]
     ].   
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            { 1 . 2 . 3 . 4} sortSmallSized   
        ]
     ].   
    "
! !

!SequenceableCollection methodsFor:'testing'!

includesKey:anIndex
    "return true, if anIndex is a valid key.
     NOTICE: in ST-80, this message is only defined for Dictionaries,
	     however, having a common protocol with indexed collections
	     often simplifies things."

    anIndex isInteger ifFalse:[^ false].
    ^ (anIndex >= 1) and:[anIndex <= self size]

    "
     #(1 2 3) includesKey:4
     #(1 2 3) includesKey:3
    "
! !

!SequenceableCollection methodsFor:'vector arithmetic'!

dot:aFloatVector
    "Return the dot product of the receiver and the argument.
     Raises an error, if the argument is not of the same size as the receiver."

    |mySize result|

    mySize := self size.
    mySize = aFloatVector size ifFalse:[
        ^ self error:'Must be of equal size'
    ].
    result := 0.0.
    1 to: mySize do:[:i|
        result := result + ((self at: i) * (aFloatVector at: i)).
    ].
    ^result

    "
     |v|
     v := #(2.0 2.0 1.0).
     v dot:v.            

     |v|
     v := #(2.0 2.0 1.0) asDoubleArray.
     v dot:v.            
    "
!

hornerMultiplyAndAdd:x
    "fallback for horner's-method computation of polynomials.
     The vector is interpreted as providing the factors for a polynomial,
        an*x^n + (an-1)*x^(n-1) + ... + a2(x) + a1
     where the ai are the elements of the Array.
     The highest rank factor is at the first position, the 0-rank constant at last."

    |mySize result|

    mySize := self size.
    result := self at:1.
    2 to: mySize do:[:i|
        result := (result * x) + (self at: i).
    ].
    ^ result

    "
     |v|
     'compute 2*10^2 + 3*10 + 4'.
     v := #(2 3 4).
     v hornerMultiplyAndAdd:10.            

     |v|
     'compute 2*10^2 + 3*10 + 4'.
     v := #(2 3 4) asFloatArray.
     v hornerMultiplyAndAdd:10.            

     |v|
     'compute 2*10^2 + 3*10 + 4'.
     v := #(2 3 4) asDoubleArray.
     v hornerMultiplyAndAdd:10.            
    "
!

squaredVectorLength
    "Return the squared length of the receiver interpreted as vector.
     Some algorithms get along without the square root, and run faster."

    ^ self dot: self

    "
     #(10.0 10.0 10.0) vectorLength
     #(10.0 10.0 10.0) squaredVectorLength

     #(10.0 10.0 10.0) asFloatArray vectorLength
     #(10.0 10.0 10.0) asFloatArray squaredVectorLength
    "
!

vectorLength
    "Return the length of the receiver interpreted as vector
     That is the length of the vector from 0.0 @ 0.0 @ ... @ 0.0
     to the point in the n-dimensional space represented by the receiver.
     In 2D, that is plain old pythagoras."

    ^ self squaredVectorLength sqrt

    "
     #(10.0 10.0) vectorLength
     #(10.0 10.0 10.0) vectorLength

     #(10.0 10.0) asFloatArray vectorLength
     #(10.0 10.0 10.0) asFloatArray vectorLength
    "
! !

!SequenceableCollection methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitSequenceableCollection:with: to aVisitor."

    ^ aVisitor visitSequenceableCollection:self with:aParameter
! !

!SequenceableCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


SequenceableCollection initialize!
