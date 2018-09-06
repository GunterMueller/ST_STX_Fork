"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TProtocol
	instanceVariableNames:'transport'
	classVariableNames:''
	poolDictionaries:'TConstants'
	category:'Net-Communication-Thrift-Protocol'
!


!TProtocol class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!TProtocol methodsFor:'as yet unclassified'!

transport
	^ transport
!

transport: aTransport
	transport := aTransport
! !

!TProtocol methodsFor:'initialize & release'!

close
    transport notNil ifTrue:[
        transport close.
        transport := nil.
    ]
!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ transport := nil.

    "/ super initialize.   -- commented since inherited method does nothing
! !

!TProtocol methodsFor:'reading'!

readBool
    self subclassResponsibility.
!

readByte
    self subclassResponsibility.
!

readDouble
    self subclassResponsibility.
!

readFieldBegin
    self subclassResponsibility.
!

readFieldEnd
!

readI16
    self subclassResponsibility.
!

readI32
    self subclassResponsibility.
!

readI64
    self subclassResponsibility.
!

readListBegin
    self subclassResponsibility.
!

readListEnd
!

readMapBegin
    self subclassResponsibility.
!

readMapEnd
!

readMessageBegin
    self subclassResponsibility.
!

readMessageEnd
!

readSetBegin
    self subclassResponsibility.
!

readSetEnd
!

readSimpleType: aType
        aType = TTypeBool ifTrue: [^ self readBool].
        aType = TTypeByte ifTrue: [^ self readByte].
        aType = TTypeDouble ifTrue: [^ self readDouble].
        aType = TTypeI16 ifTrue: [^ self readI16].
        aType = TTypeI32 ifTrue: [^ self readI32].
        aType = TTypeI64 ifTrue: [^ self readI64].
        aType = TTypeList ifTrue: [^ self readBool].
        self error:'unsupported type'
!

readString
    self subclassResponsibility.
!

readStructBegin
    self subclassResponsibility.
!

readStructEnd
!

skip: aType
        aType = TTypeStop ifTrue: [^ self].
        aType = TTypeBool ifTrue: [^ self readBool].
        aType = TTypeByte ifTrue: [^ self readByte].
        aType = TTypeI16 ifTrue: [^ self readI16].
        aType = TTypeI32 ifTrue: [^ self readI32].
        aType = TTypeI64 ifTrue: [^ self readI64].
        aType = TTypeString ifTrue: [^ self readString].
        aType = TTypeDouble ifTrue: [^ self readDouble].
        aType = TTypeStruct ifTrue:
                [| field |
                self readStructBegin.
                [(field := self readFieldBegin) type = TType stop] whileFalse:
                        [self skip: field type. self readFieldEnd].
                ^ self readStructEnd].
        aType = TTypeMap ifTrue:
                [| map |
                map := self readMapBegin.
                map size timesRepeat: [self skip: map keyType. self skip: map valueType].
                ^ self readMapEnd].
        aType = TTypeList ifTrue:
                [| list |
                list := self readListBegin.
                list size timesRepeat: [self skip: list elemType].
                ^ self readListEnd].
        aType = TTypeSet ifTrue:
                [| set |
                set := self readSetBegin.
                set size timesRepeat: [self skip: set elemType].
                ^ self readSetEnd].

        self error: 'Unknown type'
! !

!TProtocol methodsFor:'writing'!

writeBool: aBool
    self subclassResponsibility.
!

writeByte: aByte
    self subclassResponsibility.
!

writeDouble: aFloat
    self subclassResponsibility.
!

writeFieldBegin: aField
    self subclassResponsibility.
!

writeFieldEnd
!

writeFieldStop
    self subclassResponsibility.
!

writeI16: i16
    self subclassResponsibility.
!

writeI32: i32
    self subclassResponsibility.
!

writeI64: i64
    self subclassResponsibility.
!

writeListBegin: aList
    self subclassResponsibility.
!

writeListEnd
!

writeMapBegin: aMap
    self subclassResponsibility.
!

writeMapEnd
!

writeMessageBegin: msg
    self subclassResponsibility.
!

writeMessageEnd
!

writeSetBegin: aSet
    self subclassResponsibility.
!

writeSetEnd
!

writeString: aString
    self subclassResponsibility.
!

writeStructBegin: aStruct
    self subclassResponsibility.
!

writeStructEnd
! !

!TProtocol class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TProtocol.st,v 1.6 2013-03-20 16:02:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TProtocol.st,v 1.6 2013-03-20 16:02:39 cg Exp $'
! !

