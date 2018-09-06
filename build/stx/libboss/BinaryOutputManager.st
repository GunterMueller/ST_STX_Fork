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
	and tuned here and there a bit ...
"
"{ Package: 'stx:libboss' }"

"{ NameSpace: Smalltalk }"

BinaryIOManager subclass:#BinaryOutputManager
	instanceVariableNames:'objectToIdMapping fixObjectToIdMapping lastId lastClass
		lastClassId sourceMode keepReferences lastObjDefId
		storeMethodBytecode reloadGlobals'
	classVariableNames:'Globals CleanupAction ReloadGlobals LastGlobalsSize'
	poolDictionaries:''
	category:'System-BinaryStorage'
!

IdentityDictionary subclass:#ObjectDictionary
	instanceVariableNames:'emptySlotIndex emptySlotKey'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BinaryOutputManager
!

!BinaryOutputManager class methodsFor:'documentation'!

binaryObjectFormat
"
    Binary storage consists of a sequence of Object IDs

    Current FormatVersion: 3
    
    WARNING:
        FormatVersion 3 is the same as version2, except for the handling
        of floats and doubles.
        
        Up to and including version 2, an error was present,
        in that floats and doubles were stored in native order (instead of MSB).
        Thus, these could only be restored/transmitted to a machine with the same byte order.
        This has been fixed in FormatVersion 3.
        If the reader encounters a FormatVersion2 blob, it will assume, 
        that it was written for my byteorder.
        
    Object IDs are identified usually by 4 byte words;
    however, for a more compact storage, some objects are encoded
    in a special way:

    The first byte defines the type:

      byte = [128 .. 255]         small positive integer in 31 bits; 3 bytes of lower valued bits follow; first byte is high 7 bits.
      byte = 1                    object id in next 3 bytes MSB
      byte = 2                    nil
      byte = 3                    true
      byte = 4                    false
      byte = 5                    object id in next 3 bytes MSB; object definition follows
      byte = 6                    class id in next 3 bytes MSB; class definition follows
      byte = 7                    global id in next 3 bytes MSB; global definition follows
      byte = 8                    character - asciivalue in next byte 
      byte = 9                    smallInteger 0 
      byte = 10                   smallInteger 2..255, value in next byte 
      byte = 11                   object id in next byte
      byte = 12                   object id in next 2 bytes MSB
      byte = 13                   string; length byte and characters follow
      byte = 14                   2-byte character; asciivalue in next 2 bytes MSB
      byte = 15                   object id in next byte; object definition follows
      byte = 16                   class id in next byte; class definition follows
      byte = 17                   object id in next 2 bytes MSB; object definition follows
      byte = 18                   class id in next 2 bytes MSB; class definition follows
      byte = 19                   metaclass id in next 3 bytes MSB; class definition follows
      byte = 20                   a byteArray follows; length byte and bytes follow
      byte = 21                   OBSOLETE: def. for the Symbol class itself - no additional bytes
      byte = 22                   OBSOLETE: def. for the Array class itself - no additional bytes
      byte = 23                   OBSOLETE: def. for the Object class itself - no additional bytes
      byte = 24                   a meta type
      byte = 25                   object corps follow
      byte = 26                   OBSOLETE: def. for the String class itself - no additional bytes
      byte = 27                   a negative smallInteger; 4 bytes of negated value follow
      byte = 28                   a negative 1-byte integer -2..-255; negated value in next byte
      byte = 29                   a short positive integer; 2 bytes of value follow
      byte = 30                   OBSOLETE: def. for the LargeInteger class itself - no additional bytes
      byte = 31                   OBSOLETE: def. for the Float class itself - no additional bytes
      byte = 32                   OBSOLETE: def. for the ByteArray class itself - no additional bytes
      byte = 33                   a FlushInstanceID marker
      byte = 34                   a FlushClassID marker
      byte = 35                   a FlushID marker
      byte = 36                   a 64bit positive integer; 8 bytes of value follow
      byte = 37                   a 64bit negative integer; 8 bytes of value follow
      byte = 38                   smallInteger 1 
      byte = 39                   smallInteger -1 
      byte = 40                   object id is next sequential (optimized same as 15, 17 & 5); object definition follows
      byte = 41                   the Symbol class itself - no additional bytes
      byte = 42                   the Array class itself - no additional bytes
      byte = 43                   the Object class itself - no additional bytes
      byte = 44                   the String class itself - no additional bytes
      byte = 45                   the LargeInteger class itself - no additional bytes
      byte = 46                   the Float class itself - no additional bytes
      byte = 47                   the ByteArray class itself - no additional bytes
      byte = 48                   a symbol of len 1..255 follows; next byte is len, then characters

    added 2003 (FormatVersion == 2):
      byte = 49                   a 32 bit positive integer; 4 bytes of value follow

      (see BinaryIOManagers class init method)

    Object Definitions are
            class id  (1, 2 or 3 bytes) of previously stored class
            followed by
                    non-indexable
                            inst size in next byte
                            'inst size' ids follow
                    indexable
                            inst size in next byte
                            variable size in next 3 bytes
                            'inst size' ids follow
                            'variable size' elements follow

    see implementors of storeBinaryDefinitionOn:manager: & readBinaryContentsFrom:manager:

    Class Definitions are
        'format in next 2 bytes'
        name length in next 2 bytes
        name length bytes of name

    Global Definitions are
        expression length in next two bytes
        'expression' characters follow


    The objects stored as global definitions are collected during 
    BinaryOutputManager>>initialize using the addGlobalsTo:manager: message.  
    It is possible (hopefully easily) to customize this to add your own globals 
    to the set.

    Claus:
        added some more special ids for compact storage (1- and 2- bytes ids,
        character, smallinteger-0 and singleByte smallInteger, stringId etc).
        Also, a class definition consist of additional signature information to
        catch invalid classes at retrieval time.

    Example:
        #(#hello 'world' 1.234 10)

        => #[15 1 42 0 0 4 0 40 41 0 0 0 5 104 101 108 108 111 
             40 44 0 0 0 5 119 111 114 108 100 
             40 46 63 243 190 118 200 180 57 88 10 10]

        #[(15 1  DEF ID=1)
            (42  Array) (0 0 4 size=4) 0 
              (40  DEF ID=NextSeq i.e. 2)
                 (41  Symbol) (0 0 0 5 len=5) 104 101 108 108 111 
              (40  DEF ID=NextSeq i.e. 3)
                 (44  String) (0 0 0 5 len=5) 119 111 114 108 100 
              (40  DEF ID=NextSeq i.e. 4)
                 (46  Float) 63 243 190 118 200 180 57 88 
              (10 10  ByteInteger 10)
        ]

    Example (cyclic reference):
        #(#hello 'world' <selfRef> )

        => #[15 1 42 0 0 3 0 40 41 0 0 0 5 104 101 108 108 111 
             40 44 0 0 0 5 119 111 114 108 100 11 1]


        #[15 1  DEF ID=1
            (42  Array) (0 0 3  size=3) 0 
              (40  DEF ID=NextSeq i.e. 2)
                 (41  Symbol) (0 0 0 5 size=5) 104 101 108 108 111 
              (40  DEF ID=NextSeq i.e. 3)
                 (44  String) (0 0 0 5 size=5) 119 111 114 108 100 
              (11 1  Ref ID=1)
         ]

