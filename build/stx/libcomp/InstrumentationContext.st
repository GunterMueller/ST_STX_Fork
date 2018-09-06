"
 COPYRIGHT (c) 2010 by eXept Software AG
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

Object variableSubclass:#InstrumentationContext
	instanceVariableNames:'inInstrumentedCode enabled coverageOnly'
	classVariableNames:'LastProcess LastInstrumentationContext
		GlobalInstrumentationContext'
	poolDictionaries:''
	category:'System-Compiler-Instrumentation'
!

!InstrumentationContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
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
    installed as a thread-local variable (instrumentationContext) by the
    beActiveIn:aProcess method, instances of me keep some meta state while
    instrumentation is ongoing.

    Especially, instrumentationInfo objects are only updated in processes with a context. 
    This has two advantages:
        - it blocks recursive calls, while inside instrumentation code
        - it blocks measurements from other processes 
          (so code coverage is only measured when executed during a test run, not if
           executed by other processes)

    the main entries are run: and runForCoverage:
    the code must have been recompiled with instrumentation before
    (see InstrumentingCompiler - class protocol)
"
! !

!InstrumentationContext class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!InstrumentationContext class methodsFor:'instance access'!

current
    "the current context for this running thread.
     walks along the parent-process chain, up to a possible global context"

    ^ self forProcess:(Processor activeProcess)

    "
     InstrumentationContext current
    "

    "Created: / 08-08-2011 / 14:44:11 / cg"
!

forProcess:aProcess
    "the context for this thread.
     walks along the parent-process chain, up to a possible global context"

    |p context|

    aProcess isDead ifTrue:[
        "do not keep dead processes from being garbage collected"
        aProcess == LastProcess ifTrue:[
            LastProcess := LastInstrumentationContext := nil.
        ].
        ^ GlobalInstrumentationContext.
    ].

    aProcess == LastProcess ifTrue:[
        ^ LastInstrumentationContext ? GlobalInstrumentationContext
    ].

    "/ future (need a faster parentProcess query)
    p := aProcess.
    [p notNil] whileTrue:[
        context := p environmentAt:#instrumentationContext ifAbsent:nil.
        context notNil ifTrue:[
            aProcess environmentAt:#instrumentationContext put:context.
            context == 0 ifTrue:[
                context := nil.
            ].
            LastProcess := aProcess.
            LastInstrumentationContext := context.
            ^ context
        ].
        p := p parentProcess
    ].
    aProcess environmentAt:#instrumentationContext put:(GlobalInstrumentationContext ? 0).      "/ could be nil
    LastProcess := aProcess.
    LastInstrumentationContext := GlobalInstrumentationContext.
    ^ GlobalInstrumentationContext.

    "
     InstrumentationContext current
    "

    "Created: / 17-08-2011 / 11:29:51 / cg"
! !

!InstrumentationContext class methodsFor:'queries'!

hasGlobalInstrumentationContext
    ^ GlobalInstrumentationContext notNil

    "
     InstrumentationContext hasGlobalInstrumentationContext
    "

    "Created: / 21-09-2011 / 19:15:51 / cg"
! !

!InstrumentationContext class methodsFor:'running'!

run:aBlock
    "run aBlock with instrumentation enabled"

    self new run:aBlock.

    "
     Smalltalk loadPackage:'stx/goodies:regression'.
     BTree withAllPrivateClasses
        do:[:cls | cls recompileUsingCompilerClass:InstrumentingCompiler].
     InstrumentationContext
        run:[ RegressionTests::BinaryTreeTester suite run ].
     (Tools::NewSystemBrowser open)
        switchToClass:BTree;
        showCoverageInformation value:true
    "

    "Created: / 08-08-2011 / 15:47:10 / cg"
    "Modified (comment): / 12-07-2017 / 16:09:12 / mawalch"
!

runForCoverage:aBlock
    "run aBlock with instrumentation enabled, but only for coverage (i.e. not counting)"

    self new runForCoverage:aBlock.

    "
     Smalltalk loadPackage:'stx/goodies:regression'.
     BTree withAllPrivateClasses
        do:[:cls | cls recompileUsingCompilerClass:InstrumentingCompiler].
     InstrumentationContext
        run:[ RegressionTests::BinaryTreeTester suite run ].
     (Tools::NewSystemBrowser open)
        switchToClass:BTree;
        showCoverageInformation value:true
    "

    "Created: / 08-08-2011 / 15:47:10 / cg"
    "Modified (comment): / 12-07-2017 / 16:09:28 / mawalch"
