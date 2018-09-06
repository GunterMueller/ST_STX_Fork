"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#AutoResizingOrderedCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!AutoResizingOrderedCollection class methodsFor:'documentation'!

documentation
"
    I am an ordered collection which automatically resizes if elements
    are added beyond the size. 
    I.e. if #at:put: is sent for indexes > the current size, the receiver grows to
    the required index and missing fields are implicitly filled with nils.
    Queries for non-existing elements are anwered with nil.

    [see also:]
        OrderedCollection
        Array
        SparseArray
"
!

examples
"
    |coll|
    
    coll := AutoResizingOrderedCollection new.
    coll at:4 put:'four'.
    coll at:8 put:'eight'.
    coll at:9
"
! !

!AutoResizingOrderedCollection class methodsFor:'instance creation'!

newWithDefaultValue:defaultValue
    ^ AutoResizingOrderedCollectionWithDefault new setDefaultValue:defaultValue
! !

!AutoResizingOrderedCollection methodsFor:'accessing'!

at:index
    "fetch an object at index.
     If index is beyond the actual size, return nil
     (i.e. this is an alias for at:index ifAbsent:[nil])"
     
    index > self size ifTrue:[^ nil].
    ^ super at:index
!

at:index put:anObject
    "store an object at index.
     If required, grow the receiver to ensure that index is valid"
     
    index > self size ifTrue:[
        self grow:index.
    ].
    super at:index put:anObject
! !

!AutoResizingOrderedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

