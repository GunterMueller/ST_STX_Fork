"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#DebuggerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!DebuggerTest class methodsFor:'documentation'!

documentation
"
     documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 11.11.2003 / 17:21:55 / cg"
! !

!DebuggerTest methodsFor:'helpers'!

step:nr
    Transcript show:'step '; showCR:nr
! !

!DebuggerTest methodsFor:'tests'!

testBlockVars_01
    |a b me contextInspectorOK|

    contextInspectorOK := true.

    a := #( 1 2 3 4 ).
    b := #( 9 8 7 6 ).
    a do:[:eachA |
	b do:[:eachB |
	    " you should see both eachA and eachB in the debugger "
	    " eachA must be 1
	      eachB must be 9
	    "

	    "/ cg: wait for the debugger to come up,
	    "/ take a look at its local-variables inspector...

	    me := Processor activeProcess.

	    [
		|debuggers theDebugger fieldList idx|

		Delay waitForSeconds:0.5.

		debuggers := DebugView allInstances select:[:dbg | dbg inspectedProcess == me].
		self assert:(debuggers size == 1).
		theDebugger := debuggers first.
		fieldList := theDebugger contextInspector fieldList.
		idx := fieldList findFirst:[:e | e string startsWith:'eachB '].
		idx == 0 ifTrue:[
		    contextInspectorOK := false
		] ifFalse:[
		    (theDebugger contextInspector valueAtLine:idx) == eachB ifFalse:[
			contextInspectorOK := false
		    ].
		].
		idx := fieldList findFirst:[:e | e string startsWith:'eachA '].
		idx == 0 ifTrue:[
		    contextInspectorOK := false
		] ifFalse:[
		    (theDebugger contextInspector valueAtLine:idx) == eachA ifFalse:[
			contextInspectorOK := false
		    ].
		].
		me interruptWith:[theDebugger doAbort "AbortOperationRequest raise"].
	    ] fork.

	    AbortOperationRequest handle:[:ex |
	    ] do:[
		self halt:'checking variables in the debugger...'.
	    ].
	    self assert:contextInspectorOK.
	]
    ]

    "
     self run:#testBlockVars_01
     self new testBlockVars_01
    "
!

testBlockVars_02
    |a b contextInspectorOK me|

    contextInspectorOK := true.

    a := #( 1 2 3 4 ).
    b := #( 9 8 7 6 ).
    a do:[:eachA |
	|outer|

	outer := eachA + 1.
	b do:[:eachB |
	    |inner|

	    inner := eachB + 1.

	    " you should see both eachA and eachB and outer and inner in the debugger "
	    " eachA must be 1 ; outer must be 2
	      eachB must be 9 ; inner must be 10.
	    "
	    "/ cg: wait for the debugger to come up,
	    "/ take a look at its local-variables inspector...

	    me := Processor activeProcess.

	    [
		|debuggers theDebugger fieldList idx|

		Delay waitForSeconds:0.5.

		debuggers := DebugView allInstances select:[:dbg | dbg inspectedProcess == me].
		self assert:(debuggers size == 1).
		theDebugger := debuggers first.
		fieldList := theDebugger contextInspector fieldList.
		idx := fieldList findFirst:[:e | e string startsWith:'eachB '].
		idx == 0 ifTrue:[
		    contextInspectorOK := false
		] ifFalse:[
		    (theDebugger contextInspector valueAtLine:idx) == eachB ifFalse:[
			contextInspectorOK := false
		    ].
		].
		idx := fieldList findFirst:[:e | e string startsWith:'eachA '].
		idx == 0 ifTrue:[
		    contextInspectorOK := false
		] ifFalse:[
		    (theDebugger contextInspector valueAtLine:idx) == eachA ifFalse:[
			contextInspectorOK := false
		    ].
		].
		me interruptWith:[theDebugger doAbort "AbortOperationRequest raise"].
	    ] fork.

	    AbortOperationRequest handle:[:ex |
	    ] do:[
		self halt:'checking variables in the debugger...'.
	    ].
	    self assert:contextInspectorOK.
	]
    ]

    "
     self run:#testBlockVars_02
     self new testBlockVars_02
    "
!

testSteppingInEnsureBlock_01
    self halt:'proceed stepping with "next"-Button'.
    "
     you should be able to single-step through all step-sends...
    "
    self step:1.
    [
	self step:2.
	self step:3.
    ] ensure:[
	self step:4
    ].
    self step:5

    "
     self run:#testSteppingInEnsureBlock_01
     self new testSteppingInEnsureBlock_01
    "
! !

!DebuggerTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

