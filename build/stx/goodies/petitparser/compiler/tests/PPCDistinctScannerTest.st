"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCDistinctScannerTest
	instanceVariableNames:'compiler scanner'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Tokenizing'
!


!PPCDistinctScannerTest methodsFor:'as yet unclassified'!

aToken
    ^ 'a' asParser token 
        name: #token;
        yourself.
!

barToken
    ^ 'bar' asParser token 
        name: #bar;
        yourself.
!

fooToken
    ^ 'foo' asParser token 
        name: #foo;
        yourself.
!

fooTrimmingToken
    ^ 'foo' asParser trimmingToken 
        name: #foo;
        yourself.
!

idToken
    ^ #letter asParser plus token 
        name: #id;
        yourself.
!

idTrimmingToken
    ^ #letter asParser plus trimmingToken 
        name: #id;
        yourself.
!

overlappingToken
    ^ 'a' asParser token / 'a' asParser token
!

setUp
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).

    "Modified: / 07-09-2015 / 11:36:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConsumeToken
    | parser |
    parser := self fooToken, self overlappingToken.
    compiler compile: parser.
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foobaz' asPetitStream.
    scanner perform: #'consume_foo'.
    
    self assert: scanner position = 3.
    self assert: scanner resultPosition = 3.
    self assert: scanner result isNil.

    "Modified: / 28-08-2015 / 14:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConsumeToken2
    | parser |
    parser := self fooToken, self barToken.
    compiler compile: parser.
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foobar' asPetitStream.
    scanner perform: #'consume_foo'.
    
    self assert: scanner position = 3.
    self assert: scanner resultPosition = 6.
    self assert: scanner result = #bar.

    "Modified: / 28-08-2015 / 14:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testScan
    | parser |
    parser := self aToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'a' asPetitStream.
    scanner perform: #'scan_token'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 1.
    self assert: scanner result = #token.

    "Modified: / 28-08-2015 / 14:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testScan2
    | parser |
    parser := self fooToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foo' asPetitStream.
    scanner perform: #'scan_foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner result = #foo.

    "Modified: / 28-08-2015 / 14:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testScan3
    | parser |
    parser := self fooToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'bar' asPetitStream.
    scanner perform: #'scan_foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 0.
    self assert: scanner result isNil.

    "Modified: / 28-08-2015 / 14:16:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testScan4
    | parser |
    parser := self fooToken, self idToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foothere' asPetitStream.
    scanner perform: #'scan_foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner result = #foo.
    
    scanner perform: #'consume_foo'.

    self assert: scanner position = 3.
    self assert: scanner resultPosition = 8.
    self assert: scanner result = #id.

    "Modified: / 28-08-2015 / 14:16:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSequence
    | parser result |
    parser := self fooTrimmingToken, self idTrimmingToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foo there ' asPetitStream.
    scanner perform: #'foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner stream position = 4.
    self assert: scanner result = #foo.         
    
    result := scanner perform: #'consume_foo'.

    self assert: scanner position = 4.
    self assert: scanner resultPosition = 9.
    self assert: scanner stream position = 10.
    self assert: scanner result = #id.
    
    self assert: (result isKindOf: PPToken).
    self assert: result start = 1.
    self assert: result stop = 3.
    self assert: result inputValue = 'foo'.

    "Modified: / 28-08-2015 / 14:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testToken
    | parser |
    parser := self fooToken, self idTrimmingToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foo there' asPetitStream.
    scanner perform: #'foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner stream position = 3.
    self assert: scanner result = #foo.

    "Modified: / 28-08-2015 / 14:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingScan
    | parser |
    parser := self fooTrimmingToken, self idTrimmingToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foo there' asPetitStream.
    scanner perform: #'scan_foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner result = #foo.

    "Modified: / 28-08-2015 / 14:16:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmingToken
    | parser result |
    parser := self fooTrimmingToken, self idTrimmingToken.
    compiler compile: parser.
    
    scanner := (Smalltalk at: compiler context options scannerName) new.

    scanner stream: 'foo there' asPetitStream.
    result := scanner perform: #'foo'.
    
    self assert: scanner position = 0.
    self assert: scanner resultPosition = 3.
    self assert: scanner stream position = 4.
    self assert: scanner result = #foo.                 
        
    self assert: result.

    "Modified: / 28-08-2015 / 14:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCDistinctScannerTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

