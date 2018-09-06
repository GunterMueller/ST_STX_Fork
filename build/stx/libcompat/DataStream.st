"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

RWBinaryOrTextStream subclass:#DataStream
	instanceVariableNames:'byteStream topCall basePos'
	classVariableNames:'TypeMap'
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

DataStream comment:''
!

!DataStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    compatibility class for squeak compatible object loading support.
    DataStreams are Squeak's equivalent of the Binary Object Storage mechanism;
    they marshall/demarshall objects onto/from a stream.

    This does not support recursive object references (i.e. cycles).
    For that, Squeak uses a ReferenceStream.

    This is required e.g. by monticello.
    However, only the minimum functionality as required by monticello is supported
    here. Do not use it for your own binary storage / persistance,
    unless you intent to exchange data with squeak/pharo applications.
"
!

example1
    "DataStream example1"
    "ReferenceStream example1"

    {
        0 .
        3 .
        -3 .
        30000 .
        -30000 .
        30000000 .
        -30000000 .
        30000000000000000000000 .
        -30000000000000000000000 .
        0.0  .
        3.0  .
        'hello'   .
        #[1 2 3 4] .
        #(1 2 3 4) .
        (10 @ 20) .
        (10 @ 20) corner:(100@200) .
        (OrderedCollection with:1 with:2 with:3) .
        (Set with:1 with:2 with:3) .
        ('hello.txt' asFilename) .
        'hello' asUnicode32String .
        nil.
        true.
        false.
        #(3 3.0 'three').
        1024 @ -2048.
        #x.
        (Array with:( 0 @ -30000)) .
        (Array with:1 with: #(3 3.0 'three') with:3) .

    } do:[:inputObject |
        |readBack|

        "Write it out, read it back, and return it for inspection."
        Transcript show:'write: '; showCR:inputObject.
        readBack := self testWith: inputObject.
        Transcript show:'read back: '; showCR:readBack; cr.
        self assert:(readBack = inputObject).
    ].


    "Modified: / 25-11-2011 / 14:15:32 / cg"
!

example2
    "An example and test of DataStream/ReferenceStream.
     11/19/92 jhm: Use self testWith:."
    "DataStream example2"
    "ReferenceStream example2"

    | input sharedPoint |

    "Construct the test data."
    input := Array new: 9.
    input at: 1 put: nil.
    input at: 2 put: true.
"/    input at: 3 put: (Form extent: 63 @ 50 depth: 8).
"/                (input at: 3) fillWithColor: Color lightBlue.
    input at: 4 put: #(3 3.0 'three').
    input at: 5 put: false.
    input at: 6 put: 1024 @ -2048.
    input at: 7 put: #x.
    input at: 8 put: (Array with: (sharedPoint := 0 @ -30000)).
    input at: 9 put: sharedPoint.

    "Write it out, read it back, and return it for inspection."
    ^ self testWith: input

    "Modified: / 25-11-2011 / 14:15:32 / cg"
!

exampleWithPictures
        "DataStream exampleWithPictures"

        "/ this fails in ST/X, because in ST/X forms require true references to
        "/ be handled correctly (because of the cachingRegistry, which contains a
        "/ reference cycle).
        "/ Squeak forms look different, and do not have a device-form cache.
        "/ Therefore, in ST/X, a ReferenceStream is required, which has not really been ported.
        | file result |
        file := FileStream fileNamed: 'Test-Picture'.
        file binary.
        (ReferenceStream on: file) nextPut: (Form fromUser).
        file close.

        file := FileStream fileNamed: 'Test-Picture'.
        file binary.
        result := (ReferenceStream on: file) next.
        file close.
        result display.
        ^ result
! !

!DataStream class methodsFor:'initialization'!

initializeTypeMaps
        "TypeMap maps Smalltalk classes to type ID numbers which identify the data stream primitive formats.  nextPut: writes these IDs to the data stream.  NOTE: Changing these type ID numbers will invalidate all extant data stream files.  Adding new ones is OK.
         Classes named here have special formats in the file.  If such a class has a subclass, it will use type 9 and write correctly.  It will just be slow.  (Later write the class name in the special format, then subclasses can use the type also.)
         See nextPut:, next, typeIDFor:, & ReferenceStream>>isAReferenceType:"

        "DataStream initialize"

        | refTypes t |

        refTypes := OrderedCollection new.
        t := TypeMap := Dictionary new: 80.     "sparse for fast hashing"
        t at: UndefinedObject put: 1. refTypes add: 0.
        t at: True put: 2. refTypes add: 0.
        t at: False put: 3. refTypes add: 0.
        t at: SmallInteger put: 4. refTypes add: 0.
        Smalltalk isSmalltalkX ifTrue:[
            t at: String put: 5. refTypes add: 1.
            t at: ImmutableString put: 5.
        ] ifFalse:[
            t at: ByteString put: 5. refTypes add: 1.
        ].
        t at: Symbol put: 6. refTypes add: 1.
        t at: ByteArray put: 7. refTypes add: 1.
        Smalltalk isSmalltalkX ifTrue:[
            t at: ImmutableByteArray put: 7.
        ].
        t at: Array put: 8. refTypes add: 1.
        Smalltalk isSmalltalkX ifTrue:[
            t at: ImmutableArray put: 8.
        ].
        "(type ID 9 is for arbitrary instances of any class, cf. typeIDFor:)"
        refTypes add: 1.
        "(type ID 10 is for references, cf. ReferenceStream>>tryToPutReference:)"
        refTypes add: 0.
        Smalltalk isSmalltalkX ifTrue:[
            refTypes add: 1.
        ] ifFalse:[
            t at: Bitmap put: 11.
            refTypes add: 1.
        ].
        t at: Metaclass put: 12.
        refTypes add: 0.
        "Type ID 13 is used for HyperSqueak User classes that must be reconstructed."
        refTypes add: 1.
        t at: Float put: 14. refTypes add: 1.
        Smalltalk isSmalltalkX ifTrue:[
            refTypes add: 1.
        ] ifFalse:[
            t at: Rectangle put: 15.
            refTypes add: 1.        "Allow compact Rects."
        ].

        "type ID 16 is an instance with short header.  See beginInstance:size:"
        refTypes add: 1.
"/        self flag: #ByteArray.

        t at: String put: 17. refTypes add: 1.        "new String format, 1 or 4 bytes of length"
"/        t at: WordArray put: 18.
"/        refTypes add: 1.        "bitmap-like"
"/        t at: WordArrayForSegment put: 19.
"/        refTypes add: 1.        "bitmap-like"
"/        Smalltalk globals
"/                at: #SoundBuffer
"/                ifPresent: [ :class |
"/                        t at: class put: 20.
"/                        refTypes add: 1 "And all other word arrays, both
"/                16-bit and 32-bit.  See methods in ArrayedCollection.  Overridden in SoundBuffer." ].
"/        t at: CompiledMethod put: 21.
"/        refTypes add: 1.        "special creation method"       "t at:  put: 22.  refTypes add: 0."
"/

