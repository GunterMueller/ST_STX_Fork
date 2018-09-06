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
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MessageTracer
	instanceVariableNames:'traceDetail tracedBlock'
	classVariableNames:'BreakpointSignal CallingLevel BreakBlock TraceSenderBlock
		TraceSenderBlock2 LeaveBreakBlock LeaveTraceBlock MethodCounts
		MethodCountsPerReceiverClass MethodMemoryUsage MethodTiming
		TraceFullBlock TraceFullBlock2 ObjectWrittenBreakpointSignal
		ObjectCopyHolders TimeForWrappers MockedMethodMarker'
	poolDictionaries:''
	category:'System-Debugging-Support'
!

MessageTracer subclass:#InteractionCollector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MessageTracer
!

Object subclass:#MethodSpyInfo
	instanceVariableNames:'profiler'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MessageTracer
!

Object subclass:#MethodTimingInfo
	instanceVariableNames:'count minTime maxTime sumTimes avgTime'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MessageTracer
!

MessageTracer subclass:#PrintingMessageTracer
	instanceVariableNames:'output'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MessageTracer
!

!MessageTracer class methodsFor:'documentation'!

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
    This class provides a common home for the tracing
    facilities (originally, they where in Object, but have been moved to
    allow easier separation of development vs. runtime configurations).

    tracing execution of a block:

	MessageTracer trace:[ ... ]

	MessageTracer traceFull:[ ... ]

	(for system developer only:)

	MessageTracer debugTrace:[ ... ]


    trapping sends to a specific object:

	MessageTracer trap:anObject selector:aSelector
	...
	MessageTracer untrap:anObject selector:aSelector
	or:
	MessageTracer untrap:anObject



    trapping some messages sent to a specific object:

	MessageTracer trap:anObject selectors:aCollectionOfSelectors
	...
	MessageTracer untrap:anObject



    trapping any message sent to a specific object:

	MessageTracer trapAll:anObject
	...
	MessageTracer untrap:anObject



    trapping evaluation of a specific method:

	MessageTracer trapMethod:aMethod
	...
	MessageTracer unwrapMethod:aMethod



    trapping evaluation of a specific method with
    receiver being an instance of some class:

	MessageTracer trapMethod:aMethod forInstancesOf:aClass
	...
	MessageTracer unwrapMethod:aMethod



    tracing sends to a specific object:

	MessageTracer trace:anObject selector:aSelector
	...
	MessageTracer untrace:anObject selector:aSelector
	or:
	MessageTracer untrace:anObject



    tracing sender only:

	MessageTracer traceSender:anObject selector:aSelector
	...
	MessageTracer untrace:anObject selector:aSelector
	or:
	MessageTracer untrace:anObject



    tracing evaluation of a specific method:

	MessageTracer traceMethod:aMethod
	...
	MessageTracer unwrapmethod:aMethod

  see more in examples and in method comments.

    [author:]
	Claus Gittinger
"
!