"
!

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
	and tuned here and there a bit ...
"
!

documentation
"
    I keep track of objects which have already been stored to some stream
    (in objectDictionary) and store objects either by appending the objects 
    contents (for new ones) or by appending its ID (for already stored ones)
    to that stream.

    Usage is:

        |manager|

        manager := BinaryOutputManager new.
        ...
        o1 storeBinaryOn:someStream manager:manager.
        o2 storeBinaryOn:someStream manager:manager.
        ...
        manager release

    This class is based on a manchester goody, but has been adapted and
    enhanced quite a bit. See copyright.

    Added stuff:
        error handling for obsolete objects,
        a more compact format for common objects (strings, numbers etc),
        much tuning,
        configurable ID-keeping
        flush codes (for object transmitting over a stream)
        fix mappings

    [author:]
        Eliot Miranda (eliot@cs.qmc.ac.uk)
        Claus Gittinger

    [See also:]
        BinaryObjectStorage ObsoleteObject
        PersistencyManager
        Object
        (Binary object storage : programming/binaryStorage.html)
"
!

encodingSamples
"
    |out in bytes obj|

    out := #[] writeStream.
    0 storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------

    |out in bytes obj|

    out := #[] writeStream.
    -3000000000 storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------

    |out in bytes obj|

    out := #[] writeStream.
    #[1 2 3] storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------

    |out in bytes obj|

    out := #[] writeStream.
    'hello' storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------

    |out in bytes obj|

    out := #[] writeStream.
    (1 to:255) asByteArray storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------

    |out in bytes obj|

    out := #[] writeStream.
    (0 to:255) asByteArray storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------
    |out in bytes obj|

    out := #[] writeStream.
    #(0 1) storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj

  -----------------------------------------------------
    |out in bytes obj|

    out := #[] writeStream.
    obj := Array new:300.
    1 to:255 do:[:i | obj at:i put:(i@i)].
    obj at:256 put:#[1 1 1 1].
    obj at:257 put:#[2 2 2 2].
    obj storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj.
    obj

  -----------------------------------------------------
    |out in bytes obj|

    out := #[] writeStream.
    obj := Array with:#hello with:'world' with:1.234 with:10.
    obj storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj.
    obj

  result:
    #(#hello 'world' 1.234 10)

  old encoding:
   => #[15 1 42 0 0 4 0 40 41 0 0 0 5 104 101 108 108 111 40 44 0 0 0 5 119 111 114 108 100 40 46 63 243 190 118 200 180 57 88 10 10]

   #[(15 1  DEF ID=1)
       (42 Array) (0 0 4 size=4) 0   standardRep
         (40 DEF ID=NextSeq i.e. 2)
           (41 SymbolClass) (0 0 0 5 len=5) 104 101 108 108 111 
         (40 DEF ID=NextSeq i.e. 3)
           (44 StringClass) (0 0 0 5 len=5) 119 111 114 108 100 
         (40 DEF ID=NextSeq i.e. 4)
           (46 FloatClass) 63 243 190 118 200 180 57 88 
         (10 10  ByteInteger 10)
    ]

   new encoding:
      #[15 1 42 0 0 4 0 40 48 5 104 101 108 108 111 40 13 5 119 111 114 108 100 40 46 63 243 190 118 200 180 57 88 10 10]

   #[(15 1  DEF ID=1)
       (42 Array) (0 0 4 size=4) 0  standardRep
         (40 DEF ID=NextSeq i.e. 2)
           (48 Symbol1) (5 len=5) 104 101 108 108 111 
         (40 DEF ID=NextSeq i.e. 3)
           (13 String1) (5 len=5) 119 111 114 108 100 
         (40 DEF ID=NextSeq i.e. 4)
           (46 FloatClass) 63 243 190 118 200 180 57 88 
         (10 10  ByteInteger 10)
    ]

  -----------------------------------------------------
    |out in bytes obj|

    out := #[] writeStream.
    obj := Array with:#hello with:'world' with:nil.
    obj at:3 put:obj.
    obj storeBinaryOn:out.
    bytes := out contents.
    Transcript show:'encoding: '; showCR:bytes storeString.

    in := bytes readStream.
    obj := Object readBinaryFrom:in.
    Transcript showCR:obj.
    obj

  structure:
    #(#hello 'world' <selfRef> )

  old encoding:
    => #[15 1 42 0 0 3 0 40 41 0 0 0 5 104 101 108 108 111 40 44 0 0 0 5 119 111 114 108 100 11 1]


  #[15 1   DEF ID=1
   (42 Array) (0 0 3  size=3)
               0  standardRep
    (40 DEFNext)
        (41 SymbolClass) (0 0 0 5 size=5) 104 101 108 108 111 
    (40 DEFNext)
        (44 StringClass) (0 0 0 5 size=5) 119 111 114 108 100 
    (11 1 Ref ID=1)
  ]

  new encoding:
    => #[15 1 42 0 0 3 0 40 48 5 104 101 108 108 111 40 13 5 119 111 114 108 100 11 1]

  #[15 1   DEF ID=1
   (42 Array) (0 0 3  size=3)
               0   standardRep
    (40 DEFNext)
        (48 Symbol) (5 size=5) 104 101 108 108 111 
    (40 DEFNext)
        (13 String) (5 size=5) 119 111 114 108 100 
    (11 1 Ref ID=1)
  ]

  -----------------------------------------------------
