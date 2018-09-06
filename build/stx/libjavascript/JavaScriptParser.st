"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
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

JavaScriptScanner subclass:#JavaScriptParser
	instanceVariableNames:'foldConstants topEnvironment currentEnvironment currentNamespace
		selfValue classToCompileFor isDoIt usedInstVars usedClassVars
		usedGlobals usedVars modifiedInstVars modifiedClassVars
		modifiedGlobals modifiedVars noComma arraysAreImmutable
		stringsAreImmutable moreSharedPools interactiveMode tree
		alreadyWarnedUndeclaredVariables staticVars methodCategory
		gotAnyRealStatement usesSuper smalltalkCompatibilityMode
		untranslatedJavaScriptSelectors1 untranslatedJavaScriptSelectors2
		readInstVars readClassVars readGlobals readVars
		inParenthizedExpression'
	classVariableNames:'ArraysAreImmutable StringsAreImmutable'
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

StatementNode subclass:#JavaScriptStatementNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

PrimaryNode subclass:#ArrayAccessNode
	instanceVariableNames:'arrayExpr indexExpressions lineNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::ArrayAccessNode subclass:#ArrayStoreNode
	instanceVariableNames:'expression'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#BreakStatementNode
	instanceVariableNames:''
	classVariableNames:'BreakSignal BreakLabelQuery'
	poolDictionaries:''
	privateIn:JavaScriptParser
!

ParseNode subclass:#CommaExpression
	instanceVariableNames:'leftExpression rightExpression'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

ParseNode subclass:#ConditionalNode
	instanceVariableNames:'condition expr1 expr2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#ContinueStatementNode
	instanceVariableNames:''
	classVariableNames:'ContinueSignal ContinueLabelQuery'
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#DoWhileStatementNode
	instanceVariableNames:'condition loopStatements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#ForStatementNode
	instanceVariableNames:'initExpression condition incrExpression varExpression
		arrayExpression loopStatements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

MessageNode subclass:#FunctionCallNode
	instanceVariableNames:'javaScriptSelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#IfStatementNode
	instanceVariableNames:'condition ifStatements elseStatements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::FunctionCallNode subclass:#ImplicitFunctionCallNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

PrimaryNode subclass:#IncDecNode
	instanceVariableNames:'lValue isInc'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

BlockNode subclass:#InnerJavaBlockNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

AssignmentNode subclass:#JavaScriptAssignmentNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

BinaryNode subclass:#JavaScriptBinaryNode
	instanceVariableNames:'javaScriptSelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

ReturnNode subclass:#JavaScriptReturnNode
	instanceVariableNames:'environmentToReturnFrom'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#AndExpressionNode
	instanceVariableNames:'expression1 expression2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

UnaryNode subclass:#JavaScriptUnaryNode
	instanceVariableNames:'javaScriptSelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

PrimaryNode subclass:#NewNode
	instanceVariableNames:'classOrFunc dimensions lineNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#OrExpressionNode
	instanceVariableNames:'expression1 expression2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::IncDecNode subclass:#PostIncDecNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::IncDecNode subclass:#PreIncDecNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#StatementBlockNode
	instanceVariableNames:'statements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#SwitchStatementNode
	instanceVariableNames:'switchExpression statementBlocks'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

SelfNode subclass:#ThisNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#ThrowStatementNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#TryCatchStatementNode
	instanceVariableNames:'tryBlock errorExpression catchBlock finallyBlock'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

PrimaryNode subclass:#TypeOfNode
	instanceVariableNames:'expression lineNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

JavaScriptParser::JavaScriptStatementNode subclass:#WhileStatementNode
	instanceVariableNames:'condition loopStatements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptParser
!

!JavaScriptParser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    reads JavaScript-like syntax, builds up an AST similar to the ST-AST.
    Used for expecco, so be careful when changing.
"
!

example1
    "a little script as it may be in a scriptfile"
    
"
    |env val source|

    source := '
var a; var b = 5; a = 10; a + b;
'.
    env := STXScriptingEnvironment new. 
    val := 
       JavaScriptParser new 
           source:source readStream;
           evaluateDeclarationsFor:env.
    self assert:(val == 15).
    self assert:(env _localVariables at:#'a') value == 10.
    self assert:(env _localVariables at:#'b') value == 5.
"
!

example2
"
    |env val source|

    source :=
'
STXScriptingServer.errorDebugging(true);
Stdout.showCR(''hello'');
var filename;
var verdict, result;
filename = ''~/SuiteA.ets'';
verdict = Expecco::ExpeccoAPI.executeTestsFromFile_filteredByName_filteredByTag_testIDList_verboseInfoHandler_parameterFile_reporter(
    filename,
    null, /* namefilter */
    null, /* tagFilter */
    null, /* id-list */
    null, /* info handler */
    null, /* parameter file */
    (function (rslt) { result = rslt; }) /* reporter */
);
if (verdict.isSuccess) {
    alert(''ok'');
} else {
    alert(''not ok'');
}
'.

    env := STXScriptingEnvironment new. 
    val := 
       JavaScriptParser new 
           source:source readStream;
           evaluateDeclarationsFor:env.
    self assert:(env _localVariables at:#'filename') value = '~/SuiteA.ets'.
    self assert:(env _localVariables at:#'verdict') value isSuccess.
    (env _localVariables at:#'result') value inspect.
"
!

examples
"
                                                                                        [exBegin]
    JavaScriptParser parseExpression:'3 !!= 4'  
                                                                                        [exEnd]
    JavaScriptParser parseExpression:'0b11 + 0b100'   
                                                                                        [exBegin]
    (JavaScriptParser parseExpression:'3 + 4 * 5') evaluate  
                                                                                        [exEnd]
                                                                                        [exBegin]
    JavaScriptParser parseExpression:'(3 !!= 4) && (5 == 5)' 
                                                                                        [exEnd]
                                                                                        [exBegin]
    (JavaScriptParser parseExpression:'(3 == 4) || (5 == 5)') evaluate 
                                                                                        [exEnd]
                                                                                        [exBegin]
    JavaScriptParser parseExpression:'!!(3 !!= 4)'      
                                                                                        [exEnd]
                                                                                        [exBegin]
    (JavaScriptParser parseExpression:'(3 !!= 4)') evaluate
                                                                                        [exEnd]
                                                                                        [exBegin]
    (JavaScriptParser parseExpression:'!!(3 !!= 4)') evaluate
                                                                                        [exEnd]
                                                                                        [exBegin]
    #(
        '1 + 2 * 3 + 4'
        '1 * 2 * 3 * 4'
        '1 + 2 / 3'
        '10 / 3'
        '11 & 3'
        '0x8000'
        '0377'
        '3 == 3'
        '3 !!= 3'
        '3 == 4'
        '3 !!= 4'
        '3 > 3'
        '3 >= 3'
        '3 < 3'
        '3 <= 3'
        '3 > 4'
        '3 >= 4'
        '3 < 4'
        '3 <= 4'
        '4 > 3'
        '4 >= 3'
        '4 < 3'
        '4 <= 3'
        '0x8>>2'
        '8 << 2'
        '8 >>> 2'
    ) do:[:s |
        Transcript
            show:'''';
            show:s;
            show:'''';
            show:' ->  ';
            showCR:(JavaScriptParser parseExpression:s) evaluate.
    ]
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'function foo(a, b, c) {}'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'function foo(a, b, c) {
            if (a > 1) {
                return a;
            } else {
                return b;
            }
        }'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'
function bar(a, b, c) {
    var sum;

    while (a > 1) {
        sum += a;
        a--;
    }
    return sum;
}'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'
function bar(a, b, c) {
    var sum;
    var j;
    if ( foo(a,b) ) {
        for (j=0; j<=a.length; j++) {
            if (c[j] <= c[j+1])
                break;
        }
    }
    return sum;
}'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'
function bar(a, b, c) {
    var sum;

    if ( foo(a,b) ) {
        for (var j=0; j<=a.length; j++) {
            if (c[j] <= c[j+1])
                break;
        }
    }
    return sum;
}'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'
        function switch_time(value) {
          if (value < 0.5) sw = 0;
                else sw=-1;
        }
'
                                                                                        [exEnd]
                                                                                        [exBegin]
     JavaScriptParser
        parseFunction:'
        function f(a) {
          return ( function (b) { return (a + b); } );        
        }
'
                                                                                        [exEnd]
"
!

expression_examples
"
    TestCase assert:(JavaScriptParser evaluate:'3*3') = 9

    TestCase assert:(JavaScriptParser evaluate:'(8+7) % 13') = 2
    TestCase assert:(JavaScriptParser evaluate:'(5*4) % 13') = 7
    TestCase assert:(JavaScriptParser evaluate:'Math.floor(7/2)') = 3
    (JavaScriptParser evaluate:'Stdout.showCR(''hello'')')

    TestCase assert:(JavaScriptParser evaluate:'Math.gcd(5,64)') = 1

    (JavaScriptParser evaluate:'var x = { foo: ''hello'', bar:''world'' }; return x;' ) inspect
"
!

other_examples
"
    |env|
    env := JavaScriptEnvironment new.
    env _defineVariable:#UIMap value:(Expecco::SeleniumUIMap).

    JavaScriptParser 
        evaluateDeclarationsFrom:'C:\Temp\selenium\ui_map_expecconet.js' asFilename readStream
        for:env.

    self halt.



    |dummyReceiver code mthd|
    code := ('C:\Temp\selenium\ui_map_expecconet.js' asFilename contentsAsString).
    Class nameSpaceQuerySignal answer:ExpeccoDummyNameSpaceForSeleniumScripts
    do:[
    mthd := JavaScriptCompiler
            compile: ('doIt() { ',code ,' return(thisContext()); };')
            forClass:nil
            inCategory:nil
            notifying:nil
            install:false
    ].

    dummyReceiver := JavaScriptObject new.
    mthd valueWithReceiver:dummyReceiver arguments:#()
"
! !

!JavaScriptParser class methodsFor:'initialization'!

initialize
    ArraysAreImmutable := false.   
    StringsAreImmutable := false. 
!

postAutoload
    |prj|

    (prj := self projectDefinitionClass) notNil ifTrue:[
        prj loadExtensions
    ].

    "Modified: / 12-11-2010 / 11:19:36 / cg"
! !

!JavaScriptParser class methodsFor:'instance creation'!

for:aStringOrStream in:aClass
    "return a new parser, reading code for aClass from aStringOrStream"

    |parser|

    parser := self for:aStringOrStream.
    parser setClassToCompileFor:aClass.
    ^ parser
! !

!JavaScriptParser class methodsFor:'configuration'!

forInAllowed
    ^ true.
"/    ^ false.
! !

!JavaScriptParser class methodsFor:'evaluation'!

evaluate:aStringOrStream
    "evaluate a javaScript expression.
     A new environment is created, where variables are defined."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:nil
        compile:false

    "
     self evaluate:'1 + 2 * 3 + 4'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.showCR(1);
} else {
    Transcript.showCR(2);
}
'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.foo(1,2,3,4,5,6,7,8,9,10);
} else {
    Transcript.bar(1,2,3,4,5,6,7,8,9,10);
}
'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.show(""hello"");
} else {
    Transcript.show(""world"");
}
Transcript.cr;
'
    "

    "Modified: / 17.5.1998 / 21:23:33 / cg"
!

evaluate:aStringOrStream in:anEnvironment
    "like #evaluate, but take anEnvironment for variable/function declarations.
     New vars/functions will be added to that one; lookup for vars/methods
     is done there.
     If a nil environment is given, a new one will be created for the
     evaluation and discarded afterwards."

    ^ self
        evaluate:aStringOrStream
        in:anEnvironment
        receiver:nil
        notifying:nil
        logged:false
        ifFail:nil
        compile:false

    "Modified: / 17.5.1998 / 21:22:58 / cg"
!

evaluate:aString in:anEnvironment receiver:someObject notifying:requestor logged:logged ifFail:failBlock
    ^ self
        evaluate:aString
        in:anEnvironment
        receiver:someObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:false
!

evaluate:aStringOrStream in:anEnvironment receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    ^ self new
        evaluate:aStringOrStream 
        in:anEnvironment 
        receiver:anObject 
        notifying:requestor 
        logged:logged 
        ifFail:failBlock 
        compile:compile
!

evaluate:aStringOrStream receiver:receiver in:anEnvironment
    "like #evaluate, but take anEnvironment for variable/function declarations.
     New vars/functions will be added to that one; lookup for vars/methods
     is done there.
     If a nil environment is given, a new one will be created for the
     evaluation and discarded afterwards."

    ^ self
        evaluate:aStringOrStream
        in:anEnvironment
        receiver:receiver
        notifying:nil
        logged:false
        ifFail:nil
        compile:false

!

evaluateDeclarationsFrom:aStringOrStream for:anEnvironment
    |parser|

    parser := self for:aStringOrStream.
    parser nextToken.
    ^ parser evaluateDeclarationsFor:anEnvironment.

    "Created: / 17.5.1998 / 21:10:16 / cg"
    "Modified: / 17.5.1998 / 21:11:19 / cg"
!

evaluateFrom:aStringOrStream ifFail:exceptionValue
    "evaluate a javaScript expression.
     A new environment is created, where variables are defined."

    ^ self
        evaluate:aStringOrStream
        in:nil
        receiver:nil
        notifying:nil
        logged:false
        ifFail:exceptionValue
        compile:false

    "
     self evaluate:'1 + 2 * 3 + 4'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.showCR(1);
} else {
    Transcript.showCR(2);
}
'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.foo(1,2,3,4,5,6,7,8,9,10);
} else {
    Transcript.bar(1,2,3,4,5,6,7,8,9,10);
}
'
    "

    "
     self evaluate:'
if (1 > 2) {
    Transcript.show(""hello"");
} else {
    Transcript.show(""world"");
}
Transcript.cr;
'
    "

    "Modified: / 17.5.1998 / 21:23:33 / cg"
! !

!JavaScriptParser class methodsFor:'parsing'!

methodCommentFromSource:aStringOrStream
    "here, the methodComment is usually outside of the method's code,
     so comments before the function are included in the search, but after it are not."

    |parser comments|

    parser := self for:aStringOrStream.
    parser saveComments:true.
    parser nextToken.

    (comments := parser comments) isEmptyOrNil ifTrue:[^ nil].
    ^ comments first commentString.

    "
     JavaScriptParser methodCommentFromSource:'
// foo bar baz
function x() { 
    halt(); 
}
// bla bla
'                 
    "

    "Created: / 30-01-2011 / 15:56:25 / cg"
!

methodCommentsFromSource:aStringOrStream
    "returns all comments found in aStringOrStream.
     Here, the methodComment is usually outside of the method's code,
     so comments before the function are included, but after it are not."

    |parser|

    parser := self for:aStringOrStream.
    parser saveComments:true.
    parser nextToken.

    ^ (parser comments ? #()) collect:#commentString

    "
     JavaScriptParser methodCommentsFromSource:'
// foo bar baz
function x() { 
    halt(); 
}
// bla bla
'            
    "

    "Created: / 30-01-2011 / 15:56:25 / cg"
!

parseClassDefinition:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.

    tree := parser classDefinition.
    ^ tree
!

parseClassFile:aStringOrStream
    |compiler tree class sourceString outStream mthd collectingStream cat|

    outStream := WriteStream on:(String new:100).

    collectingStream := CollectingReadStream 
                        on:aStringOrStream readStream 
                        collecting:[:ch | outStream nextPut:ch].

    compiler := self for:collectingStream "aStringOrStream".
    compiler nextToken.

    tree := compiler classDefinition.
    tree isNil ifTrue:[
        compiler tokenType == #function ifFalse:[
            compiler parseError:'class or function definition expected'.
        ].    
        compiler compileFunctionDefinitions.
    ].    
    tree notNil ifTrue:[
        class := tree evaluate. "In:Smalltalk"
        class notNil ifTrue:[
            [ compiler tokenType ~~ #EOF ] whileTrue:[
                outStream := WriteStream on:(String new:100).
                "/ because the first token has already been read,
                "/ we have to manually shift it into the source collecting stream (sigh)
                outStream nextPutAll:compiler token.

                compiler reset.
                compiler targetClass:class.
                tree := compiler functionOrStaticFunction:false.
                cat := compiler methodCategory.
                sourceString := outStream contents.

                mthd := compiler
                        compileTree:tree source:sourceString
                        forClass:compiler targetClass inCategory:(cat ? 'no category')
                        notifying:nil
                        install:true
                        skipIfSame:false
                        silent:false
                        foldConstants:true.
"/ self halt.
                compiler token = $} ifTrue:[
                    compiler nextToken.
                ].
            ]
        ]
    ].
    ^ tree

    "Modified: / 26-10-2011 / 17:57:36 / cg"
!

parseExpression:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.

    tree := parser expression.
    ^ tree

    "
     self
        parseExpression:'1 + 2 * 3 + 4'
    "
    "
     self
        parseExpression:'1.1 + 2.2'
    "

    "Modified: / 14.5.1998 / 19:01:49 / cg"
!

parseFunction:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.

    tree := parser function.
    ^ tree

    "
     self
        parseFunction:'function foo(a, b, c) {}'
    "
    "
     self
        parseFunction:'function foo(a, b, c) { return a+b; }'
    "

    "Modified: / 26.10.1998 / 14:41:07 / cg"
!

parseFunction:aStringOrStream in:aClass
    |parser tree|

    parser := self for:aStringOrStream in:aClass.
    parser nextToken.

    tree := parser function.
    ^ tree

    "
     self
        parseFunction:'function foo(a, b, c) {}'
    "
    "
     self
        parseFunction:'function foo(a, b, c) { return a+b; }'
    "

    "Modified: / 26.10.1998 / 14:41:07 / cg"
!

parseMethod:aStringOrStream in:aClass
    "parse a method in a given class. Return a parser (instance of myself).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc."

    | parser |

    parser := self for:aStringOrStream in:aClass.
    parser nextToken.
    parser function.
    ^ parser

    "Created: / 16-07-2012 / 21:41:03 / cg"
    "Modified: / 24-06-2014 / 16:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod:aStringOrStream in:aClass 
    ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings

    "parse a method in a given class. Return a parser (instance of myself).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc."

    | parser |

    parser := self for:aStringOrStream in:aClass.
    parser ignoreErrors:ignoreErrors.
    parser ignoreWarnings:ignoreWarnings.
    ParseError handle:[:ex |
        ignoreErrors ifTrue:[^ parser].
        ex reject.
    ] do:[    
        parser nextToken.
        parser function.
    ].    
    ^ parser

    "Created: / 23-07-2017 / 13:40:32 / cg"
    "Modified: / 31-08-2018 / 12:49:35 / Claus Gittinger"
!

parseMethodArgAndVarSpecificationSilent:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.
    parser ignoreErrors:true.
    tree := parser function.
    ^ parser
!

parseMethodSilent:aString
    "parse a method.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors etc.
     Like #parseMethod:, but warning/error messages are suppressed."

    ^ self parseMethodSilent:aString in:nil

    "Created: / 30-01-2011 / 16:15:31 / cg"
!

parseMethodSilent:aStringOrStream in:aClass
    | parser |

    Error handle:[:ex |
        ^ nil
    ] do:[
        Warning ignoreIn:[
            parser := self parseMethod: aStringOrStream in: aClass
        ].
    ].
    ^ parser

    "Modified: / 24-06-2014 / 16:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethodSpecificationSilent:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.

    tree := parser function.
    ^ parser
!

parseStatementBlockBody:aStringOrStream
    |parser tree|

    parser := self for:aStringOrStream.
    parser nextToken.

    tree := parser statementBlockBody.
    ^ tree

    "
     self
        parseStatementBlockBody:'1+2'
    "

    "
     self
        parseStatementBlockBody:'var a; a'
    "

    "
    Class nameSpaceQuerySignal
    answer:JavaScriptEnvironment
    do:[
     self
        parseStatementBlockBody:'Math.PI'
    ]
    "

    "Created: / 16.5.1998 / 18:18:31 / cg"
    "Modified: / 17.5.1998 / 00:17:38 / cg"
!

xx_parseMethodSpecification:aStringOrStream in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    |parser functionName|

    parser := self for:aStringOrStream.
    parser nextToken.

    functionName := parser functionName.    
    parser functionBodyFor:functionName asInnerFunction:false withStatements:false.
    parser selector:functionName.
    ^ parser
! !

!JavaScriptParser class methodsFor:'selector translation'!

commonTranslatedSelectorFor:jsSelector
    "common translation (both JS-in-ST and JS-in-HTML).
     Given a javascript operator or function name,
     translate it into a corresponding smalltalk selector for a message send"

    jsSelector == #'!!=' ifTrue:[
        ^ #'~='
    ].
    jsSelector == #'==' ifTrue:[
        ^ #'='
    ].
    jsSelector == #'!!==' ifTrue:[
        ^ #'~~'
    ].
    jsSelector == #'===' ifTrue:[
        ^ #'=='
    ].

    jsSelector == #'%' ifTrue:[
        ^ #'\\'
    ].

    jsSelector == #'^' ifTrue:[
        ^ #'bitXor:'
    ].
    jsSelector == #'&' ifTrue:[
        ^ #bitAnd:
    ].
    jsSelector == #'|' ifTrue:[
        ^ #bitOr:
    ].

    jsSelector == #'<<' ifTrue:[
        ^ #bitShift:
    ].
    jsSelector == #'>>>' ifTrue:[
        ^ #rightShift:
        "/ ^ #unsignedRightShift:
    ].
    jsSelector == #'>>' ifTrue:[
        ^ #rightShift:
    ].
    jsSelector == #'+' ifTrue:[
        ^ #js_add:
    ].
    jsSelector == #'new' ifTrue:[
        ^ #js_new
    ].
    jsSelector == #'new:' ifTrue:[
        ^ #js_new:
    ].
    jsSelector == #getSeconds ifTrue:[
        ^ #js_getSeconds
    ].
    jsSelector == #map ifTrue:[
        ^ #js_map:
    ].
    jsSelector == #length ifTrue:[
        ^ #js_length
    ].
    jsSelector == #not ifTrue:[
        ^ #js_not
    ].
    jsSelector == #concat ifTrue:[
        ^ #js_concat
    ].
    ^ jsSelector

    "Modified: / 08-08-2006 / 11:04:45 / cg"
!

