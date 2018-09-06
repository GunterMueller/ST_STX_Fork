"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

ArrayedCollection variableSubclass:#WeakArray
	instanceVariableNames:'dependents'
	classVariableNames:'RegistrationFailedSignal AlreadyInitialized'
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

documentation
"
    WeakArrays can be used to trace disposal of objects; in contrast to other
    objects, references by WeakArrays will NOT keep an object from being
    garbage collected.
    Instead, whenever an object kept in a WeakArray dies, its entry is set to a SmallInteger,
    and the WeakArray is informed by the storage manager. The WeakArray itself
    then informs possible dependents via the dependency mechanism.

    WeakArrays are used to track disposal of objects which keep external
    world resources. For example, FileStreams must close their underlying
    file when disposed (otherwise you could run out of OS filedescriptors).
    This can be done by keeping the FileStream objects in a weakArray, and
    keep a parallel array of filedescriptors. Whenever a fileStream is
    freed, search both arrays for an index where the stream is set to a SmallInteger, but the
    filedescriptor is non-nil. Then close that file, and nil the filedescriptor
    entry. Notice, that there is a class (Registry) which does exactly this in
    a more programmer friendly way.

    Another application is caching of data: keep it in a weakArray, so the
    data in that cache will not be unreclaimable due to being cached.
    (for example, the ResourcePack class uses a WeakArray to cache recently
     used resource data for a while).

    The way in which weakArrays get informed by the runtime system is via
    an interrupt (DisposeInterrupt) which is first sent to the disposeHandler
    (typically ObjectMemory). ObjectMemory then takes the required steps to
    notify all weakArrays via the #lostPointer message.
    The reason for not sending messages directly from the VM is to make it
    possible to run the finalization code at lower priority or from another class.
    Also, as a side effect, it is possible to delay finalization by blocking
    interrupts. (thus, the actual sending of the #lostPointer message is under
    control of Smalltalk code, which is modifyable).


    A weakArray notifies its dependents via normal dependency notfications.

    [hint:]
        WeakArray handling adds small some overhead to the VM
        (each weakarray is scanned after each GC).
        It is uncertain, if the current mechanism works well
        with (say) ten-thousands of weakArrays.
        We had the system running with >2000 weakArrays, some being quite
        big for a while and had a few percent of added gc time.
        The system as delivered creates between 50 and 100 weakArrays,
        but with many dependents, this number may grow.
        If you need the dependency mechanism on a huge number of objects,
        consider adding a (non-weak) dependents field to your class
        - take the implementation of Model as a guide (or subclass them
        from Model).

    As a possible option, we could perform the weakArray scanning only in
    the oldSpace reclamation code - this would remove most of the overhead,
    but will lead to much longer delayed finalization .... we will see.


    [instance variables:]

        dependents                  get informed via #change notifiction
                                    that the weakArray has lost pointers.
                                    Having the dependents here is an optimization.

    [class variables:]

        RegistrationFailedSignal    raised if a weakArray cannot be
                                    registered by the VM. This only happens,
                                    if the VM has to resize its internal tables
                                    and is running out of malloc-memory.

    [memory requirements:]
        OBJ-HEADER + (size * ptr-size) + ptr-size
                   + sizeof(dependents-collection)

    [author:]
        Claus Gittinger

    [See also:]
        Array WeakIdentitySet WeakIdentityDictionary Registry
        Model
"
! !

!WeakArray class methodsFor:'initialization'!

initialize
    "setup the private signal"

    self flags:(Behavior flagWeakPointers).     "/ read the comment in basicNew:
    RegistrationFailedSignal isNil ifTrue:[
	RegistrationFailedSignal := Error newSignalMayProceed:true.
	RegistrationFailedSignal nameClass:self message:#registrationFailedSignal.
	RegistrationFailedSignal notifierString:'weakArray registration failed'.
    ].
! !

!WeakArray class methodsFor:'instance creation'!

