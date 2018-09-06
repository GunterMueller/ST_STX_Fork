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

TestCase subclass:#JavaScriptTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

!JavaScriptTests class methodsFor:'documentation'!

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
!

documentation
"
    documentation to be added.

    [author:]
	cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 12-04-2005 / 11:54:25 / cg"
! !

!JavaScriptTests class methodsFor:'queries'!

coveredClassNames
    ^ #(
	JavaScriptParser
	JavaScriptScanner
	JavaScriptCompiler
	)
! !

!JavaScriptTests methodsFor:'helpers'!

doTestEachFromSpec:spec
    spec do:[:triple |
	|str checkSelectorOrNil valExpected val expectError|

	str := triple first.
	checkSelectorOrNil := triple second.
	expectError := false.
	valExpected := triple third.
	valExpected isArray ifTrue:[
	    valExpected size > 0 ifTrue:[
		valExpected first == #eval ifTrue:[
		    valExpected := Parser evaluate:valExpected second
		] ifFalse:[
		    valExpected first == #error ifTrue:[
			expectError := true
		    ].
		].
	    ].
	].
	expectError ifTrue:[
	    self
		should:[ (JavaScriptParser parseExpression:str) evaluate ]
		raise:Error
	] ifFalse:[
	    val := (JavaScriptParser parseExpression:str) evaluate.
	    checkSelectorOrNil notNil ifTrue:[
		self assert:(val perform:checkSelectorOrNil).
	    ].
	    self assert:(val = valExpected).
	].
    ]
!

doTestEachFunctionFromSpec:spec
    spec do:[:tuple |
	|source expectError|

	source := tuple first.
	expectError := tuple second.

	expectError ifTrue:[
	    self
		should:[ JavaScriptParser parseFunction:source ]
		raise:Error
	] ifFalse:[
	    JavaScriptParser parseFunction:source.
	].
    ]
!

execute:code for:receiver arguments:arguments
    |parser f result|

    "/ First, validate the tree
    parser := JavaScriptParser parseMethod: code in: nil.
    self assert: parser tree notNil.
    JavaScriptParseNodeValidator validate: parser tree source: code.

    "/ Transcript showCR:(thisContext sender selector , '...').

    f := JavaScriptCompiler
	compile:code
	forClass:(receiver class)
	inCategory:nil
	notifying:nil
	install:false.

"/ f inspect.

    self assert:(f ~~ #Error).
    self assert:(f notNil).

"/    f decompileTo:Transcript.

    result := f valueWithReceiver:receiver arguments:arguments selector:nil search:nil sender:nil.
    ^ result

    "Modified: / 09-10-2011 / 11:41:51 / cg"
    "Modified (format): / 20-09-2013 / 11:56:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

execute:code for:receiver arguments:arguments expect:expectedResult
    |result|

    result := self execute:code for:receiver arguments:arguments.
    self assert:(result = expectedResult).
!

execute:code for:receiver arguments:arguments expectError:expectedError
    |f errorEncountered|

    "/ Transcript showCR:(thisContext sender selector , '...').

    Parser parseErrorSignal handle:[:ex |
	errorEncountered := true.
    ] do:[
	f := JavaScriptCompiler
	    compile:code
	    forClass:(receiver class)
	    inCategory:nil
	    notifying:nil
	    install:false.

	errorEncountered := (f == #Error).
    ].

    expectedError == #ParseError ifTrue:[
	self assert:(errorEncountered).
	^ self
    ].

    self assert:(errorEncountered not).
    self assert:(f notNil).

"/    f decompileTo:Transcript.

    self
	should:[f valueWithReceiver:receiver arguments:arguments]
	raise:expectedError

    "Modified: / 09-10-2011 / 11:41:57 / cg"
!

outputToTranscriptOf:aBlock
    "yes, globals are bad - that's what we need stuff like this for..."

    |output|

    output := '' writeStream.
    self withTranscriptRedirectedTo:output do:aBlock.
    ^ output contents
!

setUp
    JavaScriptCompiler isNil ifTrue:[
	Smalltalk loadPackage:'stx:libjavascript'.
	JavaScriptParseNodeValidator autoload.
    ].

    "Created: / 09-08-2011 / 23:12:13 / cg"
    "Modified: / 20-09-2013 / 11:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withTranscriptRedirectedTo:aStream do:aBlock
    "yes, globals are bad - that's what we need stuff like this for..."

    |savedTranscript|

    savedTranscript := Transcript.
    [
	Transcript := aStream.
	aBlock value.
    ] ensure:[
	Transcript := savedTranscript
    ].
! !

!JavaScriptTests methodsFor:'tests'!

testArray01
    self
	execute:'test(arr) {
		    return arr[1];
		 }'
	for:nil
	arguments:#( #(10 20 30) )
	expect:10

    "
     self run:#testArray01
     self new testArray01
    "
!

testArray02
    self
	execute:'test(arr) {
		    arr[1];
		 }'
	for:nil
	arguments:#( #(10 20 30) )
	expect:nil

    "
     self run:#testArray02
     self new testArray02
    "

    "Modified: / 21-02-2007 / 13:02:39 / cg"
!

testArray03
    self
	execute:'test(arr, val) {
		    arr[1] = val;
		    return arr;
		 }'
	for:nil
	arguments:#( #(10 20 30) 99 ) deepCopy      "deepCopy - this is immutable"
	expect:#(99 20 30)

    "
     self run:#testArray03
     self new testArray03
    "
!

testArray04
    self
	execute:'test() {
		    var arr = new Array;
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#()

    "
     self run:#testArray04
     self new testArray04
    "

    "Modified: / 21-02-2007 / 13:03:22 / cg"
!

testArray04a
    self
	execute:'test() {
		    var arr = new Array;
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#()

    "
     self run:#testArray04a
     self new testArray04a
    "

    "Created: / 21-02-2007 / 13:03:39 / cg"
!

testArray04b
    self
	execute:'test() {
		    var arr = Array.new;
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#()

    "
     self run:#testArray04b
     self new testArray04b
    "

    "Created: / 21-02-2007 / 13:03:48 / cg"
!

testArray04c
    self
	execute:'test() {
		    var arr = Array.new();
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#()

    "
     self run:#testArray04c
     self new testArray04c
    "

    "Created: / 21-02-2007 / 13:04:00 / cg"
!

testArray04d
    self
	execute:'test() {
		    var arr = new Array();
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#()

    "
     self run:#testArray04d
     self new testArray04d
    "

    "Created: / 21-02-2007 / 13:04:25 / cg"
!

testArray06a
    self
	execute:'test() {
		    var arr = new Array(5);
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#( nil nil nil nil nil )

    "
     self run:#testArray06a
     self new testArray06a
    "

    "Created: / 21-02-2007 / 13:04:52 / cg"
!

testArray06b
    self
	execute:'test() {
		    var arr = Array.new(5);
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#( nil nil nil nil nil )

    "
     self run:#testArray06b
     self new testArray06b
    "

    "Created: / 21-02-2007 / 13:05:08 / cg"
!

testArray07
    self
	execute:'test() {
		    var arr = new Array(3);
		    arr[1] = 41;
		    arr[2] = -5;
		    arr[3] = 20;
		    return arr;
		 }'
	for:nil
	arguments:#()
	expect:#( 41 -5 20 ).

    "
     self run:#testArray07
     self new testArray07
    "
!

testArray08
    self
	execute:'test() {
		    var arr = new Array(3);
		    arr[1] = 41;
		    arr[2] = -5;
		    arr[3] = 20;
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#( 41 -5 20 )

    "
     self run:#testArray08
     self new testArray08
    "
!

testArray09
    self
	execute:'test() {
		    var arr = [1,2,3];
		    return arr;
		 }'
	for:nil
	arguments:#(  )
	expect:#( 1 2 3 )

    "
     self run:#testArray09
     self new testArray09
    "

    "Created: / 21-02-2007 / 13:05:48 / cg"
!

testAssignmentExpression01
    self
	execute:'assign(a, b) {
		    var x, y;

		    x = y = 0;
		    x = y = a;
		    x = y = b;
		    return (x + y);
		 }'
	for:nil
	arguments:#(10 20)
	expect:40

    "
     self run:#testAssignmentExpression01
     self new testAssignmentExpression01
    "
!

testAssignmentExpression02
    "yes, in JS you can change an argument variable"

    self
	execute:'assign(a, b) {
		    var x, y;

		    a = x = y = 0;
		    return (a + b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testAssignmentExpression02
     self new testAssignmentExpression02
    "
!

testCommaExpression01
    self
	execute:'comma(a, b, c) {
		    return (a , b , c);
		 }'
	for:nil
	arguments:#(10 20 30)
	expect:30

    "
     self run:#testCommaExpression01
     self new testCommaExpression01
    "
!

testCommaExpression02
    self
	execute:'comma(a, b, c) {
		    return (a+10 , b+10 , c+10);
		 }'
	for:nil
	arguments:#(10 20 30)
	expect:40

    "
     self run:#testCommaExpression02
     self new testCommaExpression02
    "
!

testComments01
    |savedTranscript collector expected|

    savedTranscript := Smalltalk at:#Transcript.
    [
	Smalltalk at:#Transcript put:(collector := '' writeStream).
	self
	    execute:'
		      testComments() {
			  // Unicode is allowed in comments
			  // This is a comment \u0410\u0406\u0414\u0419
			  /* Another comment \u05D0\u2136\u05d3\u05d7 */

			  /**/ // Tiny comment
			  /***/ // Also valid

			  // Need to test string literals and identifiers
			  println("All is well in Javascript");
			  return null;
		      }
		     '
	    for:JavaScriptEnvironment new
	    arguments:#(  )
	    expect:nil
    ] ensure:[
	Smalltalk at:#Transcript put:savedTranscript
    ].

    expected := String streamContents:[:s | s showCR:'All is well in Javascript'].
    self assert:(collector contents = expected).

    "
     self run:#testComments01
     self new testComments01
    "
!

testConditionalExpression01
    self
	execute:'max(a, b) {
		    return (a > b) ? a : b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testConditionalExpression01
     self new testConditionalExpression01
    "
!

testConditionalExpression02
    self
	execute:'max(a, b) {
		    return (a < b) ? a : b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:10

    "
     self run:#testConditionalExpression02
     self new testConditionalExpression02
    "
!

testDoWhile01
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			do {
			    Transcript.showCR(n);
			} while (++n <= 3);
			return n;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:4
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '1' '2' '3' ))

    "
     self run:#testDoWhile01
     self new testDoWhile01
    "
!

testDoWhile02
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			do {
			    Transcript.showCR(n);
			    break;
			} while (true);
			return n;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:1
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '1' ))

    "
     self run:#testDoWhile02
     self new testDoWhile02
    "
!

testDoWhile03
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			do {
			    break;
			    Transcript.showCR(n);
			} while (true);
			return n;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:1
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #(  ))

    "
     self run:#testDoWhile03
     self new testDoWhile03
    "
!

testDoWhile04
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			do {
			    if (++n == 3) continue;
			    Transcript.showCR(n);
			} while (n <= 4);
			return n;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:5
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '2' '4' '5' ))

    "
     self run:#testDoWhile04
     self new testDoWhile04
    "
!

testDoWhile05
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			do {
			    if (++n == 3) break;
			    Transcript.showCR(n);
			} while (n <= 4);
			return n;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:3
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '2' ))

    "
     self run:#testDoWhile05
     self new testDoWhile05
    "
!

testDoWhile06
    self
	execute:'test(arg) {
		    var n;

		    n = 1;
		    do
			n += 1;
		    while (n < 4);
		    return n;
		 }'
	for:nil
	arguments:#(5)
	expect:4

    "
     self run:#testDoWhile06
     self new testDoWhile06
    "
!

testException01
    self
	execute:'test() {
		    try {
			return 10;
		    } catch(Error);
		    return nil;
		 }'
	for:nil
	arguments:#(  )
	expect:10

    "
     self run:#testException01
     self new testException01
    "

    "Modified: / 21-02-2007 / 10:28:50 / cg"
