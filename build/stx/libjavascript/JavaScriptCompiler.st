"
 COPYRIGHT (c) 2005 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

JavaScriptParser subclass:#JavaScriptCompiler
	instanceVariableNames:'codeBytes codeIndex litArray stackDelta extra lineno extraLiteral
		maxStackDepth relocList methodTempVars numTemp maxNumTemp
		methodClass loopStack currentLineNumber'
	classVariableNames:'JumpToAbsJump'
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

Object subclass:#LoopDescription
	instanceVariableNames:'breakLabel continueLabel backPatchListForBreak
		backPatchListForContinue'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptCompiler
!

Object subclass:#LoopDescriptionForBlock
	instanceVariableNames:'deltaScope'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptCompiler
!

JavaScriptCompiler::LoopDescription subclass:#SwitchDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptCompiler
!

!JavaScriptCompiler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    JavaScriptCompiler has a lot of stuff copied from ByteCodeCompiler.
    This is a very BAD SMELL!!
"
!

examples
"
				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'max(a, b) {
		    if (a > b) return a;
		    return b;
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(10 20).
				    [exEnd]



				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'max(a, b) {
		    if (a > b) ;
		    else return b;
		    return a;
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(10 20).
				    [exEnd]




				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'max(a, b) {
		    if (a > b) return a;
		    else return b;
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(20 10).
				    [exEnd]



				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:('test(arg) {
		    var n;

		    n = arg;
		    while (n > 0) {
			n--;
			Transcript.showCR(#hello#);
		    }
		 }' replaceAll:$# with:Character doubleQuote)
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(5).
				    [exEnd]


				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:('test(arg) {
		    var n;

		    n = 1;
		    while (n <= arg) {
			n++;
			Transcript.showCR(#hello#);
		    }
		 }' replaceAll:$# with:Character doubleQuote)
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(5).
				    [exEnd]


				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'test(arg) {
		    var n;

		    n = 1;
		    while (n <= arg) {
			Transcript.showCR(n++);
		    }
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(5).
				    [exEnd]

				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'test(arg) {
		    var n;

		    n = 1;
		    while (n++ <= arg) {
			Transcript.showCR(n);
		    }
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#(5).
				    [exEnd]

				    [exBegin]
    |f|

    f := JavaScriptCompiler
	compile:'foo() {
		    Transcript.showCR(''start'');
		    try {
			Error.raise();
		    } catch(Error) {
			Transcript.showCR(''caught error'');
		    };
		    Transcript.showCR(''end'');
		 }'
	forClass:nil
	inCategory:nil
	notifying:nil.
    f valueWithReceiver:nil arguments:#().
				    [exEnd]
"
! !

!JavaScriptCompiler class methodsFor:'instance creation'!

new

    "/ Pretty ugly hack. A caller to compiler may provide a set of breakpoints
    "/ that has to be injected to the code. However, since breakpoint injection
    "/ is actually done by a subclass or me, so we have to return this subclass here.
    "/ This subclass-to-tranform API is bit unfortunate.
    ^ self ~~ JavaScriptCompiler ifTrue:[
	super new.
    ] ifFalse:[
	| breakpoints |

	breakpoints := BreakpointQuery query.
	breakpoints notEmptyOrNil ifTrue:[
	    JavaScriptCompilerWithBreakpointSupport new
		breakpoints: breakpoints;
		yourself.
	] ifFalse:[
	    super new.
	].
    ].

    "Created: / 08-05-2014 / 11:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-05-2014 / 13:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompiler class methodsFor:'compiling methods'!

compile:aString forClass:aClass inCategory:cat
    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:nil
	install:true
	skipIfSame:false
	silent:false
	foldConstants:true

    "Created: / 30-01-2011 / 16:59:00 / cg"
!

compile:aString forClass:aClass inCategory:cat notifying:requestor
    "compile a source-string for a method in classToCompileFor.
     errors are forwarded to requestor.
     The method will get cat as category.
     Returns the new method, #Error or nil."

    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:true
	skipIfSame:false
	silent:false
	foldConstants:true
!

compile:aString forClass:aClass inCategory:cat notifying:requestor install:install
    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:install
	skipIfSame:false
	silent:false
!

compile:aString forClass:aClass inCategory:cat notifying:requestor
		 install:install skipIfSame:skipIfSame silent:silent
    "compile a source-string for a method in aClass.
     errors are forwarded to requestor.
     The method will get cat as category.
     if install is true, the method is installed in the class.
     if skipIfSame, the method is not installed if there is no change
     (used when filing in).
     if silent is true, no warnings are output.
     Returns the new method, #Error or nil."

    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:install
	skipIfSame:skipIfSame
	silent:silent
	foldConstants:true
!

compile:aString forClass:aClass inCategory:cat notifying:requestor
		 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
    |compiler |

    compiler := self new.
    "/ not needed...
    "/ compiler := self for:(ReadStream on:aString).
    "/ compiler setClassToCompileFor:aClass.
    "/ compiler nextToken.

    ^ compiler
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:requestor
	install:install
	skipIfSame:skipIfSame
	silent:silent
	foldConstants:fold

    "Modified: / 30-09-2011 / 12:49:29 / cg"
!

compile:aString in:aClass notifying:requestor ifFail:failBlock
    |newMethod|

    newMethod := self
	compile:aString
	forClass:aClass
	inCategory:'no category'
	notifying:requestor
	install:true
	skipIfSame:false
	silent:false
	foldConstants:true.
    newMethod == #Error ifTrue:[
	^ failBlock value
    ].
    ^ newMethod
!

evaluate:aString notifying:requestor compile:doCompile
    "used to install new classes"

    |tree|

    tree := self parseClassDefinition:aString.
    ^ tree evaluate.
!

newCodeSet
    ^ true
! !

!JavaScriptCompiler class methodsFor:'private'!

selectorFor:functionName numArgs:nargs
    (nargs == 1) ifTrue:[
	^ (functionName , ':') asSymbol.
    ].
    (nargs == 2) ifTrue:[
	^ (functionName , ':_:') asSymbol.
    ].
    (nargs == 3) ifTrue:[
	^ (functionName , ':_:_:') asSymbol.
    ].
    ^ (functionName , (':_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:' copyTo:nargs*2-1)) asSymbol.
! !

!JavaScriptCompiler methodsFor:'accessing'!

methodClass:something
    methodClass := something.
! !

!JavaScriptCompiler methodsFor:'code generation'!

absJumpFromJump:code
    "given a jump-symbolic code, return corresponding absolute jump"

    JumpToAbsJump isNil ifTrue:[
	JumpToAbsJump := IdentityDictionary new.
	JumpToAbsJump at:#jump put:#jumpabs.
	JumpToAbsJump at:#trueJump put:#trueJumpabs.
	JumpToAbsJump at:#falseJump put:#falseJumpabs.
	JumpToAbsJump at:#nilJump put:#nilJumpabs.
	JumpToAbsJump at:#notNilJump put:#notNilJumpabs.
	JumpToAbsJump at:#eqJump put:#eqJumpabs.
	JumpToAbsJump at:#notEqJump put:#notEqJumpabs.
	JumpToAbsJump at:#zeroJump put:#zeroJumpabs.
	JumpToAbsJump at:#notZeroJump put:#notZeroJumpabs.
	JumpToAbsJump at:#makeBlock put:#makeBlockabs.
    ].
    ^ JumpToAbsJump at:code
!

