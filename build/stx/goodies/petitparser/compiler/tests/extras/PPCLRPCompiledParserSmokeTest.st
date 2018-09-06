"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPParserSmokeTest subclass:#PPCLRPCompiledParserSmokeTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPCompiledParserSmokeTest class methodsFor:'resources'!

resources
    ^ Array with: (PPCSetUpBeforeTearDownAfterResource for: self)
! !

!PPCLRPCompiledParserSmokeTest class methodsFor:'testing'!

isAbstract
    ^ self == PPCLRPCompiledParserSmokeTest

    "Modified: / 31-07-2015 / 07:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPCompiledParserSmokeTest methodsFor:'accessing'!

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
            (("This is bit hacky!!" self compiler options tokenize) ifTrue:[ 'Tokenizing' ] ifFalse:[ 'Universal' ])) asSymbol

    "Created: / 29-07-2015 / 16:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2015 / 15:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

petitParser
    ^ self petitParserClass new

    "Created: / 29-07-2015 / 17:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

petitParserClass
    ^ PPCLRPParser
! !

!PPCLRPCompiledParserSmokeTest methodsFor:'context'!

context

    ^ PPCContext new 
! !

!PPCLRPCompiledParserSmokeTest methodsFor:'setup & teardown'!

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

