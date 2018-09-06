"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BehaviorLookupObjectTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

Object subclass:#BadLookupClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BehaviorLookupObjectTests
!

Object subclass:#ClassWithSpecialLookup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BehaviorLookupObjectTests
!

Object subclass:#LookupClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BehaviorLookupObjectTests
!

Object subclass:#NilReturningLookupClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BehaviorLookupObjectTests
!

!BehaviorLookupObjectTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BehaviorLookupObjectTests methodsFor:'helpers'!

callConstant98765
    ^ self returnConstant98765

    "Created: / 11-07-2016 / 06:26:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2016 / 08:49:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnConstant12345
    ^ 12345

    "Created: / 11-07-2016 / 08:48:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnConstant98765
    ^ 98765
! !

!BehaviorLookupObjectTests methodsFor:'tests'!

testLookupObject_01a
    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new x ] raise:MessageNotUnderstood.

    "/ at some time during the development, it crashed the second time,
    "/ due to a badly updated inlineCache
    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new x ] raise:MessageNotUnderstood.
!

testLookupObject_01b
    |firstException rslt|

    firstException := true.

    "/ catch it, and proceed without a method (leads to another dnu)...
    MessageNotUnderstood handle:[:ex |
        firstException ifTrue:[
            firstException := false.    
            self assert:(ex suspendedContext selector == #doesNotUnderstand:).
            self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
            self assert:(ex suspendedContext sender sender sender selector == #x).

            "/ Remove the lookup object (the original test has been written
            "/ for implementation that flushes the lookup object)
            ClassWithSpecialLookup setLookupObject:nil.
            ObjectMemory flushInlineCaches. 

            "/ here, we return a method...
            ex proceedWith:nil.
        ].
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #x).
        ex proceedWith:12345.
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new x
    ].

    self assert:(rslt = 12345).

    "Modified: / 11-07-2016 / 06:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testLookupObject_01c
    |rslt|

    "/ catch it, and proceed with a method...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector  == #x).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new x
    ].

    self assert:(rslt = 98765).

    "Modified: / 10-07-2016 / 00:31:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testLookupObject_02
    "/ check lookupObject with 2.. arguments
    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new x:1234 ] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7] raise:MessageNotUnderstood.

    ClassWithSpecialLookup setLookupObject:BadLookupClass.
    self should:[ ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8] raise:MessageNotUnderstood.
!

testLookupObject_02c
    |rslt|

    "/ catch it, and proceed with a method...

    "/ 1 arg...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #x:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new x:1234
    ].
    self assert:(rslt = 98765).

    "/ 2 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2
    ].
    self assert:(rslt = 98765).

    "/ 3 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3
    ].
    self assert:(rslt = 98765).

    "/ 4 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4
    ].
    self assert:(rslt = 98765).

    "/ 5 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5
    ].
    self assert:(rslt = 98765).

    "/ 6 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6
    ].
    self assert:(rslt = 98765).

    "/ 7 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7
    ].
    self assert:(rslt = 98765).

    "/ 8 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8
    ].
    self assert:(rslt = 98765).

    "/ 9 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9
    ].
    self assert:(rslt = 98765).

    "/ 10 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10
    ].
    self assert:(rslt = 98765).

    "/ 11 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:k:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10 k:11
    ].
    self assert:(rslt = 98765).

    "/ 12 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:k:l:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10 k:11 l:12
    ].
    self assert:(rslt = 98765).

    "/ 13 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:k:l:m:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10 k:11 l:12 m:13
    ].
    self assert:(rslt = 98765).

    "/ 14 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:k:l:m:n:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10 k:11 l:12 m:13 n:14
    ].
    self assert:(rslt = 98765).

    "/ 15 args...
    MessageNotUnderstood handle:[:ex |
        self assert:(ex suspendedContext selector == #doesNotUnderstand:).
        self assert:(ex suspendedContext sender selector == #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:).
        self assert:(ex suspendedContext sender sender sender selector == #a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:).
        "/ here, we return a method...
        ex proceedWith:(self class compiledMethodAt:#returnConstant98765).
    ] do:[
        ClassWithSpecialLookup setLookupObject:BadLookupClass.
        ObjectMemory flushInlineCaches.
        rslt := ClassWithSpecialLookup new a:1 b:2 c:3 d:4 e:5 f:6 g:7 h:8 i:9 j:10 k:11 l:12 m:13 n:14 o:15
    ].
    self assert:(rslt = 98765).

    "Modified: / 10-07-2016 / 00:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testLookupObject_03
    "/ check good lookupObject with 0.. arguments
    ClassWithSpecialLookup setLookupObject:LookupClass.
    self assert:( ClassWithSpecialLookup new x ) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self assert:( ClassWithSpecialLookup new x:1234 ) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10 a11:11) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10 a11:11 a12:12) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10 a11:11 a12:12 a13:13) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10 a11:11 a12:12 a13:13 a14:14) = 12345.

    ClassWithSpecialLookup setLookupObject:LookupClass.
    self should:( ClassWithSpecialLookup new a1:1 a2:2 a3:3 a4:4 a5:5 a6:6 a7:7 a8:8 a9:9 a10:10 a11:11 a12:12 a13:13 a14:14 a15:15) = 12345.
!

testLookupObject_04
    | x |
    self assert: self callConstant98765 == 98765.
    [ 

        (self class compiledMethodAt: #callConstant98765) setLookupObject: LookupClass.
        ObjectMemory flushCaches.
        ObjectMemory debugBreakPoint3.
        x := self callConstant98765.
        self assert: x == 12345.
    ] ensure:[ 
        (self class compiledMethodAt: #callConstant98765) setLookupObject: nil.
        ObjectMemory flushCaches.
    ].

    "Created: / 11-07-2016 / 06:25:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2016 / 08:49:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BehaviorLookupObjectTests::LookupClass class methodsFor:'lookup'!

lookupMethodForSelector:aSelector directedTo:searchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    ^ self compiledMethodAt:#returnConstant12345
!

lookupMethodForSelector:aSelector directedTo:searchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilc
    ^ self compiledMethodAt:#returnConstant12345

    "Created: / 04-09-2013 / 19:25:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BehaviorLookupObjectTests::LookupClass methodsFor:'trap methods'!

returnConstant12345
    ^ 12345
! !

!BehaviorLookupObjectTests::NilReturningLookupClass class methodsFor:'lookup'!

lookupMethodForSelector:aSelector directedTo:searchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    ^ nil
!

lookupMethodForSelector:aSelector directedTo:searchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilc
    ^ nil

    "Created: / 04-09-2013 / 19:26:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BehaviorLookupObjectTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

