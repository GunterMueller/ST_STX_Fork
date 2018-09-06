"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCTokenizingTest
	instanceVariableNames:'parser result context node id node2 id2 id1 node1 node3 options
		compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Tokenizing'
!

!PPCTokenizingTest methodsFor:'as yet unclassified'!

assert: p parse: whatever
    ^ result := super assert: p parse: whatever.
!

assert: p parse: whatever end: end
    ^ result := super assert: p parse: whatever end: end
!

cleanClass
    | parserClass scannerClass |
    parserClass := (Smalltalk at: options parserName ifAbsent: [nil]).
    parserClass notNil ifTrue:[ 
        parserClass removeFromSystem
    ].

    scannerClass := (Smalltalk at: options scannerName ifAbsent: [nil]).
    scannerClass notNil ifTrue:[ 
        scannerClass removeFromSystem
    ].

    "Modified: / 24-07-2015 / 19:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

context	
    ^ context := PPCProfilingContext new
!

parse: whatever
    ^ result := super parse: whatever.
!

setUp
    options := (PPCCompilationOptions new)
            profile:true;
            tokenize:true;
            yourself.
    compiler := PPCCompiler new.
    compiler context options:options.
    self cleanClass.

    "Modified: / 07-09-2015 / 10:22:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "self cleanClass"
!

testChoice
    | p1 p2 a1 a2 |
    a1 := 'a' asParser token name: 't1'; yourself.
    a2 := 'b' asParser token name: 't2'; yourself.
    
    p1 := a1 star.
    p2 := a2.
    
    parser := compiler compile: (p1 / p2).

    self assert: parser parse: ''.
    self assert: result isEmpty.
    
    self assert: parser parse: 'a'.
    self assert: result first inputValue = 'a'.

    self assert: parser parse: 'aa'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'a'.

    self assert: parser parse: 'b' end: 0.
    self assert: result isEmpty.

    self assert: parser parse: 'c' end: 0.
    
!

testChoiceOrder
    parser := compiler compile: (('a' asParser token , 'b' asParser token) / 'a' asParser token).

    
    self assert: parser parse: 'ab'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'b'.

    self assert: parser parse: 'a'.
    self assert: result inputValue = 'a'.

    self assert: parser fail: '_'.

    "Modified: / 07-09-2015 / 12:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testChoiceOrder2
    | p1 p2 |
    p1 := 'a' asParser token, 'b' asParser token.
    p2 := 'b' asParser token / 'a' asParser token.
    
    parser := compiler compile: (p1 / p2).
    
    self assert: parser parse: 'ab'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'b'.

    self assert: parser parse: 'a'.
    self assert: result inputValue = 'a'.

    self assert: parser parse: 'b'.
    self assert: result inputValue = 'b'.

    self assert: parser fail: 'c'.
    
!

testChoiceOrder3
    | p1 p2 a1 a2 |
    a1 := 'a' asParser token name: 't1'; yourself.
    a2 := 'a' asParser token name: 't2'; yourself.
    
    p1 := a1, 'b' asParser token.
    p2 := a2.
    
    parser := compiler compile: (p1 / p2).
    
    self assert: parser parse: 'ab'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'b'.

    self assert: parser parse: 'a'.
    self assert: result inputValue = 'a'.

    self assert: parser fail: 'b'.
    
!

testChoiceOrder4
    | p1 p2 a1 a2 |
    a1 := 'a' asParser token name: 't1'; yourself.
    a2 := 'a' asParser token name: 't2'; yourself.
    
    p1 := a1, 'b' asParser token.
    p2 := 'b' asParser token / a2.
    
    parser := compiler compile: (p1 / p2).
    
    self assert: parser parse: 'ab'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'b'.

    self assert: parser parse: 'a'.
    self assert: result inputValue = 'a'.

    self assert: parser parse: 'b'.
    self assert: result inputValue = 'b'.

    self assert: parser fail: 'c'.
    
!