!

testException02
    self
	execute:'test() {
		    try {
			Error.raise();
			return 10;
		    } catch(Error);
		    return nil;
		 }'
	for:nil
	arguments:#(  )
	expect:nil

    "
     self run:#testException02
     self new testException02
    "
!

testFor01
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			for (n = 0; n < 10; n++) {
			    Transcript.show("hello ");
			    Transcript.showCR(n);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #(
	'hello 0'
	'hello 1'
	'hello 2'
	'hello 3'
	'hello 4'
	'hello 5'
	'hello 6'
	'hello 7'
	'hello 8'
	'hello 9' ))

    "
     self run:#testFor01
     self new testFor01
    "
!

testFor01b
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n;

		    for (n = 0; n < arg; n++) {
			out.show("hello ");
			out.showCR(n);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor01b
     self new testFor01b
    "
!

testFor01c
    self
	execute:'test(arg) {
		    var n, m;

		    for (n = 0, m = 10; n < 10; n++, m--) {
			Transcript.show(n);
			Transcript.show(" -> ");
			Transcript.showCR(m);
		    }
		 }'
	for:nil
	arguments:#(5)
	expect:nil

    "
     self run:#testFor01c
     self new testFor01c
    "
!

testFor02
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n;

		    for (n = 0; n < arg; n++) {
			out.show("hello ");
			out.showCR(n);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor02
     self new testFor02
    "
!

testFor02b
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n;

		    for (n = 0; n < arg; ) {
			out.show("hello ");
			out.showCR(n++);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor02b
     self new testFor02b
    "
!

testFor03b
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n = 0;

		    for (; n < arg; ) {
			out.show("hello ");
			out.showCR(n++);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor03b
     self new testFor03b
    "
!

testFor04b
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n = 0;

		    for (; ; ) {
			if (n >= arg) return;
			out.show("hello ");
			out.showCR(n++);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor04b
     self new testFor04b
    "
!

testFor05
    |savedTranscript collector expected|

    savedTranscript := Smalltalk at:#Transcript.
    [
	Smalltalk at:#Transcript put:(collector := '' writeStream).
	self
	    execute:'test(arg) {
			for (var n = 0; n < arg; n++) {
			    Transcript.showCR(n);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ] ensure:[
	Smalltalk at:#Transcript put:savedTranscript
    ].

    expected := String streamContents:[:s | 0 to:4 do:[:n | s showCR:n]].
    self assert:(collector contents = expected).

    "
     self run:#testFor05
     self new testFor05
    "
!

testFor05b
    |outStream output|

    outStream := '' writeStream.

    self
	execute:'test(arg, out) {
		    var n = 0;

		    for (; ; ) {
			if (n >= arg) break;
			out.show("hello ");
			out.showCR(n++);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:outStream)
	expect:nil.

    output := outStream contents.
    self assert:(output = 'hello 0
hello 1
hello 2
hello 3
').

    "
     self run:#testFor05b
     self new testFor05b
    "
!

testFor05c
    |output|

    output := '' writeStream.
    self
	execute:'test(arg, out) {
		    var n = 0;

		    for (; ; ) {
			if (n >= arg) break;
			out.show("hello ");
			out.showCR(n++);
		    }
		 }'
	for:nil
	arguments:(Array with:4 with:output)
	expect:nil.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'hello 0'
	'hello 1'
	'hello 2'
	'hello 3'))

    "
     self run:#testFor05c
     self new testFor05c
    "
!

testFor05d
    |output|

    output := '' writeStream.
    self
	execute:'test(arg, out) {
		    var n = 0;

		    for (; ; ) {
			n++;
			if (n >= arg) break;
			if (n == 2) continue;
			out.show("hello ");
			out.showCR(n);
		    }
		 }'
	for:nil
	arguments:(Array with:5 with:output)
	expect:nil.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'hello 1'
	'hello 3'
	'hello 4' ))

    "
     self run:#testFor05d
     self new testFor05d
    "
!

testFor06
    |output|

    output := '' writeStream.
    self
	execute:'test(arg, out) {
		    for (var n = 0, var m = 10; n < 10; n++, m--) {
			out.show(n);
			out.show(" -> ");
			out.showCR(m);
		    }
		 }'
	for:nil
	arguments:(Array with:5 with:output)
	expect:nil.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'0 -> 10'
	'1 -> 9'
	'2 -> 8'
	'3 -> 7'
	'4 -> 6'
	'5 -> 5'
	'6 -> 4'
	'7 -> 3'
	'8 -> 2'
	'9 -> 1'
       ))

    "
     self run:#testFor06
     self new testFor06
    "
!

testFor07
    |output|

    output := '' writeStream.
    self
	execute:'test(arg, out) {
		    for (var n = 0, var m = 10; n < 10; n++, m--) {
			if ((n >= 3) && (n <= 6)) {
			    out.show(n);
			    out.show(" -> ");
			    out.showCR(m);
			}
		    }
		 }'
	for:nil
	arguments:(Array with:5 with:output)
	expect:nil.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'3 -> 7'
	'4 -> 6'
	'5 -> 5'
	'6 -> 4'
       ))

    "
     self run:#testFor06
     self new testFor06
    "
!

testFor08
    |output|

    output := '' writeStream.
    self
	execute:'test(arg, out) {
		    var x = 10;

		    for (var n = 0, var m = 10; n < 10; n++, m--) {
			if ((n >= 3) && (n <= 6)) {
			    if ((n >= 4) && (n <= 5)) {
				out.show(n);
				out.show(" -> ");
				out.showCR(m);
			    }
			}
		    }
		 }'
	for:nil
	arguments:(Array with:5 with:output)
	expect:nil.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'4 -> 6'
	'5 -> 5'
       ))

    "
     self run:#testFor06
     self new testFor06
    "
!

testForIn01
    |output|

    JavaScriptParser forInAllowed ifFalse:[^ self].

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var arr = [ "one", "two", "three" ];

			for (var el in arr) {
			    Transcript.showCR(el);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].

    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'one' 'two' 'three' ))

    "
     self run:#testForIn01
     self new testForIn01
    "
!

testForIn02
    |output|

    JavaScriptParser forInAllowed ifFalse:[^ self].

    output := '' writeStream.
    self
	execute:'test(arg, output) {
		    var sum = 0;

		    for (var el in arg) {
			var last = el;
			output.showCR(el*el);
			sum += el;
			last = sum;
		    }
		    return last;
		 }'
	for:nil
	arguments:( Array with:#(1 2 3) with:output)
	expect:6.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'1'
	'4'
	'9'
       ))

    "
     self run:#testForIn01
     self new testForIn01
    "
!

testForIn03
    |output|

    JavaScriptParser forInAllowed ifFalse:[^ self].

    output := '' writeStream.
    self
	execute:'test(arg, output) {
		    var sum = 0;

		    for (var el in arg) {
			output.showCR(el*el);
			if (el == 1) continue;
			sum += el;
			if (el == 2) break;
		    }
		    return sum;
		 }'
	for:nil
	arguments:( Array with:#(1 2 3) with:output)
	expect:2.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'1'
	'4'
       ))

    "
     self run:#testForIn01
     self new testForIn01
    "
!

testForIn04
    |output|

    JavaScriptParser forInAllowed ifFalse:[^ self].

    output := '' writeStream.
    self
	execute:'test(arg, output) {
		    var sum = 0;

		    for (var el in arg) {
			output.showCR(el*el);
			for (var i in ["a", "b", "c"]) {
			    output.showCR(i);
			    if (i == "b") break;
			}
			if (el == 1) continue;
			sum += el;
			if (el == 2) break;
		    }
		    return sum;
		 }'
	for:nil
	arguments:( Array with:#(1 2 3) with:output)
	expect:2.

    self assert:(output contents asCollectionOfLinesWithReturn asArray = #(
	'1'
	'a'
	'b'
	'4'
	'a'
	'b'
       ))

    "
     self run:#testForIn01
     self new testForIn01
    "
!

testIf01
    self
	execute:'max(a, b) {
		    if (a > b) return a;
		    return b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testIf01
     self new testIf01
    "
!

testIf02
    self
	execute:'max(a, b) {
		    if (a > b) ;
		    else return b;
		    return a;
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testIf02
     self new testIf02
    "
!

testIf03
    self
	execute:'max(a, b) {
		    if (a > b) return a;
		    else return b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testIf03
     self new testIf03
    "
!

testInnerFunctionWithForLoop

    |savedTranscript collector expected|

    savedTranscript := Smalltalk at:#Transcript.
    [
	Smalltalk at:#Transcript put:(collector := '' writeStream).

	self
	    execute:'
execute() {
    function foo()
    {
	Transcript.show("foo called\n");
    }

    function bar()
    {
	Transcript.show("bar called\n");
    }

    function bla(n)
    {
	Transcript.show("bla called\n");
    }

    function test()
    {

	foo();
	bar();
	var _fecUs;
	var _fecDs;
	var _cvUs = Array.new(15);
	var _cvDs = Array.new(15);
	var _headerLength = 10;
	var _headerLength2 = 10;
	var _raw = Array.new(20);

	for(var l=_headerLength+2;l<=_raw.size;l++)
	{
		var x = _raw[l];
		if(l!!=_raw.size)
		    { var y = _raw[l+1]; }

		if(_cvUs.size >10 && _cvDs.size>10)
		{
		    _fecUs = 15.asInteger - 12.asInteger;
		    _fecDs = 20.asInteger - 13.asInteger;
		    bla(_fecUs);
		    bla(_fecDs);
		    bla(_cvUs);
		    bla(_cvDs);
		    if(_fecUs >=0 && _fecUs >=0)
		    {
			Transcript.show("hello\n");
		    }

		}
	    if(_cvUs.size == 5)
	    { Transcript.show("end\n"); }
	}
	Transcript.show("bbb\n");
    }

    test();
}
'
	    for:nil
	    arguments:#()
	    expect:nil
    ] ensure:[
	Smalltalk at:#Transcript put:savedTranscript
    ].

    expected := String streamContents:[:s |
		    s showCR:'foo called'.
		    s showCR:'bar called'.
		    9 timesRepeat:[
			s showCR:'bla called'.
			s showCR:'bla called'.
			s showCR:'bla called'.
			s showCR:'bla called'.
			s showCR:'hello'.
		    ].
		    s showCR:'bbb'.
		].
    self assert:(collector contents = expected).

    "
     self run:#testVarDeclaration08
     self new testVarDeclaration08
    "
!

testLiteralReturn01
    self
	execute:'function f() { return (0); }'
	for:nil
	arguments:#()
	expect:0

    "
     self run:#testLiteralReturn01
     self new testLiteralReturn01
    "
!

testLiteralReturn02
    self
	execute:'function f() { return (0.0); }'
	for:nil
	arguments:#()
	expect:0.0

    "
     self run:#testLiteralReturn02
     self new testLiteralReturn02
    "
!

testLiteralReturn03
    self
	execute:'function f() { return ("foo"); }'
	for:nil
	arguments:#()
	expect:'foo'

    "
     self run:#testLiteralReturn03
     self new testLiteralReturn03
    "
!

testLiteralReturn04
    self
	execute:'function f() { return (true); }'
	for:nil
	arguments:#()
	expect:true

    "
     self run:#testLiteralReturn04
     self new testLiteralReturn04
    "
!

testLiteralReturn05
    self
	execute:'function f() { return (false); }'
	for:nil
	arguments:#()
	expect:false

    "
     self run:#testLiteralReturn05
     self new testLiteralReturn05
    "
!

testLiteralReturn06
    self
	execute:'function f() { return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testLiteralReturn06
     self new testLiteralReturn06
    "
!

testLiteralReturn07
    self
	execute:'function f() { return (nil); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testLiteralReturn07
     self new testLiteralReturn07
    "
!

