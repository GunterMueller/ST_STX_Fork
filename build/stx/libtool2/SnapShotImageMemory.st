"{ Encoding: utf8 }"

"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SnapShotImageMemory
	instanceVariableNames:'image stream msb ptrSize intSize intTag spaceInfos symbolEntries
		globalEntries addrToObjectMapping fetchINT hdrSize'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

Object subclass:#ImageHeader
	instanceVariableNames:'memory address classRef bits byteSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

SnapShotImageMemory::ImageHeader variableSubclass:#ImageObject
	instanceVariableNames:'cachedContents'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

SnapShotImageMemory::ImageHeader variableByteSubclass:#ImageByteObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

SnapShotImageMemory::ImageObject variableSubclass:#ImageMethodObject
	instanceVariableNames:'cachedPackage cachedMClass cachedSelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

SnapShotImageMemory::ImageObject variableSubclass:#ImageClassObject
	instanceVariableNames:'cachedCategory cachedFlags cachedName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

SnapShotImageMemory::ImageHeader variableWordSubclass:#ImageWordObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

Object subclass:#SpaceInfo
	instanceVariableNames:'start end size flags imageBase'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapShotImageMemory
!

!SnapShotImageMemory class methodsFor:'documentation'!

documentation
"
    I represent the memory as contained in a snapshot image.

    I am not used directly; instead, via the SystemBrowsers entry:
        SystemBrowser openOnSnapShotImage:'/export/home/cg/work/stx/projects/smalltalk/st.img'
        SystemBrowser openOnSnapShotImage:'crash.img'

    [author:]
        Claus Gittinger

"
! !

!SnapShotImageMemory class methodsFor:'instance creation'!

for:aFilename
    ^ self new for:aFilename
! !

!SnapShotImageMemory class methodsFor:'private'!

isNilOOP:anOOP
    ^ anOOP == 0
!

isPointerOOP:anOOP
    ^ (anOOP bitTest:1) not
!

isSmallIntegerOOP:anOOP
    ^ anOOP bitTest:1
! !

!SnapShotImageMemory methodsFor:'accessing'!

globalEntries
    "return the value of the instance variable 'globalEntries' (automatically generated)"

    ^ globalEntries
!

globalEntries:something
    "set the value of the instance variable 'globalEntries' (automatically generated)"

    globalEntries := something.
!

image

    ^ image
!

image:something

    image := something.
!

ptrSize
    "return the value of the instance variable 'ptrSize' (automatically generated)"

    ^ ptrSize
!

ptrSize:something
    "set the value of the instance variable 'ptrSize' (automatically generated)"

    ptrSize := something.
! !

!SnapShotImageMemory methodsFor:'object access'!

fetchByteAt:addr
    |byte imgAddr|

    imgAddr := self imageAddressOf:addr.
    stream position:imgAddr.
    byte := stream next.
    ^ byte
!

fetchClassObjectAt:baseAddr
    |addr classPtr size bits o classRef nInsts|

    (baseAddr bitAnd:ptrSize-1) ~~ 0 ifTrue:[self halt].

    o := addrToObjectMapping at:(baseAddr bitShift:-2) ifAbsent:nil.
    o notNil ifTrue:[^ o].

    addr := baseAddr.
    classPtr := self fetchPointerAt:addr.
    addr := addr + ptrSize.
    size := self fetchUnboxedInteger4At:addr.
    addr := addr + 4.
    bits := self fetchUnboxedInteger4At:addr.
    addr := addr + 4.

    nInsts := (size - hdrSize) // intSize.
    o := ImageClassObject new:nInsts.
    o memory:self.
    o address:baseAddr.
    addrToObjectMapping at:(baseAddr bitShift:-2) put:o.

    (self class isPointerOOP:classPtr) ifFalse:[
        self halt
    ].

    "/ size > 8000 ifTrue:[self halt].
    o byteSize:size.
    o bits:bits.

    1 to:nInsts do:[:idx |
        o at:idx put:(fetchINT value).
"/        o at:idx put:(self fetchObjectAt:(self fetchUnboxedIntegerAt:addr)).
        addr := addr + ptrSize.
    ].

    classRef := self fetchClassObjectAt:classPtr.
    o classRef:classRef.

    ^ o
!

fetchObjectAt:baseAddr
    |addr classPtr classRef size bits o nBytes nInsts flags indexTypeFlags imgAddr|

    baseAddr == 0 ifTrue:[^ nil].
    (baseAddr bitAnd:1) == 1 ifTrue:[
        "/ sign extent integer
        ptrSize == 8 ifTrue:[
            (baseAddr bitTest:16r8000000000000000) ifTrue:[
                ^ (baseAddr - 16r10000000000000000) bitShift:-1
            ].
            ^ baseAddr bitShift:-1
        ] ifFalse:[
            (baseAddr bitTest:16r80000000) ifTrue:[
                ^ (baseAddr - 16r100000000) bitShift32:-1
            ].
            ^ baseAddr bitShift32:-1
        ].
    ].
    (baseAddr bitAnd:ptrSize-1) ~~ 0 ifTrue:[self halt].

    o := addrToObjectMapping at:(baseAddr bitShift:-2) ifAbsent:nil.
    o notNil ifTrue:[^ o].

    addr := baseAddr.
    classPtr := self fetchPointerAt:addr.
    addr := addr + ptrSize.
    size := self fetchUnboxedInteger4At:addr.
    addr := addr + 4.
    bits := self fetchUnboxedInteger4At:addr.
    addr := addr + 4.

    (self class isPointerOOP:classPtr) ifFalse:[
        self halt
    ].

    classRef := self fetchClassObjectAt:classPtr.

    imgAddr := self imageAddressOf:addr.
    stream position:imgAddr.

    flags := classRef flags.
    indexTypeFlags := flags bitAnd:Behavior maskIndexType.
    (indexTypeFlags = Behavior flagBytes) ifTrue:[ 
        nBytes := (size - hdrSize).
        o := ImageByteObject new:nBytes.
        o memory:self.
        o address:baseAddr.
        o classRef:classRef.
        "/ size > 8000 ifTrue:[self halt].
        o byteSize:size.
        o bits:bits.
        addrToObjectMapping at:(baseAddr bitShift:-2) put:o.

        1 to:nBytes do:[:idx |
            o at:idx put:(stream next).
            addr := addr + 1.
        ].

"/Transcript show:'#'.
"/Transcript show:((ByteArray new:nBytes-1) replaceFrom:1 to:nBytes-1 with:o startingAt:1) asString.
"/Transcript cr.
        ^ o
    ].
    (indexTypeFlags = Behavior flagWords) ifTrue:[
        |nWords|
        
        nBytes := (size - hdrSize).
        nWords := nBytes//2.
        o := ImageWordObject new:nWords.
        o memory:self.
        o address:baseAddr.
        o classRef:classRef.
        "/ size > 8000 ifTrue:[self halt].
        o byteSize:size.
        o bits:bits.
        addrToObjectMapping at:(baseAddr bitShift:-2) put:o.

        1 to:nWords do:[:idx |
            o at:idx put:(stream nextUnsignedInt16MSB:msb).
            addr := addr + 2.
        ].

"/Transcript show:'#'.
"/Transcript show:((ByteArray new:nBytes-1) replaceFrom:1 to:nBytes-1 with:o startingAt:1) asString.
"/Transcript cr.
        ^ o
    ].
    
    (indexTypeFlags = Behavior flagNotIndexed) ifFalse:[ 
        (indexTypeFlags ~= Behavior flagPointers) ifTrue:[
            (indexTypeFlags ~= Behavior flagWeakPointers) ifTrue:[
                self halt 
            ]
        ].
    ].

    nInsts := (size - hdrSize) // intSize.
    (flags bitTest:Behavior flagBehavior)
    "/ classRef isImageBehavior 
    ifTrue:[
        o := ImageClassObject new:nInsts.
    ] ifFalse:[
        (flags bitTest:Behavior flagMethod) ifTrue:[
            o := ImageMethodObject new:nInsts.
        ] ifFalse:[
            o := ImageObject new:nInsts.
        ]
    ].
    o memory:self.
    o address:baseAddr.
    o classRef:classRef.
    "/ size > 8000 ifTrue:[self halt].
    o byteSize:size.
    o bits:bits.
    addrToObjectMapping at:(baseAddr bitShift:-2) put:o.

    1 to:nInsts do:[:idx |
        o at:idx put:(fetchINT value).
"/            o at:idx put:(self fetchObjectAt:(self fetchUnboxedIntegerAt:addr)).
        addr := addr + ptrSize.
    ].
    ^ o
!

fetchPointerAt:addr
    ^ self fetchUnboxedIntegerAt:addr
!

fetchUnboxedInteger4At:addr
    |ptr imgAddr|

    (addr bitAnd:(4-1)) ~~ 0 ifTrue:[self halt].

    imgAddr := self imageAddressOf:addr.
    stream position:imgAddr.
    ptr := stream nextUnsignedLongMSB:msb.
    ^ ptr
!

fetchUnboxedIntegerAt:addr
    |ptr imgAddr|

    (addr bitAnd:(ptrSize-1)) ~~ 0 ifTrue:[self halt].

    imgAddr := self imageAddressOf:addr.
    stream position:imgAddr.
    ptr := fetchINT value.
    ^ ptr
!

imageAddressOf:addr
    spaceInfos do:[:eachSpace |
        |byte imgAddr|

        addr >= eachSpace start ifTrue:[
            addr <= eachSpace end ifTrue:[
                imgAddr := eachSpace imageBase + (addr - eachSpace start).
                ^ imgAddr
            ]
        ].
    ].
    self halt:'image address error'.
! !

!SnapShotImageMemory methodsFor:'private'!

allClassesDo:aBlock
    globalEntries do:[:eachGlobal |
        |val|

        val := eachGlobal value.
        (val notNil
        and:[(val isKindOf:ImageHeader)
        and:[val isImageBehavior]]) ifTrue:[
            aBlock value:val
        ].
    ].
!

fetchByteArrayFor:aByteArrayRef
    |nBytes|

    (aByteArrayRef isImageBytes) ifFalse:[self halt].

    nBytes := aByteArrayRef byteSize - hdrSize.
    ^ ((ByteArray new:nBytes) replaceFrom:1 to:nBytes-1 with:aByteArrayRef startingAt:1).
!

fetchStringFor:aStringRef
    |nBytes|

    (aStringRef isImageBytes) ifFalse:[self halt].

    nBytes := aStringRef byteSize - hdrSize.
    ^ ((ByteArray new:nBytes-1) 
            replaceFrom:1 to:nBytes-1 with:aStringRef startingAt:1) asString.
!

for:aFilename
    stream := aFilename asFilename readStream binary.
    addrToObjectMapping := IdentityDictionary new.

    addrToObjectMapping at:((ObjectMemory addressOf:false) bitShift:-2) put:false.
    addrToObjectMapping at:((ObjectMemory addressOf:true) bitShift:-2)  put:true.
!

