"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCOverlappingTokensTest
	instanceVariableNames:'parser result context node options compiler fooToken idToken
		keywordToken p unaryToken assignmentToken'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Tokenizing'
!

!PPCOverlappingTokensTest methodsFor:'as yet unclassified'!

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
!

compile: aPPParser
    parser := compiler compile: aPPParser.

    "Modified: / 07-09-2015 / 12:36:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

context	
    ^ context := PPCProfilingContext new
!

setUp
    options := (PPCCompilationOptions new)
            profile:true;
            tokenize:true;
            yourself.
    compiler := PPCCompiler new.
    compiler options:options.
    self cleanClass.
    fooToken := ('foo' asParser token trim)
            name:'foo';
            yourself.
    idToken := ((#word asParser plus) token trim)
            name:'id';
            yourself.
    unaryToken := ((#word asParser plus , $: asParser not) token trim)
            name:'unary';
            yourself.
    keywordToken := ((#word asParser plus , $: asParser) token trim)
            name:'kw';
            yourself.
    assignmentToken := ((':=' asParser) token trim)
            name:'assignment';
            yourself.

    "Modified: / 07-09-2015 / 11:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "self cleanClass"
!

testOverlappingSmalltalkLike
    p := (keywordToken, idToken) star, idToken, assignmentToken, idToken.
    self compile: p.
    
    self assert: parser parse: 'foo: bar 
        id := another'.
    self assert: result first size = 1..
    self assert: result second inputValue = 'id'.
    self assert: result third inputValue = ':='.
    self assert: result last inputValue = 'another'.
!

testOverlappingSmalltalkLike2
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'JK, remove this once fixed'.
    ].   

    p := (keywordToken, idToken) star, idToken, assignmentToken, idToken.
    self compile: p.
    
    self assert: parser parse: 'foo: bar 
        id:=another'.
    self assert: result first size = 1.
    self assert: result second inputValue = 'id'.
    self assert: result third inputValue = ':='.
    self assert: result last inputValue = 'another'.
    
    true ifTrue: [ ^ self ].
    "skip for simple tokenizer"
    self assert: context tokenReadCount == 2 description: 'too many token reads?'.

    "Modified: / 08-09-2015 / 01:52:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOverlappingToken
    p := (unaryToken ==> [ :e | #unary ]) / (keywordToken ==> [:e | #kw ]).
    self compile: p.
    
    self assert: parser parse: 'foo:'.
    self assert: result == #kw.

    self assert: parser parse: 'foo '.
    self assert: result == #unary.	
!

testOverlappingToken2
    p := (idToken ==> [ :e | #id ]) / (keywordToken ==> [:e | #kw ]).
    self compile: p.
    
    self assert: parser parse: 'foo:' end: 3.
    self assert: result == #id.

    self assert: parser parse: 'foo '.
    self assert: result == #id.	
!

testOverlappingToken3
    p := (unaryToken ==> [ :e | #unary ]) / (keywordToken ==> [:e | #kw ]).
    self compile: p.
    
    self assert: parser parse: 'foo:'.
    self assert: result == #kw.

    self assert: parser parse: 'foo '.
    self assert: result == #unary.	
!

testOverlappingTokenStar
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'JK, remove this once fixed'.
    ].   

    p := (fooToken ==> [ :e | #foo ]) / (idToken ==> [:e | #id ]).
    self compile: p star.
    
    self assert: parser parse: 'foo bar foo bar'.
    self assert: result first = #foo.
    self assert: result second = #id.
    self assert: result third = #foo.
    self assert: result last = #id.
    
    true ifTrue: [ ^ self ].
    "skip for simple tokenizer"
    self assert: context tokenReadCount == 1 description: 'too many token reads?'.

    "Modified: / 08-09-2015 / 01:53:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOverlappingTokenStar2
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'JK, remove this once fixed'.
    ].   

    p := (fooToken / idToken).
    self compile: p star.
    
    self assert: parser parse: '  foo   bar    foo bar'.
    self assert: result first inputValue = 'foo'.
    self assert: result second inputValue = 'bar'.
    self assert: result third inputValue = 'foo'.
    self assert: result last inputValue = 'bar'.
    
    true ifTrue: [ ^ self ].
    "skip for simple tokenizer"
    self assert: context tokenReadCount == 1 description: 'too many token reads?'.

    "Modified: / 08-09-2015 / 01:53:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSanityAsignment
    self compile: assignmentToken.
    self assert: parser parse: ':='.
    self assert: result inputValue = ':='.
    self assert: parser fail: ':f'
!

testSanityFoo
    self compile: fooToken.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser parse: 'foobar' end: 3.
    self assert: result inputValue = 'foo'.
    self assert: parser fail: 'bar'.
!

testSanityId
    self compile: idToken.
    self assert: parser parse: 'hi'.
    self assert: result inputValue = 'hi'.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser parse: 'hi:' end: 2.
    self assert: result inputValue = 'hi'.
!

testSanityKeyword
    self compile: keywordToken .
    self assert: parser parse: 'hi:'.
    self assert: result inputValue = 'hi:'.
    self assert: parser fail: 'hi'.	
!

testSanityUnary
    self compile: unaryToken.
    self assert: parser parse: 'hi'.
    self assert: result inputValue = 'hi'.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.
    self assert: parser fail: 'hi:'
! !

