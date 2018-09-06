"{ Package: 'stx:goodies/libdbase' }"

TestCase subclass:#PersistencyManagerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Database-Support'
!

!PersistencyManagerTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger (cg@alan)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!PersistencyManagerTest methodsFor:'tests'!

test1
    "store & retrieve objects; check retrieved objects for equality with original"

    |p collStored collRetrieved|

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    collStored := (1 to:10000) asArray.
    1 to:1000 do:[:i |
       collStored at:i put:(i @ i)
    ].
    1000 to:2000 do:[:i |
       collStored at:i put:(i -> i)
    ].
    2000 to:3000 do:[:i |
       collStored at:i put:(0@0 corner:(i@i))
    ].
    p store:collStored key:1.
    p release.

    "/
    "/ retrieve
    "/
    p := PersistencyManager file:'pers'.
    collRetrieved := (p retrieve:1).
    p release.

    self assert: ( collStored size == collRetrieved size ).
    self assert: ( collStored = collRetrieved ).

    'pers' asFilename delete.

    "
     self basicNew test1
    "
!

test2
    "store & retrieve objects using other objects as key; check retrieved objects for equality with original"

    |p o|

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:'storing'.
    1 to:1000 do:[:i |
       p at:(i @ i) storeString put:(i @ i)
    ].
    1000 to:2000 do:[:i |
       p at:(i -> i) storeString put:(i -> i)
    ].
    2000 to:3000 do:[:i |
       p at:(0@0 corner:(i@i)) storeString put:(0@0 corner:(i@i))
    ].
    p release.

    "/
    "/ retrieve
    "/
    Transcript showCR:'retrieving'.
    p := PersistencyManager file:'pers'.
    1 to:1000 do:[:i |
        o := p at:(i @ i) storeString.
        self assert: ( o = (i @ i) ).
    ].
    1000 to:2000 do:[:i |
        o := p at:(i -> i) storeString.
        self assert: ( o = (i -> i) ).
    ].
    2000 to:3000 do:[:i |
        o := p at:(0@0 corner:(i@i)) storeString.
        self assert: ( o = (0@0 corner:(i@i)) ).
    ].

    p release.

    'pers' asFilename delete.

    "
     self basicNew test2
    "
!

test3
    "store & retrieve objects using other objects as key; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value values keysAndValues|

    keyLen := 40.
    valueLen := 40000.
    nObjects := 10.
    values := OrderedCollection new.
    keysAndValues := Dictionary new.

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:'storing'.
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := i printString , (String new:valueLen).
        values add:value.
        keysAndValues at:key put:value.
        p at:key put:value.
    ].
    p release.
    Transcript showCR:('pers' asFilename fileSize).

    "/
    "/ retrieve
    "/
    20 timesRepeat:[
        Transcript showCR:'retrieving'.
        p := PersistencyManager file:'pers'.
        1 to:nObjects do:[:i |
            key := i printString paddedTo:keyLen with:$x.
            value := p at:key.
            self assert: ( value = (values at:i) ).
            self assert: ( value = (keysAndValues at:key) ).
        ].
        p release.
    ].

    'pers' asFilename delete.

    "
     self basicNew test3
    "
!

test4
    "store & retrieve objects using other objects as key; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value values keysAndValues|

    keyLen := 40.
    valueLen := 40000.
    nObjects := 10.
    values := OrderedCollection new.
    keysAndValues := Dictionary new.

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:('storing...').
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := i printString , (String new:valueLen).
        values add:value.
        keysAndValues at:key put:value.
        p at:key put:value.
    ].
    p release.
    Transcript showCR:('pers' asFilename fileSize).

    "/
    "/ retrieve
    "/
    Transcript showCR:('retrieving by key...').
    p := PersistencyManager file:'pers'.
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := p at:key.
        self assert: ( value = (values at:i) ).
        self assert: ( value = (keysAndValues at:key) ).
    ].
    p release.

"/    "/
"/    "/ retrieve by key enumeration
"/    "/
"/    p := PersistencyManager file:'pers'.
"/    p keysDo:[:eachKey |
"/        value := p at:eachKey.
"/        self assert: ( value = (keysAndValues at:eachKey) ).
"/    ].
"/    p release.

    "/
    "/ retrieve by enumeration
    "/
    Transcript showCR:('retrieving by enumeration...').
    p := PersistencyManager file:'pers'.
    p keysAndValuesDo:[:eachKeyByteArray :eachValue|
        |eachKey|

        eachKey := eachKeyByteArray asString.
        self assert: ( eachValue = (keysAndValues at:eachKey) ).
    ].
    p release.

    'pers' asFilename delete.

    "
     self basicNew test4
    "
!

test4a
    "store & retrieve objects using other objects as key; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value|

    keyLen := 40.
    valueLen := 40000.
    nObjects := 10.

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:('storing...').
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := i printString , (String new:valueLen).
        p at:key put:value.
    ].
    p release.
    p close.
    Transcript showCR:('pers' asFilename fileSize).

    "
     self basicNew test4a
    "
