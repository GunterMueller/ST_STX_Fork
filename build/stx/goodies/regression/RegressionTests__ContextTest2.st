"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ContextTest2
	instanceVariableNames:'exceptionObject ttt'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

Notification subclass:#MyNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ContextTest2
!


!ContextTest2 methodsFor:'helpers'!

call10_1
    |local|

    ^ self call10_2:[:x | local := x].
!

call10_2:aBlock
    ^ self call10_3:aBlock
!

call10_3:aBlock
    aBlock value:thisContext.
    ^ thisContext sender sender
!

call11_1
    |local|

    self call11_2:[:x | local := x].
    ^ local value.
!

call11_2:aBlock
    ^ self call11_3:aBlock
!

call11_3:aBlock
    aBlock value:[thisContext].
    ^ thisContext sender sender
!

call9_1
    ^ self call9_2
!

call9_2
    ^ self call9_3
!

call9_3
    ttt := thisContext.
    ^ ttt sender sender
!

callRecursive: level withArg:argument thenDo:aBlock
    level == 0 ifTrue:[
	aBlock value:thisContext.
	^ self.
    ].
    self callRecursive:level-1 withArg:argument thenDo:aBlock

    "Created: / 07-03-2012 / 13:04:48 / cg"
!

downToNextSegmentThenDo:aBlock
    self
	downToSegment:(Processor activeProcess numberOfStackSegments + 1)
	thenDo:aBlock

    "
     self new testUnwind1
    "
!

downToNextSegmentThenUnwindAndDo:aBlock
    self
	downToSegment:(Processor activeProcess numberOfStackSegments + 1)
	thenUnwindAndDo:aBlock

    "
     self new testUnwind2
    "
!

downToSegment:nr thenDo:aBlock
    Processor activeProcess numberOfStackSegments >= nr ifTrue:[
	^  aBlock value
    ].
    self
	downToSegment:(Processor activeProcess numberOfStackSegments + 1)
	thenDo:aBlock

    "
     self new testUnwind1
    "
!

downToSegment:nr thenUnwindAndDo:aBlock
    Processor activeProcess numberOfStackSegments >= nr ifTrue:[
	aBlock home unwindThenDo: aBlock
    ].
    self
	downToSegment:(Processor activeProcess numberOfStackSegments + 1)
	thenUnwindAndDo:aBlock

    "
     self new testUnwind2
    "
!

exceptionObjectIs:ex
    exceptionObject := ex
!

getAssocWithContext
    ^ self getSendersContext -> #foo
!

getSendersContext
    ^ thisContext sender
!

raiseNotification
    NoHandlerError handle:[:ex |
	ex return
    ] do:[
	|t|

%{
  extern void *__contextToDebug__;
  __contextToDebug__ = (void *)__thisContext;
%}.
	t := MyNotification raiseRequestFrom:self.
%{
  extern void *__contextToDebug__;
  __contextToDebug__ = (void *)__thisContext;
%}.
	^ t
    ].
    ^ nil.
!

raiseWithContext
    AbortOperationRequest raiseWith:self getSendersContext
!

selfReferringContext
    |ref|

    ref := thisContext.
    ^ thisContext
!

senderContext
    ^ thisContext sender
!

senderReferringContext1
    ^ self senderReferringContext:thisContext
!

senderReferringContext2
    ^ self senderContext
!

senderReferringContext:aContext
    ^ aContext
! !

!ContextTest2 methodsFor:'tests'!

testContextRef1
    |assoc|

    assoc := self getAssocWithContext.
    ObjectMemory garbageCollect.

    "
     self new testContextRef1
    "
!

testContextRef10
    |val|

    val := self call10_1.
    ObjectMemory dumpObject:val.
    ObjectMemory dumpObject:(val varAt:1).
    ObjectMemory dumpObject:((val varAt:1) varAt:1).

    "
     self new testContextRef10
    "
!

testContextRef11
    |val|

    val := self call10_1.
    ObjectMemory dumpObject:val.

    "
     self new testContextRef11
    "
!

testContextRef2

    self getAssocWithContext.
    ObjectMemory garbageCollect.

    "
     self new testContextRef2
    "
!

testContextRef3
    AbortOperationRequest handle:[:ex |
    ] do:[
	self raiseWithContext.
    ].
    ObjectMemory garbageCollect.

    "
     self new testContextRef3
    "
!

