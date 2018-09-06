"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libboss' }"

Object subclass:#BinaryObjectStorage
	instanceVariableNames:'manager stream'
	classVariableNames:''
	poolDictionaries:''
	category:'System-BinaryStorage'
!

!BinaryObjectStorage class methodsFor:'documentation'!

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
"
!

documentation
"
    This class provides an ST-80 compatible (I hope) interface to
    BinaryInput- and BinaryOutputManager.
    The protocol is not complete, PP seems to offer more (skip etc.)
    this will be added as time goes by ...

    The protocol has been implemented by 'guessing' what users of this
    class expect from reading PD code.
    No warranty here for completeness. I depend on your feedback in adding
    more for compatibility; let me know what is required ....

    [author:]
        Claus Gittinger

    [See also:]
        BinaryIOManager ObsoleteObject
        PersistencyManager
        Object
        (binary object storage : programming/binaryStore.html )
"
!

examples 
"
    example (taken from an article in comp.lang.smalltalk):

      storing:
                                                                        [exBegin]
        |bos testArray |

        testArray := Array new: 4.
        1 to: 4 do: 
            [:index |
            | innerarray |
            innerarray := Array new: 10.
            1 to: 10 do:
                    [:innerIndex |
                    | innerinnerArray |
                    innerinnerArray := Array new: 1000 withAll: 0.
                    innerarray at: innerIndex put: innerinnerArray].
            testArray at: index put: innerarray
        ].

        bos := BinaryObjectStorage onNew:('array.boss' asFilename writeStream).
        bos nextPut: testArray.
        bos nextPut: #(1 2 3 4).
        bos nextPut: 'hello'.
        bos close.
                                                                        [exEnd]


      retrieving:
                                                                        [exBegin]
        |bos obj1 obj2 obj3|
        bos := BinaryObjectStorage onOld:('array.boss' asFilename readStream).
        obj1 := bos next.
        obj2 := bos next.
        obj3 := bos next.
        bos close.
        obj1 inspect.
        obj2 inspect.
        obj3 inspect.
                                                                        [exEnd]


   storing classes:
                                                                        [exBegin]
        |bos|

        bos := BinaryObjectStorage onNew:('FBrowser.cls' asFilename writeStream).
        bos nextPutClasses:(Array with:FileBrowser with:ChangesBrowser).
        bos close.
                                                                        [exEnd]


   retrieving:
                                                                        [exBegin]
        |bos cls1 cls2|

        bos := BinaryObjectStorage onOld:('FBrowser.cls' asFilename readStream).
        cls1 := bos next.
        cls2 := bos next.
        bos close.
        cls1 open.
        cls2 open.
                                                                        [exEnd]
"
! !

!BinaryObjectStorage class methodsFor:'instance creation'!

onNew:aStream
    "return an instance of myself to write objects to aStream"

    ^ self new onNew:aStream
!

onOld:aStream
    "return an instance of myself to read objects from aStream"

    ^ self new onOld:aStream
!

onOldNoScan:aStream
    "return an instance of myself to read objects from aStream"

    ^ self new onOldNoScan:aStream
! !

!BinaryObjectStorage class methodsFor:'Signal constants'!

binaryLoadErrorSignal  
    "return the signal raised, when a binary load fails for some reason.
     This is the parent signal for all other binary load errors; 
     therefore, it can be used to handle all errors in a single handler."

    ^ BinaryIOManager binaryLoadErrorSignal

    "Modified: 17.3.1997 / 16:02:09 / cg"
!

changedIndexedInstSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has different indexed instvars (i.e. byte-insts vs. pointers etc)"

    ^ BinaryIOManager changedIndexedInstSignal
!

changedInstLayoutSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has a different inst layout (i.e. the size matches, but the order of
     instvars has changed)"

    ^ BinaryIOManager changedInstLayoutSignal
!

changedInstSizeSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has a different inst-size (i.e. the number of named instvars has changed)"

    ^ BinaryIOManager changedInstSizeSignal
!

invalidBinaryFormatErrorSignal
    "return the signal raised, when a binary load fails due to format errors,
     for example, if you try to fileIn a binary object from another smalltalk,
     or from a stream which does not contain binary objects at all."

    ^ BinaryIOManager invalidBinaryFormatErrorSignal

    "Created: 17.3.1997 / 16:01:30 / cg"