printStringOfClass:aClassRef
    |nameSlot|

    (aClassRef isImageBehavior) ifFalse:[self halt].
    ((aClassRef byteSize - hdrSize) // intSize) < Class instSize ifTrue:[self halt.].

    nameSlot := aClassRef nameSlot.
    nameSlot isInteger ifTrue:[
        nameSlot := self fetchObjectAt:nameSlot
    ].
    nameSlot isImageSymbol ifFalse:[self halt].
    ^ 'Class: ' , (self printStringOfSymbol:nameSlot)
!

printStringOfObject:anObjectRef
    |s nBytes|

    anObjectRef isNil ifTrue:[^ 'nil'].
    (anObjectRef isInteger) ifTrue:[^ anObjectRef printString].
    (anObjectRef == true ) ifTrue:[^ anObjectRef printString].
    (anObjectRef == false) ifTrue:[^ anObjectRef printString].

    (anObjectRef isImageSymbol) ifTrue:[^ self printStringOfSymbol:anObjectRef].
    (anObjectRef isImageBehavior) ifTrue:[^ self printStringOfClass:anObjectRef].

    ^ 'obj(' , anObjectRef printString , ')'
!

printStringOfString:aStringRef
    |nBytes|

    (aStringRef isString) ifFalse:[self halt].
    ^ self fetchStringFor:aStringRef.
!

printStringOfSymbol:aSymbolRef
    (aSymbolRef isImageSymbol) ifFalse:[self halt].
    ^ self fetchStringFor:aSymbolRef.
!

readGlobalEntries
        |refPointer theSymbolPtr theSymbolRef theValuePtr theValueRef pos|

        globalEntries := OrderedCollection new.
        [
            refPointer := fetchINT value.
            theSymbolPtr := fetchINT value.
            theValuePtr := fetchINT value.
            theSymbolPtr ~~ 0
        ] whileTrue:[
            globalEntries add:(theSymbolPtr -> theValuePtr).
        ].
        globalEntries := globalEntries asArray.

"/ globalEntries inspect.
        pos := stream position.
        globalEntries do:[:item |
            theSymbolPtr := item key.
            theValuePtr := item value.
            theSymbolRef := self fetchObjectAt:theSymbolPtr.

"/            Transcript show:(self printStringOfSymbol:theSymbolRef).
"/            Transcript show:'->'.

            theValueRef := self fetchObjectAt:theValuePtr.
"/            Transcript show:(self printStringOfObject:theValueRef).
"/            Transcript cr.

            item key:theSymbolRef.
            item value:theValueRef.
        ].
        stream position:pos.
!

readHeader
        "
         (self for:'st.img') readHeader
         (self for:'crash.img') readHeader
        "

        |order magic version timeStamp snapID last_util_addr hiText_addr flags 
         lowData hiData charSlots charTableSlots fixMemStart fixMemEnd 
         symMemStart symMemEnd vmDataAddr sharedMethodCode sharedBlockCode 
         nContexts contextSpace nRegistered symbolsSeqNr nSpaces 
         classNameSize spaceSize numCharSlots|

        stream next:256.        "/ skip execCmd

        msb := false.
        order := stream nextUnsignedLongMSB:msb.        
        order = 16r076543210 ifTrue:[
        ] ifFalse:[
            order = 16r10325476 ifTrue:[
                msb := true.
            ] ifFalse:[
                self error:'unhandled byteorder'
            ].
        ].
        magic := (stream next:8) asString.
        magic ~= 'ST/X-IMG' ifTrue:[
            self error:'not an st/x image'
        ].
        version := stream nextUnsignedLongMSB:msb.        
        timeStamp := stream nextUnsignedLongMSB:msb.        
        ptrSize := stream nextByte.        
        ptrSize ~~ 4 ifTrue:[
            ptrSize ~~ 8 ifTrue:[
                self error:'unhandled ptr format'
            ].
        ].
        stream next:7.    "/ filler    
        intSize := stream nextUnsignedLongMSB:msb.        
        intSize == 9 "encoded as SmallInteger; i.e. with tag" ifTrue:[
            intSize := 4.
            intTag := 1.
        ] ifFalse:[
            intSize == 17 "encoded as SmallInteger; i.e. with tag" ifTrue:[
                intSize := 8.
                intTag := 1.
            ] ifFalse:[
                self error:'unhandled int format'
            ].
        ].
        hdrSize := ptrSize + 4 + 4.

        intSize == 4 ifTrue:[
            fetchINT := [stream nextUnsignedLongMSB:msb] 
        ] ifFalse:[
            fetchINT := [stream nextUnsignedHyperMSB:msb]
        ].

        snapID := stream nextUnsignedLongMSB:msb.        
        intSize == 8 ifTrue:[
            "/ sigh - align for 8byte
            stream next:4
        ].
        last_util_addr := fetchINT value.        
        hiText_addr := fetchINT value.
        flags := fetchINT value.        
        "infoPrinting :=" stream next.
        "debugPrinting :=" stream next.
        stream next:6.    "/ filler    

        lowData := fetchINT value.
        hiData := fetchINT value.

        charSlots := fetchINT value.
        charTableSlots := fetchINT value.

        version >= 8 ifTrue:[
            fixMemStart := fetchINT value.
            fixMemEnd := fetchINT value.
            symMemStart := fetchINT value.
            symMemEnd := fetchINT value.
            vmDataAddr := fetchINT value.
        ].
        stream next:(128 * intSize).    "/ skip sharedMethodCode ptrs
        stream next:(128 * intSize).    "/ skip sharedBlockCode ptrs

        nContexts := fetchINT value.
        contextSpace := fetchINT value.
        nRegistered := fetchINT value.

        version >= 8 ifTrue:[
            version >= 9 ifTrue:[
                symbolsSeqNr := fetchINT value.
                version >= 10 ifTrue:[
                    numCharSlots := fetchINT value.
                    stream next:(intSize * 30).
                ] ifFalse:[
                    stream next:(intSize * 31).
                ].
            ] ifFalse:[
                stream next:(intSize * 32).
            ]
        ].

        nSpaces := fetchINT value.
        spaceInfos := (1 to:nSpaces) collect:[:idx | SpaceInfo new].
        
        1 to:nSpaces do:[:i |
            (spaceInfos at:i) flags:(fetchINT value).
        ].
        nSpaces+1 to:32 do:[:i | fetchINT value].

        1 to:nSpaces do:[:i |
            (spaceInfos at:i) start:(fetchINT value).
        ].
        nSpaces+1 to:32 do:[:i | fetchINT value].

        1 to:nSpaces do:[:i |
            (spaceInfos at:i) size:(fetchINT value).
        ].
        nSpaces+1 to:32 do:[:i | fetchINT value].
        version >= 8 ifTrue:[
            stream reset.
            stream skip:4096.
        ].

        1 to:nSpaces do:[:i |
            (spaceInfos at:i) end:((spaceInfos at:i) start + (spaceInfos at:i) size - 1).
        ].
        1 to:nSpaces do:[:i |
            (spaceInfos at:i) imageBase:(stream position).
            spaceSize := (spaceInfos at:i) size.
            stream skip:spaceSize.
        ].

        "/ registration

        self readRegistrationEntries.
        Transcript showCR:'reading symbols...'.
        self readSymbolEntries.
        self readUGlobalEntries.
        Transcript showCR:'reading globals...'.
        self readGlobalEntries.


"/struct basicImageHeader {
"/        char            h_execCmd[256];
"/
"/        int             h_orderWord;
"/        char            h_magic[8];
"/        int             h_version;
"/        int             h_timeStamp;
"/        char            h_ptrSize;
"/        char            h_filler1[7];
"/        int             h_intSize;
"/        int             h_snapID;
"/        INT             h_last_util_addr;
"/        INT             h_hiText_addr;
"/        INT             h_flags;
"/        char            h_infoPrinting;
"/        char            h_debugPrinting;
"/        char            h_filler2[6];
"/
"/        /*
"/         * these are to verify compatibility of the image with
"/         * myself ...
"/         * this is now obsolete.
"/         */
"/        INT             h_lowData, h_hiData;
"/
"/        /*
"/         * base address of character- and characterTable slots
"/         */
"/        INT             h_charSlots;
"/        INT             h_charTableSlots;
"/
"/#if HEADER_VERSION >= 8
"/        /*
"/         * the fixBase (VMDATA address)
"/         */
"/        INT             h_fixMemStart;
"/        INT             h_fixMemEnd;
"/        INT             h_symMemStart;
"/        INT             h_symMemEnd;
"/
"/        INT             h_vmDataAddr;
"/#endif
"/
"/        INT             h_sharedMethodCode[128];
"/        INT             h_sharedBlockCode[128];
"/
"/        /*      
"/         * space needed to restore contexts
"/         */
"/        INT             h_nContexts;
"/        INT             h_contextSpace;
"/
"/        /*
"/         * number of class registration info records
"/         */
"/        INT             h_nRegistered;
"/
"/#if HEADER_VERSION >= 8
"/        /*
"/         * reserved slots, for future versions
"/         * (can add additional info, without affecting position of following stuff)
"/         * If you add slots, you MUST DECREMENT the fillcount.
"/         */
"/# if HEADER_VERSION >= 9
"/        INT             h_symbolsSeqNr;
"/        INT             h_reserved[31];
"/# else
"/        INT             h_reserved[32];
"/# endif
"/#endif
"/
"/        /*
"/         * number of spaces, base and size of each
"/         */
"/        INT             h_nSpaces;
"/        INT             h_spaceFlags[MAXSPACES];
"/        INT             h_spaceBase[MAXSPACES];
"/        INT             h_spaceSize[MAXSPACES];
"/
"/        /*
"/         * here come nSpaces object spaces
"/         */
"/
"/        /*
"/         * here comes registration info
"/         */
"/
"/        /*
"/         * here come nSymbols symbolEntries
"/         * followed by a zero/zero entry
"/         */
"/
"/        /*
"/         * here come nGlobal globalEntries
"/         * followed by a zero/zero entry
"/         */
"/
"/        /*
"/         * here come nUnnamedGlobal globalEntries
"/         * followed by a zero/zero entry
"/         */
"/
"/        /*
"/         * here come stack contexts
"/         */
"/};      
!

readRegistrationEntries
        |classNameSize|

        [
            classNameSize := stream nextUnsignedLongMSB:msb.
            classNameSize ~~ 0
        ] whileTrue:[
            |className flags moduleTimestamp signature nMethods nBlocks oldLitRefs nLitRefs
             oldConstTable nConsts|

            className := (stream next:classNameSize) asString.
            stream next. "/ 0-byte
            flags := fetchINT value.
            moduleTimestamp := fetchINT value.   
            signature := fetchINT value.   
            nMethods := stream nextUnsignedLongMSB:msb.   
            nMethods timesRepeat:[ fetchINT value ].
            nBlocks := stream nextUnsignedLongMSB:msb.   
            nBlocks timesRepeat:[ fetchINT value ].

            oldLitRefs := fetchINT value.  
            nLitRefs := stream nextUnsignedLongMSB:msb.
            nLitRefs timesRepeat:[ fetchINT value ].
            fetchINT value. "/ 0-litRef
            oldConstTable := fetchINT value.  
            nConsts := stream nextLongMSB:msb.
            nConsts > 0 ifTrue:[
                nConsts timesRepeat:[ fetchINT value ].
            ].
"/            Transcript show:className; 
"/                    show:' nconsts:'; show:nConsts; 
"/                    show:' nlits:'; show:nLitRefs;
"/                    show:' nMethods:'; show:nMethods;
"/                    show:' nBlocks:'; showCR:nBlocks.
        ].
!

readSymbolEntries
        |refPointer theSymbolPtr theSymbolRef pos|

        symbolEntries := OrderedCollection new.

        [
            refPointer := fetchINT value.
            theSymbolPtr := fetchINT value.
            theSymbolPtr ~~ 0
        ] whileTrue:[
            symbolEntries add:theSymbolPtr.
        ].
        symbolEntries := symbolEntries asArray.

        pos := stream position.
        1 to:symbolEntries size do:[:i |
            |theSymbolPtr|

            "/ an inlined collect, to avoid allocating big array twice.
            theSymbolPtr := symbolEntries at:i.
            theSymbolRef := self fetchObjectAt:theSymbolPtr.
            theSymbolRef isImageSymbol ifFalse:[
                self halt
            ].
            symbolEntries at:i put:theSymbolRef.
        ].        
        stream position:pos
!

readUGlobalEntries
        |refPointer theValue|

        [
            refPointer := fetchINT value.
            theValue := fetchINT value.
            refPointer ~~ 0
        ] whileTrue
! !

!SnapShotImageMemory methodsFor:'queries'!

metaClassByteSize
    ^ Metaclass instSize * ptrSize + hdrSize
!

privateMetaClassByteSize
    ^ PrivateMetaclass instSize * ptrSize + hdrSize
! !

!SnapShotImageMemory::ImageHeader methodsFor:'accessing'!

address:something
    address := something.
!

bits
    "return the value of the instance variable 'bits' (automatically generated)"

    ^ bits
!

bits:something
    "set the value of the instance variable 'bits' (automatically generated)"

    bits := something.
!

byteSize
    "return the value of the instance variable 'size' (automatically generated)"

    ^ byteSize
!

byteSize:something
    "set the value of the instance variable 'size' (automatically generated)"

"/ something > 8000 ifTrue:[self halt].
    byteSize := something.
!

classRef
    "return the value of the instance variable 'classRef' (automatically generated)"

    ^ classRef
!

classRef:something
    "set the value of the instance variable 'classRef' (automatically generated)"

    classRef := something.
!

memory
    "return the value of the instance variable 'memory' (automatically generated)"

    ^ memory
!

memory:something
    "set the value of the instance variable 'memory' (automatically generated)"

    memory := something.
! !

!SnapShotImageMemory::ImageHeader methodsFor:'queries'!

category
    |categoryPtr categoryRef category categorySlotOffset|

    self isMethodOrLazyMethod ifTrue:[
        categorySlotOffset := Method instVarOffsetOf:'category'.
        "/ categorySlotOffset := 6.
        categoryPtr := self at:categorySlotOffset.
        categoryRef := memory fetchObjectAt:categoryPtr.
        category := memory fetchStringFor:categoryRef.
        ^ category
    ].
self halt.
!

isBehavior
    ^ self isImageBehavior
!

isImageBehavior
    |flags|

    flags := classRef flags.
    ^ flags bitTest:Behavior flagBehavior  
!

isImageBytes
    |flags|

    flags := classRef flags bitAnd:Behavior maskIndexType.
    ^ flags = Behavior flagBytes 
!

isImageMethod
    |flags|

    flags := classRef flags.
    ^ flags bitTest:Behavior flagMethod 
!

isImageSymbol
    |flags|

    flags := classRef flags.
    ^ flags bitTest:Behavior flagSymbol 
!

isJavaMethod
    |nm|

    nm := classRef name.
    ^ (nm = 'JavaMethod'
      or:[ nm = 'JavaMethodWithException'
      or:[ nm = 'JavaMethodWithHandler'
      or:[ nm = 'JavaNativeMethod' ]]])
!

isLazyMethod
    ^ classRef name = 'LazyMethod'
!

isMeta
    ^ false
!

isMethod
    |cls|

    cls := classRef.
    [cls notNil] whileTrue:[
        cls name = 'Method' ifTrue:[^ true].
        cls := cls superclass
    ].
    ^ false.
!

isMethodDictionary
    ^ classRef name = 'MethodDictionary'
!

isMethodOrLazyMethod
    classRef name = 'LazyMethod' ifTrue:[^ true].
    ^ self isMethod
!

isString                               
    ^ classRef name = 'String'
! !

!SnapShotImageMemory::ImageObject methodsFor:'method protocol'!

byteCode
    |byteCodeSlotOffset byteCodePtr byteCodeRef byteCode|

    self isMethod ifTrue:[
        byteCodeSlotOffset := Method instVarOffsetOf:'byteCode'.
    ].
    byteCodeSlotOffset notNil ifTrue:[
        byteCodePtr := self at:byteCodeSlotOffset.
        byteCodeRef := memory fetchObjectAt:byteCodePtr.
        byteCodeRef isNil ifTrue:[^ nil].

        byteCode := memory fetchByteArrayFor:byteCodeRef.
        ^ byteCode
    ].

    self halt.
!

comment
    |src comment comments parser|

    self isMethod ifTrue:[
        src := self source.
        src isNil ifTrue:[^ nil].

        parser := Parser for:src in:nil.
        parser ignoreErrors; ignoreWarnings; saveComments:true.
        parser parseMethodSpec.
        comments := parser comments.
        comments size ~~ 0 ifTrue:[
            comment := comments first string.
            (comment withoutSpaces endsWith:'}') ifTrue:[
                "if first comment is a pragma, take next comment"
                comment := comments at:2 ifAbsent:nil.
                comment notNil ifTrue:[
                    comment := comment string.
                ].
            ].
        ].
        ^ comment.
    ].
    self isLazyMethod ifTrue:[
        ^ ''
    ].

    self halt.
!

containingClass
    self isMethodOrLazyMethod ifTrue:[
        ^ self mclass
    ].
    self halt.
!

flags
    |flagsSlotOffset flagsPtr flags|

    self isMethod ifTrue:[
        flagsSlotOffset := Method instVarOffsetOf:'flags'.
    ].
    flagsSlotOffset notNil ifTrue:[
        flagsPtr := self at:flagsSlotOffset.
        flags := memory fetchObjectAt:flagsPtr.
        ^ flags
    ].

    self halt.
!

hasCode
    ^ false
!

isBreakpointed
    ^ false
!

isCounting
    ^ false
!

isCountingMemoryUsage
    ^ false
!

isDynamic
    ^ false
!

isExecutable
    self isMethod ifTrue:[
        ^ false
    ].
    self halt.
!

isIgnored
    ^ false
!

isObsolete
    ^ false
!

isPrivate
    ^ false
!

isProtected
    ^ false
!

isPublic
    ^ true
!

isTimed
    ^ false
!

isTraced
    ^ false
!

isWrapped
    ^ false
!

mclass
    |mclassSlotOffset mclassPtr mclass|

    self isMethod ifTrue:[
        mclassSlotOffset := Method instVarOffsetOf:'mclass'.
    ] ifFalse:[
        self isJavaMethod ifTrue:[
            mclassSlotOffset := JavaMethod instVarOffsetOf:'javaClass'.
        ]
    ].

    mclassSlotOffset notNil ifTrue:[
        mclassPtr := self at:mclassSlotOffset.
        mclassPtr ~~ 0 ifTrue:[
            mclassPtr isInteger ifTrue:[
                mclass := memory fetchObjectAt:mclassPtr.
                self at:mclassSlotOffset put:mclass.    
            ] ifFalse:[
                mclass := mclassPtr.
            ].
            mclass isImageBehavior ifFalse:[
                self halt
            ].
            ^ mclass
        ].

        "/ search my class ...
        memory image allClassesDo:[:eachClass |
            eachClass theNonMetaclass methodDictionary keysAndValuesDo:[:sel :mthdRef |
                mthdRef == self ifTrue:[
                    self at:mclassSlotOffset put:eachClass theNonMetaclass.    
                    ^ eachClass theNonMetaclass
                ].
            ].
            eachClass theMetaclass methodDictionary keysAndValuesDo:[:sel :mthdRef |
                mthdRef == self ifTrue:[
                    self at:mclassSlotOffset put:eachClass theMetaclass.    
                    ^ eachClass theMetaclass
                ].
            ]
        ].
        self halt.
        ^ nil.
    ].
    ^ nil.
    self halt.
!

numArgs
    |flags|

    flags := self flags.
    ^ (flags bitAnd:(Method numArgsMaskInFlags)) bitShift:(Method numArgsShiftInFlags negated)   
!

package
    |packageSlotOffset packagePtr packageRef package|

    self isImageBehavior ifTrue:[
        self isMeta ifTrue:[
            ^ self theNonMetaclass package
        ].
        packageSlotOffset := Class instVarOffsetOf:'package'.
    ] ifFalse:[
        self isMethod ifTrue:[
            packageSlotOffset := Method instVarOffsetOf:'package'.
        ] ifFalse:[
            self isLazyMethod ifTrue:[
                packageSlotOffset := Method instVarOffsetOf:'package'.
            ].
        ].
    ].
    packageSlotOffset notNil ifTrue:[
        packagePtr := self at:packageSlotOffset.
        packageRef := memory fetchObjectAt:packagePtr.
        packageRef isNil ifTrue:[^ nil].

        packageRef isImageSymbol ifFalse:[
            packageRef isImageBytes ifFalse:[
                self halt.
            ].
            "/ mhmh - can be a string sometimes ...
        ].
        package := memory fetchStringFor:packageRef.
        ^ package asSymbol
    ].
    self isMeta ifTrue:[
        self halt
    ].

    ^ nil
!

previousVersion
    ^ nil
!

printStringForBrowserWithSelector:selector
    ^ selector
!

printStringForBrowserWithSelector:selector inClass:aClass
    ^ selector
!

privacy
    ^ #public
!

resources
    ^ nil
!

source
    self halt:'unimplemented'.
!

sourceFilename
    "return the sourcefilename if source is extern; nil otherwise"

    |sourcePtr sourceRef source|

    self isMethodOrLazyMethod ifTrue:[
        self sourcePosition notNil ifTrue:[
            sourcePtr := self at:(Method instVarOffsetOf:'source').
            sourceRef := memory fetchObjectAt:sourcePtr.
            sourceRef isString ifFalse:[
                self halt.
            ].
            source := memory printStringOfString:sourceRef.
            ^ source.
        ].
        ^ nil
    ].
    self halt.
!

sourceLineNumber
    self isMethodOrLazyMethod ifTrue:[
        ^ 1
    ].
    self halt.
!

sourcePosition
    |sourcePosition|

    self isMethodOrLazyMethod ifTrue:[
        sourcePosition := self sourcePositionValue.
        sourcePosition isNil ifTrue:[^ sourcePosition].
        ^ sourcePosition abs
    ].
    self halt.
!

sourcePositionValue
    |sourcePosition sourcePositionPtr|

    self isMethodOrLazyMethod ifTrue:[
        sourcePositionPtr := self at:(Method instVarOffsetOf:'sourcePosition').
        sourcePosition := memory fetchObjectAt:sourcePositionPtr.
        ^ sourcePosition 
    ].
    self halt.
!

sourceStream
    |sourcePosition source aStream fileName junk who
     myClass mgr className sep dir mod package|

    self isMethod ifTrue:[
        sourcePosition := self at:(Method instVarOffsetOf:'sourcePosition').
        source := self at:(Method instVarOffsetOf:'source').
        source := memory fetchObjectAt:source.
        source isString ifTrue:[
            source := memory printStringOfString:source.
        ].
        sourcePosition notNil ifTrue:[
            sourcePosition := memory fetchObjectAt:sourcePosition.
        ].

        source isNil ifTrue:[^ nil].
        sourcePosition isNil ifTrue:[^ source readStream].

        sourcePosition < 0 ifTrue:[
            aStream := source asFilename readStream.
            aStream notNil ifTrue:[
                ^ aStream
            ].

            fileName := Smalltalk getSourceFileName:source.
            fileName notNil ifTrue:[
                aStream := fileName asFilename readStream.
                aStream notNil ifTrue:[
                    ^ aStream
                ].
            ].
        ].

        "/
        "/ if there is no SourceManager, look in local standard places first
        "/
        (mgr := Smalltalk at:#SourceCodeManager) isNil ifTrue:[
            aStream := self localSourceStream.
            aStream notNil ifTrue:[
                ^ aStream
            ].
        ].

        "/
        "/ nope - ask my class for the source (this also invokes the SCMgr)
        "/
        myClass := self mclass.

        package := self package.
        (package notNil and:[package ~= myClass package]) ifTrue:[
            mgr notNil ifTrue:[
                "/ try to get the source using my package information ...
                sep := package indexOfAny:'/\:'.
                sep ~~ 0 ifTrue:[
                    mod := package copyTo:sep - 1.
                    dir := package copyFrom:sep + 1.
                    aStream := mgr streamForClass:nil fileName:source revision:nil directory:dir module:mod cache:true.
                    aStream notNil ifTrue:[
                        ^ aStream
                    ].
                ].
            ].
        ].

        aStream := myClass sourceStreamFor:source.
        aStream notNil ifTrue:[
            ^ aStream
        ].

        "/
        "/ nope - look in standard places
        "/ (if there is a source-code manager - otherwise, we already did that)
        "/
        mgr notNil ifTrue:[
            aStream := self localSourceStream.
            aStream notNil ifTrue:[
                ^ aStream
            ].
        ].

        "/
        "/ final chance: try current directory
        "/
        aStream isNil ifTrue:[
            aStream := source asFilename readStream.
            aStream notNil ifTrue:[
                ^ aStream
            ].
        ].

        (who isNil and:[source notNil]) ifTrue:[
            "/
            "/ mhmh - seems to be a method which used to be in some
            "/ class, but has been overwritten by another or removed.
            "/ (i.e. it has no containing class anyMore)
            "/ try to guess the class from the sourceFileName.
            "/ and retry.
            "/
            className := Smalltalk classNameForFile:source.
            className knownAsSymbol ifTrue:[
                myClass := Smalltalk at:className asSymbol ifAbsent:nil.
                myClass notNil ifTrue:[
                    aStream := myClass sourceStreamFor:source.
                    aStream notNil ifTrue:[
                        ^ aStream
                    ].
                ]
            ]
        ].

        ^ nil
    ].
    ^ nil
! !

!SnapShotImageMemory::ImageObject methodsFor:'methodDictionary protocol'!

at:aSelector ifAbsent:exceptionValue
    self isMethodDictionary ifTrue:[
        cachedContents isNil ifTrue:[
            self cacheMethodDictionary.
        ].
        ^ cachedContents at:aSelector ifAbsent:exceptionValue
    ].
    self halt.
!

cacheMethodDictionary
    |symPtr symRef mthdPtr mthdRef s|

    cachedContents isNil ifTrue:[
        cachedContents := IdentityDictionary new.

        1 to:self size by:2 do:[:idx |
            symPtr := self at:idx.
            symRef := memory fetchObjectAt:symPtr.
            symRef isImageSymbol ifFalse:[self halt].
            s := memory fetchStringFor:symRef.
            mthdPtr := self at:idx + 1.
            mthdRef := memory fetchObjectAt:mthdPtr.
            cachedContents at:s asSymbol put:mthdRef.
        ].
    ].
!

do:aBlock
    self isMethodDictionary ifTrue:[
        cachedContents isNil ifTrue:[
            self cacheMethodDictionary.
        ].
        cachedContents do:aBlock.
        ^ self.
    ].
    self halt.
!

includesKey:aSelector
    self isMethodDictionary ifTrue:[
        cachedContents isNil ifTrue:[
            self cacheMethodDictionary.
        ].
        ^ cachedContents includesKey:aSelector
    ].
    self halt.
!

keyAtValue:aMethod ifAbsent:exceptionValue
    self isMethodDictionary ifTrue:[
        cachedContents isNil ifTrue:[
            self cacheMethodDictionary.
        ].
        ^ cachedContents keyAtValue:aMethod ifAbsent:exceptionValue
    ].
    self halt.
!

keysAndValuesDo:aBlock
    self isMethodDictionary ifTrue:[
        cachedContents isNil ifTrue:[
            self cacheMethodDictionary.
        ].

        cachedContents keysAndValuesDo:[:sel :mthdRef |
            aBlock value:sel value:mthdRef.
        ].
        ^ self
    ].
    self halt.
! !

!SnapShotImageMemory::ImageByteObject methodsFor:'queries'!

size
    ^ byteSize
! !

!SnapShotImageMemory::ImageMethodObject methodsFor:'method protocol'!

localSourceStream
    "try to open a stream from a local source file,
     searching in standard places."

    |fileName aStream package source|

    package := self package.
    source := self sourceFilename.
    package notNil ifTrue:[
        fileName := Smalltalk getSourceFileName:(package copyReplaceAll:$: with:$/) , '/' , source.
        fileName notNil ifTrue:[
            aStream := fileName asFilename readStream.
            aStream notNil ifTrue:[^ aStream].
        ].
    ].
    fileName := Smalltalk getSourceFileName:source.
    fileName notNil ifTrue:[
        aStream := fileName asFilename readStream.
        aStream notNil ifTrue:[^ aStream].
    ].
    ^ nil
!

mclass
    cachedMClass isNil ifTrue:[
        cachedMClass := super mclass.
    ].
    ^ cachedMClass
!

package
    |packageSlotOffset packagePtr packageRef package|

    cachedPackage isNil ifTrue:[
        packageSlotOffset := Method instVarOffsetOf:'package'.

        packagePtr := self at:packageSlotOffset.
        packageRef := memory fetchObjectAt:packagePtr.
        packageRef isNil ifTrue:[^ nil].

        packageRef isImageSymbol ifFalse:[
            packageRef isImageBytes ifFalse:[
                self halt.
            ].
            "/ mhmh - can be a string sometimes ...
        ].
        package := memory fetchStringFor:packageRef.
        cachedPackage := package asSymbol
    ].
    ^ cachedPackage
!

selector
    cachedSelector isNil ifTrue:[
        self mclass methodDictionary keysAndValuesDo:[:sel :mthd | mthd == self ifTrue:[cachedSelector := sel]].
    ].
    ^ cachedSelector
!

source
    |sourcePosition sourcePositionPtr sourcePtr sourceRef source aStream junk|

    sourcePositionPtr := self at:(Method instVarOffsetOf:'sourcePosition').
    sourcePtr := self at:(Method instVarOffsetOf:'source').
    sourceRef := memory fetchObjectAt:sourcePtr.
    sourceRef isString ifFalse:[
        self halt.
    ].
    source := memory printStringOfString:sourceRef.
    sourcePosition := memory fetchObjectAt:sourcePositionPtr.
    sourcePosition isNil ifTrue:[
        ^ source
    ].

    aStream := self sourceStream.
    aStream notNil ifTrue:[
        Stream positionErrorSignal handle:[:ex |
            ^ nil
        ] do:[
            aStream position:sourcePosition abs.
        ].
        junk := aStream nextChunk.

        aStream close.
        ^ junk
    ].
    self halt.
!

syntaxHighlighterClass
    ^ #askClass
! !

!SnapShotImageMemory::ImageMethodObject methodsFor:'queries'!

isMethod
    ^ true
!

previousVersionCode
    "return the receivers previous versions source code"

    "there is no previous version"
    ^ nil
!

sends:aSelectorSymbol
    "return true, if this method contains a message-send
     with aSelectorSymbol as selector."

"/    (self referencesLiteral:aSelectorSymbol) ifTrue:[
"/        ^ self messagesSent includesIdentical:aSelectorSymbol
"/    ].
    ^ false
! !

!SnapShotImageMemory::ImageClassObject methodsFor:'accessing - slots'!

category
    |categoryRef|

    cachedCategory isNil ifTrue:[
        categoryRef := self categorySlot.
        categoryRef isInteger ifTrue:[
            categoryRef := memory fetchObjectAt:categoryRef.
        ].
        categoryRef notNil ifTrue:[
            cachedCategory := memory fetchStringFor:categoryRef.
        ].
    ].
    ^ cachedCategory
!

categorySlot
    ^ self at:(Class instVarOffsetOf:'category')
!

classBaseFilename
    ^ self classFilename asFilename baseName

    "Created: / 19-10-2006 / 01:10:17 / cg"
!

classFilename
    |classFilenameRef classFilename|

    classFilenameRef := self classFilenameSlot.
    classFilenameRef isInteger ifTrue:[
        classFilenameRef := memory fetchObjectAt:classFilenameRef.
    ].
    classFilenameRef notNil ifTrue:[
        classFilename := memory fetchStringFor:classFilenameRef.
    ].
    ^ classFilename
!

classFilenameSlot
    ^ self at:(Class instVarOffsetOf:'classFilename')
!

classVarNames
    |classVarNamesRef classVarNames s|

    classVarNamesRef := self classVarsSlot.
    classVarNamesRef isInteger ifTrue:[
        classVarNamesRef := memory fetchObjectAt:classVarNamesRef.
    ].
    classVarNamesRef notNil ifTrue:[
        classVarNamesRef isImageBytes ifTrue:[
            "/ a string
            classVarNames := memory fetchStringFor:classVarNamesRef.
            classVarNames := classVarNames asCollectionOfWords.
        ] ifFalse:[
            classVarNames := Array new:(classVarNamesRef size).
            1 to:classVarNames size do:[:idx |
                s := classVarNamesRef at:idx.
                s := memory fetchObjectAt:s.
                s isImageBytes ifFalse:[self halt].
                s := memory fetchStringFor:s.
                classVarNames at:idx put:s.
            ].
        ].
    ].
    ^ classVarNames ? #()
!

classVariableString
    |classVarsPtr classVarsRef classVars|

    (classVarsPtr := self classVarsSlot) == 0 ifTrue:[^ ''].
    classVarsRef := memory fetchObjectAt:classVarsPtr.
    classVarsRef isImageBytes ifTrue:[
        "/ a string
        classVars := memory fetchStringFor:classVarsRef.
        ^ classVars
    ].
    ^ self classVarNames asStringWith:(Character space)
!

classVarsSlot
    ^ self at:(Class instVarOffsetOf:'classvars')
!

comment
    |commentRef comment stream string|

    commentRef := self commentSlot.
    commentRef isInteger ifTrue:[
        (SnapShotImageMemory isSmallIntegerOOP:commentRef) ifTrue:[
            "/ comment points into file.
            stream := self sourceStream.
            stream notNil ifTrue:[
                Stream positionErrorSignal handle:[:ex |
                    ^ nil
                ] do:[
                    stream position:(commentRef bitShift:-1).
                    string := String readFrom:stream.
                    stream close.
                ].
                ^ string
            ].
            ^ nil
        ].
        commentRef := memory fetchObjectAt:commentRef.
    ].
    commentRef notNil ifTrue:[
        comment := memory fetchStringFor:commentRef.
    ].
    ^ comment
!

commentOrDocumentationString
    "the classes documentation-method's comment, its plain
     comment or nil"

    |cls m s|

    cls := self theNonMetaclass.
    m := cls theMetaclass compiledMethodAt:#documentation.
    m notNil ifTrue:[
        "/ try documentation method's comment
        s := m comment.
    ] ifFalse:[
        "try classes comment"
        s := cls comment.
        s isString ifTrue:[
            s isEmpty ifTrue:[
                s := nil
            ] ifFalse:[
                (s includes:$") ifTrue:[
                    s := s copyReplaceAll:$" with:$'.
                ].
                s size > 80 ifTrue:[
                    s := s asCollectionOfSubstringsSeparatedBy:$..
                    s := s asStringCollection.
                    s := s collect:[:each | (each startsWith:Character space) ifTrue:[
                                                each copyFrom:2
                                            ] ifFalse:[
                                                each
                                            ]
                                   ].
                    s := s asStringWith:('.' , Character cr).
                ].
            ]
        ] ifFalse:[
            "/ class redefines comment ?
            s := nil
        ].
    ].
    s isEmptyOrNil ifTrue:[^ s].
    ^ s withTabsExpanded

    "
     Array commentOrDocumentationString
    "
!

commentSlot
    ^ self at:(Class instVarOffsetOf:'comment')
!

flags
    |flags|

    cachedFlags isNil ifTrue:[
        flags := self flagsSlot.

        (SnapShotImageMemory isSmallIntegerOOP:flags) ifFalse:[
            self halt
        ].
        cachedFlags := flags bitShift:-1.
    ].
    ^ cachedFlags
!

flagsSlot
    ^ self at:(Class instVarOffsetOf:'flags')
!

instSize
    |instSizeRef|

    instSizeRef := self instSizeSlot.
    ^ memory fetchObjectAt:instSizeRef.
!

instSizeSlot
    ^ self at:(Class instVarOffsetOf:'instSize')
!

instVarNames
    |instVarNamesRef instVarNames s|

    instVarNamesRef := self instVarsSlot.
    instVarNamesRef isInteger ifTrue:[
        instVarNamesRef := memory fetchObjectAt:instVarNamesRef.
    ].
    instVarNamesRef notNil ifTrue:[
        instVarNamesRef isImageBytes ifTrue:[
            "/ a string
            instVarNames := memory fetchStringFor:instVarNamesRef.
            instVarNames := instVarNames asCollectionOfWords.
        ] ifFalse:[
            instVarNames := Array new:(instVarNamesRef size).
            1 to:instVarNames size do:[:idx |
                s := instVarNamesRef at:idx.
                s := memory fetchObjectAt:s.
                s isImageBytes ifFalse:[self halt].
                s := memory fetchStringFor:s.
                instVarNames at:idx put:s.
            ].
        ].
    ].
    ^ instVarNames ? #()
!

instVarsSlot
    ^ self at:(Class instVarOffsetOf:'instvars')
!

methodDictionary
    |methodDictionaryRef methodDictionary|

    methodDictionaryRef := self methodDictionarySlot.
    methodDictionaryRef isInteger ifTrue:[
        methodDictionaryRef == 0 ifTrue:[^ nil].
        methodDictionary := memory fetchObjectAt:methodDictionaryRef.
    ].
    ^ methodDictionary
!

methodDictionarySlot
    ^ self at:(Class instVarOffsetOf:'methodDictionary')
!

name
    |nameRef|

    cachedName isNil ifTrue:[
        self isMeta ifTrue:[
            cachedName := self theNonMetaclass name , ' class'
        ] ifFalse:[
            self isPrivateMeta ifTrue:[
self halt.
            ].

            nameRef := self nameSlot.
            nameRef isInteger ifTrue:[
                nameRef := memory fetchObjectAt:nameRef.
            ].
            nameRef notNil ifTrue:[
                cachedName := memory fetchStringFor:nameRef.
                cachedName := cachedName asSymbol
            ].
        ].
    ].
    ^ cachedName
!

nameSlot
    ^ self at:(Class instVarOffsetOf:'name')
!

packageSlot
    ^ self at:(Class instVarOffsetOf:'package')
!

primitiveSpec
    |primitiveSpecRef primitiveSpec|

    primitiveSpecRef := self primitiveSpecSlot.
    primitiveSpecRef isInteger ifTrue:[
        primitiveSpecRef := memory fetchObjectAt:primitiveSpecRef.
    ].
    primitiveSpecRef notNil ifTrue:[
        primitiveSpec := memory fetchStringFor:primitiveSpecRef.
    ].
    ^ primitiveSpec
!

primitiveSpecSlot
    (Class instVarOffsetOf:'primitiveSpec') isNil ifTrue:[
        ^ self at:(Class instVarOffsetOf:'attributes')
    ].
    ^ self at:(Class instVarOffsetOf:'primitiveSpec')
!

revision
    |revisionRef revision|

    revisionRef := self revisionSlot.
    revisionRef isInteger ifTrue:[
        revisionRef := memory fetchObjectAt:revisionRef.
    ].
    revisionRef notNil ifTrue:[
        revision := memory fetchStringFor:revisionRef.
    ].
    ^ revision
!

revisionSlot
    ^ self at:(Class instVarOffsetOf:'revision')
!

superclass
    |superClassRef superClass|

    superClassRef := self superclassSlot.
    superClassRef isInteger ifTrue:[
        superClass := memory fetchObjectAt:superClassRef.
    ].
    ^ superClass
!

superclassSlot
    ^ self at:(Class instVarOffsetOf:'superclass')
! !

!SnapShotImageMemory::ImageClassObject methodsFor:'class protocol'!

addAllClassVarNamesTo:aCollection
    "helper - add the name-strings of the class variables and of the class-vars
     of all superclasses to the argument, aCollection. Return aCollection"

    |classvars superclass|

    (superclass := self superclass) notNil ifTrue:[
        superclass addAllClassVarNamesTo:aCollection
    ].
    (classvars := self classVariableString) notNil ifTrue:[
        aCollection addAll:(classvars asCollectionOfWords).
    ].
    ^ aCollection
!

addAllInstVarNamesTo:aCollection
    |superInsts instvars superclass|

    (superclass := self superclass) notNil ifTrue:[
        self superclass addAllInstVarNamesTo:aCollection
    ].
    aCollection addAll:self instVarNames.
    ^ aCollection
!

addChangeRecordForClassFileOut:aClass
!

allClassVarNames
    "return a collection of all the class variable name-strings
     this includes all superclass-class variables"

    ^ self addAllClassVarNamesTo:(OrderedCollection new)
!

allInstVarNames
    self superclass isNil ifTrue:[^ self instVarNames].
    ^ self addAllInstVarNamesTo:(OrderedCollection new)
!

allSubclassesDo:aBlock
    "evaluate aBlock for all of my subclasses.
     There is no specific order, in which the entries are enumerated.
     Warning:
        This will only enumerate globally known classes - for anonymous
        behaviors, you have to walk over all instances of Behavior."

    self isMeta ifTrue:[
        "/ metaclasses are not found via Smalltalk allClassesDo:
        "/ here, walk over classes and enumerate corresponding metas.
        self soleInstance allSubclassesDo:[:aSubClass |
            aBlock value:(aSubClass theMetaclass)
        ].
    ] ifFalse:[
        Smalltalk allClassesDo:[:aClass |
            (aClass isSubclassOf:self) ifTrue:[
                aBlock value:aClass
            ]
        ]
    ]

    "
     Collection allSubclassesDo:[:c | Transcript showCR:(c name)]
     Collection class allSubclassesDo:[:c | Transcript showCR:(c name)]
    "

    "Modified: / 25.10.1997 / 21:17:13 / cg"
!

allSuperclasses
    "return a collection of the receivers accumulated superclasses"

    |aCollection theSuperClass|

    theSuperClass := self superclass.
    theSuperClass isNil ifTrue:[
        ^ #()
    ].
    aCollection := OrderedCollection new.
    [theSuperClass notNil] whileTrue:[
        aCollection add:theSuperClass.
        theSuperClass := theSuperClass superclass
    ].
    ^ aCollection

    "
     String allSuperclasses 
    "
!

allSuperclassesDo:aBlock
    "evaluate aBlock for all of my superclasses"

    |theClass|

    theClass := self superclass.
    [theClass notNil] whileTrue:[
        aBlock value:theClass.
        theClass := theClass superclass
    ]

    "
     String allSuperclassesDo:[:c | Transcript showCR:(c name)]
    "
!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace
    "append an expression on aStream, which defines myself."

    self
        basicFileOutDefinitionOn:aStream 
        withNameSpace:forceNameSpace 
        withPackage:true
!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage
    "append an expression on aStream, which defines myself."

    |s owner ns nsName fullName superName cls topOwner
     syntaxHilighting superclass category|

    UserPreferences isNil ifTrue:[
        syntaxHilighting := false
    ] ifFalse:[
        syntaxHilighting := UserPreferences current syntaxColoring.
    ].

    owner := self owningClass.

    owner isNil ifTrue:[
        ns := self nameSpace.
    ] ifFalse:[
        ns := self topOwningClass nameSpace
    ].
    fullName := Class fileOutNameSpaceQuerySignal query == true.

    (showPackage and:[owner isNil]) ifTrue:[
        aStream nextPutAll:'"{ Package: '''.
        aStream nextPutAll:self package asString.
        aStream nextPutAll:''' }"'; cr; cr.
    ].

    ((owner isNil and:[fullName not])
    or:[owner notNil and:[forceNameSpace and:[fullName not]]]) ifTrue:[
        (ns notNil and:[ns ~~ Smalltalk]) ifTrue:[
            nsName := ns name.
            (nsName includes:$:) ifTrue:[
                nsName := '''' , nsName , ''''
            ].
"/            aStream nextPutLine:'"{ NameSpace: ' , nsName , ' }"'; cr.
            aStream nextPutAll:'"{ NameSpace: '.
            syntaxHilighting ifTrue:[aStream bold].
            aStream nextPutAll:nsName.
            syntaxHilighting ifTrue:[aStream normal].
            aStream nextPutAll:' }"'; cr; cr.
        ]
    ].

    superclass := self superclass.
    category := self category.

    "take care of nil-superclass"
    superclass isNil ifTrue:[
        s := 'nil'
    ] ifFalse:[
        fullName ifTrue:[
            superclass == owner ifTrue:[
                s := superclass nameWithoutNameSpacePrefix
            ] ifFalse:[
                s := superclass name
            ]
        ] ifFalse:[
            (ns == superclass nameSpace 
            and:[superclass owningClass isNil]) ifTrue:[
                "/ superclass is in the same namespace;
                "/ still prepend namespace prefix, to avoid
                "/ confusing stc, which needs that information ...
                s := superclass nameWithoutPrefix
            ] ifFalse:[
                "/ a very special (rare) situation:
                "/ my superclass resides in another nameSpace,
                "/ but there is something else named like this
                "/ to be found in my nameSpace (or a private class)

                superName := superclass nameWithoutNameSpacePrefix asSymbol.
                cls := self privateClassesAt:superName.
                cls isNil ifTrue:[
                    (topOwner := self topOwningClass) isNil ifTrue:[
                        ns := self nameSpace.
                        ns notNil ifTrue:[
                            cls := ns privateClassesAt:superName
                        ] ifFalse:[
                            "/ self error:'unexpected nil namespace'
                        ]
                    ] ifFalse:[
                        cls := topOwner nameSpace at:superName.
                    ]
                ].
                (cls notNil and:[cls ~~ superclass]) ifTrue:[
                    s := superclass nameSpace name , '::' , superName
                ] ifFalse:[
                    "/ no class with that name found in my namespace ...
                    "/ if the superclass resides in Smalltalk,
                    "/ suppress prefix; otherwise, use full prefix.
                    (superclass nameSpace notNil 
                    and:[superclass nameSpace ~~ Smalltalk]) ifTrue:[
                        (owner notNil 
                        and:[owner nameSpace == superclass owningClass nameSpace])
                        ifTrue:[
                            s := superclass nameWithoutNameSpacePrefix
                        ] ifFalse:[
                            s := superclass name
                        ]
                    ] ifFalse:[
                        s := superName
                    ]
                ]
            ]
        ]
    ].

    syntaxHilighting ifTrue:[aStream bold].
    aStream nextPutAll:s.   "/ superclass
    syntaxHilighting ifTrue:[aStream normal].
    aStream space.
    self basicFileOutInstvarTypeKeywordOn:aStream.

    (fullName and:[owner isNil]) ifTrue:[
        aStream nextPutAll:'#'''.
        syntaxHilighting ifTrue:[aStream bold].
        aStream nextPutAll:(self name).
        syntaxHilighting ifTrue:[aStream normal].
        aStream nextPutAll:''''.
    ] ifFalse:[
        aStream nextPut:$#.
        syntaxHilighting ifTrue:[aStream bold].
        aStream nextPutAll:(self nameWithoutPrefix).
        syntaxHilighting ifTrue:[aStream normal].
    ].

    aStream crtab. 
    aStream nextPutAll:'instanceVariableNames:'''.
    syntaxHilighting ifTrue:[aStream bold].
    self printInstVarNamesOn:aStream indent:16.
    syntaxHilighting ifTrue:[aStream normal].
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'classVariableNames:'''.
    syntaxHilighting ifTrue:[aStream bold].
    self printClassVarNamesOn:aStream indent:16.
    syntaxHilighting ifTrue:[aStream normal].
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'poolDictionaries:'''''.

    aStream crtab.
    owner isNil ifTrue:[
        "/ a public class
        aStream nextPutAll:'category:'.
        category isNil ifTrue:[
            s := ''''''
        ] ifFalse:[
            s := category asString storeString
        ].
        aStream nextPutAll:s.
    ] ifFalse:[
        "/ a private class
        aStream nextPutAll:'privateIn:'.
        syntaxHilighting ifTrue:[aStream bold].
"/        fullName ifTrue:[
"/            s := owner name.
"/        ] ifFalse:[
"/            s := owner nameWithoutNameSpacePrefix.
"/        ].
        s := owner nameWithoutNameSpacePrefix.
        aStream nextPutAll:s.
        syntaxHilighting ifTrue:[aStream normal].
    ].
    aStream cr

    "Created: / 4.1.1997 / 20:38:16 / cg"
    "Modified: / 8.8.1997 / 10:59:50 / cg"
    "Modified: / 18.3.1999 / 18:15:46 / stefan"
!

basicFileOutInstvarTypeKeywordOn:aStream
    "a helper for fileOutDefinition"

    |isVar s superclass|

    superclass := self superclass.
    superclass isNil ifTrue:[
        isVar := self isVariable
    ] ifFalse:[
        "I cant remember what this is for ?"
        isVar := (self isVariable and:[superclass isVariable not])
    ].

    aStream nextPutAll:(self firstDefinitionSelectorPart).

    "Created: 11.10.1996 / 18:57:29 / cg"
!

binaryRevision
    "return the revision-ID from which the class was stc-compiled;
     nil if its an autoloaded or filedIn class.
     If a classes binary is up-to-date w.r.t. the source repository,
     the returned string is the same as the one returned by #revision."

    |owner info c revision|

    revision := self revision.

    (owner := self owningClass) notNil ifTrue:[^ owner binaryRevision].
    revision notNil ifTrue:[
        c := revision first.
        c == $$ ifTrue:[
            info := Class revisionInfoFromString:revision.
            info isNil ifTrue:[^ '0'].
            ^ info at:#revision ifAbsent:'0'.
        ].
        c isDigit ifFalse:[
            ^ '0'
        ].
    ].

    ^ revision

    "
     Object binaryRevision
     Object class binaryRevision
    "

    "
     to find all classes which are not up-to-date:

     |classes|

     classes := Smalltalk allClasses 
                    select:[:cls | cls binaryRevision notNil and:[cls binaryRevision ~= cls revision]].
     SystemBrowser browseClasses:classes title:'classes which are not up-to-date'
    "

    "Created: 7.12.1995 / 10:58:47 / cg"
    "Modified: 1.4.1997 / 23:33:01 / stefan"
    "Modified: 9.9.1997 / 12:05:41 / cg"
!

compiledMethodAt:aSelector

    ^ self compiledMethodAt:aSelector ifAbsent:nil
!

compiledMethodAt:aSelector ifAbsent:exceptionValue
    |dict|

    dict := self methodDictionary.
    dict isNil ifTrue:[
        ('Behavior [warning]: nil methodDictionary in ' , self name printString) errorPrintCR.
        ^ exceptionValue value
    ].

    ^ dict at:aSelector ifAbsent:exceptionValue
!

evaluatorClass
    ^ Object evaluatorClass
!

fileOut
    |baseName dirName nm fileName|

    baseName := (Smalltalk fileNameForClass:self name).
    nm := baseName asFilename withSuffix:'st'.

    "
     this test allows a smalltalk to be built without Projects/ChangeSets
    "
    Project notNil ifTrue:[
        dirName := Project currentProjectDirectory
    ] ifFalse:[
        dirName := Filename currentDirectory
    ].
    fileName := (dirName asFilename construct:nm).
    fileName makeLegalFilename.

    self fileOutAs:fileName name.

"/    "
"/     add a change record; that way, administration is much easier,
"/     since we can see in that changeBrowser, which changes have 
"/     already found their way into a sourceFile and which must be
"/     applied again
"/    "
"/    self addChangeRecordForClassFileOut:self

    "Modified: / 7.6.1996 / 09:14:43 / stefan"
    "Modified: / 27.8.1998 / 02:02:57 / cg"
!

fileOutAllDefinitionsOn:aStream
    "append expressions on aStream, which defines myself and all of my private classes."

    self fileOutDefinitionOn:aStream.
    aStream nextPutChunkSeparator. 
    aStream cr; cr.

    "/
    "/ optional classInstanceVariables
    "/
    self classRef instanceVariableString isBlank ifFalse:[
        self fileOutClassInstVarDefinitionOn:aStream.
        aStream nextPutChunkSeparator. 
        aStream cr; cr
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc 
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:true do:[
        self privateClassesSorted do:[:aClass |
            aClass fileOutAllDefinitionsOn:aStream
        ]
    ].

    "Created: 15.10.1996 / 11:15:19 / cg"
    "Modified: 22.3.1997 / 16:11:56 / cg"
!

fileOutAllMethodsOn:aStream methodFilter:methodFilter
    |collectionOfCategories|

    collectionOfCategories := self theMetaclass categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self theMetaclass fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
            aStream cr
        ]
    ].
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
            aStream cr
        ]
    ].

    self privateClassesSorted do:[:aClass |
        aClass fileOutAllMethodsOn:aStream methodFilter:methodFilter
    ].
!

fileOutAs:fileNameString
    "create a file consisting of all methods in myself in
     sourceForm, from which the class can be reconstructed (by filing in).
     The given fileName should be a full path, including suffix.
     Care is taken, to not clobber any existing file in
     case of errors (for example: disk full). 
     Also, since the classes methods need a valid sourcefile, the current 
     sourceFile may not be rewritten."

    |aStream fileName newFileName savFilename needRename
     mySourceFileName sameFile s mySourceFileID anySourceRef|

    self isLoaded ifFalse:[
        ^ Class fileOutErrorSignal 
            raiseRequestWith:self
                 errorString:'will not fileOut unloaded classes'
    ].

    fileName := fileNameString asFilename.

    "
     if file exists, copy the existing to a .sav-file,
     create the new file as XXX.new-file,
     and, if that worked rename afterwards ...
    "
    (fileName exists) ifTrue:[
        sameFile := false.

        "/ check carefully - maybe, my source does not really come from that
        "/ file (i.e. all of my methods have their source as string)

        anySourceRef := false.
        self methodDictionary do:[:m|
            m sourcePosition notNil ifTrue:[
                anySourceRef := true
            ]
        ].
        self classRef methodDictionary do:[:m|
            m sourcePosition notNil ifTrue:[
                anySourceRef := true
            ]
        ].

        anySourceRef ifTrue:[
            s := self sourceStream.
            s notNil ifTrue:[
                mySourceFileID := s pathName asFilename info id.
                sameFile := (fileName info id) == mySourceFileID.
                s close.
            ] ifFalse:[
                self classFilename notNil ifTrue:[
                    "
                     check for overwriting my current source file
                     this is not allowed, since it would clobber my methods source
                     file ... you have to save it to some other place.
                     This happens if you ask for a fileOut into the source-directory
                     (from which my methods get their source)
                    "
                    mySourceFileName := Smalltalk getSourceFileName:self classFilename. 
                    sameFile := (fileNameString = mySourceFileName).
                    sameFile ifFalse:[
                        mySourceFileName notNil ifTrue:[
                            sameFile := (fileName info id) == (mySourceFileName asFilename info id)
                        ]
                    ].
                ]
            ].
        ].

        sameFile ifTrue:[
            ^ Class fileOutErrorSignal 
                raiseRequestWith:fileNameString
                errorString:('may not overwrite sourcefile:', fileNameString)
        ].

        savFilename := Filename newTemporary.
        fileName copyTo:savFilename.
        newFileName := fileName withSuffix:'new'.
        needRename := true
    ] ifFalse:[
        "/ another possible trap: if my sourceFileName is
        "/ the same as the written one AND the new files directory
        "/ is along the sourcePath, we also need a temporary file
        "/ first, to avoid accessing the newly written file.

        anySourceRef := false.
        self methodDictionary do:[:m|
            |mSrc|

            (mSrc := m sourceFilename) notNil ifTrue:[
                mSrc asFilename baseName = fileName baseName ifTrue:[
                    anySourceRef := true
                ]
            ]
        ].
        self classRef methodDictionary do:[:m|
            |mSrc|

            (mSrc := m sourceFilename) notNil ifTrue:[
                mSrc asFilename baseName = fileName baseName ifTrue:[
                    anySourceRef := true
                ]
            ]
        ].
        anySourceRef ifTrue:[
            newFileName := fileName withSuffix:'new'.
            needRename := true
        ] ifFalse:[
            newFileName := fileName.
            needRename := false
        ]
    ].

    aStream := newFileName writeStream.
    aStream isNil ifTrue:[
        savFilename notNil ifTrue:[
            savFilename delete
        ].
        ^ Class fileOutErrorSignal 
                raiseRequestWith:newFileName
                errorString:('cannot create file:', newFileName name)
    ].
    self fileOutOn:aStream.
    aStream close.

    "
     finally, replace the old-file
     be careful, if the old one is a symbolic link; in this case,
     we have to do a copy ...
    "
    needRename ifTrue:[
        newFileName copyTo:fileName.
        newFileName delete
    ].
    savFilename notNil ifTrue:[
        savFilename delete
    ].

    "
     add a change record; that way, administration is much easier,
     since we can see in that changeBrowser, which changes have 
     already found their way into a sourceFile and which must be
     applied again
    "
    self addChangeRecordForClassFileOut:self

    "Modified: / 7.6.1996 / 09:14:43 / stefan"
    "Created: / 16.4.1997 / 20:44:05 / cg"
    "Modified: / 12.8.1998 / 11:14:56 / cg"
!

fileOutCategory:aCategory
    "create a file 'class-category.st' consisting of all methods in aCategory.
     If the current project is not nil, create the file in the projects
     directory."

    |aStream fileName|

    fileName := (self name , '-' , aCategory , '.st') asFilename.
    fileName makeLegalFilename.

    "/
    "/ this test allows a smalltalk to be built without Projects/ChangeSets
    "/
    Project notNil ifTrue:[
        fileName := Project currentProjectDirectory asFilename construct:(fileName name).
    ].

    "/
    "/ if the file exists, save original in a .sav file
    "/
    fileName exists ifTrue:[
        fileName copyTo:(fileName withSuffix:'sav')
    ].
    aStream := FileStream newFileNamed:fileName.
    aStream isNil ifTrue:[
        ^ Class fileOutErrorSignal 
                raiseRequestWith:fileName
                errorString:('cannot create file:', fileName pathName)
    ].

    self fileOutCategory:aCategory on:aStream.
    aStream close

    "Modified: / 1.4.1997 / 16:00:24 / stefan"
    "Created: / 1.4.1997 / 16:04:18 / stefan"
    "Modified: / 28.10.1997 / 14:40:28 / cg"
!

fileOutCategory:aCategory except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    |dict source sortedSelectors first privacy interestingMethods cat|

    dict := self methodDictionary.
    dict notNil ifTrue:[
        interestingMethods := OrderedCollection new.
        dict do:[:aMethod |
            |wanted|

            (methodFilter isNil
            or:[methodFilter value:aMethod]) ifTrue:[
                (aCategory = aMethod category) ifTrue:[
                    skippedMethods notNil ifTrue:[
                        wanted := (skippedMethods includesIdentical:aMethod) not
                    ] ifFalse:[
                        savedMethods notNil ifTrue:[
                            wanted := (savedMethods includesIdentical:aMethod).
                        ] ifFalse:[
                            wanted := true
                        ]
                    ].
                    wanted ifTrue:[interestingMethods add:aMethod].
                ]
            ]
        ].
        interestingMethods notEmpty ifTrue:[
            first := true.
            privacy := nil.

            "/
            "/ sort by selector
            "/
            sortedSelectors := interestingMethods collect:[:m | self selectorAtMethod:m].
            sortedSelectors sortWith:interestingMethods.

            interestingMethods do:[:aMethod |
                first ifFalse:[
                    privacy ~~ aMethod privacy ifTrue:[
                        first := true.
                        aStream space.
                        aStream nextPutChunkSeparator.
                    ].
                    aStream cr; cr
                ].

                privacy := aMethod privacy.

                first ifTrue:[
                    aStream nextPutChunkSeparator.
                    self printClassNameOn:aStream.
                    privacy ~~ #public ifTrue:[
                        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
                    ] ifFalse:[
                        aStream nextPutAll:' methodsFor:'.
                    ].
                    cat := aCategory.
                    cat isNil ifTrue:[ cat := '' ].
                    aStream nextPutAll:aCategory asString storeString.
                    aStream nextPutChunkSeparator; cr; cr.
                    first := false.
                ].
                source := aMethod source.
                source isNil ifTrue:[
                    Class fileOutErrorSignal 
                        raiseRequestWith:self
                        errorString:'no source for method: ', (aMethod displayString)
                ] ifFalse:[
                    aStream nextChunkPut:source.
                ].
            ].
            aStream space.
            aStream nextPutChunkSeparator.
            aStream cr
        ]
    ]

    "Modified: 28.8.1995 / 14:30:41 / claus"
    "Modified: 12.6.1996 / 11:37:33 / stefan"
    "Modified: 15.11.1996 / 11:32:21 / cg"
    "Created: 1.4.1997 / 16:04:33 / stefan"
!

fileOutCategory:aCategory methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream"

    self fileOutCategory:aCategory except:nil only:nil methodFilter:methodFilter on:aStream
!

fileOutCategory:aCategory on:aStream
    Class fileOutNameSpaceQuerySignal answer:true do:[
        self fileOutCategory:aCategory except:nil only:nil methodFilter:nil on:aStream
    ]
!

fileOutClassInstVarDefinitionOn:aStream withNameSpace:withNameSpace
    "append an expression to define my classInstanceVariables on aStream"

    |anySuperClassInstVar|

    self isLoaded ifFalse:[
        ^ self basicFileOutDefinitionOn:aStream withNameSpace:withNameSpace
    ].

    withNameSpace ifTrue:[
        self name printOn:aStream.
    ] ifFalse:[
        self printClassNameOn:aStream.
    ].
    aStream nextPutAll:' class instanceVariableNames:'''.
    self theMetaclass printInstVarNamesOn:aStream indent:8.
    aStream nextPutAll:''''.

    "mhmh - good idea; saw this in SmallDraw sourcecode ..."

    anySuperClassInstVar := false.
    self allSuperclassesDo:[:aSuperClass |
        aSuperClass theMetaclass instVarNames do:[:ignored | anySuperClassInstVar := true].
    ].

    aStream cr; cr; nextPut:(Character doubleQuote); cr; space.
    anySuperClassInstVar ifFalse:[
        aStream  
            nextPutLine:'No other class instance variables are inherited by this class.'.
    ] ifTrue:[
        aStream  
            nextPutLine:'The following class instance variables are inherited by this class:'.
        aStream cr.
        self allSuperclassesDo:[:aSuperClass |
            aStream tab; nextPutAll:aSuperClass name; nextPutAll:' - '.
            aStream nextPutLine:(aSuperClass theMetaclass instanceVariableString).
        ].

    ].
    aStream nextPut:(Character doubleQuote); cr.

    "Created: / 10.12.1995 / 16:31:25 / cg"
    "Modified: / 1.4.1997 / 16:00:33 / stefan"
    "Modified: / 3.2.2000 / 23:05:28 / cg"
!

fileOutCommentOn:aStream
    "append an expression on aStream, which defines my comment"

    |comment s|

    self printClassNameOn:aStream.
    aStream nextPutAll:' comment:'.
    (comment := self comment) isNil ifTrue:[
        s := ''''''
    ] ifFalse:[
        s := comment storeString
    ].
    aStream nextPutAllAsChunk:s.
    aStream nextPutChunkSeparator.
    aStream cr
!

fileOutDefinitionOn:aStream
    "append an expression on aStream, which defines myself."

    ^ self basicFileOutDefinitionOn:aStream withNameSpace:false
!

fileOutMethod:aMethod
    |aStream fileName selector|

    selector := self selectorAtMethod:aMethod.
    selector notNil ifTrue:[
        fileName := (self name , '-' , selector, '.st') asFilename.
        fileName makeLegalFilename.

        "
         this test allows a smalltalk to be built without Projects/ChangeSets
        "
        Project notNil ifTrue:[
            fileName := Project currentProjectDirectory asFilename construct:fileName name.
        ].

        "
         if file exists, save original in a .sav file
        "
        fileName exists ifTrue:[
            fileName copyTo:(fileName withSuffix: 'sav')
        ].

        fileName := fileName name.

        aStream := FileStream newFileNamed:fileName.
        aStream isNil ifTrue:[
            ^ Class fileOutErrorSignal 
                raiseRequestWith:fileName
                errorString:('cannot create file:', fileName)
        ].
        self fileOutMethod:aMethod on:aStream.
        aStream close
    ]

    "Modified: / 1.4.1997 / 16:00:57 / stefan"
    "Created: / 2.4.1997 / 00:24:28 / stefan"
    "Modified: / 28.10.1997 / 14:40:34 / cg"
!

fileOutMethod:aMethod on:aStream
    |dict cat source privacy|

    dict := self methodDictionary.
    dict notNil ifTrue:[
        aStream nextPutChunkSeparator.
        self name printOn:aStream.
"/        self printClassNameOn:aStream.

        (privacy := aMethod privacy) ~~ #public ifTrue:[
            aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
        ] ifFalse:[
            aStream nextPutAll:' methodsFor:'.
        ].
        cat := aMethod category.
        cat isNil ifTrue:[
            cat := ''
        ].
        aStream nextPutAll:cat asString storeString.
        aStream nextPutChunkSeparator; cr; cr.
        source := aMethod source.
        source isNil ifTrue:[
            Class fileOutErrorSignal 
                raiseRequestWith:self
                errorString:('no source for method: ' ,
                             self name , '>>' ,
                             (self selectorAtMethod:aMethod))
        ] ifFalse:[
            aStream nextChunkPut:source.
        ].
        aStream space.
        aStream nextPutChunkSeparator.
        aStream cr
    ]

    "Modified: 27.8.1995 / 01:23:19 / claus"
    "Modified: 12.6.1996 / 11:44:41 / stefan"
    "Modified: 15.11.1996 / 11:32:43 / cg"
    "Created: 2.4.1997 / 00:24:33 / stefan"
!

fileOutOn:aStream

    ^ self fileOutOn:aStream withTimeStamp:true
!

fileOutOn:aStream withTimeStamp:stampIt
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended."

    self fileOutOn:aStream withTimeStamp:stampIt withInitialize:true
!

fileOutOn:aStream withTimeStamp:stampIt withInitialize:initIt
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization."

    self 
        fileOutOn:aStream 
        withTimeStamp:stampIt 
        withInitialize:initIt 
        withDefinition:true
        methodFilter:nil
!

fileOutOn:aStream withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    |collectionOfCategories copyrightMethod copyrightText comment versionMethod skippedMethods
     meta|

    self isLoaded ifFalse:[
        ^ Class fileOutErrorSignal 
            raiseRequestWith:self
                 errorString:'will not fileOut unloaded classes'
    ].

    meta := self classRef.

    "
     if there is a copyright method, add a copyright comment
     at the beginning, taking the string from the copyright method.
     We cannot do this unconditionally - that would lead to my copyrights
     being put on your code ;-).
     On the other hand: I want every file created by myself to have the
     copyright string at the beginning be preserved .... even if the
     code was edited in the browser and filedOut.
    "
    (copyrightMethod := meta compiledMethodAt:#copyright) notNil ifTrue:[
        "
         get the copyright methods source,
         and insert at beginning.
        "
        copyrightText := copyrightMethod source.
        copyrightText isNil ifTrue:[
            "
             no source available - trigger an error
            "
            Class fileOutErrorSignal
                raiseRequestWith:'no source for class ' , self name , ' available. Cannot fileOut'.
            ^ self
        ].
        "
         strip off the selector-line
        "
        copyrightText := copyrightText asCollectionOfLines asStringCollection.
        copyrightText := copyrightText copyFrom:2 to:(copyrightText size).
"/        copyrightText do:[:line | aStream nextPutAll:line. aStream cr.].
        copyrightText := copyrightText asString.
        aStream nextPutAllAsChunk:copyrightText.
    ].

    stampIt ifTrue:[
        "/
        "/ first, a timestamp
        "/
        aStream nextPutAll:(Smalltalk timeStamp).
        aStream nextPutChunkSeparator. 
        aStream cr; cr.
    ].

    withDefinition ifTrue:[
        "/
        "/ then the definition
        "/
        self fileOutAllDefinitionsOn:aStream.
        "/
        "/ a comment - if any
        "/
        (comment := self comment) notNil ifTrue:[
            self fileOutCommentOn:aStream.
            aStream cr.
        ].
        "/
        "/ primitive definitions - if any
        "/
        self fileOutPrimitiveSpecsOn:aStream.
    ].

    "/
    "/ methods from all categories in metaclass (i.e. class methods)
    "/ EXCEPT: the version method is placed at the very end, to
    "/         avoid sourcePosition-shifts when checked out later.
    "/         (RCS expands this string, so its size is not constant)
    "/
    collectionOfCategories := meta categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        "/
        "/ documentation first (if any), but not the version method
        "/
        (collectionOfCategories includes:'documentation') ifTrue:[
            versionMethod := meta compiledMethodAt:#version.
            versionMethod notNil ifTrue:[
                skippedMethods := Array with:versionMethod
            ].
            meta fileOutCategory:'documentation' except:skippedMethods only:nil methodFilter:methodFilter on:aStream.
            aStream cr.
        ].

        "/
        "/ initialization next (if any)
        "/
        (collectionOfCategories includes:'initialization') ifTrue:[
            meta fileOutCategory:'initialization' methodFilter:methodFilter on:aStream.
            aStream cr.
        ].

        "/
        "/ instance creation next (if any)
        "/
        (collectionOfCategories includes:'instance creation') ifTrue:[
            meta fileOutCategory:'instance creation' methodFilter:methodFilter on:aStream.
            aStream cr.
        ].
        collectionOfCategories do:[:aCategory |
            ((aCategory ~= 'documentation')
            and:[(aCategory ~= 'initialization')
            and:[aCategory ~= 'instance creation']]) ifTrue:[
                meta fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
                aStream cr
            ]
        ]
    ].

    "/
    "/ methods from all categories in myself
    "/
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
            aStream cr
        ]
    ].

    "/
    "/ any private classes' methods
    "/
    self privateClassesSorted do:[:aClass |
        aClass fileOutAllMethodsOn:aStream methodFilter:methodFilter
    ].


    "/
    "/ finally, the previously skipped version method
    "/
    versionMethod notNil ifTrue:[
        meta fileOutCategory:'documentation' except:nil only:skippedMethods methodFilter:methodFilter on:aStream.
    ].

    initIt ifTrue:[
        "/
        "/ optionally an initialize message
        "/
        (meta implements:#initialize) ifTrue:[
            self printClassNameOn:aStream. aStream nextPutAll:' initialize'.
            aStream nextPutChunkSeparator.
            aStream cr
        ]
    ]

    "Created: / 15.11.1995 / 12:53:06 / cg"
    "Modified: / 1.4.1997 / 16:01:05 / stefan"
    "Modified: / 13.3.1998 / 12:23:59 / cg"
!

fileOutPrimitiveDefinitionsOn:aStream
    "append primitive defs (if any) to aStream."

    |s|

    "
     primitive definitions - if any
    "
    (s := self primitiveDefinitionsString) notNil ifTrue:[
        aStream nextPutChunkSeparator.
        self printClassNameOn:aStream.
        aStream nextPutAll:' primitiveDefinitions';
                nextPutChunkSeparator;
                cr.
        aStream nextPutAll:s.
        aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].
    (s := self primitiveVariablesString) notNil ifTrue:[
        aStream nextPutChunkSeparator.
        self printClassNameOn:aStream.
        aStream nextPutAll:' primitiveVariables';
                nextPutChunkSeparator;
                cr.
        aStream nextPutAll:s.
        aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].

    "Modified: 8.1.1997 / 17:45:40 / cg"
!

fileOutPrimitiveSpecsOn:aStream
    "append primitive defs (if any) to aStream."

    |s|

    "
     primitive definitions - if any
    "
    self fileOutPrimitiveDefinitionsOn:aStream.
    "
     primitive functions - if any
    "
    (s := self primitiveFunctionsString) notNil ifTrue:[
        aStream nextPutChunkSeparator.
        self printClassNameOn:aStream.
        aStream nextPutAll:' primitiveFunctions';
                nextPutChunkSeparator;
                cr.
        aStream nextPutAll:s.
        aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].

    "Modified: 8.1.1997 / 17:45:51 / cg"
!

firstDefinitionSelectorPart
    "return the first part of the selector with which I was (can be) defined in my superclass"

    self isVariable ifFalse:[
        ^ #'subclass:'
    ].
    self isBytes ifTrue:[
        ^ #'variableByteSubclass:'
    ].
    self isLongs ifTrue:[
        ^ #'variableLongSubclass:'
    ].
    self isFloats ifTrue:[
        ^ #'variableFloatSubclass:'
    ].
    self isDoubles ifTrue:[
        ^ #'variableDoubleSubclass:'
    ].
    self isWords ifTrue:[
        ^ #'variableWordSubclass:'
    ].
    self isSignedWords ifTrue:[
        ^ #'variableSignedWordSubclass:'
    ].
    self isSignedLongs ifTrue:[
        ^ #'variableSignedLongSubclass:'
    ].
    self isSignedLongLongs ifTrue:[
        ^ #'variableSignedLongLongSubclass:'
    ].
    self isLongLongs ifTrue:[
        ^ #'variableLongLongSubclass:'
    ].
    ^ #'variableSubclass:'
!

getPrimitiveSpecsAt:index
    "{ Pragma: +optSpace }"

    "return a primitiveSpecification component as string or nil"

    |owner pos stream string primitiveSpec classFilename|

    (owner := self owningClass) notNil ifTrue:[^ owner getPrimitiveSpecsAt:index].

    primitiveSpec := self primitiveSpec.

    primitiveSpec isNil ifTrue:[^ nil].
    pos := primitiveSpec at:index.
    pos isNil ifTrue:[^ nil].

    "the primitiveSpec is either a string, or an integer specifying the
     position within the classes sourcefile ...
    "
    pos isNumber ifTrue:[
        classFilename := self classFilename.
        classFilename notNil ifTrue:[
            stream := self sourceStream. 
            stream notNil ifTrue:[
                stream position:pos+1.
                string := stream nextChunk.
                stream close.
                ^ string
            ]
        ].
        ^ nil
    ].
    ^ pos

    "Modified: 15.1.1997 / 15:29:30 / stefan"
!

hasMethods
    "return true, if there are any (local) methods in this class"

    ^ (self methodDictionary size ~~ 0)
!

implements:aSelector
    ^ self includesSelector:aSelector
!

includesSelector:aSelector
    ^ self methodDictionary includesKey:aSelector
!

instanceVariableString
    "return a string of the instance variable names"

    |instvars|

    instvars := self instVarNames.
    instvars isNil ifTrue:[^ ''].
    instvars isString ifTrue:[
        ^ instvars
    ].

    ^ instvars asStringWith:(Character space)

    "
     Point instanceVariableString   
    "

    "Modified: 22.8.1997 / 14:59:14 / cg"
!

isObsolete 
    "return true, if the receiver is obsolete 
     (i.e. has been replaced by a different class or was removed, 
      but is still referenced by instanced)"

    |cat|

    cat := self category.

    ^ cat = 'obsolete' 
      or:[cat = 'removed'
      or:[cat = '* removed *'
      or:[cat = '* obsolete *']]]
!

isSubclassOf:aClass
    "return true, if I am a subclass of the argument, aClass"

    |theClass|

    theClass := self superclass.
    [theClass notNil] whileTrue:[
        (theClass == aClass) ifTrue:[^ true].
        theClass := theClass superclass.
    ].
    ^ false
!

localSourceStreamFor:sourceFile
    "return an open stream on a local sourcefile, nil if that is not available"

    |fileName info module dir fn package packageDir zar entry|

    "/
    "/ old: look in 'source/<filename>'
    "/ this is still kept in order to find user-private
    "/ classes in her currentDirectory.
    "/
    fileName := Smalltalk getSourceFileName:sourceFile.
    fileName notNil ifTrue:[
        ^ fileName asFilename readStream.
    ].

    (package := self package) notNil ifTrue:[
        "/ newest sceme ...
        packageDir := package copyReplaceAll:$: with:$/.
        packageDir := Smalltalk getPackageFileName:packageDir.
        packageDir notNil ifTrue:[
            "/ present there ?
            packageDir := packageDir asFilename.
            (fn := packageDir construct:sourceFile) exists ifTrue:[
                ^ fn readStream.
            ].

            "/ a source subdirectory ?
            fn := (packageDir construct:'source') construct:sourceFile.
            fn exists ifTrue:[
                ^ fn readStream.
            ].

            "/ a zip-file ?
            fn := (packageDir construct:'source.zip').
            fn exists ifTrue:[
                zar := ZipArchive oldFileNamed:fn.
                zar notNil ifTrue:[
                    entry := zar extract:sourceFile.
                    entry notNil ifTrue:[
                        ^ entry asString readStream
                    ]
                ]
            ]
        ].

        "/ will vanish ...
        (package includes:$:) ifTrue:[
            package := package asString copyReplaceAll:$: with:$/
        ] ifFalse:[
            package := 'stx/' , package
        ].
        fileName := Smalltalk getSourceFileName:(package , '/' , sourceFile).
        fileName notNil ifTrue:[
            ^ fileName asFilename readStream.
        ].
        (package startsWith:'stx/') ifTrue:[
            fileName := Smalltalk getSourceFileName:((package copyFrom:5) , '/' , sourceFile).
            fileName notNil ifTrue:[
                ^ fileName asFilename readStream.
            ]
        ]
    ].

    "/
    "/ new: look in 'source/<module>/<package>/<filename>
    "/ this makes the symbolic links to (or copy of) the source files
    "/ obsolete.
    info := self packageSourceCodeInfo.
    info notNil ifTrue:[
        module := info at:#module ifAbsent:nil.
        module notNil ifTrue:[
            dir := info at:#directory ifAbsent:nil.
            dir notNil ifTrue:[
                fn := (module asFilename construct:dir) construct:sourceFile.
                fileName := Smalltalk getSourceFileName:(fn name).
                fileName notNil ifTrue:[
                    ^ fileName asFilename readStream.
                ].

                "/ brand new: look for source/<module>/package.zip
                "/ containing an entry for <filename>

                fn := (module asFilename construct:dir) withSuffix:'zip'.
                fileName := Smalltalk getSourceFileName:(fn name).
                fileName notNil ifTrue:[
                    zar := ZipArchive oldFileNamed:fileName.
                    zar notNil ifTrue:[
                        entry := zar extract:sourceFile.
                        entry notNil ifTrue:[
                            ^ entry asString readStream
                        ]
                    ]
                ].

                "/ and also in source/source.zip ...

                fileName := Smalltalk getSourceFileName:'source.zip'.
                fileName notNil ifTrue:[
                    zar := ZipArchive oldFileNamed:fileName.
                    zar notNil ifTrue:[
                        entry := zar extract:sourceFile.
                        entry notNil ifTrue:[
                            ^ entry asString readStream
                        ]
                    ]
                ].
            ]
        ]
    ].
    ^ nil

    "Modified: / 18.7.1998 / 22:53:19 / cg"
!

lookupMethodFor:aSelector
    "return the method, which would be executed if aSelector was sent to
     an instance of the receiver. I.e. the selector arrays of the receiver
     and all of its superclasses are searched for aSelector.
     Return the method, or nil if instances do not understand aSelector.
     EXPERIMENTAL: take care of multiple superclasses."

    |m cls|

    cls := self.
    [cls notNil] whileTrue:[
        m := cls compiledMethodAt:aSelector.
        m notNil ifTrue:[^ m].
        cls := cls superclass
    ].
    ^ nil
!

nameWithoutNameSpacePrefix
    |nm owner|

    nm := self nameWithoutPrefix.
    (owner := self owningClass) isNil ifTrue:[
        ^ nm
    ].

    ^ (owner nameWithoutNameSpacePrefix , '::' , nm)
!

nameWithoutPrefix
    |nm idx|

    nm := self name.
    idx := nm lastIndexOf:$:.
    idx == 0 ifTrue:[
        ^ nm
    ].
    ^ nm copyFrom:idx+1.
!

packageSourceCodeInfo
    "{ Pragma: +optSpace }"

    "return the sourceCodeInfo, which defines the module and the subdirectory
     in which the receiver class was built. 
     This info is extracted from the package id (which is added to stc-compiled classes).
     This method is to be obsoleted soon, since the same info is now found
     in the versionString.

     The info returned consists of a dictionary
     filled with (at least) values at: #module, #directory and #library.
     If no such info is present in the class, nil is returned.
     (this happens with autoloaded and filed-in classes)
     Auotloaded classes set their package from the revisionInfo, if present.

     By convention, this info is encoded in the classes package
     string (which is given as argument to stc) as the last word in parenthesis. 
     The info consists of 1 to 3 subcomponents, separated by colons.
     The first defines the classes module (i.e. some application identifier), 
     the second defines the subdirectory within that module, the third
     defines the name of the class library. 
     If left blank, the module info defaults to 'stx',
     the directory info defaults to library name.
     The library name may not be left blank.
     (this is done for backward compatibility,)

     For example: 
        '....(libbasic)'                         -> module: stx directory: libbasic library: libbasic
        '....(stx:libbasic)'                     -> module: stx directory: libbasic library: libbasic
        '....(stx:foo:libbfoo)'                  -> module: stx directory: foo library: libfoo
        '....(aeg:libIECInterface)'              -> module: aeg directory: libIECInterface library:libIECInterface
        '....(stx:goodies/persistency:libdbase)' -> module: stx directory: goodies/persistency library:libdbase 

     The way how the sourceCodeManager uses this to find the source location
     depends on the scheme used. For CVS, the module is taken as the -d arg,
     while the directory is prepended to the file name.
     Other schemes may do things differently - these are not yet specified.

     Caveat:
        Encoding this info in the package string seems somewhat kludgy.
    "

    |owner sourceInfo packageString idx1 idx2 
     moduleString directoryString libraryString components component1 component2 dirComponents mgr
     package|

    (owner := self owningClass) notNil ifTrue:[^ owner packageSourceCodeInfo].

    package := self package.
    package isNil ifTrue:[^ nil].

    packageString := package asString.
    idx1 := packageString lastIndexOf:$(.
    idx1 ~~ 0 ifTrue:[
        idx2 := packageString indexOf:$) startingAt:idx1+1.
        idx2 ~~ 0 ifTrue:[
            sourceInfo := packageString copyFrom:idx1 + 1 to:idx2 - 1
        ]
    ] ifFalse:[
        sourceInfo := packageString
    ].

    sourceInfo isNil ifTrue:[^ nil].
    components := sourceInfo asCollectionOfSubstringsSeparatedBy:$:.
    components size == 0 ifTrue:[
"/        moduleString := 'stx'.
"/        directoryString := libraryString := ''.
        ^ nil
    ].

    component1 := components at:1.
    components size == 1 ifTrue:[
        "/ a single name given - the module becomes 'stx' or
        "/ the very first directory component (if such a module exists).
        "/ If the component includes slashes, its the directory
        "/ otherwise the library.
        "/ 
        dirComponents := Filename concreteClass components:component1.     
        (dirComponents size > 1
        and:[(mgr := self sourceCodeManager) notNil
        and:[mgr checkForExistingModule:dirComponents first]]) ifTrue:[
            moduleString := dirComponents first.
            directoryString := libraryString := (Filename fromComponents:(dirComponents copyFrom:2)) asString.
        ] ifFalse:[
            "/ non-existing; assume directory under the stx package.
            moduleString := 'stx'.
            (component1 startsWith:'stx/') ifTrue:[
                component1 := component1 copyFrom:5
            ].
            directoryString := libraryString := component1.
        ].

        (libraryString includes:$/) ifTrue:[
            libraryString := libraryString asFilename baseName
        ]
    ] ifFalse:[
        component2 := components at:2.
        components size == 2 ifTrue:[
            "/ two components - assume its the module and the directory; 
            "/ the library is assumed to be named after the directory
            "/ except, if slashes are in the name; then the libraryname
            "/ is the last component.
            "/
            moduleString := component1.
            directoryString := libraryString := component2.
            (libraryString includes:$/) ifTrue:[
                libraryString := libraryString asFilename baseName
            ]
        ] ifFalse:[
            "/ all components given
            moduleString := component1.
            directoryString := component2.
            libraryString := components at:3.
        ]
    ].

    libraryString isEmpty ifTrue:[
        directoryString notEmpty ifTrue:[
            libraryString := directoryString asFilename baseName
        ].
        libraryString isEmpty ifTrue:[
            "/ lets extract the library from the liblist file ...
            libraryString := Smalltalk libraryFileNameOfClass:self.
            libraryString isNil ifTrue:[^ nil].
        ]
    ].

    moduleString isEmpty ifTrue:[
        moduleString := 'stx'.
    ].
    directoryString isEmpty ifTrue:[
        directoryString := libraryString.
    ].

    ^ IdentityDictionary
        with:(#module->moduleString)
        with:(#directory->directoryString)
        with:(#library->libraryString)

    "
     Object packageSourceCodeInfo     
     View packageSourceCodeInfo    
     Model packageSourceCodeInfo  
     BinaryObjectStorage packageSourceCodeInfo  
     MemoryMonitor packageSourceCodeInfo  
     ClockView packageSourceCodeInfo  
    "

    "Created: 4.11.1995 / 20:36:53 / cg"
    "Modified: 19.9.1997 / 10:42:25 / cg"
!

primitiveDefinitionsString
    "{ Pragma: +optSpace }"

    "return the primitiveDefinition string or nil"

    ^ self getPrimitiveSpecsAt:1

    "
     Object primitiveDefinitionsString
     String primitiveDefinitionsString
    "
!

primitiveFunctionsString
    "{ Pragma: +optSpace }"

    "return the primitiveFunctions string or nil"

    ^ self getPrimitiveSpecsAt:3
!

primitiveVariablesString
    "{ Pragma: +optSpace }"

    "return the primitiveVariables string or nil"

    ^ self getPrimitiveSpecsAt:2
!

printClassNameOn:aStream
    |nm|

    Class fileOutNameSpaceQuerySignal query == false ifTrue:[
        nm := self nameWithoutNameSpacePrefix
    ] ifFalse:[
        nm := self name.
    ].

    aStream nextPutAll:nm.
!

printClassVarNamesOn:aStream indent:indent
    "print the class variable names indented and breaking at line end"

    self printNameArray:(self classVarNames) on:aStream indent:indent
!

printHierarchyAnswerIndentOn:aStream
    "print my class hierarchy on aStream - return indent
     recursively calls itself to print superclass and use returned indent
     for my description - used in the browser"

    |indent nm superclass|

    superclass := self superclass.
    indent := 0.
    (superclass notNil) ifTrue:[
        indent := (superclass printHierarchyAnswerIndentOn:aStream) + 2
    ].
    aStream spaces:indent.
    nm := self printNameInHierarchy.
    aStream nextPutAll:nm; nextPutAll:' ('.
    self printInstVarNamesOn:aStream indent:(indent + nm size + 2).
    aStream nextPutLine:')'.
    ^ indent
!

printHierarchyOn:aStream
    self printHierarchyAnswerIndentOn:aStream
!

printInstVarNamesOn:aStream indent:indent
    "print the instance variable names indented and breaking at line end"

    self printNameArray:(self instVarNames) on:aStream indent:indent

    "Created: 22.3.1997 / 14:12:00 / cg"
!

printNameArray:anArray on:aStream indent:indent
    "print an array of strings separated by spaces; when the stream
     defines a lineLength, break when this limit is reached; indent
     every line; used to printOut instance variable names"

    |thisName nextName arraySize lenMax pos mustBreak line spaces|

    arraySize := anArray size.
    arraySize ~~ 0 ifTrue:[
        pos := indent.
        lenMax := aStream lineLength.
        thisName := anArray at:1.
        line := ''.
        1 to:arraySize do:[:index |
            line := line , thisName.
            pos := pos + thisName size.
            (index == arraySize) ifFalse:[
                nextName := anArray at:(index + 1).
                mustBreak := false.
                (lenMax > 0) ifTrue:[
                    ((pos + nextName size) > lenMax) ifTrue:[
                        mustBreak := true
                    ]
                ].
                mustBreak ifTrue:[
                    aStream nextPutLine:line withTabs.
                    spaces isNil ifTrue:[
                        spaces := String new:indent
                    ].
                    line := spaces.
                    pos := indent
                ] ifFalse:[
                    line := line , ' '.
                    pos := pos + 1
                ].
                thisName := nextName
            ]
        ].
        aStream nextPutAll:line withTabs
    ]

    "Modified: 9.11.1996 / 00:12:06 / cg"
    "Created: 22.3.1997 / 14:12:12 / cg"
!

printNameInHierarchy
    ^ self name
!

privateClasses
    "{ Pragma: +optSpace }"

    "return a collection of my private classes (if any).
     The classes are in any order."

    ^ self privateClassesOrAll:false
!

privateClassesAt:aClassNameStringOrSymbol
    |nmSym|

    nmSym := (self name , '::' , aClassNameStringOrSymbol) asSymbolIfInterned.
    nmSym isNil ifTrue:[
        "/ no such symbol - there cannot be a corresponding private class
        ^ nil
    ].

    ^ memory image at:nmSym.
!

privateClassesOrAll:allOfThem
    "{ Pragma: +optSpace }"

    "return a collection of my direct private classes (if any)
     or direct plus indirect private classes (if allOfThem).
     An empty collection if there are none.
     The classes are in any order."

    |classes myName myNamePrefix myNamePrefixLen|

    myName := self name.
    myNamePrefix := myName , '::'.
    myNamePrefixLen := myNamePrefix size.

    memory image keysDo:[:nm |
        |cls|

        (nm startsWith:myNamePrefix) ifTrue:[
            (allOfThem
            or:[(nm indexOf:$: startingAt:myNamePrefixLen + 1) == 0]) ifTrue:[
                cls := memory image at:nm.

                (cls isBehavior and:[cls isMeta not]) ifTrue:[
                    classes isNil ifTrue:[
                        classes := IdentitySet new:10.
                    ].
                    classes add:cls.
                ]
            ]
        ]
    ].

    ^ classes ? #()

    "
     UILayoutTool privateClassesOrAll:true 
     UILayoutTool privateClassesOrAll:false 
    "

    "Modified: / 29.5.1998 / 23:23:18 / cg"
!

privateClassesSorted
    "{ Pragma: +optSpace }"

    "return a collection of my private classes (if any).
     The classes are sorted by inheritance."

    |classes|

    classes := self privateClasses.
    (classes size > 0) ifTrue:[
        classes := classes asOrderedCollection topologicalSort:[:a :b | b isSubclassOf:a].
    ].
    ^ classes.

    "
     Object privateClassesSorted
    "

    "Created: 22.3.1997 / 16:10:42 / cg"
    "Modified: 22.3.1997 / 16:11:20 / cg"
!

revisionInfo
    "return a dictionary filled with revision info.
     This extracts the relevant info from the revisionString.
     The revisionInfo contains all or a subset of:
        #binaryRevision - the revision upon which the binary of this class is based
        #revision       - the revision upon which the class is based logically
                          (different, if a changed class was checked in, but not yet recompiled)
        #user           - the user who checked in the logical revision
        #date           - the date when the logical revision was checked in
        #time           - the time when the logical revision was checked in
        #fileName       - the classes source file name
        #repositoryPath - the classes source container
    "

    |vsnString info mgr|

    vsnString := self revisionString.
    vsnString notNil ifTrue:[
        mgr := self sourceCodeManager.
        mgr notNil ifTrue:[
            info := mgr revisionInfoFromString:vsnString
        ] ifFalse:[
            info := Class revisionInfoFromString:vsnString.
        ].
        info notNil ifTrue:[
            info at:#binaryRevision put:self binaryRevision.
        ]
    ].
    ^ info
!

revisionInfoOfManager: mgr
    ^ (Smalltalk classNamed:self name)
            revisionInfoOfManager: mgr
!

revisionString
    "{ Pragma: +optSpace }"

    "return my revision string; that one is extracted from the
     classes #version method. Either this is a method returning that string,
     or its a comment-only method and the comment defines the version.
     If the source is not accessible or no such method exists,
     nil is returned."

    |owner cls meta m src val|

    (owner := self owningClass) notNil ifTrue:[^ owner revisionString].

    thisContext isRecursive ifTrue:[^ nil ].

    self isMeta ifTrue:[
        meta := self. cls := self soleInstance
    ] ifFalse:[
        cls := self. meta := self classRef
    ].

    m := meta compiledMethodAt:#version.
    m isNil ifTrue:[
        m := cls compiledMethodAt:#version.
        m isNil ifTrue:[^ nil].
    ].

    m isExecutable ifTrue:[
        "/
        "/ if its a method returning the string,
        "/ thats the returned value
        "/
        val := cls version.
        val isString ifTrue:[^ val].
    ].

    "/
    "/ if its a method consisting of a comment only
    "/ extract it - this may lead to a recursive call
    "/ to myself (thats what the #isRecursive is for)
    "/ in case we need to access the source code manager
    "/ for the source ...
    "/
    src := m source.
    src isNil ifTrue:[^ nil].
    ^ Class revisionStringFromSource:src 

    "
     Smalltalk allClassesDo:[:cls |
        Transcript showCR:cls revisionString
     ].

     Number revisionString  
     FileDirectory revisionString
     Metaclass revisionString
    "

    "Created: 29.10.1995 / 19:28:03 / cg"
    "Modified: 23.10.1996 / 18:23:56 / cg"
    "Modified: 1.4.1997 / 23:37:25 / stefan"
!

selectorAtMethod:aMethod
    ^ self selectorAtMethod:aMethod ifAbsent:[nil]
!

selectorAtMethod:aMethod ifAbsent:failBlock
    |md|

    md := self methodDictionary.
    md isNil ifTrue:[
        'OOPS - nil methodDictionary' errorPrintCR.
        ^ nil
    ].
    ^ md keyAtValue:aMethod ifAbsent:failBlock.
!

soleInstance
    self isMeta ifFalse:[self halt].
    ^ self theNonMetaclass.
!

sourceCodeManager
    ^ SourceCodeManager
!

sourceStreamFor:source
    "return an open stream on a sourcefile, nil if that is not available"

    |owner fileName aStream mgr validated guessedFileName sep mod dir classFilename package name|

    self isMeta ifTrue:[
        ^ self theNonMetaclass sourceStreamFor:source
    ].

    (owner := self owningClass) notNil ifTrue:[^ owner sourceStreamFor:source].
    validated := false.

    classFilename := self classFilename.
    package := self package.
    name := self name.

    "/
    "/ if there is no SourceCodeManager,
    "/ or TryLocalSourceFirst is true,
    "/ look in standard places first
    "/
    ((mgr := self sourceCodeManager) isNil
    or:[Class tryLocalSourceFirst == true]) ifTrue:[
        aStream := self localSourceStreamFor:source.
    ].

    aStream isNil ifTrue:[
        "/ mhmh - still no source file.
        "/ If there is a SourceCodeManager, ask it to acquire the
        "/ the source for my class, and return an open stream on it.
        "/ if that one does not know about the source, look in
        "/ standard places

        mgr notNil ifTrue:[
            self classFilename ~= source ifTrue:[
                sep := self package indexOfAny:'/\:'.
                sep ~~ 0 ifTrue:[
                    mod := package copyTo:sep - 1.
                    dir := package copyFrom:sep + 1.
                    aStream := mgr streamForClass:nil fileName:source revision:nil directory:dir module:mod cache:true.
                ].
            ].
            aStream isNil ifTrue:[
                classFilename isNil ifTrue:[
                    classFilename := guessedFileName := (Smalltalk fileNameForClass:self) , '.st'.
                ].
                source asFilename baseName = classFilename asFilename baseName ifTrue:[
                    aStream := mgr getSourceStreamFor:self.
                ]
            ].
            aStream notNil ifTrue:[
                (self validateSourceStream:aStream) ifFalse:[
                    ('Class [info]: repositories source for `'
                     , (self isMeta ifTrue:[self soleInstance name]
                                    ifFalse:[name])
                     , ''' is invalid.') infoPrintCR.
                    aStream close.
                    aStream := nil
                ] ifTrue:[
                    validated := true.
                ].
            ].
        ]
    ].

    aStream isNil ifTrue:[
        "/
        "/ hard case - there is no source file for this class
        "/ (in the source-dir-path).
        "/

        "/
        "/ look if my binary is from a dynamically loaded module,
        "/ and, if so, look in the modules directory for the
        "/ source file.
        "/
        ObjectFileLoader notNil ifTrue:[
            ObjectFileLoader loadedObjectHandlesDo:[:h |
                |f classes|

                aStream isNil ifTrue:[
                    (classes := h classes) size > 0 ifTrue:[
                        (classes includes:self) ifTrue:[
                            f := h pathName.
                            f := f asFilename directory.
                            f := f construct:source.
                            f exists ifTrue:[
                                aStream := f readStream.
                            ].
                        ].
                    ].
                ]
            ].
        ].
    ].

    "/
    "/ try along sourcePath
    "/
    aStream isNil ifTrue:[
        aStream := self localSourceStreamFor:source.
    ].

    "/
    "/ final chance: try current directory
    "/
    aStream isNil ifTrue:[
        aStream := source asFilename readStream.
    ].

    (aStream notNil and:[validated not]) ifTrue:[
        (self validateSourceStream:aStream) ifFalse:[
            (Smalltalk releaseIdentification = 'ST/X_free_demo_vsn') ifTrue:[
"/                ('Class [info]: source for ''' , self name , ''' is not available in the demo version.') infoPrintCR
            ] ifFalse:[
                ('Class [warning]: source for ''' , self name , ''' is invalid or stripped. Take care.') errorPrintCR
            ]
        ].
    ].
    (aStream notNil and:[aStream isFileStream]) ifTrue:[
        guessedFileName notNil ifTrue:[
            classFilename := aStream pathName asFilename baseName.
        ]
    ].
    ^ aStream

    "
     Object sourceStream
     Clock sourceStream
     Autoload sourceStream
    "

    "Created: / 10.11.1995 / 21:05:13 / cg"
    "Modified: / 22.4.1998 / 19:20:50 / ca"
    "Modified: / 23.4.1998 / 15:53:54 / cg"
!

subclasses
    "return a collection of the direct subclasses of the receiver"

    |newColl|

"/    "/ use cached information (avoid class hierarchy search)
"/    "/ if possible
"/
"/    SubclassInfo notNil ifTrue:[
"/        newColl := SubclassInfo at:self ifAbsent:nil.
"/        newColl notNil ifTrue:[^ newColl asOrderedCollection]
"/    ].

    newColl := OrderedCollection new.
    self subclassesDo:[:aClass |
        newColl add:aClass
    ].
"/    SubclassInfo notNil ifTrue:[
"/        SubclassInfo at:self put:newColl.
"/    ].
    ^ newColl
!

subclassesDo:aBlock
    "evaluate the argument, aBlock for all immediate subclasses.
     This will only enumerate globally known classes - for anonymous
     behaviors, you have to walk over all instances of Behavior."

    |coll|

    self isMeta ifTrue:[
        self halt.
        "/ metaclasses are not found via Smalltalk allClassesDo:
        "/ here, walk over classes and enumerate corresponding metas.
        self soleInstance subclassesDo:[:aSubClass |
            aBlock value:(aSubClass theMetaclass)
        ].
        ^ self
    ].

    "/ use cached information (avoid class hierarchy search)
    "/ if possible

"/    SubclassInfo isNil ifTrue:[
"/        Behavior subclassInfo
"/    ].
"/    SubclassInfo notNil ifTrue:[
"/        coll := SubclassInfo at:self ifAbsent:nil.
"/        coll notNil ifTrue:[
"/            coll do:aBlock.
"/        ].
"/        ^ self
"/    ].

    Smalltalk allClassesDo:[:aClass |
        (aClass superclass == self) ifTrue:[
            aBlock value:aClass
        ]
    ]

    "
     Collection subclassesDo:[:c | Transcript showCR:(c name)]
    "

    "Modified: 22.1.1997 / 18:44:01 / cg"
!

syntaxHighlighterClass
    ^ Object syntaxHighlighterClass
!

theMetaclass
    self isMeta ifTrue:[^ self].
    ^ self classRef.
!

theNonMetaclass
    |instSlotOffs clsPtr|

    self isMeta ifFalse:[^ self].
    instSlotOffs := Metaclass instVarOffsetOf:'myClass'.
    clsPtr := self at:instSlotOffs.
    ^ memory fetchObjectAt:clsPtr.
!

validateSourceStream:aStream
    "check if aStream really contains my source.
     This is done by checking the version methods return value
     against the version string as contained in the version method"

    ^ true
!

whichClassDefinesClassVar:aVariableName
    "return the class which defines the class variable
     named aVariableName. This method should not be used for
     repeated searches (i.e. in the compiler/parser), since it creates
     many throw away intermediate objects."

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
        (cls classVarNames includes:aVariableName) ifTrue:[ ^ cls].
        cls := cls superclass
    ].
    ^ nil
!

whichClassIncludesSelector:aSelector
    "return the class in the inheritance chain, which implements the method
     for aSelector; return nil if none."

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
        (cls includesSelector:aSelector) ifTrue:[^ cls].
        cls := cls superclass
    ].
    ^ nil
!

withAllSuperclasses
    "return a collection containing the receiver and all
     of the receivers accumulated superclasses"

    |aCollection theSuperClass|

    aCollection := OrderedCollection with:self.
    theSuperClass := self superclass.
    [theSuperClass notNil] whileTrue:[
        aCollection add:theSuperClass.
        theSuperClass := theSuperClass superclass
    ].
    ^ aCollection
!

withAllSuperclassesDo:aBlock
    |sc|

    aBlock value:self.
    sc := self superclass.
    sc notNil ifTrue:[
        sc withAllSuperclassesDo:aBlock.
    ]
! !

!SnapShotImageMemory::ImageClassObject methodsFor:'namespace protocol'!

allClasses
    |classes|

    classes := IdentitySet new.
    self allClassesDo:[:aClass | classes add:aClass].
    ^ classes
!

allClassesDo:aBlock
    |prefix|

    self isNameSpace ifFalse:[ self error ].
    prefix := self name , '::'.

    memory image allClassesDo:[:cls |
        (cls name startsWith:prefix) ifTrue:[
            aBlock value:cls
        ]
    ]
!

at:aKey
    |fullName|

    aKey isString ifFalse:[
        ^ super at:aKey
    ].

    self isNameSpace ifFalse:[ self error:'namespace expected' ].
    fullName := self name , '::' , aKey.
    ^ memory image at:fullName asSymbol
! !

!SnapShotImageMemory::ImageClassObject methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'img-'.
    aStream nextPutAll:self name.
! !

!SnapShotImageMemory::ImageClassObject methodsFor:'queries'!

categories
    |newList|

    newList := Set new.
    self methodDictionary do:[:aMethod |
        |cat|

        cat := aMethod category.
        cat isNil ifTrue:[
            cat := '* no category *'
        ].
        newList add:cat
    ].
    ^ newList
!

isBytes
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagBytes.
!

isDoubles
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagDoubles.
!

isFloats
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagFloats.
!

isImageBehavior
    ^ true
!

isLoaded
    |superclass|

    superclass := self superclass.
    superclass isNil ifTrue:[^ true].
    ^ self superclass name ~= 'Autoload'
!

isLongLongs
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagLongLongs.
!

isLongs
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagLongs.
!

isMeta
    |clsName|

    thisContext isRecursive ifTrue:[^ false].
    byteSize = memory metaClassByteSize ifFalse:[^ false].

    clsName := classRef name.
    ^ clsName = 'Metaclass' or:[clsName = 'PrivateMetaclass'].

"/self halt.
"/    ^ self size == (Metaclass instSize).
!

isNameSpace
    "return true, if this is a nameSpace."

    |superclass|

    superclass := self superclass.
    ^ superclass notNil
      and:[ superclass name = 'NameSpace' ].
!

isPrivate
    ^ classRef isPrivateMeta
!

isPrivateMeta
    thisContext isRecursive ifTrue:[^ false].
    byteSize = memory privateMetaClassByteSize ifFalse:[^ false].
    ^ classRef name = 'PrivateMetaclass'
!

isSignedLongLongs
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagSignedLongLongs.
!

isSignedLongs
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagSignedLongs.
!

isSignedWords
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagSignedWords.
!

isTopLevelNameSpace
    "return true, if this is a top level nameSpace."

    ^ self isNameSpace and:[(self name includes:$:) not]
!

isVariable
    ^ (self flags bitAnd:Behavior maskIndexType) ~= 0.
!

isVisualStartable
    ^ false
!

isWords
    ^ (self flags bitAnd:Behavior maskIndexType) == Behavior flagWords.
!

nameSpace
    |env name idx nsName|

"/    (env := self environment) notNil ifTrue:[^ env].
    env := memory image at:#Smalltalk. "/ default
    name := self name.
    idx := name lastIndexOf:$:.
    idx ~~ 0 ifTrue:[
        (name at:idx-1) == $: ifTrue:[
            nsName := name copyTo:(idx - 2).
            env := memory image at:nsName asSymbol.
        ]
    ].
    ^ env
!

owningClass
    |ownerPtr owner|

    classRef isPrivateMeta ifFalse:[^ nil].
    ownerPtr := classRef at:(PrivateMetaclass instVarOffsetOf:'owningClass').
    owner := memory fetchClassObjectAt:ownerPtr.
    ^ owner
!

owningClassOrYourself
    self owningClass notNil ifTrue:[^ self topOwningClass].
    ^ self
!

supportsMethodCategories
    ^ true
!

topNameSpace
    "return the nameSpace of my topOwningClass (if private) or my own nameSpace."

    self isPrivate ifTrue:[^ self topOwningClass topNameSpace].
    ^ self nameSpace
!

topOwningClass
    |owner|

    classRef isPrivateMeta ifTrue:[
        owner := self owningClass.
        [owner classRef isPrivateMeta] whileTrue:[
            owner := owner owningClass
        ].
        ^ owner
    ] ifFalse:[
        ^ nil
    ].
    ^ self halt.
!

wasAutoloaded
    ^ false
! !

!SnapShotImageMemory::ImageWordObject methodsFor:'queries'!

size
    ^ byteSize // 2
! !

!SnapShotImageMemory::SpaceInfo methodsFor:'accessing'!

end
    "return the value of the instance variable 'end' (automatically generated)"

    ^ end
!

end:something
    "set the value of the instance variable 'end' (automatically generated)"

    end := something.
!

flags
    "return the value of the instance variable 'flags' (automatically generated)"

    ^ flags
!

flags:something
    "set the value of the instance variable 'flags' (automatically generated)"

    flags := something.
!

imageBase
    "return the value of the instance variable 'imageBase' (automatically generated)"

    ^ imageBase
!

imageBase:something
    "set the value of the instance variable 'imageBase' (automatically generated)"

    imageBase := something.
!

size
    "return the value of the instance variable 'size' (automatically generated)"

    ^ size
!

size:something
    "set the value of the instance variable 'size' (automatically generated)"

    size := something.
!

start
    "return the value of the instance variable 'start' (automatically generated)"

    ^ start
!

start:something
    "set the value of the instance variable 'start' (automatically generated)"

    start := something.
! !

!SnapShotImageMemory class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