"/        ReferenceStream refTypes: refTypes.     "save it"       "For all classes that are like WordArrays, store them the way ColorArray is stored.  As bits, and able to change endianness."

        Smalltalk allClassesDo: [ :cls |
            (cls isPointers not 
            and:[ cls isVariable 
            and:[ cls isWords or:[cls isLongs or:[cls isSignedWords or:[cls isSignedLongs]]]]]) ifTrue: [
                (t includesKey: cls) ifFalse: [ t at: cls put: 20 ]
            ]
        ]

    "Created: / 07-06-2016 / 11:20:01 / cg"
! !

!DataStream class methodsFor:'instance creation'!

fileNamed: aString
	"Here is the way to use DataStream and ReferenceStream:
rr := ReferenceStream fileNamed: 'test.obj'.
rr nextPut: <your object>.
rr close.
"

	| strm |
	strm := self on: (FileStream fileNamed: aString).               "will be binary"
	strm byteStream setFileTypeToObject.
		"Type and Creator not to be text, so can attach correctly to an email msg"
	^ strm
!

new
    TypeMap isNil ifTrue:[
        self initializeTypeMaps
    ].
    ^ self basicNew

    "Modified: / 07-06-2016 / 11:20:30 / cg"
!

newFileNamed: aString
	"Here is the way to use DataStream and ReferenceStream:
rr := ReferenceStream fileNamed: 'test.obj'.
rr nextPut: <your object>.
rr close.
"

	| strm |
	strm :=  self on: (FileStream newFileNamed: aString).           "will be binary"
	strm byteStream setFileTypeToObject.
		"Type and Creator not to be text, so can attach correctly to an email msg"
	^ strm
!

oldFileNamed: aString
	"Here is the way to use DataStream and ReferenceStream:
rr := ReferenceStream oldFileNamed: 'test.obj'.
^ rr nextAndClose.
"

	| strm ff |
	ff := FileStream oldFileOrNoneNamed: aString.
	ff ifNil: [^ nil].
	strm := self on: (ff binary).
	^ strm
!

on: aStream
        "Open a new DataStream onto a low-level I/O stream."

        ^ self new setStream: aStream
                "aStream binary is in setStream:"

    "Modified: / 07-06-2016 / 11:20:39 / cg"
! !

!DataStream class methodsFor:'cleanup'!

cleanUp
	"Re-initialize DataStream to avoid hanging onto obsolete classes"

	self initialize
! !

!DataStream class methodsFor:'marshalling'!