!

test4b
    "store & retrieve objects using other objects as key; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value valueExpected|

    keyLen := 40.
    valueLen := 40000.
    nObjects := 10.

    "/
    "/ retrieve
    "/
    Transcript showCR:('retrieving by key...').
    p := PersistencyManager file:'pers'.
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := p at:key.
        valueExpected := i printString , (String new:valueLen).
        self assert: ( value = valueExpected ).
    ].
    p release.

"/    "/
"/    "/ retrieve by key enumeration
"/    "/
"/    p := PersistencyManager file:'pers'.
"/    p keysDo:[:eachKey |
"/        value := p at:eachKey.
"/        self assert: ( value = (keysAndValues at:eachKey) ).
"/    ].
"/    p release.

    "/
    "/ retrieve by enumeration
    "/
    Transcript showCR:('retrieving by enumeration...').
    p := PersistencyManager file:'pers'.
    p keysAndValuesDo:[:eachKeyByteArray :eachValue|
        |eachKey keyNr|

        eachKey := eachKeyByteArray asString.
        keyNr := Integer readFrom:eachKey.
        valueExpected := keyNr printString , (String new:valueLen).
        self assert: ( eachValue = valueExpected ).
    ].
    p release.

    "
     self basicNew test4b
    "
!

test5
    "store & retrieve large objects; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value values keysAndValues|

    keyLen := 400.
    valueLen := 80000.
    nObjects := 100.
    values := OrderedCollection new.
    keysAndValues := Dictionary new.

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:('storing...').
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := i printString , (String new:valueLen).
        values add:value.
        keysAndValues at:key put:value.
        p at:key put:value.
    ].
    p release.
    Transcript showCR:('pers' asFilename fileSize).

    "/
    "/ retrieve
    "/
    Transcript showCR:('retrieving by key...').
    p := PersistencyManager file:'pers'.
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := p at:key.
        self assert: ( value = (values at:i) ).
        self assert: ( value = (keysAndValues at:key) ).
    ].
    p release.

"/    "/
"/    "/ retrieve by key enumeration
"/    "/
"/    p := PersistencyManager file:'pers'.
"/    p keysDo:[:eachKey |
"/        value := p at:eachKey.
"/        self assert: ( value = (keysAndValues at:eachKey) ).
"/    ].
"/    p release.

"/    "/
"/    "/ retrieve by enumeration
"/    "/
"/    Transcript showCR:('retrieving by enumeration...').
"/    p := PersistencyManager file:'pers'.
"/    p keysAndValuesDo:[:eachKeyByteArray :eachValue|
"/        |eachKey|
"/
"/        eachKey := eachKeyByteArray asString.
"/        self assert: ( eachValue = (keysAndValues at:eachKey) ).
"/    ].
"/    p release.

    'pers' asFilename delete.

    "
     self basicNew test5
    "
!

test6
    "store & retrieve large objects; check retrieved objects for equality with original"

    |p nObjects keyLen valueLen key value values keysAndValues|

    keyLen := 400.
    valueLen := 80000.
    nObjects := 100.
    values := OrderedCollection new.
    keysAndValues := Dictionary new.

    p := PersistencyManager file:'pers'.
    "/
    "/ store
    "/
    Transcript showCR:('storing...').
    1 to:nObjects do:[:i |
        key := i printString paddedTo:keyLen with:$x.
        value := i printString , (String new:valueLen).
        values add:value.
        keysAndValues at:key put:value.
        p at:key put:value.
    ].
    p release.
    Transcript showCR:('pers' asFilename fileSize).

"/    "/
"/    "/ retrieve
"/    "/
"/    Transcript showCR:('retrieving by key...').
"/    p := PersistencyManager file:'pers'.
"/    1 to:nObjects do:[:i |
"/        key := i printString paddedTo:keyLen with:$x.
"/        value := p at:key.
"/        self assert: ( value = (values at:i) ).
"/        self assert: ( value = (keysAndValues at:key) ).
"/    ].
"/    p release.

    "/
    "/ retrieve by key enumeration
    "/
    p := PersistencyManager file:'pers'.
    p keysDo:[:eachKey |
        value := p at:eachKey.
        self assert: ( value = (keysAndValues at:eachKey asString) ).
    ].
    p release.

"/    "/
"/    "/ retrieve by enumeration
"/    "/
"/    Transcript showCR:('retrieving by enumeration...').
"/    p := PersistencyManager file:'pers'.
"/    p keysAndValuesDo:[:eachKeyByteArray :eachValue|
"/        |eachKey|
"/
"/        eachKey := eachKeyByteArray asString.
"/        self assert: ( eachValue = (keysAndValues at:eachKey) ).
"/    ].
"/    p release.

    'pers' asFilename delete.

    "
     self basicNew test6
    "
! !

!PersistencyManagerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/libdbase/PersistencyManagerTest.st,v 1.2 2006-11-13 13:29:30 stefan Exp $'
! !
