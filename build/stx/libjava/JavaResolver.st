"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaResolver
	instanceVariableNames:'exceptionThrower'
	classVariableNames:'uniqueInstance'
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaResolver class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaResolver class methodsFor:'initialization'!

initialize
    uniqueInstance := JavaResolver new.
    uniqueInstance exceptionThrower: JavaVM.

    "/has methods at: and at: put: 
    "/uniqueInstance resolvedClasses: Java.

    "Modified: / 10-04-2011 / 10:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2011 / 14:07:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver class methodsFor:'instance creation'!

uniqueInstance
    ^uniqueInstance.

    "Created: / 08-04-2011 / 17:36:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 11-04-2011 / 19:06:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver methodsFor:'accessing'!

exceptionThrower
    ^ exceptionThrower
!

exceptionThrower:something
    exceptionThrower := something.
! !

!JavaResolver methodsFor:'class resolving'!

checkIfPrimitiveArrayRef: aJavaClassRef andWrap: result 

    ^ (JavaDescriptor readFromString: aJavaClassRef name) javaClass.

    "Created: / 23-05-2011 / 21:12:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

resolveClassIndentifiedByRef: aJavaClassRef init: doInit 
    "marcel is back working harder then ever :)"
    
    | result |
    self validateClassRef: aJavaClassRef.
    result := self 
         lookupClassIfAlreadyResolved: aJavaClassRef javaClassNameOrPrimitiveTypeId
         definedBy: aJavaClassRef classLoader.
            
