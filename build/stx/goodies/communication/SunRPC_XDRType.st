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
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Object subclass:#XDRType
	instanceVariableNames:'name'
	classVariableNames:'AccessErrorSignal BadEnumValueErrorSignal IndexBoundsErrorSignal
		BadMemberAccessErrorSignal ElementOutOfBoundsSignal
		ReturnBadEnumsAsNumeric'
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

XDRType subclass:#ArrayType
	instanceVariableNames:'dimension maxSize elementType'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#ScalarType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ScalarType subclass:#IntegerType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#CompoundType
	instanceVariableNames:'fields cachedSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ScalarType subclass:#DoubleType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

Object subclass:#EnumItem
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ScalarType subclass:#EnumType
	instanceVariableNames:'enumValues'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

Object subclass:#Field
	instanceVariableNames:'name type'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ScalarType subclass:#FloatType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntegerType subclass:#HyperType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntegerType subclass:#IntType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntegerType subclass:#CharType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntegerType subclass:#LongType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#OpaqueType
	instanceVariableNames:'dimension maxSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#OptionalType
	instanceVariableNames:'type'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ScalarType subclass:#BooleanType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntegerType subclass:#ShortType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#StringType
	instanceVariableNames:'dimension maxSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::CompoundType subclass:#StructType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#TypedefType
	instanceVariableNames:'type'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::Field subclass:#UnionField
	instanceVariableNames:'discriminantValue'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::CompoundType subclass:#UnionType
	instanceVariableNames:'discriminant defaultField'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#UnknownType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::CharType subclass:#UnsignedCharType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::HyperType subclass:#UnsignedHyperType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::IntType subclass:#UnsignedIntType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::LongType subclass:#UnsignedLongType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType::ShortType subclass:#UnsignedShortType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

XDRType subclass:#VoidType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XDRType
!

!XDRType class methodsFor:'documentation'!

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
    an XDRType represents a type of some XDR-datum.

    [Author:]
        Claus Gittinger

    [see also:]
        XDRType XDRDatum XDRParser
        IDLType IDLDatum IDLParser
        CType
"
! !

!XDRType class methodsFor:'Signal constants'!

accessErrorSignal
    ^ AccessErrorSignal

    "Created: / 22.12.2001 / 00:05:31 / cg"
!

badEnumValueErrorSignal
    ^ BadEnumValueErrorSignal

    "Created: / 22.12.2001 / 00:05:31 / cg"
!

badMemberAccessErrorSignal
    ^ BadMemberAccessErrorSignal

    "Created: / 22.12.2001 / 00:05:31 / cg"
!

elementOutOfBoundsSignal
    ^ ElementOutOfBoundsSignal

    "Created: / 22.12.2001 / 00:05:31 / cg"
!

indexBoundsErrorSignal
    ^ IndexBoundsErrorSignal

    "Created: / 22.12.2001 / 00:05:31 / cg"
! !

!XDRType class methodsFor:'class access'!

arrayType
    ^ ArrayType

    "Created: / 22.12.2001 / 00:05:31 / cg"
    "Modified: / 22.12.2001 / 00:13:28 / cg"
!

booleanType
    ^ BooleanType 
!

charType
    ^ CharType
!

doubleType
    ^ DoubleType

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:21:22 / cg"
!

enumItem
    ^ EnumItem

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:20:53 / cg"
!

enumType
    ^ EnumType

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:21:22 / cg"
!

field
    ^ Field

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:20:34 / cg"
!

floatType
    ^ FloatType

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:20:10 / cg"
!

hyperType
    ^ HyperType

    "Modified: / 22.12.2001 / 00:18:37 / cg"
    "Created: / 22.12.2001 / 02:56:58 / cg"
!

intType
    ^ IntType

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:21:08 / cg"
!

longType
    ^ LongType
!

opaqueType
    ^ OpaqueType
!

optionalType
    ^ OptionalType 
!

shortType
    ^ ShortType
!

stringType
    ^ StringType

    "Created: / 22.12.2001 / 00:05:33 / cg"
    "Modified: / 22.12.2001 / 00:18:23 / cg"
!

structType
    ^ StructType

    "Created: / 22.12.2001 / 00:05:33 / cg"
    "Modified: / 22.12.2001 / 00:18:23 / cg"
!

typedefType
    ^ TypedefType

    "Created: / 22.12.2001 / 00:05:33 / cg"
    "Modified: / 22.12.2001 / 00:18:04 / cg"
!

unionField
    ^ UnionField

    "Created: / 22.12.2001 / 00:05:32 / cg"
    "Modified: / 22.12.2001 / 00:20:34 / cg"
!

unionType
    ^ UnionType

    "Created: / 22.12.2001 / 00:05:33 / cg"
    "Modified: / 22.12.2001 / 00:17:46 / cg"
!

unknownType
    ^ UnknownType

    "Created: / 22.12.2001 / 00:05:33 / cg"
    "Modified: / 22.12.2001 / 00:17:31 / cg"
!

unsignedCharType
    ^ UnsignedCharType
!

unsignedHyperType
    ^ UnsignedHyperType

    "Modified: / 22.12.2001 / 00:15:39 / cg"
    "Created: / 22.12.2001 / 03:47:35 / cg"
!

unsignedIntType
    ^ UnsignedIntType

    "Created: / 22.12.2001 / 00:05:34 / cg"
    "Modified: / 22.12.2001 / 00:16:34 / cg"
!

