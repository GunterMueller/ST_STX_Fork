"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help


 Original authors note:

 Hopefully someone will be able to adapt this for Smalltalk-V (if needed).
 I place NO restrictions on the use of this code.

 Here it is; Share And Enjoy!!

 Eliot Miranda                           email:          eliot@cs.qmc.ac.uk
 Dept of Computer Science                Tel:            01 975 5220
 Queen Mary College                      International:  +44 1 975 5220
 Mile End Road
 LONDON E1 4NS

 Claus: adapted to ST/X, compacted the format, added error handling
	and tuned here and there ...
"
"{ Package: 'stx:libboss' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BinaryIOManager
	instanceVariableNames:'usedFormat'
	classVariableNames:'FormatVersion ClassType Class1Type Class2Type GlobalType IdType
		Id1Type Id2Type NilType ObjectType Object1Type Object2Type
		ObjectSeqType TrueType FalseType CharacterType Character2Type
		ByteIntegerType ZeroType OneType MinusOneType StringType
		ByteArrayType SymbolType FullClassType MetaType ObjectCorpsType
		IntegerType NegativeIntegerType NegativeByteIntegerType
		ShortIntegerType BigIntegerType BigNegativeIntegerType
		FlushInstanceIDType FlushClassIDType FlushIDType TypeTableArray
		TypeSkipTableArray SpecialClassDefTypes SpecialClassTypes
		ImmediateObjectTypes BinaryLoadErrorSignal InvalidClassSignal
		NonexistingClassSignal ChangedInstLayoutSignal
		ChangedInstSizeSignal ChangedIndexedInstSignal
		RequestConversionSignal InvalidBinaryFormatErrorSignal
		Character3Type'
	poolDictionaries:''
	category:'System-BinaryStorage'
!

!BinaryIOManager class methodsFor:'documentation'!

copyright
"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help


 Original authors note:

 Hopefully someone will be able to adapt this for Smalltalk-V (if needed).
 I place NO restrictions on the use of this code.

 Here it is; Share And Enjoy!!

 Eliot Miranda                           email:          eliot@cs.qmc.ac.uk
 Dept of Computer Science                Tel:            01 975 5220
 Queen Mary College                      International:  +44 1 975 5220
 Mile End Road
 LONDON E1 4NS

 Claus: adapted to ST/X, compacted the format, added error handling
	and tuned here and there ...
"
!

documentation
"
    I am a shared superclass for the binary IO classes BinaryInputManager & 
    BinaryOutputManager.
    I define some class variables that define the types of descriptions in binary
    files, see BinaryIOManager class>>initialize

    [author:]
        Eliot Miranda (eliot@cs.qmc.ac.uk)
        Claus Gittinger

    [See also:]
        BinaryObjectStorage ObsoleteObject
        PersistencyManager
        Object
        (binary object storage : programming/binaryStore.html )
"
!

examples
"
    See examples in BinaryOutputManager
"


! !

!BinaryIOManager class methodsFor:'Signal constants'!

binaryLoadErrorSignal  
    "return the signal raised, when a binary load fails due to some reason.
     This is the parent signal for all other binary load errors; 
     therefore, it can be used to handle all errors in a single handler."

    ^ BinaryLoadErrorSignal

    "Modified: 17.3.1997 / 16:01:02 / cg"
!

changedIndexedInstSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has different indexed instvars (i.e. byte-insts vs. pointers etc)"

    ^ ChangedIndexedInstSignal
!

changedInstLayoutSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has a different inst layout (i.e. the size matches, but the order of
     instvars has changed)"

    ^ ChangedInstLayoutSignal
!

changedInstSizeSignal
    "return the signal raised, when an instance of a class is about to be filed in,
     which has a different inst-size (i.e. the number of named instvars has changed)"

    ^ ChangedInstSizeSignal
!

invalidBinaryFormatErrorSignal
    "return the signal raised, when a binary load fails due to format errors,
     for example, if you try to fileIn a binary object from another smalltalk,
     or from a stream which does not contain binary objects at all."

    ^ InvalidBinaryFormatErrorSignal

    "Created: 17.3.1997 / 16:00:48 / cg"
!

invalidClassSignal
    "return the signal raised, when an object is about to be filed in,
     for which no valid class exists in the system, 
     or when such a class is referenced in an instvar of a loaded object.
    
     This is the parent signal for all class related binary load errors; 
     therefore, it can be used to handle these in a single handler."

    ^ InvalidClassSignal

    "Modified: / 27-09-2007 / 09:49:03 / cg"