addLiteral:anObject
    "add a literal to the literalArray - watch for and eliminate
     duplicates. return the index of the literal in the Array"

    |index "{ Class: SmallInteger }" oldLit class|

    litArray isNil ifTrue:[
	litArray := Array with:anObject.
	^ 1
    ].
    index := litArray identityIndexOf:anObject.
    (index == 0) ifTrue:[
	"
	 reuse constants if same value and same class
	"
	class := anObject class.
	((class == Float)
	or:[class == Fraction
	or:[class == LargeInteger
	"or:[class == String] --only if literalString option has been added---" ]]) ifTrue:[
	    index := litArray indexOf:anObject.
	    index ~~ 0 ifTrue:[
		oldLit := litArray at:index.
		oldLit class == class ifFalse:[
		    index := 0.
		] ifTrue:[
		    "/ dont mess up negative with positive zeros
		    anObject = 0.0 ifTrue:[
			anObject isNegativeZero ~~ oldLit isNegativeZero ifTrue:[
			    index := 0
			]
		    ]
		].
	    ].
	].
	(index == 0) ifTrue:[
	    litArray := litArray copyWith:anObject.
	    ^ litArray size
	].
    ].
    ^ index

    "Modified: / 12.11.1997 / 18:49:43 / cg"
!

addReloc:symIndex
    "remember to relocate offset at symIndex later ..."

    relocList isNil ifTrue:[
	relocList := OrderedCollection new.
    ].
    relocList add:symIndex
!

appendByte:aByte
    "append a byte to the code-Array, checking for byte-range (debug-only)"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    (aByte between:0 and:255) ifTrue:[
	codeBytes at:idx put:aByte.
	codeIndex := idx + 1
    ] ifFalse:[
	self error:'byte range error'.
	errorFlag := #Error
    ]
!

appendByteCodeFor:codeSymbol
    "append the byteCode for an instructionSymbol to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:(self byteCodeFor:codeSymbol).
    codeIndex := idx + 1
!

appendEmptyByte
    "append an empty byte to the code-Array"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    codeBytes at:idx put:0.
    codeIndex := idx + 1
!

appendSignedByte:aByte
    "append a signedbyte (as in jump-offsets) to the code-Array,
     check range and report an error if invalid"

    |b   "{Class: SmallInteger }"
     idx "{Class: SmallInteger }"|

    idx := codeIndex.
    b := aByte.
    (b >= 0) ifTrue:[
	(b > 127) ifTrue:[
	    self error:'jump-range error'.
	    errorFlag := #Error
	].
	codeBytes at:idx put:b
    ] ifFalse:[
	(b < -128) ifTrue:[
	    self error:'jump-range error'.
	    errorFlag := #Error
	].
	b := 256 + b
    ].
    codeBytes at:idx put:b.
    codeIndex := idx + 1
!

appendSignedWord:aWord
    "append a signed word to the code-Array,
     check range and report an error if invalid"

    |w   "{Class: SmallInteger }"|

    w := aWord.
    (w >= 0) ifTrue:[
	(w > 16r7FFFF) ifTrue:[
	    self error:'word-range error'.
	    errorFlag := #Error
	].
    ] ifFalse:[
	(w < 16r-8000) ifTrue:[
	    self error:'word-range error'.
	    errorFlag := #Error
	].
	w := (16r10000 + w).
    ].
    self appendWord:w
!

appendWord:aWord
    "append an unsigned word (low-high) to the code-Array,
     checking for word-range (debug-only)"

    |idx "{Class: SmallInteger }"|

    idx := codeIndex.
    (aWord between:0 and:16rFFFF) ifTrue:[
	codeBytes at:idx put:(aWord bitAnd:16rFF).
	idx := idx + 1.
	codeBytes at:idx put:(aWord bitShift:-8).
	codeIndex := idx + 1
    ] ifFalse:[
	self error:'word range error'.
	errorFlag := #Error
    ]
!

