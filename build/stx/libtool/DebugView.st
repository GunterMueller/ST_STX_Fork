"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
 COPYRIGHT (c) 2017 Patrik Svestka
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

StandardSystemView subclass:#DebugView
	instanceVariableNames:'busy haveControl exitAction canContinue contextView codeView
		receiverInspector contextInspector contextArray selectedContext
		catchBlock grabber mayProceed traceView tracing bigStep
		skipLineNr abortButton terminateButton continueButton stepButton
		nextButton nextOverButton nextOutButton sendButton returnButton
		restartButton exclusive inspecting nChainShown inspectedProcess
		updateProcess updateButton defineButton monitorToggle stepping
		steppedContextLineno actualContext inWrap stackInspector
		steppedContext wrapperContext firstContext stepHow cachable
		currentMethod ignoreBreakpoints stepUntilEntering
		lastStepUntilEntering lastSelectionInReceiverInspector
		lastSelectionInContextInspector canShowMore reportButton
		setOfHiddenCallingSelectors isStoppedAtHaltOrBreakPoint
		exceptionInfoLabel methodCodeToggle
		methodCodeToggleSelectionHolder
		isStoppedAtBreakPointWithParameter breakPointParameter
		hideSupportCode contextInfoLabel resendButton
		gotoDialogOpenerButton isStoppedInModalDialog selectorToDefine
		classToDefineIn gotoApplicationActionMethodButton
		isStoppedInApplicationAction isStoppedAtStatementBreakpoint
		verboseBacktraceHolder keyboardMap'
	classVariableNames:'CachedDebugger CachedExclusive OpenDebuggers MoreDebuggingDetail
		DebuggingDebugger DebuggingDebugger2 DebuggingContextWalk
		DefaultDebuggerBackgroundColor InitialNChainShown IgnoredHalts
		ShowThreadID LastIgnoreHaltNTimes LastIgnoreHaltDuration
		LastExtent LastOrigin RememberedCallChain DebuggingDebugger3
		NumberOfDebuggers DebuggerOnMainDisplayOnly'
	poolDictionaries:''
	category:'Interface-Debugger'
!

DebugView class instanceVariableNames:'defaultKeyboardMap'

"
 The following class instance variables are inherited by this class:

	StandardSystemView - 
	TopView - 
	View - 
	SimpleView - ClassResources DefaultFont
	DisplaySurface - 
	GraphicsMedium - 
	Object - 
"
!

Object subclass:#IgnoredHaltOrBreakpoint
	instanceVariableNames:'ignoreEndTime ignoreCount ignoreUntilShiftKeyPressed
		ignoredReceiverClasses ignoredProcesses
		ignoredSendingClassAndSelectors'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DebugView
!

DebugView::IgnoredHaltOrBreakpoint subclass:#IgnoredHalt
	instanceVariableNames:'weakMethodHolder lineNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DebugView
!

DebugView::IgnoredHaltOrBreakpoint subclass:#IgnoredBreakpoint
	instanceVariableNames:'parameter'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DebugView
!

!DebugView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
 COPYRIGHT (c) 2017 Patrik Svestka
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
    This class implements a graphical debugger interface.
    The debugger usually sits on top of the faulting process,
    taking over its event processing.

    (this is different from other Smalltalk debuggers, which control
     the debuggee as a separate process. Consider this an historic
     leftover - the debugger was one of the first applications written for ST/X.

     The whole setup might be changed, once the required process primitives
     are available, which allow control of another processes execution
     (i.e. single-step, restart & return). The setup will be changed then,
     to have the debugger control the debuggee (i.e. two processes).
     However, as it works as it is, and is reliable enough,
     why should we change it without a particular need...).

    Only the 'stopped' debugged process is affected;
    other processes continue to respond to events.
    The one exception to this is when an error occurs within the dispatcher process
    or in one of the eventhandler processes. In this case, the debugger
    will sit on an exclusive display connection.

    See additional information in 'doc/misc/debugger.doc'.

    Notice & Warning (attention when changing thingslike menus, window spec etc. here):
        the DebugView class caches the last used debugger in a class variable,
        and hides/shows this window without recreating one from scratch. This is done to make
        the debugger come up faster when single stepping, or hopping from breakpoint to breakpoint.

        It may happen, that a malfunctioning debugger (for example, a halfway created/destroyed one)
        is kept there. You will notice this, if a debugger comes up without showing any contents.
        In this case, close (or destroy) the broken debugView, and execute
            Debugger newDebugger
        which removes the cached debugger and forces creation of a new one the next time.
        This is a temporary workaround - the debugger should be fixed to avoid this situation.

        You must also flush the cached debugger, if you change the debugger's
        initialization code (buttons, menu, etc.) or the debugger's class layout,
        and you want the new code to become effective.

    [author:]
        Claus Gittinger

    [see also:]
        Exception Signal
        Process
"
! !

!DebugView class methodsFor:'initialization'!

initialize
    DebuggingDebugger := DebuggingDebugger2 := MoreDebuggingDetail := false.

    InitialNChainShown := 50.
    "/ DefaultDebuggerBackgroundColor := nil.
    "/ DefaultDebuggerBackgroundColor := Color red lightened.
    "/ DefaultDebuggerBackgroundColor := Color blue lightened lightened.

    "Created: 20.3.1997 / 16:53:37 / cg"
    "Modified: 20.3.1997 / 16:54:32 / cg"
!

initializeDefaultKeyboardMap
    defaultKeyboardMap := KeyboardMap new.
    defaultKeyboardMap 
        bindValue: #DebuggerContinue to: #F9;
        bindValue: #DebuggerNext to: #F8;
        bindValue: #DebuggerSend to: #F7.

      "/Other possibilities actions, not bound by default...

      "/bindValue: #DebuggerAbort to: ...
      "/bindValue: #DebuggerDefine to: ...
      "/bindValue: #DebuggerGotoResponsibleApplicationMethod to: ...
      "/bindValue: #DebuggerGoToDialogOpener to: ...
      "/bindValue: #DebuggerNext to: ...
      "/bindValue: #DebuggerResend to: ...
      "/bindValue: #DebuggerRestart to: ...
      "/bindValue: #DebuggerTerminate to: ...

    "Ceated: / 04-02-2017 / 22:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"

    "Created: / 04-02-2017 / 22:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2017 / 22:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitialize
    "reinitialize after an image-restart"

    self newDebugger
! !

!DebugView class methodsFor:'accessing'!

defaultKeyboardMap
    defaultKeyboardMap isNil ifTrue:[
        self initializeDefaultKeyboardMap.
    ].
    ^ defaultKeyboardMap

    "Created: / 04-02-2017 / 22:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView class methodsFor:'cleanup'!

lowSpaceCleanup
    "in low memory situations, give up cached debuggers"

    CachedDebugger notNil ifTrue:[
        CachedDebugger destroy.
        CachedDebugger := nil.
    ].
    CachedExclusive := nil.
    OpenDebuggers := nil.
    RememberedCallChain := nil.

    "
     DebugView lowSpaceCleanup
    "

    "Modified: / 08-03-2012 / 01:30:21 / cg"
!

newDebugger
    "force creation of a new debugger (give up cached debuggers).
     Call this, if you changed the debugger heavily, and you want to avoid
     that an old, cached debugger gets reused when the next error comes around."

    CachedDebugger notNil ifTrue:[
        CachedDebugger destroy.
        CachedDebugger := nil.
    ].
    CachedExclusive := nil.
    OpenDebuggers := nil.

    "/ only assign to the global debugger, if it has not been redefined
    "/ to another class.
    (Debugger isBehavior and:[Debugger name = #DebugView]) ifTrue:[
        Smalltalk at:#Debugger put:self
    ].

    "
     DebugView newDebugger
    "
! !

!DebugView class methodsFor:'defaults'!

debuggerOnMainDisplayOnly
    ^ DebuggerOnMainDisplayOnly ? true
!

defaultIcon
    "return the browsers default window icon"

    <resource: #programImage>

    ^ ToolbarIconLibrary debug22x22Icon
    "/ ^ ToolbarIconLibrary debugIt20x20Icon

    "Modified: / 11-02-2007 / 11:47:20 / cg"
!

defaultIconForAboutBox
    <resource: #programImage>

    ^ ToolbarIconLibrary debug22x22IconForBlackBackgound
!

defaultVerboseBacktrace
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ UserPreferences current verboseBacktraceInDebugger

    "Created: 11.1.1997 / 12:14:35 / cg"
!

defaultVerboseBacktrace:aBoolean
    <resource: #obsolete>
    self obsoleteMethodWarning.
    UserPreferences current verboseBacktraceInDebugger:aBoolean
!

maxNumberOfDebuggers
    "to prevent debuggers from flooding the screen,
     in case of an error in an ever-forked background process
     (such as tooltip process)"

    ^ 20
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'debugView.viewBackgroundColor')>

    DefaultDebuggerBackgroundColor := StyleSheet at:#'debugView.viewBackgroundColor'

    "Modified: / 17.11.2001 / 17:31:42 / cg"
! !

!DebugView class methodsFor:'ignoring halts'!

haltIgnoreInformationFor:haltingMethod atLineNr:lineNrInHaltingMethod
    "the information (if any) about the ignore-state of a halt"

    IgnoredHalts isNil ifTrue:[^ nil].

    IgnoredHalts do:[:ign |
        (ign isForMethod:haltingMethod line:lineNrInHaltingMethod)
        "/ (ign isHaltIgnoredInMethod:haltingMethod line:lineNrInHaltingMethod)
        ifTrue:[
            ^ ign
        ].
    ].
    ^ nil.
!

hasIgnoredHalts
    self removeInactiveIgnores.
    ^ IgnoredHalts notEmptyOrNil
!

ignoreBreakpointWithParameter:parameterOrNil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil

    "remember to ignore a breakpoint with a parameter (i.e. breakpoint:#cg) for some number of invocations
     or until some time has elapsed.
     With nil count and time arguments, such an ignored breakpoint is reactivated"

    self
        ignoreHaltOrBreakpoint:#halt
        method:nil line:nil
        parameter:parameterOrNil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:nil
!

ignoreHaltIn:haltingMethod at:lineNrOfHalt
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil

    "remember to ignore a halt in some method for some number of invocations
     or until some time has elapsed.
     With nil count and time arguments, such an ignored halt is reactivated"

    self
        ignoreHaltOrBreakpoint:#halt
        method:haltingMethod line:lineNrOfHalt
        parameter:nil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:nil
!

ignoreHaltIn:haltingMethod at:lineNrOfHalt
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:ifCalledForMethodOrNil

    "remember to ignore a halt in some method for some number of invocations
     or until some time has elapsed. 
     With a count of -1, it is ignored forever (i.e. until reenabled via the
     settings).
     With nil count and time arguments, such an ignored halt is reactivated"

    self
        ignoreHaltOrBreakpoint:#halt
        method:haltingMethod line:lineNrOfHalt
        parameter:nil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:ifCalledForMethodOrNil
!

ignoreHaltOrBreakpoint:type method:methodOrNil line:lineNrOfHaltOrNil parameter:parameterOrNil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil

    "remember to ignore a breakpoint with a parameter (i.e. breakpoint:#cg) for some number of invocations
     or until some time has elapsed.
     With nil count and time arguments, such an ignored breakpoint is reactivated"

    ^ self
        ignoreHaltOrBreakpoint:type method:methodOrNil line:lineNrOfHaltOrNil parameter:parameterOrNil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:nil
!

ignoreHaltOrBreakpoint:type method:methodOrNil line:lineNrOfHaltOrNil parameter:parameterOrNil
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:ifCalledFromMethodOrNil

    "remember to ignore a breakpoint with a parameter (i.e. breakpoint:#cg) for some number of invocations
     or until some time has elapsed.
     With nil count and time arguments, such an ignored breakpoint is reactivated"

    |oldEntry ign|

    IgnoredHalts notNil ifTrue:[
        self removeInactiveIgnores.
        type == #halt ifTrue:[
            oldEntry := IgnoredHalts
                            detect:[:ign | ign isForMethod:methodOrNil line:lineNrOfHaltOrNil]
                            ifNone:nil.
        ] ifFalse:[
            oldEntry := IgnoredHalts
                            detect:[:ign | ign isForBreakpointWithParameter:parameterOrNil]
                            ifNone:nil.
        ].
        oldEntry notNil ifTrue:[
            (processOrNil notNil or:[receiverClassOrNil notNil]) ifTrue:[
                receiverClassOrNil notNil ifTrue:[
                    oldEntry ignoreForReceiverClass:receiverClassOrNil.
                ].
                processOrNil notNil ifTrue:[
                    oldEntry ignoreForProcess:processOrNil.
                ].
                ^ self.
            ].
            IgnoredHalts remove:oldEntry ifAbsent:[].
        ]
    ].

    (countOrNil notNil
      or:[dTOrNil notNil
      or:[untilShiftKey == true
      or:[receiverClassOrNil notNil
      or:[processOrNil notNil
      or:[ifCalledFromMethodOrNil notNil]]]]]
    ) ifTrue:[
        IgnoredHalts isNil ifTrue:[
            IgnoredHalts := OrderedCollection new.
        ].
        type == #halt ifTrue:[
            ign := IgnoredHalt new method:methodOrNil lineNumber:lineNrOfHaltOrNil.
        ] ifFalse:[
            ign := IgnoredHalt new breakpointWithParameter:parameterOrNil.
        ].

        (countOrNil notNil and:[countOrNil > 0]) ifTrue:[
            ign ignoreCount:countOrNil.
        ].
        (dTOrNil notNil) ifTrue:[
            ign ignoreEndTime:(Timestamp now + dTOrNil).
        ].
        untilShiftKey == true ifTrue:[
            ign ignoreUntilShiftKeyPressed:true.
        ].
        receiverClassOrNil notNil ifTrue:[
            ign ignoreForReceiverClass:receiverClassOrNil.
        ].
        processOrNil notNil ifTrue:[
            ign ignoreForProcess:processOrNil.
        ].
        ifCalledFromMethodOrNil notNil ifTrue:[
            ign ignoreIfCalledFromMethod:ifCalledFromMethodOrNil.
        ].
        IgnoredHalts add:ign.
    ].
    Smalltalk changed:#ignoredHalts.

    "Created: / 06-03-2012 / 12:37:58 / cg"
!

isBreakpointToBeIgnoredForParameter:parameter context:aContext modifyEntryCount:modifyCount
    "/ should a breakpoint be ignored ?

    IgnoredHalts isNil ifTrue:[^ false].

    "/ Transcript showCR:'halt/break in ',haltingMethod printString,' at ',lineNrInHaltingMethod printString.
    IgnoredHalts do:[:ign |
        (ign isForBreakpointWithParameter:parameter) ifTrue:[
            Transcript show:'Debugger [info]: break ignored for ', parameter.

            modifyCount ifTrue:[ ign decrementIgnoreCount ].
            ign isHaltIgnored ifFalse:[
                Transcript showCR:'Debugger [info]: no longer ignore breakpoint for ', parameter.
                IgnoredHalts remove:ign ifAbsent:[].
            ].
            ^ true.
        ].
    ].

    IgnoredHalts := (IgnoredHalts reject:[:ign | ign isActive not ]) asNilIfEmpty.

    ^ false.

    "Created: / 06-03-2012 / 12:50:30 / cg"
!

isHaltToBeIgnoredIn:haltingMethod atLineNr:lineNrInHaltingMethod context:aContext modifyEntryCount:modifyCount
    "should a halt be ignored ?"

    IgnoredHalts isNil ifTrue:[^ false].

    "/ Transcript showCR:'halt/break in ',haltingMethod printString,' at ',lineNrInHaltingMethod printString.
    IgnoredHalts do:[:ign |
        (ign isHaltIgnoredInMethod:haltingMethod line:lineNrInHaltingMethod context:aContext) ifTrue:[
            Transcript showCR:'Debugger [info]: halt/break ignored: %1' with:ign.

            modifyCount ifTrue:[ ign decrementIgnoreCount ].
            ign isHaltIgnored ifFalse:[
                Transcript showCR:'Debugger [info]: no longer ignored (rest count=0)'.
                IgnoredHalts remove:ign ifAbsent:[].
            ].
            ^ true.
        ].
    ].

    IgnoredHalts := (IgnoredHalts reject:[:ign | ign isActive not]) asNilIfEmpty.

    ^ false.

    "Modified (comment): / 06-03-2012 / 12:51:43 / cg"
!

removeInactiveIgnores
    IgnoredHalts notNil ifTrue:[
        IgnoredHalts := IgnoredHalts select:[:i | i isActive].
    ].
!

stopIgnoringHalts
    "forget about all ignored halts"

    IgnoredHalts := nil.
    Smalltalk changed:#ignoredHalts.
!

stopIgnoringHaltsFor:haltingMethod atLineNr:lineNrInHaltingMethod
    "remove the information (if any) about the ignore-state of a halt;
     effectively reenables the breakpoint/halt"

    IgnoredHalts isNil ifTrue:[^ self].

    IgnoredHalts := IgnoredHalts reject:[:ign |
        (ign isForMethod:haltingMethod line:lineNrInHaltingMethod)
    ].
! !

!DebugView class methodsFor:'instance creation / entering'!

enter
    "enter a debugger"

    <context: #return>

    ^ self
        enter:thisContext sender
        withMessage:'Debugger Entered'
        mayProceed:true.
!

enter:aContext withMessage:aString
    "enter a debugger"

    <context: #return>

    ^ self
        enter:aContext
        withMessage:aString
        mayProceed:true
!

enter:aContext withMessage:aString mayProceed:mayProceed
    "enter a debugger; if this is a recursive invocation, enter
     a MiniDebugger instead.
     This is the standard way of entering the debugger;
     sent from error- and halt messages."

    <context: #return>

    |nDebuggers display|

    nDebuggers := (NumberOfDebuggers ? 0).
    (nDebuggers < 0 or:[nDebuggers > self maxNumberOfDebuggers]) ifTrue:[
        "/ ouch - we lost track of some...
        nDebuggers := NumberOfDebuggers := self allSubInstances count:[:d | d isOpen].
    ].
    nDebuggers > self maxNumberOfDebuggers ifTrue:[
        MiniDebugger enter:aContext withMessage:'too many debuggers - looping?' mayProceed:true.
    ].

    DebuggingDebugger == true ifTrue:[
        '==> enter1: (' print. aContext print. ')' printCR.
    ].

    display := (self debuggerOnMainDisplayOnly)
                ifTrue:[ Display ]
                ifFalse:[ Screen current ].

    Screen currentScreenQuerySignal answer:display
    do:[
        StepInterruptPending := nil.
        ControlInterrupt handle:[:ex |
            'DebugView [info]: breakpoint in debugger setup ignored [enter.]' infoPrintCR.
            ('DebugView [info]: breakpoint on:' , ex suspendedContext printString) infoPrintCR.
            ex proceed
        ] do:[
            |debugger|

            "
             well, it could be a stepping or sending debugger up there;
             in this case, return to it. This happens, when a stepping process
             runs into an error (for example, a halt). In this case, we want the
             stepping debugger to come up again instead of a new one.
            "
            (debugger := self openDebuggerForActiveProcess) notNil ifTrue:[
                debugger unstep.
                debugger setLabelFor:aString in:Processor activeProcess.
                debugger mayProceed:mayProceed.
                ^ debugger enter:aContext select:nil.
            ].
        ].
        ^ self enterUnconditional:aContext withMessage:aString mayProceed:mayProceed
    ].

    "Modified: / 06-11-2013 / 20:58:54 / cg"
!

enterException:ex
    "enter a debugger; if this is a recursive invocation, enter
     a MiniDebugger instead.
     This is the standard way of entering the debugger;
     sent from error- and halt messages."

    "/ a quick check for ignored breakpoints here,
    "/ to shortcut the expensive debugger setup.
    "/ big speedup when many ignored breakpoints are reached.
    IgnoredHalts notNil ifTrue:[
        ((ex creator == NoHandlerError)
        and:[ ex exception creator == BreakPointInterrupt ])  ifTrue:[
            (self 
                isHaltToBeIgnoredIn:(ex suspendedContext method)
                atLineNr:1
                context:(ex suspendedContext)
                modifyEntryCount:true
            ) ifTrue:[
                "/ Transcript showCR:'quick ignored'.
                ^ true.
            ].
        ].
    ].
    ^ self
        enter:ex returnableSuspendedContext
        withMessage:('[',ex originalSignal class name,']: ',ex descriptionForDebugger)
        mayProceed:(ex mayProceed).
!

enterUnconditional:aContext withMessage:aString mayProceed:mayProceed
    "enter a debugger - do not check for recursive invocation"

    <context: #return>

    |aDebugger|

    StepInterruptPending := nil.
    NumberOfDebuggers := (NumberOfDebuggers ? 0) + 1.

    "/ ignore halts & breakpoints while setting up the debugger
    "/ to avoid recursive debugging ...
    ControlInterrupt handle:[:ex |
        'DebugView [info]: breakpoint in debugger setup ignored [enterUncond.]' infoPrintCR.
        ('DebugView [info]: breakpoint on:' , ex suspendedContext printString) infoPrintCR.
        ex proceed
    ] do:[
        aDebugger := self new.
    ].

    aDebugger isNil ifTrue:[
        'DebugView [error]: cannot open debugger' errorPrintCR.
        'DebugView [error]: Exception: ' errorPrint. aString errorPrintCR.
        mayProceed ifTrue:[
            (Dialog confirm:'Error/Breakpoint caught.\\Press Continue or Abort.' withCRs
                   yesLabel:'Continue' noLabel:'Abort')
            ifTrue:[
                ^ nil
            ].
        ] ifFalse:[
            self information:'Error caught.\\Press OK to abort the operation.' withCRs.
        ].
        AbortOperationRequest raise.
        "not reached"
    ].

    aDebugger mayProceed:mayProceed.
    aDebugger setLabelFor:aString in:Processor activeProcess.
    aDebugger enter:aContext select:nil.
    ^ nil.

    "
        nil halt
    "

    "Modified: / 18.11.2001 / 00:29:23 / cg"
!

enterWithMessage:message
    "enter a debugger"

    <context: #return>

    ^ self
        enter:(thisContext sender)
        withMessage:message
        mayProceed:true.
!

new
    "return a new DebugView.
     - return a cached debugger if it already exists.
     Also, care for remote displays on which no debugger is wanted
     (ask with mayOpenDebugger) - if so, open on the default screen."

    |debugger currentScreen debuggerScreen|

    currentScreen := Screen current.

    currentScreen notNil ifTrue:[
        (currentScreen suppressDebugger) ifTrue:[
            "/ no debuggers with that device - show an alertBox which aborts...
            ^ nil.
        ].
        (currentScreen mayOpenDebugger) ifFalse:[
            "/ no debugger on that device - but on the main screen
            currentScreen := Display ? Screen default.
        ].
    ].

    "
     need a blocking debugger if no processes or
     or if its a timing/interrupt process
     (because otherwise we would not get any events here ...
    "
    Processor activeProcessIsSystemProcess ifTrue:[
        ((debugger := CachedExclusive) isNil
        or:[debugger device ~~ currentScreen
        or:[currentScreen isNil
        or:[currentScreen isOpen not]]]) ifTrue:[
            debugger := self newExclusive
        ].
        CachedExclusive := nil.
    ] ifFalse:[
        CachedDebugger notNil ifTrue:[
            (CachedDebugger device ~~ currentScreen
            or:[currentScreen isNil
            or:[currentScreen isOpen not
            or:[CachedDebugger class ~~ self]]]) ifTrue:[
                CachedDebugger := nil
            ]
        ].

        (debugger := CachedDebugger) notNil ifTrue:[
            CachedDebugger := nil.
        ] ifFalse:[
            debuggerScreen := currentScreen.
            debuggerScreen isNil ifTrue:[
                "/ use the default display
                debuggerScreen := Screen default.
            ].
            (debuggerScreen isNil
            or:[debuggerScreen isOpen not
            "/ or:[debuggerDevice mayOpenDebugger not]
            ]) ifTrue:[
                "/ no debugger
                ^ nil.
            ].

            Screen currentScreenQuerySignal answer:debuggerScreen
            do:[
                debugger := super new.
            ].
            debugger label:'Debugger'.
            debugger icon:self defaultIcon.
        ]
    ].
    ^ debugger

    "Modified: 31.7.1997 / 21:20:27 / cg"
!

newExclusive
    "return a debugger for exclusive display access"

    |debugger|

    debugger := super new.
    debugger label:'Debugger'.
    debugger icon:self defaultIcon.
    debugger exclusive:true.
    ^ debugger

    "Modified: 1.1.1970 / 23:27:06 / cg"
!

openDebuggerForActiveProcess
    "return an already open debugger for the active process, or nil, if there is none.
     Open debuggers exist when stepping only, as then, the debugger is left open until the step
     is reached, to avoid too much flickering and redrawing on the screen"

    "
     well, it could be a stepping or sending debugger up there;
     in this case, return to it. This happens, when a stepping process
     runs into an error (for example, a halt). In this case, we want the
     stepping debugger to come up again instead of a new one.
    "
    OpenDebuggers notNil ifTrue:[
        ^ self openDebuggerForProcess:(Processor activeProcess)
    ].    
    ^ nil

    "Created: / 06-11-2013 / 20:57:49 / cg"
!

openDebuggerForProcess:aProcess
    "if aProcess is being debugged and has an open debugger on it, 
     then return it, or nil, if there is none.
     Open debuggers also exist as unmapped windows when single-stepping"

    "
     well, it could be a stepping or sending debugger up there;
     in this case, return to it. This happens, when a stepping process
     runs into an error (for example, a halt). In this case, we want the
     stepping debugger to come up again instead of a new one.
    "
    OpenDebuggers notNil ifTrue:[
        OpenDebuggers do:[:aDebugger |
            |debuggersProcess|

            (aDebugger notNil and:[aDebugger ~~ 0]) ifTrue:[
                debuggersProcess := aDebugger inspectedProcess.
                debuggersProcess == aProcess ifTrue:[
                    aDebugger device isOpen ifTrue:[
                        DebuggingDebugger == true ifTrue:[
                            'reusing cached debugger' errorPrintCR.
                        ].
                        aDebugger unstep.
                        ^ aDebugger.
                    ]
                ].
                (debuggersProcess notNil and:[ debuggersProcess isDead ]) ifTrue:[
                    aDebugger destroy.
                ].
            ]
        ]
    ].
    ^ nil
!

openOn:aProcess
    "start a debugger on aProcess
     (actually not more than a good-looking inspector)"

    |aDebugger label nm|

    aDebugger := super new.
    aDebugger icon:self defaultIcon.
    aProcess notNil ifTrue:[
        nm := aProcess name.
        nm notNil ifTrue:[
            nm := (nm contractTo:17) , '-' , aProcess id printString
        ] ifFalse:[
            nm := aProcess id printString
        ].
        label := 'Debugger [' , nm , ']'.
    ] ifFalse:[
        label := 'no process'
    ].
    aDebugger label:label iconLabel:'Debugger'.
    aDebugger openOn:aProcess.
    ^ nil

    "Modified: 4.4.1997 / 16:22:36 / cg"
! !

!DebugView class methodsFor:'menu specs'!

breakPointMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#breakPointMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView breakPointMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: canRemoveBreakpoint
            label: 'Remove Breakpoint'
            itemValue: removeBreakpoint
          )
         (MenuItem
            label: 'Remove all Breakpoints'
            itemValue: removeAllBreakpoints
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Ignore this Halt/BreakPoint'
            submenu:
           (Menu
              (
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'Forever (Until Ignoring is Stopped)'
                  itemValue: ignoreHaltForever
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'For Some Time...'
                  itemValue: openIgnoreHaltUntilTimeElapsedDialog
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'For the Next N Times...'
                  itemValue: openIgnoreHaltNTimesDialog
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'Until Shift-Key is Pressed'
                  itemValue: ignoreHaltUntilShiftKeyIsPressed
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'In Current Process'
                  itemValue: ignoreHaltForCurrentProcess
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'For this Receiver Class'
                  itemValue: ignoreHaltForThisReceiverClass
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'If Called from Any Of'
                  submenuChannel: menuForIgnoreBreakpointIfCalledFromAnyOf
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: isStoppedAtBreakPointWithParameter
            label: 'Ignore all BreakPoints with this Parameter'
            submenu:
           (Menu
              (
               (MenuItem
                  enabled: isStoppedAtBreakPointWithParameter
                  label: 'Forever (Reenable in BreakPoint-Browser)'
                  itemValue: ignoreBreakpointsWithThisParameterForever
                )
               (MenuItem
                  enabled: isStoppedAtBreakPointWithParameter
                  label: 'For Some Time...'
                  itemValue: openIgnoreBreakpointsWithThisParameterUntilTimeElapsedDialog
                )
               (MenuItem
                  enabled: isStoppedAtBreakPointWithParameter
                  label: 'For the Next N Times...'
                  itemValue: openIgnoreBreakpointsWithThisParameterNTimesDialog
                )
               (MenuItem
                  enabled: isStoppedAtBreakPointWithParameter
                  label: 'Until Shift-Key is Pressed'
                  itemValue: ignoreBreakpointsWithThisParameterUntilShiftKeyIsPressed
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'In Current Process'
                  itemValue: ignoreAllHaltsForCurrentProcess
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'For this Receiver Class'
                  itemValue: ignoreAllHaltsForThisReceiverClass
                )
               (MenuItem
                  enabled: isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
                  label: 'If Called from Any Of'
                  submenuChannel: menuForIgnoreAllBreakpointsIfCalledFromAnyOf
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Ignore all Halts/BreakPoints'
            submenu:
           (Menu
              (
               (MenuItem
                  label: 'Forever (Until Ignoring is Stopped)'
                  itemValue: ignoreAllHaltsForever
                )
               (MenuItem
                  label: 'For Some Time...'
                  itemValue: openIgnoreAllHaltsUntilTimeElapsedDialog
                )
               (MenuItem
                  label: 'Until Shift-Key is Pressed'
                  itemValue: ignoreAllHaltsUntilShiftKeyIsPressed
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: hasHaltsToIgnore
            label: 'Stop Ignoring'
            itemValue: stopIgnoringHalts
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canAddBreakpoint
            label: 'Add Breakpoint'
            itemValue: addBreakpoint
          )
         (MenuItem
            label: 'Manage Breakpoints'
            itemValue: openBreakPointBrowser
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Allow Halt in Debugger'
            itemValue: allowBreakPointsInDebugger:
            indication: allowBreakPointsInDebugger
          )
         )
        nil
        nil
      )
!

classMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#receiverMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView receiverMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: canBrowseImplementingClass
            label: 'Browse Implementing Class'
            itemValue: browseImplementingClass
          )
         (MenuItem
            enabled: canBrowseReceiversClass
            label: 'Browse Receiver''s Class'
            itemValue: browseReceiversClass
          )
         (MenuItem
            enabled: canBrowseProcessesApplication
            label: 'Browse Application Class'
            itemValue: browseProcessesApplication
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canBrowseClassHierarchy
            label: 'Browse Receiver''s Class Hierarchy'
            itemValue: browseClassHierarchy
            isVisible: false
          )
         (MenuItem
            enabled: canBrowseFullClassProtocol
            label: 'Browse Receiver''s Full Protocol'
            itemValue: browseFullClassProtocol
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            enabled: canBrowseProcessesApplication
            label: 'Inspect Application'
            itemValue: inspectProcessesApplication
          )
         (MenuItem
            enabled: canInspectWidgetHierarchy
            label: 'Inspect Widget Hierarchy'
            itemValue: inspectWidgetHierarchy
          )
         )
        nil
        nil
      )

    "Modified: / 25-11-2016 / 13:14:28 / cg"
!

contextMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#contextMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView contextMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: canReturn
            label: 'Return'
            itemValue: doReturn
            shortcutKey: DebuggerReturn
          )
         (MenuItem
            enabled: canRestart
            label: 'Restart'
            itemValue: doRestart
            shortcutKey: DebuggerRestart
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasContextSelected
            label: 'Inspect'
            itemValue: inspectContext
          )
         (MenuItem
            label: 'Copy WalkBack Text'
            itemValue: copyWalkbackText
          )
         (MenuItem
            label: 'Inspect Method'
            itemValue: inspectContextsMethod
          )
         (MenuItem
            label: 'Bookmark Method in SystemBrowser'
            itemValue: addBrowserBookmark
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasBlockContextSelected
            label: 'Find Home Context in Caller Chain...'
            itemValue: findHomeContext
          )
         (MenuItem
            enabled: hasContextSelected
            label: 'Find Context with String in Source...'
            itemValue: findContextWithStringInSource
          )
         (MenuItem
            enabled: hasContextSelected
            label: 'Find Context with Value in Variable...'
            itemValue: findContextWithValueInVariable
          )
         (MenuItem
            enabled: hasContextSelected
            label: 'Find Next Exception Handler'
            itemValue: findNextExceptionHandlerContext
          )
         (MenuItem
            enabled: hasContextSelected
            label: 'Find Handler For...'
            itemValue: findHandlerFor
          )
         (MenuItem
            label: 'Find Dialog Opener...'
            itemValue: doGotoDialogOpener
          )
         (MenuItem
            label: 'Find Application Action Method...'
            itemValue: doGotoApplicationActionMethod
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Remember Callchain && Highlight on Next Entry'
            itemValue: rememberCallchain
          )
         (MenuItem
            label: 'Clear Remembered Callchain'
            itemValue: clearRememberedCallchain
          )
         )
        nil
        nil
      )

    "Modified: / 13-10-2017 / 22:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#fileMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView fileMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: canSendEmail
            label: 'Report a Bug via eMail...'
            itemValue: doOpenReportMailApp
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canCloseAllDebuggers
            label: 'Close all Debuggers...'
            itemValue: closeAllDebuggers
            isVisible: isNotInspecting
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Exit'
            itemValue: closeRequest
            isVisible: isInspecting
          )
         (MenuItem
            label: 'Close Debugger and Abort'
            itemValue: closeRequest
            isVisible: isNotInspecting
          )
         )
        nil
        nil
      )
!

helpMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#helpMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView helpMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'Debugger''s Documentation'
            itemValue: openHTMLDocument:
            argument: 'tools/debugger/TOP.html'
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'About DebugView...'
            itemValue: openAboutThisApplication
          )
         )
        nil
        nil
      )
!

menuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView menuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenuChannel: fileMenuSpec
          )
         (MenuItem
            label: 'View'
            submenuChannel: viewMenuSpec
          )
         (MenuItem
            label: 'Process'
            submenuChannel: processMenuSpec
          )
         (MenuItem
            label: 'Context'
            submenuChannel: contextMenuSpec
          )
         (MenuItem
            label: 'Receiver'
            submenuChannel: classMenuSpec
          )
         (MenuItem
            label: 'Selector'
            submenuChannel: selectorMenuSpec
          )
         (MenuItem
            label: 'Breakpoint'
            submenuChannel: breakPointMenuSpec
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenuChannel: helpMenuSpec
          )
         )
        nil
        nil
      )
!

processMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#processMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView processMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Continue'
            itemValue: doContinue
            nameKey: Continue
            shortcutKey: DebuggerContinue
          )
         (MenuItem
            label: 'Debug_Next'
            itemValue: doNext
            shortcutKey: DebuggerNext
          )
         (MenuItem
            label: 'Debug_Step'
            itemValue: doStep
            shortcutKey: DebuggerStep
          )
         (MenuItem
            label: 'Debug_Send'
            itemValue: doSend
            shortcutKey: DebuggerSend
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'After 5 Seconds'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Continue'
                  itemValue: doContinueAfterDelay
                )
               (MenuItem
                  label: 'Next (Line-Step)'
                  itemValue: doNextAfterDelay
                )
               (MenuItem
                  label: 'Step'
                  itemValue: doStepAfterDelay
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Skip to Cursor Line'
            itemValue: skip
          )
         (MenuItem
            label: 'Step Out (Skip until Return)'
            itemValue: skipForReturn
          )
         (MenuItem
            label: 'Skip until Entering...'
            itemValue: skipUntilEntering
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Abort'
            itemValue: doAbort
            shortcutKey: DebuggerAbort
          )
         (MenuItem
            enabled: abortAllIsHandled
            label: 'Abort All'
            itemValue: doAbortAll
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect'
            itemValue: doInspectProcess
          )
         (MenuItem
            label: 'Change Priority...'
            itemValue: doChangeProcessPriority
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Debug_Terminate'
            itemValue: doTerminate
            shortcutKey: DebuggerTerminate
          )
         (MenuItem
            label: 'Hard Terminate (Danger)'
            itemValue: quickTerminate
            isVisible: false
          )
         )
        nil
        nil
      )

    "Modified: / 13-10-2017 / 22:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#selectorMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView selectorMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'Browse Implementors...'
            itemValue: browseImplementorsOf
          )
         (MenuItem
            label: 'Browse Senders...'
            itemValue: browseSendersOf
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canDefineMethod
            label: 'Define Missing Method'
            itemValue: doDefineMethod
            shortcutKey: DebuggerDefine
          )
         )
        nil
        nil
      )

    "Modified: / 13-10-2017 / 22:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

viewMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DebugView andSelector:#viewMenuSpec
     (Menu new fromLiteralArrayEncoding:(DebugView viewMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: canShowMore
            label: 'Show More WalkBack'
            itemValue: showMoreWalkback
          )
         (MenuItem
            enabled: canShowMore
            label: 'Show Full WalkBack'
            itemValue: showFullWalkback
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show Dense WalkBack'
            itemValue: showingDenseWalkback:
            hideMenuOnActivated: false
            indication: showingDenseWalkback
          )
         (MenuItem
            enabled: notShowingDenseWalkbackHolder
            label: 'Show Support Code (Implementation of Enumerations, Exceptions etc.)'
            itemValue: showingSupportCode:
            hideMenuOnActivated: false
            indication: showingSupportCode
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Raise Debugger when Entering'
            itemValue: autoRaiseView:
            hideMenuOnActivated: false
            indication: autoRaiseView
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Settings...'
            itemValue: openSettingsDialog
          )
         )
        nil
        nil
      )
! !

!DebugView class methodsFor:'misc'!

interestingContextFrom:aContext
    "return an interesting context to be shown in an error notifier.
     We move up the calling chain, skipping intermediate Signal
     and Exception contexts, to present the context in which the error
     actually occurred.
     Just for your convenience :-)"

    |someContexts con idx|

    "/ fetch some contexts...
    someContexts := Array new:25.
    con := aContext.
    idx := 1.
    [(idx <= someContexts size) and:[con notNil]] whileTrue:[
        someContexts at:idx put:con.
        con := con sender.
        idx := idx + 1.
    ].
    "/ search...
    idx := self interestingContextIndexIn:someContexts.
    ^ someContexts at:idx.

    "Modified: / 28-08-2013 / 20:12:47 / cg"
!

interestingContextIndexIn:aContextArray
    "return an interesting context's index, or nil.
     This is the context initially shown (selected) in the walkback.
     We move up the calling chain, skipping all intermediate Signal
     and Exception contexts, to present the context in which the error actually occurred.
     Just for your (my) convenience :-)"

    |con found offset sel prev rcvr nMax idx methodHome method|

"/ Transcript showCR:'x'.
"/ Transcript showCR:aContextArray.

    nMax := aContextArray size.
    nMax <= 1 ifTrue:[^ 1].
    con := aContextArray at:1.
    con isBlockContext ifTrue:[^ 1].
    (con method notNil and:[ con method isWrapped ]) ifTrue:[^ 1].  "/ we are already there

    "/ somewhere, at the bottom, there must be a raise ...
    "/ find the exception
    1 to:5 do:[:i |
        found isNil ifTrue:[
            con := aContextArray at:i ifAbsent:nil.
            con notNil ifTrue:[
                sel := con selector ? ''.
                (sel isSymbol
                and:[ (sel startsWith:'raise')
                and:[ ((rcvr := con receiver) isProtoObject not)
                and:[ rcvr isExceptionCreator]]]) ifTrue:[
                    offset := i.
                    found := con.

                    "/ if this is a noHandler exception,
                    "/ skip forward to the erroneous context
                    (rcvr isException) ifTrue:[
                        rcvr creator == Signal noHandlerSignal ifTrue:[
                            found := rcvr suspendedContext.
                            offset := aContextArray identityIndexOf:found.
                        ]
                    ].
                ].
            ].
        ].
    ].
