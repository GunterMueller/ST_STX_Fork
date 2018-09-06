"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCUniversalTest
	instanceVariableNames:'parser result context node compiler id node2 id2 id1 node1 node3
		options'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Universal'
!


!PPCUniversalTest methodsFor:'context'!

context	
    ^ context := PPCProfilingContext new
! !

!PPCUniversalTest methodsFor:'test support'!

assert: p parse: whatever
    ^ result := super assert: p parse: whatever.
!

parse: whatever
    ^ result := super parse: whatever.
!

tearDown
    | parserClass |

    parserClass := (Smalltalk at: options parserName ifAbsent: [nil]).
    parserClass notNil ifTrue:[ 
        "parserClass removeFromSystem"
    ].

    "Modified: / 24-07-2015 / 19:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCUniversalTest methodsFor:'tests - compiling'!

testCompileAnd
    parser := compiler compile: (#digit asParser and).
    
    self assert: parser parse: '1' to: $1 end: 0.
    self assert: parser fail: 'a'.
    self assert: parser fail: ''.

    parser := ('foo' asParser, ($: asParser and)) compile.
    self assert: parser parse: 'foo:' to: { 'foo'. $: } end: 3.
!

testCompileAny
    parser := #any asParser compile.
    
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: '_' to: $_.
    self assert: parser parse: '
' to: Character cr.
!

testCompileAnyStar
    parser := compiler compile: (#any asParser star).
    
    
    self assert: parser parse: 'aaa' to: { $a. $a . $a }.
    self assert: context invocationCount = 1.
    self assert: parser parse: '' to: { }.	
!

testCompileBlock
    parser := (#letter asParser) plus ==> [ :res | res collect: [:each | each asUppercase ]].
    parser := compiler compile: (parser).
    
    self assert: parser parse: 'foo' to: { $F . $O . $O}.
    self assert: parser parse: 'bar' to: { $B . $A . $R}.
    self assert: parser fail: ''.
!

testCompileCharacter
    parser := compiler compile: ($a asParser).
    
    self assert: parser parse: 'a'  to: $a.
    self assert: parser fail: 'b'.

    parser := compiler compile: ($# asParser).
    self assert: parser parse: '#'.
!

testCompileChoice
    parser := compiler compile: ((#digit asParser / #letter asParser)).
    
    self assert: parser parse: '1' to: $1.
    self assert: parser parse: 'a' to: $a.
    self assert: parser fail: '_'.
    
!

testCompileChoice2
    parser := compiler compile: (('true' asParser / 'false' asParser)).
    
    self assert: parser parse: 'true' to: 'true'.
    self assert: parser parse: 'false' to: 'false'.
    self assert: parser fail: 'trulse'.
    
!

testCompileLiteral
    parser := compiler compile: ('foo' asParser).
    
    self assert: parser parse: 'foo'  to: 'foo'.
    self assert: parser parse: 'foobar'  to: 'foo' end: 3.
    self assert: parser fail: 'boo'.
    
    parser := compiler compile: ('#[' asParser).
    self assert: parser parse: '#[1]' to: '#[' end: 2.
!

testCompileLiteral2
    | quote |
    quote := '''' asParser.
    parser := compiler compile: ((quote , $a asParser)).	
    self assert: parser parse: '''a'  to: {'''' . $a}.	
!

testCompileNegate
    parser := #letter asParser negate star, #letter asParser.
    parser := compiler compile: (parser).
    
    self assert: parser parse: '...a' to: { { $. . $. . $. } . $a }.
    self assert: parser parse: 'aaa' to: { {} . $a } end: 1.
    self assert: parser fail: '...'.
!

testCompileNil
    parser := compiler compile: (nil asParser).
    
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser parse: '' to: nil end: 0.
    
    parser := nil asParser, 'foo' asParser.
    self assert: parser parse: 'foo' to: { nil . 'foo' }
!

testCompileNot
    parser := compiler compile: (#digit asParser not).
    
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser fail: '1'.
    self assert: parser parse: '' to: nil end: 0.

    parser := 'foo' asParser, $: asParser not.
    parser := compiler compile: (parser).	
    self assert: parser parse: 'foo' to: { 'foo'. nil } end: 3.
    
    parser := 'foo' asParser, $: asParser not, 'bar' asParser.
    parser := compiler compile: (parser).	
    self assert: parser parse: 'foobar' to: { 'foo'. nil . 'bar' } end: 6.
!

testCompileNot2
    parser := compiler compile: (($a asParser , $b asParser) not).
        
    self assert: parser parse: '' to: nil end: 0.
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser parse: 'aa' to: nil end: 0.
    self assert: parser fail: 'ab'.
!

testCompileNot3
    parser := compiler compile: (('foo' asParser not , 'fee' asParser)).
        
    self assert: parser parse: 'fee' to: #(nil 'fee').
    self assert: parser fail: 'foo'.
!

testCompileNotLiteral
    parser := compiler compile: ('foo' asParser not).
    self assert: parser class methodDictionary size = 1.

    self assert: parser parse: 'bar' to: nil end: 0.
        
    self assert: parser fail: 'foo'.
    self assert: parser parse: '' to: nil end: 0.

    parser := '''' asParser not compile.
    self assert: parser class methodDictionary size = 1.

    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser fail: ''''.
    self assert: parser parse: '' to: nil end: 0.


    parser := ('foo' asParser, 'bar' asParser not) compile.
    self assert: parser parse: 'foofoo' to: { 'foo'. nil } end: 3.
    
    parser := ('foo' asParser, 'foo' asParser not, #any asParser star) compile.
    self assert: parser parse: 'foobar' to: { 'foo'. nil . #($b $a $r) } end: 6.
    self assert: parser fail: 'foofoo'.
!

testCompileOptional
    parser := compiler compile: (#digit asParser optional).
    
    self assert: parser parse: '1' to: $1.
    self assert: parser parse: 'a' to: nil end: 0.
    
    parser := (#digit asParser optional, #letter asParser) compile.
    self assert: parser parse: '1a' to: { $1 . $a }.
    self assert: parser parse: 'a' to: { nil . $a }.
!

testCompilePlus
    parser := compiler compile: (#letter asParser plus).
    
    self assert: parser parse: 'lorem' to: {$l. $o. $r. $e. $m} .
    self assert: parser parse: 'a123' to: {$a} end: 1.
    self assert: parser parse: 'ab123' to: {$a . $b} end: 2.

    self assert: parser fail: ''.
    self assert: parser fail: '123'.
!

testCompilePredicate
    parser := compiler compile: (#digit asParser).
    
    self assert: parser parse: '1' to: $1.
    self assert: parser parse: '0' to: $0.
    self assert: parser fail: 'a'.
!

testCompilePredicate2
    parser := compiler compile: (#space asParser).
    
    self assert: parser parse: ' ' to: Character space.
    self assert: parser fail: 'a'.
!

testCompileSequence
    parser := compiler compile: ((#digit asParser , #letter asParser)).
    
    self assert: parser parse: '1a' to: {$1 .$a}.
    
    
!

testCompileSequence2
    parser := compiler compile: (#digit asParser , #space asParser , #letter asParser).
    
    self assert: parser parse: '9 c' to: {$9 . Character space. $c }.   
    self assert: parser fail: '9c'.

    "Modified: / 07-09-2015 / 12:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileSequence3
    parser := compiler compile: (#any asParser , #any asParser , #any asParser).
    
    self assert: parser parse: 'foo' to: #($f $o $o).   
    self assert: parser fail: 'fo'.

    "Modified: / 07-09-2015 / 12:38:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompileStar
    parser := compiler compile: (#letter asParser star).
    
    self assert: parser parse: 'lorem' to: {$l. $o. $r. $e. $m} .
    self assert: parser parse: '' to: {}.
    self assert: parser parse: '123' to: {} end: 0.
    self assert: parser parse: 'ab123' to: {$a . $b} end: 2.
!

testCompileStarLiteral
    parser := compiler compile: ('foo' asParser star).
    
    self assert: parser parse: 'foo' to: #('foo' ) .
    self assert: parser parse: 'foofoo' to: #('foo' 'foo') .
    self assert: parser parse: 'foofoofoo' to: #('foo' 'foo' 'foo') .
    self assert: parser parse: '' to: #().
    self assert: parser parse: 'bar' to: #() end: 0.
!

testCompileStarPredicate
    parser := compiler compile: (#letter asParser star).
    
    self assert: parser parse: 'foo' to: #($f $o $o ) .
    self assert: parser parse: '' to: #().
    self assert: parser parse: '123' to: #() end: 0.
!

testCompileSymbolBlock
    parser := (#letter asParser) plus ==> #second.
    parser := compiler compile: (parser).
    
    self assert: parser parse: 'foo' to: $o.
    self assert: parser parse: 'bar' to: $a.
    self assert: parser fail: ''.
    self should: [ parser parse: 'f' ] raise: Error.
!

testCompileTrim
    parser := compiler compile: ($a asParser trim).
    
    self assert: parser fail: ''.
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: '   a' to: $a.
    self assert: parser parse: 'a    ' to: $a.
    self assert: parser parse: '  a    ' to: $a.
!

testCompileTrimmingToken
    | token1 token2 |
    token1 := (#letter asParser) plus trimmingToken.
    token2 := (#letter asParser) plus trimmingToken.
    
    parser := compiler compile: ((token1 , token2)).
    
    self assert: parser parse: 'foo bar'.
    self assert: parser parse: ' foo bar '.
!

testCompileTrimmingToken2
    | token1 token2 |
    token1 := (#letter asParser) plus trimmingToken.
    token2 := (#letter asParser) plus trimmingToken / 'foo' asParser trimmingToken.
    
    parser := compiler compile: ((token1 , token2)).
    
    self assert: parser parse: 'foo bar'.
    self assert: parser parse: ' foo bar '.
!

testCompileTrimmingToken3
    | token1 token2 |
    token1 := ($a asParser, $b asParser) trimmingToken name: 'token1'.
    token2 := (token1 not, $c asParser) trimmingToken name: 'token2'.
    
    parser := compiler compile: ((token1 / token2)).

    self assert: (parser class methodDictionary includesKey: #'token1').
    self assert: (parser class methodDictionary includesKey: #'token1_fast').
    
    self assert: parser parse: 'ab'.
    self assert: (result isKindOf: PPToken).
    self assert: result inputValue = 'ab'.

    self assert: parser parse: 'c'.
    self assert: (result isKindOf: PPToken).
    self assert: result inputValue = 'c'.
    
! !

!PPCUniversalTest methodsFor:'tests - extra'!

testCompileSmalltalkToken
    parser := compiler compile: (#letter asParser , ((#letter asParser / #digit asParser) star)) smalltalkToken.
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser parse: 'a'.
    self assert: result inputValue = 'a'.
    self assert: parser parse: 'f123a'.
    self assert: result inputValue = 'f123a'.
    
    self assert: parser fail: ''.
    self assert: parser fail: '12'.

    self assert: parser parse: ' "comment" foo'.
    self assert: result inputValue = 'foo'.
    
    self assert: parser parse: ' "comment" bar "another comment" '.
    self assert: result inputValue = 'bar'.
    self assert: parser parse: '
        "b"
        "b"
        foo
        "and yet, another comment"

        "one more to make sure :)"
    '.
    self assert: result inputValue = 'foo'.

    "Modified: / 07-09-2015 / 12:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCycle
    | p1 block |
    
    p1 := PPDelegateParser new.
    block := ${ asParser, p1, $} asParser / nil asParser.
    p1 setParser: block.
    
    parser := compiler compile: (block).
    self assert: parser parse: '{}' to: { ${. nil . $} }.
    self assert: parser parse: '{{}}' to: { ${. { ${ . nil . $} } . $} }.
    
!

testSmalltalkToken
    parser := compiler compile: (#letter asParser , (#digit asParser / #letter asParser) star) smalltalkToken.
    
    self assert: parser class methodDictionary size = 5.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: context invocationCount = 8.
    self assert: context rememberCount = 0.
    self assert: context lwRememberCount = 0.
    self assert: context lwRestoreCount = 0.

    "Modified: / 07-09-2015 / 12:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSmalltalkToken2
    id := (#letter asParser, (#digit asParser / #letter asParser) star)
        name: 'identifier';
        yourself.
        
    parser := (id wrapped, $: asParser) smalltalkToken 
        name: 'kw';
        yourself.
    
    parser := compiler compile: (parser).
    
    self assert: parser parse: 'foo:'.
    self assert: result inputValue = 'foo:'.
!

testToken
    parser := compiler compile: (#letter asParser , (#digit asParser / #letter asParser) star) flatten.

    
    self assert: parser parse: 'foo' to: 'foo'.
    self assert: parser parse: 'a' to: 'a'.
    self assert: parser parse: 'f123a' to: 'f123a'.
    self assert: parser fail: ''.

    "Modified: / 07-09-2015 / 12:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testToken2
    parser := compiler compile: (#letter asParser , (#digit asParser / #letter asParser) star) token.

    
    self assert: parser class methodDictionary size = 4.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: context invocationCount = 6.
    self assert: context rememberCount = 0.
    self assert: context lwRememberCount = 0.
    self assert: context lwRestoreCount = 0.

    "Modified: / 07-09-2015 / 12:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingToken
    parser := compiler compile: (#letter asParser , (#digit asParser / #letter asParser) star) 
                    trimmingToken.

    self assert: parser class methodDictionary size = 4.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    self assert: context invocationCount = 6.
    self assert: context rememberCount = 0.
    self assert: context lwRememberCount = 0.
    self assert: context lwRestoreCount = 0.    

    self assert: parser parse: ' foo '.
    self assert: result inputValue = 'foo'.



    self assert: parser fail: '123'.

    self assert: context invocationCount = 1.
    self assert: context rememberCount = 0.
    self assert: context lwRememberCount = 0.
    self assert: context lwRestoreCount = 0.    


    self assert: parser fail: ''.

    "Modified: / 07-09-2015 / 12:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingToken2

    parser := compiler compile:  ('foo' asParser trimmingToken , 'bar' asParser trimmingToken).

    
    self assert: parser parse: 'foobar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.      
    self assert: context invocationCount = 3.

    self assert: parser parse: ' foobar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.      
    self assert: context invocationCount = 3.
    self assert: (context invocations anySatisfy: [ :e | e beginsWith: 'token' ]).      
        
    self assert: parser fail: 'bar'.
    self assert: context invocationCount = 2.
"       self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'token' ]).         "

    "Modified: / 07-09-2015 / 12:37:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingToken3

    parser := compiler compile: ('foo' asParser trimmingToken / 'bar' asParser trimmingToken).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: context invocationCount = 2.

    self assert: parser parse: ' bar'.
    self assert: result inputValue = 'bar'.     
    self assert: context invocationCount = 2.
    self assert: (context invocations anySatisfy: [ :e | e beginsWith: 'token' ]).      
        
    self assert: parser fail: 'baz'.
    self assert: context invocationCount = 2.
    
    self assert: parser fail: 'zaz'.
    self assert: context invocationCount = 1.
    self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'token' ]).

    "Modified: / 07-09-2015 / 12:37:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingTokenNested
    | identifier kw |
    kw := 'false' asParser trimmingToken name: #kw.
    identifier := (kw not, (#letter asParser, #word asParser star)) trimmingToken name: #identifier.
    
    parser := identifier / kw.
    parser := compiler compile: (parser).
    self assert: parser class methodDictionary size = 5.

    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    self assert: parser parse: 'false'.
    self assert: result inputValue = 'false'.
!

testTrimmingTokenNested2
    | identifier kw |
    kw := 'false' asParser trimmingToken name: #kw.
    identifier := (kw not, (#letter asParser, #word asParser star)) trimmingToken name: #identifier.
    
    parser := identifier / kw.
    parser := compiler compile: (parser).
    self assert: parser class methodDictionary size = 5.

    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    self assert: parser parse: 'false'.
    self assert: result inputValue = 'false'.
!

testTrimmingTokenNested3
    | identifier kw |
    kw := ('false' asParser, #word asParser not) trimmingToken name: #kw.
    identifier := (kw not, (#letter asParser, #word asParser star)) trimmingToken name: #identifier.
    
    parser := identifier / kw.
    parser := compiler compile: (parser).
    self assert: parser class methodDictionary size = 8.
    self assert: (parser class methodDictionary values anySatisfy: [ :m | m selector = #kw ]).
    self assert: (parser class methodDictionary values anySatisfy: [ :m | m selector = #kw_fast ]).

    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    self assert: parser parse: 'false'.
    self assert: result inputValue = 'false'.

    "Modified: / 10-05-2015 / 07:33:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCUniversalTest methodsFor:'tests - ids'!

setUp
    options := (PPCCompilationOptions new)
            profile:true;
            debug:true;
            tokenize:false;
            yourself.
    compiler := PPCCompiler new.
    compiler context options:options

    "Modified: / 07-09-2015 / 10:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCUniversalTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

