"{ Encoding: utf8 }"

"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help


 Original authors note:

 Hopefully someone will be able to adapt this for Smalltalk-V (if needed).
 I place NO restrictions on the use of this code.

 Here it is; Share And Enjoy!!

 Eliot Miranda                           email:          eliot@cs.qmc.ac.uk
 Dept of Computer Science                Tel:            01 975 5220
 Queen Mary College                      International:  +44 1 975 5220
 Mile End Road
 LONDON E1 4NS

 Claus: adapted to ST/X, compacted the format, added error handling
	and tuned here and there ...
"
"{ Package: 'stx:libboss' }"

"{ NameSpace: Smalltalk }"

BinaryIOManager subclass:#BinaryInputManager
	instanceVariableNames:'idToObjectMapping fixIdToObjectMapping stream lastId
		newToOldClassMapping allowGlobalExpressions'
	classVariableNames:''
	poolDictionaries:''
	category:'System-BinaryStorage'
!

!BinaryInputManager class methodsFor:'documentation'!

copyright
"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help


 Original authors note:

 Hopefully someone will be able to adapt this for Smalltalk-V (if needed).
 I place NO restrictions on the use of this code.

 Here it is; Share And Enjoy!!

 Eliot Miranda                           email:          eliot@cs.qmc.ac.uk
 Dept of Computer Science                Tel:            01 975 5220
 Queen Mary College                      International:  +44 1 975 5220
 Mile End Road
 LONDON E1 4NS

 Claus: adapted to ST/X, compacted the format, added error handling
	and tuned here and there ...
"
!

documentation
"
    I read binary files of the format created by BinaryOutputManager.  
    See the BinaryOutputManager>>binaryObjectFormat for details of the format.  
    Use

        BinaryInputManager readFrom:'filename.stbin'

    or:
        BinaryInputManager readFrom:someStream

    to recreate the objects stored on such files.
    (but see the classes BinaryObjectStorage and PersitencyManager
     for higher level interfaces to this mechanism).

    you can also read individual objects by:

        |manager|

        manager := BinaryInputManager on:someStreamOrFilename.
        o1 := manager nextObject.
        o2 := manager nextObject.
        ...

    This class is based on a manchester goody, but has been adapted and
    enhanced quite a bit. See copyright.

    Added value:
        error handling for obsolete objects,
        a more compact format for common objects (strings, numbers etc),
        much tuning,
        configurable ID-keeping
        flush codes (for object transmitting over a stream)

    [author:]
        Eliot Miranda (eliot@cs.qmc.ac.uk)
        Claus Gittinger

    [See also:]
        BinaryObjectStorage ObsoleteObject
        PersistencyManager
        Object
        (binary object storage : programming/binaryStore.html )
"
!

examples
"
    See examples in BinaryOutputManager
"

! !

!BinaryInputManager class methodsFor:'instance creation'!

new
    "return a manager for reading"

     ^ self basicNew initialize

    "Modified: / 1.11.1997 / 16:53:57 / cg"
!

on:streamOrFileName
    "return a manager for reading streamOrFileName.
     If the argument is not a stream, it is assumed to be the name 
     of a file which is to be opened for reading."

     ^ self new on:streamOrFileName
! !

!BinaryInputManager class methodsFor:'binary storage'!

readFrom:streamOrFileName
    "Reads an object from the stream streamOrFileName
     or the file named streamOrFileName. 
     If the argument is not a stream, it is assumed to be the name 
     of a file which is to be opened for reading and closed afterwards.
     If it's a stream, it will remain open and positioned after the
     object's definition (after the read)."

     ^ self new readFrom:streamOrFileName

    "Modified (comment): / 13-02-2017 / 19:55:58 / cg"
!