unsignedLongType
    ^ UnsignedLongType
!

unsignedShortType
    ^ UnsignedShortType
!

voidType
    ^ VoidType

    "Created: / 22.12.2001 / 00:05:34 / cg"
    "Modified: / 22.12.2001 / 00:15:01 / cg"
! !

!XDRType class methodsFor:'class initialization'!

initialize
    AccessErrorSignal isNil ifTrue:[
        AccessErrorSignal := ErrorSignal newSignalMayProceed:true.
        AccessErrorSignal nameClass:self message:#accessErrorSignal.
        AccessErrorSignal notifierString:'bad access'.

        IndexBoundsErrorSignal := AccessErrorSignal newSignalMayProceed:true.
        IndexBoundsErrorSignal nameClass:self message:#indexBoundsErrorSignal.
        IndexBoundsErrorSignal notifierString:'bad array index'.

        ElementOutOfBoundsSignal := AccessErrorSignal newSignalMayProceed:true.
        ElementOutOfBoundsSignal nameClass:self message:#elementOutOfBoundsSignal.
        ElementOutOfBoundsSignal notifierString:'element out of bounds'.

        BadMemberAccessErrorSignal := AccessErrorSignal newSignalMayProceed:true.
        BadMemberAccessErrorSignal nameClass:self message:#badMemberErrorSignal.
        BadMemberAccessErrorSignal notifierString:'bad member'.

        BadEnumValueErrorSignal := AccessErrorSignal newSignalMayProceed:true.
        BadEnumValueErrorSignal nameClass:self message:#badEnumValueErrorSignal.
        BadEnumValueErrorSignal notifierString:'bad enum value'.
    ].

    "
     self initialize
    "

    "Created: / 22.12.2001 / 00:05:34 / cg"
    "Modified: / 23.12.2001 / 12:30:40 / cg"
! !

!XDRType class methodsFor:'defaults'!

returnBadEnumsAsNumeric:aBoolean
    "should be left false during development & debugging;
     can be set to true for end-user-apps.
     (however, the app should be prepared to get numeric enum-field values)"

    ReturnBadEnumsAsNumeric := aBoolean

    "Modified: / 24.10.1998 / 17:39:22 / cg"
    "Created: / 22.12.2001 / 00:05:34 / cg"
!

structAlignment
    ^ 0
!

unionAlignment
    ^ 0
! !

!XDRType methodsFor:'accessing'!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.
! !

!XDRType methodsFor:'accessing-C'!

fieldNamed:fieldName ifAbsent:exceptionValue
    "raise an error for field accesses.
     This is only redefined in StructType."

    ^ BadMemberAccessErrorSignal raiseErrorString:'not a struct/union'

    "Created: / 22.12.2001 / 00:05:25 / cg"
    "Modified: / 22.12.2001 / 01:16:57 / cg"
!

fields
    "return my fields - this returns an empty collection here;
     redefined in union and struct types"

    ^ #()

    "Created: / 22.12.2001 / 00:05:25 / cg"
!

name
    ^ name ? ''

    "Created: / 22.12.2001 / 00:05:25 / cg"
!

type

    ^self

    "Created: / 22.12.2001 / 00:05:26 / cg"
! !

!XDRType methodsFor:'inspecting'!

inspectorClass
    "return the class of an appropriate inspector.
     ST/X has a specialized IDLDatumInspectorView for that"

    ^ IDLDatumInspectorView ? InspectorView

    "Created: / 22.12.2001 / 00:05:27 / cg"
    "Modified: / 22.12.2001 / 01:15:32 / cg"
! !

!XDRType methodsFor:'printing'!

displayString
    "return a nice printed representation"

    ^ self class name , '(' , (self idlString:nil indent:0) , ')'

    "Created: / 22.12.2001 / 00:05:27 / cg"
    "Modified: / 22.12.2001 / 01:14:37 / cg"
!

idlString:datum indent:indent
    "helper for displayString."

    ^ ''

    "Modified: / 15.5.1998 / 20:17:07 / cg"
    "Created: / 22.12.2001 / 01:14:58 / cg"
!

idlString:datum indent:indent fieldName:fieldName
    "helper for displayString."

    ^ (self idlString:datum indent:indent) , ' ' , fieldName

    "Modified: / 17.10.1998 / 15:55:36 / cg"
    "Created: / 22.12.2001 / 01:14:49 / cg"
!

idlString:datum offset:o indent:indent
    "helper for displayString."

    ^ ''

    "Modified: / 15.5.1998 / 20:17:07 / cg"
    "Created: / 22.12.2001 / 01:14:58 / cg"
!

idlString:datum offset:o indent:indent fieldName:fieldName
    "helper for displayString."

    ^ (self idlString:datum offset:o indent:indent) , ' ' , fieldName

    "Modified: / 17.10.1998 / 15:55:36 / cg"
    "Created: / 22.12.2001 / 01:14:49 / cg"
!

methodAgumentNameForTemplate:template
    "return a string usable as argument name giving a type hint;
     for example, string types should generate <templ>String"

    |nm s|

    nm := self idlString:'' indent:0.
    s := (nm asCollectionOfWords collect:[:each | each asUppercaseFirst]) asStringWith:''.
    ^ template,s

    "
     SunRPC::XDRType::LongType basicNew
        methodAgumentNameForTemplate:'arg1'
    "
!

smalltalkDefaultValueString
    "return a string usable as default value for this type.
     for example, integer types should return '0' here"

    ^ 'nil'
