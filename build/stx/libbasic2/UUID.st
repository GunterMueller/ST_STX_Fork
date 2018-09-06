"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

ByteArray variableByteSubclass:#UUID
	instanceVariableNames:''
	classVariableNames:'CachedMACAddress Lock SequenceNumber LastTime Increment
		NameSpaceToUuidBytes CachedUuidsBySymbol'
	poolDictionaries:''
	category:'Net-Communication-Support'
!

!UUID class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    128-bit Universal Unique Ids (UUIDs) as defined by OpenGroup/DCE
        http://www.opengroup.org/onlinepubs/9629399/apdxa.htm.

    See also RFC4122.

    A UUID is unique in time and space (at least until about Year 3400).

    Several fields if the UUID are interpreted as integers, so host/network byte
    order is relevant. UUIDs are stored in a ByteArray in network byte order (MSB-first),
    so they may be exported/imported between different machines.

    You can import UUIDs in host byte order using #fromNativeBytes:

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!UUID class methodsFor:'initialization'!

initialize
    "I want to get informed about image restarts"

    Lock isNil ifTrue:[
        Lock := RecursionLock new name:#UUID.
        LastTime := 0.
        Increment := 0.
        CachedUuidsBySymbol := IdentityDictionary new.
    ]
!

nameSpaceToUuidBytes
    NameSpaceToUuidBytes isNil ifTrue:[
        NameSpaceToUuidBytes := Dictionary 
            withKeysAndValues:#(
                DNS  #[16r6B 16rA7 16rB8 16r10 16r9D 16rAD 16r11 16rD1 16r80 16rB4 16r0 16rC0 16r4F 16rD4 16r30 16rC8]            
                URL  #[16r6B 16rA7 16rB8 16r11 16r9D 16rAD 16r11 16rD1 16r80 16rB4 16r0 16rC0 16r4F 16rD4 16r30 16rC8]
                "ASN.1 OID in DER or as Text"
                OID  #[16r6B 16rA7 16rB8 16r12 16r9D 16rAD 16r11 16rD1 16r80 16rB4 16r0 16rC0 16r4F 16rD4 16r30 16rC8]
                "X.500 DN as DER or as Text"
                X500 #[16r6B 16rA7 16rB8 16r14 16r9D 16rAD 16r11 16rD1 16r80 16rB4 16r0 16rC0 16r4F 16rD4 16r30 16rC8]            
            ).
    ].
    ^ NameSpaceToUuidBytes
!

update:something with:aParameter from:changedObject
    "flush cached MAC address (may have been restarted on another host)"

    (something == #restarted) ifTrue:[
        CachedMACAddress := nil.
        SequenceNumber := nil.
    ]
! !

!UUID class methodsFor:'instance creation'!

basicNew
    ^ super basicNew:16
!

basicNew:size
    "allow creating with exact size. We need this for XMLStandardDecoder"

    size ~~ 16 ifTrue:[
        ^ self shouldNotImplement.
    ].
    ^ super basicNew:size.
!

decodeFromLiteralArray:anArray
    anArray size == 2 ifTrue:[
        "/ UUID 'uuid-string'
        ^ self readFrom:(anArray at:2).
    ].
    "/ UUID bytes...
    ^ super decodeFromLiteralArray:anArray "/ self readFrom:(anArray at:2)

    "
     (UUID decodeFromLiteralArray:#(UUID '5b023ce0-41f1-11dd-b99f-001558137da0'))
       literalArrayEncoding   
    "
!

fromBytes:aByteArray
    "set uuid from aByteArray.
     aByteArray must be 16 bytes in network byte order (MSB-first)"

    |uuid|

    uuid := super basicNew:16.
    uuid replaceFrom:1 to:16 with:aByteArray.
    ^ uuid.

    "    
     UUID fromBytes:#[16r01 16r02 16r03 16r04
                      16r05 16r06 16r07 16r08
                      16r09 16r10 16r11 16r12
                      16r13 16r14 16r15 16r16]. 
    "