readFrom:streamOrFileName using:anIdToObjectMapping
    "Reads an object from the stream streamOrFileName
     or the file named streamOrFileName.
     If the argument is not a stream, it is assumed to be the name
     of a file which is to be opened for reading and closed afterwards.
     If it is a stream, it will remain open and positioned after the
     object's definition (after the read).
     The mapping argument contains fix id->object
     mappings, which is used while reading. (i.e. objects 
     contained there are loaded by id - not by value)"

    |mgr|

    mgr := self new.
    mgr fixIdToObjectMapping:anIdToObjectMapping.
    ^ mgr readFrom:streamOrFileName

    "Created: / 02-11-1997 / 11:11:02 / cg"
    "Modified (comment): / 13-02-2017 / 19:56:02 / cg"
    "Modified (comment): / 23-05-2017 / 16:09:24 / mawalch"
! !

!BinaryInputManager methodsFor:'error handling'!

replacementClassFor:sym signature:sig instVarNames:instVarString
    "return a replacement class"

    |type meta cls|

    type := Class instTypeFromSignature:sig.

    "create the metaclass first"
    meta := Metaclass new.
    meta setSuperclass:(ObsoleteObject class).
    meta instSize:(ObsoleteObject class instSize).

    "then let the new meta create the class"
    cls := meta new.
    cls setSuperclass:ObsoleteObject.
    cls instSize:instVarString countWords.
    cls setName:sym.
    cls flags:type.
    cls setClassVariableString:''.
    cls setInstanceVariableString:instVarString.
    cls setCategory:#'* obsolete *'.
    ^ cls

    "Modified: 10.9.1996 / 20:01:22 / cg"
    "Modified: 1.4.1997 / 15:42:35 / stefan"
! !

!BinaryInputManager methodsFor:'initialization'!

allowGlobalExpressions:aBoolean
    "globals are stored as Smalltalk expressions.
     This may open a security hole, when binary objects
     are read from alien sources.
     By default, this is enabled for backward compatibility.
     Should be disabled, if bianry data is read from untrusted sources"

    allowGlobalExpressions := aBoolean
!

initialize
    <modifier: #super> "must be called if redefined"

    usedFormat := FormatVersion.
    idToObjectMapping := IdentityDictionary new.
    allowGlobalExpressions := true.

    "Created: / 01-11-1997 / 17:51:03 / cg"
    "Modified: / 08-02-2017 / 00:33:20 / cg"
! !

!BinaryInputManager methodsFor:'object reading'!

nextObject
    "read the next object. The first byte specifies how its
     encoded. SmallIntegers are special"

    |ret typeByte typeAction value|

    ret := self.
    "internal managment actions (flushXXX) return self"
    [ret == self] whileTrue:[

        typeByte := stream next.
        typeByte isNil ifTrue:[^ nil].

        "/ hacky optimization: nil is so common
"/        typeByte == 2 ifTrue:[
"/            ^ nil
"/        ].

        typeByte > 127 ifTrue: [
            "/ a 31 bit positive integer
            value := typeByte bitAnd:16r7F.
            value := (value bitShift:8) bitOr:stream next.
            value := (value bitShift:8) bitOr:stream next.
            value := (value bitShift:8) bitOr:stream next.
            ^ value
        ].

        (typeByte between:1 and:TypeTableArray size) ifFalse:[
            "
             this signal is raised if an invalid typecode is encountered.
             Typically, this happens when a non bos-stream, or a stream
             written by an incompatible bos-utility or a corrupted bos stream
             is read.
             Sorry, there is no chance to get those objects into the system ...
            "
            ^ InvalidBinaryFormatErrorSignal 
                  raiseRequestWith:typeByte
                  errorString:('invalid (incompatible) binary format code=' , typeByte printString)
        ].
        typeAction := TypeTableArray at:typeByte.

        ret := self perform:typeAction.
    ]. 

    ^ ret.

    "Modified: / 11.3.1996 / 14:34:41 / stefan"
    "Modified: / 12.11.2001 / 18:56:54 / cg"
!

