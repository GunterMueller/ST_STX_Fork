"{ Package: 'stx:goodies/communication/thrift' }"

SharedPool subclass:#TConstants
	instanceVariableNames:''
	classVariableNames:'TTypeBool TTypeByte TTypeDouble TTypeI16 TTypeI32 TTypeI64
		TTypeList TTypeMap TTypeSet TTypeString TTypeStruct TTypeVoid
		TTypeStop CompactTypeBooleanTrue CompactTypeBooleanFalse
		CompactTypeByte CompactTypeI16 CompactTypeI32 CompactTypeI64
		CompactTypeDouble CompactTypeBinary CompactTypeList
		CompactTypeSet CompactTypeMap CompactTypeStruct'
	poolDictionaries:''
	category:'Net-Communication-Thrift-Misc'
!


!TConstants class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    TTypeBool := TType bool.
    TTypeByte := TType byte.
    TTypeDouble := TType double.
    TTypeI16 := TType i16.
    TTypeI32 := TType i32.
    TTypeI64 := TType i64.
    TTypeList := TType list.
    TTypeMap := TType map.
    TTypeSet := TType set.
    TTypeString := TType string.
    TTypeStruct := TType struct.
    TTypeVoid := TType void.
    TTypeStop := TType stop.

    CompactTypeBooleanTrue := 1.
    CompactTypeBooleanFalse := 2.
    CompactTypeByte := 3.
    CompactTypeI16 := 4.
    CompactTypeI32 := 5.
    CompactTypeI64 := 6.
    CompactTypeDouble := 7.
    CompactTypeBinary := 8.
    CompactTypeList := 9.
    CompactTypeSet := 10.
    CompactTypeMap := 11.
    CompactTypeStruct := 12
! !

!TConstants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TConstants.st,v 1.2 2013-03-20 00:13:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TConstants.st,v 1.2 2013-03-20 00:13:49 cg Exp $'
! !


TConstants initialize!