!

fromBytes:aByteArray MSB:msb
    "Set the UUID from aByteArray. UUIDS are stored internally as MSB-first. 
     So, alway set
        msb = true      if reading from network or persistent storage"

    |uuid|

    uuid := self fromBytes:aByteArray.
    msb ifFalse:[
        self adjustByteOrder:uuid.
    ].

    ^ uuid

    "
     UUID fromBytes:#[16r01 16r02 16r03 16r04
                      16r05 16r06 16r07 16r08
                      16r09 16r10 16r11 16r12
                      16r13 16r14 16r15 16r16] msb:false. 
    "
    "
     UUID fromBytes:#[16r01 16r02 16r03 16r04
                      16r05 16r06 16r07 16r08
                      16r09 16r10 16r11 16r12
                      16r13 16r14 16r15 16r16] msb:true.    
    "
!

fromNativeBytes:aByteArray
    "convert bytes to uuid.
     aByteArray represents a UUID in host byte order 
     - e.g. an UUID fetched from the Windows OS"

    |uuid|

    uuid := self fromBytes:aByteArray.
    IsBigEndian ifFalse:[
        self adjustByteOrder:uuid.
    ].
    ^ uuid.

    "    
     UUID fromNativeBytes:#[16r01 16r02 16r03 16r04
                              16r05 16r06 16r07 16r08
                              16r09 16r10 16r11 16r12
                              16r13 16r14 16r15 16r16]. 

    "
!

fromString:aStringOrSymbol
    "convert aStringOrSymbol to a UUID. 
     If aStringOrSymbol is a symbol, cache this UUID for faster conversion.

     The real conversion is done in #readFrom:onError."

    |isSymbol uuid|

    isSymbol := aStringOrSymbol isSymbol.
    isSymbol ifTrue:[
        uuid := CachedUuidsBySymbol at:aStringOrSymbol ifAbsent:[].
        uuid notNil ifTrue:[^ uuid].
    ].
    uuid := self readFrom:aStringOrSymbol readStream.
    isSymbol ifTrue:[
        CachedUuidsBySymbol at:aStringOrSymbol put:uuid.
    ].
    ^ uuid.

    "
        UUID fromString:'be1ef7a0-ae1d-11e0-9cb5-02ff7d4f61ea'
        UUID fromString:#'be1ef7a0-ae1d-11e0-9cb5-02ff7d4f61ea'

        Time millisecondsToRun:[
            100000 timesRepeat:[
                UUID fromString:'be1ef7a0-ae1d-11e0-9cb5-02ff7d4f61ea'.
            ]
        ]

        Time millisecondsToRun:[
            100000 timesRepeat:[
                UUID fromString:#'be1ef7a0-ae1d-11e0-9cb5-02ff7d4f61ea'.
            ]
        ]
    "
!

genRandomUUID
    "generate a new random UUID"

    ^ (super basicNew:16) setRandomUUIDFromBytes:(RandomGenerator new nextBytes:16).


    "
      self genRandomUUID
    "

    "
      |uuids sample|
      sample := 100000.
      uuids := Set new:sample.  
      sample timesRepeat:[
          uuids add:UUID genRandomUUID.
      ].
      self assert:(uuids size = sample).  
      uuids

      1 to: 100 do:[ : el |
          Transcript show:el.
          Transcript show:': '.
          Transcript showCR:(UUID genRandomUUID).
      ].
    "
!

genTimestampUUID
    "generate a new timestamp UUID"

    ^ (super basicNew:16) genTimestampUUID

    "
      self genTimestampUUID
    "
!

