"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

nil subclass:#Object
	instanceVariableNames:''
	classVariableNames:'AbortAllSignal AbortSignal ActivityNotificationSignal
		DebuggerHooks DeepCopyErrorSignal Dependencies
		ElementOutOfBoundsSignal EnabledBreakPoints ErrorRecursion
		ErrorSignal FinalizationLobby HaltSignal IndexNotFoundSignal
		InfoPrinting InformationSignal InternalErrorSignal
		KeyNotFoundSignal MessageNotUnderstoodSignal
		NonIntegerIndexSignal NonWeakDependencies NotFoundSignal
		OSSignalInterruptSignal ObjectAttributes
		ObjectAttributesAccessLock PartialErrorPrintLine
		PartialInfoPrintLine PrimitiveFailureSignal
		RecursionInterruptSignal RecursiveStoreStringSignal
		SubscriptOutOfBoundsSignal SynchronizationSemaphores
		UserInterruptSignal UserNotificationSignal WarningSignal'
	poolDictionaries:''
	category:'Kernel-Objects'
!

!Object class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

dependencies
"
   ST/X dependencies are slightly modified from ST-80's
   (we think they are better ;-).

   One problem occuring very often in ST-80 is that some object
   cannot be garbage collected because some dependency is present,
   having the object as a dependent of some other object.
   In ST-80, this association remains alive (because a Dictionary
   is used to hold dependents) - even if no other references exist to
   to dependent or the dependee.

   This means, that in ST-80, a #release is mandatory in order to
   prevent memory leaks.
   We think, that this is a bad solution, since after all, exactly that
   kind of work should be performed by a garbage collector - you should not
   need to care about dependencies.
   From a philosophical point of view, why should some object depend on
   something that the programmer considers a dead object ?
   (well - worse than that: it seems that some ST-80 code even depends on
    that behavior)

   In order to limit the trouble, ST-80 reimplemented the way dependents
   are stored in the model class - this one keeps the dependents locally,
   so these dependents go away, once the model is reclaimed.
   That may make things even more confusing: with models, no #release is
   needed, with general objects it is mandatory.


   In ST/X, dependencies are implemented using a WeakDictionary; this means,
   that once the dependee dies, the dependency association is removed automatically,
   and the dependent can be reclaimed by the garbage collector, if no other
   references exist to the dependent.
   In order to (at least) provide a mechanism for the old behavior
   (in case your application heavily depends on the ST-80 mechanism), complementary
   protocol to add nonWeak dependencies is provided
   (see #addNonWeakDependent / #removeNonWeakDependent).


   Caveat:
      since interests are implemented using InterestConverter (which are simply
      forwarding messages), these must use the nonWeak mechanism (as done in ST-80
      automatically).
      The reason is that there are usually no direct references to the converters,
      and those would be reclaimed if stored in a weakDictionary.
      This means, that those interests MUST be removed with #retractInterest
      (which is bug-compatible to ST-80).
      We rewrite things to provide a more convenient mechanism in the future ...


   I like to hear comments on the above - do you think its better ?
"
!

documentation
"
   Object is the superclass of most other classes.
   (except for nil-subclasses, which inherit nothing,
    to catch any message into their #doesNotUnderstand: method)

   Protocol which is common to every object is defined here.
   Also some utility stuff (like notify) and error handling is implemented here.

   Object has no instance variables (and may not get any added). One reason is, that
   UndefinedObject and SmallInteger are also inheriting from Object - these two cannot
   have instance variables (due to their implementation).
   The other reason is that the runtime system (VM) knows about the layout of some built-in
   classes (think of Class, Method, Block and also Integer or Float).
   If you were allowed to add instance variables to Object, the VM had to be recompiled
   (and also rewritten in some places).

   [Class variables:]

        ErrorSignal     <Signal>        Signal raised for error/error: messages
                                        also, parent of all other signals.

        HaltSignal      <Signal>        Signal raised for halt/halt: messages

        MessageNotUnderstoodSignal      Signals raised for various error conditions
        UserInterruptSignal
        RecursionInterruptSignal
        ExceptionInterruptSignal
        SubscriptOutOfBoundsSignal
        NonIntegerIndexSignal
        NotFoundSignal
        KeyNotFoundSignal
        ElementOutOfBoundsSignal
        InformationSignal
        WarningSignal
        DeepCopyErrorSignal
        InternalErrorSignal

        AbortSignal      <Signal>       Signal raised by debugger, to abort a computation
                                        BUT, the debugger will only raise it if it is handled.
                                        By handling the abortSignal, you can control where the
                                        debuggers abort-function resumes execution in case of
                                        an error.

        ErrorRecursion   <Boolean>      controls behavior when recursive errors occur (i.e.
                                        an error while handling an error).

        Dependencies     <WeakDependencyDictionary>
                                        keeps track of object dependencies.

        InfoPrinting     <Boolean>      controls weather informational messages
                                        are printed.

        ActivityNotificationSignal <QuerySignal>
                                         raised on #activityNotification:

        NonWeakDependencies <Dictionary> keeps track of object dependencies.
                                         Dependents stay alive.

        SynchronizationSemaphores <WeakIdentityDictionary>
                                         Semaphores for per-object-monitor.


    [author:]
        Claus Gittinger

"
! !

!Object class methodsFor:'initialization'!

initSignals
    "called only once - initialize signals"

    "/ notice: the class variables here are a leftover from times
    "/ when errors where signal-instance, not class based.
    "/ then, signal instances where created here and kept as class vars,
    "/ to be fetched from the class var or via signal-getter methods.
    "/ Nowadays, we use class based exceptions, where the exception class
    "/ is directly referenced.
    "/ the classvars here are kept for backward compatibility, but they now
    "/ simply alias the corresponding exception class.
    "/ Old code should be rewritten to access the error class.

    ErrorSignal := Error.
    HaltSignal := HaltInterrupt.
    MessageNotUnderstoodSignal := MessageNotUnderstood.
    PrimitiveFailureSignal := PrimitiveFailure.
    InternalErrorSignal := VMInternalError.
    UserInterruptSignal := UserInterrupt.
    RecursionInterruptSignal := RecursionError.
    NotFoundSignal := NotFoundError.
    IndexNotFoundSignal := IndexNotFoundError.
    SubscriptOutOfBoundsSignal := SubscriptOutOfBoundsError.
    NonIntegerIndexSignal := NonIntegerIndexError.
    KeyNotFoundSignal := KeyNotFoundError.
    ElementOutOfBoundsSignal := ElementBoundsError.
    UserNotificationSignal := UserNotification.
    WarningSignal := Warning.
    InformationSignal := UserInformation.
    ActivityNotificationSignal := ActivityNotification.

    DeepCopyErrorSignal := DeepCopyError.

    AbortSignal := AbortOperationRequest.
    AbortAllSignal := AbortAllOperationRequest.

    OSSignalInterruptSignal := OSSignalInterrupt.
    RecursiveStoreStringSignal := RecursiveStoreError.

    "
     Object initSignals
    "

    "Modified: / 22.1.1998 / 21:23:40 / av"
    "Modified: / 4.8.1999 / 08:54:06 / stefan"
    "Modified: / 16.11.2001 / 16:30:08 / cg"
!

initialize
    "called only once - initialize signals"

    ErrorSignal isNil ifTrue:[
        self initSignals.
        ErrorRecursion := true.
    ].

    ObjectAttributes isNil ifTrue:[
        ObjectAttributes := WeakIdentityDictionary new.
        ObjectAttributesAccessLock := RecursionLock new.
    ].
    Dependencies isNil ifTrue:[
        Dependencies := WeakDependencyDictionary new.
    ].
    NonWeakDependencies isNil ifTrue:[
        NonWeakDependencies := IdentityDictionary new.
    ].
    SynchronizationSemaphores isNil ifTrue:[
        SynchronizationSemaphores := WeakIdentityDictionary new.
    ].
    FinalizationLobby isNil ifTrue:[
        FinalizationLobby := Registry new.
    ].

    "/ initialize InfoPrinting to the VM's infoPrint setting
    "/ (which can be turned off via a command line argument)
    InfoPrinting := ObjectMemory infoPrinting.

    "Object initialize"

    "Modified: / 22.1.1998 / 21:23:40 / av"
    "Modified: / 3.2.1998 / 18:55:09 / cg"
    "Modified: / 4.8.1999 / 08:54:06 / stefan"
! !


!Object class methodsFor:'Compatibility-ST80'!

rootError
    "return the signal used for error/error: - handling.
     Same as errorSignal for ST80 compatibility."

    ^ Error

    "Created: / 15.1.1998 / 23:47:05 / stefan"
! !

!Object class methodsFor:'Signal constants'!

abortAllSignal
    "return the signal used to abort user actions (much like AbortSignal).
     This signal is supposed to abort multiple operation actions, and get out of
     the loop (such as when confirming multiple class deletions etc.)"

    ^ AbortAllOperationRequest
!

abortSignal
    "return the signal used to abort user actions. This signal is only
     raised if caught (by the debugger), and will lead way out of the
     currently active doIt/printIt or inspectIt. (also some others use
     this for a save abort)"

    ^ AbortOperationRequest
!

activityNotificationSignal
    "return the signal used for activity notifications.
     A handler for this signal gets all #activityNotification: sends"

    ^ ActivityNotification
!

ambiguousMessageSignal
    "return the signal used for ambiguousMessage: - error handling"

    ^ AmbiguousMessage

    "Created: / 21-07-2010 / 15:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

conversionErrorSignal
    "return the signal used for conversion error handling"

    ^ ConversionError
!

deepCopyErrorSignal
    "return the signal raised when a deepcopy is asked for
     an object which cannot do this (for example, BlockClosures
     or Contexts)."

    ^ DeepCopyError
!

elementOutOfBoundsSignal
    "return the signal used for element error reporting
     (this signal is used for example when a value not in 0..255 is to
      be put into a bytearray)"

    ^ ElementBoundsError
!

errorSignal
    "return the signal used for error/error: - handling"

    ^ Error
!

haltSignal
    "return the signal used for halt/halt: - handling"

    ^ HaltSignal
!

indexNotFoundSignal
    "return the signal used for bad index error reporting.
     This is also the parentSignal of the nonIntegerIndex- and
     subscriptOutOfBoundsSignal"

    ^ IndexNotFoundSignal

    "Created: / 8.11.1997 / 19:15:48 / cg"
!

informationSignal
    "return the signal used for informations.
     A handler for this signal gets all #information: sends"

    ^ InformationSignal
!

internalErrorSignal
    "return the signal used to report internal (VM-) errors."

    ^ VMInternalError
!

keyNotFoundSignal
    "return the signal used for no such key error reporting"

    ^ KeyNotFoundError
!

messageNotUnderstoodSignal
    "return the signal used for doesNotUnderstand: - error handling"

    ^ MessageNotUnderstood
!

nonIntegerIndexSignal
    "return the signal used for bad subscript error reporting"

    ^ NonIntegerIndexSignal
!

notFoundSignal
    "return the signal used for no element found error reporting"

    ^ NotFoundSignal
!

notifySignal
    "return the parent of all notification signals."

    ^ Notification
!

osSignalInterruptSignal
    "return the signal used for OS-signal error reporting;
     This is only raised if handled - otherwise, a debugger is entered."

    ^ OSSignalInterrupt

    "Modified: / 12.6.1998 / 16:27:26 / cg"
!

primitiveFailureSignal
    "return the signal used for primitiveFailed - error handling"

    ^ PrimitiveFailure
!

privateMethodSignal
    "return the signal used for privateMethod - error handling"

    ^ MessageNotUnderstoodSignal
!

recursionInterruptSignal
    "return the signal used for recursion overflow error handling"

    ^ RecursionInterruptSignal
!

recursiveStoreStringSignal
    "return the notification used to report storeString generation of recursive objects"

    ^ RecursiveStoreError

    "
     RecursiveStoreError handle:[:ex |
        self halt
     ] do:[
        |a|

        a := Array new:1.
        a at:1 put:a.
        a storeOn:Transcript
     ]
    "

    "
     |a|

     a := Array new:1.
     a at:1 put:a.
     a storeOn:Transcript
    "
!

subclassResponsibilitySignal
    "return the signal used for subclassResponsibility error reporting.
     (this signal is used to signal incomplete subclasses - i.e. a programmers error)"

    ^ SubclassResponsibilityError
!

subscriptOutOfBoundsSignal
    "return the signal used for subscript error reporting.
     (this signal is used for example when an array is accessed with an
      index less than 1 or greater than the array size)"

    ^ SubscriptOutOfBoundsSignal
!

userInterruptSignal
    "return the signal used for ^C interrupts handling"

    ^ UserInterruptSignal
!

userNotificationSignal
    "the parent signal used with information and warnings.
     Handling this allows handling of both information- and warning notifications."

    ^ UserNotificationSignal
!

warningSignal
    "return the signal used for warnings.
     A handler for this signal gets all #warn: sends"

    ^ WarningSignal
! !

!Object class methodsFor:'info messages'!

infoPrinting
    "return the flag which controls information messages."

    ^ InfoPrinting
!

infoPrinting:aBoolean
    "{ Pragma: +optSpace }"

    "turn on/off printing of information messages.
     If the argument, aBoolean is false, infoPrint will not output
     messages. The default is true."

    InfoPrinting := aBoolean
! !


!Object class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for Object here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == Object
!

isBuiltInClass
    "return true if this class is known by the run-time-system,
     i.e. you cannot add/remove instance variables without recompiling
     the VM.
     Here, true is returned for myself, false for subclasses."

    ^ self == Object

    "Modified: 23.4.1996 / 16:00:07 / cg"
! !





!Object methodsFor:'Compatibility-GNU'!

display
    "print the receiver on the standard output stream (which is not the Transcript).
     Added for GNU-ST compatibility"

    self print
!

displayNl
    "print the receiver followed by a cr on the standard output stream (which is not the Transcript).
     Added for GNU-ST compatibility"

    self printCR
! !

!Object methodsFor:'Compatibility-ST80'!

isMetaclass
    "same as isMeta for ST80/Squeak and VW compatibility.
     kept in the libbasic package, because it is used often"
     
    ^ self isMeta
! !

!Object methodsFor:'Compatibility-Squeak'!

clone
    ^ self shallowCopy
!

copyTwoLevel
    "one more level than a shallowCopy"

    ^ self copyToLevel:2

    "
     |original copy elL1 elL2 elL3 copyOfElL1|

     original := Array new:3.
     original at:1 put:1234.
     original at:2 put:'hello'.
     original at:3 put:(elL1 := Array new:3).

     elL1 at:1 put:1234.
     elL1 at:2 put:'hello'.
     elL1 at:3 put:(elL2 := Array new:3).

     elL2 at:1 put:1234.
     elL2 at:2 put:'hello'.
     elL2 at:3 put:(elL3 := Array new:3).

     elL3 at:1 put:1234.
     elL3 at:2 put:'hello'.
     elL3 at:3 put:(Array new:3).

     copy := original copyTwoLevel.
     self assert:((original at:2) ~~ (copy at:2)).
     self assert:((original at:3) ~~ (copy at:3)).

     copyOfElL1 := copy at:3.
     self assert:((elL1 at:2) == (copyOfElL1 at:2)).
     self assert:((elL1 at:3) == (copyOfElL1 at:3)).
    "
!

flag:aString
    "Send this message, with a relevant symbol as argument, to flag a message for subsequent retrieval.  For example, you might put the following line in a number of messages:
     self flag: #returnHereUrgently
     Then, to retrieve all such messages, browse all senders of #returnHereUrgently."

    "Created: / 21-04-2015 / 15:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCompiledMethod
    "same as isMethod - for squeak compatibility"

    "/ left in libbasic package, because it is used by refactory code
    ^ false
!

veryDeepCopy
     ^ self deepCopyUsing:(IdentityDictionary new)
! !

!Object methodsFor:'Compatibility-VW'!

isCharacters
    "true, if the receiver is a string-like thing.
     added for visual works compatibility"

    "/ kept in libbasic package, because it is used in libjava and imap-implementation 
    ^ false
!

isSignalledException
    "VW compatibility"

    ^ self isException
!

keyNotFoundError:aKey
    "VW compatibility"

    "/ kept in libbasic package, because it is used by the refactory code
    self errorKeyNotFound:aKey.
! !


!Object methodsFor:'accessing'!

_at:index
    "experimental:
     this is a synthetic selector, generated by the compiler,
     if a construct of the form expr[idx...] is parsed.
     I.e.
        v[n]
     generates
        v _at: n
    "

    ^ self at:index

    "Created: / 21-03-2011 / 14:07:57 / cg"
!

_at:index put:value
    "experimental:
     this is a synthetic selector, generated by the compiler,
     if a construct of the form expr[idx...] is parsed.
     I.e.
        v[n]
     generates
        v _at: n
    "

    ^ self at:index put:value

    "Created: / 21-03-2011 / 14:10:12 / cg"
!

addSlot: slotName
    "dynamically add a new slot to the receiver.
     The receiver must be a real object, not nil or a smallInteger"

    |classGetter myClass anonCls newObj|

    myClass := self class.
    classGetter := ('%__get_',slotName,'__') asSymbol.

    anonCls := self perform:classGetter ifNotUnderstood:nil.
    anonCls isNil ifTrue:[
        anonCls := myClass
                subclass:(myClass name,'+',slotName) asSymbol
                instanceVariableNames:slotName
                classVariableNames:''
                poolDictionaries:'' category:nil
                inEnvironment:nil.
        anonCls compile:('%1 ^  %1' bindWith:slotName).
        anonCls compile:('%1:v %1 := v' bindWith:slotName).
        Class withoutUpdatingChangesDo:[
            |m|
            m := Compiler compile:('__get_',slotName,' ^ #fooBar' bindWith:slotName) forClass:myClass install:false.
            m literalAt:(m literals indexOf:#fooBar) put:anonCls.
            myClass addSelector:classGetter withMethod:m.
        ].
    ].
    newObj := anonCls cloneFrom:self.
    self become:newObj.

    "
     |p1 p2 p3|

     p1 := Point x:10 y:20.
     p2 := Point x:100 y:200.
     Transcript show:'p1 is '; showCR:p1.
     Transcript show:'p2 is '; showCR:p2.
     p1 addSlot:'z'.
     p1 z:30.
     Transcript show:'p1 is '; showCR:p1.
     Transcript show:'p2 is '; showCR:p2.
     ObjectMemory dumpObject:p1.
     ObjectMemory dumpObject:p2.

     p1 addSlot:'t'.
     p1 t:30.
     Transcript show:'p1 is '; showCR:p1.
     ObjectMemory dumpObject:p1.

     p3 := Point x:110 y:120.
     p3 addSlot:'z'.
     p3 addSlot:'t'.
     p1 inspect.
     p2 inspect.
     p3 inspect.
    "
!

at:index
    "return the indexed instance variable with index, anInteger;
     this method can be redefined in subclasses."

    ^ self basicAt:index
!

at:index put:anObject
    "store the 2nd arg, anObject as indexed instvar with index, anInteger.
     this method can be redefined in subclasses. Returns anObject (sigh)"

    ^ self basicAt:index put:anObject

    "Modified: 19.4.1996 / 11:13:29 / cg"
!

basicAt:index
    "return the indexed instance variable with index, anInteger.
     Trigger an error if the receiver has no indexed instance variables.
     This method should NOT be redefined in any subclass (except with great care, for tuning)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        int idx1Based = index.intValue();   // st index is 1 based
        return context._RETURN( self.basicAt( idx1Based ));
    }
    /* NOTREACHED */
#else
    REGISTER INT indx;
    REGISTER INT nBytes;
    OBJ myClass;
    REGISTER char *pFirst;
    REGISTER int n;

    /*
     * notice the missing test for self being a nonNilObject -
     * this can be done since basicAt: is defined both in UndefinedObject
     * and SmallInteger
     */
    if (__isSmallInteger(index)) {
        myClass = __qClass(self);
        indx = __intVal(index) - 1;
        n /* nInstVars */ = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
        n /* nInstBytes */ = OHDR_SIZE + __OBJS2BYTES__(n /* nInstVars */);
        nBytes = __qSize(self) - n /* nInstBytes */;
        pFirst = (char *)(__InstPtr(self)) + n /* nInstBytes */;

        switch ((INT)(__ClassInstPtr(myClass)->c_flags) & __MASKSMALLINT(ARRAYMASK)) {
            case __MASKSMALLINT(POINTERARRAY):
                /*
                 * pointers
                 */
                if ((unsigned INT)indx < (unsigned INT)(__BYTES2OBJS__(nBytes))) {
                    OBJ *op;

                    op = (OBJ *)pFirst + indx;
                    RETURN ( *op );
                }
                break;

            case __MASKSMALLINT(WKPOINTERARRAY):
                if ((unsigned INT)indx < (unsigned INT)(__BYTES2OBJS__(nBytes))) {
                    OBJ *op;
                    OBJ el;

                    op = (OBJ *)pFirst + indx;
                    el = *op;
                    el = __WEAK_READ__(self, el);
                    RETURN ( el );
                }
                break;

            case __MASKSMALLINT(BYTEARRAY):
                /*
                 * (unsigned) bytes
                 */
                if ((unsigned INT)indx < (unsigned INT)nBytes) {
                    unsigned char *cp;

                    cp = (unsigned char *)pFirst + indx;
                    RETURN ( __mkSmallInteger( (*cp & 0xFF)) );
                }
                break;

            case __MASKSMALLINT(FLOATARRAY):
                /*
                 * native floats
                 */
# ifdef __NEED_FLOATARRAY_ALIGN
                if ((INT)pFirst & (__FLOATARRAY_ALIGN-1)) {
                    int delta = __FLOATARRAY_ALIGN - ((INT)pFirst & (__FLOATARRAY_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes / sizeof(float))) {
                    float *fp;
                    float f;
                    OBJ v;

                    fp = (float *)pFirst + indx;
                    f = *fp;
                    if (f == 0.0) {
                        v = STX__float0;
                    } else {
                        __qMKSFLOAT(v, f);
                    }
                    RETURN (v);
                }
                break;

            case __MASKSMALLINT(DOUBLEARRAY):
                /*
                 * native doubles
                 */
# ifdef __NEED_DOUBLE_ALIGN
                if ((INT)pFirst & (__DOUBLE_ALIGN-1)) {
                    int delta = __DOUBLE_ALIGN - ((INT)pFirst & (__DOUBLE_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes / sizeof(double))) {
                    double *dp;
                    double d;
                    OBJ v;

                    dp = (double *)pFirst + indx;
                    d = *dp;
                    if (d == 0.0) {
                        v = STX__float0;
                    } else {
                        __qMKFLOAT(v, d);
                    }
                    RETURN (v);
                }
                break;

            case __MASKSMALLINT(WORDARRAY):
                /*
                 * unsigned 16bit ints
                 */
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the short-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>1)) {
                    unsigned short *sp;

                    sp = (unsigned short *)(pFirst + (indx<<1));
                    RETURN ( __mkSmallInteger( (*sp & 0xFFFF)) );
                }
                break;

            case __MASKSMALLINT(SWORDARRAY):
                /*
                 * signed 16bit ints
                 */
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the short-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>1)) {
                    short *ssp;

                    ssp = (short *)(pFirst + (indx<<1));
                    RETURN ( __mkSmallInteger( (*ssp) ));
                }
                break;

            case __MASKSMALLINT(LONGARRAY):
                /*
                 * unsigned 32bit ints
                 */
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the int-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>2)) {
                    unsigned int32 ul;
                    unsigned int32 *lp;

                    lp = (unsigned int32 *)(pFirst + (indx<<2));
                    ul = *lp;
# if __POINTER_SIZE__ == 8
                    {
                        unsigned INT ull = (unsigned INT)ul;
                        RETURN ( __mkSmallInteger(ull) );
                    }
# else
                    if (ul <= _MAX_INT) {
                        RETURN ( __mkSmallInteger(ul) );
                    }
                    RETURN ( __MKULARGEINT(ul) );
# endif
                }
                break;

            case __MASKSMALLINT(SLONGARRAY):
                /*
                 * signed 32bit ints
                 */
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the int-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>2)) {
                    int32 *slp;
                    int32 l;

                    slp = (int32 *)(pFirst + (indx<<2));
                    l = *slp;
# if __POINTER_SIZE__ == 8
                    {
                        INT ll = (INT)l;
                        RETURN ( __mkSmallInteger(ll) );
                    }
# else
                    if (__ISVALIDINTEGER(l)) {
                        RETURN ( __mkSmallInteger(l) );
                    }
                    RETURN ( __MKLARGEINT(l) );
# endif
                }
                break;

            case __MASKSMALLINT(SLONGLONGARRAY):
                /*
                 * signed 64bit longlongs
                 */
# ifdef __NEED_LONGLONG_ALIGN
                if ((INT)pFirst & (__LONGLONG_ALIGN-1)) {
                    int delta = __LONGLONG_ALIGN - ((INT)pFirst & (__LONGLONG_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the long/longlong-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>3)) {
# if __POINTER_SIZE__ == 8
                    INT *slp, ll;

                    slp = (INT *)(pFirst + (indx<<3));
                    ll = *slp;
                    if (__ISVALIDINTEGER(ll)) {
                        RETURN ( __mkSmallInteger(ll) );
                    }
                    RETURN ( __MKLARGEINT(ll) );
# else
                    __int64__ *llp;

                    llp = (__int64__ *)(pFirst + (indx<<3));
                    RETURN (__MKINT64(llp));
# endif
                }
                break;

            case __MASKSMALLINT(LONGLONGARRAY):
                /*
                 * unsigned 64bit longlongs
                 */
# ifdef __NEED_LONGLONG_ALIGN
                if ((INT)pFirst & (__LONGLONG_ALIGN-1)) {
                    int delta = __LONGLONG_ALIGN - ((INT)pFirst & (__LONGLONG_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                /* Notice: the hard coded shifts are by purpose;
                 * it makes us independent of the long/longlong-size of the machine
                 */
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>3)) {
# if __POINTER_SIZE__ == 8
                    unsigned INT *ulp, ul;

                    ulp = (unsigned INT *)(pFirst + (indx<<3));
                    ul = *ulp;
                    if (ul <= _MAX_INT) {
                        RETURN ( __mkSmallInteger(ul) );
                    }
                    RETURN ( __MKULARGEINT(ul) );
# else
                    __uint64__ *llp;

                    llp = (__uint64__ *)(pFirst + (indx<<3));
                    RETURN (__MKUINT64(llp));
# endif
                }
                break;
        }
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ self indexNotIntegerOrOutOfBounds:index
!

basicAt:index put:anObject
    "store the 2nd arg, anObject as indexed instvar with index, anInteger.
     Returns anObject (sigh).
     Trigger an error if the receiver has no indexed instance variables.

     This method should NOT be redefined in any subclass (except with great care, for tuning)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        int idx1Based = index.intValue();   // st index is 1 based

        self.basicAt_put(idx1Based, anObject );
        return context._RETURN( anObject );
    }
    /* NOTREACHED */
