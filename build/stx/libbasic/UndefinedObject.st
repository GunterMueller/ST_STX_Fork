"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#UndefinedObject
	instanceVariableNames:''
	classVariableNames:'CreateMinimumProtocolInNewSubclassQuery'
	poolDictionaries:''
	category:'Kernel-Objects'
!

!UndefinedObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    there is only one instance of this class: nil,
    representing an undefined or otherwise unspecified object.

    All instance variables, array elements and even method/block local
    variables are initially set to nil.

    Since in Smalltalk/X (and in other smalltalks), nil is represented by
    a special pointer value (NULL), there can be only one instance of UndefinedObject,
    and no subclassing is possible.
    (to be exact: subclassing UndefinedObject is technically possible,
     but instances of it would not be recognized as being nil
     - therefore, subclassing is blocked and an error is raised when it is tried)

    For advanced users:
      Beside the above role, nil can be subclassed (!!).
      This creates a class which inherits no protocol whatsoever - not even
      the basic interfaces as defined by the Object class. Subclasses of nil
      are useful if all messages send to instances should trap into the
      #doesNotUnderstand: method. For example, proxy objects are typically defined
      this way.

    [author:]
        Claus Gittinger
"
! !

!UndefinedObject class methodsFor:'initialization'!

initialize
    CreateMinimumProtocolInNewSubclassQuery isNil ifTrue:[
        CreateMinimumProtocolInNewSubclassQuery := QuerySignal new.
        CreateMinimumProtocolInNewSubclassQuery nameClass:self message:#createMinimumProtocolInNewSubclassQuery.
        CreateMinimumProtocolInNewSubclassQuery defaultAnswer:false.
    ].

    "
     UndefinedObject initialize
    "

    "Created: 3.1.1997 / 15:02:40 / cg"
    "Modified: 3.1.1997 / 15:18:33 / cg"
! !

!UndefinedObject class methodsFor:'instance creation'!

basicNew
    "catch new - there MUST be only one nil in the system"

    ^ nil
!

basicNew:size
    "catch new - there MUST be only one nil in the system"

    ^ nil
! !

!UndefinedObject class methodsFor:'Signal constants'!

createMinimumProtocolInNewSubclassQuery
    "return the signal used to ask if the minimum required protocol
     should be created for nil subclasses.
     By default, this is not done, however, the browser answers true
     here, to avoid big trouble with nil subclasses which do not define
     some methods which the inspector needs."

    ^ CreateMinimumProtocolInNewSubclassQuery

    "Created: 3.1.1997 / 15:05:48 / cg"
    "Modified: 3.1.1997 / 15:06:15 / cg"
! !


!UndefinedObject class methodsFor:'queries'!

canBeSubclassed
    "return true if it is allowed to create subclasses of the receiver.
     Return false here - since it is NOT possible for UndefinedObject.
     (due to the representation of nil as a 0-pointer)"

    ^ false

    "Modified: / 5.11.1998 / 16:11:43 / cg"
!

hasImmediateInstances
    "return true if this class has immediate instances
     i.e. if the instances are represented in the pointer itself and
     no real object header/storage is used for the object.
     Redefined from Behavior"

    ^ true

    "Created: 3.6.1997 / 12:01:39 / cg"
!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     True returned here - there is only one nil."

    ^ true


!

isBuiltInClass
    "return true if this class is known by the run-time-system,
     i.e. you cannot add/remove instance variables without recompiling
     the VM.
     Here, true is returned for myself, false for subclasses."

    ^ self == UndefinedObject
! !


!UndefinedObject methodsFor:'Compatibility-Squeak'!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString category:cat
    ^ self subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries: '' category:cat

    "Created: / 24-07-2015 / 19:29:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !



!UndefinedObject methodsFor:'converting'!

asBoolean
    ^ false
!

asNilIfEmpty
    "I am nil, so answer nil"

    ^ self
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ self

    "Created: 25.2.1997 / 19:18:47 / cg"
! !

!UndefinedObject methodsFor:'copying'!

copy
    "return a shallow copy of myself
     - since there is only one nil in the system return self"

    ^ self