genUUID
    "generate a uuid.
     If a physical mac address can be retrieved from the OS,
     a mac-address/timestamp uuid is generated,
     otherwise a random uuid will be generated."

    CachedMACAddress isNil ifTrue:[
        self getValidMACAddress.
    ].
    CachedMACAddress == false ifTrue:[
        "no mac address - generate random UUID"
        ^ self genRandomUUID.
    ].
    ^ (super basicNew:16) genTimestampUUID.

    "
      self genUUID
    "

    "
      1 to: 100 do:[ : el |
          Transcript show:el.
          Transcript show:': '.
          Transcript showCR:(UUID genUUID).
      ].
    "
!

genUUID:nameStringOrBytes inNameSpace:namespaceStringOrUUID
    "generate a namespace UUID (Version 5, hashed by SHA-1).
     See RFC4122."

    ^ (super basicNew:16) genUUID:nameStringOrBytes inNameSpace:namespaceStringOrUUID

    "
        self genUUID:'www.example.org' inNameSpace:'DNS'.
        self genUUID:'http://www.exept.de' inNameSpace:'URL'.
        self genUUID:'1.2.3.4.5' inNameSpace:'OID'.
        self genUUID:(OSI::DERCoder encode:(OSI::ASN1_OID newID:#(1 2 3 4 5))) 
             inNameSpace:'OID'.
        self genUUID:'c=de, o=eXept Software AG, cn=Development' 
             inNameSpace:'X500'.
        self genUUID:(OSI::DERCoder encode:(OSI::DistinguishedName fromString:'c=de, o=eXept Software AG, cn=Development') asAsn1Value) 
             inNameSpace:'X500'.
    "
!

new
    ^ self genUUID

    "
     self new 
    "
!

readFrom:aStringOrStream onError:errorBlock
    |d offs s uuid t byte hasBrackets|

    Error handle:[:ex |
        ^ errorBlock value.
    ] do:[
        s := aStringOrStream readStream.
        uuid := super basicNew:16.
        hasBrackets := false.

        s skipSeparators.
        s peek == ${ ifTrue:[
            s next; skipSeparators.
            hasBrackets := true.
        ].

        t := s next:8.
        d := Integer readFrom:t radix:16 onError:[^ errorBlock value].
        uuid unsignedInt32At:1 put:d MSB:true.
        offs := 5.

        s next.         "skip $-"

        1 to:2 do:[:i |
            t := s next:4.
            d := Integer readFrom:t radix:16 onError:[^ errorBlock value].
            uuid unsignedInt16At:offs put:d MSB:true.
            offs := offs + 2.
            s next.     "skip $-"
        ].

        1 to:2 do:[:i |
            t := s next:2.
            d := Integer readFrom:t radix:16 onError:[^ errorBlock value].
            uuid at:offs put:d.
            offs := offs + 1.
        ].
        s next.         "skip $-"

        1 to:6 do:[:i |
            t := s next:2.
            byte := Integer readFrom:t radix:16 onError:[^ errorBlock value].
            uuid at:offs put:byte.
            offs := offs + 1.
        ].
        hasBrackets ifTrue:[
            s peek == $} 
                ifTrue:[s next] 
                ifFalse:errorBlock
        ].
    ].
    ^ uuid

    "
     UUID readFrom:'5ab2e9b4-3d48-11d2-9ea4-80c5140aaa77' 
     UUID readFrom:'{5ab2e9b4-3d48-11d2-9ea4-80c5140aaa77}' 
     UUID readFrom:'{5ab2e9b4-3d48-11d2-9ea4-80c5140aaa77' 
     UUID fromString:'5ab2e9b4-3d48-11d2-9ea4-80c5140aaa77 bllll' 
     UUID fromString:'5ab2e9b4-3d48-11d2-9ea4-80c5140aaa77' 
     UUID fromString:'00000001-0000-0000-C000-000000000046'
     UUID fromString:'00000001-0000-0000-C000-000000004600'
     UUID fromString:'00000001-0000-0000-C000-000000460000'
     UUID fromString:'00000001-0000-0000-C000-000046000000'
     UUID fromString:'00000001-0000-0000-C000-004600000000'
     UUID fromString:'00000001-0000-0000-C000-460000000000'
     UUID fromString:'00000001-0000-0000-C046-000000000000'
     UUID fromString:'00000001-0000-0046-C000-000000000000'
     UUID fromString:'00000001-0000-4600-C000-000000000000'
     UUID fromString:'00000001-0046-0000-C000-000000000000'
     UUID fromString:'00000001-4600-0000-C000-000000000000'
     UUID fromString:'00000100-4600-0000-C000-000000000000'
     UUID fromString:'00010000-4600-0000-C000-000000000000'
     UUID fromString:'10000000-4600-0000-C000-000000000000'
    "

    "Modified: / 10-10-2007 / 23:03:47 / cg"
! !

!UUID class methodsFor:'helpers'!

adjustByteOrder:aByteArray
    "change the byte order of the uuid"

    |d|

    d := aByteArray unsignedInt32At:1 MSB:false.
    aByteArray unsignedInt32At:1 put:d MSB:true.

    d := aByteArray unsignedInt16At:1+4 MSB:false.
    aByteArray unsignedInt16At:1+4 put:d MSB:true.

    d := aByteArray unsignedInt16At:1+4+2 MSB:false.
    aByteArray unsignedInt16At:1+4+2 put:d MSB:true.
!

getDtssUtcTime
    "return the DTSS based time in 100 nsec intervals
     DTSS UTC base time is October 15, 1582 (the start of the Gregorian Calendar)."

     "Unix base time is January 1, 1970.
      The difference between both is: 122192928000000000"

"   
        (Timestamp epoch asDate subtractDate:(Date day:15 month:10 year:1582))
        *  (24 * 60 * 60)
"

    ^ (Timestamp now getMilliseconds + 12219292800000) * 10000.
!

getValidMACAddress
    "return the first valid MAC address (i.e. having at least 6 bytes with the first six bytes ~~ 0).
     As a side effect, initialize anything needed for timestamp UUIDs."

    CachedMACAddress isNil ifTrue:[
        CachedMACAddress := false.      "negative caching: remember the fact, that there is no MAC address" 
        PrimitiveFailure catch:[
            CachedMACAddress := OperatingSystem getNetworkMACAddresses 
                                    detect:[:macAddress | macAddress size >= 6 
                                                            and:[(macAddress startsWith:#[0 0 0 0 0 0]) not]]
                                    ifNone:false.
            Lock isNil ifTrue:[
                Lock := RecursionLock new name:#UUID.
                LastTime := 0.
                Increment := 0.
            ].
        ].
        "try again when restarted from a snapshot"
        ObjectMemory addDependent:self.
    ].

    ^ CachedMACAddress

    "
       CachedMACAddress := nil.
       self getValidMACAddress
    "

    "Modified: / 17-11-2004 / 01:45:53 / cg"
! !


!UUID methodsFor:'accessing'!

clockSeqHiAndReserved
    ^ self at:9
!

clockSeqLow
    ^ self at:10
!

node
    "answer the node (ethernet) address of this uuid"

    self isTimestampUUID ifFalse:[
        ConversionError raiseWith:self errorString:' - trying to get node address from random UUID'.
    ].            
    ^ (ByteArray new:6) replaceFrom:1 to:6 with:self startingAt:11.

    "
       (self allInstances 
            select:[:e| e isTimestampUUID] 
            thenCollect:[:e| e node]) asBag
    "
!

timeHighAndVersion
    ^ self unsignedInt16At:7 MSB:true
!

timeLow
    ^ self unsignedInt32At:1 MSB:true
!

timeMid
    ^ self unsignedInt16At:5 MSB:true
!

timestamp
    "Get the UTC timestamp, when the UUID has been created.
     This is only valid for timestampUUIDs"

    |low med high dtssUtcTime|

    self isTimestampUUID ifFalse:[
        ConversionError raiseWith:self errorString:' - trying to get timestamp from random UUID'.
    ].            

    low := self unsignedInt32At:1 MSB:true.
    med := self unsignedInt16At:5 MSB:true.
    high := (self unsignedInt16At:7 MSB:true) bitAnd:16rFFF.

    dtssUtcTime := low + ((med + (high bitShift:16)) bitShift:32).

    ^ UtcTimestamp utcMillisecondsSince1970:(dtssUtcTime//10000) - 12219292800000.

    "
        self genTimestampUUID timestamp
        self genRandomUUID timestamp

        (self allInstances asSet asArray select:[:e| e isTimestampUUID] 
                                            thenCollect:[:e| e timestamp]) sort
    "
!

version
    "the version number of the uuid"

    ^ ((self at:7) bitAnd:16rF0) bitShift:-4.

    "
        self genTimestampUUID version
        self genRandomUUID version
    "
! !

!UUID methodsFor:'converting'!

asBytes
    "convert this UUID to a ByteArray in network byte order (MSB-first)"

    |bytes|

    bytes := ByteArray new:16.
    bytes replaceFrom:1 to:16 with:self.
    ^ bytes

    "
     |bytes|
        
     bytes := #[16r01 16r02 16r03 16r04
                      16r05 16r06 16r07 16r08
                      16r09 16r10 16r11 16r12
                      16r13 16r14 16r15 16r16].
     (UUID fromBytes:bytes) asBytes ~= bytes ifTrue:[self halt] 
    "
!

asBytesMSB:msb
    "convert this UUID to a ByteArray.
     If msb == false, it is converted into LSB-first byte ordering"

    |bytes|

    bytes := self asBytes.

    msb ifFalse:[
        self class adjustByteOrder:bytes.
    ].
    ^ bytes

    "Modified: / 10-10-2007 / 22:51:09 / cg"
!

asNativeBytes
    "convert this uuid to a ByteArray in host byte order.
     Use this only to pass the UUID to the OS (Windows)"

    |bytes|

    bytes := self asBytes.
    IsBigEndian ifFalse:[
        self class adjustByteOrder:bytes.
    ].
    ^ bytes.
!

asString
    ^ self printString

    "
        self genUUID asString
    "
!

asUUID
    ^ self
!

literalArrayEncoding
    ^ Array 
        with:(self class name)
        with:(self printString).
! !

!UUID methodsFor:'copying'!

deepCopy
    "I am never changed, after I have been created.
     So there is no need to make a copy"

    ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "I am never changed, after I have been created.
     So there is no need to make a copy"

    ^ self
!

shallowCopy
    "I am never changed, after I have been created.
     So there is no need to make a copy"

    ^ self
!

simpleDeepCopy
    "I am never changed, after I have been created.
     So there is no need to make a copy"

    ^ self
! !

!UUID methodsFor:'generating uuids'!

genTimestampUUID
    "generate a timestamp (and mac-address) based uuid"

    |macBytes utcTime seqNr|

    (self at:7) ~~ 0 ifTrue:[
        "once created, an UUID is immutable"
        self noModificationError.
    ].

    macBytes := CachedMACAddress.
    macBytes isNil ifTrue:[
        macBytes := self class getValidMACAddress.
        macBytes size < 6 ifTrue:[
            self error:'no mac address - cannot generate UUID'.
        ].
    ].

    "use 60 bit counter of 100ns ticks since 00:00:00 15.oct 1582 (sigh)"
    utcTime := self class getDtssUtcTime.

    Lock critical:[
        SequenceNumber isNil ifTrue:[
            SequenceNumber := RandomGenerator new nextIntegerBetween:0 and:16383.
        ].
        utcTime > (LastTime+Increment) ifTrue:[
            Increment := 0.
        ] ifFalse:[
            LastTime = utcTime ifTrue:[
                "clock didn't advance since last call. Simply add a tick"
                Increment := Increment + 1.
            ] ifFalse:[
                "clock went backwards - increment SequenceNumber"
                Increment := 0.
                SequenceNumber := SequenceNumber + 1.
                SequenceNumber >= 16384 ifTrue:[SequenceNumber := 0].
            ].
        ].
        
        LastTime := utcTime.
        utcTime := utcTime + Increment.
        seqNr := SequenceNumber.
    ].


    "time low: long"
    self unsignedInt32At:1 put:(utcTime bitAnd:16rFFFFFFFF) MSB:true.

    "time med: short"
    utcTime := utcTime bitShift:-32.
    self unsignedInt16At:5 put:(utcTime bitAnd:16rFFFF) MSB:true.

    "time high and version: short
     multiplex the 4 bit version number in highest 4 bits (version 1 -> time based version)"
    self unsignedInt16At:7 put:((utcTime bitShift:-16) bitOr:16r1000) MSB:true.

    "2 sequence bytes + reserved bits (this is not a short!!)"
    self at:9  put:(((seqNr bitShift:-8) bitAnd:16r3F) bitOr:16r80).
    self at:10 put:(seqNr bitAnd:16rFF).

    "48 bits of MAC-Address"
    self replaceFrom:11 to:16 with:macBytes startingAt:1.

    "
      self genTimestampUUID
      self genTimestampUUID genTimestampUUID
    "

    "
      1 to: 100 do:[ : el |
          Transcript show:el.
          Transcript show:': '.
          Transcript showCR:(UUID new genTimestampUUID).
      ].
    "

    "Modified: / 26-12-2011 / 13:41:23 / cg"
!

genUUID:nameStringOrBytes inNameSpace:namespaceStringOrUUID
    "generate a namespace UUID (Version 5, hashed by SHA-1).
     See RFC4122."

    |sha1 namespaceUUID|

    (self at:7) ~~ 0 ifTrue:[
        "once created, an UUID is immutable"
        self noModificationError.
    ].

    namespaceStringOrUUID isUUID ifTrue:[
        namespaceUUID := namespaceStringOrUUID.
    ] ifFalse:[
        "this throws an exception, if namespaceStringOrUUID is unknown"
        namespaceUUID := self class nameSpaceToUuidBytes at:namespaceStringOrUUID.
    ].

    sha1 := SHA1Stream new.
    sha1 
        nextPutAll:namespaceUUID;
        nextPutAll:nameStringOrBytes.

    self replaceFrom:1 to:16 with:(sha1 hashValue).
    "multiplex the 4 bit version number (Version 5 -> SHA1 Namspace UUID) in high bits of byte 7"
    self at:7 put:(((self at:7) bitAnd:16r0F) bitOr:16r50).
    self at:9 put:(((self at:9) bitAnd:16r3F) bitOr:16r80).

    "
        self genUUID:'www.example.org' inNameSpace:'DNS'.
        self genUUID:'http://www.exept.de' inNameSpace:'URL'.
        self genUUID:'some text' inNameSpace:(UUID fromString:'885f7d80-7d60-11e5-a133-101f74535bd0').
        self genUUID:'1.2.3.4.5' inNameSpace:'OID'.
        self genUUID:(OSI::DERCoder encode:(OSI::ASN1_OID newID:#(1 2 3 4 5))) 
             inNameSpace:'OID'.
        self genUUID:'c=de, o=eXept Software AG, cn=Development' 
             inNameSpace:'X500'.
        self genUUID:(OSI::DERCoder encode:(OSI::DistinguishedName fromString:'c=de, o=eXept Software AG, cn=Development') asAsn1Value) 
             inNameSpace:'X500'.
    "
!

setRandomUUIDFromBytes:sixteenBytes
    "answer a randomly generated uuid as defined in RFC4122 section 4.4"

    (self at:7) ~~ 0 ifTrue:[
        "once created, an UUID is immutable"
        self noModificationError.
    ].

    self replaceFrom:1 to:16 with:sixteenBytes.
    "multiplex the 4 bit version number (Version 4 -> Random UUID) in high bits of byte 7"
    self at:7 put:(((self at:7) bitAnd:16r0F) bitOr:16r40).
    self at:9 put:(((self at:9) bitAnd:16r3F) bitOr:16r80).
! !

!UUID methodsFor:'hashing'!

hash
   "Generate a 30 bit hash value.
    For Timestamp-UUIDs:
        Bytes 1,2,3,4 are the least significant bits of the timestamp,
        Bytes 13,14,15,16 are the least significant bytes of the mac address - 
            but considering these bytes does not generate a better hash to
            justify the additional computations.

    For random UUIDs, every byte is random anyway."

    ^ (self computeXorHashFrom:1 to:4)
"/        bitXor:(self computeXorHashFrom:13 to:16)

    "
        |allHashes|
        allHashes := UUID allInstances collect:[:each| each hash].
        (allHashes asSet size / allHashes size) asFloat
    "
! !


!UUID methodsFor:'printing'!

displayOn:aGCOrStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.

    aGCOrStream isStream ifTrue:[
        self printOn:aGCOrStream.
        ^ self.
    ].

    ^ super displayOn:aGCOrStream.

    "
        self genUUID displayOn:Transcript
    "
!

printOn:aStream
    1 to:4 do:[:idx|
        (self basicAt:idx) printOn:aStream base:-16 size:2 fill:$0.
    ].
    aStream nextPut:$-.
    5 to:6 do:[:idx|
        (self basicAt:idx) printOn:aStream base:-16 size:2 fill:$0.
    ].
    aStream nextPut:$-.
    7 to:8 do:[:idx|
        (self basicAt:idx) printOn:aStream base:-16 size:2 fill:$0.
    ].
    aStream nextPut:$-.
    9 to:10 do:[:idx|
        (self basicAt:idx) printOn:aStream base:-16 size:2 fill:$0.
    ].
    aStream nextPut:$-.
    11 to:16 do:[:idx|
        (self basicAt:idx) printOn:aStream base:-16 size:2 fill:$0.
    ].

    "
     UUID genUUID printString 
     UUID genUUID asString 
    "

"/    d := self unsignedLongAt:1 bigEndian:true.
"/    d printOn:tmpStream base:16 size:8 fill:$0.
"/    tmpStream nextPut:$-.
"/
"/    d := self unsignedShortAt:1+4 bigEndian:true.
"/    d printOn:tmpStream base:16 size:4 fill:$0.
"/    tmpStream nextPut:$-.
"/
"/    d := self unsignedShortAt:1+4+2 bigEndian:true.
"/    d printOn:tmpStream base:16 size:4 fill:$0.
"/    tmpStream nextPut:$-.
"/
"/    d := self at:1+4+2+2.
"/    d printOn:tmpStream base:16 size:2 fill:$0.
"/    d := self at:1+4+2+2+1.
"/    d printOn:tmpStream base:16 size:2 fill:$0.
"/    tmpStream nextPut:$-.
"/
"/    11 to:16 do:[:idx|
"/        d := self at:idx.
"/        d printOn:tmpStream base:16 size:2 fill:$0.
"/    ].


    "Modified: / 10-10-2007 / 23:19:03 / cg"
!

storeOn:aStream
    aStream 
        nextPut:$(; 
        nextPutAll:self class name; 
        nextPutAll:' fromString:'''.
    self printOn:aStream.
    aStream nextPutAll:''')'.

    "
     Object readFrom:(UUID genUUID storeString) 
    "
! !

!UUID methodsFor:'testing'!

isRandomUUID
    ^ self version == 4

    "
      self genRandomUUID isRandomUUID
    "
!

isTimestampUUID
    ^ self version == 1

    "
      self genTimestampUUID isTimestampUUID
    "
!

isUUID
    ^ true
! !

!UUID class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


UUID initialize!
