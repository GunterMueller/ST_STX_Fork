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

Object subclass:#JavaFinalizationRegistry
	instanceVariableNames:'accessLock finalizationSemaphore finalizationProcess lastCGCcount
		lastIGCcount skippedCycles'
	classVariableNames:'SkipCycleLimit'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaFinalizationRegistry class methodsFor:'documentation'!

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
    A tricky class that implements Java-style finalization.
    Future versions may involve some C / VM optimization,
    if this algorithm prooves usefull

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaFinalizationRegistry class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    SkipCycleLimit := 10.

    "Modified: / 16-08-2012 / 18:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaFinalizationRegistry methodsFor:'finalization'!

finalizationCycle

    | java_lang_ref_Finalizer ref refs objs living firstPendingReference lastPendingReference finished |


    skippedCycles < SkipCycleLimit ifTrue:[
        lastCGCcount == ObjectMemory garbageCollectCount ifTrue:[ skippedCycles := skippedCycles + 1. ^ self ].
        lastIGCcount == ObjectMemory incrementalGCCount ifTrue:[ skippedCycles := skippedCycles + 1. ^ self ].
    ].
    skippedCycles := 0.

    java_lang_ref_Finalizer := JavaVM classNamed:'java.lang.ref.Finalizer' definedBy: nil.
    java_lang_ref_Finalizer isNil ifTrue:[ ^ self ].

    refs := OrderedCollection new.
    ref := java_lang_ref_Finalizer instVarNamed: #unfinalized.
    [ ref notNil ] whileTrue:[
        refs add: ref.
        ref := ref instVarAt: 5. "/Second next field!!!!!!"
    ].
    refs isEmpty ifTrue:[ ^ self ].
    refs := refs asArray.
    objs := refs collect:[:each|each instVarAt:1"referent"].
    living := Array new: refs size.

    firstPendingReference := nil.
    finished := self allObjectsIncludingContextsDo:[:o|
        self scan: o forReferenceToAnyOf: objs living: living finalizers: refs
    ].
    finished ifFalse:[ ^ self ].

    living withIndexDo:[:each :index|
        each isNil ifTrue:[
            ref := refs at: index. 
            firstPendingReference isNil ifTrue:[
                firstPendingReference := lastPendingReference := ref
            ] ifFalse:[
                self setNextOf: lastPendingReference to: ref.
                lastPendingReference := ref.
            ].
            self setNextOf: lastPendingReference to: lastPendingReference
        ].
    ].
    self informReferenceHandler: firstPendingReference.

    lastCGCcount := ObjectMemory garbageCollectCount.
    lastIGCcount := ObjectMemory incrementalGCCount.

    "Created: / 24-07-2012 / 15:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2013 / 01:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalizationLoop

    [ 
        finalizationSemaphore waitWithTimeoutMs: 60"sec" * 1000.
        self finalizationCycle    
    ] loop

    "Created: / 24-07-2012 / 15:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    accessLock := RecursionLock new.
    lastCGCcount := ObjectMemory garbageCollectCount.
    lastIGCcount := ObjectMemory incrementalGCCount.
    skippedCycles := 0.


    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 16-08-2012 / 18:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry methodsFor:'private'!

allObjectsIncludingContextsDo:aBlock

    | wasBlocked |

    wasBlocked := OperatingSystem blockInterrupts.

    (ObjectMemory allObjectsDo:aBlock) ifFalse:[ 
        wasBlocked ifTrue:[
            OperatingSystem unblockInterrupts.
        ].
        ^false
    ].
    ProcessorScheduler knownProcesses do:[:p |
        |con|

        con := p suspendedContext.
        [con notNil] whileTrue:[
            aBlock value:con.
            con := con sender.
        ].
    ].
    wasBlocked ifTrue:[
        OperatingSystem unblockInterrupts.
    ].

    ^ true

    "Created: / 28-07-2012 / 02:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getNextOf: reference

    ^reference instVarAt: 3

    "Created: / 24-07-2012 / 11:22:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

grow: array
    ^self grow: array min: 30

    "Created: / 28-07-2012 / 01:14:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

grow: array min: min
    | grown |

    grown := Array new: ((array size * 2) max: min).
    grown replaceFrom: 1 with: array.
    ^grown

    "Created: / 28-07-2012 / 01:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

