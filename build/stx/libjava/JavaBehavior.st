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

Class subclass:#JavaBehavior
	instanceVariableNames:'constantPool interfaces accessFlags initValues lock'
	classVariableNames:'InitialValuePerType ACX_ABSTRACT_OR_INTERFACE'
	poolDictionaries:'JavaConstants JavaVMData'
	category:'Languages-Java-Classes'
!

!JavaBehavior class methodsFor:'documentation'!

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
!

documentation
"
    A base class for all Java classes. Slots & behavior defined here
    is known to the VM. Do not change the order of slots and
    add only to the end. You will have to modify stc.h then.

    Non-VM known stuff could be added to JavaClass safely.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        constantPool
        interfaces
        accessFlags
    [class variables:]

    [see also:]

"
! !

!JavaBehavior class methodsFor:'initialization'!

initialize

    "/ Cannot do this as the constant pool may not be initialized
    "/ACX_ABSTRACT_OR_INTERFACE := ACC_ABSTRACT bitOr:ACC_INTERFACE.
    ACX_ABSTRACT_OR_INTERFACE := 16r0000400 bitOr: 16r0000200.

    InitialValuePerType := IdentityDictionary new.
    InitialValuePerType at:$B put:0.
    InitialValuePerType at:$C put:0.
    InitialValuePerType at:$D put:0.0.
    InitialValuePerType at:$F put:(0.0 asShortFloat).
    InitialValuePerType at:$I put:0.
    InitialValuePerType at:$J put:0.
    InitialValuePerType at:$S put:0.
    InitialValuePerType at:$Z put:0.
    InitialValuePerType at:$L put:nil.
    InitialValuePerType at:$[ put:nil.

    "
     JavaBehavior initialize
    "

    "Modified: / 13-11-1998 / 14:09:52 / cg"
    "Modified: / 11-02-2012 / 16:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior class methodsFor:'constants'!

ACC_NATIVE
    ^ ACC_NATIVE

    "Created: / 16.5.1998 / 01:18:43 / cg"
!

ACC_PUBLIC
    ^ ACC_PUBLIC

    "Created: / 13.5.1998 / 13:03:18 / cg"
!

ACC_STATIC
    ^ ACC_STATIC

    "Created: / 16.5.1998 / 00:02:07 / cg"
! !

!JavaBehavior class methodsFor:'signature parsing'!

initialValueFromSignature:aSignature
    "given a signature, return an initializer value"

    |s|

    s := aSignature readStream.
    ^ self initialValueFromStream:s.

    "
     JavaBehavior initialValueFromSignature:'LObject;'
     JavaBehavior initialValueFromSignature:'B'
     JavaBehavior initialValueFromSignature:'I'
    "
!

initialValueFromStream:s
    "parse a fieldTypeSpec - see java doc"

    |typeChar|

    typeChar := s next.
    ^ InitialValuePerType at:typeChar ifAbsent:nil.
! !

!JavaBehavior methodsFor:'accessing'!

accessFlags
    ^ accessFlags
!

constantPool
    ^ constantPool
!

interfaceNames
    "Returns set of intefaces as java names (dotted)"

    | cp |

    cp := self constantPool.
    interfaces notNil ifTrue:[
         ^ interfaces collect:[:ifaceRefIndex | | ifaceRef | ifaceRef := cp at: ifaceRefIndex. ifaceRef isJavaClassRef ifTrue:[ifaceRef javaClassName] ifFalse:[ifaceRef javaName]].
    ].
    ^ #()

    "Created: / 13-02-2013 / 09:33:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2014 / 17:00:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interfaces
    | cp |

    cp := self constantPool.
    interfaces notNil ifTrue:[ 
        ^ interfaces collect: [:ifaceRefIndex | (cp at: ifaceRefIndex) javaClass ] 
    ].

    ^ #()

    "Modified: / 27-11-2014 / 16:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior methodsFor:'accessing-Java'!

getJavaLockWord
    <resource: #obsolete>

    self obsoleteFeatureWarning: 'Should no longer be sent'.      
    ^ lock getJavaLockWord

    "Created: / 26-08-2012 / 14:03:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2016 / 00:03:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getJavaMonitor
    <resource: #obsolete>
    "Returns fat JavaMonitor associated with the receiver"

    self obsoleteMethodWarning: 'Should no longer be sent'.      

    "/ For Java objects, check if there is already a thinlock,
    "/ inflate it and return the fatlock
    _lockWord_ class == SmallInteger ifTrue:[
        _lockWord_ := JavaVM inflateLockFor: self lockword: _lockWord_.
    ].
    ^_lockWord_

    "Created: / 26-08-2012 / 18:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:28:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior methodsFor:'compiler interface'!

programmingLanguage

    ^JavaLanguage instance

    "Created: / 26-10-2010 / 23:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior methodsFor:'private accessing'!

getInterfaces
    ^ interfaces

    "Created: / 15-09-2013 / 00:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasMultipleVersions
    "
    return true if this class has multiple coexisting versions
    "
    ^ ((accessFlags bitAnd:ACX_HASMULTIVERS) == 0) not.

    "Created: / 02-10-2013 / 21:48:24 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 28-10-2013 / 13:01:32 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

makeObsolete
    accessFlags := accessFlags bitOr:ACC_OBSOLETE

    "Created: 7.8.1997 / 19:04:48 / cg"
!

markMultipleVersions
    "
     mark this class non cacheable - references to this class have to be
     resolved over and over again, cannot be cached."
    
    self hasMultipleVersions not ifTrue: [
        accessFlags := accessFlags bitXor: ACX_HASMULTIVERS
    ].

    "Created: / 14-04-2013 / 14:17:38 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 28-10-2013 / 14:07:35 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

markNonMultipleVersions
    "
     mark this class cacheable - references to this class dont have to be
     resolved over and over again, can be cached."
    
    self hasMultipleVersions ifTrue: [
        accessFlags := accessFlags bitXor: ACX_HASMULTIVERS
    ].

    "Created: / 14-04-2013 / 14:25:23 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 28-10-2013 / 14:07:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

markUninitialized
    (accessFlags bitAnd:ACX_INITIALIZED) ~~ 0 ifTrue:[
	accessFlags := accessFlags bitXor:ACX_INITIALIZED
    ].
!

setAccessFlags:flags
    accessFlags := flags.

    "Created: 15.4.1996 / 16:42:52 / cg"
!

setConstantPool:aJavaConstantPool 
    constantPool := aJavaConstantPool.
    constantPool notNil ifTrue:[
        constantPool owner:self
    ].

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Modified: / 04-08-2014 / 15:51:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInterfaces:aCollection
    interfaces := aCollection asNilIfEmpty

    "Modified: / 07-04-1997 / 15:44:53 / cg"
    "Modified: / 05-05-2014 / 09:44:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setMethodDictionary:dict constantPool:aJavaConstantPool 
    | methodDictionaryToSet |
    dict class ~~ MethodDictionary ifTrue:[
        methodDictionaryToSet := MethodDictionary withAll:dict.
        methodDictionaryToSet isNil ifTrue:[

            "/ refuse to do this
            "/ (can only happen in case of memory allocation trouble,
            "/  where the allocation failed and some exception handler returned
            "/  nil ...)

            self error:'cannot set methodDictionary to nil' mayProceed:true.
            ^ self.
        ]
    ] ifFalse:[
        methodDictionaryToSet := dict.
    ].
    aJavaConstantPool owner:self.

    "/ Now, set it...
    methodDictionary := methodDictionaryToSet.
    constantPool := aJavaConstantPool.

    "Created: / 01-04-2015 / 16:37:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior methodsFor:'queries'!

hasInterface:aJavaInterface
    "return true, if I respond to all methods as
     required by the argument, an aJavaInterface"

    interfaces size > 0 ifTrue:[
	self interfaces do:[:if |
	    aJavaInterface == if ifTrue:[
		^ true
	    ].
	]
    ].
    superclass isJavaClass ifTrue:[
	^ superclass hasInterface:aJavaInterface
    ].
    ^ false.

"/    aJavaInterface methodDictionary keysAndValuesDo:[:sel :mthd |
"/        (self canUnderstand:sel) ifFalse:[
"/            ^ false.
"/        ]
"/    ].
    ^ true

    "Modified: / 28.1.1998 / 01:46:16 / cg"

!

isAbstract
    "return true, if the receiver is abstract
     (i.e. may not have instances)"

    ^ (accessFlags bitAnd:ACC_ABSTRACT) ~~ 0

    "Modified: / 7.5.1998 / 12:24:42 / cg"
!

isAnnotation
    "return true, if the receiver is an interface"

    ^ (accessFlags bitAnd:ACC_ANNOTATION) ~~ 0

    "Modified: / 07-05-1998 / 12:23:39 / cg"
    "Created: / 11-02-2012 / 16:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isEnum
    "return true, if the receiver is an interface"

    ^ (accessFlags bitAnd:ACC_ENUM) ~~ 0

    "Modified: / 07-05-1998 / 12:23:39 / cg"
    "Created: / 11-02-2012 / 16:55:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFinal
    "return true, if the receiver is final
     (i.e. may not be subclassed)"

    ^ (accessFlags bitAnd:ACC_FINAL) ~~ 0

    "Modified: / 7.5.1998 / 12:24:21 / cg"
!

isInitialized
    "return true, if the receiver is initialized"

    ^ (accessFlags bitAnd:ACX_INITIALIZED) ~~ 0

    "Modified: / 7.5.1998 / 12:23:54 / cg"
!

isInterface
    "return true, if the receiver is an interface"

    ^ (accessFlags bitAnd:ACC_INTERFACE) ~~ 0

    "Modified: / 7.5.1998 / 12:23:39 / cg"
!

isObsolete
    "return true, if the receiver is obsolete
     Java classes are never."

    ^ (accessFlags bitAnd:ACC_OBSOLETE) ~~ 0.

    "Modified: 7.8.1997 / 19:04:28 / cg"
!

isPackagePrivate
    ^ (accessFlags bitAnd:ACC_PRIVATE | ACC_PUBLIC | ACC_PROTECTED) = 0

    "Created: / 05-07-2012 / 10:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPrivate
    "return true, if the receiver is an interface"

    ^ (accessFlags bitAnd:ACC_PRIVATE) ~~ 0

    "Modified: / 07-05-1998 / 12:23:39 / cg"
    "Created: / 11-02-2012 / 16:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isProtected
    "return true, if the receiver is an interface"

    ^ (accessFlags bitAnd:ACC_PROTECTED) ~~ 0

    "Modified: / 07-05-1998 / 12:23:39 / cg"
    "Created: / 11-02-2012 / 16:56:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPublic
    "return true, if the receiver is public"

    ^ (accessFlags bitAnd:ACC_PUBLIC) ~~ 0

    "Modified: / 7.5.1998 / 12:22:44 / cg"
!

isSynthetic
    "return true, if the receiver is a synthetic class
     (usually a proxy generated at runtime)"

    ^ (accessFlags bitAnd:ACC_SYNTHETIC) ~~ 0

    "Created: / 13-04-2012 / 18:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior methodsFor:'synchronized evaluation'!

freeSynchronizationSemaphore
    "free synchronizationSemaphore. May be used, to save memory when
     an object is no longer used synchronized."

    ^ self shouldNotImplement

    "
     self synchronized:[].
     self synchronizationSemaphore.
     self freeSynchronizationSemaphore.
    "

    "Created: / 28-01-1997 / 19:31:20 / stefan"
    "Modified: / 08-12-2013 / 22:21:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronizationSemaphore
    "return the synchronization semaphore for myself.
     subclasses may redefine"

    ^ self shouldNotImplement

    "
      self synchronizationSemaphore
    "

    "Modified: / 28-01-1997 / 19:47:09 / stefan"
    "Modified: / 08-12-2013 / 22:21:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronizationSemaphore:aSemaphore
    "set the synchronisationSemaphore for myself.
     subclasses may redefine this method"

    ^ self shouldNotImplement

    "Modified: / 28-01-1997 / 19:37:48 / stefan"
    "Modified: / 08-12-2013 / 22:21:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronized:aBlock
    "Evaluate aBlock synchronized, i.e. use a monitor for this object"

    lock synchronized:  aBlock

    "Created: / 28-01-1997 / 17:52:56 / stefan"
    "Modified: / 30-01-1997 / 13:38:54 / cg"
    "Modified: / 20-02-1997 / 09:43:35 / stefan"
    "Modified: / 12-10-2016 / 00:02:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBehavior class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaBehavior.st,v 1.12 2015-03-20 12:07:59 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaBehavior.st,v 1.12 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaBehavior initialize!