reverseCommonTranslatedSelectorFor:smalltalkSelector
    "reverse translation.
     Given a smalltalk selector, return a corresponding JavaScript
     operator or function name.
     Used by the document generator only"

    |operatorPrefix|

    operatorPrefix := 'operator'.

    smalltalkSelector == #'~=' ifTrue:[
        ^ operatorPrefix , #'!!='
    ].
    smalltalkSelector == #'=' ifTrue:[
        ^ operatorPrefix , #'=='
    ].
    smalltalkSelector == #'~~' ifTrue:[
        ^ operatorPrefix , #'!!=='
    ].
    smalltalkSelector == #'==' ifTrue:[
        ^ operatorPrefix , #'==='
    ].

    smalltalkSelector == #'\\' ifTrue:[
        ^ operatorPrefix , #'%'
    ].

    smalltalkSelector == #'bitXor:' ifTrue:[
        ^ operatorPrefix , #'^'
    ].
    smalltalkSelector == #bitAnd: ifTrue:[
        ^ operatorPrefix , #'&'
    ].
    smalltalkSelector == #bitOr: ifTrue:[
        ^ operatorPrefix , #'|'
    ].

    smalltalkSelector == #bitShift: ifTrue:[
        ^ operatorPrefix , #'<<'
    ].
    smalltalkSelector == #rightShift: ifTrue:[
        ^ operatorPrefix , #'>>'
        "/ ^ #unsignedRightShift:
    ].
    smalltalkSelector == #js_add: ifTrue:[
        ^ operatorPrefix , #'+'
    ].
    smalltalkSelector == #, ifTrue:[
        ^ operatorPrefix , #'+'
    ].
    smalltalkSelector == #'js_new' ifTrue:[
        ^ #new
    ].
    smalltalkSelector == #'js_new:' ifTrue:[
        ^ #new:
    ].
    smalltalkSelector == #js_getSeconds ifTrue:[
        ^ #getSeconds
    ].
    smalltalkSelector == #'js_map:' ifTrue:[
        ^ #map
    ].
    (smalltalkSelector startsWith: #'js_concat:') ifTrue:[
        ^ #concat
    ].
    smalltalkSelector == #js_length ifTrue:[
        ^ #length
    ].
    smalltalkSelector == #js_not ifTrue:[
        ^ #not
    ].
    ((smalltalkSelector == #js_lastIndexOf:) or:[ smalltalkSelector == #js_lastIndexOf:_: ]) ifTrue:[
        ^ #lastIndexOf
    ].
    ((smalltalkSelector == #js_indexOf:) or:[ smalltalkSelector == #js_indexOf:_: ]) ifTrue:[
        ^ #indexOf
    ].
    ^ smalltalkSelector

    "Modified (comment): / 16-05-2017 / 18:15:45 / mawalch"
!

reverseTranslatedJavaScriptSelectorFor:smalltalkSelector
    "translate javaScript selectors as req'd for compiled JTalk.
     Given a javascript operator or function name,
     translate it into a corresponding smalltalk selector for a message send"

    |xlatedSelector numArgs operatorPrefix|

    numArgs := smalltalkSelector numArgs.
    operatorPrefix := 'operator'.

    (smalltalkSelector isBinarySelector not and:[smalltalkSelector ~~ #'^']) ifTrue:[
        numArgs == 0 ifTrue:[
            ^ self reverseCommonTranslatedSelectorFor:smalltalkSelector.
        ].

        numArgs == 1 ifTrue:[
            smalltalkSelector = '=' ifTrue:[
                ^ #'equals'.
            ].
            smalltalkSelector = '=' ifTrue:[
                ^ operatorPrefix , #'=='.
            ].
            smalltalkSelector = '~=' ifTrue:[
                ^ operatorPrefix , #'!!=='.
            ].
            smalltalkSelector = '==' ifTrue:[
                ^ operatorPrefix , #'==='.
            ].
            smalltalkSelector = '~~' ifTrue:[
                ^ operatorPrefix , #'!!==='.
            ].
            (smalltalkSelector endsWith:$:) ifTrue:[
                ^ (smalltalkSelector copyButLast).
            ].
            xlatedSelector := self reverseCommonTranslatedSelectorFor:smalltalkSelector.
            xlatedSelector = smalltalkSelector ifTrue:[
                ^ operatorPrefix , smalltalkSelector
            ].
            ^ xlatedSelector
        ].

        xlatedSelector := (smalltalkSelector copyReplaceAll:$: with:$_).
        (xlatedSelector endsWith:$_) ifTrue:[
            xlatedSelector := xlatedSelector copyButLast.
        ].
        ^ xlatedSelector.
    ].

    xlatedSelector := self reverseCommonTranslatedSelectorFor:smalltalkSelector.
    xlatedSelector = smalltalkSelector ifTrue:[
        ^ operatorPrefix , smalltalkSelector
    ].
    ^ xlatedSelector

    "
     self reverseTranslatedJavaScriptSelectorFor:#show:    
     self reverseTranslatedJavaScriptSelectorFor:#at:      
     self reverseTranslatedJavaScriptSelectorFor:#at:put:  
     self reverseTranslatedJavaScriptSelectorFor:#+    
     self reverseTranslatedJavaScriptSelectorFor:#-    

    "
!

selectorForFunctionName:name numArgs:n
    "given a javaScript function name,
     return an appropriate valid smalltalk selector.
     This is used when methods are compiled"

    n == 0 ifTrue:[
        ^ name asSymbol
    ].
    ^ (name , (':_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:' copyTo:n*2-1)) asSymbol.

    "Modified: / 17.5.1998 / 00:47:12 / cg"
! !

!JavaScriptParser class methodsFor:'temporary hacks for DWIM'!

parseMethod:aStringOrStream setup:setupBlock onError: onErrorBlock
    |parser tree nodesSoFar|

    parser := self for:aStringOrStream.
    parser ignoreErrors:true.

    setupBlock value:parser.

    parser nextToken.
    ParseError handle:[:ex |
        onErrorBlock value:(ex description) value:ex value:nodesSoFar
    ] do:[
        tree := parser function.
    ].
    ^ tree
! !

!JavaScriptParser methodsFor:'accessing'!

currentNameSpace:aNameSpace
    currentNamespace := aNameSpace.

    "Created: / 26-04-2012 / 12:20:27 / cg"
!

currentNamespace:aNameSpace
    <resource: #obsolete>
    self obsoleteMethodWarning:'use currentNameSpace:'.
    currentNamespace := aNameSpace.

    "Created: / 26-04-2012 / 12:20:27 / cg"
!

interactiveMode:something
    "support for stx-scripting service"

    interactiveMode := something.
!

methodCategory
    ^ methodCategory
!

methodCategory:something
    methodCategory := something.
!

moreSharedPools:aCollection
    moreSharedPools := aCollection
!

selector
    ^ tree functionName asSymbol
!

targetClass
    ^ classToCompileFor
!

targetClass:aClass
    classToCompileFor := aClass.
!

tree
    "return the value of the instance variable 'tree' (automatically generated)"

    errorFlag ifTrue:[^ nil].
    ^ tree
!

tree:something
    "set the value of the instance variable 'tree' (automatically generated)"

    tree := something.
! !

!JavaScriptParser methodsFor:'debugging'!

inspector2TabParseTreeInspector
    (Smalltalk at:#'SmallSense::ParseNodeInspector') ifTrue:[
        ^ Tools::Inspector2Tab new
            label: 'Parse tree';
            priority: 50;
            application: ((Smalltalk at:#'SmallSense::ParseNodeInspector') new
                            node: tree source:source collection)
    ].
    ^ nil

    "Created: / 19-09-2013 / 18:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2Tabs
    ^ super inspector2Tabs , #(inspector2TabParseTreeInspector)

    "Created: / 19-09-2013 / 18:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser methodsFor:'dummy-syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markFunctionNameFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markGlobalIdentifierFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markKeyword:kw from:pos1 to:pos2
    "/ intentionally left blank here
!

markLocalIdentifierFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markSelector:id from:pos1 to:pos2 receiverNode:aReceiverNodeOrNil numArgs:numArgs
    "/ intentionally left blank here
!

markSelfFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markSuperFrom:pos1 to:pos2
    "/ intentionally left blank here
!

markVariable:v
    "/ intentionally left blank here
!

markVariable:v from:pos to:endPos
    "/ intentionally left blank here
! !

!JavaScriptParser methodsFor:'error handling'!

parseError:aMessage position:position to:endPos
    super parseError:aMessage position:position to:endPos.
    ParseError raiseRequestErrorString:aMessage
!

undefError:varName
    |ex doCorrect|

    ex := Parser undefinedVariableNotification newException.
    ex parser:self.
    ex parameter:varName.
    ex suspendedContext:thisContext.
    doCorrect := ex raiseRequest.
    doCorrect notNil ifTrue:[
        ^ doCorrect
    ].
    Transcript showCR:('warning: unknown global: ' , varName).
    "/ self parseError:'unknown global: ' , varName.
    ^ varName

    "Modified: / 12-07-2006 / 15:11:08 / cg"
!

warning:msg
    ^ self notifyWarning:('JavaScript [warning]: ' , msg) position:tokenPosition to:nil
"/    ^ super warning:msg

    "Created: / 17.5.1998 / 20:29:01 / cg"
    "Modified: / 17.5.1998 / 23:38:25 / cg"
! !

!JavaScriptParser methodsFor:'evaluation'!

evaluate:aString in:anEnvironment receiver:someObject notifying:requestor logged:logged ifFail:failBlock
    ^ self
        evaluate:aString
        in:anEnvironment
        receiver:someObject
        notifying:requestor
        logged:logged
        ifFail:failBlock
        compile:(self class ~~ JavaScriptParser) "/ true -- assuming that subclasses can compile

    "Modified: / 22-10-2017 / 10:18:03 / cg"
!

evaluate:aStringOrStream in:anEnvironment receiver:anObject notifying:requestor logged:logged ifFail:failBlock compile:compile
    "return the result of evaluating aStringOrStream, errors are reported to requestor.
     Allow access to anObject as self and to its instVars (used in the inspector).
     If logged is true, an entry is added to the change-file. If the failBlock argument
     is non-nil, it is evaluated if an error occurs.
     Finally, compile specifies if the string should be compiled down to
     bytecode or instead be interpreted from the parseTree.
     The first should be done for doIts etc, where a readable walkback is
     required.
     The latter is better done for constants, styleSheet and resource
     reading and simple sends, where the overhead of compilation is bigger
     than the interpretation overhead."

    |tree mustBackup loggedString value s spc m cls|

    aStringOrStream isNil ifTrue:[
        EmptySourceNotificationSignal raiseRequest.
        ^ nil
    ].

    compile ifTrue:[
        Error handle:[:ex |
        ] do:[
            m := self class
                    compile:('doIt() {',aStringOrStream,'}') 
                    forClass:anObject class
                    inCategory:'* doIts *'
                    notifying:requestor
                    install:false
                    skipIfSame:false 
                    silent:true
                    foldConstants:false.
        ].
        m notNil ifTrue:[
            ^ m
                valueWithReceiver:anObject 
                arguments:#() 
                selector:#doIt
        ].
    ].

    (mustBackup := aStringOrStream isStream) ifTrue:[
        s := aStringOrStream.
    ] ifFalse:[
        loggedString := aStringOrStream.
        s := ReadStream on:aStringOrStream.
    ].
    self initializeFor:s.
    self environment:anEnvironment.
    self isDoIt:true.

"/    self parseForCode.
"/    self foldConstants:nil.
    self setSelf:anObject.
"/    self setContext:aContext.
    (anEnvironment isContext) ifTrue:[
        "/ self setSelf:(anEnvironment receiver).
        anEnvironment method notNil ifTrue:[
            cls := anEnvironment method mclass
        ].
        self setClassToCompileFor:(cls ? anEnvironment receiver class).
    ].

"/    anEnvironment notNil ifTrue:[
"/        self setSelf:(anEnvironment)
"/    ].
    self notifying:requestor.
    self nextToken.
    tree := self parseDeclarationsFor:anEnvironment. "/ statementBlockBody.

    "if reading from a stream, backup for next expression"
    mustBackup ifTrue:[
        self backupPosition
    ].

    ("self errorFlag or:["tree == #Error"]") ifTrue:[
        failBlock notNil ifTrue:[
            ^ failBlock value
        ].
        ^ #Error
    ].

    tree isNil ifTrue:[
        EmptySourceNotificationSignal raiseRequest.
        ^ nil
    ].

"/ no, javaScript stuff is not logged in the changes file.
"/
"/    (logged
"/    and:[loggedString notNil
"/    and:[Smalltalk logDoits]]) ifTrue:[
"/        Class updateChangeFileQuerySignal raise ifTrue:[
"/            chgStream := Class changesStream.
"/            chgStream notNil ifTrue:[
"/                chgStream nextChunkPut:loggedString.
"/                chgStream cr.
"/                chgStream close
"/            ]
"/        ].
"/    ].
"/

    (requestor respondsTo:#currentNameSpace) ifTrue:[
        spc := requestor currentNameSpace
    ] ifFalse:[
        spc := Class nameSpaceQuerySignal query.
    ].

    Class nameSpaceQuerySignal answer:spc
    do:[
        |method|

"/        self evalExitBlock:[:value | self release. ^ value].
        value := tree evaluateIn:anEnvironment.
"/        self evalExitBlock:nil.
    ].
    self release.
    ^ value

    "Modified: / 19-05-2010 / 12:48:17 / cg"
!

evaluateDeclarationFor:anEnvironment
    "this is used with the scripting interpreter, where an existing environment
     is used and manipulated (i.e. declared variables are persistent across evaluations).
     Reads a single decl; for function decls, declare them; 
     for statements & expressions, evaluate them."

    |f tree lastValue prevCon|

    tokenType isNil ifTrue:[ self nextToken ].
    tokenType == #EOF ifTrue:[^ nil].

    "/ declarations may either be immediate-expressions
    "/ or function declarations.

    prevCon := currentEnvironment.
    currentEnvironment := anEnvironment.

    tokenType == #function ifTrue:[
        f := self function.
        anEnvironment _defineFunction:f as:(self translatedJSSelectorFor:(f functionName asSymbol) numArgs:(f numArgs)).
        lastValue := f.
    ] ifFalse:[
        tree := self statementWithSemi:interactiveMode not. "/ BlockBodyFor:currentEnvironment.
        tree notNil ifTrue:[
            "/ Transcript showCR:tree.
            lastValue := tree evaluateIn:anEnvironment.
        ]
    ].

    currentEnvironment := prevCon.
    ^ lastValue

    "
     |env val|
     
     env := STXScriptingEnvironment new. 
     val := 
        JavaScriptParser new 
            source:'var a; var b = 5; a = 10; a + b;' readStream;
            evaluateDeclarationsFor:env.
     self assert:(val == 15).
     self assert:(env _localVariables at:#'a') value == 10.
     self assert:(env _localVariables at:#'b') value == 5.
    "
    
    "Created: / 17-05-1998 / 21:09:36 / cg"
    "Modified: / 06-12-2011 / 01:17:03 / cg"
!

evaluateDeclarationsFor:anEnvironment
    "read; for function decls, declare them; for statements & expressions,
     evaluate them.
     Returns the value of the last expression"

    |lastValue|

    "/ declarations may either be immediate-expressions
    "/ or function declarations.

    [tokenType ~~ #EOF] whileTrue:[
        lastValue := self evaluateDeclarationFor:anEnvironment.
    ].
    ^ lastValue

    "Modified: / 17.5.1998 / 20:40:42 / cg"
    "Created: / 17.5.1998 / 21:09:36 / cg"
! !

!JavaScriptParser methodsFor:'helpers'!

commonTranslatedSelectorFor:jsSelector
    "common translation (both JS-in-ST and JS-in-HTML).
     Given a javascript operator or function name,
     translate it into a corresponding smalltalk selector for a message send"

    jsSelector == #'!!=' ifTrue:[
        ^ #'~='
    ].
    jsSelector == #'==' ifTrue:[
        ^ #'='
    ].
    jsSelector == #'!!==' ifTrue:[
        ^ #'~~'
    ].
    jsSelector == #'===' ifTrue:[
        ^ #'=='
    ].

    jsSelector == #'%' ifTrue:[
        ^ #'\\'
    ].

    jsSelector == #'^' ifTrue:[
        ^ #'bitXor:'
    ].
    jsSelector == #'&' ifTrue:[
        ^ #bitAnd:
    ].
    jsSelector == #'|' ifTrue:[
        ^ #bitOr:
    ].

    jsSelector == #'<<' ifTrue:[
        ^ #bitShift:
    ].
    jsSelector == #'>>>' ifTrue:[
        ^ #rightShift:
        "/ ^ #unsignedRightShift:
    ].
    jsSelector == #'>>' ifTrue:[
        ^ #rightShift:
    ].
    jsSelector == #'+' ifTrue:[
        ^ #js_add:
    ].
    jsSelector == #'new' ifTrue:[
        ^ #js_new
    ].
    jsSelector == #'new:' ifTrue:[
        ^ #js_new:
    ].
    jsSelector == #getSeconds ifTrue:[
        ^ #js_getSeconds
    ].
    jsSelector == #map ifTrue:[
        ^ #js_map:
    ].
    jsSelector == #length ifTrue:[
        ^ #js_length
    ].
    jsSelector == #not ifTrue:[
        ^ #js_not
    ].
    jsSelector == #concat ifTrue:[
        ^ #js_concat
    ].
    jsSelector == #split ifTrue:[
        ^ #js_split:
    ].
    ^ jsSelector

    "Modified: / 08-08-2006 / 11:04:45 / cg"
    "Modified: / 03-07-2018 / 09:48:08 / Claus Gittinger"
!

currentNameSpace
    |spc|

    spc := currentNamespace.
    spc isNil ifTrue:[
        (requestor respondsTo:#currentNameSpace) ifTrue:[
            spc := requestor currentNameSpace
        ] ifFalse:[
            spc := Class nameSpaceQuerySignal query.
        ].
        currentNamespace := spc.
    ].
    ^ spc

    "Created: / 16.5.1998 / 17:16:58 / cg"
    "Modified: / 16.5.1998 / 17:17:09 / cg"
!

expect:expected
    tokenType == expected ifFalse:[
        self parseError:'''' , expected printString , ''' expected (i.e. ''' , tokenType printString allBold , ''' unexpected)'.
    ].
    self nextToken.

    "Created: / 26.10.1998 / 14:52:58 / cg"
!

expectKeyword:expected
    |pos1 pos2|

    pos1 := tokenPosition.
    pos2 := tokenPosition + tokenName size - 1.
    tokenType == expected ifFalse:[
        self parseError:'''' , expected printString , ''' expected (i.e. ''' , tokenType printString allBold , ''' unexpected)'.
    ].

    self markKeyword:tokenType from:pos1 to:pos2.
    self nextToken.

    "Created: / 26.10.1998 / 14:52:58 / cg"
!

findNameSpaceWith:aVariableName
    |currentSpace|

"/    "/ private names have already been searched for.
"/
"/    classToCompileFor notNil ifTrue:[
"/        "/ Q:
"/        "/ consider private classes of superclasses.
"/        "/ or search in the top owing classes namespace only ?
"/
"/        "/ for now, ignore other private classes - they are only
"/        "/ known to the corresponding ownerClass.
"/
"/        "is it in the classes namespace ?"
"/
"/        classToCompileFor isPrivate ifTrue:[
"/            ns := classToCompileFor topOwningClass nameSpace
"/        ] ifFalse:[
"/            ns := classToCompileFor nameSpace.
"/        ].
"/
"/        (ns notNil
"/        and:[ns ~~ Smalltalk]) ifTrue:[
"/            (ns privateClassesAt:aVariableName) notNil ifTrue:[
"/                ^ ns
"/            ]
"/        ].
"/
"/"/        ns := classToCompileFor nameSpace.
"/"/        ns notNil ifTrue:[
"/"/            "is it in the current classes namespace ?"
"/"/            (ns at:aVariableName asSymbol) notNil ifTrue:[
"/"/                ^ ns
"/"/            ]
"/"/        ].
"/    ].

    "is it in the current namespace ?"
    currentSpace := self currentNameSpace.
    (currentSpace notNil
    and:[currentSpace ~~ Smalltalk]) ifTrue:[
        (currentSpace privateClassesAt:aVariableName) notNil ifTrue:[
            ^ currentSpace
        ]
    ].

"/    "is it in one of the used namespaces ?"
"/    usedSpaces := self currentUsedNameSpaces.
"/    usedSpaces notNil ifTrue:[
"/        usedSpaces do:[:aNameSpace |
"/            (aNameSpace privateClassesAt:aVariableName) notNil ifTrue:[
"/                ^ aNameSpace
"/            ]
"/        ]
"/    ].
    ^ nil

    "Created: / 19.12.1996 / 23:51:02 / cg"
    "Modified: / 16.5.1998 / 17:16:28 / cg"
!

ifRequiredTranslateSelectorIn:aNode
    |topEnvironment translatedSelector numArgs jsSelector|

    numArgs := aNode numArgs.
    jsSelector := aNode selector.
    
    topEnvironment := self topEnvironment.
    (topEnvironment notNil 
    and:[topEnvironment isContext not
    and:[topEnvironment _isHTMLEnvironment]]) ifTrue:[
        "/ we are compiling a javaScript-script in a browser.
        "/ (i.e. not JTalk-code)
        "/ In HTML, translate selectors.
        translatedSelector := self translatedJSSelectorFor:jsSelector numArgs:numArgs.
    ] ifFalse:[
        translatedSelector := self translatedSmalltalkSelectorFor:jsSelector numArgs:numArgs.
    ].
    aNode translatedSelector:(translatedSelector asSymbol)
!

isOpAssignSymbol:token
    ^ #(
        #'+='
        #'-='
        #'*='
        #'/='
        #'%='

        #'&='
        #'|='
        #'^='

        #'>>='
        #'<<='
        #'>>>='

      ) includes:token
!

selectorForFunctionName:arg1 numArgs:arg2
    ^ self class selectorForFunctionName:arg1 numArgs:arg2
!

topEnvironment
    topEnvironment isNil ifTrue:[
        currentEnvironment notNil ifTrue:[
            currentEnvironment isContext ifTrue:[
                topEnvironment := currentEnvironment methodHome.
            ] ifFalse:[
                currentEnvironment isJavaScriptClassNode ifFalse:[
                    topEnvironment := currentEnvironment _topEnvironment.
                ].
            ].
        ]
    ].
    ^ topEnvironment
!

translatedJSSelectorFor:selector numArgs:numArgs
    "translate selectors as req'd for HTML-scripts.
     All selectors get a js_ prepended, to avoid conflicts with corresponding
     smalltalk selectors.
     This is especially req'd, as at:/at:put: in JS are 0-based,
     while being 1-based in ST.
     Thus, the translation allows for indexOf: to remain unchanged, and js_indexOf: returns a 0-based index."

    (selector isBinarySelector not
    and:[selector ~~ #'^']) ifFalse:[
        numArgs == 0 ifTrue:[
            ^ ('js_' , selector).
        ].

        numArgs == 1 ifTrue:[
            ^ ('js_' , selector , ':').
        ].

        ^ ('js_' , (selector copyReplaceAll:$_ with:$:) , ':').
    ].

    ^ self commonTranslatedSelectorFor:selector.
!

translatedSmalltalkSelectorFor:jsSelector numArgs:numArgs
    "translate javaScript selectors as req'd for compiled JTalk.
     Given a javascript operator or function name,
     translate it into a corresponding smalltalk selector for a message send"

    |xlatedSelector|

    (jsSelector isBinarySelector not and:[jsSelector ~~ #'^']) ifTrue:[
        numArgs == 0 ifTrue:[
            ^ self commonTranslatedSelectorFor:jsSelector.
        ].

        numArgs == 1 ifTrue:[
            (untranslatedJavaScriptSelectors1 notNil and:[untranslatedJavaScriptSelectors1 includes:jsSelector]) ifFalse:[
                #(
                    'equals'        #'='
                    '=='            #'='
                    '!!=='           #'~='
                    '==='           #'=='
                    '!!==='          #'~~'
                    'concat'        #'js_concat:'
                    'indexOf'       #'js_indexOf:'
                    'lastIndexOf'   #'js_lastIndexOf:'
                    'split'         #'js_split:'
                ) pairWiseDo:[:jsSel :stSel |
                    jsSelector = jsSel ifTrue:[
                        ^ stSel
                    ].    
                ].
            ].

            ^ (jsSelector , ':').
        ].

        numArgs == 2 ifTrue:[
            (untranslatedJavaScriptSelectors2 notNil and:[untranslatedJavaScriptSelectors2 includes:jsSelector]) ifFalse:[
                #(
                    'indexOf'       #'js_indexOf:_:'
                    'lastIndexOf'   #'js_lastIndexOf:_:'
                ) pairWiseDo:[:jsSel :stSel |
                    jsSelector = jsSel ifTrue:[
                        ^ stSel
                    ].    
                ].
            ].
        ].

        xlatedSelector := ((jsSelector copyReplaceAll:$_ with:$:) , ':').
        [xlatedSelector numArgs < numArgs] whileTrue:[
            xlatedSelector := xlatedSelector , '_:'
        ].

        jsSelector = 'concat' ifTrue:[
            ^ #'js_',xlatedSelector.
        ].
        ^ xlatedSelector.
    ].

    ^ self commonTranslatedSelectorFor:jsSelector.

    "Modified: / 28-06-2010 / 17:37:49 / cg"
    "Modified: / 03-07-2018 / 09:47:05 / Claus Gittinger"
! !

!JavaScriptParser methodsFor:'initialization'!

environment:anEnvironment
    currentEnvironment := anEnvironment

    "Created: / 16.5.1998 / 23:50:13 / cg"
    "Modified: / 16.5.1998 / 23:51:44 / cg"
!

foldConstants:aBoolean
    foldConstants := aBoolean
!

initialize
    super initialize.

    interactiveMode := false.
    foldConstants := false.
    isDoIt := false.
    arraysAreImmutable := ArraysAreImmutable ? true.
    stringsAreImmutable := StringsAreImmutable ? true.
    usesSuper := false.

    alreadyWarnedUndeclaredVariables := Set new.

    "Created: / 14.5.1998 / 19:14:23 / cg"
    "Modified: / 14.5.1998 / 19:16:16 / cg"
!

isDoIt
    ^ isDoIt ? false
!

isDoIt:aBoolean
    isDoIt := aBoolean.
!

parseForCode
!

setClassToCompileFor:aClass
    "set the class to be used for parsing/evaluating"

    classToCompileFor := aClass.
"/    (classToCompileFor ~~ PrevClass) ifTrue:[
"/        PrevClass notNil ifTrue:[
"/            Parser update:PrevClass
"/        ]
"/    ]
!

setSelf:anObject
    selfValue := anObject.
    
    classToCompileFor := anObject class.
"/    (classToCompileFor ~~ PrevClass) ifTrue:[
"/        PrevClass notNil ifTrue:[
"/            Parser update:PrevClass
"/        ]
"/    ]
!

smalltalkCompatibilityMode
    "in smalltalk mode, array indexing is 1-based,
     and conditions must be booleans.
     in non-smalltalk (i.e. javaScript) mode, indexing is 0 based
     and conditions can also be integers (treating 0 as false).
     The default is true (and MUST remain so for expecco)"

    ^ smalltalkCompatibilityMode ? true
!

smalltalkCompatibilityMode:aBoolean
    "in smalltalk mode, array indexing is 1-based,
     and conditions must be booleans.
     in non-smalltalk (i.e. javaScript) mode, indexing is 0 based
     and conditions can also be integers (treating 0 as false).
     The default is true (and MUST remain so for expecco)"

    smalltalkCompatibilityMode := aBoolean
!

untranslatedJavaScriptSelectors1
    ^ untranslatedJavaScriptSelectors1
!

untranslatedJavaScriptSelectors1:something
    untranslatedJavaScriptSelectors1 := something.
!

untranslatedJavaScriptSelectors2
    ^ untranslatedJavaScriptSelectors2
!

untranslatedJavaScriptSelectors2:something
    untranslatedJavaScriptSelectors2 := something.
! !

!JavaScriptParser methodsFor:'parsing'!

argList
    "arg | argList , arg
    "

    |args argIndex var|

    (tokenType == $)) ifTrue:[
        ^ #()
    ].

    args := OrderedCollection new.
    argIndex := 0.

    [true] whileTrue:[
        (tokenType ~= #Identifier) ifTrue:[
            self parseError:'''identifier'' expected.'.
            ^ args.
        ].
        self markArgumentIdentifierFrom:tokenPosition to:(tokenPosition+tokenName size-1).

        argIndex := argIndex + 1.
        "/ var := JavaScriptVariableNode type:#MethodArg name:(tokenName asSymbol) token:(Variable name:(tokenName asSymbol)) index:argIndex.
        "/ args at:(tokenName asSymbol) put:var.
        var := JavaScriptVariable type:#MethodArg name:(tokenName asSymbol) index:argIndex.
        args add:var.

        self nextToken.

        tokenType == $) ifTrue:[
            ^ args asArray
        ].
        tokenType == $, ifFalse:[
            self parseError:''','' or '')'' expected.'.
            ^ nil
        ].
        self nextToken.
    ].

    "Created: / 14.5.1998 / 21:14:12 / cg"
    "Modified: / 17.5.1998 / 00:45:05 / cg"
!