basicNew:size
    "return a new weakArray with size slots"

    "This is a kludge: I would like to set the WEAK-flag in the classes
     initialize method, but (currently) the order in which the class-initialize
     methods are called is not defined ...
     ... therefore it could happen, that a WeakArray is used by other
     classes initialize method BEFORE this method is evaluated.
     To avoid this, the WEAK bit in the class is set here, when the very first
     WeakArray is created.
     [Actually, the cleanest solution was to add another class definition
      keyword (such as #variableWeakSubclass:) which sets the weak flag right
      from the start.]"

    AlreadyInitialized isNil ifTrue:[
	self flags:(Behavior flagWeakPointers).
	AlreadyInitialized := true
    ].

    ^ (super basicNew:size) registerAsWeakArray

    "Modified: 25.1.1997 / 13:17:22 / cg"
! !

!WeakArray class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == WeakArray
! !

!WeakArray methodsFor:'GC registration'!

registerAsWeakArray
    "register the receiver in the VM -
     i.e. tell the VM to nil disposed entries in the receiver
     and notify the disposeInterruptHandler whenever that happened."

    |ok|

%{
    OBJ __addShadowObject();

    ok = __addShadowObject(self, 0);
    if (ok == false) {
        /*
         * the behavior of __addShadowObject() in case of overflowing
         * VM-table space can be controlled by the second argument:
         *   if its 0, the weakObject is not registered, and false
         *   is returned.
         *   if its 1, the tables are reallocated, registration proceeds,
         *   and true is returned.
         * This allows for the caller to have an influence on the VM's
         * shadow table allocation.
         *
         * If addShadowObject() returned false, too many shadow objects are
         * already there. Then collect garbage to get rid of
         * obsolete ones, and try again.
         * Since a full collect is expensive, we try
         * a scavenge first, doing a full collect only if
         * that does not help.
         *
         * THIS MAY OR MAY NOT BE A GOOD IDEA: although it reduces
         * the number of shadow objects that have to be
         * processed at GC time, it may create a long delay here,
         * at shadow object creation time.
         * Don't know which is better ...
         */
        __nonTenuringScavenge(__context);
        ok = __addShadowObject(self, 0);

        if (ok == false) {
            /*
             * hard stuff - need full collect
             * if this is the very first GC, assume that we are in
             * the startup phase (where all weak stuff is allocated).
             * Then do no GC.
             * Heuristics showed, that this GC does not find much ...
             */
            if ((__garbageCollectCount() != 0)
             || (__incrementalGCCount() != 0)) {
                __markAndSweepIfUseful(__context);
                ok = __addShadowObject(self, 0);
            }
            if (ok == false) {
                /*
                 * mhmh - it seems that there are really many shadow
                 * objects around - force creation
                 */
                ok = __addShadowObject(self, 1);
                if (ok == false) {
                    /*
                     * no chance - something must be wrong
                     * lets fall into the exception and see.
                     */
                }
            }
        }
    }
%}.
    ok ifFalse:[
        "
         the VM was not able to register the new weakArray
         This can only happen, if the VM has to resize its tables,
         and a malloc request failed. Usually, this smells like big
         trouble being on the way (soon running out of memory in
         other places as well).
         Configure your OS for more swap space.
        "
        ^ RegistrationFailedSignal raiseRequestWith:self
    ]
! !

!WeakArray methodsFor:'accessing'!

at:index
    "return the indexed instance variable with index, anInteger.
     Reimplemented here for IGC readBarrier.
     (You don't have to understand this.)"

    ^ self basicAt:index

    "Modified: 25.1.1997 / 13:41:25 / cg"
!

at:index ifAbsent:exceptionValue
    "return the indexed instance variable with index, anInteger,
     or exceptionValue if the index is invalid.
     Reimplemented here for IGC readBarrier.
     (You don't have to understand this.)"

    (index < 0 or:[index > self size]) ifTrue:[^ exceptionValue].
    ^ self at:index
!

at:index ifInvalid:exceptionalValue
    "return the indexed instance variable with index, anInteger,
     but only if still valid; otherwise return the value from exceptionalValue"

    |el|

    el := self basicAt:index.
    el class == SmallInteger ifTrue:[
        ^ exceptionalValue value
    ].
    ^ el
!

at:index put:someObject
    "store someObject in the weakArray at some index."

    ^ self basicAt:index put:someObject
!

basicAt:index
    "return the indexed instance variable with index, anInteger.
     Reimplemented here for IGC readBarrier.
     (You don't have to understand this.)"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER unsigned INT nIndex;
    OBJ el;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	if (indx >= 0) {
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    indx += __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
	    if (indx < nIndex) {
		el = __InstPtr(self)->i_instvars[indx];
		if (__isNonNilObject(el)) {
		    el = __WEAK_READ__(self, el);
#ifdef WEAK_DEBUG
		    if (! __ISVALIDOBJECT(el)) {
			fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
			__dumpObject__(el, __LINE__);
			el = nil;
		    }
#endif
		}
		RETURN (el);
	    }
	}
    }
%}.
    ^ super basicAt:index
!

basicAt:index put:someObject
    "store someObject in the weakArray at some index."

%{  /* NOCONTEXT */
    REGISTER INT indx;
    REGISTER unsigned INT nIndex;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	if (indx >= 0) {
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    indx += __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
	    if (indx < nIndex) {
		REGISTER OBJ el = someObject;

		__InstPtr(self)->i_instvars[indx] = el;
		if (__isNonNilObject(el)) {
		    __STORE(self, el);
		    __WEAK_WRITE__(self, el);
		}
		RETURN (el);
	    }
	}
    }
%}.
    "/ for the error-message ...
    ^ super basicAt:index put:someObject
! !

!WeakArray methodsFor:'copying'!

postCopy
    "copying alone does not really help - we have to tell
     the VM, that there is a new WeakArray around ...
     Q: who copies weakArrays ?"

    dependents := nil.
    self registerAsWeakArray.
!

postDeepCopy
    dependents := nil.
    self registerAsWeakArray.
!

skipInstvarIndexInDeepCopy:index
    "a helper for deepCopy; only indices for which this method returns
     false are copied in a deep copy."

    ^ index == 1    "/ skip dependents
! !

!WeakArray methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    [
	|deps|

	deps := dependents.
	"/
	"/ store the very first dependent directly in
	"/ the dependents instVar
	"/
	(deps isNil and:[anObject isCollection not]) ifTrue:[
	    dependents := anObject
	] ifFalse:[
	    "/
	    "/ store more dependents in the dependents collection
	    "/
	    deps isCollection ifTrue:[
		deps add:anObject
	    ] ifFalse:[
		deps == anObject ifFalse:[
		    deps isNil ifTrue:[
			dependents := (IdentitySet with:anObject)
		    ] ifFalse:[
			dependents := (IdentitySet with:deps with:anObject)
		    ]
		]
	    ]
	]
    ] ensure:[
	wasBlocked ifFalse:[
	    OperatingSystem unblockInterrupts
	]
    ]

    "Modified: 8.1.1997 / 23:40:30 / cg"
!

dependents
    "return the dependents of the receiver"

    dependents isNil ifTrue:[^ #()].
    dependents isCollection ifTrue:[
	^ dependents
    ].
    ^ IdentitySet with:dependents

    "Modified: / 27.10.1997 / 19:37:16 / cg"
!

dependents:aCollection
    "set the dependents of the receiver"

    |dep|

    aCollection size == 1 ifTrue:[
	dep := aCollection first.
	dep isCollection ifFalse:[
	    dependents := aCollection first.
	    ^ self
	]
    ].
    dependents := aCollection
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents"

    |deps|

    deps := dependents.
    deps notNil ifTrue:[
	deps isCollection ifTrue:[
	    deps do:aBlock
	] ifFalse:[
	    aBlock value:deps
	]
    ]
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
        |deps sz dep|

        deps := dependents.
        deps notNil ifTrue:[
            deps isCollection ifTrue:[
                dep := deps remove:anObject ifAbsent:[].
                "if dep is nil, nothing has changed"
                dep notNil ifTrue:[
                    (sz := deps size) == 0 ifTrue:[
                        dependents := nil
                    ] ifFalse:[
                        sz == 1 ifTrue:[
                            (dep := deps first) isCollection ifFalse:[
                                dependents := dep
                            ]
                        ]
                    ].
                ].
            ] ifFalse:[
                deps == anObject ifTrue:[
                    dependents := nil
                ]
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]
! !

!WeakArray methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for each element in the collection.
     - reimplemented for IGC readBarrier.
     You don't have to understand this."

    |element|

%{
    REGISTER int index;
    unsigned INT nIndex;
    static struct inlineCache val = _ILC1;

    index = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);

    if (__isBlockLike(aBlock)
     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
        {
            /*
             * the most common case: a static compiled block, with home on the stack ...
             */
            REGISTER OBJFUNC codeVal;

            if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
             && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))) {

#               define BLOCK_ARG        aBlock
                {
                    for (; index < nIndex; index++) {
                        if (InterruptPending != nil) __interruptL(@line);

                        element = __InstPtr(self)->i_instvars[index];
                        if (__isNonNilObject(element)) {
                            element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                            if (! __ISVALIDOBJECT(element)) {
                                fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                                __dumpObject__(element, __LINE__);
                                element = nil;
                            }
#endif
                        }
                        (*codeVal)(BLOCK_ARG, element);
                    }
                    RETURN (self);
                }
            }
        }

        /*
         * sorry, must check code-pointer in the loop
         * it could be recompiled or flushed
         */
#       undef BLOCK_ARG
#       define BLOCK_ARG        aBlock
#       define IBLOCK_ARG       nil
        for (; index < nIndex; index++) {
            REGISTER OBJFUNC codeVal;

            if (InterruptPending != nil) __interruptL(@line);

            element = __InstPtr(self)->i_instvars[index];
            if (__isNonNilObject(element)) {
                element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                if (! __ISVALIDOBJECT(element)) {
                    fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                    __dumpObject__(element, __LINE__);
                    element = nil;
                }
#endif
            }
            if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                (*codeVal)(BLOCK_ARG, element);
            } else {
                if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                    /*
                     * arg is a compiled block with bytecode -
                     * directly call interpreter without going through Block>>value
                     */
#ifdef PASS_ARG_POINTER
                    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &element);
#else
                    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, element);