!

nonexistingClassSignal
    "return the signal raised, when an object is about to be filed in,
     for which no class exists (or no-longer exists)."

    ^ NonexistingClassSignal
!

requestConversionSignal
    "return the signal raised, when an instance of an obsolete class has
     to be converted. The handler gets an instance of a dummy class (which has the
     old classes structure) and the new class as parameters, and is supposed to
     return an instance of the new class with the dummy-instances contents."

    ^ RequestConversionSignal

    "Modified: / 27-09-2007 / 09:50:35 / cg"
! !

!BinaryIOManager class methodsFor:'class initialization'!

initialize
    "Initialize the types & type table for binary i/o"

    |lastCode|

    self ~~ BinaryIOManager ifTrue:[^ self].

    FormatVersion := 2.

    BinaryLoadErrorSignal isNil ifTrue:[
        BinaryLoadErrorSignal := Error newSignalMayProceed:true.
        BinaryLoadErrorSignal nameClass:self message:#binaryLoadErrorSignal.
        BinaryLoadErrorSignal notifierString:'error in binary load'.

        InvalidBinaryFormatErrorSignal := BinaryLoadErrorSignal newSignalMayProceed:true.
        InvalidBinaryFormatErrorSignal nameClass:self message:#invalidBinaryFormatErrorSignal.
        InvalidBinaryFormatErrorSignal notifierString:'invalid binary format'.

        InvalidClassSignal := BinaryLoadErrorSignal newSignalMayProceed:true.
        InvalidClassSignal nameClass:self message:#invalidClassSignal.
        InvalidClassSignal notifierString:'invalid class (in binary load)'.

        RequestConversionSignal := BinaryLoadErrorSignal newSignalMayProceed:true.
        RequestConversionSignal nameClass:self message:#requestConversionSignal.
        RequestConversionSignal notifierString:'conversion request (in binary load)'.
        RequestConversionSignal handlerBlock:[:ex | ex parameter value].

        NonexistingClassSignal := InvalidClassSignal newSignalMayProceed:true.
        NonexistingClassSignal nameClass:self message:#nonexistingClassSignal.
        NonexistingClassSignal notifierString:'non existing class (in binary load)'.

        ChangedInstSizeSignal := InvalidClassSignal newSignalMayProceed:true.
        ChangedInstSizeSignal nameClass:self message:#changedInstSizeSignal.
        ChangedInstSizeSignal notifierString:'number of instvars has changed (in binary load)'.

        ChangedInstLayoutSignal := InvalidClassSignal newSignalMayProceed:true.
        ChangedInstLayoutSignal nameClass:self message:#changedInstLayoutSignal.
        ChangedInstLayoutSignal notifierString:'instvar definition has changed (in binary load)'.

        ChangedIndexedInstSignal := InvalidClassSignal newSignalMayProceed:true.
        ChangedIndexedInstSignal nameClass:self message:#changedIndexedInstSignal.
        ChangedIndexedInstSignal notifierString:'type of indexed instvars has changed (in binary load)'.
    ].

    "/
    "/ the numbers are related to the tableArrays below
    "/ for backward compatibility (i.e. to be able to read
    "/ older bos-data), only add new types at the end.
    "/ NEVER remove or change numeric values.
    "/ typeIDs above 127 are reserved.
    "/
    IdType          := 1.
    NilType         := 2.
    TrueType        := 3.
    FalseType       := 4.
    ObjectType      := 5.
    ClassType       := 6.
    GlobalType      := 7.
    CharacterType   := 8.
    ZeroType        := 9.
    ByteIntegerType := 10.
    Id1Type         := 11.
    Id2Type         := 12.
    StringType      := 13.
    Character2Type  := 14.
    Object1Type     := 15.
    Class1Type      := 16.
    Object2Type     := 17.
    Class2Type      := 18.
    FullClassType   := 19.
    ByteArrayType   := 20.
    "/ SymbolClassDefType := 21.
    "/ ArrayClassDefType  := 22.
    "/ ObjectClassDefType  := 23.
    MetaType        := 24.
    ObjectCorpsType := 25.
    "/ StringClassType := 26.
    NegativeIntegerType := 27.
    NegativeByteIntegerType := 28.
    ShortIntegerType := 29.
    "/ LargeIntegerClassDefType := 30
    "/ FloatClassDefType := 31
    "/ ByteArrayClassDefType := 32
    FlushInstanceIDType := 33.
    FlushClassIDType := 34.
    FlushIDType := 35.
    BigIntegerType := 36.
    BigNegativeIntegerType := 37.
    OneType        := 38.
    MinusOneType   := 39.
    ObjectSeqType  := 40.
    "/ SymbolClassDefType := 41.
    "/ ArrayClassDefType  := 42.
    "/ ObjectClassDefType  := 43.
    "/ StringClassType := 44.
    "/ LargeIntegerClassDefType := 45
    "/ FloatClassDefType := 46
    "/ ByteArrayClassDefType := 47
    SymbolType      := 48.
    IntegerType := 49.
    Character3Type  := 50.
    lastCode := 50.


    "/ the ones below are no longer generated by the writer,
    "/ but still here for reading old binaries ...

    SpecialClassDefTypes := IdentityDictionary new.
    SpecialClassDefTypes at:Symbol       put:21. "/ SymbolClassDefType.
    SpecialClassDefTypes at:Array        put:22. "/ ArrayClassDefType.
    SpecialClassDefTypes at:Object       put:23. "/ ObjectClassDefType.
    SpecialClassDefTypes at:String       put:26. "/ StringClassDefType.
    SpecialClassDefTypes at:LargeInteger put:30. "/ LargeIntegerClassDefType.
    SpecialClassDefTypes at:Float        put:31. "/ FloatClassDefType.
    SpecialClassDefTypes at:ByteArray    put:32. "/ ByteArrayClassDefType.

    "/ these are now generated by the writer,
    "/ they refer to those classes, but do not define them
    "/ in the object-ID mapping.

    "/ we store immutable objects as mutable objects

    SpecialClassTypes := IdentityDictionary new.
    SpecialClassTypes at:Symbol          put:41. "/ SymbolClassType.
    SpecialClassTypes at:Array           put:42. "/ ArrayClassType.
    SpecialClassTypes at:ImmutableArray  put:42. "/ ArrayClassType.
    SpecialClassTypes at:Object          put:43. "/ ObjectClassType.
    SpecialClassTypes at:String          put:44. "/ StringClassType.
    SpecialClassTypes at:ImmutableString put:44. "/ StringClassType.
    SpecialClassTypes at:LargeInteger    put:45. "/ LargeIntegerClassType.
    SpecialClassTypes at:Float           put:46. "/ FloatClassType.
    SpecialClassTypes at:ByteArray       put:47. "/ ByteArrayClassType.
    SpecialClassTypes at:ImmutableByteArray put:47. "/ ByteArrayClassType.


    ImmediateObjectTypes := Array new:lastCode withAll:false.
    ImmediateObjectTypes at:ByteArrayType put:true.
    ImmediateObjectTypes at:StringType put:true.
    ImmediateObjectTypes at:SymbolType put:true.


    TypeTableArray := #( 
    "1"                 getObjectId 
                        getNil 
                        getTrue
                        getFalse 
                        getObjectDefinition
                        getClassDefinition
                        getGlobalDefinition 
                        getCharacterDefinition 
                        getZero
    "10"                getByteInteger 
                        getObject1Id 
                        getObject2Id 
                        getString
                        getCharacter2Definition 
                        getObject1Definition
                        getClass1Definition
                        getObject2Definition
                        getClass2Definition
                        getFullClass
    "20"                getByteArray
                        getSymbolClassDef
                        getArrayClassDef
                        getObjectClassDef
                        getMetaDefinition
                        getObjectCorps
                        getStringClassDef
                        getNegativeInteger 
                        getNegativeByteInteger 
                        getShortInteger 
    "30"                getLargeIntegerClassDef
                        getFloatClassDef
                        getByteArrayClassDef
                        flushInstanceIDs
                        flushClassIDs
                        flushIDs
                        getBigInteger 
                        getBigNegativeInteger 
                        getOne
                        getMinusOne
    "40"                getObjectSeqDefinition
                        getSymbolClass
                        getArrayClass
                        getObjectClass
                        getStringClass
                        getLargeIntegerClass
                        getFloatClass
                        getByteArrayClass
                        getSymbol
    "49"                getInteger
    "50"                getCharacter3Definition
                      ).

    TypeSkipTableArray := #( 
    "1"                 skipObjectId 
                        getNil 
                        getTrue
                        getFalse 
                        getObjectDefinition
                        getClassDefinition
                        getGlobalDefinition 
                        getCharacterDefinition 
                        getZero
    "10"                skip1
                        skipObject1Id 
                        skipObject2Id 
                        getString
                        getCharacter2Definition 
                        getObject1Definition
                        getClass1Definition
                        getObject2Definition
                        getClass2Definition
                        getFullClass
    "20"                getByteArray
                        getSymbolClass
                        getArrayClass
                        getObjectClass
                        getMetaDefinition
                        getObjectCorps
                        getStringClass
                        skip4
                        skip1
                        getShortInteger 
    "30"                getLargeIntegerClass
                        getFloatClass
                        getByteArrayClass
                        flushInstanceIDs
                        flushClassIDs
                        flushIDs
                        skip8
                        skip8
                        getOne
                        getMinusOne
    "40"                getObjectSeqDefinition
                        getSymbolClass
                        getArrayClass
                        getObjectClass
                        getStringClass
                        getLargeIntegerClass
                        getFloatClass
                        getByteArrayClass
                        getSymbol
    "49"                skip4
    "50"                getCharacter3Definition
                      ).

    "
     BinaryIOManager initialize
    "

    "Modified: / 2.11.1997 / 16:11:51 / cg"