"/ Transcript showCR:con.
"/ Transcript show:'1 '; showCR:found.

    found isNil ifTrue:[
        "/ this is a kludge, but convenient.
        "/ show the place where the error (divisionByZero...) happend,
        "/ not where the signal was raised.
        con := (aContextArray at:1).
        sel := con methodHome selector.

"/ Transcript show:'2 '; showCR:con.
        "/ typically a DivisionByZero - show caller of division
        (sel == #//
        or:[sel == #/
        or:[sel == #\\]]) ifTrue:[
            ^ 2
        ].

        "/ show the place of the bad message; not where the Signal was raised...
        (sel == #doesNotUnderstand:) ifTrue:[
            idx := 3.
            nMax > 2 ifTrue:[
                sel := (aContextArray at:idx) selector ? ''.
                sel == #doesNotUnderstand: ifTrue:[
                    idx := 4
                ].
                nMax > idx ifTrue:[
                    sel := (aContextArray at:idx) selector ? ''.
                    "/ show the place of the perfor-send; not where the Signal was raised...
                    ((sel == #perform:)
                    or:[sel startsWith:'perform:with']) ifTrue:[
                        idx := idx + 1
                    ].
                ]
            ].
            ^ idx min:nMax
        ].

        "/ show the bad method; not where the Signal was raised...
        (sel == #noByteCode) ifTrue:[
            ^ 2
        ].

"/        "/ show the place of the halt; not where the HaltSignal was raised...
"/        ((sel == #halt) or:[sel == #halt:]) ifTrue:[
"/            ^ 2
"/        ].

"/        "/ show the place of the shouldImplement; not where the Signal was raised...
"/        (sel == #shouldImplement) ifTrue:[
"/            ^ 2
"/        ].

"/        "/ show the place of error-call; not where the ErrorSignal was raised...
"/        ((sel == #error:mayProceed:)
"/        or:[ sel == #signalFailure:resumable:]) ifTrue:[
"/            nMax > 2 ifTrue:[
"/                sel := (aContextArray at:2) selector.
"/                sel == #mustBeBoolean ifTrue:[
"/                    ^ 3
"/                ].
"/            ].
"/            ^ 2
"/        ].

        "/ show the place of signalInterrupt-call; not where the Signal was raised...
        (sel == #signalInterrupt:) ifTrue:[
            ^ 2
        ].

"/        "/ show the place of error-call; not where the ErrorSignal was raised...
"/        ((sel == #error) or:[sel == #error:]) ifTrue:[
"/            con method mclass == Object ifTrue:[
"/                ^ 2
"/            ]
"/        ].

"/        "/ show the place of the send; not where the Signal was raised...
"/        (sel == #subclassResponsibility) ifTrue:[
"/            ^ 2
"/        ].

        "/ show the place of the bad index; not where the Signal was raised...
        ( #(#notIndexed
            #indexNotIntegerOrOutOfBounds:
            #subscriptBoundsError:
            #elementBoundsError:
            "/ #subclassResponsibility
        ) includes:sel) ifTrue:[
            idx := 2.
            [ idx <= 3
                and:[
                    sel := (aContextArray at:idx) selector.
                    #(#notIndexed
                      #indexNotIntegerOrOutOfBounds:
                      #subscriptBoundsError:
                      #elementBoundsError: ) includes:sel
                ]
            ] whileTrue:[ idx := idx + 1 ].
            sel := (aContextArray at:idx) selector.
            (nMax > idx and:[ #(#basicAt: #basicAt:put: #at: #at:put: ) includes:sel])
            ifTrue:[
                sel := (aContextArray at:idx+1) selector.
                (nMax > (idx+1) and:[ #(#basicAt: #basicAt:put: #at: #at:put: ) includes:sel])
                ifTrue:[
                    sel := (aContextArray at:idx+2) selector.
                    (nMax > (idx+2) and:[ #(#basicAt: #basicAt:put: #at: #at:put: ) includes:sel])
                    ifTrue:[
                        ^ idx+3
                    ].
                    ^ idx+2
                ].
                ^ idx+1
            ].
            ^ idx
        ].
        offset := 1.
    ].

    "/ the above is all too hard-coded;
    "/ ask the method, if it thinks it should be skipped in the walkback.
    "/ as more methods get flagged, remove code from above.
    con := aContextArray at:offset ifAbsent:nil.
"/ Transcript show:'2 '; showCR:con.
    [
        con notNil
        and:[ (methodHome := con methodHome) notNil
        and:[ (method := methodHome method) notNil
        and:[ method shouldBeSkippedInDebuggersWalkBack ]]]
    ] whileTrue:[
"/ Transcript showCR:con methodHome method.
        offset := offset + 1.
        con := aContextArray at:offset ifAbsent:nil.
    ].
    methodHome := nil. "/ help GC

    "
     got it; move up, skipping all intermediate Signal and
     Exception contexts
    "
    prev := nil.
    rcvr := con receiver.
    [
        rcvr isProtoObject not and:[(rcvr isExceptionHandler) or:[(rcvr isException)]]
    ] whileTrue:[
        prev := con.
        nMax > offset ifFalse:[^ offset].

        offset := offset + 1.
        con := aContextArray at:offset.
        rcvr := con receiver.
    ].

    "
     now, we are one above the raising context
    "
"/ Transcript show:'3 '; showCR:con.

    (con selector == #retry:coercing:) ifTrue:[
        "/ show the operation which failed to coerce, not the coerce
        ^ offset + 1
    ].

    "
     if the sender-method of the raise is one of object's error methods ...
    "
    ( #( halt halt:
         error error:
         doesNotUnderstand:
         subclassResponsibility
         primitiveFailed) includes:con selector)
    ifTrue:[
        con selector == #doesNotUnderstand: ifTrue:[
            "
             one more up, to get to the originating context
            "
            con := aContextArray at:(offset + 1).
            con isNil ifTrue:[^ offset].
            offset := offset + 1.
        ].
        con := aContextArray at:(offset + 1).
        con isNil ifTrue:[^ offset].
        offset := offset + 1.
    ] ifFalse:[
        "
         ok, got the raise - if its a BreakPoint, look for the sender
        "
        (prev notNil and:[prev receiver == BreakPointInterrupt]) ifTrue:[
            offset := offset + 1
        ].
    ].

    ^ offset

    "Created: / 17-11-2001 / 20:37:49 / cg"
    "Modified: / 28-08-2013 / 20:23:35 / cg"
! !

!DebugView class methodsFor:'utilities'!

withOptionToIgnoreException:exceptionOrHandlerSet do:aBlock
    "execute aBlock; 
     if any from exceptionOrHandlerSet is raised during the execution,
     open a confitmation dialog, asking if the debugger should be entered.
     For halts/breakpoints, honors the ignored halt/break list;
     also, two checkboxes are added, to also ignore them in the future"

    ^ exceptionOrHandlerSet 
        handle:[:ex |     
            |msg descr where whatError showIgnoreOptions 
             ignoreForSomeTimeHolder ignoreForEverHolder 
             lineNrOfHalt haltingMethod resources|

            showIgnoreOptions := false.
            ignoreForSomeTimeHolder := false asValue.
            ignoreForEverHolder := false asValue.

            (ControlInterrupt accepts:ex creator) ifTrue:[
                |suspendedContext sender|
                
                "/ also deal with ignored breakpoints here;
                "/ otherwise, it is almost impossible to place a breakpoint into
                "/ RB-code, and ignoring it...
                suspendedContext := ex suspendedContext.
                sender := suspendedContext sender.
                "/ suspendedContext selector == #break ifTrue:[
                "/     lineNrOfHalt := sender lineNumber.
                "/     haltingMethod := sender method.
                "/  ] ifFalse:[
                    lineNrOfHalt := sender lineNumber.
                    haltingMethod := sender method.
                "/ ]. 
                suspendedContext := sender := nil.
                "/ Transcript showCR:haltingMethod.
                "/ Transcript showCR:lineNrOfHalt.
                (self 
                    isHaltToBeIgnoredIn:haltingMethod
                    atLineNr:lineNrOfHalt
                    context:nil
                    modifyEntryCount:false
                ) ifTrue:[
                    Transcript showCR:'breakpoint ignored in background processing'.
                    ^ ex proceed.
                ].
                showIgnoreOptions := true.
                whatError := 'Halt/Breakpoint:'
            ] ifFalse:[
                whatError := 'Error encountered:'
            ].

            resources := self resources.
            descr := ex description allBold.
            where := ex suspendedContext printString.

            Dialog modifyingBoxWith:[:box |
                showIgnoreOptions ifTrue:[
                    box verticalPanel 
                        add:(View new height:20);
                        add:(CheckBox
                                    label:(resources string:'Ignore this Halt/Break for some time (30s)')
                                    model:ignoreForSomeTimeHolder);
                        add:(CheckBox
                                    label:(resources string:'Ignore this Halt/Break forever')
                                    model:ignoreForEverHolder).
                ].    
            ] do:[
                |answer canRemove labels actions|

                "/ cannot remove halts or coded breakpoints.                
                canRemove := haltingMethod notNil and:[haltingMethod isMethodWithBreakpoints or:[ haltingMethod isBreakpointed ]].
                labels := #('Ignore' 'Remove Breakpoint' 'Debug' ).
                actions := #(ignore remove debug).
                canRemove ifFalse:[
                    labels := #('Ignore' 'Debug' ).
                    actions := #(ignore debug).
                ].    

                answer := OptionBox
                            choose:(self resources 
                                        stringWithCRs:'%1\%2\\%3'
                                        with:whatError
                                        with:descr
                                        with:where)
                            label:whatError 
                            image:nil 
                            labels:(resources array:labels)
                            values:actions 
                            default:#ignore 
                            onCancel:#ignore.
"/                answer := Dialog
"/                            confirm:(self resources 
"/                                        stringWithCRs:'%1\%2\\%3'
"/                                        with:whatError
"/                                        with:descr
"/                                        with:where)
"/                            yesLabel:(resources string:'Debug')
"/                            noLabel:(resources string:'Ignore').
                
                (ignoreForSomeTimeHolder value or:[ignoreForEverHolder value]) ifTrue:[
                    self
                        ignoreHaltIn:haltingMethod at:lineNrOfHalt
                        forCount:(ignoreForEverHolder value ifTrue:[-1] ifFalse:[nil]) 
                        orTimeDuration:(ignoreForSomeTimeHolder value ifTrue:[30 seconds] ifFalse:[nil]) 
                        orUntilShiftKey:false
                        orReceiverClass:nil orProcess:nil
                        orIfCalledFromMethod:nil.
                ].

                answer == #remove ifTrue:[
                    haltingMethod isMethodWithBreakpoints ifTrue:[
                        haltingMethod disableBreakpointInLine:lineNrOfHalt
                    ] ifFalse:[
                        haltingMethod isBreakpointed ifTrue:[
                            haltingMethod clearBreakPoint
                        ].    
                    ].
                    ex proceed
                ].
                answer == #debug ifTrue:[
                    ex reject.
                ].
                ex proceed
            ]
        ] 
        do:aBlock.
    
    "
     HaltInterrupt withOptionToIgnoreDo:[self halt]   -- catches this
     HaltInterrupt withOptionToIgnoreDo:[self error]  -- but not this  

     -- catches both, but disable buttons are only shown for halt/breaks
     ControlInterrupt withOptionToIgnore:(HaltInterrupt,Error) do:[self halt]
     ControlInterrupt withOptionToIgnore:(HaltInterrupt,Error) do:[self error]
    "

    "Modified: / 25-07-2016 / 19:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView methodsFor:'accessing'!

contextInspector
    ^ contextInspector
!

inspectedProcess
    ^ inspectedProcess
!

keyboardMap
    keyboardMap isNil ifTrue:[ 
        self initializeKeyboardMap.
    ].
    ^keyboardMap

    "
    WorkspaceApplication new open; yourself
    "

    "Created: / 02-02-2017 / 00:16:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2017 / 00:25:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView methodsFor:'accessing-keyboard mappings'!

shortKeyStringForAction: aSymbol
    | shortcut |

    shortcut := self shortKeyStringFor: aSymbol.
    ^ shortcut isNil 
        ifTrue:[ '' ]
        ifFalse:[ '  -  ' , shortcut].

    "Created: / 11-05-2017 / 21:04:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView methodsFor:'aspects'!

verboseBacktraceHolder
    verboseBacktraceHolder isNil ifTrue:[
        verboseBacktraceHolder := ValueHolder with:false
    ].
    ^ verboseBacktraceHolder
! !

!DebugView methodsFor:'basic'!

enableDisableActions
    |m|

    m := contextView middleButtonMenu.
    m notNil ifTrue:[
        self updateMenuItems.

        (inspecting or:[AbortOperationRequest isHandled]) ifTrue:[
            abortButton enable.
            m enable:#doAbort.
        ] ifFalse:[
            abortButton disable.
            m disable:#doAbort.
        ].
        exclusive ifTrue:[
            terminateButton disable.
            m disable:#doTerminate.
        ] ifFalse:[
            terminateButton enable.
            m enable:#doTerminate.
        ]
    ].

    mayProceed == false ifTrue:[
        continueButton disable.
        m notNil ifTrue:[m disable:#doContinue].
    ] ifFalse:[
        continueButton enable.
        m notNil ifTrue:[m enable:#doContinue]
    ].

    "Created: / 16.11.2001 / 17:40:51 / cg"
!

enter
    "enter a debugger"

    <context: #return>

    ^ self
        enter:thisContext sender
        select: nil.

    "Modified: / 28-08-2012 / 21:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enter:aContext select:initialSelectionOrNil
    "enter the debugger - get and display the context, then start an
     exclusive event loop on top of eveything else"

    <context: #return>

    |con m enteredByInterrupt sel iAmNew foundNoByteCodeContext foundExitContext c 
     userprefs logFile|

    DebuggingDebugger == true ifTrue:[
        '==> enter2: (' print. aContext print.
        ') select: ' print. initialSelectionOrNil printCR.
    ].
    thisContext isRecursive ifTrue:[
        "/ care for the special case, were the Debugger was autoloaded.
        "/ in this case, thisContext IS recursive, but that's no error condition.
        foundNoByteCodeContext := false.
        foundExitContext := false.

        c := thisContext findNextContextWithSelector:#enter:withMessage:mayProceed: or:#noByteCode or:#exit_unwindThenDo:.
        [
         foundNoByteCodeContext not
         and:[ foundExitContext not
         and:[c notNil
         and:[c selector ~~ #enter:withMessage:mayProceed:
        ]]]]
        whileTrue:[
            c selector == #exit_unwindThenDo: ifTrue:[
                foundExitContext := true
            ].
            c selector == #noByteCode ifTrue:[
                foundNoByteCodeContext := true
            ].
            c := c findNextContextWithSelector:#enter:withMessage:mayProceed: or:#noByteCode or:#exit_unwindThenDo:.
        ].

        (foundNoByteCodeContext not
        and:[ foundExitContext not]) ifFalse:[
            ('DebugView [warning]: reentered') errorPrintCR.

            ^ MiniDebugger
                enter:aContext
                withMessage:'DebugView [error]: recursive error (in debugger)'
                mayProceed:mayProceed.
        ].
        foundExitContext ifTrue:[
            'DebugView [error]: recursive error (in debugger) ignored' printCR.
            ^ self.
        ].
    ].

    "/'entering: ' print. aContext printCR.
    "/'initial: ' print. initialSelectionOrNil printCR.
    thisContext sender fixAllLineNumbers. "/ _CONTEXTLINENOS(s)

    (self isHaltToBeIgnored) ifTrue:[
        ^ self.
    ].
"/    "/ does not work yet - but we should ignore any breakpoints while stepping
"/    (stepping and:[steppedContext notNil]) ifTrue:[
"/        self isEnteredDueToBreakpointOrHalt ifTrue:[
"/            'DebugView [info]: ignored other interrupt while stepping' infoPrintCR.
"/            ^ self
"/        ].
"/    ].
    userprefs := UserPreferences current.
    "/ optionally log this debugger entry
    (logFile := userprefs debuggerLogFile) notNil ifTrue:[
        logFile asFilename appendingFileDo:[:s |
            s cr.
            s nextPutLine:'-----------------------'.
            Timestamp now printOn:s. 
            s nextPutAll:' ['; nextPutAll:Processor activeProcess name; nextPutAll:']'; cr.
            s cr.
            aContext fullPrintAllOn:s
        ].    
    ].
    
    iAmNew := self drawableId isNil.

    self verboseBacktraceHolder value:(userprefs verboseBacktraceInDebugger).

    busy := cachable := true.
    inspecting := false.
    inspectedProcess := Processor activeProcess.
    stepping := false.
    bigStep := false.
    stepHow := nil.
    nChainShown := InitialNChainShown.

    "/ if debugger is entered while a box has grabbed the
    "/ pointer, we must ungrab - otherwise X won't talk to us here.

    "/ On a multiUser system, ungrab all of them ...
    "/ Q: this is good for multi-screen apps (where an error should not happen),
    "/    but not for multi-user development, where the debugger is entered often.
    "/    What is a good solution to this dilemma ?
    Screen allScreens do:[:aScreen |
        aScreen ungrabPointer.
        aScreen ungrabKeyboard.
    ].

    ("inspectedProcess suspendedContext isNil
    or:["inspectedProcess isSystemProcess"]") ifTrue:[
        terminateButton disable.
    ] ifFalse:[
        terminateButton enable.
        abortButton enable.
    ].

    iAmNew ifFalse:[
        "/ not the first time - disable buttons & menus
        "/ from the previous life
        self turnOffAllButtons.

        m := contextView middleButtonMenu.
        m notNil ifTrue:[
            m disableAll:#(showMore "skip skipForReturn" inspectContext).
        ].
        self showingDenseWalkback:(self verboseBacktraceHolder value not).
    ].
    self iconLabel:'Debugger'.

    windowGroup isNil ifTrue:[
        self windowGroup: WindowGroup new.
        windowGroup addTopView:self.
    ].
    exclusive ifFalse:[
        "/ create a (modal) windowGroup for myself

        windowGroup setModal:true.
    ] ifTrue:[
        "/ create a windowGroup with a synchronous sensor for me

        windowGroup beSynchronous.
    ].
    windowGroup setProcess:Processor activeProcess.
    IsDebuggingQuery answer:true do:[

        "
         get the walkback list; clear inspectors if we did not come here by single stepping)
        "
"/Transcript show:'0 '; showCR:aContext.
"/Transcript show:'0 '; showCR:thisContext sender.
"/Transcript show:'0 '; showCR:thisContext sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender sender sender .
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender sender sender sender sender.
"/Transcript show:'0 '; showCR:thisContext sender sender sender sender sender sender sender sender sender sender sender.
"/Transcript showCR:initialSelectionOrNil.
        self setContext:aContext releaseInspectors:(exitAction ~~ #step).
        "/'after setContext; first is ' print.
        "/(contextArray at:1 ifAbsent:nil) printCR.
        self setInitialSelectionOnEntry:initialSelectionOrNil context:aContext.

        self updateButtonsAndMenuItemsForContext:aContext.

        "
         If this is a new debugger, do a realize.
         Otherwise, its probably better to do a map, which shows the
         view at the previous position, without a need for the user to set the
         position again
        "
        iAmNew ifTrue:[
            self realize.
        ] ifFalse:[
            self remap.
        ].
        self setForegroundWindow.

        exclusive ifTrue:[
            self showError:'
Debugging system process `' , (inspectedProcess nameOrId) printString , '''.

This is a modal debugger - all event processing is stopped..
Therefore, you cannot interact with other views or
open any other tools while this debugger is active.

Also, there is no event processing (redraw) for other views.'
        ].

        self autoRaiseView ifTrue:[
            "/ self raise.
            self raiseDeiconified.
            self topView activate; setForegroundWindow; activate.
        ].

        canContinue := true.
        exitAction := nil.

        "/ enter private event handling loop. This is left (and we come back here again)
        "/ when any button was pressed which requires continuation of the debuggee or
        "/ closedown of the debugger.
        [self controlLoop] ifCurtailed:[
            windowGroup notNil ifTrue:[
                windowGroup setProcess:nil.
            ].
            NumberOfDebuggers := (NumberOfDebuggers ? 1) - 1.
            self destroy
        ].
        NumberOfDebuggers := (NumberOfDebuggers ? 1) - 1.
    ].
    "/ here after my own control loop is finished.

    "/ release all context stuff.
    "/ This is required to avoid keeping references to the debuggees objects
    "/ forever. (since the debugger is reused for faster startup next time)
    contextView contents:nil.

    codeView acceptAction:nil.
    codeView doItAction:nil.

    ObjectMemory stepInterruptHandler == self ifTrue:[
        ObjectMemory stepInterruptHandler:nil.
    ].

    lastSelectionInReceiverInspector := receiverInspector selectedKeyName.
    lastSelectionInContextInspector := contextInspector selectedKeyName.

    (exitAction ~~ #step) ifTrue:[
        "/ not stepping or continue - close window
        self cacheMyself.
        receiverInspector release.
        contextInspector release.

        self unmap.
        self flush.

        (exitAction == #abort) ifTrue:[ self exit_abort. "does not return" ].
        (exitAction == #abortAll) ifTrue:[ self exit_abortAll. "does not return" ].
        (exitAction == #return) ifTrue:[ self exit_return. "does not return" ].
        (exitAction == #restart) ifTrue:[ self exit_restart. "does not return" ].
        (exitAction == #resend) ifTrue:[ self exit_resend. "does not return" ].
        (exitAction == #quickTerminate) ifTrue:[ self exit_quickTerminate. "does not return" ].
        (exitAction == #terminate) ifTrue:[ self exit_terminate. "does not return" ].
        exitAction isBlock ifTrue:[
            self exit_unwindThenDo:exitAction.
            "does not return"
        ].
        "not reached"
        ^ self
    ].

    "/ stepping - window stays open
    selectedContext := actualContext := firstContext := nil.

    "/ restore the previous pointer grab
    grabber notNil ifTrue:[
        device grabPointerInView:grabber.
        grabber := nil.
    ].

    (exitAction == #step) ifTrue:[
        "
         schedule another stepInterrupt
         - must enter myself into the collection of open debuggers,
           in case the stepping process comes back again via a halt or signal
           before the step is finished. In this case, the stepping debugger should
           come up (instead of a new one)
         - must flush caches since optimized methods not always
           look for pending interrupts
        "

        "/
        "/ also must care for stepping into a return
        "/
        steppedContext notNil ifTrue:[
            Processor activeProcess forceInterruptOnReturnOf:steppedContext.
        ].

        OpenDebuggers isNil ifTrue:[
            OpenDebuggers := WeakIdentitySet new.
        ].
        OpenDebuggers add:self.

        self label:'single stepping - please wait ...'.
        stepping := true.

        ObjectMemory stepInterruptHandler:self.
        Processor activeProcess stepInterruptHandler:self.
        ObjectMemory flushCaches.

        Context singleStepInterruptRequest isHandled ifTrue:[
            Context singleStepInterruptRequest
                raiseWith:
                    (("bigStep" steppedContextLineno notNil)
                        ifTrue:[#next]
                        ifFalse:[#step])
        ] ifFalse:[
            "/ see if we came here through an interrupt-action
            "/ (i.e. aProcess interruptWith:...)

            enteredByInterrupt := false.
            con := thisContext findNextContextWithSelector:#timerInterrupt or:#ioInterrupt or:nil.
            [enteredByInterrupt not
             and:[con notNil
             and:[con ~~ aContext]]] whileTrue:[
                ((sel := con selector) == #timerInterrupt
                or:[sel == #ioInterrupt]) ifTrue:[
                    enteredByInterrupt := true.
                ] ifFalse:[
                    con := con findNextContextWithSelector:#timerInterrupt or:#ioInterrupt or:nil.
                ].
            ].

            ObjectMemory flushInlineCaches.

            DebuggingDebugger == true ifTrue:[
                enteredByInterrupt printCR.
            ].
            enteredByInterrupt ifTrue:[
                "/ don't want to step through all intermediate
                "/ (scheduler-) contexts; place a return-trap on the
                "/ one right below the interesting one

"/                'special unwind return' printCR.
                con unwindThenDo:[
                                  Processor activeProcess stepInterruptHandler:self.
                                  ObjectMemory stepInterruptHandler:self.
                                  InStepInterrupt := nil.
                                  StepInterruptPending := 1.
                                  InterruptPending := 1].
            ] ifFalse:[
"/                'normal step return' printCR.
                skipLineNr ~~ #return ifTrue:[
                    StepInterruptPending := 1.
                    InterruptPending := 1.
                ] ifFalse:[
"/                    'step for return' printCR.
                ]
            ].
            InStepInterrupt := nil
        ]
    ] ifFalse:[
        OpenDebuggers notNil ifTrue:[
            OpenDebuggers remove:self ifAbsent:[].
        ].
        self cacheMyself.
    ]

    "Modified: / 17-04-1997 / 13:01:32 / stefan"
    "Created: / 30-10-1997 / 21:08:18 / cg"
    "Modified: / 13-10-1998 / 19:56:59 / ps"
    "Modified: / 27-07-2012 / 17:35:56 / cg"
!

exit_abort
    "/ cannot simply raise an abort here, because if there is an abortHandler somewhere,
    "/ that one would run on top of this context.
    "/ Therefore, any controlInterrupt(i.e. halt) or reentering of the debugger from that handler
    "/ would be interpreted as a recursive invocation (in #enter:select).
    "/ To avoid this, we unwind all contexts and simulate the raise as if it was
    "/ done in the #enter:select method.
    "/ You are not expected to understand this.

    self exit_unwindThenDo:[ AbortOperationRequest raise ]
!

exit_abortAll
    "/ cannot simply raise an abort here, because if there is an abortHandler somewhere,
    "/ that one would run on top of this context.
    "/ Therefore, any controlInterrupt(i.e. halt) or reentering of the debugger from that handler
    "/ would be interpreted as a recursive invocation (in #enter:select).
    "/ To avoid this, we unwind all contexts and simulate the raise as if it was
    "/ done in the #enter:select method.
    "/ You are not expected to understand this.

    self exit_unwindThenDo:[ AbortAllOperationRequest raise ]
!

exit_quickTerminate
    self cacheMyself.
    Processor activeProcess terminateNoSignal

    "Created: / 16.11.2001 / 17:23:51 / cg"
    "Modified: / 17.11.2001 / 23:20:07 / cg"
!

exit_resend
    |con|

    selectedContext notNil ifTrue:[
        con := selectedContext.
        self cacheMyself.
        "
         have to catch errors occuring in unwind-blocks
        "
        Error handle:[:ex |
            'DebugView [info]: ignored error while unwinding: ' infoPrint.
            ex description infoPrintCR.
            ex proceed
        ] do:[
            ^ con unwindThenResend.
        ].
        'DebugView [warning]: cannot resend selected context''s message' errorPrintCR
    ]
!

exit_restart
    |con|

    selectedContext notNil ifTrue:[
        con := selectedContext.
        self cacheMyself.
        "
         have to catch errors occuring in unwind-blocks
        "
        Error handle:[:ex |
            'DebugView [info]: ignored error while unwinding: ' infoPrint.
            ex description infoPrintCR.
            ex proceed
        ] do:[
            con unwindAndRestart.
        ].
        'DebugView [warning]: cannot restart selected context' errorPrintCR
    ]

    "Created: / 16-11-2001 / 17:23:17 / cg"
    "Modified: / 26-09-2012 / 15:09:52 / cg"
!

exit_return
    |con retVal|

    retVal := nil.

    selectedContext notNil ifTrue:[
        "
         if there is a selection in the codeView,
         evaluate it and use the result as return value
        "
"/ disabled for now, there is almost always a selection (the current line)
"/ and that is syntactically incorrect ...
"/ ... leading to a popup warning from the codeView
"/
"/                codeView hasSelection ifTrue:[
"/                    Error handle:[:ex |
"/                        'DebugView [warning]: error - returning nil' errorPrintCR.
"/                        retVal := nil.
"/                        ex return
"/                    ] do:[
"/                        |s|
"/
"/                        s := codeView selection asString.
"/                        retVal := codeView doItAction value:s.
"/                    ].
"/                ].

        con := selectedContext.
        self cacheMyself.
        "
         have to catch errors occuring in unwind-blocks
        "
        Error handle:[:ex |
            'DebugView [info]: ignored error while unwinding: ' infoPrint.
            ex description infoPrintCR.
            ex proceed
        ] do:[
            con unwind:retVal.
        ].
        'DebugView [warning]: cannot return from selected context' errorPrintCR
    ]

    "Created: / 16.11.2001 / 17:22:24 / cg"
    "Modified: / 17.11.2001 / 23:20:21 / cg"
!

exit_terminate

    "
     have to catch errors occuring in unwind-blocks
    "
    Error handle:[:ex |
        'DebugView [info]: ignored error while unwinding: ' infoPrint.
        ex description infoPrintCR.
        ex proceed
    ] do:[
        self cacheMyself.
        Processor activeProcess terminate.
    ].
    'DebugView [warning]: cannot terminate process' errorPrintCR

    "Created: / 16.11.2001 / 17:24:20 / cg"
    "Modified: / 17.11.2001 / 23:20:27 / cg"
!

exit_unwindThenDo:aBlock
    |con|

    "/ cannot simply raise an abort here, because if there is an abortHandler somewhere,
    "/ that one would run on top of this context.
    "/ Therefore, any controlInterrupt(i.e. halt) or reentering of the debugger from that handler
    "/ would be interpreted as a recursive invocation (in #enter:select).
    "/ To avoid this, we unwind all contexts and simulate the raise as if it was
    "/ done in the #enter:select method.
    "/ You are not expected to understand this.

    "
     have to catch errors occuring in unwind-blocks
    "
    self cacheMyself.
    con := thisContext sender.

    Error handle:[:ex |
        'DebugView [info]: ignored error while unwinding: ' infoPrint.
        ex description infoPrintCR.
        ex proceed
    ] do:[
        "/ find the enter:select context.
        [(con selector ~~ #enter:select:) or:[con receiver ~~ self]] whileTrue:[
            con := con sender
        ].

        "/ must skip over its caller (because this one has a ControlInterrupt handler too)
        con sender receiver == self class ifTrue:[
            con := con sender.
            con sender receiver == self class ifTrue:[
                con := con sender methodHome.
            ].
        ].

        con unwindThenDo:aBlock.
    ].
    'DebugView [warning]: abort failed' errorPrintCR

    "Created: / 16.11.2001 / 17:20:45 / cg"
    "Modified: / 18.11.2001 / 00:58:14 / cg"
!

initialSelectionOnEntry:initialSelectionOrNil context:aContext
    |selection con1 con2 h|

    initialSelectionOrNil notNil ifTrue:[
        ^ initialSelectionOrNil
    ].

    "
     and find the one context to show initially
     - if we came here by a send (single step), its the top context;
     - if we came here by a step (i.e. bigStep), its the top context
       (for ifs and whiles) or the sender (for regular sends).
     - otherwise, we came here by some signal raise, and we are interested
       in the context where the raise actually occurred.
    "
    con1 := (contextArray at:1 ifAbsent:nil).
    con2 := (contextArray at:2 ifAbsent:nil).
"/ Transcript show:'x '; showCR:exitAction.

    "/ came here via a step?
    exitAction == #step ifTrue:[
        selection := 1.
        steppedContext notNil ifTrue:[

            "
             if we came here by a big-step, show the method where we are
            "
            con1 == steppedContext ifTrue:[
                selection := 1
            ] ifFalse:[
                con2 == steppedContext ifTrue:[
                    selection := 2
                ]
            ].
            "
             for bigStep, we could also be in a block below the actual method ...
            "
            ((h := con1 home) notNil
             and:[h == steppedContext]) ifTrue:[
                selection := 1
            ] ifFalse:[
                (con2 notNil
                and:[(h := con2 home) notNil
                and:[h == steppedContext]]) ifTrue:[
                    selection := 2
                ]
            ].
            h := nil.
        ]
    ] ifFalse:[
        steppedContext isNil ifTrue:[
            "
             preselect a more interesting context, (where halt/raise was ...)
            "
            "/ selection := self class interestingContextIndexFrom:aContext.
            selection := self class interestingContextIndexIn:contextArray.
"/ Transcript show:'x '; showCR:selection.
            selection := selection min:(contextArray size).
        ] ifFalse:[
            "
             if we came here by a big-step, show the method where we are
            "
            con1 == steppedContext ifTrue:[
                selection := 1
            ] ifFalse:[
                con2 == steppedContext ifTrue:[
                    selection := 2.
                ]
            ]
        ]
    ].
    ^ selection

    "Created: / 17.11.2001 / 20:26:26 / cg"
    "Modified: / 17.11.2001 / 22:51:46 / cg"
!

isInspecting
    ^ inspecting
!

isNotInspecting
    ^ inspecting not
!

openOn:aProcess
    "enter the debugger on a process -
     in this case, we are just inspecting the context chain of the process,
     not running on top of the debugged process, but as a separate
     one. (think of it as an inspector showing more detail, and offering
     some more control operations)"

    |bpanel dummy w|

    self verboseBacktraceHolder value:( UserPreferences current verboseBacktraceInDebugger ).

    busy := true.
    bigStep := false.
    stepHow := nil.
    inspecting := true.
    inspectedProcess := aProcess.
    nChainShown := InitialNChainShown.

    bpanel := abortButton superView.
    bpanel ignoreInvisibleComponents:true.

    "/ get the max size & freeze button
    continueButton label:(resources string:'Continue').
    w := continueButton preferredWidth.
    continueButton label:(resources string:'Stop').
    w := w max:(continueButton preferredWidth).
    continueButton preferredExtent:(w @ continueButton preferredHeight).

    aProcess state == #run ifTrue:[
        device hasColors ifTrue:[
            continueButton foregroundColor:Color red darkened.
        ].
        continueButton label:(resources string:'Stop').
        continueButton action:[self doStop].
    ] ifFalse:[
        device hasColors ifTrue:[
            continueButton foregroundColor:Color green darkened darkened.
        ].
        continueButton label:(resources string:'Continue').
        continueButton action:[self doContinue].
    ].
    continueButton preferredExtent:(w @ continueButton preferredHeight).

    returnButton disable.
    restartButton disable.

    dummy := View extent:(10 @ 5) in:bpanel.
    dummy borderWidth:0; level:0.

"/    stepButton destroy.
"/    sendButton destroy.

    updateButton := Button
                        label:(resources string:'Update')
                        action:[self updateContext]
                        in:bpanel.
    monitorToggle := Toggle in:bpanel.
    monitorToggle label:(resources string:'Monitor').
    monitorToggle pressAction:[self autoUpdateOn].
    monitorToggle releaseAction:[self autoUpdateOff].

    "can only look into process - context chain is not active"
    canContinue := true.

    terminateButton enable.
    abortButton enable.

    sendButton disable; beInvisible.
    stepButton disable; beInvisible.
    nextButton disable; beInvisible.
    nextOverButton notNil ifTrue:[nextOverButton disable; beInvisible].
    nextOutButton notNil ifTrue:[nextOutButton disable; beInvisible].

    aProcess isNil ifTrue:[
        terminateButton disable.
        abortButton disable.
        continueButton disable.
        returnButton disable.
        restartButton disable.
    ] ifFalse:[
        (aProcess suspendedContext isNil
        or:[aProcess isSystemProcess]) ifTrue:[
            terminateButton disable.
        ].

        self setContextSkippingInterruptContexts:aProcess suspendedContext.

        catchBlock := [
            catchBlock := nil.
            contextArray := nil.
            selectedContext := actualContext := firstContext := nil.
            steppedContext := wrapperContext := nil.

            (exitAction == #terminate) ifTrue:[
                aProcess terminate.
            ].
            (exitAction == #quickTerminate) ifTrue:[
                aProcess terminateNoSignal.
            ].
            super destroy
        ].
    ].
    self open

    "Modified: 20.3.1997 / 16:53:56 / cg"
    "Modified: 17.4.1997 / 13:01:57 / stefan"
!

selectContextWithIndex:index
    self showSelection:index.
    contextView setSelection:index.
    index > 1 ifTrue:[
        contextView scrollToLine:(index - 1)
    ].
!

setInitialSelectionOnEntry:initialSelectionOrNil context:aContext
    |selection|

    selection := self initialSelectionOnEntry:initialSelectionOrNil context:aContext.
    selection notNil ifTrue:[
        self selectContextWithIndex:selection
    ].

    "Created: / 16.11.2001 / 17:28:07 / cg"
    "Modified: / 17.11.2001 / 20:27:21 / cg"
!

turnOffAllButtons
    terminateButton turnOffWithoutRedraw.
    continueButton turnOffWithoutRedraw.
    returnButton turnOffWithoutRedraw.
    restartButton turnOffWithoutRedraw.
    abortButton turnOffWithoutRedraw.
    nextButton turnOffWithoutRedraw.
    stepButton turnOffWithoutRedraw.
    sendButton turnOffWithoutRedraw.

    "Created: / 16.11.2001 / 17:36:18 / cg"
! !


!DebugView methodsFor:'help'!

flyByHelpDependsOnPositionIn:aView
    "subclasses where the help-text depends upon the pointer position might
     want to redefine this"

    ^ aView == codeView
!

flyByHelpTextFor:aComponent
    |s|

    aComponent == codeView ifTrue:[
        |point localPoint|

        point := device pointerPosition.
        localPoint := device translatePointFromRoot:point toView:codeView.
        ((localPoint x between:0 and:codeView width)
        and:[localPoint y between:0 and:codeView height])
        ifTrue:[
            ^ self flyByHelpTextFor:codeView at:localPoint
        ].
        ^ nil
    ].

    aComponent == abortButton ifTrue:[
        s := 'Abort (unwind to eventLoop)'
    ].
    aComponent == terminateButton ifTrue:[
        Processor activeProcess isGUIProcess ifTrue:[
            s := 'Terminate the process.\Attention: closes view and shuts down application.'
        ] ifFalse:[
            s := 'Terminate the process.\Attention: do not kill a system thread'
        ]
    ].
    aComponent == continueButton ifTrue:[
        continueButton label = (resources string:'Stop') ifTrue:[
            s := 'Stop'
        ] ifFalse:[
            s := 'Continue execution'
        ]
    ].
    aComponent == stepButton ifTrue:[
        s := 'Step to next send in selected context (don''t enter into called methods)'
    ].
    aComponent == nextButton ifTrue:[
        s := 'Step to next line in selected context (don''t enter into called methods)'
    ].
    aComponent == nextOverButton ifTrue:[
        s := 'Step over to cursor-line'
    ].
    aComponent == nextOutButton ifTrue:[
        s := 'Step out to caller'
    ].
    aComponent == sendButton ifTrue:[
        s := 'Send next message (enter into called methods)'
    ].
    aComponent == returnButton ifTrue:[
        restartButton enabled ifTrue:[
            s := 'Return from the selected method'
        ] ifFalse:[
            s := 'Return from the selected method.\Disabled, because this method was compiled with context optimization, and cannot be returned from.' withCRs
        ]
    ].
    aComponent == restartButton ifTrue:[
        restartButton enabled ifTrue:[
            s := 'Restart the selected method.\If the code was changed in the meanwhile, the original method will be executed again'
        ] ifFalse:[
            s := 'Restart the selected method.\Disabled, because this method was compiled with context optimization, and cannot be returned from.' withCRs
        ]
    ].
    aComponent == resendButton ifTrue:[
        resendButton enabled ifTrue:[
            s := 'Resend the selected method''s message.\If the code was changed in the meanwhile, the new method will be called with the original arguments.'
        ] ifFalse:[
            s := 'Resend the selected method''s message.\Disabled, because this method was compiled with context optimization, and cannot be returned from.' withCRs
        ]
    ].
    aComponent == monitorToggle ifTrue:[
        s := 'Toggle monitoring'
    ].
    aComponent == updateButton ifTrue:[
        s := 'Update'
    ].
    aComponent == defineButton ifTrue:[
        s := 'Define the missing method (as halting) and proceed into it.\A debugger will reopen there, so you can add the code then'
    ].
    aComponent == reportButton ifTrue:[
        s := 'Send a defect report via eMail'
    ].
    s notNil ifTrue:[
        ^ resources stringWithCRs:s
    ].
    ^ nil

    "Modified: / 29-08-1995 / 23:38:54 / claus"
    "Modified: / 18-06-2010 / 11:34:51 / cg"
!

flyByHelpTextFor:aComponent at:aPointOrNil
    |s vline line col pos interval|

    aComponent == codeView ifFalse:[^ nil].
    aPointOrNil isNil ifTrue:[^ nil].
    self sensor motionEventPending ifTrue:[^ nil].

    vline := codeView visibleLineOfY:aPointOrNil y.
    col := codeView colOfX:aPointOrNil x inVisibleLine:vline.
    line := codeView visibleLineToAbsoluteLine:vline.

    pos := codeView characterPositionOfLine:line col:col.
    interval := pos to:pos.

    self
        withNodeValueAtInterval:interval
        do:[:value :description |
            |valueClassOrSizeString valueString|

            valueClassOrSizeString := valueString := ''.

            "/ some heuristics as when to show the class name (a purely subjective preference)
            value isString ifTrue:[
                value isText ifTrue:[
                    valueString := '"',(value contractTo:80),'"'.
                ] ifFalse:[
                    valueString := value storeString contractTo:80.
                ].
            ] ifFalse:[
                (value isBoolean
                or:[ value isInteger
                or:[ value isSymbol ]]) ifTrue:[
                    valueString := value printString.
                ] ifFalse:[
                    valueClassOrSizeString := ' (',value class name,')'.

                    (value isArray
                    or:[ value isOrderedCollection ]) ifTrue:[
                        valueClassOrSizeString := ' (size=',value size printString,')'.
                    ].

                    Error handle:[:ex |
                        valueString := '??? (',ex description,')'
                    ] do:[
                        [
                            valueString := value printString contractTo:80.
                        ] valueWithWatchDog:[ valueString := value class nameWithArticle ] afterMilliseconds:30.
                        "do not use classNameWithArticle - it is missing in ProtoObject!!"
                    ]
                ]
            ].
            description isEmptyOrNil ifTrue:[
                s := valueString , valueClassOrSizeString
            ] ifFalse:[
                s := description , ': ', valueString, valueClassOrSizeString
            ].
        ].
    "/ Transcript showCR:s.
    ^ s

    "Modified: / 27-04-2010 / 17:51:53 / cg"
!

helpTextFor:aComponent
    |s|

    aComponent == abortButton ifTrue:[
        s := 'HELP_ABORT'
    ].
    aComponent == terminateButton ifTrue:[
        s := 'HELP_TERMINATE'
    ].
    aComponent == continueButton ifTrue:[
        continueButton label = (resources string:'Stop') ifTrue:[
            s := 'HELP_STOP'
        ] ifFalse:[
            s := 'HELP_CONTINUE'
        ]
    ].
    aComponent == stepButton ifTrue:[
        s := 'HELP_STEP'
    ].
    aComponent == nextButton ifTrue:[
        s := 'HELP_NEXT'
    ].
    aComponent == nextOverButton ifTrue:[
        s := 'HELP_NEXTOVER'
    ].
    aComponent == nextOutButton ifTrue:[
        s := 'HELP_NEXTOUT'
    ].
    aComponent == stepButton ifTrue:[
        s := 'HELP_STEP'
    ].
    aComponent == sendButton ifTrue:[
        s := 'HELP_SEND'
    ].
    aComponent == returnButton ifTrue:[
        returnButton enabled ifTrue:[
            s := 'HELP_RETURN'
        ] ifFalse:[
            s := 'HELP_RETURN_DISABLED'
        ].
    ].
    aComponent == restartButton ifTrue:[
        restartButton enabled ifTrue:[
            s := 'HELP_RESTART'
        ] ifFalse:[
            s := 'HELP_RESTART_DISABLED'
        ].
    ].
    aComponent == resendButton ifTrue:[
        resendButton enabled ifTrue:[
            s := 'HELP_RESEND'
        ] ifFalse:[
            s := 'HELP_RESEND_DISABLED'
        ].
    ].
    aComponent == contextView ifTrue:[
        s := 'HELP_WALKBACK'
    ].
    aComponent == codeView ifTrue:[
        s := 'HELP_CODEVIEW'
    ].
    aComponent == monitorToggle ifTrue:[
        s := 'HELP_MONITOR'
    ].
    aComponent == updateButton ifTrue:[
        s := 'HELP_UPDATE'
    ].
    aComponent == gotoDialogOpenerButton ifTrue:[
        s := 'HELP_GOTO_DIALOG_OPENER'
    ].
    aComponent == gotoApplicationActionMethodButton ifTrue:[
        s := 'HELP_GOTO_APPLICATION_ACTION'
    ].
"/    aComponent == stopButton ifTrue:[
"/        s := 'HELP_STOP'
"/    ].
    (aComponent isComponentOf:receiverInspector) ifTrue:[
        s := 'HELP_REC_INSP'
    ].
    (aComponent isComponentOf:contextInspector) ifTrue:[
        s := 'HELP_CON_INSP'
    ].

    s notNil ifTrue:[
        ^ resources stringWithCRs:s
    ].
    ^ nil

    "Modified: 29.8.1995 / 23:38:54 / claus"
    "Modified: 4.3.1997 / 01:54:03 / cg"
! !

!DebugView methodsFor:'initialization'!

initializeKeyboardMap
    keyboardMap := self class defaultKeyboardMap copy.
    device notNil ifTrue:[
        keyboardMap parent: device keyboardMap.
    ].

    "Created: / 02-02-2017 / 23:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2017 / 22:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView methodsFor:'initialization & release'!

addToCurrentProject
    "ignored here"

    ^ self
!

destroy
    "closing the debugger implies an abort or continue"

    self destroyWithConfirmation:true

    "Modified: / 10-07-1997 / 17:15:41 / stefan"
    "Modified: / 23-03-2012 / 12:50:01 / cg"
!

destroyWithConfirmation:withConfirmation
    "closing the debugger implies an abort or continue"

    |m|

    withConfirmation ifTrue:[
        self checkIfCodeIsReallyModified ifTrue:[
            (self confirm:('Code was modified.\\Exit anyway ?'))
            ifFalse:[
                ^ self
            ]
        ]
    ].

    self autoUpdateOff.

    (m := contextView middleButtonMenu) notNil ifTrue:[m hide].
    inspecting ifFalse:[
        "I am running on top of a process, abort or continue it"

        windowGroup notNil ifTrue:[
            windowGroup setProcess:nil.
        ].
        self uncacheMyself.

        "/
        "/ catch invalid return;
        "/ this happens, when my process has somehow died (quickterminate)
        "/ and I am a leftOver view, which gets terminated via the launchers
        "/ #destroy-window function.
        "/
        Context cannotReturnSignal handle:[:ex |
            'DebugView [info]: OOPS - non regular debugView closing(1)' infoPrintCR.
            self uncacheMyself.
            Debugger newDebugger.
            ex return.
        ] do:[
            AbortOperationRequest isHandled ifTrue:[
                self doAbort.
            ] ifFalse:[
                self doContinue
            ]
        ].
        "/ We don't reach this point normally
        'DebugView [info]: OOPS - non regular debugView closing(2)' infoPrintCR.
    ].

    Debugger newDebugger.
    "/ since I am going to be destroyed, remove me from the cache
    self uncacheMyself.
    super destroy.

    "Modified: / 10-07-1997 / 17:15:41 / stefan"
    "Created: / 23-03-2012 / 12:49:50 / cg"
!

initialize
    |menu menuPanel mH panel bpanel bH bpanel1 bH1 bpanel2 bH2 codePanel
     newLayout v exceptionAndTogglePanel codeToggleLabels|

    super initialize.

    self initializeFlags.

    busy := false.
    exclusive := false.
    inspecting := false.
    exitAction := nil.
    bigStep := false.
    stepHow := nil.
    canContinue := false.

    mH := 0.

    menuPanel := MenuPanel in:self.
    menuPanel receiver:self.
    menuPanel verticalLayout:false.
    menu := self class menuSpec decodeAsLiteralArray.
    menu findGuiResourcesIn:self.
    menuPanel menu:menu.

    mH := menuPanel preferredHeight.
    menuPanel origin:(0.0 @ 0.0) corner:(1.0 @ (mH)).

    newLayout := UserPreferences current useNewLayoutInDebugger.
    newLayout ifFalse:[
        bpanel := HorizontalPanelView in:self.

        self initializeButtonsIn:bpanel.

        bH := bpanel preferredHeight + 5.
        bpanel origin:(0.0 @ mH)
               extent:(1.0 @ bH).
        panel := VariableVerticalPanel
                            origin:(0.0 @ (mH + bH))
                            corner:(1.0 @ 1.0)
                            in:self.

        v := self initializeContextListViewIn:panel.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 0.25).

        codePanel := View in:panel.
        v := self initializeCodeViewIn:codePanel.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        codePanel origin:(0.0 @ 0.25) corner:(1.0 @ 0.75).

        v := self initializeInspectorViewsIn:panel.
        v origin:(0.0 @ 0.75) corner:(1.0 @ 1.0).

    ] ifTrue:[
        bpanel1 := HorizontalPanelView in:self.
        self initializeButtons1In:bpanel1.

        contextInfoLabel := Label label:''.
        contextInfoLabel adjust:#left.
        bpanel1 add:contextInfoLabel.

        bH1 := bpanel1 preferredHeight + 5.
        bpanel1 origin:(0.0 @ mH)
                extent:(1.0 @ bH1).
        panel := VariableVerticalPanel
                            origin:(0.0 @ (mH + bH1))
                            corner:(1.0 @ 1.0)
                                in:self.
        "/ panel showHandle:true.
        "/ panel handlePosition:#left.

        v := self initializeContextListViewIn:panel.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 0.25).

        codePanel := View in:panel.
        bpanel2 := HorizontalPanelView in:codePanel.
        self initializeButtons2In:bpanel2.

        bH2 := bpanel2 preferredHeight + 5.
        bpanel2 origin:(0.0 @ 0.0)
                extent:(1.0 @ bH2).

        exceptionInfoLabel := Label label:''.
        exceptionInfoLabel adjust:#left.

        exceptionAndTogglePanel := HorizontalPanelView in:codePanel.
        exceptionAndTogglePanel horizontalLayout:#left.
        exceptionAndTogglePanel
            geometryLayout:
                ((LayoutFrame
                    origin:(0.0 @ 0.0)
                    corner:(1.0 @ 0.0))
                        topOffset:bH2;
                        bottomOffset:(bH2 + exceptionInfoLabel preferredHeight + 6);
                        rightOffset:-2).

        methodCodeToggleSelectionHolder := 1 asValue.
        methodCodeToggleSelectionHolder onChangeSend:#methodCodeToggleChanged to:self.
        codeToggleLabels := resources array:{
                    'Showing Original Code (being executed, but obsolete)' asText backgroundColorizeAllWith:Color red lightened .
                    'Showing Current Code'                                 asText backgroundColorizeAllWith:Color green lightened .
                  }.
        methodCodeToggle := PopUpList label:codeToggleLabels first in:exceptionAndTogglePanel.
        methodCodeToggle list:codeToggleLabels.
        methodCodeToggle useIndex:true.
        methodCodeToggle model:methodCodeToggleSelectionHolder.
        methodCodeToggle beInvisible.

        exceptionAndTogglePanel add:exceptionInfoLabel.

        v := self initializeCodeViewIn:codePanel.
        v origin:(0.0 @ (bH2+exceptionInfoLabel preferredHeight+6)) corner:(1.0 @ 1.0).
        codePanel origin:(0.0 @ 0.25) corner:(1.0 @ 0.75).

        v := self initializeInspectorViewsIn:panel.
        v origin:(0.0 @ 0.75) corner:(1.0 @ 1.0).
    ].

    DefaultDebuggerBackgroundColor notNil ifTrue:[
        self allViewBackground:DefaultDebuggerBackgroundColor.
    ].
    LastExtent notNil ifTrue:[
        self extent:LastExtent.
    ].
    LastOrigin notNil ifTrue:[
        self origin:LastOrigin.
    ].
    "
     Debugger newDebugger
    "

    "Modified: / 27-07-2012 / 14:46:07 / cg"
!

initializeAbortButtonIn:bpanel
    abortButton := Button
                label:(resources string:'Abort'), (self shortKeyStringForAction: #DebuggerAbort)
                action:[
                    abortButton turnOffWithoutRedraw.
                    self doAbort
                ]
                in:bpanel.

    abortButton name:'abortButton'.

    "Created: / 17-11-2001 / 20:56:47 / cg"
    "Modified: / 16-08-2017 / 08:48:50 / Patrik Svestka <patrik.svestka@gmail.com>"
    "Modified: / 13-10-2017 / 22:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeButtons1In:bpanel
    "creates the top button row, consisting of 'continue', 'abort', 'terminate'..."

    |separator buttonWidth|

    buttonWidth := 170.
    
    bpanel horizontalLayout:#left.
    bpanel verticalLayout:#centerMax.
    bpanel verticalSpace:ViewSpacing // 2.

    self initializeContinueButtonIn:bpanel.
    continueButton width:buttonWidth.

    "/ separator := View extent:(10 @ 5) in:bpanel.
    "/ separator borderWidth:0; level:0.
    self initializeAbortButtonIn:bpanel.
    abortButton width:buttonWidth.

    separator := View extent:(100 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeTerminateButtonIn:bpanel.

    separator := View extent:(50 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeGotoDialogOpenerButtonIn:bpanel.
    self initializeGotoApplicationActionMethodButtonIn:bpanel.
    self initializeDefineButtonIn:bpanel.

    (UserPreferences current allowSendMailFromDebugger and:[SendMailTool notNil]) ifTrue:[
        separator := View extent:(10 @ 5) in:bpanel.
        separator borderWidth:0; level:0.
        self initializeReportButtonIn:bpanel.
    ].
    "Modified: / 17.11.2001 / 21:02:59 / cg"
!

initializeButtons2In:bpanel
    "creates the second button row, consisting of 'next', 'step', 'return'..."

    |separator buttonWidth|

    buttonWidth := 130.

    bpanel horizontalLayout:#left.
    bpanel verticalLayout:#centerMax.
    bpanel verticalSpace:ViewSpacing // 2.

    self initializeNextButtonIn:bpanel.
    nextButton width:buttonWidth.

    self initializeStepButtonIn:bpanel.
    stepButton width:buttonWidth.

"/ cg:
"/ I disabled the stepIn / stepOut buttons - for now.
"/ they do not work reliable with inlined blocks yet.
"/


"/    img := Image fromFile:'bitmaps/stepIn.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'next')
"/    ].
"/    nextButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNext]
"/                        in:bpanel.
"/
"/    img := Image fromFile:'bitmaps/stepOver.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'over')
"/    ].
"/    nextOverButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNextOver]
"/                        in:bpanel.
"/
"/    img := Image fromFile:'bitmaps/stepOut.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'out')
"/    ].
"/    nextOutButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNextOut]
"/                        in:bpanel.

    self initializeSendButtonIn:bpanel.
    sendButton width:buttonWidth.

    separator := View extent:(30 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeReturnButtonIn:bpanel.
    returnButton width:buttonWidth.
    self initializeRestartButtonIn:bpanel.
    restartButton width:buttonWidth.
    self initializeResendButtonIn:bpanel.
    resendButton width:buttonWidth.

    "Modified: / 18-06-2010 / 08:32:05 / cg"
!

initializeButtonsIn:bpanel
    |separator|

    bpanel horizontalLayout:#left.
    bpanel verticalLayout:#centerMax.
    bpanel verticalSpace:ViewSpacing // 2.

    self initializeAbortButtonIn:bpanel.

    separator := View extent:(10 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeContinueButtonIn:bpanel.

    separator := View extent:(10 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeReturnButtonIn:bpanel.
    self initializeRestartButtonIn:bpanel.
    self initializeResendButtonIn:bpanel.

    separator := View extent:(10 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeNextButtonIn:bpanel.
    self initializeStepButtonIn:bpanel.

"/ cg:
"/ I disabled the stepIn / stepOut buttons - for now.
"/ they do not work relyable with inlined blocks yet.
"/


"/    img := Image fromFile:'bitmaps/stepIn.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'next')
"/    ].
"/    nextButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNext]
"/                        in:bpanel.
"/
"/    img := Image fromFile:'bitmaps/stepOver.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'over')
"/    ].
"/    nextOverButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNextOver]
"/                        in:bpanel.
"/
"/    img := Image fromFile:'bitmaps/stepOut.xpm'.
"/    img isNil ifTrue:[
"/        img := (resources at:'out')
"/    ].
"/    nextOutButton := Button
"/                        label:img
"/                        action:[stepButton turnOff. self doNextOut]
"/                        in:bpanel.

    self initializeSendButtonIn:bpanel.

    separator := View extent:(30 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeTerminateButtonIn:bpanel.

    separator := View extent:(30 @ 5) in:bpanel.
    separator borderWidth:0; level:0.

    self initializeDefineButtonIn:bpanel.
    (UserPreferences current allowSendMailFromDebugger and:[SendMailTool notNil]) ifTrue:[
        self initializeReportButtonIn:bpanel.
    ].


    "Created: / 17.11.2001 / 20:56:20 / cg"
    "Modified: / 17.11.2001 / 21:03:18 / cg"
!

initializeCodeViewIn:panel
    |scrollableCodeView|

    (UserPreferences current useCodeView2In: #Debugger) ifTrue:[
        scrollableCodeView := codeView := Tools::CodeView2 new.
        codeView model: ValueHolder new.
        codeView methodHolder: ValueHolder new.
        codeView classHolder: ValueHolder new.
    ] ifFalse:[
        scrollableCodeView := HVScrollableView
                    for:CodeView
                    miniScrollerH:true
                    miniScrollerV:false
                    in:panel.

        codeView := scrollableCodeView scrolledView.
        codeView enableMotionEvents. "/ for active help
    ].

     (UserPreferences current showAcceptCancelBarInBrowser
        and:[codeView isCodeView2 not or:[UserPreferences current codeView2ShowAcceptCancel not]]) ifTrue:[
        ViewWithAcceptAndCancelBar notNil ifTrue:[
            |v|

            v := ViewWithAcceptAndCancelBar new.
            v slaveView:scrollableCodeView.
            v reallyModifiedHolder:(codeView isCodeView2
                                        ifTrue:[ codeView reallyModifiedChannel ]
                                        ifFalse:[
                                            BlockValue
                                                with:[:m |
                                                    |same|

                                                    same := (codeView contentsAsString string = currentMethod source string).
                                                    codeView modifiedChannel setValue:false.  "/ so it triggers again
                                                    same not.
                                                ]
                                                argument:codeView modifiedChannel
                                        ]).
            v cancelAction:
                [
                    "/ codeView setClipboardText:(codeView contents).   "/ for undo
                    codeView device rememberInCopyBufferHistory:(codeView contents).  "/ for undo
                    codeView contents:(currentMethod source).
                    codeView modifiedChannel setValue:false; changed.   "/ trigger
                    codeView requestFocus.
                ].
            v compareAction:
                [
                    v := DiffCodeView
                            openOn:codeView contentsAsString
                            label:(resources string:'Changed definition (to be accepted ?)')
                            and:currentMethod source
                            label:(resources string:'Method''s Original Code').
                    v label:(resources string:'Changed Code in Debugger').
                    v waitUntilVisible.
                    "/ codeView requestFocus
                ].
            scrollableCodeView := v.
        ]
    ].

    panel add:scrollableCodeView.
    ^ scrollableCodeView

    "Modified: / 06-12-2013 / 17:30:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeContextListViewIn:panel
    |v|

    v := HVScrollableView
                for:SelectionInListView
                miniScrollerH:true
                miniScrollerV:false
                in:panel.
    v autoHideHorizontalScrollBar:true.

    contextView := v scrolledView.
    contextView action:[:lineNr | self showSelection:lineNr].
    contextView doubleClickAction:[:line | self browseImplementingClass].
    contextView selectConditionBlock:[:line | self checkSelectionChangeAllowed:line].

    contextView middleButtonMenu:(self middleButtonMenu).

    ^ v
!

initializeContextViewsMiddleButtonMenu
    <resource: #programMenu >

    contextView middleButtonMenu:(self middleButtonMenu).
!

initializeContinueButtonIn:bpanel
    continueButton := Button
                label:(resources string:'Continue') , (self shortKeyStringForAction: #DebuggerContinue)    
                action:[
                    continueButton turnOffWithoutRedraw.
                    self doContinue
                ]
                in:bpanel.

    continueButton name:'continueButton'.

    "Created: / 17-11-2001 / 20:57:34 / cg"
    "Modified: / 17-05-2017 / 16:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeDefineButtonIn:bpanel
    defineButton := Button
                label:(resources string:'Define') , (self shortKeyStringForAction: #DebuggerDefine)
                action:[
                    defineButton turnOffWithoutRedraw.
                    self doDefine
                ]
                in:bpanel.

    defineButton name:'defineButton'.
    defineButton beInvisible

    "Created: / 17-11-2001 / 21:02:48 / cg"
    "Modified: / 13-10-2017 / 22:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFlags
    |userPrefs|

    userPrefs := UserPreferences current.
    self verboseBacktraceHolder value:(userPrefs verboseBacktraceInDebugger).
    hideSupportCode := userPrefs hideSupportCodeInDebugger ? false.
    ignoreBreakpoints := true.    "/ ignore halts/breakpoints in doIts of
                                  "/ the debugger
!

initializeGotoApplicationActionMethodButtonIn:bpanel
    gotoApplicationActionMethodButton := Button
                label:(resources string:'Goto Responsible Application Method') , (self shortKeyStringForAction: #DebuggerGotoResponsibleApplicationMethod)
                action:[
                    gotoApplicationActionMethodButton turnOffWithoutRedraw.
                    self doGotoApplicationActionMethod
                ]
                in:bpanel.

    gotoApplicationActionMethodButton name:'gotoAppMethodButton'.
    gotoApplicationActionMethodButton beInvisible

    "Modified: / 16-08-2017 / 09:07:00 / Patrik Svestka <patrik.svestka@gmail.com>"
    "Modified: / 13-10-2017 / 22:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeGotoDialogOpenerButtonIn:bpanel
    gotoDialogOpenerButton := Button
                label:(resources string:'Goto Dialog Opener') , (self shortKeyStringForAction: #DebuggerGoToDialogOpener)
                action:[
                    gotoDialogOpenerButton turnOffWithoutRedraw.
                    self doGotoDialogOpener
                ]
                in:bpanel.

    gotoDialogOpenerButton name:'gotoDialogOpenerButton'.
    gotoDialogOpenerButton beInvisible

    "Modified: / 13-10-2017 / 22:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeInspectorViewsIn:panel
    |hpanel|

    hpanel := VariableHorizontalPanel in:panel.

    receiverInspector := InspectorView
                                origin:(0.0 @ 0.0) corner:(0.5 @ 1.0)
                                    in:hpanel.
    receiverInspector fieldListLabel:'Receiver'.

    contextInspector := ContextInspectorView
                                origin:(0.5 @ 0.0) corner:(1.0 @ 1.0)
                                    in:hpanel.
    contextInspector fieldListLabel:'Context'.

    ^ hpanel
!

initializeNextButtonIn:bpanel
    nextButton := Button
                label:(resources string:'Debug_Next') , (self shortKeyStringForAction: #DebuggerNext)
                action:[
                    stepButton turnOff.
                    self doNext
                ]
                in:bpanel.

    nextButton name:'nextButton'.

    "Created: / 17-11-2001 / 20:59:38 / cg"
    "Modified: / 11-05-2017 / 21:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeReportButtonIn:bpanel
    reportButton := Button
                label:(resources string:'Report by Mail...')
                action:[
                    reportButton turnOffWithoutRedraw.
                    self doOpenReportMailApp.
                ]
                in:bpanel.

    reportButton name:'reportButton'.

    "Created: / 17.11.2001 / 21:02:20 / cg"
!

initializeResendButtonIn:bpanel
    resendButton := Button
                label:(resources string:'Resend') , (self shortKeyStringForAction: #DebuggerResend)
                action:[
                    resendButton turnOff.
                    self doResend
                ]
                in:bpanel.

    resendButton name:'resendButton'.

    "/ if we have this, we do not need the restart button
    restartButton beInvisible.

    "Modified: / 16-08-2017 / 09:05:00 / Patrik Svestka <patrik.svestka@gmail.com>"
    "Modified: / 13-10-2017 / 22:50:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeRestartButtonIn:bpanel
    restartButton := Button
                label:(resources string:'Restart'), (self shortKeyStringForAction: #DebuggerRestart)
                action:[
                    restartButton turnOff.
                    self doRestart
                ]
                in:bpanel.

    restartButton name:'restartButton'

    "Created: / 17-11-2001 / 20:58:52 / cg"
    "Modified: / 13-10-2017 / 22:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeReturnButtonIn:bpanel
    returnButton := Button
                label:(resources string:'Return') , (self shortKeyStringForAction: #DebuggerReturn)
                action:[
                    returnButton turnOff.
                    self doReturn
                ]
                in:bpanel.

    returnButton name:'returnButton'.

    "Created: / 17.11.2001 / 20:58:22 / cg"
    "Modified: / 16-08-2017 / 09:11:20 / Patrik Svestka <patrik.svestka@gmail.com>"
!

initializeSendButtonIn:bpanel
    sendButton := Button
                label:(resources string:'Debug_Send') , (self shortKeyStringForAction: #DebuggerSend)
                action:[
                    sendButton turnOff.
                    self doSend
                ]
                in:bpanel.

    sendButton name:'sendButton'.

    "Created: / 17-11-2001 / 21:01:20 / cg"
    "Modified: / 25-05-2017 / 23:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeStepButtonIn:bpanel
    stepButton := Button
                label:(resources string:'Debug_Step') , (self shortKeyStringForAction: #DebuggerStep)
                action:[
                    stepButton turnOff.
                    self doStep
                ]
                in:bpanel.

    stepButton name:'stepButton'.
    "Created: / 17.11.2001 / 21:00:13 / cg"
    "Modified: / 02-08-2017 / 10:16:38 / Patrik Svestka <patrik.svestka@gmail.com>"
!

initializeTerminateButtonIn:bpanel
    terminateButton := Button
                label:(resources string:'Debug_Terminate') , (self shortKeyStringForAction: #DebuggerTerminate)
                action:[
                    terminateButton turnOffWithoutRedraw.
                    self doTerminate
                ]
                in:bpanel.

    terminateButton name:'terminateButton'.
    terminateButton backgroundColor:Color red lightened.
    "/ terminateButton foregroundColor:Color red.

    "Created: / 17-11-2001 / 21:02:20 / cg"
    "Modified: / 16-08-2017 / 09:17:10 / Patrik Svestka <patrik.svestka@gmail.com>"
    "Modified: / 13-10-2017 / 22:51:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postRealize
    super postRealize.

    inspecting ifTrue:[
        inspectedProcess notNil ifTrue:[
            "
             set prio somewhat higher (by 2, to allow walkBack-update process
             to run between mine and the debugged processes prio)
            "
            Processor activeProcess
                priority:(((inspectedProcess priority + 2) min:(Processor highIOPriority)) max:(Processor userSchedulingPriority+1)).
        ]
    ].

    self sensor addEventListener:self.

    "Created: 24.7.1997 / 18:17:44 / cg"
!

reinitialize
    "/ redefined - since the debugView runs on top of
    "/ the debuggee, there would be no event loop for me.

    self drawableId notNil ifTrue:[
        ^ self
    ].
    "physically create the view & subviews"
    self recreate.
!

releaseDebuggee
    "We have to be careful to release all refs to the debuggee,
     because we may be in the cache.
     Otherwise, the GC will not be able to release it"

    busy := false.

    codeView acceptAction:nil.
    codeView doItAction:nil.
    codeView contents:nil.

    receiverInspector release.
    contextInspector release.
    inspectedProcess := nil.
    contextArray := nil.
    ((exitAction == #restart) or:[exitAction == #return or:[exitAction == #resend]]) ifFalse:[
        selectedContext := nil.
    ].
    actualContext := firstContext := nil.
    steppedContext := wrapperContext := nil.
    catchBlock := nil.
    grabber := nil.
    self autoUpdateOff.

    "Created: / 10-07-1997 / 14:57:51 / stefan"
    "Modified: / 26-09-2012 / 15:08:21 / cg"
!

setLabelFor:aMessage in:aProcess
    |l lines processNameOrNil pidOrNil osPidString colorUsed|

    lines := aMessage asStringCollection.
    lines size > 1 ifTrue:[
        l := lines first
    ] ifFalse:[
        l := aMessage.
    ].

    l := l , ' ('.
    Error handle:[:ex |
        l := l , '???'
    ] do:[
        processNameOrNil := aProcess name.
        processNameOrNil notNil ifTrue:[
            l := l , (processNameOrNil contractTo:20) , ''.
        ].
        pidOrNil := aProcess id printString.
        l := l , '[' , pidOrNil , ']'.
    ].
    l := l , ')'.
    self label:l.

    ((ShowThreadID == true) and:[OperatingSystem isMSDOSlike]) ifTrue:[
        osPidString := ' {threadID: ',OperatingSystem getThreadId printString,'}'.
    ].

    exceptionInfoLabel notNil ifTrue:[
        colorUsed := isStoppedAtHaltOrBreakPoint 
                        ifTrue:[ Color orange ]
                        ifFalse:[ Color red ].
        colorUsed := colorUsed contrastingColorFor:exceptionInfoLabel backgroundColor.                
        
        exceptionInfoLabel
            label:(resources
                    string:'%1 in process %2 [%3]%4'
                    with:(lines first withColor:colorUsed)
                    with:(processNameOrNil ? '')
                    with:(pidOrNil ? '')
                    with:(osPidString ? ''))
    ].

    "Modified: / 06-07-2006 / 12:43:19 / cg"
! !

!DebugView methodsFor:'interrupt handling'!

contextInterrupt
    DebuggingDebugger == true ifTrue:[
        'contextIRQ' printCR.
        thisContext methodHome sender fullPrint.
    ].
    self stepOrNext

    "Modified: / 30.10.1997 / 21:22:25 / cg"
!

stepInterrupt
    DebuggingDebugger == true ifTrue:[
        'stepIRQ' print.
        "/ ' in ' print. thisContext sender fullPrint.
        '' printCR.
    ].
    Processor yield.
    self stepOrNext

    "Modified: / 20-07-2012 / 14:06:54 / cg"
!

stepOrNext
    |where here con s isWrap method wrappedMethod
     originalMethodOfWrappedMethod originalMethodsContext
     inBlock subBlockLeft ignore contextBelow wrapContext
     leftWrap enteredWrap anyStepBlocks
     oneMore initiallyShown inBlockBelow receiver processName
     inBreakPointHandlingCode bpntReceiver|

    "/ DebuggingDebugger := true
    "/ DebuggingDebugger := false
    "/ DebuggingDebugger2 := true
    "/ DebuggingDebugger2 := false
    "/ DebuggingDebugger3 := false
    "/ '' printCR

    processName := (Processor activeProcess nameOrId),' [',Processor activeProcess id printString,']'.

    skipLineNr == #return ifTrue:[
        self label:('stepping context returned ' , ' (process: ' , processName , ')').
        here := thisContext sender sender.
        here setLineNumber:nil.
        here := nil.
        con := thisContext sender sender sender.

        HaltInterrupt handle:[:ex |
            ('DebugView [info]: halt/breakpoint in debugger at %1 ignored [stepOrNext]' bindWith:ex suspendedContext) infoPrintCR.
            ex proceed
        ] do:[
            self enter:con select:nil.
        ].
        con := nil.
        ^ self
    ].

"/    "/
"/    "/ should no longer happen
"/    "/
"/    stepForReturn == true ifTrue:[
"/"/'stepForreturn' printCR.
"/        self enter:thisContext sender.
"/        ^ self
"/    ].

    Processor activeProcess ~~ inspectedProcess ifTrue:[
        'DebugView [info]: stray step interrupt' infoPrintCR.
        ^ self
    ].

    here := thisContext.        "stepInterrupt"
    here := here sender.        "the caller; step- or contextIRQ"
    here := here sender.        "the interrupted context"

    DebuggingDebugger2 == true ifTrue:[
        '***************************' printCR.
        'here in ' print.
        inWrap ifTrue:['(wrap) ' print.].
        ((ObjectMemory addressOf:here) printStringRadix:16) print. ' ' print.
        here selector printCR.
        'stepping in ' print.
        steppedContext notNil ifTrue:[
            ((ObjectMemory addressOf:steppedContext) printStringRadix:16) print. ' ' print.
        ].
        steppedContext printCR.
    ].

    (inBreakPointHandlingCode := (here selector == #break)) ifTrue:[
        bpntReceiver := here receiver.
    ] ifFalse:[
        (inBreakPointHandlingCode := (here sender selector == #break)) ifTrue:[
            bpntReceiver := here sender receiver.
        ]
    ].

    "/ when single stepping, ignore breakpoints
    inBreakPointHandlingCode ifTrue:[
        (bpntReceiver notNil and:[ bpntReceiver isKindOf:Breakpoint ]) ifTrue:[
            false "here receiver isEnabled" ifFalse:[
                con := nil.
                where := nil. here := nil.
                StepInterruptPending := 1.
                InterruptPending := 1.
                InStepInterrupt := nil.
                ^ self
            ]
        ].
    ].

    "/ kludge: a bug-workaround;
    "/ I should not see those...

    here selector == #ioInterrupt ifTrue:[
        DebuggingDebugger2 == true ifTrue:[
            'oops - should not get that one' printCR.
        ].
        Processor ioInterrupt.
        StepInterruptPending := 1.
        InterruptPending := 1.
        where := nil. here := nil.
        InStepInterrupt := nil.
        ^ self
    ].

    stepUntilEntering notNil ifTrue:[
        DebuggingDebugger2 == true ifTrue:[
            'check if entering ' print. stepUntilEntering printCR.
        ].
        (stepUntilEntering match:here selector) ifTrue:[
            DebuggingDebugger2 == true ifTrue:[
                'entering...' printCR.
            ].
            self label:('arrived at ' , stepUntilEntering , ' (process: ' , processName , ')').

            lastStepUntilEntering := stepUntilEntering.
            stepUntilEntering := nil.
            self enter:here select:nil.
            con := nil.
            ^ self
        ].
        "/ see if stepping context is still active ...

        con := here.

        DebuggingDebugger2 == true ifTrue:[
            'start searching at: ' print.
            con fullPrint.
        ].
        [con notNil and:[con ~~ steppedContext]] whileTrue:[
            con := con sender
        ].
        con notNil ifTrue:[
            DebuggingDebugger2 == true ifTrue:[
                'steppingContext still active - continue stepping' printCR.
            ].
            con := nil.
            where := nil. here := nil.
            StepInterruptPending := 1.
            InterruptPending := 1.
            InStepInterrupt := nil.
            ^ self
        ].
        stepUntilEntering := nil.
    ].

    "
     kludge to hide breakpoint wrappers in the context list and when single stepping:
         check if we are in a wrapper method's hidden setup-sequence
         if so, ignore the interrupt and continue single sending.
         Assume we are in a wrappers setup code, if there is another context above,
         which is for the wrapper method (i.e. if there is context with an originalmethod
         of some other context higher in the caller chain
    "
    isWrap := false.
    subBlockLeft := false.
    leftWrap := enteredWrap := false.

    inWrap ifTrue:[
        "/ situation1:
        "/   valueWithReceiver or other
        "/   foo (wrapped)                 <- wrapContext
        "/
        "/ situation2:
        "/   foo (original)                <- originalMethodsContext
        "/   valueWithReceiver
        "/   foo (wrapped)                 <- wrapContext
        "/
        "/ situation3:
        "/   other
        "/   foo (original)                <- originalMethodsContext
        "/   valueWithReceiver
        "/   foo (wrapped)                 <- wrapContext
        "/
        "/ situation4:
        "/   ... many-contexts ... (more than 8)
        "/   possibly foo (original)
        "/   valueWithReceiver or other
        "/   foo (wrapped)
        "/

        "/ search for the wrapped method's context and extract the original method
        where := here.
        8 timesRepeat:[
            wrapContext isNil ifTrue:[
                where notNil ifTrue:[
                    DebuggingDebugger2 == true ifTrue:[
                        ((ObjectMemory addressOf:where) printStringRadix:16) print. ' ' print.
                        where printCR
                    ].
                    where isBlockContext ifFalse:[
                        method := where method.
                        (method notNil and:[method isWrapped]) ifTrue:[
                            originalMethodOfWrappedMethod := method originalMethod.
                            wrappedMethod := method.
                            wrapContext := where.
                        ].
                    ].
                    where := where sender
                ]
            ]
        ].
        DebuggingDebugger2 == true ifTrue:[
            'wrap-context is: ' print.
            wrapContext notNil ifTrue:[
                ((ObjectMemory addressOf:wrapContext) printStringRadix:16) print. ' ' print.
            ].
            wrapContext printCR
        ].
        originalMethodOfWrappedMethod isNil ifTrue:[
            'oops no wrap?' errorPrintCR.
        ].
    ].

    (inWrap and:[ originalMethodOfWrappedMethod notNil ]) ifTrue:[
        isWrap := false.
        "/ DebuggingDebugger2 ifTrue:[ '----------->' print. originalMethodOfWrappedMethod printCR ].
        where := here.
        8 timesRepeat:[
            originalMethodsContext isNil ifTrue:[
                where notNil ifTrue:[
                    DebuggingDebugger2 ifTrue:[
                        ((ObjectMemory addressOf:where) printStringRadix:16) print. ' ' print.
                        where printCR
                    ].
                    where isBlockContext ifFalse:[
                        method := where method.
                        method == originalMethodOfWrappedMethod ifTrue:[
                            originalMethodsContext := here.
                            where == here ifTrue:[
                                "/ situation2
                                DebuggingDebugger2 ifTrue:[ 's2' printCR ].
                                isWrap := true.
                                "/ here setSender:(wrapContext sender). --- leads to a crash
                            ] ifFalse: [
                                "/ situation3
                                DebuggingDebugger2 ifTrue:[ 's3' printCR ].
                                inWrap := false.
                                isWrap := false.
                            ].
                            steppedContext := where
"/                        ] ifFalse:[
"/                            where selector == wrapContext selector ifTrue:[
"/                                where receiver == wrapContext receiver ifTrue:[
"/                                    '!!!!!!!!!!!!!!!!!!!!!!!!' printCR.
"/                                    method printCR.
"/                                    method originalMethod printCR.
"/                                    originalMethodOfWrappedMethod printCR.
"/                                    '!!!!!!!!!!!!!!!!!!!!!!!!' printCR.
"/                                ].
"/                            ].
                        ].
                        where := where sender
                    ].
                ].
            ].
        ].
        DebuggingDebugger2 ifTrue:[
            'original method-context is: ' print.
            originalMethodsContext notNil ifTrue:[
                ((ObjectMemory addressOf:originalMethodsContext) printStringRadix:16) print. ' ' print.
            ].
            originalMethodsContext printCR
        ].
        originalMethodsContext isNil ifTrue:[
            originalMethodOfWrappedMethod isNil ifTrue:[
                "/ situation4
                DebuggingDebugger2 ifTrue:[ 's4' printCR ].
                DebuggingDebugger2 ifTrue:[ steppedContext printCR ].
                isWrap := false.
            ] ifFalse:[
                "/ situation1
                DebuggingDebugger2 ifTrue:[ 's1' printCR ].
                isWrap := true.
                "/ steppedContext := wrapContext
            ].
        ].
    ].

    isWrap ifTrue:[
        DebuggingDebugger2 == true ifTrue:[
            'ignore wrap' printCR.
        ].

        "/
        "/ ignore, while in wrappers hidden setup
        "/
        where := nil. here := nil.
        ObjectMemory flushInlineCaches.

        DebuggingDebugger2 == true ifTrue:[
            skipLineNr == #return ifTrue:[
                'skipRet in wrap' printCR.
            ]
        ].

        StepInterruptPending := 1.
        InterruptPending := 1.
        InStepInterrupt := nil.
        ^ self
    ].

    inBlock := inBlockBelow := anyStepBlocks := false.

    DebuggingDebugger2 == true ifTrue:[
        'bigStep is: ' print. bigStep printCR.
        'steppedContext is: ' print. steppedContext printCR.
    ].

    s := 'Debugger: after step'.

    "/
    "/ is this for a send or a step/next ?
    "/
    (bigStep and:[steppedContext notNil]) ifTrue:[
        "
         a step or next - ignore all contexts below the interesting one
        "
        where := here.      "the interrupted context"
        contextBelow := nil.

        where home notNil ifTrue:[
            "/
            "/ in a block called by 'our' context ?
            "/
            where home == steppedContext ifTrue:[
                "/ '*block*' printCR.
                inBlock := true
            ]
        ].
        (where == steppedContext) ifFalse:[
            where := where sender.

            where notNil ifTrue:[
                where home == steppedContext ifTrue:[
                    "/ '*block*' printCR.
                    inBlock := true.
                ]
            ].

"/ 'looking for ' print.
"/  (steppedContextAddress printStringRadix:16)print. '' printCR.

"/where print. ' ' print. ((ObjectMemory addressOf:where)printStringRadix:16) printCR.
"/steppedContext print. ' ' print. ((ObjectMemory addressOf:steppedContext)printStringRadix:16) printCR.

            where == steppedContext ifFalse:[

                "/ check if we are in a context below steppedContext
                "/ (i.e. if steppedContext can be reached from
                "/  interrupted context. Not using context-ref but its
                "/  address to avoid creation of many useless contexts.)

                (inBlock) ifFalse:[
                    [where notNil] whileTrue:[

                        "/ if either the receiver or any arg of this context
                        "/ is a block of the steppedContext, we must really
                        "/ do a single step. Otherwise, stepping through a
                        "/ do:-loop would be very difficult.
                        receiver := where receiver.
where selector == #critical: ifTrue:[
anyStepBlocks := true.
] ifFalse:[
                        (receiver isBlock
                        and:[(receiver isKindOf:Block)
                        and:[receiver homeMethod == steppedContext method
                             "receiver home == steppedContext"]])
                        ifTrue:[
                            anyStepBlocks := true.
                        ] ifFalse:[
                            where args do:[:arg |
                                (arg isBlock
                                and:[(arg isKindOf:Block)
                                and:[arg homeMethod == steppedContext method
                                     "arg home == steppedContext"]])
                                ifTrue:[
                                    anyStepBlocks := true.
                                ] ifFalse:[
                                    (where methodHome notNil
                                    and:[where methodHome receiver isBlock
                                    and:[(where methodHome receiver isKindOf:Block)
                                    and:[where methodHome receiver homeMethod == steppedContext method
                                         "where methodHome receiver home == steppedContext"]]])
                                    ifTrue:[
                                        anyStepBlocks := true.
                                    ]
                                ].
                            ]
                        ].
].
                        DebuggingDebugger2 == true ifTrue:[
                            ((ObjectMemory addressOf:where) printStringRadix:16)print. ' ' print.
                            where selector printCR.
                        ].

                        where == steppedContext ifTrue:[
"/ 'found it - below; ignore' printCR.
                            "
                             found the interesting context somewhere up in the
                             chain. We seem to be still below the interesting one ...
                            "
                            tracing == true ifTrue:[
                                here printString printCR
                            ].
                            "
                              yes, a context below
                              - continue and schedule another stepInterrupt.
                              Must flush caches since optimized methods not always
                              look for pending interrupts
                            "

                            contextBelow notNil ifTrue:[
"/ 'prepare for unwind-catch' printCR.
"/ 'con= ' print. contextBelow printCR.
"/                                contextBelow selector notNil ifTrue:[
"/                                    self label:'single stepping - please wait ...(' , contextBelow selector , ')'.
"/                                ].

                                DebuggingDebugger2 == true ifTrue:[
                                    'below stepCon; continue until unwind of: ' print.
                                    contextBelow printCR.
                                ].
                                Processor activeProcess forceInterruptOnReturnOf:contextBelow.
                                StepInterruptPending := nil.
                            ] ifFalse:[
                                ObjectMemory flushInlineCaches.

"/                                here selector notNil ifTrue:[
"/                                    self label:'single stepping - please wait ...(' , here selector , ')'.
"/                                ].

                                DebuggingDebugger2 == true ifTrue:[
                                    'in stepCon; continue single stepping' printCR.
                                ].
                                StepInterruptPending := 1.
                                InterruptPending := 1.
                            ].
                            where := nil. here := nil.
                            InStepInterrupt := nil.

                            ^ self
                        ].

                        (steppedContext notNil and:[
                         where methodHome == steppedContext methodHome]) ifTrue:[
                            inBlockBelow := true.
                        ].

                        anyStepBlocks ifFalse:[
                            inBlock ifFalse:[
"/ workaround a VM bug,
"/ which does not honor interrupt-on-return of block contexts
"/ sigh
where isBlockContext ifFalse:[
                                contextBelow := where
].
                            ]
                        ].
                        where := where sender
                    ].
                    s := 'Debugger: context returned'.
                    subBlockLeft := true.
                ].
            ] ifTrue:[
"/ 'found it right in sender' printCR.
                s := 'Debugger: after step'
            ].
        ] ifTrue:[
"/ 'found it right away' printCR.
            s := 'Debugger: after step'
        ].
    ] ifFalse:[
"/ ' send' printCR.
        "
         a send
        "
        DebuggingDebugger2 == true ifTrue:[
            'clear steppedContext' printCR.
        ].
        steppedContext := nil.
        s := 'Debugger: after send'
    ].

    ignore := false.
    (inBlock and:[stepHow == #nextOver or:[stepHow == #nextOut]]) ifTrue:[
        ignore := true.
    ].

    "/ handle the case, when a subBlock leaves;
    "/ continue stepping in the home context.

    subBlockLeft ifTrue:[
        steppedContext home notNil ifTrue:[
            steppedContext := steppedContext home.
            s := 'Debugger: after step'.
            subBlockLeft := false.
"/ DebugView enterUnconditional:thisContext withMessage:'debug'.

        ]
    ].

    "
     kludge to hide breakpoint wrappers in the context list:
         check if we are in a wrapper methods hidden exit-sequence
         if so, ignore the interrupt and continue single sending
    "
    (where isNil
    and:[wrapperContext notNil])
    ifTrue:[
        "/ did not find our steppedContext along the chain;
        "/ could be in a wrappedMethods exitBlock ...

        leftWrap ifFalse:[
            where := here.
            wrappedMethod := nil.
            5 timesRepeat:[
                where notNil ifTrue:[
                    where isBlockContext ifFalse:[
                        method := where method.
                        (method notNil and:[method isWrapped]) ifTrue:[
                            where == wrapperContext ifTrue:[
                                DebuggingDebugger2 == true ifTrue:[
                                    'change stepCon fromWrapped: ' print.
                                    steppedContext print.
                                    ' to: ' print.
                                    wrapperContext printCR.
                                ].

                                inWrap := true.
                                enteredWrap := true.
                                steppedContext := wrapperContext.
                                wrapperContext := nil.
                            ]
                        ].
                    ].
                    where := where sender
                ]
            ].
        ].
        enteredWrap ifTrue:[
            ignore := true
        ]
    ].

    "/

    subBlockLeft ifTrue:[
        "/ special care for stepInterrupt in send,
        "/ when created a dummy context (lineNr == 1)

        steppedContext lineNumber isNil ifTrue:[
            steppedContext selector == here sender selector ifTrue:[
                subBlockLeft := false.
                s := 'Debugger: after step'.
                steppedContext := here sender.
            ].
        ].
        oneMore := true
    ].

    inBlock ifTrue:[
        DebuggingDebugger2 == true ifTrue:[ 'inBlock' printCR ].
        s := 'Debugger: in block'.
    ].
    inBlockBelow ifTrue:[
        DebuggingDebugger2 == true ifTrue:[ 'inBlockBelow' printCR ].
        ignore := true
    ].

    DebuggingDebugger2 == true ifTrue:[
        where notNil ifTrue:[
            '(' print. steppedContextLineno print. ') ' print.
            where printCR.
        ].
    ].

    ignore ifFalse:[
        (bigStep
        and:[steppedContextLineno notNil
        and:[where notNil
        and:[where lineNumber == steppedContextLineno]]]) ifTrue:[
            (here isBlockContext
            and:[(here methodHome == steppedContext)
                 or:[here home == steppedContext]]) ifTrue:[
                DebuggingDebugger2 == true ifTrue:[
                    'same line but in block' printCR.
                ].

                steppedContext := actualContext := here.
                steppedContextLineno := here lineNumber.
            ] ifFalse:[
                "/ kludge - I only have the info for up to 255 lines
                steppedContextLineno ~~ 255 ifTrue:[
                    DebuggingDebugger2 == true ifTrue:[
                        'same line - ignored' printCR.
                    ].
                    ignore := true
                ].
            ].
        ].

        (subBlockLeft not
        and:[skipLineNr notNil
        and:[where notNil
        and:[where lineNumber notNil
        and:[where lineNumber < skipLineNr]]]]) ifTrue:[
            DebuggingDebugger2 == true ifTrue:[
                'skip (' print. skipLineNr print. ' unreached - ignored' printCR.
            ].
            ignore := true
        ].

        (steppedContextLineno isNil
        and:[skipLineNr isNil
        and:[thisContext sender selector == #contextInterrupt]]) ifTrue:[
            DebuggingDebugger2 == true ifTrue:[
                'same line2 (after conIRQ) - ignored' printCR.
            ].
            ignore := true
        ].
    ].

    ignore ifTrue:[
"/' ' printCR.
        where := nil. here := nil.
        "
         yes, a context below
          - continue and schedule another stepInterrupt.
          Must flush caches since optimized methods not always
          look for pending interrupts
        "
        ObjectMemory flushInlineCaches.
        StepInterruptPending := 1.
        InterruptPending := 1.
        InStepInterrupt := nil.
        ^ self
    ].

"/ ' ' printCR.

    self label:(s , ' (process: ' , processName , ')').

    tracing := false.
    bigStep := false.

    "release refs to context"
    where := nil. here := nil.
"/'enter' printCR.

    DebuggingDebugger2 == true ifTrue:[
        '==> enter on: ' print. thisContext sender sender printCR.
    ].

    initiallyShown := nil.
    (oneMore == true) ifTrue:[
        (thisContext sender sender lineNumber ? 0) <= 1 ifTrue:[
            initiallyShown := 2
        ] ifFalse:[
            initiallyShown := 1
        ]
    ].
    con := thisContext sender sender.

    HaltInterrupt handle:[:ex |
        'DebugView [info]: halt/breakpoint in debugger ignored [stepOpNext 2]' infoPrintCR.
        ex proceed
    ] do:[
        self enter:con select:initiallyShown
    ].
    con := nil

    "Created: / 14-10-1996 / 12:53:39 / cg"
    "Modified: / 30-04-2016 / 11:47:01 / cg"
! !

!DebugView methodsFor:'menu & button actions'!

addBrowserBookmark
    "add a browser-bookmark for the selected contexts method"

    |cls sel|

    selectedContext isNil ifTrue:[^ self].

    cls := selectedContext receiver class.
    sel := selectedContext selector.
    (cls includesSelector:sel) ifFalse:[
        sel := nil
    ].
    Tools::NewSystemBrowser addToBookMarks:cls selector:sel
!

autoRaiseView
    ^ UserPreferences current autoRaiseDebugger

    "Created: / 15-05-2007 / 13:29:55 / cg"
!

autoRaiseView:aBoolean
    UserPreferences current autoRaiseDebugger:aBoolean

    "Created: / 15-05-2007 / 13:30:04 / cg"
!

autoUpdateOff
    "stop the update process"

    updateProcess notNil ifTrue:[
        monitorToggle lampColor:(Color yellow).
        updateProcess terminate.
        updateProcess := nil
    ]
!

autoUpdateOn
    "fork a subprocess which updates the contextList in regular intervals"

    updateProcess isNil ifTrue:[
        updateProcess :=
            [
                [true] whileTrue:[
                    monitorToggle showLamp ifTrue:[
                        monitorToggle lampColor:(Color yellow).
                    ] ifFalse:[
                        monitorToggle activeForegroundColor:Color black.
                    ].
                    (Delay forSeconds:0.25) wait.
                    self updateContext.
                    monitorToggle showLamp ifTrue:[
                        monitorToggle lampColor:(Color red).
                    ] ifFalse:[
                        monitorToggle activeForegroundColor:Color red.
                    ].
                    (Delay forSeconds:0.25) wait.
                    self updateContext.
                ]
            ] forkAt:(Processor activePriority - 1)
    ]

!

browseBlocksHome
    "browse the receiver block's home method (if a value-like send is selected)"

    |cls sel block mthd|

    selectedContext isNil ifTrue:[^ self].
    (block := selectedContext receiver) isBlock ifFalse:[ ^ self ].

    mthd := block method.
    cls := mthd mclass.
    sel := mthd selector.

    (cls notNil and:[(cls includesSelector:sel)]) ifTrue:[
        cls browserClass openInClass:cls selector:sel.
        ^ self
    ].

    mthd source notEmptyOrNil ifTrue:[
        (Dialog confirm:'Block''s home method is (no longer) present in any class.\Do you want to see the method anyway?' withCRs)
        ifTrue:[
            SystemBrowser default browseMethods:{ mthd } title:'Unbound Method' sort:false
            "/ TextView openWith:mthd source title:'Unbound Method''s Source'.
        ].
        ^ self
    ].
    cls notNil ifTrue:[
        (Dialog confirm:'Block''s home method is (no longer) present in any class and no source can be shown.\Do you want to browse the method''s last class instead?' withCRs)
        ifTrue:[
            cls browserClass openInClass:cls selector:nil.
        ].
        ^ self
    ].
    Dialog information:'Block''s home method is (no longer) present in any class.'.
!

browseClass
    "browse the receiver's class (of the selected context's message)"

    |cls sel|

    selectedContext isNil ifTrue:[^ self].

    cls := selectedContext receiver class.
    sel := selectedContext selector.
    (cls includesSelector:sel) ifFalse:[
        sel := nil
    ].
    cls browserClass openInClass:cls selector:sel.

    "Modified: / 3.2.1998 / 20:23:36 / cg"
!

browseClassHierarchy
    "browse the receiver's classHierarchy (of the selected context's message)"

    |cls mthd|

    selectedContext isNil ifTrue:[^ self].

    mthd := selectedContext method.
    mthd notNil ifTrue:[
        cls := mthd containingClass.
        "/ still nil if unbound - then use receiver's class
    ].
    cls isNil ifTrue:[
        cls := selectedContext receiver class
    ].
    cls browserClass browseClassHierarchy:cls.

    "Modified: / 17-11-2001 / 19:43:06 / cg"
    "Modified (comment): / 30-04-2016 / 15:51:28 / cg"
!

browseFullClassProtocol
    "browse the receiver's full protocol (of the selected context's message)"

    |cls mthd|

    selectedContext isNil ifTrue:[^ self].

    mthd := selectedContext method.
    mthd notNil ifTrue:[
        cls := mthd containingClass.
        "/ still nil if unbound - then use receiver's class
    ].
    cls isNil ifTrue:[
        cls := selectedContext receiver class
    ].
    cls browserClass browseFullClassProtocol:cls.

    "Modified: / 17-11-2001 / 19:43:43 / cg"
    "Modified (comment): / 30-04-2016 / 15:51:32 / cg"
!

browseImplementingClass
    "browse the implementing class (of the selected context's message)"

    |con mthd who sel cls home|

    con := selectedContext ? actualContext.
    con isNil ifTrue:[^ self].

    mthd := con method.
    mthd notNil ifTrue:[
        who := mthd who.
        who notNil ifTrue:[
            cls := who methodClass.
            sel := who methodSelector.
        ] ifFalse:[
            "might have been re-accepted"
            (home := con methodHome) notNil ifTrue:[
                (sel := home selector) notNil ifTrue:[
                    cls := home receiver class
                            whichClassImplements:selectedContext selector.
                    cls notNil ifTrue:[
                        Dialog information:'Method has been changed/moved in the meanwhile.\Browser will show the most recent (current) version.' withCRs.
                    ].
                ]
            ].
        ].
    ].
    cls isNil ifTrue:[
        "/ class not found - try receiver
        cls := con receiver class
    ].

    cls browserClass openInClass:cls selector:sel.

    "Created: / 22-11-1995 / 21:27:01 / cg"
    "Modified: / 19-07-2012 / 11:27:32 / cg"
!

browseImplementors
    "open a browser on the implementors of the selected method's selector"

    selectedContext isNil ifTrue:[
        ^ self showError:'** select a context first **'
    ].
    "/ selectedContext receiver class browserClass
    self withWaitCursorDo:[
        UserPreferences systemBrowserClass
             browseImplementorsOf:selectedContext selector.
    ]

    "Modified: / 19-07-2012 / 11:44:03 / cg"
!

browseImplementorsOf
    "open a browser on the implementors of some selector"

    |initial selector sel|

    (sel := codeView selection) notNil ifTrue:[
        initial := SystemBrowser extractSelectorFrom:sel
    ].
    initial isNil ifTrue:[
        initial := selectedContext isNil
                            ifTrue:[nil]
                            ifFalse:[selectedContext selector].
    ].
    selector := Dialog
                    requestSelector:'Selector to browse implementors of:'
                    initialAnswer:initial.

    selector notEmptyOrNil ifTrue:[
        self withWaitCursorDo:[
            UserPreferences systemBrowserClass
                browseImplementorsMatching:selector.
        ]
    ]

    "Modified: / 19-07-2012 / 11:43:52 / cg"
!

browseProcessesApplication
    "browse the application class (of the process, if it is a GUI process)"

    |app appClass|

    (app := self processesApplication) notNil ifTrue:[
        appClass := app class.
        appClass browserClass openInClass:appClass selector:nil.
    ].
!

browseReceiversClass
    "browse the receiver's class (of the selected context's message)"

    |cls sel|

    selectedContext isNil ifTrue:[^ self].

    selectedContext isCheapBlockContext ifTrue:[
        cls := selectedContext method mclass.
        sel := selectedContext method selector.
    ] ifFalse:[
        cls := selectedContext receiver class.
        sel := selectedContext selector.
    ].
    (cls includesSelector:sel) ifFalse:[
        sel := nil
    ].
    cls browserClass openInClass:cls selector:sel.

    "Modified: / 19-07-2012 / 11:29:48 / cg"
!

browseSenders
    "open a browser on the senders of the selected method's selector"

    selectedContext isNil ifTrue:[
        ^ self showError:'** select a context first **'
    ].
    self withWaitCursorDo:[
        UserPreferences systemBrowserClass
            browseAllCallsOn:selectedContext selector.
    ]

    "Modified: / 19-07-2012 / 11:43:02 / cg"
!

browseSendersOf
    "open a browser on the senders of some selector"

    |initial selector sel|

    (sel := codeView selection) notNil ifTrue:[
        initial := SystemBrowser extractSelectorFrom:sel
    ].
    initial isNil ifTrue:[
        initial := selectedContext isNil
                            ifTrue:[nil]
                            ifFalse:[selectedContext selector].
    ].
    selector := Dialog
                    requestSelector:'Selector to browse senders of:'
                    initialAnswer:initial.

    selector notEmptyOrNil ifTrue:[
        self withWaitCursorDo:[
            UserPreferences systemBrowserClass
                browseAllCallsOn:selector asSymbol.
        ]
    ]

    "Modified: / 19-07-2012 / 11:43:29 / cg"
!

clearRememberedCallchain
    "clear the remembered callchain."

    RememberedCallChain := nil

    "Created: / 08-03-2012 / 01:29:46 / cg"
!

closeAllDebuggers
    (Dialog confirm:'Close all Debuggers (without confirmation if code was changed)?')
    ifFalse:[
        ^ self
    ].

    self class allInstancesDo:[:debugger |
        debugger ~~ self ifTrue:[
            debugger busy ifTrue:[
                debugger destroyWithConfirmation:true.
            ].
        ].
    ].
    self closeRequest.

    "Created: / 23-03-2012 / 12:40:22 / cg"
!

configureX:x y:y width:newWidth height:newHeight
    super configureX:x y:y width:newWidth height:newHeight.
    LastExtent := self extent.
    LastOrigin := self origin.

    "Created: / 10-11-2010 / 10:09:11 / cg"
!

copyWalkbackText
    "place the contents of the walkback view into the copy-paste buffer.
     This allows pasting it into some other view for printing.

     Show the full verbose context without filtering."

    |infoText|

    firstContext isNil ifTrue:[
        infoText := 'No context, no walkback'.
    ] ifFalse:[
        exceptionInfoLabel notNil ifTrue:[
            infoText := exceptionInfoLabel label , '\\' withCRs.
        ] ifFalse:[
            infoText := ''
        ].
        infoText := infoText asStringCollection, firstContext fullPrintAllString asStringCollection.
    ].

    self setClipboardText:infoText

    "Modified: 28.8.1995 / 15:31:59 / claus"
!

doAbort
    "abort - send Object>>abortSignal, which is usually caught
     at save places (for example: in the event loop) and returns back
     from whatever the process is doing, but does not terminate it."

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Abort anyway ?')
    ifFalse:[ ^ self ].
    ^ self doAbortWithoutConfirmation

    "Modified: / 25-11-2016 / 13:37:05 / cg"
!

doAbortAll
    "abortAll - send Object>>abortAllSignal, which is usually caught
     at save places (for example: in the event loop) and returns back
     from whatever the process is doing, but does not terminate it."

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Abort anyway ?') 
    ifFalse:[ ^ self ].

    inspecting ifTrue:[
        inspectedProcess isDead ifTrue:[
            self showTerminated.
            ^ self
        ].
        (AbortOperationRequest isHandledIn:inspectedProcess suspendedContext) ifFalse:[
            self showError:'** the process does not handle the abort signal **'
        ] ifTrue:[
            self interruptProcessWith:[AbortAllOperationRequest raise].
        ].
        ^ self
    ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #abortAll.

    "exit private event-loop"
    catchBlock notNil ifTrue:[
        abortButton turnOff.
        catchBlock value.

        "/ not reached
        'DebugView [warning]: abort failed' errorPrintCR.
    ].

    ^ self.

    "Modified: / 25-11-2016 / 13:36:15 / cg"
!

doAbortWithoutConfirmation
    "abort - send Object>>abortSignal, which is usually caught
     at save places (for example: in the event loop) and returns back
     from whatever the process is doing, but does not terminate it."

    inspecting ifTrue:[
        inspectedProcess isDead ifTrue:[
            self showTerminated.
            ^ self
        ].
        (AbortOperationRequest isHandledIn:inspectedProcess suspendedContext) ifFalse:[
            self showError:'** the process does not handle the abort signal **'
        ] ifTrue:[
            self interruptProcessWith:[AbortOperationRequest raise].
        ].
        ^ self
    ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #abort.

    "exit private event-loop"
    catchBlock notNil ifTrue:[
        abortButton turnOff.
        catchBlock value.

        "/ not reached
        'DebugView [warning]: abort failed' errorPrintCR.
    ].

    ^ self.

    "Modified: / 17.11.2001 / 22:53:22 / cg"
!

doChangeProcessPriority
    "ask for and change the process's priority"

    |oldPrio newPrio s|

    oldPrio := (inspectedProcess ? Processor activeProcess) priority.

    [
        s := Dialog
                request:(resources stringWithCRs:'Change the processes priority to (proceed with prio):\\    2 - system background\    4 - user background\    8 - normal\    9 - high\   16 - I/O (danger alert)\')
                initialAnswer:oldPrio printString.
        s isEmptyOrNil ifTrue:[^ self].
        newPrio := Integer readFrom:s onError:nil.
        newPrio isNil
    ] whileTrue.

    newPrio := newPrio max:(Processor lowestPriority).
    newPrio := newPrio min:(Processor highestPriority).
    newPrio >= Processor highIOPriority ifTrue:[
        (Dialog
                confirm:(resources
                            stringWithCRs:'Attention: event handling takes place at prio 16.\An ever running high priority process\could block the system and make the UI unusable.\\Proceed?'))
        ifFalse:[^ self].
    ].
    (inspectedProcess ? Processor activeProcess) priority:newPrio.

    "Created: / 07-03-2012 / 14:15:09 / cg"
!

doContinue
    "continue from menu"

    |proc exContext ex answer|

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Continue anyway ?')
    ifFalse:[ ^ self ].

    inspecting ifTrue:[
        device hasColors ifTrue:[
            continueButton foregroundColor:Color red darkened.
        ].
        continueButton label:(resources string:'Stop').
        continueButton action:[self doStop].

        self processPerform:#resume.

        ^ self
    ].
    canContinue ifTrue:[
        exContext := thisContext findSpecialHandle:false raise:true.

        (exContext notNil
        and:[ (ex := exContext receiver) isProtoObject not
        and:[ ex isException
        and:[ ex creator == NoHandlerError
        and:[ ex exception creator == RecursionError]]]])
        ifTrue:[
            "/ debug due to unhandled recursionInterrupt.
            "/ ask if we should proceed with more stack.

            answer := self confirm:'Debugger entered due to a stack overflow.\\Continue with more stack ?' withCRs.
            answer == true ifTrue:[
                proc := Processor activeProcess.
                proc setMaximumStackSize:(proc maximumStackSize * 2).
            ].
        ].

        steppedContext := wrapperContext := nil.
        tracing := false.
        haveControl := false.
        exitAction := #continue.

        "exit private event-loop"
        catchBlock value.

        "/ not reached.
        'DebugView [warning]: continue failed' errorPrintCR.
        continueButton turnOff.

    ] ifFalse:[
        inspecting ifFalse:[
            'DebugView [info]: resuming top context' infoPrintCR.
            self showSelection:1.
            self doReturn
        ]
    ]

    "Modified: / 26-07-1999 / 15:38:45 / stefan"
    "Modified: / 25-11-2016 / 13:37:20 / cg"
!

doContinueAfterDelay
    Delay waitForSeconds:5.
    self doContinue.
!

doDefine
    |selectionIndex selector argNames receiversClass proto haltStmtDef haltStmtFix code cat
     bagOfClassNames bagOfUsedClassNames implClass idx callee restart varName argName|

    selectionIndex := contextView selection.
    restart := true.

    selectorToDefine notNil ifTrue:[
        selector := selectorToDefine.
        receiversClass := classToDefineIn.
    ] ifFalse:[
        selector := actualContext selector.
        receiversClass := actualContext receiver class.
    ].

    implClass := actualContext receiver class whichClassIncludesSelector:selector.
    implClass notNil ifTrue:[
        "/ must be a subclassResponsibility

        idx := contextArray identityIndexOf:actualContext.
        idx > 1 ifTrue:[
            callee := contextArray at:idx-1.

            callee selector == #subclassResponsibility ifTrue:[
                restart := false.
            ]
        ].
    ].

    "generate nice argument names"
    bagOfClassNames := (actualContext args collect:[:eachArg | eachArg class name]) asBag.
    bagOfUsedClassNames := Bag new.
    argNames := actualContext args
                    collect:
                        [:eachArg |
                            |nm|

                            nm := eachArg class nameWithoutPrefix.
                            (bagOfClassNames occurrencesOf:nm) == 1 ifTrue:[
                                nm article , nm
                            ] ifFalse:[
                                bagOfUsedClassNames add:nm.
                                nm asLowercaseFirst , (bagOfUsedClassNames occurrencesOf:nm) printString
                            ].
                        ].

    proto := Method methodDefinitionTemplateForSelector:selector andArgumentNames:argNames.

    haltStmtDef := '    self halt:''please define %2 here''.'.
    haltStmtFix := '    self halt:''please change %2 as required''.'.


    ( { UndefinedObject . True . False } includes:receiversClass ) ifTrue:[
        (self confirm:'Are you sure you want to add this method (to ',receiversClass name,') ?')
        ifFalse:[
            ^ self
        ]
    ].


    "/ code for a getter
    (receiversClass instVarNames includes:selector) ifTrue:[
        code := '%1\' , haltStmtFix , '\    ^ %2'.
        cat := 'accessing'.
    ].

    "/ code for a setter
    (selector numArgs == 1
    and:[(selector endsWith:':')
    and:[receiversClass instVarNames includes:(selector copyButLast:1)]])
    ifTrue:[
        varName := selector copyButLast:1.
        argName := argNames first.
        code := '%1\' , haltStmtFix , '\    %3 := %4.'.
        cat := 'accessing'.
    ].

    "/ code for a tester
    (selector numArgs == 0
    and:[(selector startsWith:'is')
    and:[(Smalltalk classNamed:(selector copyFrom:3)) notNil ]])
    ifTrue:[
        (receiversClass nameWithoutPrefix = (selector copyFrom:3)) ifTrue:[
            code := '%1\' , haltStmtFix , '\    ^ true.'.
        ] ifFalse:[
            code := '%1\' , haltStmtFix , '\    ^ false.'.
        ].
        cat := 'testing'.
    ].

"/    actualContext receiver isClass ifTrue:[
"/        selector == #new ifTrue:[
"/            code := '%1\' , haltStmt , '\    ^ self basicNew initialize'
"/        ].
"/        selector == #'new:' ifTrue:[
"/            code := '%1\' , haltStmt , '\    ^ (self basicNew:arg) initialize'
"/        ].
"/    ].
    code isNil ifTrue:[
        code := '%1\' , haltStmtDef
    ].

    self
        codeAccept:(code bindWith:proto with:selector with:varName with:argName) withCRs
        inClass:receiversClass
        unwind:false
        category:cat
        onCancel:[^ self].

    self doShowSelection:selectionIndex.
    restart ifTrue:[
        self doRestart
    ]

    "Modified: / 23-03-2012 / 09:49:31 / cg"
!

doGotoApplicationActionMethod
    "select the first application-model context.
     This is another great helper, when you hit an exception,
     to quickly navigate to the responsible code of you application"

    contextArray keysAndValuesDo:[:i :c |
        |nextCon nextRcvr dialog|

        "/ find the first appModel context
        nextCon := contextArray at:i+1.
        "/
        "/ while not in the appModel
        "/
        [
            nextRcvr := nextCon receiver.
            (nextRcvr isKindOf:ApplicationModel)
        ] whileFalse:[
            nextCon := nextCon sender
        ].
        self selectContext:nextCon.
        ^ self.
    ].
    "/ not found
    gotoApplicationActionMethodButton disable.
!

doGotoDialogOpener
    "select the context where the dialog was opened.
     This is a great helper, when you press interrupt while a modal dialog
     is open, to quickly navigate to the corresponding opening code of you application"

    contextArray keysAndValuesDo:[:i :c |
        |nextCon nextRcvr dialog|

        "/ find the openModal, then walk upward
        ((c selector == #openModal) or:[c selector == #openModal:]) ifTrue:[
            dialog := c receiver.
            nextCon := contextArray at:i+1.
            "/
            "/ while still in dialog code
            "/
            [
                nextRcvr := nextCon receiver.
                (nextRcvr == dialog)
                or:[ nextRcvr == dialog class
                or:[ nextRcvr == DialogBox ]]
            ] whileTrue:[
                (nextCon isBlockContext and:[ nextCon methodHome notNil]) ifTrue:[
                    nextCon := nextCon methodHome
                ].
                nextCon := nextCon sender.
            ].
            "/
            "/ while still in a Notification
            "/
            [
                nextRcvr := nextCon receiver.
                (nextRcvr isKindOf:UserInformation)
                or:[ nextRcvr isBehavior
                     and:[nextRcvr includesBehavior:UserInformation]]
            ] whileTrue:[
                nextCon := nextCon sender
            ].
            "/
            "/ while still in UIBuilder
            "/
            [
                nextRcvr := nextCon receiver.
                (nextRcvr isKindOf:WindowBuilder)
            ] whileTrue:[
                nextCon := nextCon sender
            ].
            "/
            "/ while still in SimpleDialog
            "/
            [
                nextRcvr := nextCon receiver.
                (nextRcvr class == SimpleDialog)
            ] whileTrue:[
                nextCon := nextCon sender
            ].
            "/
            "/ while still in applicationModel support code
            "/
            [
                (nextCon selector startsWith:'openDialogSpec').
            ] whileTrue:[
                nextCon := nextCon sender
            ].
            self selectContext:nextCon.
            ^ self.
        ]
    ].
    "/ not found
    gotoDialogOpenerButton disable.
!

doInspectProcess
    (inspectedProcess ? Processor activeProcess) inspect.
!

doMicroSend
    "single send; reenter with next message send"

    inspecting ifTrue:[^ self].

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Step anyway ?')
    ifFalse:[ ^ self ].

    canContinue ifTrue:[
        steppedContext := wrapperContext := nil.
        haveControl := false.
        exitAction := #step.

        "exit private event-loop"
        catchBlock value.

        "/ not reached
        'DebugView [warning]: send failed' errorPrintCR.
        sendButton turnOff.
    ]

    "Created: / 06-03-1997 / 21:09:36 / cg"
    "Modified: / 25-11-2016 / 13:37:34 / cg"
!

doNext
    "skip for next source-code line; entering blocks"

    stepHow := #nextIn.
    self doStep:nil

    "Modified: 7.3.1997 / 18:38:41 / cg"
!

doNextAfterDelay
    Delay waitForSeconds:5.
    self doNext.
!

doNextOut
    "skip for next source-code line; leaving blocks"

    stepHow := #nextOut.
    self doStep:nil

    "Created: 3.3.1997 / 21:31:22 / cg"
    "Modified: 7.3.1997 / 18:38:49 / cg"
!

doNextOver
    "skip for next source-code line; skip over blocks"

    stepHow := #nextOver.
    self doStep:nil

    "Created: 3.3.1997 / 20:50:38 / cg"
    "Modified: 7.3.1997 / 18:39:00 / cg"
!

doNoTrace
    traceView notNil ifTrue:[
        traceView topView destroy.
        traceView := nil.
    ].
    tracing := false
!

doOpenReportMailApp
    "open a mail report tool"

    | str |

    str := '' writeStream.

    str nextPutLine:('Error notification from '
                    , OperatingSystem getLoginName
                    , '@'
                    , OperatingSystem getHostName).
    str cr.

    str nextPutLine:('Time: ' , Timestamp now printString).
    str nextPutLine:('STX Version: ' , Smalltalk versionString).
    str nextPutLine:('Description: ' , self label).
"/    str nextPutLine:('Error: ', printedException description).
"/    str nextPutLine:('Signal: ', printedException signal printString).
"/    str nextPutLine:('Parameter: ', printedException parameter printString).
    str nextPutLine:'Backtrace:'.
    str cr.

    firstContext notNil ifTrue:[
        firstContext fullPrintAllOn:str.
    ].
    str cr;cr.

    SendMailTool
        openForMessage:(str contents)
        withSubject:('STX Error:[', self label, ']')
        preOpenBlock:[:inst|
            inst recipientEntryField value:'error@exept.de'
        ].

    "Modified: / 20-09-2007 / 12:40:40 / cg"
!

doResend
    "resend - the selected context is unwound and its message resent.
     To be done after a cde change, to get nto the new method"

    inspecting ifTrue:[
        ^ self showError:'** not avail in inspecting debugger **'
    ].

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Resend anyway ?')
    ifFalse:[ ^ self ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #resend. "exit private event-loop"

    catchBlock value.

    "/ normally not reached

    'DebugView [warning]: resend failed' errorPrintCR.
    resendButton turnOff.

    "Modified: / 25-11-2016 / 13:37:56 / cg"
!

doRestart
    "restart - the selected context will be restarted"

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Restart anyway ?')
    ifFalse:[ ^ self ].

    inspecting ifTrue:[
        selectedContext isNil ifTrue:[
            ^ self showError:'** select a context first **'
        ].
        self interruptProcessWith:[ selectedContext unwindAndRestart ].
        ^ self
    ].
    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #restart. "exit private event-loop"

    catchBlock value.

    "/ normally not reached

    'DebugView [warning]: restart failed' errorPrintCR.
    restartButton turnOff.

    "Modified: / 25-11-2016 / 13:38:14 / cg"
!

doReturn
    "return - the selected context will do a ^nil"

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Return anyway ?')
    ifFalse:[ ^ self ].

    inspecting ifTrue:[
        selectedContext isNil ifTrue:[
            ^ self showError:'** select a context first **'
        ].
        self interruptProcessWith:[selectedContext unwind:nil].
        ^ self
    ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #return.

    "exit private event-loop"
    catchBlock value.

    "/ not reached
    'DebugView [warning]: return failed' errorPrintCR.
    returnButton turnOff.

    "Modified: / 25-11-2016 / 13:38:27 / cg"
!

doSend
    "single send; reenter with next message send"

    stepHow := #send.
    self doStep:-1

"/    inspecting ifTrue:[^ self].
"/
"/    canContinue ifTrue:[
"/        steppedContext := wrapperContext := nil.
"/        haveControl := false.
"/        exitAction := #step.
"/
"/        "exit private event-loop"
"/        catchBlock notNil ifTrue:[catchBlock value].
"/
"/        "/ not reached
"/        'DebugView [warning]: send failed' errorPrintCR.
"/        sendButton turnOff.
"/    ]

    "Modified: 7.3.1997 / 18:41:26 / cg"
!

doStep
    "skip for next send in selected method"

    stepHow := #step.
    self doStep:-1

    "Modified: 7.3.1997 / 18:46:49 / cg"
!

doStep:lineNrOrNilOrMinus1
    "common helper for step, skip & next.
     Arrange for single-steppping until we pass lineNr (if nonNil)
     or to next line (if nil) or to next send (if -1)"

    |con method|

    inspecting ifTrue:[^ self].

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Step anyway ?')
    ifFalse:[ ^ self ].

    canContinue ifTrue:[
        selectedContext notNil ifTrue:[
            con := actualContext. "/ selectedContext.
            steppedContextLineno := actualContext lineNumber.
        ] ifFalse:[
            con := contextArray at:2.
            steppedContextLineno := con lineNumber.
        ].

        skipLineNr := lineNrOrNilOrMinus1.

        lineNrOrNilOrMinus1 == -1 ifTrue:[
            steppedContextLineno := skipLineNr := nil.
        ].

        (stepUntilEntering isNil and:[stepHow == #send]) ifTrue:[
            steppedContext := contextArray at:1.
            stepHow := #nextIn.
        ] ifFalse:[
            stepHow == #nextOut ifTrue:[
                steppedContext := con home.
            ] ifFalse:[
                steppedContext := con.
            ].
        ].

        wrapperContext := nil.

"/ ' step con:' print. (ObjectMemory addressOf:steppedContext) printHex. ' ' print. steppedContext printCR.

        "
         if we step in a wrapped method,
         prepare to skip the prolog ...
        "

        inWrap := false.
        method := con method.
        (method notNil
        and:[method isWrapped
        and:[method originalMethod ~~ method]]) ifTrue:[
            inWrap := true
        ].

        lineNrOrNilOrMinus1 == #return ifTrue:[
            Processor activeProcess forceInterruptOnReturnOf:con.
        ].

        con := nil.
        bigStep := true.
        haveControl := false.
        exitAction := #step.

        "exit private event-loop"
        catchBlock value.

        "/ not reached
        'DebugView [warning]: step failed' errorPrintCR.
        stepButton turnOff. nextButton turnOff. sendButton turnOff.
    ]

    "Modified: / 25-11-2016 / 13:38:40 / cg"
!

doStepAfterDelay
    Delay waitForSeconds:5.
    self doStep.
!

doStop
    "stop the process (if its running, otherwise this is a no-op)"

    inspecting ifTrue:[
        device hasColors ifTrue:[
            continueButton foregroundColor:Color green darkened darkened.
        ].
        continueButton label:(resources string:'Continue').
        continueButton action:[self doContinue].

        self processPerform:#stop.

        ^ self
    ].

    "Modified: 20.10.1996 / 18:30:48 / cg"
!

doTerminate
    "terminate - the process has a chance for cleanup"

    (self checkIfCodeIsReallyModifiedAndConfirmWith:'Code was modified.\\Terminate anyway ?')
    ifFalse:[ ^ self ].

    inspecting ifTrue:[
        self processPerform:#terminate.
        ^ self
    ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #terminate.

    "exit private event-loop"
    catchBlock value.

    "/ not reached (normally)
    inspecting ifFalse:[
        'DebugView [warning]: terminate failed' errorPrintCR.
        (self confirm:'Regular terminate failed - do it the hard way ?') ifTrue:[
            Debugger newDebugger.
            Processor activeProcess terminate.
        ]
    ].
    terminateButton turnOff.

    "Modified: / 25-11-2016 / 13:38:51 / cg"
!

doTrace
    "tracing - not really implemented ..."

    self warn:'this function is not yet implemented'.

"/    |v b|
"/
"/    traceView isNil ifTrue:[
"/        v := StandardSystemView on:Display.
"/        v label:'Debugger-Trace'.
"/        v icon:icon.
"/
"/        b := Button label:'untrace' in:v.
"/        b origin:(0 @ 0) extent:(1.0 @ (b height)).
"/        b action:[
"/            StepInterruptPending := nil.
"/            tracing := false.
"/            v unrealize.
"/            traceView := nil
"/        ].
"/        traceView := ScrollableView for:TextCollector in:v.
"/        traceView origin:(0 @ (b height))
"/                  extent:[v width @ (v height - b height)]
"/    ].
"/    v realize.
"/
"/    tracing := true.
!

doTraceStep
    "tracestep - not implemented yet"

    canContinue ifTrue:[
        tracing := true.
        self doStep
    ]
!

exit
    "exit from menu: immediate exit from smalltalk"

    OperatingSystem exit:10
!

findContextForWhich:aBlock thenDo:additionalAction
    |con|

    con := self selectedContext.
    con isNil ifTrue:[^ self].

    con := con sender.
    [con notNil] whileTrue:[
        (aBlock value:con) ifTrue:[
            (self selectContext:con) ifTrue:[
                additionalAction value:con.
                ^ self.
            ]
        ].
        con := con sender.
    ].

    Dialog information:'None found'.
!

findContextWithStringInSource
    |stringToSearch source|

    stringToSearch := Dialog request:'Search what:'.
    stringToSearch isEmptyOrNil ifTrue:[^ self].

    self
        findContextForWhich:[:con |
            con method notNil
            and:[ (source := con method source) notNil
            and:[ (source includesString:stringToSearch) ]]
        ]
        thenDo:[:con |
            codeView searchFwd:stringToSearch.
        ]
!

findContextWithValueInVariable
    |valueStringToSearch|

    valueStringToSearch := Dialog request:'Search for a local value whith printString containing:'.
    valueStringToSearch isEmptyOrNil ifTrue:[^ self].

    self
        findContextForWhich:[:con |
            con argsAndVars contains:[:val | val printString asLowercase includesString: valueStringToSearch asLowercase]
        ]
        thenDo:[:con | ]
!

findHandlerFor
    |exClass con|

    (con := self selectedContext) isNil ifTrue:[
        con := contextArray at:1
    ].
    con sender isNil ifTrue:[
        self information:'Context has already returned'.
        ^ self
    ].

    exClass := Dialog
                choose:'Exception class:'
                fromList:(GenericException withAllSubclasses copyAsOrderedCollection sort:[:a :b | a name < b name])
                lines:25
                title:'Choose Exception class'.
    exClass isNil ifTrue:[^ self].

    self
        findContextForWhich:[:con |
            con isHandleContext
            and:[ (con receiver handlerForSignal:exClass context:con originator:nil) notNil ]
        ]
        thenDo:[:con |
            self selectContext:con sender.
        ]
!

findHomeContext
    |con home|

    (con := self selectedContext) isNil ifTrue:[
        self beep.
        ^ self.
    ].
    (home := con home) isNil ifTrue:[
        self beep.
        ^ self.
    ].

    "/ still have to find it - home could be elsewhere (another process)
    "/ (i.e. cannot simply select it)

    self
        findContextForWhich:[:con |
            con == home
        ]
        thenDo:[:con |
            self selectContext:con.
        ]
!

findNextExceptionHandlerContext
    self
        findContextForWhich:[:con |
            con isHandleContext
        ]
        thenDo:[:con |
            self selectContext:con sender.
        ]
!

inspectContext
    "launch an inspector on the currently selected context"

    |con|

    (con := self selectedContext) notNil ifTrue:[
        con inspect.
    ]

    "Modified: / 17-07-2012 / 12:52:34 / cg"
!

inspectContextsMethod
    "launch an inspector on the currently selected context's method"

    |con|

    (con := self selectedContext) notNil ifTrue:[
        con method inspect.
    ]
!

inspectProcessesApplication
    "inspect the application (of the process, if it is a GUI process)"

    |app|

    (app := self processesApplication) notNil ifTrue:[
        app inspect.
    ].
!

inspectWidgetHierarchy
    |rcvr view app|

    Tools::ViewTreeInspectorApplication isNil ifTrue:[
        Dialog warn:'Missing class: Tools::ViewTreeInspectorApplication'.
        ^ self.
    ].

    selectedContext notNil ifTrue:[
        rcvr := selectedContext receiver.
        rcvr isView ifTrue:[
            view := rcvr
        ] ifFalse:[
            (rcvr isKindOf:ApplicationModel) ifTrue:[
                view := rcvr window
            ].
        ].
    ].
    view isNil ifTrue:[
        (app := self processesApplication) notNil ifTrue:[
            view := app window
        ] ifFalse:[
            Dialog warn:'Please select a context with the app as receiver'.
            ^ self.
        ]
    ].
    Tools::ViewTreeInspectorApplication openOn:view

    "Modified: / 25-11-2016 / 13:21:45 / cg"
!

middleButtonMenu
    <resource: #programMenu >

    |items m nameOfExecutable|

    exclusive ifTrue:[
        items := #(
                    ('Show More WalkBack'               showMore                )
                    ('-'                                                        )
                    ('Add Breakpoint'                   addBreakpoint           )
                    ('Remove Breakpoint'                removeBreakpoint        )
                    ('Remove all Break- && Tracepoints'  removeAllBreakpoints   )
                    ('-'                                                        )
                  ).
    ] ifFalse:[
        items := #(
                    ('Show More WalkBack'               showMore                )
                    ('-'                                                        )
                    ('Skip'                             skip                    )
                    ('Step Out'                         skipForReturn           )
                    ('Skip until Entering...'           skipUntilEntering       )
                    ('-'                                                        )
"
                    ('Continue'                         doContinue              )
                    ('Terminate'                        doTerminate             )
                    ('Abort'                            doAbort                 )
                    ('-'                                                        )
                    ('Step'                             doStep                  )
                    ('Send'                             doSend                  )
                    ('-'                                                        )
                    ('Return'                           doReturn                )
                    ('Restart'                          doRestart               )
                    ('-'                                                        )
"
                    ('Add Breakpoint'                   addBreakpoint           )
                    ('Remove Breakpoint'                removeBreakpoint        )
                    ('Remove all Break- & Tracepoints'  removeAllBreakpoints    )
                ).

"/        self allowBreakPointsInDebugger ifFalse:[
"/            items := items , #(
"/                        ('Allow Breakpoints & halt in Debugger'      doNotIgnoreBreakpoints  )
"/                    ).
"/        ] ifTrue:[
"/            items := items , #(
"/                        ('Ignore Breakpoints & halt in Debugger'     doIgnoreBreakpoints  )
"/                    ).
"/        ].

        items := items , #(
                    ('-'                                                        )
                    ('Browse Implementing Class'      browseImplementingClass )
                    ('Browse Receiver''s Class'             browseReceiversClass    )
                    ('Browse Blocks''s Home'                browseBlocksHome    )
"/                    ('Browse Receivers Class Hierarchy'   browseClassHierarchy    )
"/                    ('Browse Receivers Full Protocol'     browseFullClassProtocol )
                    ('Implementors'                     browseImplementors      )
                    ('Implementors Of...'               browseImplementorsOf    )
                    ('Senders'                          browseSenders           )
                    ('Senders Of...'                    browseSendersOf         )
                    ('-'                                                        )
                    ('Inspect Context'                  inspectContext          )
                  ).
    ].

    items := items , #(
                ('Copy WalkBack Text'               copyWalkbackText        )
                ('-'                                                        )
                ('Hard Terminate (Danger)'          quickTerminate          )
                ('='                                                        )).

    nameOfExecutable := OperatingSystem nameOfSTXExecutable asFilename withoutSuffix baseName.
    nameOfExecutable = 'stx' ifTrue:[ nameOfExecutable := 'Smalltalk' ].

    items := items , {
        { 'Exit %1 (Danger: No Confirmation)' bindWith:nameOfExecutable. #exit                 }}.

    m := PopUpMenu
                itemList:items
                resources:resources
                receiver:self
                for:contextView.

    inspecting ifTrue:[
        m notNil ifTrue:[
            m disableAll:#(doTraceStep removeBreakpoint browseImplementingClass browseReceiversClass
                           browseClassHierarchy browseFullClassProtocol
                           browseImplementors browseSenders browseBlocksHome inspectContext skip doStepOut).
        ].
    ].
    self updateMenuItems.

    ^ m.

    "Modified: / 22-07-2013 / 15:30:05 / cg"
!

notShowingDenseWalkbackHolder
    ^ BlockValue forLogicalNot: self showingDenseWalkbackHolder.
!

notShowingSupportCode
    ^ hideSupportCode == true.

    "Created: / 10-06-2012 / 21:27:24 / cg"
!

openAboutThisApplication
    "opens an about box for this application."

    Dialog aboutClass:self class.

    "Modified: / 12-09-2006 / 17:20:38 / cg"
!

openSettingsDialog
    |settingsList|

    settingsList :=
        #(
           #('Debugger'       #'AbstractSettingsApplication::DebuggerSettingsAppl'            )
           #('Editor'         #'AbstractSettingsApplication::EditSettingsAppl'                )
           #('Syntax Color'   #'AbstractSettingsApplication::SyntaxColorSettingsAppl'         )
           #('Code Format'    #'AbstractSettingsApplication::SourceCodeFormatSettingsAppl'    )
        ).

    SettingsDialog
        openWithList:settingsList
        label:(resources string:'Debugger Settings').
!

processesApplication
    "if the debugged process is a GUI process,
     AND it has an applicaiton, return it.
     Otherwise, return nil"

    |p wgs app nonModalWGs|

    p := inspectedProcess ? Processor activeProcess.
    (p notNil and:[p isGUIProcess]) ifTrue:[
        wgs := WindowGroup scheduledWindowGroups select:[:wg | wg process == p].
        nonModalWGs := wgs reject:[:wg | wg isModal].
        nonModalWGs notEmpty ifTrue:[^ nonModalWGs first application].

        wgs do:[:wg |
            |wgi|

            wgi := wg.
            [wgi notNil] whileTrue:[
                (app := wgi application) notNil ifTrue:[^ app].
                wgi isModal ifTrue:[
                    wgi := wgi previousGroup
                ] ifFalse:[
                    wgi := nil.
                ]
            ]
        ]
    ].
    ^ nil
!

quickTerminate
    "quick terminate - the process will get no chance for cleanup actions"

    inspecting ifTrue:[
        self processPerform:#terminateNoSignal.
        ^ self
    ].

    steppedContext := wrapperContext := nil.
    haveControl := false.
    exitAction := #quickTerminate.

    "exit private event-loop"
    catchBlock value.

    "/ not reached (normally)
    inspecting ifFalse:[
        'DebugView [warning]: quick terminate failed' errorPrintCR.
        (self confirm:'Regular quick terminate failed - do it the hard way ?') ifTrue:[
            Debugger newDebugger.
            Processor activeProcess terminateNoSignal.
        ]
    ].
    terminateButton turnOff.

    "Modified: 10.1.1997 / 17:42:10 / cg"
!

rememberCallchain
    "remember the callchain in a classvar.
     When entered the next time, highlight already entered contexts.
     This makes it possible to identitfy the caller as the first common context
     along the chain (i.e. the context which is responsible for the debugger to be entered)"

    RememberedCallChain := contextArray copy

    "Created: / 07-03-2012 / 23:07:07 / cg"
!

selectContext:aContext
    |idx|

    idx := contextArray identityIndexOf:aContext.
    idx == 0 ifTrue:[
        "/ some contexts hidden?
        (self showingDenseWalkback or:[self showingSupportCode not]) ifTrue:[
            Dialog information:'Context is hidden - disabling the "hideSupportCode" option (see view menu)'.
            self showFullWalkback.
            self showingDenseWalkback:false.
            self showingSupportCode:true.
        ].
        idx := contextArray identityIndexOf:aContext.
    ].
    idx ~~ 0 ifTrue:[
        self selectContextWithIndex:idx.
        ^ true.
    ].
    ^ false
!

selectedContext
    |selIdx|

    (selIdx := contextView selection) notNil ifTrue:[
        (contextView selectionValue startsWith:'**') ifFalse:[
            ^ (contextArray at:selIdx).
        ]
    ].
    ^ nil

    "Created: / 17-07-2012 / 12:52:10 / cg"
!

showFullWalkback
    "double the number of contexts shown"

    contextArray notNil ifTrue:[
        nChainShown := 9999.
        self redisplayBacktrace.
    ]

    "Created: / 23-07-2012 / 12:24:02 / cg"
!

showMore
    "double the number of contexts shown"

    contextArray notNil ifTrue:[
        nChainShown := nChainShown * 2.
        self redisplayBacktrace.
    ]

    "Modified: / 17.11.2001 / 20:14:31 / cg"
!

showSupportCode
    hideSupportCode := false.
    self redisplayBacktrace.

    "Created: / 10-06-2012 / 21:27:53 / cg"
!

showingDenseWalkback
    ^ self verboseBacktraceHolder value not

    "Created: / 17.11.2001 / 20:13:53 / cg"
!

showingDenseWalkback:aBoolean
    self verboseBacktraceHolder value:aBoolean not.
    self redisplayBacktrace.

    "Created: / 27-07-2012 / 14:58:00 / cg"
!

showingDenseWalkbackHolder
    ^ BlockValue forLogicalNot:self verboseBacktraceHolder
!

showingSupportCode
    ^ hideSupportCode == false.

    "Created: / 10-06-2012 / 21:28:05 / cg"
!

showingSupportCode:aBoolean
    hideSupportCode := aBoolean not.
    self redisplayBacktrace.

    "Created: / 27-07-2012 / 14:58:00 / cg"
!

showingVerboseWalkback
    ^ self verboseBacktraceHolder value

    "Created: / 17.11.2001 / 20:13:46 / cg"
!

sizeChanged:how
    super sizeChanged:how.
    LastExtent := self extent.

    "Created: / 10-11-2010 / 09:08:41 / cg"
!

skip
    "skip for cursor line in selected method"

    stepHow := #skip.
    self doStep:codeView cursorLine.

    "Modified: 3.3.1997 / 20:56:23 / cg"
!

skipForReturn
    "skip until the selected context is left."

    stepHow := #skipReturn.
    self doStep:#return.

    "Modified: 3.3.1997 / 20:56:32 / cg"
!

skipUntilEntering
    "skip until some particular method is invoked."

    |selector|

    selector := Dialog
                request:'Skip until entering what (matchpattern):'
                initialAnswer:self goodSkipUntilSelector.
    selector size == 0 ifTrue:[^ self].

    stepUntilEntering := selector asSymbol.
    stepHow := #send.
    self doStep:-1.

    "Modified: 3.3.1997 / 20:56:32 / cg"
!

toggleShowSupportCode
    hideSupportCode ifTrue:[
        self showSupportCode
    ] ifFalse:[
        self hideSupportCode
    ].

    "Modified: / 17-11-2001 / 20:07:45 / cg"
    "Created: / 10-06-2012 / 21:28:17 / cg"
!

toggleVerboseWalkback
    self showingDenseWalkback:(self showingDenseWalkback not)

    "Modified: / 27-07-2012 / 15:00:15 / cg"
!

updateMenuItems
    "enable/disable some menu items, depending on the current selected context"

    |m mthd cls mCls rCls|

    m := contextView middleButtonMenu.
    m notNil ifTrue:[
        m disable:#removeBreakpoint.
        m disable:#addBreakpoint.
        canShowMore ifFalse:[
            m disable:#showMore
        ].

        selectedContext notNil ifTrue:[
            m enableAll:#(browseImplementors browseSenders inspectContext skip skipForReturn).

            mthd := selectedContext method.
            mthd notNil ifTrue:[
                cls := mCls := mthd containingClass.
                mthd isBreakpointed ifTrue:[
                    m enable:#removeBreakpoint.
                ] ifFalse:[
                    m enable:#addBreakpoint.
                ]
            ].
            (selectedContext isBlockContext and:[selectedContext home isNil]) ifTrue:[
                "/ a cheap block's context
            ] ifFalse:[
                rCls := selectedContext receiver class.
                cls isNil ifTrue:[
                    cls := rCls
                ].
            ].
            cls notNil ifTrue:[
                m enableAll:#(browseImplementingClass browseReceiversClass browseClassHierarchy browseFullClassProtocol).
                rCls == mCls ifTrue:[
                    m disable:#browseReceiversClass
                ].
                mCls isNil ifTrue:[
                    m disable:#browseImplementingClass
                ]

            ] ifFalse:[
                m disableAll:#(browseImplementingClass browseReceiversClass browseClassHierarchy browseFullClassProtocol).
            ].
            mthd notNil ifTrue:[
                m enableAll:#(browseImplementingClass).
            ].
            selectedContext isCheapBlockContext ifTrue:[
                m disableAll:#(browseReceiversClass).
            ].
            selectedContext receiver isBlock ifTrue:[
                m enableAll:#(browseBlocksHome).
            ] ifFalse:[
                m disableAll:#(browseBlocksHome).
            ].
        ] ifFalse:[
            m disableAll:#(browseImplementingClass browseReceiversClass browseClassHierarchy
                           browseBlocksHome browseFullClassProtocol).
        ]
    ]

    "Modified: / 19-07-2012 / 11:53:30 / cg"
! !

!DebugView methodsFor:'menu & button actions-breakpoints'!

addBreakpoint
    "add a breakpoint on the selected contexts method - if any"

    |implementorClass method|

    selectedContext isNil ifTrue:[
        ^ self showError:'** select a context first **'
    ].
    (MessageTracer isNil or:[MessageTracer isLoaded not]) ifTrue:[
        ^ self
    ].

    implementorClass := selectedContext methodClass.
    implementorClass notNil ifTrue:[
        method := implementorClass compiledMethodAt:selectedContext selector.
        (method notNil and:[method isBreakpointed not]) ifTrue:[
            method setBreakPoint
        ]
    ].
    contextView middleButtonMenu disable:#addBreakpoint.
    contextView middleButtonMenu enable:#removeBreakpoint.

    "Modified: / 13.1.1998 / 00:24:47 / cg"
!

allowBreakPointsInDebugger
    ^ ignoreBreakpoints not
!

allowBreakPointsInDebugger:aBoolean
    ignoreBreakpoints := aBoolean not.
    self initializeMiddleButtonMenu.
    self initializeContextViewsMiddleButtonMenu.
!

doIgnoreBreakpoints
    self allowBreakPointsInDebugger:false
!

doNotIgnoreBreakpoints
    self allowBreakPointsInDebugger:true
!

ignoreAllHaltsForCurrentProcess
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:true
        orIfCalledFromMethod:nil
        forAll:true.

    "Created: / 27-01-2012 / 11:32:14 / cg"
!

ignoreAllHaltsForThisReceiverClass
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:true orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:true.

    "Created: / 27-01-2012 / 11:32:14 / cg"
!

ignoreAllHaltsForever
    self
        addIgnoredHaltForCount:-1 orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:true.

    "Created: / 08-05-2011 / 10:19:56 / cg"
!

ignoreAllHaltsIfCalledFromMethod:aMethod
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:aMethod
        forAll:true.
!

ignoreAllHaltsUntilShiftKeyIsPressed
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:true
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:true.

    "Created: / 27-01-2012 / 11:32:14 / cg"
!

ignoreBreakpointsWithThisParameterForever
    Object disableBreakPoint:breakPointParameter.
    "/ self addIgnoredHaltForCount:-1 orTimeDuration:nil orUntilShiftKey:false forAll:false.

    "Created: / 06-03-2012 / 12:35:48 / cg"
!

ignoreBreakpointsWithThisParameterUntilShiftKeyIsPressed
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:true
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:false.

    "Created: / 06-03-2012 / 12:35:22 / cg"
!

ignoreHaltForCurrentProcess
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:true
        orIfCalledFromMethod:nil
        forAll:false.

    "Created: / 27-01-2012 / 11:32:14 / cg"
!

ignoreHaltForThisReceiverClass
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:true orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:false.

    "Created: / 27-01-2012 / 11:32:14 / cg"
!

ignoreHaltForever
    self
        addIgnoredHaltForCount:-1 orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:false.

    "Modified: / 27-01-2012 / 11:31:37 / cg"
!

ignoreHaltIfCalledFromMethod:aMethod
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:false
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:aMethod
        forAll:false.
!

ignoreHaltUntilShiftKeyIsPressed
    self
        addIgnoredHaltForCount:nil orTimeDuration:nil orUntilShiftKey:true
        orThisReceiverClass:false orCurrentProcess:false
        orIfCalledFromMethod:nil
        forAll:false.

    "Created: / 27-01-2012 / 11:36:54 / cg"
!

menuForIgnoreAllBreakpointsIfCalledFromAnyOf
    <resource: #programMenu >

    ^ self menuForIgnoreBreakpointIfCalledFromAnyOfForAll:true
!

menuForIgnoreBreakpointIfCalledFromAnyOf
    <resource: #programMenu >

    ^ self menuForIgnoreBreakpointIfCalledFromAnyOfForAll:false
!

menuForIgnoreBreakpointIfCalledFromAnyOfForAll:forAllHaltsBoolean
    <resource: #programMenu >

    |m count already|

    m := Menu new.
    count := 0.
    already := IdentitySet new.

    contextArray do:[:con |
        |mthd cls sel|

        mthd := con method.
        mthd notNil ifTrue:[
            mthd isWrapped ifFalse:[
                (already includes:already) ifFalse:[
                    already add:mthd.
                    m addItem:(MenuItem
                                label: (mthd whoString)
                                itemValue: [ forAllHaltsBoolean
                                                ifTrue:[self ignoreHaltIfCalledFromMethod:mthd]
                                                ifFalse:[self ignoreAllHaltsIfCalledFromMethod:mthd]
                                           ]
                                translateLabel: false).
                    count := count + 1.
                    (count > 20) ifTrue:[
                        ^ m
                    ].
                ]
            ]
        ]
    ].
    ^ m
!

openBreakPointBrowser
    Tools::BreakpointBrowser open

    "Created: / 27-10-2010 / 12:52:49 / cg"
!

openIgnoreAllHaltsUntilTimeElapsedDialog
    |answer dT|

    [
        answer := Dialog
                    request:(resources string:'How long should all halts/breakpoints be ignored [smh] ?')
                    initialAnswer:(LastIgnoreHaltDuration ? '30s') printString.
        answer isEmptyOrNil ifTrue:[^ self].

        dT := TimeDuration readFrom:answer onError:[ nil ].
        dT notNil ifTrue:[
            LastIgnoreHaltDuration := dT.
            self
                addIgnoredHaltForCount:nil orTimeDuration:dT orUntilShiftKey:false
                orThisReceiverClass:false orCurrentProcess:false
                orIfCalledFromMethod:nil
                forAll:true.
            ^ self.
        ].
    ] loop

    "Created: / 08-05-2011 / 10:19:20 / cg"
!

openIgnoreBreakpointsWithThisParameterNTimesDialog
    |answer n|

    [
        answer := Dialog
                    request:(resources
                                string:'How often should breakpoints with parameter "%1" be ignored ?'
                                with:breakPointParameter)
                    initialAnswer:(LastIgnoreHaltNTimes ? '') printString.
        answer isEmptyOrNil ifTrue:[^ self].

        n := Integer readFrom:answer onError:nil.
        n notNil ifTrue:[
            LastIgnoreHaltNTimes := n.
            self
                addIgnoredHaltForCount:n orTimeDuration:nil orUntilShiftKey:false
                orThisReceiverClass:false orCurrentProcess:false
                orIfCalledFromMethod:nil
                forAll:false.
            ^ self.
        ].
    ] loop.

    "Modified: / 27-01-2012 / 11:31:44 / cg"
    "Created: / 06-03-2012 / 12:28:51 / cg"
!

openIgnoreBreakpointsWithThisParameterUntilTimeElapsedDialog
    |answer dT|

    [
        answer := Dialog
                    request:(resources
                                string:'How long should breakpoints with parameter "%1" be ignored (s/m/h) ?'
                                with:breakPointParameter)
                    initialAnswer:(LastIgnoreHaltDuration ? '30s') printString.
        answer isEmptyOrNil ifTrue:[^ self].

        dT := TimeDuration readFrom:answer onError:[ nil ].
        dT notNil ifTrue:[
            LastIgnoreHaltDuration := dT.
            self
                addIgnoredHaltForCount:nil orTimeDuration:dT orUntilShiftKey:false
                orThisReceiverClass:false orCurrentProcess:false
                orIfCalledFromMethod:nil
                forAll:false.
            ^ self.
        ].
    ] loop

    "Created: / 06-03-2012 / 12:03:36 / cg"
!

openIgnoreHaltNTimesDialog
    |answer n|

    [
        answer := Dialog
                    request:(resources string:'How often should this halt be ignored ?')
                    initialAnswer:(LastIgnoreHaltNTimes ? '') printString.
        answer isEmptyOrNil ifTrue:[^ self].

        n := Integer readFrom:answer onError:nil.
        n notNil ifTrue:[
            LastIgnoreHaltNTimes := n.
            self
                addIgnoredHaltForCount:n orTimeDuration:nil orUntilShiftKey:false
                orThisReceiverClass:false orCurrentProcess:false
                orIfCalledFromMethod:nil
                forAll:false.
            ^ self.
        ].
    ] loop.

    "Modified: / 27-01-2012 / 11:31:44 / cg"
!

openIgnoreHaltUntilTimeElapsedDialog
    |answer dT|

    [
        answer := Dialog
                    request:(resources string:'How long should this halt/breakpoint be ignored (s/m/h) ?')
                    initialAnswer:(LastIgnoreHaltDuration ? '30s') printString.
        answer isEmptyOrNil ifTrue:[^ self].

        dT := TimeDuration readFrom:answer onError:[ nil ].
        dT notNil ifTrue:[
            LastIgnoreHaltDuration := dT.
            self
                addIgnoredHaltForCount:nil orTimeDuration:dT orUntilShiftKey:false
                orThisReceiverClass:false orCurrentProcess:false
                orIfCalledFromMethod:nil
                forAll:false.
            ^ self.
        ].
    ] loop

    "Modified: / 27-01-2012 / 11:31:47 / cg"
!

removeAllBreakpoints
    "remove all trace & breakpoints - if any"

    self withExecuteCursorDo:[
        (MessageTracer notNil and:[MessageTracer isLoaded]) ifTrue:[
            MessageTracer unwrapAllMethods
        ].
        (MethodWithBreakpoints notNil and:[MethodWithBreakpoints isLoaded]) ifTrue:[
            MethodWithBreakpoints removeAllBreakpoints
        ].
    ]

    "Modified: / 21.5.1998 / 01:44:43 / cg"
!

removeBreakpoint
    "remove breakpoint on the selected contexts method - if any"

    |implementorClass method|

    selectedContext isNil ifTrue:[
        ^ self showError:'** select a context first **'
    ].
    (MessageTracer isNil or:[MessageTracer isLoaded not]) ifTrue:[
        ^ self
    ].

    implementorClass := selectedContext methodClass.
    implementorClass notNil ifTrue:[
        method := implementorClass compiledMethodAt:selectedContext selector.
        (method notNil and:[method isBreakpointed]) ifTrue:[
            method clearBreakPoint
        ]
    ].
    contextView middleButtonMenu disable:#removeBreakpoint.
    contextView middleButtonMenu enable:#addBreakpoint.

    "Modified: / 13.1.1998 / 00:24:47 / cg"
!

stopIgnoringHalts
    self class stopIgnoringHalts
! !

!DebugView methodsFor:'private'!

abortAllIsHandled
    ^ AbortAllOperationWantedQuery query

    "Modified: / 09-02-2011 / 13:53:13 / cg"
!

busy
    ^ busy
!

exclusive:aBoolean
    exclusive := aBoolean
!

explainSelection
    |interval crsrPos|

    interval := self selectedInterval.
    interval isEmpty ifTrue:[
        crsrPos := codeView characterPositionOfCursor.
        codeView characterUnderCursor isSeparator ifTrue:[
            crsrPos := (crsrPos - 1) max:1
        ].
        interval := crsrPos to:crsrPos.
    ].
    self
        withNodeValueAtInterval:interval
        do:[:value :description |
            self showValue:value
        ].
!

findNodeForInterval:interval
    |source|

    interval isEmpty ifTrue: [^ nil].

    source := codeView contentsAsString string.
"/    source := currentMethod notNil
"/                ifTrue:[ currentMethod source ]
"/                ifFalse:[ codeView contents asString ].
    source isNil ifTrue:[^ nil].

    ^ DoWhatIMeanSupport findNodeForInterval:interval in:(source string) allowErrors:true.
"/    ^ DoWhatIMeanSupport findNodeForInterval:interval in:(source string).
!

findNodeIn:tree forInterval:interval
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ DoWhatIMeanSupport findNodeIn:tree forInterval:interval
"/    |node|
"/
"/    node := nil.
"/    tree nodesDo:[:each |
"/        (each intersectsInterval:interval) ifTrue:[
"/            (node isNil or:[node == each parent]) ifTrue:[
"/                node := each
"/            ] ifFalse:[
"/                (node parent notNil
"/                    and:[node parent isCascade and:[each parent isCascade]]) ifFalse:[^ nil]
"/            ]
"/        ]
"/    ].
"/    ^ node
!

goodSkipUntilSelector
    |current|

    lastStepUntilEntering notNil ifTrue:[^ lastStepUntilEntering].
    selectedContext isNil ifTrue:[^ nil].
    current := selectedContext selector.
    current isNil ifTrue:[^ nil].
    ('change:*' match:current) ifTrue:[
        ^ 'update:*'
    ].
    ^ nil
!

haltSelectors
    ^ #( #'halt' #'halt:' #'breakPoint:' #'breakPoint:info:' #'break').

    "Modified (format): / 27-01-2012 / 11:10:00 / cg"
!

interruptProcessWith:aBlock
    "let inspected process do something, then update the context list"

    inspectedProcess isDead ifTrue:[
        self showTerminated.
        ^ self
    ].
    inspectedProcess interruptWith:aBlock.
    "
     give the process a chance to run, then update
    "
    Delay waitForSeconds:0.2.
    self setContext:(inspectedProcess suspendedContext).
!

mayProceed:aBoolean
    mayProceed := aBoolean
!

openHTMLDocument: anHTMLFilename
    "open a HTMLDocumentView on anHTMLFilename"

    HTMLDocumentView openFullOnDocumentationFile: anHTMLFilename
!

processPerform:aMessage
    "do something, then update the context list"

    inspectedProcess isDead ifTrue:[
        self showTerminated.
        ^ self
    ].
    inspectedProcess perform:aMessage.

    "
     give the process a chance to run, then update
    "
    (Delay forSeconds:0.2) wait.
    self setContext:(inspectedProcess suspendedContext).
!

redisplayBacktrace
    "force redisplay of the walkBack list; invoked when the
     verbose-flag setting is changed"

    |oldSelection oldContext con idx|

    contextArray notNil ifTrue:[
        self withExecuteCursorDo:[
            oldSelection := contextView selection.
            oldSelection notNil ifTrue:[
                oldContext := contextArray at:oldSelection ifAbsent:nil.
            ].

            con := firstContext.
"/            con := contextArray at:1.
            "/ force redisplay, even if same by changing the first entry
            contextArray size > 0 ifTrue:[
                contextArray at:1 put:nil.
            ].
            self setContext:con.

            oldContext isNil ifTrue:[
                idx := oldSelection
            ] ifFalse:[
                idx := contextArray identityIndexOf:oldContext ifAbsent:nil.
            ].
            contextView setSelection:idx.
            idx notNil ifTrue:[
                self showSelection:idx
            ]
        ]
    ]

    "Created: / 10.1.1997 / 21:36:46 / cg"
    "Modified: / 21.5.1998 / 01:47:07 / cg"
!

selectedInterval
    ^ codeView selectedInterval
!

showError:message
    codeView contents:(resources string:message).
    shown ifTrue:[
        exclusive ifTrue:[
            "/ consider this a kludge:
            "/ if exclusive, cannot use flash, since it suspends
            "/ (but we cannot suspend here ...)
            codeView redrawInverted. self flush.
            OperatingSystem millisecondDelay:200.
            codeView redraw
        ] ifFalse:[
            codeView flash
        ]
    ]

    "Modified: / 18.11.2001 / 00:01:13 / cg"
!

showTerminated
    self showError:'** the process has terminated **'
!

showValue:aValue
    "/ TODO: show value in info field
    "/ Transcript showCR:aValue printString
!

stepping
    ^ stepping
!

unstep
    stepping := false.
    bigStep := false.
    steppedContext := wrapperContext := nil.
    exitAction := nil

    "Modified: 22.10.1996 / 11:59:57 / cg"
!

updateButtonsAndMenuItemsForContext:aContext
    |m|

    m := contextView middleButtonMenu.
    m notNil ifTrue:[
        self updateMenuItems.

        (inspecting or:[AbortOperationRequest isHandledIn:aContext]) ifTrue:[
            abortButton enable.
            m enable:#doAbort.
        ] ifFalse:[
            abortButton disable.
            m disable:#doAbort.
        ].
        exclusive ifTrue:[
            terminateButton disable.
            m disable:#doTerminate.
        ] ifFalse:[
            terminateButton enable.
            m enable:#doTerminate.
        ].
    ].

    mayProceed == false ifTrue:[
        continueButton disable.
        m notNil ifTrue:[m disable:#doContinue].
    ] ifFalse:[
        continueButton enable.
        m notNil ifTrue:[m enable:#doContinue]
    ].

    isStoppedInModalDialog ifTrue:[
        gotoDialogOpenerButton enable.
        gotoDialogOpenerButton beVisible.
    ] ifFalse:[
        gotoDialogOpenerButton beInvisible.
    ].

    (isStoppedInModalDialog not & isStoppedInApplicationAction) ifTrue:[
        gotoApplicationActionMethodButton enable.
        gotoApplicationActionMethodButton beVisible.
    ] ifFalse:[
        gotoApplicationActionMethodButton beInvisible.
    ].

    "Created: / 06-07-2011 / 12:24:53 / cg"
!

updateContext
    |oldContext idx|

    inspectedProcess state == #dead ifTrue:[
        self showTerminated.
        ^ self
    ].

    oldContext := selectedContext.
    [
        (self setContextSkippingInterruptContexts:inspectedProcess suspendedContext) ifTrue:[
            oldContext notNil ifTrue:[
                contextArray notNil ifTrue:[
                    idx := contextArray identityIndexOf:oldContext.
                    idx ~~ 0 ifTrue:[
                        self showSelection:idx
                    ] ifFalse:[
                        codeView contents:('** context returned **')
                    ]
                ]
            ]
        ].
    ] valueUninterruptably.

    "Modified: 20.10.1996 / 18:11:24 / cg"
!

withNodeValueAtInterval:interval do:aBlock
    "helper for flyByHelp and explan-selection"

    |node definingNode nm nmBold nameSymbol
     varIdx parentNode receiver con receiversNonMetaClass|

    "/ interval printCR.
    Error
        handle:[:ex | ]
        do:[
            [
                node := self findNodeForInterval:interval
            ] valueWithWatchDog:[ ^ self ] afterMilliseconds:50.
        ].

    node isNil ifTrue:[ ^ self ].
    node isVariable ifFalse:[
        "/ Transcript showCR:node.
        ^ self
    ].

    nm := node name.
    nmBold := nm allBold.
    actualContext isNil ifTrue:[^ self ].
    actualContext methodHome isNil ifTrue:[^ self ].
    receiver := actualContext methodHome receiver.

    (nm = 'self') ifTrue:[
        aBlock value:receiver value:'receiver' allBold.
        ^ self
    ].
    (nm = 'super') ifTrue:[
        aBlock value:receiver value:'receiver' allBold.
        ^ self
    ].
    (nm = 'thisContext') ifTrue:[
        aBlock value:actualContext value:'context' allBold.
        ^ self
    ].

    definingNode := node whoDefines:nm.
    definingNode isNil ifTrue:[
        (receiver class allInstVarNames includes:nm) ifTrue:[
"/aBlock value:'xIII' value:'instVar'.
            receiver class isMetaclass ifTrue:[
                aBlock value:(receiver instVarNamed:nm) value:'classInstVar ',nmBold.
            ] ifFalse:[
                aBlock value:(receiver instVarNamed:nm) value:'instVar ',nmBold.
            ].
            ^ self
        ].

        receiversNonMetaClass := receiver class theNonMetaclass.
        (receiversNonMetaClass privateClasses contains:[:cls | cls nameWithoutPrefix = nm]) ifTrue:[
            aBlock value:'' value:'private class ',nmBold.
            ^ self
        ].
        (receiversNonMetaClass classVarNames includes:nm) ifTrue:[
            aBlock value:((currentMethod mclass ? receiversNonMetaClass) theNonMetaclass classVarAt:nm) value:'classVar ',nmBold.
            ^ self
        ].
        receiversNonMetaClass sharedPoolNames do:[:eachPoolName |
            |pool|

            pool := Smalltalk at:eachPoolName.
            pool isNil ifTrue:[ pool := receiversNonMetaClass topNameSpace at:eachPoolName].
            (pool classVarNames includes:nm) ifTrue:[
                aBlock value:(pool classVarAt:nm) value:'poolVar ',nm allBold,' in ',eachPoolName allBold,' '.
                ^ self
            ].
        ].
        nameSymbol := nm asSymbolIfInterned.
        nameSymbol notNil ifTrue:[
            (Smalltalk includesKey:nameSymbol) ifTrue:[
                (Smalltalk at:nameSymbol) isClass ifTrue:[
                    aBlock value:'class: ',nmBold value:nil.
                ] ifFalse:[
                    aBlock value:(Smalltalk at:nameSymbol) value:'global ',nmBold.
                ].
                ^ self
            ].
        ].
        aBlock value:'' value:'unknown'.
        ^ self
    ].
"/definingNode printCR.

    definingNode isMethod ifTrue:[
        varIdx := definingNode arguments findFirst:[:arg | arg name = nm].
        varIdx ~~ 0 ifTrue:[
            Error
                handle:[:ex | ]
                do:[ aBlock value:(actualContext methodHome argAt:varIdx) value:'methodArg ',nmBold ].
            ^ self
        ].
        varIdx := definingNode temporaries findFirst:[:var | var name = nm].
        varIdx ~~ 0 ifTrue:[
            actualContext methodHome numVars >= varIdx ifTrue:[
                Error
                    handle:[:ex | ]
                    do:[ aBlock value:(actualContext methodHome varAt:varIdx) value:'methodVar ',nmBold ].
                ^ self
            ]
        ].
    ].

    definingNode isBlock ifTrue:[
        varIdx := definingNode arguments findFirst:[:arg | arg name = nm].
        (definingNode arguments contains:[:arg | arg name = nm]) ifTrue:[
            varIdx ~~ 0 ifTrue:[
                "/ am I in this block ?
                (actualContext lineNumber notNil
                and:[ definingNode lastLineNumber notNil
                and:[ (actualContext lineNumber
                            between:definingNode firstLineNumber
                            and:definingNode lastLineNumber)
                and:[ varIdx <= actualContext numArgs ] ]])
                ifTrue:[
                    aBlock value:(actualContext argAt:varIdx) value:'blockArg ',nmBold .
                    ^ self
                ].
                aBlock value:nmBold , ' is not in scope of selected context' value:nil.
                ^ self
            ]
        ].
    ].

    parentNode := definingNode parent.

    [parentNode notNil] whileTrue:[
        "/'isMethod ' print. parentNode isMethod printCR.
        parentNode isMethod ifTrue:[
            varIdx := parentNode temporaries findFirst:[:var | var name = nm].
            varIdx ~~ 0 ifTrue:[
                actualContext methodHome numVars >= varIdx ifTrue:[
                    Error
                        handle:[:ex | ]
                        do:[ aBlock value:(actualContext methodHome varAt:varIdx) value:'methodVar ',nmBold ].
                    ^ self
                ]
            ].
        ].
        "/'isBlock ' print. parentNode isBlock printCR.
        parentNode isBlock ifTrue:[
            "/ we don't have any information on the inlineability
            "/ of this block here (RBParser does not know what
            "/ the compiler does).
            "/ therefore, it is questionable if we can use the
            "/ context's home context here.
            "/ am I in this block ?
            con := actualContext.
            [con notNil
            and:[ parentNode lastLineNumber notNil
            and:[ con lineNumber notNil
            and:[ con lineNumber
                    between:parentNode firstLineNumber
                    and:parentNode lastLineNumber ]]]] whileTrue:[
                con := con sender.
            ].
            con notNil ifTrue:[
                varIdx := parentNode arguments findFirst:[:arg | arg name = nm].
                varIdx ~~ 0 ifTrue:[
                    Error
                        handle:[:ex | ]
                        do:[ aBlock value:(con argAt:varIdx) value:'blockArg ',nmBold ].
                    ^ self
                ].
                varIdx := parentNode body temporaries findFirst:[:var | var name = nm].
                varIdx ~~ 0 ifTrue:[
                    Error
                        handle:[:ex | ]
                        do:[ aBlock value:(con varAt:varIdx) value:'blockVar ',nmBold ].
                    ^ self
                ].
            ].
        ].
        parentNode := parentNode parent.
    ].
    aBlock value:nmBold , ' is not in scope of selected context' value:nil.

    "Modified: / 18-01-2011 / 17:57:34 / cg"
! !

!DebugView methodsFor:'private queries'!

canBrowseClassHierarchy
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil and:[m isEnabled:#browseClassHierarchy]
!

canBrowseFullClassProtocol
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil and:[m isEnabled:#browseFullClassProtocol]
!

canBrowseImplementingClass
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil and:[m isEnabled:#browseImplementingClass]
!

canBrowseProcessesApplication
    |p|

    p := inspectedProcess ? Processor activeProcess.
    p isNil ifTrue:[^ false].
    ^ p isGUIProcess and:[self processesApplication notNil ].
!

canBrowseReceiversClass
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil 
        and:[
            (m isEnabled:#browseReceiversClass)
            or:[ m isEnabled:#browseImplementingClass ]
        ]

    "Modified: / 25-11-2016 / 13:25:55 / cg"
!

canCloseAllDebuggers
    self class allInstancesDo:[:debugger |
        debugger ~~ self ifTrue:[
            debugger busy ifTrue:[^ true].
        ]
    ].
    ^ false

    "Created: / 23-03-2012 / 12:40:18 / cg"
!

canDefineMethod
    ^ defineButton isVisible
!

canInspectWidgetHierarchy
    |rcvr|

    ^ (selectedContext notNil
        and:[(rcvr := selectedContext receiver) isProtoObject not 
        and:[rcvr isView or:[rcvr isKindOf: ApplicationModel]]])
    or:[
        self canBrowseProcessesApplication
    ]

    "Modified: / 25-11-2016 / 13:17:20 / cg"
!

canRestart
    ^ restartButton isEnabled

    "Modified: / 17.11.2001 / 19:59:49 / cg"
!

canReturn
    ^ returnButton isEnabled

    "Modified: / 17.11.2001 / 19:59:18 / cg"
!

canSendEmail
    ^ SendMailTool notNil

    "Created: / 15-10-2010 / 11:51:23 / cg"
!

canShowMore
    ^ canShowMore
!

hasBlockContextSelected
    ^ contextView hasSelection
    and:[ self selectedContext isBlockContext ]
!

hasContextSelected
    ^ contextView hasSelection

    "Created: / 17.11.2001 / 19:57:03 / cg"
!

hasHaltsToIgnore
    ^ IgnoredHalts notEmptyOrNil
!

isAborting
    ^ exitAction == #abort
!

isStoppedAtBreakPointWithParameter
    ^ isStoppedAtBreakPointWithParameter

    "Created: / 06-03-2012 / 12:16:56 / cg"
!

isStoppedAtHaltOrBreakPoint
    ^ isStoppedAtHaltOrBreakPoint
!

isStoppedAtHaltOrBreakPointOrSelectedContextIsWrapped
    ^ isStoppedAtHaltOrBreakPoint or:[self selectedContextIsWrapped]
!

selectedContextIsWrapped
    |con mthd|

    (con := self selectedContext) notNil ifTrue:[
        mthd := con method.
        ^ mthd notNil and:[mthd isWrapped]
    ].
    ^ false.

    "Modified: / 19-07-2012 / 11:36:28 / cg"
!

setOfHiddenCallingSelectors
    ^ setOfHiddenCallingSelectors ? #( #'doIt' #'doIt:' )
!

setOfHiddenCallingSelectors:aCollectionOfSymbols
    setOfHiddenCallingSelectors := aCollectionOfSymbols
! !

!DebugView methodsFor:'private-breakpoints'!

addIgnoredHaltForCount:countOrNil
        orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orThisReceiverClass:forThisReceiverClass orCurrentProcess:forCurrentProcess
        orIfCalledFromMethod:ifCalledForMethodOrNil
        forAll:aBoolean

    |haltingContext haltingMethod lineNrOfHalt receiverClassOrNil processOrNil|

    aBoolean ifTrue:[
        haltingMethod := #all
    ] ifFalse:[
        haltingContext := self findHaltingContext.
        haltingContext isNil ifTrue:[
            Transcript showCR:'no halting context found'.
            ^ self
        ].

        haltingMethod := haltingContext method.
        lineNrOfHalt := haltingContext lineNumber.
        (lineNrOfHalt isNil or:[lineNrOfHalt <= 0]) ifTrue:[
            Transcript showCR:'no halt lineNr found'.
            ^ self
        ].
        forThisReceiverClass ifTrue:[
            receiverClassOrNil := haltingContext receiver class
        ].
        forCurrentProcess ifTrue:[
            processOrNil := Processor activeProcess
        ].
    ].

    self class
        ignoreHaltIn:haltingMethod at:lineNrOfHalt
        forCount:countOrNil orTimeDuration:dTOrNil orUntilShiftKey:untilShiftKey
        orReceiverClass:receiverClassOrNil orProcess:processOrNil
        orIfCalledFromMethod:ifCalledForMethodOrNil

    "Created: / 27-01-2012 / 11:31:12 / cg"
!

canAddBreakpoint
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil and:[m isEnabled:#addBreakpoint]
!

canRemoveBreakpoint
    |m|

    m := contextView middleButtonMenu.
    ^ m notNil and:[m isEnabled:#removeBreakpoint]
!

findHaltingContext
    |haltSelectors|

    haltSelectors := self haltSelectors.

    contextArray keysAndValuesDo:[:idx :con |
        |sel con2 sel2 method|

        sel := con selector.
        (haltSelectors includes:sel) ifTrue:[
            (method := con method) notNil ifTrue:[
                method mclass == Object ifTrue:[
                    con2 := contextArray at:idx+1.
                    sel2 := con2 selector.
                    (haltSelectors includes:sel2) ifTrue:[
                        con2 method mclass == Object ifTrue:[
                            ^ contextArray at:idx+2.
                        ]
                    ].
                    ^ contextArray at:idx+1
                ].
                method mclass == Breakpoint ifTrue:[
(contextArray at:idx+1) infoPrintCR.
                    ^ contextArray at:idx+1
                ].
            ].
        ].
        con method isWrapped ifTrue:[
            ^ con
        ].
    ].
    ^ nil

    "Modified: / 27-01-2012 / 11:06:02 / cg"
!

ignoreBreakpoints
    ^ ignoreBreakpoints

    "Created: / 17.11.2001 / 18:20:16 / cg"
! !

!DebugView methodsFor:'private-cache handling'!

cacheMyself
    "remember myself for next debug session"

    "caching the last debugger will make the next debugger appear
     faster, since no resources have to be allocated in the display.
     We have to be careful to release all refs to the debuggee, though.
     Otherwise, the GC will not be able to release it."

    windowGroup notNil ifTrue:[
        windowGroup setProcess:nil.
    ].

    self releaseDebuggee.

    cachable ~~ true ifTrue:[^ self].

    "/
    "/ only cache if I am on the Display (i.e. the default screen)
    "/
    device == Display ifTrue:[
        exclusive ifTrue:[
            CachedExclusive := self
        ] ifFalse:[
            CachedDebugger := self
        ].
    ].

    ObjectMemory stepInterruptHandler == self ifTrue:[
        ObjectMemory stepInterruptHandler:nil
    ].

    "Modified: 10.7.1997 / 15:50:46 / stefan"
    "Modified: 31.7.1997 / 21:20:14 / cg"
!

isCached
    "tell whether we are a cached debugger"

    CachedExclusive == self ifTrue:[
        ^ true.
    ].
    CachedDebugger == self ifTrue:[
        ^ true.
    ].

    ^ false.

    "Created: / 10-07-1997 / 15:22:43 / stefan"
    "Modified (comment): / 27-07-2013 / 15:38:47 / cg"
!

uncacheMyself
    "do not remember myself any longer for next debug session"

    cachable := false.

    CachedExclusive == self ifTrue:[
        CachedExclusive := nil.
    ].
    CachedDebugger == self ifTrue:[
        CachedDebugger := nil.
    ].
    OpenDebuggers notNil ifTrue:[
        OpenDebuggers remove:self ifAbsent:[].
    ].

    "Modified: 31.7.1997 / 21:20:11 / cg"
! !

!DebugView methodsFor:'private-code view'!

codeAspect
    ^ SyntaxHighlighter codeAspectMethod

    "Created: / 27-07-2011 / 13:07:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 22:20:27 / cg"
! !

!DebugView methodsFor:'private-context handling'!

contextListEntryFor:aContext
    ^ Error
        handle:[:ex | '???' ]
        do:[
            |s|

            aContext selector == #doIt ifTrue:[
                aContext receiver isNil ifTrue:[
                    s := 'doIt' allBold
                ]
            ].

            s := Text streamContents:[:s | aContext printOn:s ].
            RememberedCallChain notNil ifTrue:[
                (RememberedCallChain includesIdentical:aContext) ifTrue:[
                    s := s withColor:#red.
                ].
            ].
            s
        ].

    "Created: / 21-05-2007 / 13:30:24 / cg"
!

is:aHomeContext inCallingChainOf:aContext
    |con|

    con := aContext.
    [con notNil and:[con ~~ aHomeContext]] whileTrue:[
        con := con sender
    ].
    ^ con notNil

    "Created: / 10-06-2012 / 18:46:29 / cg"
!

isEnteredDueToBreakpointOrHalt
    "see if we came here due to a step interrupt"

    |c cReceiver|

    "/ look for a breakpoint-wrapper's context
    c := thisContext findNextContextWithSelector:#'raiseRequestWith:errorString:in:' or:nil or:nil.
    c isNil ifTrue:[
        ^ true.
    ].
    cReceiver := c receiver.
    ^ cReceiver == BreakPointInterrupt

    "Modified: / 01-08-2013 / 23:34:01 / cg"
!

isHaltToBeIgnored
    "see if the current halt (if any) is in the ignore-list"

    |c cReceiver sender haltingMethod lineNrInHaltingMethod breakpointParameter
     sReceiver|

    "/ should a halt be ignored ?
    IgnoredHalts isNil ifTrue:[^ false].

    "/ look for a method breakpoint-wrapper's context
    c := thisContext findNextContextWithSelector:#doRaise or:nil or:nil.
    c notNil ifTrue:[
        ((cReceiver := c receiver) isKindOf:NoHandlerError) ifTrue:[
            c := c sender findNextContextWithSelector:#doRaise or:nil or:nil.
            cReceiver := c receiver.
        ].
        (cReceiver isKindOf:BreakPointInterrupt) ifFalse:[
            c := nil
        ] ifTrue:[
            [
                sender := c sender.
                ((sReceiver := sender receiver) isKindOf:BreakPointInterrupt)
                or:[ sReceiver == BreakPointInterrupt ]
            ] whileTrue:[
                c := sender
            ].
            [ (sender := c sender) isBlockContext ] whileTrue:[
                c := sender
            ].
            sender := nil. "/ avoid keeping a reference to this context
        ].
    ].
    "/ Transcript showCR:c.
    c isNil ifTrue:[
        "/ look for halts or explicit breakpoints
        c := thisContext findNextContextWithSelector:#halt or:#halt: or:nil.
        c isNil ifTrue:[
            c := thisContext findNextContextWithSelector:#breakPoint: or:#breakPoint:info: or:nil.
            c isNil ifTrue:[
               ^ false
            ].
            breakpointParameter := c argAt:1.
            (self class
                    isBreakpointToBeIgnoredForParameter:breakpointParameter
                    context:(c sender)
                    modifyEntryCount:true
            ) ifTrue:[
                ^ true.
            ].
        ].
    ].

    c := c sender.
    "/ a code-breakpoint ?
    (c receiver isKindOf:Breakpoint) ifTrue:[
        c := c sender.
    ].
    haltingMethod := c method.

    haltingMethod isWrapped ifTrue:[
        lineNrInHaltingMethod := 1.
    ] ifFalse:[
        lineNrInHaltingMethod := c lineNumber.
        "/ Transcript showCR:c.
    ].

    ^ self class
        isHaltToBeIgnoredIn:haltingMethod
        atLineNr:lineNrInHaltingMethod
        context:c
        modifyEntryCount:true.

    "Created: / 22-10-2010 / 12:09:53 / cg"
    "Modified: / 06-03-2012 / 12:54:09 / cg"
!

setContext:aContext
    "show calling chain from aContext in the walk-back listview"

    ^ self setContext:aContext releaseInspectors:true

    "Modified: 27.6.1996 / 17:21:59 / cg"
!

setContext:aContext releaseInspectors:releaseInspectors
    "show calling chain from aContext in the walk-back listview.
     Most complications here arise from filtering less-interesting contexts
     if not in verbose-context mode or when hiding implementation contexts.
     There is a lot of heuristic magic here, to make the debugger as useful
     as possible for the user (but not particularly for the debugger-developer)"

    |con sel text method caller caller2 called called2 m count c cc sndr
     suspendContext calledBySuspendContext nm h calledContext show2
     alreadyInApplicationCode verboseBacktrace|

"/    (contextArray size > 0 and:[aContext == (contextArray at:1)]) ifTrue:[
"/        "no change"
"/        ^ false
"/    ].

    isStoppedAtHaltOrBreakPoint := isStoppedAtBreakPointWithParameter := false.
    isStoppedInModalDialog := isStoppedInApplicationAction := alreadyInApplicationCode := false.
    isStoppedAtStatementBreakpoint := false.
    firstContext := aContext.
    verboseBacktrace := self verboseBacktraceHolder value.

    m := contextView middleButtonMenu.
    m notNil ifTrue:[
        m disable:#showMore.
    ].
    canShowMore := false.

    aContext isNil ifTrue:[
        text := Array with:'** no context **'.
        contextArray := nil.
    ] ifFalse:[
        text := OrderedCollection new:nChainShown.
        contextArray := OrderedCollection new:nChainShown.

        con := aContext.
        calledContext := nil.

        DebuggingContextWalk == true ifTrue:[
            '======================================' print. con printCR.
        ].
        alreadyInApplicationCode :=
                con receiver isProtoObject not     "/ careful to not force futures/lazy values
                and:[con receiver class includesBehavior:ApplicationModel].     "do not use #isKindOf: - ProtoObject compat"

        verboseBacktrace ~~ true ifTrue:[
            "/ with dense backtrace, hide the ProcessorScheduler
            "/ contexts at the top; look for a Process>>suspend*
            "/ context within the first 10 contexts

            suspendContext := nil.
            c := con.
            1 to:10 do:[:i |
                |selector|

                c notNil ifTrue:[
                    selector := c selector.
                    selector notNil ifTrue:[
                        (selector isSymbol and:[(selector startsWith:'suspend') and:[c receiver isMemberOf:Process]]) ifTrue:[
                            suspendContext := c.
                            calledBySuspendContext := cc.
                        ].
                    ].
                    cc := c.
                    c := c sender.
                ]
            ].
            suspendContext notNil ifTrue:[
                con := suspendContext.
                calledContext := calledBySuspendContext.
                suspendContext := nil
            ].
        ].
        "/ Transcript show:'1 '; showCR:con.
        con notNil ifTrue:[
            "/ hide the halt implementation
            sel := con selector.
            (self haltSelectors includes:sel) ifTrue:[
                (method := con method) notNil ifTrue:[
                    method mclass == Object ifTrue:[
                        (sel isSymbol and:[ sel startsWith:'breakPoint:']) ifTrue:[
                            isStoppedAtBreakPointWithParameter := true.
                            breakPointParameter := con argAt:1.
                        ].
                        isStoppedAtHaltOrBreakPoint := true.
                        verboseBacktrace ~~ true ifTrue:[
                            calledContext := con.
                            con := con sender.
                        ]
                    ] ifFalse:[
                        method mclass == Breakpoint ifTrue:[
                            isStoppedAtHaltOrBreakPoint := true.
                            isStoppedAtStatementBreakpoint := true.
                            verboseBacktrace ~~ true ifTrue:[
                                calledContext := con.
                                con := con sender.
                            ].
                            "/ Transcript show:'2 '; showCR:con.
                        ].
                    ].
                ].
            ].
        ].

        (verboseBacktrace not or:[ hideSupportCode]) ifTrue:[
            [
                con notNil
                and:[ con isBlockContext not
                and:[ con method notNil
                and:[ (con method shouldBeSkippedInDebuggersWalkBack)
                and:[ (self haltSelectors includes: con selector) not]]]]
            ] whileTrue:[
                "/ Transcript show:'xx '; showCR:con.
                calledContext := con.
                con := con sender
            ].
        ].

        "
         get them all, by walking along the caller chain.
         depending on the settings, skip some intermediate contexts
         (such as collection enumeration implementations), which are usually not
         of interest when debugging an application.
         On the fly, gather some additional information
         such as: are we at a halt/breakpoint, are we in a modal dialog opened,
         are we coming from an application model's action etc.
        "
        count := 0.
        [con notNil and:[count <= nChainShown]] whileTrue:[
            "/ remember any halt/breakpoint or openModal on the fly
            DebuggingContextWalk == true ifTrue:[ '---' print. con printCR ].

            sel := con selector.
            (self haltSelectors includes:sel) ifTrue:[
                (method := con method) notNil ifTrue:[
                    method mclass == Object ifTrue:[
                        (sel isSymbol and:[sel startsWith:'breakPoint:']) ifTrue:[
                            isStoppedAtBreakPointWithParameter := true.
                            breakPointParameter := con argAt:1.
                        ].
                        isStoppedAtHaltOrBreakPoint := true.
                    ] ifFalse:[
                        method mclass == Breakpoint ifTrue:[
                            isStoppedAtHaltOrBreakPoint := true.
                        ].
                    ]
                ]
            ] ifFalse:[
                ((sel == #openModal) or:[sel == #openModal:]) ifTrue:[
                    isStoppedInModalDialog := true.
                ] ifFalse:[
                    alreadyInApplicationCode ifFalse:[
                        (con receiver isProtoObject not  "/ careful to not force futures/lazy values
                         and:[con receiver isKindOf:ApplicationModel]) ifTrue:[
                            isStoppedInApplicationAction := true.
                        ]
                    ]
                ]
            ].

            [
                |show1|

                show1 := self showingContext1:con calling:calledContext.
                DebuggingDebugger3 == true ifTrue:[
                    'showingContext1: (' print. con print. ') --> ' print. show1 printCR.
                ].
                show1
            ] whileFalse:[
                calledContext := con.
                con := con sender.
            ].

            show2 := self showingContext2:con nesting:count.
            DebuggingDebugger3 == true ifTrue:[
                'showingContext2: (' print. con print. ') --> ' print. show2 printCR.
            ].

            show2 ifTrue:[
                contextArray add:con.

                (MoreDebuggingDetail == true) ifTrue:[
                    nm := (((ObjectMemory addressOf:con) printStringRadix:16) , ' ' , con printString).
                ] ifFalse:[
                    nm := self contextListEntryFor:con.
                ].
                text add:nm.
                count := count + 1.
            ].

            "/ with hidden support code, skip over internals of exceptions
            hideSupportCode == true ifTrue:[
                "/ Transcript showCR:'x'.
                (con isBlockContext
                and:[ (h := con home) notNil
                and:[ (self is:h inCallingChainOf:con) ]]) ifTrue:[
                    |blocksReceiver|
                    blocksReceiver := con receiver.
                    c := con sender.
                    [
                        c notNil
                        and:[
                            sndr := c sender.
                            (sndr ~= h)
                            and:[
                                blocksReceiver isCollection         "/ skip collection implementations
                                or:[ ( #( #'handle:do:'         "/ skip exception implementations
                                          #'handleDo:'
                                          #'answer:do:'
                                          #'ensure:' ) includes: c selector )
                                or:[ #'perform:*'               "/ skip perform implementations
                                         match: c selector ]]
                            ]
                        ]
                    ] whileTrue:[
                        c := sndr
                    ].
                    c notNil ifTrue:[
                        con := c "sender".
                    ].
                ].
            ].

            "/
            "/ kludge: if it's a wrapped method, then hide the wrap-call
            "/
            method := con method.
            method notNil ifTrue:[
                called := con.
                caller := con sender.
                (caller notNil and:[caller receiver == method]) ifTrue:[
                    called2 := caller.
                    caller2 := caller sender.
                    caller2 notNil ifTrue:[
                        (caller2 method isWrapped
                        and:[ caller2 method originalMethod == method ]) ifTrue:[
                            calledContext := called2.
                            con := caller2
                        ].
                    ].

                ].
                caller := caller2 := nil
            ].

            "/ with dense backtrace, skip the doIt method's context
            "/ (its dummy anyway) and fake that context's name

            verboseBacktrace ~~ true ifTrue:[
                (con isBlockContext
                 and:[(h := con home) == con sender
                 and:[h notNil
                 and:[(self setOfHiddenCallingSelectors includes:h selector)
                 and:[h method who isNil]]]]) ifTrue:[
                    calledContext := con.
                    con := con sender.
                    text removeLast.

                    text add:(self contextListEntryFor:con methodHome).
                ].
                h := nil.  "/ never keep refs to contexts unless you really need them ...
            ].

            "/ with dense backtrace, don't show contexts below the doIt
            ( verboseBacktrace ~~ true
            and:[ (self setOfHiddenCallingSelectors includes:con selector) ]) ifTrue:[
                con := nil.
            ] ifFalse:[
                calledContext := con.
                con := con sender
            ].
        ].

        "
         did we reach the end ?
        "
        (con isNil or:[con sender isNil]) ifTrue:[

            "/ the very last one is the startup context
            "/ (in main) - it has nil as receiver and nil as selector

            (contextArray notEmpty
            and:[contextArray last selector isNil]) ifTrue:[
                contextArray removeLast.
                text removeLast
            ].

            verboseBacktrace ~~ true ifTrue:[
                "/ in dense mode, remove process startup contexts (if any)

                (contextArray size > 0
                and:[(con := contextArray last) methodClass == Process]) ifTrue:[
                    con selector == #start ifTrue:[
                        contextArray removeLast.
                        text removeLast.

                        [contextArray size > 0
                         and:[contextArray last methodHome == con]] whileTrue:[
                            contextArray removeLast.
                            text removeLast.
                        ]
                    ]
                ]
            ]
        ] ifFalse:[
            m notNil ifTrue:[
                m enable:#showMore.
            ].
            canShowMore := true.
            text add:(resources string:'*** more walkback follows - click here to see them ***')
        ].
    ].

    contextView setList:text.

    releaseInspectors ifTrue:[
        receiverInspector release.
        contextInspector release.
    ].

    m notNil ifTrue:[
        m disableAll:#(addBreakpoint removeBreakpoint browseImplementors browseSenders browseReceiversClass).
    ].
    self updateMenuItems.
    ^ true

    "Created: / 14-12-1995 / 19:10:31 / cg"
    "Modified: / 27-07-2012 / 15:10:53 / cg"
!

setContextSkippingInterruptContexts:aContext
    "show calling chain from aContext in the walk-back listview.
     Ignore any non-interesting interrupt-context."

    |con|

    con := aContext.
    self verboseBacktraceHolder value ifFalse:[
        (con notNil and:[con selector == #threadSwitch:]) ifTrue:[
            con := con sender.
            (con notNil and:[con selector == #timerInterrupt]) ifTrue:[
                con := con sender.
            ].
        ].
    ].
    ^ self setContext:con releaseInspectors:true

    "Created: / 20.10.1996 / 18:10:21 / cg"
    "Modified: / 17.1.1998 / 12:43:19 / cg"
!

showingContext1:aContext calling:calledContext
    "return false, if this (top) context is to be skipped.
     Here, we hide some well known methods, which are usually not too interesting;
     the set of methods which are suppressed is my (claus's) own choice."

    |recIsException sel rec senderRec mthd mthdClass calledSel calledRec|

    self verboseBacktraceHolder value ifTrue:[ ^true ].
    aContext isNil ifTrue:[ ^true ].

    sel := aContext selector.
    rec := aContext receiver.
    mthd := aContext method.
    mthd notNil ifTrue:[ mthdClass := mthd mclass ].

    "/ to avoid firing/waiting the lazy or future
    recIsException := (rec isProtoObject not) and:[rec isException].
    aContext sender notNil ifTrue:[
        senderRec := aContext sender receiver
    ].

    DebuggingDebugger3 == true ifTrue:[
        'showingContext1: (' print. aContext print.
        ') calling: (' print. calledContext print.
        ')' printCR.
    ].

    (#(doCallHandler: doRaise
    ) includes:sel)
        ifTrue:[
            recIsException ifTrue:[ ^ false].
        ].

    (#(raise raiseRequest
    ) includes:sel)
        ifTrue:[
            recIsException ifTrue:[
                (senderRec isProtoObject not
                and:[ senderRec isExceptionCreator]) ifTrue:[^ false].
            ].
        ].

    (#(doWhile:
    ) includes:sel)
        ifTrue:[
            rec isBlock ifTrue:[
                true "aContext sender isBlockContext" ifTrue:[^ false].
            ].
        ].

    calledContext notNil ifTrue:[
        calledSel := calledContext selector.
        calledRec := calledContext receiver.

        calledRec isBlock ifTrue:[
            (calledSel == #ensure:) ifTrue:[^ false].
            (calledSel == #ifCurtailed:) ifTrue:[^ false].
        ].
        (calledSel == #handle:do:) ifTrue:[^ false].
        (calledSel == #answer:do:) ifTrue:[^ false].

"/        calledRec isProtoObject ifFalse:[
"/            ((calledSel == #doWhile:)
"/            and:[calledRec isBlock])
"/                ifTrue:[^ false].
"/
"/            ((#(ensure: ifCurtailed: valueNowOrOnUnwindDo: valueOnUnwindDo:
"/                ) includes:calledSel)
"/             and:[calledRec isBlock])
"/                ifTrue:[^ false].
"/
"/            ((calledSel == #handle:do:)
"/             and:[calledRec isExceptionHandler])
"/                ifTrue:[^ false].
"/        ].
    ].

    (#(handleDo:) includes:sel)
        ifTrue:[
            (calledRec isProtoObject not and:[calledRec isExceptionHandler]) ifTrue:[^ false].
        ].
    (#(
        withCursor:do:
        withWaitCursorDo:
        withReadCursorDo:
        withWriteCursorDo:
        withSearchCursorDo:
      ) includes:sel)
        ifTrue:[
            (mthdClass == TopView) ifTrue:[^ false].
            (mthdClass == ApplicationModel) ifTrue:[^ false].
            (mthdClass == WindowGroup) ifTrue:[^ false].
        ].

    (#(
        wait
        waitWithTimeout:
        waitWithTimeoutMs:
      ) includes:sel)
        ifTrue:[
            (mthdClass == Semaphore) ifTrue:[^ false].
            (mthdClass == SemaphoreSet) ifTrue:[^ false].
        ].

    ^ true

    "Created: / 17-11-2001 / 22:24:06 / cg"
    "Modified: / 27-07-2012 / 17:30:18 / cg"
!

showingContext2:aContext nesting:nesting
    "return false, if this (intermediate) context is to be skipped.
     Here, we hide some well known methods, which are usually not too interesting;
     the set of methods which are suppressed is my (claus's) own choice."

    |sel rec mClass
     sender senderReceiver senderSelector senderReceiverClass|

    self verboseBacktraceHolder value ifTrue:[^ true].
    aContext isNil ifTrue:[^ true].

    rec := aContext receiver.
    sel := aContext selector.
    mClass := aContext methodClass.

    sender := aContext sender.
    sender notNil ifTrue:[
        senderSelector := sender selector.
        senderReceiver := sender receiver.
        senderReceiverClass := senderReceiver class.
    ].

    sel == #withCursor:do: ifTrue:[
        (mClass == WindowGroup) ifTrue:[^ false].
        (mClass == TopView) ifTrue:[^ false].
    ].
    (sel == #withExecuteCursorDo:
    or:[sel == #withWaitCursorDo:]) ifTrue:[
        (mClass == DisplaySurface) ifTrue:[^ false].
    ].

    (sel == #do:
    or:[sel == #from:to:do:
    or:[sel == #keysAndValuesDo:
    or:[sel == #doWithIndex:]]]) ifTrue:[
        mClass == Array ifTrue:[^ false].
        mClass == OrderedCollection ifTrue:[^ false].
        mClass == Set ifTrue:[^ false].
        mClass == Dictionary ifTrue:[^ false].
        mClass == Interval ifTrue:[^ false].
    ].
    (sel == #perform:
    or:[sel == #perform:with:
    or:[sel == #perform:with:with:
    or:[sel == #perform:with:with:with:
    or:[sel == #perform:with:with:with:with:
    or:[sel == #perform:withArguments:
    or:[sel == #perform:with:ifNotUnderstood:
    or:[sel == #perform:withArguments:ifNotUnderstood:]]]]]]])
    ifTrue:[
        hideSupportCode == true ifTrue:[
            "/ 'x' printCR.
            mClass == Object ifTrue:[^ false]
        ].
        nesting == 0 ifTrue:[^ true].
        mClass == Array ifTrue:[^ false].
        mClass == OrderedCollection ifTrue:[^ false].
    ].

    sel == #valueWithReceiver:arguments:selector:search:sender: ifTrue:[^ false].

    (mClass == Object) ifTrue:[
        (sel startsWith:'perform:') ifTrue:[^ false]
    ].

    (mClass == Method) ifTrue:[
        (sel startsWith:'valueWithReceiver:') ifTrue:[^ false]
    ].

    (mClass == SmallInteger) ifTrue:[
        (sel == #to:do:) ifTrue:[^ false].
        (sel == #to:by:do:) ifTrue:[^ false].
    ].

    (mClass == Block) ifTrue:[
        sel == #ensure: ifTrue:[^ false].
        sel == #ifCurtailed: ifTrue:[^ false].
        sel == #valueNowOrOnUnwindDo: ifTrue:[^ false].
        sel == #valueOnUnwindDo: ifTrue:[^ false].
        sel == #on:do: ifTrue:[^ false].
        sel == #on:do:ensure: ifTrue:[^ false].
        sel == #on:do:ifCurtailed: ifTrue:[^ false].

        sel == #value ifTrue:[^ false].
        sel == #value: ifTrue:[^ false].
        sel == #value:value: ifTrue:[^ false].
        sel == #value:value:value: ifTrue:[^ false].
        sel == #value:value:value:value: ifTrue:[^ false].
        sel == #value:value:value:value:Value: ifTrue:[^ false].
        sel == #value:value:value:value:value:value: ifTrue:[^ false].
    ].

    aContext isBlockContext ifTrue:[
        |home|
"/        sel == #value ifTrue:[^ false].
"/        sel == #value: ifTrue:[^ false].
"/        sel == #value:value: ifTrue:[^ false].
"/        sel == #value:value:value: ifTrue:[^ false].
"/        sel == #value:value:value:value: ifTrue:[^ false].
"/        sel == #value:value:value:value:Value: ifTrue:[^ false].
"/        sel == #value:value:value:value:value:value: ifTrue:[^ false].

"/        (senderSelector == #answer:do:) ifTrue:[
"/            senderReceiverClass == QuerySignal ifTrue:[
"/                ^ false
"/            ]
"/        ]

        home := aContext home.
        (home notNil 
         and:[home receiver isProtoObject not 
         and:[home receiver isKindOf:Semaphore]]) ifTrue:[
            (home selector == #wait) ifTrue:[^ false].
            (home selector == #waitWithTimeoutMs:) ifTrue:[^ false].
        ].
    ].

    rec isProtoObject ifTrue:[
        ^ true.
    ].
    (rec isExceptionHandler) ifTrue:[
        sel == #handle:do: ifTrue:[^ false].
        sel == #handleDo: ifTrue:[^ false].
        (sel startsWith:#raise) ifTrue:[^ false].
        sel == #answer:do: ifTrue:[^ false].
    ].
    (rec isException) ifTrue:[
        sel == #doRaise ifTrue:[^ false].
        sel == #doCallHandler: ifTrue:[^ false].
        (sel == #raise or:[sel == #raiseRequest]) ifTrue:[
            senderReceiverClass == Signal ifTrue:[^ false].
        ]
    ].
    (mClass == Context) ifTrue:[
        sel == #unwind ifTrue:[^ false].
        sel == #unwind: ifTrue:[^ false].
    ].
    (mClass == ProcessorScheduler) ifTrue:[
        sel == #interruptActive ifTrue:[^ false].
        sel == #threadSwitch: ifTrue:[^ false].
        sel == #suspend: ifTrue:[^ false].
    ].
    mClass == Process ifTrue:[
        sel == #suspendWithState: ifTrue:[^ false].
    ].
    (sel == #break) ifTrue:[
        (mClass == Breakpoint) ifTrue:[^ false].
    ].
    ^ true.

    "Created: / 17-11-2001 / 19:34:20 / cg"
    "Modified: / 27-07-2012 / 17:26:54 / cg"
    "Modified: / 31-01-2017 / 20:21:32 / stefan"
! !

!DebugView methodsFor:'private-control loop'!

controlLoop
    "this is a kludge:
        start a dispatchloop which exits when
        either continue, return or step is pressed
    "

    haveControl := true.
    [
        [haveControl] whileTrue:[
AbortOperationRequest handle:[:ex |
] do:[
            self controlLoopCatchingErrors
]
        ].
    ] ensure:[
        catchBlock := nil.
        haveControl := false
    ].

    "Modified: 9.7.1996 / 18:29:09 / cg"
!

controlLoopCatchingErrors
    "this is the debuggers own private event handling loop;
     errors are caught, to prevent recursive debugger-invocations."

    "setup a self removing catch-block"
    catchBlock := [catchBlock := nil. ^ nil].

    (exclusive or:[windowGroup isNil]) ifTrue:[
        "if we do not have multiple processes or its a system process
         we start another dispatch loop, which exits when
         either continue, return or step is pressed
         or (via the catchBlock) if an error occurs.
         Since our display is an extra exclusive one,
         all processing for normal views stops here ...
        "

        WindowGroup setActiveGroup:windowGroup.
        SignalSet anySignal handle:[:ex |
            |signal|

            signal := ex creator.
            (UserInterruptSignal accepts:signal) ifTrue:[
Transcript showCR:'UserInterruptSignal'.
                self topView raiseDeiconified.
                ex proceed.
            ].

            (UserNotification accepts:signal) ifTrue:[
Transcript showCR:'UserNotification'.
                (signal ~~ ActivityNotificationSignal) ifTrue:[
                    self showError:ex description.
                ].
                ex proceed.
            ].
            (HaltInterrupt accepts:signal) ifTrue:[
Transcript showCR:'HaltInterrupt'.
                Transcript showCR:'Halt/Break in debugger ignored'.
                self topView raiseDeiconified.
                ex proceed.
            ].

            self showError:'*** Error in modal debugger:

>>>> Signal:  ' , signal printString , '
>>>> In:      ' , ex suspendedContext printString , '
>>>> From:    ' , ex suspendedContext sender printString , '
>>>>     :    ' , ex suspendedContext sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender sender sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender sender sender sender sender sender sender sender sender sender sender printString , '
>>>> Message: ' , ex description , '

caught & ignored.'.
            ex return.
        ] do:[
"/            UserNotification handle:[:ex |
"/                (ex signal == ActivityNotificationSignal) ifTrue:[
"/                    ex proceed
"/                ].
"/                self showError:ex description.
"/                ex proceed.
"/            ] do:[
                device isNil ifTrue:[^ self].
                
                device
                    dispatchModalWhile:[
                        Processor activeProcess state:#debug.
                        haveControl].
"/            ]
        ].
        WindowGroup setActiveGroup:nil.
    ] ifFalse:[
        "we do have multiple processes -
         simply enter the DebugViews-Windowgroup event loop.
         effectively suspending event processing for the currently
         active group.
        "
        SignalSet anySignal handle:[:ex |
            |answer signal eMsg|

            signal := ex creator.

            DebuggingDebugger ~~ true ifTrue:[
                (signal == ActivityNotification) ifTrue:[
                    ex proceed
                ].
                "/
                "/ ignore exceptions which say they explicitly have to be ignored
                "/
                ex catchInDebugger ifTrue:[
                    'DebugView [info]: ',signal printString,'-signal in debugger caught for close' infoPrintCR.
                    self halt. "/ self destroy.
                    ex reject
                ].

                "/
                "/ ignore recursive breakpoints
                "/
                (signal isControlInterrupt) ifTrue:[
                    ignoreBreakpoints == true ifTrue:[
                        'DebugView [info]: halt/break in debugger ignored 1' infoPrintCR.
                        ('DebugView [info]: ',ex suspendedContext printString) infoPrintCR.
                        self topView raiseDeiconified.
                        ex proceed
                    ].
                ].
                (signal == TerminateProcessRequest) ifTrue:[
                    "/ mhm - someone wants to shoot me down while debugging ...
                    answer := Dialog
                                choose:('Process termination signal arrived while debugging\\close debugger ?') withCRs
                                labels:#( 'Ignore' 'Close & terminate' )
                                values:#( #proceed #close )
                                default:#close.
                    answer == #close ifTrue:[
                        self destroy.
                        ex reject
                    ].
                    ex return.
                ].
                signal == RecursiveExceptionError ifTrue:[
                    (ex exception creator == BreakPointInterrupt)
                    ifTrue:[
                        'DebugView [info]: recursive breakpoint in debugger ignored' infoPrintCR.
                        ex proceed.
                    ].

                    self showError:'*** Recursive error in debugger:

>>>> Signal:  ' , ex creator printString , '
>>>>          ' , ex parameter creator printString , '
>>>> In:      ' , ex suspendedContext printString , '
>>>> From:    ' , ex suspendedContext sender printString , '
>>>>     :    ' , ex suspendedContext sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender printString , '
>>>>     :    ' , ex suspendedContext sender sender sender sender printString , '
>>>> Message: ' , ex description , '

caught & ignored.'.
                    ex return
                ].
            ].

            self topView raiseDeiconified.

            eMsg := ex description.
            (signal isControlInterrupt) ifTrue:[
                eMsg := eMsg , Character cr asString , 'in ' , ex suspendedContext printString
            ].
            Dialog aboutToOpenBoxNotificationSignal
                handle:[:ex | ex proceed ]
                do:[
                    answer := Dialog
                        choose:(ex creator class theNonMetaclass name,' in debugger:\' withCRs , eMsg , '\\debug again ?' withCRs)
                        labels:#( 'Proceed' 'Cancel' 'Debug' )
                        values:#( #proceed #cancel #debug )
                        default:#cancel.
                ].
            answer == #debug ifTrue:[
                'DebugView [info]: caught exception - debugging' infoPrintCR.
                Debugger
                    enterUnconditional:(ex suspendedContext)
                    withMessage:(ex creator class theNonMetaclass name,' in debugger: ' , eMsg)
                    mayProceed:true.
                ex proceed.
            ].
            answer == #proceed ifTrue:[
                'DebugView [info]: ignored exception - proceeding' infoPrintCR.
                ex proceed.
            ].
            'DebugView [info]: caught exception - returning' infoPrintCR.
            ex return.
        ] do:[
            "/ make certain that sub-debuggers, inspectors etc.
            "/ come up on my device.
            Screen currentScreenQuerySignal answer:device
            do:[
                Dialog aboutToOpenBoxNotificationSignal
                    handle:[:ex | ex proceed ]
                    do:[
                        windowGroup
                            eventLoopWhile:[Processor activeProcess state:#debug.
                                              true]
                            onLeave:[]
                    ]
            ]
        ].
    ].
    catchBlock := nil.

    "Created: / 24-11-1995 / 20:33:45 / cg"
    "Modified: / 26-09-2012 / 15:03:39 / cg"
! !

!DebugView methodsFor:'queries'!

canDefineForCallee:callee
    "again, pure heuristics here"

    |mthd app heuristic selector sender|

    callee isNil ifTrue:[^ false].

    classToDefineIn := selectorToDefine := nil.    "/ sorry - left as info to define action

    "/ clicked on an unimplemented method ?
    sender := callee sender.
    sender isNil ifTrue:[^ false].
    
    mthd := sender method.
    mthd isNil ifTrue:[
        sender isBlockContext ifFalse:[
            "/ an unimplemented method
            selector := sender selector.
            (sender receiver class canUnderstand:selector) ifFalse:[
                classToDefineIn := sender receiver class.
                selectorToDefine := selector.
                ^ true
            ]
        ]
    ].

    mthd := callee method.
    mthd notNil ifTrue:[
        (mthd selector == #subclassResponsibility) ifTrue:[
            classToDefineIn := sender receiver class.
            selectorToDefine := sender selector.
            ^ true.
        ].

        "/ that's a big hack, but I am tired of navigating to find the missing menu message...
        "/ you will thank me!!
        mthd selector == #error:mayProceed: ifTrue:[
            (callee receiver isKindOf:MenuPanel) ifTrue:[
                |senderHome|
                
                (senderHome := sender home) notNil ifTrue:[
                    (senderHome selector startsWith:'accept:') ifTrue:[
                        (inspectedProcess notNil and:[inspectedProcess isGUIProcess]) ifTrue:[
                            (app := self processesApplication) notNil ifTrue:[
                                heuristic := senderHome argsAndVars select:[:o | o isSymbol].
                                heuristic size == 1 ifTrue:[
                                    classToDefineIn := app class.
                                    selectorToDefine := heuristic first.
                                    ^ true
                                ].
                            ].
                        ].
                    ].
                ].
            ].
        ]
    ].
    ^ false
!

showingAlreadyModifiedCode
    ^ methodCodeToggle isVisible
    and:[ methodCodeToggleSelectionHolder value = 2 ]
! !

!DebugView methodsFor:'testing'!

isDebugView
    ^ true
! !

!DebugView methodsFor:'user interaction'!

checkIfCodeIsReallyModified
    |methodSource editorCode|

    codeView modified ifFalse:[^ false].

    currentMethod isNil ifTrue:[^ false].

    methodSource := currentMethod source.
    methodSource notNil ifTrue:[
        methodSource := methodSource string.
        editorCode := codeView contents string.
        methodSource = editorCode ifTrue:[
            ^ false
        ].
        (methodSource withTabsExpanded:8) = (editorCode withTabsExpanded:8) ifTrue:[
            ^ false
        ].
    ].
    ^ true
!

checkIfCodeIsReallyModifiedAndConfirmWith:questionString
    "if code was not modified or confirmation answered with 'ok',
     return true (i.e. whatever user wants to do should be done).
     Otherwise, return false"

    self checkIfCodeIsReallyModified ifFalse:[^ true].
    (self confirm:(resources stringWithCRs:questionString)) ifTrue:[^ true].
    ^ false.

    "Created: / 25-11-2016 / 13:35:34 / cg"
!

checkSelectionChangeAllowed
    ^ self checkSelectionChangeAllowed:nil
!

checkSelectionChangeAllowed:newSelection
    |answer v|

    self checkIfCodeIsReallyModified ifFalse:[^ true].

    (newSelection notNil
    and:[newSelection = contextView selection]) ifTrue:[
        ^ true
    ].

    answer := Dialog
                confirmWithCancel:('Code modified - change selection anyway ?')
                labels:#('No' 'No, Show Diffs' 'Yes').
    answer isNil ifTrue:[^ false].
    answer == false ifTrue:[
        v := DiffCodeView
                openOn:codeView contents
                label:(resources string:'Changed code (to be accepted ?)')
                and:currentMethod source
                label:(resources string:'Method''s actual (maybe original) code').
        v label:(resources string:'Comparing method''s code').
        v waitUntilVisible.
        ^ false
    ].

    codeView modified:false.
    ^ true
!

codeAccept:someCode
    "user wants some code to be recompiled"

    ParseError handle:[:ex |
        ex lineNumber notNil ifTrue:[
            codeView selectLine:ex lineNumber. "/ selectFromCharacterPosition:ex startPosition to:ex endPosition.
        ].
        Dialog information:ex description.
"/            ParseError new
"/                errorMessage:aMessage startPosition:position endPosition:endPos;
"/                parameter:self;
"/                lineNumber:tokenLineNr; "lineNr"
"/                raiseRequest.
    ] do:[
        ^ self codeAccept:someCode unwind:false category:nil onCancel:nil
    ].

    "Modified: / 28-11-2006 / 19:49:04 / cg"
!

codeAccept:someCode inClass:aClass unwind:doUnwind category:category onCancel:cancelAction
    "user wants some code to be recompiled.
     Optionally unwind stack to right above the changed method.
     This undwind option is a leftover from times, when the debugger had no chance to
     show the original code.
     Now, it can, and got a choice-field to select between original and changed code.
     So the undwind option is not longer used and probably completely obsolete now
     (aka: this method is always called with doUnwind==false, these days)"

    |con newMethod|

    codeView withWaitCursorDo:[
        "
         find the method-home context for this one
        "
        doUnwind ifTrue:[
            con := selectedContext.
            top := con.
            [con notNil] whileTrue:[
                (con methodHome == selectedContext) ifTrue:[
                    top := con
                ].
                con := con sender
            ].
        ].

        "/
        "/ provide the classes nameSpace and changefile-update answers;
        "/ in case we accept while in another context, to not capture these settings again
        "/
        (Class updateChangeFileQuerySignal,
         Class updateChangeListQuerySignal,
         Class updateHistoryLineQuerySignal) answer:true
        do:[
            Class nameSpaceQuerySignal answer:(aClass nameSpace)
            do:[
                "/ the compiler nowadays already cares for the package...
                "/ no, actually, it does not in case we are in the middle of a fileIn,
                "/ and packageQuery is already answered by someone else.
                "/ Better make it unpackaged, in case the user makes changes to other
                "/ classes here (actually, I often change compiler, debugger, inspector here)
                Class packageQuerySignal
                answer:nil
                do:[
                    codeView contents:someCode.
                    Class methodRedefinitionNotification
                        answer:#keep
                        do:[
                            | breakpoints newMethodOrClass |

                            breakpoints := nil.
                            codeView isCodeView2 ifTrue:[
                                breakpoints := codeView breakpoints.
                            ].

                            BreakpointQuery answer: breakpoints do:[
                                "/ Use original method's programming language instead of class's one.
                                "/ In most cases it's the same, but it may be that the method edited
                                "/ and accepted was an extension method written in another languages
                                "/ (such as Smalltalk extension to Java class or Ruby extension to
                                "/ Smalltalk class.
                                newMethodOrClass := selectedContext programmingLanguage 
                                                        compilerClassForInteractiveTools
                                                             compile:someCode
                                                             forClass:aClass
                                                             inCategory:category
                                                             notifying:codeView.
                                "/ Kludge for accepting Java code in a debugger. The Java compiler
                                "/ does not compile single methods but always a full class and returns
                                "/ the compiled class(es) rather than a method. 
                                "/ However, we need to update the method holder of a codeView.
                                "/
                                "/ So, here we check whether the returned `newMethod` is really a method,
                                "/ if it's a class, try to search that class for a method with the
                                "/ same selector as selector of currently selected context. If found,
                                "/ that's the 'new' method we are going to show.
                                newMethodOrClass isBehavior ifTrue:[
                                    | selector |

                                    selector := selectedContext selector.
                                    newMethod := newMethodOrClass compiledMethodAt: selector ifAbsent: nil.
                                ] ifFalse:[
                                    newMethod := newMethodOrClass.
                                    newMethod == #Error ifTrue:[
                                        "/ should now be obsolete
                                        newMethod := nil
                                    ].    
                                ].    
                            ].
                        ].
                ].
            ].
        ].

        methodCodeToggleSelectionHolder value:2.    "/ showing current code
        methodCodeToggle beVisible.

        inspecting ifFalse:[
            (newMethod isNil) ifTrue:[^ cancelAction value].

            codeView modified:false.
            codeView isCodeView2 ifTrue:[
                codeView methodHolder value: newMethod.
            ].
            currentMethod := newMethod.
            
            doUnwind ifTrue:[
                "/ if it worked, and doUnwind is true,
                "/ remove everything up to and including top
                "/ from the context chain

                selectedContext canReturn ifTrue:[
                    self setContext:(top "sender").
                    exitAction := #restart.
                    selectedContext setLineNumber:1.
                    self doRestart.
                ] ifFalse:[
                    self setContext:(top sender).
                    exitAction := #return.
                ].
            ].
        ].
    ].

    "Created: / 17-11-2001 / 21:50:55 / cg"
    "Modified: / 29-08-2006 / 14:22:22 / cg"
    "Modified: / 17-08-2014 / 11:44:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAccept:someCode unwind:doUnwind category:givenCategoryOrNil onCancel:cancelAction
    "user wants some code to be recompiled"

    |sel implementorClass receiverClass method category wrapper|

    codeView withWaitCursorDo:[
"/        "
"/         find the method-home context for this one
"/        "
"/        con := selectedContext.
"/        top := con.
"/        [con notNil] whileTrue:[
"/            (con methodHome == selectedContext) ifTrue:[
"/                top := con
"/            ].
"/            con := con sender
"/        ].

        "
         use class&selector to find the method for the compilation
         and compile.
        "
        category := givenCategoryOrNil.
        sel := selectedContext selector.
        implementorClass := selectedContext methodClass.
        method := selectedContext method.

        implementorClass isNil ifTrue:[
            (method notNil 
                and:[method mclass isNil 
                and:[(wrapper := method wrapper) notNil]]
            ) ifTrue:[
                method := wrapper.
            ].
            method notNil ifTrue:[
                implementorClass := method mclass.
                implementorClass isNil ifTrue:[
                    implementorClass := method getMclass
                ].
            ].
        ].
        implementorClass notNil ifTrue:[
            category isNil ifTrue:[
                method isNil ifTrue:[
                    method := implementorClass compiledMethodAt:sel.
                ].
                category := method category
            ]
        ] ifFalse:[
            receiverClass := selectedContext receiver class.
            implementorClass := receiverClass whichClassImplements:sel.
            implementorClass := implementorClass ? receiverClass.
            implementorClass ~~ Object ifTrue:[
                implementorClass := Dialog
                                        request:('Define ''%1'' in class:' bindWith:sel allBold)
                                        initialAnswer:implementorClass name
                                        list:(implementorClass withAllSuperclasses collect:[:each| each name]).
                implementorClass size == 0 ifTrue:[
                    ^ cancelAction value "/ cancelled
                ].
                implementorClass := Smalltalk classNamed:implementorClass.
                implementorClass isNil ifTrue:[
                    Dialog warn:'No such class'.
                    ^ cancelAction value "/ cancelled
                ].
            ].
        ].

        self
            codeAccept:someCode
            inClass:implementorClass
            unwind:doUnwind
            category:category
            onCancel:cancelAction.
    ].

    "Created: / 17-11-2001 / 21:50:55 / cg"
    "Modified: / 29-08-2006 / 14:22:22 / cg"
!

codeCompletion
    "/ I found this code 3 times (CodeView2, NewSystemBrowser and DebugView) - smell?
    "/ (can we move that to a utility - probably DoWhatIMeanSupport)

    |cls language|

    currentMethod isNil ifTrue:[ ^ self ].

    cls := currentMethod mclass.
    cls notNil ifTrue:[
        language := cls programmingLanguage.
    ].

    UserInformation handle:[:ex |
        ex proceed.
    ] do:[
        DoWhatIMeanSupport codeCompletionForLanguage:language class:cls context:selectedContext codeView:codeView.
    ].

    "Modified: / 18-09-2013 / 14:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

confirm:aString
    "open a modal yes-no dialog.
     Redefined here, to answer true, if exclusice Debugger, which cannot handle popup boxes"

    (exclusive or:[windowGroup isNil]) ifTrue:[
        ^ true
    ].
    ^ super confirm:(resources stringWithCRs:aString).
!

doShowSelection:lineNr
    "user clicked on a header line - show selected code in textView.
     Also sent to autoselect an interesting context on entry."

    HaltInterrupt handle:[:ex |
        ignoreBreakpoints ifFalse:[ex reject].
        ('DebugView [info]: halt/breakpoint in debugger at %1 ignored [doShowSelection.]' bindWith:ex suspendedContext) infoPrintCR.
        ex proceed
    ] do:[
        self updateForContext:lineNr
    ].
    self updateMenuItems

    "Modified: / 17.11.2001 / 22:12:16 / cg"
!

hideStackInspector
    stackInspector notNil ifTrue:[
        stackInspector destroy.
        stackInspector := nil.
        receiverInspector origin:(0.0 @ 0.0) corner:0.5 @ 1.0.
        contextInspector origin:(0.5 @ 0.0) corner:(1.0 @ 1.0)
    ]
!

methodCodeToggleChanged
    |sel|

    sel := contextView selection.
    sel notNil ifTrue:[
        self showSelection:sel
    ]

    "Created: / 18-06-2010 / 12:29:21 / cg"
!

processEvent:anEvent
    "filter keyboard events for popUp variable value display.
     Return true, if I have eaten the event"

    <resource: #keyboard (#CodeCompletion )>

    |evView focusView key rawKey inCodeView|

    evView := anEvent view.
    evView notNil ifTrue:[
        focusView := evView windowGroup focusView.
        focusView isNil ifTrue:[
            focusView := evView.
        ].

        anEvent isKeyPressEvent ifTrue:[
            key := anEvent key.
            rawKey := anEvent rawKey.

            inCodeView := (focusView == codeView
                          or:[focusView isComponentOf:codeView]).
            inCodeView ifTrue:[
                key == #CodeCompletion ifTrue:[
                    "/ complete the word before/under the cursor.
                    self sensor
                        pushUserEvent:#codeCompletion
                        for:self
                        withArguments:#().
                    ^ true
                ].
            ].
        ].

false ifTrue:[
        anEvent isButtonReleaseEvent ifTrue:[
            anEvent view == codeView ifTrue:[
                (RBParser notNil and:[RBParser isLoaded])
                ifTrue:[
                    self sensor
                        pushEvent:anEvent.  "/ must be first in queue

                    self sensor
                      pushUserEvent:#explainSelection
                      for:self
                      withArguments:nil.
                    ^ true  "/ eaten
                ]
            ]
        ].
].

    ].
    ^ false
!

setCurrentMethod:aMethodOrNil
    currentMethod := aMethodOrNil.
!

showSelection:lineNr
    "user clicked on a header line - show selected code in textView.
     Also sent to autoselect an interesting context on entry."

    UserNotification
        handle:[:ex |
            "/ ex suspendedContext fullPrintAll.
            Transcript showCR:ex description.
            "/ Transcript showCR:ex parameter.
            ex proceed
        ]
        do:[
            Error
                handle:[:ex |
                    |s con|

                    ex creator isControlInterrupt ifTrue:[
                        'DebugView [info]: halt/break ignored - while showing selection in debugger'
                            infoPrintCR.
                        ex proceed
                    ].
                    ('DebugView [info]: error at %1 when showing selection in debugger ignored'
                        bindWith:ex suspendedContext) infoPrintCR.
                    s := '' writeStream.
                    s nextPutLine:'**** error in debugger, while extracting source'.
                    s nextPutLine:'****'.
                    s nextPutLine:'**** ',(ex description).
                    s nextPutLine:'****'.
                    con := ex suspendedContext.
                    s nextPutLine:'**** ',(con printString).
                    con := con sender.
                    HaltInterrupt ignoreIn:[ con fullPrintAllOn:s. ].

"/                            [con notNil] whileTrue:[
"/                                Error catch:[:ex |
"/                                    s nextPutAll: '**** '; nextPutLine:(con printString).
"/                                ].
"/
"/                                (con receiver == self and:[con selector == #'enter:select:']) ifTrue:[
"/                                    con := nil
"/                                ] ifFalse:[
"/                                    con := con sender.
"/                                ]
"/                            ].

                    codeView contents:(s contents).
                    ex return.
                ]
                do:[ self doShowSelection:lineNr ]
        ]

    "Modified: / 19-07-2012 / 10:56:58 / cg"
!

showStackInspectorFor:con
    stackInspector isNil ifTrue:[
        receiverInspector origin:(0.0 @ 0.0) corner:0.3 @ 1.0.
        contextInspector origin:(0.3 @ 0.0) corner:(0.6 @ 1.0).
        stackInspector := InspectorView
                    origin:(0.6 @ 0.0)
                    corner:(1.0 @ 1.0)
                    in:contextInspector superView.
        stackInspector realize.
        stackInspector fieldListLabel:'Stack'.
        stackInspector hideReceiver:true
    ].
    stackInspector inspect:(con stackFrame asArray).
    stackInspector showLast
!

updateContextInfoFor:aContext
    "additional info as-per selected context;
     for now:
        update:with:from: - show who was responsible
    "

    |whatChanged changedObject receiver|

    aContext selector == #'update:with:from:' ifTrue:[
        receiver := aContext receiver.
        whatChanged := aContext argAt:1.
        changedObject := aContext argAt:3.

        changedObject isBehavior ifTrue:[
            contextInfoLabel label:('update (',whatChanged printString allBold,') triggered by ',changedObject name allBold).
            ^ self
        ].

        receiver class allInstanceVariableNames keysAndValuesDo:[:i :nm |
            |val|

            IsDebuggingQuery answer:true do:[    
                val := receiver instVarAt:i.
            ].
            val == changedObject ifTrue:[
                contextInfoLabel label:('update (',whatChanged printString allBold,') triggered by ',nm allBold).
                ^ self
            ]
        ].

        (receiver isProtoObject not and:[receiver isKindOf:ApplicationModel]) ifTrue:[
            receiver builder notNil ifTrue:[
                (receiver builder bindings ? #()) keysAndValuesDo:[:eachAspect :eachValue |
                    eachValue == changedObject ifTrue:[
                        contextInfoLabel label:('update (',whatChanged printString allBold,') triggered by aspect ',eachAspect allBold).
                        ^ self
                    ]
                ]
            ]
        ].

        "do not use classNameWithArticle - it is missing in ProtoObject!!"
        contextInfoLabel label:('update (',whatChanged printString allBold,') triggered by ',changedObject class nameWithArticle allBold).
        ^ self.
    ].
    contextInfoLabel label:nil.
!

updateForContext:lineNr
    "show selected code for lineNr in contextList in textView.
     Also used to autoselect an interesting context on entry."

    |con homeContext sel method code canAccept
     implementorClass lineNrInMethod rec m line
     sender selSender tryVars possibleBlocks errMsg
     codeSet highlighter evaluatorClass
     canDefine callee searchClass originalMethod cannotAcceptDueToOutdatedClass|

    canDefine := cannotAcceptDueToOutdatedClass := false.
    self setCurrentMethod:nil.

    contextArray notNil ifTrue:[
        lineNr <= contextArray size ifTrue:[
            con := contextArray at:lineNr.
            callee := contextArray at:lineNr-1 ifAbsent:nil.
        ].
        "
         clicking on the '** ...'-line shows more ...
        "
        con isNil ifTrue:[
            line := contextView list at:lineNr.
            (line startsWith:'**') ifTrue:[
                self showMore.
                lineNr >= contextArray size ifTrue:[
                    contextView setSelection:lineNr.
                    con := contextArray at:lineNr ifAbsent:nil
                ]
            ].
            con isNil ifTrue:[
                codeView contents:nil.
                ^ self
            ].
        ].

        selectedContext := con.
        m := contextView middleButtonMenu.
        (m notNil and:[selectedContext notNil]) ifTrue:[
            m enableAll:#(browseImplementors browseSenders inspectContext)
        ].

        self withExecuteCursorDo:[
            codeSet := false.

            "
             give it to the (lower right) inspector
            "
            Error handle:[:ex |
                'DebugView [warning]: error while accessing context: ' errorPrint.
                ex description errorPrintCR.
                contextInspector inspect:nil.
                contextInspector fieldListLabel:('Context').
                ex suspendedContext fullPrintAllOn: Transcript.
"/ ex reject.
            ] do:[
                contextInspector inspect:con.
                "/ contextInspector fieldListLabel:('Context: ',con method whoString).
                contextInspector tryToSelectKeyNamed:lastSelectionInContextInspector.
            ].

            "/ show a stack inspector sometimes

            con hasStackToShow ifTrue:[
                self showStackInspectorFor:con
            ] ifFalse:[
                self hideStackInspector
            ].

            homeContext := con methodHome.
            con canReturn ifTrue:[
                returnButton enable. restartButton enable.
            ] ifFalse:[
                returnButton disable. restartButton disable.
            ].

            lineNrInMethod := con lineNumber.

            canAccept := false.

            homeContext isNil ifTrue:[
                "
                 mhmh - an optimized block
                 should get the block here, and get the method from
                 that one ...
                 But in the current version, there is no easy way to get to the block
                 since that one is not in the context.
                 A future new block calling scheme will fix this
                 (passing the block instead of the home as block argument).
                "
                (method := con method) isNil ifTrue:[
                    "temporary kludge - peek into the sender context.
                     If its a do-like method and there is a single block variable
                     in the args or temporaries, that must be the one.
                     This helps in some cases.
                    "
                    (sender := con sender) notNil ifTrue:[
                        tryVars := false.
                        (selSender := sender selector) notNil ifTrue:[
                            ((selSender endsWith:'do:') or:[selSender endsWith:'Do:']) ifTrue:[
                                tryVars := true.
                            ]
                        ].
                        tryVars ifTrue:[
                            possibleBlocks := sender argsAndVars select:[:v | v isBlock].
                            possibleBlocks := possibleBlocks select:[:b | b home isNil].
                            possibleBlocks size == 1 ifTrue:[
                                method := possibleBlocks first method.
                            ].
                        ]
                    ].
                ]
            ] ifFalse:[
                "fetch rec here - so we won't need context in doItAction"
                rec := homeContext receiver.
                sel := homeContext selector.
                sel notNil ifTrue:[
                    canAccept := true.

                    implementorClass := homeContext methodClass.
                    implementorClass isNil ifTrue:[
                        homeContext method notNil ifTrue:[
                            WrappedMethod allInstancesDo:[:wrapped |
                                wrapped originalMethod == homeContext method ifTrue:[
                                    implementorClass := wrapped mclass
                                ]
                            ].
                            implementorClass isNil ifTrue:[
                                (homeContext searchClass notNil
                                and:[homeContext searchClass isObsolete]) ifTrue:[
                                    cannotAcceptDueToOutdatedClass := true.
                                ]
                            ].
                        ].
                    ].
                    implementorClass isNil ifTrue:[
                        Error handle:[:ex |
"/ not covered by Error, anyway
"/                            ex signal == BreakPointInterrupt ifTrue:[
"/                                ex proceed.
"/                            ].
                            code := 'error while asking method for its source'.
                            code := code , Character cr , ex creator printString.
                            code := code , Character cr , 'in: ' , ex suspendedContext printString.

                            canAccept := false.
                            ex return.
                        ] do:[
                            "
                             special: look if this context was created by
                             valueWithReceiver kind of method invocation;
                             if so, grab the method from the sender and show it
                            "
                            ((sender := homeContext sender) notNil
                            and:[((sender selector ? '') startsWith:'valueWithReceiver:')
                            and:[sender receiver isMethod]]) ifTrue:[
                                method := sender receiver.
                                canAccept := false.
                            ] ifFalse:[
                                (method := con method) notNil ifTrue:[
                                    canAccept := false.
                                ]
                            ].
                        ]
                    ] ifFalse:[
                        method := implementorClass compiledMethodAt:sel.
                    ].
                ]
            ].

            homeContext notNil ifTrue:[
                searchClass := homeContext searchClass ? rec class.
                currentMethod := searchClass lookupMethodFor:sel.
            ].
            originalMethod := currentMethod.
            (currentMethod notNil
                and:[currentMethod ~~ method
                and:[ (currentMethod isWrapped and:[ method == currentMethod originalMethod]) not ]]
            ) ifTrue:[
                originalMethod := method.
                methodCodeToggleSelectionHolder value = 1 ifTrue:[
                    method := originalMethod.   "/ the one which is suspended / was executing
                ] ifFalse:[
                    method := currentMethod.    "/ the one which has already been accepted/modified.
                    lineNrInMethod := nil.
                    canAccept := true.
                ].
                methodCodeToggle beVisible.
            ] ifFalse:[
                methodCodeToggle beInvisible.
            ].

            code isNil ifTrue:[
                errMsg := nil.
                method isNil ifTrue:[
                    "/ fall back heuristics (see how this was called, fetch block from caller)
                    sender := con sender.
                    con isBlockContext ifTrue:[
                        (sender notNil
                        and:[((sender selector ? '') startsWith:'value')
                        and:[sender receiver isBlock]]) ifTrue:[
                            code := sender receiver source.
                        ]
                    ] ifFalse:[
                        (sender notNil
                        and:[((sender selector ? '') startsWith:'valueWith')
                        and:[sender receiver isMethod]]) ifTrue:[
                            method := sender receiver.
                        ]
                    ]
                ].
                method notNil ifTrue:[
                    contextInspector fieldListLabel:(method selector "whoString").
                    Error handle:[:ex |
"/ not covered by Error, anyway
"/                        ex signal isControlInterrupt ifTrue:[
"/                            ex proceed.
"/                        ].
                        code := 'error while asking method for its source'.
                        code := code , Character cr , ex creator printString.
                        code := code , Character cr , 'in: ' , ex suspendedContext printString.

                        canAccept := false.
                        ex return.
                    ] do:[
                        self sensor shiftDown ifTrue:[
                            code := method decompiledSource
                        ] ifFalse:[
                            code := method source.
                        ].
                    ].

                    code isNil ifTrue:[
                        method sourceFilename notNil ifTrue:[
                            codeView contents:(resources
                                                       string:'** no sourcefile: %1 **'
                                                       with:method sourceFilename).
                            codeView realized ifTrue:[
                                "codeView is not realized on initial startup"
                                codeView flash:'no source'.
                            ].
                            codeSet := true.
                        ] ifFalse:[
                            [
                                |src|

                                src := String streamContents:[:s | Decompiler decompile:method to:s].
                                codeView contents:src.
                                codeSet := true.
                            ] on: Error do:[
                                errMsg := '** no source **'
                            ].
                        ]
                    ].
                ] ifFalse:[
                    contextInspector fieldListLabel:'Context'.
                    homeContext isNil ifTrue:[
                        errMsg := '** sorry; cannot show code of all optimized blocks (yet) **'.
                    ] ifFalse:[
                        errMsg := '** no method - no source **'.
                        canDefine := true.
                    ]
                ].
                errMsg notNil ifTrue:[
                   self showError:errMsg.
                   codeSet := true.
                ]
            ].

            code isNil ifTrue:[
                "/ canAccept := false.
                codeSet ifFalse:[
                    codeView contents:nil.
                ]
            ] ifFalse:[
                lineNrInMethod notNil ifTrue:[
                    lineNrInMethod == 0 ifTrue:[
                        (method notNil and:[method isJavaMethod]) ifTrue:[
                            lineNrInMethod := method lineNumber
                        ].
                        "/ guess lineNumber from sent-messages selector
                        "/ kludge to fix lineNr-display of shared subclassResponsibility methods.
                        lineNrInMethod == 0 ifTrue:[
                            |conIdx sentContext messages|

                            conIdx := contextArray identityIndexOf:con.
                            conIdx > 1 ifTrue:[
                                sentContext := contextArray at:conIdx-1.
                                sentContext isBlockContext ifFalse:[
                                    (method notNil and:[code notNil]) ifTrue:[
                                        messages := method messagesSent.
                                        messages size == 1 ifTrue:[
                                            sentContext selector == messages first ifTrue:[
                                                lineNrInMethod := code asStringCollection findFirst:[:l | l includesString:sentContext selector].
                                            ]
                                        ]
                                    ].
                                ].
                            ].
                        ].
                    ].
                ].
                codeView isCodeView2 ifTrue:[
                    codeView model
                        setValue: code;
                        changed.
                    codeView methodHolder value: method.
                    codeView classHolder value: ((method respondsTo: #mclass) ifTrue:[method mclass] ifFalse:[rec class])
                ] ifFalse:[
                    UserPreferences current syntaxColoring ifTrue:[
                        implementorClass isNil ifTrue:[
                            |guessedHome|
                            (con isBlockContext
                            and:[con home isNil
                            and:[(guessedHome := con guessedHome) notNil]])
                            ifTrue:[
                                implementorClass := guessedHome mclass
                            ]
                        ].
                        implementorClass notNil ifTrue:[
                            (highlighter := implementorClass syntaxHighlighterClass) notNil ifTrue:[
                                code size < 100000 ifTrue:[
                                    Error catch:[
                                        code := highlighter formatMethodSource:code in:implementorClass.
                                    ]
                                ]
                            ]
                        ]
                    ].

"/                code ~= (codeView contents) ifTrue:[
                    cannotAcceptDueToOutdatedClass ifTrue:[
                        codeView setContents:(('Obsolete code (outdated due to class change). Use Browser.' withColor:Color red),Character cr,Character cr,code asString).
                    ] ifFalse:[
                        codeView setContents:code.
                    ].
"/                ].
                ].
                (lineNrInMethod notNil
                and:[lineNrInMethod ~~ 0
                and:[lineNrInMethod <= codeView list size]]) ifTrue:[
lineNrInMethod == 255 ifFalse:[
                    (lineNrInMethod == 255
                    and:[method notNil
                    and:[method hasCode not]]) ifTrue:[
                        "/ means: do not really know in interpreted methods
                        codeView selectFromLine:255 col:1 toLine:codeView list size + 1 col:0.
                    ] ifFalse:[
                        codeView selectLine:lineNrInMethod.
                    ].
                    codeView makeSelectionVisible
].
                ] ifFalse:[
                    codeView unselect.
                    codeView scrollToTop
                ]
            ].

            codeView acceptEnabled:canAccept.
            canAccept ifTrue:[
                codeView acceptAction:[:code | self codeAccept:code asString]
            ] ifFalse:[
                codeView acceptAction:[:code | self beep]
            ].

            receiverInspector inspect:rec.
            "do not use classNameWithArticle - it is missing in ProtoObject!!"
            receiverInspector fieldListLabel:("'Receiver: ',"rec class nameWithArticle).
            receiverInspector tryToSelectKeyNamed:lastSelectionInReceiverInspector.

            "
             the one below is wrong: currently, the
             evaluator cannot handle passed contexts.
             Once it does, pass con as in:-arg
            "
            (rec isJavaObject
            and:[method isNil or:[method isJavaMethod not]]) ifTrue:[
                "/ although a java object, use the smalltalk parser here for doIts.
                evaluatorClass := Parser.
                codeView commentStrings:#( '//' ( '/*' '*/' ) ).
            ] ifFalse:[
                (method notNil and:[method mclass notNil]) ifTrue:[
                    evaluatorClass := method mclass evaluatorClass.
                    codeView commentStrings:method mclass programmingLanguage commentStrings.
                ] ifFalse:[
                    evaluatorClass := rec class evaluatorClass.
                    codeView commentStrings:rec class programmingLanguage commentStrings.
                ].
            ].

            codeView
                simulatedSelf:rec;
                doItAction:
                    [:theCode |
                         evaluatorClass
                             evaluate:theCode
                             in:actualContext "/ (selectedContext ? actualContext)
                             receiver:rec
                             notifying:codeView
                             logged:true
                             ifFail:nil
                    ];
                editedMethodOrClass:(method ? rec class).


            self setCurrentMethod:method.

            selectedContext := homeContext ? con.
            actualContext := con
        ].
    ] ifFalse:[
        codeView contents:nil.
    ].
    codeView modified:false.

    con isContext ifFalse:[
        sendButton disable.
    ] ifTrue:[
        sendButton enable.
    ].
    self updateContextInfoFor:con.

    "clear out locals to prevent keeping around unneeded contexts
     (due to the block held in codeView).
     (not really needed, since stuff gets collected away sooner or later ...
      ... but this makes it a bit sooner)
    "
    con := nil.
    homeContext := nil.

    (canDefine or:[self canDefineForCallee:callee]) ifTrue:[
        defineButton beVisible.
    ] ifFalse:[
        defineButton beInvisible.
    ].

    "/ enable/disable some menu items
    self updateMenuItems

    "Created: / 14-08-1997 / 20:15:00 / cg"
    "Modified: / 05-10-2011 / 11:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2013 / 15:13:02 / cg"
! !

!DebugView::IgnoredHaltOrBreakpoint methodsFor:'accessing'!

ignoreCount:something
    ignoreCount := something.
!

ignoreEndTime:something
    ignoreEndTime := something.
!

ignoreForProcess:aProcess
    ignoredProcesses isNil ifTrue:[
        ignoredProcesses := WeakIdentitySet new.
    ].
    ignoredProcesses add:aProcess
!

ignoreForReceiverClass:aClass
    ignoredReceiverClasses isNil ifTrue:[
        ignoredReceiverClasses := WeakIdentitySet new.
    ].
    ignoredReceiverClasses add:aClass
!

ignoreIfCalledFromMethod:aMethod
    ignoredSendingClassAndSelectors isNil ifTrue:[
         ignoredSendingClassAndSelectors := OrderedCollection new.
    ].

    "/ remember the method's name, not the method.
    "/ so it can be recompiled and we still detect ignores
    ignoredSendingClassAndSelectors add:{aMethod mclass name . aMethod selector }
!

ignoreUntilShiftKeyPressed:aBoolean
    ignoreUntilShiftKeyPressed := aBoolean.

    "Created: / 27-01-2012 / 11:35:23 / cg"
! !

!DebugView::IgnoredHaltOrBreakpoint methodsFor:'misc'!

decrementIgnoreCount
    ignoreCount notNil ifTrue:[
        ignoreCount > 0 ifTrue:[
            ignoreCount := ignoreCount - 1
        ]
    ]
! !

!DebugView::IgnoredHaltOrBreakpoint methodsFor:'printing'!

printConditionOn:aStream
    ignoredSendingClassAndSelectors notEmptyOrNil ifTrue:[
        aStream nextPutAll:(' if called from %1  %2'
                                bindWith:ignoredSendingClassAndSelectors first first
                                with:ignoredSendingClassAndSelectors first second).
        ^ self.
    ].
    ignoredProcesses notEmptyOrNil ifTrue:[
        aStream nextPutAll:(' in %1 processes (%2)'
                                bindWith:ignoredProcesses size
                                with:((ignoredProcesses collect:[:each | each name] as:OrderedCollection) asStringWith:', ')).
        ^ self.
    ].
    ignoredReceiverClasses notNil ifTrue:[
        aStream nextPutAll:(' for %1 classes (%2)'
                            bindWith:ignoredReceiverClasses size
                            with:((ignoredReceiverClasses collect:[:each | each name] as:OrderedCollection) asStringWith:', ')).
        ^ self.
    ].
    ignoreUntilShiftKeyPressed == true ifTrue:[
        aStream nextPutAll:' until shiftKey pressed'.
        ^ self.
    ].
    ignoreEndTime notNil ifTrue:[
        aStream nextPutAll:' until '.
        ignoreEndTime printOn:aStream.
        ^ self.
    ].
    (ignoreCount notNil) ifTrue:[
        (ignoreCount > 0) ifTrue:[
            aStream nextPutAll:' for '.
            ignoreCount printOn:aStream.
            ^ self.
        ].
        (ignoreCount < 0) ifTrue:[
            aStream nextPutAll:' forEver'.
            ^ self.
        ].
        aStream nextPutAll:' no longer'.
    ].
! !

!DebugView::IgnoredHaltOrBreakpoint methodsFor:'queries'!

haltIgnoredInfoString
    "some string describing why and how this halt is ignored;
     nil if not ignored"

    ^ String streamContents:[:s |
        s nextPutAll:'ignored '.
        self printConditionOn:s
    ].

"/    ignoreCount notNil ifTrue:[
"/        ignoreCount > 0 ifTrue:[
"/            ^ '%1 more calls ignored' bindWith:ignoreCount
"/        ].
"/        ^ nil
"/    ].
"/    ignoreEndTime notNil ifTrue:[
"/        (ignoreEndTime > Timestamp now) ifTrue:[
"/            ^ 'ignored until %1' bindWith:ignoreEndTime
"/        ].
"/        ^ nil
"/    ].
"/    ignoreUntilShiftKeyPressed == true ifTrue:[
"/        Screen current shiftDown ifFalse:[
"/            ^ 'ignored until shiftKey is pressed'
"/        ].
"/        ^ nil
"/    ].
"/    ignoredProcesses notNil ifTrue:[
"/        ^ 'ignored in some processes'
"/    ].
"/    ignoredReceiverClasses notNil ifTrue:[
"/        ^ 'ignored for some receiver classes'
"/    ].
"/
"/    ^ 'ignored until reenabled'

    "Modified: / 27-01-2012 / 11:35:48 / cg"
!

isActive
    "true if this ignore-entry is still active"

    ignoreEndTime notNil ifTrue:[
        ^ ignoreEndTime > Timestamp now
    ].
    ignoreCount notNil ifTrue:[
        ^ ignoreCount == -1 or:[ ignoreCount > 0 ]
    ].
    ignoredProcesses notNil ifTrue:[
        ignoredProcesses := ignoredProcesses reject:[:p | p notNil and:[p isDead]].
        ignoredProcesses isEmpty ifTrue:[
            ignoredProcesses := nil.
            ^ false
        ].
    ].
    ^ true

    "Created: / 06-03-2012 / 12:39:46 / cg"
!

isForBreakpointWithParameter
    ^ false

    "Modified: / 27-01-2012 / 11:36:01 / cg"
    "Created: / 06-03-2012 / 12:47:02 / cg"
!

isForBreakpointWithParameter:paramArg
    ^ false

    "Modified: / 27-01-2012 / 11:36:01 / cg"
    "Created: / 06-03-2012 / 14:36:28 / cg"
!

isHaltIgnored
    "true if this halt should be ignored (sometimes)"

    ignoreUntilShiftKeyPressed == true ifTrue:[
        ^ Screen current shiftDown not
    ].
    ignoreCount notNil ifTrue:[
        ^ ignoreCount > 0
    ].
    ignoreEndTime notNil ifTrue:[
        ^ ignoreEndTime > Timestamp now
    ].

    ^ true

    "Modified: / 27-01-2012 / 11:36:01 / cg"
! !

!DebugView::IgnoredHalt methodsFor:'accessing'!

method
    |m|

    weakMethodHolder == #all ifTrue:[^ weakMethodHolder ].

    m := weakMethodHolder at:1.
"/ wait until really gone (it could still be on the call stack
"/
"/    m notNil ifTrue:[
"/        m mclass isNil ifTrue:[
"/            "/ no longer valid
"/            weakMethodHolder at:1 put:nil.
"/            ^ nil
"/        ].
"/    ].
    ^ m

    "Modified: / 08-05-2011 / 10:28:10 / cg"
!

method:methodArg lineNumber:lineNumberArg
    "/ self assert:(methodArg mclass notNil).

    methodArg == #all ifTrue:[
        weakMethodHolder := methodArg
    ] ifFalse:[
        weakMethodHolder := WeakArray with:methodArg.
    ].
    lineNumber := lineNumberArg.

    "Modified: / 08-05-2011 / 10:28:41 / cg"
! !

!DebugView::IgnoredHalt methodsFor:'printing'!

printOn:aStream
    |method|

    (method := self method) isNil ifTrue:[
        aStream nextPutAll:'an obsolete IgnoredHalt'.
        ^ self
    ].

    aStream nextPutAll:'Ignore '.
    method isSymbol ifTrue:[
        method printOn:aStream.
    ] ifFalse:[
        method whoString printOn:aStream.
    ].
    self printConditionOn:aStream.

    "Modified: / 27-07-2012 / 23:04:42 / cg"
! !

!DebugView::IgnoredHalt methodsFor:'queries'!

isActive
    "true if this ignore-entry is still active"

    self method isNil ifTrue:[self breakPoint:#cg. ^ false ].    "/ method no longer valid
    ^ super isActive

    "Modified: / 06-03-2012 / 12:40:20 / cg"
!

isForMethod:aMethod line:line
    "/ check in this order - method has a flushing side-effect, which is useful here...
    weakMethodHolder == #all ifTrue:[^ true].

    ^ (aMethod = self method) and:[ line = lineNumber ].

    "Modified: / 08-05-2011 / 10:27:31 / cg"
!

isHaltIgnoredInMethod:aMethod line:line
    ^ self isHaltIgnoredInMethod:aMethod line:line context:nil
!

isHaltIgnoredInMethod:aMethod line:line context:context
    "/ Transcript show:'?same as ign '; show:(weakMethodHolder at:1); show:' at '; showCR:lineNumber.

"/    Transcript showCR:'-----------------------------'.
"/    Transcript showCR:aMethod.
"/    Transcript showCR:line.
"/    Transcript showCR:context.

    (self isForMethod:aMethod line:line) ifFalse:[^ false].
    "/ Transcript show:'is same; ignored: '; showCR:self isHaltIgnored.

    context notNil ifTrue:[
        ignoredReceiverClasses notNil ifTrue:[
            ^ ignoredReceiverClasses includes:(context receiver class)
        ].
    ].

"/    Transcript showCR:ignoredProcesses.
"/    Transcript showCR:Processor activeProcess.
    ignoredProcesses notNil ifTrue:[
        ^ ignoredProcesses includes:(Processor activeProcess)
    ].
    ignoredSendingClassAndSelectors notNil ifTrue:[
        context withAllSendersDo:[:each |
            |m className selector cls|

            (m := each method) notNil ifTrue:[
                cls := m mclass.
                cls notNil ifTrue:[
                    className := cls name.
                    selector := m selector.
                    (ignoredSendingClassAndSelectors contains:[:entry | entry first = className and:[entry second = selector]])
                        ifTrue:[^ true].
                ].
            ]
        ]
    ].

    ^ self isHaltIgnored  "/ unconditionally
! !

!DebugView::IgnoredBreakpoint methodsFor:'accessing'!

parameter
    ^ parameter
!

parameter:something
    parameter := something.
! !

!DebugView::IgnoredBreakpoint methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'Ignore breakpoint:#', parameter.
    self printConditionOn:aStream.

    "Created: / 06-03-2012 / 12:42:10 / cg"
! !

!DebugView::IgnoredBreakpoint methodsFor:'queries'!

isForBreakpointWithParameter
    ^ true

    "Created: / 06-03-2012 / 12:54:35 / cg"
!

isForBreakpointWithParameter:paramArg
Transcript showCR:parameter.
    ^ paramArg = parameter

    "Created: / 06-03-2012 / 14:36:21 / cg"
! !

!DebugView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


DebugView initialize!