testLiteralReturn08
    self
	execute:'function f() { return ("hello"); }'
	for:nil
	arguments:#()
	expect:'hello'

    "
     self run:#testLiteralReturn08
     self new testLiteralReturn08
    "
!

testLiterals01
    |t|

    t := JavaScriptParser
	evaluate:'
[
    {"params": {"name": "q"}, "method": "click"},
    {"params": {"text": "hello world", "name": "q"}, "method": "type"},
    {"params": {"link": "Hallo-Welt-Programm \u2013 Wikipedia"}, "method": "click"},
    {"params": {"timeout": "20000"}, "method": "waits.forPageLoad"},
    {"params": {"link": "Druckversion", "timeout": "8000"}, "method": "waits.forElement"},
    {"params": {"link": "Druckversion"}, "method": "click"},
    {"params": {"timeout": "20000"}, "method": "waits.forPageLoad"},
    {"params": {"id": "siteSub"}, "method": "asserts.assertNode"}
];
'.
    self assert:(t isArray).
    self assert:(t size == 8).
    self assert:(t first class == JavaScriptObject).
    self assert:((t first at:#method) = 'click').
    self assert:((t last at:#method) = 'asserts.assertNode').

    "
     self run:#testLiterals01
     self new testLiterals01
    "
!

testLiterals02
    |t|

    t := JavaScriptParser
	evaluate:'
	    [ 1, 2, 3, 4, 5, 6, 7, 8 ];
	'.
    self assert:(t isArray).
    self assert:(t size == 8).
    self assert:(t = #(1 2 3 4 5 6 7 8)).

    "
     self run:#testLiterals02
     self new testLiterals02
    "
!

testLocalFunction01
    self
	execute:'test(arg) {
		    var x ;

		    function localFunction() {  return 10 / arg; };

		    x = localFunction() + 1;
		    return x;
		 }'
	for:nil
	arguments:#(5)
	expect:3

    "
     self run:#testLocalFunction01
     self new testLocalFunction01
    "

    "Created: / 20-02-2007 / 18:13:19 / cg"
    "Modified: / 20-02-2007 / 21:35:56 / cg"
!

testLocalFunction02
    self
	execute:'test(arg) {
		    var x ;

		    function localFunction() {  return (10 / arg) from test; };

		    x = localFunction() + 1;
		    return x;
		 }'
	for:nil
	arguments:#(5)
	expect:2

    "
     self run:#testLocalFunction02
     self new testLocalFunction02
    "

    "Created: / 20-02-2007 / 21:36:31 / cg"
!

testNew01
    self
	execute:'test() {
		    var a;

		    a = Array.new(5);
		    return a;
		 }'
	for:nil
	arguments:#()
	expect:#(nil nil nil nil nil).

    "
     self run:#testNew01
     self new testNew01
    "
!

testNew02
    self
	execute:'test() {
		    var a;

		    a = new Array(5);
		    return a;
		 }'
	for:nil
	arguments:#()
	expect:#(nil nil nil nil nil).

    "
     self run:#testNew02
     self new testNew02
    "
!

testNew03
    self
	execute:'test() {
		    var days;

		    days = new Array(7);
		    days[1] = "Monday";
		    days[2] = "Tuesday";
		    days[3] = "Wednesday";
		    days[4] = "Thursday";
		    days[5] = "Friday";
		    days[6] = "Saturday";
		    days[7] = "Sunday";

		    return days;
		 }'
	for:nil
	arguments:#()
	expect:#('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' 'Sunday')

    "
     self run:#testNew03
     self new testNew03
    "
!

testOperators01_plus
    self
	execute:'expr(a, b) {
		    return (a + 0);
		 }'
	for:nil
	arguments:#(10 20)
	expect:10

    "
     self run:#testOperators01_plus
     self new testOperators01_plus
    "
!

testOperators02_plus
    self
	execute:'expr(a, b) {
		    return (a + 1);
		 }'
	for:nil
	arguments:#(10 20)
	expect:11

    "
     self run:#testOperators02_plus
     self new testOperators02_plus
    "
!

testOperators03_minus
    self
	execute:'expr(a, b) {
		    return (a - 1);
		 }'
	for:nil
	arguments:#(10 20)
	expect:9

    "
     self run:#testOperators03_minus
     self new testOperators03_minus
    "
!

testOperators04_plus
    self
	execute:'expr(a, b) {
		    return (a + a);
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testOperators04_plus
     self new testOperators04_plus
    "
!

testOperators05_mul
    self
	execute:'expr(a, b) {
		    return (a * 0);
		 }'
	for:nil
	arguments:#(10 20)
	expect:0

    "
     self run:#testOperators05_mul
     self new testOperators05_mul
    "
!

testOperators06_mul
    self
	execute:'expr(a, b) {
		    return (a * 1);
		 }'
	for:nil
	arguments:#(10 20)
	expect:10

    "
     self run:#testOperators06_mul
     self new testOperators06_mul
    "
!

testOperators07_mul
    self
	execute:'expr(a, b) {
		    return (a * -1);
		 }'
	for:nil
	arguments:#(10 20)
	expect:-10

    "
     self run:#testOperators07_mul
     self new testOperators07_mul
    "
!

testOperators08_mul
    self
	execute:'expr(a, b) {
		    return (a * 10);
		 }'
	for:nil
	arguments:#(10 20)
	expect:100

    "
     self run:#testOperators08_mul
     self new testOperators08_mul
    "
!

testOperators09_mul
    self
	execute:'expr(a, b) {
		    return (a * a);
		 }'
	for:nil
	arguments:#(10 20)
	expect:100

    "
     self run:#testOperators09_mul
     self new testOperators09_mul
    "
!

testOperators10_mul
    self
	execute:'expr(a, b) {
		    return (a * b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:200

    "
     self run:#testOperators10_mul
     self new testOperators10_mul
    "
!

testOperators11_minus
    self
	execute:'expr(a, b) {
		    return (a - b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:-10

    "
     self run:#testOperators11_minus
     self new testOperators11_minus
    "
!

testOperators12_unaryMinus
    self
	execute:'expr(a) {
		    return (-a);
		 }'
	for:nil
	arguments:#(10)
	expect:-10

    "
     self run:#testOperators12_unaryMinus
     self new testOperators12_unaryMinus
    "
!

testOperators13_minus
    self
	execute:'expr(a, b) {
		    return (a - -b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:30

    "
     self run:#testOperators13_minus
     self new testOperators13_minus
    "
!

testOperators14_unaryMinus
    self
	execute:'expr(a, b) {
		    return (a * -b);
		 }'
	for:nil
	arguments:#(10 1)
	expect:-10

    "
     self run:#testOperators14_unaryMinus
     self new testOperators14_unaryMinus
    "
!

testOperators15_div
    self
	execute:'expr(a, b) {
		    return (a / 1.0);
		 }'
	for:nil
	arguments:#(10 1)
	expect:10.0

    "
     self run:#testOperators15_div
     self new testOperators15_div
    "
!

testOperators16a_postInc
    self
	execute:'expr(a, b) {
		    return (a++);
		 }'
	for:nil
	arguments:#(10 1)
	expect:10

    "
     self run:#testOperators16a_postInc
     self new testOperators16a_postInc
    "

    "Modified: / 23-02-2007 / 13:29:51 / cg"
!

testOperators16b_postInc
    self
	execute:'expr(a, b) {
		    var aa = a;

		    return (aa++);
		 }'
	for:nil
	arguments:#(10 1)
	expect:10

    "
     self run:#testOperators16b_postInc
     self new testOperators16b_postInc
    "
!

testOperators16c_postInc
    self
	execute:'expr(a, b) {
		    var t = a++;
		    return (t);
		 }'
	for:nil
	arguments:#(10 1)
	expect:10

    "
     self run:#testOperators16c_postInc
     self new testOperators16c_postInc
    "

    "Created: / 23-02-2007 / 13:30:21 / cg"
!

testOperators16d_postInc
    self
	execute:'expr(a, b) {
		    var t = a++;
		    return (a);
		 }'
	for:nil
	arguments:#(10 1)
	expect:11

    "
     self run:#testOperators16d_postInc
     self new testOperators16d_postInc
    "

    "Created: / 23-02-2007 / 13:30:32 / cg"
!

testOperators16e_postInc
    self
	execute:'expr(a, b) {
		    var t = a++;
		    return (b);
		 }'
	for:nil
	arguments:#(10 1)
	expect:1

    "
     self run:#testOperators16e_postInc
     self new testOperators16e_postInc
    "

    "Created: / 23-02-2007 / 13:31:02 / cg"
!

testOperators17a_eq
    self
	execute:'expr(a, b) {
		    return (a == b);
		 }'
	for:nil
	arguments:#(10 10)
	expect:true

    "
     self run:#testOperators17a_eq
     self new testOperators17a_eq
    "
!

testOperators17b_eq
    self
	execute:'expr(a, b) {
		    return (a == b);
		 }'
	for:nil
	arguments:#(10 11)
	expect:false

    "
     self run:#testOperators17b_eq
     self new testOperators17b_eq
    "
!

testOperators17c_ne
    self
	execute:'expr(a, b) {
		    return (a !!= b);
		 }'
	for:nil
	arguments:#(10 10)
	expect:false

    "
     self run:#testOperators17c_ne
     self new testOperators17c_ne
    "
!

testOperators17d_ne
    self
	execute:'expr(a, b) {
		    return (a !!= b);
		 }'
	for:nil
	arguments:#(10 11)
	expect:true

    "
     self run:#testOperators17d_ne
     self new testOperators17d_ne
    "
!

testOperators18a_eq
    self
	execute:'expr(a, b) {
		    return (a == b);
		 }'
	for:nil
	arguments:#(10 10.0)
	expect:true

    "
     self run:#testOperators18a_eq
     self new testOperators18a_eq
    "
!

testOperators18b_ne
    self
	execute:'expr(a, b) {
		    return (a !!= b);
		 }'
	for:nil
	arguments:#(10 11.0)
	expect:true

    "
     self run:#testOperators18b_ne
     self new testOperators18b_ne
    "
!

testOperators19a_identical
    self
	execute:'expr(a, b) {
		    return (a === b);
		 }'
	for:nil
	arguments:#(10 10)
	expect:true

    "
     self run:#testOperators19a_identical
     self new testOperators19a_identical
    "
!

testOperators19b_identical
    self
	execute:'expr(a, b) {
		    return (a === b);
		 }'
	for:nil
	arguments:#( 10 10.0 )
	expect:false

    "
     self run:#testOperators19b_identical
     self new testOperators19b_identical
    "
!

testOperators19c_notIdentical
    self
	execute:'expr(a, b) {
		    return (a !!== b);
		 }'
	for:nil
	arguments:#( 10 10 )
	expect:false

    "
     self run:#testOperators19c_notIdentical
     self new testOperators19c_notIdentical
    "
!

testOperators19d_notIdentical
    self
	execute:'expr(a, b) {
		    return (a !!== b);
		 }'
	for:nil
	arguments:#( 10 10.0 )
	expect:true

    "
     self run:#testOperators19d_notIdentical
     self new testOperators19d_notIdentical
    "
!

testOperators20a_eq
    self
	execute:'expr(a, b) {
		    return (a == b);
		 }'
	for:nil
	arguments:#( 'foo' 'foo' )
	expect:true

    "
     self run:#testOperators20a_eq
     self new testOperators20a_eq
    "
!

testOperators20b_eq
    self
	execute:'expr(a, b) {
		    return (a == b);
		 }'
	for:nil
	arguments:#( 'foo' 'Foo' )
	expect:false

    "
     self run:#testOperators20b_eq
     self new testOperators20b_eq
    "
!

testOperators20c_ne
    self
	execute:'expr(a, b) {
		    return (a !!= b);
		 }'
	for:nil
	arguments:#( 'foo' 'Foo' )
	expect:true

    "
     self run:#testOperators20c_ne
     self new testOperators20c_ne
    "
!

