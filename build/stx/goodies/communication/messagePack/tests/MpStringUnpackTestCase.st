'From Smalltalk/X, Version:7.1.0.0 on 07-05-2018 at 10:00:58 PM'                !

"{ Package: 'stx:goodies/communication/messagePack/tests' }"

"{ NameSpace: Smalltalk }"

MpTestCase subclass:#MpStringUnpackTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'MpConstantsPool'
	category:'MessagePackTest-Core'
!

!MpStringUnpackTestCase class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!MpStringUnpackTestCase methodsFor:'private'!

encodeRandomBin16: size
	| bytes encoded |
	bytes :=  MpPackUnpackTestCase new createRawBytesSized: size.
	encoded := bytes messagePacked at: 1 put: MpConstants bin16; yourself.
	^{bytes. encoded}
!

encodeRandomBin32: size
	| bytes encoded |
	bytes :=  MpPackUnpackTestCase new createRawBytesSized: size.
	encoded := bytes messagePacked at: 1 put: MpConstants bin32; yourself.
	^{bytes. encoded}
!

encodeRandomBin8: size
	| bytes encoded |
	bytes :=  MpPackUnpackTestCase new createRawBytesSized: size.
	encoded := (ByteArray with: MpConstants bin8 with: size), bytes.
	^{bytes. encoded}
!

encodeString8: aString
	| byteStream |
	byteStream := WriteStream with: (ByteArray with: MpConstants str8 with: aString size).
	byteStream nextPutAll: aString asByteArray.
	^ byteStream contents
	
! !

!MpStringUnpackTestCase methodsFor:'testing'!

testUnpackBinFamilyBytes
	"self debug: #testUnpackBinFamilyBytes"
	| arr bytes1 encoded1 bytes2 encoded2 bytes3 encoded3 |
	arr := self encodeRandomBin8: 130.
	bytes1 := arr first.
	encoded1 := arr second. 
	self assert: (bytes1 = (MpMessagePack unpack: encoded1)).
	arr := self encodeRandomBin16: 300.
	bytes2 := arr first.
	encoded2 := arr second. 
	self assert: (bytes2 = (MpMessagePack unpack: encoded2)).
	arr := self encodeRandomBin32: 67000.
	bytes3 := arr first.
	encoded3 := arr second. 
	self assert: (bytes3 = (MpMessagePack unpack: encoded3))
	
	
!

testUnpackString8
	"self debug: #testUnpackString8"
	| str1 data1 data2 str2 |
	str1 := 'hi'.
	data1 := self encodeString8: str1.
	"self assert: [(MpMessagePack unpack: data1) = str1]." 
	self assert: ((Object fromMessagePack: data1 setting: [:se | se formatVersion: 2013]) = str1). "2013 would be default. It is temporary"
	
	str2 := 'Str format family stores an byte array in 1, 2, 3, or 5 bytes of extra bytes in addition to the size of the byte array'.
	data2 := self encodeString8: str2.
	"self assert: [(MpMessagePack unpack: data2) = str2]"
	self assert: ((Object fromMessagePack: data2 setting: [:se | se formatVersion: 2013]) = str2). "2013 would be default. It is temporary"
	
! !

