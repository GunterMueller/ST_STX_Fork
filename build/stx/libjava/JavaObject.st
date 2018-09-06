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

Object subclass:#JavaObject
	instanceVariableNames:'_lockWord_'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaObject class methodsFor:'documentation'!

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
    'Proto' class for all Java classes: java.lang.Object inherits 
    from JavaObject class. Methods provided here are provides a 'glue' 
    code necessary to integrate Java objects into Smalltalk world.

    The 'lock' instance variable here is to support Java monitors.
    It contains either smalltinteger with lockword or a reference to
    full JavaMonitor.

    [author:]
        Claus Gittinger
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        _lockWord_  <SmallInteger|JavaMonitor>  either thin-locing lock word
                                                or fat-lock (JavaMonitor). The funny name
                                                here is to prevent name clashes

    [class variables:]

    [see also:]

"
! !

!JavaObject class methodsFor:'misc'!

resolveClassRefs
!

resolveClassRefsIgnoring:setOfClasses
! !

!JavaObject class methodsFor:'queries'!

isCloneable
    ^ false

    "Created: / 12-11-2013 / 11:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject class methodsFor:'smalltalk interface'!

convertJavaObject:val signature:retValSignature
^ val.

    retValSignature = 'void' ifTrue:[
	^ #void
    ].
    retValSignature = 'boolean' ifTrue:[
	val == 0 ifTrue:[^ false].
	^ true
    ].
    retValSignature = 'int' ifTrue:[
	val isInteger ifFalse:[
	    self halt
	].
	^ val
    ].
    retValSignature = 'char[]' ifTrue:[
	"/ these are ST-strings
	^ val
    ].

    retValSignature = 'char' ifTrue:[
	"/ these are ST-characters
	val isInteger ifTrue:[
	    ^ Character value:val
	].
	self halt.
	^ val
    ].

    retValSignature = 'Object' ifTrue:[
	^ val
    ].

    retValSignature = 'String' ifTrue:[
	^ Java as_ST_String:val
    ].

    'no conversion for: ' print. val class name print. ' to: ' print. retValSignature printNL.
    ^ val.

    "Modified: 8.8.1997 / 12:07:23 / cg"
!

javaStringFrom:aString
    "hard-coding internas of java.lang.String here is bad ..."

    self halt.
    ^ Java as_String:aString

    "Modified: 7.8.1997 / 21:17:32 / cg"
!

stringFromJavaString:aJavaString
    "hard-coding internas of java.lang.String here is bad ..."

    self halt.
    ^ Java as_ST_String:aJavaString

    "Modified: 8.8.1997 / 12:07:29 / cg"
! !

!JavaObject methodsFor:'accessing-Java'!

getJavaLockWord
    "Returns a Java lock word for given object. The returned
     value is 
        - either SmallInteger that encodes the thinlock
        - or a fat lock, instance of JavaMonitor
    "

    "/For nonJava objects, always return fatlock

    ^_lockWord_

    "Created: / 26-08-2012 / 14:03:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getJavaMonitor
    "Returns fat JavaMonitor associated with the receiver"

    "/ For Java objects, check if there is allready a thinlock,
    "/ inflate it and return the fatlock

    _lockWord_ isInteger ifTrue:[
        _lockWord_ := JavaVM inflateLockFor: self lockword: _lockWord_.
    ].
    ^_lockWord_

    "Created: / 26-08-2012 / 18:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasJavaLockWord
    "Returns true, if a Java lock word is present"

    "/For nonJava objects, always return falseatlock

    ^ true
!

setJavaLockWord: lockWordOrJavaMonitor
    "Sets a Java lock word for receiver to lockWordOrJavaMonitor. 
     The lockWordOrJavaMonitor must be:
        - either SmallInteger that encodes the thinlock
        - or a fat lock, instance of JavaMonitor
    "

    "/for non-Java objects, store fat lock in LockTable in JavaVM

    ^_lockWord_ := lockWordOrJavaMonitor

    "Created: / 26-08-2012 / 14:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'comparing'!

