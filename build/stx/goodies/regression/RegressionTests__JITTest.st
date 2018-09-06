"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#JITTest
	instanceVariableNames:'i1 i2 i3 i4 i5 i6'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

Object subclass:#BarClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JITTest
!

Object subclass:#FooClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JITTest
!


!JITTest class methodsFor:'tests'!

cond1:arg
    arg == 0 ifTrue:[
	^ 'zero'
    ].
    ^ 'not zero'

    "
     JITTest cond1:0
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

cond2:arg
    self size.
    arg == 0 ifTrue:[
	^ 'zero'
    ].
    ^ 'not zero'

    "
     JITTest cond2:0
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

send1:arg
    ^ self send1:arg with:(Association new) with:thisContext sender

    "
     JITTest send1:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

send1:arg1 with:arg2 with:arg3
    self halt

    "
     JITTest send1:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test1
    ^ 5

    "
     JITTest test1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test2
    ^ [5]

    "
     JITTest test2 value
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test2b
    ^ [:a | a]

    "
     JITTest test2b value:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test3
    ^ 256

    "
     JITTest test3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test4
    ^ 16r7FFF

    "
     JITTest test4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test5
    ^ 16rFFFF

    "
     JITTest test5
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test5b
    ^ -16rFFFF

    "
     JITTest test5b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test5c
    ^ -1

    "
     JITTest test5c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test6
    ^ #hello

    "
     JITTest test6
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test6b
    ^ #fooBarBazThisIsANonCommonSymbol

    "
     JITTest test6b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test6c
    ^ 123456789

    "
     JITTest test6c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test6d
    ^ 1234567890

    "
     JITTest test6d
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test7
    ^ true

    "
     JITTest test7
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test8:arg1 a:arg2 a:arg3 a:arg4
    ^ arg1

    "
     JITTest test8:1 a:2 a:3 a:4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test8b:arg1 a:arg2 a:arg3 a:arg4
    ^ arg2

    "
     JITTest test8b:1 a:2 a:3 a:4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test8c:arg1 a:arg2 a:arg3 a:arg4
    ^ arg3

    "
     JITTest test8c:1 a:2 a:3 a:4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

test9:arg1
    ^ arg1 + 1

    "
     JITTest test9:0
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
! !

!JITTest methodsFor:'helpers'!

withWaitCursorDo:aBlock
    aBlock value

    "Created: / 16.11.2001 / 00:06:20 / cg"
! !

!JITTest methodsFor:'public - test - arithmetic'!

testAdd1
    self assert:( (JITTest new add1:-1000) == -999 ).
    self assert:( (JITTest new add1:-1) == 0 ).
    self assert:( (JITTest new add1:0) == 1 ).
    self assert:( (JITTest new add1:1) == 2 ).
    self assert:( (JITTest new add1:1000) == 1001 ).

    self assert:( (JITTest new add1:SmallInteger maxVal) class == LargeInteger ).
    self assert:( ((JITTest new add1:SmallInteger maxVal) - 1) class == SmallInteger ).

    self assert:( (JITTest new add1:-1000.0) = -999.0 ).
    self assert:( (JITTest new add1:-1.0) = 0.0 ).
    self assert:( (JITTest new add1:0.0) = 1.0 ).
    self assert:( (JITTest new add1:1.0) = 2.0 ).
    self assert:( (JITTest new add1:1000.0) = 1001.0 ).


    self assert:( (JITTest new add2:-1000) = -999 ).
    self assert:( (JITTest new add2:-1) = 0 ).
    self assert:( (JITTest new add2:0) = 1 ).
    self assert:( (JITTest new add2:1) = 2 ).
    self assert:( (JITTest new add2:1000) = 1001 ).

    self assert:( (JITTest new add2:-1000.0) = -999.0 ).
    self assert:( (JITTest new add2:-1.0) = 0.0 ).
    self assert:( (JITTest new add2:0.0) = 1.0 ).
    self assert:( (JITTest new add2:1.0) = 2.0 ).
    self assert:( (JITTest new add2:1000.0) = 1001.0 ).

    "
     self basicNew testAdd1
    "
! !

!JITTest methodsFor:'public - test - blocks'!

testFindFirst
    self assert:(self findFirst1:1) == 1.
    self assert:(self findFirst1:2) == 2.
    self assert:(self findFirst1:3) == 3.
    self assert:(self findFirst1:4) == 4.
    self assert:(self findFirst1:0) == 0.
    self assert:(self findFirst1:10) == 0.
    self assert:(self findFirst1:4.0) == 0.

    self assert:(self findFirst2:1) == 1.
    self assert:(self findFirst2:2) == 2.
    self assert:(self findFirst2:3) == 3.
    self assert:(self findFirst2:4) == 4.
    self assert:(self findFirst2:0) == 0.
    self assert:(self findFirst2:10) == 0.
    self assert:(self findFirst2:4.0) == 4.


    self assert:(self findFirst3:1) == 1.
    self assert:(self findFirst3:2) == 2.
    self assert:(self findFirst3:3) == 3.
    self assert:(self findFirst3:4) == 4.
    self assert:(self findFirst3:0) == 0.
    self assert:(self findFirst3:10) == 0.
    self assert:(self findFirst3:4.0) == 0.

    "
     self basicNew testFindFirst
    "
! !

!JITTest methodsFor:'public - test - ifs'!

testAnd1
    i1 := nil. i2 := nil.
    self assert:(self tstNilAndNil2) == 1.

    i1 := nil. i2 := 0.
    self assert:(self tstNilAndNil2) == 0.

    i1 := 0. i2 := nil.
    self assert:(self tstNilAndNil2) == 0.

    i1 := 0. i2 := 0.
    self assert:(self tstNilAndNil2) == 0.

    i1 := nil. i2 := nil.
    self assert:(self tstNotNilAndNotNil2) == 0.

    i1 := nil. i2 := 0.
    self assert:(self tstNotNilAndNotNil2) == 0.

    i1 := 0. i2 := nil.
    self assert:(self tstNotNilAndNotNil2) == 0.

    i1 := 0. i2 := 0.
    self assert:(self tstNotNilAndNotNil2) == 1.


    i1 := nil. i2 := nil.
    self assert:(self tstNilAndNil3) == 1.

    i1 := nil. i2 := 0.
    self assert:(self tstNilAndNil3) == 0.

    i1 := 0. i2 := nil.
    self assert:(self tstNilAndNil3) == 0.

    i1 := 0. i2 := 0.
    self assert:(self tstNilAndNil3) == 0.

    i1 := nil. i2 := nil.
    self assert:(self tstNotNilAndNotNil3) == 0.

    i1 := nil. i2 := 0.
    self assert:(self tstNotNilAndNotNil3) == 0.

    i1 := 0. i2 := nil.
    self assert:(self tstNotNilAndNotNil3) == 0.

    i1 := 0. i2 := 0.
    self assert:(self tstNotNilAndNotNil3) == 1.

    "
     self basicNew testAnd1
    "
!