!

invalidClassSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which is no longer compatible to the object,
     or when such a class is referenced in an instvar of a loaded object."

    ^ BinaryIOManager invalidClassSignal

    "Modified: / 27-09-2007 / 09:49:28 / cg"
!

nonexistingClassSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which does not (or no-longer) exist."

    ^ BinaryIOManager nonexistingClassSignal
!

requestConversionSignal
    "return the signal raised, when the binary storage manager requests
     an obsolete object to be converted. 
     The handler gets an instance of a dummy class (which has the
     old classes structure) and the new class as parameters, and is supposed to
     return an instance of the new class with the dummy-instances contents."

    ^ BinaryIOManager requestConversionSignal

    "Modified: / 27-09-2007 / 09:50:47 / cg"
! !

!BinaryObjectStorage methodsFor:'accessing'!

classEnvironment:aNameSpace
    "define the nameSpace, into which classes are installed.
     The default is nil, which means that loaded classes are returned,
     but not installed."

    manager classEnvironment:aNameSpace

    "Created: 8.10.1996 / 18:02:25 / cg"
!

manager
    ^ manager

    "Created: 19.3.1997 / 14:29:11 / cg"
!

sourceMode
    "return the mode-symbol which controls how sourceCode is stored
     in nextPutClasses:. The value can be one of:
	#keep      - store the sourceCode with methods
	#discard   - forget (i.e. do not store) any sourceCode
	#reference - store a reference into the classes source file."

    ^ manager sourceMode
!

sourceMode:aSymbol
    "set the mode-symbol which controls how sourceCode is stored
     in nextPutClasses:. The value must be one of:
	#keep      - store the sourceCode with methods
	#discard   - forget (i.e. do not store) any sourceCode
	#reference - store a reference into the classes source file."

    ^ manager sourceMode:aSymbol
!

storeMethodBytecode:aBoolean
    "set to true, to always store a method's bytecode"

    manager storeMethodBytecode:aBoolean
! !

!BinaryObjectStorage methodsFor:'object io'!

atEnd
    ^ stream atEnd

    "Modified: 22.1.1997 / 18:54:34 / cg"
!

close
    "close the storage (i.e. close the underlying stream)"

    stream close

    "Modified: 22.1.1997 / 18:54:34 / cg"
!

contents
    "read all objects; return a collection of objects"

    |coll|

    coll := OrderedCollection new.
    [stream atEnd] whileFalse:[
        coll add:self next
    ].
    ^ coll
!

next
    "read and return the next object"

    ^ manager readFrom:stream
!

nextPut:anObject
    "write an object"

    anObject storeBinaryOn: stream manager: manager
!

nextPutAll:aCollectionOfObjects
    "write all objects of the argument, aCollectionOfObjects"

    aCollectionOfObjects do:[:obj |
        obj storeBinaryOn: stream manager: manager
    ]

    "Modified: 22.1.1997 / 18:54:40 / cg"
!

nextPutClasses:aCollectionOfClasses
    "write all classes of the argument, aCollectionOfClasses.
     The classes are stored in superclass order (supers first).
     The classes can be retrieved with #next."

    |sortedByInheritance|

    sortedByInheritance := aCollectionOfClasses topologicalSort:[:a :b | b isSubclassOf:a]. 
    sortedByInheritance do:[:cls |
	cls storeBinaryClassOn: stream manager: manager
    ]
! !

!BinaryObjectStorage methodsFor:'private'!

onNew:aStream
    "setup for saving objects onto the given stream."

    stream := aStream.
    stream binary.
    manager := BinaryOutputManager new.

    "Modified: / 1.11.1997 / 20:41:23 / cg"
!

onOld:aStream
    "setup for reading objects from the given stream."

    stream := aStream.
    stream binary.
    manager := BinaryInputManager new.

    "Modified: / 1.11.1997 / 20:41:55 / cg"
!

onOldNoScan:aStream
    "compatibility."

    ^ self onOld:aStream
! !

!BinaryObjectStorage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/BinaryObjectStorage.st,v 1.28 2012-12-28 08:53:13 stefan Exp $'
! !

