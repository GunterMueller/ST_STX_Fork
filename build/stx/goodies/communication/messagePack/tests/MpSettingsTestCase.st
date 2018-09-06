"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack/tests' }"

"{ NameSpace: Smalltalk }"

MpTestCase subclass:#MpSettingsTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePackTest-Core'
!


!MpSettingsTestCase methodsFor:'fixtures'!

arrayWithNil
	^ Array with: nil with: 2
!

arrayWithUnknown
	^ Array with: Date today with: 2
!

complexDictionaryAfterConverted
	| dic dicIn|
	dic := Dictionary new.
	dicIn := Dictionary new.
	
	self simpleIdentityDictionary keysAndValuesDo: [:k :v | dicIn at:  (MpPortableUtil default bytesFromString: k) put: (MpPortableUtil default bytesFromString: v)].
	
	dic at: (MpPortableUtil default bytesFromString: #key1) put: (MpPortableUtil default bytesFromString: 'aaa').
	dic at: (MpPortableUtil default bytesFromString: #key2) put: dicIn.
	^dic
!

complexIdentityDictionary
	| dic |
	dic := IdentityDictionary new.
	dic at: #key1 put: 'aaa'.
	dic at: #key2 put: self simpleIdentityDictionary.
	^dic
!

dictionaryWithNil
	| dic |
	dic := Dictionary new.
	dic at: 'key1' put: nil.
	dic at: 'key2' put: 'bbb'.
	^dic
!

dictionaryWithUnknown
	| dic |
	dic := Dictionary new.
	dic at: 'key1' put: Time now.
	dic at: 'key2' put: 'bbb'.
	^dic
!

simpleIdentityDictionary
	| dic |
	dic := IdentityDictionary new.
	dic at: #key1 put: 'aaa'.
	dic at: #key2 put: 'bbb'.
	^dic
!

simpleString
	^'This is a test'
!

simpleStringContainedArray
	^ #('this' 'is' 'a' 'test')
!

stringsArray
	^ self stringSizes collect: [:each | self createStringSized: each]
! !

!MpSettingsTestCase methodsFor:'private'!

createStringSized: size
	^ self newCollection: String sized: size withAll: (Character value: (self atRandom: 255))
!

stringSizes
	^ #(0 1 31 32 65535 65536)
! !

!MpSettingsTestCase methodsFor:'testing'!

testPackStringArrayAsArrayOfBytes
        "self debug: #testPackStringArrayAsArrayOfBytes"
        | bytes |

        "/ why should this raise an error?
        Smalltalk isSmalltalkX ifFalse:[
            self should: [
                self simpleStringContainedArray 
                    messagePacked: [:settings | settings legacyFormat]
            ] raise: MpError.
        ].

        bytes := self simpleStringContainedArray 
                    messagePacked: [:settings | 
                        settings 
                                legacyFormat;
                                stringAsBytes: true
                    ].
        
        self assert: (bytes = ((self simpleStringContainedArray         collect: [:each | each asByteArray]) 
                                                                        messagePacked: [:settings | settings legacyFormat]))
!

testPackStringAsBytes
        "self debug: #testPackStringAsBytes"
        | bytes |

        self 
            should: [
                self simpleString messagePacked:[:se | se legacyFormat]
            ] raise: MpError.

        bytes := self simpleString messagePacked: [:settings | settings legacyFormat; stringAsBytes: true].
        
        self assert: (bytes = (self simpleString asByteArray messagePacked:[:se | se legacyFormat])).
        
        self deny: (bytes = (self simpleString asByteArray messagePacked))
!

testPackUnknownContainedArray
	"self debug: #testPackUnknownContainedArray"
	| bytes |
	self should: [self arrayWithUnknown messagePacked] raise: MpError.
	
	bytes := self arrayWithUnknown messagePacked: [:settings | settings encodeMode: #unknownAsNil].
		
	self assert: (bytes = self arrayWithNil messagePacked)
!

testPackUnknownContainedDictionary
	"self debug: #testPackUnknownContainedDictionary"
	| bytes |
	self should: [self dictionaryWithUnknown messagePacked] raise: MpError.
	
	bytes := self dictionaryWithUnknown messagePacked: [:settings | settings stringAsBytes: true; encodeMode: #unknownAsNil].
		
	self assert: (bytes = (self dictionaryWithNil messagePacked: [:settings | settings stringAsBytes: true]))
!

testPackUnpackComplexIdentityDictionary
        "self debug: #testPackUnpackComplexIdentityDictionary"
        | bytes convertedDic unpacked1 unpacked2 |

        self should: [self complexIdentityDictionary messagePacked] raise: MpError.
        
        bytes := self complexIdentityDictionary messagePacked: [:se | se legacyFormat; stringAsBytes: true; encodeMode: #loose].
        
        convertedDic := self complexDictionaryAfterConverted.
        
        unpacked1 := Object fromMessagePack: bytes setting: [:se | se legacyFormat; bytesAsString: true].
        unpacked2 := Object fromMessagePack: (convertedDic messagePacked: [:se | se legacyFormat]) setting: [:se | se legacyFormat; bytesAsString: true].
        
        self should: [self collectionEquals: unpacked1 with: unpacked2]
!

testPackUnpackSimpleIdentityDictionary
	"self debug: #testPackUnpackSimpleIdentityDictionary"
	| bytes convertedDic unpacked1 unpacked2 |
	self should: [self simpleIdentityDictionary messagePacked] raise: MpError.
	
	bytes := self simpleIdentityDictionary messagePacked: [:se | se legacyFormat; stringAsBytes: true; encodeMode: #loose].
	
	convertedDic := Dictionary new.
	self simpleIdentityDictionary keysAndValuesDo: [:k :v | convertedDic at:  (MpPortableUtil default bytesFromString: k) put: (MpPortableUtil default bytesFromString: v)].
	
	unpacked1 := Object fromMessagePack: bytes setting: [:se | se legacyFormat; bytesAsString: true].
	unpacked2 := Object fromMessagePack: (convertedDic messagePacked: [:se | se legacyFormat] ) setting: [:se | se legacyFormat; bytesAsString: true].
	
	self should: [self collectionEquals: unpacked1 with: unpacked2]
			
		
!

testPackUnpackStrings
	"self debug: #testPackUnpackStrings"
	self stringsArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:se | se stringAsBytes: true].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked asString with: each]
	]
!

testUnpackBytesAsString
	"self debug: #testUnpackBytesAsString"
	| bytes unpackedAsByteArrays unpacked  |
	bytes := self simpleStringContainedArray messagePacked: [:se | se legacyFormat; stringAsBytes: true].
	unpackedAsByteArrays := Object fromMessagePack: bytes setting: [:se | se legacyFormat].
	self assert: (unpackedAsByteArrays = (self simpleStringContainedArray collect: [:each | each asByteArray])).
	
	unpacked := Object fromMessagePack: bytes setting: [:se | se legacyFormat; bytesAsString: true].
	self assert: (unpacked = self simpleStringContainedArray)
			
		
! !

!MpSettingsTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/tests/MpSettingsTestCase.st,v 1.4 2018-05-08 16:29:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/tests/MpSettingsTestCase.st,v 1.4 2018-05-08 16:29:46 cg Exp $'
! !