! !

!XDRType methodsFor:'queries'!

defaultValue
    ^ nil
!

enumValues
    "raise an error here;
     redefined in enum types"

    self error:'not an enum type'

    "Created: / 22.12.2001 / 00:05:28 / cg"
!

hasEnumValues
    "true if my type is a kind of enum type"

    ^ false
!

isIndexed
    "return true if this Type has fields accessible via an index (i.e. is an array)"

    ^ false

    "Created: / 22.12.2001 / 00:05:29 / cg"
    "Modified: / 22.12.2001 / 01:13:16 / cg"
!

isInteger
    "return true if this Type represents an integer 
     (i.e. signed, unsigned integer, short or long)"

    ^ false

    "Created: / 22.12.2001 / 01:11:12 / cg"
!

isOptional
    "return true if this Type represents an optional type"

    ^ false
!

isXDRArray
    "return true if this Type represents an Array"

    ^ false

    "Modified: / 15.5.1998 / 20:18:00 / cg"
    "Created: / 22.12.2001 / 01:09:13 / cg"
!

isXDRBoolean
    "return true if this Type represents an Boolean"

    ^ false
!

isXDRChar
    "return true if this Type represents a char type 
     (i.e. signed, unsigned integer)"

    ^ false
!

isXDRCompound
    "return true if this Type represents either a struct or a union"

    ^ false

    "Modified: / 15.5.1998 / 20:18:52 / cg"
    "Created: / 22.12.2001 / 01:10:02 / cg"
!

isXDRDouble
    "return true if this Type represents a double"

    ^ false

    "Created: / 22.12.2001 / 01:10:22 / cg"
!

isXDREnum
    "return true if this Type represents an enum"

    ^ false

    "Created: / 22.12.2001 / 01:10:43 / cg"
!

isXDRFloat
    "return true if this Type represents a float"

    ^ false

    "Created: / 22.12.2001 / 01:10:57 / cg"
!

isXDRHyper
    "return true if this Type represents a hyper size number 
     (i.e. an int64 or unsigned64 )"

    ^ false

    "Modified: / 24.10.1998 / 16:39:30 / cg"
    "Created: / 22.12.2001 / 01:11:31 / cg"
!

isXDRInteger
    "return true if this Type represents an integer type 
     (i.e. signed, unsigned integer)"

    ^ false

    "Modified: / 24.10.1998 / 16:39:30 / cg"
    "Created: / 22.12.2001 / 01:11:31 / cg"
!

isXDRLong
    "return true if this Type represents a long type 
     (i.e. signed, unsigned integer)"

    ^ false
!

isXDRNumber
    "return true if this Type represents a number 
     (i.e. signed, unsigned integer, float or double)"

    ^ false

    "Modified: / 24.10.1998 / 16:39:30 / cg"
    "Created: / 22.12.2001 / 01:11:31 / cg"
!

isXDROpaque
    "return true if this Type represents an opaque"

    ^ false

    "Created: / 22.12.2001 / 01:10:43 / cg"
!

isXDRScalar
    "return true if this Type represents a scalar (non composite type).
     I.e. its one of char, int, float or short"

    ^ false

    "Modified: / 15.5.1998 / 20:19:35 / cg"
    "Created: / 22.12.2001 / 01:12:01 / cg"
!

isXDRShort
    "return true if this Type represents a short type 
     (i.e. signed, unsigned integer)"

    ^ false
!

isXDRString
    "return true if this Type represents an array of chars (or unsigned chars)"

    ^ false

    "Modified: / 15.5.1998 / 20:18:21 / cg"
    "Created: / 22.12.2001 / 01:12:18 / cg"
!

isXDRStruct
    "return true if this Type represents a struct"

    ^ false

    "Modified: / 15.5.1998 / 20:19:45 / cg"
    "Created: / 22.12.2001 / 01:12:30 / cg"
!

isXDRTypeDef
    "return true if this Type is a typedef"

    ^ false

    "Modified: / 15.5.1998 / 20:20:22 / cg"
    "Created: / 22.12.2001 / 01:12:41 / cg"
!

isXDRUnion
    "return true if this Type represents a union"

    ^ false

    "Modified: / 15.5.1998 / 20:19:52 / cg"
    "Created: / 22.12.2001 / 01:12:52 / cg"
!

isXDRUnsigned
    "return true if this Type represents an unsigned integer scalar type."

    ^ false

    "Modified: / 24.10.1998 / 16:39:46 / cg"
    "Created: / 22.12.2001 / 01:13:02 / cg"
!

isXDRVoid
    "return true if this Type represents a void type"

    ^ false
!

numericEnumValues
    "raise an error here;
     redefined in enum types"

    self error:'not an enum type'

    "Created: / 22.12.2001 / 00:05:30 / cg"
!

sameTypeAs:aType
    "return true if this Type is compatible with aType"

    ^ self == aType

    "Created: / 22.12.2001 / 00:05:30 / cg"
    "Modified: / 22.12.2001 / 01:13:24 / cg"
!

symbolicEnumValues
    "raise an error here;
     redefined in enum types"

    self error:'not an enum type'

    "Created: / 22.12.2001 / 00:05:30 / cg"
!

xdrType
    "return my actual type; that's myself here,
     but redefined in typedef, to return the real type 
     (which will avoid indirections in later accesses)"

    ^ self

    "Modified: / 18-05-1998 / 13:59:48 / cg"
    "Created: / 22-12-2001 / 01:13:51 / cg"
    "Modified (comment): / 12-06-2017 / 21:01:25 / cg"
