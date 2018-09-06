"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CompilerTest
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

Object subclass:#DummyClass
	instanceVariableNames:'applicationModel service request'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CompilerTest
!

Object subclass:#Schedule
	instanceVariableNames:'state'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CompilerTest
!

Object subclass:#State
	instanceVariableNames:'state'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CompilerTest::Schedule
!


!CompilerTest class methodsFor:'helpers'!

compile:code
    Class withoutUpdatingChangesDo:[
	^ Compiler
	    compile:code
	    forClass:self
	    install:false.
    ].
! !

!CompilerTest class methodsFor:'tests - constants'!

test_int1024
    ^ 1024

    "
     self test_int1024
    "

!

test_int1048576
    ^ 1048576
!

test_int128
    ^ 128

    "
     self test_int128
    "
!

test_int131072
    ^ 131072
!

test_int16384
    ^ 16384

    "
     self test_int16384
    "

!

test_int2048
    ^ 2048

    "
     self test_int2048
    "

!

test_int2097152
    ^ 2097152
!

test_int256
    ^ 256

    "
     self test_int256
    "

!

test_int262144
    ^ 262144
!

test_int32768
    ^ 32768

    "
     self test_int32768
    "

!

test_int4096
    ^ 4096

    "
     self test_int4096
    "

!

test_int512
    ^ 512

    "
     self test_int512
    "

!

test_int524288
    ^ 524288
!

test_int65536
    ^ 65536

    "
     self test_int65536
    "

!

test_int8192
    ^ 8192

    "
     self test_int8192
    "

!

test_intM128
    ^ -128
! !

!CompilerTest class methodsFor:'tests argument passing'!

ret0
    ^ 0

    "
     self ret0
     Time millisecondsToRun:[ 1000000 timesRepeat:[self ret0] ]
    "
!

ret1
    ^ 1

    "
     self ret1
     1000000 timesRepeat:[self ret1]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self ret1] ]
    "
!

retArg1:arg
    ^ arg

    "
     self retArg1:1
     1000000 timesRepeat:[self retArg1:1]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retArg1:1] ]
    "
!

retArg2:arg1 _:arg2
    ^ arg2

    "
     self retArg2:1 _:2
     1000000 timesRepeat:[self retArg2:1 _:2]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retArg2:1 _:2] ]
    "
!

retArg3:arg1 _:arg2 _:arg3
    ^ arg3

    "
     self retArg3:1 _:2 _:3
     1000000 timesRepeat:[self retArg3:1 _:2 _:3]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retArg3:1 _:2 _:3] ]
    "
!

retArg4:arg1 _:arg2 _:arg3 _:arg4
    ^ arg4

    "
     self retArg4:1 _:2 _:3 _:4
     1000000 timesRepeat:[self retArg4:1 _:2 _:3 _:4]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retArg4:1 _:2 _:3 _:4] ]
    "
!

retArg5:arg1 _:arg2 _:arg3 _:arg4 _:arg5
    ^ arg5

    "
     self retArg5:1 _:2 _:3 _:4 _:5
     1000000 timesRepeat:[self retArg5:1 _:2 _:3 _:4 _:5]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retArg5:1 _:2 _:3 _:4 _:5] ]
    "
!

retLiteral1
    ^ 'hello'

    "
     self retLiteral1
     1000000 timesRepeat:[self retLiteral1]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retLiteral1] ]
    "
!

retM1
    ^ -1

    "
     self retM1
     1000000 timesRepeat:[self retM1]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retM1] ]
    "
!

retSelf
    ^ self

    "
     self retSelf
     1000000 timesRepeat:[self retSelf]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self retSelf] ]
    "
! !

!CompilerTest methodsFor:'helpers'!

callEnsureWith2Returns
    [
	^ false
    ] ensure:[
	^ true
    ].
    ^ nil

    "Created: / 24-08-2010 / 12:51:50 / cg"
!

callEnsureWithException
    [
	ProceedableError raiseRequest
    ] ensure:[
	^ true
    ].
    ^ nil

    "Created: / 24-08-2010 / 12:54:07 / cg"
!