"
!

examples
"
    BinaryInputManager and BinaryOutputManager are usually accessed indirectly,
    either via the BinaryObjectStorage protocol, or
    by sending #storeBinaryTo: to some object or #readBinaryFrom: to some class.

    The following examples show these uses.

  storing into a byteStream:
                                                                        [exBegin]
        |someObject aStream|

        someObject := (1 to:99) asArray.
        aStream := ByteArray new writeStream.
        someObject storeBinaryOn:aStream.
        aStream contents inspect.
                                                                        [exEnd]

  storing in a file:
                                                                        [exBegin]
        |someObject aStream|

        someObject := Dictionary new.
        someObject at:'one' put:#one.
        someObject at:'two' put:'two'.
        someObject at:#three put:#3.
        someObject at:'four' put:4.0.
        someObject at:'five' put:#(1 2 3 4 5).

        aStream := 'foo.bin' asFilename writeStream.
        someObject storeBinaryOn:aStream.
        aStream close.
                                                                        [exEnd]


  reading from a file:
                                                                        [exBegin]
        |aStream someObject|

        aStream := 'foo.bin' asFilename readStream.
        someObject := Object readBinaryFrom:aStream.
        aStream close.
        someObject inspect.
                                                                        [exEnd]

    Storing (and reading) a class (only the class name and signature is stored):
                                                                        [exBegin]
        |manager aStream|

        manager := BinaryOutputManager new.
        aStream := ByteArray new readWriteStream.
        CParser storeBinaryOn:aStream manager:manager.
        aStream contents inspect.
        aStream reset.
        (Object readBinaryFrom:aStream) inspect
                                                                        [exEnd]


    Storing a class (with source and byte code):
                                                                        [exBegin]
        |manager aStream|

        manager := BinaryOutputManager new sourceMode:#keep; storeMethodBytecode:true.
        aStream := ByteArray new readWriteStream.
        CParser storeBinaryClassOn:aStream manager:manager.
        aStream contents inspect.
        aStream reset.
        (Object readBinaryFrom:aStream) inspect
                                                                        [exEnd]

    Storing a global (as a reference):
                                                                        [exBegin]
        |manager aStream|

        manager := BinaryOutputManager new reloadGlobals:true.
        aStream := ByteArray new readWriteStream.
        Stderr storeBinaryOn:aStream manager:manager.
        aStream contents inspect.
        aStream reset.
        (Object readBinaryFrom:aStream) inspect
                                                                        [exEnd]


  a cyclic object:
    writing:
                                                                        [exBegin]
        |cycle this last aStream|

        cycle := Array new:2.
        this := cycle.
        1 to:4 do:[:index |
            this at:1 put:index.
            last := this.
            last at:2 put:(this := Array new:2)
        ].
        this at:1 put:5.
        this at:2 put:cycle.

        aStream := 'foo.bin' asFilename writeStream.
        cycle storeBinaryOn:aStream.
        aStream close.
                                                                        [exEnd]


    reading:
                                                                        [exBegin]
        |aStream someObject|

        aStream := 'foo.bin' asFilename readStream.
        someObject := Object readBinaryFrom:aStream.
        aStream close.
        someObject inspect.
                                                                        [exEnd]

  migrating instances of obsolete classes:
                                                                        [exBegin]
    |origObj fn bos child newObj|

    Class withoutUpdatingChangesDo:[
        HierarchicalItem subclass:#XHierarchicalItem
            instanceVariableNames:''
            classVariableNames:''
            poolDictionaries:''
            category:'Views-Support'.
    ].

    origObj := XHierarchicalItem  new.
    child := XHierarchicalItem new.
    origObj add: child.
    child instVarNamed:#width put:XHierarchicalItem.

    fn := '/tmp/testBOS' asFilename.
    bos :=  BinaryObjectStorage onNew: (fn writeStream).
    bos nextPut: origObj.
    bos close.

    origObj inspect.

    Class withoutUpdatingChangesDo:[
        XHierarchicalItem addInstVarName:'foo'
    ].

    fn := '/tmp/testBOS' asFilename.

    bos := BinaryObjectStorage onOld: fn readStream.
    BinaryIOManager requestConversionSignal handle:[:ex|
        | oldObject newClass |

        newClass := ex parameter key.
        oldObject := ex parameter value.
        Transcript showCR: 'converting...'.
        ex proceedWith: (newClass cloneFrom: oldObject).
    ] do:[
        BinaryIOManager invalidClassSignal handle:[:ex2|
            | oldClass newClass proceedClass |

            newClass := Smalltalk at: ex2 parameter name asSymbol.
            oldClass := ex2 parameter.

            Transcript showCR: 'will convert instance of ',oldClass name.
            ((newClass isSubclassOf: HierarchicalItem) or:[newClass == HierarchicalItem]) 
                ifTrue:[proceedClass := newClass] 
                ifFalse:[proceedClass := oldClass].
            ex2 proceedWith: proceedClass.
        ] do:[
            newObj := bos next.
            newObj inspect.
        ].
    ].
                                                                        [exEnd]
"
! !

!BinaryOutputManager class methodsFor:'initialization'!

deinitialize
    Smalltalk removeDependent:self
!

initialize
    "want to get informed about changes in the globals
     (Smalltalk) dictionary"

    LastGlobalsSize := 200.
    ReloadGlobals := false.
    ReloadGlobals ifTrue:[
        Smalltalk addDependent:self
    ]

    "Modified: 21.3.1997 / 15:30:45 / cg"
!