!

deepCopy
    "return a deep copy of myself
     - since there is only one nil in the system return self"

    ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of myself
     - since there is only one nil in the system, return self"

    ^ self
!

shallowCopy
    "return a shallow copy of myself
     - since there is only one nil in the system return self"

    ^ self
!

simpleDeepCopy
    "return a deep copy of myself
     - since there is only one nil in the system return self"

    ^ self
! !

!UndefinedObject methodsFor:'dependents access'!

addDependent:someObject
    "raise an error here - nil may not have dependents (it never changes anyway)"

    self error:'nil may not have dependents' mayProceed:true

    "Modified: / 28-07-2010 / 19:20:36 / cg"
!

dependents
    "nil has no dependents"

    ^#()
!

release
    "ignored here - nil has no dependents"
!

removeDependent:someObject
    "ignored here - nil has no dependents"
! !

!UndefinedObject methodsFor:'error catching'!

basicAt:index
    "catch array access - it's illegal.
     Redefined here since basicAt: in Object ommits the nil-check"

    ^ self notIndexed
!

basicAt:index put:anObject
    "catch array access - it's illegal.
     Redefined here since basicAt:put: in Object ommits the nil-check"

    ^ self notIndexed
! !


!UndefinedObject methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the
     argument, aStream"

    aStream nextPutAll:'nil'
!

printString
    "return a string for printing myself"

    ^ 'nil'
!

storeOn:aStream
    "append a printed representation of the receiver to the
     argument, aStream, which allows reconstruction of it"

    ^ self printOn:aStream
!

storeString
    "return a string for storing myself"

    ^ 'nil'
! !

!UndefinedObject methodsFor:'queries'!

basicSize
    "return the number of indexed instvars
     defined here since size in Object ommits the nil-check"

    ^ 0
!

size
    "return the number of indexed instvars
     defined here since size in Object ommits the nil-check"

    ^ 0
! !


!UndefinedObject methodsFor:'subclass creation'!

nilSubclass:action
    "common helper for subclass creation.
     Creates a nil-superclass class.
     If the CreateMinimumProtocolInNewSubclassQuery answers true,
     entries for the minimum required protocol (#class, #isBehavior
     and #doesNotUnderstand:) are also automatically created.
     (this query is typically answered by the browser)
     These are required to avoid getting into deep trouble when
     inspecting or debugging instances of this new class.
     The methods get a modified source code to remind you that these
     methods were automatically generated."

    |newClass methodDict method|

    Class withoutUpdatingChangesDo:[
        newClass := action value
    ].
    newClass notNil ifTrue:[
        newClass setSuperclass:nil.
        newClass class setSuperclass:Class.

        newClass hasMethods ifFalse:[
            Class addChangeRecordForClass:newClass.

            CreateMinimumProtocolInNewSubclassQuery query
            ifTrue:[
                "
                 copy over method objects from Object
                 and modify the source code
                "
                methodDict := MethodDictionary new:3.
                #(#class #isBehavior #doesNotUnderstand:) do:[:sel|
                    method := (Object compiledMethodAt:sel) copy.
                    method source: method source , '
"
*** WARNING
***
*** this method has been automatically created,
*** since all nil-subclasses should respond to some minimum required
*** protocol.
***
*** Inspection and/or debugging of instances may not be possible,
*** if you remove/change this method. 
"
'.
                    methodDict at:sel put:method.
"/                    newClass addChangeRecordForMethod:method
                ].
                newClass methodDictionary:methodDict.
            ]
        ]
    ].
    ^ newClass

    "Modified: / 3.1.1997 / 15:53:21 / cg"
    "Created: / 3.1.1997 / 16:00:34 / cg"
    "Modified: / 18.3.1999 / 18:29:58 / stefan"
!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool
    "create a new class which has nil as superclass
     - i.e. traps into #doesNotUnderstand: for all of its messages."

    "this method allows fileIn of ST/V and V'Age classes
     (which seem to have no category)"

    ^ self
        subclass:nameSymbol
        instanceVariableNames:instVarNameString
        classVariableNames:classVarString
        poolDictionaries:pool
        category:(Class defaultCategoryForSTVorVAGEClasses).