classDefinition
    "public class <name> extends <superName> {
        <varDecls>
     }
    "

    |classNode prevCon pos1 name superClassName|

    prevCon := currentEnvironment.
    currentEnvironment := classNode := JavaScriptClassNode new.
    currentEnvironment _outerEnvironment:prevCon.

    ((tokenType == #Identifier) and:[tokenName = 'public']) ifTrue:[
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
    ].
    tokenType == #function ifTrue:[
        ^ nil
    ].    
    ((tokenType == #Identifier) and:[tokenName = 'class']) ifTrue:[
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
    ].
    (tokenType == #Identifier) ifFalse:[
        self parseError:'''class name identifier'' expected.'.
        ^ nil
    ].
    pos1 := tokenPosition.
    name := self classNameIdentifier.
    self markGlobalIdentifierFrom:pos1 to:(pos1+tokenName size-1).
    classNode className:name.

    ((tokenType == #Identifier) and:[tokenName = 'extends']) ifTrue:[
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
        pos1 := tokenPosition.
        (tokenType == #Identifier) ifFalse:[
            self parseError:'''superclass name identifier'' expected.'.
            ^ nil
        ].
        superClassName := self classNameIdentifier.
        self markGlobalIdentifierFrom:pos1 to:(pos1+tokenName size-1).
    ] ifFalse:[
        pos1 := tokenPosition.
        (tokenType == #Identifier) ifTrue:[
            superClassName := self classNameIdentifier.
            self markGlobalIdentifierFrom:pos1 to:(pos1+tokenName size-1).
        ] ifFalse:[
            tokenType == ${ ifFalse:[
                self parseError:'''superclass name identifier'' or ''{'' expected.'.
                ^ nil
            ].
            superClassName := 'Object'.
        ].
    ].    
    classNode superClassName:superClassName.

    self expect:${.

    [(tokenType == #Identifier and:[tokenName = 'static']) or:[ (tokenType == #var) ]] whileTrue:[
        self varDeclaration.
    ].
    classNode staticVariables:staticVars.
    self expect:$}.

    currentEnvironment := prevCon.
    ^ classNode

    "
     self
        parseClassDefinition:'public class Foo extends Object {}'
    "

    "Modified: / 16-07-2012 / 20:34:11 / cg"
    "Modified: / 27-08-2018 / 18:41:17 / Claus Gittinger"
!

classNameIdentifier
    |name|

    [
        (tokenType == #Identifier) ifFalse:[
            self parseError:'''class name identifier'' expected.'.
            ^ nil
        ].
        name := (name ? '') , tokenName.
        self nextToken.
        tokenType == #'::' ifTrue:[
            name := name , '::'.
            self nextToken.
            true
        ] ifFalse:[
            false
        ].
    ] whileTrue.

    ^ name
!

constDeclaration
    "'const' name [ '=' constExpression ]';'
    "

    ^ self constDeclarationFor:currentEnvironment

    "Created: / 16-08-2017 / 00:16:04 / cg"
!

constDeclarationFor:anEnvironment
    " [ 'static' ] 'const' name ['=' initExpr] ';'
    "

    ^ self constOrVarDeclarationFor:anEnvironment isConst:true

    "Created: / 16-08-2017 / 00:17:18 / cg"
!

constOrVarDeclarationFor:anEnvironment isConst:isConstIn
    " [ 'static' ] ('const'|'var') name ['=' initExpr] ';'
      | 'let' name ['=' initExpr] ';'
    "

    |isConst isStatic isLet var varIndex initValueExpression locals value 
     firstInitializer lastInitializer initializer varNode pos1 pos2 |

    isStatic := isLet := false.
    isConst := isConstIn.

    (tokenType == #Identifier) ifTrue:[
        (token = 'static') ifTrue:[
            isStatic := true.
            self nextToken.
        ].
    ].

    isConst ifTrue:[
        (tokenType == #const) ifFalse:[
            self parseError:'''const'' expected.'.
        ].
    ] ifFalse:[
        (tokenType == #var) ifFalse:[
            (isLet := tokenType == #let) ifFalse:[
                (isStatic and:[tokenType == #const]) ifFalse:[
                    self parseError:'''var'' or ''let'' expected.'.
                ].
                isConst := true.
            ].
        ].
    ].    
    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    self nextToken.

    varIndex := 0.
    anEnvironment notNil ifTrue:[
        locals := anEnvironment _localVariables.
    ].
    
    [true] whileTrue:[
        isConst ifTrue:[
            isStatic ifTrue:[
                var := self declareStaticConstant:tokenName.
            ] ifFalse:[
                var := self declareConstant:tokenName inEnvironment:anEnvironment.
            ].
        ] ifFalse:[
            isStatic ifTrue:[
                var := self declareStaticVariable:tokenName.
            ] ifFalse:[
                var := self declareVariable:tokenName inEnvironment:anEnvironment.
            ].
        ].    
        pos1 := tokenPosition.
        pos2 := tokenPosition + tokenName size - 1.
        self nextToken.

        tokenType == $= ifTrue:[
            self nextToken.
            initValueExpression := self nonCommaExpression.
            var expressionForSetup:initValueExpression.
            ((tokenType == $;) or:[tokenType == $,]) ifFalse:[
                self parseError:'Expected '';'' or '','' after init expression.'.
            ].
            (interactiveMode or:[isDoIt]) ifTrue:[
                "/ perform the assignment
                value := initValueExpression evaluateIn:anEnvironment.
                var value:value.
                locals isEmptyOrNil ifTrue:[
                    anEnvironment _localVariables:(locals := IdentityDictionary new).
                ].
                locals at:var name put:var.
            ] ifFalse:[
                "/ if already in the real statements section, do the assignment here...
                firstInitializer isNil ifTrue:[
                    firstInitializer := lastInitializer := JavaScriptStatementNode new.
                ] ifFalse:[
                    lastInitializer nextStatement: JavaScriptStatementNode new.
                    lastInitializer := lastInitializer nextStatement.
                ].
                (anEnvironment notNil and:[anEnvironment isInnerFunction]) ifTrue:[
                    varNode := JavaScriptVariableNode
                                    type:#BlockVariable
                                    name:var name
                                    token:var
                                    index:var index
                                    block:anEnvironment 
                                    from:anEnvironment    
                ] ifFalse:[
                    (anEnvironment notNil and:[anEnvironment isJavaScriptClassNode]) ifTrue:[
                        varNode := JavaScriptVariableNode 
                                        type:(isStatic ifTrue:[#ClassVariable] ifFalse:[#InstanceVariable])
                                        name:var name
                                        token:var
                                        index:nil.
                    ] ifFalse:[
                        varNode := JavaScriptVariableNode 
                                        type:#MethodVariable
                                        name:var name
                                        token:var
                                        index:var index.
                    ].
                ].
                varNode startPosition: pos1 endPosition: pos2.
                lastInitializer expression:(initializer := (JavaScriptAssignmentNode variable:varNode expression:initValueExpression) parent: lastInitializer).
                anEnvironment isNil ifTrue:[
                ] ifFalse:[
                    anEnvironment isJavaScriptClassNode ifFalse:[
                        var expressionForSetup:nil.
                    ].
                ].
            ].
        ].

        tokenType == $; ifTrue:[
            interactiveMode ifTrue:[
                tokenType := token := nil. "/ so we will read the next token
                ^ initValueExpression
            ].
            self nextToken.
            ^ firstInitializer
        ].
        tokenType == $, ifFalse:[
            self parseError:''','' or '';'' expected.'.
            ^ nil
        ].
        tokenType == #EOF ifTrue:[^ self].
        self nextToken.
    ].
    "/ not reached

    "Created: / 16-08-2017 / 00:18:49 / cg"
!

declareConstant:varName inEnvironment:anEnvironment
    ^ self declareVariable:varName inEnvironment:anEnvironment isConstant:true

    "Created: / 16-08-2017 / 00:20:37 / cg"
!

declareStaticConstant:varName
    " name (not eaten)
    "

    ^ self declareStaticVariable:varName isConstant:true

    "Created: / 16-08-2017 / 00:20:03 / cg"
!

declareStaticVariable:varName
    " name (not eaten)
    "

    ^ self declareStaticVariable:varName isConstant:false

    "Modified: / 16-08-2017 / 00:19:57 / cg"
!

declareStaticVariable:varName isConstant:isConstant
    " name (not eaten)
    "

    |var namePrefix|

    namePrefix := ''.
    currentEnvironment notNil ifTrue:[       
        currentEnvironment _isFunctionEnvironment ifTrue:[
            namePrefix := currentEnvironment functionName , '_'.
        ].
    ].

    self markGlobalIdentifierFrom:tokenPosition to:(tokenPosition+tokenName size-1).
    var := JavaScriptVariable type:#ClassVariable name:(namePrefix,varName) asSymbol.
    staticVars isNil ifTrue:[
        staticVars := Dictionary new.
    ].
    staticVars at:(varName asSymbol) put:var.

    ^ var.

    "Created: / 16-08-2017 / 00:19:44 / cg"
!

declareVariable:varName inEnvironment:anEnvironment
    ^ self declareVariable:varName inEnvironment:anEnvironment isConstant:false

    "Modified: / 16-08-2017 / 00:20:31 / cg"
!

declareVariable:varName inEnvironment:anEnvironment isConstant:isConstant
    "caveat: isConstant is currently ignored"

    |var varIndex locals|

    (tokenType == #Identifier) ifFalse:[
        self parseError:'''identifier'' expected.'.
        ^ nil.
    ].

    anEnvironment notNil ifTrue:[
        locals := anEnvironment _localVariables.
    ].
    locals isNil ifTrue:[
        locals := IdentityDictionary new.    
        anEnvironment notNil ifTrue:[
            anEnvironment _localVariables:locals
        ].    
    ].
    (locals includesKey:(varName asSymbol)) ifTrue:[
        self parseError:'redeclaration of ' , varName.
    ].

    self markLocalIdentifierFrom:tokenPosition to:(tokenPosition+varName size-1).
    varIndex := locals size + 1.
    (anEnvironment notNil and:[anEnvironment isInnerFunction]) ifTrue:[
        var := JavaScriptVariable type:#BlockVariable name:(varName asSymbol) index:varIndex.
    ] ifFalse:[
        var := JavaScriptVariable type:#MethodVariable name:(varName asSymbol) index:varIndex.
    ].
    locals at:(varName asSymbol) put:var.

    ^ var.

    "Created: / 16-08-2017 / 00:20:16 / cg"
    "Modified (format): / 30-08-2018 / 13:14:59 / Claus Gittinger"
!

function
    "function(args) stats ;
    "

    ^ self function:true

    "Modified: / 19-09-2013 / 17:56:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

function:readOverClosingBrace
    "function(args) stats ;
    "

    | functionName start end |

    start := tokenPosition.
    functionName := self functionName.    
    tree := self functionBodyFor:functionName asInnerFunction:false.
    readOverClosingBrace ifTrue:[
        self nextToken.
    ].
    end := tokenLastEndPosition - 1.
    tree startPosition:start endPosition: end.
    ^ tree

    "Modified: / 19-09-2013 / 17:56:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

functionBodyFor:functionNameOrNil asInnerFunction:asInnerFunction
    " (args) stats ;
    "

    |func|

    func := self functionBodyFor:functionNameOrNil asInnerFunction:asInnerFunction withStatements:true.
    asInnerFunction ifTrue:[
        self nextToken.
    ].
    ^ func
!

functionBodyFor:functionNameOrNil asInnerFunction:asInnerFunction withStatements:withStatements
    " (args) stats ;
    "

    |functionNode prevCon |

    self topEnvironment. "/ To ensure topEnvironment is initialized.
    prevCon := currentEnvironment.
    asInnerFunction ifTrue:[
        functionNode := JavaScriptInnerFunctionNode new.
    ] ifFalse:[
        functionNode := JavaScriptFunctionNode new.
    ].
    functionNode _outerEnvironment:currentEnvironment.
    functionNode functionName:functionNameOrNil.

    currentEnvironment := functionNode.
    "/ If there's no top environment, then set function as top-level environment

    topEnvironment isNil ifTrue:[
         topEnvironment := functionNode 
    ].
    currentEnvironment _outerEnvironment:prevCon.

    tokenType == $( ifFalse:[
        self parseError:'''('' expected after function keyword (i.e. ''' , tokenType printString allBold , ''' unexpected)'.
    ].
    self nextToken.

    functionNode arguments:self argList.

    self expect:$).
    gotAnyRealStatement := false.

    withStatements ifTrue:[
        functionNode statements:(self statementBlock:false).
    ].
    currentEnvironment := prevCon.
    ^ functionNode

    "Modified (comment): / 24-09-2013 / 15:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2017 / 15:42:30 / cg"
!

functionName
    "function name(args) stats ;
     | function className.name(args) stats ;
     | function className.class.name(args) stats ;   
    "

    |functionName className cls pos1|

"/    tokenType == #public ifTrue:[
"/        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
"/        self nextToken.
"/    ].

    tokenType == #function ifTrue:[
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
    ].

    tokenType == #Identifier ifFalse:[
        self parseError:'function name expected.'.
        ^ nil
    ].
    functionName := tokenName.
    pos1 := tokenPosition.
    self nextToken.
    (token == $.) ifTrue:[
        className := functionName.
        (cls := Smalltalk classNamed:className) isNil ifTrue:[
            self parseError:'no such class: ',className.
        ].
        classToCompileFor notNil ifTrue:[
            self parseError:'only functions for ',classToCompileFor name,' allowed'
        ].
        classToCompileFor := cls.
        self nextToken.
        token = 'class' ifTrue:[
            self nextToken.
            classToCompileFor := classToCompileFor theMetaclass.
            self expect:$..
        ].
        tokenType == #Identifier ifFalse:[
            self parseError:'function name expected.'.
            ^ nil
        ].
        functionName := tokenName.    
        self nextToken.
    ].    
    self markFunctionNameFrom:pos1 to:(tokenPosition+tokenName size-1).
    ^ functionName

    "
     self
        parseFunction:'function foo(a, b, c) {}'
    "

    "
     self
        parseFunction:'function Math.class.foo(a, b, c) {}'
    "

    "
     self
        parseFunction:'function foo(a, b, c) {
            if (a > 1) {
                return a;
            } else {
                return b;
            }
        }'
    "

    "
     self
        parseFunction:'function bar(a, b, c) {
            var sum;

            while (a > 1) {
                sum += a;
                a--;
            }
            return sum;
        }'
    "

    "Modified: / 26.10.1998 / 14:59:56 / cg"
!

functionOrStaticFunction:readFinalBrace
    "]static] function(args) stats ;
    "

    ((tokenType == #Identifier) and:[tokenName = 'static']) ifTrue:[
        classToCompileFor notNil ifTrue:[ classToCompileFor := classToCompileFor theMetaclass ].
        self nextToken.
    ].
    ^ self function:readFinalBrace
!

lambdaFunctionBodyWithArguments:argList
    " 
        { stats }
        | expr
    "

    |hasBrace functionNode prevCon expr retNode|

    self topEnvironment. "/ To ensure topEnvironment is initialized.
    prevCon := currentEnvironment.
    functionNode := JavaScriptInnerFunctionNode new.
    functionNode _outerEnvironment:currentEnvironment.

    currentEnvironment := functionNode.
    "/ If there's no top environment, then set function as top-level environment

    topEnvironment isNil ifTrue:[
         topEnvironment := functionNode 
    ].
    currentEnvironment _outerEnvironment:prevCon.

    functionNode arguments:argList.

    gotAnyRealStatement := false.

    (hasBrace := tokenType == ${) ifTrue:[
        functionNode statements:(self statementBlock:false).
        functionNode endPosition:tokenPosition.
        self nextToken. "/ the final brace
    ] ifFalse:[
        expr := self expression.
        retNode := JavaScriptReturnNode expression:expr.
        retNode startPosition:expr startPosition.
        retNode endPosition: expr endPosition.
        "/ retNode home:self blockHome:currentBlock.
        retNode lineNumber:expr lineNumber.
        "/ self checkPlausibilityOf:retNode from:expr startPosition to:expr endPosition.
        "/ self rememberReturnedValue:expr.
        functionNode statements:retNode.
        functionNode endPosition:expr endPosition.
    ].
    
    currentEnvironment := prevCon.
    ^ functionNode

    "Modified (comment): / 27-08-2018 / 18:32:31 / Claus Gittinger"
!

needSemi
    " ;
    "

    self expect:$;.

    "Created: / 14.5.1998 / 21:03:59 / cg"
    "Modified: / 26.10.1998 / 15:00:26 / cg"
!

parseDeclarationsFor:anEnvironment
    "read; for function decls, declare them; for statements & expressions,
     parse (but do not evaluate) them."

    |f lastValue prevCon func|

    "/ declarations may either be immediate-expressions
    "/ or function declarations.

    prevCon := currentEnvironment.
    currentEnvironment := anEnvironment.

    [(tokenType ~~ #EOF) and:[tokenType ~~ $} ]] whileTrue:[
        tokenType == #function ifTrue:[
            self nextToken.
            tokenType == #Identifier ifTrue:[
                f := self function.
                anEnvironment notNil ifTrue:[
                    anEnvironment _defineFunction:f as:(self class selectorForFunctionName:f functionName numArgs:f numArgs).
                ] ifFalse:[
                    "/ define as workspaceVariable
                    Workspace notNil ifTrue:[
                        Workspace workspaceVariableAt:(f functionName) put:f.
                    ].    
                ].    
                lastValue := nil.
            ] ifFalse:[
                func := self functionBodyFor:nil asInnerFunction:true.
                lastValue := func evaluate. "/ gives me a real function from the node
                tokenType == $; ifTrue:[ self nextToken ].
            ].
        ] ifFalse:[
            currentEnvironment := anEnvironment.
            lastValue := self statementBlockBodyFor:currentEnvironment.
        ].
    ].
    currentEnvironment := prevCon.
    ^ lastValue

    "Modified (format): / 22-10-2017 / 10:09:09 / cg"
!

parseExpressionWithSelf:anObject notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings inNameSpace:aNameSpaceOrNil
    "parse aString as an expression with self set to anObject;
     Return the parseTree (if ok), nil (for an empty string 
     or comment only ) or #Error (syntactic error).

     Errors and warnings are forwarded to someOne (usually some
     codeView) which can highlight it and show a popup box,
     iff ignoreErrors/ignoreWarnings is true respectively."

    |tree tok|

    aNameSpaceOrNil notNil ifTrue:[
        currentNamespace := aNameSpaceOrNil
    ].
    self setSelf:anObject.
    self notifying:someOne.
    self ignoreErrors:ignoreErrors.
    self ignoreWarnings:ignoreWarnings.
    tok := self nextToken.
    (tok == #return) ifTrue:[
        self nextToken.
    ].
    (tok == #EOF) ifTrue:[
        ^ nil
    ].
    tree := self expression.
    (errorFlag or:[tree == #Error]) ifTrue:[^ #Error].
    ^ tree

    "Modified: / 20-07-2006 / 11:24:13 / cg"
!

parseMethod
    self nextToken.
    self function
!

parseMethod:theCode in:aClass ignoreErrors:ignoreErrorsArg ignoreWarnings:ignoreWarningsArg
    self source:(theCode readStream).
    classToCompileFor := aClass.
    ignoreErrors := ignoreErrorsArg.
    ignoreWarnings := ignoreWarningsArg.

    self nextToken.
    self function
!

rememberAssignmentTo:var
    |type|

    type := var type.
    type == #InstanceVariable ifTrue:[
        self rememberInstVarModified:var name
    ] ifFalse:[
        type == #MethodVariable ifTrue:[
            self rememberLocalModified:var name
        ] ifFalse:[
            type == #ClassVariable ifTrue:[
                self rememberClassVarModified:var name
            ] ifFalse:[
                type == #GlobalVariable ifTrue:[
                    self rememberGlobalModified:var name
                ] ifFalse:[
"/                        type == #PoolVariable ifTrue:[
"/                            self rememberPoolVarModified:var name
"/                        ].
                ].
            ].
        ].
    ].

    "Modified: / 31-03-2017 / 17:47:54 / stefan"
    "Modified: / 23-07-2017 / 13:46:41 / cg"
!

rememberReadOf:var
    |type|

    type := var type.
    
    type == #InstanceVariable ifTrue:[
        self rememberInstVarRead:var name
    ] ifFalse:[
        type == #MethodVariable ifTrue:[
            self rememberLocalRead:var name
        ] ifFalse:[
            type == #ClassVariable ifTrue:[
                self rememberClassVarRead:var name
            ] ifFalse:[
                type == #GlobalVariable ifTrue:[
                    self rememberGlobalRead:var name
                ] ifFalse:[
"/                        type == #PoolVariable ifTrue:[
"/                            self rememberPoolVarModified:var name
"/                        ].
                ].
            ].
        ].
    ].

    "Created: / 23-07-2017 / 13:46:18 / cg"
!

varDeclaration
    " [ 'static' ] 'var' name ['=' initExpr] ';'
      [ 'static' ] 'const' name ['=' initExpr] ';'
      | 'let' name ['=' initExpr] ';'
    "

    ^ self varDeclarationFor:currentEnvironment

    "Modified (comment): / 16-08-2017 / 00:16:21 / cg"
!

varDeclarationFor:anEnvironment
    " [ 'static' ] 'var' name ['=' initExpr] ';'
      [ 'static' ] 'const' name ['=' initExpr] ';'
      | 'let' name ['=' initExpr] ';'
    "

    ^ self constOrVarDeclarationFor:anEnvironment isConst:false

    "Created: / 14-05-1998 / 21:14:12 / cg"
    "Modified: / 18-10-2013 / 13:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2017 / 13:49:22 / stefan"
    "Modified: / 16-08-2017 / 00:19:25 / cg"
! !

!JavaScriptParser methodsFor:'parsing-expressions'!

addExpression
    "addExpr -> mulExpr addOp mulExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self mulExpression.
    [tokenType == $+
    or:[tokenType == $-]] whileTrue:[
        op := tokenType asString asSymbol.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self mulExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        node isMessage ifTrue:[
            self ifRequiredTranslateSelectorIn:node.
        ].
        expr1 := node.
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:24:22 / cg"
    "Modified: / 14.5.1998 / 19:29:40 / cg"
!

arrayConstant
    "arrayConstant -> Integer-constant
                      | Float-constant
                      | String-constant
                      | true    
                      | false    
                      | null    
                      | arrayLiteral
                      | objectLiteral
    "

    |val const|

    (tokenType == #String) ifTrue:[
        val := tokenValue.
        stringsAreImmutable ifTrue:[ val := Parser makeImmutableString:val].
        self nextToken.
        ^ val
    ].

    ((tokenType == #Integer)
     or:[(tokenType == #Character)
     or:[(tokenType == #Float)
     or:[(tokenType == #true)
     or:[(tokenType == #false)
     or:[(tokenType == #null)
     or:[(tokenType == #Nil)
     ]]]]]]) ifTrue:[
        val := tokenValue.
        self nextToken.
        ^ val
    ].

    tokenType == $[ ifTrue:[
        const := self arrayLiteral.
        ^ const value.
    ].

    tokenType == ${ ifTrue:[
        self nextToken.
        const := self objectLiteral.
        ^ const value.
    ].

    self parseError:'invalid array element'
!

arrayIndexing:expr
    "arrayIndexing -> [...]
    "

    |indexExpressions indexNode lnr|

    tokenType == $[ ifFalse:[ ^ expr ].

    indexExpressions := OrderedCollection new.
    [true] whileTrue:[
        lnr := tokenLineNr.
        self nextToken.
        indexExpressions add:(self nonCommaExpression).
        tokenType == $, ifFalse:[
            self expect:$].
            indexNode := ArrayAccessNode new array:expr indices:indexExpressions.
            indexNode startPosition: expr startPosition endPosition: tokenPosition.
            indexNode lineNumber:lnr.
            ^ indexNode
        ]
    ].
    "/ not reached

    "Created: / 15-05-1998 / 14:04:27 / cg"
    "Modified: / 27-07-2013 / 17:23:14 / cg"
    "Modified: / 20-09-2013 / 14:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

arrayIndexingExpression:recIn
    "arrayIndexingExpression -> variableOrFunctionExpression
                                | variableOrFunctionExpression[ indexExpr ]
    "

    |expr|

    expr := self functionCallExpression:recIn.
    ^ self arrayIndexing:expr
!

arrayIndexingExpressionList:exprIn
    "arrayIndexingExpressionList -> 
                                .identifier(...)
                               | [ array-expr ] 
    "

    |expr|

    expr := exprIn.
    [tokenType == $. or:[tokenType == $[ ]] whileTrue:[
        tokenType == $[  ifTrue:[
            expr := self arrayIndexing:expr
        ] ifFalse:[
            self nextToken.
            expr := self arrayIndexingExpression:expr.
        ].
    ].
    ^ expr
!

arrayLiteral
    "arrayLiteral -> [ literalConstant { , literalConstant } ] ']'
     initial opening bracket has NOT been read.
    "

    |elements elExpr arr pos1 pos2 anyNonConstant|

    pos1 := tokenPosition.
    self nextToken.     "/ skip "["

    anyNonConstant := false.

    elements := OrderedCollection new.
    [ tokenType == $] ] whileFalse:[
        elExpr := self nonCommaExpression.
        elExpr isConstant ifFalse:[ anyNonConstant := true ].
        elements add:elExpr.
        tokenType == $] ifFalse:[
            tokenType == $, ifFalse:[
                self parseError:'"," expected'.
            ].
            self nextToken.
        ].
    ].
    pos2 := tokenPosition.
    self nextToken.

    anyNonConstant ifFalse:[ 
        self markConstantFrom:pos1 to:pos2.

        arr := (elements map:#value) asArray.
        arraysAreImmutable ifTrue:[
            arr := Parser makeImmutableArray:arr
        ].
        ^ (JavaScriptConstantNode type:#Array value:arr)
            startPosition: pos1 endPosition: pos2;
            yourself.
    ].

    "/ generate an array dynamically
    ^ Parser genMakeArrayWith:elements

    "Modified: / 20-09-2013 / 15:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bitAndExpression
    "bitAndExpression -> equalityExpr & equalityExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self equalityExpression.
    [tokenType == $&] whileTrue:[
        op := tokenType asString asSymbol.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self equalityExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:#'&' arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        expr1 := node.
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:20:11 / cg"
    "Modified: / 14.5.1998 / 19:29:53 / cg"
!

bitOrExpression
    "bitOrExpression -> bitXorExpr | bitXorExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self bitXorExpression.
    [tokenType == $|] whileTrue:[
        op := tokenType asString asSymbol.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self bitXorExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:#'|' arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        expr1 := node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:19:33 / cg"
    "Modified: / 14.5.1998 / 19:29:56 / cg"
!

bitShiftExpression
    "conditionalExpr -> addExpr shiftOp addExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self addExpression.
    [tokenType == #'<<'
    or:[tokenType == #'>>'
    or:[tokenType == #'>>>']]] whileTrue:[
        lnr := tokenLineNr.

        op := tokenType.

        self nextToken.
        expr2 := self addExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        expr1 := node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:23:56 / cg"
    "Modified: / 14.5.1998 / 19:45:19 / cg"
!

bitXorExpression
    "bitXorExpression -> bitAndExpr ^ bitAndExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self bitAndExpression.
    [tokenType == $^] whileTrue:[
        op := tokenType asString asSymbol.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self bitAndExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:#'^' arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        expr1 := node
    ].

    ^ expr1.
!

booleanAndExpression
    "booleanAndExpression -> bitOrExpr && bitOrExpr
    "

    |expr1 expr2 node lnr|

    expr1 := self bitOrExpression.
    (tokenType == #'&&') ifTrue:[
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self booleanAndExpression.
        node := AndExpressionNode new expression1:expr1 expression2:expr2.

        node lineNumber:lnr.
        expr1 := node
    ].

    ^ expr1.
!

booleanOrExpression
    "booleanAndExpression -> bitOrExpr || bitOrExpr
    "

    |expr1 expr2 node lnr|

    expr1 := self booleanAndExpression.
    (tokenType == #'||') ifTrue:[
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self booleanOrExpression.

        node := OrExpressionNode new expression1:expr1 expression2:expr2.

        node lineNumber:lnr.
        expr1 := node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:19:07 / cg"
    "Modified: / 14.5.1998 / 20:22:54 / cg"
!

commaExpression
    "commaExpression -> conditionalExpression [, commaExpression ]
    "

    |expr|

    expr := self nonCommaExpression.
    noComma ~~ true ifTrue:[
        [tokenType == $,] whileTrue:[
            self nextToken.
            expr := CommaExpression left:expr right:self nonCommaExpression.
        ].
    ].
    ^ expr.
!

compareExpr
    "compareExpr -> bitShiftExpr relOp bitShiftExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self bitShiftExpression.
    (tokenType == $<
    or:[tokenType == #'<='
    or:[tokenType == $>
    or:[tokenType == #'>=']]]) ifTrue:[
        lnr := tokenLineNr.
        op := tokenType asSymbol.

        self nextToken.
        expr2 := self bitShiftExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        ^ node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:26:01 / cg"
    "Modified: / 14.5.1998 / 20:09:50 / cg"
!

compoundExpression
    ^ self expression

    "Created: / 14.5.1998 / 21:06:06 / cg"
!

conditionalExpression
    "conditionalExpr -> boolOrExpr ? boolOrExpr
    "

    |expr1 expr2 expr3 node lnr|

    expr1 := self booleanOrExpression.
    (tokenType == $?) ifTrue:[
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self booleanOrExpression.
        (tokenType == $:) ifFalse:[
             self parseError:''':'' expected (in ?-expression)'.
        ].
        self nextToken.
        expr3 := self booleanOrExpression.

        node := ConditionalNode new condition:expr1 expression1:expr2 expression2:expr3.
        node lineNumber:lnr.
        ^ node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 19:12:51 / cg"
    "Modified: / 17.5.1998 / 21:04:00 / cg"
!

constantExpression
    |expr|

    expr := self nonCommaExpression.
    expr isConstant ifFalse:[
        self parseError:'constant expected'.
    ].
    ^ expr
!

equalityExpression
    "equalityExpression -> compareExpr relOp compareExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self compareExpr.
    ((tokenType == #'==')
    or:[tokenType == #'!!='
    or:[tokenType == #'==='
    or:[tokenType == #'!!==']]]) ifTrue:[
        lnr := tokenLineNr.

        op := tokenType.
        self nextToken.
        expr2 := self compareExpr.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node lineNumber:lnr.
        self ifRequiredTranslateSelectorIn:node.
        ^ node
    ].

    ^ expr1.

    "Created: / 14.5.1998 / 16:20:50 / cg"
    "Modified: / 14.5.1998 / 20:11:51 / cg"
!

expression
    "expression -> commaExpression
    "

    ^ self commaExpression.
!

expressionList
    "expression | expressionList , expression
    "

    |expressions|

    (tokenType == $)) ifTrue:[
        ^ #()
    ].

    expressions := OrderedCollection new.
    [true] whileTrue:[
        expressions add:(self nonCommaExpression).

        tokenType == $) ifTrue:[
            ^ expressions
        ].
        tokenType == $, ifFalse:[
            self parseError:''','' or '')'' expected.'.
            ^ nil
        ].
        self nextToken.
    ].

    "Created: / 15.5.1998 / 14:18:28 / cg"
    "Modified: / 15.5.1998 / 14:20:06 / cg"
!

functionCallExpression
    <resource: #obsolete>
    "OOPS: almost same as primaryExpression - please refactor"

    "primaryExpr ->
                '(' expr ')'
                | constant
                | 'this'
                | variable
                | 'new' class
                | 'new' funcOrClass '(' dim ')'
                | 'function' '(' argList ')'  '{' statements '}'
    "

    |expr val varOrArrayElement node op isString indexExpr
     needSend lnr topEnvironment functionName pos2 |

    tokenType == $( ifTrue:[
        self nextToken.
        expr := self expression.
        tokenType ~~ $) ifTrue:[
            self parseError:''')'' expected'.
        ].
        self nextToken.
        ^ self arrayIndexingExpressionList:expr
    ].

    tokenType == $[ ifTrue:[
        expr := self arrayLiteral.
        ^ self arrayIndexingExpressionList:expr
    ].

    (tokenType == #null) ifTrue:[
        self markConstantFrom:tokenPosition to:tokenPosition+tokenName size-1.
        self nextToken.
        ^ JavaScriptConstantNode type:#Nil value:tokenValue.
    ].

    ((tokenType == #Integer)
     or:[(tokenType == #String)
     or:[(tokenType == #Character)
     or:[(tokenType == #Float)
     or:[(tokenType == #this)
     or:[(tokenType == #true)
     or:[(tokenType == #false)
     or:[(tokenType == #Symbol)]]]]]]]) ifTrue:[
        tokenType == #this ifTrue:[
            val := ThisNode new value:selfValue.
            self markSelfFrom:tokenPosition to:tokenPosition+tokenName size-1.
        ] ifFalse:[
            "/ make it a special string (with additional protocol)
            tokenType == #String ifTrue:[
                stringsAreImmutable ifTrue:[ tokenValue := Parser makeImmutableString:tokenValue].
                isString := true.

                topEnvironment := self topEnvironment.
                (topEnvironment notNil and:[topEnvironment _isHTMLEnvironment]) ifTrue:[
                    "/ make it a JavaScriptString - with its restricted message set.

                    JavaScriptEnvironment autoload.
                    tokenValue := tokenValue copy changeClassTo:JavaScriptEnvironment::String.
                ].
            ] ifFalse:[
                self markConstantFrom:tokenPosition to:tokenPosition+tokenName size-1.
            ].
            val := JavaScriptConstantNode type:tokenType value:tokenValue.
        ].
        self nextToken.
        [ (tokenType == $.) or:[tokenType == $[ ] ] whileTrue:[
            (tokenType == $.) ifTrue:[
                self nextToken.
                val := self arrayIndexingExpression:val.
            ] ifFalse:[
                isString == true ifTrue:[
                    lnr := tokenLineNr.
                    self nextToken.
                    indexExpr := self expression.
                    tokenType == $] ifFalse:[
                        self parseError:''']'' expected'.
                    ].
                    self nextToken.
                    val := (ArrayAccessNode new array:val index:indexExpr) lineNumber:lnr.
                    val startPosition: val startPosition endPosition: tokenLastEndPosition. 
                ]
            ].
        ].
        val isMessage ifTrue:[
            ^ val
        ].

        ((tokenType == $= ) or:[ self isOpAssignSymbol:tokenType]) ifTrue:[
            self parseError:'assignment to a constant'
        ].
        ^ val
    ].

    tokenType == #Identifier ifTrue:[
        "/ new is handled explicitely here, as it is no keyword
        "/ (can also be used as identifier in other context)
        tokenName = 'new' ifTrue:[
            ^ self newExpression.
        ].

        varOrArrayElement := self arrayIndexingExpression:nil.

        varOrArrayElement := self arrayIndexingExpressionList:varOrArrayElement.
"/        varOrArrayElement isMessage ifTrue:[
"/            ^ varOrArrayElement
"/        ].

        tokenType == $= ifTrue:[
            needSend := false.
            pos2 := tokenLastEndPosition.
            self nextToken.
            expr := self expression.

            varOrArrayElement isMessage ifTrue:[
                varOrArrayElement isImplicitJavaScriptMessage ifFalse:[
"/                    self halt.
                    self parseError:'cannot assign to an explicit function call'
                ].
                varOrArrayElement numArgs == 0 ifFalse:[
                    "/ self halt.
                    self parseError:'cannot assign to this function call (yet)'
                ].

                "/ must make it a setter-send
                node := self functionCallNodeForReceiver:(varOrArrayElement receiver)
                             selector:(varOrArrayElement translatedSelector)
                             args:(Array with:expr) fold:false.
                node endPosition: pos2.

                ^ node.
            ].
            varOrArrayElement isImmutable ifTrue:[
                self parseError:'cannot assign to an immutable value'
            ].

            node := JavaScriptAssignmentNode variable:varOrArrayElement expression:expr.
            self rememberAssignmentTo:varOrArrayElement.
            ^ node.
        ].

        (self isOpAssignSymbol:tokenType) ifTrue:[
            op := (tokenType copyButLast:1) asSymbol.
            lnr := tokenLineNr.
            self nextToken.

            val := self expression.
            node := JavaScriptBinaryNode receiver:varOrArrayElement selector:op arg:val.
            node lineNumber:lnr.
            self ifRequiredTranslateSelectorIn:node.

            node := JavaScriptAssignmentNode variable:varOrArrayElement expression:node.
            self rememberAssignmentTo:varOrArrayElement.
            ^ node.
        ].
        ^ varOrArrayElement
    ].

    tokenType == #function ifTrue:[
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
        tokenType == #Identifier ifTrue:[
            functionName := tokenName.
            self nextToken.
        ].
        node := self functionBodyFor:functionName asInnerFunction:true.
        ^ node.
    ].

    tokenType == #Identifier ifFalse:[
        self parseError:'unexpected: ''' , tokenType , ''''.
    ] ifTrue:[
        self parseError:'unexpected: ''' , (tokenName ? tokenType) , ''''.
    ].
    ^ nil.

    "Created: / 14-05-1998 / 19:00:09 / cg"
    "Modified: / 05-07-2010 / 14:11:58 / cg"
    "Modified: / 20-09-2013 / 15:30:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

functionCallExpression:recIn
    "functionCallExpression -> var
                               | var(argList)
    "

    |rec id argList lnr callNode varNode pos1 pos2 blockVar|

    pos1 := tokenPosition.
    lnr := tokenLineNr.

    (recIn notNil and:[ recIn isInnerFunction ]) ifTrue:[
        tokenType == $( ifTrue:[
            "/ function call
            self nextToken.
            tokenType == $) ifFalse:[
                argList := self expressionList.
            ].
            tokenType == $) ifFalse:[
                self parseError:''')'' expected in function call'.
            ].
            pos2 := tokenPosition.
            self nextToken.
            callNode := self realFunctionCallNodeForReceiver:recIn selector:nil args:argList fold:false.
            callNode selectorPosition:nil.
            callNode startPosition:pos1 endPosition:pos2.
            callNode lineNumber:lnr.
            ^ callNode
        ].
        ((tokenType == #with)
          or:[ tokenType == #typeof
          or:[ tokenType == #Identifier ]]
        ) ifFalse:[
            ^ recIn.
        ].
    ].

    ((tokenType == #with)
      or:[ tokenType == #typeof
      or:[ tokenType == #Identifier ]]
    ) ifFalse:[
        self parseError:'identifier expected'.
    ].
    
    id := tokenName.
    pos2 := tokenPosition+tokenName size-1.

    self nextToken.

    tokenType == $( ifTrue:[
        "/ function call
        self nextToken.
        tokenType == $) ifFalse:[
            argList := self expressionList.
        ].
        tokenType == $) ifFalse:[
            self parseError:''')'' expected in function call'.
        ].
        self nextToken.
        recIn isNil ifTrue:[
            "/ ok, this is a function call without a receiver proper.
            "/ this is a self-send, unless the function's name is known as
            "/ variable - in that case, its a function call, 
            "/ which is technically a block-evaluation.
            blockVar := self variable:id ignoreErrors:true.
            (blockVar notNil 
            and:[blockVar isGlobalVariable not]) ifTrue:[
                rec := nil.
                blockVar startPosition: -1 endPosition: -1 "/ To indicate node is synthetic
            ] ifFalse:[
                rec := ThisNode new value:selfValue.
                rec startPosition: -1 endPosition: -1 "/ To indicate node is synthetic
            ].
        ] ifFalse:[
            rec := recIn
        ].
        self markSelector:id from:pos1 to:pos2 receiverNode:rec numArgs:argList size.
        rec isNil ifTrue:[
            callNode := self realFunctionCallNodeForReceiver:blockVar selector:id args:argList fold:false.
        ] ifFalse:[
            callNode := self functionCallNodeForReceiver:rec selector:id args:argList fold:false.
        ].
        callNode selectorPosition: (pos1 to: pos2).
        callNode startPosition: pos1 endPosition: tokenLastEndPosition.
        callNode lineNumber:lnr.
        ^ callNode
    ].

    recIn notNil ifTrue:[
        self markSelector:id from:pos1 to:pos2 receiverNode:recIn numArgs:argList size.
        callNode := self implicitFunctionCallNodeForReceiver:recIn selector:id args:#() fold:false.
        callNode selectorPosition: (pos1 to: pos2).     
        callNode endPosition: pos2.
        callNode lineNumber:lnr.
        ^ callNode
    ].

    varNode := self variable:id.
    (varNode isKindOf:VariableNode) ifTrue:[
        varNode startPosition: pos1 endPosition: pos2.
        self markVariable:varNode from:pos1 to:pos2.
    ].
    ^ varNode

    "Modified: / 07-11-1998 / 12:25:52 / cg"
    "Modified: / 17-11-2014 / 13:32:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2018 / 12:38:14 / Claus Gittinger"
!

mulExpression
    "mulExpr -> powerExpression mulOp powerExpression
    "

    |expr1 expr2 op node lnr|

    expr1 := self powerExpression.
    [tokenType == $*
    or:[tokenType == $/
    or:[tokenType == $%]]] whileTrue:[
        op := tokenType asString asSymbol.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self powerExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node isConstant ifFalse:[
            node lineNumber:lnr.
            self ifRequiredTranslateSelectorIn:node.
        ].
        expr1 := node
    ].

    ^ expr1.

    "Created: / 14-05-1998 / 16:39:46 / cg"
    "Modified: / 14-05-1998 / 19:29:58 / cg"
    "Modified (comment): / 27-08-2018 / 15:34:01 / Claus Gittinger"
!

newExpression
    |classOrFunc dimExpressions moreDimensions lnr node pos0 pos1 pos2|

    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    pos0 := tokenPosition.
    self nextToken.

    tokenType == #function ifTrue:[
        ^ self primaryExpression
    ].

    (tokenType == #Identifier) ifFalse:[
        self parseError:'identifier expected'.
        ^ nil.
    ].
    classOrFunc := tokenName.
    lnr := tokenLineNr.
    pos1 := tokenPosition.
    pos2 := pos1+classOrFunc size-1.
    self nextToken.
    classOrFunc := self variable:classOrFunc.

    (classOrFunc isKindOf:VariableNode) ifTrue:[
        classOrFunc startPosition: pos1 endPosition: pos2.
        self markVariable:classOrFunc from:pos1 to:pos2.
    ].

    dimExpressions := OrderedCollection new.
    (tokenType == $( ) ifTrue:[
        [
            self nextToken.
            tokenType == $) ifTrue:[
                moreDimensions := false
            ] ifFalse:[
                dimExpressions add:(self nonCommaExpression).

                moreDimensions := (tokenType == $,).
                (moreDimensions or:[tokenType == $)]) ifFalse:[
                    self parseError:'")" or "," expected'.
                ].
            ].
        ] doWhile:[moreDimensions].
        self nextToken.
    ].
    node := (NewNode new classOrFunc:classOrFunc) dimensions:dimExpressions.
    node startPosition: pos0 endPosition: tokenLastEndPosition.
    node lineNumber:lnr.
    ^ node

    "Modified: / 20-09-2013 / 14:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nonCommaExpression
    ^ self conditionalExpression.
!

objectLiteral
    "objectLiteral -> '{' [ slotName ':' literal { , slotName ':' literal } ] '}'
     opening brace has already been read
    "

    |slots name anyNonConstant expr obj 
     jso jc mkarr pos1 pos2 node|

    anyNonConstant := false.
    pos1 := tokenLastEndPosition.

    slots := OrderedCollection new.
    [ tokenType == $} ] whileFalse:[
        (tokenType == #Identifier) ifTrue:[
            name := tokenName.
        ] ifFalse:[
            (tokenType == #String) ifTrue:[
                name := tokenValue asSymbol.
            ] ifFalse:[
                self parseError:'Identifier expected'.
            ]
        ].
        self nextToken.
        tokenType == $: ifFalse:[
            self parseError:'":" expected'.
        ].
        self nextToken.

        expr := self nonCommaExpression.
        slots add:(name asSymbol -> expr).
        expr isConstant ifFalse:[
            anyNonConstant := true
        ].
        tokenType == $} ifFalse:[
            tokenType == $, ifFalse:[
                self parseError:'"," expected'.
            ].
            self nextToken.
        ].
    ].

    self nextToken.
    pos2 := tokenLastEndPosition.

    anyNonConstant ifTrue:[
        "/ generate a structure dynamically
        jso := VariableNode globalNamed:#JavaScriptObject.
        jso startPosition:-1 endPosition:-1.

        jc := JavaScriptConstantNode type:#Array value:(slots map:#key) asArray.
        jc startPosition:-1 endPosition:-1.

        mkarr := Parser genMakeArrayWith:(slots map:#value).
        mkarr startPosition:-1 endPosition:-1.

        node := MessageNode
                receiver:jso 
                selector:#newWith:values: 
                arg1:jc 
                arg2:mkarr.
        node startPosition:pos1 endPosition:pos2.
        ^ node
    ] ifFalse:[
        "/ generate a structure
        obj := JavaScriptObject newWith:(slots map:#key) values:((slots map:#value) map:#value).
        ^ JavaScriptConstantNode type:#Object value:obj
    ].
    "Modified: / 16-07-2012 / 21:15:24 / cg"
!

powerExpression
    "powerExpr -> unaryExpr ** unaryExpr
    "

    |expr1 expr2 op node lnr|

    expr1 := self unaryExpression.
    [tokenType == #'**'] whileTrue:[
        op := tokenType.
        lnr := tokenLineNr.

        self nextToken.
        expr2 := self unaryExpression.
        node := JavaScriptBinaryNode receiver:expr1 selector:op arg:expr2 fold:foldConstants.
        node isConstant ifFalse:[
            node lineNumber:lnr.
            self ifRequiredTranslateSelectorIn:node.
        ].
        expr1 := node
    ].

    ^ expr1.

    "Created: / 27-08-2018 / 15:33:45 / Claus Gittinger"
!

primaryExpression
    "primaryExpr ->
                '(' expr ')'
                | '(' id1,...idN ')' '=>' lambdaFunctionBody
                | '(' ')'            '=>' lambdaFunctionBody
                | variable           '=>' lambdaFunctionBody
                | constant
                | 'this'
                | 'super'
                | variable
                | 'new' class
                | 'new' funcOrClass '(' dim ')'
                | 'function' '(' argList ')'  '{' statements '}'
    "

    |expr val varOrArrayElement node op isString indexExpr
     needSend lnr topEnvironment functionName pos1 pos2 startPos|

    startPos := tokenPosition.

    tokenType == $( ifTrue:[
        self nextToken.

        tokenType == #Identifier ifTrue:[
            "/ sigh for lambda-expression: if we simply proceed parsing, we will get 
            "/ undefined variable errors for the identifiers.
            "/ therefore, we try to parse ahead for the formal argList and the '=>' token.
            "/ if that fails, go back and parse as expression.
            self saveParseAheadDo:[
                |idList lambdaFunction endPos isLambda|

                idList := OrderedCollection new.
                isLambda := true.

                [
                    |moreArgs|

                    moreArgs := true.
                    tokenType == #Identifier ifTrue:[
                        idList add:(JavaScriptVariable type:#MethodArg name:(tokenName asSymbol) index:(idList size + 1)).
                        self nextToken.
                        (moreArgs := tokenType == $,) ifTrue:[
                            self nextToken.
                        ]
                    ] ifFalse:[
                        isLambda := moreArgs := false.
                    ].
                    moreArgs                     
                ] whileTrue.

                isLambda ifTrue:[
                    tokenType == $) ifTrue:[
                        self nextToken.
                        tokenType == #'=>' ifTrue:[
                            self nextToken.
                            lambdaFunction := self lambdaFunctionBodyWithArguments:idList.
                            lambdaFunction startPosition:startPos.
                            ^ self arrayIndexingExpression:lambdaFunction
                        ].
                    ].
                ].
            ].
            "/ old scanner state restored here
        ].
        
        tokenType == $) ifTrue:[
            "/ empty list; only in a lambda expression
            |lambdaFunction|
            
            self nextToken.
            (tokenType == #'=>') ifFalse:[
                self parseError:'''=>'' expected after empty argList'.
            ].
            self nextToken.
            lambdaFunction := self lambdaFunctionBodyWithArguments:#().
            lambdaFunction startPosition:startPos.
            ^ self arrayIndexingExpression:lambdaFunction
        ].    

        expr := self expression.
        tokenType ~~ $) ifTrue:[
            self parseError:''')'' expected'.
        ].
        self nextToken.
        ^ self arrayIndexingExpressionList:expr
    ].

    tokenType == $[ ifTrue:[
        expr := self arrayLiteral.
        ^ self arrayIndexingExpressionList:expr
    ].
    tokenType == ${ ifTrue:[
        self nextToken.
        expr := self objectLiteral.
        ^ expr
    ].

    (tokenType == #null) ifTrue:[
        | null |
        self markConstantFrom:tokenPosition to:tokenPosition+tokenName size-1.
        null := JavaScriptConstantNode type:#Nil value:tokenValue.
        null startPosition: tokenPosition endPosition:tokenPosition+tokenName size-1. 
        self nextToken.
        ^ self arrayIndexingExpressionList:null
    ].
    (tokenType == #void) ifTrue:[
        | null |
        self markConstantFrom:tokenPosition to:tokenPosition+tokenName size-1.
        null := JavaScriptConstantNode type:#Void value:tokenValue.
        null startPosition: tokenPosition endPosition:tokenPosition+tokenName size-1. 
        self nextToken.
        ^ self arrayIndexingExpressionList:null
    ].

    ((tokenType == #Integer)
     or:[(tokenType == #String)
     or:[(tokenType == #Character)
     or:[(tokenType == #Float)
     or:[(tokenType == #this)
     or:[(tokenType == #super)
     or:[(tokenType == #true)
     or:[(tokenType == #false)
     or:[(tokenType == #Symbol)]]]]]]]]) ifTrue:[
        tokenType == #super ifTrue:[
            val := SuperNode new value:selfValue.
            val startPosition: tokenPosition endPosition: tokenPosition+tokenName size-1.
            self markSuperFrom:tokenPosition to:tokenPosition+tokenName size-1.
            usesSuper := true.
        ] ifFalse:[
            tokenType == #this ifTrue:[
                val := ThisNode new value:selfValue.
                val startPosition: tokenPosition endPosition: tokenPosition+tokenName size-1.
                self markSelfFrom:tokenPosition to:tokenPosition+tokenName size-1.
            ] ifFalse:[
                "/ make it a special string (with additional protocol)
                tokenType == #String ifTrue:[
                    stringsAreImmutable ifTrue:[ tokenValue := Parser makeImmutableString:tokenValue].
                    isString := true.

                    topEnvironment := self topEnvironment.
                    (topEnvironment notNil 
                    and:[topEnvironment isContext not 
                    and:[topEnvironment _isHTMLEnvironment]]) ifTrue:[
                        "/ make it a JavaScriptString - with its restricted message set.

                        JavaScriptEnvironment autoload.
                        tokenValue := tokenValue copy changeClassTo:JavaScriptEnvironment::String.
                    ].
                ] ifFalse:[
                    self markConstantFrom:tokenPosition to:source position.
                ].
                val := JavaScriptConstantNode type:tokenType value:tokenValue.
                val startPosition: tokenPosition endPosition: source position.
            ].
        ].
        self nextToken.
        [ (tokenType == $.) or:[tokenType == $[ ] ] whileTrue:[
            (tokenType == $.) ifTrue:[
                self nextToken.
                val := self arrayIndexingExpression:val.
            ] ifFalse:[
                isString == true ifTrue:[
                    lnr := tokenLineNr.
                    self nextToken.
                    indexExpr := self expression.
                    tokenType == $] ifFalse:[
                        self parseError:''']'' expected'.
                    ].
                    self nextToken.
                    val := (ArrayAccessNode new array:val index:indexExpr) lineNumber:lnr.
                    val startPosition: val arrayExpression startPosition endPosition: tokenLastEndPosition 
                ]
            ].
        ].
        ((tokenType == $= ) or:[ self isOpAssignSymbol:tokenType]) ifTrue:[
            val isMessage ifTrue:[
                pos2 := tokenLastEndPosition.

                val isImplicitJavaScriptMessage ifFalse:[
                    self parseError:'cannot assign to an explicit function call'
                ].

                "/ mhm sth. like foo.bar.baz = expr;
                "/ or foo.bar[x] = expr;
                "/ rewrite the message into a setter (with argument)
                val isUnaryMessage ifTrue:[
                    self nextToken.
                    expr := self expression.

                    "/ must make it a setter-send
                    node := self functionCallNodeForReceiver:(val receiver)
                                 selector:(val translatedSelector)
                                 args:(Array with:expr) fold:false.
                    node endPosition: pos2.
                    ^ node.
                ].
                self parseError:'cannot assign to this function call (yet)'
            ] ifFalse:[
                val isJavaScriptArrayAccess ifTrue:[
                    pos2 := tokenLastEndPosition.

                    self nextToken.
                    expr := self expression.

                    "/ must make it a setter-send
                    node := AssignmentNode variable:val expression:expr.
                    "/ parserFlags fullLineNumberInfo ifTrue:[node lineNumber:lnr].
                    node endPosition: pos2.
                    ^ node.
                ].
                self parseError:'assignment to a constant'
            ].
        ].
        ^ val
    ].

    tokenType == #Identifier ifTrue:[
        "/ new is handled explicitely here, as it is no keyword
        "/ (can also be used as identifier in other context)
        tokenName = 'new' ifTrue:[
            ^ self newExpression.
        ].

        self saveParseAheadDo:[
            |argName|

            argName := tokenName.
            self nextToken.
            (tokenType == #'=>') ifTrue:[
                |lambdaFunction|
                
                self nextToken.
                lambdaFunction := self lambdaFunctionBodyWithArguments:{ (JavaScriptVariable type:#MethodArg name:(argName asSymbol) index:1) }.
                lambdaFunction startPosition:startPos.
                ^ self arrayIndexingExpression:lambdaFunction
            ].
        ].
        
        varOrArrayElement := self arrayIndexingExpression:nil.
        varOrArrayElement := self arrayIndexingExpressionList:varOrArrayElement.

        tokenType == $= ifTrue:[
            needSend := false.
            pos2 := tokenLastEndPosition.
            self nextToken.
            expr := self expression.

            varOrArrayElement isMessage ifTrue:[
                varOrArrayElement isImplicitJavaScriptMessage ifFalse:[
                    "/ self halt.
                    self parseError:'cannot assign to an explicit function call'
                ].
                varOrArrayElement isUnaryMessage ifFalse:[
                    "/ self halt.
                    self parseError:'cannot assign to this function call (yet)'
                ].

                "/ must make it a setter-send
                node := self functionCallNodeForReceiver:(varOrArrayElement receiver)
                             selector:(varOrArrayElement translatedSelector)
                             args:(Array with:expr) fold:false.
                node endPosition: pos2.
                ^ node.
            ].
            varOrArrayElement isImmutable ifTrue:[
                self parseError:'cannot assign to an immutable value'
            ].

            node := JavaScriptAssignmentNode variable:varOrArrayElement expression:expr.
            self rememberAssignmentTo:varOrArrayElement.
            ^ node.
        ].

        (self isOpAssignSymbol:tokenType) ifTrue:[
            op := (tokenType copyButLast:1) asSymbol.
            lnr := tokenLineNr.
            self nextToken.

            val := self expression.
            node := JavaScriptBinaryNode receiver:varOrArrayElement selector:op arg:val.
            node lineNumber:lnr.
            self ifRequiredTranslateSelectorIn:node.

            node := JavaScriptAssignmentNode variable:varOrArrayElement copy expression:node.
            self rememberAssignmentTo:varOrArrayElement.
            ^ node.
        ].
        
        varOrArrayElement isVariable ifTrue:[
            self rememberReadOf:varOrArrayElement
        ].    
        ^ varOrArrayElement
    ].

    tokenType == #function ifTrue:[
        pos1 := tokenPosition.
        self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
        tokenType == #Identifier ifTrue:[
            functionName := tokenName.
            self nextToken.
        ].
        node := self functionBodyFor:functionName asInnerFunction:true.
        pos2 := tokenLastEndPosition - 1.
        node startPosition:pos1 endPosition: pos2.
        ^ node.
    ].

    tokenType == #Identifier ifTrue:[
        self parseError:'unexpected: ''' , (tokenName ? tokenType) , ''''.
    ] ifFalse:[
        self parseError:'unexpected: ''' , tokenType printString , ''''.
    ].
    ^ nil.

    "Created: / 14-05-1998 / 19:00:09 / cg"
    "Modified: / 20-09-2013 / 17:46:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-07-2017 / 13:47:26 / cg"
    "Modified (comment): / 31-08-2018 / 12:55:09 / Claus Gittinger"
!

typeofExpression
    |expression lnr node pos1 pos2 |

    lnr := tokenLineNr.

    pos1 := tokenPosition.
    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    self nextToken.

    expression := self primaryExpression.
    pos2 := tokenLastEndPosition.

    node := TypeOfNode new expression:expression.
    node lineNumber:lnr.
    node startPosition: pos1 endPosition: pos2.
    ^ node

    "Modified: / 23-09-2013 / 10:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unaryExpression
    "unaryExpr -> !! unaryExpression
                | ~ unaryExpression
                | - unaryExpression
                | ++unaryExpression
                | --unaryExpression
                | typeof(primaryExpression)
                | primaryExpression
                | primaryExpression--
                | primaryExpression++
    "

    |expr op node lnr pos1|

    tokenType == #'typeof' ifTrue:[
        ^ self typeofExpression
    ].

    lnr := tokenLineNr.
    tokenType == $!! ifTrue:[
        pos1 := tokenPosition.
        self nextToken.
        expr := self unaryExpression.
        node := JavaScriptUnaryNode receiver:expr selector:#js_not fold:foldConstants.
        node startPosition: pos1  endPosition: expr endPosition.
        node lineNumber:lnr.
        ^ node
    ].
    tokenType == $~ ifTrue:[
        pos1 := tokenPosition.
        self nextToken.
        expr := self unaryExpression.
        node := JavaScriptUnaryNode receiver:expr selector:#bitInvert fold:foldConstants.
        node startPosition: pos1  endPosition: expr endPosition.
        node lineNumber:lnr.
        ^ node
    ].
    tokenType == $- ifTrue:[
        pos1 := tokenPosition.
        self nextToken.
        expr := self unaryExpression.
        node := JavaScriptUnaryNode receiver:expr selector:#negated fold:foldConstants.
        node startPosition: pos1  endPosition: expr endPosition.
        node lineNumber:lnr.
        ^ node
    ].
    (tokenType == #'++'
    or:[tokenType == #'--']) ifTrue:[
        op := tokenType.
        pos1 := tokenPosition.
        self nextToken.
        expr := self unaryExpression.
        expr isImmutable ifTrue:[
            self parseError:'++/-- is not allowed here (immutable expression)' position:pos1.
        ].
        node := PreIncDecNode new lValue:expr.
        node isInc:(op == #'++').
        node startPosition: pos1 endPosition: expr endPosition.
        node lineNumber:lnr.
        ^ node
    ].

    expr := self primaryExpression.

    (tokenType == #'++'
    or:[tokenType == #'--']) ifTrue:[
        expr isImmutable ifTrue:[
            self parseError:'++/-- is not allowed here (immutable expression)' .
        ].
        op := tokenType.
        lnr := tokenLineNr.
        self nextToken.
        node := PostIncDecNode new lValue:expr.
        node startPosition: expr startPosition endPosition: tokenLastEndPosition.
        node isInc:(op == #'++').
        node lineNumber:lnr.
        ^ node
    ].

    ^ expr.

    "Created: / 14-05-1998 / 16:39:46 / cg"
    "Modified: / 15-05-1998 / 15:09:33 / cg"
    "Modified: / 20-09-2013 / 15:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

varDeclaringExpression
    "an expression inside a for loop;
     slightly different, allowing an already declared varName to be (re)-defined"
    
    |expr var|

    tokenType == #var ifFalse:[
        ^ self expression
    ].

    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    self nextToken.
    tokenType == #Identifier ifFalse:[
        self parseError:'identifier expected after var'.
    ].
    
    (currentEnvironment notNil
      and:[currentEnvironment _localVariables notEmptyOrNil
      and:[currentEnvironment _localVariables includesKey:(tokenName asSymbol)]]
    ) ifTrue:[
        "/ already known
    ] ifFalse:[
        var := self declareVariable:tokenName inEnvironment:currentEnvironment.
    ].
    
    noComma := true.
    expr := self nonCommaExpression.
    noComma := false.

    tokenType == $, ifFalse:[
        ^ expr.
    ].
    self nextToken.
    ^ CommaExpression left:expr right:(self varDeclaringExpression)

    "Modified: / 30-08-2018 / 13:18:40 / Claus Gittinger"
!

variable:idAlreadyScanned
    ^ self variable:idAlreadyScanned ignoreErrors:ignoreErrors
!

variable:idAlreadyScanned ignoreErrors:ignoreErrors
    |id space varIndex deltaLevel
     localVars localVariable argVars argVariable staticVariable
     con global varNames pos|

    idAlreadyScanned isNil ifTrue:[
        tokenType ~~ #Identifier ifTrue:[
            self parseError:'identifier expected'.
        ].
        id := tokenName.
        self nextToken.
        pos := tokenPosition.
    ] ifFalse:[
        id := idAlreadyScanned.
        pos := tokenPosition - idAlreadyScanned size.
    ].

    [tokenType == #'::'] whileTrue:[
        self nextToken.
        tokenType ~~ #Identifier ifTrue:[
            self parseError:'identifier expected'.
        ].
        id := id , '::' , tokenName.
        self nextToken.
    ].
    id := id asSymbol.

    "/ if there is one in the current evaluationContext,
    "/ use that one.
    deltaLevel := 0.
    con := currentEnvironment.
    con isContext ifTrue:[
        "/ a real context (of a compiled function)
        [con notNil] whileTrue:[
            varNames := con argAndVarNames.
            varNames size > 0 ifTrue:[
                varIndex := varNames lastIndexOf:tokenName.
                varIndex ~~ 0 ifTrue:[
                    ^ (VariableNode type:#ContextVariable
                                    name:tokenName
                                 context:con
                                   index:varIndex)
                        "/ startPosition: tokenPosition endPosition: tokenPosition + tokenName size - 1
                ].
            ].
        
            self breakPoint:#cg.
            con := con home "sender".
            deltaLevel := deltaLevel + 1.
        ].
    ] ifFalse:[
        "/ simulated interpreter context
        [con notNil] whileTrue:[
            localVars := con _localVariables.
            localVars notEmptyOrNil ifTrue:[
                localVariable := localVars at:id ifAbsent:nil.
                localVariable notNil ifTrue:[
                    con _isFunctionEnvironment ifTrue:[
                        con isInnerFunction ifTrue:[
                            ^ JavaScriptVariableNode
                                type:#BlockVariable
                                name:id
                                token:localVariable
                                index:localVariable index
                                block:con 
                                from:currentEnvironment    
                        ].
                        ^ JavaScriptVariableNode
                            type:#MethodVariable
                            name:id
                            token:localVariable
                            index:localVariable index
                    ].
                    con isInnerJavaScriptBlock ifTrue:[
                        ^ JavaScriptVariableNode
                            type:#BlockVariable
                            name:id
                            token:localVariable
                            index:localVariable index
                            block:con 
                            from:currentEnvironment    
                    ].
                    ^ JavaScriptVariableNode
                            type:#EvaluationContextLocal
                            name:id
                            token:localVariable
                            index:nil
                            block:nil
                            from:nil
                ]
            ].
            argVars := con _argVariables.
            argVars notEmptyOrNil ifTrue:[
                argVariable := argVars detect:[:var | var name = id] ifNone:nil.
                argVariable notNil ifTrue:[
                    con _isFunctionEnvironment ifTrue:[
                        con isInnerFunction ifTrue:[
                            ^ JavaScriptVariableNode
                                type:#BlockArg
                                name:id
                                token:argVariable
                                index:argVariable index
                                block:con 
                                from:currentEnvironment    
                        ].
                        ^ JavaScriptVariableNode
                            type:(argVariable type)
                            name:id
                            token:argVariable
                            index:argVariable index
                    ].
                    con isInnerJavaScriptBlock ifTrue:[
                        ^ JavaScriptVariableNode
                            type:#BlockArg
                            name:id
                            token:argVariable
                            index:argVariable index
                            block:con 
                            from:currentEnvironment    
                    ].

                    ^ JavaScriptVariableNode
                        type:#EvaluationContextArg
                        name:id
                        token:argVariable
                        index:nil
                        block:nil
                        from:nil
                ].
            ].
            con := con _outerEnvironment.
            deltaLevel := deltaLevel + 1.
        ].
    ].

    staticVars notNil ifTrue:[
        staticVariable := staticVars at:id ifAbsent:nil.
        staticVariable notNil ifTrue:[
            ^ JavaScriptVariableNode type:#ClassVariable class:classToCompileFor name:(staticVariable name).
        ].
    ].

    classToCompileFor notNil ifTrue:[
        "is it an instance-variable ?"
        varIndex := classToCompileFor allInstVarNames lastIndexOf:id.
        varIndex ~~ 0 ifTrue:[
            self rememberInstVarUsed:id.
            ^ JavaScriptVariableNode 
                        type:#InstanceVariable
                        name:id
                        index:varIndex
                        selfValue:selfValue
        ].
        classToCompileFor notNil ifTrue:[
            "is it a class-variable ?"
            (classToCompileFor theNonMetaclass allClassVarNames includes:id) ifTrue:[
                self rememberClassVarUsed:id.
                ^ JavaScriptVariableNode 
                            type:#ClassVariable
                            class:classToCompileFor theNonMetaclass
                            name:id.
            ].
        ].
    ].
    "is it a class-variable ? (treated like statics)"
    (self isDoIt and:[ selfValue isBehavior ]) ifTrue:[
        (selfValue allClassVarNames includes:id) ifTrue:[
            self rememberClassVarUsed:id.
            ^ JavaScriptVariableNode 
                        type:#ClassVariable
                        class:selfValue
                        name:id.
        ].
    ].

    space := self findNameSpaceWith:id.
    space notNil ifTrue:[
        space ~~ Smalltalk ifTrue:[
            ^ JavaScriptVariableNode type:#PrivateClass class:space name:id
        ].
        (space includesKey:id asSymbol) ifFalse:[
            ignoreErrors ifTrue:[^ nil].
            self parseError:'unknown global: ' , id.
        ].
        global := id asSymbol.
    ] ifFalse:[
        "/ if the id starts with an upper-case character,
        "/ it may be a global.
        id isUppercaseFirst ifTrue:[
            (Smalltalk includesKey:id asSymbol) ifFalse:[
                self isSyntaxHighlighter ifFalse:[
                    ignoreErrors ifFalse:[
                        self undefError:id.
                    ].
                ].
            ].
            global := id.
        ].
    ].

    global notNil ifTrue:[
"/        [tokenType == #'::'] whileTrue:[
"/            self nextToken.
"/            tokenType ~~ #Identifier ifTrue:[
"/                self parseError:'identifier expected'.
"/            ].
"/            global := global , '::' , tokenName.
"/            self nextToken.
"/        ].
        self rememberGlobalUsed:global.
        ^ JavaScriptVariableNode type:#GlobalVariable name:global asSymbol.
    ].

    self isSyntaxHighlighter ifFalse:[
        ignoreErrors ifFalse:[
            (alreadyWarnedUndeclaredVariables includes:id) ifFalse:[
                self parseError:('unknown variable: "%1"' bindWith:id allBold) position:pos.
                alreadyWarnedUndeclaredVariables add:id.
            ].
        ].
    ].

    self rememberGlobalUsed:id.
    ^ JavaScriptVariableNode type:#GlobalVariable name:id.

    "Created: / 07-11-1998 / 12:25:20 / cg"
    "Modified: / 15-08-2017 / 16:33:00 / cg"
! !

!JavaScriptParser methodsFor:'parsing-obsolete'!

assignmentExpression
    <resource: #obsolete>
    "assExpr -> var = condExpr
    "

    |var expr node lnr|

    var := self variable.
    (tokenType == $=) ifTrue:[
        lnr := tokenLineNr.

        self nextToken.
        expr := self nonCommaExpression.
        node := JavaScriptAssignmentNode variable:var expression:expr.
        node lineNumber:lnr.
        self rememberAssignmentTo:var.
        ^ node
    ].

    ^ var.

    "Created: / 14-05-1998 / 19:02:47 / cg"
    "Modified: / 23-07-2010 / 23:48:34 / cg"
! !

!JavaScriptParser methodsFor:'parsing-statements'!

breakStatement
    "breakStatement -> break ';'
    "

    |line pos1 |

    line := tokenLineNr.
    pos1 := tokenPosition.
    self expectKeyword:#break.
    self expect:$;.
    ^ BreakStatementNode new 
        lineNumber:line;
        startPosition: pos1 endPosition: pos1 + 4;
        yourself

    "Created: / 15-05-1998 / 14:08:34 / cg"
    "Modified: / 26-10-1998 / 15:24:48 / cg"
    "Modified: / 20-09-2013 / 16:01:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

catchPartFor:tryBlockNode
    "tryCatchStatement -> try {
                                ...
                              statements
                                ...
                          } 
                          catch([Error] [exVar] ) {
                                ...
                              statements
                                ...
                          }
                          [ finally {
                                ...
                              statements
                                ...
                          }
                            
     Notice: try { ... } has already been parsed.
     Either Error-name or exVar or both may be present in the catch
     (but one of them at least)
    "

    |lNr errorExpression exceptionVar prevCon 
     catchBlockNode finallyBlockNode node pos1 pos2 |

    lNr := tokenLineNr.
    self expectKeyword:#catch.

    self expect:$(.
    (tokenType == #Identifier and:[tokenName isLowercaseFirst]) ifTrue:[
        "/ implicit
        errorExpression := VariableNode globalNamed:#Error.
    ] ifFalse:[
        errorExpression := self expression.
    ].
    tokenType == #Identifier ifTrue:[
        exceptionVar := tokenName.
        self markLocalIdentifierFrom:tokenPosition to:(tokenPosition+tokenName size-1).
        self nextToken.
    ].
    self expect:$).

    prevCon := currentEnvironment.
    catchBlockNode := InnerJavaBlockNode new.
    catchBlockNode home:currentEnvironment.
    exceptionVar notNil ifTrue:[
        catchBlockNode arguments:(Array with:(JavaScriptVariable type:#BlockArg name:exceptionVar index:1)).
    ].
    catchBlockNode lineNumber:tokenLineNr.

    currentEnvironment := catchBlockNode.
    pos1 := tokenPosition.      
    catchBlockNode statements:(self statementBlock).
    pos2 := tokenLastEndPosition.
    currentEnvironment := prevCon.
    catchBlockNode startPosition: pos1 endPosition: pos2.

    node := (TryCatchStatementNode new
        tryBlock:tryBlockNode
        errorExpression:errorExpression
        catchBlock:catchBlockNode) lineNumber:lNr.

    tokenType == #finally ifTrue:[
        finallyBlockNode := self finallyPart.
        node finallyBlock:finallyBlockNode.
    ].

    ^ node

    "Modified: / 23-09-2013 / 10:52:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2018 / 13:08:54 / Claus Gittinger"
!

continueStatement
    "continueStatement -> continue ';'
    "

    |line pos1 |

    line := tokenLineNr.
    pos1 := tokenPosition.
    self expectKeyword:#continue.
    self expect:$;.
    ^ ContinueStatementNode new 
        lineNumber:line;
        startPosition: pos1 endPosition: pos1 + 7;
        yourself

    "Modified: / 14-05-1998 / 21:40:43 / cg"
    "Created: / 26-10-1998 / 15:24:31 / cg"
    "Modified: / 20-09-2013 / 16:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doWhileStatement
    "doWhileStatement -> do stat while (expression)
    "

    |cond loopStats pos1 pos2 |

    pos1 := tokenPosition.
    ((tokenType == #Identifier) and:[tokenName = 'do']) ifFalse:[
        self parseError:'"do" expected'.
    ].
    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    self nextToken.

    loopStats := self statementBlock.

    self expect:#while.
    self expect:$(.
    tokenType ~~ $) ifTrue:[
        cond := self expression.
    ].
    pos2 := tokenPosition.
    self expect:$).

    ^ (DoWhileStatementNode new condition:cond loopStatements:loopStats)
        startPosition: pos1 endPosition: pos2;
        yourself

    "Modified: / 20-09-2013 / 15:57:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finallyPart
    "finallyPart -> finally {
                                ...
                              statements
                                ...
                          }
    "

    |prevCon finallyBlockNode pos1 pos2 |

    self expectKeyword:#finally.

    prevCon := currentEnvironment.
    finallyBlockNode := InnerJavaBlockNode new.
    finallyBlockNode home:currentEnvironment.
    finallyBlockNode lineNumber:tokenLineNr.

    currentEnvironment := finallyBlockNode.
    pos1 := tokenPosition.      
    finallyBlockNode statements:(self statementBlock).
    pos2 := tokenLastEndPosition.
    currentEnvironment := prevCon.
    finallyBlockNode startPosition: pos1 endPosition: pos2.       

    ^ finallyBlockNode.

    "Modified: / 23-09-2013 / 10:53:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forStatement
    "forStatement -> for (initexpr ; condexpr ; increxpression) stat
                   | for (variable in array) stat"

    |initExpr condExpr incrExpr loopStat varExpr arrayExpr pos1 pos2  lineNumber|

    pos1 := tokenPosition.
    lineNumber := tokenLineNr.
    self expectKeyword:#for.
    self expect:$(.

    "/ initPart or variable-part
    tokenType == $; ifFalse:[
        initExpr := self varDeclaringExpression.
        (tokenType == #Identifier 
         and:[tokenName = 'in']) ifTrue:[
            self markKeyword:'in' from:tokenPosition to:tokenPosition+1.

            self class forInAllowed ifFalse:[
                self parseError:'for..in statement is not yet supported'.
            ] ifTrue:[
                "/ for (var <id> in expr) {... }
                initExpr isVariable ifFalse:[
                    self parseError:'only a single variable name allowed in for..in statement'.
                ].
                varExpr := initExpr. initExpr := nil.
                self nextToken.
                arrayExpr := self expression.
                self expect:$).

                loopStat := self statementBlock.
                pos2 := tokenLastEndPosition.
                ^ ForStatementNode new 
                    varExpression:varExpr 
                    arrayExpression:arrayExpr 
                    loopStatements:loopStat;
                    startPosition: pos1 endPosition: pos2;
                    lineNumber:lineNumber;
                    yourself
            ].
        ].
    ].
    self expect:$;.

    "/ conditionPart
    tokenType == $; ifFalse:[
        condExpr := self expression.
    ].
    self expect:$;.

    "/ incrPart
    tokenType == $) ifFalse:[
        incrExpr := self expression.
    ].
    self expect:$).

    loopStat := self statementBlock.
    pos2 := tokenLastEndPosition.
    ^ ForStatementNode new 
        initExpression:initExpr 
        condition:condExpr 
        incrExpression:incrExpr 
        loopStatements:loopStat;
        lineNumber:lineNumber;
        startPosition: pos1 endPosition: pos2;
        yourself

    "Modified: / 26-10-1998 / 14:56:32 / cg"
    "Modified: / 20-09-2013 / 17:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

functionDefinition
    |var fNameOrNil fnode node varNode pos1 pos2 |

    pos1 := tokenPosition.
    tokenType ~~ #function ifTrue:[ 
        self parseError:'"function" expected.'.
    ].
    self markKeyword:tokenType from:tokenPosition to:(tokenPosition+tokenName size-1).
    self nextToken.

    (tokenType == #Identifier) ifTrue:[
        var := self declareVariable:tokenName inEnvironment:currentEnvironment.
        self nextToken.
        fNameOrNil := var name.
    ].
    fnode := self functionBodyFor:fNameOrNil asInnerFunction:true.
    pos2 := tokenLastEndPosition.
    fnode startPosition: pos1 endPosition: pos2.
    tokenType == $; ifTrue:[
        self nextToken
    ] ifFalse:[
        "/ ok without semi
        "/ self parseError:''';'' expected.'.
    ].
    fNameOrNil isNil ifTrue:[
        node := fnode
    ] ifFalse:[
        varNode := self variable:fNameOrNil.    
        varNode startPosition: -1 endPosition: -1. "/ To indicates that the node is synthatic.
        node := JavaScriptAssignmentNode variable:varNode expression:fnode.
        node startPosition: -1 endPosition: -1. "/ To indicates that the node is synthatic.
    ].
    ^ JavaScriptStatementNode new expression:node.

    "Created: / 20-02-2007 / 21:30:56 / cg"
    "Modified: / 19-05-2010 / 13:41:27 / cg"
    "Modified: / 20-09-2013 / 17:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ifStatement
    "ifStatement -> if (expression) stat [ else stat ]
    "

    |cond ifStats elseStats pos1 pos2 |

    pos1 := tokenPosition.
    self expectKeyword:#if.
    self expect:$(.
    cond := self expression.
    self expect:$).

    ifStats := self statementBlock.
    pos2 := tokenLastEndPosition.

    tokenType == #else ifTrue:[
        self expectKeyword:#else.
        elseStats := self statementBlock.
        pos2 := tokenLastEndPosition.
    ].
    ^ (IfStatementNode new 
            condition:cond ifStatements:ifStats elseStatements:elseStats;
            startPosition: pos1 endPosition: pos2;
            yourself)

    "Created: / 14-05-1998 / 21:33:46 / cg"
    "Modified: / 26-10-1998 / 14:55:22 / cg"
    "Modified: / 20-09-2013 / 16:14:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnStatement
    "returnStatement -> return [ expression ] ['from' outerFunctionName ] ';'
    "

    |expr environmentToReturnFrom env found node pos1 pos2 |

    pos1 := tokenPosition.
    self expectKeyword:#return.

    tokenType == $; ifTrue:[
        self nextToken.
        ^ (JavaScriptReturnNode new)
            startPosition: pos1 endPosition: tokenLastEndPosition;
            yourself
    ].

    (tokenType == #Identifier and:[tokenName = 'from']) ifFalse:[
        expr := self expression.
        pos2 := tokenLastEndPosition.
    ].

    (tokenType == #Identifier and:[tokenName = 'from']) ifTrue:[
        self markKeyword:tokenName from:tokenPosition to:(tokenPosition+4-1).
        self nextToken.
        (tokenType == #Identifier) ifFalse:[
            self parseError:'function name expected.'.
        ].
        found := false.
        env := currentEnvironment.
        [found not and:[env notNil]] whileTrue:[
            env _isFunctionEnvironment ifTrue:[
                env functionName = tokenName ifTrue:[
                    environmentToReturnFrom := env.
                    found := true.
                ].
            ].
            env := env _outerEnvironment.
        ].
        found ifFalse:[
            self parseError:'invalid function return.'.
        ].
        (environmentToReturnFrom notNil 
        and:[environmentToReturnFrom _outerEnvironment notNil]) ifTrue:[
            self parseError:'only return from the top-function is (currently) allowed.'.
        ].
        pos2 := tokenLastEndPosition.
        self nextToken.
    ] ifFalse:[
        env := currentEnvironment.
        [env isNil or:[env _isFunctionEnvironment]] whileFalse:[
            env := env _outerEnvironment
        ].
        environmentToReturnFrom := env ? currentEnvironment.
    ].

    self expect:$;.

    node := JavaScriptReturnNode new.
    expr notNil ifTrue:[ node expression:expr ].

"/    currentEnvironment isInnerJavaScriptBlock ifTrue:[
"/        environmentToReturnFrom := currentEnvironment home.
"/    ].

    environmentToReturnFrom notNil ifTrue:[
        environmentToReturnFrom isReturnedFrom:true.
        node environmentToReturnFrom:environmentToReturnFrom.
    ].
    node startPosition: pos1 endPosition: pos2.
    ^ node.

    "Created: / 14-05-1998 / 21:35:53 / cg"
    "Modified: / 19-05-2010 / 15:11:27 / cg"
    "Modified: / 20-09-2013 / 20:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statement
    "statement -> expression ;
    "

    ^ self statementWithSemi:true
!

statementBlock
    "statementBlock -> { statList } | statement
    "

    ^ self statementBlock:true

    "Created: / 14.5.1998 / 21:16:20 / cg"
    "Modified: / 26.10.1998 / 14:57:47 / cg"
!

statementBlock:readClosingBraceBoolean
    "statementBlock -> { statList } | statement
    "

    |stats |

    tokenType == ${ ifTrue:[
        self nextToken.
        tokenType == $} ifFalse:[
            stats := self statementBlockBodyFor:currentEnvironment.
        ].
        tokenType == $} ifFalse:[
            self parseError:'''}'' expected (i.e. ''' , tokenType printString allBold , ''' unexpected)'.
        ] ifTrue:[
            readClosingBraceBoolean ifTrue:[ self nextToken ].
        ].
        ^ stats
    ].

    ^ self statement.

    "Created: / 14.5.1998 / 21:16:20 / cg"
    "Modified: / 26.10.1998 / 14:57:47 / cg"
!

statementBlockBody
    "statementBlock -> [ var decl ] statList
    "

    ^ self statementBlockBodyFor:nil

    "Modified: / 17.5.1998 / 00:29:11 / cg"
!

statementBlockBodyFor:anEnvironment
    "statementBlock -> [ var decl ] statList"

    |stats prevCon|

    prevCon := currentEnvironment.
    anEnvironment isNil ifTrue:[
        currentEnvironment := JavaScriptEnvironment new.
        currentEnvironment _localVariables:IdentityDictionary new.
        currentEnvironment _outerEnvironment:prevCon.
    ] ifFalse:[
        currentEnvironment := anEnvironment
    ].
    stats := self statements.
    currentEnvironment := prevCon.

    ^ stats

    "Created: / 17-05-1998 / 00:28:24 / cg"
    "Modified: / 20-02-2007 / 21:34:27 / cg"
!

statementWithSemi:needSemi
    "statement -> 
            var varName ....
            let varName ....
            const varName ....
            static var varName ....
            function ....
            ifStatement
            whileStatement
            doStatement
            returnStatement
            forStatement
            switchStatement
            breakStatement
            continueStatement
            tryStatement
            throwStatement
            { statementBlock }
            expression ;
    "

    |expr stat t|

    t := tokenType.
    (tokenType == #const) ifTrue:[
        ^ self constDeclaration.
    ].
    ((tokenType == #var) 
    or:[ tokenType == #let
    or:[ (tokenType == #Identifier) and:[ tokenName = 'static' ]]]) ifTrue:[ 
        ^ self varDeclaration.
    ].
    tokenType == #function ifTrue:[ 
        ^ self functionDefinition.
    ].

    gotAnyRealStatement := true.
    tokenType == #if ifTrue:[ ^ self ifStatement. ].
    tokenType == #while ifTrue:[ ^ self whileStatement ].
    ((tokenType == #Identifier) and:[tokenName = 'do']) ifTrue:[ ^ self doWhileStatement ].
    tokenType == #return ifTrue:[ ^ self returnStatement ].
    tokenType == #for ifTrue:[ ^ self forStatement ].
    tokenType == #switch ifTrue:[ ^ self switchStatement ].
    tokenType == #break ifTrue:[^ self breakStatement ].
    tokenType == #continue ifTrue:[ ^ self continueStatement ].
    tokenType == #try ifTrue:[ ^ self tryStatement ].
    tokenType == #throw ifTrue:[ ^ self throwStatement ].
"/    tokenType == #foreach ifTrue:[ ^ self foreachStatement ].
"/    tokenType == #with ifTrue:[ ^ self withStatement ].

    tokenType == ${ ifTrue:[ ^ self statementBlock ].

    tokenType ~~ $; ifTrue:[
        expr := self compoundExpression.
        stat := JavaScriptStatementNode new expression:expr.

        tokenType == #EOF ifTrue:[
            self class == JavaScriptParser ifFalse:[ "compiling"
                self isDoIt ifFalse:[
                    self warning:'missing '';'' at end of statement'.
                ]
            ].
            ^ stat.
        ]
    ].

    needSemi ifTrue:[
        self needSemi.
    ] ifFalse:[
        tokenType == $; ifTrue:[
            (interactiveMode not
            or:[ source isExternalStream not 
            or:[ source isFileStream ]]) ifTrue:[
                self nextToken
            ] ifFalse:[
                token := tokenType := nil.
            ].
        ].
    ].
    ^ stat

    "Created: / 14-05-1998 / 20:26:49 / cg"
    "Modified: / 06-12-2011 / 00:14:21 / cg"
!

statements
    "statement -> expression ;
    "

    |stat first prev|

    [true] whileTrue:[

        "/ stop when a function declaration is encountered;
        "/ this is encountered, when reading a javaScript, in which statements
        "/ and function-decls are intermixed.

"/        tokenType == #function ifTrue:[
"/            currentEnvironment _outerEnvironment isNil ifTrue:[
"/                ^ first.
"/            ]
"/        ].

        tokenType == #EOF ifTrue:[
            "/ an empty statement
            ^ first.
        ].
        tokenType == $} ifTrue:[
            "/ an empty statement
"/            self warning:'missing '';'' at end of statement block.'.
            ^ first.
        ].
        stat := self statement.
        stat notNil ifTrue:[
            first isNil ifTrue:[
                first := stat
            ].
            prev notNil ifTrue:[
                prev nextStatement:stat
            ].
        ].
        tokenType == #EOF ifTrue:[
            ^ first.
        ].
        tokenType == $} ifTrue:[
            ^ first.
        ].
        stat notNil ifTrue:[
            prev := stat last.
        ]
    ].

    "Created: / 14-05-1998 / 21:18:39 / cg"
    "Modified: / 20-02-2007 / 21:34:04 / cg"
!

switchStatement
    "switchStatement -> switch (expression) {
                          case constant-expression1:
                                ...
                                stat
                                ...
                                break ;
                          case constant-expression2:
                                ...
                          default:
                                ...
                        }
    "

    |pos1 pos2 switchExpression switchBlocks switchVal blocksStatements stat|

    pos1 := tokenPosition.
    self expectKeyword:#switch.
    self expect:$(.
    switchExpression := self expression.
    self expect:$).

    self expect:${.
    switchBlocks := OrderedCollection new.    
    [ tokenType ~~ $} ] whileTrue:[
        tokenType == #case ifTrue:[
            self expectKeyword:tokenType.
            switchVal := self expression. "/ constantExpression.
            blocksStatements := OrderedCollection new.
            switchBlocks add:(switchVal -> blocksStatements).
            self expect:$:.
        ] ifFalse:[
            tokenType == #default ifTrue:[
                self expectKeyword:tokenType.
                blocksStatements := OrderedCollection new.
                switchBlocks add:(nil -> blocksStatements).
                self expect:$:.
            ] ifFalse:[
                stat := self statement.
                blocksStatements notNil ifTrue:[
                    blocksStatements add:stat.
                ].
            ].
        ].
    ].

    switchBlocks isEmpty ifTrue:[
        self notifyWarning:'no cases in switch statement' position:pos1 to:tokenPosition
    ] ifFalse:[
        (switchBlocks contains:[:b | b value notEmptyOrNil]) ifFalse:[
            self notifyWarning:'empty switch statement' position:pos1 to:tokenPosition
        ]
    ].
    pos2 := tokenPosition.
    self nextToken.
    ^ SwitchStatementNode new
        switchExpression:switchExpression
        statementBlocks:switchBlocks;
        startPosition: pos1 endPosition: pos2;
        yourself

    "Modified: / 23-09-2013 / 11:05:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwStatement
    "throwStatement -> throw expression ';'
    "

    |lNr expr node|

    lNr := tokenLineNr.
    self expectKeyword:#throw.

    expr := self expression.
    self expect:$;.

    node := ThrowStatementNode new.
    node expression:expr.
    node lineNumber:lNr.

    ^ node.
!

tryStatement
    "tryStatement -> try {
                           ...
                           statements
                           ...
                         }
                     ( catchPart | finallyPart ]   
    "

    |lNr1 lNr2 prevCon tryBlockNode finallyBlockNode pos1 pos2 |

    lNr1 := tokenLineNr.
    pos1 := tokenPosition.
    self expectKeyword:#try.

    prevCon := currentEnvironment.

    tryBlockNode := InnerJavaBlockNode new.
    tryBlockNode home:currentEnvironment.
    tryBlockNode arguments:#().
    tryBlockNode lineNumber:(lNr2 := tokenLineNr).

    currentEnvironment := tryBlockNode.
    pos1 := tokenPosition.
    tryBlockNode statements:(self statementBlock).
    pos2 := tokenLastEndPosition.
    currentEnvironment := prevCon.
    tryBlockNode startPosition: pos1 endPosition: pos2.

    tokenType == #catch ifTrue:[
        | tryCatchFinallyNode |

        tryCatchFinallyNode := self catchPartFor:tryBlockNode.
        pos2 := tokenLastEndPosition.
        tryCatchFinallyNode startPosition: pos1 endPosition: pos2.
        ^ tryCatchFinallyNode 
    ].
    finallyBlockNode := self finallyPart.
    pos2 := tokenLastEndPosition.
    ^ (TryCatchStatementNode new
        tryBlock:tryBlockNode
        finallyBlock:finallyBlockNode) 
        lineNumber:lNr1;
        startPosition: pos1 endPosition: pos2;
        yourself

    "Modified: / 23-09-2013 / 10:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

whileStatement
    "whileStatement -> while (expression) stat
    "

    |cond loopStats pos1 pos2|

    pos1 := tokenPosition.
    self expectKeyword:#while.
    self expect:$(.
    cond := self expression.
    self expect:$).
    pos2 := tokenLastEndPosition.

    loopStats := self statementBlock.

    ^ WhileStatementNode new 
        condition:cond loopStatements:loopStats;
        startPosition: pos1 endPosition: pos2.

    "Created: / 14-05-1998 / 22:02:50 / cg"
    "Modified: / 26-10-1998 / 14:58:29 / cg"
    "Modified: / 23-09-2013 / 10:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser methodsFor:'private'!

functionCallNodeForReceiver:rec selector:id args:argList fold:fold
    |sendNode selector|

    rec isNil ifTrue:[
        "/ block evaluation - generate a value-send
        argList isEmptyOrNil ifTrue:[
            selector := 'value'.
        ] ifFalse:[
            selector := ((argList collect:[:ign | 'value:']) asStringWith:'') asSymbol.
        ].
        "useless computation. And now??"    
        "/ self halt.
    ] ifFalse:[
        sendNode := FunctionCallNode receiver:rec selector:id args:argList fold:fold.
        sendNode lineNumber:lineNr.
        self ifRequiredTranslateSelectorIn:sendNode.
        ^ sendNode
    ].

    "Modified: / 19-05-2010 / 16:01:47 / cg"
!

handleCategoryDirective:categoryString
    "callback from the scanner, whenever it encountered a category comment-directive"

    methodCategory := categoryString.

    "Created: / 26-10-2011 / 17:49:49 / cg"
!

implicitFunctionCallNodeForReceiver:rec selector:id args:argList fold:fold
    |callNode|

    callNode := ImplicitFunctionCallNode receiver:rec selector:id args:argList fold:fold.
    callNode lineNumber:lineNr.
    self ifRequiredTranslateSelectorIn:callNode.
    ^ callNode
!

isSyntaxHighlighter
    ^ false
!

nameSpaceSelectorFor:aSymbol
    "Caring for the current namespace, return the real selector used for a send."

    |ns usedSym|

    usedSym := aSymbol.

    Smalltalk hasSelectorNameSpaces ifTrue:[
        ns := self currentNameSpace.
        (ns notNil and:[ns ~~ Smalltalk]) ifTrue:[
            usedSym := (':',ns name,'::',aSymbol) asSymbol.
            "/ Logger info:('compile ',aSymbol,' as ',usedSym).
        ].
    ].
    ^ usedSym.

    "Created: / 05-03-2007 / 13:28:59 / cg"
    "Modified (comment): / 29-08-2018 / 12:52:56 / Claus Gittinger"
!

realFunctionCallNodeForReceiver:rec selector:id args:argList fold:fold
    "/ block evaluation - generate a value-send

    |evalSelector nodeClass|

    argList isEmptyOrNil ifTrue:[
        evalSelector := 'value'.
        nodeClass := JavaScriptUnaryNode.
    ] ifFalse:[
        evalSelector := ((argList collect:[:ign | 'value:']) asStringWith:'') asSymbol.
        nodeClass := MessageNode.
    ].
    ^ nodeClass 
            receiver:rec 
            selector:evalSelector
            args:argList.

    "Modified: / 26-03-2018 / 15:23:17 / stefan"
!

saveParseAheadDo:aBlock
    |savLineNr savPos savToken savTokenType savTokenPosition savTokenValue
     savTokenName savTokenLineNr savTokenLastEndPosition
     savHereChar savPeekChar savPeekChar2 savErrorFlag|

    savLineNr := lineNr.
    savPos := source position.
    savToken := token.
    savTokenType := tokenType.
    savTokenPosition := tokenPosition.
    savTokenValue := tokenValue.
    savTokenName := tokenName.
    savTokenLineNr := tokenLineNr.
    savTokenLastEndPosition := tokenLastEndPosition.
    savHereChar := hereChar.
    savPeekChar := peekChar.
    savPeekChar2 := peekChar2.
    savErrorFlag := errorFlag.

    aBlock value.
    
    "/ restore old scanner state
    source position:savPos.
    lineNr := savLineNr.
    token := savToken.
    tokenType := savTokenType.
    tokenPosition := savTokenPosition.
    tokenValue := savTokenValue.
    tokenName := savTokenName.
    tokenLineNr := savTokenLineNr.
    tokenLastEndPosition := savTokenLastEndPosition.
    hereChar := savHereChar.
    peekChar := savPeekChar.
    peekChar2 := savPeekChar2.
    errorFlag := savErrorFlag.

    "Created: / 27-08-2018 / 17:49:02 / Claus Gittinger"
! !

!JavaScriptParser methodsFor:'queries'!

isEmptyMethod
    "return true (after a parse) if this is an empty (documentation) method"

    ^ self tree isNil
!

methodArgs
    ^ topEnvironment arguments collect:[:each | each name ].

    "Modified: / 24-09-2013 / 15:46:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodVars
    ^ topEnvironment localVariableNames
!

wasParsedForCode
    ^ false "/ a kludge for compatibility
! !

!JavaScriptParser methodsFor:'queries-statistic'!

messagesPossiblySent
    "return a collection with possible message selectors (valid after parsing).
     Includes things known or possibly used with #perform or in specs.
     Not yet implemented here."

    ^ #()
    "/ ^ (messagesPossiblySent ? #()) collect:[:each | each asSymbol]
!

messagesSent
    "return a collection with sent message selectors (valid after parsing).
     Includes all sent messages (i.e. also sent super messages)"

    |selectors|

    tree notNil ifTrue:[
        selectors := IdentitySet new.
        tree messageSelectorsDo:[:sel | selectors add:sel].
        ^ selectors.
    ].
    ^ #()
!

messagesSentToSelf
    "that is not true - for now, to make the browser happy"

    ^ #()
!

messagesSentToSuper
    "that is not true - for now, to make the browser happy"

    ^ #()
!

modifiedClassVars
    ^ modifiedClassVars ? #()
!

modifiedGlobals
    ^ modifiedGlobals ? #()
!

modifiedInstVars
    ^ modifiedInstVars ? #()
!

usedClassVars
    ^ usedClassVars ? #()
!

usedGlobals
    ^ usedGlobals ? #()
!

usedInstVars
    ^ usedInstVars ? #()
!

usedVars
    ^ usedVars ? #()

    "Created: / 16-07-2012 / 21:42:06 / cg"
!

usesSuper
    "return true if the parsed method uses super (valid after parsing)"

    ^ usesSuper
! !

!JavaScriptParser methodsFor:'statistic'!

rememberClassVarModified:name
    modifiedClassVars isNil ifTrue:[
        modifiedClassVars := Set new
    ].
    modifiedClassVars add:name.
    self rememberClassVarUsed:name.
!

rememberClassVarRead:name
    readClassVars isNil ifTrue:[
        readClassVars := Set new
    ].
    readClassVars add:name.
    self rememberClassVarUsed:name.

    "Created: / 23-07-2017 / 13:42:24 / cg"
!

rememberClassVarUsed:name
    usedClassVars isNil ifTrue:[
        usedClassVars := Set new
    ].
    usedClassVars add:name.
    self rememberVariableUsed:name

    "Created: / 16-07-2012 / 21:43:33 / cg"
!

rememberGlobalModified:name
    modifiedGlobals isNil ifTrue:[
        modifiedGlobals := Set new
    ].
    modifiedGlobals add:name.
    self rememberGlobalUsed:name.
!

rememberGlobalRead:name
    readGlobals isNil ifTrue:[
        readGlobals := Set new
    ].
    readGlobals add:name.
    self rememberGlobalUsed:name.

    "Created: / 23-07-2017 / 13:42:42 / cg"
!

rememberGlobalUsed:name 
    usedGlobals isNil ifTrue:[
        usedGlobals := Set new
    ].
    usedGlobals add:name.
    self rememberVariableUsed:name
!

rememberInstVarModified:name
    modifiedInstVars isNil ifTrue:[
        modifiedInstVars := Set new
    ].
    modifiedInstVars add:name.
    self rememberInstVarUsed:name.
!

rememberInstVarRead:name
    readInstVars isNil ifTrue:[
        readInstVars := Set new
    ].
    readInstVars add:name.
    self rememberInstVarUsed:name.

    "Created: / 23-07-2017 / 13:42:52 / cg"
!

rememberInstVarUsed:name
    usedInstVars isNil ifTrue:[
        usedInstVars := Set new
    ].
    usedInstVars add:name.
    self rememberVariableUsed:name
!

rememberLocalModified:name
"/    modifiedLocalVars isNil ifTrue:[
"/        modifiedLocalVars := Set new.
"/    ].
"/    modifiedLocalVars add:name.
    self rememberLocalUsed:name
!

rememberLocalRead:name
"/    readLocalVars isNil ifTrue:[
"/        readLocalVars := Set new.
"/    ].
"/    readLocalVars add:name.
    self rememberLocalUsed:name

    "Created: / 23-07-2017 / 13:43:36 / cg"
!

rememberLocalUsed:name
"/    usedLocalVars isNil ifTrue:[
"/        usedLocalVars := Set new
"/    ].
"/    usedLocalVars add:name.
!

rememberVariableUsed:name
    usedVars isNil ifTrue:[
        usedVars := Set new
    ].
    usedVars add:name
! !

!JavaScriptParser methodsFor:'temporary hacks for DWIM'!

nodeGenerationCallback:nodeGenerationHook
!

rememberNodes:aBoolean
!

rememberTokens:aBoolean
! !

!JavaScriptParser methodsFor:'utilities'!

ensureBooleanExpression:expr
    |jsCondition|

    self smalltalkCompatibilityMode ifTrue:[
        ^ expr
    ].
    "/ relops are guaranteed to return booleans...
    expr isBinaryMessage ifTrue:[
        ( #( < <= > >= == = ~~ ~=) includes:expr selector)
        ifTrue:[
            ^ expr
        ].
    ].
    jsCondition := JavaScriptUnaryNode
                    receiver:expr
                    selector:#js_asBoolean
                    args:#().
    ^ jsCondition

    "Modified: / 26-03-2018 / 15:21:43 / stefan"
! !

!JavaScriptParser::JavaScriptStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    self class ~~ JavaScriptParser::JavaScriptStatementNode ifTrue:[
        self subclassResponsibility.
    ].

    expression notNil ifTrue:[
        expression codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ].
! !

!JavaScriptParser::JavaScriptStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    expression notNil ifTrue:[
        super printOn:aStream indent:i.
        aStream nextPutAll:';'.
    ]
! !

!JavaScriptParser::JavaScriptStatementNode methodsFor:'testing'!

isDoWhileStatement
    ^ false
!

isExpressionStatement
    ^ true
!

isForStatement
    ^ false
!

isIfStatement
    ^ false
!

isThrowStatement
    ^ false
!

isTryCatchFinallyStatement
    ^ false

    "Created: / 27-08-2018 / 13:10:18 / Claus Gittinger"
!

isTryCatchStatement
    ^ false
!

isTryFinallyStatement
    ^ false
!

isWhileStatement
    ^ false
! !

!JavaScriptParser::JavaScriptStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptStatementNode:self 
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'accessing'!

array:a index:i
    self array: a indices: (Array with:i)

    "Created: / 15-05-1998 / 14:07:34 / cg"
    "Modified: / 20-09-2013 / 17:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

array:a indices:i
    arrayExpr := a.
    indexExpressions := i.

    arrayExpr parent: self.
    indexExpressions do:[:each | each parent: self ].

    "Created: / 15-05-1998 / 14:07:34 / cg"
    "Modified: / 20-09-2013 / 12:23:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

arrayExpression
    ^ arrayExpr
!

indexExpressions
    ^ indexExpressions 
!

lineNumber
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'compiling'!

codeOn:aStream inBlock:codeBlock for:aCompiler
    self codeOn:aStream inBlock:codeBlock valueNeeded:true for:aCompiler
!

codeOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    indexExpressions size == 1 ifTrue:[
        ((MessageNode
            receiver:arrayExpr
            selector:(aCompiler smalltalkCompatibilityMode
                        ifTrue:[#'at:']
                        ifFalse:[#'js_at:'])
            arg:(indexExpressions first)
         ) lineNumber:lineNumber)
                 codeOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler.
        ^ self
    ].
    "/ self halt.
    self error:'multidimensional arrays are not yet supported'

    "Modified: / 19-05-2010 / 16:02:32 / cg"
!

codeStore:valueExpr on:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    |numIndices|

    numIndices := indexExpressions size.
    numIndices == 1 ifTrue:[
        ((MessageNode
            receiver:arrayExpr
            selector:(aCompiler smalltalkCompatibilityMode
                        ifTrue:[#'at:put:']
                        ifFalse:[#'js_at:put:'])
            arg1:(indexExpressions first)
            arg2:valueExpr
        ) lineNumber:lineNumber) codeOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler.
        ^ self.
    ].
    self error:'multiDimensional arrays are not yet supported'.

    "Modified: / 20-04-2005 / 11:52:09 / cg"
!

codeStoreOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    "emit code to store the top of stack"

    |numIndices selLitIdx|

    numIndices := indexExpressions size.
    numIndices == 1 ifTrue:[
        |indexExpr needPlus1 needMinus1|

        "/ the stack is
        "/      value   <--- TOP
        arrayExpr codeOn:aStream inBlock:codeBlock for:aCompiler.

        "/ the stack is
        "/      value   
        "/      array   <--- TOP
        aStream nextPut:#over.

        "/ the stack is
        "/      value   
        "/      array   
        "/      value   <--- TOP

        needPlus1 := needMinus1 := false.

        indexExpr := indexExpressions first.
        (indexExpr isPostIncDec or:[indexExpr isPreIncDec]) ifTrue:[
            "/ already has been inc/decremented, when it did the load
            indexExpr := indexExpr lValue.
            indexExpr isInc ifTrue:[
                needMinus1 := true.
            ] ifFalse:[
                needPlus1 := true.
            ].
        ].
        indexExpr codeOn:aStream inBlock:codeBlock for:aCompiler.
        needPlus1 ifTrue:[aStream nextPut:#plus1; nextPut:(indexExpr lineNumber).].
        needMinus1 ifTrue:[aStream nextPut:#minus1; nextPut:(indexExpr lineNumber).].

        "/ now, we have the stack in wrong order for the send;
        "/      value
        "/      array
        "/      value   
        "/      index   <--- TOP
        aStream nextPut:#swap.
        "/ now, we have:
        "/      value
        "/      array
        "/      index
        "/      value   <--- TOP

        selLitIdx := aCompiler 
                        addLiteral:(aCompiler smalltalkCompatibilityMode
                                        ifTrue:[#'at:put:']
                                        ifFalse:[#'js_at:put:']).
        self emitSendLiteralIndex:selLitIdx numArgs:2 line:("lineNr ?" 1) on:aStream for:aCompiler.

        "/ now, we have:
        "/      value   leftover from #over
        "/      value   <--- TOP (returned by at:put:)
        aStream nextPut:#drop.
        aStream nextPut:#drop.
        ^ self.
    ].
    self error:'multiDimensional arrays are not yet supported'.

    "Modified: / 20-04-2005 / 11:52:09 / cg"
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    arrayExpr allNodesDo:aBlock.
    indexExpressions notNil ifTrue:[ 
        indexExpressions do:[:expr |
            expr allNodesDo:aBlock
        ]
    ]
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    arrayExpr messageSelectorsDo:aBlock.
    indexExpressions notNil ifTrue:[ 
        indexExpressions do:[:expr |
            expr messageSelectorsDo:aBlock
        ]
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    arrayExpr messagesDo:aBlock.
    indexExpressions notNil ifTrue:[ 
        indexExpressions do:[:expr |
            expr messagesDo:aBlock
        ]
    ]
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    arrayExpr variableNodesDo:aBlock.
    indexExpressions notNil ifTrue:[ 
        indexExpressions do:[:expr |
            expr variableNodesDo:aBlock
        ]
    ]
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'evaluating'!

evaluateIn:anEnvironment
    |arr idx|

    arr := arrayExpr evaluateIn:anEnvironment.
    indexExpressions size == 1 ifTrue:[
        idx := indexExpressions first evaluateIn:anEnvironment.
        "/ ^ arr js_at:idx
        ^ arr at:idx
    ].
    self error:'multidimensional arrays are not yet supported'

    "Modified: / 19-05-2010 / 16:02:40 / cg"
!

store:newValue
    |arr idx|

    arr := arrayExpr evaluate.
    indexExpressions size == 1 ifTrue:[
        idx := indexExpressions first evaluate.
        "/ ^ arr js_at:idx put:newValue
        ^ arr at:idx put:newValue
    ].
    self error:'multidimensional arrays are not yet supported'

    "Created: / 06-11-1998 / 22:27:36 / cg"
    "Modified: / 19-05-2010 / 16:02:45 / cg"
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'printing'!

printOn:aStream indent:i
    arrayExpr printOn:aStream indent:i.
    aStream nextPutAll:'['.
    indexExpressions keysAndValuesDo:[:idx :eachIndexExpr |
        idx > 1 ifTrue:[
            aStream nextPutAll:', '.
        ].
        eachIndexExpr printOn:aStream.
    ].

    aStream nextPutAll:']'.

    "Created: / 15.5.1998 / 14:33:09 / cg"
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'queries'!

isImmutable
    ^ false
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'testing'!

isJavaScriptArrayAccess
    ^ true

    "Created: / 05-07-2010 / 14:03:59 / cg"
! !

!JavaScriptParser::ArrayAccessNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitArrayAccessNode:self 
! !

!JavaScriptParser::ArrayStoreNode class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaScriptParser::ArrayStoreNode methodsFor:'accessing'!

expression
    ^ expression
!

expression:something
    expression := something.
! !

!JavaScriptParser::ArrayStoreNode methodsFor:'compiling'!

codeOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    self error.
! !

!JavaScriptParser::BreakStatementNode class methodsFor:'Signal constants'!

breakLabelQuery
    ^ BreakLabelQuery

    "Created: / 26.10.1998 / 15:17:46 / cg"
!

breakSignal
    ^ BreakSignal

    "Created: / 26.10.1998 / 15:17:46 / cg"
! !

!JavaScriptParser::BreakStatementNode class methodsFor:'initialization'!

initialize
    BreakSignal isNil ifTrue:[
        BreakSignal := Signal new.
        BreakLabelQuery := QuerySignal new.
    ]

    "Modified: / 26.10.1998 / 15:17:30 / cg"
! !

!JavaScriptParser::BreakStatementNode methodsFor:'compilation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |loopDescr|

    loopDescr := aCompiler loopDescription.
    loopDescr isNil ifTrue:[
        aCompiler parseError:'break not within a loop or switch'.
        ^ self
    ].
    loopDescr codeForBreakOn:aStream at:lineNr for:aCompiler.

    "Modified: / 06-11-2013 / 21:17:30 / cg"
!

codeOn:aStream inBlock:b for:aCompiler
    self codeForSideEffectOn:aStream inBlock:b for:aCompiler

    "Created: / 06-11-2013 / 21:07:38 / cg"
! !

!JavaScriptParser::BreakStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    "/ self halt.
    BreakSignal raise

    "Created: / 26-10-1998 / 15:30:41 / cg"
    "Modified: / 19-05-2010 / 16:02:50 / cg"
! !

!JavaScriptParser::BreakStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'break;'.

    "Created: / 15.5.1998 / 14:33:45 / cg"
    "Modified: / 15.5.1998 / 15:05:51 / cg"
! !

!JavaScriptParser::BreakStatementNode methodsFor:'testing'!

isBreakStatement
    ^ true
!

isExpressionStatement
    ^ false
! !

!JavaScriptParser::BreakStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitBreakStatementNode:self 
! !

!JavaScriptParser::CommaExpression class methodsFor:'instance creation'!

left:l right:r
    ^ self new left:l right:r
! !

!JavaScriptParser::CommaExpression methodsFor:'accessing'!

expression1
    ^ leftExpression

    "Created: / 19-09-2013 / 18:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression2
    ^ rightExpression

    "Created: / 19-09-2013 / 18:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

left:l right:r
    self assert:l notNil.
    self assert:r notNil.

    leftExpression := l.
    leftExpression parent: self.
    rightExpression := r.
    rightExpression parent: self.

    startPosition := leftExpression startPosition.
    endPosition := rightExpression endPosition

    "Created: / 15-05-1998 / 15:02:55 / cg"
    "Modified: / 19-05-2010 / 16:02:57 / cg"
    "Modified: / 20-09-2013 / 15:41:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::CommaExpression methodsFor:'compilation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    leftExpression codeForSideEffectOn:aStream inBlock:b for:aCompiler.
    rightExpression codeForSideEffectOn:aStream inBlock:b for:aCompiler.
!

codeOn:aStream inBlock:b for:aCompiler
    leftExpression codeForSideEffectOn:aStream inBlock:b for:aCompiler.
    rightExpression codeOn:aStream inBlock:b for:aCompiler.
! !

!JavaScriptParser::CommaExpression methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    leftExpression allNodesDo:aBlock.
    rightExpression allNodesDo:aBlock.
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    leftExpression messageSelectorsDo:aBlock.
    rightExpression messageSelectorsDo:aBlock.
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    leftExpression messagesDo:aBlock.
    rightExpression messagesDo:aBlock.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    leftExpression variableNodesDo:aBlock.
    rightExpression variableNodesDo:aBlock.
! !

!JavaScriptParser::CommaExpression methodsFor:'printing'!

printOn:aStream indent:i
    leftExpression printOn:aStream indent:i.
    aStream nextPutAll:', '.
    rightExpression printOn:aStream indent:i.

    "Created: / 15.5.1998 / 15:02:20 / cg"
! !

!JavaScriptParser::CommaExpression methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitCommaExpression:self 
! !

!JavaScriptParser::ConditionalNode methodsFor:'accessing'!

condition
    ^ condition
!

condition:c expression1:e1 expression2:e2
    condition := c.
    expr1 := e1.
    expr2 := e2.

    condition parent: self.
    expr1 parent: self.
    expr2 parent: self.

    startPosition := condition startPosition.
    endPosition := condition endPosition.

    "Created: / 17-05-1998 / 21:00:44 / cg"
    "Modified: / 20-09-2013 / 15:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

elseExpression
    ^ expr2

    "Created: / 09-06-2010 / 01:59:44 / cg"
!

ifExpression
    ^ expr1

    "Created: / 09-06-2010 / 01:59:39 / cg"
! !

!JavaScriptParser::ConditionalNode methodsFor:'compilation'!

codeOn:aStream inBlock:b for:aCompiler
    |jmpDeltaPos jmpJoinDeltaPos code|

    (aCompiler ensureBooleanExpression:condition)
        codeOn:aStream inBlock:b for:aCompiler.

    aStream nextPut:#falseJump.
    jmpDeltaPos := aStream position + 1.
    aStream nextPut:0.

    expr1 codeOn:aStream inBlock:b for:aCompiler.

    aStream nextPut:#jump.
    jmpJoinDeltaPos := aStream position + 1.
    aStream nextPut:0.
    code := aStream contents.
    code at:jmpDeltaPos put:(aStream position + 1).
    expr2 codeOn:aStream inBlock:b for:aCompiler.
    code at:jmpJoinDeltaPos put:(aStream position + 1).
! !

!JavaScriptParser::ConditionalNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    condition allNodesDo:aBlock.
    expr1 allNodesDo:aBlock.
    expr2 allNodesDo:aBlock.
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    condition messageSelectorsDo:aBlock.
    expr1 messageSelectorsDo:aBlock.
    expr2 messageSelectorsDo:aBlock.
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    condition messagesDo:aBlock.
    expr1 messagesDo:aBlock.
    expr2 messagesDo:aBlock.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    condition variableNodesDo:aBlock.
    expr1 variableNodesDo:aBlock.
    expr2 variableNodesDo:aBlock.
! !

!JavaScriptParser::ConditionalNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |cond e|

    cond := condition evaluateIn:anEnvironment.
    cond == true ifTrue:[
        e := expr1
    ] ifFalse:[
        cond == false ifTrue:[
            e := expr2
        ] ifFalse:[
            self error:'condition does not evaluate to a boolean'.
            ^ nil.
        ]
    ].

    ^ e evaluateIn:anEnvironment.

    "Created: / 17.5.1998 / 21:02:40 / cg"
! !

!JavaScriptParser::ConditionalNode methodsFor:'printing'!

printOn:aStream indent:i
    condition printOn:aStream indent:i.
    aStream nextPutAll:' ? '.
    expr1 printOn:aStream.
    aStream nextPutAll:' : '.
    expr2 printOn:aStream.

    "Created: / 17.5.1998 / 21:01:19 / cg"
! !

!JavaScriptParser::ConditionalNode methodsFor:'testing'!

isJavaScriptConditionalExpression
    ^ true

    "Created: / 09-06-2010 / 01:55:35 / cg"
! !

!JavaScriptParser::ConditionalNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitConditionalNode:self 
! !

!JavaScriptParser::ContinueStatementNode class methodsFor:'Signal constants'!

continueLabelQuery
    ^ ContinueLabelQuery

    "Created: / 26.10.1998 / 15:20:54 / cg"
!

continueSignal
    ^ ContinueSignal

    "Created: / 26.10.1998 / 15:20:54 / cg"
! !

!JavaScriptParser::ContinueStatementNode class methodsFor:'initialization'!

initialize
    ContinueSignal isNil ifTrue:[
        ContinueSignal := Signal new.
        ContinueLabelQuery := QuerySignal new.
    ]

    "Created: / 26.10.1998 / 15:20:28 / cg"
! !

!JavaScriptParser::ContinueStatementNode methodsFor:'compilation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |loopDescr|

    loopDescr := aCompiler loopDescription.
    loopDescr isNil ifTrue:[
        aCompiler parseError:'continue not within a loop'.
        ^ self
    ].
    loopDescr codeForContinueOn:aStream at:lineNr for:aCompiler.

    "Modified: / 06-11-2013 / 21:18:12 / cg"
! !

!JavaScriptParser::ContinueStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    "/ self halt.
    ContinueSignal raise

    "Created: / 26-10-1998 / 15:30:49 / cg"
    "Modified: / 19-05-2010 / 16:03:05 / cg"
! !

!JavaScriptParser::ContinueStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'continue;'.

    "Created: / 15.5.1998 / 14:34:04 / cg"
! !

!JavaScriptParser::ContinueStatementNode methodsFor:'testing'!

isExpressionStatement
    ^ false
! !

!JavaScriptParser::ContinueStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitContinueStatementNode:self 
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'accessing'!

condition
    "return the value of the instance variable 'condition' (automatically generated)"

    ^ condition

    "Created: / 15.5.1998 / 14:36:13 / cg"
!

condition:something
    "set the value of the instance variable 'condition' (automatically generated)"

    condition := something.
    condition parent: self.

    "Created: / 15-05-1998 / 14:36:13 / cg"
    "Modified: / 20-09-2013 / 15:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

condition:c loopStatements:l
    self condition: c.
    self loopStatements: l.

    "Created: / 15-05-1998 / 14:40:02 / cg"
    "Modified: / 20-09-2013 / 15:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loopStatements
    "return the value of the instance variable 'loopStatements' (automatically generated)"

    ^ loopStatements

    "Created: / 15.5.1998 / 14:36:15 / cg"
!

loopStatements:something
    "set the value of the instance variable 'loopStatements' (automatically generated)"

    loopStatements := something.
    loopStatements parent: self.

    "Created: / 15-05-1998 / 14:36:15 / cg"
    "Modified: / 20-09-2013 / 15:55:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |loopDescription condVal loopPos|

    loopDescription := aCompiler newLoopDescription.
    loopPos := aStream position + 1.
    loopStatements notEmptyOrNil ifTrue:[
        aCompiler pushLoopDescription:loopDescription.
        loopStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.
        aCompiler popLoopDescription.
    ].

    loopDescription patchContinuesTo:(aStream position + 1) in:aStream.

    condition isNil ifTrue:[
        condVal := true.
    ] ifFalse:[
        condition isConstant ifTrue:[
            condVal := condition evaluate.
        ].
    ].
    condVal == false ifTrue:[
        "/ always false: no loop at all
    ] ifFalse:[
        condVal == true ifTrue:[
            "/ always true:
            aStream nextPut:#jump.
            aStream nextPut:loopPos.
        ] ifFalse:[
            (aCompiler ensureBooleanExpression:condition)
                codeOn:aStream inBlock:b for:aCompiler.
            aStream nextPut:#trueJump.
            aStream nextPut:loopPos.
        ].
    ].

    loopDescription patchBreaksTo:(aStream position + 1) in:aStream.
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'enumeration'!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    condition messageSelectorsDo:aBlock.
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each messageSelectorsDo:aBlock]
    ]
!

messagesnodeDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    condition messagesnodeDo:aBlock.
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each messagesnodeDo:aBlock]
    ]
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    |cond|

    [true] whileTrue:[
        JavaScriptParser::ContinueStatementNode continueSignal handle:[:ex |
            ex return
        ] do:[
            loopStatements notNil ifTrue:[
                JavaScriptParser::BreakStatementNode breakSignal handle:[:ex |
                    ^ self
                ] do:[
                    loopStatements evaluateIn:anEnvironment
                ].
            ].

            cond := condition evaluateIn:anEnvironment.
            cond == false ifTrue:[
                ^ nil
            ].
            cond ~~ true ifTrue:[
                NonBooleanReceiverError raiseRequestErrorString:'non-boolean in while-condition. Proceed for false'.
                ^ nil.
            ].
        ].
    ].
    ^ nil

    "Modified: / 27-08-2018 / 14:48:40 / Claus Gittinger"
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'do {'.
    aStream cr; spaces:i+4.
    loopStatements printAllOn:aStream indent:i+4.
    aStream cr; spaces:i.
    aStream nextPutAll:'} while ('.
    condition printOn:aStream.
    aStream nextPutAll:')'.

    "
     JavaScriptParser
        parseFunction:'
test() {
    var i = 0;
    do {
        Transcript.showCR(''hello'');
    } while (i++ < 5);
}
'.     
    "
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'testing'!

isDoWhileStatement
    ^ true
!

isExpressionStatement
    ^ false
! !

!JavaScriptParser::DoWhileStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitDoWhileStatementNode:self 
! !

!JavaScriptParser::ForStatementNode methodsFor:'accessing'!

arrayExpression
    ^ arrayExpression
!

condition
    ^ condition
!

incrExpression
    ^ incrExpression
!

initExpression
    ^ initExpression
!

initExpression:i condition:c incrExpression:incr loopStatements:l
    initExpression := i.
    initExpression notNil ifTrue:[
        initExpression parent: self.
    ].

    condition := c.
    condition notNil ifTrue:[
        condition parent: self.
    ].

    incrExpression := incr.
    incrExpression notNil ifTrue:[
        incrExpression parent: self.
    ].

    loopStatements := l.
    loopStatements notNil ifTrue:[
        loopStatements parent: self.
    ].

    "Created: / 15-05-1998 / 14:49:02 / cg"
    "Modified: / 20-09-2013 / 17:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loopStatements
    ^ loopStatements
!

varExpression
    ^ varExpression
!

varExpression:v arrayExpression:a loopStatements:l
    varExpression := v.
    varExpression parent: self.

    arrayExpression := a.
    arrayExpression parent: self.

    loopStatements := l.
    loopStatements notNil ifTrue:[
        loopStatements parent: self.
    ].

    "Modified: / 20-09-2013 / 17:49:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::ForStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |loopJumpPos loopStartPos code loopDescription node condJumpPos|

    varExpression notNil ifTrue:[
        |runVariable assignment loopBlock|

        loopDescription := aCompiler newLoopDescriptionForBlock.
        runVariable := VariableNode blockArgumentNamed:'__js_for_in'.
        "/ make a block...
        loopBlock := BlockNode arguments:(Array with:runVariable) home:b variables:nil.
        runVariable block:loopBlock; index:1.
        assignment := StatementNode expression:(AssignmentNode variable:varExpression expression:runVariable).
        assignment nextStatement:loopStatements.
        loopBlock
"/            parent:b;
            lineNumber:lineNr;
            statements:assignment.

        self hasBreakStatement ifTrue:[
            "/ loopDescription deltaScope:2.
            "We do a #returnablePerform:with: here, in order to make 'break' working"
            node := MessageNode
                            receiver:arrayExpression
                            selector:#returnablePerform:with:
                            args:(Array with:(ConstantNode value:#do:) 
                                        with:loopBlock).
        ] ifFalse:[
            node := MessageNode
                            receiver:arrayExpression
                            selector:#do:
                            args:(Array with:loopBlock).
        ].
        node lineNumber:lineNr.

        aCompiler pushLoopDescription:loopDescription.
        node codeForSideEffectOn:aStream inBlock:b for:aCompiler.
        aCompiler popLoopDescription.
        ^ self.
    ].

    loopDescription := aCompiler newLoopDescription.
    initExpression notNil ifTrue:[
        initExpression codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ].

    condition notNil ifTrue:[
        aStream nextPut:#jump.
        loopJumpPos := aStream position + 1.
        aStream nextPut:0.
    ].
    loopStartPos := aStream position + 1.
    condition isNil ifTrue:[
        loopDescription continueLabel:loopStartPos.
    ].

    loopStatements notNil ifTrue:[
        aCompiler pushLoopDescription:loopDescription.
        loopStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.
        aCompiler popLoopDescription.
    ].

    incrExpression notNil ifTrue:[
        incrExpression codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ].

    loopDescription patchContinuesTo:aStream position + 1 in:aStream.

    condition isNil ifTrue:[
        aStream nextPut:#jump.
        aStream nextPut:loopStartPos.
    ] ifFalse:[
        code := aStream contents.
        code at:loopJumpPos put:(aStream position + 1).

        (aCompiler ensureBooleanExpression:condition)
            codeOn:aStream inBlock:b for:aCompiler.

        "/ FIXME:
        "/ the code below is OK, but currently leads to a problem with
        "/ mcompiler, which only does interrupt-checks on backward unconditional jumps
        "/ therefore, until mcompiler is fixed,
        "/ generate a forward conditional jump over a backward unconditional one.
        aStream nextPut:#falseJump.
        condJumpPos := aStream position + 1.
        aStream nextPut:0.
        aStream nextPut:#jump.
        aStream nextPut:loopStartPos.
        code at:condJumpPos put:(aStream position + 1).

        "/ aStream nextPut:#trueJump.
        "/ aStream nextPut:loopStartPos.
    ].

    loopDescription patchBreaksTo:aStream position + 1 in:aStream.

    "Modified: / 06-11-2013 / 21:09:42 / cg"
! !

!JavaScriptParser::ForStatementNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    initExpression notNil ifTrue:[ initExpression allNodesDo:aBlock].
    condition notNil ifTrue:[ condition allNodesDo:aBlock].
    incrExpression notNil ifTrue:[ incrExpression allNodesDo:aBlock].
    varExpression notNil ifTrue:[ varExpression allNodesDo:aBlock].
    arrayExpression notNil ifTrue:[ arrayExpression allNodesDo:aBlock].
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each allNodesDo:aBlock]
    ]
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    initExpression notNil ifTrue:[ initExpression messageSelectorsDo:aBlock].
    condition notNil ifTrue:[ condition messageSelectorsDo:aBlock].
    incrExpression notNil ifTrue:[ incrExpression messageSelectorsDo:aBlock].
    varExpression notNil ifTrue:[ varExpression messageSelectorsDo:aBlock].
    arrayExpression notNil ifTrue:[ arrayExpression messageSelectorsDo:aBlock].
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each messageSelectorsDo:aBlock]
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    initExpression notNil ifTrue:[ initExpression messagesDo:aBlock].
    condition notNil ifTrue:[ condition messagesDo:aBlock].
    incrExpression notNil ifTrue:[ incrExpression messagesDo:aBlock].
    varExpression notNil ifTrue:[ varExpression messagesDo:aBlock].
    arrayExpression notNil ifTrue:[ arrayExpression messagesDo:aBlock].
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each messagesDo:aBlock]
    ]
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    initExpression notNil ifTrue:[ initExpression variableNodesDo:aBlock].
    condition notNil ifTrue:[ condition variableNodesDo:aBlock].
    incrExpression notNil ifTrue:[ incrExpression variableNodesDo:aBlock].
    varExpression notNil ifTrue:[ varExpression variableNodesDo:aBlock].
    arrayExpression notNil ifTrue:[ arrayExpression variableNodesDo:aBlock].
    loopStatements notNil ifTrue:[
        loopStatements do:[:each | each variableNodesDo:aBlock]
    ]
! !

!JavaScriptParser::ForStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    varExpression notNil ifTrue:[
        |collection|
        collection := arrayExpression evaluateIn:anEnvironment.
        JavaScriptParser::BreakStatementNode breakSignal handle:[:ex |
            "finished"
        ] do:[
            collection do:[:each|
                varExpression store:each.
                loopStatements notNil ifTrue:[
                    loopStatements evaluateIn:anEnvironment.
                ].
            ].
        ].
        ^ self.
    ].

    initExpression notNil ifTrue:[initExpression evaluateIn:anEnvironment].

    [true] whileTrue:[
        JavaScriptParser::ContinueStatementNode continueSignal handle:[:ex |
            ex return
        ] do:[
            |cond|

            cond := condition isNil or:[condition evaluateIn:anEnvironment].
            cond == false ifTrue:[
                ^ nil.
            ].
            cond ~~ true ifTrue:[
                NonBooleanReceiverError raiseRequestErrorString:'non-boolean in for-condition. Proceed for false'.
                ^ nil.
            ].
            loopStatements notNil ifTrue:[
                JavaScriptParser::BreakStatementNode breakSignal handle:[:ex |
                    ^ self
                ] do:[
                    loopStatements evaluateIn:anEnvironment
                ]
            ].
            incrExpression notNil ifTrue:[incrExpression evaluateIn:anEnvironment].
        ]
    ]

    "Modified: / 26-10-1998 / 15:22:18 / cg"
    "Modified: / 27-08-2018 / 14:49:08 / Claus Gittinger"
! !

!JavaScriptParser::ForStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'for ('.
    varExpression notNil ifTrue:[
        varExpression printOn:aStream.
        aStream nextPutAll:' in '.
        arrayExpression printOn:aStream.
    ] ifFalse:[
        initExpression notNil ifTrue:[
            initExpression printOn:aStream.
        ].
        aStream nextPutAll:'; '.
        condition notNil ifTrue:[
            condition printOn:aStream.
        ].
        aStream nextPutAll:'; '.
        incrExpression notNil ifTrue:[
            incrExpression printOn:aStream.
        ].
    ].
    aStream nextPutAll:') {'.
    aStream cr.
    loopStatements printAllOn:aStream indent:i+4.
    aStream cr; spaces:i; nextPutAll:'}'; cr.

    "Created: / 15.5.1998 / 14:49:46 / cg"
! !

!JavaScriptParser::ForStatementNode methodsFor:'testing'!

hasBreakStatement
    "is there a break statement in the loop?"

    loopStatements allNodesDo:[:eachNode| 
        eachNode isBreakStatement ifTrue:[
            ^ true.
        ].
    ].
    ^ false.
!

isExpressionStatement
    ^ false
!

isForStatement
    ^ true
! !

!JavaScriptParser::ForStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitForStatementNode:self 
! !

!JavaScriptParser::FunctionCallNode methodsFor:'accessing'!

translatedSelector
    ^ javaScriptSelector ? selector
!

translatedSelector:stSelector
    javaScriptSelector := selector.
    selector := stSelector.
! !

!JavaScriptParser::FunctionCallNode methodsFor:'evaluation'!

evaluateCallIn:anEnvironment 
    |retVal r argValueArray sel value nargs "{Class: SmallInteger}"|

    sel := self evaluationSelector.
    sel numArgs > 0 ifTrue:[
        "the perform below would fail"
        ^ self evaluateIn:anEnvironment forCascade:false.
    ].
    r := receiver evaluateIn:anEnvironment.
    value := r perform:sel ifNotUnderstood:[^ self evaluateIn:anEnvironment forCascade:false].

    nargs := argArray size.
    (nargs == 0) ifTrue:[
        retVal := value value
    ] ifFalse:[
        argValueArray := Array new:nargs.
        1 to:nargs do:[:idx | argValueArray at:idx put:((argArray at:idx) evaluateIn:anEnvironment)].
        retVal := value valueWithReceiver:value arguments:argValueArray.
    ].

    ^ retVal

    "Created: / 06-12-2011 / 01:31:25 / cg"
!

evaluateIn:anEnvironment
    MessageNotUnderstood handle:[:ex |
        |sel msg|

        msg := ex parameter.
        sel := msg selector.
        (sel startsWith:'js_') ifTrue:[
            msg setSelector:(sel copyFrom:4) asSymbol.
            ^ msg sendTo:(ex receiver)
        ].
        ex reject.
    ] do:[
        receiver isSuper ifTrue:[
            ^ self evaluateIn:anEnvironment forCascade:false
        ].

        ^ self evaluateCallIn:anEnvironment 
    ].

    "Modified: / 06-12-2011 / 01:31:46 / cg"
!

evaluationSelector
    ^ (selector ? javaScriptSelector) asSymbol

    "Modified: / 20-04-2005 / 12:13:28 / cg"
!

javaScriptSelector:aSelector
    javaScriptSelector := aSelector
! !

!JavaScriptParser::FunctionCallNode methodsFor:'printing'!

printOn:aStream indent:i
    |first|

    receiver printOn:aStream indent:i.
    aStream nextPutAll:'.'.
    javaScriptSelector printOn:aStream.

    aStream nextPutAll:'('.

    argArray size > 0 ifTrue:[
        first := true.
        argArray do:[:arg |
            first ifTrue:[
                first := false.
            ] ifFalse:[
                aStream nextPutAll:', '.
            ].
            arg printOn:aStream indent:i.
        ].
    ].
    aStream nextPutAll:')'

    "Created: / 15.5.1998 / 14:16:04 / cg"
    "Modified: / 17.5.1998 / 21:31:37 / cg"
! !

!JavaScriptParser::FunctionCallNode methodsFor:'queries'!

isImplicit
    ^ false
! !

!JavaScriptParser::FunctionCallNode methodsFor:'testing'!

isUnaryMessage
    ^ self numArgs == 0
! !

!JavaScriptParser::FunctionCallNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitFunctionCallNode:self 
! !

!JavaScriptParser::IfStatementNode methodsFor:'accessing'!

condition
    ^ condition
!

condition:c ifStatements:i elseStatements:e
    condition := c.
    ifStatements := i.
    elseStatements := e.

    condition parent: self.
    ifStatements notNil ifTrue:[
        ifStatements parent: self.
    ].
    elseStatements notNil ifTrue:[
        elseStatements parent: self.
    ].

    "Created: / 15-05-1998 / 14:44:45 / cg"
    "Modified: / 20-09-2013 / 17:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

elseStatements
    ^ elseStatements
!

ifStatements
    ^ ifStatements
! !

!JavaScriptParser::IfStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    self codeOn:aStream inBlock:b for:aCompiler
!

codeOn:aStream inBlock:b for:aCompiler
    |jmpDeltaPos jmpJoinDeltaPos code|

    condition isNil ifTrue:[
        ^ self
    ].

    (aCompiler ensureBooleanExpression:condition)
        codeOn:aStream inBlock:b for:aCompiler.
    ifStatements isNil ifTrue:[
        elseStatements isNil ifTrue:[
            ^ self.
        ].
        aStream nextPut:#trueJump.
        jmpDeltaPos := aStream position + 1.
        aStream nextPut:0.
        elseStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.
        code := aStream contents.
        code at:jmpDeltaPos put:(aStream position + 1).
        ^ self.
    ].

    aStream nextPut:#falseJump.
    jmpDeltaPos := aStream position + 1.
    aStream nextPut:0.

    ifStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.

    elseStatements isNil ifTrue:[
        code := aStream contents.
        code at:jmpDeltaPos put:(aStream position + 1).
    ] ifFalse:[
        aStream nextPut:#jump.
        jmpJoinDeltaPos := aStream position + 1.
        aStream nextPut:0.
        code := aStream contents.
        code at:jmpDeltaPos put:(aStream position + 1).
        elseStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.
        code at:jmpJoinDeltaPos put:(aStream position + 1).
    ].

    "Modified: / 06-09-2007 / 13:54:59 / cg"
! !

!JavaScriptParser::IfStatementNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    condition allNodesDo:aBlock.
    ifStatements notNil ifTrue:[ ifStatements allNodesDo:aBlock ].
    elseStatements notNil ifTrue:[ elseStatements allNodesDo:aBlock ].
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    condition messageSelectorsDo:aBlock.
    ifStatements notNil ifTrue:[ ifStatements messageSelectorsDo:aBlock ].
    elseStatements notNil ifTrue:[ elseStatements messageSelectorsDo:aBlock ].
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    condition messagesDo:aBlock.
    ifStatements notNil ifTrue:[ ifStatements messagesDo:aBlock ].
    elseStatements notNil ifTrue:[ elseStatements messagesDo:aBlock ].
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    condition variableNodesDo:aBlock.
    ifStatements notNil ifTrue:[ ifStatements variableNodesDo:aBlock ].
    elseStatements notNil ifTrue:[ elseStatements variableNodesDo:aBlock ].
! !

!JavaScriptParser::IfStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    |cond stats|

    cond := condition evaluateIn:anEnvironment.
    cond == true ifTrue:[
        stats := ifStatements.
    ] ifFalse:[
        cond == false ifTrue:[
            stats := elseStatements.
        ] ifFalse:[
            NonBooleanReceiverError raiseRequestErrorString:'non-boolean in if-condition. Proceed for false'.
            stats := elseStatements.
        ]
    ].
    stats notNil ifTrue:[
        ^ stats evaluateIn:anEnvironment
    ].
    ^ nil

    "Created: / 16-05-1998 / 16:12:45 / cg"
    "Modified: / 16-05-1998 / 20:43:41 / cg"
    "Modified: / 27-08-2018 / 14:46:52 / Claus Gittinger"
! !

!JavaScriptParser::IfStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'if ('.
    condition printOn:aStream.
    aStream nextPutAll:') {'.
    aStream cr.
    ifStatements notEmptyOrNil ifTrue:[
        ifStatements printAllOn:aStream indent:i+4.
    ].
    elseStatements notEmptyOrNil ifTrue:[
        aStream cr; spaces:i; nextPutAll:'} else {'; cr.
        elseStatements printAllOn:aStream indent:i+4.
    ].
    aStream cr; spaces:i; nextPutAll:'}'; cr.

    "Created: / 15-05-1998 / 14:45:40 / cg"
    "Modified: / 24-09-2013 / 16:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::IfStatementNode methodsFor:'testing'!

isExpressionStatement
    ^ false
!

isIfStatement
    ^ true
! !

!JavaScriptParser::IfStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitIfStatementNode:self 
! !

!JavaScriptParser::ImplicitFunctionCallNode methodsFor:'code generation'!

codeStore:valueExpr on:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    "/
    "/ encountered if you code:
    "/  foo.x = expr
    "/ or:
    "/  foo.x += expr

    selector isUnary ifFalse:[ self error:'Cannot compile this assignment' ].

    ((MessageNode
            receiver:receiver
            selector:(selector , ':') asSymbol
            arg:valueExpr
    ) lineNumber:lineNr) 
        codeOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler.

    "Created: / 04-07-2010 / 14:36:35 / cg"
! !

!JavaScriptParser::ImplicitFunctionCallNode methodsFor:'queries'!

isImplicit
    ^ true
!

isImplicitJavaScriptMessage
    ^ true

    "Created: / 05-07-2010 / 14:11:11 / cg"
! !

!JavaScriptParser::ImplicitFunctionCallNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitImplicitFunctionCallNode:self 
! !

!JavaScriptParser::IncDecNode methodsFor:'accessing'!

isInc
    "return the value of the instance variable 'isInc' (automatically generated)"

    ^ isInc

    "Created: / 14.5.1998 / 22:15:20 / cg"
!

isInc:something
    "set the value of the instance variable 'isInc' (automatically generated)"

    isInc := something.

    "Created: / 14.5.1998 / 22:15:20 / cg"
!

lValue
    "return the value of the instance variable 'lValue' (automatically generated)"

    ^ lValue

    "Created: / 14.5.1998 / 22:15:17 / cg"
!

lValue:something
    "set the value of the instance variable 'lValue' (automatically generated)"

    lValue := something.
    lValue parent: self.

    "Created: / 14-05-1998 / 22:15:17 / cg"
    "Modified: / 20-09-2013 / 15:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::IncDecNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ^ self subclassResponsibility
! !

!JavaScriptParser::IncDecNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    lValue allNodesDo:aBlock.
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    lValue messageSelectorsDo:aBlock.
    isInc ifTrue:[
        aBlock value:#+
    ] ifFalse:[
        aBlock value:#-
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    lValue messagesDo:aBlock.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    lValue variableNodesDo:aBlock.
! !

!JavaScriptParser::IncDecNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    self subclassResponsibility

    "Created: / 26.10.1998 / 14:43:57 / cg"
! !

!JavaScriptParser::IncDecNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitIncDecNode:self 
! !

!JavaScriptParser::InnerJavaBlockNode methodsFor:'accessing'!

_argVariables
    ^ blockArgs
!

_localVariables
    ^ blockVars
!

_localVariables:aCollection
    blockVars := aCollection
!

_outerEnvironment
    ^ home
!

_topEnvironment
    ^ home isNil ifTrue:self ifFalse:[home _topEnvironment]
!

localVariables
    ^ self _localVariables
! !

!JavaScriptParser::InnerJavaBlockNode methodsFor:'queries'!

_isFunctionEnvironment
    ^ false

    "Modified: / 21-02-2007 / 11:51:57 / cg"
!

isInnerJavaScriptBlock
    ^ true
! !

!JavaScriptParser::InnerJavaBlockNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitInnerJavaBlockNode:self 
! !

!JavaScriptParser::JavaScriptAssignmentNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:codeBlock for:aCompiler
    variable isVariable ifTrue:[
        super codeForSideEffectOn:aStream inBlock:codeBlock for:aCompiler.
        ^ self.
    ].

    variable
        codeStore:expression
        on:aStream
        inBlock:codeBlock
        valueNeeded:false
        for:aCompiler
!

codeOn:aStream inBlock:b for:aCompiler
    variable isVariable ifTrue:[
        super codeOn:aStream inBlock:b for:aCompiler.
        ^ self.
    ].
    self error:'assignment to non-variables not yet supported'.

"/
"/    (self checkIncDecOn:aStream) ifTrue:[^ self].
"/
"/    self codeNormalOn:aStream valueNeeded:false inBlock:b for:aCompiler
"/

    "Modified: / 19-05-2010 / 16:03:26 / cg"
! !

!JavaScriptParser::JavaScriptAssignmentNode methodsFor:'printing'!

printOperatorOn:aStream
    aStream nextPutAll:' = '.
! !

!JavaScriptParser::JavaScriptAssignmentNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptAssignmentNode:self 
! !

!JavaScriptParser::JavaScriptBinaryNode methodsFor:'accessing'!

translatedSelector:stSelector
    javaScriptSelector := selector.
    selector := stSelector.
! !

!JavaScriptParser::JavaScriptBinaryNode methodsFor:'printing'!

printSelectorOn:aStream
    (javaScriptSelector ? selector) printString printOn:aStream.
! !

!JavaScriptParser::JavaScriptBinaryNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptBinaryNode:self 
! !

!JavaScriptParser::JavaScriptReturnNode methodsFor:'accessing'!

environmentToReturnFrom
    ^ environmentToReturnFrom

    "Created: / 19-05-2010 / 15:51:35 / cg"
!

environmentToReturnFrom:something
    environmentToReturnFrom := myHome := something.

    "Modified: / 19-05-2010 / 15:51:04 / cg"
! !

!JavaScriptParser::JavaScriptReturnNode methodsFor:'code generation'!

basicCodeOn:aStream inBlock:b for:aCompiler
    (environmentToReturnFrom isNil or:[environmentToReturnFrom == b]) ifTrue:[
        self codeLocalReturnOn:aStream inBlock:b for:aCompiler.
        ^ self.
    ].
    super basicCodeOn:aStream inBlock:b for:aCompiler.

    "Created: / 20-02-2007 / 18:18:52 / cg"
    "Modified: / 19-05-2010 / 15:50:18 / cg"
!

codeOn:aStream inBlock:b for:aCompiler
    (environmentToReturnFrom isNil or:[environmentToReturnFrom == b]) ifTrue:[
        self codeLocalReturnOn:aStream inBlock:b for:aCompiler.
        ^ self.
    ].
    super codeOn:aStream inBlock:b for:aCompiler

    "Modified: / 19-05-2010 / 15:50:34 / cg"
! !

!JavaScriptParser::JavaScriptReturnNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'return'.
    expression notNil ifTrue:[
        aStream nextPutAll:'('.
        expression printOn:aStream indent:i.
        aStream nextPutAll:')'.
    ].
    (environmentToReturnFrom notNil and:[environmentToReturnFrom functionName notNil]) ifTrue:[
        aStream nextPutAll:' from '.
        aStream nextPutAll:environmentToReturnFrom functionName.
    ].
    aStream nextPutAll:';'.

    "Created: / 15-05-1998 / 15:05:10 / cg"
    "Modified: / 19-05-2010 / 15:52:21 / cg"
! !

!JavaScriptParser::JavaScriptReturnNode methodsFor:'testing'!

isExpressionStatement
    ^ false
!

isJavaScriptReturnNode
    ^ true

    "Created: / 19-05-2010 / 15:14:40 / cg"
! !

!JavaScriptParser::JavaScriptReturnNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptReturnNode:self 
! !

!JavaScriptParser::AndExpressionNode methodsFor:'accessing'!

expression1
    ^ expression1
!

expression1:expression1Arg expression2:expression2Arg 
    expression1 := expression1Arg.
    expression2 := expression2Arg.

    expression1 parent: self.
    expression2 parent: self.

    startPosition := expression1 startPosition.
    endPosition := expression1 endPosition.

    "Modified: / 20-09-2013 / 17:09:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression2
    ^ expression2
! !

!JavaScriptParser::AndExpressionNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    self codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut: #drop.

    "Created: / 12-06-2018 / 12:24:40 / Claus Gittinger"
!

codeOn:aStream inBlock:b for:aCompiler
    |jmpDeltaPos code|

    (aCompiler ensureBooleanExpression:expression1)
        codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut: #dup.
    aStream nextPut: #falseJump.
    jmpDeltaPos := aStream position + 1.
    aStream nextPut:0.

    aStream nextPut: #drop.
    expression2 codeOn:aStream inBlock:b for:aCompiler.

    code := aStream contents.
    code at:jmpDeltaPos put:(aStream position + 1).
! !

!JavaScriptParser::AndExpressionNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    expression1 allNodesDo:aBlock.
    expression2 allNodesDo:aBlock.
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    expression1 messageSelectorsDo:aBlock.
    expression2 messageSelectorsDo:aBlock.
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    expression1 messagesDo:aBlock.
    expression2 messagesDo:aBlock.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    expression1 variableNodesDo:aBlock.
    expression2 variableNodesDo:aBlock.
! !

!JavaScriptParser::AndExpressionNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    ( expression1 evaluateIn:anEnvironment ) ifFalse:[
        ^ false
    ].
    ^ expression2 evaluateIn:anEnvironment
! !

!JavaScriptParser::AndExpressionNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'('.
    expression1 printOn:aStream.
    aStream nextPutAll:') && ('.
    expression2 printOn:aStream.
    aStream nextPutAll:')'.
! !

!JavaScriptParser::AndExpressionNode methodsFor:'testing'!

isJavaScriptAndExpression
    ^ true
! !

!JavaScriptParser::AndExpressionNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitAndExpressionNode:self 
! !

!JavaScriptParser::JavaScriptUnaryNode methodsFor:'accessing'!

translatedSelector:stSelector
    javaScriptSelector := selector.
    selector := stSelector.
! !

!JavaScriptParser::JavaScriptUnaryNode methodsFor:'printing'!

printOn:aStream indent:i
    |prefixOP|

    selector == #'js_not' ifTrue:[
        prefixOP := '!!'
    ] ifFalse:[
        selector == #'negated' ifTrue:[
            prefixOP := '-'
        ] ifFalse:[
            selector == #'bitInvert' ifTrue:[
                prefixOP := '~'
            ]
        ]
    ].
    prefixOP notNil ifTrue:[
        aStream nextPutAll:prefixOP.
        aStream nextPutAll:'('.
        receiver printOn:aStream indent:i.
        aStream nextPutAll:')'.
        ^ self.
    ].
    super printOn:aStream indent:i 
!

printSelectorOn:aStream
    (javaScriptSelector ? selector) printString printOn:aStream.
! !

!JavaScriptParser::NewNode methodsFor:'accessing'!

classOrFunc
    "return the value of the instance variable 'classOrFunc' (automatically generated)"

    ^ classOrFunc

    "Created: / 7.11.1998 / 12:11:49 / cg"
!

classOrFunc:something
    "set the value of the instance variable 'classOrFunc' (automatically generated)"

    classOrFunc := something.
    classOrFunc parent: self.

    "Created: / 07-11-1998 / 12:11:49 / cg"
    "Modified: / 20-09-2013 / 14:16:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dimension
    "return the value of the instance variable 'dimension' (automatically generated)"

    dimensions size ~~ 1 ifTrue:[
        self error:'multidimensional arrays no yet supported'
    ].
    ^ dimensions first

    "Created: / 07-11-1998 / 12:08:52 / cg"
    "Modified: / 19-05-2010 / 16:03:44 / cg"
!

dimension:something
    "set the value of the instance variable 'dimension' (automatically generated)"

    dimensions := Array with:something.

    "Created: / 7.11.1998 / 12:08:52 / cg"
!

dimensions
    ^ dimensions 
!

dimensions:dimensionsArg
    dimensions := dimensionsArg.
!

lineNumber
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
!

numberOfDimensions
    ^ dimensions size
! !

!JavaScriptParser::NewNode methodsFor:'compiling'!

codeOn:aStream inBlock:codeBlock for:aCompiler
    | newExpr numElements |

"/    classOrFunc isGlobal ifTrue:[
"/        dimensions size == 0 ifTrue:[
"/            (classOrFunc evaluate respondsTo:#'new') ifFalse:[
"/                self error:'bad new'.
"/            ]
"/        ] ifFalse:[
"/            (classOrFunc evaluate respondsTo:#'new:') ifFalse:[
"/                self error:'bad new()'.
"/            ]
"/        ]
"/    ].
    dimensions size == 1 ifTrue:[
        newExpr := MessageNode
                        receiver:classOrFunc
                        selector:(aCompiler commonTranslatedSelectorFor:#'new:')
                        arg:(dimensions first).
    ] ifFalse:[
        dimensions size == 0 ifTrue:[
            newExpr := JavaScriptParser::JavaScriptUnaryNode
                            receiver:classOrFunc
                            selector:(aCompiler commonTranslatedSelectorFor:#'new').
            newExpr lineNumber:lineNumber.
        ] ifFalse:[
            numElements := dimensions inject:1 into:[:prod :el | prod * el value].
            newExpr := MessageNode
                            receiver:classOrFunc
                            selector:(aCompiler commonTranslatedSelectorFor:#'new:')
                            arg:(ConstantNode type:#Integer value:numElements).
            newExpr lineNumber:lineNumber.
        ].
    ].

    newExpr lineNumber:lineNumber.
    newExpr codeOn:aStream inBlock:codeBlock for:aCompiler

    "Modified: / 28-06-2010 / 17:45:59 / cg"
    "Modified: / 26-03-2018 / 15:44:36 / stefan"
! !

!JavaScriptParser::NewNode methodsFor:'enumeration'!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

"/    dimensions size == 0 ifTrue:[
"/        aBlock value:#new
"/    ] ifFalse:[
"/        aBlock value:#new:
"/    ]
! !

!JavaScriptParser::NewNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |dim cls val|

    cls := classOrFunc evaluateIn:anEnvironment.
    cls isNil ifTrue:[
        self error:'no such class' mayProceed:true.
        ^ nil
    ].

    dimensions size == 1 ifTrue:[
        dim := dimensions first evaluateIn:anEnvironment.
        val := cls js_new:dim.
    ] ifFalse:[
        val := cls js_new.
    ].
    ^ val

    "Modified: / 7.11.1998 / 12:28:19 / cg"
! !

!JavaScriptParser::NewNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'new '.
    classOrFunc printOn:aStream indent:i.
    dimensions notEmptyOrNil ifTrue:[
        aStream nextPutAll:'('.
        dimensions 
            do:[:eachDim |
                eachDim printOn:aStream indent:i.
            ]
            separatedBy:[
                aStream nextPutAll:', '.
            ].
        aStream nextPutAll:')'.
    ].
! !

!JavaScriptParser::NewNode methodsFor:'testing'!

isNew
    ^ true
! !

!JavaScriptParser::NewNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitNewNode:self 
! !

!JavaScriptParser::OrExpressionNode methodsFor:'accessing'!

expression1
    ^ expression1
!

expression1:expression1Arg expression2:expression2Arg 
    expression1 := expression1Arg.
    expression2 := expression2Arg.

    expression1 parent: self.
    expression2 parent: self.

    startPosition := expression1 startPosition.
    endPosition := expression1 endPosition.

    "Modified: / 20-09-2013 / 17:10:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression2
    ^ expression2
! !

!JavaScriptParser::OrExpressionNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    self codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut: #drop.

    "Created: / 12-06-2018 / 12:24:51 / Claus Gittinger"
!

codeOn:aStream inBlock:b for:aCompiler
    |jmpDeltaPos code|

    (aCompiler ensureBooleanExpression:expression1)
        codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut: #dup.
    aStream nextPut: #trueJump.
    jmpDeltaPos := aStream position + 1.
    aStream nextPut:0.

    aStream nextPut: #drop.
    expression2 codeOn:aStream inBlock:b for:aCompiler.

    code := aStream contents.
    code at:jmpDeltaPos put:(aStream position + 1).
! !

!JavaScriptParser::OrExpressionNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    expression1 allNodesDo:aBlock.
    expression2 allNodesDo:aBlock.
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    expression1 messageSelectorsDo:aBlock.
    expression2 messageSelectorsDo:aBlock.
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    expression1 messagesDo:aBlock.
    expression2 messagesDo:aBlock.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    expression1 variableNodesDo:aBlock.
    expression2 variableNodesDo:aBlock.
! !

!JavaScriptParser::OrExpressionNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    ( expression1 evaluateIn:anEnvironment ) ifTrue:[
        ^ true
    ].
    ^ expression2 evaluateIn:anEnvironment
! !

!JavaScriptParser::OrExpressionNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'('.
    expression1 printOn:aStream.
    aStream nextPutAll:') || ('.
    expression2 printOn:aStream.
    aStream nextPutAll:')'.
! !

!JavaScriptParser::OrExpressionNode methodsFor:'testing'!

isJavaScriptOrExpression
    ^ true
! !

!JavaScriptParser::OrExpressionNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitOrExpressionNode:self 
! !

!JavaScriptParser::PostIncDecNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |code assignment const1 lValuePlus1|

    lValue isVariable ifFalse:[
        self breakPoint:#expecco
    ].

    lValue isMethodArg ifTrue:[
        self error.
    ].

    lValue isMethodVariable ifTrue:[
        isInc ifTrue:[
            code := #incMethodVar
        ] ifFalse:[
            code := #decMethodVar
        ].
        aStream nextPut:code; nextPut:(1 "expression lineNumber"); nextPut:(lValue index).
        ^ self
    ].

    assignment := JavaScriptParser::JavaScriptAssignmentNode new.
    const1 := ConstantNode type:#Integer value:1.
    lValuePlus1 := JavaScriptParser::JavaScriptBinaryNode receiver:lValue selector:#'+' arg:const1 fold:false.
    assignment variable:lValue expression:lValuePlus1.
    assignment codeForSideEffectOn:aStream inBlock:b for:aCompiler

    "Modified: / 19-05-2010 / 16:04:35 / cg"
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    |code|

    lValue isVariable ifFalse:[
        self breakPoint:#expecco
    ].

    lValue codeOn:aStream inBlock:codeBlock for:aCompiler.
    aStream nextPut:#dup.

    isInc ifTrue:[
        code := #plus1
    ] ifFalse:[
        code := #minus1
    ].
    aStream nextPut:code; nextPut:(lValue lineNumber).
    lValue codeStoreOn:aStream inBlock:codeBlock valueNeeded:false for:aCompiler.

    "Modified: / 19-05-2010 / 16:04:40 / cg"
! !

!JavaScriptParser::PostIncDecNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |val|

    val := lValue evaluateIn:anEnvironment.
    isInc ifTrue:[
        lValue store:(val + 1)
    ] ifFalse:[
        lValue store:(val - 1)
    ].
    ^ val

    "Created: / 18.5.1998 / 13:39:52 / cg"
    "Modified: / 18.5.1998 / 13:40:42 / cg"
! !

!JavaScriptParser::PostIncDecNode methodsFor:'printing'!

displayString
    ^ lValue displayString , (isInc ifTrue:'++' ifFalse:'--')
!

printOn:aStream indent:i
    lValue printOn:aStream indent:i.
    isInc ifTrue:[
        aStream nextPutAll:'++'
    ] ifFalse:[
        aStream nextPutAll:'--'
    ].

    "Created: / 14.5.1998 / 22:17:49 / cg"
! !

!JavaScriptParser::PostIncDecNode methodsFor:'testing'!

isPostIncDec
    ^ true
! !

!JavaScriptParser::PostIncDecNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitPostIncDecNode:self 
! !

!JavaScriptParser::PreIncDecNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |code|

    lValue isVariable ifFalse:[
        self breakPoint:#expecco
    ].

    lValue isMethodArg ifTrue:[
        self error.
    ].

    lValue isMethodVariable ifTrue:[
        isInc ifTrue:[
            code := #incMethodVar
        ] ifFalse:[
            code := #decMethodVar
        ].
        aStream nextPut:code; nextPut:(1 "expression lineNumber"); nextPut:(lValue index).
        ^ self
    ].
    self error:'only inc/dec for methodVariables supported'

    "Modified: / 19-05-2010 / 16:05:31 / cg"
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    |code|

    lValue isVariable ifFalse:[
        self breakPoint:#expecco
    ].

    lValue isMethodArg ifTrue:[
        self error:'method arguments are readOnly'
    ].

    lValue codeOn:aStream inBlock:codeBlock for:aCompiler.

    isInc ifTrue:[
        code := #plus1
    ] ifFalse:[
        code := #minus1
    ].
    aStream nextPut:code; nextPut:(1 "expression lineNumber").
    aStream nextPut:#dup.
    lValue codeStoreOn:aStream inBlock:codeBlock valueNeeded:false for:aCompiler.

    "Modified: / 19-05-2010 / 16:04:45 / cg"
! !

!JavaScriptParser::PreIncDecNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |val|

    val := lValue evaluateIn:anEnvironment.
    isInc ifTrue:[
        val := val + 1
    ] ifFalse:[
        val :=val - 1
    ].
    lValue store:val.
    ^ val

    "Created: / 18.5.1998 / 13:52:32 / cg"
! !

!JavaScriptParser::PreIncDecNode methodsFor:'printing'!

displayString
    ^ (isInc ifTrue:'++' ifFalse:'--') , lValue displayString 
!

printOn:aStream indent:i
    isInc ifTrue:[
        aStream nextPutAll:'++'
    ] ifFalse:[
        aStream nextPutAll:'--'
    ].
    lValue printOn:aStream indent:i

    "Created: / 14.5.1998 / 22:17:37 / cg"
! !

!JavaScriptParser::PreIncDecNode methodsFor:'testing'!

isPreIncDec
    ^ true
! !

!JavaScriptParser::PreIncDecNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitPreIncDecNode:self 
! !

!JavaScriptParser::StatementBlockNode methodsFor:'accessing'!

endPosition
    ^ statements notEmpty ifTrue:[ 
        statements last endPosition
    ] ifFalse:[
        endPosition
    ]

    "Created: / 20-09-2013 / 15:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startPosition
    ^ statements notEmpty ifTrue:[ 
        statements first startPosition
    ] ifFalse:[
        startPosition
    ]

    "Created: / 20-09-2013 / 15:03:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statements
    ^ statements
!

statements:something
    statements := something.
    statements do:[:each | each parent: self]

    "Modified: / 20-09-2013 / 14:19:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::StatementBlockNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    statements do:[:eachStatement |
        eachStatement codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ].
! !

!JavaScriptParser::StatementBlockNode methodsFor:'enumeration'!

allNodesDo:aBlock
    "evaluate aBlock for each node in this node and subnodes"

    aBlock value:self.
    self allSubNodesDo:aBlock
!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    statements notNil ifTrue:[
        statements do:[:each | each allNodesDo:aBlock].
    ]
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    statements notNil ifTrue:[
        statements do:[:each | each messageSelectorsDo:aBlock].
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    statements notNil ifTrue:[
        statements do:[:each | each messagesDo:aBlock].
    ]
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    statements notNil ifTrue:[
        statements do:[:each | each variableNodesDo:aBlock].
    ]
! !

!JavaScriptParser::StatementBlockNode methodsFor:'printing'!

printOn:aStream indent:i
    statements do:[:each |
        aStream spaces:i.
        each printOn:aStream indent:i.
        aStream nextPutAll:';'.
        aStream cr.
    ].
! !

!JavaScriptParser::StatementBlockNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitStatementBlockNode:self 
! !

!JavaScriptParser::SwitchStatementNode methodsFor:'accessing'!

statementBlocks
    ^ statementBlocks
!

switchExpression
    ^ switchExpression
!

switchExpression:switchExpressionArg statementBlocks:switchStatementBlocksArg 
    "set instance variables (automatically generated)"

    switchExpression := switchExpressionArg.
    switchExpression parent: self.

    statementBlocks := switchStatementBlocksArg.
    self caseValuesAndStatementsDo:[:caseValue :statementBlock |
        caseValue notNil ifTrue:[
            caseValue parent: self.
        ].
        statementBlock isCollection ifTrue:[
            statementBlock do:[:each | each parent: self ].
        ] ifFalse:[
            statementBlock parent: self.
        ]
    ].

    "Modified: / 23-09-2013 / 11:08:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::SwitchStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "/ for now, generate a naive if-then-else cascade comparing each value in sequence.
    "/ ToDo:
    "/    binary compare (log-n tests)
    "/ and finally:
    "/    VM change to support a switch-table and switch-jump

    |defaultStatementBlock jumpPositionPerStatementBlock switchDescription|

    jumpPositionPerStatementBlock := IdentityDictionary new.

    switchExpression codeOn:aStream inBlock:b for:aCompiler.
    self caseValuesAndStatementsDo:[:caseValue :statementBlock |
        caseValue isNil ifTrue:[
            defaultStatementBlock := statementBlock.
        ] ifFalse:[
            aStream nextPut:#dup.
            caseValue codeOn:aStream inBlock:b for:aCompiler.
            aStream nextPut:#=.
            aStream nextPut:(lineNr ? 0).
            aStream nextPut:#trueJump.
            jumpPositionPerStatementBlock at:statementBlock put:(aStream position + 1).
            aStream nextPut:0.
        ].
    ].
    aStream nextPut:#drop.
    switchDescription := aCompiler newSwitchDescription.

    defaultStatementBlock isNil ifTrue:[
        aStream nextPut:#jump.
        switchDescription rememberToBackPatchForBreak:(aStream position + 1).
        aStream nextPut:0.
    ] ifFalse:[
        defaultStatementBlock ~~ statementBlocks first value ifTrue:[
            aStream nextPut:#jump.
            jumpPositionPerStatementBlock at:defaultStatementBlock put:(aStream position + 1).
            aStream nextPut:0.
        ].
    ].

    aCompiler pushLoopDescription:switchDescription.

    self caseValuesAndStatementsDo:[:caseValue :statementBlock |
        |jumpPos|

        jumpPos := jumpPositionPerStatementBlock at:statementBlock ifAbsent:nil.
        jumpPos notNil ifTrue:[
            aStream contents at:jumpPos put:(aStream position + 1).
        ].
        statementBlock do:[:eachStatement |
            eachStatement codeForSideEffectOn:aStream inBlock:b for:aCompiler
        ].
    ].

    aCompiler popLoopDescription.
    switchDescription patchBreaksTo:(aStream position + 1) in:aStream.

    "Modified (comment): / 12-06-2018 / 12:26:19 / Claus Gittinger"
! !

!JavaScriptParser::SwitchStatementNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    switchExpression allNodesDo:aBlock.
    statementBlocks notNil ifTrue:[
        self caseValuesAndStatementsDo:[:caseValue :statementBlock |
            caseValue notNil ifTrue:[
                caseValue allNodesDo:aBlock.
            ].
            "/ temporary hack
            statementBlock isCollection ifTrue:[
                statementBlock do:[:stat | stat allNodesDo:aBlock].
            ] ifFalse:[
                statementBlock allNodesDo:aBlock.
            ].
        ].
    ]
!

caseValuesAndStatementsDo:aTwoArgBlock
    statementBlocks do:[:eachBlockSpec |
        |caseValue statementBlock|

        caseValue := eachBlockSpec key.
        statementBlock := eachBlockSpec value.
        aTwoArgBlock value:caseValue value:statementBlock
    ].
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    switchExpression messageSelectorsDo:aBlock.
    statementBlocks notNil ifTrue:[
        self caseValuesAndStatementsDo:[:caseValue :statementBlock |
            caseValue notNil ifTrue:[
                caseValue messageSelectorsDo:aBlock.
            ].
            "/ temporary hack
            statementBlock isCollection ifTrue:[
                statementBlock do:[:stat | stat messageSelectorsDo:aBlock].
            ] ifFalse:[
                statementBlock messageSelectorsDo:aBlock.
            ].
        ].
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    switchExpression messagesDo:aBlock.
    statementBlocks notNil ifTrue:[
        self caseValuesAndStatementsDo:[:caseValue :statementBlock |
            caseValue notNil ifTrue:[
                caseValue messagesDo:aBlock.
            ].
            "/ temporary hack
            statementBlock isCollection ifTrue:[
                statementBlock do:[:stat | stat messagesDo:aBlock].
            ] ifFalse:[
                statementBlock messagesDo:aBlock.
            ].
        ].
    ]
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    switchExpression variableNodesDo:aBlock.
    statementBlocks notNil ifTrue:[
        self caseValuesAndStatementsDo:[:caseValue :statementBlock |
            caseValue notNil ifTrue:[
                caseValue variableNodesDo:aBlock.
            ].
            "/ temporary hack
            statementBlock isCollection ifTrue:[
                statementBlock do:[:stat | stat variableNodesDo:aBlock].
            ] ifFalse:[
                statementBlock variableNodesDo:aBlock.
            ].
        ].
    ]
! !

!JavaScriptParser::SwitchStatementNode methodsFor:'testing'!

isExpressionStatement
    ^ false
! !

!JavaScriptParser::SwitchStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitSwitchStatementNode:self 
! !

!JavaScriptParser::ThisNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'this'

    "Created: / 15.5.1998 / 14:25:57 / cg"
! !

!JavaScriptParser::ThisNode methodsFor:'testing'!

isThis
    ^ true
! !

!JavaScriptParser::ThisNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitThisNode:self 
! !

!JavaScriptParser::ThrowStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |node|

    expression isNew ifTrue:[
        node := JavaScriptParser::JavaScriptUnaryNode
                    receiver:expression
                    selector:#'raiseRequest'.
    ] ifFalse:[
        node := MessageNode
                    receiver:(VariableNode globalNamed:'Error')
                    selector:#'raiseRequestWith:'
                    arg:expression.
    ].
    node lineNumber:lineNr.
    node codeForSideEffectOn:aStream inBlock:b for:aCompiler

    "Modified: / 28-06-2010 / 18:35:39 / cg"
    "Modified: / 26-03-2018 / 15:27:25 / stefan"
! !

!JavaScriptParser::ThrowStatementNode methodsFor:'enumeration'!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    expression isNew ifTrue:[
        aBlock value:#'raiseRequest'.
    ] ifFalse:[
        aBlock value:#'raiseRequestWith:'.
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    super messagesDo:aBlock.

    "/ mhmh - we ought to generate a messageNode for myself
    "/ and call aBlock with it; or else, call the block with myself as arg.
    "/ (not done yet: needs more protocol)
    "/ aBlock value:self.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

"/    expression isNew ifTrue:[
"/        aBlock value:#'raiseRequest'.
"/    ] ifFalse:[
"/        aBlock value:#'raiseRequestWith:'.
"/    ]
! !

!JavaScriptParser::ThrowStatementNode methodsFor:'testing'!

isThrowStatement
    ^ true
! !

!JavaScriptParser::ThrowStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitThrowStatementNode:self 
! !

!JavaScriptParser::TryCatchStatementNode methodsFor:'accessing'!

catchBlock
    ^ catchBlock
!

errorExpression
    ^ errorExpression
!

finallyBlock
    ^ finallyBlock
!

finallyBlock:something
    finallyBlock := something.
    finallyBlock parent: self.

    "Modified: / 23-09-2013 / 10:49:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tryBlock
    ^ tryBlock
!

tryBlock:tryBlockArg errorExpression:errorExpressionArg catchBlock:catchBlockArg 
    tryBlock := tryBlockArg.
    tryBlock parent: self.

    errorExpression := errorExpressionArg.
    errorExpression parent: self.

    catchBlock := catchBlockArg.
    catchBlock parent: self.

    "Modified: / 23-09-2013 / 10:49:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tryBlock:tryBlockArg finallyBlock:finallyBlockArg 
    tryBlock := tryBlockArg.
    tryBlock parent: self.

    finallyBlock := finallyBlockArg.
    finallyBlock parent: self.

    "Modified: / 23-09-2013 / 10:49:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::TryCatchStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |node|

    catchBlock isNil ifTrue:[
        "/ a try...finally 
        "/  -> [ ... ] ensure:[...]
        node := MessageNode
                        receiver:tryBlock
                        selector:#'ensure:'
                        args:(Array with:finallyBlock).
        node lineNumber:lineNr.
        node codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ] ifFalse:[
        finallyBlock isNil ifTrue:[
            "/ a try...catch 
            "/  -> [ ... ] on:Err do:[...]
            node := MessageNode
                            receiver:tryBlock
                            selector:#'on:do:'
                            args:(Array with:errorExpression with:catchBlock).
        ] ifFalse:[
            "/ a try...catch...finally
            "/  -> [ ... ] on:Err do:[...] ensure:[...]
            node := MessageNode
                            receiver:tryBlock
                            selector:#'on:do:ensure:'
                            args:(Array with:errorExpression with:catchBlock with:finallyBlock).
        ]
    ].

    node lineNumber:lineNr.
    node codeForSideEffectOn:aStream inBlock:b for:aCompiler
! !

!JavaScriptParser::TryCatchStatementNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    tryBlock notNil ifTrue:[ tryBlock allNodesDo:aBlock ].
    catchBlock notNil ifTrue:[ catchBlock allNodesDo:aBlock ].
    finallyBlock notNil ifTrue:[ finallyBlock allNodesDo:aBlock ].
    errorExpression notNil ifTrue:[ errorExpression allNodesDo:aBlock ].
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    catchBlock isNil ifTrue:[
        aBlock value:#'ensure:'.
    ] ifFalse:[
        finallyBlock isNil ifTrue:[
            aBlock value:#'on:do:'.
        ] ifFalse:[
            aBlock value:#'on:do:ensure:'.
        ]
    ]
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    tryBlock notNil ifTrue:[ tryBlock messagesDo:aBlock ].
    catchBlock notNil ifTrue:[ catchBlock messagesDo:aBlock ].
    finallyBlock notNil ifTrue:[ finallyBlock messagesDo:aBlock ].
    errorExpression notNil ifTrue:[ errorExpression messagesDo:aBlock ].

    "/ mhmh - we ought to generate a messageNode for myself
    "/ and call aBlock with it; or else, call the block with myself as arg.
    "/ (not done yet: needs more protocol)
    "/ aBlock value:self.
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    tryBlock notNil ifTrue:[ tryBlock variableNodesDo:aBlock ].
    catchBlock notNil ifTrue:[ catchBlock variableNodesDo:aBlock ].
    finallyBlock notNil ifTrue:[ finallyBlock variableNodesDo:aBlock ].
    errorExpression notNil ifTrue:[ errorExpression variableNodesDo:aBlock ].
! !

!JavaScriptParser::TryCatchStatementNode methodsFor:'testing'!

isExpressionStatement
    ^ false
!

isTryCatchFinallyStatement
    ^ catchBlock notNil and:[finallyBlock notNil]

    "Created: / 27-08-2018 / 13:00:00 / Claus Gittinger"
!

isTryCatchStatement
    ^ finallyBlock isNil
!

isTryFinallyStatement
    ^ catchBlock isNil
! !

!JavaScriptParser::TryCatchStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitTryCatchStatementNode:self 
! !

!JavaScriptParser::TypeOfNode methodsFor:'accessing'!

expression
    ^ expression
!

expression:something
    expression := something.
    expression parent: self.

    "Modified: / 23-09-2013 / 10:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
! !

!JavaScriptParser::TypeOfNode methodsFor:'compiling'!

codeOn:aStream inBlock:codeBlock for:aCompiler
    | newExpr |

    newExpr := UnaryNode
                    receiver:expression
                    selector:#'typeof'.

    newExpr lineNumber:lineNumber.
    newExpr codeOn:aStream inBlock:codeBlock for:aCompiler

    "Modified: / 19-05-2010 / 12:58:12 / cg"
! !

!JavaScriptParser::TypeOfNode methodsFor:'enumeration'!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    aBlock value:#'typeof'.
! !

!JavaScriptParser::TypeOfNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    ^ (expression evaluateIn:anEnvironment) typeof 
! !

!JavaScriptParser::TypeOfNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitTypeOfNode:self 
! !

!JavaScriptParser::WhileStatementNode methodsFor:'accessing'!

condition
    "return the value of the instance variable 'condition' (automatically generated)"

    ^ condition

    "Created: / 15.5.1998 / 14:36:13 / cg"
!

condition:something
    "set the value of the instance variable 'condition' (automatically generated)"

    condition := something.
    condition parent: self.

    "Created: / 15-05-1998 / 14:36:13 / cg"
    "Modified: / 23-09-2013 / 10:35:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

condition:c loopStatements:l
    self condition: c.
    self loopStatements: l

    "Created: / 15-05-1998 / 14:40:02 / cg"
    "Modified: / 23-09-2013 / 10:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loopStatements
    "return the value of the instance variable 'loopStatements' (automatically generated)"

    ^ loopStatements

    "Created: / 15.5.1998 / 14:36:15 / cg"
!

loopStatements:something
    "set the value of the instance variable 'loopStatements' (automatically generated)"

    loopStatements := something.
    loopStatements notNil ifTrue:[ 
        loopStatements parent: self
    ]

    "Created: / 15-05-1998 / 14:36:15 / cg"
    "Modified: / 17-09-2014 / 14:54:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParser::WhileStatementNode methodsFor:'compiling'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |loopDescription condVal checkDeltaPos loopPos code|

    loopDescription := aCompiler newLoopDescription.

    condition isConstant ifTrue:[
        condVal := condition evaluate.
    ].
    condVal == false ifTrue:[
        "/ always false: no code at all
        ^ self.
    ].
    condVal == true ifTrue:[
        "/ always true:
        loopDescription continueLabel:aStream position + 1.
    ] ifFalse:[
        aStream nextPut:#jump.
        checkDeltaPos := aStream position + 1.
        aStream nextPut:0.
    ].

    loopPos := aStream position + 1.
    loopStatements notNil ifTrue:[
        aCompiler pushLoopDescription:loopDescription.
        loopStatements codeAllForSideEffectOn:aStream inBlock:b for:aCompiler.
        aCompiler popLoopDescription.
    ].
    checkDeltaPos isNil ifTrue:[
        aStream nextPut:#jump.
        aStream nextPut:loopPos.
    ] ifFalse:[
        code := aStream contents.
        code at:checkDeltaPos put:(aStream position + 1).

        loopDescription patchContinuesTo:(aStream position + 1) in:aStream.

        (aCompiler ensureBooleanExpression:condition)
            codeOn:aStream inBlock:b for:aCompiler.

        aStream nextPut:#trueJump.
        aStream nextPut:loopPos.
    ].
    loopDescription patchBreaksTo:(aStream position + 1) in:aStream.
! !

!JavaScriptParser::WhileStatementNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    condition allNodesDo:aBlock.
    loopStatements notNil ifTrue:[ loopStatements allNodesDo:aBlock ].
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    condition messageSelectorsDo:aBlock.
    loopStatements notNil ifTrue:[ loopStatements messageSelectorsDo:aBlock ].
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    condition messagesDo:aBlock.
    loopStatements notNil ifTrue:[ loopStatements messagesDo:aBlock ].
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    condition variableNodesDo:aBlock.
    loopStatements notNil ifTrue:[ loopStatements variableNodesDo:aBlock ].
! !

!JavaScriptParser::WhileStatementNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    |cond|

    [true] whileTrue:[
        JavaScriptParser::ContinueStatementNode continueSignal handle:[:ex |
            ex return
        ] do:[
            cond := condition evaluateIn:anEnvironment.
            cond == false ifTrue:[
                ^ nil
            ].
            cond ~~ true ifTrue:[
                NonBooleanReceiverError raiseRequestErrorString:'non-boolean in while-condition. Proceed for false'.
                ^ nil.
            ].
            loopStatements notNil ifTrue:[
                JavaScriptParser::BreakStatementNode breakSignal handle:[:ex |
                    ^ self
                ] do:[
                    loopStatements evaluateIn:anEnvironment
                ].
            ].
        ].
    ].
    ^ nil

    "Created: / 16-05-1998 / 16:12:45 / cg"
    "Modified: / 26-10-1998 / 15:28:01 / cg"
    "Modified: / 27-08-2018 / 14:49:27 / Claus Gittinger"
! !

!JavaScriptParser::WhileStatementNode methodsFor:'printing'!

printOn:aStream indent:i
    aStream nextPutAll:'while ('.
    condition printOn:aStream.
    aStream nextPutAll:') {'.
    aStream cr.
    loopStatements printAllOn:aStream indent:i+4.
    aStream cr; spaces:i; nextPutAll:'}'; cr.

    "Created: / 15.5.1998 / 14:38:15 / cg"
    "Modified: / 15.5.1998 / 14:40:46 / cg"
! !

!JavaScriptParser::WhileStatementNode methodsFor:'testing'!

isExpressionStatement
    ^ false
!

isWhileStatement
    ^ true
! !

!JavaScriptParser::WhileStatementNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitWhileStatementNode:self 
! !

!JavaScriptParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParser.st,v 1.300 2018-08-31 10:56:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParser.st,v 1.300 2018-08-31 10:56:20 cg Exp $'
! !


JavaScriptParser initialize!
JavaScriptParser::BreakStatementNode initialize!
JavaScriptParser::ContinueStatementNode initialize!