testOperators20d_ne
    self
	execute:'expr(a, b) {
		    return (a !!= b);
		 }'
	for:nil
	arguments:#( 'foo' 'foo' )
	expect:false

    "
     self run:#testOperators20d_ne
     self new testOperators20d_ne
    "
!

testOperators21a_ne
    self
	execute:'expr(a) {
		    return (a !!= 0);
		 }'
	for:nil
	arguments:#('foo')
	expect:true

    "
     self run:#testOperators21a_ne
     self new testOperators21a_ne
    "
!

testOperators21b_ne
    self
	execute:'expr(a) {
		    return (a !!= 0);
		 }'
	for:nil
	arguments:#(0)
	expect:false

    "
     self run:#testOperators21b_ne
     self new testOperators21b_ne
    "
!

testOperators22a_gt
    self
	execute:'expr(a) {
		    return (a > 0);
		 }'
	for:nil
	arguments:#(0)
	expect:false

    "
     self run:#testOperators22a_gt
     self new testOperators22a_gt
    "
!

testOperators22b_gt
    self
	execute:'expr(a) {
		    return (a > 0);
		 }'
	for:nil
	arguments:#(1)
	expect:true

    "
     self run:#testOperators22b_gt
     self new testOperators22b_gt
    "
!

testOperators23a_unaryMinus
    self
	execute:'expr(a) {
		    return (-a);
		 }'
	for:nil
	arguments:#(1)
	expect:-1

    "
     self run:#testOperators23a_unaryMinus
     self new testOperators23a_unaryMinus
    "
!

testOperators23b_unaryMinus
    self
	execute:'expr(a) {
		    return (0 - -a);
		 }'
	for:nil
	arguments:#(1)
	expect:1

    "
     self run:#testOperators23b_unaryMinus
     self new testOperators23b_unaryMinus
    "
!

testOperators24a_div
    self
	execute:'expr(a) {
		    return (a / 4);
		 }'
	for:nil
	arguments:#(4)
	expect:1

    "
     self run:#testOperators24a_div
     self new testOperators24a_div
    "
!

testOperators24b_div
    self
	execute:'expr(a) {
		    return (a / 4.0);
		 }'
	for:nil
	arguments:#(4)
	expect:1.0

    "
     self run:#testOperators24b_div
     self new testOperators24b_div
    "
!

testOperators24c_div
    self
	execute:'expr(a) {
		    return (a / 4);
		 }'
	for:nil
	arguments:#(4.0)
	expect:1.0

    "
     self run:#testOperators24c_div
     self new testOperators24c_div
    "
!

testOperators24d_div
    self
	execute:'expr(a) {
		    return (a / 4.0);
		 }'
	for:nil
	arguments:#(4.0)
	expect:1.0

    "
     self run:#testOperators24d_div
     self new testOperators24d_div
    "
!

testOperators25a_mod
    self
	execute:'expr(a) {
		    return (a % 4);
		 }'
	for:nil
	arguments:#(4)
	expect:0

    "
     self run:#testOperators25a_mod
     self new testOperators25a_mod
    "
!

testOperators25b_mod
    self
	execute:'expr(a) {
		    return (a % 4.0);
		 }'
	for:nil
	arguments:#(4)
	expect:0.0

    "
     self run:#testOperators25b_mod
     self new testOperators25b_mod
    "
!

testOperators25c_mod
    self
	execute:'expr(a) {
		    return (a % 4);
		 }'
	for:nil
	arguments:#(4.0)
	expect:0.0

    "
     self run:#testOperators25c_mod
     self new testOperators25c_mod
    "
!

testOperators25d_mod
    self
	execute:'expr(a) {
		    return (a % 4.0);
		 }'
	for:nil
	arguments:#(4.0)
	expect:0.0

    "
     self run:#testOperators25d_mod
     self new testOperators25d_mod
    "
!

testOperators25e_mod
    self
	execute:'expr(a) {
		    return (a % 4);
		 }'
	for:nil
	arguments:#(-4)
	expect:0

    "
     self run:#testOperators25e_mod
     self new testOperators25e_mod
    "
!

testOperators25f_mod
    self
	execute:'expr(a) {
		    return (a % 4.0);
		 }'
	for:nil
	arguments:#(-4)
	expect:0.0

    "
     self run:#testOperators25f_mod
     self new testOperators25f_mod
    "
!

testOperators25g_mod
    self
	execute:'expr(a) {
		    return (a % 4);
		 }'
	for:nil
	arguments:#(-4.0)
	expect:0.0

    "
     self run:#testOperators25g_mod
     self new testOperators25g_mod
    "
!

testOperators25h_mod
    self
	execute:'expr(a) {
		    return (a % 4.0);
		 }'
	for:nil
	arguments:#(-4.0)
	expect:0.0

    "
     self run:#testOperators25h_mod
     self new testOperators25h_mod
    "
!

testOperators26a_postInc
    self
	execute:'expr(a) {
		    var x = a;

		    return (x++);
		 }'
	for:nil
	arguments:#(1)
	expect:1

    "
     self run:#testOperators26a_postInc
     self new testOperators26a_postInc
    "
!

testOperators26b_postDec
    self
	execute:'expr(a) {
		    var x = a;

		    return (x--);
		 }'
	for:nil
	arguments:#(1)
	expect:1

    "
     self run:#testOperators26b_postDec
     self new testOperators26b_postDec
    "
!

testOperators26c_preInc
    self
	execute:'expr(a) {
		    var x = a;

		    return (++x);
		 }'
	for:nil
	arguments:#(1)
	expect:2

    "
     self run:#testOperators26c_preInc
     self new testOperators26c_preInc
    "
!

testOperators26d_preDec
    self
	execute:'expr(a) {
		    var x = a;

		    return (--x);
		 }'
	for:nil
	arguments:#(1)
	expect:0

    "
     self run:#testOperators26d_preDec
     self new testOperators26d_preDec
    "
!

testOperators27a_postInc
    self
	execute:'expr(a) {
		    var x = a;

		    x++;
		    return (x);
		 }'
	for:nil
	arguments:#(1)
	expect:2

    "
     self run:#testOperators27a_postInc
     self new testOperators27a_postInc
    "
!

testOperators27b_postDec
    self
	execute:'expr(a) {
		    var x = a;

		    x--;
		    return (x);
		 }'
	for:nil
	arguments:#(1)
	expect:0

    "
     self run:#testOperators27b_postDec
     self new testOperators27b_postDec
    "
!

testOperators27c_preInc
    self
	execute:'expr(a) {
		    var x = a;

		    ++x;
		    return (x);
		 }'
	for:nil
	arguments:#(1)
	expect:2

    "
     self run:#testOperators27c_preInc
     self new testOperators27c_preInc
    "
!

testOperators27d_preDec
    self
	execute:'expr(a) {
		    var x = a;

		    --x;
		    return (x);
		 }'
	for:nil
	arguments:#(1)
	expect:0

    "
     self run:#testOperators27d_preDec
     self new testOperators27d_preDec
    "
!

testOperators27e_postInc
    |arr|

    arr := (1 to:15) asArray.

    self
	execute:'expr(a) {
		    return (a[10]++);
		 }'
	for:nil
	arguments:{ arr }
	expect:10.

    self assert:(arr = #(1 2 3 4 5 6 7 8 9 11 11 12 13 14 15))

    "
     self run:#testOperators27e_postInc
     self new testOperators27e_postInc
    "
!

testOperators27f_preDec
    |arr|

    arr := (1 to:15) asArray.

    self
	execute:'expr(a) {
		    return (--a[10]);
		 }'
	for:nil
	arguments:{ arr }
	expect:9.

    self assert:(arr = #(1 2 3 4 5 6 7 8 9 9 11 12 13 14 15))

    "
     self run:#testOperators27f_preDec
     self new testOperators27f_preDec
    "
!

testOperators28_not
    self
	execute:'expr(a) {
		    return (!! a);
		 }'
	for:nil
	arguments:#(true)
	expect:false

    "
     self run:#testOperators28_not
     self new testOperators28_not
    "
!

testOperators29a_plusAssign
    self
	execute:'expr(a, b, c, d) {
		    var s = 0;
		    s += a;
		    s += b;
		    s += c;
		    s += d;
		    s += 1;
		    return (s);
		 }'
	for:nil
	arguments:#( 1 2 3 4 )
	expect:11

    "
     self run:#testOperators29a_plusAssign
     self new testOperators29a_plusAssign
    "
!

testOperators29c_minusAssign
    self
	execute:'expr(a, b, c, d) {
		    var s = 0;
		    s -= a;
		    s -= b;
		    s -= c;
		    s -= d;
		    s -= 1;
		    return (s);
		 }'
	for:nil
	arguments:#( 1 2 3 4 )
	expect:-11

    "
     self run:#testOperators29c_minusAssign
     self new testOperators29c_minusAssign
    "
!

testOperators30_timesAssign
    self
	execute:'expr(a, b, c, d) {
		    var s = 1;
		    s *= a;
		    s *= b;
		    s *= c;
		    s *= d;
		    s *= 2;
		    return (s);
		 }'
	for:nil
	arguments:#( 1 2 3 4 )
	expect:48

    "
     self run:#testOperators30_timesAssign
     self new testOperators30_timesAssign
    "
!

testOperators31a_shiftLeft
    self
	execute:'expr(a) {
		    return (a << 1);
		 }'
	for:nil
	arguments:#( 1 )
	expect:2

    "
     self run:#testOperators31a_shiftLeft
     self new testOperators31a_shiftLeft
    "
!

testOperators31b_shiftLeft
    self
	execute:'expr(a) {
		    return (a << 32);
		 }'
	for:nil
	arguments:#( 1 )
	expect:16r100000000

    "
     self run:#testOperators31b_shiftLeft
     self new testOperators31b_shiftLeft
    "
!

testOperators31c_shiftLeftAssign
    self
	execute:'expr(a) {
		    var b = a;

		    b <<= 1;
		    return b;
		 }'
	for:nil
	arguments:#( 1 )
	expect:2

    "
     self run:#testOperators31c_shiftLeftAssign
     self new testOperators31c_shiftLeftAssign
    "
!

testOperators32a_shiftRight
    self
	execute:'expr(a) {
		    return (a >> 1);
		 }'
	for:nil
	arguments:#( 2 )
	expect:1

    "
     self run:#testOperators32a_shiftRight
     self new testOperators32a_shiftRight
    "
!

testOperators32b_shiftRightAssign
    self
	execute:'expr(a) {
		    var b = a;

		    b >>= 1;
		    return b;
		 }'
	for:nil
	arguments:#( 5 )
	expect:2

    "
     self run:#testOperators32b_shiftRightAssign
     self new testOperators32b_shiftRightAssign
    "
!

testOperators33_bitOrAssign
    self
	execute:'expr(a, b) {
		    var s = 0;
		    s |= a;
		    s |= b;
		    return (s);
		 }'
	for:nil
	arguments:#(1 4)
	expect:5

    "
     self run:#testOperators33_bitOrAssign
     self new testOperators33_bitOrAssign
    "
!

testOperators34_bitAndAssign
    self
	execute:'expr(a, b) {
		    var s = 0xFFFF;
		    s &= a;
		    s &= b;
		    return (s);
		 }'
	for:nil
	arguments:#(3 5)
	expect:1

    "
     self run:#testOperators34_bitAndAssign
     self new testOperators34_bitAndAssign
    "
!

testOperators35a_bitXorAssign
    self
	execute:'expr(a) {
		    var s = 0xFFFF;
		    s ^= a;
		    return (s);
		 }'
	for:nil
	arguments:#( 1 )
	expect:16rFFFE

    "
     self run:#testOperators35a_xorAssign
     self new testOperators35a_xorAssign
    "
!

testOperators35b_bitXor
    self
	execute:'expr(a) {
		    var s = 0xFFFF;
		    s = s ^ a;
		    return (s);
		 }'
	for:nil
	arguments:#( 1 )
	expect:16rFFFE

    "
     self run:#testOperators35b_xor
     self new testOperators35b_xor
    "
