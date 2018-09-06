"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Behavior subclass:#Structure
	instanceVariableNames:'i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i16 i17 i18
		i19 i20 i21 i22 i23 i24 i25 i26 i27 i28 i29 i30 i31 i32 i33 i34
		i35 i36 i37 i38 i39 i40 i41 i42 i43 i44 i45 i46 i47 i48 i49 i50'
	classVariableNames:'OneInstance DummyClass ReadAccessMethods WriteAccessMethods
		OtherMethods OtherSelectors IndexOfFlags IndexOfMethodDictionary
		IndexOfInstSize'
	poolDictionaries:''
	category:'Programming-Support'
!

!Structure class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    This is an experimental class, stressing the metaObject capabilities.

    Structures are objects which are class-less,
    only holding some values, and provide a protocol to access
    those fields. In addition, they support the array-protocol,
    so they can be used as backward compatible replacements in
    places where arrays were returned.
    (However, we recommend using private classes, since they are easier
     to understand and maintain).

    For example, some structure object can be create with:
        ^ Structure with:#foo->'someFooValue' with:#bar->'someBarValue'

    and access these values either as:
        retVal at:1     -> returns the foo instvar value
        retVal at:2     -> returns the bar instvar value
    or (much more convenient and readable) as:
        retVal foo
        retVal bar

    Implementation note:
        this is a very tricky (but fully legal) implementation,
        creating an object which is its own class.
        Therefore, no additional overhead by extra (class) objects is involved.
        These are very lightweight objects.

        Another prove that smalltalk is a powerful & flexible programming language.
        However, some smalltalk systems crash if your try this ;-)

    CAVEAT:
        tricky implementation - not the full object protocol is supported;
        a maximum of 50 instance variables is allowed.

    [WARNING:]
        this is an experimental goody - for our amusement and not meant
        to be used in real applications.
        It may be removed without notice and/or no longer maintained in the furure.

    [author:]
        Claus Gittinger

    [see also:]
        Array
        Behavior
"
!