= anotherObject
    ^ (self perform: #'equals(Ljava/lang/Object;)Z' with: anotherObject) == 1

    "Created: / 07-10-2013 / 17:32:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ self perform: #'hashCode()I'

    "Created: / 07-10-2013 / 17:31:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'exception handling support'!

catchInDebugger
   "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process).
     Dummy here"

    ^false

    "Created: / 20-08-2012 / 14:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

creator

    self class isThrowable ifTrue:[
        ^self class.
    ].
    ^super creator

    "Created: / 14-10-2013 / 11:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description

    self class isThrowable ifTrue:[
        ^self getMessage
    ].
    ^super description

    "Created: / 20-08-2012 / 14:19:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlerForSignal:exceptionHandler context:theContext originator:originator
    ^nil

!

isQuerySignal

    ^false

    "Created: / 18-03-2012 / 13:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent
    "Required for old instance based exceptions, sigh"
    ^nil

    "Created: / 18-03-2012 / 13:26:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

signal

    self class isThrowable ifTrue:[
        ^self class.
    ].
    ^super signal

    "Created: / 20-08-2012 / 14:15:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'finalization'!

finalizationLobby

"/    ^super finalizationLobby

    ^JavaVM finalizationLobby "/ Do not use this yet!!

    "Created: / 24-07-2012 / 01:04:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'initialization'!

initialize
    self perform:#'<init>()V'.

    "Created: / 09-06-2012 / 21:49:37 / Jan Kurs (kursjan@fit.cvut.cz)"
!

initializeToZero
    |sz|

    sz := self class instSize.
    1 to:sz do:[:i |
	self instVarAt:i put:0
    ]
! !


!JavaObject methodsFor:'message sending'!

doesNotUnderstand:aMessage

    <resource: #skipInDebuggersWalkBack>
    
    | sender retval didNotUnderstood |
    "/ When we arrive here, the stack is:
    "/   1 - JavaObject>>doesNotUnderstand: (i.e., this method)
    "/   2 - context for not understood method (created by VM to hold arguments)
    "/   3 - context of method that sent the not understood message
    "/ Hence the `thisContext sender sender below.
    sender := thisContext sender sender.
    didNotUnderstood := false.
    retval := self class perform: aMessage onReceiver: self from: sender ifNotFound: [ didNotUnderstood :=  true ].
    ^ didNotUnderstood ifTrue:[
        super doesNotUnderstand: aMessage .
    ] ifFalse:[
        retval
    ].

    "Modified: / 16-11-1998 / 16:50:56 / cg"
    "Modified: / 19-09-2011 / 23:43:56 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 01-01-2012 / 19:49:35 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 23-03-2016 / 10:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'printing & storing'!

basicPrintOn: aStream
    aStream nextPutAll: self class javaName.
    aStream nextPut:$@.
    self identityHash printOn: aStream.

    "Created: / 13-04-2012 / 17:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayString

    JavaVM booted ifTrue:[
        | toStringM toString |
        toStringM := self class lookupSelector: #'toString()Ljava/lang/String;'.
        (toStringM javaClass binaryName ~~ #'java/lang/Object') ifTrue:[
            [ 
                toString := Java as_ST_String:(self perform:#'toString()Ljava/lang/String;').
            ] on: Error do: [ 
                toString := nil 
            ].        
        ].
        toString notNil ifTrue:[        
            ^toString
        ]
    ].
    ^String streamContents: [:s|self basicPrintOn: s]

    "Modified: / 04-11-1998 / 18:35:00 / cg"
    "Modified: / 28-01-2011 / 15:10:05 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-10-2013 / 22:46:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn: aStream
    |myClassName |

    myClassName := self class binaryName.
    myClassName == #'java/lang/String' ifTrue:[
        aStream nextPut:$".
        aStream nextPutAll: (Java as_ST_String: self).
        aStream nextPut:$".
        ^self.
    ].
    myClassName == #'java/lang/Class' ifTrue:[
        super printOn: aStream.
        aStream nextPut: $(.
        (JavaVM reflection classForJavaClassObject:self) javaMirror getName printOn: aStream.
        aStream nextPut: $).
        ^self.
    ].
    myClassName == #'java.lang.reflect.Method' ifTrue:[
        super printOn: aStream.
        aStream nextPut: $(.
        (JavaVM reflection methodForJavaMethodObject:self) printOn: aStream.
        aStream nextPut: $).
        ^self.
    ].

    JavaVM booted ifTrue:[
        | toString |
        [ toString := Java as_ST_String:(self perform:#'toString()Ljava/lang/String;').]
            on: Error do: [ toString := nil ].        
        toString notNil ifTrue:[        
            "/super printOn: aStream.
            "/aStream nextPut: $(.
            aStream nextPutAll: toString.
            "/aStream nextPut: $).
            ^self.
        ] 
    ].
    super printOn: aStream.

    "Created: / 04-12-2011 / 10:29:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:47:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'queries'!

instanceOf: aJavaClassOrJavaClassAccessor
    "A Smalltalk-friendly version  of Java language `instanceof` operator.

     The difference between #instanceOf and #isKindOf: is that
     #instanceOf: takes interfaces into an account whereas
     #isKindOf: not.

     NOTE: It's up to an discussion whethere #isKindOf: sent to
     a java object should or should not behave as #instanceOf:.
     Maybe in future they will be the same."

    | class |

    class := aJavaClassOrJavaClassAccessor class == JavaClassAccessor 
                ifTrue:[aJavaClassOrJavaClassAccessor theClass]
                ifFalse:[aJavaClassOrJavaClassAccessor].
    ^ (JavaVM _INSTANCEOF: self _: class) == 1.

    "Created: / 09-10-2013 / 22:36:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 10-10-2013 / 16:35:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaClassRef
    ^ false

    "Created: / 9.11.1999 / 17:13:37 / cg"
!

isJavaMethodRef
    ^ false

    "Created: / 9.11.1999 / 15:43:21 / cg"
!

isJavaObject
    ^ true

    "Created: 26.3.1997 / 13:34:17 / cg"
!

size
    "What a hack!!!!!!"

    ^(self respondsTo:#'size()I') ifTrue:[
        self perform:#'size()I'
    ] ifFalse:[
        super size.    
    ]

    "Created: / 29-02-2012 / 14:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'smalltalk interface'!

lookupMethod:selector numArgs:nargs
    "lookup a method"

    |method cls sel|

    sel := selector.
    (sel includes:$:) ifTrue:[
	sel := sel copyTo:(sel indexOf:$:)-1    
    ].

    sel := sel asSymbolIfInterned.
    sel notNil ifTrue:[
	cls := self class.
	[cls notNil and:[cls ~~ JavaObject]] whileTrue:[
	    cls methodDictionary keysAndValuesDo:[:jSel :aMethod |
		(jSel == sel ) ifTrue:[
		    ^ aMethod
		]
	    ].
	    cls methodDictionary keysAndValuesDo:[:jSel :aMethod |
		(aMethod name = sel 
		or:[aMethod signatureNameWithoutReturnType = sel]) ifTrue:[
		    aMethod numArgs == nargs ifTrue:[
			^ aMethod
		    ]
		]
	    ].
	    cls := cls superclass.
	].
    ].

    ^ nil

    "
     |stack|

     stack := (Java at:'java.util.Stack') basicNew.
     stack lookupMethod:#'<init>' numArgs:0. 
    "
    "
     |stack|

     stack := (Java at:'java.util.Stack') new.
     stack lookupMethod:#isEmpty numArgs:0. 
    "
    "
     |frame|

     frame := (Java at:'java.awt.Frame') new.
     frame lookupMethod:#'<init> (String)' numArgs:1. 
    "

    "Modified: 22.3.1997 / 00:56:54 / cg"
! !

!JavaObject methodsFor:'synchronized evaluation'!

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

%{
    extern void __monitorEnter(OBJ obj);
    __monitorEnter(self);
%}.
    aBlock ensure:[
%{
    extern void __monitorExit(OBJ obj);
    __monitorExit(self);
%}.
    1. "/ To make stc happy (stc needs a return value but primitive code has none)
    ].

    "Modified: / 11-10-2016 / 23:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'unwind'!

unwindHandlerInContext: aContext 
    "given a context which has been marked for unwind,
     retrieve the handler block. This method is called when ST
     exception raises and stack is unwinding. JavaClass instance
     has an opportunity to clean up monitors"
    
    ^ JavaVM unwindHandlerForJavaContext: aContext.

    "Created: / 08-11-2011 / 12:25:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaObject methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^JavaVM _ARRAYLENGTH: self

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_CHECKCAST: cls
    JavaVM _CHECKCAST: self _: cls.
%{
    void ___checkcast_bind();
    ___checkcast_bind(__pilc, __Class(self));

%}.  
    ^self  

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INSTANCEOF: cls
    | r |
    
    r := JavaVM _INSTANCEOF: self _: cls.
%{
    void ___instanceof_bind();    
    ___instanceof_bind(__pilc, __Class(self), r);
%}. 
    ^r

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaObject.st,v 1.61 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaObject.st,v 1.61 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