initializeGlobals
    "Get the system (Smalltalk) to register all objects it considers 'global'
     to the Globals table.  Such objects will not be stored; instead an expression
     is stored which (when evaluated) references the global.
     Arbitrary objects may be defined as globals. (use the messages menu item &
     look for implementors of addGlobalsTo:manager:).

    The default is to define as global
            globals in Smalltalk,
            classes,
            class variables & pool variables.

    Collecting the globals takes about 2 seconds (cg: in ST2.4).
    If this is too much time per object
    a default set of globals could be maintained in a class variable.

    cg: although it does not take 2secs, it is still too slow, to
        create the global table for each store. Therefore, the globals
        are cached, once the globals table is built. By being dependent
        on Smalltalk, we get informed when this is no longer up-to-date.
    "

    Globals := IdentityDictionary new:LastGlobalsSize.
    Smalltalk addGlobalsForBinaryStorageTo:Globals.
    LastGlobalsSize := Globals size + 100.
    Smalltalk addDependent:self.

    "Modified: 21.3.1997 / 15:41:37 / cg"
!

installCleanup
    "arrange that the cached globals collection is released some time
     after the store ..."

    Globals notNil ifTrue:[
        CleanupAction isNil ifTrue:[
            CleanupAction := [CleanupAction := Globals := nil].
        ].
        Processor addTimedBlock:CleanupAction for:Processor timeoutHandlerProcess afterSeconds:30.
    ]

    "Created: 21.3.1997 / 15:31:43 / cg"
    "Modified: 21.3.1997 / 15:39:06 / cg"
!

releaseGlobals
    "flush my list-of-known-globals"

    CleanupAction notNil ifTrue:[
        Processor removeTimedBlock:CleanupAction.
    ].
    CleanupAction := Globals := nil
! !

!BinaryOutputManager class methodsFor:'instance creation'!

new
    "return a new binaryOutput manager"

    ^ self basicNew initializeForSize:nil.

    "Modified: / 1.11.1997 / 16:51:18 / cg"
!

newForSize:numberOfObjectsToStoreOrNil
    "return a new binaryOutput manager .
     numberOfObjectsToStoreOrNil is the number of unique objects we expect to store. 
     If numberOfObjectsToStoreOrNil is too small, we have to grow the Dictionary, which is slow."

    ^ self basicNew initializeForSize:numberOfObjectsToStoreOrNil.

    "Modified: / 1.11.1997 / 16:51:18 / cg"
! !

!BinaryOutputManager class methodsFor:'binary storage'!

store:anObject on:aStreamOrFilename
    "store anObject in a binary form.
     If the stream argument is a string, a file with that
     name is created and the object stored into that."

    self store:anObject on:aStreamOrFilename using:nil

    "Modified: / 2.11.1997 / 11:12:41 / cg"
!

store:anObject on:aStreamOrFilename using:fixObjectToIdMapping
    "store anObject in a binary form.
     If the stream argument is a string, a file with that
     name is created and the object stored into that.
     The mapping argument contains fix object->id
     mappings, which is used while storing (i.e. objects 
     contained there are stored by id - not by value)"

    |manager|

    manager := self new.
    fixObjectToIdMapping notNil ifTrue:[
        manager fixObjectToIdMapping:fixObjectToIdMapping.
    ].
    manager store:anObject on:aStreamOrFilename.
    self installCleanup

    "Created: / 2.11.1997 / 02:46:45 / cg"
    "Modified: / 2.11.1997 / 13:47:00 / cg"
! !

!BinaryOutputManager class methodsFor:'update'!

update:something with:someArgument from:someone
    "when Smalltalk changes, flush my list-of-known-globals"

    someone == Smalltalk ifTrue:[
        self releaseGlobals.
    ]

    "
     Smalltalk changed
    "
! !

!BinaryOutputManager methodsFor:'access-storing'!