!

testOperators36a_mod
    self
	execute:'expr(a) {
		    return (a % 2);
		 }'
	for:nil
	arguments:#(10)
	expect:0

    "
     self run:#testOperators36a_mod
     self new testOperators36a_mod
    "
!

testOperators36b_mod
    self
	execute:'expr(a) {
		    return (a % 2);
		 }'
	for:nil
	arguments:#(9)
	expect:1

    "
     self run:#testOperators36b_mod
     self new testOperators36b_mod
    "
!

testOperators37a_cond
    self
	execute:'expr(a) {
		    return (a ? 1 : 0);
		 }'
	for:nil
	arguments:#(true)
	expect:1

    "
     self run:#testOperators37a_cond
     self new testOperators37a_cond
    "
!

testOperators37b_cond
    self
	execute:'expr(a) {
		    return (a ? 1 : 0);
		 }'
	for:nil
	arguments:#(false)
	expect:0

    "
     self run:#testOperators37b_cond
     self new testOperators37b_cond
    "
!

testOperators37c_cond
    self
	execute:'expr(a, b) {
		    return (a ? (b ? 0 : 1) : (b ? 2 : 3));
		 }'
	for:nil
	arguments:#(false false)
	expect:3

    "
     self run:#testOperators37c_cond
     self new testOperators37c_cond
    "
!

testOperators37d_cond
    self
	execute:'expr(a) {
		    return (a == 1 ? 2 : 3);
		 }'
	for:nil
	arguments:#(1)
	expect:2

    "
     self run:#testOperators37d_cond
     self new testOperators37d_cond
    "
!

testOperators38a_eq
    self
	execute:'expr(a) {
		    return (a == 1);
		 }'
	for:nil
	arguments:#(1)
	expect:true

    "
     self run:#testOperators38a_eq
     self new testOperators38a_eq
    "
!

testOperators38b_eq
    self
	execute:'expr(a) {
		    return (a == 1);
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators38b_eq
     self new testOperators38b_eq
    "
!

testOperators38c_eq
    self
	execute:'expr(a) {
		    return ( "hello"[1].asString == "h" );
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators38c_eq
     self new testOperators38c_eq
    "

    "Modified: / 21-02-2007 / 14:12:07 / cg"
!

testOperators38c_ne
    self
	execute:'expr(a) {
		    return (a !!= 1);
		 }'
	for:nil
	arguments:#(1.0)
	expect:false

    "
     self run:#testOperators38c_ne
     self new testOperators38c_ne
    "
!

testOperators38d_eq
    self
	execute:'expr(a) {
		    return ("hello"[1] == $''h'' );
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators38d_eq
     self new testOperators38d_eq
    "
!

testOperators38d_ne
    self
	execute:'expr(a) {
		    return (a !!= 1);
		 }'
	for:nil
	arguments:#(2.0)
	expect:true

    "
     self run:#testOperators38d_ne
     self new testOperators38d_ne
    "
!

testOperators38e_eq
    self
	execute:'expr(a) {
		    return ( "hello"[1] == "h"[1] );
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators38e_eq
     self new testOperators38e_eq
    "

    "Created: / 21-02-2007 / 14:15:14 / cg"
!

testOperators38f_eq
    self
	execute:'expr(a) {
		    return ( ("hello"[1]).asString == "h" );
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators38f_eq
     self new testOperators38f_eq
    "

    "Created: / 21-02-2007 / 14:16:00 / cg"
!

testOperators39a_identical
    self
	execute:'expr(a) {
		    return (a === 1);
		 }'
	for:nil
	arguments:#(1)
	expect:true

    "
     self run:#testOperators39a_identical
     self new testOperators39a_identical
    "
!

testOperators39b_identical
    self
	execute:'expr(a) {
		    return (a === 1);
		 }'
	for:nil
	arguments:#(1.0)
	expect:false

    "
     self run:#testOperators39b_identical
     self new testOperators39b_identical
    "
!

testOperators39c_notIdentical
    self
	execute:'expr(a) {
		    return (a !!== 1);
		 }'
	for:nil
	arguments:#(1.0)
	expect:true

    "
     self run:#testOperators39c_notIdentical
     self new testOperators39c_notIdentical
    "
!

testOperators39d_notIdentical
    self
	execute:'expr(a) {
		    return (a !!== 1);
		 }'
	for:nil
	arguments:#(1)
	expect:false

    "
     self run:#testOperators39d_notIdentical
     self new testOperators39d_notIdentical
    "
!

testOperators40a_bitAnd
    self
	execute:'expr(a) {
		    return (a & 1);
		 }'
	for:nil
	arguments:#(1)
	expect:1

    "
     self run:#testOperators40a_bitAnd
     self new testOperators40a_bitAnd
    "
!

testOperators40b_bitAnd
    self
	execute:'expr(a) {
		    return (a & 1);
		 }'
	for:nil
	arguments:#(7)
	expect:1

    "
     self run:#testOperators40b_bitAnd
     self new testOperators40b_bitAnd
    "
!

testOperators41a_bitOr
    self
	execute:'expr(a) {
		    return (a | 1);
		 }'
	for:nil
	arguments:#(6)
	expect:7

    "
     self run:#testOperators41a_bitOr
     self new testOperators41a_bitOr
    "
!

testOperators42a_bitXor
    self
	execute:'expr(a) {
		    return (a ^ 1);
		 }'
	for:nil
	arguments:#(7)
	expect:6

    "
     self run:#testOperators42a_bitXor
     self new testOperators42a_bitXor
    "
!

testOperators43a_bitNot
    self
	execute:'expr(a) {
		    return (~a);
		 }'
	for:nil
	arguments:#(1)
	expect:-2

    "
     self run:#testOperators43a_bitNot
     self new testOperators43a_bitNot
    "
!

testOperators44a_logAnd
    self
	execute:'expr(a, b) {
		    return (a && (b > 5));
		 }'
	for:nil
	arguments:#(true 6)
	expect:true.

    self
	execute:'expr(a, b) {
		    return (a && (b > 5));
		 }'
	for:nil
	arguments:#(true 5)
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a > 10 && (b > 5));
		 }'
	for:nil
	arguments:#(10 5)
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a > 10 && (b > 5));
		 }'
	for:nil
	arguments:#(11 5)
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a > 10 && (b > 5));
		 }'
	for:nil
	arguments:#(10 6)
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a > 10 && (b > 5));
		 }'
	for:nil
	arguments:#(11 15)
	expect:true.

    self
	execute:'expr(a, b) {
		    return (a.size > 10 && (b.size > 5));
		 }'
	for:nil
	arguments:{Array new:10 . Array new:5}
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a.size > 10 && (b.size > 5));
		 }'
	for:nil
	arguments:{Array new:11 . Array new:5}
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a.size > 10 && (b.size > 5));
		 }'
	for:nil
	arguments:{Array new:10 . Array new:6}
	expect:false.

    self
	execute:'expr(a, b) {
		    return (a.size > 10 && (b.size > 5));
		 }'
	for:nil
	arguments:{Array new:11 . Array new:15}
	expect:true.

    "
     self run:#testOperators44a_logAnd
     self new testOperators44a_logAnd
    "
!

testOperators44b_logAnd
    "the right part of a logical and should not be evaluated,
     if the left is already false"

    self
	execute:'expr(a, bIn) {
		    var x, b;

		    b = bIn;
		    x = (a && (b++ > 5));
		    return b;
		 }'
	for:nil
	arguments:#(true 5)
	expect:6.

    self
	execute:'expr(a, bIn) {
		    var x, b;

		    b = bIn;
		    x = (a && (b++ > 5));
		    return b;
		 }'
	for:nil
	arguments:#(false 5)
	expect:5

    "
     self run:#testOperators44b_logAnd
     self new testOperators44b_logAnd
    "
!

testOperators45a_logOr
    self
	execute:'expr(a, b) {
		    return (a || (b > 5));
		 }'
	for:nil
	arguments:#(true 6)
	expect:true.

    self
	execute:'expr(a, b) {
		    return (a || (b > 5));
		 }'
	for:nil
	arguments:#(false 6)
	expect:true.

    self
	execute:'expr(a, b) {
		    return (a || (b > 5));
		 }'
	for:nil
	arguments:#(false 5)
	expect:false

    "
     self run:#testOperators45a_logOr
     self new testOperators45a_logOr
    "
!

testOperators45b_logOr
    "the right part of a logical or should not be evaluated,
     if the left is already true"

    self
	execute:'expr(a, bIn) {
		    var x, b;

		    b = bIn;
		    x = (a || (b++ > 5));
		    return b;
		 }'
	for:nil
	arguments:#(true 5)
	expect:5.

    self
	execute:'expr(a, bIn) {
		    var x, b;

		    b = bIn;
		    x = (a || (b++ > 5));
		    return b;
		 }'
	for:nil
	arguments:#(false 5)
	expect:6

    "
     self run:#testOperators45b_logOr
     self new testOperators45b_logOr
    "
!

testOperators46_comma
    self
	execute:'expr(a, b, c) {
		    var x;

		    x = a+1, b+1, c+1;
		    return x;
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:4.

    self
	execute:'expr(aIn, bIn, cIn) {
		    var x;
		    var a = aIn;
		    var b = bIn;
		    var c = cIn;

		    x = ++a , ++b, ++c, a+b+c;
		    return x;
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:9.

    self
	execute:'expr(aIn, bIn, cIn) {
		    var x;
		    var a = aIn;
		    var b = bIn;
		    var c = cIn;

		    x = a++ , b++, c++, a+b+c;
		    return x;
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:9.

    self
	execute:'expr(aIn, bIn, cIn) {
		    var x;
		    var a = aIn;
		    var b = bIn;
		    var c = cIn;

		    x = a++ , b++, c++, ++a + ++b + ++c;
		    return x;
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:12.

    self
	execute:'expr(aIn, bIn, cIn) {
		    var x;
		    var a = aIn;
		    var b = bIn;
		    var c = cIn;

		    x = a++ , b++, c++, a++ + b++ + c++;
		    return x;
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:9.
    "
     self run:#testOperators46_comma
     self new testOperators46_comma
    "
!

testOperators47_asString
    self
	execute:'expr() {
		    return 123.asString;
		 }'
	for:nil
	arguments:#()
	expect:'123'.

    self
	execute:'expr() {
		    return 1.23.asString;
		 }'
	for:nil
	arguments:#()
	expect:'1.23'.

    "
     self run:#testOperators47_toString
     self new testOperators47_toString
    "
!

testOperators48_isArray
    self
	execute:'expr(arg) {
		    return arg.isArray() ;
		 }'
	for:nil
	arguments:#(123)
	expect:false.

    self
	execute:'expr(arg) {
		    return arg.isArray() ;
		 }'
	for:nil
	arguments:#('hello')
	expect:false.

    self
	execute:'expr(arg) {
		    return arg.isArray() ;
		 }'
	for:nil
	arguments:#( (1 2 3) )
	expect:true.

    "
     self run:#testOperators48_isArray
     self new testOperators48_isArray
    "
!

testOperators49_concat
    self
	execute:'expr(arg1) {
		    return arg1.concat() ;
		 }'
	for:nil
	arguments:#( 'a')
	expect:'a'.

    self
	execute:'expr(arg1, arg2) {
		    return arg1.concat(arg2) ;
		 }'
	for:nil
	arguments:#( 'a' 'b')
	expect:'ab'.

    self
	execute:'expr(arg1, arg2, arg3) {
		    return arg1.concat(arg2, arg3) ;
		 }'
	for:nil
	arguments:#( 'a' 'b' 'c' )
	expect:'abc'.

    self
	execute:'expr() {
		    return "a".concat("b", "c", "d", "e", "f") ;
		 }'
	for:nil
	arguments:nil
	expect:'abcdef'.

    self
	execute:'expr() {
		    return "a".concat("b", "c", "d", "e", "f", "g") ;
		 }'
	for:nil
	arguments:nil
	expect:'abcdefg'.

    self
	execute:'expr() {
		    return "a".concat("b", "c", "d", "e", "f", "g", "h") ;
		 }'
	for:nil
	arguments:nil
	expect:'abcdefgh'.

    self
	execute:'expr(arg1, arg2, arg3) {
		    return arg1.concat(arg2, arg3) ;
		 }'
	for:nil
	arguments:#( (1) (2) (3) )
	expect:#(1 2 3).

    "
     self run:#testOperators49_concat
     self new testOperators49_concat
    "