examples
"
  For the common cases, you will find a menu entry in the SystemBrowser.
  Howeever, more special cases (especially with condition checks) can be
  set up by evaluating the lower level entries.


  trapping specific methods:
  (by class/selector):
									[exBegin]
     MessageTracer trapClass:Collection selector:#select:.
     Dictionary new select:[:e | ].       'not caught - Dictionary has its own select'.
     (Array new:10) select:[:e | ].       'not caught - SeqColl has its own select'.
     Set new select:[:e | ].              'caught - Set inherits this from Collection'.
     MessageTracer untrapClass:Collection
									[exEnd]

  (by method):
									[exBegin]
     MessageTracer trapMethod:(Collection compiledMethodAt:#select:).
     Dictionary new select:[:e | ].       'not caught - Dictionary has its own select'.
     (Array new:10) select:[:e | ].       'not caught - SeqColl has its own select'.
     Set new select:[:e | ].              'caught - Set inherits this from Collection'.
     MessageTracer unwrapMethod:(Collection compiledMethodAt:#select:).
									[exEnd]

  (by method & instance class):
									[exBegin]
     MessageTracer trapMethod:(SequenceableCollection compiledMethodAt:#select:)
		   forInstancesOf:SortedCollection.
     Dictionary new select:[:e | ].       'not caught - Dictionary has its own select'.
     (Array new:10) select:[:e | ].       'not caught - not a SortedCollection'.
     OrderedCollection new select:[:e | ]. 'not caught - not a SortedCollection'.
     SortedCollection new select:[:e | ].  'caught - Set inherits this from Collection'.
     MessageTracer unwrapMethod:(SequenceableCollection compiledMethodAt:#select:).
									[exEnd]

  tracing specific methods:
  (by class/selector):
									[exBegin]
     MessageTracer traceClass:SequenceableCollection selector:#quickSortFrom:to:.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceClass:SequenceableCollection
									[exEnd]

  (by method):
									[exBegin]
     MessageTracer traceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
     #(6 1 9 66 2 17) copy sort.
     MessageTracer unwrapMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
									[exEnd]

  object trapping:
									[exBegin]
     |o|

     o := OrderedCollection new.
     MessageTracer trapAll:o.
     o collect:[:el | el].
									[exEnd]

  trapping modifications to an objects instVars:
									[exBegin]
     |o|

     o := Point new.
     MessageTracer trapModificationsIn:o.
     o x:1.
     o y:2.
     o x:1.
     o y:2.
     MessageTracer untrap:o
									[exEnd]

  trapping modifications of a particular instVar:
									[exBegin]
     |o|

     o := Point new.
     MessageTracer trapModificationsIn:o filter:[:old :new | old x ~~ new x].
     o x:1.
     o y:2.
     o x:1.
     o y:2.
     MessageTracer untrap:o
									[exEnd]
  tracing during block execution:
									[exBegin]
     MessageTracer trace:[ 10 factorialR ]
									[exEnd]

"
! !

!MessageTracer class methodsFor:'Signal constants'!

breakpointSignal
    ^ BreakpointSignal
!

objectWrittenBreakpointSignal
    ^ ObjectWrittenBreakpointSignal

    "Created: / 21.4.1998 / 14:38:49 / cg"
! !

!MessageTracer class methodsFor:'class initialization'!

initialize
    BreakpointSignal isNil ifTrue:[
        "/ BreakpointSignal := HaltSignal newSignalMayProceed:true.
        "/ BreakpointSignal nameClass:self message:#breakpointSignal.
        BreakpointSignal := BreakPointInterrupt.
        BreakpointSignal notifierString:'breakpoint encountered'.
    ].

    ObjectWrittenBreakpointSignal isNil ifTrue:[
        ObjectWrittenBreakpointSignal := BreakpointSignal newSignalMayProceed:true.
        ObjectWrittenBreakpointSignal nameClass:self message:#objectWrittenBreakpointSignal.
        ObjectWrittenBreakpointSignal notifierString:'object modified'.
    ].

    "/ the following have been written as cheapBlocks (by purpose)
    BreakBlock       := [:con | BreakpointSignal raiseRequestWith:nil errorString:nil in:con].
    TraceSenderBlock  := [:con | MessageTracer printEntrySender:con on:(Smalltalk at:#Stderr)     ].
    TraceSenderBlock2 := [:con | MessageTracer printEntrySender:con on:(Smalltalk at:#Transcript) ].
    TraceFullBlock    := [:con | MessageTracer traceEntryFull:con on:(Smalltalk at:#Stderr)       ].
    TraceFullBlock2   := [:con | MessageTracer traceEntryFull:con on:(Smalltalk at:#Transcript)   ].
    LeaveBreakBlock  := [:con :retVal | retVal ].
    LeaveTraceBlock  := [:con :retVal | retVal ].

    ObjectMemory addDependent:self.

    MockedMethodMarker := Object new.

    "
     BreakpointSignal := nil.
     MessageTracer initialize
    "

    "Modified: / 15-09-2011 / 19:02:13 / cg"
    "Modified: / 29-07-2014 / 09:16:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:parameter from:changedObject
    "sent when restarted after a snapIn"

    (something == #restarted) ifTrue:[
	TimeForWrappers := nil
    ]

    "Created: / 30.7.1998 / 17:00:09 / cg"
! !

!MessageTracer class methodsFor:'class tracing'!

untraceAllClasses
    "remove all traces of messages sent to any class"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self untrapAllClasses
!

untraceClass:aClass
    "remove all traces of messages sent to instances of aClass"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self untrapClass:aClass
! !

!MessageTracer class methodsFor:'class wrapping'!

wrapClass:orgClass selector:aSelector onEntry:entryBlock onExit:exitBlock
    "arrange for the two blocks entryBlock and exitBlock to be evaluated whenever
     aSelector is sent to instances of orgClass or subclasses.
     EntryBlock will be called on entry, and get the current context passed as argument.
     ExitBlock will be called, when the method is left, and get context and the methods return value as arguments.
    "

    |myMetaclass trapMethod s spec implClass newClass dict|

    WrappedMethod autoload.     "/ just to make sure ...

    "
     create a new method, which calls the original one,
     but only if not already being trapped.
    "
    spec := Parser methodSpecificationForSelector:aSelector.

    s := WriteStream on:''.
    s nextPutAll:spec.
    s cr.
    s nextPutAll:'<context: #return>'; cr.
    s nextPutAll:'|retVal stubClass|'; cr.
    entryBlock notNil ifTrue:[
        s nextPutAll:'#literal1 yourself value:thisContext.'; cr.
    ].
    s nextPutAll:('retVal := #originalMethod. ').    "/ just to get a literal to be replaced by theoriginal method
    s nextPutAll:('retVal := super ' , spec , '.'); cr.
    exitBlock notNil ifTrue:[
        s nextPutAll:'#literal2 yourself value:thisContext value:retVal.'; cr.
    ].
    s nextPutAll:'^ retVal'; cr.

    ParserFlags
        withSTCCompilation:#never
        do:[
            Class withoutUpdatingChangesDo:[
                trapMethod := Compiler
                                compile:s contents
                                forClass:orgClass
                                inCategory:'trapping'
                                notifying:nil
                                install:false
                                skipIfSame:false
                                silent:true.
            ]
        ].

    implClass := orgClass whichClassIncludesSelector:aSelector.
    implClass isNil ifTrue:[
        Transcript showCR:aSelector , ' is not understood by ' , orgClass name.
    ] ifFalse:[
        trapMethod changeLiteral:#originalMethod to:(implClass compiledMethodAt:aSelector).
    ].
    entryBlock notNil ifTrue:[
        trapMethod changeLiteral:#literal1 to:entryBlock.
    ].
    exitBlock notNil ifTrue:[
        trapMethod changeLiteral:#literal2 to:exitBlock.
    ].

    "
     change the source of this new method
     (to avoid confusion in the debugger ...)
    "
    trapMethod source:'this is a wrapper method - not the real one'.
    trapMethod changeClassTo:WrappedMethod.
    trapMethod register.

    dict := orgClass methodDictionary.

    "
     if not already trapping, create a new class
    "
    orgClass category == #'* trapping *' ifTrue:[
        dict at:aSelector put:trapMethod.
        orgClass methodDictionary:dict.
        newClass := orgClass superclass.
    ] ifFalse:[
        myMetaclass := orgClass class.

        newClass := myMetaclass copy new.
        newClass setSuperclass:orgClass superclass.
        newClass instSize:orgClass instSize.
        newClass flags:orgClass flags.
        newClass setClassVariableString:orgClass classVariableString.
        newClass setSharedPoolNames:(orgClass sharedPoolNames).
        newClass setInstanceVariableString:orgClass instanceVariableString.
        newClass setName:orgClass name.
        newClass setCategory:orgClass category.
        newClass methodDictionary:dict.

        orgClass setSuperclass:newClass.
        orgClass setClassVariableString:''.
        orgClass setInstanceVariableString:''.
        orgClass setCategory:#'* trapping *'.

        dict := MethodDictionary new:1.
        dict at:aSelector put:trapMethod.
        orgClass methodDictionary:dict.
    ].
    trapMethod changeLiteral:(newClass superclass) to:newClass.

    ObjectMemory flushCaches.

    "
     MessageTracer
                wrapClass:Point
                 selector:#scaleBy:
                   onEntry:nil
                    onExit:[:con :retVal |
                               Transcript show:'leave Point>>scaleBy:; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     (1@2) scaleBy:5.
     MessageTracer untrapClass:Point selector:#scaleBy:.
     (1@2) scaleBy:5.
    "
    "
     MessageTracer
                wrapClass:Integer
                 selector:#factorial
                   onEntry:[:con |
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               Transcript show:'leave Integer>>factorial; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer untrapClass:Integer selector:#factorial.
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "
    "
     |lvl|

     lvl := 0.
     MessageTracer
                wrapClass:Integer
                 selector:#factorial
                   onEntry:[:con |
                               Transcript spaces:lvl. lvl := lvl + 2.
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               lvl := lvl - 2. Transcript spaces:lvl.
                               Transcript show:('leave ' , con receiver printString , '>>factorial; returning:').
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer untrapClass:Integer selector:#factorial.
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "

    "Modified: / 25-06-1996 / 22:01:05 / stefan"
    "Modified: / 01-07-2011 / 10:01:59 / cg"
! !

!MessageTracer class methodsFor:'cleanup'!

cleanup
    "if you forgot which classes/methods where wrapped and/or trapped,
     this cleans up everything ..."

    ObjectCopyHolders := nil.
    MethodCounts := MethodMemoryUsage := MethodTiming := TimeForWrappers := nil.

    self untrapAllClasses.
    self unwrapAllMethods.

    "
     MessageTracer cleanup
    "
! !

!MessageTracer class methodsFor:'execution trace'!

debugTrace:aBlock
    "trace execution of aBlock. This is for system debugging only;
     The trace output is a low level trace generated in the VM."

    ObjectMemory sendTraceOn.
    ^ aBlock ensure:[ObjectMemory sendTraceOff]

    "
     MessageTracer debugTrace:[#(6 5 4 3 2 1) sort]
    "

    "Modified: / 31.7.1998 / 16:39:43 / cg"
!

trace:aBlock
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block."

     ^ self trace:aBlock on:Processor activeProcess stderr

    "
     MessageTracer trace:[#(6 5 4 3 2 1) sort]
    "
!

trace:aBlock on:aStream
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block."

    ^ PrintingMessageTracer new
	output:aStream;
	trace:aBlock detail:false.

    "
     MessageTracer trace:[#(6 5 4 3 2 1) sort] on:Transcript
    "
!

traceFull:aBlock
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block.
     The trace information is more detailed."

     ^ self traceFull:aBlock on:Processor activeProcess stderr

    "
     MessageTracer traceFull:[#(6 5 4 3 2 1) sort]
    "
!

traceFull:aBlock on:aStream
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block.
     The trace information is more detailed."

     ^ PrintingMessageTracer new
	output:aStream;
	trace:aBlock detail:true.

    "
     MessageTracer traceFull:[#(6 5 4 3 2 1) sort]
    "
!

traceFullIndented:aBlock
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block.
     The trace information is more detailed."

     ^ self traceFullIndented:aBlock on:Processor activeProcess stderr

    "
     MessageTracer traceFullIndented:[ #(6 5 4 3 2 1) sort ]
    "
!

traceFullIndented:aBlock on:aStream
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block.
     The trace information is more detailed."

     ^ PrintingMessageTracer new
	output:aStream;
	trace:aBlock detail:#fullIndent.

    "
     MessageTracer traceFullIndented:[ #(6 5 4 3 2 1) sort ]
    "
!

traceIndented:aBlock
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block."

     ^ self traceIndented:aBlock on:Processor activeProcess stderr

    "
     MessageTracer traceIndented:[ #(6 5 4 3 2 1) sort ]
    "
!

traceIndented:aBlock on:aStream
    "evaluate aBlock sending trace information to stdout.
     Return the value of the block."

     ^ PrintingMessageTracer new
	output:aStream;
	trace:aBlock detail:#indent.

    "
     MessageTracer traceIndented:[ #(6 5 4 3 2 1) sort ] on:Transcript
    "
! !

!MessageTracer class methodsFor:'method breakpointing'!

trapClass:aClass selector:aSelector
    "arrange for the debugger to be entered when a message with aSelector is
     sent to instances of aClass (or subclass instances). Use untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    self trapMethod:(aClass compiledMethodAt:aSelector)

    "
     MessageTracer trapClass:Collection selector:#select:.
     Dictionary new select:[:e | ].       'not caught - Dictionary has its own select'.
     (Array new:10) select:[:e | ].       'not caught - SeqColl has its own select'.
     Set new select:[:e | ].              'caught - Set inherits this from Collection'.
     MessageTracer untrapClass:Collection
    "
!

trapMethod:aMethod
    "arrange for the debugger to be entered when aMethod is about to be executed.
     The trap is enabled for any process - see #trapMethod:inProcess: for a more
     selective breakPoint.
     Use unwrapMethod or untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    ^ self wrapMethod:aMethod
	      onEntry:BreakBlock
	       onExit:LeaveBreakBlock.

    "
     MessageTracer trapMethod:(Collection compiledMethodAt:#select:).
     Dictionary new select:[:e | ].       'not caught - Dictionary has its own select'.
     (Array new:10) select:[:e | ].       'not caught - SeqColl has its own select'.
     Set new select:[:e | ].              'caught - Set inherits this from Collection'.
     MessageTracer unwrapMethod:(Collection compiledMethodAt:#select:).
    "

    "Modified: 22.10.1996 / 17:39:58 / cg"
!

trapMethod:aMethod after:countInvocations
    "arrange for the debugger to be entered when aMethod has been invoked countInvocations times.
     The trap is enabled for any process.
     Use unwrapMethod or untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    |n|

    n := 0.
    ^ self wrapMethod:aMethod
	      onEntry:[:con | n := n + 1.
			      n > countInvocations
			      ifTrue:[
				BreakpointSignal raiseRequestWith:nil errorString:nil in:con
			      ]
		      ]
	       onExit:LeaveBreakBlock.

!

trapMethod:aMethod forInstancesOf:aClass
    "arrange for the debugger to be entered when aMethod is about to be executed
     for an instance of aClass.
     Use unwrapMethod or untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    ^ self wrapMethod:aMethod
	      onEntry:[:con |
			 (con receiver isMemberOf:aClass) ifTrue:[
			     BreakpointSignal raiseRequestWith:nil errorString:nil in:con
			 ]
		      ]
	       onExit:LeaveBreakBlock.

    "
     MessageTracer trapMethod:(View compiledMethodAt:#redraw) forInstancesOf:myView.
    "

    "Modified: 22.10.1996 / 17:40:03 / cg"
!

trapMethod:aMethod if:conditionBlock
    "arrange for the debugger to be entered when aMethod has been invoked and conditionBlock
     evaluates to true.
     The trap is enabled for any process.
     Use unwrapMethod or untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    ^ self
	wrapMethod:aMethod
	onEntry:[:con |
	    |conditionFires|

	    Error handle:[:ex |
		'MessageTrace: error in breakpoint condition caught: ' errorPrint.
		ex description errorPrintCR.
	    ] do:[
		conditionBlock numArgs == 1 ifTrue:[
		    conditionFires := conditionBlock value:con
		] ifFalse:[
		    conditionFires := conditionBlock value:con value:aMethod
		].
	    ].
	    conditionFires == true ifTrue:[
		BreakpointSignal raiseRequestWith:nil errorString:nil in:con
	    ]
	]
	onExit:LeaveBreakBlock.

    "Created: / 18-08-2000 / 22:09:10 / cg"
    "Modified: / 20-10-2010 / 09:38:57 / cg"
!

trapMethod:aMethod inProcess:aProcess
    "arrange for the debugger to be entered when aMethod is about to be executed,
     but only, if executed aProcess or one of aProcess's offspring.
     This allows for breakpoints to be set on system-critical code.
     The trap will only fire for selected processes (making browsers etc. still usable).
     Use unwrapMethod or untrapClass to remove this trap.
     Be careful, to not place a trap on code needed in the debugger (i.e. on scrollBars etc.);
     if there is a need to trap those, use the low-level wrap-methods, and put a check into the
     entry/leave blocks."

    ^ self wrapMethod:aMethod
	      onEntry:[:con |
			(Processor activeProcess processGroupId = aProcess id) ifTrue:[
			    BreakpointSignal raiseRequestWith:nil errorString:nil in:con
			]
		      ]
	       onExit:LeaveBreakBlock.

    "Created: 14.10.1996 / 15:38:46 / cg"
    "Modified: 22.10.1996 / 17:40:06 / cg"
!

untrapAllClasses
    "remove any traps on any class"

    Smalltalk allClassesDo:[:aClass |
	self untrapClass:aClass
    ]

    "
     MessageTracer untrapAllClasses
    "
!

untrapClass:aClass
    "remove any traps on aClass"

    "this is done by just patching the class back to the original"

    |orgClass|

    aClass category == #'* trapping *' ifFalse:[
	^ self
    ].
    orgClass := aClass superclass.

    aClass setSuperclass:orgClass superclass.
    aClass setClassVariableString:orgClass classVariableString.
    aClass setSharedPoolNames:(orgClass sharedPoolNames).
    aClass setInstanceVariableString:orgClass instanceVariableString.
    aClass setCategory:orgClass category.
    aClass methodDictionary:orgClass methodDictionary.

    ObjectMemory flushCaches.

    "
     MessageTracer untrapClass:Point
    "

    "Modified: / 05-06-1996 / 13:57:39 / stefan"
    "Modified: / 18-01-2011 / 20:43:50 / cg"
!

untrapClass:aClass selector:aSelector
    "remove trap of aSelector sent to aClass"

    |dict|

    aClass category == #'* trapping *' ifFalse:[
	^ self
    ].

    dict := aClass methodDictionary.
    dict at:aSelector ifAbsent:[^ self].

    ObjectMemory flushCaches. "avoid calling the old trap method"

    dict size == 1 ifTrue:[
	"the last trapped method"
	^ self untrapClass:aClass
    ].
    dict removeKey:aSelector.
    aClass methodDictionary:dict.

    "
     MessageTracer trapClass:Point selector:#copy.
     (1@2) copy.
     (1@2) deepCopy.
     MessageTracer trapClass:Point selector:#deepCopy.
     (1@2) copy.
     (1@2) deepCopy.
     MessageTracer untrapClass:Point selector:#copy.
     (1@2) copy.
     (1@2) deepCopy.
     MessageTracer untrapClass:Point selector:#deepCopy.
     (1@2) copy.
     (1@2) deepCopy.
    "

    "Modified: 5.6.1996 / 14:00:55 / stefan"
    "Modified: 10.9.1996 / 20:06:29 / cg"
!

untrapMethod:aMethod
    "remove break on aMethod"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self unwrapMethod:aMethod
! !

!MessageTracer class methodsFor:'method breakpointing - new'!

breakMethod: method atLine: line
    "Installs new breakpoint in given method at given line.
     Returns the installed breakpoint or nil if none could be
     installed"

    | analyzer map lines i breakpoint table |

    (ConfigurableFeatures includesFeature: #VMBreakpointSupport) ifFalse:[
	self error: 'Breakpoint support not present'.
	^nil.
    ].

    analyzer := BreakpointAnalyzer parseMethodSilent: method source in: method mclass.
    map := analyzer messageSendMap.
    lines := map keys asSortedCollection.
    i := lines indexForInserting: line.
    i > lines size ifTrue:[
	^nil
    ].
    breakpoint := Breakpoint new line: (lines at: i).
    breakpoint breaksToIgnore: (((map at: breakpoint line) size - 1) max: 0).

    table := method breakpointTable.
    table isNil ifTrue:[
	"/old way:
	"/table := Array with: (breakpoint line) with: breakpoint.

	"/new way:
	table := Array with: breakpoint.
    ] ifFalse:[
	"/old way:
	"/table := table, (Array with: (breakpoint line) with: breakpoint).

	"/new way:
	table := table copyWith: breakpoint
    ].
    method breakpointTable: table.

    ^breakpoint

    "Created: / 16-04-2013 / 00:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-04-2013 / 19:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracer class methodsFor:'method counting'!

countMethod:aMethod
    "arrange for a aMethod's execution to be counted.
     Use unwrapMethod to remove this."

    MethodCounts isNil ifTrue:[
	MethodCounts := IdentityDictionary new.
    ].
    MethodCounts at:aMethod put:0.

    ^ self wrapMethod:aMethod
	 onEntry:[:con |
			|cnt|

			cnt := MethodCounts at:aMethod ifAbsent:0.
			MethodCounts at:aMethod put:(cnt + 1).
			MessageTracer changed:#statistics: with:aMethod.
			aMethod changed:#statistics
		 ]
	 onExit:nil

    "
     MessageTracer countMethod:(Integer compiledMethodAt:#factorial).
     5 factorial.
     MessageTracer executionCountOf:(Integer compiledMethodAt:#factorial) printNL.
     MessageTracer stopCountingMethod:(Integer compiledMethodAt:#factorial)
    "

    "Created: / 15.12.1995 / 10:57:49 / cg"
    "Modified: / 27.7.1998 / 10:47:46 / cg"
!

countMethodByReceiverClass:aMethod
    "arrange for a aMethod's execution to be counted and maintain
     a per-receiver class profile.
     Use unwrapMethod to remove this."

    MethodCountsPerReceiverClass isNil ifTrue:[
	MethodCountsPerReceiverClass := IdentityDictionary new.
    ].
    MethodCountsPerReceiverClass at:aMethod put:(IdentityDictionary new).

    ^ self wrapMethod:aMethod
	 onEntry:[:con |
			|cls perMethodCounts cnt|

			cls := (con receiver class).
			perMethodCounts := MethodCountsPerReceiverClass at:aMethod.
			cnt := perMethodCounts at:cls ifAbsentPut:0.
			perMethodCounts at:cls put:(cnt + 1).
			MessageTracer changed:#statistics: with:aMethod.
			aMethod changed:#statistics
		 ]
	 onExit:nil

    "
     MessageTracer countMethodWithReceiverStatistic:(Collection compiledMethodAt:#detect:).
     NewSystemBrowser open.
     MessageTracer executionCountsOf:(Collection compiledMethodAt:#detect:) printNL.
     MessageTracer stopCountingMethod:(Collection compiledMethodAt:#detect:)
    "
!

executionCountOfMethod:aMethod
    "return the current count"

    |count counts|

    MethodCounts notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    count := MethodCounts at:aMethod originalMethod ifAbsent:nil.
	    count notNil ifTrue:[^ count].
	].
	^ MethodCounts at:aMethod ifAbsent:0
    ].
    MethodCountsPerReceiverClass notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    counts := MethodCountsPerReceiverClass at:aMethod originalMethod ifAbsent:nil.
	].
	counts isNil ifTrue:[
	    counts := MethodCounts at:aMethod ifAbsent:#().
	].
	^ (counts collect:[:eachClassCountAssoc | eachClassCountAssoc value]) sum
    ].
    ^ 0
!

executionCountsByReceiverClassOfMethod:aMethod
    "return a collection mapping receiver class to call counts"

    |counts|

    MethodCountsPerReceiverClass notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    counts := MethodCountsPerReceiverClass at:aMethod originalMethod ifAbsent:nil.
	].
	counts isNil ifTrue:[
	    counts := MethodCounts at:aMethod ifAbsent:#().
	].
	^ counts
    ].
    ^ #()
!

resetCountOfMethod:aMethod
    "return the current count"

    MethodCounts notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodCounts at:aMethod originalMethod put:0.
	].
    ].

    "Created: / 30.7.1998 / 17:42:08 / cg"
!

stopCountingMethod:aMethod
    "remove counting of aMethod"

    MethodCounts notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodCounts removeKey:aMethod originalMethod ifAbsent:nil.
	].
    ].
    MethodCountsPerReceiverClass notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodCountsPerReceiverClass removeKey:aMethod originalMethod ifAbsent:nil.
	].
    ].
    ^ self unwrapMethod:aMethod

    "Modified: 15.12.1995 / 15:43:53 / cg"
! !

!MessageTracer class methodsFor:'method memory usage'!

countMemoryUsageOfMethod:aMethod
    "arrange for aMethod's memory usage to be counted.
     Use unwrapMethod to remove this."

    |oldPriority oldScavengeCount oldNewUsed|

    MethodCounts isNil ifTrue:[
        MethodCounts := IdentityDictionary new.
    ].
    MethodMemoryUsage isNil ifTrue:[
        MethodMemoryUsage := IdentityDictionary new.
    ].

    MethodCounts at:aMethod put:0.
    MethodMemoryUsage at:aMethod put:0.

    ^ self wrapMethod:aMethod
         onEntry:[:con |
                        oldPriority := Processor activeProcess changePriority:(Processor userInterruptPriority).
                        oldNewUsed := ObjectMemory newSpaceUsed.
                        oldScavengeCount := ObjectMemory scavengeCount.
                 ]
         onExit:[:con :retVal |
             |cnt memUse scavenges|

             memUse := ObjectMemory newSpaceUsed - oldNewUsed.
             scavenges := ObjectMemory scavengeCount - oldScavengeCount.
             scavenges ~~ 0 ifTrue:[
                memUse := memUse + (ObjectMemory newSpaceSize * scavenges)
             ].

             MethodCounts notNil ifTrue:[
                 cnt := MethodCounts at:aMethod ifAbsent:0.
                 MethodCounts at:aMethod put:(cnt + 1).
             ].
             MethodMemoryUsage notNil ifTrue:[
                 cnt := MethodMemoryUsage at:aMethod ifAbsent:0.
                 MethodMemoryUsage at:aMethod put:(cnt + memUse).
             ].
             Processor activeProcess priority:oldPriority.
             MessageTracer changed:#statistics: with:aMethod.
             aMethod changed:#statistics.
             retVal
         ]
         onUnwind:[
             oldPriority notNil ifTrue:[
                 Processor activeProcess priority:oldPriority
             ]
         ]

    "
     MessageTracer countMemoryUsageOfMethod:(Integer compiledMethodAt:#factorialR).
     3 factorialR.
     Transcript showCR:(MessageTracer memoryUsageOfMethod:(Integer compiledMethodAt:#factorialR)).
     MessageTracer stopCountingMemoryUsageOfMethod:(Integer compiledMethodAt:#factorialR)
    "

    "Created: / 18.12.1995 / 15:41:27 / stefan"
    "Modified: / 18.12.1995 / 21:46:48 / stefan"
    "Modified: / 27.7.1998 / 10:47:38 / cg"
!

isCountingMemoryUsage:aMethod
    "return true if aMethod is counting memoryUsage"

    MethodMemoryUsage isNil ifTrue:[^ false].
    (MethodMemoryUsage includesKey:aMethod) ifTrue:[^ true].
    aMethod isWrapped ifTrue:[
	^ MethodMemoryUsage includesKey:aMethod originalMethod
    ].
    ^ false

    "Created: 18.12.1995 / 15:51:49 / stefan"
!

memoryUsageOfMethod:aMethod
    "return the current count"

    |count memUse orgMethod|

    (MethodCounts isNil or:[MethodMemoryUsage isNil]) ifTrue:[^ 0].
    aMethod isWrapped ifTrue:[
	orgMethod := aMethod originalMethod.
	count := MethodCounts at:orgMethod ifAbsent:nil.
	memUse := MethodMemoryUsage at:orgMethod ifAbsent:nil.
    ].
    memUse isNil ifTrue:[
	count := MethodCounts at:aMethod ifAbsent:0.
	memUse := MethodMemoryUsage at:aMethod ifAbsent:0.
    ].
    count = 0 ifTrue:[^ 0].
    ^ memUse//count

    "Modified: 18.12.1995 / 16:25:51 / stefan"
!

resetMemoryUsageOfMethod:aMethod
    "reset the current usage"

    |orgMethod|

    MethodCounts notNil ifTrue:[
	MethodMemoryUsage notNil ifTrue:[
	    aMethod isWrapped ifTrue:[
		orgMethod := aMethod originalMethod.
		MethodCounts at:orgMethod put:0.
		MethodMemoryUsage at:orgMethod put:nil.
	    ]
	].
    ].

    "Created: / 30.7.1998 / 17:43:07 / cg"
!

stopCountingMemoryUsageOfMethod:aMethod
    "remove counting memory of aMethod"

    |orgMethod|

    MethodCounts notNil ifTrue:[
	MethodMemoryUsage notNil ifTrue:[
	    aMethod isWrapped ifTrue:[
		orgMethod := aMethod originalMethod.
		MethodCounts removeKey:orgMethod ifAbsent:nil.
		MethodMemoryUsage removeKey:orgMethod ifAbsent:nil.
	    ]
	].
    ].
    ^ self unwrapMethod:aMethod

    "Modified: 18.12.1995 / 21:54:36 / stefan"
! !

!MessageTracer class methodsFor:'method mocking'!

mock: selector in: class do: block
    | method |

    method := class compiledMethodAt: selector ifAbsent: [ self error:'No such mnethod' ].
    ^ self mockMethod: method do: block

    "Created: / 28-07-2014 / 23:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2014 / 09:44:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mockMethod: method do: block
    "Temporarily change the behaviour of the given method to perform the given block instead 
     of the method's code. The value of the block is returned as the method's return value.
     The behaviour is changed only for current thread, i.e., thread the calling this methood
     and its child threads.

     The block gets the receiver as the first argument, followed by method parameters
     and then - optionally - the original method object.

     Do not forget to 'unmock' by means of #unmockMethod: or #unmockAllMethods

     CAVEAT: The 'current thread and its child threads' detection is done by walking
             threads along their #creatorId. However, when the parent thread dies, 
             the link if broken and thus 'and its child threads' may not work 100%. 
             For the calling thread itself, mocking should work reliably.
    "

    | selector class trapMethod spec src dict sel saveUS xselector|

    CallingLevel := 0.

    "
     create a new method, which calls the original one,
     but only if not already being trapped.
    "
    (method isNil or:[method isWrapped]) ifTrue:[
        ^ method
    ].
    method isLazyMethod ifTrue:[
        method makeRealMethod
    ].

    "
     get class/selector
    "
    class := method containingClass.
    class isNil ifTrue:[
        self error:'cannot place trap (no containing class found)' mayProceed:true.
        ^ method
    ].
    selector := class selectorAtMethod:method.
    
    WrappedMethod autoload. "/ for small systems

    "
     get a new method-spec
    "
    xselector := '_x'.
    method numArgs timesRepeat:[
        xselector := xselector , '_:'
    ].
    spec := Parser methodSpecificationForSelector:xselector.

    "
     create a method, executing the trap-blocks and the original method via a direct call
    "
    src := '%(spec)

    <context: #return>
    | currentProcess mock mockedVal context args marker | 

    context := thisContext.
    currentProcess := Processor activeProcess.
    mock := false.
    marker := #mockedMethodMarker yourself.

    [ mock not and:[currentProcess notNil] ] whileTrue:[ 
        mock := currentProcess id = %(pid).
        currentProcess := ProcessorScheduler knownProcesses detect:[:p | p id = currentProcess creatorId ] ifNone:[ nil ].
    ].
    mock ifTrue:[ 
        mockedVal := #replacementBlock yourself valueWithOptionalArguments: (((Array with: context receiver) , (context args)) copyWith: #originalMethod)
    ] ifFalse:[ 
        mockedVal := #originalMethod yourself
                        valueWithReceiver:(context receiver)
                        arguments:(context args)
                        selector:(context selector)
                        search:(context searchClass)
                        sender:nil.
    ].
    ^  mockedVal'.

    src := src expandPlaceholdersWith:
        (Dictionary new
            at: 'spec' put: spec;
            at: 'pid' put: Processor activeProcess id;
            yourself).
        
    saveUS := Compiler allowUnderscoreInIdentifier.
    ParserFlags
        withSTCCompilation:#never
        do:[
            [
                Compiler allowUnderscoreInIdentifier:true.
                Class withoutUpdatingChangesDo:[
                    trapMethod := Compiler
                                    compile:src
                                    forClass:UndefinedObject
                                    inCategory:method category
                                    notifying:nil
                                    install:false
                                    skipIfSame:false
                                    silent:false. "/ true.
                ]
            ] ensure:[
                Compiler allowUnderscoreInIdentifier:saveUS.
            ].
        ].

    trapMethod setPackage:method package.
    trapMethod changeClassTo:WrappedMethod.
    trapMethod register.

    "
     raising our eyebrows here ...
    "
    block notNil ifTrue:[
        trapMethod changeLiteral:#replacementBlock to: block.
    ].
    trapMethod changeLiteral:#originalMethod to:method.
    trapMethod changeLiteral:#mockedMethodMarker to: MockedMethodMarker.

    "
     change the source of this new method
     (to avoid confusion in the debugger ...)
    "
    trapMethod source: src.
"/    trapMethod sourceFilename:(method getSource) position:(method getSourcePosition).

    dict := class methodDictionary.
    sel := dict at:selector ifAbsent:[0].
    sel == 0 ifTrue:[
        self error:'oops, unexpected error' mayProceed:true.
        ^ method
    ].

    dict at:selector put:trapMethod.
    class methodDictionary:dict.
    ObjectMemory flushCaches.

    class changed:#methodTrap with:selector. "/ tell browsers
    MethodTrapChangeNotificationParameter notNil ifTrue:[
        Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:class changeSelector:selector).
    ].
    ^ trapMethod

    "
     MessageTracer
                mockMethod:(Color class compiledMethodAt:#magenta)
                do: [ :color |
                    Color red
                ].
     Color magenta.
     [ [ Color magenta inspect ] fork. Delay waitForSeconds: 1. ] fork.
     (Color class compiledMethodAt:#magenta) isMocked.
     MessageTracer unwrapMethod:(Color class compiledMethodAt:#magenta).
     Color magenta.    
    "

    "Created: / 29-07-2014 / 09:44:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2015 / 15:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmock: selector in: class 
    | method |

    method := class compiledMethodAt: selector ifAbsent: [ self error:'No such mnethod' ].
    ^ self unmockMethod: method

    "Created: / 29-07-2014 / 10:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmockAllMethods
    "Remove mocking wrapper from all methods, unconditionally. 
     May (should) be called in tearDdown of each testcase that
     uses method mocking"

    WrappedMethod allInstancesDo:[:method |
        method isMocked ifTrue:[    
            method unregister.
            self unwrapMethod: method.  
        ]        
    ]

    "Created: / 29-07-2014 / 10:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmockMethod: method
    "Remove mocking wrapper from a method, if it has been mocked by
     #mockMethod:do:"

    method isMocked ifTrue:[ 
        self unwrapMethod: method  
    ].

    "Created: / 29-07-2014 / 09:45:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracer class methodsFor:'method profiling'!

spyMethod:aMethod
    "arrange for given method to collect profiling data
     using message tally profiler.
     Use unwrapMethod to remove this.
    "

    self spyMethod: aMethod interval: MessageTally normalSamplingIntervalMS

    "Created: / 01-02-2015 / 09:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spyMethod:aMethod interval: anInteger
    "arrange for given method to collect profiling data
     using message tally profiler.
     Use unwrapMethod to remove this.
    "

    |selector class trapMethod s spec src dict sel saveUS xselector info |

    CallingLevel := 0.

    "
     create a new method, which calls the original one,
     but only if not already being trapped.
    "
    (aMethod isNil or:[aMethod isWrapped]) ifTrue:[
        ^ aMethod
    ].
    aMethod isLazyMethod ifTrue:[
        aMethod makeRealMethod
    ].

    "
     get class/selector
    "
    class := aMethod containingClass.
    class isNil ifTrue:[
        self error:'cannot place trap (no containing class found)' mayProceed:true.
        ^ aMethod
    ].
    selector := class selectorAtMethod:aMethod.

    WrappedMethod autoload. "/ for small systems

    "
     get a new method-spec
    "
    xselector := '_x'.
    aMethod numArgs timesRepeat:[
        xselector := xselector , '_:'
    ].
    spec := Parser methodSpecificationForSelector:xselector.


    info := MethodSpyInfo new.
    "
     create a method, executing the trap-blocks and the original method via a direct call
    "
    s := WriteStream on:''.
    s nextPutAll:spec.
    s nextPutAll:' <context: #return>'.
    s nextPutAll:' |retVal context| '.
    s nextPutAll:' context := thisContext.'.
    s nextPutAll: '#info profiler: (Tools::Profiler ? MessageTally) new.';
      nextPutAll: '#info profiler spyOn: [';
      nextPutAll:'retVal := #originalMethod yourself';
      nextPutAll:             ' valueWithReceiver:(context receiver)';
      nextPutAll:             ' arguments:(context args)';
      nextPutAll:             ' selector:(context selector)';
      nextPutAll:             ' search:(context searchClass)';
      nextPutAll:             ' sender:nil. ';
      nextPutAll:'] interval:'; nextPutAll: anInteger printString; nextPutAll: '.'.
    s nextPutAll:'^ retVal'; cr.

    src := s contents.
    saveUS := Compiler allowUnderscoreInIdentifier.
    ParserFlags
        withSTCCompilation:#never
        do:[
            [
                Compiler allowUnderscoreInIdentifier:true.
                Class withoutUpdatingChangesDo:[
                    trapMethod := Compiler
                                    compile:src
                                    forClass:UndefinedObject
                                    inCategory:aMethod category
                                    notifying:nil
                                    install:false
                                    skipIfSame:false
                                    silent:false. "/ true.
                ]
            ] ensure:[
                Compiler allowUnderscoreInIdentifier:saveUS.
            ].
        ].

    trapMethod setPackage:aMethod package.
    trapMethod changeClassTo:WrappedMethod.
    trapMethod register.

    "
     raising our eyebrows here ...
    "
    trapMethod changeLiteral:#info to: info. 
    trapMethod changeLiteral:#originalMethod to:aMethod.
    "
     change the source of this new method
     (to avoid confusion in the debugger ...)
    "
"/    trapMethod source:'this is a wrapper method - not the real one'.
    trapMethod sourceFilename:(aMethod getSource) position:(aMethod getSourcePosition).

    dict := class methodDictionary.
    sel := dict at:selector ifAbsent:[0].
    sel == 0 ifTrue:[
        self error:'oops, unexpected error' mayProceed:true.
        ^ aMethod
    ].

    dict at:selector put:trapMethod.
    class methodDictionary:dict.
    ObjectMemory flushCaches.

    class changed:#methodTrap with:selector. "/ tell browsers
    MethodTrapChangeNotificationParameter notNil ifTrue:[
        Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:class changeSelector:selector).
    ].
    ^ trapMethod

    "
     MessageTracer
                wrapMethod:(Point compiledMethodAt:#scaleBy:)
                   onEntry:nil
                    onExit:[:con :retVal |
                               Transcript show:'leave Point>>scaleBy:; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     (1@2) scaleBy:5.
     MessageTracer unwrapMethod:(Point compiledMethodAt:#scaleBy:).
     (1@2) scaleBy:5.
    "
    "
     MessageTracer
                wrapMethod:(Integer compiledMethodAt:#factorial)
                   onEntry:[:con |
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               Transcript show:'leave Integer>>factorial; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer unwrapMethod:(Integer compiledMethodAt:#factorial).
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "
    "
     |lvl|

     lvl := 0.
     MessageTracer
                wrapMethod:(Integer compiledMethodAt:#factorial)
                   onEntry:[:con |
                               Transcript spaces:lvl. lvl := lvl + 2.
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               lvl := lvl - 2. Transcript spaces:lvl.
                               Transcript show:('leave ' , con receiver printString , '>>factorial; returning:').
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer unwrapMethod:(Integer compiledMethodAt:#factorial).
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "

    "Created: / 01-02-2015 / 09:22:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracer class methodsFor:'method timing'!

executionTimesOfMethod:aMethod
    "return the current gathered execution time statistics"

    |info|

    MethodTiming notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    info := ( MethodTiming at:(aMethod originalMethod) ifAbsent:nil ) copy.
	].
    ].

    info isNil ifTrue:[ info := MethodTimingInfo new ].
    ^ info

    "Created: / 17-06-1996 / 17:07:30 / cg"
    "Modified: / 05-03-2007 / 15:46:17 / cg"
!

resetExecutionTimesOfMethod:aMethod
    "reset the gathered execution times statistics for aMethod;
     the method remains wrapped."

    MethodTiming notNil ifTrue:[
	MethodTiming removeKey:aMethod.
	aMethod isWrapped ifTrue:[
	    MethodTiming removeKey:aMethod originalMethod.
	].
    ].

    "Created: / 30-07-1998 / 17:12:35 / cg"
    "Modified: / 05-03-2007 / 15:36:59 / cg"
!

stopTimingMethod:aMethod
    "remove timing of aMethod"

    ^ self unwrapMethod:aMethod

    "Modified: 15.12.1995 / 15:43:53 / cg"
    "Created: 17.6.1996 / 17:04:03 / cg"
!

timeMethod:aMethod
    "arrange for a aMethod's execution time to be measured.
     Use unwrapMethod: or stopTimingMethod: to remove this."

    |t0|

    MethodTiming isNil ifTrue:[
	MethodTiming := IdentityDictionary new.
    ].
    MethodTiming removeKey:aMethod ifAbsent:nil.

    TimeForWrappers isNil ifTrue:[
	self getTimeForWrappers
    ].

    ^ self wrapMethod:aMethod
	 onEntry:[:con |
			t0 := OperatingSystem getMicrosecondTime.
		 ]
	 onExit:[:con :retVal |
			|info t cnt minT maxT sumTimes|

			t := OperatingSystem getMicrosecondTime - t0.
			t := t - TimeForWrappers.
			t < 0 ifTrue:[t := 0].
			t := t / 1000.0.

			MethodTiming isNil ifTrue:[
			    MethodTiming := IdentityDictionary new.
			].
			info := MethodTiming at:aMethod ifAbsent:nil.
			info isNil ifTrue:[
			    MethodTiming at:aMethod put:(info := MethodTimingInfo new)
			] ifFalse:[
			    info rememberExecutionTime:t.
			].
			MessageTracer changed:#statistics: with:aMethod.
			aMethod changed:#statistics.
			retVal
		]

    "
     MessageTracer timeMethod:(Integer compiledMethodAt:#factorial).
     5 factorial.
     5 factorial.
     5 factorial.
     (MessageTracer executionTimesOfMethod:(Integer compiledMethodAt:#factorial)) printCR.
     MessageTracer stopTimingMethod:(Integer compiledMethodAt:#factorial)
    "

    "Created: / 17-06-1996 / 17:03:50 / cg"
    "Modified: / 05-03-2007 / 15:34:01 / cg"
! !

!MessageTracer class methodsFor:'method tracing'!

traceClass:aClass selector:aSelector
    "arrange for a trace message to be output on Stderr, when a message with aSelector is
     sent to instances of aClass (or subclass instances). Use untraceClass to remove this."

    self traceClass:aClass selector:aSelector on:Processor activeProcess stderr

    "
     MessageTracer traceClass:Integer selector:#factorial.
     5 factorial.
     MessageTracer untraceClass:Integer
    "
    "
     MessageTracer traceClass:SequenceableCollection selector:#quickSortFrom:to:.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceClass:SequenceableCollection
    "
    "
     MessageTracer traceClass:Array selector:#at:.
     MessageTracer traceClass:Array selector:#at:put:.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceClass:Array
    "
!

traceClass:aClass selector:aSelector on:aStream
    "arrange for a trace message to be output on aStream, when a message with aSelector is
     sent to instances of aClass (or subclass instances). Use untraceClass to remove this."

    self traceMethod:(aClass compiledMethodAt:aSelector) on:aStream

    "
     MessageTracer traceClass:Integer selector:#factorial on:Transcript.
     5 factorial.
     MessageTracer untraceClass:Integer
    "
    "
     MessageTracer traceClass:Integer selector:#factorialR on:Transcript.
     5 factorialR.
     MessageTracer untraceClass:Integer
    "

!

traceMethod:aMethod
    "arrange for a trace message to be output on Stderr,
     when aMethod is executed. Traces both entry and exit.
     Use unwrapMethod to remove this."

    ^ self traceMethod:aMethod on:Processor activeProcess stderr

    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorial).
     5 factorial.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorial)
    "
    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorialR).
     5 factorialR.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorialR)
    "
    "
     MessageTracer traceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
    "
    "
     don't do this:
    "
    "
     MessageTracer traceMethod:(Object compiledMethodAt:#at:).
     MessageTracer traceMethod:(Object compiledMethodAt:#at:put:).
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(Object compiledMethodAt:#at:).
     MessageTracer untraceMethod:(Object compiledMethodAt:#at:put:).
    "
!

traceMethod:aMethod on:aStream
    "arrange for a trace message to be output on aStream,
     when aMethod is executed. Traces both entry and exit.
     Use unwrapMethod to remove this."

    |lvl inside|

    ^ self wrapMethod:aMethod
	 onEntry:[:con |
			inside isNil ifTrue:[
			    inside := true.
			    CallingLevel isNil ifTrue:[
				CallingLevel := 0.
			    ].
			    lvl notNil ifTrue:[
				lvl := lvl + 1
			    ] ifFalse:[
				CallingLevel := lvl := CallingLevel + 1.
			    ].
			    MessageTracer printEntryFull:con level:lvl on:aStream.
			    inside := nil
			]
		 ]
	 onExit:[:con :retVal |
			inside isNil ifTrue:[
			    inside := true.
			    MessageTracer printExit:con with:retVal level:lvl on:aStream.
			    CallingLevel := lvl := lvl - 1.
			    inside := nil
			].
			retVal
		]

    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorial) on:Transcript.
     5 factorial.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorial)
    "
    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorialR) on:Transcript.
     5 factorialR.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorialR)
    "
    "
     MessageTracer traceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:) on:Transcript.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
    "
!

traceMethodAll:aMethod
    "arrange for a full trace message to be output on Stderr, when aMethod is executed.
     Only the sender is traced on entry.
     Use untraceMethod to remove this trace.
     This is for system debugging only;
     The trace output is a low level trace generated in the VM."

    ^ self wrapMethod:aMethod
	      onEntry:[:con | ObjectMemory flushCaches. ObjectMemory sendTraceOn.]
	      onExit:[:con :retVal | ObjectMemory sendTraceOff. retVal]

    "Modified: / 31.7.1998 / 16:40:07 / cg"
!

traceMethodEntry:aMethod
    "arrange for a trace message to be output on stdErr,
     when aMethod is executed. Only entry is traced.
     Use unwrapMethod to remove this."

    ^ self traceMethodEntry:aMethod on:Processor activeProcess stderr

    "
     MessageTracer traceMethodEntry:(Integer compiledMethodAt:#factorial).
     5 factorial.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorial)
    "
    "
     MessageTracer traceMethodEntry:(Integer compiledMethodAt:#factorialR).
     5 factorialR.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorialR)
    "
    "
     MessageTracer traceMethodEntry:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
    "
!

traceMethodEntry:aMethod on:aStream
    "arrange for a trace message to be output on aStream,
     when aMethod is executed. Only entry is traced.
     Use unwrapMethod to remove this."

    |lvl inside|

    ^ self wrapMethod:aMethod
	 onEntry:[:con |
			inside isNil ifTrue:[
			    inside := true.
			    CallingLevel isNil ifTrue:[
				CallingLevel := 0.
			    ].
			    lvl notNil ifTrue:[
				lvl := lvl + 1
			    ] ifFalse:[
				CallingLevel := lvl := CallingLevel + 1.
			    ].
			    MessageTracer printEntryFull:con level:lvl on:aStream.
			    inside := nil
			]
		 ]
	 onExit:nil

    "
     MessageTracer traceMethodEntry:(Integer compiledMethodAt:#factorial) on:Transcript.
     5 factorial.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorial)
    "
    "
     MessageTracer traceMethodEntry:(Integer compiledMethodAt:#factorialR) on:Transcript.
     5 factorialR.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorialR)
    "
    "
     MessageTracer traceMethodEntry:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:) on:Transcript.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
    "
!

traceMethodFull:aMethod
    "arrange for a full trace message to be output on Stderr, when amethod is executed.
     Only the sender is traced on entry.
     Use untraceMethod to remove this trace."

    ^ self traceMethodFull:aMethod on:Processor activeProcess stderr

    "Created: 15.12.1995 / 18:19:31 / cg"
    "Modified: 22.10.1996 / 17:39:28 / cg"
!

traceMethodFull:aMethod on:aStream
    "arrange for a full trace message to be output on Stderr, when aMethod is executed.
     Only the sender is traced on entry.
     Use untraceMethod to remove this trace."

    ^ self
	wrapMethod:aMethod
	onEntry:(self traceFullBlockFor:aStream)
	onExit:LeaveTraceBlock.

    "Created: 15.12.1995 / 18:19:31 / cg"
    "Modified: 22.10.1996 / 17:39:28 / cg"
!

traceMethodSender:aMethod
    "arrange for a trace message to be output on Stderr,
     when amethod is executed.
     Only the sender is traced on entry.
     Use untraceMethod to remove this trace."

    ^ self traceMethodSender:aMethod on:Processor activeProcess stderr
!

traceMethodSender:aMethod on:aStream
    "arrange for a trace message to be output on Stderr, when amethod is executed.
     Only the sender is traced on entry.
     Use untraceMethod to remove this trace."

    ^ self
	wrapMethod:aMethod
	onEntry:(self traceSenderBlockFor:aStream)
	onExit:LeaveTraceBlock.

    "Modified: 22.10.1996 / 17:39:33 / cg"
!

traceUpdateMethod:aMethod on:aStream
    "arrange for a trace message to be output on aStream,
     when aMethod is executed.
     Traces both entry and exit.
     Use unwrapMethod to remove this.
     This one is specialized for change-update calling i.e. it traces from the update
     back to the origial change message."

    |lvl inside|

    ^ self
	wrapMethod:aMethod
	onEntry:[:con |
			inside isNil ifTrue:[
			    inside := true.
			    CallingLevel isNil ifTrue:[
				CallingLevel := 0.
			    ].
			    lvl notNil ifTrue:[
				lvl := lvl + 1
			    ] ifFalse:[
				CallingLevel := lvl := CallingLevel + 1.
			    ].
			    MessageTracer printUpdateEntryFull:con level:lvl on:aStream.
			    inside := nil
			]
		 ]
	onExit:[:con :retVal |
			inside isNil ifTrue:[
			    inside := true.
			    MessageTracer printExit:con with:retVal level:lvl on:aStream.
			    CallingLevel := lvl := lvl - 1.
			    inside := nil
			].
			retVal
		]
!

tracelogMethod:aMethod
    "arrange for a trace log entry to be appended to a standard log using
     Logger, when aMethod is executed. Traces both entry and exit.
     Use unwrapMethod to remove this."

    |lvl inside|

    ^ self wrapMethod:aMethod
         onEntry:[:con |
                        | msg |
                        inside isNil ifTrue:[
                            inside := true.
                            CallingLevel isNil ifTrue:[
                                CallingLevel := 0.
                            ].
                            lvl notNil ifTrue:[
                                lvl := lvl + 1
                            ] ifFalse:[
                                CallingLevel := lvl := CallingLevel + 1.
                            ].
                            msg := String streamContents:[:s|MessageTracer printEntryFull:con level:lvl on:s].
                            Logger log: msg severity: Logger severityENTER attachment: con args.
                            inside := nil
                        ]
                 ]
         onExit:[:con :retVal |
                        | msg |
                        inside isNil ifTrue:[
                            inside := true.
                            msg := String streamContents:[:s|MessageTracer printExit:con with:retVal level:lvl on:s].
                            Logger log: msg severity: Logger severityLEAVE attachment: retVal.
                            CallingLevel := lvl := lvl - 1.
                            inside := nil
                        ].
                        retVal
                ]

    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorial) on:Transcript.
     5 factorial.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorial)
    "
    "
     MessageTracer traceMethod:(Integer compiledMethodAt:#factorialR) on:Transcript.
     5 factorialR.
     MessageTracer untraceMethod:(Integer compiledMethodAt:#factorialR)
    "
    "
     MessageTracer traceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:) on:Transcript.
     #(6 1 9 66 2 17) copy sort.
     MessageTracer untraceMethod:(SequenceableCollection compiledMethodAt:#quickSortFrom:to:).
    "

    "Created: / 15-03-2013 / 11:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2014 / 15:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

untraceMethod:aMethod
    "remove tracing of aMethod"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self unwrapMethod:aMethod
! !

!MessageTracer class methodsFor:'method wrapping'!

unwrapAllMethods
    "just in case you don't know what methods have break/trace-points
     on them; this removes them all"

    WrappedMethod allInstancesDo:[:aWrapperMethod |
        aWrapperMethod unregister.
        self unwrapMethod:aWrapperMethod.
    ]

    "
     MessageTracer unwrapAllMethods
    "

    "Modified: / 01-07-2011 / 10:02:47 / cg"
!

unwrapMethod:aMethod
    "remove any wrapper on aMethod"

    |selector class originalMethod dict mthd|

    aMethod isWrapped ifTrue:[
	originalMethod := aMethod originalMethod.
    ].

    MethodCounts notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodCounts removeKey:originalMethod ifAbsent:nil.
	].
	MethodCounts removeKey:aMethod ifAbsent:nil.
	MethodCounts := MethodCounts asNilIfEmpty.
    ].
    MethodMemoryUsage notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodMemoryUsage removeKey:originalMethod ifAbsent:nil.
	].
	MethodMemoryUsage removeKey:aMethod ifAbsent:nil.
	MethodMemoryUsage := MethodMemoryUsage asNilIfEmpty.
    ].
    MethodTiming notNil ifTrue:[
	aMethod isWrapped ifTrue:[
	    MethodTiming removeKey:originalMethod ifAbsent:nil.
	].
	MethodTiming removeKey:aMethod ifAbsent:nil.
	MethodTiming := MethodTiming asNilIfEmpty.
    ].

    CallingLevel := 0.

    (aMethod isNil or:[aMethod isWrapped not]) ifTrue:[
	^ aMethod
    ].

    "
     get class/selector
    "
    class := aMethod containingClass.
    class isNil ifTrue:[
	'MessageTracer [info]: no containing class for method found' infoPrintCR.
	^ aMethod
    ].
    selector := class selectorAtMethod:aMethod.

    originalMethod isNil ifTrue:[
	self error:'oops, could not find original method' mayProceed:true.
	^ aMethod
    ].

    dict := class methodDictionary.
    mthd := dict at:selector ifAbsent:nil.
    mthd notNil ifTrue:[
	dict at:selector put:originalMethod.
	class methodDictionary:dict.
    ] ifFalse:[
	'MessageTracer [info]: no containing class for method found' infoPrintCR.
"/        self halt:'oops, unexpected error - cannot remove wrap'.
	aMethod becomeSameAs:originalMethod.
	^ aMethod
    ].

    ObjectMemory flushCaches.

    class changed:#methodTrap with:selector. "/ tell browsers
    MethodTrapChangeNotificationParameter notNil ifTrue:[
	Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:class changeSelector:selector).
    ].
    ^ originalMethod

    "Modified: / 05-06-1996 / 14:08:08 / stefan"
    "Modified: / 04-10-2007 / 16:41:01 / cg"
!

wrapMethod:aMethod onEntry:entryBlock onExit:exitBlock
    ^ self wrapMethod:aMethod onEntry:entryBlock onExit:exitBlock onUnwind:nil

    "Modified: 18.12.1995 / 15:58:12 / stefan"
!

wrapMethod:aMethod onEntry:entryBlock onExit:exitBlock onUnwind:unwindBlock
    "arrange for the two blocks entryBlock and exitBlock to be evaluated whenever
     aMethod is evaluated.
     EntryBlock will be called on entry, and gets the current context passed as argument.
     ExitBlock will be called, when the method is left, and gets the context and
     the methods return value as arguments.
     UnwindBlock will be called when the contxt of aMethod is unwound.
     If there is an unwindBlock, the entry and exitBlocks will be called within the unwind block,
     because allocating the unwindBlock uses memory and some users want to count allocated memory.
    "

    |selector class trapMethod s spec src dict sel saveUS xselector|

    CallingLevel := 0.

    "
     create a new method, which calls the original one,
     but only if not already being trapped.
    "
    (aMethod isNil or:[aMethod isWrapped]) ifTrue:[
        ^ aMethod
    ].
    aMethod isLazyMethod ifTrue:[
        aMethod makeRealMethod
    ].

    "
     get class/selector
    "
    class := aMethod containingClass.
    class isNil ifTrue:[
        self error:'cannot place trap (no containing class found)' mayProceed:true.
        ^ aMethod
    ].
    selector := class selectorAtMethod:aMethod.

    WrappedMethod autoload. "/ for small systems

    "
     get a new method-spec
    "
    xselector := '_x'.
    aMethod numArgs timesRepeat:[
        xselector := xselector , '_:'
    ].
    spec := Parser methodSpecificationForSelector:xselector.

    "
     create a method, executing the trap-blocks and the original method via a direct call
    "
    s := WriteStream on:''.
    s nextPutAll:spec.
    s nextPutAll:' <context: #return>'.
    s nextPutAll:' |retVal context| '.
    s nextPutAll:' context := thisContext.'.
    unwindBlock notNil ifTrue:[
        s nextPutAll:'['.
    ].
    entryBlock notNil ifTrue:[
        s nextPutAll:'#entryBlock yourself value:context. '.
    ].
    s nextPutAll:'retVal := #originalMethod yourself';
      nextPutAll:             ' valueWithReceiver:(context receiver)';
      nextPutAll:             ' arguments:(context args)';
      nextPutAll:             ' selector:(context selector)';
      nextPutAll:             ' search:(context searchClass)';
      nextPutAll:             ' sender:nil. '.

    exitBlock notNil ifTrue:[
        s nextPutAll:'^ #exitBlock yourself value:context value:retVal.'.
    ].
    unwindBlock notNil ifTrue:[
        s nextPutAll:'] ifCurtailed:#unwindBlock yourself.'.
    ].
    s nextPutAll:'^ retVal'; cr.

    src := s contents.
    saveUS := Compiler allowUnderscoreInIdentifier.
    ParserFlags
        withSTCCompilation:#never
        do:[
            [
                Compiler allowUnderscoreInIdentifier:true.
                Class withoutUpdatingChangesDo:[
                    trapMethod := Compiler
                                    compile:src
                                    forClass:UndefinedObject
                                    inCategory:aMethod category
                                    notifying:nil
                                    install:false
                                    skipIfSame:false
                                    silent:false. "/ true.
                ]
            ] ensure:[
                Compiler allowUnderscoreInIdentifier:saveUS.
            ].
        ].

    trapMethod setPackage:aMethod package.
    trapMethod changeClassTo:WrappedMethod.
    trapMethod register.

    "
     raising our eyebrows here ...
    "
    entryBlock notNil ifTrue:[
        trapMethod changeLiteral:#entryBlock to:entryBlock.
    ].
    trapMethod changeLiteral:#originalMethod to:aMethod.
    exitBlock notNil ifTrue:[
        trapMethod changeLiteral:#exitBlock to:exitBlock.
    ].
    unwindBlock notNil ifTrue:[
        trapMethod changeLiteral:#unwindBlock to:unwindBlock.
    ].
    "
     change the source of this new method
     (to avoid confusion in the debugger ...)
    "
"/    trapMethod source:'this is a wrapper method - not the real one'.
    trapMethod sourceFilename:(aMethod getSource) position:(aMethod getSourcePosition).

    dict := class methodDictionary.
    sel := dict at:selector ifAbsent:[0].
    sel == 0 ifTrue:[
        self error:'oops, unexpected error' mayProceed:true.
        ^ aMethod
    ].

    dict at:selector put:trapMethod.
    class methodDictionary:dict.
    ObjectMemory flushCaches.

    class changed:#methodTrap with:selector. "/ tell browsers
    MethodTrapChangeNotificationParameter notNil ifTrue:[
        Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:class changeSelector:selector).
    ].
    ^ trapMethod

    "
     MessageTracer
                wrapMethod:(Point compiledMethodAt:#scaleBy:)
                   onEntry:nil
                    onExit:[:con :retVal |
                               Transcript show:'leave Point>>scaleBy:; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     (1@2) scaleBy:5.
     MessageTracer unwrapMethod:(Point compiledMethodAt:#scaleBy:).
     (1@2) scaleBy:5.
    "
    "
     MessageTracer
                wrapMethod:(Integer compiledMethodAt:#factorial)
                   onEntry:[:con |
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               Transcript show:'leave Integer>>factorial; returning:'.
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer unwrapMethod:(Integer compiledMethodAt:#factorial).
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "
    "
     |lvl|

     lvl := 0.
     MessageTracer
                wrapMethod:(Integer compiledMethodAt:#factorial)
                   onEntry:[:con |
                               Transcript spaces:lvl. lvl := lvl + 2.
                               Transcript showCR:('entering ' , con receiver printString , '>>factorial').
                           ]
                    onExit:[:con :retVal |
                               lvl := lvl - 2. Transcript spaces:lvl.
                               Transcript show:('leave ' , con receiver printString , '>>factorial; returning:').
                               Transcript showCR:retVal printString.
                               Transcript endEntry
                           ].
     Transcript showCR:'5 factorial traced'.
     5 factorial.
     MessageTracer unwrapMethod:(Integer compiledMethodAt:#factorial).
     Transcript showCR:'5 factorial normal'.
     5 factorial.
    "

    "Modified: / 25-06-1996 / 22:04:51 / stefan"
    "Modified: / 01-07-2011 / 10:01:48 / cg"
! !

!MessageTracer class methodsFor:'object breakpointing'!

objectHasWraps:anObject
    "return true, if anObject has any wraps"

    ^ anObject class category == #'* trapping *'
!

realClassOf:anObject
    "return anObjects real class"

    (anObject class category == #'* trapping *') ifFalse:[
	^ anObject class
    ].
    ^ anObject class superclass
!

trap:anObject selector:aSelector
    "arrange for the debugger to be entered when a message with aSelector is
     sent to anObject. Use untrap to remove this trap.
     The current implementation does not allow integers or nil to be trapped."

    self wrap:anObject
	 selector:aSelector
	 onEntry:BreakBlock
	 onExit:LeaveBreakBlock.

    "
     |p|

     p := Point new.
     MessageTracer trap:p selector:#x:.
     p x:5
    "

    "Modified: 22.10.1996 / 17:39:41 / cg"
!

trap:anObject selectors:aCollection
    self wrap:anObject
	 selectors:aCollection
	 onEntry:BreakBlock
	 onExit:LeaveBreakBlock.

    "Modified: 22.10.1996 / 17:39:50 / cg"
!

trapAll:anObject
    "trap on all messages which are understood by anObject"

    self wrapAll:anObject
	 onEntry:BreakBlock
	 onExit:LeaveBreakBlock.

    "Modified: 22.10.1996 / 17:39:54 / cg"
!

trapAll:anObject from:aClass
    "trap on all messages defined in aClass sent to anObject"

    self trap:anObject selectors:aClass selectors

    "Modified: 5.6.1996 / 13:46:06 / stefan"
!

untrap:anObject
    "remove any traps on anObject"

    "this is done by just patching the objects class back to the original"

    |orgClass|

    orgClass := anObject class.
    orgClass category == #'* trapping *' ifFalse:[
	^ self
    ].

    anObject changeClassTo:orgClass superclass.
    ObjectCopyHolders notNil ifTrue:[
	ObjectCopyHolders removeKey:anObject ifAbsent:nil.
    ].

    "
     |p|

     p := Point new copy.
     MessageTracer trace:p selector:#x:.
     MessageTracer trace:p selector:#y:.
     p y:1.
     p x:2.
     MessageTracer untrap:p
     p y:2.
     p x:1.
    "

    "Modified: / 21.4.1998 / 15:43:33 / cg"
!

untrap:anObject selector:aSelector
    "remove trap on aSelector from anObject"

    |orgClass dict|

    orgClass := anObject class.
    orgClass category == #'* trapping *' ifFalse:[^ self].

    dict := orgClass methodDictionary.
    dict at:aSelector ifAbsent:[^ self].

    dict size == 1 ifTrue:[
	"the last trap got removed"
	anObject changeClassTo:orgClass superclass.
	ObjectCopyHolders notNil ifTrue:[
	    ObjectCopyHolders removeKey:anObject ifAbsent:nil.
	].
	^ self
    ].
    dict removeKey:aSelector.
    orgClass methodDictionary:dict.
    ObjectMemory flushCaches. "avoid calling the old trap method"

    "
     |p|

     p := Point new copy.
     MessageTracer trace:p selector:#x:.
     MessageTracer trace:p selector:#y:.
     'trace both ...' errorPrintNL.
     p x:2.
     p y:1.
     'trace only y ...' errorPrintNL.
     MessageTracer untrap:p selector:#x:.
     p x:2.
     p y:1.
     'trace none ...' errorPrintNL.
     MessageTracer untrap:p selector:#y:.
     p x:2.
     p y:1.
    "

    "Modified: / 5.6.1996 / 13:56:08 / stefan"
    "Modified: / 21.4.1998 / 15:43:55 / cg"
!

wrappedSelectorsOf:anObject
    "return the set of wrapped selectors (if any)"

    (anObject class category == #'* trapping *') ifFalse:[
	^ #()
    ].
    ^ anObject class selectors
! !

!MessageTracer class methodsFor:'object modification traps'!

trapModificationsIn:anObject
    "trap modifications in anObject"

    self
	trapModificationsIn:anObject filter:[:old :new | true]

    "
     |a|

     a := Array new:10.
     MessageTracer trapModificationsIn:a.

     a size.
     a at:1.
     a at:2 put:nil.   ' no trap here (nil already there) '.
     a at:2 put:2.     ' expect trap here (changing nil to 2) '.
     a at:2.
     a at:3.
     a at:2 put:2.      ' no trap here (2 already there) '.
     a at:2 put:3.      ' expect trap here (changing 2 to 3) '.
     MessageTracer untrace:a.
     a at:3 put:5.
    "

    "Created: / 21.4.1998 / 14:32:34 / cg"
    "Modified: / 21.4.1998 / 14:58:24 / cg"
!

trapModificationsIn:anObject filter:aFilterBlock
    "trap modifications in anObject"

    |allSelectors|

    allSelectors := IdentitySet new.
    anObject class withAllSuperclassesDo:[:aClass |
	aClass methodDictionary keys addAllTo:allSelectors
    ].

    self trapModificationsIn:anObject selectors:allSelectors filter:aFilterBlock

    "trap if arrays 5th slot is modified:

     |a|

     a := Array new:10.
     MessageTracer trapModificationsIn:a filter:[:old :new | (old at:5) ~~ (new at:5)].

     a size.
     a at:1.
     a at:2 put:nil.
     a at:2 put:2.
     a at:2.
     a at:3.
     a at:2 put:2.
     a at:2 put:3.
     a at:5 put:3.
     a at:5 put:3.
     MessageTracer untrace:a.
     a at:3 put:5.
    "

    "Modified: / 21.4.1998 / 15:53:38 / cg"
!

trapModificationsIn:anObject selector:aSelector filter:aFilterBlock
    "install a trap for modifications in anObject by aSelector-messages.
     the filterBlock will be invoked (after a modification) with the old and
     new values as arguments and should return true,
     if the debugger is really wanted."

    self
	trapModificationsIn:anObject
	selectors:(Array with:aSelector)
	filter:aFilterBlock

    "Modified: / 21.4.1998 / 15:34:44 / cg"
!

trapModificationsIn:anObject selectors:aCollectionOfSelectors filter:aFilterBlock
    "install a trap for modifications in anObject by aSelector-messages.
     the filterBlock will be invoked (after a modification) with the old and
     new values as arguments and should return true,
     if the debugger is really wanted."

    |copyHolder sels checkBlock|

    (anObject isNil
	or:[anObject isSymbol
	or:[anObject class == SmallInteger
	or:[anObject == true
	or:[anObject == false]]]])
    ifTrue:[
	self error:'cannot place trap on this object' mayProceed:true.
	^ self.
    ].

    ObjectCopyHolders isNil ifTrue:[
	ObjectCopyHolders := WeakIdentityDictionary new.
    ].
    copyHolder := ObjectCopyHolders at:anObject ifAbsent:nil.
    copyHolder isNil ifTrue:[
	ObjectCopyHolders at:anObject put:(copyHolder := ValueHolder new).
    ].

    copyHolder value:(anObject shallowCopy).

    "/ some required ones, which are used in the wrapped code and are known to
    "/ do no harm to the object ... consider this a kludge
    sels := aCollectionOfSelectors copy.
    sels removeAll:#(#class #species #yourself #'sameContentsAs:'
		     #'instVarAt:' #'at:' #'basicAt:'
		     #'shallowCopy' #'copy'
		     #'=' #'==' #'~=' #'~~'
		     #'size'
		    ).

    checkBlock :=
		   [:con :retVal |
			|oldValue|

			oldValue :=  copyHolder value.

			"/ compare with copy ...
			(anObject sameContentsAs:oldValue) ifFalse:[
			    "/ see oldValue vs. anObject
			    (aFilterBlock value:oldValue value:anObject) ifTrue:[
				copyHolder value:(anObject shallowCopy).
				ObjectWrittenBreakpointSignal
				    raiseRequestWith:(oldValue -> anObject)
				    errorString:('object was modififed in: ' , con sender selector)
				    in:con sender
			    ]
			]
		   ].

    sels do:[:aSelector |
	self
	    wrap:anObject
	    selector:aSelector
	    onEntry:[:con | ]
	    onExit:checkBlock
	    withOriginalClass:true
	    flushCaches:false.
    ].
    ObjectMemory flushCaches

    "Created: / 21.4.1998 / 15:34:05 / cg"
    "Modified: / 21.4.1998 / 16:00:39 / cg"
!

trapModificationsOf:anInstVarOrOffset in:anObject
    "trap modifications in anObject"

    |idx selectors definingClass|

    anInstVarOrOffset isInteger ifTrue:[
	"/ indexed slot
	self
	    trapModificationsIn:anObject filter:[:old :new | (old at:anInstVarOrOffset) ~~ (new at:anInstVarOrOffset)]
   ] ifFalse:[
	"/ instVar by name
	selectors := IdentitySet new.
	definingClass := anObject class whichClassDefinesInstVar:anInstVarOrOffset.

	definingClass withAllSuperclassesDo:[:aClass |
	    aClass methodDictionary keys addAllTo:selectors
	].
	idx := anObject class instVarIndexFor:anInstVarOrOffset.
	self
	    trapModificationsIn:anObject selectors:selectors filter:[:old :new | (old instVarAt:idx) ~~ (new instVarAt:idx)]
   ]

    "
     |a|

     a := Array new:10.
     MessageTracer trapModificationsOf:2 in:a.

     a size.
     a at:1.
     a at:2 put:nil.   ' no trap here (nil already there) '.
     a at:2 put:2.     ' expect trap here (changing nil to 2) '.
     a at:2.
     a at:3.
     a at:2 put:2.      ' no trap here (2 already there) '.
     a at:2 put:3.      ' expect trap here (changing nil to 2) '.
     a at:3.
     a at:3 put:3.      ' no trap here (index is different) '.
     MessageTracer untrace:a.
     a at:3 put:5.
    "
! !

!MessageTracer class methodsFor:'object tracing'!

trace:anObject selector:aSelector
    "arrange for a trace message to be output on Stderr, when a message with
     aSelector is sent to anObject. Both entry and exit are traced.
     Use untrap to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    self trace:anObject selector:aSelector on:Processor activeProcess stderr

    "
     |p|

     p := Point new.
     MessageTracer trace:p selector:#x:.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer trace:a selector:#at:put:.
     MessageTracer trace:a selector:#at:.
     a sort.
    "

    "Modified: / 21.4.1998 / 15:37:05 / cg"
!

trace:anObject selector:aSelector on:aStream
    "arrange for a trace message to be output on Stderr, when a message with
     aSelector is sent to anObject. Both entry and exit are traced.
     Use untrap to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    self
	trace:anObject
	selectors:(Array with:aSelector)
	on:aStream

    "
     |p|

     p := Point new.
     MessageTracer trace:p selector:#x: on:Stderr.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer trace:a selector:#at:put: on:Stderr.
     MessageTracer trace:a selector:#at:.    on:Stderr
     a sort.
    "

    "Modified: / 21.4.1998 / 15:37:05 / cg"
!

trace:anObject selectors:aCollectionOfSelectors
    "arrange for a trace message to be output on Stderr, when any message
     from aCollectionOfSelectors is sent to anObject.
     Both entry and exit are traced.
     Use untrap:/untrace: to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    self trace:anObject selectors:aCollectionOfSelectors on:Processor activeProcess stderr

    "
     |p|

     p := Point new.
     MessageTracer trace:p selector:#x:.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer trace:a selector:#at:put:.
     MessageTracer trace:a selector:#at:.
     a sort.
    "

    "Modified: / 21.4.1998 / 15:41:57 / cg"
!

trace:anObject selectors:aCollectionOfSelectors on:aStream
    "arrange for a trace message to be output on Stderr, when any message
     from aCollectionOfSelectors is sent to anObject.
     Both entry and exit are traced.
     Use untrap:/untrace: to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    aCollectionOfSelectors do:[:aSelector |
	|methodName|

	methodName := anObject class name , '>>' , aSelector.
	self
	    wrap:anObject
	    selector:aSelector
	    onEntry:[:con |
			aStream nextPutAll:'enter '; nextPutAll:methodName.
			aStream nextPutAll:' receiver='.
			con receiver printOn:aStream.
			aStream nextPutAll:' args='. (con args) printOn:aStream.
			aStream nextPutAll:' from:'. con sender printOn:aStream.
			aStream cr; flush
		    ]
	    onExit:[:con :retVal |
			aStream nextPutAll:'leave '; nextPutAll:methodName.
			aStream nextPutAll:' receiver='. con receiver printOn:aStream.
			aStream nextPutAll:' returning:'. retVal printOn:aStream.
			aStream cr; flush
		   ]
	    withOriginalClass:true
	    flushCaches:false
    ].
    ObjectMemory flushCaches

    "
     |p|

     p := Point new.
     MessageTracer trace:p selectors:#(x:) on:Transcript.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer trace:a selectors:#( at:put: at:) on:Transcript.
     a sort.
    "

    "Modified: / 21.4.1998 / 15:41:57 / cg"
!

traceAll:anObject
    "trace all messages which are understood by anObject"

    self traceAll:anObject on:Processor activeProcess stderr

    "
     trace all (implemented) messages sent to Display
     (other messages lead to an error, anyway)
    "

    "
     MessageTracer traceAll:Display
     MessageTracer untrace:Display
    "

    "Modified: 5.6.1996 / 13:43:51 / stefan"
!

traceAll:anObject from:aClass
    "trace all messages defined in aClass sent to anObject"

    self traceAll:anObject from:aClass on:Processor activeProcess stderr

    "
     trace all methods in Display, which are implemented
     in the DisplayWorkstation class.
    "

    "
     MessageTracer traceAll:Display from:XWorkstation
     MessageTracer untrace:Display
    "

    "Modified: 5.6.1996 / 13:45:37 / stefan"
!

traceAll:anObject from:aClass on:aStream
    "trace all messages defined in aClass sent to anObject"

    self trace:anObject selectors:aClass selectors on:aStream

    "
     trace all methods in Display, which are implemented
     in the DisplayWorkstation class.
    "

    "
     MessageTracer traceAll:Display from:XWorkstation on:Transcript
     MessageTracer untrace:Display
    "

    "Modified: 5.6.1996 / 13:45:37 / stefan"
!

traceAll:anObject on:aStream
    "trace all messages which are understood by anObject"

    |allSelectors|

    allSelectors := IdentitySet new.
    anObject class withAllSuperclassesDo:[:aClass |
	aClass methodDictionary keys addAllTo:allSelectors
    ].
    self trace:anObject selectors:allSelectors on:aStream

    "
     trace all (implemented) messages sent to Display
     (other messages lead to an error, anyway)
    "

    "
     MessageTracer traceAll:Display on:Transcript
     MessageTracer untrace:Display
    "

    "Modified: 5.6.1996 / 13:43:51 / stefan"
!

traceEntry:anObject selectors:aCollectionOfSelectors on:aStream
    "arrange for a trace message to be output on Stderr, when any message
     from aCollectionOfSelectors is sent to anObject.
     Only entry is traced.
     Use untrap:/untrace: to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    self
        traceEntry:anObject selectors:aCollectionOfSelectors on:Processor activeProcess stderr

    "
     |p|

     p := Point new.
     MessageTracer traceEntry:p selectors:#(x:).
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer traceEntry:a selectors:#( at:put: at:).
     a sort.
    "

    "Modified: / 21.4.1998 / 15:41:57 / cg"
!

traceSender:anObject selector:aSelector
    "arrange for a trace message to be output on Stderr, when a message with
     aSelector is sent to anObject. Only the sender is traced on entry.
     Use untrap to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    ^ self traceSender:anObject selector:aSelector on:Processor activeProcess stderr

    "
     |p|

     p := Point new.
     MessageTracer traceSender:p selector:#x:.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer traceSender:a selector:#at:put:.
     MessageTracer traceSender:a selector:#at:.
     a sort.
    "

    "Modified: 10.1.1997 / 17:54:53 / cg"
!

traceSender:anObject selector:aSelector on:aStream
    "arrange for a trace message to be output on Stderr, when a message with
     aSelector is sent to anObject. Only the sender is traced on entry.
     Use untrap to remove this trace.
     The current implementation does not allow integers or nil to be traced."

    |methodName|

    methodName := anObject class name , '>>' , aSelector.
    self wrap:anObject
	 selector:aSelector
	 onEntry:[:con |
		     aStream nextPutAll:methodName.
		     aStream nextPutAll:' from '.
		     con sender printOn:aStream.
		     aStream cr; flush.
		 ]
	 onExit:LeaveTraceBlock.

    "
     |p|

     p := Point new.
     MessageTracer traceSender:p selector:#x: on:Transcript.
     p x:5.
     p y:1.
     p x:10.
     MessageTracer untrap:p.
     p x:7
    "
    "
     |a|

     a := #(6 1 9 66 2 17) copy.
     MessageTracer traceSender:a selector:#at:put: on:Transcript.
     MessageTracer traceSender:a selector:#at:.    on:Transcript
     a sort.
    "

    "Modified: 10.1.1997 / 17:54:53 / cg"
!

untrace:anObject
    "remove any traces on anObject"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self untrap:anObject
!

untrace:anObject selector:aSelector
    "remove traces of aSelector sent to anObject"

    "just a rename for your convenience - the same basic mechanism is used for all of these
     trace facilities ..."

    ^ self untrap:anObject selector:aSelector
! !

!MessageTracer class methodsFor:'object wrapping'!

wrap:anObject selector:aSelector onEntry:entryBlock onExit:exitBlock
    "arrange for the two blocks entryBlock and exitBlock to be evaluated whenever
     a message with aSelector is sent to anObject. EntryBlock will be called on
     entry, and get the current context passed as argument. ExitBlock will be called,
     when the method is left, and get the context and the methods return value as arguments.
     The current implementation does not allow integers or nil to be wrapped."

    "I have not yet enough experience, if the wrapped original method should
     run as an instance of the original, or of the catching class;
     The latter has the advantage of catching recursive and other sends, while
     it might lead into trouble when the message is sent from a debugger or a long
     return is done out of the original method ...
     Time will show, you can experiment by setting the withOriginalClass: flag to false
    "
    ^ self
	wrap:anObject
	selector:aSelector
	onEntry:entryBlock
	onExit:exitBlock
	withOriginalClass:true
	flushCaches:true

    "Modified: / 21.4.1998 / 15:29:50 / cg"
!

wrap:anObject selector:aSelector onEntry:entryBlock onExit:exitBlock additionalEntryCode:additionalEntryCode additionalExitCode:additionalExitCode  additionalVariables:additionalVariables withOriginalClass:withOriginalClass flushCaches:flushCaches
    "arrange for the two blocks entryBlock and exitBlock to be evaluated whenever
     a message with aSelector is sent to anObject. EntryBlock will be called on
     entry, and get the current context passed as argument. ExitBlock will be called,
     when the method is left, and get the current context and the methods return value as argument.
     If withOriginalClass is true, the class of anObject will be set to its original class
     before the wrapped method will be called.
     NOTICE: The current implementation does not allow integers or nil to be wrapped."

    |newClass orgClass myMetaclass trapMethod s spec implClass dict
     originalMethod|

    "
     some are not allowed (otherwise we get into trouble ...)
    "
    (aSelector == #class
    or:[aSelector == #changeClassTo:]) ifTrue:[
        Transcript showCR:'sorry, cannot place trap on: ' , aSelector.
        ^ self
    ].

    WrappedMethod autoload.     "/ just to make sure ...

    "
     create a new (anonymous) subclass of the receiver's class
     but only if not already being trapped.
    "
    orgClass := anObject class.
    orgClass category == #'* trapping *' ifTrue:[
        newClass := orgClass
    ] ifFalse:[
        myMetaclass := orgClass class.

        newClass := myMetaclass copy new.
        newClass setSuperclass:orgClass.
        newClass instSize:orgClass instSize.
        newClass flags:orgClass flags.
        newClass isMeta ifFalse:[newClass setClassVariableString:''].
        newClass setInstanceVariableString:''.
        newClass setName:orgClass name.
        newClass setCategory:#'* trapping *'.
        newClass methodDictionary:MethodDictionary new.
    ].

    "
     create a method, executing the trap-blocks and the original method via a super-send
    "
    spec := Parser methodSpecificationForSelector:aSelector.
    s := WriteStream on:''.
    s nextPutAll:spec.
    s nextPutAll:' <context: #return>'.
    s nextPutAll:' |retVal stubClass '.
    additionalVariables notNil ifTrue:[
        s nextPutAll:additionalVariables.
    ].
    s nextPutAll:'| '.
    withOriginalClass ifTrue:[
        s nextPutAll:'stubClass := self class. '.
        s nextPutAll:'self changeClassTo:(stubClass superclass). '.
    ].
    additionalEntryCode notNil ifTrue:[
        s nextPutAll:additionalEntryCode.
    ].
    entryBlock notNil ifTrue:[
        s nextPutAll:'#literal1 yourself value:thisContext. '.               "/ #literal1 will be replaced by the entryBlock
    ].
    s nextPutAll:('retVal := #originalMethod. ').                            "/ just to get a place for the originalMethod
    s nextPutAll:('retVal := super ' , spec , '. ').
    exitBlock notNil ifTrue:[
        s nextPutAll:'#literal2 yourself value:thisContext value:retVal. '.  "/ #literal2 will be replaced by the exitBlock
    ].
    additionalExitCode notNil ifTrue:[
        s nextPutAll:additionalExitCode.
    ].
    withOriginalClass ifTrue:[
        s nextPutAll:'self changeClassTo:stubClass. '.
    ].
    s nextPutAll:'^ retVal'; cr.

    ParserFlags
        withSTCCompilation:#never
        do:[
            Class withoutUpdatingChangesDo:[
                [
                    trapMethod := Compiler
                                    compile:s contents
                                    forClass:newClass
                                    inCategory:'breakpointed'
                                    notifying:nil
                                    install:false
                                    skipIfSame:false
                                    silent:true.
                ] on: ParseError do:[:ex |
                    "/ Sigh, compiler used to return #Error but now raises
                    "/ a ParseError. Simulate old behaviour
                    trapMethod := #Error
                ].
            ]
        ].

    trapMethod == #Error ifTrue:[
        Transcript showCR:('cannot place trap on method: ' , aSelector).
        ^ self
    ].

    implClass := orgClass whichClassIncludesSelector:aSelector.
    implClass isNil ifTrue:[
        Transcript showCR:aSelector , ' is not understood by ' , orgClass name.
    ] ifFalse:[
        originalMethod := (implClass compiledMethodAt:aSelector).
        originalMethod notNil ifTrue:[
            trapMethod setPackage:originalMethod package.
        ].

        trapMethod changeLiteral:#originalMethod to:originalMethod.
    ].
    entryBlock notNil ifTrue:[
        trapMethod changeLiteral:#literal1 to:entryBlock.
    ].
    exitBlock notNil ifTrue:[
        trapMethod changeLiteral:#literal2 to:exitBlock.
    ].
    "
     change the source of this new method
     (to avoid confusion in the debugger ...)
    "
    trapMethod source:'this is a wrapper method - not the real one'.
    trapMethod changeClassTo:WrappedMethod.
    trapMethod register.

    "
     install this new method
    "
    dict := newClass methodDictionary.
    dict := dict at:aSelector putOrAppend:trapMethod.
    flushCaches ifTrue:[
        newClass methodDictionary:dict.
    ] ifFalse:[
        newClass setMethodDictionary:dict.
    ].

    "
     and finally, the big trick:
    "
    newClass ~~ orgClass ifTrue:[
        anObject changeClassTo:newClass
    ].

    "
                                                                        [exBegin]
     |p|

     p := Point new copy.
     MessageTracer
                wrap:p
            selector:#y:
             onEntry:nil
              onExit:[:context :retVal |
                         Transcript show:'leave Point>>y:, returning:'.
                         Transcript showCR:retVal printString.
                         Transcript endEntry
                     ]
               withOriginalClass:true.
     Transcript showCR:'sending x: ...'.
     p x:1.
     Transcript showCR:'sending y: ...'.
     p y:2.
     MessageTracer untrap:p.
     Transcript showCR:'sending x: ...'.
     p x:2.
     Transcript showCR:'sending y: ...'.
     p y:1.
                                                                        [exEnd]
    "

    "
                                                                        [exBegin]
     |p|

     p := Point new copy.
     MessageTracer wrap:p
               selector:#y:
                onEntry:[:context | self halt:'y: you are trapped']
                 onExit:nil
                  withOriginalClass:false.
     Transcript showCR:'sending x: ...'.
     p x:1.
     Transcript showCR:'sending y: ...'.
     p y:2.
     MessageTracer untrap:p.
     Transcript showCR:'sending x: ...'.
     p x:2.
     Transcript showCR:'sending y: ...'.
     p y:1.
                                                                        [exEnd]
    "

    "Modified: / 25-06-1996 / 22:11:21 / stefan"
    "Created: / 21-04-1998 / 15:30:27 / cg"
    "Modified: / 29-07-2014 / 11:58:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrap:anObject selector:aSelector onEntry:entryBlock onExit:exitBlock withOriginalClass:withOriginalClass flushCaches:flushCaches
    "arrange for the two blocks entryBlock and exitBlock to be evaluated whenever
     a message with aSelector is sent to anObject. EntryBlock will be called on
     entry, and get the current context passed as argument. ExitBlock will be called,
     when the method is left, and get the current context and the methods return value as argument.
     If withOriginalClass is true, the class of anObject will be set to its original class
     before the wrapped method will be called.
     NOTICE: The current implementation does not allow integers or nil to be wrapped."

    ^ self
	wrap:anObject selector:aSelector onEntry:entryBlock onExit:exitBlock
	additionalEntryCode:nil additionalExitCode:nil  additionalVariables:nil
	withOriginalClass:withOriginalClass flushCaches:flushCaches
!

wrap:anObject selectors:aCollection onEntry:entryBlock onExit:exitBlock
    "install wrappers for anObject on all selectors from aCollection"

    aCollection do:[:aSelector |
	self
	    wrap:anObject selector:aSelector
	    onEntry:entryBlock onExit:exitBlock
	    withOriginalClass:true
	    flushCaches:false
    ].
    ObjectMemory flushCaches

    "Modified: / 21.4.1998 / 15:40:28 / cg"
!

wrapAll:anObject onEntry:entryBlock onExit:exitBlock
    "install wrappers for anObject on all implemented selectors"

    |allSelectors|

    allSelectors := IdentitySet new.
    anObject class withAllSuperclassesDo:[:aClass |
	aClass methodDictionary keys addAllTo:allSelectors
    ].
    self wrap:anObject selectors:allSelectors onEntry:entryBlock onExit:exitBlock

    "Modified: 5.6.1996 / 14:50:07 / stefan"
! !

!MessageTracer class methodsFor:'queries'!

allWrappedMethods
    ^ WrappedMethod allWrappedMethods. 
    "/ ^ Smalltalk allMethodsForWhich:[:mthd | mthd isWrapped]
!

areAnyMethodsWrapped
    ^ WrappedMethod allWrappedMethods notEmpty.
"/    Smalltalk allMethodsDo:[:mthd |
"/        mthd isWrapped ifTrue:[ ^ true ]
"/    ].
"/    ^ false
!

isCounting:aMethod
    "return true if aMethod is counted"

    MethodCounts notNil ifTrue:[
	(MethodCounts includesKey:aMethod) ifTrue:[^ true].
	aMethod isWrapped ifTrue:[
	    (MethodCounts includesKey:aMethod originalMethod)ifTrue:[^ true].
	].
    ].
    MethodCountsPerReceiverClass notNil ifTrue:[
	(MethodCountsPerReceiverClass includesKey:aMethod) ifTrue:[^ true].
	aMethod isWrapped ifTrue:[
	    (MethodCountsPerReceiverClass includesKey:aMethod originalMethod)ifTrue:[^ true].
	].
    ].
    ^ false

    "Created: 15.12.1995 / 11:07:58 / cg"
    "Modified: 15.12.1995 / 15:42:10 / cg"
!

isCountingByReceiverClass:aMethod
    "return true if aMethod is counted with per receiver class statistics"

    MethodCountsPerReceiverClass isNil ifTrue:[^ false].
    (MethodCountsPerReceiverClass includesKey:aMethod) ifTrue:[^ true].
    aMethod isWrapped ifTrue:[
	^ MethodCountsPerReceiverClass includesKey:aMethod originalMethod
    ].
    ^ false
!

isMocking:aMethod
    "Return true if aMethod is mocking"

    aMethod basicLiterals do:[ :object | object == MockedMethodMarker ifTrue:[ ^ true ] ].
    ^ false

    "Created: / 29-07-2014 / 09:51:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTiming:aMethod
    "return true if aMethod is timed"

    MethodTiming isNil ifTrue:[^ false].
    (MethodTiming includesKey:aMethod) ifTrue:[^ true].
    aMethod isWrapped ifTrue:[
	^ MethodTiming includesKey:aMethod originalMethod
    ].
    ^ false

    "Modified: 15.12.1995 / 15:42:10 / cg"
    "Created: 17.6.1996 / 17:04:29 / cg"
!

isTrapped:aMethod
    "return true, if a breakpoint is set on aMethod.
     This only returns true for standard breakpoints (i.e. for user-wraps,
     this returns false)"

    aMethod isWrapped ifFalse:[^ false].
    ^ aMethod basicLiterals includesIdentical:LeaveBreakBlock

    "
     MessageTracer trapMethod:(Collection compiledMethodAt:#select:).
     Transcript showCR:(Collection compiledMethodAt:#select:) isWrapped.
     Transcript showCR:(MessageTracer isTrapped:(Collection compiledMethodAt:#select:)).
     MessageTracer unwrapMethod:(Collection compiledMethodAt:#select:).
    "

    "Modified: 22.10.1996 / 17:40:37 / cg"
! !

!MessageTracer class methodsFor:'trace helpers'!

dummyEmptyMethod
    "helper - to get the time it takes to evaluate the wrappers for
     a dummy method."

    "Created: / 30.7.1998 / 16:58:08 / cg"
!

getTimeForWrappers
    "helper - get the overhead (in ms) spent in the wrapper code of
     a timed method."

    |m times|

    TimeForWrappers := 0.

    "/ wrap the dummy method ...

    m := self class compiledMethodAt:#dummyEmptyMethod.
    m := self timeMethod:m.

    "/ invoke it a few times ...
    "/ (cannot take the smallest, since the work done in the wrapper
    "/  depends on whether there is already some statistic data)

    10 timesRepeat:[
	self dummyEmptyMethod.
    ].

    "/ fetch min time & unwrap

    times := self executionTimesOfMethod:m.
    self stopTimingMethod:m.

    ^ (TimeForWrappers := times avgTime)

    "
     self getTimeForWrappers
    "

    "Modified: / 05-03-2007 / 15:44:24 / cg"
!

printEntryFull:aContext
    self printEntryFull:aContext level:0 on:Processor activeProcess stderr
!

printEntryFull:aContext level:lvl
    self printEntryFull:aContext level:lvl on:Processor activeProcess stderr
!

printEntryFull:aContext level:lvl on:aStream
    aStream
	spaces:lvl;
	nextPutAll:'enter '.
    self printFull:aContext on:aStream withSender:true.
!

printEntryFull:aContext on:aStream
    self printEntryFull:aContext level:0 on:aStream
!

printEntrySender:aContext on:aStream
    |sender mClass mClassName|

    mClass := aContext methodClass.
    mClass isNil ifTrue:[
	mClassName := '???'
    ] ifFalse:[
	mClassName := mClass name
    ].

    aStream
	nextPutAll:mClassName;
	space;
	bold;
	nextPutAll:aContext selector;
	normal;
	nextPutAll:' from '.

    sender := aContext sender.
    sender notNil ifTrue:[
	(sender selector startsWith:'perform:') ifTrue:[
	    sender := sender sender.
	].
    ].
    sender printOn:aStream.
    aStream cr; flush.

    "Modified: / 30.7.1998 / 20:40:14 / cg"
!

printExit:aContext with:retVal
    self printExit:aContext with:retVal level:0 on:Processor activeProcess stderr
!

printExit:aContext with:retVal level:lvl
    self printExit:aContext with:retVal level:lvl on:Processor activeProcess stderr
!

printExit:aContext with:retVal level:lvl on:aStream
    |mClass mClassName|

    mClass := aContext methodClass.
    mClass isNil ifTrue:[
	mClassName := '???'
    ] ifFalse:[
	mClassName := mClass name
    ].
    aStream
	spaces:lvl;
	nextPutAll:'leave ';
	nextPutAll:mClassName;
	space;
	bold;
	nextPutAll:aContext selector;
	normal;
	nextPutAll:' rec=['.

    self printObject:aContext receiver on:aStream.
    aStream nextPutAll:'] return: ['.
    retVal printOn:aStream.
    aStream nextPutAll:']'; cr; flush.
!

printExit:aContext with:retVal on:aStream
    self printExit:aContext with:retVal level:0 on:aStream
!

printFull:aContext on:aStream withSender:withSender
    self
	printFull:aContext on:aStream
	withSenderContext:(withSender ifTrue:[aContext sender]
				      ifFalse:[nil])
!

printFull:aContext on:aStream withSenderContext:aSenderContextOrNil
    |mClass mClassName|

    mClass := aContext methodClass.
    mClass isNil ifTrue:[
	mClassName := '???'
    ] ifFalse:[
	mClassName := mClass name
    ].

    aStream
	nextPutAll:mClassName;
	space;
	bold;
	nextPutAll:aContext selector;
	normal;
	nextPutAll:' rec=['.

    self printObject:aContext receiver on:aStream.

    aStream nextPutAll:'] '.
    (aContext args) keysAndValuesDo:[:idx :arg |
	aStream nextPutAll:'arg'. idx printOn:aStream. aStream nextPutAll:'=['.
	self printObject:arg on:aStream.
	aStream nextPutAll:'] '.
    ].

    aSenderContextOrNil notNil ifTrue:[
	self printSender:aSenderContextOrNil on:aStream.
    ].
    aStream cr; flush.
!

printObject:anObject on:aStream
    |s|

    anObject isProtoObject ifTrue:[
        s := anObject classNameWithArticle
    ] ifFalse:[
        s := anObject printString.
        s size > 40 ifTrue:[
            s := s contractTo:40.
        ].
    ].
    aStream nextPutAll:s
!

printSender:aSenderContext on:aStream
    |sender|

    sender := aSenderContext.
    sender notNil ifTrue:[
	(sender selector startsWith:'perform:') ifTrue:[
	    sender := sender sender.
	].
    ].
    aStream nextPutAll:'from:'.
    aStream bold.
    sender printOn:aStream.
    aStream normal.
!

printUpdateEntryFull:aContext level:lvl on:aStream
    |con|

    con := aContext.

    [con notNil
     and:[con selector ~~ #'changed:with:']
    ] whileTrue:[
	con := con sender.
    ].
    "/ con is #'changed:with:'
    con isNil ifTrue:[
	^ self printEntryFull:aContext level:lvl on:aStream.
    ].

    (con sender notNil
    and:[ con sender selector == #'changed:']) ifTrue:[
	con := con sender.
    ].
    (con sender notNil
    and:[ con sender selector == #'changed']) ifTrue:[
	con := con sender.
    ].
    (con sender notNil) ifTrue:[
	con := con sender.
    ].

    aStream spaces:lvl; nextPutAll:'enter '.
    self
	printFull:aContext
	on:aStream
	withSenderContext:con
!

traceEntryFull:aContext on:aStream
    aStream nextPutLine:'-----------------------------------------'.
    aContext fullPrintAllOn:aStream

    "Created: / 30.7.1998 / 20:39:57 / cg"
    "Modified: / 30.7.1998 / 20:42:23 / cg"
!

traceFullBlockFor:aStream
    "avoid generation of fullBlocks"

    aStream == Transcript ifTrue:[
	^ TraceFullBlock2
    ].
    aStream == Stderr ifTrue:[
	^ TraceFullBlock
    ].
    ^ [:con | con fullPrintAllOn:aStream]



!

traceSenderBlockFor:aStream
    "avoid generation of fullBlocks"

    aStream == Transcript ifTrue:[
	^ TraceSenderBlock2
    ].
    aStream == Stderr ifTrue:[
	^ TraceSenderBlock
    ].
    ^ [:con | MessageTracer printEntrySender:con on:aStream]



! !

!MessageTracer methodsFor:'trace helpers'!

trace:aBlock detail:fullDetail
    "trace execution of aBlock."

    traceDetail := fullDetail.
    tracedBlock := aBlock.

    ObjectMemory stepInterruptHandler:self.
    ^ [
	ObjectMemory flushInlineCaches.
	StepInterruptPending := 1.
	InterruptPending := 1.
	aBlock value
    ] ensure:[
	tracedBlock := nil.
	StepInterruptPending := nil.
	ObjectMemory stepInterruptHandler:nil.
    ]

    "
     PrintingMessageTracer new trace:[#(6 5 4 3 2 1) sort] detail:false

     PrintingMessageTracer new trace:[#(6 5 4 3 2 1) sort] detail:true

     PrintingMessageTracer new trace:[#(6 5 4 3 2 1) sort] detail:#indent

     PrintingMessageTracer new trace:[#(6 5 4 3 2 1) sort] detail:#fullIndent
    "
! !

!MessageTracer::InteractionCollector methodsFor:'trace helpers'!

stepInterrupt
    StepInterruptPending := nil.
    ObjectMemory flushInlineCaches.
    StepInterruptPending := 1.
    InterruptPending := 1.
! !

!MessageTracer::MethodSpyInfo methodsFor:'accessing'!

profiler
    ^ profiler
!

profiler:aMessageTally
    profiler := aMessageTally.
! !

!MessageTracer::MethodTimingInfo methodsFor:'accessing'!

avgTime
    sumTimes notNil ifTrue:[
	^ sumTimes / count
    ].
    ^ nil

    "Created: / 05-03-2007 / 15:38:43 / cg"
!

avgTimeRounded
    |avg|

    avg := self avgTime.
    avg > 100 ifTrue:[ ^ avg roundTo:1 ].
    avg > 10 ifTrue:[ ^ avg roundTo:0.1 ].
    avg > 1 ifTrue:[ ^ avg roundTo:0.01 ].
    ^ avg roundTo:0.001

    "Created: / 05-03-2007 / 15:47:02 / cg"
!

count
    ^ count
!

count:countArg minTime:minTimeArg maxTime:maxTimeArg sumTimes:sumTimesArg
    count := countArg.
    minTime := minTimeArg.
    maxTime := maxTimeArg.
    sumTimes := sumTimesArg.
!

maxTime
    ^ maxTime
!

maxTimeRounded
    |max|

    max := self maxTime.
    ^ max roundTo:(max > 10 ifTrue:0.1 ifFalse:0.01)

    "Created: / 05-03-2007 / 15:47:22 / cg"
!

minTime
    ^ minTime
!

minTimeRounded
    |min|

    min := self minTime.
    ^ min roundTo:(min > 10 ifTrue:0.1 ifFalse:0.01)

    "Created: / 05-03-2007 / 15:47:16 / cg"
!

sumTimes
    ^ sumTimes
! !

!MessageTracer::MethodTimingInfo methodsFor:'initialization'!

rememberExecutionTime:t
    (count isNil or:[count == 0]) ifTrue:[
	minTime := maxTime := sumTimes := t.
	count := 1.
    ] ifFalse:[
	t < minTime ifTrue:[
	    minTime := t.
	] ifFalse:[
	    t > maxTime ifTrue:[
		maxTime := t.
	    ]
	].
	sumTimes := (sumTimes + t).
	count := count + 1
    ].

    "Created: / 05-03-2007 / 15:32:43 / cg"
! !

!MessageTracer::PrintingMessageTracer methodsFor:'accessing'!

output:something
    output := something.
! !

!MessageTracer::PrintingMessageTracer methodsFor:'trace helpers'!

stepInterrupt
    "called for every send while tracing"

    |ignore sel con r outStream senderContext|

    StepInterruptPending := nil.
    con := senderContext := thisContext sender.
    ignore := false.
    outStream := output notNil ifTrue:[output] ifFalse:[Processor activeProcess stderr].

    con receiver == Processor ifTrue:[
        (sel := con selector) == #threadSwitch: ifTrue:[
            ignore := true.
        ].
        sel == #timerInterrupt ifTrue:[
            ignore := true.
        ]
    ].

    con lineNumber == 1 ifFalse:[
        ignore := true
    ].

    ignore ifFalse:[
        con markForInterruptOnUnwind.

        ((r := con receiver) ~~ self
        and:[r ~~ tracedBlock]) ifTrue:[
            traceDetail == #fullIndent ifTrue:[
                [con notNil
                and:[(r := con receiver) ~~ self
                and:[r ~~ tracedBlock]]] whileTrue:[
                    '  ' printOn:outStream.
                    con := con sender.
                ].
                con := senderContext.
                self class printFull:con on:outStream withSender:false.
            ] ifFalse:[
                traceDetail == #indent ifTrue:[
                    [con notNil
                    and:[(r := con receiver) ~~ self
                    and:[r ~~ tracedBlock]]] whileTrue:[
                        '  ' printOn:outStream.
                        con := con sender.
                    ].
                    con := senderContext.
                    con printOn:outStream.
                    outStream cr.
                ] ifFalse:[
                    traceDetail == true ifTrue:[
                        self class printFull:con on:outStream withSender:true.
                    ] ifFalse:[
                        con printOn:outStream.
                        outStream cr.
                    ]
                ]
            ].
        ].
    ].

    ObjectMemory flushInlineCaches.
    StepInterruptPending := 1.
    InterruptPending := 1.

    "
     self new trace:[#(6 5 4 3 2 1) sort] detail:false

     self new trace:[#(6 5 4 3 2 1) sort] detail:true

     self new trace:[#(6 5 4 3 2 1) sort] detail:#indent

     self new trace:[#(6 5 4 3 2 1) sort] detail:#fullIndent
     self new trace:[ View new ] detail:#fullIndent
    "
! !

!MessageTracer class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !


MessageTracer initialize!