putIdOf:anObject on:aStream
    "{ Pragma: +optSpeed }"

    "append anObject's binary representation to aStream.
     If it has already been stored, simply append the ID;
     otherwise, assign it a new ID, and store its contents"

    |objectId owner val|

    "/
    "/ we handle these common cases first ...
    "/
    anObject isNil ifTrue:[
        aStream nextPut:NilType.
        ^ self
    ].
    anObject == true ifTrue:[
        aStream nextPut:TrueType.
        ^ self
    ].
    anObject == false ifTrue:[
        aStream nextPut:FalseType.
        ^ self
    ].
    anObject class == SmallInteger ifTrue:[
        val := anObject.

        val < 0 ifTrue:[
            val := val negated.
            "/ val is known to be positive here ...
            val <= 16rFF ifTrue:[
                val == 1 ifTrue:[
                    aStream nextPut:MinusOneType.
                    ^ self
                ].
                aStream nextPut:NegativeByteIntegerType; nextPut:val.
                ^ self
            ].
            val digitLength <= 4 ifTrue:[
                aStream nextPut:NegativeIntegerType.
                aStream nextPutInt32:val MSB:true.
                ^ self
            ].
            val digitLength <= 8 ifTrue:[            
                "/ a 64bit smallInt
                aStream nextPut:BigNegativeIntegerType.
                aStream nextPutInt64:val MSB:true.
                ^ self
            ].
            self error:'128bit architecture ?'   
        ].

        (val <= 16rFF) ifTrue:[
            val == 0 ifTrue:[
                aStream nextPut:ZeroType.
                ^ self
            ].
            val == 1 ifTrue:[
                aStream nextPut:OneType.
                ^ self
            ].
            aStream nextPut:ByteIntegerType; nextPut:val.
            ^ self
        ].
        (val <= 16rFFFF) ifTrue:[
            aStream nextPut:ShortIntegerType. 
            aStream nextPutInt16MSB:val.
            ^ self
        ].

        val digitLength <= 4 ifTrue:[
            (val bitAnd: 16r80000000) == 0 ifTrue:[
                "/ a 31 bit positive integer - store without extra byte, using TAG
                aStream nextPutInt32:(val bitOr:16r80000000) MSB:true.
                ^ self
            ].
        ]. 
    ].

    anObject isInteger ifTrue:[
        anObject digitLength <= 4 ifTrue:[
            anObject < 0 ifTrue:[
                aStream nextPut:NegativeIntegerType.
                aStream nextPutInt32:anObject negated MSB:true.
                ^ self.
            ].
            "/ old format did not have IntegerType-byte.
            usedFormat >= 2 ifTrue:[
                aStream nextPut:IntegerType.
                aStream nextPutInt32:anObject MSB:true.
                ^ self.
            ].
        ].

        anObject digitLength <= 8 ifTrue:[
            anObject < 0 ifTrue:[
                aStream nextPut:BigNegativeIntegerType.
                aStream nextPutInt64:anObject negated MSB:true.
            ] ifFalse:[
                aStream nextPut:BigIntegerType.
                aStream nextPutInt64:anObject MSB:true.
            ].
            ^ self.
        ].
    ].

    "/
    "/ other specially encoded stuff
    "/
    anObject hasSpecialBinaryRepresentation ifTrue: [
        ^ anObject storeBinaryOn:aStream manager:self
    ].

    objectId := objectToIdMapping findValueOrNil:anObject.
    objectId isNil ifTrue:[
        fixObjectToIdMapping notNil ifTrue:[
            objectId := fixObjectToIdMapping findValueOrNil:anObject.
        ]
    ].
    objectId notNil ifTrue: [
        "
         already stored ...
        "
        objectId <= 16rFF ifTrue:[
            ^ aStream nextPut:Id1Type; nextPut:objectId
        ].
        objectId <= 16rFFFF ifTrue:[
            ^ aStream nextPut:Id2Type; nextPutInt16MSB:objectId
        ].
        ^ aStream nextPut:IdType; nextNumber:3 put:objectId MSB:true
    ].

    "/ new: classes first ...
    "/ this avoids classes in globals / classVars to be stored in full ...
    
    anObject isBehavior ifTrue:[
        objectId := lastId := lastId + 1.
        objectToIdMapping at:anObject putNew:objectId.

        anObject isMeta ifTrue:[
            aStream nextPut:MetaType; nextNumber:3 put:objectId MSB:true.
            anObject soleInstance storeBinaryDefinitionOn:aStream manager:self.
        ] ifFalse:[
            objectId <= 16rFF ifTrue:[
                aStream nextPut:Class1Type; nextPut:objectId
            ] ifFalse:[
                objectId <= 16rFFFF ifTrue:[
                    aStream nextPut:Class2Type; nextPutInt16MSB:objectId
                ] ifFalse:[
                    aStream nextPut:ClassType; nextNumber:3 put:objectId MSB:true.
                ]
            ].
            anObject storeBinaryDefinitionOn:aStream manager:self.
        ].
        ^ self
    ].

    reloadGlobals ifTrue:[
        Globals isNil ifTrue:[
            self class initializeGlobals
        ].

        (owner := Globals at:anObject ifAbsent:[]) notNil ifTrue: [
            "/ something considered global; to be recreated by
            "/ asking the owner at load time.

            objectId := lastId := lastId + 1.     
            objectToIdMapping at:anObject putNew:objectId.     
            aStream nextPut:GlobalType; nextNumber:3 put:objectId MSB:true.
            (owner key) storeBinaryDefinitionOf:owner value on:aStream manager:self.
            ^ self.
        ]
    ].

    keepReferences ifFalse:[
        aStream nextPut:ObjectCorpsType.
        objectToIdMapping flushEmptySlotCache.
    ] ifTrue:[
        objectId := lastId := lastId + 1.
        objectToIdMapping at:anObject putNew:objectId.

        (lastObjDefId notNil
        and:[(lastObjDefId + 1) == objectId]) ifTrue:[
            aStream nextPut:ObjectSeqType
        ] ifFalse:[
            lastId <= 16rFF ifTrue:[
                aStream nextPut:Object1Type; nextPut:objectId
            ] ifFalse:[
                lastId <= 16rFFFF ifTrue:[
                    aStream nextPut:Object2Type; nextPutInt16MSB:objectId
                ] ifFalse:[
                    aStream nextPut:ObjectType; nextNumber:3 put:objectId MSB:true.
                ]
            ]
        ].
        lastObjDefId := objectId.
    ].
    anObject storeBinaryDefinitionOn:aStream manager:self.

    "Modified: / 2.11.1997 / 10:39:20 / cg"
!

putIdOfClass:aClass on:aStream
    "{ Pragma: +optSpeed }"

    "a slightly stripped down (less checking) version of putIdOf:on:;
     to be called if it's known to be a class.
     To speed up things a bit for large homogenous collections,
     it keeps the last classes id - avoids a lookup operation for the
     class when storing these.
     Not for normal use ..."

    |objectId classCode|

    "/ can avoid lookup of the class object, if multiple instances
    "/ of the same class come along in a sequence ...
    aClass == lastClass ifTrue:[
        objectId := lastClassId
    ] ifFalse:[
        objectId := objectToIdMapping findValueOrNil:aClass.
        objectId isNil ifTrue:[
            fixObjectToIdMapping notNil ifTrue:[
                objectId := fixObjectToIdMapping findValueOrNil:aClass.
            ]
        ]
    ].

    objectId notNil ifTrue: [
        "
         already stored ...
        "
        objectId <= 16rFF ifTrue:[
            ^ aStream nextPut:Id1Type; nextPut:objectId
        ].
        objectId <= 16rFFFF ifTrue:[
            ^ aStream nextPut:Id2Type; 
                      nextPutInt16MSB:objectId
        ].
        ^ aStream nextPut:IdType; 
                  nextNumber:3 put:objectId MSB:true
    ].

    classCode := SpecialClassTypes at:aClass ifAbsent:[nil].
    classCode notNil ifTrue:[
        aStream nextPut:classCode.
        ^ self
    ].

    objectToIdMapping at:aClass putNew:(objectId := lastId := lastId + 1).

    "/ new: classes first
    
    objectId <= 16rFF ifTrue:[
"/
"/ NO LONGER generated; but still understood when
"/ reading binaries (for backward compatibility).
"/
"/        classCode := SpecialClassDefTypes at:aClass ifAbsent:[nil].
"/        classCode notNil ifTrue:[
"/            aStream nextPut:classCode; nextPut:objectId.
"/            ^ self
"/        ].
        aStream nextPut:Class1Type; nextPut:objectId
    ] ifFalse:[
        objectId <= 16rFFFF ifTrue:[
            aStream nextPut:Class2Type; nextPutInt16MSB:objectId
        ] ifFalse:[
            aStream nextPut:ClassType; nextNumber:3 put:objectId MSB:true.
        ]
    ].
    aClass storeBinaryDefinitionOn:aStream manager:self.
    lastClass := aClass.
    lastClassId := objectId.

    "Modified: / 07-03-1996 / 11:39:43 / stefan"
    "Modified: / 02-11-1997 / 10:39:27 / cg"
    "Modified (comment): / 13-02-2017 / 19:56:07 / cg"