skipObject
    "skip the next object. Somewhat faster than nextObject, 
     since no real object is read for inline special objects.
     However, for full objects/classes the work has still to be done,
     since the object may later be referenced - and the information will
     then be needed."

    |typeByte| 

    typeByte := stream next.
    typeByte isNil ifTrue:[^ self].
    typeByte > 127 ifTrue: [
        stream skip:3.        "/ skip remaining value bytes
        ^ self
    ].

    (typeByte between:1 and:TypeSkipTableArray size) ifFalse:[
        "
         this signal is raised if an invalid typecode is encountered.
         Typically, this happens when a non bos-stream, or a stream
         written by an incompatible bos-utility or a corrupted bos stream
         is read.
         Sorry, there is no chance to get those objects into the system ...
        "
        ^ InvalidBinaryFormatErrorSignal 
              raiseRequestWith:typeByte
              errorString:'invalid (incompatible) binary format'
    ].
    self perform: (TypeSkipTableArray at: typeByte).
    ^ self

    "Modified: / 1.11.1997 / 19:11:44 / cg"
! !

!BinaryInputManager methodsFor:'private-flushing'!

flushClassIDs
    "remove all cached classID -> object associations."

    idToObjectMapping keysAndValuesDo:[:id :obj |
        obj isBehavior ifTrue:[
            idToObjectMapping safeRemoveKey:id
        ]
    ].
    idToObjectMapping possiblyShrink.

    "Modified: / 7.3.1996 / 11:18:41 / stefan"
    "Modified: / 2.11.1997 / 10:20:38 / cg"
!

flushIDs
    "remove all cached ID -> object associations."

    idToObjectMapping removeAll

    "Modified: / 7.3.1996 / 11:18:34 / stefan"
    "Modified: / 2.11.1997 / 10:20:46 / cg"
!

flushInstanceIDs
    "remove all cached non-classID -> object associations."

    idToObjectMapping keysAndValuesDo:[:id :obj |
        obj isBehavior ifFalse:[
            idToObjectMapping safeRemoveKey:id
        ]
    ].
    idToObjectMapping possiblyShrink.

    "Modified: / 7.3.1996 / 11:18:14 / stefan"
    "Modified: / 2.11.1997 / 10:20:53 / cg"
! !

!BinaryInputManager methodsFor:'private-structure reading'!

getArrayClass
    "the Array class"

    ^ Array

    "Modified: / 1.11.1997 / 19:52:17 / cg"
!

getArrayClassDef
    "get the Array class (encountered a ref to the Array class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:Array.
    ^ Array

    "Created: / 1.11.1997 / 19:42:43 / cg"
    "Modified: / 2.11.1997 / 10:18:59 / cg"
!

getBigInteger
    "get a bigInteger (64 bits)"

    |value|

"/    value := stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.
"/    value := (value bitShift: 8) bitOr: stream next.

    value := stream nextUnsignedInt64MSB:true.
    ^ value
!

getBigNegativeInteger
    "get a negative bigInteger (64 bits)"

    ^ self getBigInteger negated

    "Modified: 21.10.1997 / 18:39:02 / cg"
!

getByteArray
    "get a small byteArray (size = 0..255) "

    |len|

    len := stream next.
    ^ stream nextBytes:len.

    "Modified: / 2.11.1997 / 16:20:26 / cg"
!

getByteArrayClass
    "the ByteArray class"

    ^ ByteArray

    "Created: / 29.2.1996 / 00:10:48 / cg"
    "Modified: / 1.11.1997 / 19:52:45 / cg"
!

getByteArrayClassDef
    "get the ByteArray class (encountered a ref to the ByteArray class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:ByteArray.
    ^ ByteArray

    "Created: / 1.11.1997 / 19:43:02 / cg"
    "Modified: / 2.11.1997 / 10:19:02 / cg"
!

getByteInteger
    "get a 1-byte smallInteger"

    ^ stream next
!

getCharacter2Definition
    "get a 2-byte character"

    |ascii|

    ascii := stream nextUnsignedInt16MSB:true.
    ^ Character codePoint:ascii

    "Modified: 11.11.1996 / 17:33:27 / cg"