examples
"
  access is possibly by name:
                                                                [exBegin]
    Transcript showCR:
        (Structure with:#foo->'foo value') foo
                                                                [exEnd]

  AND also by index (for backward compatibility):
                                                                [exBegin]
    Transcript showCR:
        ((Structure with:#foo->'foo value') at:1)
                                                                [exEnd]

  it can be inspected:
                                                                [exBegin]
    (Structure with:#foo->'foo value') inspect
                                                                [exEnd]

  and presents its contents nicely:
                                                                [exBegin]
    (Structure with:#foo->'foo value' with:#bar->'bar value') inspect
                                                                [exEnd]

                                                                [exBegin]
    (Structure with:#foo->'hello' with:#bar->true with:#baz->'world') inspect
                                                                [exEnd]

"
! !

!Structure class methodsFor:'initialization'!

initializeOneInstance
    OneInstance isNil ifTrue:[
        "/ check if the first few instvars correspond to Behavior's definition:

"/        (Behavior instSize + 1) == (self instanceVariableNames indexOf:#i1) ifFalse:[
"/            self halt:'you must change the definition of this class (instvars before i1 must match behavior''s)'.
"/        ].
        IndexOfFlags := Behavior instVarIndexFor:'flags'.
        IndexOfMethodDictionary := Behavior instVarIndexFor:'methodDictionary'. 
        IndexOfInstSize := Behavior instVarIndexFor:'instSize'. 
        
        OneInstance := self basicNew.

        DummyClass := Behavior shallowCopy.
        DummyClass flags:(Behavior flagBehavior bitOr:Behavior flagPointers).
        DummyClass setName:#DummyClass.

        ReadAccessMethods := (1 to:50)
                                collect:[:i | |m|
                                            m := self compiledMethodAt:('i', i printString) asSymbol.
                                            (m notNil and:[m isLazyMethod]) ifTrue:[m makeRealMethod].
                                            m
                                ].
        WriteAccessMethods := (1 to:50)
                                collect:[:i | |m|
                                            m := self compiledMethodAt:('i', i printString) asMutator.
                                            (m notNil and:[m isLazyMethod]) ifTrue:[m makeRealMethod].
                                            m
                                ].

        OtherMethods := OrderedCollection new.
        OtherMethods
            add:(self compiledMethodAt:#doesNotUnderstand:);
            add:(Object compiledMethodAt:#class);
            add:(Object compiledMethodAt:#identityHash);
            add:(Object compiledMethodAt:#at:);
            add:(Object compiledMethodAt:#at:put:);
            add:(Object compiledMethodAt:#basicAt:);
            add:(Object compiledMethodAt:#basicAt:put:);
            add:(Object compiledMethodAt:#printString);
            add:(Object compiledMethodAt:#printOn:);
            add:(Object compiledMethodAt:#basicPrintOn:);
            add:(Object compiledMethodAt:#addDependent:);
            add:(Object compiledMethodAt:#removeDependent:);
            add:(Object compiledMethodAt:#dependents);
            add:(Object compiledMethodAt:#dependents:);
            add:(Object compiledMethodAt:#perform:);
            add:(Object compiledMethodAt:#perform:with:);
            add:(Object compiledMethodAt:#respondsTo:);
            add:(Object compiledMethodAt:#isBoolean).
        OtherMethods := OtherMethods asArray.

        OtherSelectors := #(#doesNotUnderstand:
                            #class #identityHash
                            #at: #at:put: #basicAt: #basicAt:put:
                            #printString #printOn: #basicPrintOn:
                            #addDependent: #removeDependent: #dependents #dependents:
                            #perform: #perform:with:
                            #respondsTo:
                            #isBoolean).
    ].

    "
     OneInstance := nil.
     self initialize.
    "

    "Modified: 21.9.1996 / 16:01:48 / cg"
! !

!Structure class methodsFor:'instance creation'!

newWith:names
    "return a new structure containing fields as passed in the names collection.
     The argument must be a sequenceable collection of symbols.
     The new structures values are all initialized to nil."

     ^ self newWith:names values:nil

    "
     Structure newWith:#(foo bar)
    "

    "Created: 13.5.1996 / 20:03:42 / cg"
!

newWith:names values:values
    "return a new structure containing fields as passed in the names collection.
     The argument must be a sequenceable collection of symbols.
     The new structures values are set to corresponding values from the second argument, values."

    |arr sels mthds nInsts behviorsInstSize|

    OneInstance isNil ifTrue:[
        self initializeOneInstance
    ].

    nInsts := names size.

    sels := names collect:[:nm | nm asSymbol].
    sels := sels , (names collect:[:nm | nm asMutator]).
    sels := sels , OtherSelectors.

    mthds := ReadAccessMethods copyTo:nInsts.
    mthds := mthds , (WriteAccessMethods copyTo:nInsts).
    mthds := mthds , OtherMethods.

    "/ create a prototype object as an array ...
    "/ the object will be its own class, and have the indexable flag bit set;
    "/ therefore, the first behviorsInstSize instVars must correspond to Behavior instvars,
    "/ the remaining ones will be the indexed instvars.
    behviorsInstSize := Behavior instSize.

    arr := Array new:(behviorsInstSize + nInsts).
"/    arr at:1 put:nil.                                                   "/ superclass
    arr at:IndexOfFlags put:(Behavior flagBehavior bitOr:Behavior flagPointers).          "/ flags
    arr at:IndexOfMethodDictionary put:(MethodDictionary withKeys:sels andValues:mthds).  "/ selectors & methods
"/    arr at:IndexOfLookupObject put:nil.                                                 "/ lookupObject
    arr at:IndexOfInstSize put:behviorsInstSize.                                      "/ instSize
    
    "/ now, the big trick ...

    arr changeClassTo:DummyClass.
    arr changeClassTo:arr.

    values notNil ifTrue:[
        values keysAndValuesDo:[:i :val |
            arr at:i put:val
        ]
    ].

    ^ arr.

    "
     Structure newWith:#(foo bar) values:#('foo' 'bar')
    "

    "Created: 13.5.1996 / 20:03:42 / cg"
    "Modified: 3.7.1996 / 10:24:43 / cg"
!

with:assoc
    "return a new structure with a single field, named to the assocs key,
     and initialized with assocs value."

     ^ self newWith:(Array with:assoc key) values:(Array with:assoc value)

    "
     Structure with:#foo->'foo'
    "
!

with:assoc1 with:assoc2
    "return a new structure with two fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key)
             values:(Array with:assoc1 value with:assoc2 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar'
    "
!

with:assoc1 with:assoc2 with:assoc3
    "return a new structure with three fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key with:assoc3 key)
             values:(Array with:assoc1 value with:assoc2 value with:assoc3 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar' with:#baz->'baz'
    "
!

with:assoc1 with:assoc2 with:assoc3 with:assoc4
    "return a new structure with four fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key
                           with:assoc3 key with:assoc4 key)
             values:(Array with:assoc1 value with:assoc2 value
                           with:assoc3 value with:assoc4 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar' with:#baz->'baz' with:#hello->'hello'
    "
!

with:assoc1 with:assoc2 with:assoc3 with:assoc4 with:assoc5
    "return a new structure with five fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key
                           with:assoc3 key with:assoc4 key
                           with:assoc5 key)
             values:(Array with:assoc1 value with:assoc2 value
                           with:assoc3 value with:assoc4 value
                           with:assoc5 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar' with:#baz->'baz' with:#hello->'hello' with:#world->'world'
    "
!

with:assoc1 with:assoc2 with:assoc3 with:assoc4 with:assoc5 with:assoc6
    "return a new structure with five fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key
                           with:assoc3 key with:assoc4 key
                           with:assoc5 key with:assoc6 key)
             values:(Array with:assoc1 value with:assoc2 value
                           with:assoc3 value with:assoc4 value
                           with:assoc5 value with:assoc6 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar' with:#baz->'baz' with:#hello->'hello' with:#world->'world'
    "
!

with:assoc1 with:assoc2 with:assoc3 with:assoc4 with:assoc5 with:assoc6 with:assoc7
    "return a new structure with five fields, named as defined by the arguments'
     keys, and and initialized with the assocs' values."

     ^ self newWith:(Array with:assoc1 key with:assoc2 key
                           with:assoc3 key with:assoc4 key
                           with:assoc5 key with:assoc6 key
                           with:assoc7 key)
             values:(Array with:assoc1 value with:assoc2 value
                           with:assoc3 value with:assoc4 value
                           with:assoc5 value with:assoc6 value
                           with:assoc7 value)

    "
     Structure with:#foo->'foo' with:#bar->'bar' with:#baz->'baz' with:#hello->'hello' with:#world->'world'
    "
! !

!Structure class methodsFor:'special'!

primAddSelector:newSelector withMethod:newMethod
    "must reinit myself when methods are accepted."

    |val|

    val := super primAddSelector:newSelector withMethod:newMethod.
    OneInstance := nil.
    "/ self initializeOneInstance.
    ^ val
! !

!Structure methodsFor:'accessing'!

flags
    "return the flags - required class protocol"

    ^ flags

    "Created: 13.5.1996 / 21:19:23 / cg"
!

flags:something
    "set the flags - required class protocol"

    flags := something.

    "Created: 13.5.1996 / 21:19:23 / cg"
!

i1
    "prototype method to return the first instance variable"

    ^ i1

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i10
    "prototype method to return the 10th instance variable"

    ^ i10

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i10:something
    "prototype method to set the 10th instance variable"

    i10 := something.

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i11
    "return i11"

    ^ i11

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i11:something
    "prototype method to set the 11th instance variable"

    i11 := something.

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i12
    "return i12"

    ^ i12

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i12:something
    "set i12"

    i12 := something.

    "Created: 13.5.1996 / 21:19:27 / cg"
!

i13
    "return i13"

    ^ i13

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i13:something
    "set i13"

    i13 := something.

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i14
    "return i14"

    ^ i14

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i14:something
    "set i14"

    i14 := something.

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i15
    "return i15"

    ^ i15

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i15:something
    "set i15"

    i15 := something.

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i16
    "return i16"

    ^ i16

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i16:something
    "set i16"

    i16 := something.

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i17
    "return i17"

    ^ i17

    "Created: 13.5.1996 / 21:19:28 / cg"
!

i17:something
    "set i17"

    i17 := something.

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i18
    "return i18"

    ^ i18

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i18:something
    "set i18"

    i18 := something.

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i19
    "return i19"

    ^ i19

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i19:something
    "set i19"

    i19 := something.

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i1:something
    "prototype method to set the 1st instance variable"

    i1 := something.

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i2
    "prototype method to return the 2nd instance variable"

    ^ i2

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i20
    "return i20"

    ^ i20

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i20:something
    "set i20"

    i20 := something.

    "Created: 13.5.1996 / 21:19:29 / cg"
!

i21
    "return i21"

    ^ i21

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i21:something
    "set i21"

    i21 := something.

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i22
    "return i22"

    ^ i22

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i22:something
    "set i22"

    i22 := something.

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i23
    "return i23"

    ^ i23

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i23:something
    "set i23"

    i23 := something.

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i24
    "return i24"

    ^ i24

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i24:something
    "set i24"

    i24 := something.

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i25
    "return i25"

    ^ i25

    "Created: 21.9.1996 / 16:06:21 / cg"
!

i25:something
    "set i25"

    i25 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i26
    "return i26"

    ^ i26

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i26:something
    "set i26"

    i26 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i27
    "return i27"

    ^ i27

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i27:something
    "set i27"

    i27 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i28
    "return i28"

    ^ i28

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i28:something
    "set i28"

    i28 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i29
    "return i29"

    ^ i29

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i29:something
    "set i29"

    i29 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i2:something
    "prototype method to set the 2nd instance variable"

    i2 := something.

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i3
    "prototype method to return the 3rd instance variable"

    ^ i3

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i30:something
    "set i30"

    i30 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i31
    "return i31"

    ^ i31

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i31:something
    "set i31"

    i31 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i32
    "return i32"

    ^ i32

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i32:something
    "set i32"

    i32 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i33
    "return i33"

    ^ i33

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i33:something
    "set i33"

    i33 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i34
    "return i34"

    ^ i34

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i34:something
    "set i34"

    i34 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i35
    "return i35"

    ^ i35

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i35:something
    "set i35"

    i35 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i36
    "return i36"

    ^ i36

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i36:something
    "set i36"

    i36 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i37
    "return i37"

    ^ i37

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i37:something
    "set i37"

    i37 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i38
    "return i38"

    ^ i38

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i38:something
    "set i38"

    i38 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i39
    "return i39"

    ^ i39

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i39:something
    "set i39"

    i39 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i3:something
    "prototype method to set the 3rd instance variable"

    i3 := something.

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i4
    "prototype method to return the 4th instance variable"

    ^ i4

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i40
    "return the value of the instance variable 'i40' (automatically generated)"

    ^ i40
!

i40:something
    "prototype method"

    i40 := something.

    "Created: 21.9.1996 / 16:06:22 / cg"
!

i41
    "prototype method"

    ^ i41

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i41:something
    "prototype method"

    i41 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i42
    "prototype method"

    ^ i42

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i42:something
    "prototype method"

    i42 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i43
    "prototype method"

    ^ i43

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i43:something
    "prototype method"

    i43 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i44
    "prototype method"

    ^ i44

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i44:something
    "prototype method"

    i44 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i45
    "prototype method"

    ^ i45

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i45:something
    "prototype method"

    i45 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i46
    "prototype method"

    ^ i46

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i46:something
    "prototype method"

    i46 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i47
    "prototype method"

    ^ i47

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i47:something
    "prototype method"

    i47 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i48
    "prototype method"

    ^ i48

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i48:something
    "prototype method"

    i48 := something.

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i49
    "prototype method"

    ^ i49

    "Created: 21.9.1996 / 16:06:23 / cg"
!

i49:something
    "prototype method"

    i49 := something.

    "Created: 21.9.1996 / 16:06:24 / cg"
!

i4:something
    "prototype method to set the 4th instance variable"

    i4 := something.

    "Created: 13.5.1996 / 21:19:25 / cg"
!

i5
    "prototype method to return the 5th instance variable"

    ^ i5

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i50
    "prototype method"

    ^ i50

    "Created: 21.9.1996 / 16:06:24 / cg"
!

i50:something
    "prototype method"

    i50 := something.

    "Created: 21.9.1996 / 16:06:24 / cg"
!

i5:something
    "prototype method to set the 5th instance variable"

    i5 := something.

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i6
    "prototype method to return the 6th instance variable"

    ^ i6

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i6:something
    "prototype method to set the 6th instance variable"

    i6 := something.

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i7
    "prototype method to return the 7th instance variable"

    ^ i7

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i7:something
    "prototype method to set the 7th instance variable"

    i7 := something.

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i8
    "prototype method to return the 8th instance variable"

    ^ i8

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i8:something
    "prototype method to set the 8th instance variable"

    i8 := something.

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i9
    "prototype method to return the 9th instance variable"

    ^ i9

    "Created: 13.5.1996 / 21:19:26 / cg"
!

i9:something
    "prototype method to set the 9th instance variable"

    i9 := something.

    "Created: 13.5.1996 / 21:19:27 / cg"
!

instSize
    "return instSize - required class protocol"

    ^ instSize

    "Created: 13.5.1996 / 21:19:24 / cg"
!

instSize:something
    "set instSize - required class protocol"

    instSize := something.

    "Created: 13.5.1996 / 21:19:25 / cg"
!

methodDictionary
    "return the methodDictionary - required class protocol"

    ^ methodDictionary
!

superclass
    "return superclass - required class protocol"

    ^ superclass

    "Created: 13.5.1996 / 21:19:23 / cg"
!

superclass:something
    "set superclass - required class protocol"

    superclass := something.

    "Created: 13.5.1996 / 21:19:23 / cg"
! !

!Structure methodsFor:'stubs'!

doesNotUnderstand:aMessage
    "catch unimplemented messages - pass some to the superclass.
     Notice that although this method calls super messages,
     actual instances will have no valid superClass."

    <ignore: RBReturnsBooleanAndOtherRule rationale:'returns whatever the forwarded method returns' author:'cg'>
    
    |sel args names sz s idx|

    "/ instance protocol

    sel := aMessage selector.
    args := aMessage arguments.

    (sel == #displayOn:) ifTrue:[
        s := args at:1.
        s nextPutAll:'Structure('.
        names := self allInstVarNames.
        names notNil ifTrue:[
            names keysAndValuesDo:[:idx :nm |
                s nextPutAll:nm; nextPutAll:'->'.
                (self at:idx) displayOn:s.
                s space
            ].
        ].
        s nextPut:$).
        ^ self.
    ].

    (sel == #displayString) ifTrue:[
        s := CharacterWriteStream on:''.
        self displayOn:s.
        ^ s contents
    ].

    sel == #basicInspect ifTrue:[
        ^ InspectorView openOn:self
    ].

    sel == #inspectorClass ifTrue:[
        ^ InspectorView
    ].
    sel == #inspect ifTrue:[
        ^ InspectorView openOn:self
    ].

    sel == #instVarAt: ifTrue:[
        |nr|

        nr := args at:1.
        nr == 1 ifTrue:[^ i1].
        nr == 2 ifTrue:[^ i2].
        nr == 3 ifTrue:[^ i3].
        nr == 4 ifTrue:[^ i4].
        nr == 5 ifTrue:[^ i5].
        nr == 6 ifTrue:[^ i6].
        nr == 7 ifTrue:[^ i7].
        nr == 8 ifTrue:[^ i8].
        nr == 9 ifTrue:[^ i9].
        nr == 10 ifTrue:[^ i10].
        nr == 11 ifTrue:[^ i11].
        nr == 12 ifTrue:[^ i12].
        nr == 13 ifTrue:[^ i13].
        nr == 14 ifTrue:[^ i14].
        ^ nil
    ].

    (sel == #perform:) ifTrue:[
         ^ super perform:(args at:1)
    ].
    (sel == #perform:with:) ifTrue:[
         ^ super perform:(args at:1) with:(args at:2)
    ].

    (sel == #=) ifTrue:[
        (args at:1) class == (args at:1) ifFalse:[^ false].    "/ must be another struct
        names := self allInstVarNames.
        names notNil ifTrue:[
            Error handle:[:ex |
                ^ false
            ] do:[
                names do:[:slotName |
                    ((args at:1) perform:slotName asSymbol) = (self perform:slotName asSymbol)
                    ifFalse:[slotName halt. ^ false]
                ]
            ].
        ].
        ^ true.
    ].
    (sel == #~=) ifTrue:[
         ^ super ~= (args at:1)
    ].

    (sel == #size or:[sel == #basicSize]) ifTrue:[
         ^ super basicSize
    ].

    (sel == #at: or:[sel == #basicAt:]) ifTrue:[
         ^ super basicAt:(args at:1)
    ].

    (sel == #at:put: or:[sel == #basicAt:put:]) ifTrue:[
         ^ super basicAt:(args at:1) put:(args at:2)
    ].

    sel == #== ifTrue:[
         ^ self == (args at:1)
    ].

    sel == #clone ifTrue:[
         ^ super clone
    ].
    sel == #shallowCopy ifTrue:[
         ^ super shallowCopy
    ].
    sel == #identityHash ifTrue:[
         ^ super identityHash
    ].
    sel == #hash ifTrue:[
         ^ super hash
    ].
    (sel == #isException) ifTrue:[
         ^ false
    ].
    (sel == #isStructure) ifTrue:[
         ^ true
    ].
    (sel == #class) ifTrue:[
         ^ Structure
    ].
    (sel == #theMetaclass) ifTrue:[
         ^ Structure class
    ].


    "/ class protocol

    (sel == #name or:[sel == #className or:[sel == #fullName or:[sel == #nameInBrowser]]]) ifTrue:[
        ^ #Structure
    ].
    (sel == #package) ifTrue:[
        ^ #'stx:libcomp'
    ].
    sel == #isVariable ifTrue:[
         ^ false
    ].
    sel == #isImmediate ifTrue:[
         ^ false
    ].
    sel == #isImage ifTrue:[
         ^ false
    ].
    sel == #isFilename ifTrue:[
         ^ false
    ].
    sel == #isLazyValue ifTrue:[
         ^ false
    ].
    sel == #isClass ifTrue:[
         ^ false
    ].
    sel == #isMeta ifTrue:[
         ^ false
    ].
    sel == #isBehavior ifTrue:[
         ^ false
    ].
    sel == #isKindOf: ifTrue:[
         ^ false
    ].
    sel == #includesBehavior: ifTrue:[
         ^ (args at:1) == Structure or:[(args at:1) == Behavior].
    ].
    sel == #isString ifTrue:[
         ^ false
    ].
    sel == #hasImmediateInstances ifTrue:[
         ^ false
    ].
    sel == #respondsTo: ifTrue:[
         ^ false
    ].
    sel == #canUnderstand: ifTrue:[
        methodDictionary isNil ifTrue:[
            ^ false
        ].
        ^ methodDictionary includesKey:(args at:1).
    ].
    sel == #whichClassIncludesSelector: ifTrue:[
         ^ nil
    ].
    sel == #evaluatorClass ifTrue:[
        ^ Compiler
    ].
    sel == #theNonMetaclass ifTrue:[
        ^ self
    ].
    sel == #classNameWithArticle ifTrue:[
         ^ self displayString
    ].
    sel == #nameWithArticle ifTrue:[
         ^ 'a Structure'
    ].
    (sel == #allSubclasses or:[sel == #subclasses]) ifTrue:[
        ^ #()
    ].
    sel == #allClassVarNames ifTrue:[
        ^ #()
    ].
    sel == #inspector2TabCommon ifTrue:[
        ^ super inspector2TabForInspectorClass
    ].
    sel == #programmingLanguage ifTrue:[
        ^ Object programmingLanguage
    ].

    sel == #methodDictionary ifTrue:[
        ^ methodDictionary
    ].
    sel == #allInstVarNames ifTrue:[
        methodDictionary isNil ifTrue:[
            'Structure [info]: oops - nil methodDict' infoPrintCR.
            ^ #()
        ].

        sz := super basicSize.
        names := Array new:sz.

        methodDictionary keysAndValuesDo:[:sel :mthd|
            |index mysel|

            (sel endsWith:$:) ifFalse:[
                (sel ~~ #class) ifTrue:[
                    "/
                    "/ which method is it ?
                    "/
                    idx := 1.
                    [idx <= sz] whileTrue:[
                        mysel := ('i' , idx printString) asSymbol.
                        mthd == (Structure compiledMethodAt:mysel) ifTrue:[
                            names at:idx put:sel.
                            idx := sz.   "/ break
                        ].
                        idx := idx + 1.
                    ].
                ]
            ]
        ].

         ^ names
    ].

    (sel == #instSize) ifTrue:[
         ^ instSize
    ].
    ((sel startsWith:'is') or:[sel startsWith:'has']) ifTrue:[
        ^ false.
    ].
    'Structure [warning]: return nil for: ' infoPrint.
    aMessage infoPrint.' args ' infoPrint. args infoPrintCR.
"/ Object halt.

    ^ nil.

    "Created: / 13-05-1996 / 20:22:22 / cg"
    "Modified: / 16-07-2017 / 13:54:58 / cg"
    "Modified (format): / 24-07-2017 / 16:43:06 / stefan"
! !

!Structure class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

