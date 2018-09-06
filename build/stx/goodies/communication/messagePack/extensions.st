"{ Package: 'stx:goodies/communication/messagePack' }"!

!Behavior methodsFor:'*MessagePack-Core-packing'!

fromMessagePack: bytes
        ^ MpDecoder decode: bytes
! !

!Behavior methodsFor:'*MessagePack-Core-packing'!

fromMessagePack: bytes setting: settingBlock
        ^ MpDecoder decode: bytes setting: settingBlock
! !

!Object methodsFor:'*MessagePack-Core-converting'!

asMpConverted
	"Override"
	"Only called if you select #loose encodeMode"
	^self asMpMap
! !

!Object methodsFor:'*MessagePack-Core-converting'!

asMpMap
	"Override"
	"Only called if you select #loose encodeMode"
	^Dictionary new
! !

!Object methodsFor:'*MessagePack-Core-packing'!

messagePacked
	^ MpEncoder encode: self
! !

!Object methodsFor:'*MessagePack-Core-packing'!

messagePacked: settingBlock
	^ MpEncoder encode: self setting: settingBlock
! !

!Object methodsFor:'*MessagePack-Core-optimization'!

mpWriteSelector
	^nil
! !

!stx_goodies_communication_messagePack class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/extensions.st,v 1.2 2018-05-08 11:02:55 cg Exp $'
! !