#endif
                } else {
                    /*
                     * arg is something else - call it with #value
                     */
                    (*val.ilc_func)(aBlock, @symbol(value:), nil, &val, element);
                }
            }
        }
        RETURN (self);

#       undef BLOCK_ARG
#       undef IBLOCK_ARG

    }

    /*
     * not a block - send it #value:
     */
    for (; index < nIndex; index++) {
        if (InterruptPending != nil) __interruptL(@line);

        element = __InstPtr(self)->i_instvars[index];
        if (__isNonNilObject(element)) {
            element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
            if (! __ISVALIDOBJECT(element)) {
                fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                __dumpObject__(element, __LINE__);
                element = nil;
            }
#endif
        }
        (*val.ilc_func)(aBlock,
                            @symbol(value:),
                            nil, &val,
                            element);
    }
    RETURN (self);
%}.
    ^ super do:[:each |
        each notNil ifTrue:[aBlock value:each]
      ]

    "Modified: / 23-07-2015 / 15:35:24 / cg"
!

forAllDeadIndicesDo:aBlock
    "evaluate the argument, aBlock for all indices where elements have been
     replaced by zero (due to a collected object).
     Be aware, that while indices are being enumerated, other
     slots may change iff the garbage collector finds new garbage."

    self keysAndValuesDo:[:index :element |
	element class == SmallInteger ifTrue:[
	     aBlock value:index
	]
    ]

    "Modified: 25.1.1997 / 14:50:59 / cg"
