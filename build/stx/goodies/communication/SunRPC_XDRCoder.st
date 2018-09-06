"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Object subclass:#XDRCoder
	instanceVariableNames:'xdrStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

!XDRCoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    XDR (eXternal Data Representation) encoder and decoder.
    Encodes/decodes objects to/from the wire-protocol format.
    Only a limited subset of object types is supported (see XDR documentation)

    [author:]
        Claus Gittinger
        
    [see also:]
        http://tools.ietf.org/html/rfc4506
"
! !

!XDRCoder class methodsFor:'instance creation'!

from:data
    ^ self basicNew initializeFor:data
!

new
    ^ self basicNew initialize
! !

!XDRCoder methodsFor:'accessing'!

contents
    "return the data buffered so far"

    ^ xdrStream contents

    "
     (self new
        uint:16r12345678;
        contents) printOn:Transcript base:16
    "
! !

!XDRCoder methodsFor:'decoding'!

decodeArrayWithType:arrayType
    |size array|

    size := self unpackUnsignedInt.
    array := Array new:size.
    1 to:size do:[:idx |
        |element|

        element := arrayType elementType decodeFrom:self.
        array at:idx put:element.
    ].
    ^ array
!

decodeBoolean
    ^ self unpackBool

    "Created: / 30.1.2002 / 15:13:50 / cg"
!

decodeChar
    ^ self unpackInt
!

decodeInt
    ^ self unpackInt
!

decodeLong
    ^ self unpackInt
!