! !

!XDRType methodsFor:'queries-C'!

alignment
    "return the Types (wire) alignment in bytes"

    ^ self sizeof
!

memberNames
    ^ #()

    "Created: / 22.12.2001 / 00:05:30 / cg"
!

sizeof
    "return the Types (wire) size in bytes"

    ^ self subclassResponsibility
! !

!XDRType::ArrayType methodsFor:'accessing'!

dimension

   ^dimension

    "Created: / 22.12.2001 / 00:06:04 / cg"
!

dimension:dim elementType:eltype
   dimension := dim.
   elementType := eltype

    "Created: / 22.12.2001 / 00:06:04 / cg"
!

dimensions

   ^ Array with:dimension

    "Created: / 22.12.2001 / 00:06:04 / cg"
!

elementType
    ^ elementType

    "Created: / 22.12.2001 / 00:06:04 / cg"
!

elementType:aType
    elementType := aType

    "Created: / 22.12.2001 / 00:06:04 / cg"
!

maxSize
    "return the value of the instance variable 'maxSize' (automatically generated)"

    ^ maxSize
!

maxSize:something
    "set the value of the instance variable 'maxSize' (automatically generated)"

    maxSize := something.
!

numDimensions

   ^1

    "Created: / 22.12.2001 / 00:06:04 / cg"
! !

!XDRType::ArrayType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeArrayWithType:self

    "Created: / 30.12.2001 / 23:48:35 / cg"
    "Modified: / 30.12.2001 / 23:48:51 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeArray:value type:self with:aParameter

    "Modified: / 30.12.2001 / 23:49:01 / cg"
! !

!XDRType::ArrayType methodsFor:'printing'!

idlString:datum indent:indent
    ^ (elementType idlString:datum indent:indent) , '[' , dimension printString , ']'

    "Created: / 22.12.2001 / 00:06:07 / cg"
!

idlString:datum indent:indent fieldName:fieldName
    ^ (elementType idlString:datum indent:indent) , ' ' , fieldName , '[' , dimension printString , ']'

    "Created: / 22.12.2001 / 00:06:07 / cg"
! !

!XDRType::ArrayType methodsFor:'queries'!

isIndexed
    ^ true

    "Created: / 22.12.2001 / 00:06:07 / cg"
!

isXDRArray
    ^ true

    "Created: / 22.12.2001 / 02:54:53 / cg"
! !

!XDRType::ScalarType methodsFor:'queries'!

isIDLScalar
    ^ true

    "Created: / 22.12.2001 / 02:49:11 / cg"
! !

!XDRType::IntegerType methodsFor:'queries'!

defaultValue
    ^ 0
!

isXDRInteger
    "return true if this Type represents a integer 
     (i.e. signed, unsigned integer, short or long)"

    ^ true

    "Created: / 22.12.2001 / 02:41:58 / cg"
!

isXDRNumber

    ^true

    "Created: / 22.12.2001 / 02:42:27 / cg"
!

smalltalkDefaultValueString
    "return a string usable as default value for this type.
     for example, integer types should return '0' here"

    ^ '0'
! !

!XDRType::CompoundType methodsFor:'accessing'!

fieldNamed:aFieldName ifAbsent:exceptionValue
    "return a fields type"

    ^ fields detect:[:aField | aField name = aFieldName] ifNone:exceptionValue

    "Created: / 22.12.2001 / 00:05:43 / cg"
!

fields
    "return the value of the instance variable 'fields' (automatically generated)"

    ^ fields

    "Created: / 22.12.2001 / 00:05:43 / cg"
!

fields:something
    "set the value of the instance variable 'fields' (automatically generated)"

    fields := something.

    "Created: / 22.12.2001 / 00:05:43 / cg"
! !

!XDRType::CompoundType methodsFor:'printing'!

idlString:datum indent:indent
    |s|

    self isXDRStruct ifTrue:[
        s := 'struct '
    ] ifFalse:[
        s := 'union '
    ].
    s := s , (name ? '???') , ' {'.

"/    fields notNil ifTrue:[
"/        s := s , Character cr asString.
"/        fields do:[:f |
"/            |fieldType fieldName fieldOffs sF i valString val|
"/
"/            fieldType := f type.
"/            fieldName := f name.
"/
"/            sF := (String new:indent+4).
"/            sF := sF ,  (fieldType idlString:datum indent:indent+4 fieldName:fieldName).
"/            sF := sF ,  (fieldType idlString:datum indent:indent+4 fieldName:fieldName).
"/            i := sF lastIndexOf:Character cr.
"/            i ~~ 0 ifTrue:[
"/                sF := (sF copyTo:i) , ((sF copyFrom:i+1) paddedTo:44).
"/            ] ifFalse:[
"/                sF := sF paddedTo:44.
"/            ].
"/            s := s , sF , Character cr asString.
"/        ].
"/        s := s , (String new:indent).
"/    ].
    s := s , '}'.
    ^ s

    "Modified: / 11.3.1999 / 22:25:36 / cg"
    "Created: / 22.12.2001 / 00:05:44 / cg"
! !

!XDRType::CompoundType methodsFor:'queries'!

isIDLCompound
    ^ true

    "Created: / 22.12.2001 / 02:54:05 / cg"
!

isXDRCompound
    ^ true

    "Created: / 22.12.2001 / 02:54:05 / cg"