!

forAllDeadIndicesDo:aBlock replacingCorpsesWith:newValue
    "evaluate the argument, aBlock for all indices where elements have been
     replaced by a SmallInteger (due to a collected object), and replace the element
     with newValue.
     In the current implementation, the block sees the newValue (i.e. it is
     changed before the block is called); this behavior is not guaranteed
     with future versions.
     Be aware, that while indices are being enumerated, other
     slots may change iff the garbage collector finds new garbage."

    self keysAndValuesDo:[:index :element |
        element class == SmallInteger ifTrue:[
            self at:index put:newValue.
            aBlock value:index.
        ]
    ]

    "Modified: 25.1.1997 / 14:51:28 / cg"
!

nilAllCorpsesAndDo:aBlock
    "evaluate the argument, aBlock for all indices where elements have been
     cleared (due to a collected object), nil the entry."

    self forAllDeadIndicesDo:aBlock replacingCorpsesWith:nil
!

nonNilElementsDo:aBlock
    "evaluate the argument, aBlock for each non-nil element"

    |element|
%{
    REGISTER int index;
    unsigned INT nIndex;
    static struct inlineCache val = _ILC1;

    index = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    if (__isBlockLike(aBlock)
     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
        {
            /*
             * the most common case: a static compiled block, with home on the stack ...
             */
            REGISTER OBJFUNC codeVal;

            if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
             && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))) {


#               define BLOCK_ARG        aBlock
                {
                    for (; index < nIndex; index++) {
                        element = __InstPtr(self)->i_instvars[index];
                        if (element) {
                            if (InterruptPending != nil) {
                                __interruptL(@line);
                                element = __InstPtr(self)->i_instvars[index];
                            }

                            if (__isNonNilObject(element)) {
                                element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                                if (! __ISVALIDOBJECT(element)) {
                                    fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                                    __dumpObject__(element, __LINE__);
                                    element = nil;
                                }
#endif
                            }
                            if (element) {
                                (*codeVal)(BLOCK_ARG, element);
                            }
                        }
                    }
                    RETURN (self);
                }
            }
        }

        /*
         * sorry, must check code-pointer in the loop
         * it could be recompiled or flushed
         */