!

getCharacter3Definition
    "get a 3-byte character"

    |ascii|

    ascii := stream nextUnsignedInt24MSB:true.
    ^ Character codePoint:ascii
!

getCharacterDefinition
    "get a 1-byte character"

    ^ Character codePoint:stream next
!

getClass1Definition
    "read a classes definition with a 1-byte id"

    |id|

    id := stream next.
    ^ self getClassDefinition:id
!

getClass2Definition
    "read a classes definition with a 2-byte id"

    |id|

    id := stream nextUnsignedInt16MSB:true.
    ^ self getClassDefinition:id

    "Modified: 11.11.1996 / 17:33:34 / cg"
!

getClassDefinition
    "read a classes definition with a 3-byte id"

    |id|

    id := stream nextUnsignedInt24MSB:true. "/ id := stream nextNumber: 3.
    ^ self getClassDefinition:id
!

getClassDefinition:id
    "read a classes definition; the id has already been read"

    |nameLength name sym class signature value classLayoutOK
     varLength instVarString replacementClass actualSignature sig|

    signature := stream nextUnsignedInt32MSB:true. "/ stream nextNumber:4.
    varLength := stream nextUnsignedInt16MSB:true. "/ stream nextNumber:2.
    varLength ~~ 0 ifTrue:[
        instVarString := (stream nextString:varLength).
    ] ifFalse:[
        instVarString := ''
    ].
    nameLength := stream nextUnsignedInt16MSB:true. "/ stream nextNumber:2.
    name := (stream nextString:nameLength).

    (sym := name asSymbolIfInterned) notNil ifTrue:[
        class := Smalltalk at:sym ifAbsent:nil.
        class notNil ifTrue:[
            class isBehavior ifFalse:[
                class := nil.
            ]
        ].
    ].

    class notNil ifTrue:[
        "
         if it's an autoloaded class, load it here
        "
        class autoload.

        "
         if it's a built-in class, it must be compatible
        "
        class isBuiltInClass ifTrue:[
            id notNil ifTrue:[
                idToObjectMapping at:id put:class
            ].
            ^ class
        ]
    ].

    class isNil ifTrue:[
        "
         a class which no longer exists
        "
        replacementClass := self replacementClassFor:name asSymbol
                              signature:signature
                              instVarNames:instVarString.

        value := NonexistingClassSignal
                        raiseRequestWith:replacementClass
                        errorString:'non existing class: ' , name , ' (in binary load)'.
        "
         check again - maybe handler has repaired things.
         If so, it is supposed to return the class.
         If not, use the replacement class, which at least provides
         some environment for the restored object.
        "
        value isBehavior ifTrue:[
            class := value.
        ] ifFalse:[
            class := replacementClass
        ]
    ].

    "
     quick check if the classes layout is still the same
    "
    signature == class signature ifTrue:[
        id notNil ifTrue:[
            idToObjectMapping at:id put:class
        ].
        ^ class
    ].

    "
     no, find out what has changed ...
    "
    classLayoutOK := true.
    actualSignature := class signature.

    "
     classes signature has changed - check if its not a
     simple name change in the instvars
    "
    (Class instSizeFromSignature:signature) == (Class instSizeFromSignature:actualSignature) ifFalse:[
        "
         class has changed inst layout (number of named instvars)
        "
        classLayoutOK := false.
        sig := ChangedInstSizeSignal
    ] ifTrue:[
        "
         instances have the same size
        "
        (Class instTypeFromSignature:signature) == (Class instTypeFromSignature:actualSignature) ifFalse:[
            "
             indexed instvar type has changed
            "
            classLayoutOK := false.
            sig := ChangedIndexedInstSignal
        ] ifTrue:[
            (Class instNameKeyFromSignature:signature) == (Class instNameKeyFromSignature:actualSignature) ifFalse:[
                "
                 instance variable definition is different (but size is OK)
                 this may or may-not be an error; should we raise an error here ?
                "
                classLayoutOK := false.
                sig := ChangedInstLayoutSignal
            ] ifTrue:[
                "
                 only classinstvars have changed - no problem
                "
            ]
        ]
    ].

    classLayoutOK ifFalse:[
        "
         stored class is incompatible with definition of present class.
         The error is caused by a class which has changed its definition.
         The signal is raised passing a dummy class (which has the original layout)
         as argument. If the signal is handled and simply returns, that dummy class
         will be taken in place of the original one.
         If the handler returns a class, this return value is taken.
        "
        replacementClass := self replacementClassFor:name asSymbol
                              signature:signature
                              instVarNames:instVarString.
        value := sig raiseRequestWith:replacementClass.

        "
         check again - maybe handler has repaired things.
         If so, it is supposed to return the class.
         If not, use the replacement class, which at least provides
         some environment for the restored object.
        "
        value isBehavior ifTrue:[
            class := value.
            "/
            "/ remember the dummy class (which describes the original layout),
            "/ and a mapping from the new class.
            "/ for references, we use the new class; however, for structure reading,
            "/ we use the old one.
            "/
            newToOldClassMapping isNil ifTrue:[
                newToOldClassMapping := IdentityDictionary new.
            ].
            newToOldClassMapping at:class put:replacementClass.
            id notNil ifTrue:[
                idToObjectMapping at:id put:class
            ].
            ^ class
        ].
        class := replacementClass
    ].

    "
     check again - this time, we only check for
     the size of the classes instances.
    "
    (Class instSizeFromSignature:signature) == (class instSize) ifTrue:[
        (Class instTypeFromSignature:signature) == (Class instTypeFromSignature:class signature) ifTrue:[
            id notNil ifTrue:[
                idToObjectMapping at:id put:class
            ].
            ^ class
        ] ifFalse:[
            sig := ChangedIndexedInstSignal
        ]
    ] ifFalse:[
        sig := ChangedInstSizeSignal
    ].

    value notNil ifTrue:[
        "
         the class provided as replacement is not ok
         for this obsolete object ...
        "
        sig raiseRequestWith:class errorString:'incompatible replacement class'.

    ] ifFalse:[
        "
         some incompatible object (actually unknown class) was encountered,
         and no repair was made.
         Abort the binary load.
        "
        BinaryLoadErrorSignal raise.
    ].
    ^ nil

    "Modified: / 27-09-2007 / 09:47:07 / cg"
    "Modified (comment): / 13-02-2017 / 19:55:48 / cg"
    "Modified (comment): / 09-10-2017 / 14:13:13 / mawalch"
