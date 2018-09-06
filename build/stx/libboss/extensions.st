"{ Package: 'stx:libboss' }"!

!Behavior methodsFor:'binary storage'!

binaryDefinitionFrom:stream manager:manager
    "sent during a binary read by the input manager.
     Read the definition on an empty instance (of my class) from stream.
     All pointer instances are left nil, while all bits are read in here.
     return the new object."

    |obj t
     basicSize "{ Class: SmallInteger }" 
     msb|

    self isPointers ifTrue: [
        "/
        "/ inst size not needed - if you uncomment the line below,
        "/ also uncomment the corresponding line in
        "/ Object>>storeBinaryDefinitionOn:manager:
        "/
        "/ stream next. "skip instSize"
        self isVariable ifTrue: [
            ^ self basicNew:(stream nextUnsigned:3 MSB:true)
        ].
        ^ self basicNew
    ].

    "
     an object with bit-valued instance variables.
     These are read here.
    "
    basicSize := stream nextUnsignedInt32MSB.
    obj := self basicNew:basicSize.

    self isBytes ifTrue: [
        stream nextBytes:basicSize into:obj
    ] ifFalse: [
        self isWords ifTrue: [
            1 to:basicSize do:[:i |
                obj basicAt:i put:(stream nextUnsignedInt16MSB)
            ]
        ] ifFalse:[
            self isLongs ifTrue: [
                1 to:basicSize do:[:i |
                    obj basicAt:i put:(stream nextUnsignedInt32MSB)
                ]
            ] ifFalse:[
                self isFloats ifTrue: [
                    t := ShortFloat basicNew.
                    manager usedFormat > 2 ifTrue:[
                        "/ bug fix: always read MSB
                        msb := true
                    ] ifFalse:[
                        "/ bug: can only read from same-machine order
                        msb := UninterpretedBytes isBigEndian
                    ].    
                    "could do it in one big read on same-byte-order machines which use IEEE floats ..."
                    1 to:basicSize do:[:i |
                        ShortFloat readBinaryIEEESingleFrom:stream into:t MSB:msb.
                        obj basicAt:i put: t
                    ]
                ] ifFalse:[
                    self isDoubles ifTrue: [
                        t := Float basicNew.
                        manager usedFormat > 2 ifTrue:[
                            "/ bug fix: always read MSB
                            msb := true
                        ] ifFalse:[
                            "/ bug: can only read from same-machine order
                            msb := UninterpretedBytes isBigEndian
                        ].    
                        "could do it in one big read on same-byte-order machines which use IEEE doubles ..."
                        1 to:basicSize do:[:i |
                            Float readBinaryIEEEDoubleFrom:stream into:t MSB:msb.
                            obj basicAt:i put: t
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^obj
! !

!Behavior methodsFor:'binary storage'!

fromBinaryStoreBytes:bytes
    "reconstruct an instance of myself from the binary-store bytes.
     These bytes are typically the result from binaryStoring into a byteArray.
     I.e. this is the reverse operation to #binaryStoreBytes"

    ^ self readBinaryFrom:(bytes readStream)

    "
     Object fromBinaryStoreBytes:
        #[15 1 42 0 0 3 0 40 13 5 104 101 108 108 111 38 40 46 63 243 190 118 200 180 57 88]
    "
! !

!Behavior methodsFor:'binary storage'!

readBinaryFrom:aStream
    "read an object's binary representation from the argument,
     aStream and return it. 
     The read object must be a kind of myself, otherwise an error is raised. 
     To get any object, use 'Object readBinaryFrom:...',
     To get any number, use 'Number readBinaryFrom:...' and so on.
     This is the reverse operation to 'storeBinaryOn:'. "

    ^ self readBinaryFrom:aStream onError:[self error:('expected ' , self name)]

    "
     |s|
     s := WriteStream on:(ByteArray new).
     #(1 2 3 4) storeBinaryOn:s.
     Object readBinaryFrom:(ReadStream on:s contents)  
    "
    "
     |s|
     s := 'testFile' asFilename writeStream binary.
     #(1 2 3 4) storeBinaryOn:s.
     'hello world' storeBinaryOn:s.
     s close.

     s := 'testFile' asFilename readStream binary.
     Transcript showCR:(Object readBinaryFrom:s).
     Transcript showCR:(Object readBinaryFrom:s).
     s close.
    "
! !

!Behavior methodsFor:'binary storage'!

readBinaryFrom:aStream onError:exceptionBlock
    "read an object's binary representation from aStream and return it. 
     The read object must be a kind of myself, otherwise the value of
     the exceptionBlock is returned.
     To get any object, use 'Object readBinaryFrom:...',
     To get any number, use 'Number readBinaryFrom:...' and so on.
     This is the reverse operation to 'storeBinaryOn:'. "

    |newObject|

    BinaryIOManager binaryLoadErrorSignal handle:[:ex|
        ^ exceptionBlock value.
    ] do:[
        newObject := (BinaryInputManager new) readFrom:aStream.
    ].
    
    (self == Object and:[(newObject isKindOf:self)]) ifTrue:[
        ^ newObject
    ].    
    ^ exceptionBlock value

    "
     |s|
     s := WriteStream on:(ByteArray new).
     #(1 2 3 4) storeBinaryOn:s.
     Object readBinaryFrom:(ReadStream on:s contents) onError:['oops'] 
    "
    "
     |s|
     s := WriteStream on:(ByteArray new).
     #[1 2 3 4] storeBinaryOn:s.
     Array readBinaryFrom:(ReadStream on:s contents)  onError:['oops']  
    "

    "Modified: / 08-10-2017 / 08:47:34 / cg"
! !

!Behavior methodsFor:'binary storage'!

storeBinaryDefinitionOn: stream manager: manager
    "binary store of a classes definition.
     Classes will store the name only and restore by looking for
     that name in the Smalltalk dictionary.
     This is an internal interface for the binary storage mechanism."

    | myName |

    myName := self name.
    stream nextNumber:4 put:self signature MSB:true.
    stream nextNumber:2 put:0 MSB:true.              "/ no instVarNames string here
    stream nextNumber:2 put:myName size MSB:true.
    stream nextPutBytes:(myName size) from:myName startingAt:1.
"/    myName do:[:c| 
"/        stream nextPut:c asciiValue
"/    ]

    "
     |s|
     s := WriteStream on:ByteArray new.
     #(1 2 3 4) storeBinaryOn:s.
     Object readBinaryFrom:(ReadStream on:s contents)  

     |s|
     s := WriteStream on:ByteArray new.
     Rectangle storeBinaryOn:s.
     Object readBinaryFrom:(ReadStream on:s contents)  
    "

    "Modified: 19.3.1997 / 19:49:59 / cg"
! !

!Block methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    byteCode isNil ifTrue:[
	self error:'cannot preserve semantics of block'.
    ].
    ^ super storeBinaryDefinitionOn:stream manager:manager
! !

!Boolean methodsFor:'binary storage'!

hasSpecialBinaryRepresentation
    "return true, if the receiver has a special binary representation"

    ^ true
! !

!ByteArray methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "append a binary representation of the receiver onto stream.
     Redefined since short ByteArrays can be stored with a special type code
     in a more compact way.
     This is an internal interface for the binary storage mechanism."

    |myClass myBasicSize|

    "not, if I have named instance variables"
    (myClass := self class) instSize ~~ 0 ifTrue:[
        ^ super storeBinaryDefinitionOn:stream manager:manager
    ].

    myBasicSize := self basicSize.

    "/ can use a more compact representation;
    "/ but not for subclasses ...

    ((myClass == ByteArray)
    and:[myBasicSize <= 255]) ifTrue:[
        "/ special encoding: <codeForByteArray> <len> <bytes> ...
        stream nextPut:(manager codeForByteArray); nextPut:myBasicSize.
    ] ifFalse:[
        manager putIdOfClass:myClass on:stream.
        stream nextNumber:4 put:myBasicSize MSB:true.
    ].
    self storeBinaryElementsOn:stream.

    "Modified: / 2.11.1997 / 15:28:45 / cg"
! !

!ByteArray methodsFor:'binary storage'!

storeBinaryElementsOn:aStream
    aStream nextPutBytes:self basicSize from:self startingAt:1.
! !

!ByteArray class methodsFor:'binary storage'!

binaryDefinitionFrom: stream manager: manager
    "get a ByteArray from the binary stream.
     ByteArrays are stored as a 4-byte int containing the size, 
     followed by the actual bytes.
     This is only invoked for long bytearrays.
     Short ones are stored in a dense format with a 1 byte length."

    |len|

    "take care of subclasses ..."
    self == ByteArray ifTrue:[
        len := stream nextUnsignedInt32MSB:true.
        ^ stream nextBytes:len.
    ].
    ^ super binaryDefinitionFrom:stream manager:manager

    "Modified: / 2.11.1997 / 16:19:49 / cg"
! !

!Character methodsFor:'binary storage'!

hasSpecialBinaryRepresentation
    "return true, if the receiver has a special binary representation"

    ^ true
! !

!Character methodsFor:'binary storage'!

identityHashForBinaryStore
    self proceedableError:'should not be called'.
    ^ self identityHash.

    "Modified: / 24-05-2018 / 14:55:24 / Claus Gittinger"
! !

!Character methodsFor:'binary storage'!

storeBinaryOn:stream manager:manager
    "store a binary representation of the receiver on stream;
     redefined, since single-byte characters are stored more compact
     with a special type-code followed by the asciiValue."

    (asciivalue <= 16rFF) ifTrue:[
        stream nextPut:manager codeForCharacter; nextPut:asciivalue.
    ] ifFalse:[
        (asciivalue <= 16rFFFF) ifTrue:[
            stream nextPut:manager codeForTwoByteCharacter.
            stream nextPutInt16MSB:asciivalue
        ] ifFalse:[
            (asciivalue <= 16rFFFFFF) ifTrue:[
                stream nextPut:manager codeForThreeByteCharacter.
                stream nextNumber:3 put:asciivalue MSB:true
            ] ifFalse:[
                self error:'unsupported (codePoint > FFFFFF)'
            ].
        ].
    ]
! !

!CharacterArray methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "append a binary representation of the receiver onto stream.
     This is an internal interface for the binary storage mechanism."

    |myClass|

    "not, if I have named instance variables"
    (myClass := self class) instSize ~~ 0 ifTrue:[
        ^ super storeBinaryDefinitionOn:stream manager:manager
    ].

    manager putIdOfClass:myClass on:stream.
    stream nextNumber:4 put:self basicSize MSB:true.
    self storeBinaryElementsOn:stream.
! !

!CharacterArray methodsFor:'binary storage'!

storeBinaryElementsOn:aStream
    aStream nextPutBytes:self basicSize from:self startingAt:1.
! !

!Class methodsFor:'binary storage'!

addGlobalsForBinaryStorageTo:globalDictionary
"
    classPool == nil ifFalse: [
        classPool associationsDo: [:assoc|
            globalDictionary at: assoc put: self
        ]
    ]
"

    "Created: 21.3.1997 / 15:40:45 / cg"
! !

!Class methodsFor:'binary storage'!

binaryClassDefinitionFrom:stream manager:manager
    "retrieve a class as stored previously with
     #storeBinaryClassOn:manager:
     The namespace, where the class is to be installed is queries via the
     NameSpaceQuerySignal - it should answer with nil, to suppress installation."

    |superclassName name flags instvars classvars category classInstVars
     comment package superclassSig rev
     newClass superClass methods cmethods formatID environment
     ownerName owner nPrivate privateClass cls|

    "/ the following order must correlate to
    "/ the storing in #storeBinaryClassOn:manager:

    "/ retrieve
    "/   formatID
    "/   superclasses name,
    "/   superclasses signature
    "/   name,
    "/   typeSymbol,
    "/   instVarNames
    "/   classVarNames
    "/   category
    "/   classInstVarNames
    "/   comment
    "/   revision
    "/   package
    "/   name of owner, or nil
    "/   classes methodDictionary
    "/   methodDictionary
    "/   number of private classes
    "/   private classes, if any

    formatID := manager nextObject.
    formatID isInteger ifFalse:[       "/ backward compatibilty
        formatID := nil.
        superclassName := formatID
    ] ifTrue:[
        superclassName := manager nextObject.
    ].
    superclassSig := manager nextObject.

    superclassName notNil ifTrue:[
        superClass := Smalltalk at:superclassName ifAbsent:nil.

        superClass isNil ifTrue:[
            BinaryIOManager nonexistingClassSignal
                raiseRequestWith:'non existent superclass (in binaryLoad)'.
            ^ nil
        ].

        "/ ('loading superclass: ' ,  superclassName ) printNL.
        superClass autoload.
        superClass := Smalltalk at:superclassName.

        superclassSig ~= superClass signature ifTrue:[
            BinaryIOManager changedInstLayoutSignal
                raiseRequestWith:'incompatible superclass (in binaryLoad)'.
            ^ nil
        ]
    ].

    name := manager nextObject.
    flags := manager nextObject.
    instvars := manager nextObject.
    instvars isNil ifTrue:[instvars := ''].
    classvars := manager nextObject.
    classvars isNil ifTrue:[classvars := ''].
    category := manager nextObject.
    classInstVars := manager nextObject.
    classInstVars isNil ifTrue:[classInstVars := ''].
    comment := manager nextObject.
    package := manager nextObject.
    formatID == 1 ifTrue:[
        rev := manager nextObject.
        ownerName := manager nextObject.
        ownerName notNil ifTrue:[
            name := name copyFrom:(ownerName size + 2 + 1).
            owner := Smalltalk at:ownerName.
        ]
    ].

"/    'got superName:' print. superclassName printNL.
"/    'got name:' print. name printNL.
"/    'got flags: ' print. flags printNL.
"/    'got instvars: ' print. instvars printNL.
"/    'got classvars: ' print. classvars printNL.
"/    'got category: ' print. category printNL.
"/    'got classInstvars: ' print. classInstVars printNL.

"/ ('create class: ' ,  name ) printNL.

    owner notNil ifTrue:[
        environment := owner
    ] ifFalse:[
        environment := Class nameSpaceQuerySignal query.
    ].

    cls := superClass.
    superClass isNil ifTrue:[
        cls := Object
    ].

    newClass := cls class
            name:name asSymbol
            inEnvironment:environment
            subclassOf:cls
            instanceVariableNames:instvars
            variable:false
            words:false
            pointers:true
            classVariableNames:classvars
            poolDictionaries:''
            category:category
            comment:comment
            changed:false
            classInstanceVariableNames:classInstVars.

    newClass isNil ifTrue:[
        ^ nil.
    ].

    superClass isNil ifTrue:[
        newClass setSuperclass:nil.
        newClass class setSuperclass:Class.
    ].

"/ Transcript showCR:'loaded ' , name , ' in ' , environment name.

    newClass flags:flags.

    "/ retrieve class methods
    cmethods := MethodDictionary binaryFullDefinitionFrom:stream manager:manager.
    "/ retrieve inst methods
    methods := MethodDictionary binaryFullDefinitionFrom:stream manager:manager.

    formatID == 1 ifTrue:[
        "/ privateClasses
        nPrivate := manager nextObject.
        nPrivate timesRepeat:[
            Class nameSpaceQuerySignal
                answer:newClass
                do:[
                    privateClass := manager nextObject
                ]
        ]
    ].

    (superClass isNil and:[superclassName notNil]) ifTrue:[^ nil].
    newClass isNil ifTrue:[
        ^ nil
    ].

    owner notNil ifTrue:[
        newClass setCategory:nil.
    ] ifFalse:[
        newClass setPackage:package.
    ].
    newClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:package].

    newClass methodDictionary:methods.
    newClass class methodDictionary:cmethods.

    newClass initializeWithAllPrivateClasses.

    ^ newClass

    "Created: / 8.10.1996 / 17:57:02 / cg"
    "Modified: / 16.2.1999 / 10:09:22 / cg"
    "Modified: / 18.3.1999 / 18:15:58 / stefan"
! !

!Class methodsFor:'binary storage'!

storeBinaryClassOn:stream manager:manager
    "store a classes complete description (i.e. including methods).
     However, the superclass chain is not stored - at load time, that must
     be either present or autoloadable."

    |s sig owner superclass privateClasses nPrivate|

    stream nextPut: manager codeForClass.

    "/ the following order must correlate to
    "/ the storing in #binaryDefinitionFrom:manager:

    "/ store
    "/   format ID
    "/   superclasses name
    "/   superclasses signature
    "/   name
    "/   typeSymbol,
    "/   instVarNames
    "/   classVarNames
    "/   category
    "/   classInstVarNames
    "/   comment
    "/   package
    "/   revision
    "/   name of owner, or nil
    "/   classes methodDictionary
    "/   methodDictionary
    "/   # of privateClass names
    "/   privateClasses, if any

    1 storeBinaryOn:stream manager:manager.  "/ formatID

    owner := self owningClass.

    superclass := self superclass.
    superclass isNil ifTrue:[
        s := nil.
        sig := 0.
    ] ifFalse:[
        s := superclass name.
        sig := superclass signature.
    ].
    s storeBinaryOn:stream manager:manager.
    sig storeBinaryOn:stream manager:manager.

    name storeBinaryOn:stream manager:manager.
    flags storeBinaryOn:stream manager:manager.
    (instvars isEmptyOrNil) ifTrue:[
        s := nil
    ] ifFalse:[
        s := self instanceVariableString
    ].
    s storeBinaryOn:stream manager:manager.

    (classvars isEmptyOrNil) ifTrue:[
        s := nil
    ] ifFalse:[
        s := self classVariableString
    ].
    s storeBinaryOn:stream manager:manager.

    "/ the category
    owner notNil ifTrue:[
        nil storeBinaryOn:stream manager:manager.
    ] ifFalse:[
        category storeBinaryOn:stream manager:manager.
    ].

    "/ the classInstVarString
    s := self class instanceVariableString.
    (s notNil and:[s isEmpty]) ifTrue:[
        s := nil
    ].
    s storeBinaryOn:stream manager:manager.

    "/ the comment
    s := comment.
    manager sourceMode == #discard ifTrue:[
        s := nil
    ].
    s storeBinaryOn:stream manager:manager.

    "/ the revision, package & owner
    owner notNil ifTrue:[
        nil storeBinaryOn:stream manager:manager.
        nil storeBinaryOn:stream manager:manager.
        owner name storeBinaryOn:stream manager:manager.
    ] ifFalse:[
        package storeBinaryOn:stream manager:manager.
        revision storeBinaryOn:stream manager:manager.
        nil storeBinaryOn:stream manager:manager.
    ].

    "/
    "/ store class method dictionary and methods
    "/
    self class methodDictionary storeFullBinaryDefinitionOn:stream manager:manager.
    "/ store inst method dictionary and methods
    self methodDictionary storeFullBinaryDefinitionOn:stream manager:manager.

    "/
    "/ names of private classes
    "/
    privateClasses := self privateClassesSorted.
    (nPrivate := privateClasses size) storeBinaryOn:stream manager:manager.
    nPrivate > 0 ifTrue:[
        privateClasses do:[:aClass |
            aClass storeBinaryClassOn:stream manager:manager
        ]
    ].

    "
     |bos|

     bos := BinaryObjectStorage onNew: (Filename named: 'FBrowser.cls') writeStream.
     bos nextPutClasses:(Array with:FileBrowser).
     bos close.
    "
    "
     |bos cls|

     bos := BinaryObjectStorage onOld: (Filename named: 'FBrowser.cls') readStream.
     cls := bos next.
     bos close.
     cls open.
    "

    "Modified: / 7.6.1996 / 13:39:02 / stefan"
    "Modified: / 16.2.1999 / 07:07:00 / cg"
! !

!Class methodsFor:'binary storage'!

storeBinaryDefinitionOf: anAssociation on: stream manager: manager
    "not usable at the moment - there are no classpools currently"

    | string |

    string := self name, ' classPool at: ', anAssociation key storeString.
    stream nextNumber: 2 put: string size MSB:true.
    stream nextPutBytes:(string size) from:string startingAt:1.
"/    string do: [:char| stream nextPut: char asciiValue]

    "Modified: 19.3.1997 / 18:49:54 / cg"
! !

!Class methodsFor:'binary storage'!

storeBinaryDefinitionOn: stream manager: manager
    "store the receiver in a binary format on stream.
     This is an internal interface for binary storage mechanism.
     classes only store the name, signature and instvar names.
     They restore by looking for that name in the Smalltalk dictionary.
     However, using the signature, a check for being valid is made at
     restore time.
     This avoids a full recursive store of a class in the normal binary
     storage - however, it also means that a classes semantics cannot
     be stored with the basic storeBinary operation
     (we depend on the class being present at binaryLoad time.
    To store classes, use #storeBinaryClassOn:manager: or BOSS>>nextPutClasses:."

    |varnames n sz|

    "
     output the signature
    "
    stream nextNumber:4 put:self signature MSB:true.

    "
     output the instance variable name string
    "
    varnames := self allInstVarNames.
    n := varnames size.
    n == 0 ifTrue:[
        sz := 0
    ] ifFalse:[
        sz := varnames inject:0 into:[:sum :nm | sum + nm size].
        sz := sz + n - 1.
    ].
    stream nextNumber:2 put:sz MSB:true.
    varnames keysAndValuesDo:[:i :nm |
        stream nextPutBytes:(nm size) from:nm startingAt:1.
"/        nm do:[:c |
"/            stream nextPut:c codePoint
"/        ].
        i ~~ n ifTrue:[stream nextPut:(Character space codePoint)]
    ].

    "
     output my name
    "
    stream nextNumber:2 put:name size MSB:true.
    stream nextPutBytes:(name size) from:name startingAt:1.
"/    name do:[:c|
"/        stream nextPut:c asciiValue
"/    ]

    "
     |s|
     s := WriteStream on:ByteArray new.
     Rectangle storeBinaryOn:s.
     Object readBinaryFrom:(ReadStream on:s contents)
    "

    "Modified: 19.3.1997 / 18:47:10 / cg"
! !

!Color methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    self class == Color ifTrue:[
        red := manager nextObject.
        green := manager nextObject.
        blue := manager nextObject.
        writable := manager nextObject.
        self restored.
    ] ifFalse:[
        super readBinaryContentsFrom: stream manager: manager
    ].
! !

!Color methodsFor:'binary storage'!

storeBinaryDefinitionBodyOn:stream manager:manager
    self class == Color ifTrue:[
        manager putIdOf:red on:stream.
        manager putIdOf:green on:stream.
        manager putIdOf:blue on:stream.
        manager putIdOf:writable on:stream.
    ] ifFalse:[
        super storeBinaryDefinitionBodyOn:stream manager:manager
    ].
! !

!DisplaySurface methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "tell the newly restored View to recreate itself.
     Bug: does not work correctly yet.
          (restored view looses its position & wg process)"

    |wasRealized|

    super readBinaryContentsFrom: stream manager: manager.

    wasRealized := realized.
    realized := false.
    self recreate.
    wasRealized ifTrue:[
        self remap
    ]


    "
     |s l|
     s := 'storedLabel.boss' asFilename writeStream binary.
     l := (Label label:'hello there') realize.
     Delay waitForSeconds:1.
     l storeBinaryOn:s.
     s close.
    "

    "
     |s l|
     s := 'storedLabel.boss' asFilename writeStream binary.
     (l := Label label:'hello there') open.
     (Delay forSeconds:10) wait.
     l storeBinaryOn:s.
     s close.
     l destroy.
    "

    "
     |s|
     s := 'storedLabel.boss' asFilename readStream binary.
     (Object readBinaryFrom:s)
    "

    "Modified: 3.5.1996 / 23:59:38 / stefan"
    "Modified: 14.2.1997 / 15:42:55 / cg"
! !

!ExecutableFunction methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "make certain, that no invalid function addresses are created."

    super readBinaryContentsFrom: stream manager: manager.
    self code:nil.
! !

!False methodsFor:'binary storage'!

storeBinaryOn: stream manager: manager
    "store a binary representation of the receiver on stream;
     redefined, since false is stored with a special type-code"

    stream nextPut: manager codeForFalse
! !

!Float methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "store the receiver in a binary format on stream.
     This is an internal interface for binary storage mechanism (BOSS)."

    manager putIdOfClass:(self class) on:stream.
    manager usedFormat > 2 ifTrue:[
        "/ fixed; store in MSB
        Float storeBinaryIEEEDouble:self on:stream MSB:true.
    ] ifFalse:[
        "/ bug compatible: stored in native order
        Float storeBinaryIEEEDouble:self on:stream.
    ].
    
    "Modified: 23.4.1996 / 09:29:48 / cg"
! !

!Float class methodsFor:'binary storage'!

binaryDefinitionFrom:aStream manager: manager
    "This is an internal interface for binary storage mechanism (BOSS)."

    |f|

    f := self basicNew.
    manager usedFormat > 2 ifTrue:[
        "/ fixed; read in MSB
        self readBinaryIEEEDoubleFrom:aStream into:f MSB:true.
    ] ifFalse:[
        "/ backward bug compatible: read in native format        
        self readBinaryIEEEDoubleFrom:aStream into:f.
    ].
    ^ f

    "Modified: 16.4.1996 / 21:23:38 / cg"
! !

!Font methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "tell the newly restored Font about restoration"

    super readBinaryContentsFrom: stream manager: manager.
    self restored
! !

!Form methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "tell the newly restored Form about restoration"

    width := manager nextObject.
    height := manager nextObject.
    depth := manager nextObject.
    offset := manager nextObject.
    data := manager nextObject.

"/    super readBinaryContentsFrom: stream manager: manager.
"/    device := nil. "/ Screen current.

    self restored.
"/    self recreate.
"/    Lobby register:self.

    "
     |f|

     f := Form fromFile:'bitmaps/SBrowser.xbm'.
     f storeBinaryOn:'foo.bos'.

     (Form readBinaryFrom:'foo.bos') inspect
    "
! !

!Form methodsFor:'binary storage'!

storeBinaryDefinitionOn: stream manager: manager
    "store a binary representation of the receiver on stream.
     This is an internal interface for binary storage mechanism.
     Redefined to store the actual bits, even if I have been loaded 
     from a file, and to ommit all device related stuff."

    |bits|

    manager putIdOfClass:(self class) on:stream.
    manager putIdOf:width on:stream.
    manager putIdOf:height on:stream.
    manager putIdOf:depth on:stream.
    manager putIdOf:offset on:stream.
    (bits := data) isNil ifTrue:[
        bits := self bits.
    ].
    manager putIdOf:bits on:stream.

"/    savedDevice := device.
"/    (savedData := data) isNil ifTrue:[
"/        data := self bits.
"/    ].
"/    device := nil.
"/    super storeBinaryDefinitionOn:stream manager:manager.
"/    data := savedData.
"/    device := savedDevice.

    "Modified: 23.4.1996 / 09:30:47 / cg"
! !

!Image methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "read a binary representation of an image from stream.
     Redefined to flush any device data."

    super readBinaryContentsFrom: stream manager: manager.
    device := nil.
    deviceForm := nil.
    monoDeviceForm := nil.
    fullColorDeviceForm := nil.
! !

!Image methodsFor:'binary storage'!

storeBinaryDefinitionOn: stream manager: manager
    "store a binary representation of the receiver on stream.
     This is an internal interface for binary storage mechanism.
     Redefined to not store the device form (which is recreated at
     load time anyway)"

    |tDevice tDeviceForm tMonoDeviceForm tFullColorDeviceForm|

    tDevice := device.
    tDeviceForm := deviceForm.
    tMonoDeviceForm := monoDeviceForm.
    tFullColorDeviceForm := fullColorDeviceForm.

    [
        device := nil.
        deviceForm := nil.
        monoDeviceForm := nil.
        fullColorDeviceForm := nil.

        super storeBinaryDefinitionOn: stream manager: manager.
    ] ensure:[
        device := tDevice.
        deviceForm := tDeviceForm.
        monoDeviceForm := tMonoDeviceForm.
        fullColorDeviceForm := tFullColorDeviceForm.
    ].
    
    "Modified: 23.4.1996 / 09:30:50 / cg"
! !

!Method methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    self hasCode ifTrue:[
	"built-in method - already complete"
	^ self
    ].

    ^ super readBinaryContentsFrom: stream manager: manager

    "Modified: / 13.11.1998 / 23:21:26 / cg"
! !

!Method methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "store the receiver in a binary format on stream.
     This is an internal interface for binary storage mechanism.
     only store bytecode-methods - machinecode methods are stored
     as class/selector pair and a lookup is done when restored.

     If the receiver method is a built-in (i.e. machine coded)
     method, a temporary interpreted byte code method is created,
     and its bytecode stored. 
     This works only, if the source of the method is available and the
     method does not contain primitive code."

    |storedMethod who|

    byteCode isNil ifTrue:[
        (manager storeMethodBytecode not and:[self hasCode]) ifTrue:[
            (who := self who) notNil ifTrue:[
                "
                 machine code only - assume it's a built-in method,
                 and store the class/selector information.
                 The restored method may not be exactly the same ...
                "
                manager putIdOfClass:(self class) on:stream.
                stream nextPutByte:0.   "means: built-in method" 
                manager putIdOf:(who methodClass) on:stream.
                manager putIdOf:(who methodSelector) on:stream.
                ^ self
            ]
        ].

        storedMethod := self asByteCodeMethod.
        storedMethod isNil ifTrue:[
            self error:'store of built-in method failed'.
        ].
        storedMethod mclass:(self getMclass).
        ^ storedMethod storeBinaryDefinitionOn:stream manager:manager
    ].

    manager putIdOfClass:(self class) on:stream.
    stream nextPutByte:1.       "means: byte-coded method"
    self storeBinaryDefinitionBodyOn:stream manager:manager

    "Modified: / 13.11.1998 / 23:21:42 / cg"
! !

!Method methodsFor:'binary storage'!

storeFullBinaryDefinitionOn:stream manager:manager
    "store full bytecoded-method."

    |m code srcPos|

    "/ need a byteCode version of myself ...
    m := self.
    code := byteCode.
    code isNil ifTrue:[
	m := self asByteCodeMethod.
	code := m byteCode.
	code isNil ifTrue:[
	    m := self
	]
    ].

    ObjectMemory snapshotID storeBinaryOn:stream manager:manager.
    category storeBinaryOn:stream manager:manager.

    m flags storeBinaryOn:stream manager:manager.
    m literals storeBinaryOn:stream manager:manager.
    manager sourceMode == #discard ifTrue:[
	"/ add nil, nil, nil
	nil storeBinaryOn:stream manager:manager. "/ sourceFileName
	nil storeBinaryOn:stream manager:manager. "/ sourcePosition
	nil storeBinaryOn:stream manager:manager. "/ source
    ] ifFalse:[
	"/ add sourceFilename, srcPos
	"/ or  nil, nil, source
	m sourceFilename storeBinaryOn:stream manager:manager.
	manager sourceMode == #reference ifTrue:[
	    srcPos := m sourcePosition.
	] ifFalse:[
	    srcPos := nil
	].
	srcPos storeBinaryOn:stream manager:manager.
	srcPos isNil ifTrue:[
	    m source storeBinaryOn:stream manager:manager.
	].
    ].

    code storeBinaryOn:stream manager:manager.

    "Created: 16.1.1996 / 14:41:45 / cg"
    "Modified: 5.1.1997 / 00:39:29 / cg"
! !

!Method class methodsFor:'binary storage'!

binaryDefinitionFrom: stream manager: manager
    "read my definition from stream."

    |cls sel|

    "type-byte"
    stream nextByte == 0 ifTrue:[
        "
         built-in method
        "
        cls := manager nextObject.
        sel := manager nextObject.

        "
         mhmh - on the source system, this was a machinecode
         method, while here its an interpreted one ...
        "
        cls := cls autoload.
        ^ cls compiledMethodAt:sel
    ].
    "
     bytecode method
    "
    ^ super binaryDefinitionFrom:stream manager:manager
! !

!Method class methodsFor:'binary storage'!

binaryFullDefinitionFrom:stream manager:manager
    "retrieve a full bytecoded-method."

    |snapId cat flags code lits m sourceFilename sourcePos source|

    snapId := manager nextObject.
    cat := manager nextObject.
    flags := manager nextObject.
    lits := manager nextObject.
    sourceFilename := manager nextObject.
    sourcePos := manager nextObject.
    sourcePos isNil ifTrue:[
        source := manager nextObject.
    ].
    code := manager nextObject.

    snapId == ObjectMemory snapshotID ifTrue:[
        ObjectMemory incrementSnapshotID
    ].

    m := Method basicNew:(lits size).
    cat notNil ifTrue:[m setCategory:cat].
    m flags:flags.
    m literals:lits.
    m byteCode:code.
    sourcePos isNil ifTrue:[
        m source:source
    ] ifFalse:[
        m sourceFilename:sourceFilename position:sourcePos
    ].
    ^ m

    "Created: 16.1.1996 / 14:44:08 / cg"
    "Modified: 24.6.1996 / 12:29:35 / stefan"
    "Modified: 5.1.1997 / 01:09:56 / cg"
! !

!MethodDictionary methodsFor:'binary storage'!

storeFullBinaryDefinitionOn:stream manager:manager
    "store the complete description (i.e. including methods)"

    self size storeBinaryOn:stream manager:manager.
    self keysAndValuesDo:[:sel :mthd|
        sel storeBinaryOn:stream manager:manager.
        mthd makeRealMethod storeFullBinaryDefinitionOn:stream manager:manager.
    ].

    "Created: 7.6.1996 / 12:53:00 / stefan"
! !

!MethodDictionary class methodsFor:'binary storage'!

binaryFullDefinitionFrom:stream manager:manager
   |size "{ Class: SmallInteger }" 
    inst|

   size := manager nextObject.
   inst := self new:size.
   1 to:size*2 by:2 do:[:i|
        inst basicAt:i put:manager nextObject.          "/ get selector
        inst basicAt:(i + 1) put:(Method binaryFullDefinitionFrom:stream manager:manager).
   ].
   ^ inst

    "Created: 7.6.1996 / 13:37:22 / stefan"
    "Modified: 7.6.1996 / 13:52:08 / stefan"
    "Modified: 3.7.1996 / 11:06:34 / cg"
! !

!Object methodsFor:'binary storage'!

binaryStoreBytes
    "store byself into a new byteArray and return it.
     A copy of the receiver can be reconstructing by sending 
     #fromBinaryStoreBytes: to my class (or superclass)"

    ^ ByteArray streamContents:[:s | self storeBinaryOn:s].

    "
     #('hello' 1 1.234) binaryStoreBytes
     'hello' asUnicode16String binaryStoreBytes

     Object fromBinaryStoreBytes:
        ('hello' asUnicode16String binaryStoreBytes)
    "
! !

!Object methodsFor:'binary storage'!

hasSpecialBinaryRepresentation
    "return true, if the receiver has a special binary representation;
     default here is false, but can be redefined in class which provide
     their own storeBinary/readBinary methods.

     Normal user classes should not use this, it is meant as a hook for
     special classes such as True, False, UndefinedObject or SmallInteger.

     If your instances should be stored in a special way, see
     #representBinaryOn: and #readBinaryContentsFromdata:manager:."

    ^ false
! !

!Object methodsFor:'binary storage'!

readBinaryContentsFrom:stream manager:manager
    "reconstruct the receiver's instance variables by reading a binary
     binary representation from stream. 
     This is a general implementation, walking over instances 
     and loading each recursively using manager.
     Redefined by some classes to read a more compact representations
     (see String, SmallInteger etc).

     Notice, that the object is already recreated as an empty corps
     with instance variables all nil and bit-instances (bytes, words etc.) 
     already read and restored.

     Also notice: this method is not called, if a private representation
     has been stored (see representBinaryOn:). 
     In that case, #readBinaryContentsFromData:manager: is called, which
     has to be reimplemented in the object's class."

    |size "{ Class: SmallInteger }"
     instvarArray|

    stream next == 1 ifTrue:[
        "/
        "/ special representation ...
        "/
        instvarArray := Array new:(size := stream nextUnsigned:3 MSB:true).
        1 to:size do:[:i |
            instvarArray basicAt:i put:(manager nextObject)
        ].
        self readBinaryContentsFromData:instvarArray manager:manager.
        ^ self
    ].

    "/
    "/ standard representation
    "/
    size := self basicSize.
    size ~~ 0 ifTrue:[
        self class isPointers ifTrue:[
            1 to:size do:[:i |
                self basicAt:i put:(manager nextObject)
            ]
        ]
    ].
    size := self class instSize.
    1 to:size do:[:i |
        self instVarAt:i put:(manager nextObject)
    ].
! !

!Object methodsFor:'binary storage'!

readBinaryContentsFromData:instVarArray manager:manager
    "this is only needed if instances want to use a special binary representation
     as specified by redefining representBinaryOn:manager.
     Must reconstruct the receiver's instance variables by filling instance
     variables with values from instVarArray. This array contains the instvars
     as specified in #representBinaryOn: when the object was stored.
     It is the receiver's responsibility to set its instance variables in the
     same order from that array."

    ^ SubclassResponsibilityError raiseRequestErrorString:'method must be reimplemented in subclass for binary storage'

    "typical implementation (see also comment in #representBinaryOn:)
     (for an object with foo, bar and baz as instance variables,
      which did not store baz and wants baz to be reinitialized to
      some constant string)

        foo := instvarArray at:1.
        bar := instvarArray at:2.
        baz := 'aConstant'.
    "
! !

!Object methodsFor:'binary storage'!

representBinaryOn:manager
    "this method is called by the storage manager to ask objects
     if they wish to provide their own binary representation.

     If they want to do so, they should return an array containing all
     instance variables (named & indexed pointer) to be stored. 
     If not redefined, this method returns nil which means that all 
     instance variables are to be stored.

     It should be redefined in objects which do not want all instance variables
     to be stored (for example: objects which keep references to a view etc.).

     If this is redefined returning non-nil, the corresponding class needs
     a redefined instance method named #readBinaryContentsFromData:manager:
     which has to fill the receiver's named (and optionally indexed pointer)
     instance variables with corresponding values from a data array."

    ^ nil

    "typical implementation:  
     (see also comment in #readBinaryContentsFromData:manager:)
     for an object with foo, bar and baz as instance variables,
     which does not want to store baz:

     representBinaryOn:manager
        |data|

        data := Array new:2.
        data at:1 put:foo.
        data at:2 put:bar.
        ^ data
    "
! !

!Object methodsFor:'binary storage'!

storeBinaryDefinitionBodyOn:stream manager:manager
    "append a binary representation of the receiver's body onto stream.
     This is a general implementation walking over instances storing
     each recursively as an ID using manager.
     Can be redefined in subclasses."

    |basicSize    "{ Class: SmallInteger }"
     instSize     "{ Class: SmallInteger }"
     specialSize  "{ Class: SmallInteger }"
     myClass specialRep pointers|

    myClass := self class.
    instSize := myClass instSize.

    (pointers := myClass isPointers) ifTrue:[
        "/
        "/ inst size not needed - if you uncomment the line below,
        "/ also uncomment the corresponding line in
        "/ Object>>binaryDefinitionFrom:manager:
        "/
        "/ stream nextPut:instSize. "mhmh this limits us to 255 named instvars"

        myClass isVariable ifTrue:[
            stream nextNumber:3 put:(basicSize := self basicSize) MSB:true
        ] ifFalse:[
            basicSize := 0
        ].
    ] ifFalse: [
        stream nextNumber:4 put:(basicSize := self basicSize) MSB:true.
        myClass isBytes ifTrue:[
            1 to:basicSize do:[:i |
                stream nextPut:(self basicAt:i)
            ]
        ] ifFalse:[
            myClass isWords ifTrue:[
                1 to:basicSize do:[:i |
                    stream nextNumber:2 put:(self basicAt: i) MSB:true
                ]
            ] ifFalse:[
                myClass isLongs ifTrue:[
                    1 to:basicSize do:[:i |
                        stream nextNumber:4 put:(self basicAt: i) MSB:true
                    ]
                ] ifFalse:[
                    myClass isFloats ifTrue:[
                        manager usedFormat > 2 ifTrue:[
                            "/ bug fix: store in MSB
                            "could do it in one big write on MSB machines which use IEEE floats ..."
                            1 to:basicSize do:[:i |
                                ShortFloat storeBinaryIEEESingle:(self basicAt:i) on:stream MSB:true
                            ]
                        ] ifFalse:[    
                            "/ buggy: stored in native order
                            "could do it in one big write on machines which use IEEE floats ..."
                            1 to:basicSize do:[:i |
                                ShortFloat storeBinaryIEEESingle:(self basicAt:i) on:stream
                            ]
                        ]
                    ] ifFalse:[
                        myClass isDoubles ifTrue:[
                            manager usedFormat > 2 ifTrue:[
                                "/ bug fix: store in MSB
                                "could do it in one big write on MSB machines which use IEEE doubles ..."
                                1 to:basicSize do:[:i |
                                    Float storeBinaryIEEEDouble:(self basicAt:i) on:stream MSB:true
                                ]
                            ] ifFalse:[    
                                "could do it in one big write on machines which use IEEE doubles ..."
                                1 to:basicSize do:[:i |
                                    Float storeBinaryIEEEDouble:(self basicAt:i) on:stream
                                ]
                            ]
                        ] ifFalse:[
                            "/ should never be reached ...
                            1 to:basicSize do:[:i |
                                manager putIdOf:(self basicAt:i) on:stream
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].

    (pointers or:[instSize ~~ 0]) ifTrue:[
        specialRep := self representBinaryOn:manager.
        specialRep notNil ifTrue:[
            specialSize := specialRep basicSize.
            stream nextPut:1.     "/ means: private representation follows
            stream nextNumber:3 put:specialSize MSB:true.

            1 to:specialSize do:[:i |
                manager putIdOf:(specialRep at:i) on:stream
            ].
        ] ifFalse:[
            stream nextPut:0.     "/ means: normal representation follows
                                  "/ index pointers followed by named instanceVars
            pointers ifTrue:[
                basicSize ~~ 0 ifTrue:[
                    1 to:basicSize do:[:i |
                        manager putIdOf:(self basicAt:i) on:stream
                    ].
                ].
            ].
            instSize ~~ 0 ifTrue:[
                1 to:instSize do:[:i |
                    manager putIdOf:(self instVarAt:i) on:stream
                ]
            ].
        ]
    ]

    "Modified: / 2.11.1997 / 14:43:29 / cg"
! !

!Object methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "append a binary representation of the receiver onto stream.
     This is an internal interface for binary storage mechanism.
     This method first stores the class, then the body, which is done
     in a separate method to allow redefinition of the bodies format.
     Can be redefined in subclasses to write more compact representations
     (see String, SmallInteger etc)."

    manager putIdOfClass:(self class) on:stream.
    self storeBinaryDefinitionBodyOn:stream manager:manager

    "Modified: 23.4.1996 / 09:31:12 / cg"
! !

!Object methodsFor:'binary storage'!

storeBinaryOn:aStreamOrFilename
    "Writes a description of the receiver onto aStreamOrFilename, in a way that allows
     the object's structure to be reconstructed from the stream's contents"

    BinaryOutputManager store:self on:aStreamOrFilename

    "
     |a s1 s2|

     s1 := 'hello'.
     s2 := 'world'.
     a := Array new:5.
     a at:1 put:s1.
     a at:2 put:s2.
     a at:3 put:s1.
     a at:4 put:s2.
     a storeBinaryOn:'test.boss'
    "

    "
     (BinaryObjectStorage onOld:'test.boss' asFilename readStream)
        next
            inspect
    "

    "Modified: / 1.11.1997 / 21:16:24 / cg"
! !

!Object methodsFor:'binary storage'!

storeBinaryOn:stream manager:manager
    "append a binary representation of the receiver onto stream."

    manager putIdOf:self on:stream
! !

!Set methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "must rehash after reload"

    super readBinaryContentsFrom: stream manager: manager.
    self rehash
! !

!SharedPool class methodsFor:'binary storage'!

addGlobalsForBinaryStorageTo:globalDictionary
    self keysAndValuesDo: [:eachKey :eachValue|
        (eachValue isBehavior or:[eachValue class hasSharedInstances]) ifFalse:[
            globalDictionary at:eachValue put:(self->eachKey).
        ].
    ]
! !

!SharedPool class methodsFor:'binary storage'!

storeBinaryDefinitionOf:anObject on:stream manager:manager
    |string|

    anObject class == Association ifTrue:[
        string := self name, ' associationAt:', anObject key storeString
    ] ifFalse: [
        string := self name, ' at:', anObject storeString
    ].
    stream nextNumber:2 put:string size MSB:true.
    stream nextPutBytes:(string size) from:string startingAt:1.
! !

!SmallInteger methodsFor:'binary storage'!

identityHashForBinaryStore
    self proceedableError:'should not be called'.
    ^ self identityHash.

    "Modified: / 24-05-2018 / 21:05:23 / Claus Gittinger"
! !

!Smalltalk class methodsFor:'binary storage'!

addGlobalsForBinaryStorageTo:globalDictionary
    |pools|

    pools := IdentitySet new.

    self keysAndValuesDo:[:eachKey :eachValue |
        (eachKey includes:$:) ifFalse:[       "/ skip classVars
            (eachValue ~~ self 
            and:[eachValue notNil]) ifTrue:[
                eachValue isClass ifTrue:[
                    eachValue addGlobalsForBinaryStorageTo:globalDictionary.
                    pools addAll:eachValue sharedPools
                ] ifFalse:[
                    globalDictionary at:(eachKey->eachValue) put:(self->eachKey)
                ].
                (eachValue isBehavior or:[eachValue class hasSharedInstances]) ifFalse:[
                    globalDictionary at:eachValue put:(self->eachKey)
                ]
            ]
        ]
    ].

    pools do:[:poolDictionary|
        poolDictionary addGlobalsForBinaryStorageTo:globalDictionary
    ]

    "Modified: 19.3.1997 / 18:15:25 / cg"
    "Created: 21.3.1997 / 15:40:31 / cg"
! !

!Smalltalk class methodsFor:'binary storage'!

storeBinaryDefinitionOf:anObject on:stream manager:manager
    |string|

    anObject class == Association ifTrue:[
        string := 'Smalltalk associationAt:', anObject key storeString
    ] ifFalse: [
        string := 'Smalltalk at:', anObject storeString
    ].
    stream nextNumber:2 put:string size MSB:true.
    stream nextPutBytes:(string size) from:string startingAt:1.

    "Modified: 19.3.1997 / 18:49:14 / cg"
! !

!String methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "append a binary representation of the receiver onto stream.
     Redefined since short Strings can be stored with a special type code
     in a more compact way.
     This is an internal interface for the binary storage mechanism."

    |myClass myBasicSize|

    "/ not for subclasses with named instVars.
    (myClass := self class) instSize ~~ 0 ifTrue:[
        ^ super storeBinaryDefinitionOn:stream manager:manager
    ].

    myBasicSize := self basicSize.

    "/ can use a more compact representation;
    "/ but not for subclasses ...

    ((myClass == String)
    and:[myBasicSize <= 255]) ifTrue:[
        "/ special encoding: <codeForString> <len> <bytes> ...
        stream nextPut:(manager codeForString); nextPut:myBasicSize.
    ] ifFalse:[
        manager putIdOfClass:myClass on:stream.
        stream nextNumber:4 put:myBasicSize MSB:true.
    ].
    stream nextPutBytes:myBasicSize from:self startingAt:1.

    "Modified: / 2.11.1997 / 15:28:56 / cg"
! !

!String class methodsFor:'binary storage'!

binaryDefinitionFrom:stream manager:manager
    "read a binary representation from stream. This is only invoked
     for long strings. Short strings are stored with 1byte length."

    |s len|

    "take care of subclasses ..."
    ((self == String) or:[self == Symbol]) ifTrue:[
        len := stream nextUnsignedInt32MSB.
        s := String uninitializedNew:len.
        stream nextBytes:len into:s startingAt:1.
        self == Symbol ifTrue:[
            ^ s asSymbol
        ].
        ^ s
    ].
    ^ super binaryDefinitionFrom:stream manager:manager

    "Modified: / 2.11.1997 / 16:18:37 / cg"
! !

!Symbol methodsFor:'binary storage'!

identityHashForBinaryStore
    "may not use inherited identityHashForBinaryStore, because it changes the internal object hash,
     which is actually not used for symbols."

    ^ self identityHash.
! !

!Symbol methodsFor:'binary storage'!

storeBinaryDefinitionOn:stream manager:manager
    "append a binary representation of the receiver onto stream.
     Redefined since short Symbol can be stored with a special type code 
     in a more compact way.
     This is an internal interface for the binary storage mechanism."

    |myClass myBasicSize|

    "/ not for subclasses with named instVars.
    (myClass := self class) instSize ~~ 0 ifTrue:[
        ^ super storeBinaryDefinitionOn:stream manager:manager
    ].

    myBasicSize := self basicSize.

    "/ can use a more compact representation;
    "/ but not for subclasses ...

    ((myClass == Symbol) 
    and:[myBasicSize <= 255]) ifTrue:[
        "/ special encoding: <codeForSymbol> <len> <bytes> ...
        stream nextPut:(manager codeForSymbol); nextPut:myBasicSize.
    ] ifFalse:[
        manager putIdOfClass:myClass on:stream.
        stream nextNumber:4 put:myBasicSize MSB:true.
    ].
    stream nextPutBytes:myBasicSize from:self startingAt:1.

    "Modified: / 2.11.1997 / 15:28:56 / cg"
    "Created: / 2.11.1997 / 16:13:47 / cg"
! !

!Symbol class methodsFor:'binary storage'!

binaryDefinitionFrom:stream manager:manager
    "retrieve a symbol from a binary input stream (nonpublic interface)"

    ^ self intern:(super binaryDefinitionFrom:stream manager:manager)

    "Modified: / 2.11.1997 / 16:17:06 / cg"
! !

!True methodsFor:'binary storage'!

storeBinaryOn: stream manager: manager
    "store a binary representation of the receiver on stream;
     redefined, since true is stored with a special type-code"

    stream nextPut: manager codeForTrue
! !

!UndefinedObject methodsFor:'binary storage'!

identityHashForBinaryStore
    self proceedableError:'should not be called'.
    ^ self identityHash.

    "Modified: / 24-05-2018 / 21:05:35 / Claus Gittinger"
! !

!UndefinedObject methodsFor:'binary storage'!

storeBinaryOn: stream manager: manager
    "store a binary representation of the receiver on stream;
     redefined, since true is stored with a special type-code"

    stream nextPut: manager codeForNil
! !

!Unicode16String methodsFor:'binary storage'!

storeBinaryElementsOn: stream
    self do:[:each|
        stream nextPutInt16MSB:each asInteger.
    ].
! !

!Unicode32String methodsFor:'binary storage'!

storeBinaryElementsOn: stream
    self do:[:each|
        stream nextPutInt32:each asInteger MSB:true.
    ].
! !

!stx_libboss class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libboss/extensions.st,v 1.29 2018-05-24 19:09:11 cg Exp $'
! !

