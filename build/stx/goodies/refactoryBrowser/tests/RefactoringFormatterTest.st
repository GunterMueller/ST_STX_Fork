"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

TestCase subclass:#RefactoringFormatterTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RefactoringFormatterTest class methodsFor:'spec'!

sunitAllSelectors
    ^ (super sunitAllSelectors select:[:sel | sel numArgs == 0])
"/      , (Smalltalk allClasses
"/            select:[:cls | cls isLoaded and:[cls name startsWith:'B'] ]
"/            thenCollect:[:cls | 'test_' , cls name])
! !

!RefactoringFormatterTest methodsFor:'helpers'!

doTestStable
    "all methods must parse the same from the formatted code..."

    "takes VERY long to run - but should be done once in a while"
    Smalltalk allClassesDo:[:eachClass |
	self testStable:eachClass.
    ].

    "
     self new doTestStable
    "
!

doesNotUnderstand:aMessage 
    |className class|

    (aMessage selector startsWith:'test_') ifTrue:[
	className := aMessage selector copyFrom:'test_' size + 1.
	class := Smalltalk at:className asSymbol.
	class notNil ifTrue:[
	    self testStable:class.
	    ^ self
	].
    ].
    ^ super doesNotUnderstand:aMessage.
!

testStable:aClass
    "all methods must parse the same from the formatted code..."

    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	self testStableMethod:mthd.
    ].

    "
     self new testStable:Error
     self new testStable:Color
    "
!

testStableMethod:aMethod
    "all methods must parse the same from the formatted code..."

    |err sourceOrig treeOrig formattedSource1 treeFormatted1 treeFormatted2 
     formattedSource2 formattedSource3|

    Transcript showCR:'  - ' , aMethod selector.
    sourceOrig := aMethod source.

    treeOrig := RBParser parseMethod:sourceOrig onError: [:aString :position | err := aString -> position].
    self assert:(err isNil).
    self assert:(treeOrig notNil).

    formattedSource1 := treeOrig printString.
    treeFormatted1 := RBParser parseMethod:formattedSource1 onError: [:aString :position | err := aString -> position].
    self assert:(err isNil).
    self assert:(treeOrig = treeFormatted1).

    formattedSource2 := treeFormatted1 printString.
    treeFormatted2 := RBParser parseMethod:formattedSource2 onError: [:aString :position | err := aString -> position].
    self assert:(err isNil).
    self assert:(treeFormatted1 = treeFormatted2).

    formattedSource3 := treeFormatted2 printString.

    self assert:(formattedSource2 = formattedSource1).
    self assert:(formattedSource3 = formattedSource1).

    "
     self new testStableMethod:(Color compiledMethodAt:#skipInstvarIndexInDeepCopy:)
    "
! !

!RefactoringFormatterTest methodsFor:'running'!

restorePolicyAfter:aBlock
    |oldPolicy oldBlockStyle|

    oldPolicy := RBFormatter periodAfterLastStatementPolicy.
    oldBlockStyle := RBFormatter cStyleBlocks.
    aBlock value.
    RBFormatter periodAfterLastStatementPolicy:oldPolicy.
    RBFormatter cStyleBlocks:oldBlockStyle.
! !

!RefactoringFormatterTest methodsFor:'testing'!

testBlocks1
    |in out|

    self restorePolicyAfter:[
	RBFormatter cStyleBlocks:false.

	in := 'foo ^ []'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ []').

	in := 'foo ^ [nil]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ [ nil ]').

	in := 'foo ^ [:a]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ [:a | ]').

	in := 'foo ^ [:a|nil]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ [:a | nil ]').
    ]

    "
     self new testBlocks1
    "
!

testBlocks2
    |in out|

    self restorePolicyAfter:[
	RBFormatter cStyleBlocks:false.

	in := 'foo ^ []'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ []').

	in := 'foo ^ [nil]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ [ nil ]').
    ]

    "
     self new testBlocks2
    "
!

testBlocks3
    |in out|

    self restorePolicyAfter:[
	RBFormatter cStyleBlocks:false.

	in := 'foo 1>2 ifTrue:[]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    1 > 2 ifTrue:[]').

	in := 'foo 1>2 ifTrue:[self foo. self bar.]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    1 > 2 
	ifTrue:
	    [ self foo.
	    self bar. ]').
    ]

    "
     self new testBlocks3
    "
!

testComments1   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    ^ self

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    ^ self

    "comment1"
    "comment2"').
    ].

    "
     self new testComments1
    "
!

testComments10   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    #(1 2 
      3 4)

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    #( 1 2
       3 4 )

    "comment1"
    "comment2"').
    ].

    "
     self new testComments10
    "
!

testComments11   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo
    [ true ] whileTrue:[
	self a.
	"/ comment1
    ]

    "comment2"
    "comment3"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    [ true ] whileTrue:[
	self a.
	"/ comment1
    ]

    "comment2"
    "comment3"').
    ].

    "
     self new testComments11
    "
