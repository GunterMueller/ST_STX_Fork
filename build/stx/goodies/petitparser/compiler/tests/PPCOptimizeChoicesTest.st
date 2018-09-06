"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCOptimizeChoicesTest
	instanceVariableNames:'node result visitor compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!

!PPCOptimizeChoicesTest methodsFor:'as yet unclassified'!

asPPCTree: parser
    ^ compiler compile: parser

    "Modified: / 07-09-2015 / 10:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUp
    | options |

    super setUp.
    visitor := PPCOptimizeChoices new.
    options := (PPCCompilationOptions new)
            profile:true;
            generate:false;
            tokenize:false;
            yourself.
    compiler := PPCCompiler new.
    compiler passes:{ PPCCacheFirstFollowPass }.
    compiler options:options.

    "Modified: / 07-09-2015 / 10:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testHasCommonPrefix
    | foo bar |
    foo := 'foo' asParser name: 'foo'; yourself.
    bar := 'bar' asParser.
    
    node := self asPPCTree: (foo, bar) / foo.

    self assert: (visitor hasCommonPrefix: node children).
! !