!

testParserErrors01
    self should:[
	self
	    execute:'expr(a, ) {
			return (a == b);
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    self should:[
	self
	    execute:'expr(a b) {
			return (a == b);
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    self should:[
	self
	    execute:'expr(x) {
			return (x == 1 ?);
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    self should:[
	self
	    execute:'expr(x) {
			return (x == 1 ? 1 );
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    self should:[
	self
	    execute:'expr(x) {
			return (x == 1 ? 1 : );
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    self should:[
	self
	    execute:'expr(x) {
			return (x == 1 ? 1 : +);
		     }'
	    for:nil
	    arguments:#(10 10)
	    expect:true
    ] raise:ParseError.

    "
     self run:#testParserErrors01
     self new testParserErrors01
    "
!

testPrecidences01
    self
	execute:'expr(a, b) {
		    return (a + 4 * 5 + b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:(10 + (4 * 5) + 20)

    "
     self run:#testPrecidences01
     self new testPrecidences01
    "
!

testPrecidences02
    self
	execute:'expr(a, b) {
		    return (a * 4 + b * 5);
		 }'
	for:nil
	arguments:#(10 20)
	expect:140

    "
     self run:#testPrecidences02
     self new testPrecidences02
    "
!

testPrecidences03
    self
	execute:'expr(a, b) {
		    return -(a + b);
		 }'
	for:nil
	arguments:#(10 20)
	expect:-30

    "
     self run:#testPrecidences03
     self new testPrecidences03
    "
!

testPrecidences04
    self
	execute:'expr(a, b) {
		    return -a + b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:10

    "
     self run:#testPrecidences04
     self new testPrecidences04
    "
!

testPrecidences05
    self
	execute:'expr(a, b) {
		    return -a + -b;
		 }'
	for:nil
	arguments:#(10 20)
	expect:-30

    "
     self run:#testPrecidences05
     self new testPrecidences05
    "
!

testPrint
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'
		      testPrint() {
			  print("1 ");
			  print("2 ");
			  print("3 ");
			  println("4");
			  return null;
		      }
		     '
	    for:JavaScriptEnvironment new
	    arguments:#(  )
	    expect:nil.
    ].
    self assert:(output = '1 2 3 4\' withCRs).

    "
     self run:#testPrint
     self new testPrint
    "
!

testRecursion01
    self
	execute:'test(n) {
		     function factorial(n) {
			if (n > 0) {
			    return n * factorial(n-1);
			} else {
			    return 1;
			}
		     };

		     return factorial(n);
		 }'
	for:nil
	arguments:#(10)
	expect:(10 factorial)

    "
     self run:#testRecursion01
     self new testRecursion01
    "

    "Modified: / 20-04-2005 / 11:55:30 / cg"
!

testReturn01
    self
	execute:'test(n) {
		     return 1;
		 }'
	for:nil
	arguments:#(10)
	expect:1

    "
     self run:#testReturn01
     self new testReturn01
    "

    "Modified: / 20-04-2005 / 11:55:30 / cg"
!

testReturn02
    self
	execute:'test(n) {
		     function inner() { return 2 from test; };

		     inner();
		     return 1;
		 }'
	for:nil
	arguments:#(10)
	expect:2

    "
     self run:#testReturn02
     self new testReturn02
    "
!

testReturn03
    self
	execute:'test(n) {
		     function inner1() {
			function inner2() {
			    return 2 from test;
			};

			inner2();
		     };

		     inner1();
		     return 1;
		 }'
	for:nil
	arguments:#(10)
	expect:2

    "
     self run:#testReturn03
     self new testReturn03
    "
!

testReturn04
    "/ currently fails.
^ self.

    self
	execute:'test(n) {
		     function inner1() {
			function inner2() {
			    return 2 from inner1;
			};

			inner2();
		     };

		     inner1();
		     return 1;
		 }'
	for:nil
	arguments:#(10)
	expectError:#ParseError

    "
     self run:#testReturn04
     self new testReturn04
    "

    "Modified: / 21-02-2007 / 15:08:11 / cg"
!

testReturn05
    self
	execute:'test(n) {
		     function inner() { return 2; };

		     return inner() + 1;
		 }'
	for:nil
	arguments:#(10)
	expect:3

    "
     self run:#testReturn05
     self new testReturn05
    "

    "Created: / 21-02-2007 / 15:02:47 / cg"
!

testReturnNew01
    self
	execute:'test() {
		    var someString;

		    someString = "1234";
		    return (new Point).x(someString.asInteger());
		 }'
	for:nil
	arguments:#()
	expect:(Point x:1234 y:nil).

    "
     self run:#testReturnNew01
     self new testReturnNew01
    "

    "Created: / 01-02-2011 / 15:34:37 / cg"
!

testReturnNew02
    |result|

    result := self
	execute:'test() {
		    var someString;

		    someString = "1234";
		    return (new ValueHolder).value(someString.asInteger());
		 }'
	for:nil
	arguments:#().

    self assert:(result isKindOf:ValueHolder).
    self assert:(result value = 1234).

    "
     self run:#testReturnNew02
    "

    "Created: / 01-02-2011 / 15:35:36 / cg"
!

testScanner01
    self
	execute:'f() { }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner01
     self new testScanner01
    "
!

testScanner02
    self
	execute:'f(a) { }'
	for:nil
	arguments:#(1)
	expect:nil

    "
     self run:#testScanner02
     self new testScanner02
    "
!

testScanner03
    self
	execute:'f(a, b) { }'
	for:nil
	arguments:#(1 2)
	expect:nil

    "
     self run:#testScanner03
     self new testScanner03
    "
!

testScanner04
    self
	execute:'f(a, b) { return (null); }'
	for:nil
	arguments:#(1 2)
	expect:nil

    "
     self run:#testScanner04
     self new testScanner04
    "
!

testScanner05
    self
	execute:'f(a, b) { return (null); }'
	for:nil
	arguments:#(1)
	expectError:(Method wongNumberOfArgumentsSignal)

    "
     self run:#testScanner05
     self new testScanner05
    "

    "Modified: / 20-04-2005 / 11:53:20 / cg"
!

testScanner06
    self
	execute:'f() { /* a comment */ return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner06
     self new testScanner06
    "
!

testScanner07
    self
	execute:'f() { // an EOL comment
 return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner07
     self new testScanner07
    "
!

testScanner08
    self
	execute:'f() { // a comment in an /* an EOL comment
 return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner08
     self new testScanner08
    "
!

testScanner09
    self
	execute:'f() { // a comment in an /* an EOL */ comment
 return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner09
     self new testScanner09
    "
!

testScanner10
    self
	execute:'f() { /** a comment */
 return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner10
     self new testScanner10
    "
!

testScanner11
    self
	execute:'f() { /**/
 return (null); }'
	for:nil
	arguments:#()
	expect:nil

    "
     self run:#testScanner11
     self new testScanner11
    "
!

testScanner12
    "/ cg: is the comment below legal ?
    ^ self. "/ assume not

    self
	execute:'f() { /*/
 return (null); }'
	for:nil
	arguments:#()
	expectError:#ParseError

    "
     self run:#testScanner12
     self new testScanner12
    "
!

testScanner13
    "/ cg: is the comment below legal ?
    ^ self. "/ assume not

    self
	execute:'f_1() { /*/
 return (null); }'
	for:nil
	arguments:#()
	expectError:#ParseError

    "
     self run:#testScanner13
     self new testScanner13
    "
!

testScanner20
    #(

	 ' = '                  $=
	 '/* ignored */= '      $=
	 '/* ignored */ = '     $=
	 ' + '                  $+
	 ' - '                  $-
	 ' * '                  $*
	 ' / '                  $/
	 ' % '                  $%
	 ' & '                  $&
	 ' ^ '                  $^
	 ' | '                  $|
	 ' !! '                  $!!
	 ' < '                  $<
	 ' > '                  $>

	 ' << '        #'<<'
	 ' >> '        #'>>'
	 ' == '        #'=='
	 ' <= '        #'<='
	 ' >= '        #'>='
	 ' !!= '        #'!!='
	 ' || '        #'||'
	 ' && '        #'&&'
	 ' ++ '        #'++'
	 ' -- '        #'--'

	 ' += '        #'+='
	 ' -= '        #'-='
	 ' *= '        #'*='
	 ' /= '        #'/='
	 ' %= '        #'%='
	 ' &= '        #'&='
	 ' ^= '        #'^='
	 ' |= '        #'|='

	 ' >>> '       #'>>>'
	 ' >>= '       #'>>='
	 ' <<= '       #'<<='
	 ' === '       #'==='
	 ' !!== '       #'!!=='

	 ' 1 '         #Integer
	 ' 12345 '     #Integer
	 ' 1.0 '       #Float
	 ' 1e10 '      #Float
	 ' 1E10 '      #Float
	 ' 1E+10 '     #Float
	 ' 1E-10 '     #Float
	 ' 1.0d '      #Float
	 ' 1. '        #Float
"/         ' 1.'         #Float
    ) pairWiseDo:[:src :expectedToken |
	|scannedToken|

	scannedToken := (JavaScriptScanner for:src) nextToken.
	self assert:(scannedToken == expectedToken)
    ].

    "
     self run:#testScanner20
     self new testScanner20
    "
!

testString01
    self
	execute:'test(str) {
		    return "foo".size;
		 }'
	for:nil
	arguments:#( nil )
	expect:3

    "
     self run:#testString01
     self new testString01
    "
!

testString02
    self
	execute:'test(str) {
		    return str.size();
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:5

    "
     self run:#testString02
     self new testString02
    "
!

testString03
    self
	execute:'test(str) {
		    return str.size;
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:5

    "
     self run:#testString03
     self new testString03
    "
!

testString04
    self
	execute:'test(str) {
		    return str[1];
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:$h

    "
     self run:#testString04
     self new testString04
    "
!

testString05
    self
	execute:'test(str) {
		    return str[1] == "h"[1];
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:true

    "
     self run:#testString05
     self new testString05
    "
!

testString06
    self
	execute:'test(str) {
		    return str[1] == $''h'';
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:true

    "
     self run:#testString06
     self new testString06
    "
!

testString07
    self
	execute:'test(str) {
		    return str[1].isLowercase;
		 }'
	for:nil
	arguments:#( 'hello' )
	expect:true

    "
     self run:#testString07
     self new testString07
    "
!

testSuper01
    |class1 class2|

    Class withoutUpdatingChangesDo:[
	class1 := Class name:'T1' subclassOf:Object.
	class2 := Class name:'T2' subclassOf:class1.

	JavaScriptCompiler
	    compile:'foo() { return 1; }'
	    forClass:class1
	    inCategory:nil
	    notifying:nil
	    install:true.

	JavaScriptCompiler
	    compile:'foo() { return 2; }'
	    forClass:class2
	    inCategory:nil
	    notifying:nil
	    install:true.

	JavaScriptCompiler
	    compile:'callFoo() { return foo(); }'
	    forClass:class2
	    inCategory:nil
	    notifying:nil
	    install:true.

	JavaScriptCompiler
	    compile:'callSuperFoo() { return super.foo(); }'
	    forClass:class2
	    inCategory:nil
	    notifying:nil
	    install:true.
    ].

    self assert:(class2 new callFoo == 2).
    self assert:(class2 new callSuperFoo == 1).

    "
     self run:#testSuper01
     self new testSuper01
    "
