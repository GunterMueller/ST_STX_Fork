"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CoverageInstrumentationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!CoverageInstrumentationTest methodsFor:'testFunctions'!

calledByF6
    'dummy'
!

f1
    ^ 1234
!

f2:aBoolean
    aBoolean ifTrue:[
	^ 1234
    ].
    ^ 2345
!

f3:aBoolean
    aBoolean ifTrue:[
	^ 1234  "both should be executed with a true arg, and coverage should see that"
    ] ifFalse:[
	^ 2345  "bith should be executed with a true arg, and coverage should see that"
    ].
    ^ 3456
!

f4:aBoolean
    aBoolean ifFalse:[
	^ 1234  "should not be executed with a true arg, and coverage should see that"
    ].
!

f5:loopCount
    1 to:loopCount do:[:i |
	1 + 2   "should be executed 10 times, and coverage should see that"
    ].
!

f6:loopCount
    1 to:loopCount do:[:i |
	self calledByF6
    ].
! !

!CoverageInstrumentationTest methodsFor:'tests'!

test_01_instrumentation
    |m1|

    self class recompile:#f1 usingCompilerClass:InstrumentingCompiler.

    m1 := (self class compiledMethodAt:#f1).

    self assert:(m1 hasBeenCalled not).

    "/ execute
    InstrumentationContext runForCoverage:[
	self f1.
    ].
    self assert:(m1 hasBeenCalled).

    "
     self new test_01_instrumentation
    "
!

test_02_instrumentation
    |m2 context|

    self class recompile:#f2: usingCompilerClass:InstrumentingCompiler.

    m2 := (self class compiledMethodAt:#f2:).

    self assert:(m2 hasBeenCalled not).
    self assert:(m2 blockInvocationInfo size == 1).
    self assert:(m2 statementInvocationInfo size == 3).
    self assert:(m2 blockInvocationInfo conform:[:i | i hasBeenExecuted not]).
    self assert:(m2 statementInvocationInfo conform:[:i | i hasBeenExecuted not]).

    "/ execute
    context := InstrumentationContext new.
    context runForCoverage:[
	self f2:true.
    ].
    self assert:(m2 hasBeenCalled).
    self assert:(m2 blockInvocationInfo conform:[:i | i hasBeenExecuted]).
    self assert:(m2 statementInvocationInfo first hasBeenExecuted).
    self assert:(m2 statementInvocationInfo second hasBeenExecuted).
    self assert:(m2 statementInvocationInfo third hasBeenExecuted not).

    "/ execute in the same context
    context runForCoverage:[
	self f2:false.
    ].

    self assert:(m2 hasBeenCalled).
    self assert:(m2 blockInvocationInfo conform:[:i | i hasBeenExecuted]).
    self assert:(m2 statementInvocationInfo conform:[:i | i hasBeenExecuted]).

    "
     self new test_02_instrumentation
    "

    "Modified: / 12-09-2013 / 16:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03_instrumentation
    |m3 context|

    self class recompile:#f3: usingCompilerClass:InstrumentingCompiler.

    m3 := (self class compiledMethodAt:#f3:).

    "/ before execution
    self assert:(m3 hasBeenCalled not).
    self assert:(m3 blockInvocationInfo size == 2).
    self assert:(m3 statementInvocationInfo size == 4).
    self assert:(m3 blockInvocationInfo conform:[:i | i hasBeenExecuted not]).
    self assert:(m3 blockInvocationInfo conform:[:i | i count == 0]).
    self assert:(m3 statementInvocationInfo conform:[:i | i hasBeenExecuted not]).

    "/ execute
    context := InstrumentationContext new.
    context runForCoverage:[
	self f3:true.
    ].

    "/ one block should have been invoked, the other not"
    self assert:(m3 hasBeenCalled).
    self assert:(m3 blockInvocationInfo count:[:i | i hasBeenExecuted]) = 1.
    self assert:(m3 blockInvocationInfo count:[:i | i hasBeenExecuted not]) = 1.
    self assert:(m3 statementInvocationInfo first hasBeenExecuted).
    self assert:(m3 statementInvocationInfo second hasBeenExecuted).
    self assert:(m3 statementInvocationInfo third hasBeenExecuted not).
    self assert:(m3 statementInvocationInfo fourth hasBeenExecuted not).

    "/ execute
    context runForCoverage:[
	self f3:false.
    ].

    "/ both blocks should have been invoked"
    self assert:(m3 hasBeenCalled).
    self assert:(m3 blockInvocationInfo count:[:i | i hasBeenExecuted]) = 2.
    self assert:(m3 blockInvocationInfo count:[:i | i hasBeenExecuted not]) = 0.
    self assert:(m3 blockInvocationInfo conform:[:i | i count == 1]).
    self assert:(m3 statementInvocationInfo first hasBeenExecuted).
    self assert:(m3 statementInvocationInfo second hasBeenExecuted).
    self assert:(m3 statementInvocationInfo third hasBeenExecuted).
    self assert:(m3 statementInvocationInfo fourth hasBeenExecuted not).


    "
     self new test_03_instrumentation
    "

    "Modified: / 12-09-2013 / 16:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04_instrumentation
    |m4|

    self class recompile:#f4: usingCompilerClass:InstrumentingCompiler.

    m4 := (self class compiledMethodAt:#f4:).

    self assert:(m4 hasBeenCalled not).
    self assert:(m4 blockInvocationInfo size == 1).
    self assert:(m4 statementInvocationInfo size == 2).
    self assert:(m4 blockInvocationInfo conform:[:i | i hasBeenExecuted not]).
    self assert:(m4 statementInvocationInfo conform:[:i | i hasBeenExecuted not]).

    "/ execute
    InstrumentationContext runForCoverage:[
	self f4:true.
    ].

    self assert:(m4 hasBeenCalled).

    "
     self new test_04_instrumentation
    "

    "Modified: / 12-09-2013 / 16:19:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05_instrumentation_loop_count
    |m5|

    self class recompile:#f5: usingCompilerClass:InstrumentingCompiler.

    m5 := (self class compiledMethodAt:#f5:).

    self assert:(m5 hasBeenCalled not).
    self assert:(m5 blockInvocationInfo size == 1).

    "/ execute
    InstrumentationContext run:[
	self f5:10.
    ].

    self assert:(m5 hasBeenCalled).
    self assert:(m5 blockInvocationInfo first count == 10).
    self assert:(m5 hasBeenCalled).

    "
     self new test_05_instrumentation
    "
!

test_06_instrumentation_methodInvokationCount
    |m|

    self class recompile:#f6: usingCompilerClass:InstrumentingCompiler.
    self class recompile:#calledByF6 usingCompilerClass:InstrumentingCompiler.

    m := (self class compiledMethodAt:#calledByF6).

    self assert:(m hasBeenCalled not).
    self assert:(m methodInvocationInfo hasBeenCalled not).
    self assert:(m hasBeenCalled not).
    self assert:(m methodInvocationInfo count == 0).

    "/ execute
    InstrumentationContext run:[
	self f6:10.
    ].

    self assert:(m hasBeenCalled).
    self assert:(m methodInvocationInfo count == 10).

    "
     self new test_06_instrumentation_methodInvokationCount
    "
! !

!CoverageInstrumentationTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