!

memberNames
    ^ fields collect:[:f | f name]

    "Created: / 22.12.2001 / 00:05:44 / cg"
! !

!XDRType::DoubleType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeDouble

    "Created: / 31.12.2001 / 02:39:32 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeDouble:value with:aParameter

    "Created: / 30.12.2001 / 23:50:42 / cg"
! !

!XDRType::DoubleType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'double'

    "Created: / 22.12.2001 / 00:06:08 / cg"
!

smalltalkDefaultValueString
    "return a string usable as default value for this type.
     for example, integer types should return '0' here"

    ^ '0.0'
! !

!XDRType::DoubleType methodsFor:'queries'!

defaultValue
    ^ 0.0
!

isXDRDouble
    "return true if this IDLType represents an IDL-double"

    ^ true

    "Created: / 22.12.2001 / 02:53:54 / cg"
!

isXDRNumber

    ^true

    "Created: / 22.12.2001 / 02:52:54 / cg"
! !

!XDRType::EnumItem methodsFor:'accessing'!

enumValue
    "return the value of the instance variable 'value' (automatically generated)"

    ^ value

    "Created: / 22.12.2001 / 00:05:59 / cg"
!

enumValue:something
    "set the value of the instance variable 'value' (automatically generated)"

    value := something.

    "Created: / 22.12.2001 / 00:05:59 / cg"
!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name

    "Created: / 22.12.2001 / 00:05:59 / cg"
!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.

    "Created: / 22.12.2001 / 00:05:59 / cg"
!

name:enumIdSymbol enumValue:val
    name := enumIdSymbol.
    value := val

    "Created: / 22.12.2001 / 00:05:59 / cg"
! !

!XDRType::EnumType methodsFor:'accessing'!

fields:list
    |dict v nextValue|

    "/ first, fill any missing values.
    nextValue := 0.
    list do:[:item |
        (v := item enumValue) notNil ifTrue:[
            nextValue := v
        ] ifFalse:[
            item enumValue:nextValue.
        ].
        nextValue := nextValue + 1
    ].
    "/ create mapping from number to symbol and symbol to number
    dict := IdentityDictionary new.
    list do:[:item |
        dict at:item enumValue put:item name.
        dict at:item name put:item enumValue.
    ].
    enumValues := dict

    "Modified: / 18.5.1998 / 16:06:28 / cg"
    "Created: / 22.12.2001 / 00:05:54 / cg"
! !

!XDRType::EnumType methodsFor:'encoding & decoding'!

decodeFrom:decoder 
    ^ decoder decodeEnumWithType:self

    "Created: / 30.1.2002 / 14:59:16 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeEnum:value type:self with:aParameter
! !

!XDRType::EnumType methodsFor:'queries'!

enumValues
    ^ enumValues

    "Created: / 22.12.2001 / 00:05:54 / cg"
!

hasEnumValues
    "true if my type is a kind of enum type"

    ^ true
!

isXDREnum

    ^true

    "Created: / 22.12.2001 / 02:53:45 / cg"
!

numericEnumValues
    "return a collection of all possible numeric enum values"

    ^ enumValues keys select:[:el| el isSymbol not]

    "Modified: / 24.10.1998 / 17:40:39 / cg"
    "Created: / 22.12.2001 / 00:05:55 / cg"
!

numericValueFor:aSymbolOrInteger
    "return the numeric value corresponding to a given symbolic value"

    aSymbolOrInteger isSymbol ifFalse:[^ aSymbolOrInteger].
    ^ enumValues 
        at:aSymbolOrInteger
        ifAbsent:[BadEnumValueErrorSignal 
                        raiseWith:aSymbolOrInteger 
                        errorString:'unrepresentable enumvalue']

    "Modified: / 24-10-1998 / 17:43:27 / cg"
    "Created: / 22-12-2001 / 00:05:55 / cg"
    "Modified (format): / 21-07-2017 / 12:56:30 / cg"
!

symbolicEnumValues
    "return a collection of all possible symbolic enum values"

    ^ (enumValues keys select:[:el| el isSymbol] as:OrderedCollection)
           sort
"/           sort:[:a :b | (enumValues at:a) < (enumValues at:b)]

    "Modified: / 24.10.1998 / 17:40:52 / cg"
    "Created: / 22.12.2001 / 00:05:55 / cg"
!

symbolicValueFor:aNumericValue
    "return the symbolic value corresponding to a given numeric value"

    aNumericValue isSymbol ifTrue:[^ aNumericValue].
    ^ enumValues 
        at:aNumericValue        
        ifAbsent:[BadEnumValueErrorSignal 
                        raiseWith:aNumericValue errorString:'unrepresentable enumvalue']

    "Modified: / 24.10.1998 / 17:42:31 / cg"
    "Created: / 22.12.2001 / 00:05:55 / cg"
! !

!XDRType::Field methodsFor:'accessing'!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name

    "Created: / 22.12.2001 / 00:05:45 / cg"
!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.

    "Created: / 22.12.2001 / 00:05:45 / cg"
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type

    "Created: / 22.12.2001 / 00:05:45 / cg"
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    self assert:(something isKindOf:XDRType).
    type := something.

    "Created: / 22.12.2001 / 00:05:45 / cg"
! !

!XDRType::Field methodsFor:'printing & storing'!

displayString
    ^ 'Field name=' , (name ? '') , ' type=' , (type displayString)
! !

!XDRType::Field methodsFor:'queries'!

