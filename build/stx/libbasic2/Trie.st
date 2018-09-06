"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#Trie
	instanceVariableNames:'value children'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered'
!

Dictionary subclass:#RegularDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Trie
!

Object subclass:#SmallDictionaryWith1Element
	instanceVariableNames:'k1 v1'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Trie
!

Object subclass:#SmallDictionaryWith2Elements
	instanceVariableNames:'k1 k2 v1 v2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Trie
!

Object subclass:#SmallDictionaryWith3Elements
	instanceVariableNames:'k1 k2 k3 v1 v2 v3'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Trie
!

!Trie class methodsFor:'documentation'!

documentation
"
    A trie is a collection which maps string keys to values (see also SuffixTree and RadixTree).
    It keeps its elements as a tree, where each node's children are indexed by a fragment of the element's key.
    The fragment is a single character in this implementation.
    Thus, insertion and access times are linear to size of the key (the number of characters in the key), 
    not the number of elements in the collection.
    Due to the extra memory required to represent the tree, a Dictionary is usually much faster.
    However, a trie allows for prefix matches and sorted enumerations, which are hard with dictionaries.

    See AATree examples for speed comparison.

    [author:]
        Claus Gittinger
"
!

example
"
                                            [exBegin]
    |t|

    t := Trie new.
    t at:'12345' put:'hallo'.
    t at:'54923' put:'Welt'.
    t at:'1256' put:'bla'.
    t at:'12' put:'zwölf'.
    t at:'123' put:'einszweidrei'.
    t at:'1234' put:'einszweidreivier'.

    t at:'54923'.
    t includesKey:'54923'.  
    t includesKey:'5492'.     
    t size.      
    t.
                                            [exEnd]

                                            [exBegin]
    build a trie of all selectors in the system:

    |t0 t c|

    t0 := Time millisecondsToRun:[
        c := Trie new.
        Smalltalk allClassesDo:[:cls |
            cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            ].
        ].
    ].   
    Transcript show:'tOverhead: '; showCR:t0.

    t := Time millisecondsToRun:[
        c := Trie new.
        Smalltalk allClassesDo:[:cls |
            cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                (c at:sel ifAbsentPut:[Set new]) add:mthd
            ].
        ].
    ].   
    Transcript show:'tTrie: '; showCR:t.

    t := Time millisecondsToRun:[
        c := Dictionary new.
        Smalltalk allClassesDo:[:cls |
            cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                (c at:sel ifAbsentPut:[Set new]) add:mthd
            ].
        ].
    ].
    Transcript show:'tDict: '; showCR:t.
                                            [exEnd]
"
! !

!Trie class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Trie methodsFor:'accessing'!

add:aValue 
    ^ self at:aValue put:aValue

    "Created: / 04-08-2012 / 11:31:30 / cg"
!

at:key 
    ^ self at:key ifAbsent:[self error]

    "Created: / 04-08-2012 / 10:44:02 / cg"
!

at:key ifAbsent:exceptionValue 
    ^ self at:key keyIndex:1 ifAbsent:exceptionValue

    "Created: / 04-08-2012 / 10:10:23 / cg"
!

at:key ifAbsentPut:newValue 
    ^ self at:key keyIndex:1 ifAbsentPut:newValue

    "Created: / 04-08-2012 / 17:51:49 / cg"
!

at:key put:anElement
    self at:key keyIndex:1 put:anElement

    "Created: / 04-08-2012 / 10:09:39 / cg"
!

remove:aValue 
    ^ self at:aValue put:nil

    "Created: / 04-08-2012 / 11:32:16 / cg"
! !

!Trie methodsFor:'enumeration'!

do:aBlock
    value notNil ifTrue:[ aBlock value: value ].
    children notNil ifTrue:[
        children do:[:eachNode | eachNode do:aBlock ].
    ].

    "Created: / 04-08-2012 / 11:24:49 / cg"
! !

!Trie methodsFor:'private'!

at:key keyIndex:idx ifAbsent:exceptionalValue
    |childIndex|

    idx > key size ifTrue:[
        "/ at leaf
        value notNil ifTrue:[ ^ value ].
        ^ exceptionalValue value
    ] ifFalse:[
        childIndex := key at:idx.
        ^ (children at:childIndex) at:key keyIndex:idx+1 ifAbsent:exceptionalValue
    ].

    "Created: / 04-08-2012 / 17:58:29 / cg"
!

