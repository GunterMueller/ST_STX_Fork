"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpSettings
	instanceVariableNames:'settingsDict'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpSettings methodsFor:'accessing'!

bytesAsString
	^self at: #bytesAsString ifAbsentPut: [false]
!

bytesAsString: aBoolean
	^self at: #bytesAsString ifAbsentPut: aBoolean
!

decodeMode
	^self at: #decodeMode ifAbsent: [#strict]
!

decodeMode: aSymbol
	"#strict #unknownAsNil #loose"
	^self at: #decodeMode ifAbsentPut: aSymbol
!

defaultStreamSize
	^self at: #defaultStreamSize ifAbsentPut: [1024]
!

defaultStreamSize: anInteger
	^self at: #defaultStreamSize put: anInteger
!

encodeMode
	^self at: #encodeMode ifAbsent: [#strict]
!

encodeMode: aSymbol
	"#strict #unknownAsNil #loose"
	^self at: #encodeMode ifAbsentPut: aSymbol
!

fastBulkWrite
	^self at: #fastBulkWrite ifAbsentPut: [MpPortableUtil default useFastBulkWrite]
!

fastBulkWrite: aBoolean
	^self at: #fastBulkWrite put: aBoolean
!

formatVersion
	"2008, 2013"
	^self at: #formatVersion ifAbsent: [2013]
!

formatVersion: anInteger
	^self at: #formatVersion ifAbsentPut: anInteger
!

legacyFormat
	^self formatVersion: 2008
!

stringAsBytes
	^self at: #stringAsBytes ifAbsentPut: [false]
!

stringAsBytes: aBoolean
	^self at: #stringAsBytes ifAbsentPut: aBoolean
! !

!MpSettings methodsFor:'accessing-private'!

settingsDict
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]
! !

!MpSettings methodsFor:'actions-dictionary'!

at: key
	^self settingsDict at: key
!

at: key ifAbsent: aBlock
	^self settingsDict at: key ifAbsent: aBlock
!

at: key ifAbsentPut: aBlock
	^self settingsDict at: key ifAbsentPut: aBlock
!

at: key put: value
	^self settingsDict at: key put: value
!

includesKey: key
	^self settingsDict includesKey: key
!

keys
	^self settingsDict keys
! !

!MpSettings methodsFor:'class initialization'!

initialize
	settingsDict := nil
! !

!MpSettings methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: 'a MpSettings('.
	self settingsDict printOn: aStream.
	aStream nextPutAll: ')'.
! !

!MpSettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSettings.st,v 1.2 2018-05-08 11:01:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSettings.st,v 1.2 2018-05-08 11:01:38 cg Exp $'
! !