typeName

    ^ type name

    "Created: / 22.12.2001 / 00:05:45 / cg"
! !

!XDRType::FloatType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeFloat

    "Created: / 31.12.2001 / 02:39:21 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeFloat:value with:aParameter

    "Created: / 30.12.2001 / 23:50:57 / cg"
! !

!XDRType::FloatType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'float'

    "Created: / 22.12.2001 / 00:05:37 / cg"
!

smalltalkDefaultValueString
    "return a string usable as default value for this type.
     for example, integer types should return '0' here"

    ^ '0.0'
! !

!XDRType::FloatType methodsFor:'queries'!

defaultValue
    ^ 0.0
!

isXDRFloat
    "return true if this IDLType represents an IDL-float"

    ^ true

    "Created: / 22.12.2001 / 02:53:38 / cg"
!

isXDRNumber

    ^true

    "Created: / 22.12.2001 / 02:52:46 / cg"
! !

!XDRType::HyperType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeHyper

    "Created: / 31.12.2001 / 02:39:03 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeHyper:value with:aParameter

    "Created: / 30.12.2001 / 23:51:13 / cg"
! !

!XDRType::HyperType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'hyper int'

    "Created: / 22.12.2001 / 02:57:57 / cg"
    "Modified: / 22.12.2001 / 02:58:18 / cg"
! !

!XDRType::HyperType methodsFor:'queries'!

isXDRHyper
    "return true if this Type represents a hyper size number 
     (i.e. an int64 or unsigned64 )"

    ^ true
! !

!XDRType::IntType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeInt
!

encode:value on:encoder with:aParameter
    encoder encodeInt:value with:aParameter
! !

!XDRType::IntType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'int'

    "Modified: / 15.5.1998 / 18:29:47 / cg"
    "Created: / 22.12.2001 / 00:06:11 / cg"
! !

!XDRType::CharType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeChar
!

encode:value on:encoder with:aParameter
    encoder encodeChar:value with:aParameter
! !

!XDRType::CharType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'char'

    "Modified: / 15.5.1998 / 18:29:47 / cg"
    "Created: / 22.12.2001 / 00:06:11 / cg"
! !

!XDRType::CharType methodsFor:'queries'!

isXDRChar
    "return true if this Type represents a char size number 
     (i.e. an int8 or unsigned8 )"

    ^ true
! !

!XDRType::LongType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeLong
!

encode:value on:encoder with:aParameter
    encoder encodeLong:value with:aParameter
! !

!XDRType::LongType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'long'

    "Modified: / 15.5.1998 / 18:29:47 / cg"
    "Created: / 22.12.2001 / 00:06:11 / cg"
! !

!XDRType::LongType methodsFor:'queries'!

isXDRLong
    "return true if this Type represents a long size number 
     (i.e. an int32 or unsigned32 )"

    ^ true
! !

!XDRType::OpaqueType methodsFor:'accessing'!

dimension
    "return the value of the instance variable 'dimension' (automatically generated)"

    ^ dimension
!

dimension:something
    "set the value of the instance variable 'dimension' (automatically generated)"

    dimension := something.
!

maxSize
    "return the value of the instance variable 'maxSize' (automatically generated)"

    ^ maxSize
!

maxSize:something
    "set the value of the instance variable 'maxSize' (automatically generated)"

    maxSize := something.
! !

!XDRType::OpaqueType methodsFor:'encoding & decoding'!

decodeFrom:decoder 
   ^ decoder decodeOpaqueWithType:self
!

encode:value on:encoder with:aParameter
    encoder encodeOpaque:value type:self with:aParameter
! !

!XDRType::OpaqueType methodsFor:'queries'!

isXDROpaque
    "return true if this Type represents an opaque"

    ^ true
! !

!XDRType::OptionalType methodsFor:'accessing'!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
! !

!XDRType::OptionalType methodsFor:'delegating'!

fields
    ^ type fields
!

fields:fieldList
    ^ type fields:fieldList
! !

!XDRType::OptionalType methodsFor:'encoding & decoding'!

decodeFrom:decoder 
   ^ decoder decodeOptionalWithType:self

    "Created: / 30.1.2002 / 14:30:09 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeOptional:value type:self with:aParameter
! !

!XDRType::OptionalType methodsFor:'queries'!

isOptional
    "return true if this Type represents an optional type"

    ^ true
!

isXDRStruct
    "return true if this Type represents a struct"

    ^ type isXDRStruct
! !

!XDRType::BooleanType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeBoolean

    "Modified: / 23.12.2001 / 13:23:36 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeBoolean:value with:aParameter

    "Modified: / 23.12.2001 / 13:23:00 / cg"
    "Created: / 30.12.2001 / 23:47:37 / cg"
! !

!XDRType::BooleanType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'boolean'

    "Created: / 23.12.2001 / 12:28:39 / cg"
    "Modified: / 23.12.2001 / 12:28:51 / cg"
!

smalltalkDefaultValueString
    "return a string usable as default value for this type.
     for example, integer types should return '0' here"

    ^ 'false'
! !

!XDRType::BooleanType methodsFor:'queries'!

defaultValue
    ^ false
!

isXDRBoolean
    "return true if this Type represents an Boolean"

    ^ true
! !

!XDRType::ShortType methodsFor:'encoding & decoding'!

decodeFrom:decoder
   ^ decoder decodeShort
!

encode:value on:encoder with:aParameter
    encoder encodeShort:value with:aParameter
