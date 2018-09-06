"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCSmalltalkTests
	instanceVariableNames:'compiler result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Smalltalk'
!

!PPCSmalltalkTests methodsFor:'as yet unclassified'!

assert: parser parse: input
    result := parser parse: input.
    self assert: result isPetitFailure not.
!

setUp
    compiler := PPCCompiler newWithOptions: #(profile: true)

    "Modified: / 07-09-2015 / 11:10:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSmalltakToken
    | token1  |
    token1 := compiler compile: 'a' asParser smalltalkToken.
    
    self assert: ((token1 parse: 'a') class == PPSmalltalkToken).
    self assert: (token1 parse: '"comment" a "another comment"') inputValue = 'a'

    "Modified: / 07-09-2015 / 12:36:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSmalltakToken2
    | parser compiled  |
    parser := 'a' asParser smalltalkToken, 'b' asParser smalltalkToken.
    compiled := compiler compile: parser.
    
    self assert: compiled parse: 'ab'.
    self assert: compiled parse: '"comment" a "another comment" b '.
    self assert: result size = 2.
    self assert: result first inputValue = 'a'.
    self assert: result second inputValue = 'b'.
    
!

testSmalltakWhitespace
    | ws1 ws2 |
    ws1 := PPSmalltalkWhitespaceParser new.
    ws2 := PPSmalltalkWhitespaceParser new.
    
    self assert: ws1 = ws2.
    self assert: ws1 ~~ ws2.
    
    self assert: ws1 hash = ws2 hash.

    "Modified: / 30-07-2015 / 06:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

