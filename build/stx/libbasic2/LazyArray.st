"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

ArrayedCollection variableSubclass:#LazyArray
	instanceVariableNames:'valueGenerator'
	classVariableNames:'UncomputedValueSingleton'
	poolDictionaries:''
	category:'Collections-Arrayed'
!

Object subclass:#UncomputedValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:LazyArray
!

!LazyArray class methodsFor:'documentation'!

documentation
"
    An Array which computes its values lazily (on demand) and remembers them.
    Useful if it is relatively expensive to compute an element, 
    and it may be needed again later.

    [author:]
        Claus Gittinger (cg@alan)

    [see also:]
        Lazy
"
!

examples
"
                                                                [exBegin]
    |squares|

    squares := LazyArray new:100.
    squares valueGenerator:[:index | index squared].

    squares at:50.   
    squares inspect.
                                                                [exEnd]
"
! !

!LazyArray class methodsFor:'initialization'!

initialize
    UncomputedValueSingleton isNil ifTrue:[
        UncomputedValueSingleton := UncomputedValue new.
    ]

    "
     self initialize
    "
! !

!LazyArray class methodsFor:'instance creation'!

new:size
    ^ (super new:size) atAllPut:UncomputedValue
! !

!LazyArray methodsFor:'accessing'!

at:index
    |val|

    val := super at:index.
    val == UncomputedValue ifTrue:[
        val := valueGenerator value:index.
        self at:index put:val.
    ].
    ^ val.
!

valueGenerator:aBlock
    valueGenerator := aBlock
! !

!LazyArray class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


LazyArray initialize!