#else
    REGISTER INT indx;
    REGISTER INT nBytes;
    OBJ myClass;
    REGISTER char *pFirst;
    /* int nInstBytes, ninstvars, flags; */
    REGISTER int n;
    unsigned int u;
    int val;

    /* notice the missing test for self being a nonNilObject -
       this can be done since basicAt: is defined both in UndefinedObject
       and SmallInteger */

    if (__isSmallInteger(index)) {
        indx = __intVal(index) - 1;
        myClass = __qClass(self);
        n /* ninstvars */ = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
        n /* nInstBytes */ = OHDR_SIZE + __OBJS2BYTES__(n /* ninstvars */);
        nBytes = __qSize(self) - n /* nInstBytes */;
        pFirst = (char *)(__InstPtr(self)) + n /* nInstBytes */;

        switch ((INT)(__ClassInstPtr(myClass)->c_flags) & __MASKSMALLINT(ARRAYMASK)) {
            case __MASKSMALLINT(POINTERARRAY):
                if ((unsigned INT)indx < (unsigned INT)(__BYTES2OBJS__(nBytes))) {
                    OBJ *op;

                    op = (OBJ *)pFirst + indx;
                    *op = anObject;
                    __STORE(self, anObject);
                    RETURN ( anObject );
                }
                break;

            case __MASKSMALLINT(WKPOINTERARRAY):
                if ((unsigned INT)indx < (unsigned INT)(__BYTES2OBJS__(nBytes))) {
                    OBJ *op;

                    op = (OBJ *)pFirst + indx;
                    *op = anObject;
                    __STORE(self, anObject);
                    __WEAK_WRITE__(self, anObject);
                    RETURN ( anObject );
                }
                break;

            case __MASKSMALLINT(BYTEARRAY):
                if (__isSmallInteger(anObject)) {
                    val = __intVal(anObject);
                    if ((val & ~0xFF) == 0 /* i.e. (val >= 0) && (val <= 255) */) {
                        if ((unsigned INT)indx < (unsigned INT)nBytes) {
                            char *cp;

                            cp = pFirst + indx;
                            *cp = val;
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(FLOATARRAY):
# ifdef __NEED_FLOATARRAY_ALIGN
                if ((INT)pFirst & (__FLOATARRAY_ALIGN-1)) {
                    int delta = __FLOATARRAY_ALIGN - ((INT)pFirst & (__FLOATARRAY_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes / sizeof(float))) {
                    float *fp;

                    fp = (float *)pFirst + indx;
                    if (anObject != nil) {
                        if (! __isSmallInteger(anObject)) {
                            if (__qIsFloatLike(anObject)) {
                                *fp = (float)(__floatVal(anObject));
                                RETURN ( anObject );
                            }
                            if (__qIsShortFloat(anObject)) {
                                *fp = __shortFloatVal(anObject);
                                RETURN ( anObject );
                            }
                        } else {
                            *fp = (float) __intVal(anObject);
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(DOUBLEARRAY):
# ifdef __NEED_DOUBLE_ALIGN
                if ((INT)pFirst & (__DOUBLE_ALIGN-1)) {
                    int delta = __DOUBLE_ALIGN - ((INT)pFirst & (__DOUBLE_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes / sizeof(double))) {
                    double *dp;

                    dp = (double *)pFirst + indx;
                    if (anObject != nil) {
                        if (! __isSmallInteger(anObject)) {
                            if (__qIsFloatLike(anObject)) {
                                *dp = __floatVal(anObject);
                                RETURN ( anObject );
                            }
                            if (__qIsShortFloat(anObject)) {
                                *dp = (double)__shortFloatVal(anObject);
                                RETURN ( anObject );
                            }
                        } else {
                            *dp = (double) __intVal(anObject);
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(WORDARRAY):
                if (__isSmallInteger(anObject)) {
                    val = __intVal(anObject);
                    if ((unsigned)val <= 0xFFFF) {
                        if ((unsigned INT)indx < (unsigned INT)(nBytes>>1)) {
                            unsigned short *sp;

                            sp = (unsigned short *)(pFirst + (indx<<1));
                            *sp = val;
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(SWORDARRAY):
                if (__isSmallInteger(anObject)) {
                    val = __intVal(anObject);
                    if ((val >= -32768) && (val < 32768)) {
                        if ((unsigned INT)indx < (unsigned INT)(nBytes>>1)) {
                            short *ssp;

                            ssp = (short *)(pFirst + (indx<<1));
                            *ssp = val;
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(SLONGARRAY):
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>2)) {
                    int32 *slp;

                    slp = (int32 *)(pFirst + (indx<<2));
                    if (__isSmallInteger(anObject)) {
                        *slp = __intVal(anObject);
                        RETURN ( anObject );
                    }
                    n = __signedLongIntVal(anObject);
                    /*
                     * zero means failure for an int larger than INT-size bytes
                     * (would be a smallInteger)
                     */
                    if (n) {
# if __POINTER_SIZE__ == 8
                        if ((n >= -0x80000000) && (n < 0x80000000))
# endif
                        {
                            *slp = n;
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(LONGARRAY):
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>2)) {
                    unsigned int32 *lp;

                    lp = (unsigned int32 *)(pFirst + (indx<<2));
                    if (anObject == __mkSmallInteger(0)) {
                        *lp = 0;
                        RETURN ( anObject );
                    }
                    u = __longIntVal(anObject);
                    /*
                     * zero means failure for an int larger than 4 bytes
                     * (would be a smallInteger)
                     */
                    if (u) {
# if __POINTER_SIZE__ == 8
                        if (u <= 0xFFFFFFFF)
# endif
                        {
                            *lp = u;
                            RETURN ( anObject );
                        }
                    }
                }
                break;

            case __MASKSMALLINT(SLONGLONGARRAY):
# ifdef __NEED_LONGLONG_ALIGN
                if ((INT)pFirst & (__LONGLONG_ALIGN-1)) {
                    int delta = __LONGLONG_ALIGN - ((INT)pFirst & (__LONGLONG_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>3)) {
                    __int64__ ll;
                    __int64__ *sllp;

                    sllp = (__int64__ *)(pFirst + (indx<<3));

# if __POINTER_SIZE__ == 8
                    if (__isSmallInteger(anObject)) {
                        *sllp = __intVal(anObject);
                        RETURN ( anObject );
                    }
                    n = __signedLongIntVal(anObject);
                    if (n) {
                        *sllp = n;
                        RETURN ( anObject );
                    }
# else
                    if (anObject == __mkSmallInteger(0)) {
                        ll.lo = ll.hi = 0;
                        *sllp = ll;
                        RETURN ( anObject );
                    }
                    if (__signedLong64IntVal(anObject, &ll)) {
                        *sllp = ll;
                        RETURN ( anObject );
                    }
# endif
                }
                break;

            case __MASKSMALLINT(LONGLONGARRAY):
# ifdef __NEED_LONGLONG_ALIGN
                if ((INT)pFirst & (__LONGLONG_ALIGN-1)) {
                    int delta = __LONGLONG_ALIGN - ((INT)pFirst & (__LONGLONG_ALIGN-1));

                    pFirst += delta;
                    nBytes -= delta;
                }
# endif
                if ((unsigned INT)indx < (unsigned INT)(nBytes>>3)) {
                    __uint64__ ll;
                    __uint64__ *llp;

                    llp = (__uint64__ *)(pFirst + (indx<<3));
# if __POINTER_SIZE__ == 8
                    if (__isSmallInteger(anObject)) {
                        *llp = __intVal(anObject);
                        RETURN ( anObject );
                    }
                    ll = __longIntVal(anObject);
                    if (ll) {
                        *llp = ll;
                        RETURN ( anObject );
                    }
# else
                    if (anObject == __mkSmallInteger(0)) {
                        ll.lo = ll.hi = 0;
                        *llp = ll;
                        RETURN ( anObject );
                    }
                    if (__unsignedLong64IntVal(anObject, &ll)) {
                        *llp = ll;
                        RETURN ( anObject );
                    }
# endif
                }
                break;
        }
    }
#endif /* ! __SCHTEAM__ */
%}.
    index isInteger ifFalse:[
        "
         the index should be an integer number
        "
        ^ self indexNotInteger:index
    ].
    (index between:1 and:self size) ifFalse:[
        "
         the index is less than 1 or greater than the size of the
         receiver collection
        "
        ^ self subscriptBoundsError:index
    ].
    (self class isFloatsOrDoubles) ifTrue:[
        anObject isNumber ifTrue:[
            ^ self basicAt:index put:(anObject asFloat)
        ]
    ].
    anObject isInteger ifFalse:[
        "
         the object to put into the receiver collection
         should be an integer number
        "
        ^ self elementNotInteger
    ].
    "
     the object to put into the receiver collection
     is not an instance of the expected element class,
     or the value is  not within the elements valid range.
    "
    ^ self elementBoundsError:anObject

    "Modified: 19.4.1996 / 11:14:10 / cg"
!

byteAt:index
    "return the byte at index.
     This is only allowed for non-pointer indexed objects
     (i.e. byteArrays, wordArrays, floatArrays etc.).
     The receiver's indexed instvars are treated as an uninterpreted
     collection of bytes.
     Only useful with binary storage."

%{  /* NOCONTEXT */

    if (__isSmallInteger(index)) {
        OBJ slf = self;
        if (__isNonNilObject(slf)) {
            OBJ cls = __qClass(slf);
            INT indx = __intVal(index) - 1;
            INT nIndex = __byteArraySize(slf);
            unsigned char *pFirst = __byteArrayVal(slf) + __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

            switch ((INT)(__ClassInstPtr(cls)->c_flags) & __MASKSMALLINT(ARRAYMASK)) {
                case __MASKSMALLINT(DOUBLEARRAY):
#ifdef __NEED_DOUBLE_ALIGN
                    if ((INT)pFirst & (__DOUBLE_ALIGN-1)) {
                        int delta = __DOUBLE_ALIGN - ((INT)pFirst & (__DOUBLE_ALIGN-1));

                        pFirst += delta;
                        nIndex -= delta;
                    }
#endif
                    goto common;

                case __MASKSMALLINT(FLOATARRAY):
#ifdef __NEED_FLOATARRY_ALIGN
                    if ((INT)pFirst & (__FLOATARRY_ALIGN-1)) {
                        int delta = __FLOATARRY_ALIGN - ((INT)pFirst & (__FLOATARRY_ALIGN-1));

                        pFirst += delta;
                        nIndex -= delta;
                    }
#endif
                    goto common;

                case __MASKSMALLINT(LONGLONGARRAY):
                case __MASKSMALLINT(SLONGLONGARRAY):
#ifdef __NEED_LONGLONG_ALIGN
                    if ((INT)pFirst & (__LONGLONG_ALIGN-1)) {
                        int delta = __LONGLONG_ALIGN - ((INT)pFirst & (__LONGLONG_ALIGN-1));

                        pFirst += delta;
                        nIndex -= delta;
                    }
#endif
                    goto common;

                case __MASKSMALLINT(BYTEARRAY):
                case __MASKSMALLINT(WORDARRAY):
                case __MASKSMALLINT(LONGARRAY):
                case __MASKSMALLINT(SWORDARRAY):
                case __MASKSMALLINT(SLONGARRAY):
            common:
                    if ((unsigned INT)indx < (unsigned INT)nIndex) {
                        RETURN ( __mkSmallInteger( (INT)(pFirst[indx])) );
                    }
                    break;

            }
        }
    }
%}.
    "/ index not integer or index out of range
    "/ or non-byte indexable receiver

    ^ self primitiveFailed

    "
     Point new byteAt:1
     (ByteArray with:1 with:2) byteAt:2
     (WordArray with:1) byteAt:1
     (WordArray with:1) byteAt:2
     (FloatArray with:1.0) byteAt:2
     'hello' byteAt:1
    "
!

byteAt:index put:byteValue
    "set the byte at index.
     This is only allowed for non-pointer indexed objects
     (i.e. byteArrays, wordArrays, floatArrays etc.).
     The receiver's indexed instvars are treated as an uninterpreted
     collection of bytes.
     Only useful with binary storage."

%{  /* NOCONTEXT */

    REGISTER INT indx;
    int val, nIndex;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__bothSmallInteger(index, byteValue)) {
        val = __intVal(byteValue);
        if ((unsigned)(val) <= 0xFF /* i.e. (val >= 0) && (val <= 255) */) {
            slf = self;
            if (__isNonNilObject(slf)) {
                int nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
                cls = __qClass(slf);

                indx = __intVal(index) - 1;
                switch ((INT)(__ClassInstPtr(cls)->c_flags) & __MASKSMALLINT(ARRAYMASK)) {
                    case __MASKSMALLINT(DOUBLEARRAY):
# ifdef __NEED_DOUBLE_ALIGN
                        nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
# endif
                        goto common;

                    case __MASKSMALLINT(FLOATARRAY):
# ifdef __NEED_FLOATARRAY_ALIGN
                        nInstBytes = (nInstBytes-1+__FLOATARRAY_ALIGN) &~ (__FLOATARRAY_ALIGN-1);
# endif
                        goto common;

                    case __MASKSMALLINT(LONGLONGARRAY):
                    case __MASKSMALLINT(SLONGLONGARRAY):
# ifdef __NEED_LONGLONG_ALIGN
                        nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
# endif
                        goto common;

                    case __MASKSMALLINT(BYTEARRAY):
                    case __MASKSMALLINT(WORDARRAY):
                    case __MASKSMALLINT(LONGARRAY):
                    case __MASKSMALLINT(SWORDARRAY):
                    case __MASKSMALLINT(SLONGARRAY):
                common:
                        indx += nInstBytes;
                        nIndex = __byteArraySize(slf);
                        if ((unsigned INT)indx < (unsigned INT)nIndex) {
                            __ByteArrayInstPtr(slf)->ba_element[indx] = val;
                            RETURN ( byteValue );
                        }
                        break;
                }
            }
        }
    }
%}.
    "/ index not integer or index out of range
    "/ or non-byte indexable receiver

    ^ self primitiveFailed

    "
     (ByteArray with:1 with:2) byteAt:2 put:3; yourself
     'hello' copy byteAt:1 put:105; yourself
    "
!

instVarAt:index
    "return a non-indexed instance variable;
     peeking into an object this way is not very object oriented
     - use with care (needed for copy, inspector etc.)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.instVarAt(index.intValue()-1) );
#else
    OBJ myClass;
    int idx, ninstvars;

    if (__isSmallInteger(index)) {
        myClass = __Class(self);
        idx = __intVal(index) - 1;
        /*
         * do not allow returning of non-object fields.
         * if subclass did not make provisions for that,
         * we won't do so here ...
         */
        if (((INT)(__ClassInstPtr(myClass)->c_flags) & __MASKSMALLINT(NONOBJECT_INSTS))) {
            if (idx == 0) {
                RETURN ( nil )
            }
        }
        ninstvars = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
        if ((idx >= 0) && (idx < ninstvars)) {
            // do not trust the ninstvars slot - verify
            if ((__OBJS2BYTES__(ninstvars) + OHDR_SIZE) <= __qSize(self)) {
                RETURN ( __InstPtr(self)->i_instvars[idx] );
            }
            console_printf("[VM] warning: bad ninsts in class\n");
        }
    }
#endif /* not SCHTEAM */
%}.
    ^ self indexNotIntegerOrOutOfBounds:index
!

instVarAt:index put:value
    "change a non-indexed instance variable;
     peeking into an object this way is not very object oriented
     - use with care (needed for copy, inspector etc.)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    self.instVarAt_put(index.intValue()-1, value);
    return context._RETURN( value );
#else
    OBJ myClass;
    int idx, ninstvars;

    if (__isSmallInteger(index)) {
        myClass = __Class(self);
        idx = __intVal(index) - 1;
        ninstvars = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
        /*
         * do not allow setting of non-object fields.
         * if subclass did not make provisions for that,
         * we won't do so here ...
         */
        if (((INT)(__ClassInstPtr(myClass)->c_flags) & __MASKSMALLINT(NONOBJECT_INSTS))) {
            if (idx == 0) {
                RETURN ( nil )
            }
        }
        if ((idx >= 0) && (idx < ninstvars)) {
            // do not trust the ninstvars slot - verify
            if ((__OBJS2BYTES__(ninstvars) + OHDR_SIZE) <= __qSize(self)) {
                __InstPtr(self)->i_instvars[idx] = value;
                __STORE(self, value);
                RETURN ( value );
            }
            console_printf("[VM] warning: bad ninsts in class\n");
        }
    }
#endif /* not SCHTEAM */
%}.
    ^ self indexNotIntegerOrOutOfBounds:index
!

instVarNamed:name
    "return a non-indexed instance variables value by name;
     peeking into an object this way is not very object oriented
     - use with care if at all (provided for inspectors and memory usage monitor).
     Notice, this access is very slow (because the classes instVar-description has to be
     parsed ad runtime)"

    |idx|

    idx := self class instVarIndexFor:name.
    idx isNil ifTrue:[
        ^ self errorKeyNotFound:name.
    ].
    ^ self instVarAt:idx.


    "
     |p|

     p := Point x:10 y:20.
     p instVarNamed:'cx'
    "

    "Modified: 19.4.1996 / 11:12:39 / cg"
!

instVarNamed:name ifAbsent:exceptionBlock
    "return a non-indexed instance variables value by name,
     or the value of exceptionBlock, if there is no such instance variable.
     peeking into an object this way is not very object oriented
     - use with care if at all (provided for inspectors and memory usage monitor).
     Notice, this access is very slow (because the classes instVar-description has to be
     parsed ad runtime)"

    |idx|

    idx := self class instVarIndexFor:name.
    idx isNil ifTrue:[^ exceptionBlock value].
    ^ self instVarAt:idx


    "
     |p|

     p := Point x:10 y:20.
     p instVarNamed:'x'
    "

    "Created: 6.7.1996 / 23:02:49 / cg"
    "Modified: 6.7.1996 / 23:03:41 / cg"
!

instVarNamed:name put:value
    "set a non-indexed instance variable by name;
     peeking into an object this way is not very object oriented
     - if at all, use with care (provided for protocol completeness).
     Notice, this access is very slow (because the classes instVar-description has to be
     parsed ad runtime)"

    |idx|

    idx := self class instVarIndexFor:name.
    idx isNil ifTrue:[
        ^ self errorKeyNotFound:name.
    ].
    ^ self instVarAt:idx put:value.

    "
     |p|

     p := Point x:10 y:20.
     p instVarNamed:'x' put:30.
     p
    "

    "Modified: 19.4.1996 / 11:12:49 / cg"
!

instVarNamed:name put:anObject ifAbsent:exceptionBlock
    "return a non-indexed instance variables value by name,
     or the value of exceptionBlock, if there is no such instance variable.
     peeking into an object this way is not very object oriented
     - use with care if at all (provided for inspectors and memory usage monitor).
     Notice, this access is very slow (because the classes instVar-description has to be
     parsed ad runtime)"

    |idx|

    idx := self class instVarIndexFor:name.
    idx isNil ifTrue:[^ exceptionBlock value].
    ^ self instVarAt:idx put:anObject.


    "
     |p|

     p := Point x:10 y:20.
     p instVarNamed:'x' put:4711 ifAbsent:[self halt:'no such instvar'].
     p instVarNamed:'bla' put:4712 ifAbsent:[self halt:'no such instvar'].
     p inspect.
    "

    "Created: 6.7.1996 / 23:02:49 / cg"
    "Modified: 6.7.1996 / 23:03:41 / cg"
!

nilAllInstvars
    "overwrite all inst vars of the object with nil.
     Used by the crypto package to clear objects with
     keys when no longer in use."

%{  /* NOCONTEXT */
    int flags;

    if (!__isNonNilObject(self)) {
        RETURN(self);
    }
    /*
     * bail out for special (weak) objects ..
     */
    flags = __intVal(__ClassInstPtr(__qClass(self))->c_flags);
    if (((flags & ~ARRAYMASK) == 0)
        && ((flags & ARRAYMASK) != WKPOINTERARRAY)
    ) {
        bzero((void *)__InstPtr(self)->i_instvars, __qSize(self)-OHDR_SIZE);
        RETURN(self);
    }
%}.
    "/ fail for special objects
    ^ self primitiveFailed

    "
      'abcdef' copy nilAllInstvars
      100 factorial nilAllInstvars
    "
! !



!Object methodsFor:'attributes access'!

objectAttributeAt:attributeKey
    "return the attribute for a given key or nil if not found"

    | attrs |

    attrs := self objectAttributes.
    attrs size ~~ 0 ifTrue:[
        ^ attrs at:attributeKey ifAbsent:[]
    ].
    ^ nil

    "Created: / 22.1.1998 / 21:29:17 / av"
    "Modified: / 3.2.1998 / 18:55:55 / cg"
!

objectAttributeAt:attributeKey put:anObject
    "store the attribute anObject referenced by key into the receiver"

    "/ must do this save from being reentered, since the attributes collection
    "/ is possibly accessed from multiple threads...
    ObjectAttributesAccessLock critical:[
        | attrs |

        attrs := self objectAttributes.
        "/ only need a WeakIdentityDictionary, if there are any non-symbol keys in
        "/ it. Start with a regular IDDict, and migrate to WeakIDDict if ever required.
        "/ Typically, this never happens (but does in the UIPainter!!)
        attrs isEmptyOrNil ifTrue:[
            attributeKey isSymbol ifTrue:[
                attrs := IdentityDictionary new.
            ] ifFalse:[
                attrs := WeakIdentityDictionary new.
            ].
            attrs at:attributeKey put:anObject.
            self objectAttributes:attrs.
        ] ifFalse:[
            attributeKey isSymbol ifFalse:[
                attrs isWeakCollection ifFalse:[
                    "first non-symbol attributeKey - convert to WeakIdentityDictionary"
                    attrs := WeakIdentityDictionary new declareAllFrom:attrs.
                    self objectAttributes:attrs.
                ].
            ].
            attrs at:attributeKey put:anObject.
        ].
    ]

    "Attaching additional attributes (slots) to an arbitrary object:

     |p|

     p := Point new.
     p objectAttributeAt:#color put:#green.

     p objectAttributeAt:#color
    "

    "Created: / 22.1.1998 / 21:29:25 / av"
    "Modified: / 3.2.1998 / 18:57:58 / cg"
!

objectAttributes
    "return a Collection of attributes - nil if there is none.
     The default implementation here uses a global WeakDictionary to store
     attributes
     This may be too slow for high frequency slot access,
     therefore, some classes may redefine this for better performnce.
     Notice the mentioning of a WeakDictionary - read the classes documentation."

    ^ ObjectAttributes at:self ifAbsent:[nil]

    "Created: / 22.1.1998 / 21:29:30 / av"
    "Modified: / 18.2.2000 / 11:34:16 / cg"
!

objectAttributes:aCollection
    "set the collection of attributes.
     The default implementation here uses a global Dictionary to store
     attributes which may be too slow for high frequency change&update.
     Therefore, some classes may redefine this for better performance."

    "/ must do this save from being reentered, since the attributes collection
    "/ is possibly accessed from multiple threads.

    ObjectAttributesAccessLock critical:[
        aCollection isEmptyOrNil ifTrue:[
            ObjectAttributes removeKey:self ifAbsent:nil
        ] ifFalse:[
            ObjectAttributes at:self put:aCollection
        ].
    ]

    "Created: / 22.1.1998 / 21:29:35 / av"
    "Modified: / 3.2.1998 / 18:58:10 / cg"
!

removeObjectAttribute:attributeKey
    "remove an object attribute;
     return the value previously stored there, or nil.
     (make the argument, anObject be no longer an attribute of the receiver)"

    |oldVal|

    "/ must do this save from being reentered, since the attributes collection
    "/ is possibly accessed from multiple threads.
    ObjectAttributesAccessLock critical:[
        |attrs|

        attrs := self objectAttributes.
        attrs notNil ifTrue:[
            attrs size ~~ 0 ifTrue:[
                oldVal := attrs removeKey:attributeKey ifAbsent:nil.
            ].
            attrs size == 0 ifTrue:[
                self objectAttributes:nil
            ].
        ]
    ].
    ^ oldVal

    "Created: / 22.1.1998 / 21:29:39 / av"
    "Modified: / 18.2.2000 / 11:32:19 / cg"
! !




!Object methodsFor:'change & update'!

broadcast:aSelectorSymbol
    "send a message with selector aSelectorSymbol to all my dependents"

    self dependentsDo:[:dependent |
        dependent perform:aSelectorSymbol
    ]
!

broadcast:aSelectorSymbol with:anArgument
    "send a message with selector aSelectorSymbol with an additional
     argument anArgument to all my dependents."

    self dependentsDo:[:dependent |
        dependent perform:aSelectorSymbol with:anArgument
    ]
!

changeRequest
    "the receiver wants to change - check if all dependents
     grant the request, and return true if so"

    self dependentsDo:[:dependent |
        dependent updateRequest ifFalse:[^ false].
    ].
    ^ true
!

changeRequest:aSymbol
    "the receiver wants to change - check if all dependents
     grant the request, and return true if so"

    self dependentsDo:[:dependent |
        (dependent updateRequest:aSymbol) ifFalse:[^ false].
    ].
    ^ true
!

changeRequest:aSymbol from:anObject
    "the receiver wants to change - check if all dependents
     except anObject grant the request, and return true if so.
     The argument anObject is typically going to be the one who is
     about to send the change request."

    ^ self changeRequest:aSymbol with:nil from:anObject
!

changeRequest:aSymbol with:aParameter
    "the receiver wants to change - check if all dependents
     grant the request, and return true if so"

    ^ self changeRequest:aSymbol with:aParameter from:self
!

changeRequest:aSymbol with:aParameter from:anObject
    "the receiver wants to change - check if all dependents
     except anObject grant the request, and return true if so.
     The argument anObject is typically going to be the one who is
     about to send the change request."

    self dependentsDo:[:dependent |
        dependent == anObject ifFalse:[
            (dependent updateRequest:aSymbol with:aParameter from:anObject) ifFalse:[^ false].
        ]
    ].
    ^ true
!

changeRequestFrom:anObject
    "the receiver wants to change - check if all dependents
     except anObject grant the request, and return true if so.
     The argument anObject is typically going to be the one who is
     about to send the change request."

    self dependentsDo:[:dependent |
        dependent == anObject ifFalse:[
            (dependent updateRequest) ifFalse:[^ false].
        ]
    ].
    ^ true
!

changed
    "notify all dependents that the receiver has changed.
     Each dependent gets a '#update:'-message with the original
     receiver as argument."

    self changed:nil
!

changed:aParameter
    "notify all dependents that the receiver has changed somehow.
     Each dependent gets a '#update:'-message with aParameter
     as argument."

    self changed:aParameter with:nil
!

changed:aParameter with:anArgument
    "notify all dependents that the receiver has changed somehow.
     Each dependent gets an '#update:with:from:'-message, with aParameter
     and anArgument as arguments."

    self dependentsDo:[:dependent |
        dependent update:aParameter with:anArgument from:self
    ]
!

update:aParameter
    "the message is sent to a dependent, when one of the objects
     on whom the receiver depends, has changed. The argument aParameter
     is either the changed object or the argument to the #changed: message.

     Default behavior here is to do nothing"

    ^ self
!

update:aParameter with:anArgument
    "dependent is notified of some change -
     Default is to try update:"

    ^ self update:aParameter
!

update:aParameter with:anArgument from:sender
    "dependent is notified of some change -
     Default is to try update:with:"

    ^ self update:aParameter with:anArgument
!

updateRequest
    "return true if an update request is granted.
     Default here is to grant updates - may be used
     to lock updates if someone is making other changes
     from within an update. Or if someone has locked its
     state and does not want others to change things.
     However, these dependents must all honor the
     changeRequest - ifTrue - change protocol. I.e. they
     must first ask all others via changeRequest, and only do the change
     it returns true. The others must decide in updateRequest and
     return true if they think a change is ok."

    ^ true
!

updateRequest:aSymbol
    "return true if an update request is granted.
     Default here a simple updateRequest"

    ^ self updateRequest
!

updateRequest:aSymbol with:aParameter
    "return true if an update request is granted.
     Default here a simple updateRequest"

    ^ self updateRequest:aSymbol
!

updateRequest:aSymbol with:aParameter from:sender
    "return true if an update request is granted.
     Default here a simple updateRequest"

    ^ self updateRequest:aSymbol with:aParameter
!

withoutUpdating:someone do:aBlock
    "evaluate a block but remove someone from my dependents temporarily"

    (self dependents includesIdentical:someone)
    ifFalse:[
        ^ aBlock value.
    ].
    self removeDependent:someone.
    ^ aBlock ensure:[ self addDependent:someone ]
! !


!Object methodsFor:'comparing'!

= anObject
    "return true if the receiver and the arg have the same structure.
     Notice:
        This method is partially open coded (inlined) by the compiler(s)
        identical objects are always considered equal.
        redefining it may not work as expected."

    ^ self == anObject
!

== anObject
    "return true if the receiver and the arg are the same object.
     Never redefine this in any class.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( (self == anObject) ? STObject.True : STObject.False );
#else
    RETURN ( (self == anObject) ? true : false );
#endif
%}
!

deepSameContentsAs:anObject
    "return true if the receiver and the arg have the same contents
     in both the named instance vars and any indexed instVars.
     This method descends into referenced objects, where #sameContentsAs: does not descend"

    |myClass val
     sz "{ Class: SmallInteger }" |

    myClass := self class.
    myClass isVariable ifTrue:[
        sz := self basicSize.

        "compare the indexed variables"
        1 to:sz do:[:i |
            val := self basicAt:i.
            val isLiteral ifTrue:[
                val = (anObject basicAt:i) ifFalse:[^ false].
            ] ifFalse:[
                (val deepSameContentsAs:(anObject basicAt:i)) ifFalse:[^ false].
            ]
        ]
    ].

    "compare the instance variables"
    sz := myClass instSize.
    1 to:sz do:[:i |
        val := self instVarAt:i.
        val isLiteral ifTrue:[
            val = (anObject instVarAt:i) ifFalse:[^ false].
        ] ifFalse:[
            (val deepSameContentsAs:(anObject instVarAt:i)) ifFalse:[^ false].
        ]
    ].

    ^ true

    "
     #(1 2 3 4) deepSameContentsAs:#[1 2 3 4] asArray
     (1@2) deepSameContentsAs:(1->2)
    "
!

hash
    "return an Integer useful as a hash key for the receiver.
     This hash should return same values for objects with same
     contents (i.e. use this to hash on structure)"

    ^ self identityHash
!

identityHash
    "return an Integer useful as a hash key for the receiver.
     This hash should return same values for the same object (i.e. use
     this to hash on identity of objects).

     We cannot use the Objects address (as other smalltalks do) since
     no object-table exists and the hashval must not change when objects
     are moved by the collector. Therefore we assign each object a unique
     Id in the object header itself as its hashed upon.
     (luckily we have 11 bits spare to do this - unluckily its only 11 bits).
     Time will show, if 11 bits are enough; if not, another entry in the
     object header will be needed, adding 4 bytes to every object. Alternatively,
     hashed-upon objects could add an instvar containing the hash value."

%{  /* NOCONTEXT */

    REGISTER unsigned INT hash;
    static unsigned nextHash = 0;

    if (__isNonNilObject(self)) {
        hash = __GET_HASH(self);
        if (hash == 0) {
            /* has no hash yet */

            if (++nextHash > __MAX_HASH__) {
                nextHash = 1;
            }
            hash = nextHash;
            __SET_HASH(self, hash);
        }

        /*
         * now, we got 11 bits for hashing;
         * make it as large as possible; since most hashers use the returned
         * key and take it modulo some prime number, this will allow for
         * better distribution (i.e. bigger empty spaces) in hashed collection.
         */
        hash = __MAKE_HASH__(hash);
        RETURN ( __mkSmallInteger(hash) );
    }
%}.
    ^ 0 "never reached, since redefined in UndefinedObject and SmallInteger"
!

identityHashForBinaryStore
    "hash which is usable if the object does not change its class
     and does not #become something else, while the hash is used.
     This is only used by the binary storage mechanism, during the
     object writing phase."

%{  /* NOCONTEXT */

    REGISTER unsigned INT hash, hash1, hash2, sz;
    OBJ o;
    static unsigned INT nextHash = 0;
    static unsigned INT nextClassHash = 0;

    if (__isNonNilObject(self)) {
        /*
         * my own identityHash
         */
        hash1 = __GET_HASH(self);
        if (hash1 == 0) {
            /* has no hash yet */

            if (++nextHash > __MAX_HASH__) {
                nextHash = 1;
            }
            hash1 = nextHash;
            __SET_HASH(self, hash1);
        }
        /*
         * my classes identityHash
         */
        o = __qClass(self);
        hash2 = __GET_HASH(o);
        if (hash2 == 0) {
            /* has no hash yet */

            if (++nextClassHash > __MAX_HASH__) {
                nextClassHash = 1;
            }
            hash2 = nextClassHash;
            __SET_HASH(o, hash2);
        }

        /*
         * some bits of my size
         */
        sz = __qSize(self);

        /*
         * now, we got 11 + 11 + 8 bits for hashing;
         * make it as large as possible; since most hashers use the returned
         * key and take it modulo some prime number, this will allow for
         * better distribution (i.e. bigger empty spaces) in hashed collection.
         */
        hash = (hash1 << 11) | hash2;           /* 22 bits */
        hash = (hash << 8) | (sz & 0xFC);       /* 30 bits */

        while ((hash & 0x20000000) == 0) {
            hash <<= 1;
        }

        RETURN ( __mkSmallInteger(hash) );
    }
%}.
    "never reached, since UndefinedObject and SmallInteger are not hashed upon in binary storage"
    ^ self identityHash
!

sameContentsAs:anObject
    "return true if the receiver and the arg have the same contents
     in both the named instance vars and any indexed instVars.
     The code here only checks if values present in the receiver are also
     present in the arg, not vice versa.
     I.e. the argument may be bigger and/or have more instance variables."

    |myClass
     sz "{ Class: SmallInteger }" |

    myClass := self class.
    myClass isVariable ifTrue:[
        sz := self basicSize.
        anObject basicSize >= sz ifFalse:[^ false].

        "compare the indexed variables"
        1 to:sz do:[:i |
            (self basicAt:i) == (anObject basicAt:i) ifFalse:[^ false].
        ]
    ].

    "compare the instance variables"
    sz := myClass instSize.
    anObject class instSize >= sz ifFalse:[^ false].

    1 to:sz do:[:i |
        (self instVarAt:i) == (anObject instVarAt:i) ifFalse:[^ false].
    ].

    ^ true

    "
     #(1 2 3 4) sameContentsAs:#[1 2 3 4] asArray
     (1@2) sameContentsAs:(1->2)
    "

    "Created: / 21-04-1998 / 15:56:40 / cg"
    "Modified: / 05-08-2010 / 16:44:09 / sr"
!

~= anObject
    "return true if the receiver and the arg do not have the same structure.
     Notice:
        This method is partially open coded (inlined) by the compiler(s)
        identical objects are never considered unequal.
        redefining it may not work as expected."

    ^ (self = anObject) not
!

~~ anObject
    "return true if the receiver and the arg are not the same object.
     Never redefine this in any class.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( (self == anObject) ? STObject.False : STObject.True );
#else
    RETURN ( (self == anObject) ? false : true );
#endif
%}
! !

!Object methodsFor:'converting'!

-> anObject
    "return an association with the receiver as key and
     the argument as value"

    ^ Association key:self value:anObject
!

as:aSimilarClass
    "If the receiver's class is not aSimilarClass,
     create and return an instance of aSimilarClass that has the same contents
     as the receiver.
     Otherwise, return the receiver."

    self class == aSimilarClass ifTrue:[^ self].
    ^ aSimilarClass newFrom:self

    "
     #[1 2 3 4] as:ByteArray
     #[1 2 3 4] as:Array
     #[81 82 83 84] as:String
     #[81 82 83 84] as:Symbol
     'hello' as:Unicode16String
    "
!

asCollection
    "return myself as a Collection.
     Redefined in collection to return themself."

    ^ Array with:self
!

asCollectionDo:aBlock
    "enumerate myself as a Collection.
     Redefined in collection."

    ^ aBlock value:self
!

asLink
    "return a valueLink for the receiver.
     Used to make sure the receiver can be added to a linked list"

    ^ ValueLink value:self
!

asSequenceableCollection
    "return myself as a SequenceableCollection.
     Redefined in SequenceableCollection"

    ^ Array with:self
!

asString
    ^ self printString
!

asValue
    "return a valueHolder for the receiver"

    ^ ValueHolder with:self
! !

!Object methodsFor:'copying'!

cloneFrom:anObject
    "Helper for copy:
     copy all instance variables from anObject into the receiver,
     which should be of the same class as the argument."

    self cloneFrom:anObject performing:#yourself

    "
     |x|

     x := Array new:3.
     x cloneFrom:#(1 2 3).
    "
!

cloneFrom:anObject performing:aSymbol
    "Helper for copy:
     for each instance variable from anObject, send it aSymbol
     and store the result into the receiver,
     which should be of the same class as the argument."

    |myClass sz "{ Class: SmallInteger }" t |

    myClass := self class.

    "process the named instance variables"
    sz := myClass instSize.
    1 to:sz do:[:i |
        t := anObject instVarAt:i.
        aSymbol ~~ #yourself ifTrue:[
            t := t perform:aSymbol
        ].
        self instVarAt:i put:t
    ].

    myClass isVariable ifTrue:[
        sz := self basicSize.

        "process the indexed instance variables"
        1 to:sz do:[:i |
            t := anObject basicAt:i.
            aSymbol ~~ #yourself ifTrue:[
                t := t perform:aSymbol.
            ].
            self basicAt:i put:t.
        ]
    ].
!

cloneInstanceVariablesFrom:aPrototype
    "Shallow copy variables from a prototype into myself.
     This copies instVars by name - i.e. same-named variables are
     copied, others are not.
     The variable slots are copied as available
     (i.e. the min of both indexed sizes is used)."

    |myClass prototypesClass myInfo prototypesInfo
     sz "{ Class: SmallInteger }"|

    myClass := self class.
    prototypesClass := aPrototype class.
    (myClass == prototypesClass
     or:[myClass isSubclassOf:prototypesClass]) ifTrue:[
        "/ can do better, if my class is a subclass of the prototype's class
        sz := prototypesClass instSize.
        1 to: sz do:[:index |
            self instVarAt:index put:(aPrototype instVarAt:index)
        ]
    ] ifFalse:[
        "/ map instvars by name
        myInfo := myClass instanceVariableOffsets.
        prototypesInfo := prototypesClass instanceVariableOffsets.
        myInfo keysAndValuesDo:[:name :index | |varIndexAssoc|
            varIndexAssoc := prototypesInfo at:name ifAbsent:[].
            varIndexAssoc notNil ifTrue:[
                self instVarAt:index put:(aPrototype instVarAt:(varIndexAssoc value))
            ]
        ]
    ].
    myClass isVariable ifTrue:[
        prototypesClass isVariable ifTrue:[
            sz := self basicSize min:aPrototype basicSize.
            1 to:sz do:[:index |
                self basicAt:index put:(aPrototype basicAt:index)
            ].
        ].
    ].

    "
     Class withoutUpdatingChangesDo:[
        |point3D|

        point3D := Point subclass:#Point3D
           instanceVariableNames:'z'
           classVariableNames:''
           poolDictionaries:''
           category:'testing'
           inEnvironment:nil.
         (point3D new cloneInstanceVariablesFrom:1@2) inspect.
     ]
    "

    "
     Class withoutUpdatingChangesDo:[
         Point variableSubclass:#Point3D_test
           instanceVariableNames:'z'
           classVariableNames:''
           poolDictionaries:''
           category:'testing'.
         (((Smalltalk at:#Point3D_test) new:2) cloneInstanceVariablesFrom:#(1 2 3)) inspect.
     ]
    "

    "
     |someObject|

     Class withoutUpdatingChangesDo:[
         Object subclass:#TestClass1
           instanceVariableNames:'foo bar'
           classVariableNames:''
           poolDictionaries:''
           category:'testing'.
         someObject := TestClass1 new.
         someObject instVarAt:1 put:'foo'; instVarAt:2 put:'bar'.
         Object subclass:#TestClass2
           instanceVariableNames:'bar foo'
           classVariableNames:''
           poolDictionaries:''
           category:'testing'.
         (TestClass2 new cloneInstanceVariablesFrom:someObject) inspect.
     ]
    "

    "
     |top b b1|

     top := StandardSystemView new.
     top extent:100@100.

     b := Button in:top.
     b label:'hello'.

     b1 := ArrowButton new cloneInstanceVariablesFrom:b.

     top open.
     b1 inspect
    "
!

copy
    "return a copy of the receiver - defaults to shallowcopy here.
     Notice, that copy does not copy dependents."

    ^ self shallowCopy postCopy
!

copyToLevel:level
    "a controlled deepCopy, where the number of levels can be specified.
     Notice:
         This method DOES NOT handle cycles/self-refs and does NOT preserve object identity;
         i.e. identical references in the source are copied multiple times into the copy."

    |newObject newLevel class sz "{Class: SmallInteger}" newInst|

    newObject := self copy.
    newObject == self ifTrue: [^ self].   "copy of nil, true, false, ... is self"
    level == 1 ifTrue:[^ newObject].
    newLevel := level - 1.

    class := newObject class.

    "process the named instance variables"
    sz := class instSize.
    1 to:sz do:[:i |
        newInst := newObject instVarAt:i.
        newInst notNil ifTrue:[
            newObject instVarAt:i put:(newInst copyToLevel:newLevel).
        ].
    ].

    class isVariable ifTrue:[
        sz := newObject basicSize.

        "process the indexed instance variables"
        1 to:sz do:[:i |
            newInst := newObject basicAt:i.
            newInst notNil ifTrue:[
                newObject basicAt:i put:(newInst copyToLevel:newLevel).
            ].
        ]
    ].
    ^ newObject

    "
     |a b|

     a := #(
            '1.1'
            '1.2'
            '1.3'
            (
                '1.41'
                '1.42'
                '1.43'
                    (
                        '1.441'
                        '1.442'
                        '1.443'
                        ( '1.4441' '1.4442' '1.4443' )
                        '1.445'
                    )
                '1.45'
            )
            '1.5'
           ).

      b := a copyToLevel:1.
      self assert: ( (a at:1) == (b at:1) ).
      self assert: ( (a at:4) == (b at:4) ).

      b := a copyToLevel:2.
      self assert: ( (a at:1) ~~ (b at:1) ).
      self assert: ( (a at:4) ~~ (b at:4) ).
      self assert: ( ((a at:4) at:1) == ((b at:4) at:1) ).
      self assert: ( ((a at:4) at:4) == ((b at:4) at:4) ).

      b := a copyToLevel:3.
      self assert: ( (a at:1) ~~ (b at:1) ).
      self assert: ( (a at:4) ~~ (b at:4) ).
      self assert: ( ((a at:4) at:1) ~~ ((b at:4) at:1) ).
      self assert: ( ((a at:4) at:4) ~~ ((b at:4) at:4) ).
      self assert: ( (((a at:4) at:4) at:1) == (((b at:4) at:4)at:1) ).
      self assert: ( (((a at:4) at:4) at:4) == (((b at:4) at:4)at:4) ).
    "
!

deepCopy
    "return a copy of the object with all subobjects also copied.
     This method DOES handle cycles/self-refs and preserves object identity;
     however the receiver's class is not copied (to avoid the 'total' copy).

     This deepCopy is a bit slower than the old (unsecure) one, since it
     keeps track of already copied objects. If you are sure, that your
     copied object does not include duplicates (or you do not care) and
     no cycles are involved, you can use the old simpleDeepCopy,
     which avoids this overhead (but may run into trouble).
     Notice, that deepCopy does not copy dependents."

    ^ self deepCopyUsing:(IdentityDictionary new)

    "an example which is not handled by the old deepCopy:

     |a|
     a := Array new:3.
     a at:3 put:a.
     a deepCopy inspect
    "

    "
     |a|
     a := Color black onDevice:Screen current.
     a deepCopy inspect
    "

    "Modified: 27.3.1996 / 16:31:20 / stefan"
!

deepCopyError
    "{ Pragma: +optSpace }"

    "raise a signal, that deepCopy is not allowed for this object"

    ^ DeepCopyError raise
!

deepCopyUsing:aDictionary
    "a helper for deepCopy; return a copy of the object with
     all subobjects also copied. If the to-be-copied object is in the dictionary,
     use the value found there. The class of the receiver is not copied.
     This method DOES handle cycles/self references."

    ^ self deepCopyUsing:aDictionary postCopySelector:#postDeepCopyFrom:.


    "
     |a b c copyOfC|

     a := Array with:'hello' with:'world' with:nil.
     b := 99 @ 999.
     a at:3 put:b.
     c := Array with:a with:b with:a.

     Transcript showCR: (c at:1) == (c at:3).
     copyOfC := c deepCopy.
     Transcript showCR: (copyOfC at:1) == (copyOfC at:3)
    "
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "a helper for deepCopy; return a copy of the object with
     all subobjects also copied. If the to-be-copied object is in the dictionary,
     use the value found there. The class of the receiver is not copied.
     This method DOES handle cycles/self references."

    |myClass aCopy
     basicSize "{ Class: SmallInteger }"
     instSize  "{ Class: SmallInteger }"
     iOrig iCopy|

    myClass := self class.
    myClass isVariable ifTrue:[
        basicSize := self basicSize.
        aCopy := self speciesForCopy basicNew:basicSize.
    ] ifFalse:[
        basicSize := 0.
        aCopy := self speciesForCopy basicNew
    ].
    aCopy setHashFrom:self.
    aDictionary at:self put:aCopy.

    "
     copy the instance variables
    "
    instSize := myClass instSize.
    1 to:instSize do:[:i |
        (self skipInstvarIndexInDeepCopy:i) ifFalse:[
            iOrig := self instVarAt:i.
            iOrig notNil ifTrue:[
                iCopy := aDictionary at:iOrig ifAbsent:nil.
                iCopy isNil ifTrue:[
                    iCopy := iOrig deepCopyUsing:aDictionary postCopySelector:postCopySelector
                ].
                aCopy instVarAt:i put:iCopy
            ]
        ]
    ].

    "
     copy indexed instvars - if any
    "
    basicSize ~~ 0 ifTrue:[
        myClass isBits ifTrue:[
            "block-copy indexed instvars"
            aCopy replaceFrom:1 to:basicSize with:self startingAt:1
        ] ifFalse:[
            "individual deep copy the indexed variables"
            1 to:basicSize do:[:i |
                iOrig := self basicAt:i.
                iOrig notNil ifTrue:[
                    "/ used to be dict-includesKey-ifTrue[dict-at:],
                    "/ changed to use dict-at:ifAbsent:, to avoid double lookup in dictionary
                    iCopy := aDictionary at:iOrig ifAbsent:nil.
                    iCopy isNil ifTrue:[
                        iCopy := iOrig deepCopyUsing:aDictionary postCopySelector:postCopySelector
                    ].
                    aCopy basicAt:i put:iCopy
                ]
            ]
        ]
    ].

    aCopy perform:postCopySelector withOptionalArgument:self and:aDictionary.
    ^ aCopy

    "Modified: / 21-07-2011 / 13:30:52 / cg"
!

postCopy
    "this is for compatibility with ST-80 code, which uses postCopy for
     cleanup after copying, while ST/X passes the original in postCopyFrom:
     (see there)"

    ^ self
!

postDeepCopy
    "allows for cleanup after deep copying.
     To be redefined in subclasses."
!

postDeepCopyFrom:aSource
    "allows for cleanup after deep copying"

    ^ self postDeepCopy
!

setHashFrom:anObject
    "set my identity-hash key to be the same as anObjects hash key.
     This is an ST/X speciality, which is NOT available in other (especially OT based)
     Smalltalks, and may not be available in future ST/X versions.
     DO NEVER use this for normal application code."

%{  /* NOCONTEXT */

    REGISTER unsigned h;

    if (__isNonNilObject(self) && __isNonNilObject(anObject)) {
        h = __GET_HASH(anObject);
        __SET_HASH(self, h);
        RETURN (self);
    }
%}.
    self primitiveFailed    "neither receiver not arg may be nil or SmallInteger"
!

shallowCopy
    "return a copy of the object with shared subobjects (a shallow copy)
     i.e. the copy shares referenced instvars with its original."

%{  /* NOCONTEXT */
    int ninsts, spc;
    int sz;
    OBJ theCopy;
    OBJ cls;
    int flags;

    cls = __qClass(self);
    flags = __intVal(__ClassInstPtr(cls)->c_flags);

    /*
     * bail out for special objects ..
     */
    if (((flags & ~ARRAYMASK) == 0)
     && ((flags & ARRAYMASK) != WKPOINTERARRAY)) {
        sz = __qSize(self);
        __PROTECT__(self);
        __qNew(theCopy, sz);    /* OBJECT ALLOCATION */
        __UNPROTECT__(self);
        if (theCopy) {
            cls = __qClass(self);
            spc = __qSpace(theCopy);

            theCopy->o_class = cls; __STORE_SPC(theCopy, cls, spc);

            sz = sz - OHDR_SIZE;
            if (sz) {
                char *src, *dst;

                src = (char *)(__InstPtr(self)->i_instvars);
                dst = (char *)(__InstPtr(theCopy)->i_instvars);
#ifdef bcopy4
                {
                    /* care for odd-number of longs */
                    int nW = sz >> 2;

                    if (sz & 3) {
                        nW++;
                    }

                    bcopy4(src, dst, nW);
                }
#else
                bcopy(src, dst, sz);
#endif

                flags &= ARRAYMASK;
                if (flags == POINTERARRAY) {
                    ninsts = __BYTES2OBJS__(sz);
                } else {
                    ninsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
                }
                if (ninsts) {
                    do {
                        OBJ el;

                        el = __InstPtr(theCopy)->i_instvars[ninsts-1];
                        __STORE_SPC(theCopy, el, spc);
                    } while (--ninsts);
                }
            }
            RETURN (theCopy);
        }
    }
%}.
    "/ fallBack for special objects & memoryAllocation failure case

    ^ self slowShallowCopy
!

simpleDeepCopy
    "return a copy of the object with all subobjects also copied.
     This method does NOT handle cycles - but is included to allow this
     slightly faster copy in situations where it is known that
     no recursive references occur (LargeIntegers for example).
     NOTICE: you will run into trouble, when trying this with recursive
     objects (usually recursionInterrupt or memory-alert).
     This method corresponds to the 'traditional' deepCopy found in the Blue book."

    |myClass aCopy|

    (myClass := self class) isVariable ifTrue:[
        aCopy := myClass basicNew:(self basicSize).
    ] ifFalse:[
        aCopy := myClass basicNew
    ].

    "copy the instance variables"
    aCopy cloneFrom:self performing:#simpleDeepCopy.
    ^ aCopy

    "a bad example (but ST/X should survive ...)"
    "
     |a|
     a := Array new:3.
     a at:3 put:a.
     a simpleDeepCopy
    "
!

skipInstvarIndexInDeepCopy:index
    "a helper for deepCopy; only indices for which this method returns
     false are copied in a deep copy.
     The default is false here - which means that everything is copied.
     Can be redefined in subclasses for partial copies"

    ^ false
!

slowShallowCopy
    "return a copy of the object with shared subobjects (a shallow copy)
     i.e. the copy shares referenced instvars with its original.
     This method is only invoked as a fallback from #shallowCopy."

    |myClass aCopy|

    (myClass := self class) isVariable ifTrue:[
        aCopy := myClass basicNew:(self basicSize).
    ] ifFalse:[
        aCopy := myClass basicNew
    ].

    "copy the instance variables"
    aCopy cloneFrom:self performing:#yourself.
    ^ aCopy
! !

!Object methodsFor:'debugging'!

assert:aBooleanOrBlock
    "fail and report an error, if the argument does not evaluate to true"

    "{ Pragma: +optSpace }"

    <resource: #skipInDebuggersWalkBack>

    aBooleanOrBlock == true ifTrue:[^ self].
    (Smalltalk ignoreAssertions) ifTrue:[^ self].

    "/ could still be a block or false.
    (aBooleanOrBlock value) ifFalse:[
        AssertionFailedError
            raiseRequestWith:self
            errorString:('Assertion failed in ',
                         thisContext methodHome sender printString,
                         '[', thisContext  methodHome sender lineNumber printString,']')
    ].

    "
     self assert:false
    "

    "Modified: / 20-08-2010 / 17:13:06 / cg"
!

assert:aBooleanOrBlock description:messageIfFailing
    "fail, if the argument does not evaluate to true and report an error"

    "{ Pragma: +optSpace }"

    <resource: #skipInDebuggersWalkBack>

    aBooleanOrBlock == true ifTrue:[^ self].
    (Smalltalk ignoreAssertions) ifTrue:[^ self].

    "/ could still be a block or false.
    (aBooleanOrBlock value) ifFalse:[
        AssertionFailedError
            raiseRequestWith:self
            errorString:(messageIfFailing, ' {',thisContext methodHome sender "methodHome" printString,' }')
    ].

    "
     self assert:false description:'xxx'
    "

    "Modified (comment): / 06-03-2012 / 11:26:48 / cg"
!

assert:aBooleanOrBlock message:messageIfFailing
    "fail, if the argument does not evaluate to true and report an error"

    "{ Pragma: +optSpace }"

    <resource: #skipInDebuggersWalkBack>

    ^ self assert: aBooleanOrBlock description: messageIfFailing

    "
     self assert:false message:'xxx'
    "

    "Modified (comment): / 06-03-2012 / 11:26:48 / cg"
!

basicInspect
    "{ Pragma: +optSpace }"

    "launch an inspector on the receiver.
     this method should NOT be redefined in subclasses."

    Inspector isNil ifTrue:[
        "
         for systems without GUI
        "
        self warn:'No Inspector defined (Inspector is nil).'
    ] ifFalse:[
        Inspector openOn:self
    ]

    "Modified: 18.5.1996 / 15:43:25 / cg"
!

breakPoint:someKey
    "{ Pragma: +optSpace }"

    "Like halt, but disabled by default.
     Can be easily enabled.
     Can be filtered on the arguments value (typically: a symbol).
     Code with breakpoints may be even checked into the source repository"

    "Example:   nil breakPoint:#stefan"

    <resource: #skipInDebuggersWalkBack>

    "/ don't send #breakPoint:info: here - ask cg why.
    (self isBreakPointEnabled:someKey) ifTrue:[
        ^ HaltSignal
            raiseRequestWith:someKey
            errorString:('Breakpoint encountered: %1' bindWith:someKey)
    ].

    "
     nil breakPoint:#stefan
     nil breakPoint:#stefan info:'Hello'
     Smalltalk enableBreakPoint:#stefan.
     Smalltalk disableBreakPoint:#stefan.

     EncounteredBreakPoints.
     Smalltalk enableBreakPoint:#cg.
     Smalltalk disableBreakPoint:#cg.
    "
!

breakPoint:someKey info:infoString
    "{ Pragma: +optSpace }"

    "Like halt, but disabled by default.
     Can be easily enabled.
     Can be filtered on the arguments value (typically: a symbol).
     Code with breakpoints may be even checked into the source repository"

    "Example:   nil breakPoint:#stefan"

    <resource: #skipInDebuggersWalkBack>

    (self isBreakPointEnabled:someKey) ifTrue:[
        ^ HaltSignal
            raiseRequestWith:someKey
            errorString:(infoString bindWith:someKey)
    ].
!

debuggingCodeFor:someKey is:aBlock
    "{ Pragma: +optSpace }"

    "aBlock is evaluated if breakPoints for somekey are enabled.
     Allows for debugging code to be enabled/disabled via the breakpoint browser.
     Can be easily enabled.
     Can be filtered on the arguments value (typically: a symbol).
     Code with breakpoints may be even checked into the source repository"

    "Example:   nil debuggingCodeFor:#cg is:[ self halt ]"

    <resource: #skipInDebuggersWalkBack>

    (self isBreakPointEnabled:someKey) ifTrue:[
        aBlock value
    ].

    "
     Smalltalk disableBreakPoint:#cg.
     nil debuggingCodeFor:#cg is:[ Transcript showCR:'here is some debug message for cg' ].
     nil debuggingCodeFor:#stefan is:[ Transcript showCR:'here is some debug message for sv' ].
     Smalltalk enableBreakPoint:#cg.
     nil debuggingCodeFor:#cg is:[ Transcript showCR:'here is some debug message for cg' ].
     nil debuggingCodeFor:#stefan is:[ Transcript showCR:'here is some debug message for sv' ].
     Smalltalk disableBreakPoint:#cg.

    "
!

disableAllBreakPoints
    "disable all parametrized breakPoints (with any key as parameter)"

    EnabledBreakPoints := nil

    "
     nil enableBreakPoint:#cg.
     nil breakPoint:#cg.
     nil disableAllBreakPoints.
     nil breakPoint:#cg.
    "

    "Created: / 06-03-2012 / 15:32:28 / cg"
!

disableBreakPoint:someKey
    "disable parametrized breakPoints with someKey as parameter"

    "{ Pragma: +optSpace }"

    EnabledBreakPoints notNil ifTrue:[
        EnabledBreakPoints remove:someKey ifAbsent:[].
        EnabledBreakPoints := EnabledBreakPoints asNilIfEmpty.
    ].

    "
     nil enableBreakPoint:#cg.
     nil breakPoint:#cg.
     nil disableBreakPoint:#cg
     nil breakPoint:#cg.
    "

    "Modified (comment): / 06-03-2012 / 15:31:51 / cg"
!

enableBreakPoint:someKey
    "enable parametrized breakPoints with someKey as parameter"

    "{ Pragma: +optSpace }"

    EnabledBreakPoints isNil ifTrue:[
        EnabledBreakPoints := Set new.
    ].
    EnabledBreakPoints add:someKey.

    "
     nil enableBreakPoint:#cg.
     nil breakPoint:#cg.
     nil disableBreakPoint:#cg
     nil breakPoint:#cg.
    "

    "Modified (comment): / 06-03-2012 / 15:31:47 / cg"
!

halt
    "{ Pragma: +optSpace }"

    "enter debugger with halt-message.
     The error is reported by raising the HaltSignal exception."

    <resource: #skipInDebuggersWalkBack>

    Smalltalk ignoreHalt ifTrue:[^ self].
    "/ don't send #halt: here - ask cg why.
    HaltInterrupt raiseRequestWith:#halt.
    ^ self

    "
        (3 halt * 5)
    "

    "Modified: / 02-08-1999 / 17:00:29 / stefan"
    "Modified: / 18-11-2010 / 11:21:51 / cg"
!

halt:aString
    "{ Pragma: +optSpace }"

    "enter debugger with halt-message.
     The error is reported by raising the HaltSignal exception."

    <resource: #skipInDebuggersWalkBack>

    Smalltalk ignoreHalt ifTrue:[^ self].
    HaltInterrupt raiseRequestWith:#halt: errorString:aString.
    ^ self

    "Modified: / 18-11-2010 / 11:22:16 / cg"
!

isBreakPointEnabled:someKey
    "{ Pragma: +optSpace }"

    "controls which breakpoints to be enabled."

"/    something = OperatingSystem getLoginName ifTrue:[^ true].
"/    something = 'testThis' ifTrue:[^ true].
    EncounteredBreakPoints notNil ifTrue:[
        EncounteredBreakPoints add:someKey
    ].

    ^ (EnabledBreakPoints notNil and:[ EnabledBreakPoints includes:someKey ])

    "
     nil enableBreakPoint:#cg.
     nil breakPoint:#cg.
     nil disableBreakPoint:#cg
     nil breakPoint:#cg.

     EncounteredBreakPoints := Set new.
    "
!

mustBeBoolean
    "this message is sent by the VM, if a non-Boolean receiver is encountered
     in an if* or while* message.
     Caveat: for now, this is only sent by the interpreter;
     both the JIT and the stc compiler treat it as undefined."

    <resource: #skipInDebuggersWalkBack>

    self error:'Non boolean receiver - proceed for truth' mayProceed:true.
    ^ true
!

mustBeKindOf:aClass
    "for compatibility & debugging support:
     check if the receiver isKindOf:aClass and raise an error if not.
     Notice:
        it is VERY questionable, if it makes sense to add manual
        type checks to a dynamically typed language like smalltalk.
        It will, at least, slow down performance,
        make your code less reusable and clutter your code with stupid sends
        of this selector. Also, read the comment in isKindOf:, regarding the
        use of isXXX check methods.
     You see: The author does not like this at all ..."

    <resource: #skipInDebuggersWalkBack>

    (self isKindOf:aClass) ifFalse:[
        self error:'argument is not of expected type'
    ]
!

obsoleteFeatureWarning
    "{ Pragma: +optSpace }"

    "in methods which are going to be changed, a send to
     this method is used to tell programmers that some feature/semantics is
     used which is going to be changed in later ST/X versions.
     Hopefully, this warning message is annoying enough for you to change the code... ;-)."

    self obsoleteFeatureWarning:nil from:thisContext sender
!

obsoleteFeatureWarning:message
    "{ Pragma: +optSpace }"

    "in methods which are going to be changed, a send to
     this method is used to tell programmers that some feature/semantics is
     used which is going to be changed in later ST/X versions.
     Hopefully, this warning message is annoying enough for you to change the code... ;-).
     This message is intended for application developers, so its printed as info message."

    self obsoleteFeatureWarning:message from:thisContext sender
!

obsoleteFeatureWarning:message from:aContext
    "{ Pragma: +optSpace }"

    "in methods which are going to be changed, a send to
     this method is used to tell programmers that some feature/semantics is
     used which is going to be changed in later ST/X versions.
     Hopefully, this warning message is annoying enough for you to change the code... ;-).
     This message is intended for application developers, so its printed as info message."

    |spec sender|

    spec := aContext methodPrintString.
    sender := aContext sender.

    ('WARNING: the ''' , spec , ''' semantics will be changed.') infoPrintCR.
    ('         Its behavior may be different in future ST/X versions.') infoPrintCR.
    ('         called from ' , sender printString) infoPrintCR.
    ((sender selector ? '') startsWith:'perform:') ifTrue:[
    ('         called from ' , sender sender printString) infoPrintCR.
    ].
    message notNil ifTrue:[
        '------>  ' infoPrint. message infoPrintCR
    ]

    "
     Object obsoleteFeatureWarning:'foo' from:thisContext sender sender
    "
!

obsoleteMethodWarning
    "{ Pragma: +optSpace }"

    "in methods which are going to be obsoleted, a self send to
     this method is used to tell programmers that a method is
     used which is going to be removed in later ST/X versions.
     Find all methods which will be obsolete soon by looking at senders of this message.
     Hopefully, this warning message is annoying enough for you to change the code... ;-)"

    self obsoleteMethodWarning:nil from:thisContext sender
!

obsoleteMethodWarning:message
    "{ Pragma: +optSpace }"

    "in methods which are going to be obsoleted, a self send to
     this method is used to tell programmers that a method is
     used which is going to be removed in later ST/X versions.
     Find all methods which will be obsolete soon by looking at senders of this message.
     Hopefully, this warning message is annoying enough for you to change the code... ;-)"

    self obsoleteMethodWarning:message from:thisContext sender
!

obsoleteMethodWarning:messageOrNil from:aContext
    "{ Pragma: +optSpace }"

    "in methods which are going to be obsoleted, a self-send to
     this method is used to tell programmers that a method is
     used which is going to be removed in later ST/X versions.
     Find all methods which will be obsolete soon by looking at senders of this message.
     Hopefully, this warning message is annoying enough for you to change the code... ;-).
     This message is intended for application developers, so its printed as info message."

    |spec sender message|

    Smalltalk isSmalltalkDevelopmentSystem ifFalse:[
        "ignore in production systems"
        ^ self.
    ].

    message := messageOrNil ? 'Obsolete method called'.

    spec := aContext methodPrintString.
    sender := aContext sender.
    ('WARNING: the ''' , spec , ''' method is obsolete.') infoPrintCR.
    ('         And may not be present in future ST/X versions.') infoPrintCR.
    ('         called from ' , sender printString) infoPrintCR.
    (sender selector startsWith:'perform:') ifTrue:[
        sender := sender sender.
        (sender selector startsWith:'perform:') ifTrue:[
            sender := sender sender.
        ].
        ('         called from ' , sender printString) infoPrintCR.
    ].
    message notNil ifTrue:[
        '------>  ' infoPrint. message infoPrintCR
    ].

    "CG: care for standalone non-GUI progs, which have no userPreferences class"
    (Smalltalk isInitialized
    and:[ UserPreferences notNil
    and:[ UserPreferences current haltInObsoleteMethod]]) ifTrue:[
        "/ cg: nice try, stefan, but I don't want halts in system processes (fly by help and others)
        Processor activeProcess isSystemProcess ifTrue:[
            (message , ' - please fix this now (no halt in system process)') infoPrintCR
        ] ifFalse:[
            "/ please check for the sender of the obsoleteMethodWarning,
            "/ and fix the code there.
            ObsoleteMethodCallWarning raiseRequestErrorString:(message , ' - please fix this now!!')
        ].
    ].

    "
     Object obsoleteMethodWarning:'foo' from:thisContext sender sender
    "

    "Modified: / 10-08-2006 / 13:13:11 / cg"
!

todo
    "used to mark code pieces that have to be implemented.
     Halts when reached in development mode; 
     ignored in deployed production code."

    <resource: #skipInDebuggersWalkBack>

    self halt:'more work needed here'.

    "
     example:

        ...
        self todo.
        ...
    "
!

todo:aBlock
    "used to mark code pieces that have to be implemented.
     The coe in aBlock is ignored."

    <resource: #skipInDebuggersWalkBack>

"/    self halt.
"/    aBlock value.

    "
     example:

        ...
        self todo:[
            code which needs more work ...
        ].
        ...
    "

    "Created: / 25-05-2007 / 21:34:39 / cg"
    "Modified: / 29-05-2007 / 12:11:33 / cg"
!

tracePoint:someKey
    "{ Pragma: +optSpace }"

    "Like transcript show, but disabled by default.
     Can be easily enabled.
     Can be filtered on the arguments value (typically: a symbol).
     Code with tracepoints may be even checked into the source repository"

    "Example:   nil tracePoint:#stefan"

    (self isBreakPointEnabled:someKey) ifTrue:[
        ^ Transcript showCR:('Tracepoint (at %1 for %3 from %2)'
                                bindWith:(Timestamp now printString)
                                with:(thisContext sender printString)
                                with:someKey)
    ].

    "
     nil tracePoint:#stefan
     nil tracePoint:#stefan message:'Hello'
     Smalltalk enableBreakPoint:#stefan.
     Smalltalk disableBreakPoint:#stefan.
    "

    "Modified: / 28-08-2013 / 21:41:54 / cg"
!

tracePoint:someKey message:messageBlockOrString
    "{ Pragma: +optSpace }"

    "Like transcript show, but disabled by default.
     Can be easily enabled.
     Can be filtered on the arguments value (typically: a symbol).
     Code with tracepoints may be even checked into the source repository"

    "Example:   nil tracePoint:#stefan"

    (self isBreakPointEnabled:someKey) ifTrue:[
        Transcript showCR:('Tracepoint: %4 (at %1 for %3 from %2)'
                                bindWith:(Timestamp now printString)
                                with:(thisContext sender printString)
                                with:someKey
                                with:messageBlockOrString value)
    ].

    "
     Smalltalk enableBreakPoint:#stefan.
     nil tracePoint:#stefan.
     nil tracePoint:#stefan message:'Hello'.
     nil tracePoint:#stefan message:['Hello from block'].
     Smalltalk disableBreakPoint:#stefan.
    "

    "Modified: / 28-08-2013 / 21:41:47 / cg"
! !

!Object methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver"

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps dep|

        deps := self dependents.

        "/ to save a fair amount of memory in case of
        "/ many dependencies, we store a single dependent in
        "/ a WeakArray, and switch to a WeakSet if more dependents are
        "/ added.

        (deps isNil or:[deps size == 0]) ifTrue:[
            self dependents:(WeakArray with:anObject)
        ] ifFalse:[
            deps class == WeakArray ifTrue:[
                dep := deps at:1.
                dep ~~ anObject ifTrue:[
                    (dep isNil or:[dep class == SmallInteger]) ifTrue:[
                        deps at:1 put:anObject
                    ] ifFalse:[
                        self dependents:(WeakIdentitySet with:dep with:anObject)
                    ]
                ]
            ] ifFalse:[
                deps add:anObject
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Modified: / 27.10.1997 / 19:35:52 / cg"
!

breakDependents
    "remove all dependencies from the receiver"

    self dependents:nil.
    self nonWeakDependents:nil

    "Modified: / 19.4.1996 / 10:55:36 / cg"
    "Created: / 27.2.1998 / 11:26:11 / stefan"
!

breakDependentsRecursively
    "remove all dependencies from the receiver and
     recursively from all objects referred to by the receiver."

    self breakDependents.
    1 to:self class instSize do:[:idx |
        (self instVarAt:idx) breakDependentsRecursively.
    ].
    1 to:self basicSize do:[:idx |
        (self basicAt:idx) breakDependentsRecursively.
    ]
!

dependents
    "return a Collection of dependents.
     The default implementation here uses a global WeakDictionary to store
     dependents
     This may be too slow for high frequency change&update,
     therefore, some classes (Model) redefine this for better performance.
     Notice the mentioning of a WeakDictionary - read the classes documentation."

    |deps|

    (deps := Dependencies at:self ifAbsent:nil) isNil ifTrue:[
        ^ #().
    ].
    ^ deps

    "Modified: / 26.1.1998 / 11:18:15 / cg"
!

dependents:aCollection
    "set the collection of dependents.
     The default implementation here uses a global Dictionary to store
     dependents which may be too slow for high frequency change&update.
     Therefore, some classes (Model) redefine this for better performance."

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution (and to avoid creation of garbage blocks).

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ the common case - already blocked

        (aCollection isNil or:[aCollection isEmpty]) ifTrue:[
            Dependencies removeKey:self ifAbsent:nil
        ] ifFalse:[
            Dependencies at:self put:aCollection
        ].
        ^ self
    ].

    [
        (aCollection isNil or:[aCollection isEmpty]) ifTrue:[
            Dependencies removeKey:self ifAbsent:nil
        ] ifFalse:[
            Dependencies at:self put:aCollection
        ].
    ] ensure:[
        OperatingSystem unblockInterrupts
    ]

    "Modified: 30.1.1997 / 21:22:10 / cg"
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents"

    |deps nwDeps|

    deps := self dependents.
    deps size ~~ 0 ifTrue:[
        deps do:[:d |
                    (d notNil and:[d class ~~ SmallInteger]) ifTrue:[
                        aBlock value:d
                    ]
                ]
    ].
    nwDeps := self nonWeakDependents.
    (nwDeps ~~ deps and:[nwDeps size ~~ 0]) ifTrue:[
        nwDeps do:aBlock
    ].

    "Modified: / 30.1.1998 / 14:03:40 / cg"
!

myDependents
    "same as dependents - ST-80 compatibility"

    ^ self dependents
!

release
    "remove all references to objects that may refer to self.
     Subclasses may redefine this method but should do a 'super release'."

    self breakDependents

    "Modified: / 27.2.1998 / 11:29:35 / stefan"
!

removeDependent:anObject
    "make the argument, anObject be independent of the receiver"

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps n dep|

        deps := self dependents.
        deps size ~~ 0 ifTrue:[
            "/ to save a fair amount of memory in case of
            "/ many dependencies, we store a single dependent in
            "/ a WeakArray, and switch to a WeakSet if more dependents are
            "/ added. Here we have to do the inverse ...

            ((deps class == WeakArray) or:[deps class == Array]) ifTrue:[
                ((dep := deps at:1) == anObject
                 or:[dep isNil
                 or:[dep class == SmallInteger]]) ifTrue:[
                    self dependents:nil
                ]
            ] ifFalse:[
                dep := deps remove:anObject ifAbsent:[].
                "if dep is nil, nothing has changed"
                dep notNil ifTrue:[
                    (n := deps size) == 0 ifTrue:[
                        self dependents:nil
                    ] ifFalse:[
                        n == 1 ifTrue:[
                            dep := deps firstIfEmpty:nil.
                            dep notNil ifTrue:[
                                deps := (deps isWeakCollection ifTrue:[WeakArray] ifFalse:[Array]) with:dep
                            ] ifFalse:[
                                deps := nil
                            ].
                            self dependents:deps.
                        ]
                    ].
                ].
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Modified: / 05-07-2011 / 22:49:31 / cg"
! !

!Object methodsFor:'dependents access (non weak)'!

addNonWeakDependent:anObject
    "make the argument, anObject be a nonWeak dependent of the receiver.
     Be careful: this nonWeakDependency will prevent the dependent from being
     garbage collected unless the dependency is removed.
     This is a private mechanism, for directed dependencies."

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps dep|

        deps := self nonWeakDependents.

        "/ to save a fair amount of memory in case of
        "/ many dependencies, we store a single dependent in
        "/ an Array, and switch to a Set if more dependents are
        "/ added.

        deps size == 0 ifTrue:[
            anObject notNil ifTrue:[
                self nonWeakDependents:(Array with:anObject).
            ] ifFalse:[
                "adding nil causes problems when adding the next one
                 (see below: trying to add nil to IdentitySet)"
"/                self halt:'try to add nil to list of dependents'.
            ].
        ] ifFalse:[
            deps class == Array ifTrue:[
                dep := deps at:1.
                dep ~~ anObject ifTrue:[
                    self nonWeakDependents:(IdentitySet with:dep with:anObject)
                ]
            ] ifFalse:[
                deps add:anObject
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Created: / 19.4.1996 / 10:54:08 / cg"
    "Modified: / 30.1.1998 / 14:03:08 / cg"
!

nonWeakDependents
    "return a Collection of nonWeakDependents - empty if there is none.
     This is a private mechanism for directed dependencies."

    NonWeakDependencies isNil ifTrue:[^ #()].
    ^ NonWeakDependencies at:self ifAbsent:#()

    "Created: / 19.4.1996 / 10:55:06 / cg"
    "Modified: / 30.1.1998 / 14:06:47 / cg"
!

nonWeakDependents:aCollection
    "set the collection of nonWeak dependents.
     This is a private helper for directed dependencies."

    [
        (aCollection isNil or:[aCollection isEmpty]) ifTrue:[
            NonWeakDependencies removeKey:self ifAbsent:nil
        ] ifFalse:[
            NonWeakDependencies at:self put:aCollection
        ]
    ] valueUninterruptably

    "Created: 19.4.1996 / 11:07:47 / cg"
!

removeNonWeakDependent:anObject
    "remove a nonWeak dependency from the receiver to the argument, anObject.
     (i.e. make it independent of the receiver)"

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps n|

        deps := self nonWeakDependents.
        deps size ~~ 0 ifTrue:[
            deps class == Array ifTrue:[
                (deps at:1) == anObject ifTrue:[
                    self nonWeakDependents:nil
                ]
            ] ifFalse:[
                deps remove:anObject ifAbsent:[].
                (n := deps size) == 0 ifTrue:[
                    self nonWeakDependents:nil
                ] ifFalse:[
                    n == 1 ifTrue:[
                        self nonWeakDependents:(Array with:(deps first))
                    ]
                ]
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Created: / 19.4.1996 / 11:44:44 / cg"
    "Modified: / 30.1.1998 / 14:04:01 / cg"
! !



!Object methodsFor:'displaying'!

ascentOn:aGC
    "when displayed via displayOn:, some objects assume that the given y coordinate
     is the baseline (strings, text etc. do), while others assume that the topY
     coordinate is given by y.
     In other words: some draw above the given y coordinate.
     This method returns the number of pixels by which the receiver will draw above
     the given y coordinate."

    ^ aGC fontAscent
!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifTrue:[
        self printOn:aGCOrStream.
        ^ self
    ].
    ^ self displayOn:aGCOrStream x:0 y:0.

    "Created: 29.5.1996 / 16:28:58 / cg"
!

displayOn:aGC at:aPoint
    "ST-80 Compatibility
     display the receiver in a graphicsContext - this method allows
     for any object to be displayed in a ListView - for example."

    ^ self displayOn:aGC x:(aPoint x) y:(aPoint y).
!

displayOn:aGC x:x y:y
    "display the receiver in a graphicsContext - this method allows
     for any object to be displayed in a ListView - for example."

    self displayOn:aGC x:x y:y opaque:false

    "Modified: 29.5.1996 / 16:29:38 / cg"
!

displayOn:aGc x:x y:y opaque:opaque
    "display the receiver in a graphicsContext - this method allows
     for any object to be displayed in a ListView - for example.
     The fallBack here shows the receiver's displayString.
     Notice, that the string is displayed on the baseLine;
     ask using #ascentOn: if required"

    |s yBaseline|

    s := self isString ifTrue:[self] ifFalse:[self displayString].
    yBaseline := y "+ aGc font ascent".
    opaque ifTrue:[
        aGc displayOpaqueString:s x:x y:yBaseline.
    ] ifFalse:[
        aGc displayString:s x:x y:yBaseline.
    ].

    "Modified: 29.5.1996 / 16:29:38 / cg"
!

displayOpaqueOn:aGC x:x y:y
    "display the receiver in a graphicsContext - this method allows
     for any object to be displayed in a ListView - for example."

    self displayOn:aGC x:x y:y opaque:true

    "Modified: / 29.5.1996 / 16:29:38 / cg"
    "Created: / 26.10.1997 / 15:01:36 / cg"
!

displayString
    "return a string used when displaying the receiver in a view;
     for example an Inspector. This is usually the same as printString,
     but sometimes redefined for a better look.

     Note: the base method (used by the inspector) is #displayOn:.
           So you should implement #displayOn: instead of #displayString in subclasses."

    |s|

    "/ attention: TextStream is not present in ultra-mini standalone apps
    s := TextStream isNil
            ifTrue:['' writeStream]
            ifFalse:[TextStream on:(String new:32)].
    self displayOn:s.
    ^ s contents

    "
     #(1 2 3) printString
     #(1 2 3) displayString
     #(1 2 3) storeString
    "
!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    ^ aGC deviceFont heightOf:(self displayString)
!

printStringForPrintIt
    "for compatibility (used to be displayString), now the printIt menu function now sends this message"

    ^ self displayString

    "
     #(1 2 3) printString
     #(1 2 3) printStringForPrintIt
     #(1 2 3) storeString
    "
!

widthFrom:startIndex to:endIndex on:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    ^ aGC deviceFont widthOf:(self displayString) from:startIndex to:endIndex
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    ^ aGC deviceFont widthOf:(self displayString)
! !

!Object methodsFor:'double dispatching'!

equalFromComplex:aComplex
    "adding this method here allows for any non-number to be compared to a complex
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromFixedPoint:aFixedPoint
    "adding this method here allows for any non-number to be compared to a fixedPoint
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromFloat:aFloat
    "adding this method here allows for any non-number to be compared to a float
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromFraction:aFraction
    "adding this method here allows for any non-number to be compared to a fraction
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromInteger:anInteger
    "adding this method here allows for any non-number to be compared to an integer
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromLargeFloat:aLargeFloat
    "adding this method here allows for any non-number to be compared to a largeFloat
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromLongFloat:aLongFloat
    "adding this method here allows for any non-number to be compared to a longFloat
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
!

equalFromShortFloat:aShortFloat
    "adding this method here allows for any non-number to be compared to a shortFloat
     and return false from this comparison.
     Reason: we want to be able to put both numbers and non-numbers into a collection
     which uses #= (i.e. a Set or Dictionary)."

    ^ false
! !

!Object methodsFor:'encoding & decoding'!

decodeAsLiteralArray
    "given a literalEncoding in the receiver,
     create & return the corresponding object.
     The inverse operation to #literalArrayEncoding."

    ^ self
!

encodeOn:anEncoder with:aParameter
    "not used any longer. Kept for backward comaptibility"

    <resource: #obsolete>

    self acceptVisitor:anEncoder with:aParameter
!

encodingVectorForInstanceVariables
    "OBSOLETE, use elementDescriptorForInstanceVariables"

    <resource: #obsolete>

    ^ self elementDescriptorForInstanceVariablesMatching:[:val | true].

    "
      #(1 2 3 nil true symbol) encodingVectorForInstanceVariables
      Dictionary new encodingVectorForInstanceVariables
      (5 @ nil) encodingVectorForInstanceVariables
    "
!

encodingVectorForNonNilInstanceVariables
    "OBSOLETE, use elementDescriptorForNonNilInstanceVariables"

    <resource: #obsolete>

    ^ self elementDescriptorForInstanceVariablesMatching:[:varVal | varVal notNil].

    "
      #(1 2 3 nil true symbol) encodingVectorForNonNilInstanceVariables
      (5 @ nil) encodingVectorForNonNilInstanceVariables
    "
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray.
     Recursively decodes arguments."

    |sel litVal val msg ex
     stop   "{ Class:SmallInteger }" |

    stop := aSpecArray size.

    2 to:stop by:2 do:[:i|
        sel := aSpecArray at:i.
        litVal := aSpecArray at:i + 1.

        (self respondsTo:sel) ifTrue:[
            val := litVal decodeAsLiteralArray.
            self perform:sel with:val
        ] ifFalse:[
            "/ that's a debug halt,
            "/ it should probably be removed (to simply ignore unhandled attributes)...
            "/ for now, it is left in, in order to easily find incompatibilities between
            "/ VW and ST/X.
            self breakPoint:#cg.

            msg := '%1: unhandled literalArrayEncoding attribute:'
                        bindWith:self class name
                        with:sel.
            UnhandledAttributeInLiteralArrayErrorSignal isHandled ifTrue:[
                ex := UnhandledAttributeInLiteralArrayErrorSignal new.
                ex badLiteralArray:self.
                ex parameter:sel.
                ex notify:msg.
            ] ifFalse:[
                msg infoPrintCR.
            ].
        ]
    ]
!

literalArrayEncoding
    "generate a literalArrayEncoding array for myself.
     This uses #literalArrayEncodingSlotOrder which defines the slots and
     order and #skippedInLiteralEncoding which defines slots to skip.
     For most subclasses, there is no need to redefine those."

    |names encoding cls skipped slots|

    self isLiteral ifTrue:[
        ^ self
    ].

    slots    := self literalArrayEncodingSlotOrder.
    skipped  := self skippedInLiteralEncoding.
    cls      := self class.
    names    := cls allInstVarNames.
    encoding := OrderedCollection new:(1 + (2 * (slots size - skipped size))).
    encoding add:cls name.

    slots do:[:instSlot |
        |value nm|

        nm := names at:instSlot.
        (skipped includes:nm) ifFalse:[
            (value := self instVarAt:instSlot) notNil ifTrue:[
                encoding add:(nm asMutator).
                encoding add:value literalArrayEncoding
            ]
        ]
    ].
    ^ encoding asArray

    "
        (1 -> 2) literalArrayEncoding
        DebugView menuSpec decodeAsLiteralArray literalArrayEncoding  =
           DebugView menuSpec
    "
!

literalArrayEncodingSlotOrder
    "define the order in which inst-slots are saved when generating
     a literalArrayEncoding"

    ^ 1 to:self class instSize
!

postDecodeFrom:aDecoder aspect:aspectSymbol
    "invoked by xmlDecoder (and others in the future), after an
     object has been decoded (i.e. its instance variables have been restored)"

    ^ self
!

skippedInLiteralEncoding
    "return a Collection with it's elements are slots for skipping"

    ^ #()
! !

!Object methodsFor:'error handling'!

abortOperation
    "{ Pragma: +optSpace }"

    "raise the AbortOperationRequest signal.
     This will unwind and bring the current thread back to the event-handling loop,
     effectively aborting any current menu, user, doIt, printIt or other operation."

    <resource: #skipInDebuggersWalkBack>

    ^ AbortOperationRequest raise
!

ambiguousMessage:aMessage
    "this message is sent by the system in case that it
     is not clear which method to execute in response to
     aMessage.
     Such situation may occur when a current selector namespace
     imports two namespaces and both define a method with the
     requested selector."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ AmbiguousMessage raiseRequestWith:aMessage

    "Created: / 21-07-2010 / 15:44:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-11-2012 / 10:14:42 / cg"
!

cannotSendMessage:aMessage to:someReceiver
    "this message is sent by the runtime system (VM),
     when a message is sent to some object, whose class is not
     a valid behavior (see documentation in Behavior)."

    <resource: #skipInDebuggersWalkBack>

    ^ VMInternalError
          raiseWith:someReceiver
          errorString:('bad class in send of #' , aMessage selector)

    "Modified: 23.1.1997 / 00:05:39 / cg"
!

conversionErrorSignal
    "return the signal used for conversion error handling"

    ^ self class conversionErrorSignal
!

doesNotUnderstand:aMessage
    "this message is sent by the runtime system (VM) when
     a message is not understood by some object (i.e. there
     is no method for that selector). The original message has
     been packed into aMessage (i.e. the receiver, selector and
     any arguments) and the original receiver is then sent the
     #doesNotUnderstand: message.
     Here, we raise another signal which usually enters the debugger.
     You can of course redefine #doesNotUnderstand: in your classes
     to implement message delegation,
     or handle the MessageNotUnderstood exception gracefully."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ MessageNotUnderstood raiseRequestWith:aMessage
!

elementBoundsError
    "{ Pragma: +optSpace }"

    "report an error that badElement is out of bounds
     (i.e. cannot be put into that collection).
     The error is reported by raising the ElementBoundsError exception."

    <resource: #skipInDebuggersWalkBack>

    ^ ElementBoundsError raise

    "Modified: 8.5.1996 / 09:12:45 / cg"
!

elementBoundsError:aValue
    "{ Pragma: +optSpace }"

    "report an error that aValue is not valid as element
     (i.e. cannot be put into that collection).
     The error is reported by raising the ElementBoundsError exception."

    <resource: #skipInDebuggersWalkBack>

    ^ ElementBoundsError raiseWith:aValue

    "Modified: 8.5.1996 / 09:12:45 / cg"
!

elementNotCharacter
    "{ Pragma: +optSpace }"

    "report an error that object to be stored is no Character.
     (usually when storing into Strings).
     The error is reported by raising the ElementBoundsError exception."

    <resource: #skipInDebuggersWalkBack>

    ^ ElementBoundsError raise

    "Modified: 8.5.1996 / 09:12:49 / cg"
!

elementNotInteger
    "{ Pragma: +optSpace }"

    "report an error that object to be stored is not Integer.
     (in collections that store integers only).
     The error is reported by raising the ElementOutOfBoundsSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ ElementBoundsError raise

    "Modified: 8.5.1996 / 09:12:51 / cg"
!

error
    "{ Pragma: +optSpace }"

    "report error that an error occurred.
     The error is reported by raising the Error exception,
     which is non-proceedable.
     If no handler has been setup, a debugger is entered."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    Error raiseWith:#error:

    "
     nil error
    "

    "Modified: / 8.5.1996 / 09:13:01 / cg"
    "Modified: / 2.8.1999 / 17:00:19 / stefan"
!

error:aString
    "{ Pragma: +optSpace }"

    "Raise an error with error message aString.
     The error is reported by raising the Error exception,
     which is non-proceedable.
     If no handler has been setup, a debugger is entered."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    Error raiseWith:#error: errorString:aString

    "
      nil error:' bad bad bad'
    "

    "Modified: 8.5.1996 / 09:13:04 / cg"
!

error:aString mayProceed:mayProceed
    "{ Pragma: +optSpace }"

    "enter debugger with error-message aString.
     The error is reported by raising either the
     non-proceedable Error exception,
     or the ProceedableError exception."

    <resource: #skipInDebuggersWalkBack>

    mayProceed ifTrue:[
        ^ ProceedableError raiseRequestWith:#error: errorString:aString
    ].

    Error raiseWith:#error: errorString:aString

    "Modified: 8.5.1996 / 09:13:04 / cg"
!

errorInvalidFormat
    "{ Pragma: +optSpace }"

    "report an error that some conversion to/from string representation failed
     typically when converting numbers, date, time etc."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ ConversionError raiseErrorString:'invalid format'
!

errorKeyNotFound:aKey
    "{ Pragma: +optSpace }"

    "report an error that a key was not found in a collection.
     The error is reported by raising the KeyNotFoundError exception."

    <resource: #skipInDebuggersWalkBack>

    ^ KeyNotFoundError raiseRequestWith:aKey errorString:(' ', aKey printString)

    "
     Dictionary new at:#nonExistentElement
    "
!

errorNotFound
    "{ Pragma: +optSpace }"

    "report an error that no element was found in a collection.
     The error is reported by raising the NotFoundSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ NotFoundError raiseRequestWith:nil

    "Modified: / 8.5.1996 / 09:13:11 / cg"
    "Modified: / 26.7.1999 / 10:51:50 / stefan"
!

errorNotFound:errorString
    "{ Pragma: +optSpace }"

    "report an error that no element was found in a collection.
     The error is reported by raising the NotFoundSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ NotFoundError raiseRequestErrorString:errorString
!

errorSignal
    "return the signal used for error/error: handling"

    ^ self class errorSignal

    "Created: / 19.6.1998 / 02:32:32 / cg"
!

handlerForSignal:exceptionHandler context:theContext originator:originator
    " should never be invoked for non-blocks/non-exceptions/non-signals"

    thisContext isRecursive ifTrue:[^ nil].

    'Warning: handlerForSignal invoked for: ' print. self printCR.
    '         context: ' print. theContext printCR.
    '         originator: ' print. originator printCR.
    '         sender: ' print. thisContext sender printCR.

    "/ MiniDebugger enter:thisContext withMessage:'oops' mayProceed:true.
    self error:'this method should only be invoked for blocks, exceptions and signals'.
!

implementedBySubclass
    "{ Pragma: +optSpace }"

    "this is sent by ST/V code - its the same as #subclassResponsibility"

    <resource: #skipInDebuggersWalkBack>

    ^ SubclassResponsibilityError raiseRequestErrorString:'method must be reimplemented in ST/V subclass'
!

indexNotInteger
    "{ Pragma: +optSpace }"

    "report an error that index is not an Integer.
     (when accessing collections indexed by an integer key).
     The error is reported by raising the NonIntegerIndexSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ NonIntegerIndexError raiseRequestWith:nil

    "Modified: / 8.5.1996 / 09:13:37 / cg"
    "Modified: / 26.7.1999 / 10:57:43 / stefan"
!

indexNotInteger:anIndex
    "{ Pragma: +optSpace }"

    "report an error that index is not an Integer.
     (when accessing collections indexed by an integer key).
     The error is reported by raising the NonIntegerIndexSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ NonIntegerIndexError raiseRequestWith:anIndex

    "Created: / 16.5.1998 / 19:39:41 / cg"
!

indexNotIntegerOrOutOfBounds:index
    "{ Pragma: +optSpace }"

    "report an error that index is either non-integral or out of bounds"

    <resource: #skipInDebuggersWalkBack>

    index isInteger ifFalse:[
        ^ self indexNotInteger:index
    ].
    ^ self subscriptBoundsError:index
!

integerCheckError
    "{ Pragma: +optSpace }"

    "generated when a variable declared with an integer type gets a bad value assigned"

    <resource: #skipInDebuggersWalkBack>

"/    ^ self error:'bad assign of ' , self printString ,
"/                  ' (' , self class name , ') to integer-typed variable'
    ^ InvalidTypeError
        raiseRequestErrorString:(
            'bad assign of ' , self printString ,
                  ' (' , self class name , ') to integer-typed variable')

    "Modified: / 02-11-2012 / 10:25:36 / cg"
!

invalidCodeObject
    "{ Pragma: +optSpace }"

    "this is sent by VM if it encounters some non-method for execution"

    <resource: #skipInDebuggersWalkBack>

    "/ self error:'not an executable code object'
    ^ ExecutionError
        raiseRequestErrorString:'not an executable code object'

    "Created: / 01-08-1997 / 00:16:44 / cg"
!

invalidMessage
    "{ Pragma: +optSpace }"

    "this is sent by ST/V code - it is the same as #shouldNotImplement"

    <resource: #skipInDebuggersWalkBack>

    ^ self shouldNotImplement

    "Modified (comment): / 02-11-2012 / 10:11:18 / cg"
!

mustBeRectangle
    "{ Pragma: +optSpace }"

    "report an argument-not-rectangle-error"

    <resource: #skipInDebuggersWalkBack>

    "/ ^ self error:'argument must be a Rectangle'
    ^ InvalidTypeError
        raiseRequestErrorString:'argument must be a Rectangle'

    "Modified: / 02-11-2012 / 10:24:53 / cg"
!

mustBeString
    "{ Pragma: +optSpace }"

    "report an argument-not-string-error"

    <resource: #skipInDebuggersWalkBack>

    "/ ^ self error:'argument must be a String'
    ^ InvalidTypeError
        raiseRequestErrorString:'argument must be a String'

    "Modified: / 02-11-2012 / 10:24:35 / cg"
!

notIndexed
    "{ Pragma: +optSpace }"

    "report an error that receiver has no indexed instance variables.
     The error is reported by raising the SubscriptOutOfBoundsSignal exception."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ SubscriptOutOfBoundsError
        raiseRequestErrorString:'receiver has no indexed variables'

    "
     1234 at:4
    "

    "Modified: 26.7.1996 / 16:43:13 / cg"
!

notYetImplemented
    "{ Pragma: +optSpace }"

    "report an error that some functionality is not yet implemented.
     This is here only for compatibility - it has the same meaning as shouldImplement."

    <resource: #skipInDebuggersWalkBack>

    |sender|

    sender := thisContext sender.

    ^ UnimplementedFunctionalityError
        raiseRequestWith:(Message selector:sender selector arguments:sender args)

    "Modified: / 02-11-2012 / 10:24:12 / cg"
!

primitiveFailed
    "{ Pragma: +optSpace }"

    "report an error that some primitive code failed.
     The error is reported by raising the PrimitiveFailure exception.
     Sorry for the code duplication: it avoids the extra frame in the debugger."

    <resource: #skipInDebuggersWalkBack>

    |sender selector|

    "do loop to take care of super sends"
    sender := thisContext sender.
    [
        selector := sender selector.
        selector == #primitiveFailed: or:[selector == #primitiveFailed]
    ] whileTrue:[sender := sender sender].

    ^ PrimitiveFailure raiseRequestWith:(Message selector:selector arguments:sender args)
                       in:sender.

    "
     1234 primitiveFailed

     [
        ExternalBytes new   basicAt:40
     ] on:PrimitiveFailure do:[:ex|
        ex inspect
     ]
    "
!

primitiveFailed:messageString
    "{ Pragma: +optSpace }"

    "report an error that some primitive code failed.
     The error is reported by raising the PrimitiveFailureSignal exception."

    <resource: #skipInDebuggersWalkBack>

    |sender selector|

    "do loop to take care of super sends"
    sender := thisContext sender.
    [
        selector := sender selector.
        selector == #primitiveFailed: or:[selector == #primitiveFailed]
    ] whileTrue:[sender := sender sender].

    ^ PrimitiveFailure raiseRequestWith:(Message selector:selector arguments:sender args)
                       errorString:messageString
                       in:sender.

    "
     1234 primitiveFailed:'this is a test'
    "
!

shouldImplement
    "{ Pragma: +optSpace }"

    "report an error that this message/functionality should be implemented.
     This is send by automatically generated method bodies or inside as-yet-uncoded
     branches of existing methods."

    <resource: #skipInDebuggersWalkBack>

    |sender|

    sender := thisContext sender.

    ^ UnimplementedFunctionalityError
        raiseRequestWith:(Message selector:sender selector arguments:sender args)

     "
      self shouldImplement
     "
!

shouldImplement:what
    "{ Pragma: +optSpace }"

    "report an error that this message/functionality should be implemented.
     This is send by automatically generated method bodies or inside as-yet-uncoded
     branches of existing methods."

    <resource: #skipInDebuggersWalkBack>

    |sender|

    sender := thisContext sender.

    ^ UnimplementedFunctionalityError
        raiseRequestWith:(Message selector:sender selector arguments:sender args)
        errorString:what

     "
      self shouldImplement:'foobar'
     "
!

shouldNeverBeReached
    "report an error that this point may never be reached."

    <resource: #skipInDebuggersWalkBack>

    ^ ExecutionError
        raiseRequestErrorString:'Oops, this may never reached. Something somewhere was terribly wrong.'.

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

shouldNeverBeSent
    "report an error that this message may never be sent to the receiver"

    <resource: #skipInDebuggersWalkBack>

    ^ MethodNotAppropriateError
        raiseRequestErrorString:'This message never may be sent to me'.

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Modified: / 02-11-2012 / 10:10:42 / cg"
!

shouldNotImplement
    "{ Pragma: +optSpace }"

    "report an error that this message should not be implemented -
     i.e. that a method is invoked which is not appropriate for the receiver."

    <resource: #skipInDebuggersWalkBack>

    ^ MethodNotAppropriateError
        raiseRequestErrorString:'method/functionality is not appropriate for class'.

    "Modified: / 02-11-2012 / 10:02:25 / cg"
!

subclassResponsibility
    "{ Pragma: +optSpace }"

    "report an error that this message should have been reimplemented in a subclass"

    <resource: #skipInDebuggersWalkBack>

    ^ SubclassResponsibilityError raiseRequestWith:thisContext sender selector
!

subclassResponsibility:msg
    "{ Pragma: +optSpace }"

    "report an error that this message should have been reimplemented in a subclass"

    <resource: #skipInDebuggersWalkBack>

    ^ SubclassResponsibilityError raiseRequestErrorString:msg
!

subscriptBoundsError
    "{ Pragma: +optSpace }"

    "report an error that some index is out of bounds.
     (when accessing indexable collections).
     The error is reported by raising the SubscriptOutOfBoundsSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ SubscriptOutOfBoundsSignal raiseRequestWith:nil

    "Modified: / 26.7.1996 / 16:45:42 / cg"
    "Modified: / 26.7.1999 / 10:58:27 / stefan"
!

subscriptBoundsError:anIndex
    "{ Pragma: +optSpace }"

    "report an error that anIndex is out of bounds.
     (when accessing indexable collections).
     The error is reported by raising the SubscriptOutOfBoundsSignal exception."

    <resource: #skipInDebuggersWalkBack>

    ^ SubscriptOutOfBoundsError
        raiseRequestWith:anIndex
        errorString:('subscript (' , anIndex printString , ') out of bounds')

    "Modified: / 17.11.2001 / 22:49:56 / cg"
!

typeCheckError
    "{ Pragma: +optSpace }"

    "generated when a variable declared with a type hint gets a bad
     value assigned"

    <resource: #skipInDebuggersWalkBack>

"/    ^ self error:'bad assign of ' , self printString ,
"/                  ' (' , self class name , ') to typed variable'

    ^ InvalidTypeError
        raiseRequestErrorString:
            ('bad assign of ' , self printString ,
                  ' (' , self class name , ') to typed variable')

    "Modified: / 02-11-2012 / 10:19:15 / cg"
! !

!Object methodsFor:'error handling - debugger'!

addDebuggerHook:aBlock
    "add a debugger hook. Any registered hook is evaluated with the exception as
     argument before a real debugger is entered.
     Hooks can be used for two purposes:
        - record exception information in a log file
        - filter exceptions and either decide to ignore them or to open an alternative
          debugger (depending on the exception type, maybe)"

    DebuggerHooks isNil ifTrue:[
        DebuggerHooks := OrderedCollection new.
    ].
    DebuggerHooks add:aBlock

    "
     Object addDebuggerHook:[:ex | AbortSignal raise].
     (1 / (1-1)).
     Object removeDebuggerHook:(DebuggerHooks first).
    "
    "
     Object addDebuggerHook:[:ex | Transcript showCR:ex ].
     (1 / (1-1)).
     Object removeDebuggerHook:(DebuggerHooks first).
    "
    "
     Object addDebuggerHook:[:ex | ex suspendedContext fullPrintAllOn:Transcript ].
     (1 / (1-1)).
     Object removeDebuggerHook:(DebuggerHooks first).
    "
    "
     Object addDebuggerHook:[:ex | '/tmp/stx.log' asFilename
                                   appendingFileDo:[:s |
                                        s nextPutLine:'----------------------'.
                                        (Timestamp now printOn:s). s cr.
                                        ex suspendedContext fullPrintAllOn:s
                                   ]].
     (1 / (1-1)).
     Object removeDebuggerHook:(DebuggerHooks first).
    "
!

appropriateDebugger:aSelector
    "{ Pragma: +optSpace }"

    "return an appropriate debugger to use.
     If there is already a debugger active on the stack, and it is
     the DebugView, return MiniDebugger (as a last chance) otherwise abort."

    |context|

    "DebugView cannot run without system processes"

    (Processor isNil
    or:[Processor activeProcessIsSystemProcess
    or:[Smalltalk isInitialized not]]) ifTrue:[
        ^ MiniDebugger
    ].
    (Screen isNil or:[Screen default isNil or:[Screen default isOpen not]]) ifTrue:[
        Debugger isNil ifTrue:[^ nil].
        ^ MiniDebugger
    ].

    context := thisContext.
    context := context findNextContextWithSelector:aSelector or:nil or:nil.
    [context notNil] whileTrue:[
        ((context receiver class == Debugger)
         and:[context selector == aSelector]) ifTrue:[
            "we are already in some Debugger"
            (Debugger == MiniDebugger) ifTrue:[
                "we are already in the MiniDebugger"
                ErrorRecursion ifFalse:[
                    Smalltalk fatalAbort:'recursive error ...'
                ]
            ].
            MiniDebugger isNil ifTrue:[
                Smalltalk fatalAbort:'no debugger'
            ].

            "ok, an error occurred while in the graphical debugger;
             lets try MiniDebugger"
            ^ MiniDebugger
        ].
        context := context findNextContextWithSelector:aSelector or:nil or:nil.
    ].
    "not within Debugger - no problem"
    ^ Debugger

    "Modified: / 23.9.1996 / 12:14:52 / stefan"
    "Modified: / 19.5.1999 / 18:05:00 / cg"
!

openDebuggerOnException:ex
    "{ Pragma: +optSpace }"

    "enter the debugger on some unhandled exception"

    |msgString debugger|

    msgString := ex descriptionForDebugger.

    "
     if there is no debugger, ask for ignore or exit.
     Exit will terminate the application.
     ignore will raise an AbortOperationRequest.
    "
    Debugger isNil ifTrue:[
        msgString := 'Error: ' , msgString.

        thisContext isRecursive ifTrue:[
            msgString errorPrintCR.
            Smalltalk fatalAbort:'recursive unhandled exception'
        ].

        Smalltalk isStandAloneApp ifTrue:[
            (ex creator == NoHandlerError) ifTrue:[
                (HaltInterrupt handles:ex exception) ifTrue:[
                    "/ 'Halt ignored' infoPrintCR.
                    ^ nil
                ].
                "don't output the message, if the exception is a UserInterrupt (CTRL-C)"
                (ex exception creator == UserInterrupt) ifTrue:[
                    ex description errorPrintCR.
                    OperatingSystem exit:130.
                ].
            ].
        ].

        (Dialog notNil and:[Screen default notNil]) ifTrue:[
            self
                errorNotify:msgString
                from:ex suspendedContext
                allowDebug:false
                mayProceed:ex willProceed.

            "/ arrive here if proceeded...
            ^ nil
        ].

        "don't output the message, if the exception is a UserInterrupt (CTRL-C)"
        (ex creator == NoHandlerError
         and:[ex exception creator == UserInterrupt]) ifTrue:[
            OperatingSystem exit:130.
        ].
        msgString _errorPrintCR.
        'Backtrace:' _errorPrintCR.
        '' _errorPrintCR.
        thisContext fullPrintAll.
        OperatingSystem exit:1
    ].

    "
     find an appropriate debugger to use
    "
    debugger := self appropriateDebugger:(thisContext selector).
    debugger isNil ifTrue:[
        ^ AbortOperationRequest raiseRequest
    ].

    "/ call any registered debug hooks.
    "/ These may record or further filter the exception. Each hook gets the exception object and may send any
    "/ ex-message (ex proceed, ex return etc.) or raise an Abort signal.
    "/ However, the real intent for hooks is to allow saving exceptions in a log file...
    DebuggerHooks notNil ifTrue:[
        DebuggerHooks do:[:eachHook |
            eachHook value:ex.
        ].
    ].
    ^ debugger enterException:ex.

    "Modified: / 05-12-2011 / 11:53:10 / cg"
!

removeDebuggerHook:aBlock
    "remove a debugger hook."

    DebuggerHooks notNil ifTrue:[
        DebuggerHooks removeIdentical:aBlock.
        DebuggerHooks isNil ifTrue:[ DebuggerHooks := nil ].
    ].
! !

!Object methodsFor:'evaluation'!

_evaluate_
    "return the receiver itself.
     - compatibility with LazyValue"

    ^ self
!

argumentCount
    "compatibility with Blocks and Messages.
     Answer 0, since we only understand #value.

     By implementing this, you can pass any object as an exception handler."

    ^ 0

    "
        [1 // 0] on:ArithmeticError do:9999
    "
!

value
    "return the receiver itself.
     This allows every object to be used where blocks or valueHolders
     are typically used, and allows for valueHolders and blocks to be
     used interchangably in some situations.

     Time will show, if this is a good idea or leads to sloppy programming
     style ... (the idea was borrowed from the Self language).

     WARNING: don't 'optimize' away ifXXX: blocks
              (i.e. do NOT replace
                        foo ifTrue:[var1] ifFalse:[var2]
               by:
                        foo ifTrue:var1 ifFalse:var2
              )
              - the compilers will only generate inline code for the if,
                iff the argument(s) are blocks - otherwise, a true send is
                generated.
              This 'optimization' will work semantically correct,
              but execute SLOWER instead.

              Using constants (foo ifTrue:1 ifFalse:2) does not introduce a performance penalty."

    ^ self

    "
     #(1 2 3 4) indexOf:5 ifAbsent:0
     #(1 2 3 4) indexOf:5 ifAbsent:[0]
     1 > 2 ifTrue:['yes'] ifFalse:['no']
     1 > 2 ifTrue:'yes' ifFalse:'no'
    "

    "DO NOT DO THIS (its slower)
     (1 > 4) ifTrue:a ifFalse:b

     USE (the compiler optimizes blocks in if/while):
     (1 > 4) ifTrue:[a] ifFalse:[b]
    "

    "Modified: 3.5.1996 / 11:57:08 / cg"
!

valueWithPossibleArguments:argArray
    "see comment in #value.
     The argArray is ignored here
     (equivalent to sending this message to a 0-arg Block)"

     ^ self

    "
        [ 'abc' ] valueWithPossibleArguments:#(1 2 3)
        'abc' valueWithPossibleArguments:#(1 2 3)
    "
! !

!Object methodsFor:'finalization'!

disposed
    "OBSOLETE INTERFACE: use #finalize
     this is invoked for objects which have been registered
     in a Registry, when the original object dies.
     Subclasses may redefine this method"

    <resource: #obsolete>

    ^ self
!

executor
    "Return the object which does the finalization for me.
     This interface is also VW & Sqeak compatible,"

    "for now, send #shallowCopyForFinalization, to be compatible with
     classes designed for old ST/X versions"

    ^ self shallowCopyForFinalization
!

finalizationLobby
    "answer a Registry used for finalization.
     Use a generic Registry for any object.
     Subclasses using their own Registry should redefine this"

    ^ FinalizationLobby
!

finalize
    "this is invoked for executor objects which have been registered
     in a Registry, when the original object dies.
     Subclasses may redefine this method
     This interface is also VW-compatible"

    "send #disposed for compatibility with existing classes that still
     implement the obsolete #disposed message"

    ^ self disposed
!

reRegisterForFinalization
    "re-register mySelf for later finalization.
     This will create a new executor, which will receive a #finalize message when
     the receiver is garbage collected."

    self finalizationLobby registerChange:self
!

registerForFinalization
    "register mySelf for later finalization.
     Once registered, the executor of the receiver will receive a #finalize message when
     the receiver is garbage collected."

    self finalizationLobby register:self
!

shallowCopyForFinalization
    "OBSOLETE INTERFACE: use #executor.
     This is used to acquire a copy to be used for finalization -
     (the copy will be sent a #finalize message; see the documentation in the Registry class)
     This method can be redefined for more efficient copying - especially for large objects."

    <resource: #obsolete>

    ^ self shallowCopy
!

unregisterForFinalization
    "unregister mySelf from later finalization"

    self finalizationLobby unregister:self
! !

!Object methodsFor:'initialization'!

initialize
    "just to ignore initialize to objects which do not need it"

    ^ self
! !

!Object methodsFor:'inspecting'!

inspectorExtraMenuOperations
    "extra operation-menu entries to be shown in an inspector.
     Answers a collection of pairs contining aString and action aBlock.
     aString is the label of the menu item.
     aBlock is evaluated when the menu item is selected.
     To be redefined in objects which think that it makes sense to offer
     often used operations in an inspector.
     See SerialPort as an example."

    ^ OrderedCollection new.
! !

!Object methodsFor:'interrupt handling'!

childSignalInterrupt
    "death of a child process (unix process) - do nothing"

    ^ self
!

customInterrupt
    "{ Pragma: +optSpace }"

    "a custom interrupt - but no handler has defined"

    self error:'custom interrupt' mayProceed:true
!

errorInterrupt:errorID with:aParameter
    "subsystem error. The arguments errorID and aParameter are the values passed
     to the 'errorInterruptWithIDAndParameter(id, param)' function,
     which can be called from C subsystems to raise an (asynchronous)
     error exception.

     Currently, this is used to map XErrors to smalltalk errors, but can be
     used from other C subsystems too, to upcast errors.
     Especially, for subsystems which call errorHandler functions asynchronously.
     IDs (currently) used:
        #DisplayError ..... x-error interrupt
        #XtError      ..... xt-error interrupt (Xt interface is not yet published)
    "

    |handlers handler|

    handlers := ObjectMemory registeredErrorInterruptHandlers.
    handlers notNil ifTrue:[
        handler := handlers at:errorID ifAbsent:nil.
        handler notNil ifTrue:[
            "/
            "/ handler found; let it do whatever it wants ...
            "/
            handler errorInterrupt:errorID with:aParameter.
            ^ self
        ].
    ].

    "/
    "/ no handler - raise errorSignal passing the errorId as parameter
    "/
    ^ Error
        raiseRequestWith:errorID
        errorString:('Subsystem error. ErrorID = ' , errorID printString)
!

exceptionInterrupt
    "{ Pragma: +optSpace }"

    "exception interrupt - enter debugger"

    self error:'exception Interrupt' mayProceed:true
!

fpExceptionInterrupt
    "{ Pragma: +optSpace }"

    "a floating point exception occurred - this one
     has to be handled differently since it comes asynchronous
     on some machines (for example, on machines with a separate FPU
     or superscalar architectures. Also, errors from within primitive code
     (or library functions such as GL) are sent via the Unix-signal
     mechanism this way."

    |where rec|

    where := thisContext sender.
    rec := where receiver.
    rec isNumber ifTrue:[
        ^ rec class
            raise:#domainErrorSignal
            receiver:rec
            selector:where selector
            arguments:(where args asArray)
            errorString:'floating point exception'
    ].

    "/ could be in some C-library ...
    ^ DomainError raise
!

internalError:msg
    "{ Pragma: +optSpace }"

    "this is triggered, when VM hits some bad error,
     such as corrupted class, corrupted method/selector array
     etc. The argument string gives some more information on what happened.
     (for example, if you set an objects class to a non-behavior, nil etc.).
     Its not guaranteed, that the system is in a working condition once
     this error occurred ...."

    VMInternalError raiseWith:self errorString:msg
!

ioInterrupt
    "{ Pragma: +optSpace }"

    "I/O (SIGIO/SIGPOLL) interrupt (supposed to be sent to Processor).
     If we arrive here, there is either no handler (ObjMem>>ioInterruptHandler)
     or it does not understand the ioInterrupt message.
     In any case, this is a sign of some big trouble. Enter debugger."

    self error:'I/O Interrupt - but no handler' mayProceed:true
!

memoryInterrupt
    "{ Pragma: +optSpace }"

    "out-of-memory interrupt and no handler - enter debugger"

    self error:'almost out of memory' mayProceed:true
!

recursionInterrupt
    "{ Pragma: +optSpace }"

    "recursion limit (actually: stack overflow) interrupt.
     This interrupt is triggered, when a process stack grows above
     its stackLimit - usually, this leads into the debugger, but
     could be caught.
     Under Unix, the stackLimit may be increased in the handler,
     and the exception can be resumed.
     Sorry, but under win32, the stack cannot grow, and the exception
     is not proceedable.
     At the time we arrive here, the system has still some stack
     as a reserve so we can continue to do some useful work, or cleanup,
     or debug for a while.
     If the signal is ignored, and the stack continues to grow, there
     will be a few more chances (and more interrupts) before the VM
     terminates the process."

    |con remaining sender nSkipped caller level n|

    (con := thisContext) isRecursive ifFalse:[
"/        Processor activeProcess usedStackSize < Processor activeProcess maximumStackSize ifTrue:[
"/            "/ mhmh - it hit me, but I am not responsible ...
"/            'Stray recursionInterrupt ...' infoPrintCR.
"/            ^ self
"/        ].
        ObjectMemory infoPrinting ifTrue:[
            level := 0.
            caller := thisContext sender.
            [caller notNil] whileTrue:[
                level := level + 1.
                caller := caller sender.
            ].

            'Object [info]: recursionInterrupt from:' errorPrintCR.
            con := con sender.
            remaining := 500.
            n := 0.
            [con notNil and:[remaining > 0]] whileTrue:[
                sender := con sender.
                RecursionInterruptSignal handle:[:ex |
                ] do:[
                    '| ' _errorPrint. con fullPrint.
                ].
                nSkipped := 0.
                [sender notNil and:[sender sender notNil
                and:[sender selector == con selector
                and:[sender sender selector == con selector
                and:[sender method == con method]]]]] whileTrue:[
                    nSkipped := nSkipped + 1.
                    con := sender.
                    sender := con sender.
                ].
                nSkipped > 0 ifTrue:[
                    '| ... ***** ' _errorPrint. nSkipped _errorPrint. ' recursive contexts skipped *****' _errorPrintCR.
                ].
                con := sender.
                remaining := remaining - 1
            ].
        ].
        ^ RecursionInterruptSignal raiseSignal
    ]

    "Modified: / 10.11.2001 / 15:15:56 / cg"
!

schedulerInterrupt
    "{ Pragma: +optSpace }"

    "scheduler interrupt (supposed to be sent to Processor).
     If we arrive here, either the Processor does not understand it,
     or it has been set to nil. In any case, this is a sign of some
     big trouble. Enter debugger."

    self error:'schedulerInterrupt - but no Processor' mayProceed:true
!

signalInterrupt:signalNumber
    "{ Pragma: +optSpace }"

    "unix signal occurred - some signals are handled as Smalltalk Exceptions
     (SIGPIPE), others (SIGBUS) are rather fatal...
     In any case, IF a smalltalk-signal has been connected to the OS signal, that one is raised.
     Otherwise, a dialog is shown, asking the user on how to handle the signal.
     TODO: add another argument, giving more detailed signal info (PC, VADDR,
     exact cause etc.). This helps if segvs occur in primitive code.
     Currently (temporary kludge), these are passed as global variables."

    |name here sig fatal titles actions badContext msg pc addr
     action title screen|

    thisContext isRecursive ifTrue:[
        'Severe error: signalInterrupt while processing a signalInterrupt.' _errorPrintCR.
        'Terminating process ' _errorPrint. Processor activeProcess _errorPrintCR.
"/        GenericException handle:[:ex |
"/            "/ ignore any error during termination
"/        ] do:[
"/           Processor activeProcess terminate.
"/        ].
        MiniDebugger enter.
        Processor activeProcess terminateNoSignal.
    ].

    "if there has been an ST-signal installed, use it ..."
    sig := OperatingSystem operatingSystemSignal:signalNumber.
    sig notNil ifTrue:[
        sig raiseSignalWith:signalNumber.
        ^ self.
    ].

    "/ if handled, raise OSSignalInterruptSignal
    OSSignalInterrupt isHandled ifTrue:[
        OSSignalInterrupt raiseRequestWith:signalNumber.
        ^ self.
    ].

    "
     special cases
        - SIGPWR: power failure - write a crash image and continue
        - SIGHUP: hang up - write a crash image and exit
    "
    (signalNumber == OperatingSystem sigPWR) ifTrue:[
        SnapshotError ignoreIn:[ObjectMemory writeCrashImage].
        ^ self.
    ].
    (signalNumber == OperatingSystem sigHUP) ifTrue:[
        SnapshotError ignoreIn:[ObjectMemory writeCrashImage].
        'Object [info]: exit due to hangup signal.' errorPrintCR.
        Smalltalk exit:1.
    ].

    name := OperatingSystem nameForSignal:signalNumber.

    "if there is no screen at all, bring up a mini debugger"
    (Screen isNil
     or:[(screen := Screen current) isNil
     or:[(screen := Screen default) isNil
     or:[screen isOpen not]]]) ifTrue:[
        ^ self startMiniDebuggerOrExit:'OS-Signal (' , name, ')'.
    ].

    "ungrab - in case it happened in a box/popupview
     otherwise display stays locked"
    screen ungrabPointer; ungrabKeyboard.

    here := thisContext.
    badContext := here sender.          "the context, in which the signal occurred"

    "there is a screen. use it to bring up a box asking for what to do ..."
    Screen currentScreenQuerySignal answer:screen do:[
        "
         SIGBUS, SIGSEGV and SIGILL do not make sense to ignore (i.e. continue)
         since the system will retry the faulty instruction, which leads to
         another signal - to avoid frustration, better not offer this option.
        "
        fatal := OperatingSystem isFatalSignal:signalNumber.
        fatal ifTrue:[
            (Debugger isNil or:[here isRecursive]) ifTrue:[
                'Object [hard error]: signal ' errorPrint. signalNumber errorPrintCR.
                ^ self startMiniDebuggerOrExit:'OS-Signal (' , name, ')'.
            ].
            "
             a hard signal - go into debugger immediately
            "
            msg := 'OS-signal: ', name.

            "/ the IRQ-PC is passed as low-hi, to avoid the need
            "/ to allocate a LargeInteger in the VM during signal
            "/ time. I know, this is ugly.

            InterruptPcLow notNil ifTrue:[
                pc := InterruptPcLow + (InterruptPcHi bitShift:((SmallInteger maxBits + 1) // 2)).
                pc ~~ 0 ifTrue:[
                    msg := msg , ' PC=' , (pc printStringRadix:16)
                ].
            ].
            InterruptAddrLow notNil ifTrue:[
                addr := InterruptAddrLow + (InterruptAddrHi bitShift:((SmallInteger maxBits + 1) // 2)).
                addr ~~ 0 ifTrue:[
                    msg := msg , ' ADDR=' , (addr printStringRadix:16)
                ].
            ].
            Debugger enter:here withMessage:msg mayProceed:false.
            "unreachable"
            ^ nil.
        ].

        "if possible, open an option box asking the user what do.
         Otherwise, start a debugger"
        Dialog notNil ifTrue:[
            OperatingSystem isOSXlike ifTrue:[
                titles := #('Save crash image' 'Dump core' 'GDB' 'Exit ST/X' 'Debug').
                actions := #(save core gdb exit debug).
            ] ifFalse:[
                titles := #('Save crash image' 'Dump core' 'Exit ST/X' 'Debug').
                actions := #(save core exit debug).
            ].
            action := nil.
            title := 'OS Signal caught (' , name, ')'.
            title := (title , '\[in ST-process: ' , Processor activeProcess nameOrId ,']') withCRs.

            "/ if caught while in the scheduler or event dispatcher,
            "/ a modal dialog is not possible ...
            "/ (therefore, abort & return does not makes sense)

            Processor activeProcess isSystemProcess ifFalse:[
                titles := #('Abort') , titles.
                actions := #(abort), actions.

                badContext canReturn ifTrue:[
                    titles := #('Return') , titles.
                    actions :=  #(return), actions.
                ].
            ].

            fatal ifFalse:[
                titles := titles, #('Ignore').
                actions := actions , #(ignore).
            ].
            action := Dialog choose:title
                             labels:titles
                             values:actions
                             default:(fatal ifTrue:[nil] ifFalse:[#ignore]).

            "Dialog may fail (if system process), default action is debug"
            action isEmptyOrNil ifTrue:[action := #debug].
        ] ifFalse:[
            action := #debug.
        ].

        action == #save ifTrue:[
            ObjectMemory writeCrashImage
        ].
        action == #gdb ifTrue:[
            OperatingSystem openTerminalWithCommand:('gdb -p %1' bindWith:OperatingSystem getProcessId) inBackground:true.
            MiniDebugger enter. "/ to stop, so gdb can show where we are
            AbortOperationRequest raise.
        ].
        action == #core ifTrue:[
            Smalltalk fatalAbort
        ].
        action == #exit ifTrue:[
            Smalltalk exit:10.
        ].
        action == #return ifTrue:[
            badContext return
        ].
        action == #abort ifTrue:[
            AbortOperationRequest raise.
        ].

        action == #debug ifTrue:[
            Debugger isNil ifTrue:[
                ^ self startMiniDebuggerOrExit:'OS-Signal (' , name, ')'.
            ].
            Debugger enter:here withMessage:('OS-Signal ', name) mayProceed:true.
        ].
        "action == #ignore"
    ].

    "Modified: / 15-09-2011 / 16:38:14 / cg"
!

spyInterrupt
    "{ Pragma: +optSpace }"

    "spy interrupt and no handler - enter debugger"

    self error:'spy Interrupt - but no handler' mayProceed:true
!

startMiniDebuggerOrExit:text
    "some critical condition happened.
     Start a mini debugger or exit if none is present"

    MiniDebugger isNil ifTrue:[
        "a system without debugging facilities (i.e. a standalone system)
         output a message and exit."
        ('Object [error]: exit due to ', text, ' - and no debugger.') errorPrintCR.
        OperatingSystem exit:99.
    ].
    MiniDebugger enterWithMessage:text mayProceed:true.
!

timerInterrupt
    "{ Pragma: +optSpace }"

    "timer interrupt and no handler - enter debugger"

    self error:'timer Interrupt - but no handler' mayProceed:true
!

userInterrupt
    "{ Pragma: +optSpace }"

    "user (^c) interrupt.
     This is typically sent by the VM, when a ctrl-C is typed at the
     controlling tty (i.e. in the xterm)."

    UserInterrupt raiseRequest
!

userInterruptIn:aContext from:originator
    "{ Pragma: +optSpace }"

    "user (^c) interrupt - enter debugger, but show aContext
     as top-context.
     This is used to hide any intermediate scheduler contexts,
     in case of an interrupted process. Typically, this is sent by
     the WindowGroup, when a keyboardEvent for the ctrl-C key is
     processed.
     Set the originator to distinguish UserInterrupts from controlling tty vs.
     UserInterrupt from a view."

    <context: #return>

    UserInterrupt raiseRequestWith:originator errorString:nil in:aContext

    "Created: / 18.10.1996 / 20:46:04 / cg"
    "Modified: / 20.10.1996 / 13:06:38 / cg"
    "Modified: / 26.7.1999 / 10:58:49 / stefan"
! !

!Object methodsFor:'message sending'!

perform:aSelector
    "send the message aSelector to the receiver"

    <resource: #skipInDebuggersWalkBack>

%{
#ifdef __SCHTEAM__
    return context.PERFORM(self, aSelector);
#else
    REGISTER OBJ sel = aSelector;
    int hash0;

    if (InterruptPending == nil) {
        struct inlineCache *pIlc;

# define nways 2
# define nilcs 131

# define SEL_AND_ILC_INIT_1(l)   { { nil, nil } , { __ILCPERF0(l) , __ILCPERF0(l) } , 0 }
# define SEL_AND_ILC_INIT_2(l)   SEL_AND_ILC_INIT_1(l)   , SEL_AND_ILC_INIT_1(l)
# define SEL_AND_ILC_INIT_4(l)   SEL_AND_ILC_INIT_2(l)   , SEL_AND_ILC_INIT_2(l)
# define SEL_AND_ILC_INIT_8(l)   SEL_AND_ILC_INIT_4(l)   , SEL_AND_ILC_INIT_4(l)
# define SEL_AND_ILC_INIT_16(l)  SEL_AND_ILC_INIT_8(l)   , SEL_AND_ILC_INIT_8(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_64(l)  SEL_AND_ILC_INIT_32(l)  , SEL_AND_ILC_INIT_32(l)
# define SEL_AND_ILC_INIT_128(l) SEL_AND_ILC_INIT_64(l)  , SEL_AND_ILC_INIT_64(l)
# define SEL_AND_ILC_INIT_256(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_128(l)

# define SEL_AND_ILC_INIT_131(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_2(l) , SEL_AND_ILC_INIT_1(l)

        static struct { OBJ sel[nways]; struct inlineCache ilc[nways]; int flip; } sel_and_ilc[nilcs] = { SEL_AND_ILC_INIT_131(@line) };

# undef SEL_AND_ILC_INIT_1
# undef SEL_AND_ILC_INIT_2
# undef SEL_AND_ILC_INIT_4
# undef SEL_AND_ILC_INIT_8
# undef SEL_AND_ILC_INIT_16
# undef SEL_AND_ILC_INIT_32
# undef SEL_AND_ILC_INIT_64
# undef SEL_AND_ILC_INIT_128
# undef SEL_AND_ILC_INIT_256

# undef SEL_AND_ILC_INIT_131
# undef SEL_AND_ILC_INIT_257

# define TRY(n)                                  \
        if (sel == sel_and_ilc[hash0].sel[n]) { \
            pIlc = &sel_and_ilc[hash0].ilc[n];  \
            goto perform0_send_and_return;      \
        }

        if (__isNonNilObject(sel)) {
            hash0 = __MAKE_HASH__(__GET_HASH(sel)) % nilcs;
        } else {
            /* sel is either nil or smallint, use its value as hash */
            hash0 = (INT)sel % nilcs;
        }

        TRY(0);
        TRY(1);

# undef TRY
        /*printf("Object >> #perform: #%s --> no PIC found\n", __symbolVal(aSelector));*/

        pIlc = &sel_and_ilc[hash0].ilc[sel_and_ilc[hash0].flip];
        sel_and_ilc[hash0].sel[sel_and_ilc[hash0].flip] = sel;
        sel_and_ilc[hash0].flip = (sel_and_ilc[hash0].flip + 1) % nways;
        pIlc->ilc_func = __SEND0ADDR__;
        if (pIlc->ilc_poly) {
            __flushPolyCache(pIlc->ilc_poly);
            pIlc->ilc_poly = 0;
        }
perform0_send_and_return:
        RETURN ( (*(pIlc->ilc_func))(self, sel, nil, pIlc) );
    } else {
        static struct inlineCache ilc0 = __DUMMYILCSELF0(@line+1);
        RETURN (_SEND0(self, aSelector, nil, &ilc0));
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ self perform:aSelector withArguments:#()
!

perform:aSelector inClass:aClass withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver as a super-send message.
     This is actually more flexible than the normal super-send, since it allows
     to execute a method in ANY superclass of the receiver (not just the
     immediate superclass).
     Thus, it is (theoretically) possible to do
         '5 perform:#< inClass:Magnitude withArguments:#(6)'
     and evaluate Magnitudes compare method even if there was one in Number.
     This method is used by the interpreter to evaluate super sends
     and could be used for very special behavior (language extension ?).

     WARNING: this is an ST/X feature - probably not found in other smalltalks."

    |numberOfArgs a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 myClass|

    "
     check, if aClass is really a superclass of the receiver
    "
    myClass := self class.
    (myClass == aClass or:[myClass isSubclassOf:aClass]) ifFalse:[
        self error:'lookup-class argument is not a superclass of the receiver'.
        ^ nil
    ].
%{
#ifdef __SCHTEAM__
#else
    REGISTER OBJ *argP;
    int nargs, i;

    if (__isArrayLike(argArray)) {
        nargs = __arraySize(argArray);
        argP = __arrayVal(argArray);
    } else {
        if (__isNonNilObject(argArray)) {
            static struct inlineCache ilcSize = __ILC0(@line+1);
            numberOfArgs = (*ilcSize.ilc_func)(argArray, @symbol(size), nil, &ilcSize);
            if (!__isSmallInteger(numberOfArgs))
                goto bad;
            nargs = __intVal(numberOfArgs);
            argP = (OBJ *)(&a1);
            for (i=1; i <= nargs; i++) {
                *argP++ = __AT_(argArray, __mkSmallInteger(i));
            }
            argP = (OBJ *)(&a1);
        } else {
            nargs = 0;
        }
    }
    switch (nargs) {
        case 0:
            {
                static struct inlineCache ilc0 = __DUMMYILCSELF0(@line+1);
                RETURN ( _SEND0(self, aSelector, aClass, &ilc0));
            }

        case 1:
            {
                static struct inlineCache ilc1 = __DUMMYILCSELF1(@line+1);
                RETURN ( _SEND1(self, aSelector, aClass, &ilc1, argP[0]));
            }

        case 2:
            {
                static struct inlineCache ilc2 = __DUMMYILCSELF2(@line+1);
                RETURN ( _SEND2(self, aSelector, aClass, &ilc2, argP[0], argP[1]));
            }

        case 3:
            {
                static struct inlineCache ilc3 = __DUMMYILCSELF3(@line+1);
                RETURN ( _SEND3(self, aSelector, aClass, &ilc3,
                                argP[0], argP[1], argP[2]));
            }

        case 4:
            {
                static struct inlineCache ilc4 = __DUMMYILCSELF4(@line+1);
                RETURN ( _SEND4(self, aSelector, aClass, &ilc4,
                                argP[0], argP[1], argP[2], argP[3]));
            }

        case 5:
            {
                static struct inlineCache ilc5 = __DUMMYILCSELF5(@line+1);
                RETURN ( _SEND5(self, aSelector, aClass, &ilc5,
                                argP[0], argP[1], argP[2], argP[3], argP[4]));
            }

        case 6:
            {
                static struct inlineCache ilc6 = __DUMMYILCSELF6(@line+1);
                RETURN ( _SEND6(self, aSelector, aClass, &ilc6,
                                argP[0], argP[1], argP[2], argP[3], argP[4], argP[5]));
            }

        case 7:
            {
                static struct inlineCache ilc7 = __DUMMYILCSELF7(@line+1);
                RETURN ( _SEND7(self, aSelector, aClass, &ilc7,
                                argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                argP[6]));
            }

        case 8:
            {
                static struct inlineCache ilc8 = __DUMMYILCSELF8(@line+1);
                RETURN ( _SEND8(self, aSelector, aClass, &ilc8,
                                argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                argP[6], argP[7]));
            }

        case 9:
            {
                static struct inlineCache ilc9 = __DUMMYILCSELF9(@line+1);
                RETURN ( _SEND9(self, aSelector, aClass, &ilc9,
                                argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                argP[6], argP[7], argP[8]));
            }

        case 10:
            {
                static struct inlineCache ilc10 = __DUMMYILCSELF10(@line+1);
                RETURN ( _SEND10(self, aSelector, aClass, &ilc10,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9]));
            }

        case 11:
            {
                static struct inlineCache ilc11 = __DUMMYILCSELF11(@line+1);
                RETURN ( _SEND11(self, aSelector, aClass, &ilc11,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10]));
            }

        case 12:
            {
                static struct inlineCache ilc12 = __DUMMYILCSELF12(@line+1);
                RETURN ( _SEND12(self, aSelector, aClass, &ilc12,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11]));
            }

        case 13:
            {
                static struct inlineCache ilc13 = __DUMMYILCSELF13(@line+1);
                RETURN ( _SEND13(self, aSelector, aClass, &ilc13,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11], argP[12]));
            }

        case 14:
            {
                static struct inlineCache ilc14 = __DUMMYILCSELF14(@line+1);
                RETURN ( _SEND14(self, aSelector, aClass, &ilc14,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11], argP[12], argP[13]));
            }

        case 15:
            {
                static struct inlineCache ilc15 = __DUMMYILCSELF15(@line+1);
                RETURN ( _SEND15(self, aSelector, aClass, &ilc15,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11], argP[12], argP[13], argP[14]));
            }

# ifdef _SEND16
        case 16:
            {
                static struct inlineCache ilc16 = __DUMMYILCSELF16(@line+1);
                RETURN ( _SEND16(self, aSelector, aClass, &ilc15,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11], argP[12], argP[13], argP[14], argP[15]));
            }
# endif
# ifdef _SEND17
        case 17:
            {
                static struct inlineCache ilc17 = __DUMMYILCSELF17(@line+1);
                RETURN ( _SEND17(self, aSelector, aClass, &ilc15,
                                 argP[0], argP[1], argP[2], argP[3], argP[4], argP[5],
                                 argP[6], argP[7], argP[8], argP[9], argP[10],
                                 argP[11], argP[12], argP[13], argP[14], argP[15], argP[16]));
            }
# endif


    }
bad:;
#endif /* not __SCHTEAM__ */
%}.
    "/ arrive here, if bad number of arguments (too many)
    "/ ST/X (currently) only allows up to 15 method arguments

    ^ self primitiveFailed
!

perform:aSelector with:arg
    "send the one-arg-message aSelector to the receiver"

%{
#ifdef __SCHTEAM__
    return context.PERFORM_WITH(self, aSelector, arg);
#else
    REGISTER OBJ sel = aSelector;
    int hash0;

    if (InterruptPending == nil) {
        struct inlineCache *pIlc;
# undef nways
# define nways 2
# undef nilcs
# define nilcs 131

# define SEL_AND_ILC_INIT_1(l)   { { nil, nil } , { __ILCPERF1(l) , __ILCPERF1(l)  } , 0 }
# define SEL_AND_ILC_INIT_2(l)   SEL_AND_ILC_INIT_1(l)   , SEL_AND_ILC_INIT_1(l)
# define SEL_AND_ILC_INIT_4(l)   SEL_AND_ILC_INIT_2(l)   , SEL_AND_ILC_INIT_2(l)
# define SEL_AND_ILC_INIT_8(l)   SEL_AND_ILC_INIT_4(l)   , SEL_AND_ILC_INIT_4(l)
# define SEL_AND_ILC_INIT_16(l)  SEL_AND_ILC_INIT_8(l)   , SEL_AND_ILC_INIT_8(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_64(l)  SEL_AND_ILC_INIT_32(l)  , SEL_AND_ILC_INIT_32(l)
# define SEL_AND_ILC_INIT_128(l) SEL_AND_ILC_INIT_64(l)  , SEL_AND_ILC_INIT_64(l)
# define SEL_AND_ILC_INIT_256(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_128(l)

# define SEL_AND_ILC_INIT_131(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_2(l) , SEL_AND_ILC_INIT_1(l)

        static struct { OBJ sel[nways]; struct inlineCache ilc[nways]; int flip; } sel_and_ilc[nilcs] = { SEL_AND_ILC_INIT_131(@line) };

# undef SEL_AND_ILC_INIT_1
# undef SEL_AND_ILC_INIT_2
# undef SEL_AND_ILC_INIT_4
# undef SEL_AND_ILC_INIT_8
# undef SEL_AND_ILC_INIT_16
# undef SEL_AND_ILC_INIT_32
# undef SEL_AND_ILC_INIT_64
# undef SEL_AND_ILC_INIT_128
# undef SEL_AND_ILC_INIT_256

# undef SEL_AND_ILC_INIT_131
# undef SEL_AND_ILC_INIT_257

# define TRY(n)                                  \
        if (sel == sel_and_ilc[hash0].sel[n]) { \
            pIlc = &sel_and_ilc[hash0].ilc[n];  \
            goto perform1_send_and_return;      \
        }

        if (__isNonNilObject(sel)) {
            hash0 = __MAKE_HASH__(__GET_HASH(sel)) % nilcs;
        } else {
            /* sel is either nil or smallint, use its value as hash */
            hash0 = (INT)sel % nilcs;
        }

        TRY(0);
        TRY(1);

# undef TRY
        /*printf("Object >> #perform: #%s --> no PIC found\n", __symbolVal(aSelector));*/

        pIlc = &sel_and_ilc[hash0].ilc[sel_and_ilc[hash0].flip];
        sel_and_ilc[hash0].sel[sel_and_ilc[hash0].flip] = sel;
        sel_and_ilc[hash0].flip = (sel_and_ilc[hash0].flip + 1) % nways;
        pIlc->ilc_func = __SEND1ADDR__;
        if (pIlc->ilc_poly) {
            __flushPolyCache(pIlc->ilc_poly);
            pIlc->ilc_poly = 0;
        }

perform1_send_and_return:
        RETURN ( (*(pIlc->ilc_func))(self, sel, nil, pIlc, arg) );
    } else {
        static struct inlineCache ilc1 = __DUMMYILCSELF1(@line+1);
        RETURN (_SEND1(self, aSelector, nil, &ilc1, arg));
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ self perform:aSelector withArguments:(Array with:arg)
!

perform:aSelector with:arg1 with:arg2
    "send the two-arg-message aSelector to the receiver"

%{
#ifdef __SCHTEAM__
    return context.PERFORM_WITH2(self, aSelector, arg1, arg2);
#else
    REGISTER OBJ sel = aSelector;
    struct inlineCache *pIlc;
    int hash0;

    if (InterruptPending == nil) {
# undef nways
# define nways 2
# undef nilcs
# define nilcs 131

# define SEL_AND_ILC_INIT_1(l)   { { nil, nil } , { __ILCPERF2(l) , __ILCPERF2(l) } , 0 }
# define SEL_AND_ILC_INIT_2(l)   SEL_AND_ILC_INIT_1(l)   , SEL_AND_ILC_INIT_1(l)
# define SEL_AND_ILC_INIT_4(l)   SEL_AND_ILC_INIT_2(l)   , SEL_AND_ILC_INIT_2(l)
# define SEL_AND_ILC_INIT_8(l)   SEL_AND_ILC_INIT_4(l)   , SEL_AND_ILC_INIT_4(l)
# define SEL_AND_ILC_INIT_16(l)  SEL_AND_ILC_INIT_8(l)   , SEL_AND_ILC_INIT_8(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
# define SEL_AND_ILC_INIT_64(l)  SEL_AND_ILC_INIT_32(l)  , SEL_AND_ILC_INIT_32(l)
# define SEL_AND_ILC_INIT_128(l) SEL_AND_ILC_INIT_64(l)  , SEL_AND_ILC_INIT_64(l)
# define SEL_AND_ILC_INIT_256(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_128(l)

# define SEL_AND_ILC_INIT_131(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_2(l) , SEL_AND_ILC_INIT_1(l)

        static struct { OBJ sel[nways]; struct inlineCache ilc[nways]; int flip; } sel_and_ilc[nilcs] = { SEL_AND_ILC_INIT_131(@line) };

# undef SEL_AND_ILC_INIT_1
# undef SEL_AND_ILC_INIT_2
# undef SEL_AND_ILC_INIT_4
# undef SEL_AND_ILC_INIT_8
# undef SEL_AND_ILC_INIT_16
# undef SEL_AND_ILC_INIT_32
# undef SEL_AND_ILC_INIT_64
# undef SEL_AND_ILC_INIT_128
# undef SEL_AND_ILC_INIT_256

# undef SEL_AND_ILC_INIT_131
# undef SEL_AND_ILC_INIT_257

# define TRY(n)                                  \
        if (sel == sel_and_ilc[hash0].sel[n]) { \
            pIlc = &sel_and_ilc[hash0].ilc[n];  \
            goto perform2_send_and_return;      \
        }

        if (__isNonNilObject(sel)) {
            hash0 = __MAKE_HASH__(__GET_HASH(sel)) % nilcs;
        } else {
            /* sel is either nil or smallint, use its value as hash */
            hash0 = (INT)sel % nilcs;
        }

        TRY(0);
        TRY(1);

# undef TRY
        /*printf("Object >> #perform: #%s --> no PIC found\n", __symbolVal(aSelector));*/

        pIlc = &sel_and_ilc[hash0].ilc[sel_and_ilc[hash0].flip];
        sel_and_ilc[hash0].sel[sel_and_ilc[hash0].flip] = sel;
        sel_and_ilc[hash0].flip = (sel_and_ilc[hash0].flip + 1) % nways;
        pIlc->ilc_func = __SEND2ADDR__;
        if (pIlc->ilc_poly) {
            __flushPolyCache(pIlc->ilc_poly);
            pIlc->ilc_poly = 0;
        }

perform2_send_and_return:
        RETURN ( (*(pIlc->ilc_func))(self, aSelector, nil, pIlc, arg1, arg2) );
    } else {
        static struct inlineCache ilc2 = __DUMMYILCSELF2(@line+1);
        RETURN (_SEND2(self, aSelector, nil, &ilc2, arg1, arg2));
    }
#endif /* not SCHTEAM */
%}.
    ^ self perform:aSelector withArguments:(Array with:arg1 with:arg2)
!

perform:aSelector with:arg1 with:arg2 with:arg3
    "send the three-arg-message aSelector to the receiver"

%{
#ifdef __SCHTEAM__
    return context.PERFORM_WITH3(self, aSelector, arg1, arg2, arg3);
#else
    struct inlineCache *pIlc;
    static struct inlineCache ilc_0 = __ILCPERF3(@line);
    static struct inlineCache ilc_1 = __ILCPERF3(@line);
    static OBJ last_0 = nil;
    static OBJ last_1 = nil;
    static int flip = 0;

    if (InterruptPending == nil) {
        if (aSelector != last_0) {
            if (aSelector != last_1) {
                if (flip) {
                    pIlc = &ilc_0;
                    flip = 0;
                    last_0 = aSelector;
                } else {
                    pIlc = &ilc_1;
                    flip = 1;
                    last_1 = aSelector;
                }
                pIlc->ilc_func = __SEND3ADDR__;
                if (pIlc->ilc_poly) {
                    __flushPolyCache(pIlc->ilc_poly);
                    pIlc->ilc_poly = 0;
                }
            } else {
                pIlc = &ilc_1;
            }
        } else {
            pIlc = &ilc_0;
        }
        RETURN ( (*(pIlc->ilc_func))(self, aSelector, nil, pIlc, arg1, arg2, arg3) );
    } else {
        static struct inlineCache ilc3 = __DUMMYILCSELF3(@line+1);
        RETURN (_SEND3(self, aSelector, nil, &ilc3, arg1, arg2, arg3));
    }
#endif /* not SCHTEAM */
%}.
    ^ self perform:aSelector withArguments:(Array with:arg1 with:arg2 with:arg3)

!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4
    "send the four-arg-message aSelector to the receiver"

%{
    struct inlineCache *pIlc;
    static struct inlineCache ilc_0 = __ILCPERF4(@line);
    static struct inlineCache ilc_1 = __ILCPERF4(@line);
    static OBJ last_0 = nil;
    static OBJ last_1 = nil;
    static int flip = 0;

    if (InterruptPending == nil) {
        if (aSelector != last_0) {
            if (aSelector != last_1) {
                if (flip) {
                    pIlc = &ilc_0;
                    flip = 0;
                    last_0 = aSelector;
                } else {
                    pIlc = &ilc_1;
                    flip = 1;
                    last_1 = aSelector;
                }
                pIlc->ilc_func = __SEND4ADDR__;
                if (pIlc->ilc_poly) {
                    __flushPolyCache(pIlc->ilc_poly);
                    pIlc->ilc_poly = 0;
                }
            } else {
                pIlc = &ilc_1;
            }
        } else {
            pIlc = &ilc_0;
        }
        RETURN ( (*(pIlc->ilc_func))(self, aSelector, nil, pIlc,
                                     arg1, arg2, arg3, arg4) );
    } else {
        static struct inlineCache ilc4 = __DUMMYILCSELF4(@line+1);
        RETURN (_SEND4(self, aSelector, nil, &ilc4,
                       arg1, arg2, arg3, arg4));
    }
%}.
    ^ self perform:aSelector withArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4)

!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "send the five-arg-message aSelector to the receiver"

%{
    struct inlineCache *pIlc;
    static struct inlineCache ilc_0 = __ILCPERF5(@line);
    static struct inlineCache ilc_1 = __ILCPERF5(@line);
    static OBJ last_0 = nil;
    static OBJ last_1 = nil;
    static int flip = 0;

    if (InterruptPending == nil) {
        if (aSelector != last_0) {
            if (aSelector != last_1) {
                if (flip) {
                    pIlc = &ilc_0;
                    flip = 0;
                    last_0 = aSelector;
                } else {
                    pIlc = &ilc_1;
                    flip = 1;
                    last_1 = aSelector;
                }
                pIlc->ilc_func = __SEND5ADDR__;
                if (pIlc->ilc_poly) {
                    __flushPolyCache(pIlc->ilc_poly);
                    pIlc->ilc_poly = 0;
                }
            } else {
                pIlc = &ilc_1;
            }
        } else {
            pIlc = &ilc_0;
        }
        RETURN ( (*(pIlc->ilc_func))(self, aSelector, nil, pIlc,
                                     arg1, arg2, arg3, arg4, arg5) );
    } else {
        static struct inlineCache ilc5 = __DUMMYILCSELF5(@line+1);
        RETURN (_SEND5(self, aSelector, nil, &ilc5,
                       arg1, arg2, arg3, arg4, arg5));
    }
%}.
    ^ self perform:aSelector withArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4
                                                  with:arg5)

!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6
    "send the six-arg-message aSelector to the receiver"

%{
    struct inlineCache *pIlc;
    static struct inlineCache ilc_0 = __ILCPERF6(@line);
    static struct inlineCache ilc_1 = __ILCPERF6(@line);
    static OBJ last_0 = nil;
    static OBJ last_1 = nil;
    static int flip = 0;

    if (InterruptPending == nil) {
        if (aSelector != last_0) {
            if (aSelector != last_1) {
                if (flip) {
                    pIlc = &ilc_0;
                    flip = 0;
                    last_0 = aSelector;
                } else {
                    pIlc = &ilc_1;
                    flip = 1;
                    last_1 = aSelector;
                }
                pIlc->ilc_func = __SEND6ADDR__;
                if (pIlc->ilc_poly) {
                    __flushPolyCache(pIlc->ilc_poly);
                    pIlc->ilc_poly = 0;
                }
            } else {
                pIlc = &ilc_1;
            }
        } else {
            pIlc = &ilc_0;
        }

        RETURN ( (*(pIlc->ilc_func))(self, aSelector, nil, pIlc,
                                     arg1, arg2, arg3, arg4, arg5, arg6) );
    } else {
        static struct inlineCache ilc6 = __DUMMYILCSELF6(@line+1);
        RETURN (_SEND6(self, aSelector, nil, &ilc6,
                       arg1, arg2, arg3, arg4, arg5, arg6));
    }
%}.
    ^ self perform:aSelector withArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4
                                                  with:arg5 with:arg6)

!

perform:aSelector withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver."

    |numberOfArgs a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15|

%{
#ifdef __SCHTEAM__
    return context.PERFORM_WITH_ARGUMENTS(self, aSelector, argArray);
#else
    REGISTER OBJ *argP;
    int nargs;
    OBJ l;

    if (__isArrayLike(argArray)) {
        nargs = __arraySize(argArray);
        argP = __arrayVal(argArray);
    } else {
        if (__isNonNilObject(argArray)) {
            static struct inlineCache ilcSize = __ILC0(@line);
            int i;

            numberOfArgs = (*ilcSize.ilc_func)(argArray, @symbol(size), nil, &ilcSize);
            if (!__isSmallInteger(numberOfArgs))
                goto bad;
            nargs = __intVal(numberOfArgs);
            argP = (OBJ *)(&a1);
            for (i=1; i <= nargs; i++) {
                *argP++ = __AT_(argArray, __mkSmallInteger(i));
            }
            argP = (OBJ *)(&a1);
        } else {
            nargs = 0;
        }
    }
    switch (nargs) {
        case 0:
            if (InterruptPending == nil) {
                static OBJ last0_0 = nil; static struct inlineCache ilc0_0 = __ILCPERF0(@line);
                static OBJ last0_1 = nil; static struct inlineCache ilc0_1 = __ILCPERF0(@line);
                static OBJ last0_2 = nil; static struct inlineCache ilc0_2 = __ILCPERF0(@line);
                static OBJ last0_3 = nil; static struct inlineCache ilc0_3 = __ILCPERF0(@line);
                static int flip0 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last0_0) {
                    pIlc = &ilc0_0;
                } else if (aSelector == last0_1) {
                    pIlc = &ilc0_1;
                } else if (aSelector == last0_2) {
                    pIlc = &ilc0_2;
                } else if (aSelector == last0_3) {
                    pIlc = &ilc0_3;
                } else {
                    if (flip0 == 0) {
                        pIlc = &ilc0_0;
                        flip0 = 1;
                        last0_0 = aSelector;
                    } else if (flip0 == 1) {
                        pIlc = &ilc0_1;
                        flip0 = 2;
                        last0_1 = aSelector;
                    } else if (flip0 == 2) {
                        pIlc = &ilc0_2;
                        flip0 = 3;
                        last0_2 = aSelector;
                    } else {
                        pIlc = &ilc0_3;
                        flip0 = 0;
                        last0_3 = aSelector;
                    }

                    pIlc->ilc_func = __SEND0ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc));
            } else {
                static struct inlineCache ilc0 = __DUMMYILCSELF0(@line+1);
                RETURN (_SEND0(self, aSelector, nil, &ilc0));
            }

        case 1:
            if (InterruptPending == nil) {
                static OBJ last1_0 = nil; static struct inlineCache ilc1_0 = __ILCPERF1(@line);
                static OBJ last1_1 = nil; static struct inlineCache ilc1_1 = __ILCPERF1(@line);
                static OBJ last1_2 = nil; static struct inlineCache ilc1_2 = __ILCPERF1(@line);
                static OBJ last1_3 = nil; static struct inlineCache ilc1_3 = __ILCPERF1(@line);
                static int flip1 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last1_0) {
                    pIlc = &ilc1_0;
                } else if (aSelector == last1_1) {
                    pIlc = &ilc1_1;
                } else if (aSelector == last1_2) {
                    pIlc = &ilc1_2;
                } else if (aSelector == last1_3) {
                    pIlc = &ilc1_3;
                } else {
                    if (flip1 == 0) {
                        pIlc = &ilc1_0;
                        flip1 = 1;
                        last1_0 = aSelector;
                    } else if (flip1 == 1) {
                        pIlc = &ilc1_1;
                        flip1 = 2;
                        last1_1 = aSelector;
                    } else if (flip1 == 2) {
                        pIlc = &ilc1_2;
                        flip1 = 3;
                        last1_2 = aSelector;
                    } else {
                        pIlc = &ilc1_3;
                        flip1 = 0;
                        last1_3 = aSelector;
                    }

                    pIlc->ilc_func = __SEND1ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0]));
            } else {
                static struct inlineCache ilc1 = __DUMMYILCSELF1(@line+1);
                RETURN (_SEND1(self, aSelector, nil, &ilc1, argP[0]));
            }

        case 2:
            if (InterruptPending == nil) {
                static OBJ last2_0 = nil; static struct inlineCache ilc2_0 = __ILCPERF2(@line);
                static OBJ last2_1 = nil; static struct inlineCache ilc2_1 = __ILCPERF2(@line);
                static int flip2 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last2_0) {
                    pIlc = &ilc2_0;
                } else if (aSelector == last2_1) {
                    pIlc = &ilc2_1;
                } else {
                    if (flip2 == 0) {
                        pIlc = &ilc2_0;
                        flip2 = 1;
                        last2_0 = aSelector;
                    } else {
                        pIlc = &ilc2_1;
                        flip2 = 0;
                        last2_1 = aSelector;
                    }

                    pIlc->ilc_func = __SEND2ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0], argP[1]));
            } else {
                static struct inlineCache ilc2 = __DUMMYILCSELF2(@line+1);
                RETURN (_SEND2(self, aSelector, nil, &ilc2, argP[0], argP[1]));
            }

        case 3:
            if (InterruptPending == nil) {
                static OBJ last3_0 = nil; static struct inlineCache ilc3_0 = __ILCPERF3(@line);
                static OBJ last3_1 = nil; static struct inlineCache ilc3_1 = __ILCPERF3(@line);
                static int flip3 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last3_0) {
                    pIlc = &ilc3_0;
                } else if (aSelector == last3_1) {
                    pIlc = &ilc3_1;
                } else {
                    if (flip3 == 0) {
                        pIlc = &ilc3_0;
                        flip3 = 1;
                        last3_0 = aSelector;
                    } else {
                        pIlc = &ilc3_1;
                        flip3 = 0;
                        last3_1 = aSelector;
                    }

                    pIlc->ilc_func = __SEND3ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0], argP[1], argP[2]));
            } else {
                static struct inlineCache ilc3 = __DUMMYILCSELF3(@line+1);
                RETURN (_SEND3(self, aSelector, nil, &ilc3, argP[0], argP[1], argP[2]));
            }

        case 4:
            {
                static OBJ last4 = nil; static struct inlineCache ilc4 = __ILCPERF4(@line);

                if ((InterruptPending != nil) || (aSelector != last4)) {
                    ilc4.ilc_func = __SEND4ADDR__;
                    if (ilc4.ilc_poly) {
                        __flushPolyCache(ilc4.ilc_poly);
                        ilc4.ilc_poly = 0;
                    }
                    last4 = aSelector;
                }
                RETURN ( (*ilc4.ilc_func)(self, aSelector, nil, &ilc4,
                                                argP[0], argP[1], argP[2], argP[3]));
            }

        case 5:
            {
                static OBJ last5 = nil; static struct inlineCache ilc5 = __ILCPERF5(@line);

                if ((InterruptPending != nil) || (aSelector != last5)) {
                    ilc5.ilc_func = __SEND5ADDR__;
                    if (ilc5.ilc_poly) {
                        __flushPolyCache(ilc5.ilc_poly);
                        ilc5.ilc_poly = 0;
                    }
                    last5 = aSelector;
                }
                RETURN ( (*ilc5.ilc_func)(self, aSelector, nil, &ilc5,
                                                argP[0], argP[1], argP[2], argP[3], argP[4]));
            }

        case 6:
            {
                static OBJ last6 = nil; static struct inlineCache ilc6 = __ILCPERF6(@line);

                if ((InterruptPending != nil) || (aSelector != last6)) {
                    ilc6.ilc_func = __SEND6ADDR__;
                    if (ilc6.ilc_poly) {
                        __flushPolyCache(ilc6.ilc_poly);
                        ilc6.ilc_poly = 0;
                    }
                    last6 = aSelector;
                }
                RETURN ( (*ilc6.ilc_func)(self, aSelector, nil, &ilc6,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5]));
            }

        case 7:
            {
                static OBJ last7 = nil; static struct inlineCache ilc7 = __ILCPERF7(@line);

                if ((InterruptPending != nil) || (aSelector != last7)) {
                    ilc7.ilc_func = __SEND7ADDR__;
                    if (ilc7.ilc_poly) {
                        __flushPolyCache(ilc7.ilc_poly);
                        ilc7.ilc_poly = 0;
                    }
                    last7 = aSelector;
                }
                RETURN ( (*ilc7.ilc_func)(self, aSelector, nil, &ilc7,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6]));
            }

        case 8:
            {
                static OBJ last8 = nil; static struct inlineCache ilc8 = __ILCPERF8(@line);

                if ((InterruptPending != nil) || (aSelector != last8)) {
                    ilc8.ilc_func = __SEND8ADDR__;
                    if (ilc8.ilc_poly) {
                        __flushPolyCache(ilc8.ilc_poly);
                        ilc8.ilc_poly = 0;
                    }
                    last8 = aSelector;
                }
                RETURN ( (*ilc8.ilc_func)(self, aSelector, nil, &ilc8,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7]));
            }

        case 9:
            {
                static OBJ last9 = nil; static struct inlineCache ilc9 = __ILCPERF9(@line);

                if ((InterruptPending != nil) || (aSelector != last9)) {
                    ilc9.ilc_func = __SEND9ADDR__;
                    if (ilc9.ilc_poly) {
                        __flushPolyCache(ilc9.ilc_poly);
                        ilc9.ilc_poly = 0;
                    }
                    last9 = aSelector;
                }
                RETURN ( (*ilc9.ilc_func)(self, aSelector, nil, &ilc9,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8]));
            }

        case 10:
            {
                static OBJ last10 = nil; static struct inlineCache ilc10 = __ILCPERF10(@line);

                if ((InterruptPending != nil) || (aSelector != last10)) {
                    ilc10.ilc_func = __SEND10ADDR__;
                    if (ilc10.ilc_poly) {
                        __flushPolyCache(ilc10.ilc_poly);
                        ilc10.ilc_poly = 0;
                    }
                    last10 = aSelector;
                }
                RETURN ( (*ilc10.ilc_func)(self, aSelector, nil, &ilc10,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9]));
            }

        case 11:
            {
                static OBJ last11 = nil; static struct inlineCache ilc11 = __ILCPERF11(@line);

                if ((InterruptPending != nil) || (aSelector != last11)) {
                    ilc11.ilc_func = __SEND11ADDR__;
                    if (ilc11.ilc_poly) {
                        __flushPolyCache(ilc11.ilc_poly);
                        ilc11.ilc_poly = 0;
                    }
                    last11 = aSelector;
                }
                RETURN ( (*ilc11.ilc_func)(self, aSelector, nil, &ilc11,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10]));
            }

        case 12:
            {
                static OBJ last12 = nil; static struct inlineCache ilc12 = __ILCPERF12(@line);

                if ((InterruptPending != nil) || (aSelector != last12)) {
                    ilc12.ilc_func = __SEND12ADDR__;
                    if (ilc12.ilc_poly) {
                        __flushPolyCache(ilc12.ilc_poly);
                        ilc12.ilc_poly = 0;
                    }
                    last12 = aSelector;
                }
                RETURN ( (*ilc12.ilc_func)(self, aSelector, nil, &ilc12,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11]));
            }

        case 13:
            {
                static OBJ last13 = nil; static struct inlineCache ilc13 = __ILCPERF13(@line);

                if ((InterruptPending != nil) || (aSelector != last13)) {
                    ilc13.ilc_func = __SEND13ADDR__;
                    if (ilc13.ilc_poly) {
                        __flushPolyCache(ilc13.ilc_poly);
                        ilc13.ilc_poly = 0;
                    }
                    last13 = aSelector;
                }
                RETURN ( (*ilc13.ilc_func)(self, aSelector, nil, &ilc13,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12]));
            }

        case 14:
            {
                static OBJ last14 = nil; static struct inlineCache ilc14 = __ILCPERF14(@line);

                if ((InterruptPending != nil) || (aSelector != last14)) {
                    ilc14.ilc_func = __SEND14ADDR__;
                    if (ilc14.ilc_poly) {
                        __flushPolyCache(ilc14.ilc_poly);
                        ilc14.ilc_poly = 0;
                    }
                    last14 = aSelector;
                }
                RETURN ( (*ilc14.ilc_func)(self, aSelector, nil, &ilc14,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12], argP[13]));
            }

        case 15:
            {
                static OBJ last15 = nil; static struct inlineCache ilc15 = __ILCPERF15(@line);

                if ((InterruptPending != nil) || (aSelector != last15)) {
                    ilc15.ilc_func = __SEND15ADDR__;
                    if (ilc15.ilc_poly) {
                        __flushPolyCache(ilc15.ilc_poly);
                        ilc15.ilc_poly = 0;
                    }
                    last15 = aSelector;
                }
                RETURN ( (*ilc15.ilc_func)(self, aSelector, nil, &ilc15,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12], argP[13],
                                                argP[14]));
            }
    }
bad:;
#endif
%}.

    "/ arrive here, if bad number of arguments (too many)
    "/ ST/X (currently) only allows up to 15 method arguments

    ^ self primitiveFailed
!

perform:aSelector withOptionalArgument:arg
    "send aSelector-message to the receiver.
     If the message expects an argument, pass arg."

    aSelector argumentCount == 1 ifTrue:[
        ^ self perform:aSelector with:arg
    ].
    ^ self perform:aSelector

    "
     |rec sel|

     rec := -1.
     sel := #abs.
     rec perform:sel withOptionalArgument:2.

     sel := #max:.
     rec perform:sel withOptionalArgument:2.
    "
!

perform:aSelector withOptionalArgument:optionalArg1 and:optionalArg2
    "send aSelector-message to the receiver.
     Depending on the number of arguments the message expects,
     pass either none, 1, or 2 arguments."

    |numArgs|

    numArgs := aSelector argumentCount.
    numArgs == 0 ifTrue:[
        ^ self perform:aSelector
    ].
    numArgs == 1 ifTrue:[
        ^ self perform:aSelector with:optionalArg1
    ].
    ^ self perform:aSelector with:optionalArg1 with:optionalArg2.

    "
     |rec sel|

     rec := -1.
     sel := #abs.
     rec perform:sel withOptionalArgument:2.

     sel := #max:.
     rec perform:sel withOptionalArgument:2.
    "
!

perform:aSelector withOptionalArgument:optionalArg1 and:optionalArg2 and:optionalArg3
    "send aSelector-message to the receiver.
     Depending on the number of arguments the message expects,
     pass either none, 1, 2 or 3 arguments."

    |numArgs|

    numArgs := aSelector argumentCount.
    numArgs == 0 ifTrue:[
        ^ self perform:aSelector
    ].
    numArgs == 1 ifTrue:[
        ^ self perform:aSelector with:optionalArg1
    ].
    numArgs == 2 ifTrue:[
        ^ self perform:aSelector with:optionalArg1 with:optionalArg2
    ].
    ^ self perform:aSelector with:optionalArg1 with:optionalArg2 with:optionalArg3.

    "
     |rec sel|

     rec := -1.
     sel := #abs.
     rec perform:sel withOptionalArgument:2.

     sel := #max:.
     rec perform:sel withOptionalArgument:2.
    "
!

perform:aSelector withOptionalArgument:optionalArg1 and:optionalArg2 and:optionalArg3 and:optionalArg4
    "send aSelector-message to the receiver.
     Depending on the number of arguments the message expects,
     pass either none, 1, 2, 3 or 4 arguments."

    |numArgs|

    numArgs := aSelector argumentCount.
    numArgs == 0 ifTrue:[
        ^ self perform:aSelector
    ].
    numArgs == 1 ifTrue:[
        ^ self perform:aSelector with:optionalArg1
    ].
    numArgs == 2 ifTrue:[
        ^ self perform:aSelector with:optionalArg1 with:optionalArg2
    ].
    numArgs == 3 ifTrue:[
        ^ self perform:aSelector with:optionalArg1 with:optionalArg2 with:optionalArg3
    ].
    ^ self perform:aSelector with:optionalArg1 with:optionalArg2 with:optionalArg3 with:optionalArg4.

    "
     |rec sel|

     rec := -1.
     sel := #abs.
     rec perform:sel withOptionalArgument:2.

     sel := #max:.
     rec perform:sel withOptionalArgument:2.
    "
!

performMessage:aMessage
    "Send aMessage, an object which provides a selector and arguments to the
     receiver object.
     Added for Ansi compatibility"

    ^ self perform:(aMessage selector) withArguments:(aMessage arguments).

    "
     123 performMessage:(Message selector:#+ argument:100)
    "
!

performMethod:aMethod
    "invoke aMethod on the receiver.
     The method should be a zero-argument method.
     This is a non-object-oriented entry, applying a method
     in a functional way on a receiver.
     Warning:
         Take care for the method to be appropriate for the
         receiver - no checking is done by the VM."

    ^ aMethod valueWithReceiver:self arguments:#()

    "
     |mthd|

     mthd := SmallInteger compiledMethodAt:#negated.
     Transcript showCR:(1 performMethod:mthd)
    "

    "BAD USE example:

     |mthd|

     mthd := Point compiledMethodAt:#x.
     Transcript showCR:((1->2) performMethod:mthd)
    "

    "Modified: 31.7.1997 / 17:41:50 / cg"
!

performMethod:aMethod arguments:argumentArray
    "invoke aMethod on the receiver, passing an argumentArray.
     The size of the argumentArray should match the number of args
     expected by the method.
     This is a non-object-oriented entry, applying a method
     in a functional way on a receiver.
     Warning:
         Take care for the method to be appropriate for the
         receiver - no checking is done by the VM."

    ^ aMethod valueWithReceiver:self arguments:argumentArray

    "
     |mthd|

     mthd := SmallInteger compiledMethodAt:#+.
     Transcript showCR:(1 performMethod:mthd arguments:#(2))
    "

    "Created: 31.7.1997 / 17:46:31 / cg"
!

performMethod:aMethod with:arg
    "invoke aMethod on the receiver, passing an argument.
     The method should be a one-argument method.
     This is a non-object-oriented entry, applying a method
     in a functional way on a receiver.
     Warning:
         Take care for the method to be appropriate for the
         receiver - no checking is done by the VM."

    ^ aMethod valueWithReceiver:self arguments:(Array with:arg)

    "
     |mthd|

     mthd := SmallInteger compiledMethodAt:#+.
     Transcript showCR:(1 performMethod:mthd with:2)
    "

    "Modified: 31.7.1997 / 17:42:32 / cg"
!

performMethod:aMethod with:arg1 with:arg2
    "invoke aMethod on the receiver, passing two arguments.
     The method should be a two-argument method.
     This is a non-object-oriented entry, applying a method
     in a functional way on a receiver.
     Warning:
         Take care for the method to be appropriate for the
         receiver - no checking is done by the VM."

    ^ aMethod valueWithReceiver:self arguments:(Array with:arg1 with:arg2)

    "
     |mthd arr|

     arr := Array new:1.
     mthd := Array compiledMethodAt:#basicAt:put:.
     arr performMethod:mthd with:1 with:'foo'.
     Transcript showCR:arr
    "

    "Modified: 31.7.1997 / 17:44:54 / cg"
!

performMethod:aMethod with:arg1 with:arg2 with:arg3
    "invoke aMethod on the receiver, passing three arguments.
     The method should be a three-argument method.
     This is a non-object-oriented entry, applying a method
     in a functional way on a receiver.
     Warning:
         Take care for the method to be appropriate for the
         receiver - no checking is done by the VM."

    ^ aMethod valueWithReceiver:self arguments:(Array with:arg1 with:arg2 with:arg3)

    "Created: 31.7.1997 / 17:45:20 / cg"
!

performX:aSelector
    "send the message aSelector to the receiver
     This is the original implementation of #perform, for reference (before Jan's changes for Ruby tuning)."

    <resource: #skipInDebuggersWalkBack>

%{
    REGISTER OBJ sel = aSelector;

    if (InterruptPending == nil) {
        struct inlineCache *pIlc;

#define SEL_AND_ILC_INIT_1(l)   { nil , __ILCPERF0(l) }
#define SEL_AND_ILC_INIT_2(l)   SEL_AND_ILC_INIT_1(l)   , SEL_AND_ILC_INIT_1(l)
#define SEL_AND_ILC_INIT_4(l)   SEL_AND_ILC_INIT_2(l)   , SEL_AND_ILC_INIT_2(l)
#define SEL_AND_ILC_INIT_8(l)   SEL_AND_ILC_INIT_4(l)   , SEL_AND_ILC_INIT_4(l)
#define SEL_AND_ILC_INIT_16(l)  SEL_AND_ILC_INIT_8(l)   , SEL_AND_ILC_INIT_8(l)
#define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
#define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
#define SEL_AND_ILC_INIT_64(l)  SEL_AND_ILC_INIT_32(l)  , SEL_AND_ILC_INIT_32(l)
#define SEL_AND_ILC_INIT_128(l) SEL_AND_ILC_INIT_64(l)  , SEL_AND_ILC_INIT_64(l)
#define SEL_AND_ILC_INIT_256(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_128(l)
#undef nilcs
#define nilcs 256

        static struct sel_and_ilc {
            OBJ sel;
            struct inlineCache ilc;
            struct sel_and_ilc *next;
        } sel_and_ilc[nilcs] = { SEL_AND_ILC_INIT_256(29) };

#undef SEL_AND_ILC_INIT_1
#undef SEL_AND_ILC_INIT_2
#undef SEL_AND_ILC_INIT_4
#undef SEL_AND_ILC_INIT_8
#undef SEL_AND_ILC_INIT_16
#undef SEL_AND_ILC_INIT_32
#undef SEL_AND_ILC_INIT_64
#undef SEL_AND_ILC_INIT_128
#undef SEL_AND_ILC_INIT_256

        static struct sel_and_ilc *nextFree = sel_and_ilc;
        static struct sel_and_ilc *lastUsed = 0;
        int n;
        struct sel_and_ilc *slot, *prev, *prevPrev;

        for (n=0, slot = lastUsed, prev = prevPrev = 0; slot; n++, slot = slot->next) {
           if (sel == slot->sel) {
#ifdef XXDEBUG
printf("cached slot %d (len=%d)\n", slot-sel_and_ilc, n);
#endif
                pIlc = &(slot->ilc);
                // move to front
                if (prev) {
                    prev->next = slot->next;
                }
                slot->next = lastUsed;
                lastUsed = slot;
                pIlc = &(slot->ilc);
                goto perform0_send_and_return;
           }
           prevPrev = prev;
           prev = slot;
        }
        // not recently used...
        if (nextFree) {
            // another free one
            slot = nextFree;
            nextFree = nextFree + 1;
            if (nextFree >= &(sel_and_ilc[nilcs])) nextFree = 0;
#ifdef XXDEBUG
printf("new slot %d\n", slot-sel_and_ilc);
#endif
        } else {
            // no more for reuse - use least recently used
            slot = prev;
            prevPrev->next = 0;
            slot->next = lastUsed;
            lastUsed = slot;
#ifdef XXDEBUG
printf("reuse last slot %d\n", slot-sel_and_ilc);
#endif
        }

        /*printf("Object >> #perform: #%s --> no PIC found\n", __symbolVal(aSelector));*/
        pIlc = &(slot->ilc);
        slot->sel = sel;
        pIlc->ilc_func = __SEND0ADDR__;
        if (pIlc->ilc_poly) {
             __flushPolyCache(pIlc->ilc_poly);
            pIlc->ilc_poly = 0;
        }
perform0_send_and_return:
        RETURN ( (*(pIlc->ilc_func))(self, sel, nil, pIlc) );
    } else {
        static struct inlineCache ilc0 = __DUMMYILCSELF0(@line+1);
        RETURN (_SEND0(self, aSelector, nil, &ilc0));
    }
%}.
    ^ self perform:aSelector withArguments:#()
!

returnablePerform:aSelector with:arg
    "send the one-arg-message aSelector to the receiver.
     This is the same as #perform:with: but the context can return."

    <context: #return>
%{
    REGISTER OBJ sel = aSelector;

    if (InterruptPending == nil) {
        struct inlineCache *pIlc;
    /* JV @ 2010-22-07: To improve performance I use 256 ILCs instead
       of default 4. For details, see comment in perform: */

#define SEL_AND_ILC_INIT_1(l)   { nil , __ILCPERF1(l) }
#define SEL_AND_ILC_INIT_2(l)   SEL_AND_ILC_INIT_1(l)   , SEL_AND_ILC_INIT_1(l)
#define SEL_AND_ILC_INIT_4(l)   SEL_AND_ILC_INIT_2(l)   , SEL_AND_ILC_INIT_2(l)
#define SEL_AND_ILC_INIT_8(l)   SEL_AND_ILC_INIT_4(l)   , SEL_AND_ILC_INIT_4(l)
#define SEL_AND_ILC_INIT_16(l)  SEL_AND_ILC_INIT_8(l)   , SEL_AND_ILC_INIT_8(l)
#define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
#define SEL_AND_ILC_INIT_32(l)  SEL_AND_ILC_INIT_16(l)  , SEL_AND_ILC_INIT_16(l)
#define SEL_AND_ILC_INIT_64(l)  SEL_AND_ILC_INIT_32(l)  , SEL_AND_ILC_INIT_32(l)
#define SEL_AND_ILC_INIT_128(l) SEL_AND_ILC_INIT_64(l)  , SEL_AND_ILC_INIT_64(l)
#define SEL_AND_ILC_INIT_256(l) SEL_AND_ILC_INIT_128(l) , SEL_AND_ILC_INIT_128(l)
#undef nilcs
#define nilcs 256

        static struct { OBJ sel; struct inlineCache ilc; } sel_and_ilc[nilcs] = { SEL_AND_ILC_INIT_256(29) };

#undef SEL_AND_ILC_INIT_1
#undef SEL_AND_ILC_INIT_2
#undef SEL_AND_ILC_INIT_4
#undef SEL_AND_ILC_INIT_8
#undef SEL_AND_ILC_INIT_16
#undef SEL_AND_ILC_INIT_32
#undef SEL_AND_ILC_INIT_64
#undef SEL_AND_ILC_INIT_128
#undef SEL_AND_ILC_INIT_256

        static int flip = 0;
        int i;
        for (i = 0; i < nilcs; i++) {
           if (sel == sel_and_ilc[i].sel) {
                pIlc = &sel_and_ilc[i].ilc;
                goto perform1_send_and_return;
           }
        }
        /*printf("Object >> #perform: #%s with: arg --> no PIC found\n", __symbolVal(aSelector));*/
        pIlc = &sel_and_ilc[flip].ilc;
        sel_and_ilc[flip].sel = sel;
        flip = (flip + 1) % nilcs;
        pIlc->ilc_func = __SEND1ADDR__;
        if (pIlc->ilc_poly) {
             __flushPolyCache(pIlc->ilc_poly);
            pIlc->ilc_poly = 0;
        }
perform1_send_and_return:
        RETURN ( (*(pIlc->ilc_func))(self, sel, nil, pIlc, arg) );
    } else {
        static struct inlineCache ilc1 = __DUMMYILCSELF1(@line+1);
        RETURN (_SEND1(self, aSelector, nil, &ilc1, arg));
    }
%}.
    ^ self perform:aSelector withArguments:(Array with:arg)
! !

!Object methodsFor:'misc ui support'!

browse
    "open a browser on the receiver's class"

    self class theNonMetaclass browse

    "
     10 browse
     Collection browse
     Collection class browse
    "
!

inspect
    "{ Pragma: +optSpace }"

    "launch an inspector on the receiver.
     this method (or better: inspectorClass) can be redefined in subclasses
     to start special inspectors."

    |cls|

    Inspector ~~ MiniInspector ifTrue:[
        cls := (Smalltalk classNamed: #'Tools::Inspector2').
    ].
    cls isNil ifTrue:[
        cls := self inspectorClass.
        cls isNil ifTrue:[
            ^ self basicInspect
        ].
    ].    
    cls openOn:self

    "
     Object new inspect
     (1 @ 2) inspect
     Smalltalk inspect
     #(1 2 3) asOrderedCollection inspect
     (Color red) inspect
     (Image fromFile:'bitmaps/garfield.gif') inspect
    "
!

inspectorClass
    "{ Pragma: +optSpace }"

    "return the class to use for inspect.
     Can (should) be redefined in classes for which a better inspector is available"

    Inspector notNil ifTrue:[
        ^ Inspector.
    ].
    ^ (Smalltalk classNamed: #'InspectorView')

    "Modified: / 08-03-2012 / 16:09:38 / cg"
! !

!Object methodsFor:'object persistency'!

elementDescriptorFor:anAspectSymbol
    "support for persistency:
     answer a collection of associations containing the
     objects state to be encoded for aspect.
     Association key is the instance variable name or access selector,
     association value is the contents of the instance variable.

     The default is to return the contents of all non-nil instance variables"

    |ret|

    ret := 0.
    anAspectSymbol notNil ifTrue:[
        ret := self perform:anAspectSymbol ifNotUnderstood:[0].
    ].
    ret == 0 ifTrue:[
        ^ self elementDescriptorForNonNilInstanceVariables
    ].
    ^ ret.
!

elementDescriptorForInstanceVariables
    "return all instance variables for visiting/encoding"

    ^ self elementDescriptorForInstanceVariablesMatching:[:val | true].

    "
      #(1 2 3 nil true symbol) elementDescriptorForInstanceVariables
      Dictionary new elementDescriptorForInstanceVariables
      (5 @ nil) elementDescriptorForInstanceVariables
    "
!

elementDescriptorForInstanceVariablesMatching:aBlock
    "return all instance variables which conform to aBlock, for encoding/visiting.
     Indexed vars are all included."

    |instVarNames theClass children
     instSize "{ Class: SmallInteger }"
     varSize "{ Class: SmallInteger }"|

    theClass := self class.

    instSize := theClass instSize.
    varSize := theClass isVariable ifTrue:[self basicSize] ifFalse:[0].
    children := OrderedCollection new:(instSize + varSize).

    instVarNames := theClass allInstVarNames.
    1 to:instSize do:[:i | |var|
        var := self instVarAt:i.
        (aBlock value:var) ifTrue:[
            children add:((instVarNames at:i) -> var)
        ]
    ].

    varSize ~~ 0 ifTrue:[
        1 to:varSize do:[:i |
            children add:(i -> (self basicAt:i))
        ]
    ].

    ^ children.

    "
      #(1 2 3 nil true symbol) elementDescriptorForInstanceVariables
      Dictionary new elementDescriptorForInstanceVariables
      (5 @ nil) elementDescriptorForInstanceVariables
    "
!

elementDescriptorForNonNilInstanceVariables
    "return all non-nil instance variables for visiting/encoding"

    ^ self elementDescriptorForInstanceVariablesMatching:[:val | val notNil].

    "
      #(1 2 3 nil true symbol) elementDescriptorForNonNilInstanceVariables
      Dictionary new elementDescriptorForNonNilInstanceVariables
      (5 @ nil) elementDescriptorForNonNilInstanceVariables
    "
! !

!Object methodsFor:'printing & storing'!

_errorPrint
    "Do not use this in user code.
     Prints on stderr, regardless of any redirection to a logger.
     Only to be used by the MiniDebugger, to ensure that its output is shown to a user"

    self asString _errorPrint.
!

_errorPrintCR
    "Do not use this in user code.
     Prints on stderr, regardless of any redirection to a logger.
     Only to be used by the MiniDebugger, to ensure that its output is shown to a user"

    self asString _errorPrintCR.
!

_print
    "Do not use this in user code.
     Prints on stdout, regardless of any redirection to a logger.
     Only to be used by low-level crash utilities (like MiniDebugger), 
     to ensure that its output is shown to a user"

    self asString _print.
!

_printCR
    "Do not use this in user code.
     Prints on stdout, regardless of any redirection to a logger.
     Only to be used by low-level crash utilities (like MiniDebugger), 
     to ensure that its output is shown to a user"

    self asString _printCR.
!

basicPrintOn:aStream
    "append the receiver's className with an article to the argument, aStream"

    aStream nextPutAll:self classNameWithArticle
!

basicStoreString
    "defined here for compatibility with CharacterArray, which redefines this"

    ^ self storeString
!

className
    "return the classname of the receiver's class"

    ^ self class name

    "
     1 className
     1 class className
     $a className
     $a class className
    "
!

classNameWithArticle
    "return a string consisting of classname preceeded by an article.
     (don't expect me to write national variants for this ... :-)
     If you have special preferences, redefine it ..."

    | cls|

    (cls := self class) == self ifTrue:[
        ^ 'a funny object'
    ].
    cls isNil ifTrue:[
        ^ 'a nil-classes object'        "/ cannot happen
    ].
    ^ cls nameWithArticle

    "
     1 classNameWithArticle
     (1->2) classNameWithArticle
     XWorkstation basicNew classNameWithArticle
     XWorkstation classNameWithArticle
    "

    "Modified: 13.5.1996 / 12:16:14 / cg"
!

errorPrint
    "if a logger has been defined, let it print the receiver when a CR is coming.
     Otherwise, print the receiver on the Transcript and Stderr.
     The Transcript is directed to the standard error stream on
     headless applications."

    Logger notNil ifTrue:[
        PartialErrorPrintLine := (PartialErrorPrintLine ? ''), self printString string.
        ^ self.
    ].
    Stderr isNil ifTrue:[
        "/ the following allows errorPrint to be used during
        "/ the early init-phase, when no Stderr has been set up.
        "/ (depends on string to respond to #errorPrint)
        self printString utf8Encoded errorPrint.
        ^ self.
    ].

    self withErrorStreamDo:[:s | self printOn:s].

    "Modified: / 21-04-2011 / 12:46:42 / cg"
!

errorPrintCR
    "{ Pragma: +optSpace }"

    "if a logger has been defined, let it print the receiver.
     otherwise, print the receiver followed by a cr on the error stream(s).
     The Transcript is directed to the standard error stream on
     headless applications."

    Logger notNil ifTrue:[
        |fullLine|
        fullLine := (PartialErrorPrintLine ? ''), self printString string.
        PartialErrorPrintLine := nil.
        Logger error:fullLine.
        ^ self.
    ].
    Stderr isNil ifTrue:[
        "/ the following allows errorPrintCR to be used during
        "/ the early init-phase, when no Stderr has been set up.
        "/ (depends on string to respond to #errorPrintCR)
        self printString utf8Encoded errorPrintCR.
        ^ self.
    ].

    self withErrorStreamDo:[:s | self printOn:s. s cr].

    "
     'hello' errorPrintCR
    "

    "Created: / 20-05-1996 / 10:20:41 / cg"
    "Modified: / 21-04-2011 / 12:47:13 / cg"
!

errorPrintNL
    "{ Pragma: +optSpace }"
    <resource:#obsolete>

    "print the receiver followed by a cr on the standard error stream.
     Please use #errorPrintCR - this method exists for backward compatibility."

    ^ self errorPrintCR

    "Modified: 20.5.1996 / 10:24:45 / cg"
!

errorPrintNewline
    "{ Pragma: +optSpace }"
    <resource:#obsolete>

    "print the receiver followed by a cr on the standard error stream.
     Please use #errorPrintCR - this method exists for backward compatibility."

    self errorPrintCR.

    "Modified: 20.5.1996 / 10:24:38 / cg"
!

infoPrint
    "{ Pragma: +optSpace }"

    "if a logger has been defined, let it print the receiver when a CR is coming.
     otherwise print the receiver on the standard error stream.
     This is meant for information messages which are not warnings or fatal messages.
     These messages can be turned on/off by 'Object infoPrinting:true/false'"

    Logger notNil ifTrue:[
        PartialInfoPrintLine := (PartialInfoPrintLine ? ''), self printString string.
        ^ self.
    ].
    
    InfoPrinting == true ifTrue:[
        self errorPrint
    ]

    "
     'hello' infoPrint. ' world' infoPrintCR.
     'foo [info] hello' infoPrintCR.
    "
!

infoPrintCR
    "{ Pragma: +optSpace }"

    "if a logger has been defined, let it print the receiver.
     otherwise print the receiver followed by a cr on the standard error stream.
     This is meant for information messages which are not warnings or fatal messages.
     These messages can be turned on/off by 'Object infoPrinting:true/false'"

    Logger notNil ifTrue:[
        |fullLine|
        fullLine := (PartialInfoPrintLine ? ''), self printString string.
        PartialInfoPrintLine := nil.
        Logger info:fullLine.
        ^ self.
    ].
    InfoPrinting == true ifTrue:[
        self errorPrintCR
    ]

    "Created: 20.5.1996 / 10:21:28 / cg"
!

infoPrintNL
    "{ Pragma: +optSpace }"
    <resource:#obsolete>

    "print the receiver followed by a cr on the standard error stream.
     Please use #infoPrintCR - this method exists for backward compatibility."

    ^ self infoPrintCR
!

print
    "print the receiver on the standard output stream (which is not the Transcript)"

    "/ the following allows print/printCR to be used during
    "/ the early init-phase, when no Stdout has been set up.
    "/ (depends on String to respond to #print, without recurring back to here)

    Stdout isNil ifTrue:[
        self printString utf8Encoded print.
        ^ self
    ].
    self printOn:Processor activeProcess stdout

    "Modified: 4.11.1996 / 23:36:58 / cg"
!

printCR
    "print the receiver followed by a cr on the standard output stream (which is not the Transcript)"

    "/ the following allows printCR to be used during
    "/ the early init-phase, when no Stdout has been set up.
    "/ (depends on string to respond to #printCR)

    |stdout|

    Stdout isNil ifTrue:[
        self printString utf8Encoded printCR.
        ^ self
    ].
    stdout := Processor activeProcess stdout.
    self printOn:stdout.
    stdout cr

    "Created: 20.5.1996 / 10:21:37 / cg"
    "Modified: 4.11.1996 / 23:37:06 / cg"
!

printNL
    "print the receiver followed by a cr on the standard output stream
     This exists for GNU Smalltalk compatibility - please use #printCR."

    <resource:#obsolete>

    ^ self printCR

    "Modified: 20.5.1996 / 10:25:31 / cg"
!

printNewline
    "print the receiver followed by a cr on the standard output stream.
     This exists for backward compatibility - please use #printCR."

    <resource:#obsolete>

    self printCR

    "Modified: 20.5.1996 / 10:25:46 / cg"
!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back.

     The default here is to output the receiver's class name.
     BUT: this method is heavily redefined for objects which
     can print prettier."

    self basicPrintOn:aStream.

   "
    (1@2) printOn:Transcript
    (1@2) basicPrintOn:Transcript
   "
!

printOn:aStream format:format
    "this may be redefined in subclasses.
     Defined here for compatibility with subclasses"

    self printOn:aStream.
!

printOn:aStream leftPaddedTo:size
    "print the receiver on aStream, padding with spaces up to size.
     padding is done on the left."

    self printOn:aStream leftPaddedTo:size with:(Character space)

    "
     123 printOn:Transcript leftPaddedTo:10. Transcript cr
     123 printOn:Transcript leftPaddedTo:2. Transcript cr
    "
!

printOn:aStream leftPaddedTo:size with:padCharacter
    "print the receiver on aStream, padding with padCharacters up to size.
     padding is done on the left."

    aStream nextPutAll:(self printStringLeftPaddedTo:size with:padCharacter)

    "
     123 printOn:Transcript leftPaddedTo:10 with:$_ . Transcript cr
     123 printOn:Transcript leftPaddedTo:10 with:$. . Transcript cr
    "
!

printOn:aStream paddedTo:size
    "print the receiver on aStream, padding with spaces up to size."

    self printOn:aStream paddedTo:size with:(Character space)

    "
     123.0 printOn:Transcript paddedTo:10. Transcript nextPut:$|. Transcript cr
    "
!

printOn:aStream paddedTo:size with:padCharacter
    "print the receiver on aStream, padding with padCharacter up to size"

    aStream nextPutAll:(self printStringPaddedTo:size with:padCharacter).

    "
     123 printOn:Transcript paddedTo:10 with:$_ . Transcript cr
     123 printOn:Transcript paddedTo:10 with:$. . Transcript cr
    "
!

printOn:aStream zeroPaddedTo:size
    "print the receiver on aStream, padding with zeros up to size.
     Usually used with float numbers."

    self printOn:aStream paddedTo:size with:$0.

    "
     123.0 printOn:Transcript zeroPaddedTo:10
    "
!

printRightAdjustLen:size
    <resource: #obsolete>
    "obsolete - just a name confusion.
     This method will go away ..."

    (self printStringLeftPaddedTo:size) print
!

printString
    "return a string for printing the receiver.
     Since we now use printOn: as the basic print mechanism,
     we have to create a stream and print into it."

    |s|

    "allocate at least 40 bytes for fast UUID conversion.
     cg: who did that? If that's a bottleneck, it ought to be done in UUID, not here!!"

    s := CharacterWriteStream on:(String basicNew:40).
    self printOn:s.
    ^ s contents.

    "
     Date today printString.
    "
!

printStringFormat:orintFormat
    "subclasses may redefine this.
     Defined here to avoid type checks"

    ^ self printString
!

printStringLeftPaddedTo:size
    "return my printString as a right-adjusted string of length size;
     characters on the left are filled with spaces.
     If the printString is longer than size,
     it is returned unchanged (i.e. not truncated)"

    ^ self printStringLeftPaddedTo:size with:(Character space)

    "
     10 printStringLeftPaddedTo:10
     1 printStringLeftPaddedTo:10
    "
!

printStringLeftPaddedTo:size ifLarger:alternative
    "return my printString as a right-adjusted string of length size;
     characters on the left are filled with spaces.
     If the printString is larger than size,
     return the result from evaluating alternative."

    ^ self printStringLeftPaddedTo:size with:(Character space) ifLarger:alternative

    "
     12   printStringLeftPaddedTo:3 ifLarger:['***']
     123  printStringLeftPaddedTo:3 ifLarger:['***']
     1234 printStringLeftPaddedTo:3 ifLarger:['***']
    "
!

printStringLeftPaddedTo:size with:padCharacter
    "return my printString as a right-adjusted string of length size;
     characters on the left are filled with padCharacter.
     If the printString is longer than size,
     it is returned unchanged (i.e. not truncated)"

    ^ (self printString) leftPaddedTo:size with:padCharacter

    "
     123 printStringLeftPaddedTo:10 with:$.
     1 printStringLeftPaddedTo:10 with:$.
     (Float pi) printStringLeftPaddedTo:20 with:$*
    "
!

printStringLeftPaddedTo:size with:padCharacter ifLarger:alternative
    "return my printString as a right-adjusted string of length size;
     characters on the left are filled with padCharacter.
     If the printString is larger than size,
     return the result from evaluating alternative."

    |s|

    s := self printString.
    s size > size ifTrue:[^ alternative value].
    ^ s leftPaddedTo:size with:padCharacter

    "
     12   printStringLeftPaddedTo:3 with:$. ifLarger:['***']
     123  printStringLeftPaddedTo:3 with:$. ifLarger:['***']
     1234 printStringLeftPaddedTo:3 with:$. ifLarger:['***']
    "
!

printStringLimitedTo:sizeLimit
    "return a string for printing the receiver, but limit the result string in its size."

    |s|

    s := CharacterWriteStream on:(String basicNew:30).
    s writeLimit:sizeLimit.
    self printOn:s.
    ^ s contents.

    "
     Date today printStringLimitedTo:5.
     '12345678901234567890' printStringLimitedTo:5.
    "
!

printStringOnError:exceptionBlock
    "return a string for printing the receiver; if any error occurs, return the result from
     evaluating exceptionBlock. Useful to print something in an exceptionHandler or other
     cleanup code."

    |rslt|

    Error handle:[:ex |
        rslt := exceptionBlock value
    ] do:[
        rslt := self printString
    ].
    ^ rslt
!

printStringPaddedTo:size
    "return a printed representation of the receiver,
     padded with spaces (at the right) up to size.
     If the printString is longer than size,
     it is returned unchanged (i.e. not truncated)"

    ^ self printStringPaddedTo:size with:(Character space)

    "
     123 printStringPaddedTo:10
     1234567890123456 printStringPaddedTo:10
     'hello' printStringPaddedTo:10
    "
!

printStringPaddedTo:size ifLarger:alternative
    "return a printed representation of the receiver,
     padded with spaces (at the right) up to size.
     If the resulting printString is too large,
     return the result from evaluating alternative."

    ^ self printStringPaddedTo:size with:(Character space) ifLarger:alternative

    "
     12   printStringPaddedTo:3 ifLarger:['***']
     123  printStringPaddedTo:3 ifLarger:['***']
     1234 printStringPaddedTo:3 ifLarger:['***']
    "
!

printStringPaddedTo:size with:padCharacter
    "return a printed representation of the receiver,
     padded with padCharacter (at the right) up to size.
     If the printString is longer than size,
     it is returned unchanged (i.e. not truncated)"

    ^ (self printString) paddedTo:size with:padCharacter

    "
     123  printStringPaddedTo:10 with:$.
     123  printStringPaddedTo:10 with:$*
     123  printStringPaddedTo:3 with:$*
     1234 printStringPaddedTo:3 with:$*
    "
!

printStringPaddedTo:size with:padCharacter ifLarger:alternative
    "return a printed representation of the receiver,
     padded with padCharacter (at the right) up to size.
     If the resulting printString is too large,
     return the result from evaluating alternative."

    |s|

    s := self printString.
    s size > size ifTrue:[^ alternative value].
    ^ s paddedTo:size with:padCharacter

    "
     123   printStringPaddedTo:3 with:$. ifLarger:['***']
     12345 printStringPaddedTo:3 with:$. ifLarger:['***']
    "
!

printStringRightAdjustLen:size
    "obsolete - just a name confusion.
     This method will go away ..."
    <resource: #obsolete>

    ^ self printStringLeftPaddedTo:size
!

printStringZeroPaddedTo:size
    "return a printed representation of the receiver,
     padded with zero (at the right) characters up to size.
     Usually used with float numbers."

    ^ self printStringPaddedTo:size with:$0

    "
     123.0 printStringZeroPaddedTo:10
    "
!

printfPrintString:ignoredFormat
    "fallback to default printString
     (for compatibility with float and integer-printing)"

    ^ self printString
!

store
    "store the receiver on standard output.
     this method is useless, but included for compatibility."

    self storeOn:Processor activeProcess stdout
!

storeArrayElementOn:aStream
    "store an object as an Array element.
     Subclasses may redefine this to omit a leading '#'"

    ^ self storeOn:aStream
!

storeCR
    "store the receiver on standard output; append a carriage return."

    |stdout|

    stdout := Processor activeProcess stdout.
    self storeOn:stdout.
    stdout cr.

    "Created: 20.5.1996 / 10:26:01 / cg"
    "Modified: 20.5.1996 / 10:26:57 / cg"
!

storeNl
    "store the receiver on standard output; append a newline.
     This method is included for backward compatibility-  use #storeCR."

    <resource:#obsolete>

    self storeCR.

    "Modified: 20.5.1996 / 10:26:49 / cg"
!

storeOn:aStream
    "store the receiver on aStream; i.e. print an expression which will
     reconstruct the receiver.
     Notice, that no self referencing or cyclic objects can be represented
     in this format.
     Use storeBinaryOn:, which handles these cases correctly."

    |myClass hasSemi sz "{ Class: SmallInteger }" |

    thisContext isRecursive ifTrue:[
        RecursiveStoreError raiseRequestWith:self.
        'Object [error]: storeString of self referencing object (' errorPrint.
        self class name errorPrint.
        ')' errorPrintCR.
        aStream nextPutAll:'#("recursive")'.
        ^ self
    ].

    myClass := self class.
    aStream nextPut:$(.
    aStream nextPutAll:self class name.

    hasSemi := false.
    myClass isVariable ifTrue:[
        aStream nextPutAll:' basicNew:'.
        self basicSize printOn:aStream
    ] ifFalse:[
        aStream nextPutAll:' basicNew'
    ].

    sz := myClass instSize.
    1 to:sz do:[:i |
        |ref|

        ref := (self instVarAt:i).
        "/ no need to store nil entries, because the object has been instantiated
        "/ with basicNew just a moment ago (so the fields are already nil)
        ref notNil ifTrue:[
            aStream nextPutAll:' instVarAt:'.
            i printOn:aStream.
            aStream nextPutAll:' put:'.
            ref storeOn:aStream.
            aStream nextPut:$;.
            hasSemi := true
        ].
    ].
    myClass isVariable ifTrue:[
        sz := self basicSize.
        1 to:sz do:[:i |
            |ref|

            ref := (self basicAt:i).
            "/ no need to store nil entries, because the object has been instantiated
            "/ with basicNew just a moment ago (so the fields are already nil)
            ref notNil ifTrue:[
                aStream nextPutAll:' basicAt:'.
                i printOn:aStream.
                aStream nextPutAll:' put:'.
                ref storeOn:aStream.
                aStream nextPut:$;.
                hasSemi := true
            ]
        ]
    ].
    hasSemi ifTrue:[
        aStream nextPutAll:' yourself'
    ].
    aStream nextPut:$).

    "
     |s|

     s := WriteStream on:(String new).
     ('hello' -> 'world') storeOn:s.
     s := ReadStream on:(s contents).
     (Object readFrom:s) inspect
    "
    "
     |s|

     s := 'data' asFilename writeStream.
     ('hello' -> 'world') storeOn:s.
     s close.

     s := 'data' asFilename readStream.
     (Object readFrom:s) inspect
    "

    "does not work example (cyclic):"
    "
     |s a|

     a := Array new:2.
     a at:1 put:a.

     s := 'data' asFilename writeStream.
     a storeOn:s.
     s close.

     s := 'data' asFilename readStream.
     (Object readFrom:s) inspect
    "

    "Modified: / 03-12-2010 / 13:27:51 / cg"
!

storeString
    "return a string representing an expression to reconstruct the receiver.
     Notice, that no self referencing or cyclic objects can be represented
     in this format.
     Use storeBinaryOn:, which handles these cases correctly."

    |s|

    s := WriteStream on:(String new:50).
    self storeOn:s.
    ^ s contents
!

withErrorStreamDo:aBlock
    "{ Pragma: +optSpace }"

    "helper for error messages - evaluate aBlock,
     passing it a stream on which to put error messages.
     Notice that the block might be called twice,
     to print both on stderr and onto the Transcript"

    |stream stderr activeProcess|

    activeProcess := Processor activeProcess.
    stderr := activeProcess stderr.

    "CG: care for standalone non-GUI progs, which have no userPreferences class"
    (Smalltalk isInitialized
    and:[ UserPreferences notNil
    and:[ UserPreferences current sendMessagesAlsoToTranscript]]) ifTrue:[
        stream := activeProcess isSystemProcess
                            ifTrue:[stderr]
                            ifFalse:[activeProcess transcript].
    ].
    stream notNil ifTrue:[
        StreamError catch:[
            aBlock value:stream.
        ].
    ].
    stream ~~ stderr ifTrue:[
        UserPreferences current sendMessagesOnlyToTranscript ifFalse:[
            aBlock value:stderr.
        ].
    ].

    "Created: / 21-04-2011 / 12:46:21 / cg"
! !

!Object methodsFor:'queries'!

basicSize
    "return the number of the receiver's indexed instance variables,
     0 if it has none.

     This method should NOT be redefined in any subclass (except with great care, for tuning)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( self.basicSize() ) );
#else
    REGISTER INT nBytes;
    REGISTER OBJ myClass;
    int nInstBytes;

    /*
     * notice the missing test for self being a nonNilObject -
     * this can be done since basicSize is defined both in UndefinedObject
     * and SmallInteger
     */
    myClass = __qClass(self);
    nBytes = __qSize(self);
    nInstBytes = OHDR_SIZE + __OBJS2BYTES__( __intVal(__ClassInstPtr(myClass)->c_ninstvars) );

    switch ((INT)(__ClassInstPtr(myClass)->c_flags) & __MASKSMALLINT(ARRAYMASK)) {
        case __MASKSMALLINT(POINTERARRAY):
        case __MASKSMALLINT(WKPOINTERARRAY):
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(__BYTES2OBJS__(nBytes)) );

        case __MASKSMALLINT(BYTEARRAY):
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes / sizeof(char)) );

        case __MASKSMALLINT(FLOATARRAY):
# ifdef __NEED_FLOATARRAY_ALIGN
            nInstBytes = (nInstBytes-1+__FLOATARRAY_ALIGN) &~ (__FLOATARRAY_ALIGN-1);
# endif
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes / sizeof(float)) );

        case __MASKSMALLINT(DOUBLEARRAY):
# ifdef __NEED_DOUBLE_ALIGN
            nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
# endif
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes / sizeof(double)) );

        case __MASKSMALLINT(WORDARRAY):
        case __MASKSMALLINT(SWORDARRAY):
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes>>1) ); /* notice the hardcoded 2 here - not sizeof(short) */

        case __MASKSMALLINT(LONGARRAY):
        case __MASKSMALLINT(SLONGARRAY):
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes>>2) ); /* notice the hardcoded 4 here - not sizeof(int) */

        case __MASKSMALLINT(LONGLONGARRAY):
        case __MASKSMALLINT(SLONGLONGARRAY):
# ifdef __NEED_LONGLONG_ALIGN
            nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
# endif
            nBytes -= nInstBytes;
            RETURN ( __mkSmallInteger(nBytes>>3) ); /* notice the hardcoded 8 here - not sizeof(long long) */
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ 0
!

byteSize
    "return the number of bytes in the receiver's indexed instance variables,
     0 if it has none. This only returns non-zero for non-pointer indexed
     instvars i.e. byteArrays, wordArrays etc.
     Notice: for Strings the returned size may look strange.
     Only useful with binary storage."

    |myClass|

    myClass := self class.
    myClass isVariable ifTrue:[
        myClass isPointers ifFalse:[
            myClass isBytes ifTrue:[
                ^ self basicSize.
            ].
            myClass isWords ifTrue:[
                ^ self basicSize * 2.
            ].
            myClass isSignedWords ifTrue:[
                ^ self basicSize * 2.
            ].
            myClass isLongs ifTrue:[
                ^ self basicSize * 4.
            ].
            myClass isSignedLongs ifTrue:[
                ^ self basicSize * 4.
            ].
            myClass isLongLongs ifTrue:[
                ^ self basicSize * 8.
            ].
            myClass isSignedLongLongs ifTrue:[
                ^ self basicSize * 8.
            ].
            myClass isFloats ifTrue:[
                ^ self basicSize * (ExternalBytes sizeofFloat)
            ].
            myClass isDoubles ifTrue:[
                ^ self basicSize * (ExternalBytes sizeofDouble)
            ].
            self error:'unknown variable size class species'.
        ]
    ].
    ^ 0

    "
     Point new byteSize
     'hello' byteSize
     'hello' asUnicode16String byteSize
     (ByteArray with:1 with:2) byteSize
     (FloatArray with:1.5) byteSize
     (DoubleArray with:1.5) byteSize
     (WordArray with:1 with:2) byteSize
    "
!

class
    "return the receiver's class"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN(self.clazz());
#else
    RETURN ( __Class(self) );
#endif
%}

    "Modified (comment): / 30-04-2016 / 15:51:17 / cg"
!

respondsTo:aSelector
    "return true if the receiver implements a method with selector equal
     to aSelector; i.e. if there is a method for aSelector in either the
     receiver's class or one of its superclasses.

     Notice, that this does not imply, that such a message can be sent without
     an error being raised. For example, an implementation could send
     #shouldNotImplement or #subclassResponsibility."

    "
     should we go via the cache, or search (by class) ?
     The first is faster, most of the time; while the 2nd fills
     the cache with useless data if this is sent in a loop over all objects.
     For now, use the cache ...
    "
%{  /* NOCONTEXT */

    if (__lookup(__Class(self), aSelector) == nil) {
        RETURN ( false );
    }
    RETURN ( true );
%}
.
    ^ self class canUnderstand:aSelector


    "'aString' respondsTo:#+"
    "'aString' respondsTo:#,"
    "'aString' respondsTo:#collect:"
!

respondsToArithmetic
    "return true if the receiver responds to arithmetic messages.
     false is returned here - the method is redefined in ArithmeticValue."

    ^ false
!

size
    "return the number of the receiver's indexed instance variables;
     this method may be redefined in subclasses"

    ^ self basicSize
!

species
    "return a class which is similar to (or the same as) the receiver's class.
     This is used to create an appropriate object when creating derived
     copies in the collection classes (sometimes redefined)."

    ^ self class
!

speciesForCopy
    "return a class which is the receiver's class, except for readonly objects,
     such as immutable collections.
     This is only to be used by copy methods"

    ^ self class
!

yourself
    "return the receiver - used for cascades to return self at the end"

    ^ self
! !


!Object methodsFor:'secure message sending'!

?:selector
    "try to send a message to the receiver;
     if understood, return the value;
     if not, return nil."

    ^ self perform:selector ifNotUnderstood:nil

    "
     ApplicationModel new masterApplication resources first             - error
     ApplicationModel new ?: #masterApplication ?: #resources ?: #first - nil
    "
    "Modified: / 20-10-2010 / 10:45:21 / cg"
!

askFor:aSelector
    "try to send the receiver the message, aSelector.
     If it does not understand it, return false.
     Otherwise the real value returned.
     Useful to send messages such as: #isColor to unknown receivers."

    ^ self perform:aSelector ifNotUnderstood:[false]

    "
     1 askFor:#isColor
     Color red askFor:#isColor

     1 askFor:#isFoo
     Color red askFor:#isFoo
    "
!

askFor:aSelector with:argument
    "try to send the receiver the message, aSelector.
     If it does not understand it, return false.
     Otherwise the real value returned.
     Useful to send messages such as: #isXXX: to unknown receivers."

    ^ self perform:aSelector with:argument ifNotUnderstood:[false]
!

askFor:aSelector with:arg1 with:arg2
    "try to send the receiver the message, aSelector.
     If it does not understand it, return false.
     Otherwise the real value returned.
     Useful to send messages such as: #isXXX: to unknown receivers."

    ^ self perform:aSelector with:arg1 with:arg2 ifNotUnderstood:[false]
!

perform:aSelector ifNotUnderstood:exceptionBlock
    "try to send message aSelector to the receiver.
     If its understood, return the method's returned value,
     otherwise return the value of the exceptionBlock.
     Read this:
     Many programmers do an Error-handle to perform a similar
     checked-message send. However, this method is more specific,
     in that only errors for the given selector are caught - not any other
     doesNotUnderstand, and especially not any other error."

    |val ok|

    MessageNotUnderstood handle:[:ex |
        "/ reject, if the bad message is not the one
        "/ we have sent originally
        (ex selector == aSelector and:[ex receiver == self]) ifFalse:[
            ex reject
        ].
    ] do:[
        val := self perform:aSelector.
        ok := true.
    ].
    ok isNil ifTrue:[
        ^ exceptionBlock value
    ].
    ^ val

    "
     1.2345 perform:#foo ifNotUnderstood:['sorry']
     1.2345 perform:#sqrt ifNotUnderstood:['sorry']
     12345 perform:#sqrt ifNotUnderstood:['sorry']
    "
!

perform:aSelector with:argument ifNotUnderstood:exceptionBlock
    "try to send message aSelector to the receiver.
     If its understood, return the method's returned value,
     otherwise return the value of the exceptionBlock.
     Read this:
     Many programmers do an Error-handle to perform a similar
     checked-message send. However, this method is more specific,
     in that only errors for the given selector are caught - not any other
     doesNotUnderstand, and especially not any other error."

    |val ok|

    MessageNotUnderstood handle:[:ex |
        "/ reject, if the bad message is not the one
        "/ we have sent originally
        (ex selector == aSelector and:[ex receiver == self]) ifFalse:[
            ex reject
        ]
    ] do:[
        val := self perform:aSelector with:argument.
        ok := true.
    ].
    ok isNil ifTrue:[
        ^ exceptionBlock value
    ].
    ^ val

    "
     |unknown|

     unknown := 4.
     (unknown perform:#- with:2 ifNotUnderstood:['sorry']) printNewline.
     unknown := 'high there'.
     (unknown perform:#- with:2 ifNotUnderstood:['sorry']) printNewline.
    "
!

perform:aSelector with:arg1 with:arg2 ifNotUnderstood:exceptionBlock
    "try to send message aSelector to the receiver.
     If its understood, return the method's returned value,
     otherwise return the value of the exceptionBlock.
     Read this:
     Many programmers do an Error-handle to perform a similar
     checked-message send. However, this method is more specific,
     in that only errors for the given selector are caught - not any other
     doesNotUnderstand, and especially not any other error."

    |val ok|

    MessageNotUnderstood handle:[:ex |
        "/ reject, if the bad message is not the one
        "/ we have sent originally
        (ex selector == aSelector and:[ex receiver == self]) ifFalse:[
            ex reject
        ]
    ] do:[
        val := self perform:aSelector with:arg1 with:arg2.
        ok := true.
    ].
    ok isNil ifTrue:[
        ^ exceptionBlock value
    ].
    ^ val
!

perform:aSelector withArguments:argumentArray ifNotUnderstood:exceptionBlock
    "try to send message aSelector to the receiver.
     If its understood, return the method's returned value,
     otherwise return the value of the exceptionBlock.
     Read this:
     Many programmers do an Error-handle to perform a similar
     checked-message send. However, this method is more specific,
     in that only errors for the given selector are caught - not any other
     doesNotUnderstand, and especially not any other error."

    |val ok|

    MessageNotUnderstood handle:[:ex |
        "/ reject, if the bad message is not the one
        "/ we have sent originally.
        (ex selector == aSelector and:[ex receiver == self]) ifFalse:[
            ex reject
        ]
    ] do:[
        val := self perform:aSelector withArguments:argumentArray.
        ok := true.
    ].
    ok isNil ifTrue:[
        ^ exceptionBlock value
    ].
    ^ val

    "
     |unknown|

     unknown := 4.
     (unknown perform:#- withArguments:#(2) ifNotUnderstood:['sorry']) printNewline.
     unknown := 'high there'.
     (unknown perform:#- withArguments:#(2) ifNotUnderstood:['sorry']) printNewline.
    "

    "Modified: 27.3.1997 / 14:13:16 / cg"
! !

!Object methodsFor:'signal constants'!

messageNotUnderstoodSignal
    ^ MessageNotUnderstood

    "Created: 6.3.1997 / 15:46:52 / cg"
! !

!Object methodsFor:'special queries'!

allOwners
    "return a collection of all objects referencing the receiver"

    ^ ObjectMemory whoReferences:self
!

references:anObject
    "return true if the receiver refers to the argument, anObject.
     - for debugging only"

    ^ self referencesObject:anObject

    "
     |v|

     v := View new initialize.
     v references:Display.
    "
!

referencesAny:aCollection
    "return true if the receiver refers to any object from
     the argument, aCollection.
     - for debugging only"

%{
    OBJ cls, flags;
    int nInsts, inst;

    if (! __isNonNilObject(self)) {
        RETURN (false);
    }

    if (__isArrayLike(aCollection)) {
        int nObjs = __arraySize(aCollection);
        char *minAddr = 0, *maxAddr = 0;

        if (nObjs == 0) {
            RETURN (false);
        }

        cls = __qClass(self);
        flags = __ClassInstPtr(cls)->c_flags;
        if (((INT)flags & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(POINTERARRAY)) {
            nInsts = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
        } else {
            nInsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
        }

        if (nObjs == 1) {
            /* better reverse the loop */
            OBJ anObject = __arrayVal(aCollection)[0];

            if (anObject == cls) {
                RETURN(true);
            }
            if (! nInsts) {
                RETURN (false);
            }

            if ((__qSpace(self) <= OLDSPACE)
                    && !__isRemembered(self)
                    && __isNonNilObject(anObject)) {
                int spc = __qSpace(anObject);

                if ((spc == NEWSPACE) || (spc == SURVSPACE)) {
                    RETURN(false);
                }
            }

# if defined(memsrch4)
            if (memsrch4(__InstPtr(self)->i_instvars, (INT)anObject, nInsts)) {
                RETURN (true);
            }
# else
            for (inst=0; inst<nInsts; inst++) {
                if ((__InstPtr(self)->i_instvars[inst]) == anObject) {
                    RETURN (true);
                }
            }
# endif
            RETURN (false);
        }

        /*
         * a little optimization: use the fact that all old objects
         * refering to a new object are on the remSet; if I am not,
         * a trivial reject is possible, if all objects are newbees.
         * as a side effect, gather min/max addresses
         */
        if ((__qSpace(self) <= OLDSPACE) && !__isRemembered(self)) {
            int allNewBees = 1;
            int i;

            minAddr = (char *)(__arrayVal(aCollection)[0]);
            maxAddr = minAddr;

            for (i=0; i<nObjs; i++) {
                OBJ anObject = __arrayVal(aCollection)[i];

                if (__isNonNilObject(anObject)) {
                    int spc = __qSpace(anObject);

                    if ((spc != NEWSPACE) && (spc != SURVSPACE)) {
                        allNewBees = 0;
                    }
                }

                if ((char *)anObject < minAddr) {
                    minAddr = (char *)anObject;
                } else if ((char *)anObject > maxAddr) {
                    maxAddr = (char *)anObject;
                }
            }
            if (allNewBees) {
                RETURN (false);
            }
        }

        /*
         * fetch min/max in searchList (if not already done above)
         */
        if (minAddr == 0) {
            int i;

            for (i=0; i<nObjs; i++) {
                char  *anObject = (char *)__arrayVal(aCollection)[i];

                if (anObject < minAddr) {
                    minAddr = anObject;
                } else if (anObject > maxAddr) {
                    maxAddr = anObject;
                }
            }
        }

        if (((char *)cls >= minAddr) && ((char *)cls <= maxAddr)) {
# if defined(memsrch4)
            if (memsrch4(__arrayVal(aCollection), (INT)cls, nObjs)) {
                RETURN (true);
            }
# else
            int i;

            for (i=0; i<nObjs; i++) {
                if (cls == __arrayVal(aCollection)[i]) {
                    RETURN (true);
                }
            }
# endif /* memsrch4 */
        }

        for (inst=0; inst<nInsts; inst++) {
            OBJ instVar = __InstPtr(self)->i_instvars[inst];
            int i;

            if (((char *)instVar >= minAddr) && ((char *)instVar <= maxAddr)) {
# if defined(memsrch4)
                if (memsrch4(__arrayVal(aCollection), (INT)instVar, nObjs)) {
                    RETURN (true);
                }
# else
                for (i=0; i<nObjs; i++) {
                    if (instVar == __arrayVal(aCollection)[i]) {
                        RETURN (true);
                    }
                }
# endif /* memsrch4 */
            }
        }
        RETURN (false);
    }
%}.

    aCollection do:[:el |
        (self referencesObject:el) ifTrue:[^ true].
    ].
    ^ false
!

referencesDerivedInstanceOf:aClass
    "return true if the receiver refers to an instance of
     the argument, aClass or its subclass. This method exists
     to support searching for users of a class."

    |myClass
     numInst "{ Class: SmallInteger }" |

    "check the class"
    (self isKindOf:aClass) ifTrue:[^ true].

    myClass := self class.
    "check the instance variables"
    numInst := myClass instSize.
    1 to:numInst do:[:i |
        ((self instVarAt:i) isKindOf:aClass) ifTrue:[^ true]
    ].

    "check the indexed variables"
    myClass isVariable ifTrue:[
        myClass isPointers ifFalse:[
            "no need to search in non pointer fields"
            ((aClass == Number) or:[aClass isSubclassOf:Number]) ifFalse:[^ false].
        ].
        numInst := self basicSize.
        1 to:numInst do:[:i |
            ((self basicAt:i) isKindOf:aClass) ifTrue:[^ true]
        ]
    ].
    ^ false

    "
     (1 @ 3.4) referencesDerivedInstanceOf:Number
     (1 @ 3.4) referencesDerivedInstanceOf:Array
     View new initialize referencesDerivedInstanceOf:DeviceWorkstation
    "
!

referencesForWhich:checkBlock do:actionBlock
    |myClass inst
     numInst "{ Class: SmallInteger }" |

    myClass := self class.
    "check the instance variables"
    numInst := myClass instSize.
    1 to:numInst do:[:i |
        inst := self instVarAt:i.
        (checkBlock value:inst) ifTrue:[actionBlock value:inst].
    ].

    "check the indexed variables"
    myClass isVariable ifTrue:[
        myClass isPointers ifTrue:[
            "no need to search in non pointer fields"

            numInst := self basicSize.
            1 to:numInst do:[:i |
                inst := self basicAt:i.
                (checkBlock value:inst) ifTrue:[actionBlock value:inst].
            ]
        ]
    ].

    "
     (1 @ 3.4) referencesForWhich:[:i | i isFloat] do:[:i | Transcript showCR:i]
    "
!

referencesInstanceOf:aClass
    "return true if the receiver refers to an instance of
     the argument, aClass.This method exists
     to support searching for users of a class."

    |myClass
     numInst "{ Class: SmallInteger }" |

    myClass := self class.

    "check the class"
    (myClass isMemberOf:aClass) ifTrue:[^ true].

    "check the instance variables"
    numInst := myClass instSize.
    1 to:numInst do:[:i |
        ((self instVarAt:i) isMemberOf:aClass) ifTrue:[^ true]
    ].

    "check the indexed variables"
    myClass isVariable ifTrue:[
        myClass isPointers ifFalse:[
            "no need to search in non-pointer indexed fields"
            myClass isLongs ifTrue:[
                (aClass == SmallInteger or:[aClass == LargeInteger]) ifFalse:[^ false].
            ] ifFalse:[
                myClass isFloatsOrDoubles ifTrue:[^ aClass == Float].
                ^ aClass == SmallInteger
            ]
        ].
        numInst := self basicSize.
        1 to:numInst do:[:i |
            ((self basicAt:i) isMemberOf:aClass) ifTrue:[^ true]
        ]
    ].
    ^ false

    "
     (1 @ 3.4) referencesInstanceOf:Float
     (1 @ 3.4) referencesInstanceOf:Fraction
     View new initialize referencesInstanceOf:(Display class)
    "
!

referencesObject:anObject
    "return true if the receiver refers to the argument, anObject.
     - for debugging only"

%{  /* NOCONTEXT */
    OBJ cls, flags;
    int nInsts, i;

    if (! __isNonNilObject(self)) {
        RETURN (false);
    }
    cls = __qClass(self);
    if (cls == anObject) {
        RETURN (true);
    }
    flags = __ClassInstPtr(cls)->c_flags;
    if (((INT)flags & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(POINTERARRAY)) {
        nInsts = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    } else {
        nInsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
    }
    if (! nInsts) {
        RETURN (false);
    }


    /*
     * a little optimization: use the fact that all old objects
     * refering to a new object are on the remSet; if I am not,
     * a trivial reject is possible, if anObject is a newbee
     */
    if (__isNonNilObject(anObject)) {
        if ((__qSpace(self) <= OLDSPACE) && !__isRemembered(self)) {
            int spc;

            if (((spc = __qSpace(anObject)) == NEWSPACE) || (spc == SURVSPACE)) {
                RETURN (false);
            }
        }
    }

# if defined(memsrch4)
    if (memsrch4(__InstPtr(self)->i_instvars, (INT)anObject, nInsts)) {
        RETURN (true);
    }
# else
    for (i=0; i<nInsts; i++) {
        if (__InstPtr(self)->i_instvars[i] == anObject) {
            RETURN (true);
        }
    }
# endif /* memsrch4 */

%}.

"/    |myClass
"/     numInst "{ Class: SmallInteger }" |
"/
"/    myClass := self class.
"/
"/    "check the class"
"/    (myClass == anObject) ifTrue:[^ true].
"/
"/    "check the instance variables"
"/    numInst := myClass instSize.
"/    1 to:numInst do:[:i |
"/      ((self instVarAt:i) == anObject) ifTrue:[^ true]
"/    ].
"/
"/    "check the indexed variables"
"/    myClass isVariable ifTrue:[
"/      myClass isPointers ifFalse:[
"/          "/
"/          "/ we could argue about the following unconditional return:
"/          "/ it says that a non pointer array never has a reference to the
"/          "/ corresponding object - not mimicing a reference to a copy of the
"/          "/ integer. However, it avoids useless searches in huge byteArray
"/          "/ like objects when searching for owners. If in doubt, remove it.
"/          "/ A consequence of the return below is that #[1 2 3] will say that it
"/          "/ does not refer to the number 2 (think of keeping a copy instead)
"/
"/          ^ false.
"/
"/          "/ alternative:
"/          "/  anObject isNumber ifFalse:[^ false].
"/      ].
"/
"/      "/
"/      "/ because arrays are so common, and those have a highly tuned
"/      "/ idenitytIndex method, use it
"/      "/
"/      myClass == Array ifTrue:[
"/          ^ (self identityIndexOf:anObject) ~~ 0
"/      ].
"/
"/      "/
"/      "/ otherwise, do it the slow way
"/      "/
"/      numInst := self basicSize.
"/      1 to:numInst do:[:i |
"/          ((self basicAt:i) == anObject) ifTrue:[^ true]
"/      ]
"/    ].

    ^ false

    "
     |v|

     v := View new initialize.
     v references:Display.
    "
! !


!Object methodsFor:'synchronized evaluation'!

freeSynchronizationSemaphore
    "free synchronizationSemaphore. May be used, to save memory when
     an object is no longer used synchronized."

    |sema|

    sema := self synchronizationSemaphore.
    sema notNil ifTrue:[
        sema wait.              "/ get lock
        self synchronizationSemaphore:nil.
    ].

    "
     self synchronized:[].
     self synchronizationSemaphore.
     self freeSynchronizationSemaphore.
    "

    "Created: 28.1.1997 / 19:31:20 / stefan"
    "Modified: 28.1.1997 / 19:47:55 / stefan"
!

synchronizationSemaphore
    "return the synchronization semaphore for myself.
     subclasses may redefine"

    ^ SynchronizationSemaphores at:self ifAbsent:[].

    "
      self synchronizationSemaphore
    "

    "Modified: 28.1.1997 / 19:47:09 / stefan"
!

synchronizationSemaphore:aSemaphore
    "set the synchronisationSemaphore for myself.
     subclasses may redefine this method"

    aSemaphore isNil ifTrue:[
        "/ remove Semaphore
        SynchronizationSemaphores removeKey:self ifAbsent:nil.
    ] ifFalse:[
        SynchronizationSemaphores at:self put:aSemaphore.
    ].

    "Modified: 28.1.1997 / 19:37:48 / stefan"
!

synchronized:aBlock
    "evaluate aBlock synchronized, i.e. use a monitor for this object"

    |sema wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    sema := self synchronizationSemaphore.
    sema isNil ifTrue:[
        sema := RecursionLock new name:self className.
        self synchronizationSemaphore:sema.
    ].

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ sema critical:aBlock.

    "
       [Object synchronized:[Delay waitForSeconds:2. Transcript showCR:'1']] fork.
       [Object synchronized:[Delay waitForSeconds:2. Transcript showCR:'2']] fork.
    "

    "Created: 28.1.1997 / 17:52:56 / stefan"
    "Modified: 30.1.1997 / 13:38:54 / cg"
    "Modified: 20.2.1997 / 09:43:35 / stefan"
! !

!Object methodsFor:'system primitives'!

asOop
    "ST-80 compatibility:
     ST-80 returns an OOP-identity based number here (I guess: its address
     or index); since ST/X has no such thing, and the objects address cannot
     be used (since its changing over time), we return the objects identityHash
     key, which provides (at least) some identity indication.
     However, notice that (in contrast to ST-80's #asOop), the identityHash
     key of two non-identical objects may be the same.
     You'd better not use it - especially do not misuse it."

    ^ self identityHash

    "Created: 9.11.1996 / 19:09:56 / cg"
    "Modified: 9.11.1996 / 19:16:04 / cg"
!

beImmutable
    "experimental - not yet usable; do not use.
     For now the #isImmutable flag prohibits only #become*."

%{  /* NOCONTEXT */
    if (! __isNonNilObject(self)) {
        RETURN (self);
    }
    __beImmutable(self);
%}
!

beMutable
    "experimental - not yet usable; do not use.
     For now the #isImmutable flag prohibits only #become*."

%{  /* NOCONTEXT */
    if (! __isNonNilObject(self)) {
        RETURN (self);
    }
    __beMutable(self);
%}
!

become:anotherObject
    "make all references to the receiver become references to anotherObject
     and vice-versa. Notice the vice-versa; see #becomeSameAs: for a one-way become.
     This can be a very dangerous operation - be warned.
     In general, using #become: should be avoided if possible, since it may
     produce many strange effects (think of hashing in Sets, Dictionaries etc.).

     This may also be an expensive (i.e. slow) operation,
     since in the worst case, the whole memory has to be searched for
     references to the two objects (although the primitive tries hard to
     limit the search, for acceptable performance in most cases).
     This method fails, if the receiver or the argument is a SmallInteger
     or nil, or is a context of a living method (i.e. one that has not already
     returned).
     (notice that #become: is not used heavily by the system
      - the Collection-classes have been rewritten to not use it.)"
%{
    if (__primBecome(self, anotherObject)) {
        RETURN ( self );
    }
%}.
    NoModificationError raiseRequestWith:self errorString:' - #become: failed'.
!

becomeNil
    "make all references to the receiver become nil - effectively getting
     rid of the receiver.
     This can be a very dangerous operation - be warned.

     This may be an expensive (i.e. slow) operation.
     The receiver may not be a SmallInteger or a context of a living method."

%{
    if (__primBecomeNil(self)) {
        RETURN ( nil );
    }
%}.
    NoModificationError raiseRequestWith:self errorString:' - #becomeNil failed'.
!

becomeSameAs:anotherObject
    "make all references to the receiver become references to anotherObject
     but NOT vice versa (as done in #become:).
     This can be a very dangerous operation - be warned.
     In general, using #become: should be avoided if possible, since it may
     produce many strange effects (think of hashing in Sets, Dictionaries etc.).

     This may also be an expensive (i.e. slow) operation,
     since in the worst case, the whole memory has to be searched for
     references to the two objects (although the primitive tries hard to
     limit the search, for acceptable performance in most cases).
     This method fails, if the receiver or the argument is a SmallInteger
     or nil, or is a context of a living method (i.e. one that has not already returned)."
%{
    if (__primBecomeSameAs(self, anotherObject)) {
        RETURN ( self );
    }
%}.
    NoModificationError raiseRequestWith:self errorString:' - #becomeSameAs: failed'.
!

changeClassTo:otherClass
    "changes the class of the receiver to the argument, otherClass.
     This is only allowed (possible), if the receiver's class and the argument
     have the same structure (i.e. number of named instance variables and
     type of indexed instance variables).
     If the structures do not match, or any of the original class or new class
     is UndefinedObject or a Smallinteger, a primitive error is triggered."

    |myClass ok|

    otherClass autoload.

    "check for UndefinedObject/SmallInteger receiver or newClass"
%{
#ifdef __SCHTEAM__
    ok = (self.isSTInstance() && otherClass.isSTInstance())
            ? STObject.True : STObject.False;
#else
    {
        OBJ other = otherClass;

        if (__isNonNilObject(self)
         && __isNonNilObject(other)
         && (other != UndefinedObject)
         && (other != SmallInteger)) {
            ok = true;
        } else {
            ok = false;
        }
    }
#endif /* not SCHTEAM */
%}.
    ok == true ifTrue:[
        ok := false.
        myClass := self class.
        myClass == otherClass ifTrue:[
            "nothing to change"
            ^ self.
        ].
        myClass flags == otherClass flags ifTrue:[
            myClass instSize == otherClass instSize ifTrue:[
                "same instance layout and types: its ok to do it"
                ok := true.
            ] ifFalse:[
                myClass isPointers ifTrue:[
                    myClass isVariable ifTrue:[
                        ok := true
                    ]
                ]
            ]
        ] ifFalse:[
            myClass isPointers ifTrue:[
                "if newClass is a variable class, with instSize <= my instsize,
                 we can do it (effectively mapping additional instvars into the
                 variable part) - usefulness is questionable, though"

                otherClass isPointers ifTrue:[
                    otherClass isVariable ifTrue:[
                        otherClass instSize <= (myClass instSize + self basicSize)
                        ifTrue:[
                            ok := true
                        ]
                    ] ifFalse:[
                        otherClass instSize == (myClass instSize + self basicSize)
                        ifTrue:[
                            ok := true
                        ]
                    ]
                ] ifFalse:[
                    "it does not make sense to convert pointers to bytes ..."
                ]
            ] ifFalse:[
                "does it make sense, to convert bits ?"
                "could allow byteArray->wordArray->longArray->floatArray->doubleArray here ..."
                (myClass isBitsExtended and:[otherClass isBitsExtended]) ifTrue:[
                    ok := true
                ]
            ]
        ]
    ].
    ok == true ifTrue:[
        "now, change the receiver's class ..."
%{
#ifdef __SCHTEAM__
        ((STInstance)self).clazz = (STClass)otherClass;
        return __c__._RETURN(self);
#else
        {
            OBJ me = self;

            // gcc4.4 does not like this:
            // __qClass(me) = otherClass;
            __objPtr(me)->o_class = (CLASS_OBJ)otherClass;
            __STORE(me, otherClass);
            RETURN (me);
        }
#endif /* not SCHTEAM */
%}.
    ].

    "
     the receiver cannot be represented as a instance of
     the desired class.
     For example, you cannot change a bitInstance (byteArray etc.)
     into a pointer object and vice versa.
    "
    self primitiveFailed
!

changeClassToThatOf:anObject
    "changes the class of the receiver to that of the argument, anObject.
     This is only allowed (possible), if the receiver's class and the arguments
     class have the same structure (i.e. number of named instance variables and
     type of indexed instance variables). If the structures do not match, or any
     of the objects is nil or a Smallinteger, a primitive error is triggered."

    self changeClassTo:(anObject class)
!

isImmutable
    "experimental - not yet usable; do not use.
     For now the #isImmutable flag prohibits only #become*."


%{  /* NOCONTEXT */
    if (! __isNonNilObject(self)) {
        RETURN (true);
    }
    if (__isImmutable(self)) {
        RETURN (true);
    }
%}.
    ^ false
!

replaceReferencesTo:anObject with:newRef
    "if the receiver refers to the argument, anObject, replace this reference with newRef.
     Return true if any reference was changed.
     Notice: this does not change the class-reference."

%{  /* NOCONTEXT */
    OBJ cls, flags, anyChange;
    int nInsts, i;

    if (! __isNonNilObject(self)) {
        RETURN (false);
    }

    /*
     * a little optimization: use the fact that all old objects
     * refering to a new object are on the remSet; if I am not,
     * a trivial reject is possible, if anObject is a newbee
     */
    if (__isNonNilObject(anObject)) {
        if ((__qSpace(self) <= OLDSPACE) && !__isRemembered(self)) {
            int spc;

            if (((spc = __qSpace(anObject)) == NEWSPACE) || (spc == SURVSPACE)) {
                RETURN (false);
            }
        }
    }

    cls = __qClass(self);

    flags = __ClassInstPtr(cls)->c_flags;
    if (((INT)flags & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(POINTERARRAY)) {
        nInsts = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    } else {
        nInsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
    }
    if (! nInsts) {
        RETURN (false);
    }
    anyChange = false;
    for (i=0; i<nInsts; i++) {
        if (__InstPtr(self)->i_instvars[i] == anObject) {
            __InstPtr(self)->i_instvars[i] = newRef;
            __STORE(self, newRef);
            // __dumpObject__(self, __LINE__);
            anyChange = true;
        }
    }
    RETURN (anyChange);
%}.
    self primitiveFailed

    "
     |v|

     v := Array with:1234 with:'hello' with:Array.
     v replaceReferencesTo:Array with:ByteArray.
     v inspect
    "

    "Modified: / 30-07-2013 / 21:48:06 / cg"
! !

!Object methodsFor:'testing'!

? defaultValue
     "a syntactic sugar-piece:
      if the receiver is nil, return the defaultValue;
      otherwise, return the receiver.
      This method is only redefined in UndefinedObject - therefore,
      the receiver is returned here.

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

      Note: this method should never be redefined in classes other than UndefinedObject.
      Notice:
         This method is open coded (inlined) by the compiler(s)
         - redefining it may not work as expected."

    ^ self

    "
     1 ? #default
     nil ? #default
    "

    "Created: / 4.11.1996 / 20:36:19 / cg"
    "Modified: / 19.5.1998 / 17:39:56 / cg"
!

?+ aOneArgBlock
     "a syntactic sugar-piece:
      aOneArgBlock is executed with self as argument
      if self is not nil.

      Note: this method should never be redefined in classes other than UndefinedObject.
     "

    ^ aOneArgBlock value:self

    "
     1 ?+ [:v| v + 5]
     nil ?+ [:v| v + 5]
    "
!

?? defaultValue
     "a syntactic sugar-piece:
      much like ?, but sends #value to the argument if required.
      (i.e. it is the same as #ifNil:)
      If the receiver is nil, return the defaultValues value;
      otherwise, return the receiver.
      This method is only redefined in UndefinedObject - therefore,
      the receiver is returned here.

      Thus, if foo and bar are simple variables or constants,
          foo ?? bar
      is the same as:
          (foo isNil ifTrue:[bar value] ifFalse:[foo])

      if they are message sends, the equivalent code is:
          [
              |t t2|

              t := foo.
              t isNil ifTrue:[bar value] ifFalse:[t]
          ] value

      Can be used to provide defaultValues to variables,
      as in:
          foo := arg ?? [ self computeDefault ]

      Note: this method should never be redefined in classes other than UndefinedObject.
     "

    ^ self

    "
     1 ?? #default
     nil ?? #default
     1 ?? [ self halt. 1 + 2 ]
     nil ?? [ self halt. 1 + 2 ]
     1 ?? [Date today]
     nil ?? [Date today]
    "

    "Created: / 4.11.1996 / 20:36:19 / cg"
    "Modified: / 19.5.1998 / 17:42:56 / cg"
!

ifNil:aBlockOrValue
    "return myself, or the result from evaluating the argument, if I am nil.
     This is much like #?, but sends #value to the argument in case of a nil
     receiver.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ self
!

ifNil:nilBlockOrValue ifNotNil:notNilBlockOrValue
    "return the value of the first arg, if I am nil,
     the result from evaluating the 2nd argument, if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    (notNilBlockOrValue isBlock and:[notNilBlockOrValue argumentCount == 1]) ifTrue:[
        ^ notNilBlockOrValue value:self.
    ].
    ^ notNilBlockOrValue value
!

ifNotNil:aBlockOrValue
    "return myself if nil, or the result from evaluating the argument,
     if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    (aBlockOrValue isBlock and:[aBlockOrValue argumentCount == 1]) ifTrue:[
        ^ aBlockOrValue value:self.
    ].
    ^ aBlockOrValue value
!

ifNotNil:notNilBlockOrValue ifNil:nilBlockOrValue
    "return the value of the 2nd arg, if I am nil,
     the result from evaluating the 1st argument, if I am not nil.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    (notNilBlockOrValue isBlock and:[notNilBlockOrValue argumentCount == 1]) ifTrue:[
        ^ notNilBlockOrValue value:self.
    ].
    ^ notNilBlockOrValue value
!

ifNotNilDo:aBlock
    "if the receiver is non-nil, return the value of aBlock, passing myself as argument.
     Otherwise do nothing and return nil."

    ^ aBlock value:self
!

isArray
    "return true if the receiver is some kind of array (or weakArray etc);
     false is returned here - the method is only redefined in Array."

    ^ false
!

isAssociation
    "return true if the receiver is some kind of association;
     false is returned here - the method is only redefined in Association."

    ^ false

    "Created: 14.5.1996 / 17:03:45 / cg"
!

isBehavior
    "return true if the receiver is describing another object's behavior.
     False is returned here - the method is only redefined in Behavior."

    ^ false
!

isBlock
    "return true if the receiver is some kind of block;
     false returned here - the method is only redefined in Block."

    ^ false
!

isBoolean
    "return true if the receiver is a boolean;
     false is returned here - the method is only redefined in Boolean."

    ^ false
!

isBridgeProxy
    "answer true, if I am a proxy object for a bridged remote object"

    "do not move this into the bridge-package;
     it is called by some others, to prevent remote messages from implements/respondsTo, etc.
     which are called from inspectors and debuggers"

    ^ false

    "Modified (comment): / 25-05-2018 / 12:45:42 / Claus Gittinger"
!

isByteArray
    "return true if the receiver is some kind of bytearray;
     false is returned here - the method is only redefined in ByteArray."

    ^ false
!

isByteCollection
    "return true if the receiver is some kind of byte collection,
     i.e. #at: and #at:put: accesses a byte. This is different from 'self class isBytes',
     since e.g. in BitArray single bits are accessed, but it is implemented as variableBytes class.

     false is returned here - the method is only redefined in UninterpretedBytes."

    ^ false
!

isCharacter
    "return true if the receiver is some kind of character;
     false is returned here - the method is only redefined in Character."

    ^ false
!

isClass
    "return true if the receiver is some kind of class
     (real class, not just behavior);
     false is returned here - the method is only redefined in Class."

    ^ false
!

isCollection
    "return true if the receiver is some kind of collection;
     false is returned here - the method is only redefined in Collection."

    ^ false
!

isColor
    "return true if the receiver is some kind of color;
     false is returned here - the method is only redefined in Color."

    ^ false
!

isCons
    "return true if the receiver is a cons (pair);
     false is returned here - the method is only redefined in Cons."

    ^ false
!

isContext
    "return true if the receiver is some kind of Context;
     false returned here - the method is only redefined in Context."

    ^ false
!

isDictionary
    "return true if the receiver is some kind of dictionary;
     false returned here - the method is only redefined in Dictionary."

    ^ false
!

isEmptyOrNil
    "return true if I am nil or an empty collection - return false here.
     (from Squeak)"

    ^ false

    "Created: / 13.11.2001 / 13:17:04 / cg"
    "Modified: / 13.11.2001 / 13:28:40 / cg"
!

isException
    "answer true, if this is an Exception"

    ^ false

    "Created: / 17.11.2001 / 18:37:44 / cg"
!

isExceptionCreator
    "return true if the receiver can create exceptions,
     this includes #raise, #raiseRequest as well as the behavior of
     an exception handler, such as the #accepts: and #handles: messages"

    ^ false
!

isExceptionHandler
    "return true if the receiver responds to the exception handler protocol,
     especially to the #accepts: and #handles: messages"

    ^ false
!

isExternalAddress
    "return true if the receiver is some kind of externalAddress;
     false is returned here - the method is only redefined in ExternalAddress."

    ^ false

    "Created: / 22-12-2010 / 17:20:36 / cg"
!

isExternalBytes
    ^ false
!

isExternalLibraryFunction
    "return true if the receiver is some kind of externalLibrary function;
     false is returned here - the method is only redefined in ExternalLibraryFunction."

    ^false
!

isExternalStream
    "return true if the receiver is some kind of externalStream;
     false is returned here - the method is only redefined in ExternalStream."

    ^false
!

isExternalStructure
    ^ false
!

isFileStream
    "return true if the receiver is some kind of fileStream;
     false is returned here - the method is only redefined in FileStream."

    ^false
!

isFilename
    "return true if the receiver is some kind of filename;
     false is returned here - the method is only redefined in Filename."

    ^false
!

isFixedPoint
    "return true if the receiver is some kind of fixedPoint number;
     false is returned here - the method is only redefined in FixedPoint."

    ^ false

    "Created: 5.11.1996 / 19:23:04 / cg"
!

isFixedSize
    "return true if the receiver cannot grow easily
     (i.e. a grow may be expensive, since it involves a become:)"

    ^ true
!

isFloat
    "return true if the receiver is some kind of floating point number;
     false is returned here.
     Same as #isLimitedPrecisionReal, but a better name ;-)"

    ^ false

    "Modified: / 14.11.2001 / 14:57:46 / cg"
!

isForm
    "return true if the receiver is some kind of form;
     false is returned here - the method is only redefined in Form."

    ^ false
!

isFraction
    "return true if the receiver is some kind of fraction;
     false is returned here - the method is only redefined in Fraction."

    ^ false
!

isHierarchicalItem
    "used to decide if the parent is a hierarchical item or the model"

    ^ false
!

isImage
    "return true if the receiver is some kind of image;
     false is returned here - the method is only redefined in Image."

    ^ false
!

isImageOrForm
    "return true if the receiver is some kind of image or form;
     false is returned here - the method is only redefined in Image and Form."

    ^ false
!

isImmediate
    "return true if I am an immediate object
     i.e. I am represented in the pointer itself and
     no real object header/storage is used me.
     (currently, only SmallIntegers, some characters and nil return true)"

    ^ self class hasImmediateInstances

    "Created: 3.6.1997 / 12:00:18 / cg"
!

isInteger
    "return true if the receiver is some kind of integer number;
     false is returned here - the method is only redefined in Integer."

    ^ false
!

isInterestConverter
    "return true if I am a kind of interest forwarder"

    ^ false
!

isInternalByteStream
    "return true, if the receiver is some kind of Stream for reading bytes;
     false is returned here - the method is only redefined in PeekableStream."

    ^false

    "Created: / 30-05-2007 / 16:15:33 / cg"
!

isJavaClass
    "return true if this is a JavaClass.
     false is returned here - the method is only redefined in JavaClass."

    ^ false

    "Created: / 26.3.1997 / 13:34:54 / cg"
    "Modified: / 8.5.1998 / 21:25:21 / cg"
!

isJavaClassRef
    "return true if this is a JavaClassRef.
     false is returned here - the method is only redefined in JavaClassRef."

    ^ false

    "Modified: / 8.5.1998 / 21:25:46 / cg"
    "Created: / 24.12.1999 / 01:46:28 / cg"
!

isJavaContext
    "return true if this is a JavaContext.
     false is returned here - the method is only redefined in JavaContext."

    ^ false

    "Created: / 8.5.1998 / 21:24:27 / cg"
    "Modified: / 8.5.1998 / 21:25:35 / cg"
!

isJavaMethod
    "return true if this is a JavaMethod.
     false is returned here - the method is only redefined in JavaMethod."

    ^ false

    "Modified: / 8.5.1998 / 21:25:46 / cg"
    "Created: / 25.9.1999 / 23:26:12 / cg"
!

isJavaMethodRef
    "return true if this is a JavaMethodRef.
     false is returned here - the method is only redefined in JavaMethodRef."

    ^ false

    "Modified: / 8.5.1998 / 21:25:46 / cg"
    "Created: / 23.12.1999 / 19:44:51 / cg"
!

isJavaObject
    "return true if this is a JavaObject.
     false is returned here - the method is only redefined in JavaObject."

    ^ false

    "Created: / 26.3.1997 / 13:34:48 / cg"
    "Modified: / 8.5.1998 / 21:25:46 / cg"
!

isJavaScriptClass
    "return true if this is a JavaScriptClass.
     false is returned here - the method is only redefined in JavaScriptClass."

    ^ false
!

isJavaScriptMetaclass
    "return true if this is a JavaScript Metaclass.
     false is returned here - the method is only redefined in JavaScriptMetaclass."

    ^ false
!

isKindOf:aClass
    "return true if the receiver is an instance of aClass or one of its
     subclasses, false otherwise.
     Advice:
        use of this to check objects for certain attributes/protocol should
        be avoided; it limits the reusability of your classes by limiting use
        to instances of certain classes and fences you into a specific inheritance
        hierarchy.
        Use check-methods to check an object for a certain attributes/protocol
        (such as #isXXXX, #respondsTo: or #isNumber).

        Using #isKindOf: is considered BAD STYLE.

     Advice2:
        Be aware, that using an #isXXX method is usually much faster than
        using #isKindOf:; because isKindOf: has to walk up all the superclass
        hierarchy, comparing every class on the way.
        Due to caching in the VM, a call to #isXXX is normally reached via
        a single function call.
     "

%{  /* NOCONTEXT */
    register OBJ thisClass;

    thisClass = __Class(self);
    while (thisClass != nil) {
        if (thisClass == aClass) {
            RETURN ( true );
        }
        thisClass = __ClassInstPtr(thisClass)->c_superclass;
    }
    RETURN ( false );
%}

"/
"/  the above code is equivalent to:
"/
"/  thisClass := self class.
"/  [thisClass notNil] whileTrue:[
"/      thisClass == aClass ifTrue:[^ true].
"/      thisClass := thisClass superclass
"/  ].
"/  ^ false
"/
!

isLabelAndIcon
    "return true if the receiver is a LabelAndIcon;
     false is returned here - the method is only redefined in LabelAndIcon."

    ^ false
!

isLayout
    "return true if the receiver is some kind of layout;
     false is returned here - the method is only redefined in Layout."

    ^ false
!

isLazyValue
    ^ false
!

isLimitedPrecisionReal
    "return true if the receiver is some kind of floating point number;
     false is returned here - the method is only redefined in LimitedPrecisionReal."

    ^ false
!

isList
    "return true if the receiver is some kind of list collection;
     false is returned here - the method is only redefined in List."

    ^ false

    "Created: / 11.2.2000 / 01:37:05 / cg"
!

isLiteral
    "return true if the receiver can be represented as a literal constant in ST syntax;
     false is returned here - the method is redefined in some classes."

    ^ false
!

isMemberOf:aClass
    "return true if the receiver is an instance of aClass, false otherwise.
     Advice:
        use of this to check objects for certain attributes/protocol should
        be avoided; it limits the reusability of your classes by limiting use
        to instances of a certain class.
        Use check-methods to check an object for a certain attributes/protocol
        (such as #isXXX, #respondsTo: or #isNumber);

        Using #isMemberOf: is considered BAD STYLE.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ (self class) == aClass
!

isMenuItem
    "return true if the receiver is a menu item inside a MenuPanel, Menu or PopUpmenu.
     false is returned here - the method is redefined in some classes."

    ^ false
!

isMeta
    "return true if the receiver is some kind of metaclass;
     false is returned here - the method is only redefined in Metaclass."

    ^ false
!

isMethod
    "return true if the receiver is some kind of method;
     false returned here - this method is only redefined in Method."

    ^ false
!

isMorph
    "return true if the receiver is some kind of morph;
     false is returned here - the method is only redefined in Morph."

    ^ false
!

isNameSpace
    "return true if the receiver is a NameSpace.
     False is returned here - the method is only redefined in Namespace."

    ^ false

    "Created: / 11.10.1996 / 18:08:56 / cg"
    "Modified: / 8.5.1998 / 21:26:05 / cg"
!

isNamespace
    "return true if this is a NameSpace.
     false is returned here - the method is only redefined in Namespace."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #isNameSpace'.
    ^ self isNameSpace
!

isNil
    "Return true if the receiver is nil.
     Because isNil is redefined in UndefinedObject,
     the receiver is definitely not nil here, so unconditionally return false.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ false
!

isNilOrEmptyCollection
    "return true if I am nil or an empty collection - false here.
     Obsolete, use isEmptyOrNil."

    <resource:#obsolete>

    ^ false

    "Modified: / 13.11.2001 / 13:28:06 / cg"
!

isNonByteCollection
    "return true if the receiver is some kind of collection, but not a String, ByteArray etc.;
     false is returned here - the method is redefined in Collection and UninterpretedBytes."

    ^ false

    "
        21 isNonByteCollection
        'abc' isNonByteCollection
        #'abc' isNonByteCollection
        #[1 2 3] isNonByteCollection
        #(1 2 3) isNonByteCollection
    "
!

isNotNil
    <resource: #obsolete>

    "Return true if the receiver is not nil.
     Because isNotNil is redefined in UndefinedObject,
     the receiver is definitely not nil here, so unconditionally return true."

    self obsoleteMethodWarning:'use #notNil'.
    ^ true

    "Created: / 26-10-2014 / 01:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNumber
    "return true if the receiver is some kind of number;
     false is returned here - the method is only redefined in Number."

    ^ false
!

isOSErrorHolder
    ^ false
!

isOrderedCollection
    "return true if the receiver is some kind of ordered collection (or list etc);
     false is returned here - the method is only redefined in OrderedCollection."

    ^ false
!

isOsHandle
    ^ false
!

isPlainString
    "return true if the receiver is a plain string - without attributes;
     false is returned here - the method is redefined in CharacterArray and Text."

    ^ false
!

isPoint
    "return true if the receiver is some kind of point;
     false is returned here - the method is only redefined in Point."

    ^ false
!

isPrinterContext

    ^false
!

isProgrammingLanguage
    "return true if the receiver is a programming language.
     False is returned here - the method is only redefined in
     ProgrammingLanguage."

    ^ false

    "Created: / 21-07-2010 / 15:13:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isProjectDefinition
    "return true if the receiver is a projectDefinition.
     False is returned here - the method is only redefined in ProjectDefinition."

    ^ false

    "Created: / 10-08-2006 / 16:24:53 / cg"
!

isProtoObject
    ^ false
!

isProxy
    "return true if the receiver is a proxy for another (lazy loaded) object.
     False is returned here."

    ^ false

    "Created: / 21-11-2010 / 11:15:46 / cg"
!

isRealNameSpace
    "return true if the receiver is a NameSpace, but not Smalltalk (which is also a class).
     False is returned here - the method is redefined in Namespace and Smalltalk."

    ^ false

    "Created: / 10-11-2006 / 17:05:43 / cg"
!

isRectangle
    "return true if the receiver is some kind of rectangle;
     false is returned here - the method is only redefined in Rectangle."

    ^ false
!

isRemoteObject
    "return true if the receiver is some kind of remoteObject,
     false if its local - the method is only redefined in RemoteObject."

    ^ false

    "Created: 28.10.1996 / 15:18:45 / cg"
    "Modified: 28.10.1996 / 15:20:57 / cg"
!

isSequenceable
    "return true if the receiver is some kind of sequenceable collection;
     false is returned here - the method is only redefined in SequenceableCollection."

    ^ false
!

isSequenceableCollection
    "OBSOLETE: use isSequenceable for ST-80 compatibility.
     This method is a historic leftover and will be removed soon ...
     (although its name is much better than #isSequenceable - sigh)"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #isSequenceable'.
    ^ self isSequenceable
!

isSharedPool
    "return true if the receiver is a sharedPool.
     False is returned here - the method is only redefined in SharedPool."

    ^ false
!

isSingleByteString
    "return true if the receiver is a string or immutableString.
     false is returned here - the method is only redefined in String.
     Must replace foo isMemberOf:String and foo class == String"

    ^ false
!

isSocketAddress
    ^ false
!

isSpecialInstrumentationInfoLiteral
    "return true if the receiver is a special instrumentation info
     object as placed into the literal array of instrumented methods"

    ^ false

    "Created: / 07-08-2011 / 17:03:41 / cg"
!

isStream
    "return true if the receiver is some kind of stream;
     false is returned here - the method is only redefined in Stream."

    ^ false
!

isString
    "return true if the receiver is some kind of string;
     false is returned here - the method is only redefined in CharacterArray."

    ^ false
!

isStringCollection
    "return true if the receiver is some kind of stringCollection;
     false is returned here - the method is only redefined in StringCollection."

    ^ false
!

isStructure
    "redefined in Structure>>#doesNotUnderstand"

    ^ false
!

isSymbol
    "return true if the receiver is some kind of symbol;
     false is returned here - the method is only redefined in Symbol."

    ^ false
!

isText
    "return true if the receiver is some kind of text object;
     false is returned here - the method is only redefined in Text."

    ^ false

    "Created: 12.5.1996 / 10:56:50 / cg"
!

isTextView
    "return true if the receiver is some kind of textView;
     false is returned here - the method is only redefined in TextViews."

    ^ false

    "Modified (comment): / 08-09-2011 / 05:12:37 / cg"
!

isTimeDuration
    "return true if the receiver is some kind of time duration;
     false is returned here - the method is only redefined in TimeDuration."

    ^ false
!

isTimestamp
    "return true if the receiver is some kind of time duration;
     false is returned here - the method is only redefined in Timestamp."

    ^ false
!

isTrait
    "Return true if the receiver is a trait.
     Note: Do not override in any class except TraitBehavior."

    ^ false

    "Created: / 04-09-2011 / 20:04:43 / cg"
!

isURL
    "Return true if the receiver is a url.
     Note: Do not override in any class except URL."

    ^ false

    "Created: / 17-02-2017 / 10:25:12 / cg"
!

isUUID
    "Return true if the receiver is a uuid.
     Note: Do not override in any class except UUID."

    ^ false
!

isValueModel
    "return true if the receiver is some kind of valueModel;
     false is returned here - the method is only redefined in ValueModel."

    ^ false
!

isVariable
    "return true if the receiver has indexed instance variables,
     false otherwise."

    ^ self class isVariable
!

isVariableBinding
    "return true if this is a binding for a variable.
     false is returned here - the method is only redefined in Binding."

    ^ false

    "Created: / 19.6.1997 / 17:38:44 / cg"
    "Modified: / 8.5.1998 / 21:26:55 / cg"
!

isView
    "return true if the receiver is some kind of view;
     false is returned here - the method is only redefined in View."

    ^ false
!

isViewBackground
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isVoid
    "Return true if the receiver is void.
     This is (and should only be) redefined in VoidObject,
     for the one and only instance of it, void"

    ^ false

    "
     nil isVoid
     void isVoid
    "
!

isWeakCollection
    "return true if the receiver has weak references to its elements."

    ^ false
!

notEmptyOrNil
    "Squeak compatibility:
     return true if I am neither nil nor an empty collection.
     Return true here."

    ^ true
!

notNil
    "Return true if the receiver is not nil.
     Because notNil is redefined in UndefinedObject,
     the receiver is definitely not nil here, so unconditionally return true.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ true
! !

!Object methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceObject:self level:level from:referrer

    "Created: / 2.9.1999 / 09:05:17 / stefan"
! !

!Object methodsFor:'user interaction & notifications'!

activityNotification:aString
    "this can be sent from deeply nested methods, which are going to perform
     some long-time activity.
     If there is a handler for the ActivityNotificationSignal signal, that one is raised,
     passing the argument. The handler should show this message whereever it likes,
     and proceed. If there is no handler, this is simply ignored.

     This is very useful to pass busy messages up to some higher level (typically a view)
     which likes to display that message in its label or a busy-box.
     It could also be put into some logfile or printed on the standard output/error."

    ActivityNotification isHandled ifTrue:[
        ^ ActivityNotification raiseRequestWith:self errorString:aString
    ].

    "
     nil activityNotification:'hello there'
     self activityNotification:'hello there'
    "

    "
     ActivityNotification handle:[:ex |
        ex errorString printCR.
        ex proceed.
     ] do:[
        'hello' printCR.
        self activityNotification:'doing some long time computation'.
        'world' printCR.
     ]
    "

    "Modified: 16.12.1995 / 18:23:42 / cg"
!

confirm:aString
    "open a modal yes-no dialog.
     Return true for yes, false for no.
     If no GUI is present (headless applications), true is returned.

     Someone in the sender chain may redefine the confirmation handler
     by handling the UserConfirmation."

    ^ UserConfirmation raiseRequestErrorString:aString

    "
     nil confirm:'hello'
     self confirm:'hello'
    "
!

confirm:aString orCancel:cancelBlock
    "launch a confirmer, which allows user to enter yes, no or cancel.
     return true for yes, false for no, or the value from cancelBlock for cancel.
     If no GUI is present (headless applications), cancelBlock is returned."

    |answer|

    answer := self confirmWithCancel:aString.
    answer isNil ifTrue:[
        ^ cancelBlock value
    ].
    ^ answer

    "
     self confirm:'hello' orCancel:[self halt]
    "

    "Modified: 20.5.1996 / 10:28:40 / cg"
!

confirmWithCancel:aString
    "launch a confirmer, which allows user to enter yes, no or cancel.
     return true for yes, false for no, nil for cancel.
     If no GUI is present (headless applications), nil is returned.

     Someone in the sender chain may redefine the confirmation handler
     by handling the UserConfirmation."

    ^ self confirmWithCancel:aString defaultAnswer:nil

    "
     nil confirmWithCancel:'hello'
     self confirmWithCancel:'hello'
    "
!

confirmWithCancel:aString defaultAnswer:defaultAnswerOrNil
    "launch a confirmer, which allows user to enter yes, no or cancel.
     return true for yes, false for no, nil for cancel.
     If no GUI is present (headless applications), nil is returned.

     Someone in the sender chain may redefine the confirmation handler
     by handling the UserConfirmation."

    ^ UserConfirmation new
        defaultAnswer:defaultAnswerOrNil;
        canCancel:true;
        errorString:aString;
        raiseRequest

    "
     nil confirmWithCancel:'hello' defaultAnswer:true
     self confirmWithCancel:'hello' defaultAnswer:false
    "
!

errorNotify:aString
    "launch a Notifier, showing top stack, telling user something
     and give user a chance to enter debugger."

    ^ self
        errorNotify:aString
        from:thisContext sender
        allowDebug:true
        mayProceed:true

    "
     nil errorNotify:'hello there'
     self errorNotify:'hello there'
    "

    "Modified: / 16.11.2001 / 15:36:49 / cg"
!

errorNotify:aString from:aContext
    "launch a Notifier, showing top stack (above aContext),
     telling user something and give user a chance to enter debugger."

    ^ self errorNotify:aString from:aContext allowDebug:true mayProceed:true

    "Modified: / 17.8.1998 / 10:09:27 / cg"
!

errorNotify:aString from:aContext allowDebug:allowDebug
    "launch a Notifier, showing top stack (above aContext),
     telling user something and give user a chance to enter debugger."

    ^ self errorNotify:aString from:aContext allowDebug:allowDebug mayProceed:true
!

errorNotify:aString from:aContext allowDebug:allowDebug mayProceed:mayProceed
    "launch a Notifier, showing top stack (above aContext),
     telling user something and optionally give the user a chance to enter debugger."

    |currentScreen con sender action boxLabels boxValues default s|

    Smalltalk isInitialized ifFalse:[
        'errorNotification: ' print. aString printCR.
        con := aContext ? thisContext methodHome.
        con sender printAllLevels:10.
        ^ nil
    ].

    (Dialog isNil
     or:[Screen isNil
     or:[(currentScreen := Screen current) isNil
     or:[currentScreen isOpen not]]]) ifTrue:[
        "
         on systems without GUI, simply show
         the message on the Transcript and abort.
        "
        Transcript showCR:aString.
        AbortOperationRequest raise.
        "not reached"
        ^ nil
    ].

    Processor activeProcessIsSystemProcess ifTrue:[
        action := #debug.
        sender := aContext.
        Debugger isNil ifTrue:[
            '****************** Caught Error while in SystemProcess ****************' errorPrintCR.
            aString errorPrintCR.
            Exception handle:[:ex |
                'Caught recursive error while printing backtrace:' errorPrintCR.
                ex description errorPrintCR.
            ] do:[
                thisContext fullPrintAll.
            ].
            action := #abort.
        ].
    ] ifFalse:[
        Dialog autoload.        "in case it is autoloaded"

        Error handle:[:ex |
            "/ a recursive error - quickly enter debugger
            "/ this happened, when I corrupted the Dialog class ...
            ('Object [error]: ' , ex description , ' caught in errorNotification') errorPrintCR.
            action := #debug.
            ex return.
        ] do:[ |s|
            sender := aContext.
            sender isNil ifTrue:[
                sender := thisContext methodHome sender.
            ].
            con := sender.

            "/ skip intermediate (signal & exception) contexts
            DebugView notNil ifTrue:[
                con := DebugView interestingContextFrom:sender
            ].

            "/ show the first few contexts

            s := CharacterWriteStream with:aString.
            s cr; cr.
            s nextPutLine:'Calling Chain:'.
            s nextPutLine:'--------------------------------------------------------------'.
            1 to:25 do:[:n |
                con notNil ifTrue:[
                    con printOn:s.
                    s cr.
                    con := con sender
                ]
            ].

            mayProceed ifTrue:[
                boxLabels := #('Proceed').
                boxValues := #(#proceed).
                default := #proceed.
            ] ifFalse:[
                boxLabels := #().
                boxValues := #().
            ].

            AbortOperationRequest isHandled ifTrue:[
                default := #abort.
                boxLabels := boxLabels , #('Abort').
                boxValues := boxValues , #(#abort).
                AbortAllOperationRequest isHandled ifTrue:[
                    boxLabels := boxLabels , #('Abort All').
                    boxValues := boxValues , #(#abortAll).
                ].
                true "allowDebug" ifTrue:[
                    boxLabels := boxLabels , #('Copy Trace and Abort').
                    boxValues := boxValues , #(#copyAndAbort).
                ].
            ] ifFalse:[
                mayProceed "and:[allowDebug]" ifTrue:[
                    boxLabels := boxLabels , #('Copy Trace and Proceed').
                    boxValues := boxValues , #(#copyAndProceed).
                ].
            ].

            (allowDebug and:[Debugger notNil]) ifTrue:[
                boxLabels := boxLabels , #('Debug').
                boxValues := boxValues , #(#debug).
                default := #debug.
            ].

            action := Dialog
                    choose:s contents
                    label:('Exception [' , Processor activeProcess nameOrId , ']')
                    image:WarningBox errorIconBitmap
                    labels:boxLabels
                    values:boxValues
                    default:default
                    onCancel:nil.
        ].
    ].

    action == #debug ifTrue:[
        ^ Debugger enter:sender withMessage:aString mayProceed:mayProceed
    ].
    action == #proceed ifTrue:[
        ^ nil.
    ].
    (action == #copyAndProceed
    or:[action == #copyAndAbort]) ifTrue:[
        s := '' writeStream.
        Exception handle:[:ex |
            'Caught recursive error while printing backtrace' errorPrintCR.
        ] do:[
            sender fullPrintAllOn:s.
        ].
        currentScreen rootView setClipboardText:s contents.
        action == #copyAndProceed ifTrue:[
            ^ nil
        ].
    ].
    (action == #abortAll) ifTrue:[
        AbortAllOperationRequest raise
    ].

    AbortOperationRequest raise.
    "not reached"

    "
     nil errorNotify:'hello there'
     self errorNotify:'hello there'
    "

    "Created: / 17-08-1998 / 10:09:26 / cg"
    "Modified: / 08-08-2011 / 11:26:17 / sr"
    "Modified: / 05-12-2011 / 03:50:59 / cg"
!

information:aString
    "launch an InfoBox, telling user something.
     These info-boxes can be suppressed by handling
     UserNotification or InformationSignal and proceeding in the handler.
     Use #notify: for more important messages.
     If nobody handles the exception, the default action of UserNotification
     pops up an info dialog."

    UserInformation raiseRequestWith:self errorString:aString

    "
     nil information:'hello there'
     self information:'hello there'
    "

    "
     InformationSignal handle:[:ex |
        'no box popped' printCR.
        ex proceed.
     ] do:[
        'hello' printCR.
        self information:'some info'.
        'world' printCR.
     ]
    "

    "Modified: 24.11.1995 / 22:29:49 / cg"
!

notify:aString
    "launch a Notifier, telling user something.
     Use #information: for ignorable messages.
     If nobody handles the exception, the default action of UserNotification
     pops up a warn dialog."


    Smalltalk isInitialized ifFalse:[
        "/ thisContext fullPrintAll.
        'information: ' print. aString printCR.
        ^ self
    ].
    UserNotification raiseRequestWith:self errorString:aString.

    "
     nil notify:'hello there'
     self notify:'hello there'
    "

    "Modified: / 20-05-1996 / 10:28:48 / cg"
    "Modified (comment): / 23-01-2017 / 16:17:50 / stefan"
!

warn:aString
    "launch a WarningBox, telling user something.
     These warn-boxes can be suppressed by handling the
     UserNotification- or WarningSignal and proceeding in the handler.
     If nobody handles the exception, the dafault action of Warning
     pops up a warn dialog."

    Warning raiseRequestWith:self errorString:aString

    "
     nil warn:'hello there'
     self warn:'hello there'
    "

    "
     Warning handle:[:ex |
        Transcript showCR:ex description.
        ex proceed.
     ] do:[
        'hello' printCR.
        self warn:'some info'.
        'world' printCR.
     ]
    "

    "Modified: 20.5.1996 / 10:28:53 / cg"
! !

!Object methodsFor:'visiting'!

acceptVisitor:aVisitor
    "double-dispatch onto a Visitor."

    ^ self acceptVisitor:aVisitor with:nil
!

acceptVisitor:aVisitor with:aParameter
    "double-dispatch via visitObject:with: into a Visitor.
     Subclasses redefine this to pass their type in the message name (i.e. visitXXX:)"

    ^ aVisitor visitObject:self with:aParameter
! !




!Object class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Object initialize!
