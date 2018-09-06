"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

SharedPool subclass:#MpConstantsPool
	instanceVariableNames:''
	classVariableNames:'CODE_array16 CODE_uint16 CODE_uint32 CODE_uint64 CODE_uint8
		CODE_undefinedNil CODE_str8 CODE_str16 CODE_str32 CODE_map32
		CODE_map16 CODE_int8 CODE_array32 CODE_bin16 CODE_bin32 CODE_bin8
		CODE_boolFalse CODE_ext8 CODE_boolTrue CODE_double CODE_ext16
		CODE_ext32 CODE_fixext1 CODE_fixext16 CODE_fixext2 CODE_fixext4
		CODE_fixext8 CODE_float CODE_int16 CODE_int32 CODE_int64'
	poolDictionaries:''
	category:'MessagePack-Core'
!

!MpConstantsPool class methodsFor:'documentation'!

documentation
"
    replaces MPConstants

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!MpConstantsPool class methodsFor:'initialization'!

initialize
    CODE_array16 := 16rDC.
    CODE_array32 := 16rDD.
    CODE_bin16 := 16rC5.
    CODE_bin32 := 16rC6.
    CODE_bin8 := 16rC4.
    CODE_boolFalse := 16rC2.
    CODE_boolTrue := 16rC3.
    CODE_double := 16rCB.
    CODE_ext16 := 16rC8.
    CODE_ext32 := 16rC9.
    CODE_ext8 := 16rC7.
    CODE_fixext1 := 16rD4.
    CODE_fixext16 := 16rD8.
    CODE_fixext2 := 16rD5.
    CODE_fixext4 := 16rD6.
    CODE_fixext8 := 16rD7.
    CODE_float := 16rCA.
    CODE_int16 := 16rD1.
    CODE_int32 := 16rD2.
    CODE_int64 := 16rD3.
    CODE_int8 := 16rD0.
    CODE_map16 := 16rDE.
    CODE_map32 := 16rDF.
    CODE_str16 := 16rDA.
    CODE_str32 := 16rDB.
    CODE_str8 := 16rD9.
    CODE_uint16 := 16rCD.
    CODE_uint32 := 16rCE.
    CODE_uint64 := 16rCF.
    CODE_uint8 := 16rCC.
    CODE_undefinedNil := 16rC0.
! !

!MpConstantsPool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpConstantsPool.st,v 1.3 2018-05-08 11:01:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpConstantsPool.st,v 1.3 2018-05-08 11:01:41 cg Exp $'
! !


MpConstantsPool initialize!