! !

!XDRType::ShortType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'short'

    "Modified: / 15.5.1998 / 18:29:47 / cg"
    "Created: / 22.12.2001 / 00:06:11 / cg"
! !

!XDRType::ShortType methodsFor:'queries'!

isXDRShort
    "return true if this Type represents a short size number 
     (i.e. an int16 or unsigned16 )"

    ^ true
! !

!XDRType::StringType methodsFor:'accessing'!

dimension
    "return the value of the instance variable 'dimension' (automatically generated)"

    ^ dimension
!

dimension:something
    "set the value of the instance variable 'dimension' (automatically generated)"

    dimension := something.
!

maxSize
    "return the value of the instance variable 'maxSize' (automatically generated)"

    ^ maxSize
!

maxSize:something
    "set the value of the instance variable 'maxSize' (automatically generated)"

    maxSize := something.
! !

!XDRType::StringType methodsFor:'encoding & decoding'!

decodeFrom:decoder 
   ^ decoder decodeStringWithType:self
!

encode:value on:encoder with:aParameter
    encoder encodeString:value type:self with:aParameter
! !

!XDRType::StringType methodsFor:'queries'!

isXDRString
    ^ true
! !

!XDRType::StructType methodsFor:'encoding & decoding'!

decodeFrom:decoder
    ^ decoder decodeStructWithType:self
!

encode:value on:encoder with:aParameter
    encoder encodeStruct:value type:self with:aParameter
! !

!XDRType::StructType methodsFor:'queries'!

isXDRStruct
    ^ true

    "Created: / 22.12.2001 / 02:48:41 / cg"
! !

!XDRType::TypedefType methodsFor:'accessing'!

fieldNamed:fieldName ifAbsent:exceptionValue
    ^ type fieldNamed:fieldName ifAbsent:exceptionValue

    "Created: / 22.12.2001 / 00:05:48 / cg"
!

fields
    ^ type fields

    "Created: / 22.12.2001 / 00:05:47 / cg"
!

name:nm type:t
    name := nm.
    type := t.

    "Created: / 22.12.2001 / 00:05:47 / cg"
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type

    "Created: / 22.12.2001 / 00:05:47 / cg"
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.

    "Created: / 22.12.2001 / 00:05:47 / cg"
!

typeName

    ^ type name

    "Created: / 22.12.2001 / 00:05:47 / cg"
! !

!XDRType::TypedefType methodsFor:'printing'!

idlString:datum indent:indent
    type isXDRCompound ifTrue:[
        (type name = name) ifTrue:[
            ^ type idlString:datum indent:indent
        ].
        ^  (name ? '???') , '=' , (type idlString:datum indent:indent)
    ].

    ^  (name ? '???') , '=' , (type idlString:datum indent:indent)
"/    ^  (name ? '???') , (type cString:datum offset:o indent:indent)

    "Modified: / 11.3.1999 / 21:44:44 / cg"
    "Modified: / 28.5.1999 / 15:38:10 / stefan"
    "Created: / 22.12.2001 / 00:05:49 / cg"
! !

!XDRType::TypedefType methodsFor:'queries'!

enumValues
    ^ type enumValues

    "Created: / 22.12.2001 / 00:05:49 / cg"
!

isXDRCompound
    ^ type isXDRCompound

    "Modified: / 28.5.1999 / 15:44:57 / stefan"
    "Created: / 22.12.2001 / 02:50:01 / cg"
!

isXDREnum
    ^ type isXDREnum

    "Created: / 22.12.2001 / 02:49:46 / cg"
!

isXDRScalar
    ^ type isXDRScalar

    "Created: / 22.12.2001 / 02:49:03 / cg"
!

isXDRString
    ^ type isXDRString

    "Created: / 22.12.2001 / 02:48:54 / cg"
!

isXDRStruct
    ^ type isXDRStruct

    "Created: / 22.12.2001 / 02:48:28 / cg"
!

isXDRTypeDef
    ^ true

    "Created: / 22.12.2001 / 02:48:08 / cg"
!

isXDRUnion
    ^ type isXDRUnion

    "Created: / 22.12.2001 / 02:47:57 / cg"
!

memberNames
    ^ type memberNames

    "Created: / 22.12.2001 / 00:05:51 / cg"
!

numericEnumValues
    ^ type numericEnumValues

    "Created: / 22.12.2001 / 00:05:51 / cg"
!