streamedRepresentationOf: anObject

	| file |
	file := (RWBinaryOrTextStream on: (ByteArray new: 5000)).
	file binary.
	(self on: file) nextPut: anObject.
	^file contents
!

unStream: aString

	^(self on: ((RWBinaryOrTextStream with: aString) reset; binary)) next
! !

!DataStream class methodsFor:'testing support'!

testWith: anObject
        "As a test of DataStream/ReferenceStream, write out anObject and read it back.
        11/19/92 jhm: Set the file type. More informative file name."
        "DataStream testWith: 'hi'"
        "ReferenceStream testWith: 'hi'"
        | file result |

        file := FileStream newFileNamed: (self name, '_test').
        file binary.
        (self on: file) nextPut: anObject.
        file close.

        file := FileStream fileNamed: (self name, '_test').
        file binary.
        result := (self on: file) next.
        file close.
        ^ result

    "Modified: / 07-06-2016 / 11:23:12 / cg"
! !

!DataStream methodsFor:'other'!

atEnd
    "Answer true if the stream is at the end."

    ^ byteStream atEnd
!

byteStream
	^ byteStream
!

close
	"Close the stream."

	| bytes |
	byteStream closed
		ifFalse: [
			bytes := byteStream position.
			byteStream close]
		ifTrue: [bytes := 'unknown'].
	^ bytes
!

contents
	^byteStream contents
!

errorWriteReference: anInteger
    "PRIVATE -- Raise an error because this case of nextPut:'s perform:
     shouldn't be called. -- 11/15/92 jhm"

    self error: 'This should never be called'
!

flush
    "Guarantee that any writes to me are actually recorded on disk. -- 11/17/92 jhm"

    ^ byteStream flush
!

next: anInteger
    "Answer an Array of the next anInteger objects in the stream."
    | array |

    array := Array new: anInteger.
    1 to: anInteger do: [:i |
	array at: i put: self next].
    ^ array
!

nextAndClose
	"Speedy way to grab one object.  Only use when we are inside an object binary file.  Do not use for the start of a SmartRefStream mixed code-and-object file."

	| obj |
	obj := self next.
	self close.
	^ obj
!

project
	^nil
!

reset
    "Reset the stream."

    byteStream reset
!

rootObject
	"Return the object at the root of the tree we are filing out.  "

	^ topCall
!

rootObject: anObject
	"Return the object at the root of the tree we are filing out.  "

	topCall := anObject
!

setStream: aStream
	"PRIVATE -- Initialization method."

	aStream binary.
	basePos := aStream position.    "Remember where we start.  Earlier part of file contains a class or method file-in.  Allow that to be edited.  We don't deal in absolute file locations."
	byteStream := aStream.
!

setStream: aStream reading: isReading
	"PRIVATE -- Initialization method."

	aStream binary.
	basePos := aStream position.    "Remember where we start.  Earlier part of file contains a class or method file-in.  Allow that to be edited.  We don't deal in absolute file locations."
	byteStream := aStream.
!

size
    "Answer the stream's size."

    ^ byteStream size
!

vacantRef
        "Answer the magic 32-bit constant we use ***ON DISK*** as a stream 'reference
         position' to identify a reference that's not yet filled in. This must be a
         value that won't be used as an ordinary reference. Cf. outputReference: and
         readReference. --
         NOTE: We could use a different type ID for vacant-refs rather than writing
                object-references with a magic value. (The type ID and value are
                overwritten by ordinary object-references when weak refs are fulfilled.)"

        ^ SmallInteger maxVal

    "Modified (comment): / 25-11-2017 / 22:26:04 / cg"
! !

!DataStream methodsFor:'write and read'!

beginInstance: aClass size: anInteger
	"This is for use by storeDataOn: methods.
	 Cf. Object>>storeDataOn:."

		"Addition of 1 seems to make extra work, since readInstance
		has to compensate.  Here for historical reasons dating back
		to Kent Beck's original implementation in late 1988.

		In ReferenceStream, class is just 5 bytes for shared symbol.

		SmartRefStream puts out the names and number of class's instances variables for checking."

	byteStream nextNumber: 4 put: anInteger + 1.

	self nextPut: aClass name
!

beginReference: anObject
    "We're starting to read anObject. Remember it and its reference
     position (if we care; ReferenceStream cares). Answer the
     reference position."

    ^ 0
!

getCurrentReference
    "PRIVATE -- Return the currentReference posn.
     Overridden by ReferenceStream."

    ^ 0
!

maybeBeginReference: internalObject
	"Do nothing.  See ReferenceStream|maybeBeginReference:"

	^ internalObject
!