#       undef BLOCK_ARG
#       define BLOCK_ARG        aBlock
#       define IBLOCK_ARG       nil
        for (; index < nIndex; index++) {
            REGISTER OBJFUNC codeVal;

            element = __InstPtr(self)->i_instvars[index];
            if (element) {
                if (InterruptPending != nil) {
                    __interruptL(@line);
                    element = __InstPtr(self)->i_instvars[index];
                }
                if (__isNonNilObject(element)) {
                    element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                    if (! __ISVALIDOBJECT(element)) {
                        fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                        __dumpObject__(element, __LINE__);
                        element = nil;
                    }
#endif
                }
                if (element) {
                    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                        (*codeVal)(BLOCK_ARG, element);
                    } else {
                        if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                            /*
                             * arg is a compiled block with bytecode -
                             * directly call interpreter without going through Block>>value
                             */
#ifdef PASS_ARG_POINTER
                            __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &element);
#else
                            __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, element);
#endif
                        } else {
                            /*
                             * arg is something else - call it with #value
                             */
                            (*val.ilc_func)(aBlock, @symbol(value:), nil, &val, element);
                        }
                    }
                }
            }
        }
        RETURN (self);

#       undef BLOCK_ARG
#       undef IBLOCK_ARG
    }

    /*
     * not a block - send it #value:
     */
    for (; index < nIndex; index++) {
        element = __InstPtr(self)->i_instvars[index];
        if (element) {
            if (InterruptPending != nil) {
                __interruptL(@line);
                element = __InstPtr(self)->i_instvars[index];
            }
            if (__isNonNilObject(element)) {
                element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                if (! __ISVALIDOBJECT(element)) {
                    fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                    __dumpObject__(element, __LINE__);
                    element = nil;
                }
#endif
            }
            if (element) {
                (*val.ilc_func)(aBlock,
                                    @symbol(value:),
                                    nil, &val,
                                    element);
            }
        }
    }
    RETURN (self);
%}.
    ^ super do:[:each |
        each notNil ifTrue:[aBlock value:each]
      ]
!

validElementsDo:aBlock
    "evaluate the argument, aBlock for each non-nil/non-evacuated element"

    |element|