!

getFalse
    "get false"

    ^ false

    "Modified: 22.1.1997 / 18:53:26 / cg"
!

getFloatClass
    "the Float class"

    ^ Float

    "Created: / 29.2.1996 / 00:08:02 / cg"
    "Modified: / 1.11.1997 / 19:53:05 / cg"
!

getFloatClassDef
    "get the Float class (encountered a ref to the Float class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:Float.
    ^ Float

    "Created: / 1.11.1997 / 19:43:24 / cg"
    "Modified: / 2.11.1997 / 10:19:28 / cg"
!

getFullClass
    "get a full class definition"

    ^ Class binaryClassDefinitionFrom:stream manager:self.

    "Modified: 22.1.1997 / 18:52:55 / cg"
!

getGlobalDefinition
    "read a global's definition"

    |id nameLength object|

    id := stream nextUnsignedInt24MSB:true. "/ stream nextNumber:3.
    nameLength := stream nextUnsignedInt16MSB:true. "/ stream nextNumber:2.
    allowGlobalExpressions ifTrue:[
        object := Compiler 
                    evaluate:(stream next:nameLength) asString 
                    "/ for: nil 
                    "/ logged: false
                    compile:false.
    ] ifFalse:[    
        object := nil.
        'BinaryInputManager [warning]: global definition ignored' infoPrintCR.
    ].
    ^ idToObjectMapping at:id put:object