!

testComments12   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo
    [ true ] whileTrue:[
	self a.
"/ comment1
    ]

    "comment2"
    "comment3"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    [ true ] whileTrue:[
	self a.
"/ comment1
    ]

    "comment2"
    "comment3"').
    ].

    "
     self new testComments12
    "
!

testComments13   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo
    false "aBoolean" ifTrue:[
	self a.
    ]'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    false "aBoolean" ifTrue:[
	self a.
    ]').
    ].

    "
     self new testComments13
    "
!

testComments14   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := '    self halt.
"/ comment
    self halt.'.

	out := RBFormatter format:in.

	self assert:(out = '    self halt.
"/ comment
    self halt.').
    ].

    "
     self new testComments14    
    "
!

testComments2   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    self bar

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    self bar

    "comment1"
    "comment2"').
    ].

    "
     self new testComments2
    "
!

testComments3   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    self + 1

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    self + 1

    "comment1"
    "comment2"').
    ].

    "
     self new testComments3
    "
!

testComments4   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    self at:1

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    self at:1

    "comment1"
    "comment2"').
    ].

    "
     self new testComments4
    "
!

testComments5   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    [ self ] value

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    [ self ] value

    "comment1"
    "comment2"').
    ].

    "
     self new testComments5
    "
!

testComments6   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    [ self ]

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    [ self ]

    "comment1"
    "comment2"').
    ].

    "
     self new testComments6
    "
!

testComments7   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    #foo

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    #foo

    "comment1"
    "comment2"').
    ].

    "
     self new testComments7
    "
!

testComments8   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    ''hello''

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    ''hello''

    "comment1"
    "comment2"').
    ].

    "
     self new testComments8
    "
!

testComments9   
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo 
    #(1 2 3 4)

    "comment1"
    "comment2"'.

	out := RBFormatter format:in.

	self assert:(out = 'foo
    #( 1 2 3 4 )

    "comment1"
    "comment2"').
    ].

    "
     self new testComments9
    "
!

testLiteralArray1
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ #( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 )'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ #( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 )').
    ]

    "
     self new testLiteralArray1
    "
!

testLiteralArray2
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ #( 1 2 3 4 5 6 7 8 9 10 
			11 12 13 14 15 16 17 18 19 )'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ #( 1 2 3 4 5 6 7 8 9 10
	 11 12 13 14 15 16 17 18 19 )').
    ]

    "
     self new testLiteralArray2
    "
!

testNumbers1
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ 1234'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ 1234').
    ].

    "
     self new testNumbers1
    "
!

testNumbers2
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ 16r1234'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ 16r1234').
    ]

    "
     self new testNumbers2
    "
!

testNumbers3
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ 2r010101'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ 2r010101').
    ]

    "
     self new testNumbers3
    "
!

testNumbersInLiterals1
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ #(2r010101 16rAFFE 16raffe 1234)'.
	out := RBFormatter format:in.
	self assert:(
		out = 'foo
    ^ #( 2r010101 16rAFFE 16raffe 1234 )'
	).
    ].

    "
     self new testNumbersInLiterals1
    "
!

testNumbersInLiterals2
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo ^ #[ 2r010101 16rFF 16raa 123]'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    ^ #[ 2r010101 16rFF 16raa 123 ]').
    ]

    "
     self new testNumbersInLiterals2
    "
!

testPeriods1
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#add.

	in := 'foo self foo. ^ self bar'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar.').

	in := 'foo self foo. ^ self bar.'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar.').
    ].

    "
     self new testPeriods1
    "
!

testPeriods2
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#remove.

	in := 'foo self foo. ^ self bar'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar').

	in := 'foo self foo. ^ self bar.'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar').
    ]

    "
     self new testPeriods2
    "
!

testPeriods3
    |in out|

    self restorePolicyAfter:[
	RBFormatter periodAfterLastStatementPolicy:#keep.

	in := 'foo self foo. ^ self bar'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar').
	in := 'foo self foo. ^ self bar.'.
	out := RBFormatter format:in.
	self assert:(out = 'foo
    self foo.
    ^ self bar.').
    ]

    "
     self new testPeriods3
    "
!

testSimple1
    |in out|

    in := 'foo ^ self'.
    out := RBFormatter format:in.
    self assert:(out = 'foo
    ^ self.' or:[out = 'foo
    ^ self']).

    "
     self new testSimple1
    "
!

testStable
    "all methods must parse the same from the formatted code..."

    "takes VERY long to run - but should be done once in a while"
^ self.
    self doTestStable

    "
     self new testStable
    "
! !

!RefactoringFormatterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RefactoringFormatterTest.st,v 1.18 2003-10-06 14:39:33 cg Exp $'
! !
