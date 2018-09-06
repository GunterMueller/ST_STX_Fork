"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BlockTest
	instanceVariableNames:'process'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!BlockTest methodsFor:'helpers - eqeq defect'!

g
    ^ True "/ the class here

    "Created: / 31-08-2007 / 17:40:37 / cg"
!

h
    ^ True "/ the class here

    "Created: / 31-08-2007 / 17:40:39 / cg"
! !

!BlockTest methodsFor:'helpers - mkreal defect'!

backgroundBlockWithMethodReturningHelper
    "/ had this bug in one situation:
    "/  a block was forked away
    "/  the method returns (its context is moved from the stack to the heap)
    "/  the block sees wrong method-vars

    |var1 var2 var3 var4 backgroundAction sema|

    sema := Semaphore new.
    
    backgroundAction := 
        [
            var1 := self getMeVar:1 sema:sema.
            self assert:(var1 = #[1]).
            var2 := self getMeVar:2 sema:sema.
            self assert:(var2 = #[2]).
            var3 := self getMeVar:3 sema:sema.
            self assert:(var3 = #[3]).
            var4 := self getMeVar:4 sema:sema.
            self assert:(var4 = #[4]).
            sema signal.
        ].
    process := backgroundAction newProcess.
    process priority:3.
    process resume.
    ^ sema

    "Created: / 02-08-2011 / 18:56:44 / cg"
!

getMeVar:arg sema:sema
    |t|

    t := ByteArray with:arg.
    sema wait.
%{
    __markInterrupted(__context);
%}.
    ^ t

    "Created: / 02-08-2011 / 18:57:20 / cg"
! !

!BlockTest methodsFor:'running'!

tearDown
    |p|

    (p := process) notNil ifTrue:[
        process := nil.
        p terminate. 
    ]

    "Created: / 03-08-2011 / 15:11:11 / cg"
! !

!BlockTest methodsFor:'tests - eqeq defects'!

testBlockWithEQEQ_1
    |b v|

    b := [ self g == self h ].
    v := b value.
    self assert:(v == true).


    "
     self new testBlockWithEQEQ_1
    "

    "Created: / 31-08-2007 / 17:41:59 / cg"
!

testBlockWithEQEQ_2
    |b v|

    b := [ 
%{
#ifdef FOO
%}.
            self thisIsNeverCalled.
%{
#endif
%}.
            self g == self h 
         ].
    v := b value.
    self assert:(v == true).


    "
     self new testBlockWithEQEQ_2
    "

    "Created: / 31-08-2007 / 17:42:02 / cg"
!

testBlockWithEQEQ_3
    |b p v|

    p := self.

    [

        b := [ 
%{
#ifdef FOO
%}.
            self thisIsNeverCalled.
%{
#endif
%}.
            p g == p h 
         ].
    ] value.

    v := b value.
    self assert:(v == true).


    "
     self new testBlockWithEQEQ_3
    "

    "Created: / 31-08-2007 / 17:44:07 / cg"
!

testBlockWithEQEQ_4
    |b p v Tmp|

    p := self.

    [

        b := [   |foo|
%{
#ifdef FOO
%}.
            foo := Timestamp now.
            Tmp isNil ifTrue:[
                Tmp := 'flags' copy.
            ] ifFalse:[
                ObjectMemory stopBackgroundCollector.
            ].
            self thisIsNeverCalled.
%{
#endif
%}.
            p g == p h 
         ].
    ] perform:((Base64Coder decode:'dmFsdWU=') asString asSymbol).

    v := b value.
    self assert:(v == true).


    "
     self new testBlockWithEQEQ_4
    "

    "Created: / 31-08-2007 / 17:44:38 / cg"
! !

!BlockTest methodsFor:'tests - mkreal defect'!

testBackgroundBlockWithMethodReturning
    "/ had this bug in one situation:
    "/  a block was forked away
    "/  the method returns (its context is moved from the stack to the heap)
    "/  the block sees wrong method-vars

    |sema|

    sema := self backgroundBlockWithMethodReturningHelper.
    sema signal.

    sema wait.

    "Created: / 02-08-2011 / 20:00:44 / cg"
! !

!BlockTest methodsFor:'tests - unwind actions'!

test_unwind1
    |trace firstEntry callCount ensureCount|

    trace := OrderedCollection new.
    firstEntry := true.
    callCount := ensureCount := 0.

    trace add:10.
    [:restart |
        trace add:15.
        [
            trace add:20.
            callCount := callCount + 1.
            firstEntry ifTrue:[
                trace add:21.
                firstEntry := false.
                restart value.
                trace add:22.
            ].
        ] ensure:[
            trace add:30.
            ensureCount := ensureCount + 1.
        ].
        trace add:40.
    ] valueWithRestart.

    self assert:(callCount == 2).
    self assert:(ensureCount == 2).
    self assert:(trace asArray = #(10 15 20 21 30 15 20 30 40)).
!

test_unwind2
    <context: #return>

    |mark trace firstEntry callCount ensureCount kon|

    kon := thisContext.
    mark isNil ifTrue:[
        mark := true.
        trace := OrderedCollection new.
        firstEntry := true.
        callCount := ensureCount := 0.
        trace add:5.
    ].

    trace add:10.

    [
        trace add:20.
        callCount := callCount + 1.
        firstEntry ifTrue:[
            trace add:21.
            firstEntry := false.
            kon unwindAndRestart.
            trace add:22.
        ].
    ] ensure:[
        trace add:30.
        ensureCount := ensureCount + 1.
    ].

    trace add:40.

    self assert:(callCount == 2).
    self assert:(ensureCount == 2).
    self assert:(trace asArray = #(5 10 20 21 30 10 20 30 40)).
! !

!BlockTest methodsFor:'varArgBlocks'!

getBlock1
     |b|

     b := [:arg | Transcript 
                        show:'invoked with arg:'; 
                        showCR:arg
          ].
     ^ b
!

getVarArgBlock1
     |b|

     b := [:argList | Transcript 
			show:'invoked with args:'; 
			showCR:argList
	  ] asVarArgBlock.
     ^ b


!

getVarArgBlock2
     |b|

     b := [:argList | Transcript 
			show:'invoked with args:'; 
			showCR:argList.
		      argList
	  ] asVarArgBlock.
     ^ b


!

getVarArgBlock3
     |b|

     b := [:argList | Transcript 
			show:'invoked with args:'; 
			showCR:argList.
		      argList size
	  ] asVarArgBlock.
     ^ b


!

testBlock1
    |b|

    b := self getBlock1.

    b code notNil ifTrue:[
        Transcript showCR:'before call: *** blocks code is jitted'
    ] ifFalse:[
        Transcript showCR:'before call: blocks code is NOT jitted'
    ].
    b value:nil.
    b code notNil ifTrue:[
        Transcript showCR:'after call: blocks code is jitted'
    ] ifFalse:[
        Transcript showCR:'after call: *** blocks code is NOT jitted'
    ].

    b value:#foo.
    b value:1.
    b value:2

    "
     self new testBlock1
    "
!

testVarArgBlock1
    |b|

    b := self getVarArgBlock1.

    b value.
    b code notNil ifTrue:[
        Transcript showCR:'blocks code is jitted'
    ] ifFalse:[
        Transcript showCR:'*** blocks code is NOT jitted'
    ].

    b value.
    b value:'arg1'.
    b value:'arg1' value:'arg2' value:'arg3' value:'arg4'

    "
     self new testVarArgBlock1
    "
!

testVarArgBlock2
    |b|

    b := self getVarArgBlock2.

    b value.
    b code notNil ifTrue:[
        Transcript showCR:'blocks code is jitted'
    ] ifFalse:[
        Transcript showCR:'*** blocks code is NOT jitted'
    ].

    self assert:( b value     = #() ).
    self assert:( (b value:1) = #(1) ).
    self assert:( (b value:1 value:2) = #(1 2) ).
    self assert:( (b value:1 value:2 value:3) = #(1 2 3) ).
    self assert:( (b value:1 value:2 value:3 value:4) = #(1 2 3 4) ).
    self assert:( (b valueWithArguments:#(1 2 3 4)) = #(1 2 3 4) ).

    self assert:( (b perform:#value)     = #()  ).
    self assert:( (b perform:#'value:' with:1) = #(1) ).
    self assert:( (b perform:#'value:value:' with:1 with:2) = #(1 2) ).
    self assert:( (b perform:#'value:value:value:' with:1 with:2 with:3) = #(1 2 3) ).
    self assert:( (b perform:#'value:value:value:value:' with:1 with:2 with:3 with:4) = #(1 2 3 4) ).
    self assert:( (b perform:#'valueWithArguments:' with:#(1 2 3 4)) = #(1 2 3 4) ).

    "
     self new testVarArgBlock2
    "
!

testVarArgBlock3
    |b|

    b := self getVarArgBlock3.

    b value.
    b code notNil ifTrue:[
        Transcript showCR:'blocks code is jitted'
    ] ifFalse:[
        Transcript showCR:'*** blocks code is NOT jitted'
    ].

    self assert:( b value     = 0  ).
    self assert:( (b value:1) = 1  ).
    self assert:( (b value:1 value:2) = 2 ).
    self assert:( (b value:1 value:2 value:3) = 3 ).
    self assert:( (b value:1 value:2 value:3 value:4) = 4 ).
    self assert:( (b valueWithArguments:#(1 2 3 4)) = 4 ).

    self assert:( (b perform:#value)     = 0  ).
    self assert:( (b perform:#'value:' with:1) = 1 ).
    self assert:( (b perform:#'value:value:' with:1 with:2) = 2 ).
    self assert:( (b perform:#'value:value:value:' with:1 with:2 with:3) = 3 ).
    self assert:( (b perform:#'value:value:value:value:' with:1 with:2 with:3 with:4) = 4 ).
    self assert:( (b perform:#'valueWithArguments:' with:#(1 2 3 4)) = 4 ).

    "
     self new testVarArgBlock3
    "
!

xtestAll
    self testVarArgBlocks.

    "
     self new xtestAll
    "
!

xtestVarArgBlocks
    self testVarArgBlock1.
    self testVarArgBlock2.
    self testVarArgBlock3.
! !

!BlockTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