!

getInteger
    "get a positive 4-byte smallInteger"

    ^ stream nextUnsignedInt32MSB:true
!

getLargeIntegerClass
    "the LargeInteger class"

    ^ LargeInteger

    "Created: / 29.2.1996 / 00:06:58 / cg"
    "Modified: / 1.11.1997 / 19:53:23 / cg"
!

getLargeIntegerClassDef
    "get the LargeInteger class (encountered a ref to the LargeInteger class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:LargeInteger.
    ^ LargeInteger

    "Created: / 1.11.1997 / 19:43:40 / cg"
    "Modified: / 2.11.1997 / 10:19:32 / cg"
!

getMetaDefinition
    "read a meta classes definition with a 3-byte id"

    |cls id|

    id := stream nextUnsignedInt24MSB:true. "/ stream nextNumber: 3.
    cls := self getClassDefinition:nil.
    cls := cls class.
    idToObjectMapping at:id put:cls.
    ^ cls

    "Created: / 18.1.1996 / 01:32:49 / cg"
    "Modified: / 2.11.1997 / 10:19:35 / cg"
!

getMinusOne
    "get a -1 (minus one)"

    ^ -1

    "Modified: / 22.1.1997 / 18:51:31 / cg"
    "Created: / 1.11.1997 / 18:12:15 / cg"
!

getNegativeByteInteger
    "get a negative 1-byte smallInteger"

    ^ stream next negated

    "Created: 28.2.1996 / 23:27:03 / cg"
!

getNegativeInteger
    "get a negative 4-byte smallInteger"

    ^ self getInteger negated

    "Created: 28.2.1996 / 23:27:16 / cg"
    "Modified: 28.2.1996 / 23:43:16 / cg"
!

getNil
    "get nil"

    ^ nil

    "Modified: 22.1.1997 / 18:52:30 / cg"
!

getObject1Definition
    "read an object definition with a 1-byte id"

    |id|

    id := stream next.
    ^ self getObjectDefinition:id
!

getObject1Id
    "read an object id with a 1-byte id"

    |id|

    id := stream next.
    ^ self getObjectById:id

    "Modified: / 2.11.1997 / 10:35:02 / cg"
!

getObject2Definition
    "read an object definition with a 2-byte id"

    |id|

    id := stream nextUnsignedInt16MSB:true.
    ^ self getObjectDefinition:id

    "Modified: 11.11.1996 / 17:33:42 / cg"
!

getObject2Id
    "read an object id with a 2-byte id"

    |id|

    id := stream nextUnsignedInt16MSB:true.
    ^ self getObjectById:id

    "Modified: / 2.11.1997 / 10:35:09 / cg"
!

getObjectById:id
    "retrieve an object by id"

    |obj|

    id notNil ifTrue:[
        obj := idToObjectMapping at:id ifAbsent:nil.
        obj notNil ifTrue:[
            ^ obj
        ].
        fixIdToObjectMapping notNil ifTrue:[
            obj := fixIdToObjectMapping at:id ifAbsent:nil.
            obj notNil ifTrue:[
                ^ obj
            ]
        ].
        self error:'non-existing object id'
    ] ifFalse:[
        self error:'premature end of input'
    ]

    "Modified: / 2.11.1997 / 10:35:02 / cg"
!

getObjectClass
    "the Object class"

    ^ Object

    "Modified: / 1.11.1997 / 19:53:47 / cg"
!

getObjectClassDef
    "get the Object class (encountered a ref to the Object class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:Object.
    ^ Object

    "Created: / 1.11.1997 / 19:44:03 / cg"
    "Modified: / 2.11.1997 / 10:19:46 / cg"
!

getObjectCorps
    "read an object-only (i.e. without keeping it for later refs)"

    ^ self getObjectDefinition:nil
!

getObjectDefinition
    "read an object definition with a 3-byte id"

    |id|

    id := stream nextUnsignedInt24MSB:true. "/ stream nextNumber: 3.
    ^ self getObjectDefinition:id