byteCodeFor:aSymbol
    "given a symbolic instruction, return the corresponding bytecode.
     as a side-effect, leave number of bytes pushed/popped by this instr.
     in stackDelta, and, if the instruction needs extra arguments, leave
     this info in extra. Also lineno is set to true, if this code has line
     information and extraLiteral is set if any hidden send is performed by it."

    "standard bytecodes"

    (aSymbol == #pushNil) ifTrue:[stackDelta := 1. ^ 10].
    (aSymbol == #pushTrue) ifTrue:[stackDelta := 1. ^ 11].
    (aSymbol == #pushFalse) ifTrue:[stackDelta := 1. ^ 12].
    (aSymbol == #pushLit) ifTrue:[stackDelta := 1. extra := #lit. ^ 14].
    (aSymbol == #pushLitS) ifTrue:[stackDelta := 1. extra := #index. ^ 14].
    (aSymbol == #pushSelf) ifTrue:[stackDelta := 1. ^ 15].
    (aSymbol == #pushNum) ifTrue:[stackDelta := 1. extra := #number. ^ 16].

    (aSymbol == #pushMethodArg) ifTrue:[stackDelta := 1. extra := #index. ^ 30].
    (aSymbol == #pushMethodVar) ifTrue:[stackDelta := 1. extra := #index. ^ 31].
    (aSymbol == #pushBlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 32].
    (aSymbol == #pushBlockVar) ifTrue:[stackDelta := 1. extra := #index. ^ 33].
    (aSymbol == #pushInstVar) ifTrue:[stackDelta := 1. extra := #index. ^ 34].
    (aSymbol == #pushOuterBlockArg) ifTrue:[stackDelta := 1. extra := #indexLevel. ^ 42].
    (aSymbol == #pushOuterBlockVar) ifTrue:[stackDelta := 1. extra := #indexLevel. ^ 128].

    (aSymbol == #retTop) ifTrue:[stackDelta := -1. ^ 0].
    (aSymbol == #retSelf) ifTrue:[^5].

    (aSymbol == #==) ifTrue:[stackDelta := -1. extraLiteral := aSymbol. ^ 45].
    (aSymbol == #~~) ifTrue:[stackDelta := -1. extraLiteral := aSymbol. ^ 46].

    (aSymbol == #falseJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 50].
    (aSymbol == #trueJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 51].
    (aSymbol == #nilJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 52].
    (aSymbol == #notNilJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 53].
    (aSymbol == #jump) ifTrue:[extra := #offset. ^ 54].
    (aSymbol == #makeBlock) ifTrue:[stackDelta := 1. extra := #offsetNvarNarg. ^ 55].
    (aSymbol == #zeroJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 56].
    (aSymbol == #notZeroJump) ifTrue:[stackDelta := -1. extra := #offset. ^ 57].
    (aSymbol == #eqJump) ifTrue:[stackDelta := -2. extra := #offset. ^ 58].
    (aSymbol == #notEqJump) ifTrue:[stackDelta := -2. extra := #offset. ^ 59].

    (aSymbol == #lineno) ifTrue:[lineno := true. ^ 8].
    (aSymbol == #lineno16) ifTrue:[lineno := true. ^ 9].

    (aSymbol == #send) ifTrue:[lineno := true. extra := #special. ^ 19].
    (aSymbol == #superSend) ifTrue:[lineno := true. extra := #special. ^ 20].
    (aSymbol == #hereSend) ifTrue:[lineno := true. extra := #special. ^ 20].
    (aSymbol == #sendSelf) ifTrue:[lineno := true. extra := #special. ^ 13].

    (aSymbol == #drop) ifTrue:[stackDelta := -1. ^ 18].
    (aSymbol == #dup) ifTrue:[stackDelta := 1. ^ 47].

    (aSymbol == #storeMethodVar) ifTrue:[extra := #index. stackDelta := -1. ^ 37].
    (aSymbol == #storeBlockVar) ifTrue:[extra := #index. stackDelta := -1. ^ 38].
    (aSymbol == #storeInstVar) ifTrue:[extra := #index. stackDelta := -1. ^ 39].

    "/ the next 2 are to be obsoleted soon (renamed as MethodLocal)
    (aSymbol == #pushLocal) ifTrue:[ stackDelta := 1. extra := #index. ^ 239].
    (aSymbol == #storeLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 240].

    (aSymbol == #pushMethodLocal) ifTrue:[ stackDelta := 1. extra := #index. ^ 239].
    (aSymbol == #storeMethodLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 240].
    (aSymbol == #storeBlockLocal) ifTrue:[ stackDelta := -1. extra := #index. ^ 241].
    (aSymbol == #storeOuterBlockLocal) ifTrue:[ stackDelta := -1. extra := #indexLevel. ^ 242].

    (aSymbol == #pushClassVarS) ifTrue:[stackDelta := 1. extra := #speciallitS. ^ 35].
    (aSymbol == #pushGlobalS) ifTrue:[stackDelta := 1. extra := #speciallitS. ^ 36].

    (aSymbol == #storeClassVarS) ifTrue:[extra := #speciallitS.stackDelta := -1. ^ 40].
    (aSymbol == #storeGlobalS) ifTrue:[extra := #speciallitS. stackDelta := -1. ^ 41].
    (aSymbol == #pushSpecialGlobal) ifTrue:[stackDelta := 1. extra := #index. ^ 200].

    (aSymbol == #storeOuterBlockVar) ifTrue:[stackDelta := -1. extra := #indexLevel. ^ 129].

    (aSymbol == #pushClassInstVar) ifTrue:[stackDelta := 1. extra := #index. ^ 176].
    (aSymbol == #storeClassInstVar) ifTrue:[extra := #index.stackDelta := -1. ^ 177].

    "optimized bytecodes"

    (aSymbol == #retNil) ifTrue:[^ 1].
    (aSymbol == #retTrue) ifTrue:[^ 2].
    (aSymbol == #retFalse) ifTrue:[^ 3].
    (aSymbol == #ret0) ifTrue:[^ 4].
    (aSymbol == #retNum) ifTrue:[extra := #number. ^ 127].
    (aSymbol == #homeRetTop) ifTrue:[^ 7].

    (aSymbol == #pushNum16) ifTrue:[stackDelta := 1. extra := #number16. ^ 17].
    (aSymbol == #push0) ifTrue:[stackDelta := 1. ^120].
    (aSymbol == #push1) ifTrue:[stackDelta := 1. ^121].
    (aSymbol == #push2) ifTrue:[stackDelta := 1. ^139].
    (aSymbol == #pushMinus1) ifTrue:[stackDelta := 1. ^122].

    (aSymbol == #send0) ifTrue:[lineno := true. extra := #index. ^21].
    (aSymbol == #send1) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^22].
    (aSymbol == #send2) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^23].
    (aSymbol == #send3) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^24].

    (aSymbol == #sendSelf0) ifTrue:[lineno := true. extra := #index. stackDelta := 1. ^180].
    (aSymbol == #sendSelf1) ifTrue:[lineno := true. extra := #index. ^181].
    (aSymbol == #sendSelf2) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^182].
    (aSymbol == #sendSelf3) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^183].
    (aSymbol == #sendSelfDrop0) ifTrue:[lineno := true. extra := #index. ^184].
    (aSymbol == #sendSelfDrop1) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^185].
    (aSymbol == #sendSelfDrop2) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^186].
    (aSymbol == #sendSelfDrop3) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^187].

    (aSymbol == #sendDrop) ifTrue:[lineno := true. extra := #special. ^25].
    (aSymbol == #sendDrop0) ifTrue:[lineno := true. extra := #index. stackDelta := -1. ^26].
    (aSymbol == #sendDrop1) ifTrue:[lineno := true. extra := #index. stackDelta := -2. ^27].
    (aSymbol == #sendDrop2) ifTrue:[lineno := true. extra := #index. stackDelta := -3. ^28].
    (aSymbol == #sendDrop3) ifTrue:[lineno := true. extra := #index. stackDelta := -4. ^29].

    (aSymbol == #pushMethodVar1) ifTrue:[stackDelta := 1. ^80].
    (aSymbol == #pushMethodVar2) ifTrue:[stackDelta := 1. ^81].
    (aSymbol == #pushMethodVar3) ifTrue:[stackDelta := 1. ^82].
    (aSymbol == #pushMethodVar4) ifTrue:[stackDelta := 1. ^83].
    (aSymbol == #pushMethodVar5) ifTrue:[stackDelta := 1. ^84].
    (aSymbol == #pushMethodVar6) ifTrue:[stackDelta := 1. ^85].

    (aSymbol == #pushMethodArg1) ifTrue:[stackDelta := 1. ^86].
    (aSymbol == #pushMethodArg2) ifTrue:[stackDelta := 1. ^87].
    (aSymbol == #pushMethodArg3) ifTrue:[stackDelta := 1. ^88].
    (aSymbol == #pushMethodArg4) ifTrue:[stackDelta := 1. ^89].

    (aSymbol == #pushInstVar1) ifTrue:[stackDelta := 1. ^90].
    (aSymbol == #pushInstVar2) ifTrue:[stackDelta := 1. ^91].
    (aSymbol == #pushInstVar3) ifTrue:[stackDelta := 1. ^92].
    (aSymbol == #pushInstVar4) ifTrue:[stackDelta := 1. ^93].
    (aSymbol == #pushInstVar5) ifTrue:[stackDelta := 1. ^94].
    (aSymbol == #pushInstVar6) ifTrue:[stackDelta := 1. ^95].
    (aSymbol == #pushInstVar7) ifTrue:[stackDelta := 1. ^96].
    (aSymbol == #pushInstVar8) ifTrue:[stackDelta := 1. ^97].
    (aSymbol == #pushInstVar9) ifTrue:[stackDelta := 1. ^98].
    (aSymbol == #pushInstVar10) ifTrue:[stackDelta := 1. ^99].

    (aSymbol == #storeMethodVar1) ifTrue:[stackDelta := -1. ^100].
    (aSymbol == #storeMethodVar2) ifTrue:[stackDelta := -1. ^101].
    (aSymbol == #storeMethodVar3) ifTrue:[stackDelta := -1. ^102].
    (aSymbol == #storeMethodVar4) ifTrue:[stackDelta := -1. ^103].
    (aSymbol == #storeMethodVar5) ifTrue:[stackDelta := -1. ^104].
    (aSymbol == #storeMethodVar6) ifTrue:[stackDelta := -1. ^105].

    (aSymbol == #storeInstVar1) ifTrue:[stackDelta := -1. ^110].
    (aSymbol == #storeInstVar2) ifTrue:[stackDelta := -1. ^111].
    (aSymbol == #storeInstVar3) ifTrue:[stackDelta := -1. ^112].
    (aSymbol == #storeInstVar4) ifTrue:[stackDelta := -1. ^113].
    (aSymbol == #storeInstVar5) ifTrue:[stackDelta := -1. ^114].
    (aSymbol == #storeInstVar6) ifTrue:[stackDelta := -1. ^115].
    (aSymbol == #storeInstVar7) ifTrue:[stackDelta := -1. ^116].
    (aSymbol == #storeInstVar8) ifTrue:[stackDelta := -1. ^117].
    (aSymbol == #storeInstVar9) ifTrue:[stackDelta := -1. ^118].
    (aSymbol == #storeInstVar10) ifTrue:[stackDelta := -1. ^119].

    (aSymbol == #pushLit1) ifTrue:[stackDelta := 1. ^ 222].
    (aSymbol == #pushLit2) ifTrue:[stackDelta := 1. ^ 223].
    (aSymbol == #pushLit3) ifTrue:[stackDelta := 1. ^ 224].
    (aSymbol == #pushLit4) ifTrue:[stackDelta := 1. ^ 225].
    (aSymbol == #pushLit5) ifTrue:[stackDelta := 1. ^ 226].
    (aSymbol == #pushLit6) ifTrue:[stackDelta := 1. ^ 227].
    (aSymbol == #pushLit7) ifTrue:[stackDelta := 1. ^ 228].
    (aSymbol == #pushLit8) ifTrue:[stackDelta := 1. ^ 229].

    (aSymbol == #retMethodVar1) ifTrue:[^160].
    (aSymbol == #retMethodVar2) ifTrue:[^161].
    (aSymbol == #retMethodVar3) ifTrue:[^162].
    (aSymbol == #retMethodVar4) ifTrue:[^163].
    (aSymbol == #retMethodVar5) ifTrue:[^164].
    (aSymbol == #retMethodVar6) ifTrue:[^165].

    (aSymbol == #retInstVar1) ifTrue:[^166].
    (aSymbol == #retInstVar2) ifTrue:[^167].
    (aSymbol == #retInstVar3) ifTrue:[^168].
    (aSymbol == #retInstVar4) ifTrue:[^169].
    (aSymbol == #retInstVar5) ifTrue:[^170].
    (aSymbol == #retInstVar6) ifTrue:[^171].
    (aSymbol == #retInstVar7) ifTrue:[^172].
    (aSymbol == #retInstVar8) ifTrue:[^173].

    (aSymbol == #retMethodArg1) ifTrue:[^174].
    (aSymbol == #retMethodArg2) ifTrue:[^175].

    (aSymbol == #pushBlockArg1) ifTrue:[stackDelta := 1. ^140].
    (aSymbol == #pushBlockArg2) ifTrue:[stackDelta := 1. ^141].
    (aSymbol == #pushBlockArg3) ifTrue:[stackDelta := 1. ^142].
    (aSymbol == #pushBlockArg4) ifTrue:[stackDelta := 1. ^143].

    (aSymbol == #pushOuter1BlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 43].
    (aSymbol == #pushOuter2BlockArg) ifTrue:[stackDelta := 1. extra := #index. ^ 44].

    (aSymbol == #=) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^130].
    (aSymbol == #+) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^131].
    (aSymbol == #~=) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^132].
    (aSymbol == #-) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^133].
    (aSymbol == #*) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^230].
    (aSymbol == #class) ifTrue:[extraLiteral := aSymbol. ^134].
"/    (aSymbol == #x) ifTrue:[lineno := true. extraLiteral := aSymbol. ^106].
"/    (aSymbol == #y) ifTrue:[lineno := true. extraLiteral := aSymbol. ^107].
"/    (aSymbol == #width) ifTrue:[lineno := true. extraLiteral := aSymbol. ^108].
"/    (aSymbol == #height) ifTrue:[lineno := true. extraLiteral := aSymbol. ^109].
"/    (aSymbol == #origin) ifTrue:[lineno := true. extraLiteral := aSymbol. ^154].
"/    (aSymbol == #extent) ifTrue:[lineno := true. extraLiteral := aSymbol. ^155].
    (aSymbol == #at:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^135].
    (aSymbol == #at:put:)ifTrue:[lineno := true. stackDelta := -2. extraLiteral := aSymbol. ^136].
    (aSymbol == #bitAnd:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^137].
    (aSymbol == #bitOr:) ifTrue:[lineno := true. stackDelta := -1. extraLiteral := aSymbol. ^138].
    (aSymbol == #plus1) ifTrue:[lineno := true. extraLiteral := #+. ^123].
    (aSymbol == #minus1) ifTrue:[lineno := true. extraLiteral := #-. ^124].

    (aSymbol == #incMethodVar) ifTrue:[lineno := true. extraLiteral := #+. extra := #index. ^125].
    (aSymbol == #decMethodVar) ifTrue:[lineno := true. extraLiteral := #-. extra := #index. ^126].

    (aSymbol == #eq0) ifTrue:[extraLiteral := #==. ^48].
    (aSymbol == #ne0) ifTrue:[extraLiteral := #~~. ^49].

    (aSymbol == #>) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 145].
    (aSymbol == #>=) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 146].
    (aSymbol == #<) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 147].
    (aSymbol == #<=) ifTrue:[lineno := true. extraLiteral := aSymbol. stackDelta := -1. ^ 148].
"/    (aSymbol == #next) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 149].
"/    (aSymbol == #peek) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 150].
    (aSymbol == #value) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 151].
    (aSymbol == #value:) ifTrue:[lineno := true. extraLiteral := aSymbol.  stackDelta := -1. ^ 152].
    (aSymbol == #value:value:) ifTrue:[lineno := true. extraLiteral := aSymbol.  stackDelta := -2. ^ 178].
    (aSymbol == #size) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 153].
"/    (aSymbol == #asInteger) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 158].
"/    (aSymbol == #rounded) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 159].
    (aSymbol == #mk0Block) ifTrue:[^ 156].
    (aSymbol == #mkNilBlock) ifTrue:[^ 157].

    (aSymbol == #gt0) ifTrue:[lineno := true. extraLiteral := #>. ^ 212].
    (aSymbol == #pushgt0) ifTrue:[lineno := true. stackDelta := 1. extraLiteral := #>. ^ 208].
    (aSymbol == #basicNew) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 211].
    (aSymbol == #new) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 213].
    (aSymbol == #basicNew:) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 214].
    (aSymbol == #new:) ifTrue:[lineno := true. extraLiteral := aSymbol. ^ 215].

    (aSymbol == #pushBlockVar1) ifTrue:[stackDelta := 1. ^ 232].
    (aSymbol == #pushBlockVar2) ifTrue:[stackDelta := 1. ^ 233].
    (aSymbol == #pushBlockVar3) ifTrue:[stackDelta := 1. ^ 234].
    (aSymbol == #storeBlockVar1) ifTrue:[stackDelta := -1. ^ 235].
    (aSymbol == #storeBlockVar2) ifTrue:[stackDelta := -1. ^ 236].
    (aSymbol == #storeBlockVar3) ifTrue:[stackDelta := -1. ^ 237].

    (aSymbol == #falseJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 190].
    (aSymbol == #trueJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 191].
    (aSymbol == #nilJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 192].
    (aSymbol == #notNilJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 193].
    (aSymbol == #jumpabs) ifTrue:[extra := #absoffset. ^ 194].
    (aSymbol == #makeBlockabs) ifTrue:[stackDelta := 1. extra := #absoffsetNvarNarg. ^ 195].
    (aSymbol == #zeroJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 196].
    (aSymbol == #notZeroJumpabs) ifTrue:[stackDelta := -1. extra := #absoffset. ^ 197].
    (aSymbol == #eqJumpabs) ifTrue:[stackDelta := -2. extra := #absoffset. ^ 198].
    (aSymbol == #notEqJumpabs) ifTrue:[stackDelta := -2. extra := #absoffset. ^ 199].

    (aSymbol == #pushThisContext) ifTrue:[stackDelta := 1. ^ 144].

    (aSymbol == #isNil) ifTrue:[extraLiteral := aSymbol. ^ 188].
    (aSymbol == #notNil) ifTrue:[extraLiteral := aSymbol. ^ 189].
    (aSymbol == #not) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 179].
    (aSymbol == #&) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 216].
    (aSymbol == #|) ifTrue:[extraLiteral := aSymbol. lineno := true. ^ 217].

    (aSymbol == #pushClassVarL) ifTrue:[stackDelta := 1. extra := #speciallitL. ^ 218].
    (aSymbol == #pushGlobalL) ifTrue:[stackDelta := 1. extra := #speciallitL. ^ 218].
    (aSymbol == #storeClassVarL) ifTrue:[extra := #speciallitL.stackDelta := -1. ^ 219].
    (aSymbol == #storeGlobalL) ifTrue:[extra := #speciallitL. stackDelta := -1. ^ 219].
    (aSymbol == #pushLitL) ifTrue:[stackDelta := 1. extra := #unsigned16. ^ 201].

    (aSymbol == #sendL) ifTrue:[lineno := true. extra := #specialL. ^ 205].
    (aSymbol == #sendSelfL) ifTrue:[lineno := true. extra := #specialL. ^ 207].
    (aSymbol == #sendDropL) ifTrue:[lineno := true. extra := #specialL. ^ 204].
    (aSymbol == #superSendL) ifTrue:[lineno := true. extra := #specialL. ^ 206].
    (aSymbol == #hereSendL) ifTrue:[lineno := true. extra := #specialL. ^ 206].

    (aSymbol == #top) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #bottom) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #left) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #right) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].

    (aSymbol == #x) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #y) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #width) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #height) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #origin) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #extent) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #next) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #peek) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #asInteger) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].
    (aSymbol == #rounded) ifTrue:[lineno := true. extraLiteral := aSymbol. extra := #specialSend. ^ 231].

    (aSymbol == #blockRef) ifTrue:[stackDelta := 0. ^ 238].
    (aSymbol == #over) ifTrue:[stackDelta := 1. ^ 6].
    (aSymbol == #swap) ifTrue:[stackDelta := 0. ^ 243].


    self error:'invalid code symbol'.
    errorFlag := #Error

    "Modified: / 03-09-1995 / 12:58:47 / claus"
    "Modified: / 31-10-2011 / 11:35:07 / cg"
    "Modified: / 09-05-2013 / 12:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

code
    ^ codeBytes
!

codeLineNumber:nr on:codeStream
    "generate lineNumber information"

    "/ caveat: (currently) there is no separate lineNumber or symbol table;
    "/ the line numbers are coded right into the instruction stream.
    "/ This might change in the future.
    "/ (It is not a problem speed wise: the Jitter just skips them.)

    (currentLineNumber = nr or:[nr <= 0]) ifTrue:[
        ^ self
    ].

    "don't need line number information, if still on same line"
    currentLineNumber := nr.

    nr <= 255 ifTrue:[
        codeStream
            nextPut:#lineno;
            nextPut:nr.
    ] ifFalse:[
        nr <= 16rFFFF ifTrue:[
            codeStream
                nextPut:#lineno16;
                nextPutInt16:nr MSB:true.
        ]
    ].
!

contextMustBeReturnable
    ^ false
!

correctedSource
    ^ nil
!

createMethod
    |newMethod|

    newMethod := self methodClass new:(litArray size).
    newMethod mclass:classToCompileFor.
    litArray notNil ifTrue:[
	"/ fixup CheapBlocks method-field in literal array,
	litArray do:[:aLiteral |
	    (aLiteral isMemberOf:CheapBlock) ifTrue:[
		aLiteral setMethod:newMethod.
	    ]
	].
	newMethod literals:litArray
    ].

    newMethod numberOfVars:(self numberOfMethodVars + (maxNumTemp ? 0)).
    newMethod numberOfArgs:(self numberOfMethodArgs).
    newMethod stackSize:(self maxStackDepth).

    ^ newMethod
!

genByteCodeFrom:symbolicCodeArray
    "convert symbolicCode into bytecodes"

    |symIndex    "{Class: SmallInteger }"
     codeSize    "{Class: SmallInteger }"
     symCodeSize "{Class: SmallInteger }"
     index nextSym addr
     codeSymbol nargs needRetry
     stackDepth relocInfo level nvars round
     lnoLO lnoHI |

    symbolicCodeArray isNil ifTrue:[^ self].

    round := 0.
    needRetry := true.
    symCodeSize := symbolicCodeArray size.
    codeSize := symCodeSize.

    [needRetry] whileTrue:[
	stackDepth := 0.
	maxStackDepth := 0.

	codeBytes := ByteArray uninitializedNew:codeSize.
	relocInfo := Array basicNew:(codeSize + 1).
	symIndex := 1.
	codeIndex := 1.

	needRetry := false.
	round := round + 1.

	[symIndex <= symCodeSize] whileTrue:[
	    relocInfo at:symIndex put:codeIndex.

	    codeSymbol := symbolicCodeArray at:symIndex.
	    symIndex := symIndex + 1.
	    stackDelta := 0.
	    extra := extraLiteral := nil.
	    lineno := false.

	    self appendByteCodeFor:codeSymbol.

	    extraLiteral notNil ifTrue:[
		self addLiteral:extraLiteral
	    ].

	    lineno ifTrue:[
		lnoLO := (symbolicCodeArray at:symIndex) ? 0.
		self appendByte:(lnoLO min:255).
		symIndex := symIndex + 1.
		codeSymbol == #lineno16 ifTrue:[
		    lnoHI := (symbolicCodeArray at:symIndex) ? 0.
		    self appendByte:(lnoHI min:255).
		    symIndex := symIndex + 1
		]
	    ].

	    extra notNil ifTrue:[
		nextSym := symbolicCodeArray at:symIndex.

		(extra == #number) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 1.
		    self appendSignedByte:index

		] ifFalse:[ (extra == #number16) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 2.
		    self appendSignedWord:index

		] ifFalse:[ (extra == #unsigned16) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 2.
		    self appendWord:index

		] ifFalse:[ (extra == #index) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 1.
		    self appendByte:index

		] ifFalse:[ (extra == #lit) ifTrue:[
		    index := self addLiteral:nextSym.
		    symIndex := symIndex + 1.
		    self appendByte:index

		] ifFalse:[ (extra == #speciallit) ifTrue:[
		    index := self addLiteral:nextSym.
		    index > 255 ifTrue:[
			self parseError:'too many globals (' ,
					(symbolicCodeArray at:symIndex) ,
					' index=' , index printString ,
					') in method - please simplify'.
			^ #Error
		    ].
		    symIndex := symIndex + 1.
		    self appendByte:index.

		] ifFalse:[ (extra == #speciallitS) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 1.
		    self appendByte:index.

		] ifFalse:[ (extra == #speciallitL) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 2.
		    self appendWord:index.

		] ifFalse:[ (extra == #offset) ifTrue:[
		    relocInfo at:symIndex put:codeIndex.
		    self addReloc:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:0

		] ifFalse:[ (extra == #indexLevel) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 1.
		    self appendByte:index.
		    level := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:level

		] ifFalse:[ (extra == #offsetNvarNarg) ifTrue:[
		    relocInfo at:symIndex put:codeIndex.
		    self addReloc:symIndex.
		    symIndex := symIndex + 1.
		    self appendEmptyByte.
		    nvars := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:nvars.
		    level := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:level

		] ifFalse:[ (extra == #absoffset) ifTrue:[
		    relocInfo at:symIndex put:codeIndex.
		    self addReloc:symIndex.
		    addr := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:(addr bitAnd:16rFF).
		    self appendByte:((addr bitShift:-8) bitAnd:16rFF).

		] ifFalse:[ (extra == #absoffsetNvarNarg) ifTrue:[
		    relocInfo at:symIndex put:codeIndex.
		    self addReloc:symIndex.
		    addr := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:(addr bitAnd:16rFF).
		    self appendByte:((addr bitShift:-8) bitAnd:16rFF).
		    nvars := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:nvars.
		    level := symbolicCodeArray at:symIndex.
		    symIndex := symIndex + 1.
		    self appendByte:level

		] ifFalse:[ (extra == #special) ifTrue:[
		    ((codeSymbol == #send)
		     or:[codeSymbol == #sendSelf
		     or:[codeSymbol == #superSend
		     or:[codeSymbol == #hereSend]]]) ifTrue:[
			index := nextSym.
			symIndex := symIndex + 1.
			nargs := symbolicCodeArray at:symIndex.
			symIndex := symIndex + 1.
			self appendByte:nargs.
			self appendByte:index.

			(codeSymbol == #superSend
			or:[codeSymbol == #hereSend]) ifTrue:[
			    index := symbolicCodeArray at:symIndex.
			    symIndex := symIndex + 1.
			    self appendByte:index
			].
			stackDelta := nargs negated.
			codeSymbol == #sendSelf ifTrue:[
			    stackDelta := stackDelta + 1
			]
		    ] ifFalse:[ (codeSymbol == #sendDrop) ifTrue:[
			index := nextSym.
			symIndex := symIndex + 1.
			nargs := symbolicCodeArray at:symIndex.
			symIndex := symIndex + 1.
			self appendByte:nargs.
			self appendByte:index.
			stackDelta := (nargs + 1) negated
		    ]]

		] ifFalse:[ (extra == #specialL) ifTrue:[
		    ((codeSymbol == #sendL)
		     or:[codeSymbol == #sendDropL
		     or:[codeSymbol == #sendSelfL
		     or:[codeSymbol == #superSendL
		     or:[codeSymbol == #hereSendL]]]]) ifTrue:[
			index := nextSym.
			symIndex := symIndex + 2.
			nargs := symbolicCodeArray at:symIndex.
			symIndex := symIndex + 1.
			self appendByte:nargs.
			self appendWord:index.
			(codeSymbol == #superSendL
			or:[codeSymbol == #hereSendL]) ifTrue:[
			    index := symbolicCodeArray at:symIndex.
			    symIndex := symIndex + 2.
			    self appendWord:index.
			].
			stackDelta := nargs negated.
			codeSymbol == #sendSelfL ifTrue:[
			    stackDelta := stackDelta + 1
			]
		    ]
		] ifFalse:[ (extra == #specialSend) ifTrue:[
		    index := nextSym.
		    symIndex := symIndex + 1.
		    self appendByte:index.

		] ifFalse:[
		    "/ self halt:'internal error'

		]]]]]]]]]]]]]]]]
	    ].

	    stackDepth := stackDepth + stackDelta.
	    (stackDepth > maxStackDepth) ifTrue:[
		maxStackDepth := stackDepth
	    ]
	].
	relocInfo at:symIndex put:codeIndex.

	needRetry ifFalse:[
	    "
	     now relocate - returns true if ok, false if we have to do it again
	     (when short jumps have been changed to long jumps)
	    "
	    relocList notNil ifTrue:[
		needRetry := (self relocateWith:symbolicCodeArray relocInfo:relocInfo) not.
		"
		 if returned with false, a relative jump was made into
		 an absolute jump - need to start over with one more byte space
		"
		needRetry ifTrue:[
		    relocList := nil.
		    codeSize := codeSize + 1.
		]
	    ]
	] ifTrue:[
	    'Compiler [info]: compiling again ...' infoPrintCR.
	]
    ].
    "code printNL."
    ^ errorFlag

    "Modified: / 03-09-1995 / 12:59:43 / claus"
    "Modified: / 19-05-2010 / 12:55:53 / cg"
!

genSymbolicCode
    "traverse the parse-tree producing symbolicCode - return the codeArray"

    |codeStream code lastStatement|

    litArray := nil.
    codeStream := WriteStream on:(OrderedCollection new:100).

"/    primitiveContextInfo notNil ifTrue:[
"/        (primitiveContextInfo includes:('exception:' -> #unwind)) ifTrue:[
"/            self genSpecialStatement:#markForUnwind on:codeStream
"/        ].
"/        (primitiveContextInfo includes:('exception:' -> #handle)) ifTrue:[
"/            self genSpecialStatement:#markForHandle on:codeStream
"/        ].
"/        (primitiveContextInfo includes:('exception:' -> #raise)) ifTrue:[
"/            self genSpecialStatement:#markForRaise on:codeStream
"/        ].
"/    ].

    tree codeVariableSetupOn:codeStream for:self.

    (tree statements ? #()) do:[:thisStatement |
	lastStatement := thisStatement.
	thisStatement codeForSideEffectOn:codeStream inBlock:nil for:self.
    ].
    (lastStatement isNil or:[lastStatement isReturnNode not])
    ifTrue:[
	"not a return - add retNil"
	"
	 if the last statement was a send for side-effect,
	 replace the previous drop by a retNil.
	 In this case we have to keep an extra retNil because
	 it could be a jump target.
	"
	(lastStatement notNil
	 and:[(code := codeStream contents) notNil
	 and:[code size > 0
	 and:[code last == #drop]]]) ifTrue:[
	    codeStream backStep.
	    codeStream nextPut:#retNil
	].
	codeStream nextPut:#retNil
    ].
    ^ codeStream contents

    "Modified: / 21-02-2007 / 12:30:44 / cg"
!

generateVariables:varCollection on:codeStream
    varCollection isNil ifTrue:[^ self].

    varCollection do:[:eachVar |
	"/ generate code to set it up.

	|initExpression setupExpr|

	initExpression := eachVar expressionForSetup.
	initExpression notNil ifTrue:[
	    setupExpr := AssignmentNode
			    variable:(self nodeForMethodVariable:eachVar name)
			    expression:initExpression.
	    setupExpr codeForSideEffectOn:codeStream inBlock:nil for:self.
	]
    ]
!

isBuiltInSelector:sel forReceiver:receiver
    ^ false

    "Created: / 10-08-2006 / 12:09:56 / cg"
!

maxStackDepth
     ^ maxNumTemp ? 0
!

methodClass
     ^ methodClass ? JavaScriptFunction

    "Modified: / 22-07-2013 / 15:52:58 / cg"
!

numberOfMethodArgs
     ^ tree _argVariables size.
!

numberOfMethodVars
     ^ tree _localVariables size.
!

relocateWith:symbolicCodeArray relocInfo:relocInfo
    "helper for genByteCodeFrom - relocate code using relocInfo.
     if relocation fails badly (due to long relative jumps) patch
     symbolicCode to use absolute jumps instead and return false
     (genByteCodeFrom will then try again). Otherwise return true.
     Also, on the fly, jumps to jumps and jumps to return are handled."

    |delta       "{Class: SmallInteger }"
     codePos     "{Class: SmallInteger }"
     opCodePos   "{Class: SmallInteger }"
     codeOffset  "{Class: SmallInteger }"
     symOffset
     opcode      "{Class: SmallInteger }"
     dstOpcode jumpTarget
     jumpCode deleteSet|

    deleteSet := OrderedCollection new.
    relocList do:[:sIndex |
	"have to relocate symCode at sIndex ..."
	symOffset := symbolicCodeArray at:sIndex.   "the target in the symbolic code"
	codePos := relocInfo at:sIndex.             "position of the offet in byte code"
	codeOffset := relocInfo at:symOffset.       "position of the target in byte code"
	delta := codeOffset - codePos - 1.
	opCodePos := codePos - 1.
	opcode := codeBytes at:opCodePos.

	(opcode between:190 and:199) ifTrue:[
	    "an absolute jump/makeBlock"

	    codeBytes at:codePos put:(codeOffset bitAnd:16rFF).
	    codeBytes at:(codePos + 1) put:(codeOffset bitShift:-8)
	] ifFalse:[
	    "get jump-code from long and vlong codes"
	    (opcode between:50 and:59) ifFalse:[
		(opcode between:60 and:69) ifTrue:[
		    opcode := opcode - 10
		] ifFalse:[
		    (opcode between:70 and:79) ifTrue:[
			opcode := opcode - 20
		    ] ifFalse:[
			self error:'invalid code to relocate'
		    ]
		].
	    ].

	    "optimize jump to return and jump to jump"

	    (opcode == 54) ifTrue:[
		"a jump"
		dstOpcode := symbolicCodeArray at:symOffset.

		(#(retSelf retTop retNil retTrue retFalse ret0 "blockRetTop") includes:dstOpcode) ifTrue:[
		    "a jump to a return - put in the return instead jump"

		    symbolicCodeArray at:(sIndex - 1) put:dstOpcode.
		    symbolicCodeArray at:sIndex put:dstOpcode.
		    codeBytes at:opCodePos put:(self byteCodeFor:dstOpcode).
		    delta := 0.
		    deleteSet add:sIndex.

"
'jump to return at: ' print. (sIndex - 1) printNL.
"
		] ifFalse:[
		    (dstOpcode == #jump) ifTrue:[
			"jump to jump to be done soon"
			jumpTarget := symbolicCodeArray at:(symOffset + 1).
"
'jump to jump at: ' print. (sIndex - 1) print.
'  newTarget:' print. jumpTarget printNL.
"

			symbolicCodeArray at:sIndex put:jumpTarget.
			symOffset := jumpTarget.
			codeOffset := relocInfo at:symOffset.
			delta := codeOffset - codePos - 1.

			"continue with new delta"
		    ]
		]
	    ].
	    (#(50 51 52 53 56 57 58 59) includes:opcode) ifTrue:[
		"a conditional jump"

		dstOpcode := symbolicCodeArray at:symOffset.
		(dstOpcode == #jump) ifTrue:[
		    "conditional jump to unconditional jump"
		    jumpTarget := symbolicCodeArray at:(symOffset + 1).
"
'cond jump to jump at: ' print. (sIndex - 1) print.
'  newTarget:' print. jumpTarget printNL.
"

		    symbolicCodeArray at:sIndex put:jumpTarget.
		    symOffset := jumpTarget.
		    codeOffset := relocInfo at:symOffset.
		    delta := codeOffset - codePos - 1.

		    "continue with new delta"
		].
	    ].

	    (delta >= 0) ifTrue:[
		(delta > 127) ifTrue:[
		    (opcode between:50 and:59) ifFalse:[
			self error:'invalid code to relocate'
		    ] ifTrue:[
			(delta > 255) ifTrue:[
			    "change jmp into vljmp ..."
			    codeBytes at:opCodePos put:(opcode + 20).
			    delta := delta - 256
			] ifFalse:[
			    "change jmp into ljmp ..."
			    codeBytes at:opCodePos put:(opcode + 10).
			    delta := delta - 128
			].
			(delta > 127) ifTrue:[
			    "change symbolic into a jump absolute and fail"
			    jumpCode := symbolicCodeArray at:(sIndex - 1).
			    symbolicCodeArray at:(sIndex - 1) put:(self absJumpFromJump:jumpCode).
			    symbolicCodeArray at:sIndex put:symOffset.
"
'change short into abs jump' printNL.
"
			    deleteSet do:[:d | relocList remove:d].
			    ^ false
			]
		    ].
		].
		codeBytes at:codePos put:delta
	    ] ifFalse:[
		(delta < -128) ifTrue:[
		    (opcode between:50 and:59) ifFalse:[
			self error:'invalid code to relocate'
		    ] ifTrue:[
			(delta < -256) ifTrue:[
			    "change jmp into vljmp ..."
			    codeBytes at:opCodePos put:(opcode + 20).
			    delta := delta + 256
			] ifFalse:[
			    "change jmp into ljmp ..."
			    codeBytes at:opCodePos put:(opcode + 10).
			    delta := delta + 128
			].
			(delta < -128) ifTrue:[
			    "change symbolic into a jump absolute and fail"
			    jumpCode := symbolicCodeArray at:(sIndex - 1).
			    symbolicCodeArray at:(sIndex - 1) put:(self absJumpFromJump:jumpCode).
			    symbolicCodeArray at:sIndex put:symOffset.
"
'change short into abs jump' printNL.
"
			    deleteSet do:[:d | relocList remove:d].
			    ^ false
			]
		    ]
		].
		codeBytes at:codePos put:(256 + delta)
	    ]
	]
    ].
    (errorFlag == #Error) ifTrue:[
	self error:'relocation range error'
    ].
    ^ true
!

specialGlobalCodeFor:aSymbol
    ^ nil.
!

specialSendCodeFor:sel
    "return the codeExtension for sends,
     which can be performed by specialSend opCode"

    ^ nil.

    "Modified: 4.6.1997 / 12:31:08 / cg"
! !

!JavaScriptCompiler methodsFor:'compiling'!

compile:aString forClass:aClass inCategory:cat
    ^ self
	compile:aString
	forClass:aClass
	inCategory:cat
	notifying:nil
	install:true
	skipIfSame:false
	silent:false
	foldConstants:true

    "Created: / 30-09-2011 / 12:49:45 / cg"
!

compile:aString forClass:aClass inCategory:cat notifying:requestorArg
		 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
    ^ self
	compile:aString forClass:aClass inCategory:cat notifying:requestorArg
	install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
	ifFail:[]

    "Modified: / 22-07-2013 / 16:07:23 / cg"
!

compile:sourceCodeString forClass:aClass inCategory:cat notifying:aRequestor
                install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
                ifFail:failBlock
    |parseTree|

    self setClassToCompileFor:aClass.
    self parseForCode.
"/    fold ifFalse:[self foldConstants:nil].
    self notifying:requestor.
    self source:sourceCodeString.
    self nextToken.

    "/ the old code caught errors and returned #Error
    "/ we now migrate towards letting the caller know about the exception.
"/    ParseError handle:[:ex |
"/        Transcript showCR:'JS translation error: ' , ex description "errorMessage".
"/        ^ #Error
"/    ] do:[

    (tokenType == #Identifier and:[tokenName = 'static']) ifTrue:[
        self nextToken.
        self setClassToCompileFor:aClass theMetaclass.
    ].

        parseTree := self function.
"/    ].

    tokenType == $; "16r3B" ifTrue:[
        self nextToken.
    ].
    tokenType == #EOF ifFalse:[
        |errMsg|

        tokenType == $} ifTrue:[
            errMsg := 'unexpected "}" at end of function'.
        ] ifFalse:[
            errMsg := 'unexpected garbage at end of function'.
        ].
        self notifyError:errMsg position:tokenPosition to:source position
    ].

    parseTree isNil ifTrue:[
        ParseError raiseRequestErrorString:'empty function'.
        "/ Transcript showCR:'JS translation error'.
        failBlock value.
        ^ #Error
    ].
    ^ self
        compileTree:parseTree
        source:sourceCodeString
        forClass:classToCompileFor
        inCategory:cat notifying:requestor
        install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
        ifFail:failBlock

    "Created: / 22-07-2013 / 16:05:41 / cg"
!

compileTree:tree source:sourceString forClass:aClass inCategory:cat notifying:requestor
		 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
    ^ self
	compileTree:tree
	source:sourceString forClass:aClass inCategory:cat notifying:requestor
	install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
	ifFail:[]

    "Modified: / 22-07-2013 / 16:06:58 / cg"
!

compileTree:tree source:sourceString forClass:aClass inCategory:cat notifying:requestor
		 install:install skipIfSame:skipIfSame silent:silent foldConstants:fold
		 ifFail:failBlock
    |sel newMethod newSource pkg symbolicCodeArray |

    self setClassToCompileFor:aClass.
    self parseForCode.
    fold ifFalse:[self foldConstants:nil].
    self notifying:requestor.

    tree isNil ifTrue:[
	Transcript showCR:'JS translation error'.
	failBlock value.
	^ #Error
    ].

    self tree:tree.
    sel := self class selectorFor:tree functionName numArgs:self numberOfMethodArgs.

    "
     produce symbolic code first
    "
    ParseError handle:[:ex |
	ex reject.
"/ self halt.
	Transcript showCR:'JS translation error: ' , ex errorMessage.
	failBlock value.
	^ #Error
    ] do:[
	symbolicCodeArray := self genSymbolicCode.
    ].
    (symbolicCodeArray == #Error) ifTrue:[
	Transcript show:'    '.
	sel notNil ifTrue:[
	    Transcript show:(sel ,' ')
	].
	Transcript showCR:'JS translation error'.
	failBlock value.
	^ #Error
    ].

    "
     take this, producing bytecode
    "
    ((self genByteCodeFrom:symbolicCodeArray) == #Error) ifTrue:[
	Transcript show:'    '.
	sel notNil ifTrue:[
	    Transcript show:(sel ,' ')
	].
	Transcript showCR:'relocation error - must be simplified'.
	failBlock value.
	^ #Error
    ].
    "
     finally create the new method-object
    "
    newMethod := self createMethod.
    newMethod byteCode:(self code).

    "
     if there where any corrections, install the updated source
    "
    (newSource := self correctedSource) notNil ifTrue:[
	newMethod source:newSource string
    ] ifFalse:[
	newMethod source:sourceString string.
    ].

    newMethod mclass:aClass.
    newMethod setCategory:cat.
    (aClass isNil or:[aClass owningClass isNil]) ifTrue:[
	pkg := Class packageQuerySignal query.
    ] ifFalse:[
	pkg := aClass owningClass package
    ].
    newMethod setPackage:pkg.

    (self contextMustBeReturnable) ifTrue:[
	newMethod contextMustBeReturnable:true
    ].
    install ifTrue:[
	aClass notNil ifTrue:[
	    aClass addSelector:sel withMethod:newMethod
	]
    ].

"/    silent ifFalse:[
"/        aClass isNil ifTrue:[
"/            Transcript showCR:('    compiled: <nil> ', sel)
"/        ] ifFalse:[
"/            Transcript showCR:('    compiled: ', aClass name,' ', sel)
"/        ]
"/    ].

    ^ newMethod

    "Created: / 22-07-2013 / 16:06:29 / cg"
! !

!JavaScriptCompiler methodsFor:'initialization'!

reset
    "needed between functions, when reading multiple functions"

    usesSuper := false.
    gotAnyRealStatement := false.
    staticVars := nil.
    moreSharedPools := nil.
    modifiedVars := modifiedGlobals := modifiedInstVars := modifiedClassVars := nil.
    usedVars := usedGlobals := usedInstVars := usedClassVars := nil.
    currentEnvironment := nil.
    inArrayLiteral := false.
    collectedSource := nil.
    currentComments := nil.
    errorFlag := false.

    relocList := codeBytes := litArray := stackDelta := extraLiteral := maxStackDepth := nil.
    methodTempVars := maxNumTemp := loopStack := nil.

    tokenPosition := outCol := 1.
    tokenLineNr := lineNr := 1.
! !

!JavaScriptCompiler methodsFor:'loops'!

loopDescription
    loopStack isNil ifTrue:[^ nil].

    ^ loopStack last
!

newLoopDescription
    ^ LoopDescription new
!

newLoopDescriptionForBlock
    ^ LoopDescriptionForBlock new
!

newSwitchDescription
    ^ SwitchDescription new
!

popLoopDescription
    ^ loopStack removeFirst
!

pushLoopDescription:aDescription
    loopStack isNil ifTrue:[
	loopStack := OrderedCollection new.
    ].

    loopStack addFirst:aDescription
! !

!JavaScriptCompiler methodsFor:'parsing'!

compileFunctionDefinitions
    |classToCompileForBefore|

    classToCompileForBefore := classToCompileFor.

    [ tokenType ~~ #EOF ] whileTrue:[
        |cat mthd sourceString|
        
        outStream := WriteStream on:(String new:100).
        "/ because the first token ('function') has already been read,
        "/ we have to manually shift it into the source collecting stream (sigh)
        outStream nextPutAll:self token.
        self reset.
        
        classToCompileFor := classToCompileForBefore.
        tree := self functionOrStaticFunction:false.
        cat := self methodCategory.

        "/ the collected source of this function
        sourceString := outStream contents.

        mthd := self
                    compileTree:tree source:sourceString
                    forClass:classToCompileFor inCategory:(cat ? 'no category')
                    notifying:nil
                    install:true
                    skipIfSame:false
                    silent:false
                    foldConstants:true.

        token = $} ifTrue:[
            self nextToken.
        ].
    ]
! !

!JavaScriptCompiler::LoopDescription methodsFor:'accessing'!

breakLabel
    "return the value of the instance variable 'breakLabel' (automatically generated)"

    ^ breakLabel
!

breakLabel:something
    "set the value of the instance variable 'breakLabel' (automatically generated)"

    breakLabel := something.
!

continueLabel
    "return the value of the instance variable 'continueLabel' (automatically generated)"

    ^ continueLabel
!

continueLabel:something
    "set the value of the instance variable 'continueLabel' (automatically generated)"

    continueLabel := something.
! !

!JavaScriptCompiler::LoopDescription methodsFor:'backpatching'!

patchBreaksTo:breakPosition in:codeStream
    |code|

    backPatchListForBreak isEmptyOrNil ifTrue:[^ self].

    code := codeStream contents.
    backPatchListForBreak do:[:eachPatchPos |
	code at:eachPatchPos put:breakPosition
    ].
!

patchContinuesTo:continuePosition in:codeStream
    |code|

    backPatchListForContinue isEmptyOrNil ifTrue:[^ self].

    code := codeStream contents.
    backPatchListForContinue do:[:eachPatchPos |
	code at:eachPatchPos put:continuePosition
    ].
!

rememberToBackPatchForBreak:position
    backPatchListForBreak isNil ifTrue:[
	backPatchListForBreak := OrderedCollection new
    ].
    backPatchListForBreak add:position
!

rememberToBackPatchForContinue:position
    backPatchListForContinue isNil ifTrue:[
	backPatchListForContinue := OrderedCollection new
    ].
    backPatchListForContinue add:position
! !

!JavaScriptCompiler::LoopDescription methodsFor:'code generation'!

codeForBreakOn:aStream at:lineNr for:aCompiler
    |jmpDeltaPos|

    breakLabel notNil ifTrue:[
	aStream nextPut:#jump.
	aStream nextPut:breakLabel.
    ] ifFalse:[
	aStream nextPut:#jump.
	jmpDeltaPos := aStream position + 1.
	aStream nextPut:0.
	self rememberToBackPatchForBreak:jmpDeltaPos.
    ].

    "Created: / 06-11-2013 / 21:18:36 / cg"
!

codeForContinueOn:aStream at:lineNr for:aCompiler
    |jmpDeltaPos|

    continueLabel notNil ifTrue:[
	aStream nextPut:#jump.
	aStream nextPut:continueLabel.
    ] ifFalse:[
	aStream nextPut:#jump.
	jmpDeltaPos := aStream position + 1.
	aStream nextPut:0.
	self rememberToBackPatchForContinue:jmpDeltaPos.
    ].

    "Created: / 06-11-2013 / 21:19:27 / cg"
! !

!JavaScriptCompiler::LoopDescription methodsFor:'queries'!

isLoop
    ^ true
! !

!JavaScriptCompiler::LoopDescriptionForBlock methodsFor:'accessing'!

deltaScope
    ^ deltaScope ? 1

    "Created: / 06-11-2013 / 20:34:51 / cg"
!

deltaScope:something
    deltaScope := something.
! !

!JavaScriptCompiler::LoopDescriptionForBlock methodsFor:'code generation'!

codeForBreakOn:aStream at:lineNr for:aCompiler
    |thisContextVar node|

    thisContextVar := VariableNode type:#ThisContext name:#thisContext.
    node := MessageNode
		    receiver:thisContextVar
		    selector:#sender
		    args:#().
    node lineNumber:lineNr.
    self deltaScope timesRepeat:[
	node := MessageNode
			receiver:node
			selector:#sender
			args:#().
	node lineNumber:lineNr.
    ].
    node := MessageNode
		    receiver:node
		    selector:#return
		    args:#().
    node lineNumber:lineNr.
    node codeForSideEffectOn:aStream inBlock:nil for:aCompiler.

    "Created: / 06-11-2013 / 21:18:31 / cg"
!

codeForContinueOn:aStream at:lineNr for:aCompiler
    |thisContextVar node|

    thisContextVar := VariableNode type:#ThisContext name:#thisContext.
    node := MessageNode
		    receiver:thisContextVar
		    selector:#return
		    args:#().
"/    node lineNumber:lineNr.
    node codeForSideEffectOn:aStream inBlock:nil for:aCompiler.

    "Created: / 06-11-2013 / 21:19:21 / cg"
! !

!JavaScriptCompiler::LoopDescriptionForBlock methodsFor:'queries'!

isLoop
    ^ true
! !

!JavaScriptCompiler::SwitchDescription methodsFor:'backpatching'!

rememberToBackPatchForContinue:position
    self error:'invalid continue in switch'
! !

!JavaScriptCompiler::SwitchDescription methodsFor:'code generation'!

codeForContinueOn:aStream at:lineNr for:aCompiler
    aCompiler parseError:'continue not within a loop (continue in switch not allowed)'.

    "Created: / 06-11-2013 / 21:19:10 / cg"
! !

!JavaScriptCompiler::SwitchDescription methodsFor:'queries'!

isLoop
    ^ false
! !

!JavaScriptCompiler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompiler.st,v 1.58 2016-12-27 15:13:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompiler.st,v 1.58 2016-12-27 15:13:43 cg Exp $'
! !