at:key keyIndex:idx ifAbsentPut:newValue
    |childIndex node|

    idx > key size ifTrue:[
        "/ at leaf
        value isNil ifTrue:[
            value := newValue value
        ].
        ^ value
    ] ifFalse:[
        childIndex := key at:idx.
        children isNil ifTrue:[
            children := Trie::SmallDictionaryWith1Element new
                            k1:childIndex v1:(node := self class new).
        ] ifFalse:[
            (children includesKey:childIndex) ifFalse:[
                children := children newAt:childIndex put:(node := self class new).
            ] ifTrue:[
                node := children at:childIndex
            ].
        ].
        ^ node at:key keyIndex:idx+1 ifAbsentPut:newValue.
    ]

    "Created: / 04-08-2012 / 17:53:17 / cg"
!

at:key keyIndex:idx put:anElement
    |childIndex node|

    idx > key size ifTrue:[
        "/ at leaf
        value := anElement
    ] ifFalse:[
        childIndex := key at:idx.
        anElement isNil ifTrue:[
            children isNil ifTrue:[^ self ].
            node := children at:childIndex.
            node isNil ifTrue:[^ self].
            node at:key keyIndex:idx+1 put:nil.
            node isEmpty ifTrue:[
                children := children newAt:childIndex put:nil.
            ]
        ] ifFalse:[
            children isNil ifTrue:[
                children := Trie::SmallDictionaryWith1Element new
                                k1:childIndex v1:(node := self class new).
            ] ifFalse:[
                (children includesKey:childIndex) ifFalse:[
                    children := children newAt:childIndex put:(node := self class new).
                ] ifTrue:[
                    node := children at:childIndex
                ].
            ].
            node at:key keyIndex:idx+1 put:anElement.
        ].
    ].

    "Created: / 04-08-2012 / 10:36:44 / cg"
!

includesKey:key keyIndex:idx
    |childIndex node|

    idx > key size ifTrue:[
        "/ at leaf
        ^ value notNil
    ] ifFalse:[
        children isNil ifTrue:[ ^ false ].
        childIndex := key at:idx.
        (children includesKey:childIndex) ifFalse:[^ false].
        node := children at:childIndex.
        ^ node includesKey:key keyIndex:idx+1 
    ].

    "Created: / 04-08-2012 / 18:04:25 / cg"
! !

!Trie methodsFor:'queries'!

includesKey:key 
    ^ self includesKey:key keyIndex:1

    "Created: / 04-08-2012 / 11:32:42 / cg"
!

isEmpty
    ^ value isNil
    and:[ children isEmptyOrNil ]

    "Created: / 04-08-2012 / 11:45:26 / cg"
!

size
    |n|

    n := (value notNil) ifTrue:[1] ifFalse:[0].
    children notNil ifTrue:[
        children do:[:eachChild |
            eachChild notNil ifTrue:[
                n := n + eachChild size
            ]
        ].
    ].
    ^ n

    "Created: / 04-08-2012 / 10:48:45 / cg"
! !

!Trie::RegularDictionary methodsFor:'accessing'!

newAt:key put:value
    self at:key put:value.
    ^ self

    "Created: / 04-08-2012 / 11:12:39 / cg"
! !

!Trie::SmallDictionaryWith1Element methodsFor:'accessing'!

at:key 
    key = k1 ifTrue:[^ v1 ].
    ^ self error

    "Created: / 04-08-2012 / 11:17:14 / cg"
!

at:key ifAbsent:exceptionValue
    key = k1 ifTrue:[^ v1 ].
    ^ exceptionValue value

    "Created: / 04-08-2012 / 11:00:52 / cg"
!

includesKey:key
    ^ key = k1

    "Created: / 04-08-2012 / 11:13:20 / cg"
!

isEmpty
    ^ k1 isNil

    "Created: / 04-08-2012 / 11:34:12 / cg"
!

k1:k1Arg v1:v1Arg 
    k1 := k1Arg.
    v1 := v1Arg.
!

newAt:key put:value
    key = k1 ifTrue:[ v1 := value. ^ self ].
    ^ Trie::SmallDictionaryWith2Elements new
        k1:k1 v1:v1 k2:key v2:value

    "Created: / 04-08-2012 / 11:02:49 / cg"
!

size
    ^ k1 isNil ifTrue:[0] ifFalse:[1]

    "Created: / 04-08-2012 / 11:54:21 / cg"
! !

!Trie::SmallDictionaryWith1Element methodsFor:'enumeration'!

do:aBlock
    k1 notNil ifTrue:[ aBlock value: v1 ].

    "Created: / 04-08-2012 / 11:19:10 / cg"
! !