! !

!BinaryIOManager methodsFor:'accessing'!

codeForByteArray
    "return the code-byte used to encode a byteArray with 1-byte length"

    ^ ByteArrayType

    "Modified: / 2.11.1997 / 15:08:49 / cg"
!

codeForByteInteger
    "return the code-byte used to encode a small byte valued integer"

    ^ ByteIntegerType

    "Modified: 22.1.1997 / 18:46:44 / cg"
!

codeForCharacter
    "return the code-byte used to encode a single-byte character"

    ^ CharacterType

    "Modified: 22.1.1997 / 18:46:56 / cg"
!

codeForClass
    "return the code-byte used to encode a class"

    ^ FullClassType

    "Modified: 22.1.1997 / 18:48:15 / cg"
!

codeForFalse
    "return the code-byte used to encode false"

    ^ FalseType

    "Modified: 22.1.1997 / 18:48:07 / cg"
!

codeForMinusOne
    "return the code-byte used to encode the small integer -1 (minus one)"

    ^ MinusOneType

    "Modified: / 22.1.1997 / 18:47:21 / cg"
    "Created: / 1.11.1997 / 18:08:42 / cg"
!

codeForNegativeByteInteger
    "return the code-byte used to encode a negative byte valued integer"

    ^ NegativeByteIntegerType

    "Created: 28.2.1996 / 23:29:30 / cg"
    "Modified: 22.1.1997 / 18:48:01 / cg"