! !

!BinaryOutputManager methodsFor:'accessing'!

keepReferences:aBoolean
    "turn on/off caching of objectIds. Usually, it does not make sense to turn it off.
     (better use the flushing protocol)"

    keepReferences := aBoolean

    "Modified: 1.3.1996 / 22:09:56 / cg"
!

reloadGlobals
    ^ reloadGlobals
!

reloadGlobals:aBoolean
    "if true, references to global values are stored"

    reloadGlobals := aBoolean.
!

sourceMode
    "return the sourceMode - I do nothing with it, but classes being stored ask for it"

    ^ sourceMode

    "Modified: 1.3.1996 / 22:09:24 / cg"
!

sourceMode:aSymbol
    "remember the sourceMode - I do nothing with it, but classes being stored ask for it.
     The argument controls how sources are to be saved:
        #keep - include the source
        #reference - include a reference to the sourceFile
        #discard - don't save sources.

     With #reference, the sourceFile needs to be present after reload
     in order to be browsable."

    sourceMode := aSymbol

    "Modified: 1.3.1996 / 22:09:17 / cg"
!

storeMethodBytecode
    ^ storeMethodBytecode
!

storeMethodBytecode:aBoolean
    "set to true, to always store a method's bytecode"

    storeMethodBytecode := aBoolean.
! !

!BinaryOutputManager methodsFor:'binary storage'!

store:anObject on:aStreamOrFilename
    "store anObject in a binary form.
     If the stream argument is a string, a file with that
     name is created and the object stored into that."

    |fileStream|

    aStreamOrFilename isStream ifFalse:[
        fileStream := aStreamOrFilename asFilename writeStream.
        [
            fileStream binary.
            anObject storeBinaryOn: fileStream manager: self.
        ] ensure:[
            fileStream close
        ].    
    ] ifTrue: [
        aStreamOrFilename binary.
        anObject storeBinaryOn:aStreamOrFilename manager:self
    ].
! !

!BinaryOutputManager methodsFor:'initialization & release'!

initializeForSize:numberOfObjectsToStoreOrNil
    "Initialize myself for subsequent binary output of some object.
     numberOfObjectsToStoreOrNil is the number of unique objects we expect to store. 
     If numberOfObjectsToStoreOrNil is too small, we have to grow the Dictionary, which is slow."

    objectToIdMapping isNil ifTrue:[
        objectToIdMapping := ObjectDictionary new:(numberOfObjectsToStoreOrNil ? 113).
    ].

    lastId := 0.
    lastObjDefId := nil.
    sourceMode := #keep.
    storeMethodBytecode := false.
    keepReferences := true.
    usedFormat := FormatVersion.
    reloadGlobals := ReloadGlobals.

    CleanupAction notNil ifTrue:[
        "/ don't want cleanups to occur now ...
        Processor removeTimedBlock:CleanupAction.
        CleanupAction := nil.       
    ].

    ReloadGlobals ifTrue:[
        Globals isNil ifTrue:[
            self class initializeGlobals
        ]
    ].

    "Modified: / 2.11.1997 / 10:37:36 / cg"
!

release 
    "release the cached globals collection and any dependencies"

    self class releaseGlobals.
    super release.

    "Modified: 11.6.1997 / 13:17:29 / cg"
! !

!BinaryOutputManager methodsFor:'private-flushing'!

flushClassIDs
    "remove all cached object -> classID associations."
    |maxId|

    maxId := 0.
    objectToIdMapping keysAndValuesDo:[:obj :id |
        obj isBehavior ifTrue:[
            objectToIdMapping safeRemoveKey:obj
        ] ifFalse:[
            id > maxId ifTrue:[
                maxId := id.
            ]
        ]
    ].
    objectToIdMapping possiblyShrink; flushEmptySlotCache.
    lastClass := nil.
    lastId := maxId.
    lastObjDefId := nil.

    "Created: / 4.3.1996 / 17:18:47 / stefan"
    "Modified: / 7.3.1996 / 11:28:02 / stefan"
    "Modified: / 2.11.1997 / 10:37:45 / cg"
!

flushIDs
    "remove all cached ID -> object associations."

    objectToIdMapping removeAll.
    lastId := 0.
    lastClass := nil.
    lastObjDefId := nil.

    "Modified: / 2.11.1997 / 10:37:51 / cg"
!

flushInstanceIDs
    "remove all cached object -> non-classID  associations."
    |maxId|

    maxId := 0.
    objectToIdMapping keysAndValuesDo:[ :obj :id |
        obj isBehavior ifFalse:[
            objectToIdMapping safeRemoveKey:obj
        ] ifTrue:[
            id > maxId ifTrue:[
                maxId := id.
            ]
        ]
    ].
    objectToIdMapping possiblyShrink; flushEmptySlotCache.
    lastId := maxId.
    lastObjDefId := nil.

    "Created: / 1.3.1996 / 22:10:55 / cg"
    "Modified: / 7.3.1996 / 11:27:49 / stefan"
    "Modified: / 2.11.1997 / 10:37:58 / cg"
! !

!BinaryOutputManager methodsFor:'special accessing'!