testCompileAnd
    parser := compiler compile:(('foo' asParser token and) / ('bar' asParser token and)) 
                    , 'bar' asParser token.
    
    self assert: parser parse: 'bar'.
    self assert: result second inputValue = 'bar'.

    "Modified: / 07-09-2015 / 12:36:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileChoice
    parser := compiler compile: ('foo' asParser / 'bar' asParser) token.

    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.
    self assert: parser fail: '_'.

    "Modified: / 07-09-2015 / 12:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileChoice2
    parser := compiler compile:('foo' asParser token trim / 'bar' asParser token trim).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.
    self assert: parser fail: '_'.

    "Modified: / 07-09-2015 / 12:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileComplex1
    parser := compiler compile: ('foo' asParser token , 'bar' asParser token) 
                    / ('foo' asParser token , 'baz' asParser token).
    
    self assert: parser parse: 'foobar'.
    self assert: result second inputValue = 'bar'.

    self assert: parser parse: 'foobaz'.
    self assert: result second inputValue = 'baz'.

    self assert: parser fail: 'foobaq'.

    "Modified: / 07-09-2015 / 12:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileComplex2
    parser := compiler compile:('foo' asParser token , 'bar' asParser token) star , 'foo' asParser token.
    
    self assert: parser parse: 'foobarfoobarfoo'.
    self assert: parser parse: 'foo'.

    self assert: parser fail: 'bar'.

    "Modified: / 07-09-2015 / 12:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileComplex3
    parser := compiler compile: (('foo' asParser token , 'bar' asParser token) star , 'foo' asParser token) 
                    / ('foo' asParser token , 'baz' asParser token).

    
    self assert: parser parse: 'foobarfoobarfoo'.
    self assert: parser parse: 'foo'.

    self assert: parser fail: 'bar'.

    "Modified: / 07-09-2015 / 12:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileEmptytoken
    | start stop epsilon |
    start := $( asParser token.
    stop := $) asParser token.
    epsilon := '' asParser token.
    
    self should: [
        compiler compile: (start , epsilon , stop)
    ] raise: Exception.
"       
    self assert: parser parse: '()'.
    self assert: parser fail: '('.
"

    "Modified: / 07-09-2015 / 12:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileLiteral
    parser := compiler compile: ('foo' asParser token).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser fail: 'boo'.
!

testCompileSequence
    parser := compiler compile: ('foo' asParser token) , ('bar' asParser token).

    
    self assert: parser parse: 'foobar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.

    "Modified: / 07-09-2015 / 12:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileSequence2
    parser := compiler compile: ('foo' asParser trimmingToken) , ('bar' asParser trimmingToken).

    
    self assert: parser parse: 'foobar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.

    self assert: parser parse: 'foo  bar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.

    self assert: parser parse: '  foo  bar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.

    "Modified: / 07-09-2015 / 12:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileSequence3
    parser :=   compiler compile: ('foo' asParser trimmingToken) , ('bar' asParser trimmingToken) 
                     , ('baz' asParser trimmingToken).
    
    self assert: parser parse: 'foobarbaz'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.

    self assert: parser parse: ' foo  bar  baz  '.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.
    self assert: result third inputValue = 'baz'.

    "Modified: / 07-09-2015 / 12:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileStar
    parser := compiler compile: ('foo' asParser token star).
    
    self assert: parser parse: 'foo'.
    self assert: result first inputValue = 'foo'.
    
    self assert: parser parse: 'boo' end: 0.
    self assert: result isEmpty.
!

testCompileStar2
    parser := compiler compile: ('foo' asParser token , 'bar' asParser token) star.

    
    self assert: parser parse: 'foobar'.
    self assert: context tokenReads size = 1.
            
    self assert: parser parse: 'bar' end: 0.
    self assert: result isEmpty.
    self assert: context tokenReads size = 1.

    "Modified: / 07-09-2015 / 12:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileStar3
    parser := compiler compile: ('a' asParser trimmingToken star , 'b' asParser trimmingToken).

    
    self assert: parser parse: 'ab'.
    self assert: parser parse: 'aaab'.
    self assert: result size = 2.
    self assert: result first size = 3.
            
    self assert: parser fail: 'ac'.

    "Modified: / 07-09-2015 / 12:39:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileTokenComplex2
    |  a b optionsWith  |
    "based on the PPSmalltlakGrammar>>blockArgumentsWith"
    a := $| asParser smalltalkToken
        yourself.
    b := $] asParser smalltalkToken
        yourself.		
    optionsWith := (a / b and ==> [:t | ]) wrapped
        name: 'optionsWith'; 
        yourself.

    parser := compiler compile: (optionsWith).
    self assert: parser parse: '|'.

    self assert: parser parse: ']' end: 0.
!

testCompileTokenComplex3
    | choice1 choice2 a1 b1 a2 b2 tricky |
    a1 := $| asParser token
        yourself.
    b1 := $] asParser token
        yourself.		
    choice1 := (a1 / b1) wrapped
        name: 'choice1'; 
        yourself.

    a2 := $| asParser token
        yourself.
    b2 := $] asParser token
        yourself.		
    choice2 := (a2 / b2) wrapped
        name: 'choice1'; 
        yourself.
    
    tricky := (a1 asParser, choice1) / (b2 asParser, choice2).

    parser := compiler compile: (tricky).
    self assert: parser parse: '||'.

    self assert: parser parse: '|]'.

    self assert: parser parse: ']|'.

    self assert: parser parse: ']]'.
!

