"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPLL1ExpressionGrammarTest subclass:#PPCLL1ExpressionGrammarTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!

!PPCLL1ExpressionGrammarTest class methodsFor:'resources'!

resources
    ^ Array with: (PPCSetUpBeforeTearDownAfterResource for: self)
! !

!PPCLL1ExpressionGrammarTest class methodsFor:'testing'!

isAbstract
    ^ self == PPCLL1ExpressionGrammarTest
! !

!PPCLL1ExpressionGrammarTest methodsFor:'accessing'!

compiledParser
    ^ self compiledParserClass new

    "Created: / 29-07-2015 / 17:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiledParserClass
    ^ Smalltalk at: self compiledParserClassName

    "Created: / 29-07-2015 / 16:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiledParserClassName
    "Return the name of the compiled parser"

    ^ (self petitParserClass name , 'C_' , 
            "This is bit hacky!!"
            (("This is bit hacky!!" self compiler isKindOf: PPCTokenizingConfiguration) ifTrue:[ 'Tokenizing' ] ifFalse:[ 'Universal' ])) asSymbol

    "Created: / 29-07-2015 / 16:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiler
    "Return compiler to use when compiling parser (as instance of PPCConfiguration)"
    
    ^ self subclassResponsibility

    "Created: / 29-07-2015 / 16:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    ^ self compiledParserClass

    "Modified: / 29-07-2015 / 18:43:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserInstanceFor: aSymbol
    ^ self parserClass new startSymbol: aSymbol

    "Modified: / 29-07-2015 / 18:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

petitParser
    ^ self petitParserClass new

    "Created: / 29-07-2015 / 17:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

petitParserClass
    ^ PPLL1ExpressionGrammar
! !

!PPCLL1ExpressionGrammarTest methodsFor:'context'!

context

    ^ PPCContext new 
! !

!PPCLL1ExpressionGrammarTest methodsFor:'setup & teardown'!

setUpBefore
    "Called before any of my tests is run (when resources are set up)"
    | time compiler |

    compiler := self compiler.
    compiler options parserName: self compiledParserClassName.
    time := Time millisecondsToRun: [
        compiler compile: self petitParser.
    ].
    Transcript show: self petitParserClass name ; show:' compiled in: '; show: time asString; show: 'ms'; cr.

    "Created: / 29-07-2015 / 16:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2015 / 18:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDownAfter
    "Called after all my tests are ryn(when resources are torn down)"

    "Created: / 29-07-2015 / 16:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

