"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This code is part of Smalltalk/X - not part of the Manchester goodies
"
"{ Package: 'stx:goodies/libdbase' }"

Object subclass:#PersistencyManager
	instanceVariableNames:'dataBase nextSeqKey classInfoBytes fixIdToObjectMapping
		fixObjectToIdMapping'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Database-Support'
!

!PersistencyManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This code is part of Smalltalk/X - not part of the Manchester goodies
"
!

documentation
"
    This class brings persistency to Smalltalk/X (but only under UNIX).

    Instances of PersistencyManager allow storing & retrieval
    of objects into a simple DBM/NDBM/GDBM/DB1-6 dataBase. 

    A PersistencyManager is created with:
            pers := PersistencyManager file:'fileName'
    it will create the persistency file if not already existing.

    Objects are saved with:
            pers store:anObject
    or:
            pers store:anObject key:aKey

    in the first case, the persistencyManager will assign a new (unique, numeric)
    key and return it; in the second case, the object is stored under aKey.

    The key may be an Integer or a ByteArray-like object (i.e. String, Symbol etc.). 
    You may even take some other objects binary representation to
    get dictionary-like keys (i.e. taking any object as key) - but this is not recommended,
    since it will make the database useless, if the binaryStorage format is changed
    in the future (even if those changes are backward compatible, the keys will no longer
    lead to the corresponding objects in the database).

    Storing nil is equivalent to deleting an object.

    Automatically generated keys are simple integers, counting up. 
    The next available key is stored in the persistency file itself (under key == #[0]).

    The special key #[0] is reserved (used to store the nextKey information).

    Objects are retrieved using:
            pers retrieve:key

    which returns the object stored under key, or nil if nothing was stored
    with this key.

    Objects can be deleted with:
            pers delete:key

    PersistencyManager uses DBFile and binaryStorage to store objects.
    Since binaryStorage is not yet fully tested, use this goody with care. 
    Portability between platforms is intended, but has not been tested fully yet. 
    Non-IEEE floats are not converted yet (see Float class) but up to now, no non IEEE
    machines are supported anyway (which may change, with the first mainframe port of st/x).

    Some protocol compatibility with collections (actually dictionaries) is
    provided by the methods:#at, #at:put:, #includesKey: and #removeKey:
    So you can test your application using an in-memory dictionary and
    later replace it by an instance of PersistencyManager.

    [See also:]
        BinaryObjectStorage BinaryIOManager ObsoleteObject
        Dictionary
        DBFile
        (binary object storage : programming/binaryStore.html )
"
!

examples
"
   storing simple objects by numeric key
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     p store:#(1 2 3 4)                                        key:1.
     p store:'hello world'                                     key:2.
     p store:#(1 2 [1 2 3 4] [5 6 7 8] 9 10 $a 'hello')        key:3.
     p store:1.23456                                           key:4.
     p store:#(1.23456 3.456789 98765.4)                       key:5.
     p store:(FloatArray withAll:#(1.23456 3.456789 98765.4))  key:6.
     p store:(DoubleArray withAll:#(1.23456 3.456789 98765.4)) key:7.
     p release
                                                                        [exEnd]


   retrieving those objects
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     Transcript showCR:(p retrieve:1) displayString.
     Transcript showCR:(p retrieve:2) displayString.
     Transcript showCR:(p retrieve:3) displayString.
     Transcript showCR:(p retrieve:4) displayString.
     Transcript showCR:(p retrieve:5) displayString.
     Transcript showCR:(p retrieve:6) displayString.
     Transcript showCR:(p retrieve:7) displayString.
     p release
                                                                        [exEnd]


   storing simple collections
                                                                        [exBegin]
     |p  a|
     p := PersistencyManager file:'pers'.
     a := (1 to:20) asArray.
     p store:a key:1.
     a := (1 to:20) asByteArray.
     p store:a key:2.
     a := (1 to:20) asFloatArray.
     p store:a key:3.
     a := (1 to:20) asDoubleArray.
     p store:a key:4.
     a := (1 to:20).
     p store:a key:5.
     p release
                                                                        [exEnd]


   retrieving them
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     Transcript showCR:(p retrieve:1) displayString.
     Transcript showCR:(p retrieve:2) displayString.
     Transcript showCR:(p retrieve:3) displayString.
     Transcript showCR:(p retrieve:4) displayString.
     Transcript showCR:(p retrieve:5) displayString.
     p release
                                                                        [exEnd]


   storing a more complex object (self referencing)
                                                                        [exBegin]
     |p a d|
     p := PersistencyManager file:'pers'.
     a := Array new:3.
     a at:1 put:'hello'.
     a at:2 put:'self ref'.
     a at:3 put:a.
     d := Dictionary new.
     d at:#hello put:'hello'.
     d at:#world put:'world'.
     d at:'self-ref' put:a.
     p store:d key:1.
     p release
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     (p retrieve:1) inspect.
     p release
                                                                        [exEnd]


   storing a larger object
      (10000 element array, 1000 points,
       1000 assocs and 1000 rectangles)
                                                                        [exBegin]
     |p coll|

     p := PersistencyManager file:'pers'.
     coll := (1 to:10000) asArray.
     1 to:1000 do:[:i |
        coll at:i put:(i @ i)
     ].
     1000 to:2000 do:[:i |
        coll at:i put:(i -> i)
     ].
     2000 to:3000 do:[:i |
        coll at:i put:(0@0 corner:(i@i))
     ].
     p store:coll key:1.
     p release
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     (p retrieve:1) inspect.
     p release
                                                                        [exEnd]


   storing an image
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     p store:(Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif') key:4.
     p release
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     (p retrieve:4) inspect.
     p release
                                                                        [exEnd]


   storing an array with 1000 different strings
                                                                        [exBegin]
     |s p t a|
     s := '1234567890123456789012345678901234567890'.
     p := PersistencyManager file:'pers2'.
     a := Array new:1000.
     1 to:1000 do:[:i |
         a at:i put:s copy.
     ].
     t := Time millisecondsToRun:[
         p store:a key:1.
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p arr t|
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         arr := p retrieve:1.
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'.
     arr inspect
                                                                        [exEnd]


   storing an array with 1000 identical strings
                                                                        [exBegin]
     |a p t|
     a := Array new:1000.
     a atAllPut:'1234567890123456789012345678901234567890'.
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         p store:a key:1.
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p arr t|
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         arr := p retrieve:1.
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'.
     arr inspect
                                                                        [exEnd]


   storing 1000 records of 40 chars each
                                                                        [exBegin]
     |s p t|
     s := '1234567890123456789012345678901234567890'.
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         1 to:1000 do:[:i |
             p store:s key:i sync:false.
         ].
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'
                                                                        [exEnd]


   retrieving
                                                                        [exBegin]
     |p arr t|
     arr := Array new:1000.
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         1 to:1000 do:[:i |
             arr at:i put:(p retrieve:i).
         ].
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'.
     arr inspect
                                                                        [exEnd]


   storing 1000 strings with string-keys
                                                                        [exBegin]
     |s p t|
     s := '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'.
     p := PersistencyManager file:'pers2'.
     t := Time millisecondsToRun:[
         1 to:1000 do:[:i |
             p store:s key:i printString , '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' sync:false.
         ].
     ].
     p release.
     Transcript show:(t) printString; showCR:'ms'
                                                                        [exEnd]


   enumerating
                                                                        [exBegin]
     |p|

     p := PersistencyManager file:'pers2'.
     p keysAndValuesDo:[:key :object |
        Transcript showCR:(key asString printString , ' -> ' , object printString)
     ].
     p release.
                                                                        [exEnd]

   timing
                                                                        [exBegin]
     |p|
     p := PersistencyManager file:'pers'.
     Transcript showCR:(Time millisecondsToRun:[p store:'hello' key:100]).
     Transcript showCR:(Time millisecondsToRun:[p store:'world' key:101]).
     Transcript showCR:(Time millisecondsToRun:[p retrieve:100]         ).
     p release
                                                                        [exEnd]

   synchronous storing (i.e. every store goes into file);
   (b.t.w.: compare time here with execution time to store a single object
            consisting of 1000 strings ...)

                                                                        [exBegin]
     |p|
     Transcript showCR:(
        Time millisecondsToRun:[
            p := PersistencyManager file:'strings'.
            1 to:1000 do:[:key |
               |dataString|

               dataString := key printString.
               p store:dataString key:key.
            ].
        ]
     ).
     p release
                                                                        [exEnd]

   asynchronous storing (i.e. collects objects and writes from time to time);
   (b.t.w.: compare time here with execution time to store a single object
            consisting of 1000 strings ...)
                                                                        [exBegin]
     |p|
     Transcript showCR:(
        Time millisecondsToRun:[
            p := PersistencyManager file:'strings'.
            1 to:1000 do:[:key |
               |dataString|

               dataString := key printString.
               p store:dataString key:key sync:false.
            ].
            p sync
        ]
     ).
     p release
                                                                        [exEnd]

   retrieve & validate;
                                                                        [exBegin]
     |p|
     Transcript showCR:(
        Time millisecondsToRun:[
            p := PersistencyManager file:'strings'.
            1 to:1000 do:[:key |
               |dataString|

               dataString := p retrieve:key.
               dataString = key printString ifFalse:[
                   self error:'oops'
               ]
            ].
        ]
     ).
     p release
                                                                        [exEnd]

                                                                        [exBegin]
     |p k v|
     p := PersistencyManager file:'pers'.

     1 to:100 do:[:i |
        k := 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' , i printString.
        v := String new:600.
        p store:v key:k.
     ].
     p release
                                                                        [exEnd]
"
!

examples2
"
   storing 10000 personalRecord-objects in a standard PersistencyManager,
   gives a size of ~~ 2.5 Mb, 76sec store, 85sec read.

                                                                        [exBegin]
     |cls dataBase data timeToStore timeToLoad|

     Class withoutUpdatingChangesDo:[
        cls := Object subclass:#PersonalRecord
                      instanceVariableNames:'firstName lastName state city street telNo'
                      classVariableNames:''
                      poolDictionaries:''
                      category:'temporary'.

        PersonalRecord compile:'firstName ^ firstName' classified:'accessing'.
        PersonalRecord compile:'firstName:x firstName:=x.' classified:'accessing'.
        PersonalRecord compile:'lastName ^ lastName' classified:'accessing'.
        PersonalRecord compile:'lastName:x lastName:=x.' classified:'accessing'.
        PersonalRecord compile:'state ^ state' classified:'accessing'.
        PersonalRecord compile:'state:x state:=x.' classified:'accessing'.
        PersonalRecord compile:'city ^ city' classified:'accessing'.
        PersonalRecord compile:'city:x city:=x.' classified:'accessing'.
        PersonalRecord compile:'street ^ street' classified:'accessing'.
        PersonalRecord compile:'street:x street:=x.' classified:'accessing'.
        PersonalRecord compile:'telNo ^ telNo' classified:'accessing'.
        PersonalRecord compile:'telNo:x telNo:=x.' classified:'accessing'.
    ].

    Transcript showCR:'generating 10000 records of testData ...'.

    data := OrderedCollection new.
    1 to:10000 do:[:i |
        |record|

        record := PersonalRecord new.
        record firstName:('Peter' , i printString).
        record lastName:('Miller' , i printString).
        record state:('ca').
        record city:('Los Angeles').
        record street:('street' , i printString).
        record telNo:i * i.
        data add:record.
    ].

    'testpersons.db' asFilename exists ifTrue:[
        'testpersons.db' asFilename delete
    ].
    dataBase := PersistencyManager file:'testpersons.db'.

    Transcript showCR:'adding 10000 records to the dataBase ...'.
    timeToStore := Time millisecondsToRun:[
        1 to:10000 do:[:i |
            |record|

            record := data at:i.
            dataBase store:record key:i sync:false.
        ].
        dataBase close.
    ].

    Transcript showCR:'reading 10000 records from the dataBase ...'.

    dataBase := PersistencyManager file:'testpersons.db'.
    data := OrderedCollection new.
    timeToLoad := Time millisecondsToRun:[
        1 to:10000 do:[:i |
            |record|

            record := dataBase retrieve:i.
            data add:record
        ].
        dataBase close.
    ].
    Transcript showCR:'time to store: ' , timeToStore printString, ' ms'.
    Transcript showCR:'time to load: ' , timeToLoad printString, ' ms'.
                                                                    [exEnd]

   storing 10000 personalRecord-objects in a PersistencyManager,
   which has been setup to treat the PersonalRecord class as a constant
   object.
   This gives a size of ~~ 1.2 Mb, 62sec store, 8sec read.

                                                                        [exBegin]
     |cls dataBase data timeToStore timeToLoad|

     Class withoutUpdatingChangesDo:[
        cls := Object subclass:#PersonalRecord
                      instanceVariableNames:'firstName lastName state city street telNo'
                      classVariableNames:''
                      poolDictionaries:''
                      category:'temporary'.

        PersonalRecord compile:'firstName ^ firstName' classified:'accessing'.
        PersonalRecord compile:'firstName:x firstName:=x.' classified:'accessing'.
        PersonalRecord compile:'lastName ^ lastName' classified:'accessing'.
        PersonalRecord compile:'lastName:x lastName:=x.' classified:'accessing'.
        PersonalRecord compile:'state ^ state' classified:'accessing'.
        PersonalRecord compile:'state:x state:=x.' classified:'accessing'.
        PersonalRecord compile:'city ^ city' classified:'accessing'.
        PersonalRecord compile:'city:x city:=x.' classified:'accessing'.
        PersonalRecord compile:'street ^ street' classified:'accessing'.
        PersonalRecord compile:'street:x street:=x.' classified:'accessing'.
        PersonalRecord compile:'telNo ^ telNo' classified:'accessing'.
        PersonalRecord compile:'telNo:x telNo:=x.' classified:'accessing'.
    ].

    Transcript showCR:'generating 10000 records of testData ...'.

    data := OrderedCollection new.
    1 to:10000 do:[:i |
        |record|

        record := PersonalRecord new.
        record firstName:('Peter' , i printString).
        record lastName:('Miller' , i printString).
        record state:('ca').
        record city:('Los Angeles').
        record street:('street' , i printString).
        record telNo:i * i.
        data add:record.
    ].

    'testpersons.db' asFilename exists ifTrue:[
        'testpersons.db' asFilename delete
    ].
    dataBase := PersistencyManager file:'testpersons.db'.

    Transcript showCR:'tuning persistencyManager ...'.
    dataBase addConstantObjects:(Array with:PersonalRecord).

    Transcript showCR:'adding 10000 records to the dataBase ...'.
    timeToStore := Time millisecondsToRun:[
        1 to:10000 do:[:i |
            |record|

            record := data at:i.
            dataBase store:record key:i sync:false.
        ].
        dataBase close.
    ].

    Transcript showCR:'reading 10000 records from the dataBase ...'.

    dataBase := PersistencyManager file:'testpersons.db'.
    data := OrderedCollection new.
    timeToLoad := Time millisecondsToRun:[
        1 to:10000 do:[:i |
            |record|

            record := dataBase retrieve:i.
            data add:record
        ].
        dataBase close.
    ].
    Transcript showCR:'time to store: ' , timeToStore printString, ' ms'.
    Transcript showCR:'time to load: ' , timeToLoad printString, ' ms'.
                                                                    [exEnd]

  tally:
                                                                    [exBegin]
     |cls dataBase data|

     Class withoutUpdatingChangesDo:[
        cls := Object subclass:#PersonalRecord
                      instanceVariableNames:'firstName lastName state city street telNo'
                      classVariableNames:''
                      poolDictionaries:''
                      category:'temporary'.

        PersonalRecord compile:'firstName ^ firstName' classified:'accessing'.
        PersonalRecord compile:'firstName:x firstName:=x.' classified:'accessing'.
        PersonalRecord compile:'lastName ^ lastName' classified:'accessing'.
        PersonalRecord compile:'lastName:x lastName:=x.' classified:'accessing'.
        PersonalRecord compile:'state ^ state' classified:'accessing'.
        PersonalRecord compile:'state:x state:=x.' classified:'accessing'.
        PersonalRecord compile:'city ^ city' classified:'accessing'.
        PersonalRecord compile:'city:x city:=x.' classified:'accessing'.
        PersonalRecord compile:'street ^ street' classified:'accessing'.
        PersonalRecord compile:'street:x street:=x.' classified:'accessing'.
        PersonalRecord compile:'telNo ^ telNo' classified:'accessing'.
        PersonalRecord compile:'telNo:x telNo:=x.' classified:'accessing'.
    ].

    Transcript showCR:'generating 10000 records of testData ...'.

    data := OrderedCollection new.
    1 to:10000 do:[:i |
        |record|

        record := PersonalRecord new.
        record firstName:('Peter' , i printString).
        record lastName:('Miller' , i printString).
        record state:('ca').
        record city:('Los Angeles').
        record street:('street' , i printString).
        record telNo:i * i.
        data add:record.
    ].

    'testpersons.db' asFilename exists ifTrue:[
        'testpersons.db' asFilename delete
    ].
    dataBase := PersistencyManager file:'testpersons.db'.

    Transcript showCR:'tuning persistencyManager ...'.
    dataBase addConstantObjects:(Array with:PersonalRecord).

    Transcript showCR:'adding 10000 records to the dataBase ...'.
    MessageTally spyOn:[
        1 to:10000 do:[:i |
            |record|

            record := data at:i.
            dataBase store:record key:i sync:false.
        ].
        dataBase close.
    ].

    Transcript showCR:'reading 10000 records from the dataBase ...'.

    dataBase := PersistencyManager file:'testpersons.db'.
    data := OrderedCollection new.
    MessageTally spyDetailedOn:[
        1 to:10000 do:[:i |
            |record|

            record := dataBase retrieve:i.
            data add:record
        ].
        dataBase close.
    ].
                                                                    [exEnd]

"
!

tuning
"
    A new interface has been added to PersistencyManager, which
    allows tuning both the speed and the dataBase size.
    By passing a collection of objects to #addConstantObjects:,
    those objects are stored in a separate area of the dataBase,
    and referenced by ID (instead of by value) in further dataBase
    store operations.

    The typical scenario in which this mechanism can be used
    is when many objects which are instances of a small number of common
    classes are stored in some dataBase, and those classes remain unchanged.

    With a regular persistencyManager, whenever an object is stored,
    all of the objects class info is stored with it - thus, blowing up
    the size of the database and requiring more I/O time.

    With constantObject information present, a manager reads this information once
    when the dataBase is opened, and remembers it internally. When storing objects,
    those constant objects are already in the database and are referenced by ID
    (i.e. not stored again). When reading, those objects have already been read
    and are not read again.

    Typically, the classes of the most common objects in the dataBase are
    stored in that constant area (but common strings, symbols are also candidates).

    If the number of reusable constant objects in the dataBase is large compared
    to the overall number of objects, this mechanism should not be used, since
    it may create more overhead above a certain ratio.

    The break-even depends upon the number of classes (amount of memory that is used
    to hold class info) and the ratio between number of objects and number of different
    classes. As a rule of thumb, do NOT use a cachingManager, if (say) more than
    500 different classes are used and/or the ratio between numInsts and numClasses is
    less than (say 5).
    Also notice, that the startup time with constant objects present is longer than
    without - due to the reading of all those objects which is done at file-open
    time. 
    Thus, it probably does not make sense to use it when individual objects are
    to be retrieved later, and the database is reopend for each.

    The #addConstantObjects: interface should be used when the dataBase is created 
    initially (i.e. before the very first store operation).
    The set of constant objects may be expanded later, by
    calling that method again later - however, objects cannot be
    removed from constant set (that could lead to a change of the
    ID of the constant objects after the removed one, which would invalidate
    stored objects which refer to them).
    For removal of dead constant objects in the dataBase, the dataBase should
    be recreated from scratch with a new constant set.
    (having dead entries - or unused constants - does not hurt usually,
     except for the additional lost fileSystemSpace.)
"

! !

!PersistencyManager class methodsFor:'instance creation'!

file:aFileName
    "return a persistency manager storing objects in aFileName"

    ^ self new file:aFileName readOnly:false
!

readOnlyFile:aFileName
    "return a persistency manager storing objects in aFileName"

    ^ self new file:aFileName readOnly:true 
! !

!PersistencyManager class methodsFor:'Signal constants'!

openErrorSignal
    "return the signal raised if an error occurs during an open"

    ^ DBFile openErrorSignal

    "Created: 23.10.1997 / 02:32:15 / cg"
! !

!PersistencyManager class methodsFor:'constants'!

isValidKey:aKey
    "return true, if aKey is allowed for user data (i.e. is not a reserved key)"

    aKey size ~~ 1 ifTrue:[^ true].
    ^ aKey ~= self keyOfNextKey

    "Modified: / 1.11.1997 / 23:16:31 / cg"
!

keyOfNextKey
    "the key under which the next key is stored"

    ^ #[0]      "/ should be distinct from numeric-0 (which is #[0 0 0 0])

    "Modified: / 1.11.1997 / 23:16:54 / cg"
! !

!PersistencyManager methodsFor:'collection compatible interface'!

add:anObject
    "assign a new key, store anObject and return the key."

    ^ self store:anObject
!

at:aKey
    "retrieve the object stored under aKey. 
     Return nil, if nothing is present under that key.
     For protocol compatibility with dictionaries"

    ^ self retrieve:aKey

    "Modified: 12.5.1996 / 14:49:47 / cg"
!

at:aKey ifAbsent:exceptionBlock
    "retrieve the object stored under aKey. 
     Return nil, if nothing is present under that key.
     For protocol compatibility with dictionaries"

    ^ self retrieve:aKey ifAbsent:exceptionBlock

    "Modified: 12.5.1996 / 14:49:47 / cg"
    "Created: 15.7.1996 / 17:40:39 / cg"
!

at:aKey put:anObject
    "store anObject under aKey. 
     For protocol compatibility with dictionaries"

    ^ self store:anObject key:aKey sync:true
!

removeKey:aKey
    "delete the object stored under aKey. 
     For protocol compatibility with dictionaries"

    ^ self delete:aKey
! !

!PersistencyManager methodsFor:'deleting'!

delete:aKey
    "delete the object stored under aKey"

    self delete:aKey sync:true
!

delete:aKey sync:sync
    "delete the object stored under aKey. 
     if sync is true, the change is immediately brought to the disk; 
     otherwise stuff is cached in memory."

    |keyBytes|

    keyBytes := self makeKey:aKey.
    keyBytes isNil ifTrue:[^ nil].
    dataBase remove:keyBytes.
    sync ifTrue:[dataBase sync].
! !

!PersistencyManager methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for all stored objects"

    dataBase do:[:dataBytes |
        |object|

        dataBytes isNil ifTrue:[
            object := nil
        ] ifFalse:[
            object := BinaryInputManager readFrom:(ReadStream on:dataBytes)
        ].
        aBlock value:object.
    ]

    "Created: 12.5.1996 / 13:59:09 / cg"
    "Modified: 12.5.1996 / 14:00:10 / cg"
!

keysAndValuesDo:aTwoArgBlock
    "evaluate aBlock for all stored key/object pairs"

    dataBase keysAndValuesDo:[:key :dataBytes |
        |object|

        dataBytes isNil ifTrue:[
            object := nil
        ] ifFalse:[
            object := BinaryInputManager readFrom:(ReadStream on:dataBytes)
        ].
        aTwoArgBlock value:key value:object.
    ]

    "Modified: 12.5.1996 / 14:00:10 / cg"
    "Created: 11.12.1996 / 12:02:01 / cg"
!

keysDo:aBlock
    "evaluate aBlock for all stored keys"

    dataBase keysDo:[:key |
        aBlock value:key.
    ]
! !

!PersistencyManager methodsFor:'misc'!

close
    "release database (i.e. close the file)"

    dataBase close.

    "Modified: / 1.11.1997 / 21:58:02 / cg"
!

release
    "release database (i.e. close the file)"

    dataBase close.
    super release.

    "Modified: 11.6.1997 / 13:20:56 / cg"
!

sync
    "flush buffered data to disk - needed after a
     store without sync"

    dataBase sync
! !

!PersistencyManager methodsFor:'private'!

constantObjectsInClassInfoDo:aBlock
    |classInfoSize infoStream bmgr|

    "/ hard-wired; for now.
    "/ bytes 1..4:      nextSeqKey
    "/ bytes 5..8:      sizeOf classInfo (in bytes); follow below
    "/ bytes 9..128:    reserved
    "/ bytes 129..n1    sizeOf classInfo bytes containing
    "/                  the binaryStorage representation of prestored
    "/                  classes. These are not stored again or read again.

    classInfoSize := classInfoBytes doubleWordAt:5 MSB:false.
    classInfoSize ~~ 0 ifTrue:[
        infoStream := classInfoBytes readStream.
        infoStream position1Based:129.
        infoStream readLimit:(129 + classInfoSize - 1).

        "/
        "/ read everything from that data ...
        "/
        bmgr := BinaryInputManager on:infoStream.
        [infoStream atEnd] whileFalse:[
            aBlock value:bmgr nextObject
        ].
    ].
    ^ bmgr

    "Created: / 2.11.1997 / 12:30:53 / cg"
    "Modified: / 2.11.1997 / 13:13:22 / cg"
!

extractDataBaseInfo
    |classInfoSize bmgr|

    "/ hard-wired; for now.
    "/ bytes 1..4:      nextSeqKey
    "/ bytes 5..8:      sizeOf classInfo (in bytes); follow below
    "/ bytes 9..128:    reserved
    "/ bytes 129..n1    sizeOf classInfo bytes containing
    "/                  the binaryStorage representation of prestored
    "/                  classes. These are not stored again or read again.

    classInfoSize := classInfoBytes doubleWordAt:5 MSB:false.
    classInfoSize ~~ 0 ifTrue:[
        bmgr := self constantObjectsInClassInfoDo:[:aConstantObject | ].

        "/ now, remember this managers id->object mappings
        "/ and a corresponding reverse mapping for the future.

        fixIdToObjectMapping := bmgr idToObjectMapping.
        fixObjectToIdMapping := IdentityDictionary new.
        fixIdToObjectMapping keysAndValuesDo:[:id :obj |
            fixObjectToIdMapping at:obj put:id
        ]
    ]

    "Created: / 2.11.1997 / 10:52:37 / cg"
    "Modified: / 2.11.1997 / 13:09:54 / cg"
!

file:aFileName readOnly:readonly 
    "open/create the persistency file;
     get/set the nextSeq key for automatic keying.
     (the nextSeqKey is stored under key 0 in the database)"

    readonly ifTrue:[
        dataBase := DBFile readonlyDataBaseNamed:aFileName.
    ] ifFalse:[
        dataBase := DBFile dataBaseNamed:aFileName.
    ].
    dataBase isNil ifTrue:[
"/        self error:'cannot open database file: ' , aFileName.
        ^ nil
    ].
    classInfoBytes := self readDataBaseInfo.
    classInfoBytes notNil ifTrue:[
        nextSeqKey := classInfoBytes doubleWordAt:1 MSB:false.
        classInfoBytes size > 4 ifTrue:[
            "/ there is more info found in it ...
            self extractDataBaseInfo.
        ]
    ] ifFalse:[
        nextSeqKey := 1.
    ].

    "Modified: / 2.11.1997 / 12:53:29 / cg"
!

makeKey:aKey
    "make a useful key from the given key object. Also check for
     valid key (non-nil and ByteArray-like)"

    |keyBytes|

    (aKey isMemberOf:ByteArray) ifTrue:[
        (self class isValidKey:aKey) ifTrue:[
            ^ aKey
        ].
        self error:'reserved key'.
    ].
    aKey isInteger ifTrue:[
        (aKey isMemberOf:SmallInteger) ifTrue:[
            keyBytes := ByteArray uninitializedNew:4.
            keyBytes doubleWordAt:1 put:aKey MSB:false.
        ] ifFalse:[
            keyBytes := aKey printString.
        ].
        ^ keyBytes
    ].
    (aKey isByteArray) ifTrue:[
        (self class isValidKey:aKey) ifTrue:[
            ^ aKey
        ].
        self error:'reserved key'.
    ].
    self error:'invalid key'.

    "Modified: / 2.11.1997 / 13:13:41 / cg"
!

readDataBaseInfo
    "get the dataBase info, which includes the constant objects
     and the nextKey info"

    |nk|

    nk := self class keyOfNextKey.
    (dataBase includesKey:nk) ifTrue:[
        ^ dataBase at:nk.
    ].
    ^ nil

    "Modified: / 2.11.1997 / 10:52:04 / cg"
    "Created: / 2.11.1997 / 12:22:10 / cg"
! !

!PersistencyManager methodsFor:'queries'!

includesKey:aKey
    "return true, if data is stored under aKey, false otherwise"

    |keyBytes|

    keyBytes := self makeKey:aKey.
    keyBytes isNil ifTrue:[^ nil].

    ^ dataBase includesKey:keyBytes
! !

!PersistencyManager methodsFor:'special tuning'!

addConstantObjects:aCollectionOfConstantObjects
    |bmgr constantObjects s fixBytes newClassInfo|

    constantObjects := OrderedCollection new.

    classInfoBytes notNil ifTrue:[
        classInfoBytes size > 4 ifTrue:[
            bmgr := self constantObjectsInClassInfoDo:[:aConstantObject | 
                                                          constantObjects add:aConstantObject                  
                                                      ].
        ].
    ].
    aCollectionOfConstantObjects do:[:anotherOne |
        (constantObjects includesIdentical:anotherOne) ifFalse:[
            constantObjects add:anotherOne
        ]
    ].

    "/ change classInfoBytes and writeBack
    s := ByteArray new writeStream.
    bmgr := BinaryOutputManager new.
    constantObjects do:[:aConstantObject |
        aConstantObject storeBinaryOn:s manager:bmgr
    ].
    fixBytes := s contents.
    newClassInfo := ByteArray new:(128 + fixBytes size).
    newClassInfo replaceFrom:129 with:fixBytes.
    newClassInfo doubleWordAt:1 put:nextSeqKey MSB:false.
    newClassInfo doubleWordAt:5 put:(fixBytes size) MSB:false.
    classInfoBytes := newClassInfo.
    dataBase at:self class keyOfNextKey put:classInfoBytes.

    "/ and update my mappings from
    "/ this managers id->object mappings
    "/ and a corresponding reverse mapping for the future.

    fixObjectToIdMapping := bmgr objectToIdMapping.
    fixIdToObjectMapping := IdentityDictionary new.
    fixObjectToIdMapping keysAndValuesDo:[:obj :id |
        fixIdToObjectMapping at:id put:obj
    ]

    "Created: / 2.11.1997 / 12:19:42 / cg"
    "Modified: / 2.11.1997 / 13:05:36 / cg"
! !

!PersistencyManager methodsFor:'storing & retrieve'!

newUniqueKey
    "assign a new key and return it"

    |key next|

    key := nextSeqKey.
    nextSeqKey := key + 1.
    "
     store the next-key
    "
    classInfoBytes notNil ifTrue:[
        next := classInfoBytes
    ] ifFalse:[
        next := ByteArray new:4.
    ].
    next doubleWordAt:1 put:nextSeqKey MSB:false.
    dataBase at:self class keyOfNextKey put:next.

    ^ key

    "Created: / 15.7.1996 / 14:31:58 / cg"
    "Modified: / 2.11.1997 / 13:13:53 / cg"
!

retrieve:aKey
    "retrieve the object stored under aKey"

    ^ self retrieve:aKey ifAbsent:nil

    "Modified: / 2.11.1997 / 02:51:41 / cg"
!

retrieve:aKey ifAbsent:exceptionBlock
    "retrieve the object stored under aKey"

    |dataBytes keyBytes byteStream mgr|

    keyBytes := self makeKey:aKey.
    keyBytes isNil ifTrue:[^ nil].

    dataBytes := dataBase at:keyBytes ifAbsent:nil.
    dataBytes isNil ifTrue:[^ exceptionBlock value].

    byteStream := ReadStream on:dataBytes.

    mgr := BinaryInputManager new.
    fixIdToObjectMapping notNil ifTrue:[
        mgr fixIdToObjectMapping:fixIdToObjectMapping.
    ].
    ^ mgr readFrom:byteStream

    "Created: / 15.7.1996 / 17:34:58 / cg"
    "Modified: / 2.11.1997 / 16:38:46 / cg"
!

store:anObject
    "assign a key, store anObject; return the key"

    ^ self store:anObject sync:true

    "Modified: / 2.11.1997 / 16:33:31 / cg"
!

store:anObject key:aKey
    "store anObject; return the key. The objects
     data is immediately synced to disk 
     (therefore this method may take some time)"

    ^ self store:anObject key:aKey sync:true
!

store:anObject key:aKey sync:sync
    "store anObject; return the key. if sync is true,
     data is flushed to disk; otherwise stuff is cached
     in memory."

    |s dataBytes keyBytes mgr|

    keyBytes := self makeKey:aKey.
    keyBytes isNil ifTrue:[^ nil].

    anObject isNil ifTrue:[
        dataBase remove:keyBytes.
    ] ifFalse:[
        s := WriteStream on:(ByteArray uninitializedNew:20).
        mgr := BinaryOutputManager new.
        fixObjectToIdMapping notNil ifTrue:[
            mgr fixObjectToIdMapping:fixObjectToIdMapping.
        ].
        anObject storeBinaryOn:s manager:mgr.
        dataBytes := s contents.

        dataBase at:keyBytes put:dataBytes.
    ].
    sync ifTrue:[dataBase sync].
    ^ aKey

    "Modified: / 2.11.1997 / 16:37:25 / cg"
!

store:anObject sync:sync
    "assign a key, store anObject; return the key"

    |key|

    key := self newUniqueKey.
    ^ self store:anObject key:key sync:sync

    "Created: / 2.11.1997 / 16:33:15 / cg"
    "Modified: / 2.11.1997 / 16:34:20 / cg"
! !

!PersistencyManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/libdbase/PersistencyManager.st,v 1.6 2012-08-03 20:22:17 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/libdbase/PersistencyManager.st,v 1.6 2012-08-03 20:22:17 stefan Exp $'
! !
