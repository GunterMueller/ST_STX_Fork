"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#PPCCompositeParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Support'
!


!PPCCompositeParserTest class methodsFor:'accessing'!

resources
    ^ Array with: (PPCSetUpBeforeTearDownAfterResource for: self)

    "Created: / 29-07-2015 / 16:28:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompositeParserTest class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == PPCCompositeParserTest.
! !

!PPCCompositeParserTest class methodsFor:'utilities'!

generateTests
    "Regenerate all generated test cases"

    {

        PPExpressionGrammarTest .

        PPSmalltalkGrammarTests .
        PPSmalltalkParserTests .


    } do:[:each | self generateTestsFor: each ]

    "Created: / 07-09-2015 / 11:28:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateTestsFor: baseTestClass
    | compiledBaseTestClassName |

    compiledBaseTestClassName := (baseTestClass name startsWith: 'PP') 
                            ifTrue:[ 'PPC' , (baseTestClass name copyFrom: 3 to: baseTestClass name size) ]
                            ifFalse:[ 'PPC' , baseTestClass name ].
    compiledBaseTestClassName := compiledBaseTestClassName asSymbol.

    ^ self generateTestsFor: baseTestClass compiledBaseTestCaseName: compiledBaseTestClassName

    "Created: / 30-07-2015 / 07:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2015 / 07:27:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateTestsFor: baseTestClass compiledBaseTestCaseName: compiledBaseTestClassName
    | compiledBaseTestClass compiledUniversalTestClass compiledTokenizedTestClass |



    compiledBaseTestClass := baseTestClass subclass:compiledBaseTestClassName
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category: 'PetitCompiler-Extras-Tests-Misc'.

    compiledBaseTestClass class compile:
'isAbstract
    ^ self == ', compiledBaseTestClassName
    classified: 'testing'.

    compiledBaseTestClass class compile:
'resources
    ^ Array with: (PPCSetUpBeforeTearDownAfterResource for: self)'
    classified: 'resources'.

    self methodDictionary do:[:method |  
        compiledBaseTestClass compile: method source classified: method category    
    ].

    compiledBaseTestClass compile:
'petitParserClass
    ^ ' , baseTestClass new parserClass name
    classified: 'accessing'.

    compiledUniversalTestClass := compiledBaseTestClass subclass: (compiledBaseTestClassName , '_Universal') asSymbol
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category: 'PetitCompiler-Extras-Tests-Misc'.

    compiledUniversalTestClass compile: 
'compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false ) '
    classified: 'accessing'.
    
                             
    compiledTokenizedTestClass := compiledBaseTestClass subclass: (compiledBaseTestClassName , '_Tokenized') asSymbol
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category: 'PetitCompiler-Extras-Tests-Misc'.

    compiledTokenizedTestClass compile: 
'compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )'
    classified: 'accessing'.

    "Created: / 31-07-2015 / 07:26:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 12:58:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompositeParserTest methodsFor:'accessing'!

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
    "Return the name of the petit parser to compile"

    ^ self subclassResponsibility

    "Created: / 29-07-2015 / 17:01:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompositeParserTest methodsFor:'context'!

context

    ^ PPCContext new 
! !

!PPCCompositeParserTest methodsFor:'setup & teardown'!

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

!PPCCompositeParserTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