testCompileTokenComplex4
    |  symbol symbolLiteralArray symbolLiteral arrayItem  arrayLiteral |
    "based on symbolLiteral symbolLiteralArray in SmalltalkGrammar"

    symbol := PPDelegateParser new.
    symbol setParser: 'foo' asParser.
    symbol name: 'symbol'.
    
    symbolLiteralArray := PPDelegateParser new.
    symbolLiteralArray setParser: symbol token.
    symbolLiteralArray name: 'symbolLiteralArray'.
    
    symbolLiteral := PPDelegateParser new.
    symbolLiteral setParser: $# asParser token, symbol token ==> [:e | e isNil. e ].
    "                                                                  ^^^^^^^ "    
    " This is here to trick Smalltalk/X JIT optimizer which would create
      a __shared__ arg0-returning block. Because it is __shared__ it won't
      have a sourceposition filled and hence the inlining would fail.
      Sigh, there must be a better solution..."
    symbolLiteral name: 'symbolLiteral'.
    
    arrayLiteral := PPDelegateParser new.
    arrayLiteral setParser: '#(' asParser token, symbolLiteralArray, ')' asParser token.
    arrayLiteral name: 'arrayLiteral'.

    arrayItem := arrayLiteral / symbolLiteral.

    parser := compiler compile: (arrayItem).

    self assert: parser parse: '#(foo)'.
    self assert: parser parse: '#foo'.

    "Modified (comment): / 17-08-2015 / 23:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileTrim
    parser := compiler compile: ('foo' asParser token trim end).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    self assert: parser parse: 'foo  '.
    self assert: result inputValue = 'foo'.


    self assert: parser parse: '  foo'.
    self assert: result inputValue = 'foo'.

    self assert: parser parse: '  foo   '.
    self assert: result inputValue = 'foo'.

    self assert: parser fail: 'boo'.
!

testTokenCharacter
    | token |
    token := $a asParser token.
    parser := compiler compile: (token plus).

    self assert: parser parse: 'a'.
    self assert: result first inputValue = 'a'.
    self assert: context tokenReads size = 1.

    self flag: 'add the assertion here?'.
"	self assert: context invocations size = 5."
!

testTokenCharacter2
    | token |
    token := $a asParser token.
    parser := compiler compile: (token plus).

    self assert: parser parse: 'aaa'.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'a'.
    self assert: result third inputValue = 'a'.
    
    self assert: context tokenReads size = 1.
    self flag: 'Add the assertion here?'.
"	self assert: context invocations size = 7."
!

testTokenName
    | token |
    token := 'foo' asParser token name: 'fooToken'; yourself.
    parser := compiler compile: (token plus).

    self assert: parser parse: 'foofoo'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'foo'.
    self assert: (parser scanner class methodDictionary includesKey: #fooToken).
    self assert: (parser scanner class methodDictionary includesKey: #scan_fooToken).
!

testWhitespace
    | token ws trimmingToken |

    compiler removePass: PPCInliningVisitor.    
    token := 'foo' asParser token.
    ws := #blank asParser star name: 'consumeWhitespace'; yourself.
    trimmingToken := ((ws, token, ws) ==> #second) 
        propertyAt: 'trimmingToken' put: true; 
        yourself.
    
    parser := compiler compile: (trimmingToken plus).

    self assert: parser parse: ' foo '.
    self assert: result first inputValue = 'foo'.

    self assert: (context invocations select: [:e | e = #scan_consumeWhitespace ]) size = 3.

    "Modified: / 04-09-2015 / 15:02:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWhitespace2
    | token ws trimmingToken |

    compiler removePass: PPCInliningVisitor.    
    token := 'foo' asParser token.
    ws := #blank asParser star name: 'consumeWhitespace'; yourself.
    trimmingToken := ((ws, token, ws) ==> #second) 
        propertyAt: 'trimmingToken' put: true; 
        yourself.
    
    parser := compiler compile: (trimmingToken plus).

    self assert: parser parse: ' foo foo '.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'foo'.

    self assert: (context invocations select: [:e | e = #scan_consumeWhitespace ]) size = 4.

    "Modified: / 04-09-2015 / 15:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWhitespace3
    | token ws trimmingToken |

    compiler removePass: PPCInliningVisitor.    
    token := 'foo' asParser token.
    ws := #blank asParser star name: 'consumeWhitespace'; yourself.
    trimmingToken := ((ws, token, ws) ==> #second) 
        propertyAt: 'trimmingToken' put: true; 
        yourself.
    
    parser := compiler compile: (trimmingToken plus).

    self assert: parser parse: ' foo  foo  foo  '.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'foo'.
    self assert: result third inputValue = 'foo'.

    self assert: (context invocations select: [:e | e = #scan_consumeWhitespace ]) size = 5.

    "Modified: / 04-09-2015 / 15:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