testContextRef4
    |con|

    AbortOperationRequest handle:[:ex |
	ObjectMemory garbageCollect.
	con := ex parameter.
	ObjectMemory garbageCollect.
    ] do:[
	self raiseWithContext.
    ].
    ObjectMemory garbageCollect.

    "
     self new testContextRef4
    "
!

testContextRef5
    self selfReferringContext.
    ObjectMemory garbageCollect.

    "
     self new testContextRef5
    "
!

testContextRef6
    self senderReferringContext1.
    ObjectMemory garbageCollect.

    "
     self new testContextRef6
    "
!

testContextRef7
    self senderReferringContext2.
    ObjectMemory garbageCollect.

    "
     self new testContextRef7
    "
!

testContextRef8
    100000 timesRepeat:[
	self raiseNotification.
	self assert:(ObjectMemory spaceOf:exceptionObject suspendedContext) < 4.
    ].

    "
     self new testContextRef8
    "
!

testContextRef9
    |val|

    val := self call9_1.
    ObjectMemory dumpObject:val.
    ObjectMemory dumpObject:ttt.

    "
     self new testContextRef9
    "
!

testDisplayString1
    "the generated displayString must be a string (even if one of the args or receiver
     is a Twobytestring"

    Transcript showCR:'1'.
    self
	callRecursive:3
	withArg:((Unicode16String new:2)
				at:1 put:(Character value:16r151);
				at:2 put:(Character value:16rFF00);
				yourself)
	thenDo:[:context |
		    self assert:(context displayString bitsPerCharacter == 8).
		    self assert:(context fullPrintString bitsPerCharacter == 8).
	       ].

    "
     self new testDisplayString1
    "

    "Created: / 07-03-2012 / 13:03:32 / cg"
!

testProcess1
    |x set lockSet p arg|

    lockSet := Semaphore forMutualExclusion.
    set := Set new.

    x := 1 @ 1.

    arg := x.

    p := [
	[
	    lockSet critical:[set add:arg].
	    arg perform:#x .
	] ensure:[
	    lockSet critical:[set remove:arg].
	].
    ] fork.

    "
     self new testProcess1
    "
!

testProcess2
    |x set lockSet p|

    lockSet := Semaphore forMutualExclusion.
    set := Set new.

    x := 1 @ 1.

    p := [:arg |
	[
	    lockSet critical:[set add:arg].
	    arg perform:#x.
	] ensure:[
	    lockSet critical:[set remove:arg].
	].
    ] forkWith:(Array with:x).

    "
     self new testProcess2
    "
!

testProcess3
    |x set lockSet p|

    lockSet := Semaphore forMutualExclusion.
    set := Set new.

    x := 1 @ 1.

    p := [:arg |
	[
	    lockSet critical:[set add:arg].
	    arg perform:#x: with:1234.
	    lockSet critical:[set rehash].
	] ensure:[
	    lockSet critical:[set remove:arg].
	].
    ] forkWith:(Array with:x).

    "
     self new testProcess3
    "
!

testUnwind1
    Transcript showCR:'1'.
    self downToNextSegmentThenDo:[Transcript showCR:'2'. ^  self ].
    Transcript showCR:'3'.

    "
     self new testUnwind1
    "
!

testUnwind2
    Transcript showCR:'1'.
    self downToNextSegmentThenUnwindAndDo:[Transcript showCR:'2'. ^  self ].
    Transcript showCR:'3'.

    "
     self new testUnwind2
    "
!

testUnwind3
    <context: #return>

    |foo|

    Transcript showCR:'1'.
    self downToNextSegmentThenUnwindAndDo:[Transcript showCR:'2'. foo := #foo ].
    Transcript showCR:'3'.

    "
     self new testUnwind3
    "
!

testUnwind4
    |foo|

    Transcript showCR:'1'.
    self downToNextSegmentThenDo:[Transcript showCR:'2'. foo := #foo ].
    Transcript showCR:'3'.

    "
     self new testUnwind4
    "
! !

!ContextTest2::MyNotification class methodsFor:'raising'!

raiseRequestFrom:someone
    "raise a signal proceedable.
     The argument, something is passed both as parameter and originator."

    <context: #return>

    |ex|

    ex := self newException.
someone exceptionObjectIs:ex.
    ^ (ex
	suspendedContext:thisContext sender
	parameter:someone originator:someone)
	    raiseRequest.
! !

!ContextTest2 class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