informReferenceHandler: reference
    | referenceClass lock |

    reference isNil ifTrue:[ ^ self ].

    referenceClass := JavaVM classForName: 'java.lang.ref.Reference'.
    lock := (referenceClass instVarNamed:#lock) getJavaMonitor.
    lock acquire.
    [
        referenceClass instVarNamed: #pending put: reference.
        lock notify: false.
    ] ensure:[
        lock release.
    ].

    "Created: / 24-07-2012 / 03:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2017 / 22:20:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scan: object forReferenceToAnyOf: referents living: living finalizers: finalizers

    "Scans given object for references to any of referees. Returns self

     If the object is not referents array itself not finalizers array itself
       AND
     If the object refers any of the referents, then store 1 (SmallInteger)
     into living object index corresponding to the index of referent 
     (in referents array). 1 is stored because it is immediate so no
     __STORE() have to be called.
    "

%{
    OBJ cls, flags;
    int nInsts, inst;
    if (! __isNonNilObject(object)) {
        RETURN ( self );
    }
    if (object == referents) {
        RETURN ( self );
    }

    if (__isArrayLike(referents)) {
        int nObjs = __arraySize(referents);
        char *minAddr = 0, *maxAddr = 0;

        if (nObjs == 0) {
            RETURN ( self );
        }

        /*
         * a little optimization: use the fact that all old objects
         * refering to a new object are on the remSet; if I am not,
         * a trivial reject is possible, if all objects are newbees.
         * as a side effect, gather min/max addresses
         */
        if ((__qSpace(object) <= OLDSPACE) && !__isRemembered(object)) {
            int allNewBees = 1;
            int i;

            minAddr = (char *)(__ArrayInstPtr(referents)->a_element[0]);
            maxAddr = minAddr;

            for (i=0; i<nObjs; i++) {
                OBJ anObject;

                anObject = __ArrayInstPtr(referents)->a_element[i];

                if (__isNonNilObject(anObject)) {
                    int spc;

                    if (((spc = __qSpace(anObject)) != NEWSPACE) && (spc != SURVSPACE)) {
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
                RETURN ( self );
            }
        }

        /*
         * fetch min/max in searchList (if not already done)
         */
        if (minAddr == 0) {
            int i;

            for (i=0; i<nObjs; i++) {
                OBJ anObject;

                anObject = __ArrayInstPtr(referents)->a_element[i];
                if ((char *)anObject < minAddr) {
                    minAddr = (char *)anObject;
                } else if ((char *)anObject > maxAddr) {
                    maxAddr = (char *)anObject;
                }
            }
        }

        cls = __qClass(object);
        flags = __ClassInstPtr(cls)->c_flags;
        if (((INT)flags & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(POINTERARRAY)) {
            nInsts = __BYTES2OBJS__(__qSize(object) - OHDR_SIZE);
        } else {
            nInsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
        }
        if (! nInsts) {
            RETURN ( self );
        }

        for (inst=0; inst<nInsts; inst++) {
            OBJ instVar = __InstPtr(object)->i_instvars[inst];
            int i;

            if (((char *)instVar >= minAddr) && ((char *)instVar <= maxAddr)) {
                for (i=0; i < nObjs; i++) {
                    OBJ anObject;

                    anObject = __ArrayInstPtr(referents)->a_element[i];
                    if (instVar == anObject) {
                        /* Found a reference */
                        if (object != __ArrayInstPtr(finalizers)->a_element[i]) {                            
                            __ArrayInstPtr(living)->a_element[i] = __MKINT(1);
                        }
                    }
                }
            }
        }
        RETURN ( self );
    }
%}.

    self primitiveFailed.

    "Created: / 16-08-2012 / 10:01:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNextOf: reference to: value

    ^reference instVarAt: 3 put: value

    "Created: / 24-07-2012 / 11:22:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry methodsFor:'registering objects'!

register: object
    "Register an object for being finalized"

    | finalizedClass |

    accessLock critical:[
        finalizedClass := JavaVM classForName:'java.lang.ref.Finalizer' definedBy: nil.
        finalizedClass classInit.
        (finalizedClass methodDictionary at: #'register(Ljava/lang/Object;)V')
            valueWithReceiver: finalizedClass arguments: (Array with: object).
    ].

    "Created: / 24-07-2012 / 01:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:45:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerChange: anObject
    "/Nothing to do, to be polymprph with Registry"

    "Created: / 24-07-2012 / 03:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry methodsFor:'start & stop'!

resumeFinalizationProcess
    "stop the background finalizer"

    finalizationProcess notNil ifTrue:[
        finalizationProcess resume.
    ] ifFalse:[
        self startFinalizationProcessAt: 5
    ].

    "Created: / 28-07-2012 / 10:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startFinalizationProcessAt:aPriority

    |p|

    finalizationProcess notNil ifTrue:[
        finalizationProcess priority:aPriority.
        ^ self
    ].

    finalizationSemaphore := Semaphore new name:'FinalizationSemaphore (Java)'.

    p :=
        [
            [
                self finalizationLoop
            ] ifCurtailed:[
                finalizationProcess := nil.
                finalizationSemaphore := nil
            ]
        ] newProcess.
    p name:'background finalizer (Java)'.
    p priority:aPriority.
    p restartable:true.
"/    p beSystemProcess.
    p resume.
    finalizationProcess := p

    "Created: / 24-07-2012 / 15:25:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopFinalizationProcess
    "stop the background finalizer"

    finalizationProcess notNil ifTrue:[
        finalizationProcess terminate.
        finalizationProcess := nil
    ].

    "Created: / 24-07-2012 / 15:26:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suspendFinalizationProcess
    "stop the background finalizer"

    finalizationProcess notNil ifTrue:[
        finalizationProcess suspend.
    ].

    "Created: / 28-07-2012 / 10:53:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry methodsFor:'utilities'!

finalizeNow
    "Force finalization to run now"
    skippedCycles := SkipCycleLimit.
    finalizationSemaphore signal.

    "Created: / 24-07-2012 / 15:28:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFinalizationRegistry class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaFinalizationRegistry.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !


JavaFinalizationRegistry initialize!