next
        "Answer the next object in the stream."
        | type selector anObject isARefType pos internalObject |

        type := byteStream next.
        pos := byteStream position.        "absolute!!!!"
        type ifNil: [
                byteStream close.       "clean up"
                pos = 0
                        ifTrue: [self error: 'The file did not exist in this directory']
                        ifFalse: [self error: 'Unexpected end of object file'].
                pos.    "so can see it in debugger"
                ^ nil].
        type = 0 ifTrue: [
                byteStream close.       "clean up"
                self error: 'Expected start of object, but found 0'.
                ^ nil].
        isARefType := self noteCurrentReference: type.
        selector := #(readNil readTrue readFalse readInteger    "<-4"
                        readStringOld readSymbol readByteArray          "<-7"
                        readArray readInstance readReference readBitmap "<-11"
                        readClass readUser readFloat readRectangle readShortInst        "<-16"
                        readString readWordArray readWordArrayForSegment        "<-19"
                        readWordLike readMethod "<-21") at: type ifAbsent:[0].
        selector == 0 ifTrue: [
                        byteStream close.
                        self error: 'file is more recent than this system'. ^ nil].
        anObject := self perform: selector. "A method that recursively
                calls next (readArray, readInstance, objectAt:) must save &
                restore the current reference position."
        isARefType ifTrue: [self beginReference: anObject].

                "After reading the externalObject, internalize it.
                 #readReference is a special case. Either:
                   (1) We actually have to read the object, recursively calling
                           next, which internalizes the object.
                   (2) We just read a reference to an object already read and
                           thus already interalized.
                 Either way, we must not re-internalize the object here."
        selector == #readReference ifTrue: [^ anObject].
        internalObject := anObject comeFullyUpOnReload: self.
        internalObject == String ifTrue:[
                "This is a hack to figure out if we're loading a String class
                that really should be a ByteString. Note that these days this
                will no longer be necessary since we use #withClassVersion:
                for constructing the global thus using a different classVersion
                will perfectly do the trick."
                ((anObject isKindOf: DiskProxy)
                        and:[anObject globalObjectName == #String
                        and:[anObject constructorSelector == #yourself]]) ifTrue:[
                                internalObject := ByteString]].
        ^ self maybeBeginReference: internalObject

    "Modified: / 07-06-2016 / 11:48:53 / cg"
!

nextPut: anObject
        "Write anObject to the receiver stream. Answer anObject."
        | typeID selector objectToStore |

        typeID := self typeIDFor: anObject.
        (self tryToPutReference: anObject typeID: typeID)
                ifTrue: [^ anObject].

        objectToStore := (self objectIfBlocked: anObject) objectForDataStream: self.
        objectToStore == anObject ifFalse: [typeID := self typeIDFor: objectToStore].

        byteStream nextPut: typeID.
        selector := #(writeNil: writeTrue: writeFalse: writeInteger: "4"
                writeStringOld: writeSymbol: writeByteArray:         "7"
                writeArray: writeInstance: errorWriteReference: writeBitmap:  "11"
                writeClass: writeUser: writeFloat: writeRectangle: == "<-16 short inst"
                writeString: writeBitmap: writeBitmap: writeWordLike:  "20"
                writeInstance: "CompiledMethod"                        "21"
            ) at: typeID.
        self perform: selector with: objectToStore.

        ^ anObject


"NOTE: If anObject is a reference type (one that we write cross-references to) but its externalized form (result of objectForDataStream:) isn't (e.g. CompiledMethod and ViewState), then we should remember its externalized form
 but not add to 'references'. Putting that object again should just put its
 external form again. That's more compact and avoids seeks when reading.
 But we just do the simple thing here, allowing backward-references for
 non-reference types like nil. So objectAt: has to compensate. Objects that
 externalize nicely won't contain the likes of ViewStates, so this shouldn't
 hurt much.
         writeReference: -> errorWriteReference:."
!

nextPutAll: aCollection
    "Write each of the objects in aCollection to the
     receiver stream. Answer aCollection."

    ^ aCollection do: [:each | self nextPut: each]
!

noteCurrentReference: typeID
    "PRIVATE -- If we support references for type typeID, remember
     the current byteStream position so we can add the next object to
     the 'objects' dictionary, and return true. Else return false.
     This method is here to be overridden by ReferenceStream"

    ^ false
!

objectAt: anInteger
	"PRIVATE -- Read & return the object at a given stream position.  08:18 tk  anInteger is a relative file position. "
	| savedPosn anObject refPosn |

	savedPosn := byteStream position.       "absolute"
	refPosn := self getCurrentReference.    "relative position"

	byteStream position: anInteger + basePos.       "was relative"
	anObject := self next.

	self setCurrentReference: refPosn.      "relative position"
	byteStream position: savedPosn.         "absolute"
	^ anObject
!

objectIfBlocked: anObject
	"We don't do any blocking"

	^ anObject
!

outputReference: referencePosn
	"PRIVATE -- Output a reference to the object at integer stream position referencePosn (relative to basePos). To output a weak reference to an object not yet written, supply (self vacantRef) for referencePosn."

	byteStream nextPut: 10. "reference typeID"
	byteStream nextNumber: 4 put: referencePosn     "relative position"
!

readArray
        "PRIVATE -- Read the contents of an Array.
         We must do beginReference: here after instantiating the Array
         but before reading its contents, in case the contents reference
         the Array. beginReference: will be sent again when we return to
         next, but that's ok as long as we save and restore the current
         reference position over recursive calls to next."
        | count array refPosn |

        count := byteStream nextNumber: 4.

        refPosn := self beginReference: (array := Array new: count).            "relative pos"
        1 to: count do: [:i |
            |el|
            el := self next.
            array at: i put: el
        ].
        self setCurrentReference: refPosn.              "relative pos"
        ^ array

    "Modified: / 14-09-2010 / 13:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-06-2016 / 11:54:19 / cg"
!

readBitmap
	"PRIVATE -- Read the contents of a Bitmap."

	^ Bitmap newFromStream: byteStream
	"Note that the reader knows that the size is in long words, but the data is in bytes."
!

readBoolean
	"PRIVATE -- Read the contents of a Boolean.
	 This is here only for compatibility with old data files."

	^ byteStream next ~= 0
!

readByteArray
	"PRIVATE -- Read the contents of a ByteArray."

	| count |
	count := byteStream nextNumber: 4.
	^ byteStream next: count  "assume stream is in binary mode"
!

readClass
        "Should never be executed because a DiskProxy, not a class comes in."

        ^ self error: 'Classes should be filed in'

    "Modified (comment): / 09-11-2017 / 09:58:24 / mawalch"
!

readFalse
    "PRIVATE -- Read the contents of a False."

    ^ false
!

readFloat
	"PRIVATE -- Read the contents of a Float.
	 This is the fast way to read a Float.
	 We support 8-byte Floats here.  Non-IEEE"

	| new |

	Smalltalk isSmalltalkX ifTrue:[
	    new := Float basicNew.            "To get an instance"
	    1 to:8 do:[:i | new basicAt:i put:(byteStream nextByte) ].
	    ^ new
	].

	new := Float new: 2.            "To get an instance"
	new at: 1 put: (byteStream nextNumber: 4).
	new at: 2 put: (byteStream nextNumber: 4).
	^ new

    "Modified: / 25-11-2011 / 16:11:39 / cg"
!

readFloatString
	"PRIVATE -- Read the contents of a Float string.
	 This is the slow way to read a Float--via its string rep'n.
	 It's here for compatibility with old data files."

	^ Float readFrom: (byteStream next: (byteStream nextNumber: 4))
!

readInstance
        "PRIVATE -- Read the contents of an arbitrary instance.
         ASSUMES: readDataFrom:size: sends me beginReference: after it
           instantiates the new object but before reading nested objects.
         NOTE: We must restore the current reference position after
           recursive calls to next.
        Let the instance, not the class read the data.  "

        | instSize aSymbol refPosn anObject newClass |
        instSize := (byteStream nextNumber: 4) - 1.
        refPosn := self getCurrentReference.
        aSymbol := self next.
        newClass := Smalltalk globals at: aSymbol asSymbol.
        newClass hasImmutableInstances ifTrue:[
            newClass := newClass mutableClass.
        ].
        anObject := newClass isVariable
                ifFalse: [ newClass basicNew ]
                ifTrue: [ newClass basicNew: instSize - newClass instSize ].    "Create object here"
        self setCurrentReference: refPosn.      "before readDataFrom:size:"
        anObject := anObject readDataFrom: self size: instSize.
        self setCurrentReference: refPosn.      "before returning to next"
        ^ anObject

    "Modified: / 07-06-2016 / 11:33:53 / cg"
!

readInteger
    "PRIVATE -- Read the contents of a SmallInteger."

    ^ byteStream nextInt32MSB:true "/ nextInt32      "signed!!!!!!"

    "Modified: / 08-02-2012 / 14:31:37 / cg"
!

readMethod
	"PRIVATE -- Read the contents of an arbitrary instance.
	 ASSUMES: readDataFrom:size: sends me beginReference: after it
	   instantiates the new object but before reading nested objects.
	 NOTE: We must restore the current reference position after
	   recursive calls to next.
	Let the instance, not the class read the data.  "

	| instSize refPosn newClass className xxHeader nLits byteCodeSizePlusTrailer newMethod lits |
	instSize := (byteStream nextNumber: 4) - 1.
	refPosn := self getCurrentReference.
	className := self next.
	newClass := Smalltalk globals at: className asSymbol.
	xxHeader := self next.  "nArgs := (xxHeader >> 24) bitAnd: 16rF."       "nTemps := (xxHeader >> 18) bitAnd: 16r3F."     "largeBit := (xxHeader >> 17) bitAnd: 1."
	nLits := xxHeader >> 9 bitAnd: 16rFF.   "primBits := ((xxHeader >> 19) bitAnd: 16r600) + (xxHeader bitAnd: 16r1FF)."
	byteCodeSizePlusTrailer := instSize - newClass instSize - ((nLits + 1) * 4).    "0"
	newMethod := newClass newMethod: byteCodeSizePlusTrailer header: xxHeader.
	self setCurrentReference: refPosn.      "before readDataFrom:size:"
	self beginReference: newMethod.
	lits := newMethod numLiterals + 1.      "counting header"
	2 to: lits do: [ :ii | newMethod objectAt: ii put: self next ].
	lits * 4 + 1 to: newMethod basicSize do: [ :ii | newMethod basicAt: ii put: byteStream next ].  "Get raw bytes directly from the file"
	self setCurrentReference: refPosn.      "before returning to next"
	^ newMethod
!

readNil
    "PRIVATE -- Read the contents of an UndefinedObject."

    ^ nil
!

readRectangle
    "Read a compact Rectangle.  
     Rectangles with values outside +/- 2047 were stored as normal objects (type=9).  
     They will not come here.  17:22 tk"

        "Encoding is four 12-bit signed numbers.  48 bits in next 6 bytes.  17:24 tk"
        | acc left top right bottom |
        acc := byteStream nextNumber: 3.
        left := acc bitShift: -12.
        (left bitAnd: 16r800) ~= 0 ifTrue: [left := left - 16r1000].    "sign"
        top := acc bitAnd: 16rFFF.
        (top bitAnd: 16r800) ~= 0 ifTrue: [top := top - 16r1000].       "sign"

        acc := byteStream nextNumber: 3.
        right := acc bitShift: -12.
        (right bitAnd: 16r800) ~= 0 ifTrue: [right := right - 16r1000]. "sign"
        bottom := acc bitAnd: 16rFFF.
        (bottom bitAnd: 16r800) ~= 0 ifTrue: [bottom := bottom - 16r1000].      "sign"

    ^ Rectangle left: left right: right top: top bottom: bottom
!

readReference
	"Read the contents of an object reference. (Cf. outputReference:)  File is not now positioned at this object."
	| referencePosition |

	^ (referencePosition := (byteStream nextNumber: 4)) = self vacantRef    "relative"
		ifTrue:  [nil]
		ifFalse: [self objectAt: referencePosition]             "relative pos"
!

readShortInst
	"Read the contents of an arbitrary instance that has a short header.
	 ASSUMES: readDataFrom:size: sends me beginReference: after it
	   instantiates the new object but before reading nested objects.
	 NOTE: We must restore the current reference position after
	   recursive calls to next.
	Let the instance, not the class read the data.  "

	| instSize aSymbol refPosn anObject newClass |
	instSize := byteStream next - 1.        "one byte of size"
	refPosn := self getCurrentReference.
	aSymbol := self readShortRef.   "class symbol in two bytes of file pos"
	newClass := Smalltalk globals at: aSymbol asSymbol.
	anObject := newClass isVariable
		ifFalse: [ newClass basicNew ]
		ifTrue: [ newClass basicNew: instSize - newClass instSize ].    "Create object here"
	self setCurrentReference: refPosn.      "before readDataFrom:size:"
	anObject := anObject readDataFrom: self size: instSize.
	self setCurrentReference: refPosn.      "before returning to next"
	^ anObject
!

readShortRef
	"Read an object reference from two bytes only.  Original object must be in first 65536 bytes of the file.  Relative to start of data.  vacantRef not a possibility."

	^ self objectAt: (byteStream nextNumber: 2)
!

readString

	| str |
	"byteStream ascii."
	str := byteStream nextSqueakString "nextString".
	"byteStream binary."
	^ str

    "Modified: / 12-09-2010 / 13:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2012 / 14:25:01 / cg"
!

readStringOld

   ^ byteStream nextSqueakStringOld

    "Modified: / 08-02-2012 / 14:30:28 / cg"
!

readSymbol
    "PRIVATE -- Read the contents of a Symbol."
    ^ self readString asSymbol
!

readTrue
    "PRIVATE -- Read the contents of a True."

    ^ true
!

readUser
	"Reconstruct both the private class and the instance.  Still used??"

	^ self readInstance.            "Will create new unique class"
!

readWordArray
	"PRIVATE -- Read the contents of a WordArray."

	^ WordArray newFromStream: byteStream
	"Size is number of long words."
!

readWordArrayForSegment
	"Read the contents of a WordArray ignoring endianness."

	^ WordArrayForSegment newFromStream: byteStream
	"Size is number of long words."
!

readWordLike
        | refPosn aSymbol newClass anObject len|

        "Can be used by any class that is bits and not bytes (WordArray, Bitmap, SoundBuffer, etc).
         Also used to write SignedWordArray, LongArray, SignedLongArray, Unicode16Strings and Unicode32Strings.
         Note that we read the class name before the size."

        refPosn := self getCurrentReference.
        aSymbol := self next.
        aSymbol == #WideString ifTrue:[aSymbol := #Unicode16String].  "/ as coming from Squeak
        newClass := Smalltalk globals at: aSymbol asSymbol.
        byteStream peek == 16r80 ifTrue:[
            self error:'Compressed format, not supported (even by Squeak/Pharo :-)'.
            ^self.
        ].
        len := byteStream nextInt32MSB: true. "nextInt32"
        anObject := newClass new: len.
        1 to: len do:[:i|
            anObject at: i put: (byteStream nextInt32MSB: true "nextInt32")
        ].
        self setCurrentReference: refPosn.      "before returning to next"
        ^ anObject

    "Modified: / 22-08-2011 / 23:15:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2012 / 14:32:18 / cg"
!

replace: original with: proxy
	"We may wish to remember that in some field, the original object is being replaced by the proxy.  For the hybred scheme that collects with a DummyStream and writes an ImageSegment, it needs to hold onto the originals so they will appear in outPointers, and be replaced."

	"do nothing"
!

setCurrentReference: refPosn
    "PRIVATE -- Set currentReference to refPosn.
     Noop here. Cf. ReferenceStream."
!

tryToPutReference: anObject typeID: typeID
    "PRIVATE -- If we support references for type typeID, and if
       anObject already appears in my output stream, then put a
       reference to the place where anObject already appears. If we
       support references for typeID but didn't already put anObject,
       then associate the current stream position with anObject in
       case one wants to nextPut: it again.
     Return true after putting a reference; false if the object still
       needs to be put.
     For DataStream this is trivial. ReferenceStream overrides this."

    ^ false
!

typeIDFor: anObject
        "Return the typeID for anObject's class.  
        This is where the tangle of objects is clipped to stop everything from going out.
        Classes can control their instance variables by defining objectToStoreOnDataStream.
        Any object in blockers is not written out.  See ReferenceStream.objectIfBlocked: and DataStream nextPut:.
        Morphs do not write their owners.  See Morph.storeDataOn:   Each morph tells itself to 'prepareToBeSaved' before writing out."

        TypeMap isNil ifTrue:[
            self class initializeTypeMaps
        ].
        ^ TypeMap at: anObject class ifAbsent: [9 "instance of any normal class"]
"See DataStream initialize.  
    nil=1. 
    true=2.     
    false=3. 
    a SmallInteger=4. 
    (a String was 5). 
    a Symbol=6.  
    a ByteArray=7. 
    an Array=8. 
    other = 9.  
    a Bitmap=11. 
    a Metaclass=12. 
    a Float=14.  
    a Rectangle=15. any instance that can have a short header=16.  
    a String=17 (new format). 
    a WordArray=18."

    "Modified: / 07-06-2016 / 12:00:13 / cg"
!

writeArray: anArray
        "PRIVATE -- Write the contents of an Array."

        byteStream nextNumber: 4 put: anArray size.
        self nextPutAll: anArray.
!

writeBitmap: aBitmap
	"PRIVATE -- Write the contents of a Bitmap."

	aBitmap writeOn: byteStream
	"Note that this calls (byteStream nextPutAll: aBitmap) which knows enough to put 4-byte quantities on the stream!!  Reader must know that size is in long words."
!

writeBoolean: aBoolean
    "PRIVATE -- Write the contents of a Boolean.
     This method is now obsolete."

    byteStream nextPut: (aBoolean ifTrue: [1] ifFalse: [0])
!

writeByteArray: aByteArray
	"PRIVATE -- Write the contents of a ByteArray."

	byteStream nextNumber: 4 put: aByteArray size.
	"May have to convert types here..."
	byteStream nextPutAll: aByteArray.
!

writeClass: aClass
    "Write out a DiskProxy for the class.  
     It will look up the class's name in Smalltalk in the new sustem.  
     Never write classes or methodDictionaries as objects.  
     For novel classes, front part of file is a fileIn of the new class."

        "This method never executed because objectToStoreOnDataStream returns a DiskProxy.  See DataStream.nextPut:"
    ^ self error: 'Write a DiskProxy instead'
!

writeFalse: aFalse
    "PRIVATE -- Write the contents of a False."
!

writeFloat: aFloat
	"PRIVATE -- Write the contents of a Float.
	  We support 8-byte Floats here."

	Smalltalk isSmalltalkX ifTrue:[
	    1 to:8 do:[:i | byteStream nextPutByte:(aFloat basicAt:i) ].
	] ifFalse:[
	    byteStream nextNumber: 4 put: (aFloat at: 1).
	    byteStream nextNumber: 4 put: (aFloat at: 2).
	]

    "Modified: / 25-11-2011 / 16:12:17 / cg"
!

writeFloatString: aFloat
    "PRIVATE -- Write the contents of a Float string.
     This is the slow way to write a Float--via its string rep'n."

    self writeByteArray: (aFloat printString)
!

writeInstance: anObject
    "PRIVATE -- Write the contents of an arbitrary instance."

    ^ anObject storeDataOn: self
!

writeInteger: anInteger
        "PRIVATE -- Write the contents of a SmallInteger."

    Smalltalk isSmalltalkX ifTrue:[
        byteStream nextPutInt32:anInteger MSB:true.
    ] ifFalse:[
        byteStream nextInt32Put: anInteger      "signed!!!!!!!!!!"
    ]

    "Modified: / 27-12-2011 / 10:17:27 / cg"
!

writeNil: anUndefinedObject
    "PRIVATE -- Write the contents of an UndefinedObject."
!

writeRectangle: anObject
    "Write the contents of a Rectangle.  See if it can be a compact Rectangle (type=15).  
     Rectangles with values outside +/- 2047 were stored as normal objects (type=9).  17:22 tk"

        | ok right bottom top left acc |
        ok := true.
        (right := anObject right) > 2047 ifTrue: [ok := false].
        right < -2048 ifTrue: [ok := false].
        (bottom := anObject bottom) > 2047 ifTrue: [ok := false].
        bottom < -2048 ifTrue: [ok := false].
        (top := anObject top) > 2047 ifTrue: [ok := false].
        top < -2048 ifTrue: [ok := false].
        (left := anObject left) > 2047 ifTrue: [ok := false].
        left < -2048 ifTrue: [ok := false].
        ok := ok & left isInteger & right isInteger & top isInteger & bottom isInteger.

        ok ifFalse: [
                byteStream skip: -1; nextPut: 9; skip: 0. "rewrite type to be normal instance"
            ^ anObject storeDataOn: self].

        acc := ((left bitAnd: 16rFFF) bitShift: 12) + (top bitAnd: 16rFFF).
        byteStream nextNumber: 3 put: acc.
        acc := ((right bitAnd: 16rFFF) bitShift: 12) + (bottom bitAnd: 16rFFF).
        byteStream nextNumber: 3 put: acc.
!

writeString: aString
	"PRIVATE -- Write the contents of a String."

	byteStream nextPutSqueakString: aString.

    "Modified: / 08-02-2012 / 14:30:58 / cg"
!

writeStringOld: aString
	"PRIVATE -- Write the contents of a String."

	| length |
	aString size < 16384
		ifTrue: [
			(length := aString size) < 192
				ifTrue: [byteStream nextPut: length]
				ifFalse:
					[byteStream nextPut: (length // 256 + 192).
					byteStream nextPut: (length \\ 256)].
			aString do: [:char | byteStream nextPut: char codePoint]]
		ifFalse: [self writeByteArray: aString].        "takes more space"
!

writeSymbol: aSymbol
    "PRIVATE -- Write the contents of a Symbol."

    self writeString: aSymbol
!

writeTrue: aTrue
    "PRIVATE -- Write the contents of a True."
!

writeUser: anObject
    "Write the contents of an arbitrary User instance (and its devoted class)."
    " 7/29/96 tk"

	"If anObject is an instance of a unique user class, will lie and say it has a generic class"
    ^ anObject storeDataOn: self
!

writeWordLike: aWordArray
        "used to write WordArray, SignedWordArray, LongArray, SignedLongArray,
         Unicode16Strings and Unicode32Strings.
         Note that we put the class name before the size."

        |nm|

        nm := aWordArray class name.
        nm == #Unicode16String ifTrue:[ nm := #WideString ]. "/ as expected by Squeak
        self nextPut: nm.

        "/ word in Squeak means 4-byte ints (here: 4byte entries are written, even for word-sized elements)
        Smalltalk isSmalltalkX ifTrue:[
            byteStream nextPutInt32:aWordArray size MSB:true.
            aWordArray do:[:e|
                byteStream nextPutInt32: e asInteger  MSB:true.
            ].
        ] ifFalse:[
            byteStream nextInt32Put: aWordArray size.
            aWordArray do:[:e|
                byteStream nextInt32Put: e asInteger.
            ].
            "Note that this calls (byteStream nextPutAll: aBitmap) which knows enough to put 4-byte quantities on the stream!!  
             Reader must know that size is in long words or double-bytes."
        ].

    "Modified: / 22-08-2011 / 23:43:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DataStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/DataStream.st,v 1.19 2018-05-15 16:09:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/DataStream.st,v 1.19 2018-05-15 16:09:03 cg Exp $'
!

version_SVN
    ^ '$Id: DataStream.st,v 1.19 2018-05-15 16:09:03 cg Exp $'
! !