!Trie::SmallDictionaryWith2Elements methodsFor:'accessing'!

at:key 
    key = k1 ifTrue:[^ v1 ].
    key = k2 ifTrue:[^ v2 ].
    ^ self error

    "Created: / 04-08-2012 / 11:17:24 / cg"
!

at:key ifAbsent:exceptionValue
    key = k1 ifTrue:[^ v1 ].
    key = k2 ifTrue:[^ v2 ].
    ^ exceptionValue value

    "Created: / 04-08-2012 / 11:01:05 / cg"
!

includesKey:key
    ^ key = k1 or:[ key = k2 ]

    "Created: / 04-08-2012 / 11:13:41 / cg"
!

isEmpty
    ^ k1 isNil and:[ k2 isNil ]

    "Created: / 04-08-2012 / 11:34:34 / cg"
!

k1:k1Arg v1:v1Arg k2:k2Arg v2:v2Arg 
    k1 := k1Arg.
    k2 := k2Arg.
    v1 := v1Arg.
    v2 := v2Arg.

    "Created: / 04-08-2012 / 11:14:16 / cg"
!

newAt:key put:value
    key = k1 ifTrue:[ v1 := value. ^ self ].
    key = k2 ifTrue:[ v2 := value. ^ self ].
    ^ Trie::SmallDictionaryWith3Elements new
        k1:k1 v1:v1 k2:k2 v2:v2 k3:key v3:value

    "Created: / 04-08-2012 / 11:03:16 / cg"
!

size
    ^ (k1 isNil ifTrue:[0] ifFalse:[1]) + (k2 isNil ifTrue:[0] ifFalse:[1])

    "Created: / 04-08-2012 / 11:54:49 / cg"
! !

!Trie::SmallDictionaryWith2Elements methodsFor:'enumeration'!

do:aBlock
    k1 notNil ifTrue:[ aBlock value: v1 ].
    k2 notNil ifTrue:[ aBlock value: v2 ].

    "Created: / 04-08-2012 / 11:19:23 / cg"
! !

!Trie::SmallDictionaryWith3Elements methodsFor:'accessing'!

at:key 
    key = k1 ifTrue:[^ v1 ].
    key = k2 ifTrue:[^ v2 ].
    key = k3 ifTrue:[^ v3 ].
    ^ self error

    "Created: / 04-08-2012 / 11:17:38 / cg"
!

at:key ifAbsent:exceptionValue
    key = k1 ifTrue:[^ v1 ].
    key = k2 ifTrue:[^ v2 ].
    key = k3 ifTrue:[^ v3 ].
    ^ exceptionValue value

    "Created: / 04-08-2012 / 11:01:15 / cg"
!

includesKey:key
    ^ key = k1 or:[ key = k2 or:[ key = k3 ]]

    "Created: / 04-08-2012 / 11:13:54 / cg"
!

isEmpty
    ^ k1 isNil and:[ k2 isNil and:[ k3 isNil ]]

    "Created: / 04-08-2012 / 11:34:48 / cg"
!

k1:k1Arg v1:v1Arg k2:k2Arg v2:v2Arg k3:k3Arg v3:v3Arg 
    k1 := k1Arg.
    k2 := k2Arg.
    k3 := k3Arg.
    v1 := v1Arg.
    v2 := v2Arg.
    v3 := v3Arg.

    "Created: / 04-08-2012 / 11:14:35 / cg"
!

newAt:key put:value
    key = k1 ifTrue:[ v1 := value. ^ self ].
    key = k2 ifTrue:[ v2 := value. ^ self ].
    key = k3 ifTrue:[ v3 := value. ^ self ].
    ^ Trie::RegularDictionary new
        at:k1 put:v1;
        at:k2 put:v2;
        at:k3 put:v3;
        at:key put:value;
        yourself

    "Created: / 04-08-2012 / 11:04:31 / cg"
!

size
    ^ (k1 isNil ifTrue:[0] ifFalse:[1]) 
        + (k2 isNil ifTrue:[0] ifFalse:[1])
        + (k3 isNil ifTrue:[0] ifFalse:[1])

    "Created: / 04-08-2012 / 11:55:03 / cg"
! !

!Trie::SmallDictionaryWith3Elements methodsFor:'enumeration'!

do:aBlock
    k1 notNil ifTrue:[ aBlock value: v1 ].
    k2 notNil ifTrue:[ aBlock value: v2 ].
    k3 notNil ifTrue:[ aBlock value: v3 ].

    "Created: / 04-08-2012 / 11:19:36 / cg"
! !

!Trie class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

