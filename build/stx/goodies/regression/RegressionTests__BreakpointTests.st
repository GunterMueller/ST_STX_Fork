"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BreakpointTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

!BreakpointTests class methodsFor:'documentation'!

documentation
"
    Testcase to test VM breakpoint support (aka Jan's new breakpoints).
    If the VM is not compiled with new breakpoint support, this tests should
    be skipped.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BreakpointTests methodsFor:'accessing'!

shouldSkip
    "Returns true, if this testcase should be skipped when a testsuite is run.
     This inly a hint, a test runner is not obliged to respect return value.

     Currently, the only user is stx/goodies/builder/reports"

    ^ConfigurableFeatures includesFeature: #VMBreakpointSupport

    "Created: / 09-04-2013 / 11:53:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointTests methodsFor:'mock methods'!

m00
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m01: a1
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m02: a1 _: a2
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:01:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m03: a1 _: a2 _: a3
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:01:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m04: a1 _: a2 _: a3 _: a4
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m05: a1 _: a2 _: a3 _: a4 _: a5
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:02:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m06: a1 _: a2 _: a3 _: a4 _: a5 _: a6
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m07: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:02:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m08: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m09: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:02:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m10: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m11: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m12: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m13: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m14: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

m15: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14 _: a15
    self zork.
    self zork.

    "Created: / 09-04-2013 / 12:03:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mWithBlock
    [ self zork ] 
        valueWithArguments:#(). "/to optimizations
    self zork.

    "Created: / 24-04-2013 / 21:12:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-04-2013 / 22:35:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-04-2013 / 10:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mWithBlock2
    [ [ [ [ self zork ] 
        valueWithArguments:#() ] valueWithArguments:#() ] valueWithArguments:#() ] valueWithArguments:#().
    self zork.

    "
        RegressionTests::BreakpointTests new mWithBlock2
    "

    "Created: / 24-04-2013 / 21:13:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-04-2013 / 09:58:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mWithBlock3 | x |
    x := self. 
    [ [ [ [ x zork 
    ] valueWithArguments:#() ] valueWithArguments:#() ] valueWithArguments:#() ] valueWithArguments:#().
    self zork.

    "Created: / 24-04-2013 / 22:09:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 09:59:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mWithTwoSendsOnLine
    self zork. self zork.
    self zork.

    "Created: / 15-04-2013 / 15:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mWithTwoSendsOnLineInCascade
    self zork; zork.
    self zork.

    "Created: / 15-04-2013 / 15:12:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zork

    "Created: / 09-04-2013 / 12:00:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointTests methodsFor:'running'!

tearDown
    | sels |

    sels :=  self class testSelectors.
    sels addAll: #(setUp tearDown helper_01).
    self class methodDictionary keysAndValuesDo:[:sel :m|
        (sels includes: sel) ifFalse:[
            m breakpointTable: nil.
        ]
    ]

    "Created: / 09-04-2013 / 12:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-04-2013 / 21:45:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointTests methodsFor:'tests'!

helper_01: selector
    ^self perform: selector withBreakpointAt: 2 andAt: 3

    "Created: / 10-04-2013 / 10:50:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 09:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

perform: selector withBreakpointAt: line1 andAt: line2
    | a m nhits |
    m := self class >> selector.
    MessageTracer breakMethod: m atLine: line1.
    a := Array new: m numArgs.

    nhits := 0.
    [       
            self perform: selector withArguments: a
    ] on: BreakPointInterrupt do:[:ex|
            Transcript nextPutAll: 'Breakpointed in ' , selector; cr.
            nhits := nhits + 1.
            MessageTracer breakMethod: m atLine: line2.
            ex proceed.
    ].

    self assert: nhits == 2.

    "Created: / 25-04-2013 / 09:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01

    self helper_01: #m00.
    self helper_01: #m01:.
    self helper_01: #m02:_:.
    self helper_01: #m03:_:_:.
    self helper_01: #m04:_:_:_:.
    self helper_01: #m05:_:_:_:_:.
    self helper_01: #m06:_:_:_:_:_:.
    self helper_01: #m07:_:_:_:_:_:_:.
    self helper_01: #m08:_:_:_:_:_:_:_:.
    self helper_01: #m09:_:_:_:_:_:_:_:_:.
    self helper_01: #m10:_:_:_:_:_:_:_:_:_:.
    self helper_01: #m11:_:_:_:_:_:_:_:_:_:_:.
    self helper_01: #m12:_:_:_:_:_:_:_:_:_:_:_:.
    self helper_01: #m13:_:_:_:_:_:_:_:_:_:_:_:_:.
    self helper_01: #m14:_:_:_:_:_:_:_:_:_:_:_:_:_:.
    self helper_01: #m15:_:_:_:_:_:_:_:_:_:_:_:_:_:_:.

    "Created: / 09-04-2013 / 12:12:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2013 / 10:50:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01b
    | m s |

    m := self class >> #m00.
    s := #STC_m00.

    ChangeSet withoutUpdatingChangesDo:[
        ParserFlags withSTCCompilation:#always do:[
            self class compile: 'STC_', m source classified: 'mock methods - *dynamic*'
        ].
    ].
    [
        self helper_01: s.
    ] ensure:[
        self class removeSelector: s.
    ]

    "Created: / 15-04-2013 / 14:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02a
    "
    Tests two breakpoints on the same line.    
    "
    self helper_01: #mWithTwoSendsOnLine

    "Created: / 15-04-2013 / 15:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02b
    "
    Tests two breakpoints on the same line using cascade/
    "
    self helper_01: #mWithTwoSendsOnLineInCascade

    "Created: / 15-04-2013 / 15:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03a
    "
    Tests two breakpoints in blocks
    "
    self perform: #mWithBlock withBreakpointAt: 2 andAt: 4.

    "Created: / 24-04-2013 / 21:13:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 09:59:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03b
    "
    Tests two breakpoints in blocks
    "
    self perform: #mWithBlock2 withBreakpointAt: 2 andAt: 4.

    "Created: / 24-04-2013 / 21:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 10:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03c
    "
    Tests two breakpoints in blocks
    "
    self perform: #mWithBlock3 withBreakpointAt: 3 andAt: 5.

    "Created: / 24-04-2013 / 22:09:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2013 / 10:04:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