!

testSwitch01
    self
	execute:'test(arg) {
		    switch (arg) {
		    }
		 }'
	for:nil
	arguments:#(5)
	expect:nil

    "
     self run:#testSwitch01
     self new testSwitch01
    "
!

testSwitch02
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			    Transcript.show("hello ");
			    return 1;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:0
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( ))

    "
     self run:#testSwitch02
     self new testSwitch02
    "
!

testSwitch03
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			    Transcript.show("hello ");
			    Transcript.show("world ");
			    Transcript.cr();
			    return 1;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:0
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #()  )

    "
     self run:#testSwitch03
     self new testSwitch03
    "
!

testSwitch04
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			default:
			    Transcript.show("hello ");
			    Transcript.show("world ");
			    Transcript.cr();
			    return 1;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:1
    ].
    self assert:(output = 'hello world \' withCRs).

    "
     self run:#testSwitch04
     self new testSwitch04
    "
!

testSwitch05
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			default:
			    Transcript.show("hello ");
			    Transcript.show("world ");
			    return 1;
			    Transcript.cr();
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:1
    ].
    self assert:(output = 'hello world ').

    "
     self run:#testSwitch05
     self new testSwitch05
    "
!

testSwitch06a
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			case 1:
			    Transcript.showCR("one");
			    return 10;
			case 2:
			    Transcript.showCR("two");
			    return 20;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(5)
	    expect:0
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( ))

    "
     self run:#testSwitch06a
     self new testSwitch06a
    "
!

testSwitch06b
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			case 1:
			    Transcript.showCR("one");
			    return 10;
			case 2:
			    Transcript.showCR("two");
			    return 20;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(1)
	    expect:10
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'one'))

    "
     self run:#testSwitch06b
     self new testSwitch06b
    "
!

testSwitch06c
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			case 1:
			    Transcript.showCR("one");
			    return 10;
			case 2:
			    Transcript.showCR("two");
			    return 20;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#(2)
	    expect:20
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'two'))

    "
     self run:#testSwitch06c
     self new testSwitch06c
    "
!

testSwitch06d
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			switch (arg) {
			case "hallo":
			    Transcript.showCR("Hallo");
			    return 10;
			case "hello":
			    Transcript.showCR("Hello");
			    return 20;
			}
			return 0;
		     }'
	    for:nil
	    arguments:#('hello')
	    expect:20
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'Hello'))

    "
     self run:#testSwitch06d
     self new testSwitch06d
    "
!

testSwitch06e
    self
	execute:'test(arg) {
		    switch (arg) {
		    case 1:
			Transcript.showCR("Hallo");
			return 10;
		    case 2:
			Transcript.showCR("Hello");
			return 20;
		    }
		    return 0;
		 }'
	for:nil
	arguments:#(3)
	expect:0

    "
     self run:#testSwitch06e
     self new testSwitch06e
    "
!

testSwitch06f
    self
	execute:'test(arg) {
		    var a = 0;
		    switch (arg) {
		    case 1:
			a = 10;
			break;
		    case 2:
			a = 20;
			break;
		    }
		    return a;
		 }'
	for:nil
	arguments:#(1)
	expect:10

    "
     self run:#testSwitch06f
     self new testSwitch06f
    "
!

testSwitch06g
    self
	execute:'test(arg) {
		    var a = 0;
		    switch (arg) {
		    case 1:
			a = 10;
			break;
		    case 2:
			a = 20;
			break;
		    }
		    return a;
		 }'
	for:nil
	arguments:#(2)
	expect:20

    "
     self run:#testSwitch06g
     self new testSwitch06g
    "
!

testSwitch06h
    self
	execute:'test(arg) {
		    var a = 0;
		    switch (arg) {
		    case 1:
			a = 10;
			break;
		    case 2:
			a = 20;
			break;
		    }
		    return a;
		 }'
	for:nil
	arguments:#(3)
	expect:0

    "
     self run:#testSwitch06h
     self new testSwitch06h
    "
!

testThrow01
    "an exception is thrown"

    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {
			throw Error;
		    };

		    try {
			failingMethod();
		    } catch (Error e) {
			handlerWasCalled =  true;
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(0)
	expect:true

    "
     self run:#testThrow01
     self new testThrow01
    "
!

testTryCatch01a
    "in this testcase, arg is 5, so no exception should be thrown"

    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {
			return 10 / arg;
		    };

		    try {
			failingMethod();
		    } catch (Error e) {
			handlerWasCalled =  true;
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(5)
	expect:false

    "
     self run:#testTryCatch01a
     self new testTryCatch01a
    "
!

testTryCatch01b
    "in this testcase, arg is 0, so an exception should be thrown"

    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {  return 10 / arg; };

		    try {
			failingMethod();
		    } catch (Error e) {
			handlerWasCalled =  true;
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(0)
	expect:true

    "
     self run:#testTryCatch01b
     self new testTryCatch01b
    "
!

testTryCatch02a
    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {  return 10 / arg; };
		    function exceptionRaised() {  handlerWasCalled =  true; };

		    try {
			failingMethod();
		    } catch (Error e) {
			exceptionRaised();
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(5)
	expect:false

    "
     self run:#testTryCatch02a
     self new testTryCatch02a
    "
!

testTryCatch02b
    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {  return 10 / arg; };
		    function exceptionRaised() {  handlerWasCalled =  true; };

		    try {
			failingMethod();
		    } catch (Error e) {
			exceptionRaised();
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(0)
	expect:true

    "
     self run:#testTryCatch02b
     self new testTryCatch02b
    "
!

testTryCatch03a
    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {  return 10 / arg; };
		    function exceptionRaised(e) {  handlerWasCalled =  true; };

		    try {
			failingMethod();
		    } catch (Error e) {
			exceptionRaised(e);
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(5)
	expect:false

    "
     self run:#testTryCatch03a
     self new testTryCatch03a
    "
!

testTryCatch03b
    self
	execute:'test(arg) {
		    var handlerWasCalled = false;

		    function failingMethod() {  return 10 / arg; };
		    function exceptionRaised(e) {  handlerWasCalled =  true; };

		    try {
			failingMethod();
		    } catch (Error e) {
			exceptionRaised(e);
		    }
		    return handlerWasCalled;
		 }'
	for:nil
	arguments:#(0)
	expect:true

    "
     self run:#testTryCatch03b
     self new testTryCatch03b
    "
!

testTryCatch04b
    self should:[

	self
	    execute:'test(arg) {
			var handlerWasCalled = false;

			function failingMethod() {  return 10 / arg; };
			function exceptionRaised() {  handlerWasCalled =  true; };

			try {
			    failingMethod();
			} catch (Error e) {
			    exceptionRaised(e);
			}
			return handlerWasCalled;
		     }'
	    for:nil
	    arguments:#(0)
	    expect:true

    ] raise: Error.

    "
     self run:#testTryCatch04b
     self new testTryCatch04b
    "
!

testTryCatchExceptionInfo
    |savedTranscript collector expected|

    savedTranscript := Smalltalk at:#Transcript.
    [
	Smalltalk at:#Transcript put:(collector := '' writeStream).

	self
	    execute:'
test(arg) {
    var handlerWasCalled = false;

    function failingMethod() {  return 10 / arg; };

    try {
	failingMethod();
    } catch (Error e) {
	println(e.description());
	handlerWasCalled = true;
    }
    return handlerWasCalled;
}'
	    for:JavaScriptEnvironment new
	    arguments:#(0)
	    expect:true.
    ] ensure:[
	Smalltalk at:#Transcript put:savedTranscript
    ].

    expected := String streamContents:[:s | s showCR:'division by zero'].
    self assert:(collector contents = expected).

    "
     self run:#testTryCatchExceptionInfo
     self new testTryCatchExceptionInfo
    "
!

testTryCatchFinally01
    self
	    execute:
'test(arg) {
    var handlerWasCalled = false;
    var finallyExecuted = false;

    function failingMethod() {  return 10 / arg; };
    function exceptionRaised() {  handlerWasCalled =  true; };

    try {
	failingMethod();
    } catch (Error e) {
	exceptionRaised();
    } finally {
	finallyExecuted = true;
    }
    return handlerWasCalled && finallyExecuted;
}'
	    for:nil
	    arguments:#(0)
	    expect:true.

    "
     self run:#testTryCatchFinally01
     self new testTryCatchFinally01
    "
!

testTryFinally01
    |savedTranscript collector expected|

    savedTranscript := Smalltalk at:#Transcript.
    [
	Smalltalk at:#Transcript put:(collector := '' writeStream).
	self
	    execute:
'test(arg) {
    var handlerWasCalled = false;

    println("1");
    try {
	function dummy () {
	    println("2a");
	    try {
		println("2b");
		return 10 / arg;
	    } finally {
		println("2c");
		handlerWasCalled = true;
	    }
	};

	println("2");
	dummy();
	println("3");
    } catch(Error);

    println("4");
    return handlerWasCalled;
 }'
	    for:JavaScriptEnvironment new
	    arguments:#(0)
	    expect:true

    ] ensure:[
	Smalltalk at:#Transcript put:savedTranscript
    ].

    expected := String streamContents:[:s |
		    s showCR:'1'.
		    s showCR:'2'.
		    s showCR:'2a'.
		    s showCR:'2b'.
		    s showCR:'2c'.
		    s showCR:'4'.
		].
    self assert:(collector contents = expected).

    "
     self run:#testTryFinally01
     self new testTryFinally01
    "
!

testTryFinally02
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var handler1WasCalled = false;
			var handler2WasCalled = false;
			var finallyActionWasEvaluated = false;

			println("1");
			try {

			    function dummy () {
				println("2a");
				try {
				    println("2b");
				    return 10 / arg;
				} finally {
				    println("2c");
				    handler1WasCalled = true;
				}
			    };

			    println("2");
			    dummy();
			    println("3");
			} catch(Error e) {
			    println("e");
			    handler2WasCalled =  true;
			} finally {
			    println("f");
			    finallyActionWasEvaluated = true;
			};

			println("4");
			return handler1WasCalled && handler2WasCalled && finallyActionWasEvaluated;
		     }'
	    for:JavaScriptEnvironment new
	    arguments:#(0)
	    expect:true
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '1' '2' '2a' '2b' 'e' '2c' 'f' '4'))

    "
     self run:#testTryFinally02
     self new testTryFinally02
    "
!

testTryFinally03
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var handlerWasCalled = false;
			var finallyActionWasEvaluated = false;

			println("1");
			try {
			    function dummy() {};

			    println("2");
			    dummy();
			    println("3");
			} catch(Error e) {
			    println("e");
			    handlerWasCalled =  true;
			} finally {
			    println("f");
			    finallyActionWasEvaluated = true;
			};

			println("4");
			return !!handlerWasCalled && finallyActionWasEvaluated;
		     }'
	    for:JavaScriptEnvironment new
	    arguments:#(0)
	    expect:true
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '1' '2' '3' 'f' '4'))

    "
     self run:#testTryFinally03
     self new testTryFinally03
    "
!

testTypeof01
    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#(0)
	expect:'number'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#('foo')
	expect:'string'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#(true)
	expect:'boolean'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#(false)
	expect:'boolean'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#(nil)
	expect:'undefined'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#( #[1 2 3] )
	expect:'object'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:#( #(1 2 3) )
	expect:'object'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:(Array with:(Point new))
	expect:'object'.

    self
	execute:'test(arg) {
		    return typeof(arg);
		 }'
	for:nil
	arguments:(Array with:Integer)
	expect:'object'.

    "
     self run:#testTypeof01
     self new testTypeof01
    "
!

testVarDeclaration01
    self
	execute:'expr(a, b) {
		    var x = 10;

		    return x;
		 }'
	for:nil
	arguments:#(10 20)
	expect:10

    "
     self run:#testVarDeclaration01
     self new testVarDeclaration01
    "
!