fixObjectToIdMapping:anIdentityDictionary
    "preset the objectDictionary to include the associations
     given by the argument, anIdentityDictionary.
     This must contain object->id associations, typically for classes.
     This is a non-public entry for the PersistencyManager."

    |maxId|

    maxId := 0.
    anIdentityDictionary do:[:anId |
        anId > maxId ifTrue:[
            maxId := anId
        ]
    ].
    self fixObjectToIdMapping:anIdentityDictionary nextId:(maxId + 1)

    "Created: / 2.11.1997 / 10:39:47 / cg"
    "Modified: / 2.11.1997 / 13:43:51 / cg"
!

fixObjectToIdMapping:anIdentityDictionary nextId:nextId
    "preset the objectDictionary to include the associations
     given by the argument, anIdentityDictionary.
     This must contain object->id associations, typically for classes.
     This is a non-public entry for the PersistencyManager."

    fixObjectToIdMapping := anIdentityDictionary.
    lastId := nextId.
    lastClass := lastClassId := lastObjDefId := nil.

    "Modified: / 2.11.1997 / 10:10:50 / cg"
    "Created: / 2.11.1997 / 13:40:36 / cg"
!

objectToIdMapping
    "This is a non-public entry for the PersistencyManager."

    ^ objectToIdMapping

    "Created: / 2.11.1997 / 12:58:37 / cg"
    "Modified: / 2.11.1997 / 13:45:05 / cg"
! !

!BinaryOutputManager methodsFor:'special-flushing'!

flushClassesOn:aStream
    "forget all cached classIDs, and also append a flushCode for reader to do this
     when it reads the stream"

    aStream nextPut:FlushClassIDType.
    self flushClassIDs

    "Created: 1.3.1996 / 22:05:58 / cg"
    "Modified: 1.3.1996 / 22:12:31 / cg"
    "Modified: 4.3.1996 / 23:01:56 / stefan"
!

flushInstancesOn:aStream
    "forget all cached non-classIDs, and also append a flushCode for reader to do this
     when it reads the stream"

    aStream nextPut:FlushInstanceIDType.
    self flushInstanceIDs

    "Created: 1.3.1996 / 22:06:43 / cg"
    "Modified: 1.3.1996 / 22:12:43 / cg"
    "Modified: 4.3.1996 / 23:02:05 / stefan"
!

flushOn:aStream
    "forget all cached IDs, and also append a flushCode for reader to do this
     when it reads the stream"

    aStream nextPut:FlushIDType.
    self flushIDs

    "Created: 1.3.1996 / 22:11:59 / cg"
    "Modified: 1.3.1996 / 22:12:53 / cg"
    "Modified: 4.3.1996 / 23:02:14 / stefan"
! !

!BinaryOutputManager::ObjectDictionary class methodsFor:'instance creation'!

new
    "choose a larger default size, we store probably more than 7 objects"

    ^ self new:113.
! !

!BinaryOutputManager::ObjectDictionary methodsFor:'adding & removing'!

flushEmptySlotCache
    emptySlotIndex := nil.

    "Created: / 1.11.1997 / 16:36:43 / cg"
!

removeAll
    super removeAll.
    emptySlotIndex := nil.

    "Created: / 1.11.1997 / 16:35:57 / cg"
! !

!BinaryOutputManager::ObjectDictionary methodsFor:'private-dictionary access'!

at:aKey putNew:anObject
    "{ Pragma: +optSpeed }"

    "add the argument anObject under key, aKey to the receiver.
     Return anObject (sigh).
     Here, we know that aKey is nonNil and not already present in the 
     receiver.
     Also, make use of the emptySlotIndex information,
     which is left as a side effect of findValueOrNil.
     (a kludge and not too elegant, but speeds up saving ...)"

    |index "{ Class: SmallInteger }"|

    emptySlotIndex notNil ifTrue:[
        index := emptySlotIndex.
        emptySlotIndex := nil
    ] ifFalse:[
        index := self findKeyOrNil:aKey.
    ].

    "/ a new key
    keyArray basicAt:index put:aKey.
    valueArray basicAt:index put:anObject.
    tally := tally + 1.

    self possiblyGrow.
    ^ anObject

    "Created: / 19.3.1997 / 14:24:04 / cg"
    "Modified: / 1.11.1997 / 16:28:45 / cg"
!

findKeyOrNil:key
    "{ Pragma: +optSpeed }"

    "Look for the key in the receiver.  
     If it is found, return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present.
     Redefined for top speed using inline C &
     knowning that elements are never removed."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe mustGrow|

    length := keyArray basicSize.
    index := key identityHashForBinaryStore.
    index := index \\ (length // 2).
    index := index * 2 + 1.

%{
    OBJ kA = __INST(keyArray);
    OBJ vA = __INST(valueArray);
    OBJ __probe;
    OBJ *__keys, *__values;
    int __index, __length, __startIndex;
    int __limit8;

    if (__isArray(kA)
     && __isArray(vA)
     && __isSmallInteger(index)
     && __isSmallInteger(length)) {
        __keys = __ArrayInstPtr(kA)->a_element;
        __values = __ArrayInstPtr(vA)->a_element;
        __index = __startIndex = __intVal(index);
        __length = __intVal(length);

        /*
         * part 1 - from startIndex up to end
         */
        __limit8 = __length - 8;
        while (__index < __limit8) {
            __probe = __keys[__index-1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index) );
            }
            __probe = __keys[__index-1+1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+1) );
            }
            __probe = __keys[__index-1+2];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+2) );
            }
            __probe = __keys[__index-1+3];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+3) );
            }
            __probe = __keys[__index-1+4];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+4) );
            }
            __probe = __keys[__index-1+5];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+5) );
            }
            __probe = __keys[__index-1+6];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+6) );
            }
            __probe = __keys[__index-1+7];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+7) );
            }
            __index += 8;
        }

        for (;;) {
            __probe = __keys[__index-1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index) );
            }
            if (__index == __length) {
                __index = 1;
                break;
            }
            __index++;
        }

        /*
         * part 2 - from 1 to startIndex
         */
        __limit8 = __startIndex - 8;
        while (__index < __limit8) {
            __probe = __keys[__index-1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index) );
            }
            __probe = __keys[__index-1+1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+1) );
            }
            __probe = __keys[__index-1+2];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+2) );
            }
            __probe = __keys[__index-1+3];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+3) );
            }
            __probe = __keys[__index-1+4];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+4) );
            }
            __probe = __keys[__index-1+5];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+5) );
            }
            __probe = __keys[__index-1+6];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+6) );
            }
            __probe = __keys[__index-1+7];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index+7) );
            }
            __index += 8;
        }

        for (;;) {
            __probe = __keys[__index-1];
            if ((__probe == nil) || (__probe == key)) {
                RETURN ( __MKSMALLINT(__index) );
            }
            __index++;
            if (__index == __startIndex) {
                mustGrow = true;
                break;
            }
        }
    }