!

codeForNegativeInteger
    "return the code-byte used to encode a negative integer"

    ^ NegativeIntegerType

    "Created: 28.2.1996 / 23:29:34 / cg"
    "Modified: 22.1.1997 / 18:47:53 / cg"
!

codeForNil
    "return the code-byte used to encode nil"

    ^ NilType

    "Modified: 22.1.1997 / 18:47:44 / cg"
!

codeForOne
    "return the code-byte used to encode the small integer 1 (one)"

    ^ OneType

    "Modified: / 22.1.1997 / 18:47:21 / cg"
    "Created: / 1.11.1997 / 18:08:27 / cg"
!

codeForString
    "return the code-byte used to encode a string with 1-byte length"

    ^ StringType

    "Modified: / 2.11.1997 / 15:09:08 / cg"
!

codeForSymbol
    "return the code-byte used to encode a symbol with 1-byte length"

    ^ SymbolType

    "Modified: / 2.11.1997 / 15:09:08 / cg"
    "Created: / 2.11.1997 / 16:12:19 / cg"
!

codeForThreeByteCharacter
    "return the code-byte used to encode a three-byte character"

    ^ Character3Type

    "Modified (comment): / 22-05-2017 / 15:08:09 / mawalch"
!

codeForTrue
    "return the code-byte used to encode true"

    ^ TrueType

    "Modified: 22.1.1997 / 18:47:31 / cg"
!

codeForTwoByteCharacter
    "return the code-byte used to encode a two-byte character"

    ^ Character2Type

    "Modified: 22.1.1997 / 18:47:02 / cg"
!

codeForZero
    "return the code-byte used to encode the small integer 0 (zero)"

    ^ ZeroType

    "Modified: 22.1.1997 / 18:47:21 / cg"
!

usedFormat
    "the storage format used. See documentation"

    ^ usedFormat
!

usedFormat:anInteger
    "the storage format used. See documentation"

    usedFormat := anInteger.
! !

!BinaryIOManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/BinaryIOManager.st,v 1.42 2017-05-22 13:13:05 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libboss/BinaryIOManager.st,v 1.42 2017-05-22 13:13:05 mawalch Exp $'
! !


BinaryIOManager initialize!