!

getObjectDefinition:id
    "read an object definition; the id has already been read"

    |class obj className newClass oldObj isImmutable|

    lastId := id.

    (ImmediateObjectTypes at:(stream peek)) ifTrue:[
        "/ the next object comes immediately (no extra class info)
        "/ currently, only done for Strings & ByteArray.
        "/ more may follow.

        obj := self nextObject.
        id notNil ifTrue:[
            idToObjectMapping at:id put:obj.
        ].
        ^ obj
    ].

    "/ full object info follows;
    "/ first comes the class, then the body.
    "/ The body is read by the class.

    class := self nextObject.

    "
     get the object's corps - a new instance with bit-valued fields already
     preset, but instance variables all empty.
    "
    newToOldClassMapping notNil ifTrue:[
        class := newToOldClassMapping at:class ifAbsent:[class].
    ].
    isImmutable := class hasImmutableInstances.
    isImmutable ifTrue:[
        class := class mutableClass.
    ].

    obj := class binaryDefinitionFrom:stream manager:self.

    id notNil ifTrue:[
        "
         Must add the object to the table BEFORE reading the rest of its definition
         because it may (even indirectly) refer to itself
        "
        idToObjectMapping at:id put:obj.
    ].

    "
     if any, let the object read its instance variables
    "
    class isPointers ifTrue: [
        obj readBinaryContentsFrom: stream manager: self
    ].

    "
     if obsolete, give it a chance to be converted
    "
    class superclass == ObsoleteObject ifTrue:[
        "
         try a conversion ... (returns obj if unhandled)
        "
        className := class name.
        newClass := Smalltalk at:className ifAbsent:nil.
        "
         call the handler, passing the newClass and the obsolete instance
         as parameter.
        "
        oldObj := obj.

        obj := RequestConversionSignal 
                    raiseRequestWith:(Association key:newClass value:oldObj).

        oldObj becomeSameAs:obj.
        idToObjectMapping at:id put:obj.
    ].

    isImmutable ifTrue:[
        obj beImmutable.
    ].

    ^ obj

    "Modified: / 27-09-2007 / 09:45:35 / cg"
!

getObjectId
    "read an object id with a 3-byte id"

    |id|

    id := stream nextUnsignedInt24MSB:true. "/ stream nextNumber:3.
    ^ self getObjectById:id

    "Modified: / 2.11.1997 / 10:35:20 / cg"
!

getObjectSeqDefinition
    "read an object definition; id is next sequential"

    |id|

    id := lastId + 1.
    ^ self getObjectDefinition:id

    "Modified: / 11.11.1996 / 17:33:42 / cg"
    "Created: / 1.11.1997 / 19:07:33 / cg"
!

getOne
    "get a 1 (one)"

    ^ 1

    "Modified: / 22.1.1997 / 18:51:31 / cg"
    "Created: / 1.11.1997 / 18:12:04 / cg"
!

getShortInteger
    "get a 2-byte smallInteger"

    ^ stream nextUnsignedInt16MSB:true.

    "Modified: 11.11.1996 / 17:34:29 / cg"
!

getString
    "get a small string, which has a 1-byte length"

    |len s|

    len := stream next.
    ^ (stream nextString:len)
"/    s := String uninitializedNew:len.
"/    stream nextBytes:len into:s startingAt:1.
"/    ^ s

    "Modified: / 2.11.1997 / 16:20:42 / cg"
!

getStringClass
    "the String class"

    ^ String

    "Modified: / 1.11.1997 / 19:54:11 / cg"
!

getStringClassDef
    "get the String class (encountered a ref to the String class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:String.
    ^ String

    "Created: / 1.11.1997 / 19:44:20 / cg"
    "Modified: / 2.11.1997 / 10:20:00 / cg"
!

getSymbol
    "get a symbol, which has a 1-byte length"

    |len s|

    len := stream next.
    ^ (stream nextString:len) asSymbol