!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class which has nil as superclass
     - i.e. traps into #doesNotUnderstand: for all of its messages."

    ^ self
        nilSubclass:[
                Object class
                    name:nameSymbol
                    inEnvironment:(Class nameSpaceQuerySignal query)
                    subclassOf:self
                    instanceVariableNames:instVarNameString
                    variable:false
                    words:true
                    pointers:true
                    classVariableNames:classVarString
                    poolDictionaries:pool
                    category:cat
                    comment:nil
                    changed:true
        ]

    "Modified: / 3.1.1997 / 16:00:39 / cg"
    "Modified: / 18.3.1999 / 18:30:07 / stefan"
!

variableByteSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class which has nil as superclass
     - i.e. traps into #doesNotUnderstand: for all of its messages."

    ^ self
        nilSubclass:[
                Object class
                    name:nameSymbol  
                    inEnvironment:(Class nameSpaceQuerySignal query)
                    subclassOf:self
                    instanceVariableNames:instVarNameString
                    variable:true
                    words:false
                    pointers:false
                    classVariableNames:classVarString
                    poolDictionaries:pool
                    category:cat
                    comment:nil
                    changed:true
        ]

    "Modified: / 3.1.1997 / 16:00:42 / cg"
    "Modified: / 18.3.1999 / 18:30:11 / stefan"
!

variableSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class which has nil as superclass
     - i.e. traps into #doesNotUnderstand: for all of its messages."

    ^ self
        nilSubclass:[
                Object class
                    name:nameSymbol
                    inEnvironment:(Class nameSpaceQuerySignal query)
                    subclassOf:self
                    instanceVariableNames:instVarNameString
                    variable:true
                    words:false
                    pointers:true
                    classVariableNames:classVarString
                    poolDictionaries:pool
                    category:cat
                    comment:nil
                    changed:true
        ]

    "Modified: / 3.1.1997 / 16:00:45 / cg"
    "Modified: / 18.3.1999 / 18:30:16 / stefan"
! !

!UndefinedObject methodsFor:'subclass creation-private'!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:ownerClassArg
    "create a new private class which has nil as superclass
     - i.e. traps into #doesNotUnderstand: for all of its messages."

    |category ownerClass|
    
    (ownerClass := ownerClassArg) isNil ifTrue:[
        self error:'Nil (undefined) owner class - proceed to define as global' mayProceed:true.
    ] ifFalse:[
        category := ownerClassArg category
    ].

    ^ self
        nilSubclass:[
                Object class
                    name:nameSymbol
                    inEnvironment:ownerClass
                    subclassOf:self
                    instanceVariableNames:instVarNameString
                    variable:false
                    words:true
                    pointers:true
                    classVariableNames:classVarString
                    poolDictionaries:pool
                    category:category
                    comment:nil
                    changed:true
        ]

    "Modified: / 3.1.1997 / 16:00:39 / cg"
    "Modified: / 18.3.1999 / 18:30:07 / stefan"
! !

!UndefinedObject methodsFor:'testing'!

? defaultValue
     "a syntactic sugar-piece:
      if the receiver is nil, return the defaultValue;
      otherwise, return the receiver.
      This method is redefined from Object;
      the argument is returned unconditionally here.

      Thus, if foo and bar are simple variables or constants,
          foo ? bar
      is the same as:
          (foo isNil ifTrue:[bar] ifFalse:[foo])

      if they are message sends, the equivalent code is:
          [
              |t1 t2|

              t1 := foo.
              t2 := bar.
              t1 isNil ifTrue:[t2] ifFalse:[t1]
          ] value

      Can be used to provide defaultValues to variables,
      as in:
          foo := arg ? #defaultValue
     "

    ^ defaultValue

    "
     1 ? #default
     nil ? #default
    "

    "Created: / 4.11.1996 / 20:37:09 / cg"
    "Modified: / 19.5.1998 / 17:39:36 / cg"
!