! !

!InstrumentationContext class methodsFor:'utilities'!

flushAllPerProcessInstrumentationContexts
    Process allInstancesDo:[:eachProcess |
        eachProcess environmentAt:#instrumentationContext put:nil
    ].
    LastProcess := nil.

    "
     self flushAllPerProcessInstrumentationContexts
    "
!

globalInstrumentationContext
    ^ GlobalInstrumentationContext
!

setGlobalInstrumentationContext:aContextOrNil
    "setup for global instrumentation: instrumentation is performed for all processes"

    GlobalInstrumentationContext := aContextOrNil.
    LastInstrumentationContext := LastProcess := nil.

    "Created: / 21-09-2011 / 19:07:00 / cg"
!

setInstrumentationContext:aContextOrNil in:aProcess
    "setup for process specific instrumentation: 
        instrumentation is aProcess"

    "in order to keep the knowledge about which environment-variable is used
     at least local..."

    aProcess environmentAt:#instrumentationContext put:aContextOrNil.
    LastInstrumentationContext := LastProcess := nil.

    "Created: / 17-08-2011 / 11:53:19 / cg"
! !

!InstrumentationContext methodsFor:'accessing'!

coverageOnly
    "if on, only keep track of coverage (not counting);
     if off, we also count how often the code has been entered,
     and by which sender"

    ^ coverageOnly ? false

    "Created: / 23-08-2011 / 21:25:46 / cg"
!

coverageOnly:aBoolean
    "if on, only keep track of coverage (not counting);
     if off, we also count how often the code has been entered"

    coverageOnly := aBoolean.

    "Created: / 23-08-2011 / 21:25:37 / cg"
!

enabled
    ^ enabled
!

enabled:aBoolean
    enabled := aBoolean.

    "Modified (format): / 08-08-2011 / 14:47:12 / cg"
!

inInstrumentedCode
    ^ inInstrumentedCode ? false

    "Modified: / 07-08-2011 / 16:57:15 / cg"
!

inInstrumentedCode:aBoolean
    inInstrumentedCode := aBoolean.

    "Modified (format): / 08-08-2011 / 19:43:19 / cg"
! !

!InstrumentationContext methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    inInstrumentedCode := false.
    enabled := true.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 08-08-2011 / 15:44:59 / cg"
! !

!InstrumentationContext methodsFor:'installing'!

beActiveEverywhere
    "become the current instrumentaion context for all processes."

    self class setGlobalInstrumentationContext:self. 
    LastInstrumentationContext := LastProcess := nil.

    "
     InstrumentationContext new beActiveEverywhere
    "

    "Created: / 21-09-2011 / 19:08:43 / cg"
!

beActiveIn:aProcess
    "become the current instrumentaion context for a process."

    self class setInstrumentationContext:self in:aProcess.
    LastInstrumentationContext := LastProcess := nil.

    "
     InstrumentationContext new beActiveIn:(Processor activeProcess)
    "

    "Created: / 08-08-2011 / 14:46:09 / cg"
! !

!InstrumentationContext methodsFor:'queries'!

enabledAndNotInInstrumentedCode
    ^ enabled and:[ inInstrumentedCode not ]

    "Created: / 08-08-2011 / 15:44:30 / cg"
! !

!InstrumentationContext methodsFor:'running'!

run:aBlock
    "run aBlock with instrumentation enabled"

    |activeProcess|

    activeProcess := Processor activeProcess.

    [
        self beActiveIn:activeProcess.
        aBlock value
    ] ensure:[
        self class setInstrumentationContext:nil in:activeProcess
    ].

    "Modified: / 17-08-2011 / 11:53:54 / cg"
!

runForCoverage:aBlock
    "run aBlock with instrumentation enabled;
     but only for coverage (i.e. not counting)"

    coverageOnly := true.
    self run:aBlock
! !

!InstrumentationContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