numericValueFor:aSymbolOrInteger
    "return the numeric value corresponding to a given symbolic value
     (assuming the typedef'd type is an enum type)"

    ^ type numericValueFor:aSymbolOrInteger

    "Created: / 22-12-2001 / 00:05:51 / cg"
    "Modified (comment): / 21-07-2017 / 12:55:49 / cg"
!

sameTypeAs:aType
    ^ self == aType or:[aType sameTypeAs:type].

"/    aType isCTypeDef ifTrue:[
"/        ^ type sameTypeAs:(aType type)
"/    ].
"/    ^ false

    "Modified: / 14.5.1998 / 15:30:38 / cg"
    "Created: / 22.12.2001 / 00:05:51 / cg"
!

symbolicEnumValues
    ^ type symbolicEnumValues

    "Created: / 22.12.2001 / 00:05:51 / cg"
!

symbolicValueFor:val
    ^ type symbolicValueFor:val

    "Created: / 22.12.2001 / 00:05:51 / cg"
!

xdrType
    "return my actual ctype"

    ^ type xdrType

    "Modified: / 18.5.1998 / 14:00:03 / cg"
    "Created: / 22.12.2001 / 02:51:07 / cg"
! !

!XDRType::UnionField methodsFor:'accessing'!

discriminantValue
    "return the value of the instance variable 'discriminantValue' (automatically generated)"

    ^ discriminantValue
!

discriminantValue:something
    "set the value of the instance variable 'discriminantValue' (automatically generated)"

    discriminantValue := something.
! !

!XDRType::UnionType methodsFor:'accessing'!

defaultField
    "return the value of the instance variable 'defaultField' (automatically generated)"

    ^ defaultField
!

defaultField:something
    "set the value of the instance variable 'defaultField' (automatically generated)"

    defaultField := something.
!

discriminant
    "return the value of the instance variable 'discriminant' (automatically generated)"

    ^ discriminant
!

discriminant:something
    "set the value of the instance variable 'discriminant' (automatically generated)"

    discriminant := something.
! !

!XDRType::UnionType methodsFor:'encoding & decoding'!

decodeFrom:decoder
    ^ decoder decodeUnionWithType:self

    "Created: / 31.1.2002 / 15:21:10 / cg"
!

encode:value on:encoder with:aParameter
    encoder encodeUnion:value type:self with:aParameter
! !

!XDRType::UnionType methodsFor:'queries'!

isXDRUnion
    ^ true

    "Created: / 22.12.2001 / 02:46:24 / cg"
! !

!XDRType::UnknownType class methodsFor:'documentation'!

documentation
"
    this is used for unimplemented types
"
! !

!XDRType::UnsignedCharType methodsFor:'encoding & decoding'!

encode:value on:encoder with:aParameter
    encoder encodeUnsignedChar:value with:aParameter
! !

!XDRType::UnsignedCharType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'unsigned char'

    "Created: / 22.12.2001 / 00:05:58 / cg"
! !

!XDRType::UnsignedCharType methodsFor:'queries'!

isXDRUnsigned
    "return true if this Type represents an unsigned scalar type."

    ^ true

    "Created: / 22.12.2001 / 02:44:31 / cg"
    "Modified: / 22.12.2001 / 03:08:22 / cg"
! !

!XDRType::UnsignedHyperType methodsFor:'encoding & decoding'!

encode:value on:encoder with:aParameter
    encoder encodeUnsignedHyper:value with:aParameter
! !

!XDRType::UnsignedHyperType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'unsigned hyper'

    "Created: / 22.12.2001 / 03:49:09 / cg"
! !

!XDRType::UnsignedHyperType methodsFor:'queries'!

isXDRUnsigned
    "return true if this Type represents an unsigned scalar type."

    ^ true

    "Modified: / 22.12.2001 / 03:08:07 / cg"
    "Created: / 22.12.2001 / 03:48:42 / cg"
! !

!XDRType::UnsignedIntType methodsFor:'encoding & decoding'!

encode:value on:encoder with:aParameter
    encoder encodeUnsignedInt:value with:aParameter
! !

!XDRType::UnsignedIntType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'unsigned int'

    "Created: / 22.12.2001 / 00:05:58 / cg"
! !

!XDRType::UnsignedIntType methodsFor:'queries'!

isXDRUnsigned
    "return true if this Type represents an unsigned scalar type."

    ^ true

    "Created: / 22.12.2001 / 02:44:31 / cg"
    "Modified: / 22.12.2001 / 03:08:22 / cg"
! !

!XDRType::UnsignedLongType methodsFor:'encoding & decoding'!

encode:value on:encoder with:aParameter
    encoder encodeUnsignedLong:value with:aParameter
! !

!XDRType::UnsignedLongType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'unsigned long'

    "Created: / 22.12.2001 / 00:05:58 / cg"
! !

!XDRType::UnsignedLongType methodsFor:'queries'!

isXDRUnsigned
    "return true if this Type represents an unsigned scalar type."

    ^ true

    "Created: / 22.12.2001 / 02:44:31 / cg"
    "Modified: / 22.12.2001 / 03:08:22 / cg"
! !

!XDRType::UnsignedShortType methodsFor:'encoding & decoding'!

encode:value on:encoder with:aParameter
    encoder encodeUnsignedShort:value with:aParameter
! !

!XDRType::UnsignedShortType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'unsigned short'

    "Created: / 22.12.2001 / 00:05:58 / cg"
! !

!XDRType::UnsignedShortType methodsFor:'queries'!

isXDRUnsigned
    "return true if this Type represents an unsigned scalar type."

    ^ true

    "Created: / 22.12.2001 / 02:44:31 / cg"
    "Modified: / 22.12.2001 / 03:08:22 / cg"
! !

!XDRType::VoidType methodsFor:'encoding & decoding'!

encode:value on:encoder with:dummyParameter
    encoder encodeVoid:value with:dummyParameter
! !

!XDRType::VoidType methodsFor:'printing'!

idlString:datum indent:indent
    ^ 'void'

    "Modified: / 11.5.1999 / 14:26:54 / stefan"
    "Created: / 22.12.2001 / 00:06:03 / cg"
! !

!XDRType::VoidType methodsFor:'queries'!

isXDRVoid
    ^ true

    "Created: / 22.12.2001 / 02:45:54 / cg"
! !

!XDRType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRType.st,v 1.23 2017-11-18 09:52:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRType.st,v 1.23 2017-11-18 09:52:14 cg Exp $'
! !


XDRType initialize!