%{
    REGISTER int index;
    unsigned INT nIndex;
    static struct inlineCache val = _ILC1;

    index = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    if (__isBlockLike(aBlock)
     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
        {
            /*
             * the most common case: a static compiled block, with home on the stack ...
             */
            REGISTER OBJFUNC codeVal;

            if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
             && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))) {


#               define BLOCK_ARG        aBlock
                {
                    for (; index < nIndex; index++) {
                        element = __InstPtr(self)->i_instvars[index];
                        if (__isNonNilObject(element)) {
                            if (InterruptPending != nil) {
                                __interruptL(@line);
                                element = __InstPtr(self)->i_instvars[index];
                            }

                            if (__isNonNilObject(element)) {
                                element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                                if (! __ISVALIDOBJECT(element)) {
                                    fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                                    __dumpObject__(element, __LINE__);
                                    element = nil;
                                }
#endif
                                if (__isNonNilObject(element)) {
                                    (*codeVal)(BLOCK_ARG, element);
                                }
                            }
                        }
                    }
                    RETURN (self);
                }
            }
        }

        /*
         * sorry, must check code-pointer in the loop
         * it could be recompiled or flushed
         */
#       undef BLOCK_ARG
#       define BLOCK_ARG        aBlock
#       define IBLOCK_ARG       nil
        for (; index < nIndex; index++) {
            REGISTER OBJFUNC codeVal;

            element = __InstPtr(self)->i_instvars[index];
            if (__isNonNilObject(element)) {
                if (InterruptPending != nil) {
                    __interruptL(@line);
                    element = __InstPtr(self)->i_instvars[index];
                }
                if (__isNonNilObject(element)) {
                    element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                    if (! __ISVALIDOBJECT(element)) {
                        fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                        __dumpObject__(element, __LINE__);
                        element = nil;
                    }
#endif
                    if (__isNonNilObject(element)) {
                        if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                            (*codeVal)(BLOCK_ARG, element);
                        } else {
                            if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                                /*
                                 * arg is a compiled block with bytecode -
                                 * directly call interpreter without going through Block>>value
                                 */
#ifdef PASS_ARG_POINTER
                                __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &element);
#else
                                __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, element);
#endif
                            } else {
                                /*
                                 * arg is something else - call it with #value
                                 */
                                (*val.ilc_func)(aBlock, @symbol(value:), nil, &val, element);
                            }
                        }
                    }
                }
            }
        }
        RETURN (self);

#       undef BLOCK_ARG
#       undef IBLOCK_ARG
    }

    /*
     * not a block - send it #value:
     */
    for (; index < nIndex; index++) {
        element = __InstPtr(self)->i_instvars[index];
        if (__isNonNilObject(element)) {
            if (InterruptPending != nil) {
                __interruptL(@line);
                element = __InstPtr(self)->i_instvars[index];
            }
            if (__isNonNilObject(element)) {
                element = __WEAK_READ__(self, element);
#ifdef WEAK_DEBUG
                if (! __ISVALIDOBJECT(element)) {
                    fprintf(stderr, "****** OOPS - invalid Weak-Read\n");
                    __dumpObject__(element, __LINE__);
                    element = nil;
                }
#endif
                if (__isNonNilObject(element)) {
                    (*val.ilc_func)(aBlock,
                                    @symbol(value:),
                                    nil, &val,
                                    element);
                }
            }
        }
    }
    RETURN (self);
%}.
    ^ super do:[:each |
        (each notNil and:[each class ~~ SmallInteger]) ifTrue:[aBlock value:each]
      ]

    "Modified: / 23-07-2015 / 15:32:44 / cg"
! !

!WeakArray methodsFor:'notification'!

lostPointer
    "I lost a pointer; tell dependents.
     This is sent from the finalization code in ObjectMemory."

    dependents notNil ifTrue:[
	self changed:#ElementExpired with:nil.
    ].

    "Modified: 18.10.1996 / 21:28:10 / cg"
    "Modified: 7.1.1997 / 17:22:52 / stefan"
! !

!WeakArray methodsFor:'testing'!

isWeakCollection
    "return true, if the receiver has weak references to its elements."

    ^ true
! !

!WeakArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


WeakArray initialize!