testVarDeclaration02
    self
	execute:'expr(a, b) {
		    var x = 10;

		    return (a + x);
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testVarDeclaration02
     self new testVarDeclaration02
    "
!

testVarDeclaration03
    self
	execute:'expr(a, b) {
		    var x = 10;
		    var y = x+10;

		    return (y);
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testVarDeclaration03
     self new testVarDeclaration03
    "
!

testVarDeclaration04
    self
	execute:'expr(a, b) {
		    var y = x+10;
		    var x = 10;

		    return (y);
		 }'
	for:nil
	arguments:#(10 20)
	expectError:#ParseError

    "
     self run:#testVarDeclaration04
     self new testVarDeclaration04
    "

    "Modified: / 23-02-2007 / 16:26:17 / cg"
!

testVarDeclaration05
    "our JS only allows variables declarations at a blocks top"

    self
	execute:'expr(a, b) {
		    var y = 10;

		    y = y + 10;

		    var x = 10;

		    return (y);
		 }'
	for:nil
	arguments:#(10 20)
	expect:20

    "
     self run:#testVarDeclaration05
     self new testVarDeclaration05
    "

    "Modified: / 23-02-2007 / 16:25:07 / cg"
!

testVarDeclaration06

    self
	execute:'expr(x) {
		    var y = x + 20;

		    return (y);
		 }'
	for:nil
	arguments:#(10)
	expect:30

    "
     self run:#testVarDeclaration06
     self new testVarDeclaration06
    "
!

testVarDeclaration07

    self
	execute:'expr(x) {
		    var x = x + 20;

		    return (x);
		 }'
	for:nil
	arguments:#(10)
	expectError:Error

    "
     self run:#testVarDeclaration07
     self new testVarDeclaration07
    "
!

testVarDeclaration08

    self
	execute:'expr(aIn, bIn, cIn) {
		    var a = aIn, b = bIn, c = cIn;

		    return (a);
		 }'
	for:nil
	arguments:#(1 2 3)
	expect:1

    "
     self run:#testVarDeclaration08
     self new testVarDeclaration08
    "
!

testWhile01
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = arg;
			while (n > 0) {
			    n--;
			    Transcript.showCR("hello");
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'hello' 'hello' 'hello' 'hello' 'hello' ))

    "
     self run:#testWhile01
     self new testWhile01
    "
!

testWhile02
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n <= arg) {
			    n++;
			    Transcript.showCR("hello");
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( 'hello' 'hello' 'hello' 'hello' 'hello' ))

    "
     self run:#testWhile02
     self new testWhile02
    "
!

testWhile03
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n <= arg) {
			    Transcript.showCR(n++);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '1' '2' '3' '4' '5' ))

    "
     self run:#testWhile03
     self new testWhile03
    "
!

testWhile04
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n++ <= arg) {
			    Transcript.showCR(n);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '2' '3' '4' '5' '6'))

    "
     self run:#testWhile04
     self new testWhile04
    "
!

testWhile04b
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n++ <= arg) {
			    Transcript.showCR(n);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '2' '3' '4' '5' '6'))

    "
     self run:#testWhile04b
     self new testWhile04b
    "
!

testWhile05
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n++ <= arg) {
			    if (n == 3) continue;
			    Transcript.showCR(n);
			}
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '2' '4' '5' '6'))

    "
     self run:#testWhile05
     self new testWhile05
    "
!

testWhile06
    "
    Tests parsing of a while-loop with no body
    "
    |output|

    output := self outputToTranscriptOf:[
	self
	    execute:'test(arg) {
			var n;

			n = 1;
			while (n++ < arg) {
			}
			Transcript.showCR(n);
		     }'
	    for:nil
	    arguments:#(5)
	    expect:nil
    ].
    self assert:(output asCollectionOfLinesWithReturn asArray = #( '6'))

    "
     self run:#testWhile05
     self new testWhile05
    "

    "Created: / 17-09-2014 / 14:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01_parse_literals
    |spec|

    spec := #(
			('1'                    #isInteger       1)
			('0'                    #isInteger       0)
			('-1'                   #isInteger       -1)
			('12345678901234567890' #isInteger       12345678901234567890)
			('0x0'                  #isInteger       0)
			('0x1'                  #isInteger       1)
			('0xFFFF'               #isInteger       16rFFFF)
			('0xffff'               #isInteger       16rFFFF)
			('0xFFFFFFFFFFFFFFFF'   #isInteger       16rFFFFFFFFFFFFFFFF)
			('0777'                 #isInteger       8r777)

			('1.2345'               #isFloat         1.2345)
			('-1.2345'              #isFloat         -1.2345)

			('nil'                  #isNil           nil)
			('null'                 #isNil           nil)
			('true'                 nil              true)
			('false'                nil              false)

			('"aString"'            #isString        'aString' )
			('''anotherString'''    #isString        'anotherString' )
			('''anoth"er"String'''  #isString        'anoth"er"String' )
			('"anoth''er''String"'  #isString        'anoth''er''String' )
			('"hello"'              #isString        'hello' )
			('"\b"'                 #isString        (#eval 'Character backspace asString') )
			('"\f"'                 #isString        (#eval 'Character ff asString') )
			('"\t"'                 #isString        (#eval 'Character tab asString') )
			('"\r"'                 #isString        (#eval 'Character return asString') )
			('"\n"'                 #isString        (#eval 'Character nl asString') )
			('"\''"'                #isString        '''' )
			('"\""'                #isString         '"' )

			('[ 1 , 2 , 3]'         #isArray         #(1 2 3) )
			('[1,2,3]'              #isArray         #(1 2 3) )
			('[1,2,3]'              #isArray         #(1 2 3) )
			('["a","b","c"]'        #isArray         #('a' 'b' 'c') )
			('[]'                   #isArray         #() )
			('[null]'               #isArray         #( nil ) )

			('[1,[2,[3]]]'          #isArray         #(1 (2 (3))) )

	       ).

    self doTestEachFromSpec:spec.

    "
     self run:#test_01_parse_literals
     self new test_01_parse_literals
    "
!

test_02_parse_literals2
    |spec|

    spec := #(
			('"\x00"'               #isString        (#eval '(Character value:0) asString') )
			('"\x01"'               #isString        (#eval '(Character value:1) asString') )
			('"\x1a"'               #isString        (#eval '(Character value:16r1a) asString') )
			('"\x000"'              #isString        (#eval '(Character value:0) asString , ''0'' ') )
			('"\xgg"'               #isString        (#error ) )
			('"\xg"'                #isString        (#error ) )
			('"\x"'                 #isString        (#error ) )
			('"\x0g"'               #isString        (#error ) )
			('"\u1234"'             #isString        (#eval '(Character value:16r1234) asString ') )
			('"\uFFFF"'             #isString        (#eval '(Character value:16rFFFF) asString ') )
	       ).

    self doTestEachFromSpec:spec.

    "
     self run:#test_02_parse_literals2
     self new test_02_parse_literals2
    "
!

test_03_parse_comments
    |spec|

    spec := #(
			('// ignored
			  1'                    #isInteger        1 )
			('/* ignored */ 2'      #isInteger        2 )
			('/* ign//ored */ 3'    #isInteger        3 )
	       ).

    self doTestEachFromSpec:spec.

    "
     self run:#test_03_parse_comments
     self new test_03_parse_comments
    "
!

test_03_parse_literals3
    "character syntax extension"

    |spec|

    spec := #(
			('$''a'''                  #isCharacter     (#eval '$a ') )
			('$''\n'''                 #isCharacter     (#eval '(Character nl)') )
			('$''\r'''                 #isCharacter     (#eval '(Character return)') )
			('$''\b'''                 #isCharacter     (#eval '(Character backspace)') )
			('$''\x00'''               #isCharacter     (#eval '(Character value:0)') )
			('$''\x01'''               #isCharacter     (#eval '(Character value:1)') )
			('$''\x1a'''               #isCharacter     (#eval '(Character value:16r1a)') )
			('$''\x000'''              #isCharacter     (#error ) )
			('$''\xgg'''               #isCharacter     (#error ) )
			('$''\xg'''                #isCharacter     (#error ) )
			('$''\x'''                 #isCharacter     (#error ) )
			('$''\x0g'''               #isCharacter     (#error ) )
			('$''\u1234'''             #isCharacter     (#eval '(Character value:16r1234) ') )
			('$''\uFFFF'''             #isCharacter     (#eval '(Character value:16rFFFF) ') )
	       ).

    self doTestEachFromSpec:spec.

    "
     self run:#test_03_parse_literals3
     self new test_03_parse_literals3
    "
!

test_10_parse_expression1
    |spec|

    spec := #(
	     ('1+1'                     nil                2 )
	     ('1-1'                     nil                0 )
	     ('2*2'                     nil                4 )
	     ('4/2'                     nil                2 )
	     ('5%3'                     nil                2 )
	     ('1234567890*1234567890'   nil                1524157875019052100 )
	     ('1234567890/1234567890'   nil                1 )
	     ('1234567890/1234567890.0' nil                1.0 )

	     ('1>0'                     nil                true )
	     ('1<0'                     nil                false )
	     ('1<=0'                    nil                false )
	     ('1>=0'                    nil                true )
	     ('1==0'                    nil                false )
	     ('1!!=0'                    nil                true )
	     ('1!!=1'                    nil                false )

	     ('3&5'                     nil                1 )
	     ('3|5'                     nil                7 )
	     ('5^1'                     nil                4 )
	   ).
    self doTestEachFromSpec:spec.

    "
     self run:#test_10_parse_expression1
     self new test_10_parse_expression1
    "

    "Modified: / 16-01-2012 / 20:01:53 / cg"
!

test_11_parse_expression2
    |spec|

    spec := #(
		('1=0'               nil                ( #error ) )
		('"abc"[0]'          nil                ( #error ) )
		('"abc"[1]'          nil                $a )
	     ).
    self doTestEachFromSpec:spec.

    "
     self run:#test_11_parse_expression2
     self new test_11_parse_expression2
    "
!

test_30_parse_methods1
    |spec|

    "/ spec is { source shouldErrBoolean }
    spec := #(
		('
execute(in1) {
    var t;

    Dialog.information((t = in1.value()) == nil ? "nil" : t);
}'
false
		)

	     ).
    self doTestEachFunctionFromSpec:spec.

    "
     self run:#test_30_parse_methods1
     self new test_30_parse_methods1
    "
!

test_40_parse_function
    | tree |

    tree := JavaScriptParser parseExpression:'this.bar("arg1", 1)'.
    self assert: tree selectorPosition = (6 to: 8)

    "Created: / 17-11-2014 / 13:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_41_parse_function
    | tree |

    tree := JavaScriptParser parseExpression:'this.bar'.
    self assert: tree selectorPosition = (6 to: 8)

    "Created: / 17-11-2014 / 13:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xtestInnerFunctionWithInitializedLocals

    self
	execute:'
execute() {
    function foo() {}
    function bar() {}

    function test()
    {

	foo();
	bar();
	var a;
	var b;
	var c = Array.new(15);
	var d = 20;

	return [ a , b , c , d ];
    }

    test();
}
'
	for:nil
	arguments:#()
	expect:{ nil . nil . (Array new:15) . 20 }

    "
     self run:#testInnerFunctionWithInitializedLocals
     self new testInnerFunctionWithInitializedLocals
    "
!

xtestNew04
    self
	execute:'test() {
		    var days;

		    days = new Array(7,2);
		    days[1,1] = "Monday";
		    days[2,1] = "Tuesday";
		    days[3,1] = "Wednesday";
		    days[4,1] = "Thursday";
		    days[5,1] = "Friday";
		    days[6,1] = "Saturday";
		    days[7,1] = "Sunday";

		    return days;
		 }'
	for:nil
	arguments:#()
	expect:#('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' 'Sunday')

    "
     self run:#testNew04
     self new testNew04
    "

    "Created: / 23-02-2007 / 12:24:50 / cg"
! !

!JavaScriptTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