testOr1
    self assert:(self tstOr1:#Foo) == true.
    self assert:(self tstOr1:#Bar) == true.
    self assert:(self tstOr1:#Baz) == false.

    self assert:(self tstOr1:#foo) == false.
    self assert:(self tstOr1:#bar) == false.
    self assert:(self tstOr1:#baz) == false.

    self assert:(self tstOr2:#Foo) == true.
    self assert:(self tstOr2:#Bar) == true.
    self assert:(self tstOr2:#Baz) == true.

    self assert:(self tstOr2:#foo) == false.
    self assert:(self tstOr2:#bar) == false.
    self assert:(self tstOr2:#baz) == false.

    i1 := nil. i2 := nil.
    self assert:(self tstNilOrNil2) == 1.

    i1 := nil. i2 := 0.
    self assert:(self tstNilOrNil2) == 1.

    i1 := 0. i2 := nil.
    self assert:(self tstNilOrNil2) == 1.

    i1 := 0. i2 := 0.
    self assert:(self tstNilOrNil2) == 0.

    i1 := nil. i2 := nil.
    self assert:(self tstNotNilOrNotNil2) == 0.

    i1 := nil. i2 := 0.
    self assert:(self tstNotNilOrNotNil2) == 1.

    i1 := 0. i2 := nil.
    self assert:(self tstNotNilOrNotNil2) == 1.

    i1 := 0. i2 := 0.
    self assert:(self tstNotNilOrNotNil2) == 1.


    i1 := nil. i2 := nil.
    self assert:(self tstNilOrNil3) == 1.

    i1 := nil. i2 := 0.
    self assert:(self tstNilOrNil3) == 1.

    i1 := 0. i2 := nil.
    self assert:(self tstNilOrNil3) == 1.

    i1 := 0. i2 := 0.
    self assert:(self tstNilOrNil3) == 0.

    i1 := nil. i2 := nil.
    self assert:(self tstNotNilOrNotNil3) == 0.

    i1 := nil. i2 := 0.
    self assert:(self tstNotNilOrNotNil3) == 1.

    i1 := 0. i2 := nil.
    self assert:(self tstNotNilOrNotNil3) == 1.

    i1 := 0. i2 := 0.
    self assert:(self tstNotNilOrNotNil3) == 1.

    "
     self basicNew testOr1
    "
! !

!JITTest methodsFor:'public - test - logical'!

testNot

    self assert: (self tstSendNotTo: true) == false.
    self assert: (self tstSendNotTo: false) == true.
    self should: [ self tstSendNotTo: 1 ] raise: MessageNotUnderstood.
    self assert: (self tstSendNotTo: self) == #'not properly handled'.

    "Created: / 18-11-2014 / 11:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JITTest methodsFor:'public - test - misc'!

testAndGreater1

    |needUpdate mTime|

    i3 := '.' asFilename.

    i2 := i3 modificationTime.
    mTime := i3 modificationTime.

    needUpdate := mTime notNil and:[mTime > i2].

    "
     self new testAndGreater1
    "

    "Created: / 16.11.2001 / 00:07:52 / cg"
    "Modified: / 16.11.2001 / 00:09:23 / cg"
!

testAndGreater2

    | needUpdate mTime|

    i3 := '.' asFilename.

    self withWaitCursorDo:[
	i2 := i3 modificationTime.
	mTime := i3 modificationTime.
	"/ here, i2 refers to thisContext if the JITTER bug is in ...
	"/ at least on win32
	needUpdate := mTime notNil and:[mTime > i2].
    ]

    "
     self new testAndGreater2
    "

    "Created: / 16.11.2001 / 00:08:49 / cg"
    "Modified: / 16.11.2001 / 00:09:29 / cg"
!

testFailingValueHolderCode
    ObjectMemory justInTimeCompilation:false.

    self shouldnt:[ JITTest new tstValueHolderCode2 ] raise:Exception.
    self assert:(JITTest new tstValueHolderCode2 value = Date tomorrow).

    self class recompile:#tstValueHolderCode2.
    self shouldnt:[ JITTest new tstValueHolderCode2 ] raise:Exception.
    self assert:(JITTest new tstValueHolderCode2 value = Date tomorrow).

    ObjectMemory justInTimeCompilation:true.
    self class recompile:#tstValueHolderCode2.
    self shouldnt:[ JITTest new tstValueHolderCode2 ] raise:Exception.
    self assert:(JITTest new tstValueHolderCode2 value = Date tomorrow).

    ObjectMemory justInTimeCompilation:false.
    self shouldnt:[ JITTest new tstValueHolderCode1 ] raise:Exception.
    self class recompile:#tstValueHolderCode1.
    self shouldnt:[ JITTest new tstValueHolderCode1 ] raise:Exception.

    ObjectMemory justInTimeCompilation:true.
    self shouldnt:[ JITTest new tstValueHolderCode1 ] raise:Exception.
    self class recompile:#tstValueHolderCode1.
    self shouldnt:[ JITTest new tstValueHolderCode1 ] raise:Exception.

    "
     self basicNew testFailingValueHolderCode
    "
! !

!JITTest methodsFor:'test - arithmetic'!

add1:arg
    ^ 1 + arg

    "
     JITTest new add1:-1000
     JITTest new add1:-1
     JITTest new add1:0
     JITTest new add1:1
     JITTest new add1:1000
     JITTest new add1:SmallInteger maxVal

     JITTest new add1:-1.0
     JITTest new add1:0.0
     JITTest new add1:1.0
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
!

add2:arg
    ^ 1.0 + arg

    "
     JITTest new add2:-1000
     JITTest new add2:-1
     JITTest new add2:0
     JITTest new add2:1
     JITTest new add2:1000

     JITTest new add2:-1.0
     JITTest new add2:0.0
     JITTest new add2:1.0
    "
!

add3:arg
    ^ arg + 1

    "
     JITTest new add3:-1000
     JITTest new add3:-1
     JITTest new add3:0
     JITTest new add3:1
     JITTest new add3:1000

     JITTest new add3:-1.0
     JITTest new add3:0.0
     JITTest new add3:1.0
    "
!

add4:arg
    ^ arg + 1.0

    "
     JITTest new add4:-1000
     JITTest new add4:-1
     JITTest new add4:0
     JITTest new add4:1
     JITTest new add4:1000

     JITTest new add4:-1.0
     JITTest new add4:0.0
     JITTest new add4:1.0
    "
!

add5:arg
    ^ arg + arg

    "
     JITTest new add5:-1000
     JITTest new add5:-1
     JITTest new add5:0
     JITTest new add5:1
     JITTest new add5:1000

     JITTest new add5:-1.0
     JITTest new add5:0.0
     JITTest new add5:1.0
     JITTest new add5:SmallInteger maxVal
     JITTest new add5:SmallInteger minVal
     JITTest new add5:nil
    "
!

mul1:arg
    ^  arg * 2

    "
     JITTest new mul1:0
     JITTest new mul1:-1
     JITTest new mul1:1
     JITTest new mul1:1000
     JITTest new mul1:-1000
     JITTest new mul1:(SmallInteger maxVal // 2 - 1)
     JITTest new mul1:(SmallInteger maxVal // 2)
     JITTest new mul1:(SmallInteger maxVal // 2 + 1)
     JITTest new mul1:(SmallInteger maxVal // 2 + 2)
     JITTest new mul1:(SmallInteger maxVal + 1)
     JITTest new mul1:(SmallInteger maxVal)
     JITTest new mul1:(SmallInteger minVal // 2 - 1)
     JITTest new mul1:(SmallInteger minVal // 2)
     JITTest new mul1:(SmallInteger minVal // 2 + 1)
     JITTest new mul1:(SmallInteger minVal // 2 + 2)
     JITTest new mul1:(SmallInteger minVal - 1)
     JITTest new mul1:(SmallInteger minVal)

     JITTest new mul1:-1.0
     JITTest new mul1:0.0
     JITTest new mul1:1.0
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
!

mul2:arg
    ^  arg * 4

    "
     JITTest new mul2:0
     JITTest new mul2:-1
     JITTest new mul2:1
     JITTest new mul2:1000
     JITTest new mul2:-1000
     JITTest new mul2:(SmallInteger maxVal // 2 - 1)
     JITTest new mul2:(SmallInteger maxVal // 2)
     JITTest new mul2:(SmallInteger maxVal // 2 + 1)
     JITTest new mul2:(SmallInteger maxVal // 2 + 2)
     JITTest new mul2:(SmallInteger maxVal + 1)
     JITTest new mul2:(SmallInteger maxVal)
     JITTest new mul2:(SmallInteger minVal // 2 - 1)
     JITTest new mul2:(SmallInteger minVal // 2)
     JITTest new mul2:(SmallInteger minVal // 2 + 1)
     JITTest new mul2:(SmallInteger minVal // 2 + 2)
     JITTest new mul2:(SmallInteger minVal - 1)
     JITTest new mul2:(SmallInteger minVal)

     JITTest new mul2:-1.0
     JITTest new mul2:0.0
     JITTest new mul2:1.0
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
!

subtract1:arg
    ^ 1 - arg

    "
     JITTest new subtract1:-1000
     JITTest new subtract1:-1
     JITTest new subtract1:0
     JITTest new subtract1:1
     JITTest new subtract1:1000

     JITTest new subtract1:-1.0
     JITTest new subtract1:0.0
     JITTest new subtract1:1.0
     JITTest new subtract1:SmallInteger maxVal negated
     JITTest new subtract1:nil
    "
!

subtract2:arg
    ^ 1.0 - arg

    "
     JITTest new subtract2:-1000
     JITTest new subtract2:-1
     JITTest new subtract2:0
     JITTest new subtract2:1
     JITTest new subtract2:1000

     JITTest new subtract2:-1.0
     JITTest new subtract2:0.0
     JITTest new subtract2:1.0
    "
! !

!JITTest methodsFor:'test - bits'!

and1:arg
    ^ arg bitAnd:1

    "
     JITTest new and1:1
     JITTest new and1:0
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
!

or1:arg
    ^ arg bitOr:1

    "
     JITTest new or1:1
     JITTest new or1:2
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
!

xor1:arg
    ^ arg bitXor:1

    "
     JITTest new xor1:1
     JITTest new xor1:2
    "

    "Modified: / 3.6.1998 / 16:15:36 / cg"
! !

!JITTest methodsFor:'test - blocks'!

block1
    ^ [:a | a == 0]

    "
     JITTest new block1
     JITTest new block1 value
     JITTest new block1 value:1
     JITTest new block1 value:0
    "
!

block10
    |l|

    l := 1.
    ^ [ [l] ]

    "
     JITTest new block10
    "
!

block11
    |l|

    l := [1].
    ^ [ l value ]

    "
     JITTest new block11
    "
!

block12
    |b|

    b := [:a | ^ a].
    b value:1.

    "
     JITTest new block12
    "
!

block2
    ^ [:a | 'hello']

    "
     JITTest new block2
     JITTest new block2 value:nil
    "
!

block2Arg
    |b|

    b := [:a :b | a].
    (b value:1 value:2) printCR.

    "
     JITTest new block2Arg
    "
!

block2ArgB
    |b|

    b := [:a :b | b].
    (b value:1 value:2) printCR.

    "
     JITTest new block2ArgB
    "
!

block2ArgC
    |printA scale|

    scale := 1.

    printA :=
      [:iter1 :time1 |
      'block-arg1: ' print. iter1 printCR.
      'block-arg2: ' print. time1 printCR.
      Transcript cr.
      Transcript nextPutAll: (iter1 / scale) rounded printString.
      Transcript nextPutAll: '     '.
      Transcript nextPutAll: time1 printString.
      Transcript nextPutAll: '     '].

    printA value:1 value:2.

    "
     JITTest new block2ArgC
    "
!

block2bArg
    |b|

    b := [:a :b | a printCR].
    b value:1 value:2.

    "
     JITTest new block2bArg
    "
!

block2bArgB
    |b|

    b := [:a :b | b printCR].
    b value:1 value:2.

    "
     JITTest new block2bArgB
    "
!

block3
    ^ [:a | a]

    "
     JITTest new block3
    "
!

block4
    |a|

    a := 5.
    ^ [a]

    "
     JITTest new block4
     JITTest new block4 value
    "
!

block5
    ^ [self foo]

    "
     JITTest new block5
    "
!

block6
    ^ [^ self]

    "
     JITTest new block6
    "
!

block7
    ^ [^ [^ self]]

    "
     JITTest new block7
    "
!

block8
    ^ [ [^ self] ]

    "
     JITTest new block8
    "
!

block9
    |l|

    l := 1.
    ^ [ [^ l] ]

    "
     JITTest new block9
    "
!

falseBlock1
    ^ [true]

    "
     JITTest new falseBlock1
    "
!

falseBlock2
    ^ [:arg | true]

    "
     JITTest new falseBlock2
    "
!

findFirst1:arg
    |idx|

    i1 := #(1 2 3 4) asOrderedCollection.
    ^ i1 findFirst:[:el | el == arg]

    "
     self new findFirst1:1
     self new findFirst1:2
     self new findFirst1:3
     self new findFirst1:4
     self new findFirst1:0
     self new findFirst1:10
     self new findFirst1:4.0
    "
!

findFirst2:arg
    |idx|

    i1 := #(1 2 3 4) asOrderedCollection.
    ^ i1 findFirst:[:el | el = arg]

    "
     self new findFirst2:1
     self new findFirst2:2
     self new findFirst2:3
     self new findFirst2:4
     self new findFirst2:0
     self new findFirst2:10
     self new findFirst2:4.0
    "
!

findFirst3:arg
    i1 := #(1 2 3 4) asOrderedCollection.
    ^ self findFirst3b:arg

    "
     self new findFirst3:1
     self new findFirst3:2
     self new findFirst3:3
     self new findFirst3:4
     self new findFirst3:0
     self new findFirst3:10
     self new findFirst3:4.0
    "
!

findFirst3b:arg
    ^ i1 findFirst:[:el | el == arg]

    "
     self new findFirst3:1
     self new findFirst3:2
     self new findFirst3:3
     self new findFirst3:4
     self new findFirst3:0
     self new findFirst3:10
     self new findFirst3:4.0
    "
!

nilBlock1
    ^ []

    "
     JITTest new nilBlock1
    "
!

nilBlock2:arg
    ^ arg indexOf:4 ifAbsent:[]


    "
     JITTest new nilBlock2:#(1 2 3)
     JITTest new nilBlock2:#(1 2 3 4)
     JITTest new nilBlock2:#(1 2 3 4 5)
    "
!

trueBlock1
    ^ [true]

    "
     JITTest new trueBlock1
    "
!

zeroBlock1
    ^ [0]

    "
     JITTest new zeroBlock1
    "
!

zeroBlock2:arg
    ^ arg indexOf:4 ifAbsent:[0]


    "
     JITTest new zeroBlock2:#(1 2 3)
     JITTest new zeroBlock2:#(1 2 3 4)
     JITTest new zeroBlock2:#(1 2 3 4 5)
    "
! !

!JITTest methodsFor:'test - compare'!

compare10:arg
    arg = 10 ifTrue:[
	^ 11
    ].
    ^ nil

    "
     JITTest new compare10:nil
     JITTest new compare10:9
     JITTest new compare10:10
     JITTest new compare10:11
     JITTest new compare10:9.0
     JITTest new compare10:10.0
     JITTest new compare10:11.0
     JITTest new compare10:false
    "
!

compare11:arg
    ^ arg = 1

    "
     JITTest new compare11:-1000
     JITTest new compare11:-1
     JITTest new compare11:0
     JITTest new compare11:1
     JITTest new compare11:2
     JITTest new compare11:1000

     JITTest new compare11:-1.0
     JITTest new compare11:0.0
     JITTest new compare11:1.0
     JITTest new compare11:2.0
     JITTest new compare11:3.0
    "
!

compare12:arg
    ^ arg == 1

    "
     JITTest new compare12:-1000
     JITTest new compare12:-1
     JITTest new compare12:0
     JITTest new compare12:1
     JITTest new compare12:2
     JITTest new compare12:1000

     JITTest new compare12:-1.0
     JITTest new compare12:0.0
     JITTest new compare12:1.0
     JITTest new compare12:2.0
     JITTest new compare12:3.0
    "
!

compare1:arg
    ^ arg > 0

    "
     JITTest new compare1:-1000
     JITTest new compare1:-1
     JITTest new compare1:0
     JITTest new compare1:1
     JITTest new compare1:1000

     JITTest new compare1:-1.0
     JITTest new compare1:0.0
     JITTest new compare1:1.0
    "
!

compare2:arg
    ^ arg < 0

    "
     JITTest new compare2:-1000
     JITTest new compare2:-1
     JITTest new compare2:0
     JITTest new compare2:1
     JITTest new compare2:1000

     JITTest new compare2:-1.0
     JITTest new compare2:0.0
     JITTest new compare2:1.0
    "
!

compare3:arg
    ^ arg <= 0

    "
     JITTest new compare3:-1000
     JITTest new compare3:-1
     JITTest new compare3:0
     JITTest new compare3:1
     JITTest new compare3:1000

     JITTest new compare3:-1.0
     JITTest new compare3:0.0
     JITTest new compare3:1.0
    "
!

compare4:arg
    ^ arg >= 0

    "
     JITTest new compare4:-1000
     JITTest new compare4:-1
     JITTest new compare4:0
     JITTest new compare4:1
     JITTest new compare4:1000

     JITTest new compare4:-1.0
     JITTest new compare4:0.0
     JITTest new compare4:1.0
    "
!

compare5:arg
    ^ arg > 1

    "
     JITTest new compare5:-1000
     JITTest new compare5:-1
     JITTest new compare5:0
     JITTest new compare5:1
     JITTest new compare5:2
     JITTest new compare5:1000

     JITTest new compare5:-1.0
     JITTest new compare5:0.0
     JITTest new compare5:1.0
     JITTest new compare5:2.0
     JITTest new compare5:3.0
    "
!

compare6:arg
    ^ arg <= 1

    "
     JITTest new compare6:-1000
     JITTest new compare6:-1
     JITTest new compare6:0
     JITTest new compare6:1
     JITTest new compare6:2
     JITTest new compare6:1000

     JITTest new compare6:-1.0
     JITTest new compare6:0.0
     JITTest new compare6:1.0
     JITTest new compare6:2.0
     JITTest new compare6:3.0
    "
!

compare7:arg
    ^ arg < 1

    "
     JITTest new compare7:-1000
     JITTest new compare7:-1
     JITTest new compare7:0
     JITTest new compare7:1
     JITTest new compare7:2
     JITTest new compare7:1000

     JITTest new compare7:-1.0
     JITTest new compare7:0.0
     JITTest new compare7:1.0
     JITTest new compare7:2.0
     JITTest new compare7:3.0
    "
!

compare8:arg
    ^ arg >= 1

    "
     JITTest new compare8:-1000
     JITTest new compare8:-1
     JITTest new compare8:0
     JITTest new compare8:1
     JITTest new compare8:2
     JITTest new compare8:1000

     JITTest new compare8:-1.0
     JITTest new compare8:0.0
     JITTest new compare8:1.0
     JITTest new compare8:2.0
     JITTest new compare8:3.0
    "
!

compare9:arg
    arg == 10 ifTrue:[
	^ 11
    ].
    ^ nil

    "
     JITTest new compare9:nil
     JITTest new compare9:9
     JITTest new compare9:10
     JITTest new compare9:11
     JITTest new compare9:false
    "
! !

!JITTest methodsFor:'test - globals'!

g1
    ^ Array

    "
     JITTest new g1
    "
!

g1b
    ^ Time

    "
     JITTest new g1b
    "
!

g2
    ^ JITTest

    "
     JITTest new g2
    "

    "Modified: / 3.6.1998 / 15:43:14 / cg"
!

g2b
    ^ NonExistingClass

    "
     JITTest new g2b
    "

!

g3
    Foo := 1.

    "
     Smalltalk at:#Foo put:nil.
     JITTest new g3
    "
!

g3b
    NonExistingGlobal := 2.

    "
     JITTest new g3b
    "
!

send1
    ^ Time now

    "
     JITTest new send1
    "
!

send2
    self halt

    "
     JITTest new send2
    "
!

send3
    self send2

    "
     JITTest new send3
    "
!

send4
    self send3

    "
     JITTest new send4
    "
!

send5
    self send4

    "
     JITTest new send5
    "
! !

!JITTest methodsFor:'test - ifs'!

if1:aTime
    |sec min hr hrTick|

    aTime isNil ifTrue:[^ self].
    hr := aTime hours.

    "
     JITTest new if1:nil
    "
!

tstEQ1
    ^ i1 == 0

    "
     JITTest new testEQ1
     (JITTest new) instVarAt:1 put:0; testEQ1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstEQ2
    ^ i1 = 0

    "
     JITTest new testEQ2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstEQ3
    i1 == 0 ifTrue:[^ 0] ifFalse:[
	^ 1

	"
	 JITTest new testEQ3
	 (JITTest new) instVarAt:1 put:0; testEQ3
	"

	"Created: 16.8.1996 / 17:39:44 / cg"
    ]
!

tstEQ4
    i1 == 0 ifTrue:[^ 0].
    ^ 1

    "
     JITTest new testEQ4
     (JITTest new) instVarAt:1 put:0; testEQ4
    "
!

tstEQ5
    i1 = 0 ifTrue:[^ 0].
    ^ 1

    "
     JITTest new testEQ5
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilAndNil
    (i1 isNil and:[i2 isNil]) ifTrue:[
	Transcript showCR:'both nil'.
	^ self
    ].
    Transcript showCR:'any nonNil'

    "
     JITTest new tstNilAndNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNilAndNil

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilAndNil2
    (i1 isNil and:[i2 isNil]) ifTrue:[
	"/ Transcript showCR:'both nil'.
	^ 1
    ].
    "/ Transcript showCR:'any nonNil'
    ^ 0

    "
     JITTest new tstNilAndNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNilAndNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilAndNil3
    (i1 isNil and:[i2 isNil]) ifTrue:[
	"/ Transcript showCR:'both nil'.
	^ 1
    ] ifFalse:[
	"/ Transcript showCR:'any nonNil'
	^ 0
    ].

    "
     JITTest new tstNilAndNil3

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNilAndNil3

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil3

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNilAndNil3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilOrNil
    (i1 isNil or:[i2 isNil]) ifTrue:[
	Transcript showCR:'any nil'.
	^ self
    ].
    Transcript showCR:'both nonNil'

    "
     JITTest new testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilOrNil2
    (i1 isNil or:[i2 isNil]) ifTrue:[
	^ 1
    ].
    ^ 0

    "
     JITTest new testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNilOrNil3
    (i1 isNil or:[i2 isNil]) ifTrue:[
	^ 1
    ] ifFalse:[
	^ 0
    ].

    "
     JITTest new testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j testNilOrNil

    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilAndNotNil
    (i1 notNil and:[i2 notNil]) ifTrue:[
	Transcript showCR:'both notNil'.
	^ self
    ].
    Transcript showCR:'any isNil'

    "
     JITTest new tstNotNilAndNotNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilAndNotNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilAndNotNil
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilAndNotNil2
    (i1 notNil and:[i2 notNil]) ifTrue:[
	"/ Transcript showCR:'both nil'.
	^ 1
    ].
    "/ Transcript showCR:'any nonNil'
    ^ 0

    "
     JITTest new tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilAndNotNil2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilAndNotNil3
    (i1 notNil and:[i2 notNil]) ifTrue:[
	"/ Transcript showCR:'both nil'.
	^ 1
    ] ifFalse:[
	"/ Transcript showCR:'any nonNil'
	^ 0
    ].

    "
     JITTest new tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNotNilAndNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilAndNotNil2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilOrNotNil
    (i1 notNil or:[i2 notNil]) ifTrue:[
	Transcript showCR:'any notNil'.
	^ self
    ].
    Transcript showCR:'both nil'.
    ^ 0

    "
     JITTest new tstNotNilOrNotNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilOrNotNil

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilOrNotNil
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilOrNotNil2
    (i1 notNil or:[i2 notNil]) ifTrue:[
	^ 1
    ].
    ^ 0

    "
     JITTest new tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilOrNotNil2

    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstNotNilOrNotNil3
    (i1 notNil or:[i2 notNil]) ifTrue:[
	^ 1
    ] ifFalse:[
	^ 0
    ].

    "
     JITTest new tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i2' put:1.
     j tstNotNilOrNotNil2

     |j|
     j := JITTest new.
     j instVarNamed:'i1' put:1.
     j instVarNamed:'i2' put:1.
     j tstNotNilOrNotNil2

    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstOr1:arg
    ^ arg == #Foo or:[arg == #Bar]
!

tstOr2:arg
    ^ arg == #Foo or:[arg == #Bar or:[arg == #Baz]]
!

tstOr3
    (i1 isNil or:[i2 isNil]) ifTrue:[^ true].
    ^ (i4 isNil or:[i5 isNil]).

    "
     self new tstOr3
    "
!

tstOr4
    (i1 isNil or:[i2 isNil or:[i3 isNil]]) ifTrue:[^ true].
    ^ (i4 isNil or:[i5 isNil or:[i6 isNil]]).

    "
     self new tstOr4
    "
! !

!JITTest methodsFor:'test - logical'!

not
    ^ #'not properly handled'

    "Created: / 18-11-2014 / 11:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tstSendNotTo: object

    ^ object not

    "
    JITTest new tstSendNotTo: true.
    JITTest new tstSendNotTo: false.
    JITTest new tstSendNotTo: 1.
    JITTest new tstSendNotTo: JITTest new.
    "

    "Created: / 18-11-2014 / 11:49:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JITTest methodsFor:'test - loops'!

loop1
    [true] whileTrue:[
    ]

    "
     JITTest new loop1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1b
    [false] whileFalse:[
    ]

    "
     JITTest new loop1b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1c
    [true] whileFalse:[
    ]

    "
     JITTest new loop1c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1d
    [false] whileTrue:[
    ]

    "
     JITTest new loop1d
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1e
    [true] whileTrue

    "
     JITTest new loop1e
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1f
    [false] whileTrue

    "
     JITTest new loop1f
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1g
    [false] whileFalse

    "
     JITTest new loop1g
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop1h
    [true] whileFalse

    "
     JITTest new loop1h
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop2
    |i|

    i := 5.
    [i > 0] whileTrue:[
	i printCR.
	i := i - 1.
    ]

    "
     JITTest new loop2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop2a
    |i|

    i := 5.
    [i > 0] whileTrue:[
	i := i - 1.
    ]

    "
     JITTest new loop2a
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop3
    |i|

    i := 5.
    [i >= 0] whileTrue:[
	i printCR.
	i := i - 1.
    ]

    "
     (Delay waitForSeconds:5). JITTest new loop3
     JITTest new loop3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop4
    |i|

    i := 5.
    [i >= 1] whileTrue:[
	i printCR.
	i := i - 1.
    ]

    "
     JITTest new loop4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop5
    5 timesRepeat:[
	'loop' printCR.
    ]

    "
     JITTest new loop5
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop6
    |i|

    i := 5.
    5 timesRepeat:[
	i := i - 1.
	'loop' print. i printCR.
    ]

    "
     JITTest new loop6
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop7
    |j|

    j := 0.
    1 to:10000 do:[:i |
	j := j + 1.
    ].
    ^ j.

    "
     JITTest new loop7
    "

    "Created: 16.8.1996 / 17:39:44 / cg"


!

loop8
    |j|

    j := 0.
    1 to:10000 do:[:i |
	j := j + i.
    ].
    ^ j.

    "
     JITTest new loop8
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

whileLoop1
    |i|

    i := -7.
    [i <= 16] whileTrue: [
	(i >= 1 and: [i <= 8]) ifTrue:[ 'a' printCR.].
	i >= 2 ifTrue: ['b' printCR.].
	i <= 7 ifTrue: ['c' printCR.].
	i := i + 1
    ].

    "
     self new whileLoop1
    "
! !

!JITTest methodsFor:'test - misc'!

tstAsFloat:arg
    |foo|

    foo := arg asFloat.
    ^ foo

    "
     self new testAsFloat:1
     self new testAsFloat:1.0
     self new testAsFloat:(1.0 asShortFloat)
    "

    "Created: / 9.6.1998 / 20:21:51 / cg"
    "Modified: / 9.6.1998 / 20:22:40 / cg"
!

tstAsInteger:arg
    |foo|

    foo := arg asInteger.
    ^ foo

    "
     self new testAsInteger:1
     self new testAsInteger:1.0
     self new testAsInteger:(1.0 asShortFloat)
    "

    "Created: / 9.6.1998 / 20:21:51 / cg"
!

tstEven:arg
    ^ arg even

    "
     self new testEven:1
     self new testEven:2
     self new testEven:1.0
     self new testEven:2.0
     self new testEven:(SmallInteger maxVal + 1)
     self new testEven:(SmallInteger maxVal + 2)
     self new testEven:(1.0 asShortFloat)
     self new testEven:(2.0 asShortFloat)
     self new testEven:(Object new)
    "
!

tstIsInteger:arg
    ^ arg isInteger

    "
     self new testIsInteger:1
     self new testIsInteger:1.0
     self new testIsInteger:(1.0 asShortFloat)
    "

    "Modified: / 9.6.1998 / 20:22:24 / cg"
!

tstIsReal:arg
    ^ arg isReal

    "
     self new testIsReal:1
     self new testIsReal:1.0
     self new testIsReal:(1.0 asShortFloat)
    "

    "Modified: / 9.6.1998 / 20:22:24 / cg"
    "Created: / 9.6.1998 / 20:23:16 / cg"
!

tstOdd:arg
    ^ arg odd

    "
     self new testOdd:1
     self new testOdd:2
     self new testOdd:1.0
     self new testOdd:2.0
     self new testOdd:(SmallInteger maxVal + 1)
     self new testOdd:(SmallInteger maxVal + 2)
     self new testOdd:(1.0 asShortFloat)
     self new testOdd:(2.0 asShortFloat)
     self new testOdd:(Object new)
    "
!

tstOddEven1
    |x|

    x := 0.
    1 to:100 do:[:i |
	i odd ifTrue:[
	    x := x + 1
	] ifFalse:[x := x - 1]
    ].
    ^ x

    "
     self new testOddEven1
    "
!

tstValueHolderCode1
    |v|

    v := ValueHolder new.

    v value:(Date today).
    v value:(Date today + 1).

    "
     self new tstValueHolderCode1
    "
!

tstValueHolderCode2
    |v|

    v := ValueHolder new.

    v value:(Date today).
    v value:(Date today + 1).
    ^ v.

    "
     self new tstValueHolderCode2
    "
! !

!JITTest methodsFor:'tests - args'!

runPerformTestArg
    (self perform:#'tstargs9:_:_:_:_:_:_:_:_:'
	withArguments:#(1 2 3 4 5 6 7 8 9)) ~~ 9 ifTrue:[
	self halt
    ].
    (self perform:#'tstargs9_l:_:_:_:_:_:_:_:_:'
	withArguments:#(1 2 3 4 5 6 7 8 9)) ~~ 9 ifTrue:[
	self halt

	"
	 JITTest new runPerformTestArg
	"

	"Modified: / 19.4.1999 / 22:05:29 / cg"
    ]
!

runTestArg
    (self tstargs1:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self tstargs1:nil) ~~ nil ifTrue:[
	self halt
    ].
    (self tstargs2:1 _:2) ~~ 2 ifTrue:[
	self halt
    ].
    (self tstargs2:2 _:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs3:1
	_:2
	_:3) ~~ 3 ifTrue:[
	self halt
    ].
    (self
	tstargs3:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs4:1
	_:2
	_:3
	_:4) ~~ 4 ifTrue:[
	self halt
    ].
    (self
	tstargs4:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs5:1
	_:2
	_:3
	_:4
	_:5) ~~ 5 ifTrue:[
	self halt
    ].
    (self
	tstargs5:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs6:1
	_:2
	_:3
	_:4
	_:5
	_:6) ~~ 6 ifTrue:[
	self halt
    ].
    (self
	tstargs6:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs7:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7) ~~ 7 ifTrue:[
	self halt
    ].
    (self
	tstargs7:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs8:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7
	_:8) ~~ 8 ifTrue:[
	self halt
    ].
    (self
	tstargs8:8
	_:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs9:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7
	_:8
	_:9) ~~ 9 ifTrue:[
	self halt
    ].
    (self
	tstargs9:9
	_:8
	_:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt

	"
	 JITTest new runTestArg
	"

	"Modified: / 19.4.1999 / 22:02:09 / cg"
    ]
!

runTestArg_l
    (self tstargs1_l:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self tstargs1_l:nil) ~~ nil ifTrue:[
	self halt
    ].
    (self tstargs2_l:1 _:2) ~~ 2 ifTrue:[
	self halt
    ].
    (self tstargs2_l:2 _:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs3_l:1
	_:2
	_:3) ~~ 3 ifTrue:[
	self halt
    ].
    (self
	tstargs3_l:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs4_l:1
	_:2
	_:3
	_:4) ~~ 4 ifTrue:[
	self halt
    ].
    (self
	tstargs4_l:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs5_l:1
	_:2
	_:3
	_:4
	_:5) ~~ 5 ifTrue:[
	self halt
    ].
    (self
	tstargs5_l:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs6_l:1
	_:2
	_:3
	_:4
	_:5
	_:6) ~~ 6 ifTrue:[
	self halt
    ].
    (self
	tstargs6_l:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs7_l:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7) ~~ 7 ifTrue:[
	self halt
    ].
    (self
	tstargs7_l:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs8_l:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7
	_:8) ~~ 8 ifTrue:[
	self halt
    ].
    (self
	tstargs8_l:8
	_:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt
    ].
    (self
	tstargs9_l:1
	_:2
	_:3
	_:4
	_:5
	_:6
	_:7
	_:8
	_:9) ~~ 9 ifTrue:[
	self halt
    ].
    (self
	tstargs9_l:9
	_:8
	_:7
	_:6
	_:5
	_:4
	_:3
	_:2
	_:1) ~~ 1 ifTrue:[
	self halt

	"
	 JITTest new runTestArg_l
	"

	"Modified: / 19.4.1999 / 22:02:09 / cg"
	"Created: / 19.4.1999 / 22:03:13 / cg"
    ]
!

tstArgEQ:arg
    arg == #'==' ifTrue:[
	^ true
    ].
    arg == #'~~' ifTrue:[
	^ true
    ].
    arg == #'=' ifTrue:[
	^ true
    ].
    ^ false

    "
     JITTest new testArgEQ:1
     JITTest new testArgEQ:#==
     JITTest new testArgEQ:#~~
     JITTest new testArgEQ:#=
     JITTest new testArgEQ:#foo
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstarg1:arg
    ^ arg

    "
     JITTest new testarg1:1
     JITTest new testarg1:0
    "

    "Created: / 16.8.1996 / 17:39:44 / cg"
    "Modified: / 3.6.1998 / 15:49:29 / cg"
!

tstarg2:arg1 arg:arg2
    ^ arg2

    "
     JITTest new testarg2:1 arg:2
     JITTest new testarg2:0 arg:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstarg3:arg
    |l1|

    l1 := 1.
    ^ arg

    "
     JITTest new testarg3:1
     JITTest new testarg3:0
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstarg4:arg1 arg:arg2
    |l1|

    l1 := 1.
    ^ arg1

    "
     JITTest new testarg4:1 arg:2
     JITTest new testarg4:0 arg:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstarg5:arg1 arg:arg2
    |l1|

    l1 := 1.
    ^ arg2

    "
     JITTest new testarg5:1 arg:2
     JITTest new testarg5:0 arg:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstargs1:a1
    ^ a1

    "
     JITTest new testargs1:1
    "

    "Created: / 3.6.1998 / 21:04:31 / cg"
!

tstargs1_l:a1
    |l|

    l := 1.
    ^ a1

    "
     JITTest new testargs1_l:1
    "

    "Created: / 3.6.1998 / 21:04:31 / cg"
    "Modified: / 3.6.1998 / 23:36:57 / cg"
!

tstargs2:a1 _:a2
    ^ a2

    "
     JITTest new testargs2:1 _:2
    "

    "Created: / 3.6.1998 / 21:04:42 / cg"
    "Modified: / 3.6.1998 / 21:05:56 / cg"
!

tstargs2_l:a1 _:a2
    |l|

    l := 1.
    ^ a2

    "
     JITTest new testargs2_l:1 _:2
    "

    "Created: / 3.6.1998 / 23:37:03 / cg"
    "Modified: / 3.6.1998 / 23:37:41 / cg"
!

tstargs3:a1 _:a2 _:a3
    ^ a3

    "
     JITTest new testargs3:1 _:2 _:3
    "

    "Created: / 3.6.1998 / 21:05:14 / cg"
!

tstargs3_l:a1 _:a2 _:a3
    |l|

    l := 1.
    ^ a3

    "
     JITTest new testargs3_l:1 _:2 _:3
    "

    "Created: / 3.6.1998 / 23:37:07 / cg"
    "Modified: / 3.6.1998 / 23:37:44 / cg"
!

tstargs4:a1 _:a2 _:a3 _:a4
    ^ a4

    "
     JITTest new testargs4:1 _:2 _:3 _:4
    "

    "Created: / 3.6.1998 / 21:05:07 / cg"
    "Modified: / 3.6.1998 / 21:05:50 / cg"
!

tstargs4_l:a1 _:a2 _:a3 _:a4
    |l|

    l := 1.
    ^ a4

    "
     JITTest new testargs4_l:1 _:2 _:3 _:4
    "

    "Created: / 3.6.1998 / 23:37:11 / cg"
    "Modified: / 3.6.1998 / 23:37:48 / cg"
!

tstargs5:a1 _:a2 _:a3 _:a4 _:a5
    ^ a5

    "
     JITTest new testargs5:1 _:2 _:3 _:4 _:5
    "

    "Created: / 3.6.1998 / 21:05:28 / cg"
    "Modified: / 3.6.1998 / 21:05:47 / cg"
!

tstargs5_l:a1 _:a2 _:a3 _:a4 _:a5
    |l|

    l := 1.
    ^ a5

    "
     JITTest new testargs5_l:1 _:2 _:3 _:4 _:5
    "

    "Created: / 3.6.1998 / 23:37:17 / cg"
    "Modified: / 3.6.1998 / 23:37:50 / cg"
!

tstargs6:a1 _:a2 _:a3 _:a4 _:a5 _:a6
    ^ a6

    "
     JITTest new testargs6:1 _:2 _:3 _:4 _:5 _:6
    "

    "Created: / 3.6.1998 / 21:05:44 / cg"
!

tstargs6_l:a1 _:a2 _:a3 _:a4 _:a5 _:a6
    |l|

    l := 1.
    ^ a6

    "
     JITTest new testargs6_l:1 _:2 _:3 _:4 _:5 _:6
    "

    "Created: / 3.6.1998 / 23:37:20 / cg"
    "Modified: / 3.6.1998 / 23:37:54 / cg"
!

tstargs7:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7
    ^ a7

    "
     JITTest new testargs7:1 _:2 _:3 _:4 _:5 _:6 _:7
    "

    "Created: / 3.6.1998 / 21:05:44 / cg"
    "Modified: / 3.6.1998 / 21:15:35 / cg"
!

tstargs7_l:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7
    |l|

    l := 1.
    ^ a7

    "
     JITTest new testargs7_l:1 _:2 _:3 _:4 _:5 _:6 _:7
    "

    "Created: / 3.6.1998 / 23:37:23 / cg"
    "Modified: / 3.6.1998 / 23:37:57 / cg"
!

tstargs8:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7 _:a8
    ^ a8

    "
     JITTest new testargs8:1 _:2 _:3 _:4 _:5 _:6 _:7 _:8
    "

    "Created: / 3.6.1998 / 21:15:52 / cg"
!

tstargs8_l:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7 _:a8
    |l|

    l := 1.
    ^ a8

    "
     JITTest new testargs8_l:1 _:2 _:3 _:4 _:5 _:6 _:7 _:8
    "

    "Created: / 3.6.1998 / 23:37:28 / cg"
    "Modified: / 3.6.1998 / 23:38:01 / cg"
!

tstargs9:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7 _:a8 _:a9
    ^ a9

    "
     JITTest new testargs9:1 _:2 _:3 _:4 _:5 _:6 _:7 _:8 _:9
    "

    "Created: / 3.6.1998 / 21:05:44 / cg"
    "Modified: / 3.6.1998 / 21:16:55 / cg"
!

tstargs9_l:a1 _:a2 _:a3 _:a4 _:a5 _:a6 _:a7 _:a8 _:a9
    |l|

    l := 1.
    ^ a9

    "
     JITTest new testargs9_l:1 _:2 _:3 _:4 _:5 _:6 _:7 _:8 _:9
    "

    "Created: / 3.6.1998 / 23:37:33 / cg"
    "Modified: / 3.6.1998 / 23:38:03 / cg"
! !

!JITTest methodsFor:'tests - consts'!

tst10b
    ^ 'hello'

    "
     JITTest new test10b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst10c
    ^ 'world'

    "
     JITTest new test10c
     JITTest new test10b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst11
    i1 := 0

    "
     JITTest new test11
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
! !

!JITTest methodsFor:'tests - contexts'!

tstContext1
    ^ thisContext

    "
     JITTest new testContext1
     ObjectMemory dumpObject: JITTest new testContext1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstContext2
    ^ thisContext sender

    "
     JITTest new testContext2
     ObjectMemory dumpObject: JITTest new testContext2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
! !

!JITTest methodsFor:'tests - floats'!

abs1:arg
    ^ arg abs

    "
     self new abs1:1
     self new abs1:-1
     self new abs1:0
     self new abs1:1.0
     self new abs1:-1.0
     self new abs1:0.0
    "

    "Created: / 3.11.1998 / 16:14:04 / cg"
! !

!JITTest methodsFor:'tests - instvars'!

tst10
    ^ i2

    "
     JITTest new tst10
     (JITTest new) instVarAt:2 put:555; tst10
    "

    "Created: / 16.8.1996 / 17:39:44 / cg"
    "Modified: / 3.6.1998 / 15:49:54 / cg"
!

tst12:arg
    i1 := arg.
    i2 := 0

    "
     JITTest new tst12:1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst13
    i1 := nil.
    i2 := 1

    "
     JITTest new tst13
     (JITTest new tst12:1) tst13
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst13b
    i1 := nil.
    i2 := 0

    "
     JITTest new tst13b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst13c
    i1 := i2 := i3 := 0.
    i1 := nil.
    i2 := 0.
    i3 := nil

    "
     JITTest new tst13c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14
    i1 := 1.
    i2 := 2.
    i3 := 3

    "
     JITTest new tst14
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14b
    i1 := 1.
    i2 := 1.
    i3 := 1

    "
     JITTest new tst14b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14c
    i1 := 0.
    ^ 0

    "
     JITTest new tst14c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14d
    i1 := 1.
    i2 := 3.
    i3 := 5

    "
     JITTest new tst14d
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14e
    i1 := 1.
    i2 := 3.
    i3 := 5.
    i1 := 3.
    i2 := 1.
    i3 := 0

    "
     JITTest new tst14e
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14f
    i1 := true.
    i2 := false.
    i3 := true

    "
     JITTest new tst14f
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14g
    i1 := true.
    i2 := false.
    i3 := true.
    ^ true

    "
     JITTest new tst14g
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14h
    i1 := true.
    i2 := false.
    i3 := true.
    ^ false

    "
     JITTest new tst14h
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst14i
    i1 := true.
    ^ false

    "
     JITTest new tst14i
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst15
    i1 := 1.
    i2 := i1.
    i3 := i2

    "
     JITTest new tst15
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst16
    i1 := 1.
    i2 := 1.
    i3 := 1

    "
     JITTest new tst16
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17
    i1 := 1.
    i2 := 10.
    i3 := 100

    "
     JITTest new tst17
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17b
    i1 := 1.
    i2 := 10.
    i3 := 100.
    i1 := 1000

    "
     JITTest new tst17b
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17c
    i1 := 1.
    i2 := 10.
    i3 := 100.
    i1 := 1000.
    i2 := 10000

    "
     JITTest new tst17c
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17d
    i1 := 0.
    i2 := -1.
    i3 := 1

    "
     JITTest new tst17d
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17e
    i1 := nil.
    i2 := -1

    "
     JITTest new tst17e
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst17f
    i2 := -1.
    i1 := nil

    "
     JITTest new tst17f
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst9
    ^ i1

    "
     JITTest new tst9
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstInstStore1
    i1 := nil

    "
     JITTest new tstInstStore1
    "

    "Created: / 17.7.1998 / 16:42:02 / cg"
!

tstInstStore2
    i1 := 1

    "
     JITTest new tstInstStore2
    "

    "Created: / 17.7.1998 / 16:45:51 / cg"
!

tstInstStore3
    i1 := true

    "
     JITTest new tstInstStore3
    "

    "Created: / 17.7.1998 / 16:46:02 / cg"
!

tstInstStore4
    i1 := false

    "
     JITTest new tstInstStore4
    "

    "Created: / 17.7.1998 / 16:46:32 / cg"
!

tstInstStore5
    i1 := #at:put:

    "
     JITTest new tstInstStore5
    "

    "Created: / 17.7.1998 / 16:47:02 / cg"
! !

!JITTest methodsFor:'tests - locals'!

tstLocal1
    |l1|

    ^ thisContext

    "
     JITTest new testLocal1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstLocal2
    |l1 l2 l3|

    l1 := 1.
    l2 := 2.
    l3 := 3.
    ^ thisContext

    "
     JITTest new testLocal2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstLocal3
    |l1|

    ^ l1

    "
     JITTest new testLocal3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstLocal4
    |l1|

    l1 := 1.
    ^ l1

    "
     JITTest new testLocal4
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstLocal5
    |l1 l2|

    l1 := nil.
    l2 := nil

    "
     JITTest new testLocal5

     |t|
     t := self new.
     Time millisecondsToRun:[
     1000000 timesRepeat:[t testLocal5]
     ]  798 809 808 808 801 798 835
    "
!

tstLocal6
    |l1 l2|

    1000000 timesRepeat:[
	    l1 := nil.
	    l2 := nil
	]

    "
     JITTest new testLocal5

     |t|
     t := self new.
     Time millisecondsToRun:[
     t testLocal6
     ]  38 37 38 38 38 61
    "
! !

!JITTest methodsFor:'tests - return'!

tstBlock0
    ^ [
    |l1|

    l1 := 1.
    1


    "
     JITTest new testBlock0 value
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:45:26 / cg"
]
!

tstBlock1
    ^ [:arg |
    |l1|

    l1 := arg.
    arg


    "
     JITTest new testBlock1 value:1
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:44:26 / cg"
]
!

tstBlock10
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 :arg9 :arg10 |
    |l1|

    l1 := arg10.
    arg10


    "
     JITTest new testBlock10
     valueWithArguments:#(1 2 3 4 5 6 7 8 9 10)
    "

    "Modified: / 3.6.1998 / 23:22:04 / cg"
    "Created: / 3.6.1998 / 23:22:23 / cg"
]
!

tstBlock11
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 :arg9 :arg10 :arg11 |
    |l1|

    l1 := arg11.
    arg11


    "
     JITTest new testBlock11
     valueWithArguments:#(1 2 3 4 5 6 7 8 9 10 11)
    "

    "Modified: / 3.6.1998 / 23:22:04 / cg"
    "Created: / 3.6.1998 / 23:22:43 / cg"
]
!

tstBlock12
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 :arg9 :arg10 :arg11 :arg12 |
    |l1|

    l1 := arg12.
    arg12


    "
     JITTest new testBlock12
     valueWithArguments:#(1 2 3 4 5 6 7 8 9 10 11 12)
    "

    "Modified: / 3.6.1998 / 23:22:04 / cg"
    "Created: / 3.6.1998 / 23:23:01 / cg"
]
!

tstBlock13
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 :arg9 :arg10 :arg11 :arg12 :arg13 |
    |l1|

    l1 := arg13.
    arg13


    "
     JITTest new testBlock13
     valueWithArguments:#(1 2 3 4 5 6 7 8 9 10 11 12 13)
    "

    "Modified: / 3.6.1998 / 23:22:04 / cg"
    "Created: / 3.6.1998 / 23:23:21 / cg"
]
!

tstBlock2
    ^ [:arg1 :arg2 |
    |l1|

    l1 := arg2.
    arg2


    "
     JITTest new testBlock2 value:1 value:2
    "

    "Created: / 3.6.1998 / 21:46:35 / cg"
    "Modified: / 3.6.1998 / 21:46:53 / cg"
]
!

tstBlock3
    ^ [:arg1 :arg2 :arg3 |
    |l1|

    l1 := arg3.
    arg3


    "
     JITTest new testBlock3 value:1 value:2 value:3
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:46:49 / cg"
]
!

tstBlock4
    ^ [:arg1 :arg2 :arg3 :arg4 |
    |l1|

    l1 := arg4.
    arg4


    "
     JITTest new testBlock4 value:1 value:2 value:3 value:4
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:47:07 / cg"
]
!

tstBlock5
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 |
    |l1|

    l1 := arg5.
    arg5


    "
     JITTest new testBlock5 value:1 value:2 value:3 value:4 value:5
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:47:23 / cg"
]
!

tstBlock7
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 |
    |l1|

    l1 := arg7.
    arg7


    "
     JITTest new testBlock7 value:1 value:2 value:3 value:4 value:5 value:6 value:7
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:47:53 / cg"
]
!

tstBlock8
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 |
    |l1|

    l1 := arg8.
    arg8


    "
     JITTest new testBlock8 value:1 value:2 value:3 value:4 value:5 value:6 value:7 value:8
    "

    "Created: / 3.6.1998 / 21:46:49 / cg"
    "Modified: / 3.6.1998 / 22:41:58 / cg"
]
!

tstBlock9
    ^ [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 :arg7 :arg8 :arg9 |
    |l1|

    l1 := arg9.
    arg9


    "
     JITTest new testBlock9
     valueWithArguments:#(1 2 3 4 5 6 7 8 9)
    "

    "Created: / 3.6.1998 / 21:46:49 / cg"
    "Modified: / 3.6.1998 / 23:22:04 / cg"
]
!

tstBlockRet
    1 to:10 do:[:i |
	i == 5 ifTrue:[^ i]


	"
	 JITTest new testBlockRet
	"

	"Modified: / 3.6.1998 / 23:22:04 / cg"
	"Created: / 3.6.1998 / 23:23:21 / cg"
    ]
!

tstSelf1:a1 arg:a2 arg:a3 arg:a4
    ^ self

    "
     JITTest new testSelf1:1 arg:2 arg:3 arg:4
     JITTest new testSelf1:0 arg:1 arg:2 arg:3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSelf2:a1 arg:a2 arg:a3 arg:a4
    |local1|

    ^ self

    "
     JITTest new testSelf2:1 arg:2 arg:3 arg:4
     JITTest new testSelf2:0 arg:1 arg:2 arg:3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSelf3:a1 arg:a2 arg:a3 arg:a4
    |local1|

    local1 := 1.
    ^ self

    "
     JITTest new testSelf3:1 arg:2 arg:3 arg:4
     JITTest new testSelf3:0 arg:1 arg:2 arg:3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSelf3_1:a1 arg:a2 arg:a3
    ^ self

    "
     JITTest new testSelf3_1:1 arg:2 arg:3
     JITTest new testSelf3_1:0 arg:1 arg:2
    "

    "Modified: / 3.6.1998 / 21:18:37 / cg"
    "Created: / 3.6.1998 / 21:19:14 / cg"
!

tstSelf3_2:a1 arg:a2 arg:a3
    |local1|

    ^ self

    "
     JITTest new testSelf3_2:1 arg:2 arg:3
     JITTest new testSelf3_2:0 arg:1 arg:2
    "

    "Created: / 3.6.1998 / 21:19:23 / cg"
!

tstSelf3_3:a1 arg:a2 arg:a3
    |local1|

    local1 := 1.
    ^ self

    "
     JITTest new testSelf3_3:1 arg:2 arg:3
     JITTest new testSelf3_3:0 arg:1 arg:2
    "

    "Created: / 3.6.1998 / 21:19:34 / cg"
!

tstSelf3_4:a1 arg:a2 arg:a3
    |local1|

    local1 := self.
    ^ local1

    "
     JITTest new testSelf3_4:1 arg:2 arg:3
     JITTest new testSelf3_4:0 arg:1 arg:2
    "

    "Created: / 3.6.1998 / 21:19:44 / cg"
!

tstSelf4:a1 arg:a2 arg:a3 arg:a4
    |local1|

    local1 := self.
    ^ local1

    "
     JITTest new testSelf4:1 arg:2 arg:3 arg:4
     JITTest new testSelf4:0 arg:1 arg:2 arg:3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSelf4_1:a1 arg:a2 arg:a3 arg:a4
    ^ self

    "
     JITTest new testSelf4_1:1 arg:2 arg:3 arg:4
     JITTest new testSelf4_1:0 arg:1 arg:2 arg:3
    "

    "Created: / 3.6.1998 / 21:18:26 / cg"
    "Modified: / 3.6.1998 / 21:18:37 / cg"
!

tstSelf4_2:a1 arg:a2 arg:a3 arg:a4
    |local1|

    ^ self

    "
     JITTest new testSelf4_2:1 arg:2 arg:3 arg:4
     JITTest new testSelf4_2:0 arg:1 arg:2 arg:3
    "

    "Created: / 3.6.1998 / 21:18:33 / cg"
!

tstSelf4_3:a1 arg:a2 arg:a3 arg:a4
    |local1|

    local1 := 1.
    ^ self

    "
     JITTest new testSelf4_3:1 arg:2 arg:3 arg:4
     JITTest new testSelf4_3:0 arg:1 arg:2 arg:3
    "

    "Created: / 3.6.1998 / 21:18:42 / cg"
!

tstSelf4_4:a1 arg:a2 arg:a3 arg:a4
    |local1|

    local1 := self.
    ^ local1

    "
     JITTest new testSelf4_4:1 arg:2 arg:3 arg:4
     JITTest new testSelf4_4:0 arg:1 arg:2 arg:3
    "

    "Created: / 3.6.1998 / 21:18:46 / cg"
! !

!JITTest methodsFor:'tests - sends'!

ilcTest1
    "check ilc caching"

    |arr i|

    arr := Array new:10000.
    1 to:10000 do:[:i |
	i odd ifTrue:[
	    arr at:i put:FooClass new
	] ifFalse:[
	    arr at:i put:BarClass new.
	]
    ].

    i := 1.
    [i <= 10] whileTrue:[
	|el expect|

i printCR.
	el := arr at:i.
el printCR.

	i odd ifTrue:[
	    expect := #Foo
	] ifFalse:[
	    expect := #Bar
	].
expect printCR.
	el whatAreYou ~~ expect ifTrue:[
"/            self halt
	].
i print. ' ' print. el printCR.
	i := i + 1.
    ].

"/    i := 1.
"/    [i <= arr size] whileTrue:[
"/        |el expect|
"/
"/        el := arr at:i.
"/
"/        i odd ifTrue:[
"/            expect := #Foo
"/        ] ifFalse:[
"/            expect := #Bar
"/        ].
"/        el whatAreYou ~~ expect ifTrue:[
"/            self halt
"/        ].
"/i print. ' ' print. el printCR.
"/        i := i + 1.
"/    ].
"/
"/    1 to:arr size do:[:i |
"/        |el expect|
"/
"/        el := arr at:i.
"/
"/        i odd ifTrue:[
"/            expect := #Foo
"/        ] ifFalse:[
"/            expect := #Bar
"/        ].
"/        el whatAreYou ~~ expect ifTrue:[
"/            self halt
"/        ].
"/i print. ' ' print. el printCR.
"/    ].
"/
"/    arr keysAndValuesDo:[:i :el |
"/        |expect|
"/
"/        i odd ifTrue:[
"/            expect := #Foo
"/        ] ifFalse:[
"/            expect := #Bar
"/        ].
"/        el whatAreYou ~~ expect ifTrue:[
"/            self halt
"/        ].
"/i print. ' ' print. el printCR.
"/    ].

    "
     JITTest new ilcTest1
     Time millisecondsToRun:[self new ilcTest1]
    "

    "Modified: / 4.6.1998 / 12:13:27 / cg"
!

ilcTest1b
    "check ilc caching"

    |el1 el2|

    el1 := FooClass new.
    el2 := BarClass new.

    el1 whatAreYou printCR. el2 whatAreYou printCR. el1 whatAreYou printCR. el2 whatAreYou printCR.

    "
     JITTest new ilcTest1b
    "

    "Modified: / 4.6.1998 / 12:13:27 / cg"
!

ilcTest1c
    "check simple send"

    |el|

    el := FooClass new.
    el whatAreYou printCR.
    el whatAreYou printCR.

    "
     JITTest new ilcTest1c
    "

    "Modified: / 4.6.1998 / 12:13:27 / cg"
!

ilcTest1d
    "check simple send"

    |el1 el2|

    el1 := FooClass new.
    el2 := BarClass new.
    el1 whatAreYou printCR.
    el2 whatAreYou printCR.
    el1 whatAreYou printCR.
    el2 whatAreYou printCR.

    "
     JITTest new ilcTest1d
    "

    "Modified: / 4.6.1998 / 12:13:27 / cg"
!

tst44:arg
    |l1 l2|

    l1 := 1.
    l2 := 2.
    ^ l1 + l2 + arg + 1

    "
     JITTest new tst44:3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst50
    self tst51

    "
     JITTest new tst50
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst51
    self abs

    "
     JITTest new tst51
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst52
    ^ self abs

    "
     JITTest new tst52
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst53:arg1 with:arg2
    ^ arg1 abs + arg2 abs

    "
     JITTest new tst53:5 with:7
     JITTest new tst53:-5 with:7
     JITTest new tst53:5 with:-7
     JITTest new tst53:-5 with:-7
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tst54
    'hello' printCR

    "
     JITTest new tst54
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstILC1
    |x|

    1 to:4 do:[:i |
	i == 1 ifTrue:[
	    x := self
	].
	i == 2 ifTrue:[
	    x := nil
	].
	i == 3 ifTrue:[x := 1].
	i == 4 ifTrue:[
	    x := true
	].
	x tstInstStore1

	"
	 JITTest new tstILC1
	"

	"Created: / 16.8.1996 / 17:39:44 / cg"
	"Modified: / 17.7.1998 / 16:45:27 / cg"
    ]
!

tstPlus1
    |l1 l2|

    l1 := 1.
    l2 := 2.
    ^ l1 + l2

    "
     JITTest new tstPlus1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstPlusArg1:arg
    ^ arg + 1

    "
     JITTest new tstPlusArg1:1
     JITTest new tstPlusArg1:SmallInteger maxVal
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstPlusUndef1
    |l1 l2|

    ^ l1 + l2

    "
     JITTest new tstPlusUndef1
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstPlusUndef2
    |l1 l2|

    l1 := 1.
    ^ l1 + l2

    "
     JITTest new tstPlusUndef2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstPlusUndef3
    |l1 l2|

    l1 := 1.
    ^ l1 + l2

    "
     JITTest new tstPlusUndef3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSend2
    ^ self tstSend2Helper:1 with:2

    "
     JITTest new tstSend2
     JITTest new tstSend3
     JITTest new tstSend2Helper:1 with:2
     JITTest new tstSend2Helper2:1 with:2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSend2Helper2:arg1 with:arg2
    ^ arg2

    "
     JITTest new tstSend3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSend2Helper:arg1 with:arg2
    ^ arg1

    "
     JITTest new tstSend2
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
!

tstSend3
    ^ self tstSend2Helper2:1 with:2

    "
     JITTest new tstSend3
    "

    "Created: 16.8.1996 / 17:39:44 / cg"
! !

!JITTest::BarClass methodsFor:'queries'!

whatAreYou
    ^ #Bar

    "Created: / 4.6.1998 / 12:05:50 / cg"
!

whatAreYou2
    ^ (self class nameWithoutPrefix copyButLast:5) asSymbol

    "Created: / 4.6.1998 / 12:08:34 / cg"
    "Modified: / 4.6.1998 / 12:10:15 / cg"
! !

!JITTest::FooClass methodsFor:'queries'!

whatAreYou
    ^ #Foo

    "Created: / 4.6.1998 / 12:05:58 / cg"
!

whatAreYou2
    ^ (self class nameWithoutPrefix copyButLast:5) asSymbol

    "Created: / 4.6.1998 / 12:08:59 / cg"
    "Modified: / 4.6.1998 / 12:10:19 / cg"
! !

!JITTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

