"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

Method variableSubclass:#LazyMethod
	instanceVariableNames:''
	classVariableNames:'CompilationFailedSignal'
	poolDictionaries:''
	category:'Kernel-Methods'
!

!LazyMethod class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of LazyMethod are created when doing a lazy autoload.
    They do not contain any code (neither byte- nor machinecode), but
    keep their sourcecode only.

    When executed, these will trigger an error in the VM (noByteCode),
    which is caught here to create a real method from the receiver,
    amd re-execute the method.

    This allows faster loading of code, which will be later compiled
    when first executed; for classes with a large number of methods, of
    which only a small subset is actually used, this can also save
    lots of memory (beside making autoloading faster).

    [author:]
        Claus Gittinger

    [see also:]
        Autoload
"
! !

!LazyMethod class methodsFor:'initialization'!

initialize
    CompilationFailedSignal isNil ifTrue:[
        CompilationFailedSignal := InvalidCodeError newSignalMayProceed:true.
        CompilationFailedSignal nameClass:self message:#compilationFailedSignal.
        CompilationFailedSignal notifierString:'compilation of lazy method failed'.
    ]
! !

!LazyMethod class methodsFor:'Signal constants'!

compilationFailedSignal
    ^ CompilationFailedSignal
! !

!LazyMethod methodsFor:'compiling'!

makeRealMethod
    "make the receiver a real method; i.e. compile the sourcecode and
     fill in the bytecode. This must be done in order to execute the receiver."

    |m|

    "compile the method"

    [
        m := self asExecutableMethod.
    ] valueUninterruptably.

    (m isNil 
    or:[(byteCode := m byteCode) isNil 
         and:[m hasCode not]]) ifTrue:[
        "
         compilation failed
        "
        ^ nil
    ].
    self literals:m literals.
    flags := m flags.
    self code:(m code).
    self changeClassToThatOf:m.
    ^ self

    "Created: / 24.10.1995 / 14:02:50 / cg"
    "Modified: / 24.6.1996 / 17:23:57 / stefan"
    "Modified: / 13.11.1998 / 23:20:41 / cg"
! !

!LazyMethod methodsFor:'error handling'!

noByteCode 
    "this is triggered by the interpreter when a lazy method is about to 
     be executed (by sending the to-be executed  method this message).
     Hard-compile the method, install its bytecode in the receiver,
     and recall it."

    |sender spec class selector|

    "compile the method"

    self makeRealMethod isNil ifTrue:[
        "
         compilation failed
        "
        selector := thisContext sender selector.

        class := self containingClass.
        class notNil ifTrue:[
            spec := class name , '>>' , selector
        ] ifFalse:[
            spec := 'unknown>>' , selector
        ].
        "
         this error is triggered, if the compilation of a lazy method
         failed - this happens for example, if a lazy method's code has been
         changed in a fileBrowser without checking the code for syntactical
         correctnes, or if the instvars of an autoloaded classes superclass 
         have been changed without changing the subclasses code ...
         You should enter the SystemBrowser on this method, and try accepting 
         to see what the problem is.
         The method's class is found in the local 'class',
         the selector is found in the local 'selector'.

         As a general rule: never edit autoloaded classes from anything
         except the browser - to check that they work and are compilable.
        "
        ^ CompilationFailedSignal raiseRequestWith:self
                                  errorString:('compilation of lazy method ' , spec , ' failed')
    ].

    "
     Now, the receiver method has mutated into a real (non-lazy) one.
     Get the original message receiver and args, and execute the method.

     ThisContext sender is the context of the original send (the failed one)
    "
    sender := thisContext sender.
    ObjectMemory flushCaches.

    ^ self valueWithReceiver:(sender receiver)
                   arguments:(sender args)
                    selector:(sender selector)
                      search:(sender searchClass)
                      sender:nil

    "Modified (comment): / 21-11-2017 / 13:02:50 / cg"
! !

!LazyMethod methodsFor:'queries'!

isLazyMethod
    ^ true
!

literals
    "cannot ask a lazyMethod for literals ..."

    |m|

    (m := self asExecutableMethod) notNil ifTrue:[^ m literals].
    ^ #()
!

literalsDetect:aBlock ifNone:exceptionalValue
    "cannot ask a lazyMethod for literals ..."

    |m|

    (m := self asExecutableMethod) notNil ifTrue:[^ m literalsDetect:aBlock ifNone:exceptionalValue].
    ^ exceptionalValue value
!

messagesSent
    "cannot ask a lazyMethod for messagesSent ..."

    |m|

    (m := self asExecutableMethod) notNil ifTrue:[^ m messagesSent].
    ^ #()
!

messagesSentToSelf
    "cannot ask a lazyMethod for messagesSentToSelf ..."

    |m|

    (m := self asExecutableMethod) notNil ifTrue:[^ m messagesSentToSelf].
    ^ #()
!

messagesSentToSuper
    "cannot ask a lazyMethod for messagesSentToSuper ..."

    |m|

    (m := self asExecutableMethod) notNil ifTrue:[^ m messagesSentToSuper].
    ^ #()
!

resources
    "cannot ask a lazyMethod for resources ..."

    |m|

    ^ self parseResources.
"/    (self source includesString:'resource') ifFalse:[^ nil].
"/
"/    (m := self asExecutableMethod) notNil ifTrue:[^ m resources].
"/    ^ nil
! !

!LazyMethod class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


LazyMethod initialize!