"/    s := String uninitializedNew:len.
"/    stream nextBytes:len into:s startingAt:1.
"/    ^ s asSymbol

    "Created: / 2.11.1997 / 16:12:55 / cg"
    "Modified: / 2.11.1997 / 16:20:48 / cg"
!

getSymbolClass
    "the Symbol class"

    ^ Symbol

    "Modified: / 1.11.1997 / 19:54:35 / cg"
!

getSymbolClassDef
    "get the Symbol class (encountered a ref to the Symbol class)
     and define; id is next byte."

    |id|

    id := stream next.
    idToObjectMapping at:id put:Symbol.
    ^ Symbol

    "Created: / 1.11.1997 / 19:54:21 / cg"
    "Modified: / 2.11.1997 / 10:20:03 / cg"
!

getTrue
    "get true"

    ^ true

    "Modified: 22.1.1997 / 18:51:37 / cg"
!

getZero
    "get a 0 (zero)"

    ^ 0

    "Modified: 22.1.1997 / 18:51:31 / cg"
! !

!BinaryInputManager methodsFor:'private-structure skipping'!

skip1
    "skip 1 byte"

    stream next
!

skip2
    "skip 2 bytes"

    stream skip:2.
!

skip4
    "skip 4 bytes"

    stream skip:4
!

skip8
    "skip 8 bytes"

    stream skip:8
!

skipCharacter2Definition
    "skip a 2-byte characters definition"

    stream skip:2
!

skipCharacterDefinition
    "skip a 1-byte characters definition"

    stream next
!

skipObject1Id
    "skip an object defined by a 1-byte id"

    stream next.
!

skipObject2Id
    "skip an object defined by a 2-byte id"

    stream skip:2
!

skipObjectId
    "skip an object defined by a 3-byte id"

    stream skip:3 
!

skipString
    "skip a string"

    stream skip:(stream next)
! !

!BinaryInputManager methodsFor:'public access'!

on:aStreamOrFilename
    "setup for reading from aStreamOrFileName.
     If the argument is not a stream, it is assumed to be the
     name of a file which is to be opened for reading."

    aStreamOrFilename isStream ifFalse:[
	stream := aStreamOrFilename asFilename readStream.
    ] ifTrue:[
	stream := aStreamOrFilename.
    ].
    stream binary.
!

readFrom:aStreamOrFilename
    "Reads an object's structure from the stream streamOrFileName
     or the file named streamOrFileName. 
     If the argument is not a stream, it is assumed to be the name 
     of a file which is to be opened for reading and closed afterwards.
     If it's a stream, it will remain open and positioned after the
     object's definition (after the read)."

    |val|

    aStreamOrFilename isStream ifFalse:[
        stream := aStreamOrFilename asFilename readStream.
        stream binary.
        val := self nextObject.
        stream close.
        ^ val
    ].
    stream := aStreamOrFilename.
    stream binary.
    ^ self nextObject

    "Modified (comment): / 13-02-2017 / 19:55:53 / cg"
! !

!BinaryInputManager methodsFor:'special accessing'!

fixIdToObjectMapping:anIdentityDictionary
    "preset the objectDictionary to include the associations
     given by the argument, anIdentityDictionary.
     This must contain id->object associations, typically for classes.
     This is a non-public entry for the PersistencyManager."

    fixIdToObjectMapping := anIdentityDictionary.
    lastId := nil.

    "Created: / 2.11.1997 / 10:34:00 / cg"
    "Modified: / 2.11.1997 / 13:45:53 / cg"
!

idToObjectMapping
    "return my current mapping from IDs to objects"

    ^ idToObjectMapping

    "Created: / 2.11.1997 / 10:21:01 / cg"
! !

!BinaryInputManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/BinaryInputManager.st,v 1.71 2018-05-15 16:09:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libboss/BinaryInputManager.st,v 1.71 2018-05-15 16:09:46 cg Exp $'
! !