%}.

    mustGrow == true ifTrue:[
        ^ self grow findKeyOrNil:key
    ].

    "/ non-C code; never executed.

    startIndex := index.
    [true] whileTrue:[
        probe := keyArray basicAt:index.
        key == probe ifTrue:[^ index].
        probe isNil ifTrue:[
            ^ index.
        ].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            ^ self grow findKeyOrNil:key
        ].
    ]

    "Modified: 26.3.1996 / 20:00:44 / cg"
    "Created: 19.3.1997 / 13:22:04 / cg"
!

findNil:key
    "Look for the next slot usable for key.  
     WARNING:
        This method assumes that key is not already in the receiver 
        AND that keyArray does not have previously removed entries 
        AND that there is an empty slot.
     To be used ONLY while growing/rehashing to enter elements into a fresh
     collection - if any of the above conditions is not met, the method
     loops forever."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"|

    length := keyArray basicSize.
    index := key identityHashForBinaryStore.
    index := index \\ (length // 2).
    index := index * 2 + 1.

    [(keyArray basicAt:index) notNil] whileTrue:[
        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        "notice: no check for no nil found - we must find one since
         this is only called after growing"
    ].
    ^ index

    "Modified: / 1.11.1997 / 16:28:46 / cg"
!

findValueOrNil:key
    "{ Pragma: +optSpeed }"

    "Look for the key in the receiver.  If it is found, return
     the value stored under the key; otherwise return nil.
     As a courtesy to a followup at:put:, leave the index of
     an empty slot in emptySlotIndex if there is any."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe|

    length := keyArray basicSize.
    index := key identityHashForBinaryStore.
    index := index \\ (length // 2).
    index := index * 2 + 1.

%{
    OBJ kA = __INST(keyArray);
    OBJ vA = __INST(valueArray);
    OBJ __probe;
    OBJ *__keys, *__values;
    int __index, __length, __startIndex;
    int __limit8;

    if (__isArray(kA)
     && __isArray(vA)
     && __isSmallInteger(index)
     && __isSmallInteger(length)) {
        __keys = __ArrayInstPtr(kA)->a_element;
        __values = __ArrayInstPtr(vA)->a_element;
        __index = __startIndex = __intVal(index);
        __length = __intVal(length);

        /*
         * part 1 - from startIndex up to end
         */
        __limit8 = __length - 8;
        while (__index < __limit8) {
            __probe = __keys[__index-1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1] );
            }
            __probe = __keys[__index-1+1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+1);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+1] );
            }
            __probe = __keys[__index-1+2];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+2);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+2] );
            }
            __probe = __keys[__index-1+3];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+3);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+3] );
            }
            __probe = __keys[__index-1+4];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+4);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+4] );
            }
            __probe = __keys[__index-1+5];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+5);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+5] );
            }
            __probe = __keys[__index-1+6];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+6);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+6] );
            }
            __probe = __keys[__index-1+7];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+7);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+7] );
            }
            __index += 8;
        }
        for (;;) {
            __probe = __keys[__index-1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1] );
            }
            if (__index == __length) {
                __index = 1;
                break;
            }
            __index++;
        }

        /*
         * part 2 - from 1 to startIndex
         */
        __limit8 = __startIndex - 8;
        while (__index < __limit8) {
            __probe = __keys[__index-1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1] );
            }
            __probe = __keys[__index-1+1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+1);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+1] );
            }
            __probe = __keys[__index-1+2];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+2);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+2] );
            }
            __probe = __keys[__index-1+3];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+3);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+3] );
            }
            __probe = __keys[__index-1+4];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+4);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+4] );
            }
            __probe = __keys[__index-1+5];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+5);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+5] );
            }
            __probe = __keys[__index-1+6];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+6);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+6] );
            }
            __probe = __keys[__index-1+7];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index+7);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1+7] );
            }
            __index += 8;
        }
        for (;;) {
            __probe = __keys[__index-1];
            if (__probe == nil) {
                __INST(emptySlotIndex) = __MKSMALLINT(__index);
                __INST(emptySlotKey) = key; __STORE(self, key);
                RETURN ( nil );
            }
            if (__probe == key) {
                RETURN ( __values[__index-1] );
            }
            __index++;
            if (__index == __startIndex) {
                __INST(emptySlotIndex) = nil;
                RETURN ( nil );
            }
        }
    }
%}.
    "/ non-C code; never executed.

    startIndex := index.
    [true] whileTrue:[
        probe := (keyArray basicAt:index).
        probe isNil ifTrue:[emptySlotIndex := index. ^ nil].
        key == probe ifTrue:[^ valueArray basicAt: index].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        (index == startIndex) ifTrue:[emptySlotIndex := nil. ^ nil].
    ]
!

hashFor:aKey
    "return an initial index given a key."

    ^ aKey identityHashForBinaryStore

    "Modified: / 1.11.1997 / 16:28:47 / cg"
!

initialIndexForKey:aKey
    "return an initial index given a key."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"|

    length := keyArray basicSize.
    index := aKey identityHashForBinaryStore.
    index := index \\ (length // 2).
    index := index * 2 + 1.
    ^ index

    "Modified: / 1.11.1997 / 16:28:48 / cg"
! !

!BinaryOutputManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/BinaryOutputManager.st,v 1.74 2017-02-13 19:09:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libboss/BinaryOutputManager.st,v 1.74 2017-02-13 19:09:17 cg Exp $'
! !


BinaryOutputManager initialize!