?+ aOneArgBlock
     "a syntactic sugar-piece:
      aOneArgBlock is executed with self as argument
      if self is not nil.

      Note: this method should never be redefined in classes other than UndefinedObject.
     "

    ^ self
!

?? defaultValue
     "a syntactic sugar-piece:
      much like ?, but sends value to the argument if required.
      If the receiver is nil, return the defaultValues value;
      otherwise, return the receiver.
      This method is redefined from Object.

      Thus, if foo and bar are simple variables or constants,
          foo ?? bar
      is the same as:
          (foo isNil ifTrue:[bar value] ifFalse:[foo])

      if they are message sends, the equivalent code is:
          [
              |t|

              t := foo.
              t isNil ifTrue:[bar value] ifFalse:[t]
          ] value

      Can be used to provide defaultValues to variables,
      as in:
          foo := arg ?? [something]
     "

    ^ defaultValue value

    "
     1 ?? #default
     nil ?? #default
     1 ?? [Date today]
     nil ?? [Date today]
    "

    "Created: / 4.11.1996 / 20:37:09 / cg"
    "Modified: / 19.5.1998 / 17:42:10 / cg"
!

checkNilFileStream
    "Do nothing if this is a valid FileStream
     (i.e. the previous open operation was successful).
     Also implemented in UndefinedObject, to raise an Error there.

     This is an aid for converting from the old error reporting (returning nil)
     to the new error reporting (with real Exceptions).

     It will vanish as soon as the conversion has been done"

    ^ OpenError raise
!

hash
    "return an integer useful as a hash key"

    ^ 0
!

identityHash
    "return an integer useful as a hash key"

    ^ 0
!

ifNil:aBlockOrValue
    "return myself, or the result from evaluating the argument, if I am nil.
     This is much like #?, but sends #value to the argument in case of a nil
     receiver.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ aBlockOrValue value
!

ifNil:nilBlockOrValue ifNotNil:notNilBlockOrValue
    "return the value of the first arg, if I am nil,
     the result from evaluating the 2nd argument, if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ nilBlockOrValue value
!

ifNotNil:aBlockOrValue
    "return myself if nil, or the result from evaluating the argument, if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ nil
!

ifNotNil:notNilBlockOrValue ifNil:nilBlockOrValue
    "return the value of the 2nd arg, if I am nil,
     the result from evaluating the 1st argument, if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ nilBlockOrValue value
!

ifNotNilDo:aBlock
    "if the receiver is non-nil, return the value of aBlock, passing myself as argument.
     Otherwise do nothing and return nil."

    ^ nil
!

isEmptyOrNil
    "return true if I am nil or an empty collection
     - since I am nil, return true. (from Sqeak)"

    ^ true

    "Created: / 13-11-2001 / 13:16:40 / cg"
    "Modified (comment): / 17-08-2011 / 09:29:30 / cg"
!

isLiteral
    "return true if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true
!

isNil
    "Return true if the receiver is nil.
     Since I am definitely nil, unconditionally return true here.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ true
!

isNilOrEmptyCollection
    "return true if I am nil or an empty collection - false here.
     Obsolete, use isEmptyOrNil."

    <resource:#obsolete>

    ^ true

    "Modified: / 13.11.2001 / 13:28:15 / cg"
!

isNotNil
    <resource: #obsolete>

    "Return true if the receiver is not nil.
     Since I am definitely nil, unconditionally return false here.
     the receiver is definitely not nil here, so unconditionally return false."

    self obsoleteMethodWarning:'use #notNil'.
    ^ false

    "Created: / 26-10-2014 / 01:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notEmptyOrNil
    "Squeak compatibility:
     return true if I am neither nil nor an empty collection."

    ^ false
!

notNil
    "Return true if the receiver is not nil.
     Since I am definitely nil, unconditionally return false here.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ false
! !

!UndefinedObject methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceUndefinedObject:self level:level from:referrer


! !

!UndefinedObject methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitNil:with: to aVisitor."

    ^ aVisitor visitNilWith:aParameter
! !


!UndefinedObject class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


UndefinedObject initialize!