compile:someCode
    |m|

    m := self class compile:someCode.
    self assert:(m notNil and:[m ~~ #Error]).
    ^ m
!

size
    ^ 1
!

value:something
    value := something
! !

!CompilerTest methodsFor:'tests - booleans'!

_testAnd:arg1 _:arg2
    ^ arg1 & arg2

    "
     self new _testAnd:true _:true.
     self new _testAnd:true _:false.
     self new _testAnd:false _:true.
     self new _testAnd:false _:false.
     self new _testAnd:false _:nil.
     self new _testAnd:true _:nil.
     self new _testAnd:nil _:false.
     self new _testAnd:nil _:true.
     self new _testAnd:1234 _:true.
     self new _testAnd:1234 _:false.
     self new _testAnd:true _:1234.
     self new _testAnd:false _:1234.
    "
!

_testNot1:arg
    ^ arg not

    "
     self new _testNot1:true.
     self new _testNot1:false.
     self new _testNot1:1234.
    "
!

_testNot2:arg1 _:arg2
    ^ arg1 not & arg2 not

    "
     self new _testNot2:true  _:true.
     self new _testNot2:false _:true.
     self new _testNot2:true  _:false.
     self new _testNot2:false _:false.

     self new _testNot2:false _:1234.
     self new _testNot2:true  _:1234.
     self new _testNot2:1234  _:true.
     self new _testNot2:1234  _:false.
     self new _testNot2:1234  _:2345.
    "
!

_testNot3:arg1 _:arg2
    ^ arg1 not | arg2 not

    "
     self new _testNot3:true  _:true.
     self new _testNot3:false _:true.
     self new _testNot3:true  _:false.
     self new _testNot3:false _:false.

     self new _testNot3:false _:1234.
     self new _testNot3:true  _:1234.
     self new _testNot3:1234  _:true.
     self new _testNot3:1234  _:false.
     self new _testNot3:1234  _:2345.
    "
!

_testOr:arg1 _:arg2
    ^ arg1 | arg2

    "
     self new _testOr:true _:true.
     self new _testOr:true _:false.
     self new _testOr:false _:true.
     self new _testOr:false _:false.
     self new _testOr:false _:nil.
     self new _testOr:true _:nil.
     self new _testOr:nil _:false.
     self new _testOr:nil _:true.
     self new _testOr:1234 _:true.
     self new _testOr:1234 _:false.
     self new _testOr:true _:1234.
     self new _testOr:false _:1234.
    "
!

testAnd
     self assert:( ( self _testAnd:true _:true ) == true ).
     self assert:( ( self _testAnd:true _:false ) == false ).
     self assert:( ( self _testAnd:false _:true ) == false ).
     self assert:( ( self _testAnd:false _:false ) == false ).

     self assert:( ( self _testAnd:false _:nil ) == false ).
     self assert:( ( self _testAnd:true _:nil ) == nil ).
     self assert:( ( self _testAnd:false _:1234 ) == false ).
     self assert:( ( self _testAnd:true _:1234 ) == 1234 ).
     self should:[ self _testAnd:nil _:false  ] raise:Error.
     self should:[ self _testAnd:nil _:true  ] raise:Error.
     self should:[ self _testAnd:1234 _:false  ] raise:Error.
     self should:[ self _testAnd:1234 _:true  ] raise:Error.

    "
     self new testAnd
    "
!

testNot
     self assert:( ( self _testNot1:true ) == false ).
     self assert:( ( self _testNot1:false ) == true ).

     self should:[ self _testNot1:nil ] raise:Error.
     self should:[ self _testNot1:1234  ] raise:Error.


     self assert:( ( self _testNot2:true _:true) == false ).
     self assert:( ( self _testNot2:false _:true) == false ).
     self assert:( ( self _testNot2:true _:false) == false ).
     self assert:( ( self _testNot2:false _:false) == true ).

     self should:[ self _testNot2:false _:1234] raise:Error.
     self should:[ self _testNot2:true _:1234] raise:Error.
     self should:[ self _testNot2:1234 _:false] raise:Error.
     self should:[ self _testNot2:1234 _:true] raise:Error.
     self should:[ self _testNot2:1234 _:1234] raise:Error.
     self should:[ self _testNot2:nil _:false] raise:Error.
     self should:[ self _testNot2:nil _:true] raise:Error.
     self should:[ self _testNot2:nil _:1234] raise:Error.

     self assert:( ( self _testNot3:true _:true) == false ).
     self assert:( ( self _testNot3:false _:true) == true ).
     self assert:( ( self _testNot3:true _:false) == true ).
     self assert:( ( self _testNot3:false _:false) == true ).

     self should:[ self _testNot3:false _:1234] raise:Error.
     self should:[ self _testNot3:true _:1234] raise:Error.
     self should:[ self _testNot3:1234 _:false] raise:Error.
     self should:[ self _testNot3:1234 _:true] raise:Error.
     self should:[ self _testNot3:1234 _:1234] raise:Error.
     self should:[ self _testNot3:nil _:false] raise:Error.
     self should:[ self _testNot3:nil _:true] raise:Error.
     self should:[ self _testNot3:nil _:1234] raise:Error.

    "
     self new testNot
    "
!

testOr
     self assert:( ( self _testOr:true _:true ) == true ).
     self assert:( ( self _testOr:true _:false ) == true ).
     self assert:( ( self _testOr:false _:true ) == true ).
     self assert:( ( self _testOr:false _:false ) == false ).

     self assert:( ( self _testOr:false _:nil ) == nil ).
     self assert:( ( self _testOr:true _:nil ) == true ).
     self assert:( ( self _testOr:false _:1234 ) == 1234 ).
     self assert:( ( self _testOr:true _:1234 ) == true ).
     self should:[ self _testOr:nil _:false  ] raise:Error.
     self should:[ self _testOr:nil _:true  ] raise:Error.
     self should:[ self _testOr:1234 _:false  ] raise:Error.
     self should:[ self _testOr:1234 _:true  ] raise:Error.

    "
     self new testOr
    "
! !

!CompilerTest methodsFor:'tests - conditions'!

_testIf1:val
    |x|

    x := #foo.
    x := (val == #CursorRight or:[val == #CursorDown]) ifTrue:[1].
    ^ x

    "
     self new _testIf1:#CursorRight
     self new _testIf1:#CursorDown
     self new _testIf1:#Foo
     self new _testIf1:#CursorUp
     self new _testIf1:nil
     self new _testIf1:1
    "
!

_testIf2:val
    |x|

    x := #foo.
    x := (val == #CursorRight or:[val == #CursorDown]) ifTrue:1.
    ^ x

    "
     self new _testIf2:#CursorRight
     self new _testIf2:#CursorDown
     self new _testIf2:#Foo
     self new _testIf2:#CursorUp
     self new _testIf2:nil
     self new _testIf2:1
    "
!

_testIf3:val
    |x|

    x := #foo.
    x := val isInteger ifTrue:1.
    ^ x

    "
     self new _testIf3:#CursorRight
     self new _testIf3:#CursorDown
     self new _testIf3:#Foo
     self new _testIf3:#CursorUp
     self new _testIf3:nil
     self new _testIf3:1
    "
!

_testIf4:val
    ^ val isNil

    "
     self new _testIf4:#CursorRight
     self new _testIf4:1
     self new _testIf4:nil
    "
!

_testIf4:val1 with:val2
    ^ val1 == nil and:[val2 == nil]

    "
     self new _testIf4:#CursorRight with:#CursorDown
     self new _testIf4:#CursorRight with:nil
     self new _testIf4:nil with:#CursorDown
     self new _testIf4:nil with:nil
    "
!

_testIf5:val
    ^ val isNil ifTrue:[
	1
    ]

    "
     self new _testIf5:#CursorRight
     self new _testIf5:1
     self new _testIf5:nil
    "
!

_testIf5:val1 with:val2
    ^ val1 isNil and:[val2 isNil]

    "
     self new _testIf5:#CursorRight with:#CursorDown
     self new _testIf5:#CursorRight with:nil
     self new _testIf5:nil with:#CursorDown
     self new _testIf5:nil with:nil
    "
!

_testIf6:val
    ^ val isNil ifTrue:1

    "
     self new _testIf6:#CursorRight
     self new _testIf6:1
     self new _testIf6:nil
    "
!

_testIf6b:val
    val isNil ifTrue:1

    "
     self new _testIf6b:#CursorRight
     self new _testIf6b:1
     self new _testIf6b:nil
    "
!

_testIf6c:val
    val isNil ifTrue:[
	1

	"
	 self new _testIf6c:#CursorRight
	 self new _testIf6c:1
	 self new _testIf6c:nil
	"
    ]
!

_testIf6d:val
    ^ val isNil ifTrue:val

    "
     self new _testIf6d:#CursorRight
     self new _testIf6d:1
     self new _testIf6d:nil
    "
!

_testIf6e:val
    ^ val isNil ifFalse:val

    "
     self new _testIf6e:['hello']
     self new _testIf6e:('hello' asValue)
     self new _testIf6e:#CursorRight
     self new _testIf6e:1
     self new _testIf6e:nil
    "
!

_testIf7:val
    ^ val ? 1

    "
     self new _testIf7:#CursorRight
     self new _testIf7:1
     self new _testIf7:nil
    "
!

_testIfElse1:val
    |x|

    x := (val == #CursorRight or:[val == #CursorDown]) ifTrue:[
		1
	    ] ifFalse:[-1].
    ^ x

    "
     self new _testIfElse1:#CursorRight
     self new _testIfElse1:#CursorDown
     self new _testIfElse1:#Foo
     self new _testIfElse1:#CursorUp
     self new _testIfElse1:nil
     self new _testIfElse1:1
    "
!

_testIfElse2:val
    |x|

    x := (val == #CursorRight or:[val == #CursorDown]) ifTrue:1 ifFalse:-1.
    ^ x

    "
     self new _testIfElse2:#CursorRight
     self new _testIfElse2:#CursorDown
     self new _testIfElse2:#Foo
     self new _testIfElse2:#CursorUp
     self new _testIfElse2:nil
     self new _testIfElse2:1
    "
!

_testIfElse3:val
    |x|

    x := (val == #CursorRight or:[val isInteger]) ifTrue:1 ifFalse:-1.
    ^ x

    "
     self new _testIfElse3:#CursorRight
     self new _testIfElse3:#CursorDown
     self new _testIfElse3:#Foo
     self new _testIfElse3:#CursorUp
     self new _testIfElse3:nil
     self new _testIfElse3:1
    "
!

_testIfElse4:val
    |x|

    x := #foo.
    x := val isInteger ifTrue:1 ifFalse:-1.
    ^ x

    "
     self new _testIfElse4:#CursorRight
     self new _testIfElse4:#CursorDown
     self new _testIfElse4:#Foo
     self new _testIfElse4:#CursorUp
     self new _testIfElse4:nil
     self new _testIfElse4:1
    "
!

_testIfElse5:val
    |x|

    x := #foo.
    x := val ifNil:1 ifNotNil:-1.
    ^ x

    "
     self new _testIfElse5:#CursorUp
     self new _testIfElse5:nil
     self new _testIfElse5:1
    "
!

_testIfElse6:val
    |x|

    x := #foo.
    x := val ifNil:[1] ifNotNil:[-1].
    ^ x

    "
     self new _testIfElse6:#CursorUp
     self new _testIfElse6:nil
     self new _testIfElse6:1
    "
!

_testIfElse7:val with:val1 with:val2
    |x|

    x := #foo.
    x := val ifNil:val1 ifNotNil:val2.
    ^ x

    "
     self new _testIfElse7:#CursorUp with:1 with:2
     self new _testIfElse7:nil       with:1 with:2
     self new _testIfElse7:1         with:1 with:2
    "
!

testIf
    self assert:(self _testIf1:#CursorRight) == 1.
    self assert:(self _testIf1:#CursorDown) == 1.
    self assert:(self _testIf1:#Foo) == nil.
    self assert:(self _testIf1:#CursorUp) == nil.
    self assert:(self _testIf1:nil) == nil.
    self assert:(self _testIf1:1) == nil.

    self assert:(self _testIf2:#CursorRight) == 1.
    self assert:(self _testIf2:#CursorDown) == 1.
    self assert:(self _testIf2:#Foo) == nil.
    self assert:(self _testIf2:#CursorUp) == nil.
    self assert:(self _testIf2:nil) == nil.
    self assert:(self _testIf2:1) == nil.

    self assert:(self _testIf3:#CursorRight) == nil.
    self assert:(self _testIf3:#CursorDown) == nil.
    self assert:(self _testIf3:#Foo) == nil.
    self assert:(self _testIf3:#CursorUp) == nil.
    self assert:(self _testIf3:nil) == nil.
    self assert:(self _testIf3:1) == 1.

    self assert:(self _testIf4:#CursorRight) == false.
    self assert:(self _testIf4:nil) == true.
    self assert:(self _testIf4:1) == false.

    self assert:(self _testIf4:#CursorRight with:#CursorDown) == false.
    self assert:(self _testIf4:#CursorRight with:nil) == false.
    self assert:(self _testIf4:nil with:#CursorDown) == false.
    self assert:(self _testIf4:nil with:nil) == true.

    self assert:(self _testIf5:#CursorRight) == nil.
    self assert:(self _testIf5:nil) == 1.
    self assert:(self _testIf5:1) == nil.

    self assert:(self _testIf5:#CursorRight with:#CursorDown) == false.
    self assert:(self _testIf5:#CursorRight with:nil) == false.
    self assert:(self _testIf5:nil with:#CursorDown) == false.
    self assert:(self _testIf5:nil with:nil) == true.

    self assert:(self _testIf6:#CursorRight) == nil.
    self assert:(self _testIf6:nil) == 1.
    self assert:(self _testIf6:1) == nil.
    self assert:(self _testIf6d:#CursorRight) == nil.
    self assert:(self _testIf6d:nil) == nil.
    self assert:(self _testIf6d:1) == nil.
    self assert:(self _testIf6e:#CursorRight) == #CursorRight.
    self assert:(self _testIf6e:nil) == nil.
    self assert:(self _testIf6e:1) == 1.
    self assert:(self _testIf7:#CursorRight) == #CursorRight.
    self assert:(self _testIf7:nil) == 1.
    self assert:(self _testIf7:1) == 1.

    self assert:(self _testIfElse1:#CursorRight) == 1.
    self assert:(self _testIfElse1:#CursorDown) == 1.
    self assert:(self _testIfElse1:#Foo) == -1.
    self assert:(self _testIfElse1:#CursorUp) == -1.
    self assert:(self _testIfElse1:nil) == -1.
    self assert:(self _testIfElse1:1) == -1.

    self assert:(self _testIfElse2:#CursorRight) == 1.
    self assert:(self _testIfElse2:#CursorDown) == 1.
    self assert:(self _testIfElse2:#Foo) == -1.
    self assert:(self _testIfElse2:#CursorUp) == -1.
    self assert:(self _testIfElse2:nil) == -1.
    self assert:(self _testIfElse2:1) == -1.

    self assert:(self _testIfElse3:#CursorRight) == 1.
    self assert:(self _testIfElse3:#CursorDown) == -1.
    self assert:(self _testIfElse3:#Foo) == -1.
    self assert:(self _testIfElse3:#CursorUp) == -1.
    self assert:(self _testIfElse3:nil) == -1.
    self assert:(self _testIfElse3:1) == 1.

    self assert:(self _testIfElse4:#CursorRight) == -1.
    self assert:(self _testIfElse4:#CursorDown) == -1.
    self assert:(self _testIfElse4:#Foo) == -1.
    self assert:(self _testIfElse4:#CursorUp) == -1.
    self assert:(self _testIfElse4:nil) == -1.
    self assert:(self _testIfElse4:1) == 1.

    self assert:(self _testIfElse5:#CursorUp) == -1.
    self assert:(self _testIfElse5:nil) == 1.
    self assert:(self _testIfElse5:1) == -1.

    self assert:(self _testIfElse6:#CursorUp) == -1.
    self assert:(self _testIfElse6:nil) == 1.
    self assert:(self _testIfElse6:1) == -1.

    self assert:(self _testIfElse7:#CursorUp with:1 with:2) == 2.
    self assert:(self _testIfElse7:nil       with:1 with:2) == 1.
    self assert:(self _testIfElse7:1         with:1 with:2) == 2.

    "
     self basicNew testIf
    "
! !

!CompilerTest methodsFor:'tests - constant folding'!

_testFloat_pi
    ^ Float pi
!

_testFloat_unity
    ^ Float unity
!

_testFloat_zero
    ^ Float zero
!

_testSmalltalk_if_else_isSmalltalkX
    Smalltalk isSmalltalkX ifTrue:[
	^ 'yes'
    ] ifFalse:[^ 'no']
!

_testSmalltalk_if_else_isVisualWorks
    Smalltalk isVisualWorks ifTrue:[
	^ 'yes'
    ] ifFalse:[^ 'no']
!

_testSmalltalk_if_isSmalltalkX
    Smalltalk isSmalltalkX ifTrue:[
	^ 'yes'
    ].
    ^ 'no'
!

_testSmalltalk_if_isSqueak
    Smalltalk isSqueak ifTrue:[
	^ 'yes'
    ].
    ^ 'no'
!

_testSmalltalk_if_isVisualWorks
    Smalltalk isVisualWorks ifTrue:[
	^ 'yes'
    ].
    ^ 'no'
!

_testSmalltalk_isSmalltalkX
    ^ Smalltalk isSmalltalkX
!

_testSmalltalk_isSqueak
    ^ Smalltalk isSqueak
!

_testSmalltalk_isVisualAge
    ^ Smalltalk isVisualAge
!

_testSmalltalk_isVisualWorks
    ^ Smalltalk isVisualWorks
!

_testUnaryFolding
    self _testFloat_pi ~= (Float perform:#pi) ifTrue:[
	self halt
    ].
    self _testFloat_unity ~= (Float perform:#unity) ifTrue:[
	self halt
    ].
    self _testFloat_zero ~= (Float perform:#zero) ifTrue:[
	self halt
    ].
    self _testSmalltalk_isSmalltalkX ~= (Smalltalk perform:#isSmalltalkX) ifTrue:[
	self halt
    ].
    self _testSmalltalk_isSqueak ~= (Smalltalk perform:#isSqueak) ifTrue:[
	self halt
    ].
    self _testSmalltalk_isVisualWorks ~= (Smalltalk perform:#isVisualWorks) ifTrue:[
	self halt
    ].
    self _testSmalltalk_isVisualAge ~= (Smalltalk perform:#isVisualAge) ifTrue:[
	self halt
    ]

    "
     self basicNew _testUnaryFolding
    "
! !

!CompilerTest methodsFor:'tests - context setup'!

_testContextA
    ObjectMemory dumpObject:thisContext

    "
     self new _testContextA
    "
!

_testContextB
    ObjectMemory dumpObject:thisContext sender

    "
     self new _testContextB
    "
!

_testContextC
    thisContext fullPrintAll

    "
     self new _testContextC
    "
!

_testContextD
    self _testContextB

    "
     self new _testContextD
    "
!

_testContextE
    ^ thisContext sender

    "
     self new _testContextE
    "
!

_testContextF
    ^ self _testContextE

    "
     self new _testContextF
    "
!

_testSend0
    ^ 9999
!

_testSend0B:arg
    ^ arg
!

_testSend1
    ^ self _testSend0

    "
     self new testSend1
    "
!

_testSend1B
    ^ self _testSend0B:1234

    "
     self new testSend1B
    "
!

_testSend1C:arg
    ^ self _testSend0B:arg

    "
     self new testSend1C:9998
    "
!

_testSend2
    self _testContextB

    "
     self new testSend2
    "
!

_testSend3
    self _testContextC

    "
     self new testSend3
    "
!

retArgWithFrameA:arg
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    ^ arg

    "
     self new retArgWithFrameA:999
    "
!

retArgWithFrameB:arg
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    self retSelf.

    ^ arg

    "
     self new retArgWithFrameB:9999
    "
!

retLocal
    |a|

    a := 0.
    ^ a

    "
     self new retLocal
     1000000 timesRepeat:[self new retInstVar]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

retLocalB
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    ^ a

    "
     self new retLocalB
     1000000 timesRepeat:[self new retLocalB]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retLocalB] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

retLocalC
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    ^ b

    "
     self new retLocalC
     1000000 timesRepeat:[self new retInstVar]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

retLocalD
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    ^ c

    "
     self new retLocalD
     1000000 timesRepeat:[self new retInstVar]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

retLocalE
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    ^ self

    "
     self new retLocalE
     1000000 timesRepeat:[self new retInstVar]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

retLocalF
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    self retSelf.

    ^ a

    "
     self new retLocalF
    "



!

retLocalG
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    self retSelf.

    ^ b

    "
     self new retLocalG
    "



!

retLocalH
    |a b c|

    a := 0.
    b := 1.
    c := 2.
    self retSelf.

    ^ c

    "
     self new retLocalH
    "



!

retSelf


! !

!CompilerTest methodsFor:'tests - entry'!

ilcMissCheck



    "
     (Array with:self new with:nil) do:[:el | el size printCR.].
    "



! !

!CompilerTest methodsFor:'tests - inlined'!

_test_even:arg
    ^ arg even

    "
     self new _test_even:nil
     self new _test_even:123
     self new _test_even:122
     self new _test_even:(100 factorial)
    "
!

_test_isInteger:arg
    ^ arg isInteger

    "
     self new _test_isInteger:nil
     self new _test_isInteger:123
     self new _test_isInteger:(100 factorial)
    "
!

_test_isNotInteger:arg
    ^ arg isInteger not

    "
     self new _test_isNotInteger:nil
     self new _test_isNotInteger:123
     self new _test_isNotInteger:(100 factorial)
    "
!

_test_max1:arg1 _:arg2
    ^ arg1 max:arg2

    "
     self new _test_max1:nil _:nil
     self new _test_max1:1 _:nil
     self new _test_max1:nil _:1
     self new _test_max1:1 _:2
     self new _test_max1:2 _:1

     self new _test_max1:1.0 _:nil
     self new _test_max1:nil _:1.0
     self new _test_max1:1.0 _:2.0
     self new _test_max1:2.0 _:1.0

     self new _test_max1:1.0 _:2
     self new _test_max1:2.0 _:1
     self new _test_max1:1 _:2.0
     self new _test_max1:2 _:1.0
    "
!

_test_max2:arg
    ^ 1 max:arg

    "
     self new _test_max2:nil
     self new _test_max2:0
     self new _test_max2:1
     self new _test_max2:2

     self new _test_max2:0.0
     self new _test_max2:1.0
     self new _test_max2:2.0
    "
!

_test_max3:arg
    |var|

    var := Array new:10.
    ^ 1 max:arg

    "
     self new _test_max3:nil
     self new _test_max3:0
     self new _test_max3:1
     self new _test_max3:2

     self new _test_max3:0.0
     self new _test_max3:1.0
     self new _test_max3:2.0
    "
!

_test_max4:arg
    |var|

    var := Array new:10.
    ^ arg max:1

    "
     self new _test_max4:nil
     self new _test_max4:0
     self new _test_max4:1
     self new _test_max4:2

     self new _test_max4:0.0
     self new _test_max4:1.0
     self new _test_max4:2.0
    "
!

_test_min1:arg1 _:arg2
    ^ arg1 min:arg2

    "
     self new _test_min1:nil _:nil
     self new _test_min1:1 _:nil
     self new _test_min1:nil _:1
     self new _test_min1:1 _:2
     self new _test_min1:2 _:1

     self new _test_min1:1.0 _:nil
     self new _test_min1:nil _:1.0
     self new _test_min1:1.0 _:2.0
     self new _test_min1:2.0 _:1.0

     self new _test_min1:1.0 _:2
     self new _test_min1:2.0 _:1
     self new _test_min1:1 _:2.0
     self new _test_min1:2 _:1.0
    "
!

_test_min2:arg
    ^ 1 min:arg

    "
     self new _test_min2:nil
     self new _test_min2:0
     self new _test_min2:1
     self new _test_min2:2

     self new _test_min2:0.0
     self new _test_min2:1.0
     self new _test_min2:2.0
    "
!

_test_min3:arg
    |var|

    var := Array new:10.
    ^ 1 min:arg

    "
     self new _test_min3:nil
     self new _test_min3:0
     self new _test_min3:1
     self new _test_min3:2

     self new _test_min3:0.0
     self new _test_min3:1.0
     self new _test_min3:2.0
    "
!

_test_min4:arg
    |var|

    var := Array new:10.
    ^ arg min:1

    "
     self new _test_min4:nil
     self new _test_min4:0
     self new _test_min4:1
     self new _test_min4:2

     self new _test_min4:0.0
     self new _test_min4:1.0
     self new _test_min4:2.0
    "
!

_test_odd:arg
    ^ arg odd

    "
     self new _test_odd:nil
     self new _test_odd:123
     self new _test_odd:122
     self new _test_odd:(100 factorial)
    "
!

_test_size
    ^ value size

    "
     (self new value:(Array new:2)) _test_size
     (self new value:(OrderedCollection new:2)) _test_size
    "
! !

!CompilerTest methodsFor:'tests - instvar access'!

retInstVar
    ^ value

    "
     self new retInstVar
     1000000 timesRepeat:[self new retInstVar]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new retInstVar] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i retInstVar
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     1000000 timesRepeat:[i retInstVar]
    "

    "
     |i|
     i := self new.
     i instVarAt:1 put:12345.
     Time millisecondsToRun:[ 1000000 timesRepeat:[i retInstVar] ]
    "


!

setInstVarA
    value := 123

    "
     self new setInstVarA; instVarAt:1
     1000000 timesRepeat:[self new setInstVarA]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new setInstVarA] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i setInstVarA.
     i instVarAt:1
    "



!

setInstVarB
    value := 'hello'

    "
     self new setInstVarB; instVarAt:1
     1000000 timesRepeat:[self new setInstVarB]
     Time millisecondsToRun:[ 1000000 timesRepeat:[self new setInstVarB] ]
    "

    "
     |i|

     i := self new.
     i instVarAt:1 put:12345.
     i setInstVarB.
     i instVarAt:1
    "



! !

!CompilerTest methodsFor:'tests - literals'!

testLiterals
    "
     self new testLiterals
    "
    |m|

    "/ literals must be present, even if code has been optimized away
    "/ (otherwise, searches do not work correctly)

    m := self compile:'foo:arg |v| ^ (v ~~ 0) not'.
    self assert:(m literals includesIdentical:#'~~').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg |v| ^ (v == 0) not'.
    self assert:(m literals includesIdentical:#'==').
    self assert:(m literals includesIdentical:#'not').


    m := self compile:'foo:arg ^ arg not'.
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ arg notNil'.
    self assert:(m literals includesIdentical:#'notNil').
    m := self compile:'foo:arg ^ arg isNil'.
    self assert:(m literals includesIdentical:#'isNil').


    m := self compile:'foo:arg |v| v := v+1'.
    self assert:(m literals includesIdentical:#'+').

    m := self compile:'foo:arg |v| v := v-1'.
    self assert:(m literals includesIdentical:#'-').


    m := self compile:'foo:arg |v| v := v not'.
    self assert:(m literals includesIdentical:#'not').


    m := self compile:'foo:arg ^ arg ifTrue:1'.
    self assert:(m literals includesIdentical:#'ifTrue:').

    m := self compile:'foo:arg ^ arg ifFalse:1'.
    self assert:(m literals includesIdentical:#'ifFalse:').

    m := self compile:'foo:arg ^ arg ifTrue:1 ifFalse:2'.
    self assert:(m literals includesIdentical:#'ifTrue:ifFalse:').

    m := self compile:'foo:arg ^ arg ifFalse:1 ifTrue:2'.
    self assert:(m literals includesIdentical:#'ifFalse:ifTrue:').


    m := self compile:'foo:arg ^ arg isNil ifTrue:1'.
    self assert:(m literals includesIdentical:#'ifTrue:').
    self assert:(m literals includesIdentical:#'isNil').

    m := self compile:'foo:arg ^ arg isNil ifFalse:1'.
    self assert:(m literals includesIdentical:#'ifFalse:').
    self assert:(m literals includesIdentical:#'isNil').

    m := self compile:'foo:arg ^ arg isNil ifTrue:1 ifFalse:2'.
    self assert:(m literals includesIdentical:#'ifTrue:ifFalse:').
    self assert:(m literals includesIdentical:#'isNil').

    m := self compile:'foo:arg ^ arg isNil ifFalse:1 ifTrue:2'.
    self assert:(m literals includesIdentical:#'ifFalse:ifTrue:').
    self assert:(m literals includesIdentical:#'isNil').


    m := self compile:'foo:arg ^ arg notNil ifTrue:1'.
    self assert:(m literals includesIdentical:#'ifTrue:').
    self assert:(m literals includesIdentical:#'notNil').

    m := self compile:'foo:arg ^ arg notNil ifFalse:1'.
    self assert:(m literals includesIdentical:#'ifFalse:').
    self assert:(m literals includesIdentical:#'notNil').

    m := self compile:'foo:arg ^ arg notNil ifTrue:1 ifFalse:2'.
    self assert:(m literals includesIdentical:#'ifTrue:ifFalse:').
    self assert:(m literals includesIdentical:#'notNil').

    m := self compile:'foo:arg ^ arg notNil ifFalse:1 ifTrue:2'.
    self assert:(m literals includesIdentical:#'ifFalse:ifTrue:').
    self assert:(m literals includesIdentical:#'notNil').


    m := self compile:'foo:arg ^ arg not ifTrue:1'.
    self assert:(m literals includesIdentical:#'ifTrue:').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ arg not ifFalse:1'.
    self assert:(m literals includesIdentical:#'ifFalse:').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ arg not ifTrue:1 ifFalse:2'.
    self assert:(m literals includesIdentical:#'ifTrue:ifFalse:').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ arg not ifFalse:1 ifTrue:2'.
    self assert:(m literals includesIdentical:#'ifFalse:ifTrue:').
    self assert:(m literals includesIdentical:#'not').


    m := self compile:'foo:arg ^ arg and:[true]'.
    self assert:(m literals includesIdentical:#'and:').

    m := self compile:'foo:arg ^ arg not and:[true]'.
    self assert:(m literals includesIdentical:#'and:').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ arg or:[true]'.
    self assert:(m literals includesIdentical:#'or:').

    m := self compile:'foo:arg ^ arg not or:[true]'.
    self assert:(m literals includesIdentical:#'or:').
    self assert:(m literals includesIdentical:#'not').

    m := self compile:'foo:arg ^ (arg or:[true]) ifTrue:[1234]'.
    self assert:(m literals includesIdentical:#'or:').
    self assert:(m literals includesIdentical:#'ifTrue:').

    m := self compile:'foo:arg ^ (arg or:[true]) ifFalse:[1234]'.
    self assert:(m literals includesIdentical:#'or:').
    self assert:(m literals includesIdentical:#'ifFalse:').

    m := self compile:'foo:arg ^ (arg or:[true]) ifTrue:1 ifFalse:2'.
    self assert:(m literals includesIdentical:#'or:').
    self assert:(m literals includesIdentical:#'ifTrue:ifFalse:').

    m := self compile:'foo:arg ^ (arg or:[true]) ifFalse:1 ifTrue:2'.
    self assert:(m literals includesIdentical:#'or:').
    self assert:(m literals includesIdentical:#'ifFalse:ifTrue:').


    m := self compile:'foo:arg ^ [ ] loop'.
    self assert:(m literals includesIdentical:#'loop').

    m := self compile:'foo:arg ^ [ ] repeat'.
    self assert:(m literals includesIdentical:#'repeat').

    m := self compile:'foo:arg ^ arg ? 123'.
    self assert:(m literals includesIdentical:#'?').

    "
     self new testLiterals
    "
! !

!CompilerTest methodsFor:'tests - method calls'!

addDumpingMethodForSelfIsLostBug
    |code mthd|

    code :=
'_x
    "/ ObjectMemory dumpSender.
    "/ request nextPutAll: ''a''.
    ObjectMemory garbageCollect.
    ObjectMemory dumpSender.
    "/ request nextPutAll: ''b''.
'.

    Class withoutUpdatingChangesDo:[
	mthd := (Smalltalk at:#Compiler)
		    compile:code
		    in:DummyClass
		    notifying:nil
		    ifFail:[self error].
    ].
    ^ mthd
!

addHaltingMethodForSelfIsLostBug
    |code mthd|

    code :=
'_x
    request nextPutAll: ''a''.
    self halt.
    ObjectMemory garbageCollect.
    self halt.
    request nextPutAll: ''b''.
'.

    Class withoutUpdatingChangesDo:[
	mthd := (Smalltalk at:#Compiler)
		    compile:code
		    in:DummyClass
		    notifying:nil
		    ifFail:[self error].
    ].
    ^ mthd
!

addMethodForSelfIsLostBug
    |code mthd|

    code :=
'_x
    request nextPutAll: ''a''.
    ObjectMemory garbageCollect.
    request nextPutAll: ''b''.
'.

    Class withoutUpdatingChangesDo:[
	mthd := (Smalltalk at:#Compiler)
		    compile:code
		    in:DummyClass
		    notifying:nil
		    ifFail:[self error].
    ].
    ^ mthd
!

removeMethodForSelfIsLostBug
    Class withoutUpdatingChangesDo:[
	DummyClass removeSelector:#'_x'.
    ].
!

test_selfIsLost1
    |mthd rcvr retVal str|

    str := '' writeStream.

    mthd := self addMethodForSelfIsLostBug.
    self removeMethodForSelfIsLostBug.
    rcvr := DummyClass new.
    rcvr request:str.
    retVal := mthd valueWithReceiver:rcvr arguments:#().
    self assert:(retVal == rcvr).
    self assert:(str contents = 'ab').

    "
     self new test_selfIsLost1
    "
!

test_selfIsLost2
    |mthd rcvr retVal str|

    str := '' writeStream.

    mthd := self addMethodForSelfIsLostBug.
    rcvr := DummyClass new.
    rcvr request:str.

    retVal := rcvr perform:#'_x'.

    self removeMethodForSelfIsLostBug.

    self assert:(retVal == rcvr).
    self assert:(str contents = 'ab').

    "
     self new test_selfIsLost2
    "
!

test_selfIsLost3
    |mthd rcvr retVal|

    mthd := DummyClass compiledMethodAt:#'_y0'.

    rcvr := DummyClass new.

    retVal := mthd valueWithReceiver:rcvr arguments:#().
    self assert:(retVal == rcvr).

    "
     self new test_selfIsLost3
    "
!

test_selfIsLost4
    |mthd rcvr retVal|

    mthd := DummyClass compiledMethodAt:#'_y1:'.

    rcvr := DummyClass new.

    retVal := mthd valueWithReceiver:rcvr arguments:(Array with:rcvr).
    self assert:(retVal == rcvr).

    "
     self new test_selfIsLost4
    "
!

xtest_selfIsLost5
    |mthd rcvr retVal str|

    str := '' writeStream.

    mthd := self addHaltingMethodForSelfIsLostBug.
    self removeMethodForSelfIsLostBug.
    rcvr := DummyClass new.
    rcvr request:str.
    retVal := mthd valueWithReceiver:rcvr arguments:#().

    "
     self new xtest_selfIsLost5
    "
!

xtest_selfIsLost6
    |mthd rcvr retVal str|

    str := '' writeStream.

    mthd := self addDumpingMethodForSelfIsLostBug.
    self removeMethodForSelfIsLostBug.
    rcvr := DummyClass new.
    rcvr request:str.
    retVal := mthd valueWithReceiver:rcvr arguments:#().

    "
     self new xtest_selfIsLost6
    "
! !

!CompilerTest methodsFor:'tests - parsing'!

testParseBadLiteral
    self should:[self class compile:'foo ^ #( a b ( c d (' ] raise:Parser parseErrorSignal.
    self should:[self class compile:'foo ^ #( a b ( c d ()'] raise:Parser parseErrorSignal.
    self should:[self class compile:'foo ^ #( a b ( c d ())'] raise:Parser parseErrorSignal.
    self assert:((self class compile:'foo ^ #( a b ( c d ()))') ~~ #Error).

    "
     self new testParseBadLiteral
    "
!

testParseExtendedSyntax
    |compiler val|

    compiler := Parser new.
    val := compiler evaluate:' ''12\t34'' '.
    self assert:( val = '12\t34' ) .
    val := compiler evaluate:' ''12\u161634'' '.
    self assert:( val = '12\u161634' ) .

    compiler parserFlags allowExtendedSTXSyntax:true.
    val := compiler evaluate:' ''12\t34'' '.
    self assert:( val = ('12' , Character tab , '34' )) .
    val := compiler evaluate:' ''12\u161634'' '.
    self assert:( val = ('12' , (Character value:16r1616) , '34' )) .

    "
     self new testParseExtendedSyntax
    "
!

xtestParseAllMethodsInTheSystem
    |parser|

    Smalltalk allClassesDo:[:eachClass |
	Transcript showCR:'parsing all in ',eachClass name.
	eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	    parser := Parser parseMethod:(mthd source) in:(mthd mclass).
	    self assert:(parser ~~ #Error and:[parser tree ~= #Error and:[parser errorFlag ~~ true]]).
	].
    ].

    "
     self new xtestParseAllMethodsInTheSystem
    "
!

xtestRecompileAllMethodsInTheSystem
    |parser|

    Smalltalk allClassesDo:[:eachClass |
	Transcript showCR:'parsing all in ',eachClass name.
	eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	    parser := Parser parseMethod:(mthd source) in:(mthd mclass).
	    self assert:(parser ~~ #Error and:[parser tree ~= #Error and:[parser errorFlag ~~ true]]).
	    parser hasPrimitiveCode ifFalse:[
		mthd mclass recompile:sel
	    ].
	].
    ].

    "
     self new xtestRecompileAllMethodsInTheSystem
    "
! !

!CompilerTest methodsFor:'tests - return'!

test_bad_return2
    |w a p|

    w := ParserFlags warnAboutPossibleSTCCompilationProblems.
    a := ParserFlags allowPossibleSTCCompilationProblems.
    p := ParserFlags warnPlausibilityChecks.

    [
	ParserFlags warnPlausibilityChecks:true.
	ParserFlags warnAboutPossibleSTCCompilationProblems:true.
	ParserFlags allowPossibleSTCCompilationProblems:false.
	self should:[
	    self
		compile:'
foo:arg
^ arg
    ifTrue:[^ 1]
    ifFalse:[2]
'
	    ]
	    raise:Parser parseErrorSignal
    ] ensure:[
	ParserFlags warnAboutPossibleSTCCompilationProblems:w.
	ParserFlags allowPossibleSTCCompilationProblems:a.
	ParserFlags warnPlausibilityChecks:p.
    ].

    "Created: / 16-11-2006 / 14:08:48 / cg"
!

test_bad_return3
    |w a setOfSignals|

    w := ParserFlags warnAboutPossibleSTCCompilationProblems.
    a := ParserFlags allowPossibleSTCCompilationProblems.

    [
	ParserFlags warnAboutPossibleSTCCompilationProblems:false.
	ParserFlags allowPossibleSTCCompilationProblems:true.

	setOfSignals := SignalSet with:(Parser parseErrorSignal) with:(Parser parseWarningSignal).
	self
	    shouldnt:
		[
		    self
			compile:'
foo:arg
    ^ arg
	ifTrue:[^ 1]
	ifFalse:[2]
'
		]
	    raise:setOfSignals.
    ] ensure:[
	ParserFlags warnAboutPossibleSTCCompilationProblems:w.
	ParserFlags allowPossibleSTCCompilationProblems:a.
    ]

    "Created: / 16-11-2006 / 14:33:29 / cg"
!

test_good_return1
    |setOfPossibleExceptions|

    setOfPossibleExceptions := SignalSet with:ParseWarning with:ParseError.
    self
	shouldnt:
	    [
		self
		    compile:'
foo:arg
    arg
	ifTrue:[^ 1]
	ifFalse:[^ 2]
'
	    ]
	raise:setOfPossibleExceptions.

    "Created: / 16-11-2006 / 14:16:53 / cg"
!

test_good_return2
    |setOfPossibleExceptions|

    setOfPossibleExceptions := SignalSet with:(Parser parseWarningSignal) with:(Parser parseErrorSignal).
    self
	shouldnt:
	    [
		self
		    compile:'
foo:arg
    ^ arg
	ifTrue:[1]
	ifFalse:[2]
'
	    ]
	raise:setOfPossibleExceptions.

    "Created: / 16-11-2006 / 14:41:45 / cg"
! !

!CompilerTest methodsFor:'tests - sends'!

m1
    ^ 123
!

m10
    ^ self m9

    "
     self new m10
    "
!

m11
    ^ self m10

    "
     self new m11
    "
!

m12
    ^ self m11

    "
     self new m12
    "
!

m13
    ^ self m12

    "
     self new m13
    "
!

m14
    ^ self m13

    "
     self new m14
    "
!

m15
    ^ self m14

    "
     self new m15
    "
!

m16
    ^ self m15

    "
     self new m16
    "
!

m2
    ^ self m1
!

m3
    ^ self m2
!

m4
    ^ self m3
!

m5
    ^ self m4
!

m6
    ^ self m5
!

m7
    ^ self m6

    "
     self new m7
    "
!

m8
    ^ self m7

    "
     self new m8
    "
!

m9
    ^ self m8

    "
     self new m9
    "
! !

!CompilerTest methodsFor:'tests - specials'!

testEnsure
    self assert:(self callEnsureWith2Returns = true).

    Error handle:[:ex |
	ex proceed
    ] do:[
	self assert:(self callEnsureWithException = true).
    ].

    "Created: / 24-08-2010 / 12:51:27 / cg"
! !

!CompilerTest methodsFor:'tests - stc compilation'!

testCodeForMethodVarAccess
    "compile this with stc - some gcc versions generate wrong code for it (result is nil)"

    |results renderNone allSchedules overallCount passedCount inconclusiveCount failedCount|

    self x_executeBlock:[
	|localResults localPassedCount localInconclusiveCount|

	allSchedules := self x_generateSchedules.

	overallCount := allSchedules size.
	(renderNone := (overallCount == 0)) ifFalse:[
	    results := allSchedules collect:[:ts | ts getStateOfLastRun].

	    passedCount := results count:[:state | state isSuccess].
	    inconclusiveCount := results count:[:state | state isInconclusive].

	    failedCount := overallCount - passedCount - inconclusiveCount.
	]
    ].
!

x_executeBlock:aBlock
    aBlock value
!

x_generateSchedules
    ^  OrderedCollection
	with:(Schedule new state:#failed)
	with:(Schedule new state:#passed)
	with:(Schedule new state:#passed)
	with:(Schedule new state:#failed)
	with:(Schedule new state:#inconclusive)
	with:(Schedule new state:#inconclusive)
	with:(Schedule new state:#inconclusive)
	with:(Schedule new state:#failed)
! !

!CompilerTest::DummyClass methodsFor:'accessing'!

_y0
    ObjectMemory garbageCollect.
    ^ self.
!

_y1:arg1
    ObjectMemory garbageCollect.
    ^ arg1.
!

request:something
    "set the value of the instance variable 'request' (automatically generated)"

    request := something.
! !

!CompilerTest::Schedule methodsFor:'accessing'!

getStateOfLastRun
    ^  State new state:state
!

state:aSymbol
    state := aSymbol
! !

!CompilerTest::Schedule::State methodsFor:'accessing'!

state
    ^ state
!

state:something
    state := something.
! !

!CompilerTest::Schedule::State methodsFor:'queries'!

isInconclusive
    ^ state == #inconclusive
!

isSuccess
    ^ state == #passed
! !

!CompilerTest class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