decodeOpaqueWithType:stringType
    |bytes dimension nRead nPadded|

    dimension := stringType dimension.
    dimension notNil ifTrue:[
        "/ fixed size
        bytes := xdrStream next:dimension.
        nRead := dimension
    ] ifFalse:[
        "/ variable size

        "/ maxSize := stringType maxSize.
        nRead := self unpackUnsignedInt.
        bytes := xdrStream next:nRead.
    ].
    nPadded := ((nRead+3) // 4) * 4.
    nRead+1 to:nPadded do:[:pad | xdrStream nextByte].
    ^ bytes.
!

decodeOptionalWithType:optionalType
    |flag realType lastField ignoreLastInStruct coll el|

    realType := optionalType type.
    ignoreLastInStruct := false.

    realType isXDRStruct ifTrue:[
        lastField := realType fields last.
        lastField type isOptional ifTrue:[
            (lastField type == optionalType 
            or:[ lastField type type == optionalType type ]) ifTrue:[
                ignoreLastInStruct := true.
            ].
        ]
    ].

    flag := self unpackUnsignedInt.

    ignoreLastInStruct ifTrue:[
        flag == 0 ifTrue:[
            ^ #()
        ].
        coll := OrderedCollection new.
        [ flag ~~ 0 ] whileTrue:[
            el := self decodeStructWithType:realType ignoreLast:true.
            coll add:el.
            flag := self unpackUnsignedInt.
        ].
        ^ coll.
    ].

    flag == 0 ifTrue:[
        ^ nil
    ].
    ^ self decodeStructWithType:realType ignoreLast:false.

    "Created: / 30.1.2002 / 14:36:14 / cg"
    "Modified: / 30.1.2002 / 14:37:22 / cg"
!

decodeShort
    ^ self unpackInt
!

decodeStringWithType:stringType
    |string dimension nRead nPadded|

    dimension := stringType dimension.
    dimension notNil ifTrue:[
        "/ fixed size
        string := xdrStream next:dimension.
        nRead := dimension
    ] ifFalse:[
        "/ variable size

        "/ maxSize := stringType maxSize.
        nRead := self unpackUnsignedInt.
        string := xdrStream next:nRead.
    ].
    nPadded := ((nRead+3) // 4) * 4.
    nRead+1 to:nPadded do:[:pad | xdrStream nextByte].
    string := string asString.
    ^ string.
!

decodeStructWithType:structType 
    ^ self decodeStructWithType:structType ignoreLast:false
!

decodeStructWithType:structType ignoreLast:ignoreLast
    |fields fieldName fieldType fieldValue ignoredField valueDict|

    fields := structType fields.
    ignoreLast ifTrue:[
        ignoredField := fields last
    ].

    valueDict := Dictionary new.

    fields do:[:eachField |
        eachField ~~ ignoredField ifTrue:[
            fieldName := eachField name.
            fieldType := eachField type.

            fieldValue := fieldType decodeFrom:self.
            valueDict at:fieldName put:fieldValue.
        ].
    ].
    ^ valueDict
!

decodeUnionWithType:unionType
    | unionValue selector field fields fieldValue 
     discriminantValue numericDiscriminantValue|

    selector := unionType discriminant.

    discriminantValue := selector type decodeFrom:self.
    discriminantValue isInteger ifTrue:[
        numericDiscriminantValue := discriminantValue
    ] ifFalse:[
        "/ must be enum then
        numericDiscriminantValue := selector type numericValueFor:discriminantValue. 
    ].

    fields := unionType fields.
    field := fields at:numericDiscriminantValue ifAbsent:nil.
    field isNil ifTrue:[
        field := unionType defaultField.
        field isNil ifTrue:[
            self error:'bad discriminant value (no field for value)'
        ]
    ].

    unionValue := Dictionary new.
    unionValue at:(selector name) put:discriminantValue.

    field type isXDRVoid ifFalse:[
        fieldValue := field type decodeFrom:self.
        unionValue at:(field name) put:fieldValue.
    ].
    ^ unionValue

    "Created: / 31.1.2002 / 15:26:36 / cg"
!

decodeUnsignedChar
    ^ self unpackUnsignedInt
!

decodeUnsignedInt
    ^ self unpackUnsignedInt
!

decodeUnsignedLong
    ^ self unpackUnsignedInt
!

decodeUnsignedShort
    ^ self unpackUnsignedInt
! !

!XDRCoder methodsFor:'encoding'!

decodeEnumWithType:enumType
    |v|

    v := self decodeInt.
    ^ enumType symbolicValueFor:v.

    "Created: / 30.1.2002 / 15:00:05 / cg"
    "Modified: / 30.1.2002 / 15:00:58 / cg"
!

encodeArray:anArray type:arrayType with:aParameter
    self packUnsignedInt:anArray size.
    anArray do:[:eachElement |
        arrayType elementType 
            encode:eachElement on:self with:aParameter.
    ].
!

encodeBoolean:value with:aParameter
    self encodeUnsignedInt:(value ifTrue:[1] ifFalse:[0]) with:aParameter
!

encodeChar:value with:aParameter
    self packInt:value.
!

encodeEnum:value type:enumType with:aParameter
    |v|

    v := enumType numericValueFor:value.
    self packInt:v.
!

encodeInt:value with:aParameter
    self packInt:value.
!

encodeLong:value with:aParameter
    self packInt:value.
!

encodeOpaque:value type:opaqueType with:dummyParameter
    |strLen dimension maxSize nWritten nPadded|

    strLen := value size.

    dimension := opaqueType dimension.
    dimension notNil ifTrue:[
        "/ fixed size
        dimension > strLen ifTrue:[
            xdrStream nextPutAll:value.
            xdrStream next:(dimension - strLen) put:0.
        ] ifFalse:[
            dimension == strLen ifTrue:[
                xdrStream nextPutAll:value.
            ] ifFalse:[
                self error:'collections size is > fields size'.
                xdrStream nextPutAll:value startingAt:1 to:dimension
            ].
        ].
        nWritten := dimension
    ] ifFalse:[
        "/ variable size
        maxSize := opaqueType maxSize ? 16rFFFFFFFF.
        maxSize >= strLen ifTrue:[
            self packInt:strLen.
            xdrStream nextPutAll:value.
            nWritten := strLen
        ] ifFalse:[
            self error:'collections size is > fields maxSize'.
            self packInt:maxSize.
            xdrStream nextPutAll:value startingAt:1 to:maxSize.
            nWritten := maxSize
        ].
    ].

    nPadded := ((nWritten+3) // 4) * 4.
    nWritten+1 to:nPadded do:[:pad | xdrStream nextPut:0].
!

encodeOptional:value type:optionalType with:dummyParameter
    |realType lastField ignoreLastInStruct|

    value isNil ifTrue:[
        self packUnsignedInt:0.
        ^ self.
    ].
    realType := optionalType type.
    ignoreLastInStruct := false.
    (value isArray or:[value isOrderedCollection]) ifTrue:[
        realType isXDRStruct ifTrue:[
            lastField := realType fields last.
            lastField type isOptional ifTrue:[
                (lastField type == optionalType 
                or:[ lastField type type == optionalType type ]) ifTrue:[
                    ignoreLastInStruct := true.
                ].
            ]
        ].
        value do:[:val |
            self packUnsignedInt:1.
            ignoreLastInStruct ifTrue:[
                self encodeStruct:val type:realType with:dummyParameter ignoreLast:true.
            ] ifFalse:[
                realType encode:val on:self with:dummyParameter.
            ]
        ].
        self packUnsignedInt:0.
        ^ self.
    ].

    self packUnsignedInt:1.
    realType encode:value on:self with:dummyParameter.
!

encodeShort:value with:aParameter
    self packInt:value.
!

encodeString:value type:stringType with:dummyParameter
    |strLen dimension maxSize nWritten nPadded|

    strLen := value size.

    dimension := stringType dimension.
    dimension notNil ifTrue:[
        "/ fixed size
        dimension > strLen ifTrue:[
            strLen > 0 ifTrue:[ xdrStream nextPutAll:value ].
            xdrStream next:(dimension - strLen) put:0.
        ] ifFalse:[
            dimension == strLen ifTrue:[
                strLen > 0 ifTrue:[ xdrStream nextPutAll:value ].
            ] ifFalse:[
                self error:'strings size is > fields size'.
                xdrStream nextPutAll:value startingAt:1 to:dimension
            ].
        ].
        nWritten := dimension
    ] ifFalse:[
        "/ variable size

        maxSize := stringType maxSize ? 16rFFFFFFFF.
        maxSize >= strLen ifTrue:[
            self packInt:strLen.
            strLen > 0 ifTrue:[ xdrStream nextPutAll:value ].
            nWritten := strLen
        ] ifFalse:[
            self error:'strings size is > fields maxSize'.
            self packInt:maxSize.
            xdrStream nextPutAll:value startingAt:1 to:maxSize.
            nWritten := maxSize
        ].
    ].
    nPadded := ((nWritten+3) // 4) * 4.
    nWritten+1 to:nPadded do:[:pad | xdrStream nextPut:0].

    "Modified: / 09-11-2006 / 09:54:05 / cg"
!

encodeStruct:value type:structType with:dummyParameter
    self encodeStruct:value type:structType with:dummyParameter ignoreLast:false
!

encodeStruct:value type:structType with:dummyParameter ignoreLast:ignoreLast
    |fields fieldName fieldType isDictionary ignoredField useFieldType|

    isDictionary := value isKindOf:Dictionary.

    fields := structType fields.
    ignoreLast ifTrue:[
        ignoredField := fields last.
        fields size == 2 ifTrue:[
            isDictionary ifTrue:[
                useFieldType := (value includesKey:(fields first name asSymbol)) not.
            ] ifFalse:[
                useFieldType := (value respondsTo:(fields first name asSymbol)) not.
            ].
            useFieldType ifTrue:[
                fields := fields first type fields.
                ignoredField := nil.
            ].
        ].
    ].

    fields do:[:eachField |
        |fieldValue|

        eachField ~~ ignoredField ifTrue:[
            fieldName := eachField name.
            fieldType := eachField type.

            value notNil ifTrue:[
                isDictionary ifTrue:[
                    fieldValue := value at:fieldName ifAbsent:nil.
                ] ifFalse:[
                    fieldValue := value perform:fieldName asSymbol.
                ]
            ].

            fieldValue isNil ifTrue:[
                Transcript showCR:'using defaultValue for field ' , fieldName.
                fieldValue := fieldType defaultValue.
            ].

            fieldType encode:fieldValue on:self with:dummyParameter.
        ].
    ].

    "Modified: / 1.2.2002 / 14:59:33 / cg"
!

encodeUnion:value type:unionType with:dummyParameter
    |unionKey unionValue selector field fields discriminantValue|

    selector := unionType discriminant.

    value isAssociation ifTrue:[
        unionKey := value key.
    ] ifFalse:[
        unionKey := value at:(selector name).
    ].

    unionKey isInteger ifTrue:[
        discriminantValue := unionKey
    ] ifFalse:[
        "/ must be enum then
        discriminantValue := selector type numericValueFor:unionKey 
    ].

    fields := unionType fields.
    field := fields at:discriminantValue ifAbsent:nil.
    field isNil ifTrue:[
        field := unionType defaultField.
        field isNil ifTrue:[
            self error:'bad discriminant value (no field for value)'
        ]
    ].

    selector type encode:discriminantValue on:self with:dummyParameter.
    field type isXDRVoid ifTrue:[^ self].

    value isAssociation ifTrue:[
        unionValue := value value.
    ] ifFalse:[
        unionValue := value at:(field name).
    ].

    field type encode:unionValue on:self with:dummyParameter.
!

encodeUnsignedChar:value with:aParameter
    self packUnsignedInt:value.
!

encodeUnsignedInt:value with:aParameter
    self packUnsignedInt:value.
!

encodeUnsignedLong:value with:aParameter
    self packUnsignedInt:value.
!

encodeUnsignedShort:value with:aParameter
    self packUnsignedInt:value.
!

encodeVoid:value with:aParameter
    "/ nothing encoded for void
! !

!XDRCoder methodsFor:'initialization'!

initialize
    xdrStream := #[] writeStream.
!

initializeFor:data
    xdrStream := data readStream.
! !

!XDRCoder methodsFor:'packing'!

packArray:aCollection using:selector
    self packUnsignedInt:aCollection size.
    self packFArray:aCollection using:selector

    "
     self new
        packArray:#(1 2 3) using:#uint:;
        contents     
    "
!

packBool:aBool
    xdrStream nextPutInt32:(aBool ifTrue:[1] ifFalse:[0]) MSB:true

    "
     self new
        packBool:true;
        contents
    "
!

packDouble:aFloat
    self error:'not yet implemented'.

    "
     self new
        packDouble:1.2345;
        contents     
    "
!

packEnum:aNumberOrSymbol
    |num|

    (num := aNumberOrSymbol) isSymbol ifTrue:[
        num := RPCDefinitions perform:aNumberOrSymbol
    ].
    self packUnsignedInt:num
!

packFloat:aFloat
    self error:'not yet implemented'.

    "
     self new
        packFloat:1.2345;
        contents     
    "
!

packHyper:aNumber
    xdrStream nextPutInt64:aNumber MSB:true

    "
     self new
        packHyper:-1;
        contents
    "
!

packInt:aNumber
    xdrStream nextPutInt32:aNumber MSB:true

    "
     self new
        packInt:-1;
        contents
    "
!

packList:aCollection using:selectorOrBlock
    aCollection do:[:eachItem |
        self packUnsignedInt:1.
        selectorOrBlock isBlock ifTrue:[
            selectorOrBlock value:eachItem
        ] ifFalse:[
            self perform:selectorOrBlock with:eachItem
        ].
    ].
    self packUnsignedInt:0.

    "
     self new
        packList:#(1 2 3) using:#packUint:;
        contents     
    "
!

packList:aCollection using:selectorOrBlock with:aParameter
    aCollection do:[:eachItem |
        self packUnsignedInt:1.
        selectorOrBlock isBlock ifTrue:[
            selectorOrBlock value:eachItem value:aParameter
        ] ifFalse:[
            self perform:selectorOrBlock with:eachItem with:aParameter
        ].
    ].
    self packUnsignedInt:0.
!

packOpaque:something
    self packUnsignedInt:(something size).
    self packFString:something

    "
     self new
        packOpaque:'abcdefg';
        contents     
    "
!

packString:aString
    self packUnsignedInt:(aString size).
    self packFString:aString

    "
     self new
        packString:'abcdefg';
        contents     
    "
!

packUhyper:aLongNumber
    xdrStream nextPutInt64:aLongNumber MSB:true. "/ self packUnsignedHyper:aLongNumber.

    "
     self new
        packUhyper:16r123456789abcdef0;
        contents     
    "
!

packUint:aNumber
    xdrStream nextPutInt32:aNumber MSB:true "/ self packUnsignedInt:aNumber

    "
     self new
        packUint:16r12345678;
        contents
    "
!

packUnsignedHyper:aLongNumber
    xdrStream nextPutInt64:aLongNumber MSB:true

    "
     self new
        packUnsignedHyper:16r123456789abcdef0;
        contents     
    "
!

packUnsignedInt:aNumber
    xdrStream nextPutInt32:aNumber MSB:true

    "
     self new
        packUnsignedInt:16r12345678;
        contents
    "
! !

!XDRCoder methodsFor:'packing - private'!

packFArray:aCollection using:selector
    aCollection do:[:eachItem |
        self perform:selector with:eachItem
    ].

    "
     self new
        packArray:#(1 2 3) using:#uint:;
        contents     
    "
!

packFString:aString
    |len       "{Class: SmallInteger}"
     lenPadded "{Class: SmallInteger}"
     nPad      "{Class: SmallInteger}"|

    len := aString size.
    xdrStream nextPutAll:aString.
    lenPadded := ((len+3) // 4) * 4.
    nPad := lenPadded - len.
    1 to:nPad do:[:i | xdrStream nextPut:0].

    "
     self new
        string:'abcdefg';
        contents     
    "
! !

!XDRCoder methodsFor:'packing-rpc packages'!

packAcceptedReply:hdr
    |acceptStatus packedReplyData|

    self packAuth:hdr verf.
    acceptStatus := hdr acceptStatus.
    self packEnum:acceptStatus.

    ((acceptStatus == #SUCCESS) or:[acceptStatus == RPCDefinitions SUCCESS]) ifTrue:[
        "/ procedure specific results...
        packedReplyData := hdr replyData.
        packedReplyData size > 0 ifTrue:[
            xdrStream nextPutAll:packedReplyData
        ].
        ^ self.
    ].

    ((acceptStatus == #PROG_MISMATCH) or:[acceptStatus == RPCDefinitions PROG_MISMATCH]) ifTrue:[
        self packUnsignedInt:(hdr lowProgramVersion).   "/ low supported version
        self packUnsignedInt:(hdr highProgramVersion).   "/ high supported version
        ^ self.
    ].

    ((acceptStatus == #PROG_UNAVAIL) or:[acceptStatus == RPCDefinitions PROG_UNAVAIL]) ifTrue:[
        ^ self.
    ].
    ((acceptStatus == #PROC_UNAVAIL) or:[acceptStatus == RPCDefinitions PROC_UNAVAIL]) ifTrue:[
        ^ self.
    ].
    ((acceptStatus == #GARBAGE_ARGS) or:[acceptStatus == RPCDefinitions GARBAGE_ARGS]) ifTrue:[
        ^ self.
    ].

    self error:'bad acceptStatus'.
!

packAuth:auth
    |flavor|

    auth isNil ifTrue:[
        flavor := 0  "/ AUTH_NULL
    ] ifFalse:[
        flavor := auth flavor.
    ].
    self packUnsignedInt:flavor.
    flavor == RPCDefinitions::RPCAuth auth_NULL ifTrue:[
        self packUnsignedInt:0.   "/ zero size stuff
    ] ifFalse:[
        self packOpaque:(auth stuff).
    ]
!

packAuthUnix:authUnix
    |gids|

    self packUnsignedInt:(authUnix stamp).
    self packString:(authUnix machineName).
    self packUnsignedInt:(authUnix uid).
    self packUnsignedInt:(authUnix gid).

    gids := authUnix gids.
    self packUnsignedInt:(gids size).
    gids do:[:eachGid |
        self packUnsignedInt:eachGid
    ]
!

packCallHeader:hdr
    self packUnsignedInt:hdr xid.
    self packEnum:#CALL.
    self packEnum:#RPCVERSION.
    self packUnsignedInt:hdr prog.
    self packUnsignedInt:hdr vers.
    self packUnsignedInt:hdr proc.
    self packAuth:hdr cred.
    self packAuth:hdr verf.
!

packDeniedReply:hdr
    |rejectStatus|

    self packAuth:hdr verf.
    rejectStatus := hdr rejectStatus.
    self packEnum:rejectStatus.

    rejectStatus == #RPC_MISMATCH ifTrue:[
        self packUnsignedInt:2.   "/ low supported version
        self packUnsignedInt:2.   "/ high supported version
        ^ self.
    ].

    rejectStatus == #AUTH_ERROR ifTrue:[
        self packAuthStat.
        ^ self.
    ].

    self error:'bad rejectStatus'
!

packReplyHeader:hdr
    |status|

    self packUnsignedInt:hdr xid.
    self packEnum:#REPLY.
    self packEnum:(status := hdr replyStatus).

    ((status == #MSG_ACCEPTED) or:[status == RPCDefinitions MSG_ACCEPTED]) ifTrue:[
        self packAcceptedReply:hdr.
        ^ self. 
    ].

    ((status == #MSG_DENIED) or:[status == RPCDefinitions MSG_DENIED]) ifTrue:[
        self packDeniedReply:hdr.
        ^ self. 
    ].

    self error:'bad status'
! !

!XDRCoder methodsFor:'queries'!

atEnd
    ^ xdrStream atEnd
! !

!XDRCoder methodsFor:'unpacking'!

unpackArrayUsing:selector
    |a len|

    len := self unpackUnsignedInt.
    a := Array new:len.
    1 to:len do:[:idx |
        a at:idx put:(self perform:selector)
    ].
    ^ a

    "
     |data|

     data :=
        XDRCoder new
            packArray:#('a' 'b' 'c' 'd') using:#packString:;
            contents.

     (XDRCoder from:data) unpackArrayUsing:#unpackString    
    "
!

unpackBool
    |num|

    num := xdrStream nextInt32MSB:true.

    num == 0 ifTrue:[^ false].
    num == 1 ifTrue:[^ true].
    self error:'bad encoding for bool' mayProceed:true.
    "/ if proceeded, anything non-0 is treated as a true
    ^ true.

    "
     |data|

     data :=
        XDRCoder new
            packBool:true;
            contents.

     (XDRCoder from:data) unpackBool  
    "

    "
     |data|

     data :=
        XDRCoder new
            packBool:false;
            contents.

     (XDRCoder from:data) unpackBool  
    "
!

unpackDouble
    "/ self error:'not yet implemented'.
    ^ xdrStream nextIEEEDoubleMSB:true

    "
     |data|

     data :=
        XDRCoder new
            packDouble:1.234;
            contents.

     (XDRCoder from:data) unpackDouble  
    "
!

unpackEnum
    ^ xdrStream nextUnsignedInt32MSB:true "/ self unpackUnsignedInt

    "
     |data|

     data :=
        XDRCoder new
            packEnum:1234;
            contents.

     (XDRCoder from:data) unpackEnum  
    "
!

unpackFloat
    "/ self error:'not yet implemented'.
    ^ xdrStream nextIEEESingleMSB:true

    "
     |data|

     data :=
        XDRCoder new
            packFloat:1.234;
            contents.

     (XDRCoder from:data) unpackFloat  
    "
!

unpackHyper
    ^ xdrStream nextInt64MSB:true.

    "
     |data|

     data :=
        XDRCoder new
            packHyper:16r1234567890123456;
            contents.

     (XDRCoder from:data) unpackHyper hexPrintString   
    "
!

unpackInt
    ^ xdrStream nextInt32MSB:true.

    "
     |data|

     data :=
        XDRCoder new
            packInt:-1234;
            contents.

     (XDRCoder from:data) unpackInt  
    "
!

unpackListUsing:selectorOrBlock
    |tag l|

    l := OrderedCollection new.
    [ (tag := self unpackUnsignedInt) ~~ 0] whileTrue:[
        tag ~~ 1 ifTrue:[ self error:'bad list' ].
        selectorOrBlock isBlock ifTrue:[
            l add:(selectorOrBlock value)
        ] ifFalse:[
            l add:(self perform:selectorOrBlock)
        ]
    ].
    ^ l

    "
     |data|

     data :=
        XDRCoder new
            packList:#('a' 'b' 'c' 'd') using:#packString:;
            contents.

     (XDRCoder from:data) unpackListUsing:#unpackString    
    "
!

unpackListUsing:selectorOrBlock with:aParameter
    |tag l|

    l := OrderedCollection new.
    [ (tag := self unpackUnsignedInt) ~~ 0] whileTrue:[
        tag ~~ 1 ifTrue:[ self error:'bad list' ].
        selectorOrBlock isBlock ifTrue:[
            l add:(selectorOrBlock value:aParameter)
        ] ifFalse:[
            l add:(self perform:selectorOrBlock with:aParameter)
        ]
    ].
    ^ l
!

unpackOpaque
    |l|

    l := self unpackUnsignedInt.
    ^ self unpackOpaqueBytes:l.

    "
     |data|

     data :=
        XDRCoder new
            packString:'hello';
            contents.

     (XDRCoder from:data) unpackOpaque    
    "
!

unpackOpaqueBytes:nBytes
    |s lPadded|

    s := xdrStream next:nBytes.
    lPadded := ((nBytes+3)//4)*4.
    nBytes+1 to:lPadded do:[:pad | xdrStream next].
    ^ s

    "
     |data|

     data :=
        XDRCoder new
            packString:'hello';
            contents.

     (XDRCoder from:data) unpackOpaque    
    "
!

unpackString
    |len       "{Class: SmallInteger}"
     lenPadded "{Class: SmallInteger}"
     nPad      "{Class: SmallInteger}"
     s|

    len := xdrStream nextUnsignedInt32MSB:true. "/ self unpackUnsignedInt.
    s := xdrStream next:len.
    lenPadded := ((len+3)//4)*4.
    nPad := lenPadded - len.
    1 to:nPad do:[:i | xdrStream next].
    ^ s asString

    "
     |data|

     data :=
        XDRCoder new
            packString:'hello';
            contents.

     (XDRCoder from:data) unpackString    
    "
!

unpackUhyper
    ^ xdrStream nextUnsignedInt64MSB:true "/ ^ self unpackUnsignedHyper

    "
     |data|

     data :=
        XDRCoder new
            packUhyper:16r1234567890123456;
            contents.

     (XDRCoder from:data) unpackUhyper hexPrintString   
    "

    "
     |data|

     data :=
        XDRCoder new
            packUhyper:16rFEDCBA9876543210;
            contents.

     (XDRCoder from:data) unpackUhyper hexPrintString   
    "
!

unpackUint
    ^ self unpackUnsignedInt.

    "
     |data|

     data :=
        XDRCoder new
            packUint:1234;
            contents.

     (XDRCoder from:data) unpackUint  
    "
!

unpackUnsignedHyper
    ^ xdrStream nextUnsignedInt64MSB:true.

"/    |hi low|
"/
"/    hi := self unpackUint.
"/    low:= self unpackUint.
"/    ^ (hi bitShift:32) + low.

    "
     |data|

     data :=
        XDRCoder new
            packUnsignedHyper:16r1234567890123456;
            contents.

     (XDRCoder from:data) unpackUnsignedHyper hexPrintString   
    "
!

unpackUnsignedInt
    ^ xdrStream nextUnsignedInt32MSB:true.

    "
     |data|

     data :=
        XDRCoder new
            packUnsignedInt:1234;
            contents.

     (XDRCoder from:data) unpackUnsignedInt  
    "
! !

!XDRCoder methodsFor:'unpacking-rpc packages'!

unpackAuth
    |f s|

    f := self unpackEnum.
    s := self unpackOpaque.

    f == RPCDefinitions::RPCAuth auth_UNIX ifTrue:[
        ^ self unpackAuthUnixFrom:s.
    ].

    ^ RPCDefinitions::RPCAuth new flavor:f stuff:s
!

unpackAuthUnixFrom:opaqueData
    |header gids nGuid decoder|

    decoder := self class from:opaqueData.

    header := RPCDefinitions::RPCAuthUnix new.
    header stuff:opaqueData.

    header stamp:(decoder unpackUnsignedInt).
    header machineName:(decoder unpackString).
    header uid:(decoder unpackUnsignedInt).
    header gid:(decoder unpackUnsignedInt).

    gids := Array new:(nGuid := decoder unpackUnsignedInt).
    1 to:nGuid do:[:idx |
        gids at:idx put:(decoder unpackUnsignedInt)
    ].
    header gids:gids.
    ^ header
!

unpackCallHeader
    |xid rpcVersion type prog vers proc cred verf|

    xid := self unpackUnsignedInt.
    type := self unpackUnsignedInt.
    type ~~ RPCDefinitions CALL ifTrue:[
        RPCError raiseErrorString:'no CALL'.    
        "/ should send a reply here
    ].
    rpcVersion := self unpackUnsignedInt.
    rpcVersion ~~ RPCDefinitions RPCVERSION ifTrue:[
        RPCError raiseErrorString:'bad RPC version'.
        "/ should send a reply here
    ].
    prog := self unpackUnsignedInt.
    vers := self unpackUnsignedInt.
    proc := self unpackUnsignedInt.
    cred := self unpackAuth.
    verf := self unpackAuth.

    ^ RPCDefinitions::RPCCallHeader new 
        xid:xid prog:prog vers:vers proc:proc cred:cred verf:verf
!

unpackReplyHeader
    |xid stat type verf acceptStat stat2 stat3 low high|

    xid := self unpackUnsignedInt.
    type := self unpackUnsignedInt.
    type ~~ RPCDefinitions REPLY ifTrue:[
        RPCError raiseErrorString:'no REPLY'.    
    ].

    stat := self unpackUnsignedInt.
    stat ~~ RPCDefinitions MSG_ACCEPTED ifTrue:[
        stat == RPCDefinitions MSG_DENIED ifTrue:[
            stat2 := self unpackUnsignedInt.
            stat2 == RPCDefinitions RPC_MISMATCH ifTrue:[
                low := self unpackUnsignedInt.
                high := self unpackUnsignedInt.
                RPCError raiseErrorString:'RPC mismatch'
            ].
            stat2 == RPCDefinitions AUTH_ERROR ifTrue:[
                stat3 := self unpackUnsignedInt.
                RPCError raiseErrorString:'AUTH_ERROR'
            ].
            RPCError raiseErrorString:'MSG_DENIED'
        ].
        RPCError raiseErrorString:'neither ACCEPTED nor DENIED'
    ].

    verf := self unpackAuth.
    acceptStat := self unpackUnsignedInt.
    acceptStat ~~ RPCDefinitions SUCCESS ifTrue:[
        acceptStat == RPCDefinitions PROG_UNAVAIL ifTrue:[
            RPCError raiseErrorString:'PROG_UNAVAIL - program not registered'.    
        ].
        acceptStat == RPCDefinitions PROG_MISMATCH ifTrue:[
            low := self unpackUint.
            high := self unpackUint.
            RPCError raiseErrorString:'PROG_MISMATCH - prog version mismatch'.    
        ].
        acceptStat == RPCDefinitions PROC_UNAVAIL ifTrue:[
            RPCError raiseErrorString:'PROC_UNAVAIL - procedure unavailable'.    
        ].
        acceptStat == RPCDefinitions GARBAGE_ARGS ifTrue:[
            RPCError raiseErrorString:'GARBAGE_ARGS - bad arguments'.    
        ].
        RPCError raiseErrorString:'no success'.    
    ].
    ^ RPCDefinitions::RPCReplyHeader new
        xid:xid verf:verf

    "Modified: / 30.1.2002 / 16:14:20 / cg"
! !

!XDRCoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRCoder.st,v 1.24 2018-01-19 22:53:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRCoder.st,v 1.24 2018-01-19 22:53:24 cg Exp $'
! !