"/        result notNil ifTrue:[ 
"/            "/wrap result with array(s) if needed and return it
"/            "/FIXME: Marcel, can you have a look? Is that correct?
"/            ^self checkIfArrayRef: aJavaClassRef andWrap: result.
"/        ].
    "
     To resolve an unresolved symbolic reference from D to a class or interface C denoted by N,
     the following steps are performed:
     The defining class loader of D is used to create a class or interface denoted by N.
     This class or interface is C. Any exception that can be thrown as a result of failure
     of class or interface creation can thus be thrown as a result of failure of class and
     interface resolution. The details of the process are given in Section 5.3.
    "
    result isNil ifTrue: [
        JavaClassReader classLoaderQuerySignal answer: (aJavaClassRef classLoader)
            do: [
                "#loadUnresolvedClass: wraps the class!!!!!!"
                result := self loadUnresolvedClass: aJavaClassRef.
                ((aJavaClassRef name first == $[) and: [ result isJavaArrayClass not ]) ifTrue: [
                    self breakPoint: #jv.
                ]
            ].
    ] ifFalse: [ result := self checkIfArrayRef: aJavaClassRef andWrap: result. ].
    result isNil ifTrue: [ self breakPoint: #mh ].
    result isJavaPrimitiveType ifTrue: [
        ^ self checkIfPrimitiveArrayRef: aJavaClassRef andWrap: result
    ].
    (doInit and: [ result isJavaClass and: [ result isJavaArrayClass not ] ]) ifTrue: [
        result classInit
    ].
     "
     If C is an array class and its element type is a reference type, then the symbolic reference
     to the class or interface representing the element type is resolved by invoking the algorithm
     in Section 5.4.3.1 recursively.""Finally, access permissions to C are checked:
     If C is not accessible (5.4.4) to D, class or interface resolution throws an IllegalAccessError.
     This condition can occur, for example, if C is a class that was originally declared to be
     public but was changed to be non-public after D was compiled.
     
     If steps 1 and 2 succeed but step 3 fails, C is still valid and usable. Nevertheless, resolution
     fails, and D is prohibited from accessing C." 

    (self checkPermissionsFrom: aJavaClassRef owner to: result) ifFalse: [
        self throwIllegalAccessError. 
        ^nil.
    ].
    ^result

    "Created: / 11-04-2011 / 19:07:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 12-08-2011 / 22:19:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-10-2011 / 23:03:01 / m"
    "Modified: / 01-12-2012 / 13:44:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 05-10-2013 / 01:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaResolver methodsFor:'class resolving helpers'!

checkIfArrayRef: aJavaClassRef andWrap: nonArrayClass 

    "/wrap result with array(s) if needed and return it
    | class|    
    class := nonArrayClass.
    aJavaClassRef name do:[:c|
        c ~~ $[ ifTrue:[ ^ class ].
        class := class javaArrayClass.
    ].
    ^class

    "Modified: / 11-04-2011 / 19:31:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-10-2011 / 23:46:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkPermissionsFrom: refOwner to: resolvedClass    
    refOwner hasMagicAccessRights ifTrue: [ ^ true ].
    resolvedClass isJavaClass ifFalse:[ ^ true ].
    (JavaDescriptor isJavaPrimitiveArrayName: resolvedClass javaName) ifTrue: [
        ^ true
    ].
    resolvedClass isPublic ifTrue: [ ^ true ].
    resolvedClass classLoader = refOwner classLoader ifFalse: [ ^ false. ].
    refOwner javaPackage = resolvedClass javaPackage ifTrue: [ ^ true ].
    
    "/a little bit too verbose here just so it's clear what's in query
    
    JavaVM privilegedAccessQuery query ifTrue: [ ^ true ] ifFalse: [ ^ false ].

    "Created: / 11-04-2011 / 19:35:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 09-10-2011 / 23:11:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 23-08-2012 / 20:21:40 / m"
    "Modified: / 30-11-2012 / 20:34:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-11-2013 / 16:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadUnresolvedClass: aJavaClassRef 
    | nm cls i |

    nm := aJavaClassRef name.
    nm size == 1 ifTrue:[ 
        JavaDescriptor baseTypes at: nm first ifPresent: [:cls | ^ cls ] 
    ].
    "Note, that JavaVM>>classForName: itself deals with class loaders.
     The caller of me should set one using code like:
     
     JavaClassReader classLoaderQuerySignal answer: loader do:[call me]     
    "
    cls := JavaVM classForName: nm.
    (nm startsWith:$[) ifTrue:[
        i := 1.
        [ (nm at:i) == $[ ] whileTrue:[
            cls := cls javaArrayClass.
            i := i + 1.                                        
        ].
        self assert: (nm at:i) == $L.
    ].

    ^cls.

    "Created: / 11-04-2011 / 19:27:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 21:06:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 29-02-2012 / 09:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupClassIfAlreadyResolved: javaClassName definedBy: classLoader
    ^ JavaVM classNamed: javaClassName definedBy: classLoader

    "Created: / 02-05-2013 / 01:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateClassRef: aJavaClassRef 
    self assert: aJavaClassRef isJavaRef.
    self assert: aJavaClassRef isJavaClassRef .

    "Modified: / 23-05-2011 / 21:04:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver methodsFor:'common helpers'!

checkPermissionsForMethodOrField: aJavaMethodOrField from: accessingJavaClass to: resolvedJavaClass 
    "A class or interface C is accessible to a class or interface D if 
     and only if either of the following conditions are true:
     C is public.
     C and D are members of the same runtime package (Â§5.3).
     A field or method R is accessible to a class or interface D if and only
     if any of the following conditions is true:
     R is public.
     R is protected and is declared in a class C, and D is either a subclass
     of C or C itself.
     R is either protected or package private (that is, neither public nor
     protected nor private), and is declared by a class in the same runtime
     package as D.
     R is private and is declared in D.
     This discussion of access control omits a related restriction on the target
     of a protected field access or method invocation (the target must be of class
     D or a subtype of D). That requirement is checked as part of the verification
     process (Â§5.4.1); it is not part of link-time access control."

    accessingJavaClass hasMagicAccessRights ifTrue: [ ^true ].

    (self checkPermissionsFrom: accessingJavaClass to: resolvedJavaClass) ifFalse: [
        JavaVM privilegedAccessQuery query ifTrue: [ ^ true ].
        ^ false
    ].
    aJavaMethodOrField isPublic ifTrue: [ ^ true ].
    ((aJavaMethodOrField isProtected 
        and: [
            resolvedJavaClass javaComponentClass 
                equalsOrIsSubclassOf: aJavaMethodOrField javaClass
        ]) 
            and: [
                accessingJavaClass javaComponentClass 
                    equalsOrIsSubclassOf: aJavaMethodOrField javaClass
            ]) 
            ifTrue: [ ^ true ].
    ((
    aJavaMethodOrField isPrivate not 
        and: [ resolvedJavaClass javaPackage = accessingJavaClass javaPackage ]) 
            and: [ resolvedJavaClass classLoader = accessingJavaClass classLoader ]) 
            ifTrue: [ ^ true ].
    (aJavaMethodOrField isPrivate 
        and: [ aJavaMethodOrField javaClass name = accessingJavaClass name ]) 
            ifTrue: [ ^ true ].
    
    "/a little bit too verbose here just so it's clear what's in query
    
    JavaVM privilegedAccessQuery query ifTrue: [ ^ true ] ifFalse: [ ^ false ].

    "Created: / 14-04-2011 / 14:19:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 09-10-2011 / 23:12:48 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 18-11-2012 / 16:24:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 15-09-2013 / 00:09:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaResolver methodsFor:'exceptions'!

throwAbstractMethodError
    exceptionThrower throwAbstractMethodError.

    "Created: / 11-04-2011 / 20:19:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:07:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIllegalAccessError
    exceptionThrower throwIllegalAccessError.

    "Created: / 11-04-2011 / 19:39:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 23:06:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIncompatibleClassChangeError
    exceptionThrower throwIncompatibleClassChangeError.

    "Created: / 11-04-2011 / 20:02:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:07:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNoSuchFieldException
    exceptionThrower throwNoSuchFieldException.

    "Created: / 11-04-2011 / 21:35:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:07:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNoSuchMethodError
    exceptionThrower throwNoSuchMethodError.

    "Created: / 11-04-2011 / 20:19:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:08:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver methodsFor:'field resolving'!

resolveFieldIndentifiedByRef:aJavaFieldRef 
    | result  class |

    self validateFieldRef:aJavaFieldRef.
    result := self lookupFieldIfAlreadyResolved:aJavaFieldRef.
    result notNil ifTrue:[
        ^ result
    ].
    class := aJavaFieldRef classRef resolve:false.
    class isNil ifTrue:[
        self error:'should not happen - tell mh'
    ].
    result := class lookupFieldByNameAndType:aJavaFieldRef nameAndType.
    result isNil ifTrue:[
        self throwNoSuchFieldException
    ].
    (self 
        checkPermissionsForField:result
        from:aJavaFieldRef classRef owner
        to:class) ifFalse:[ self throwIllegalAccessError ].
    ^ result.

    "
     To resolve an unresolved symbolic reference from D to a field in a class
     or interface C, the symbolic reference to C given by the field reference
     must first be resolved (§5.4.3.1). Therefore, any exception that can be
     thrown as a result of failure of resolution of a class or interface reference
     can be thrown as a result of failure of field resolution. If the reference
     to C can be successfully resolved, an exception relating to the failure of
     resolution of the field reference itself can be thrown.
     When resolving a field reference, field resolution first attempts to look
     up the referenced field in C and its superclasses:

     If C declares a field with the name and descriptor specified by the field
     reference, field lookup succeeds. The declared field is the result of the
     field lookup.

     Otherwise, field lookup is applied recursively to the direct superinterfaces
     of the specified class or interface C.

     Otherwise, if C has a superclass S, field lookup is applied recursively to S.

     Otherwise, field lookup fails.
     If field lookup fails, field resolution throws a NoSuchFieldError. Otherwise,
     if field lookup succeeds but the referenced field is not accessible (§5.4.4)
     to D, field resolution throws an IllegalAccessError.
     Otherwise, let <E, L1> be the class or interface in which the referenced
     field is actually declared and let L2 be the defining loader of D. Let T be
     the name of the type of the referenced field. The Java virtual machine must
     impose the loading constraint that TL1=TL2(§5.3.4)."

    "Created: / 11-04-2011 / 21:15:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:45:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveStaticFieldIndentifiedByRef:aJavaFieldRef 
    | result  class |

    self validateFieldRef:aJavaFieldRef.
    result := self lookupFieldIfAlreadyResolved:aJavaFieldRef.
    result notNil ifTrue:[
        ^ result
    ].
    class := aJavaFieldRef classRef resolve:false.
    class isNil ifTrue:[
        self error:'should not happen - tell mh'
    ].
    result := class lookupStaticFieldByNameAndType:aJavaFieldRef nameAndType.
    result isNil ifTrue:[
        self throwNoSuchFieldException
    ].
    (self 
        checkPermissionsForField:result
        from:aJavaFieldRef classRef owner
        to:class) ifFalse:[ self throwIllegalAccessError ].
    ^ result.

    "
     To resolve an unresolved symbolic reference from D to a field in a class
     or interface C, the symbolic reference to C given by the field reference
     must first be resolved (§5.4.3.1). Therefore, any exception that can be
     thrown as a result of failure of resolution of a class or interface reference
     can be thrown as a result of failure of field resolution. If the reference
     to C can be successfully resolved, an exception relating to the failure of
     resolution of the field reference itself can be thrown.
     When resolving a field reference, field resolution first attempts to look
     up the referenced field in C and its superclasses:

     If C declares a field with the name and descriptor specified by the field
     reference, field lookup succeeds. The declared field is the result of the
     field lookup.

     Otherwise, field lookup is applied recursively to the direct superinterfaces
     of the specified class or interface C.

     Otherwise, if C has a superclass S, field lookup is applied recursively to S.

     Otherwise, field lookup fails.
     If field lookup fails, field resolution throws a NoSuchFieldError. Otherwise,
     if field lookup succeeds but the referenced field is not accessible (§5.4.4)
     to D, field resolution throws an IllegalAccessError.
     Otherwise, let <E, L1> be the class or interface in which the referenced
     field is actually declared and let L2 be the defining loader of D. Let T be
     the name of the type of the referenced field. The Java virtual machine must
     impose the loading constraint that TL1=TL2(§5.3.4)."

    "Created: / 28-04-2011 / 22:31:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:45:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:52:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaResolver methodsFor:'field resolving-helpers'!

checkPermissionsForField: aJavaField from: accessingJavaClass to: resolvedJavaClass     
    ^ self 
        checkPermissionsForMethodOrField: aJavaField
        from: accessingJavaClass
        to: resolvedJavaClass.

    "Created: / 11-04-2011 / 21:46:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:45:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupFieldIfAlreadyResolved: aJavaFieldRef 
    ^ nil.

    "Created: / 11-04-2011 / 21:16:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 11:57:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

validateFieldRef: aJavaFieldRef 
    aJavaFieldRef isJavaRef ifFalse: [ self halt: 'I expected Java Ref' ].
    aJavaFieldRef isJavaFieldRef ifFalse: [
        self error: 'I expected Java Field Ref'
    ].

    "Created: / 11-04-2011 / 21:16:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:46:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver methodsFor:'method resolving'!

resolveInterfaceMethodIdentifiedByRef: aJavaInterfaceMethodRef 
    | result  class search selector |
    self validateInterfaceMethodRef: aJavaInterfaceMethodRef.
    class := aJavaInterfaceMethodRef classRef resolve: false.
    class isNil ifTrue: [ 
        self error: 'should not happen - tell mh' 
    ].
    "Array types responds to all method of class java.lang.Object"
    class isJavaArrayClass ifTrue:[
        class := JavaVM classForName:'java.lang.Object'.
    ].
    class isInterface ifFalse: [ self throwIncompatibleClassChangeError ].

    search := class.
    selector := aJavaInterfaceMethodRef nameAndType selector.
    [ search notNil and:[result isNil] ] whileTrue:[
        result := search compiledMethodAt: selector.
        search := search superclass.
    ].  
    result isNil ifTrue:[ 
        | queue |

        queue := OrderedCollection withAll: class allInterfaces.
        [ result isNil and:[queue notEmpty ] ] whileTrue:[ 
            search := queue removeFirst.
            result := search compiledMethodAt: selector.
            result isNil ifTrue:[ 
                search interfaces do:[:interface | 
                    (queue includes: interface) ifFalse:[ queue add: interface ].
                ].
            ].
        ].
    ].  
    result isNil ifTrue: [ self throwNoSuchMethodError ].
    (self 
        checkPermissionsForMethod: result
        from: aJavaInterfaceMethodRef classRef owner
        to: class) ifFalse: [ self throwIllegalAccessError ].
    ^ result.

    "
     To resolve an unresolved symbolic reference from D to an interface method in an
     interface C, the symbolic reference to C given by the interface method reference is
     first resolved (§5.4.3.1). Therefore, any exceptions that can be thrown as a result
     of failure of resolution of an interface reference can be thrown as a result of
     failure of interface method resolution. If the reference to C can be successfully
     resolved, exceptions relating to the resolution of the interface method reference
     itself can be thrown.
     When resolving an interface method reference:

     If C is not an interface, interface method resolution throws an IncompatibleClassChangeError."
    "Otherwise, if the referenced method does not have the same name and descriptor as
a method in C or in one of the superinterfaces of C, or in class Object, interface
method resolution throws a NoSuchMethodError.
Otherwise, let <E, L1> be the interface in which the referenced interface method is
actually declared and let L2 be the defining loader of D. Let T0 be the name of
the type returned by the referenced method, and let T1, ..., Tn be the names of the
argument types of the referenced method. The Java virtual machine must impose the
loading constraints TiL1 = TiL2 for i = 0 to n (§5.3.4)."

    "Modified: / 01-12-2012 / 13:46:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2016 / 22:18:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveMethodIndentifiedByRef:aJavaMethodRef 
    | result class selector search |

    self validateMethodRef:aJavaMethodRef.

    class := aJavaMethodRef classRef resolve:false.
    class isNil ifTrue:[
        self error:'should not happen - tell mh'
    ].
    "Array types responds to all method of class java.lang.Object"
    class isJavaArrayClass ifTrue:[
        class := JavaVM classForName:'java.lang.Object'.
    ].
     "
     To resolve an unresolved symbolic reference from D to a method in
     a class C, the symbolic reference to C given by the method reference
     is first resolved (5.4.3.1). Therefore, any exceptions that can be
     thrown due to resolution of a class reference can be thrown as a result
     of method resolution. If the reference to C can be successfully resolved,
     exceptions relating to the resolution of the method reference itself
     can be thrown.
     When resolving a method reference:
     
     Method resolution checks whether C is a class or an interface.
     If C is an interface, method resolution throws an IncompatibleClassChangeError."
    class isInterface ifTrue:[
        self throwIncompatibleClassChangeError
    ].
    "Method resolution attempts to look up the referenced method in C and its
     superclasses:
     If C declares a method with the name and descriptor specified by the method
     reference, method lookup succeeds.
     Otherwise, if C has a superclass, step 2 of method lookup is recursively
     invoked on the direct superclass of C."
    search := class.
    selector := aJavaMethodRef nameAndType selector.
    [ search notNil and:[result isNil] ] whileTrue:[
        result := search compiledMethodAt: selector.
        search := search superclass.
    ].
    "Otherwise, method lookup attempts to locate the referenced method in any of
     the superinterfaces of the specified class C.
     If any superinterface of C declares a method with the name and descriptor
     specified by the method reference, method lookup succeeds."
    result isNil ifTrue:[ 
        | queue |

        queue := OrderedCollection withAll: class allInterfaces.
        [ result isNil and:[queue notEmpty ] ] whileTrue:[ 
            search := queue removeFirst.
            result := search compiledMethodAt: selector.
            result isNil ifTrue:[ 
                search interfaces do:[:interface | 
                    (queue includes: interface) ifFalse:[ queue add: interface ].
                ].
            ].
        ].
    ].
    "Otherwise, method lookup fails.
     If method lookup fails, method resolution throws a NoSuchMethodError. If method
     lookup succeeds and the method is abstract, but C is not abstract, method resolution
     throws an AbstractMethodError. Otherwise, if the referenced method is not accessible
     (�5.4.4) to D, method resolution throws an IllegalAccessError."
    result isNil ifTrue:[
        self throwNoSuchMethodError
    ].
    (result isAbstract 
        and:[ result javaClass isInterface not and:[ class isAbstract not ] ]) 
            ifTrue:[ self throwAbstractMethodError ].
    (self 
        checkPermissionsForMethod:result
        from:aJavaMethodRef classRef owner
        to:class) ifFalse:[ self throwIllegalAccessError ].
    ^ result.

    "Otherwise, let <E, L1> be the class or interface in which the referenced method is
     actually declared and let L2 be the defining loader of D. Let T0 be the name of
     the type returned by the referenced method, and let T1, ..., Tn be the names of
     the argument types of the referenced method. The Java virtual machine must impose
     the loading constraints TiL1=TiL2 for i = 0 to n (Â§5.3.4)."

    "Created: / 11-04-2011 / 19:45:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 00:01:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 01-12-2012 / 13:46:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2016 / 22:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaResolver methodsFor:'method resolving-helpers'!

checkPermissionsForMethod: aJavaMethod from: accessingJavaClass to: resolvedJavaClass    
    ^ self 
        checkPermissionsForMethodOrField: aJavaMethod
        from: accessingJavaClass
        to: resolvedJavaClass.

    "Created: / 11-04-2011 / 20:20:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 24-05-2011 / 14:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2012 / 23:15:48 / mh <hlopik@gmail.com>"
    "Modified: / 01-12-2012 / 13:46:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

validateInterfaceMethodRef: aJavaInterfaceMethodRef 
    aJavaInterfaceMethodRef isJavaRef ifFalse: [
        self error: 'I expected JavaRef instance as an argument'
    ].
    aJavaInterfaceMethodRef isJavaInterfaceMethodRef ifFalse: [
        self error: 'I expected JavaMethodRef instance as an argument'
    ].

    "Created: / 13-04-2011 / 11:53:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:46:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

validateMethodRef: aJavaMethodRef 
    aJavaMethodRef isJavaRef ifFalse: [
        self error: 'I expected JavaRef instance as an argument'
    ].
    aJavaMethodRef isJavaMethodRef ifFalse: [
        self error: 'I expected JavaMethodRef instance as an argument'
    ].

    "Created: / 11-04-2011 / 19:47:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2012 / 13:47:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaResolver class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaResolver.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaResolver initialize!
