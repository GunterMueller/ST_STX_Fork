"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

AutoResizingOrderedCollection subclass:#AutoResizingOrderedCollectionWithDefault
	instanceVariableNames:'defaultValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!AutoResizingOrderedCollectionWithDefault class methodsFor:'documentation'!

documentation
"
    I am an ordered collection which automatically resizes if elements
    are added beyond the size. 
    I.e. if #at:put: is sent for indexes > the current size, the receiver grows to
    the required index and missing fields are implicitly filled with a default value.
    Queries for non-existing elements are anwered with the default value.

    [see also:]
        OrderedCollection
        Array
        SparseArray
"
!

examples
"
    |coll|

    coll := AutoResizingOrderedCollectionWithDefault newWithDefaultValue:99.
    coll at:4 put:'four'.
    coll at:8 put:'eight'.
    coll at:9
"
! !

!AutoResizingOrderedCollectionWithDefault methodsFor:'accessing'!

at:index
    "fetch an object at index.
     If index is beyond the actual size, return the default value
     (i.e. this is an alias for at:index ifAbsent:[default value])"

    index > self size ifTrue:[^ defaultValue].
    ^ super at:index
!

at:index put:anObject
    "store an object at index.
     If required, grow the receiver to ensure that index is valid"

    |oldSize|
    
    index > (oldSize := self size) ifTrue:[
        self grow:index.
        self from:oldSize+1 to:index put:defaultValue.
    ].
    super at:index put:anObject
! !

!AutoResizingOrderedCollectionWithDefault methodsFor:'initialization'!

setDefaultValue:v
    defaultValue := v
! !

!AutoResizingOrderedCollectionWithDefault class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

