"{ Package: 'stx:goodies/petitparser/gui/tests' }"

TestCase subclass:#PPGrammarRefactoringTest
	instanceVariableNames:'refactoring'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Tests'
!


!PPGrammarRefactoringTest methodsFor:'accessing'!

change
	^ self refactoring changes
!

changes
	^ self change changes
!

refactoring
	^ refactoring
! !

!PPGrammarRefactoringTest methodsFor:'testing-parsers'!

testAddParser
        self performRefactoring: (PPAddParserRefactoring
                name: #PPMockParser
                category: #'PetitGui-Mock').
        self assert: self changes size = 2.
        self assert: self changes first class = AddClassChange.
        self assert: self changes first definitionClass = PPCompositeParser.
        self assert: self changes first changeClassName = #PPMockParser.
        self assert: self changes first category = #'PetitGui-Mock'.
        self assert: self changes last class = AddMethodChange.
        self assert: self changes last parseTree = (RBParser parseMethod: 'start ^ self shouldBeImplemented')
!

testAddParserWithSuperclass
        self performRefactoring: (PPAddParserRefactoring
                name: #PPMockParser
                category: #'PetitGui-Mock'
                superclass: PPArithmeticParser).
        self assert: self changes size = 2.
        self assert: self changes first class = AddClassChange.
        self assert: self changes first definitionClass = PPArithmeticParser.
        self assert: self changes first changeClassName = #PPMockParser.
        self assert: self changes first category = #'PetitGui-Mock'.
        self assert: self changes last class = AddMethodChange.
        self assert: self changes last parseTree = (RBParser parseMethod: 'start ^ self shouldBeImplemented')
!

testRemoveParser
        self performRefactoring: (PPRemoveParserRefactoring onClass: PPArithmeticParser).
        self assert: self changes size = 1.
        self assert: self changes first class =  RemoveClassChange.
        self assert: self changes first changeClassName = 'PPArithmeticParser'
! !

!PPGrammarRefactoringTest methodsFor:'testing-productions'!

testDefineProduction
        self performRefactoring: (PPDefineProdcutionRefactoring
                onClass: PPArithmeticParser
                source: 'function ^ #any plus , $( , $) ==> [ :e | 0 ]'
                protocols: (Array with: #productions)).
        self assert: self changes size = 2.
        self assert: self changes first class = AddInstanceVariableChange.
        self assert: self changes first variable = 'function'.
        self assert: self changes last class = AddMethodChange.
        self assert: self changes last parseTree = (RBParser parseMethod: 'function ^ #any asParser plus , $( asParser , $) asParser ==> [ :e | 0 ]')
!

testExtractProduction
        self performRefactoring: (PPExtractProdcutionRefactoring
                onClass: PPArithmeticParser
                production: #addition
                interval: (36 to: 60)
                to: #plusOrMinus).
        self assert: self changes size = 3.
        self assert: self changes first class = AddInstanceVariableChange.
        self assert: self changes first variable = 'plusOrMinus'.
        self assert: self changes second class = AddMethodChange.
        self assert: self changes second parseTree = (RBParser parseMethod: 'plusOrMinus ^ $+ asParser / $- asParser').
        self assert: self changes last class = AddMethodChange.
        self assert: self changes last parseTree = (RBParser parseMethod: 'addition ^ (factors separatedBy: plusOrMinus trim) foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]')
!

testRemoveProduction
        self performRefactoring: (PPRemoveProdcutionRefactoring
                onClass: PPArithmeticParser
                production: #addition).
        self assert: self changes size = 2.
        self assert: self changes first class = RemoveMethodChange.
        self assert: self changes first selector = #addition.
        self assert: self changes last class = RemoveInstanceVariableChange.
        self assert: self changes last variable = 'addition'
!

testRenameProduction
        self performRefactoring: (PPRenameProdcutionRefactoring
                onClass: PPArithmeticParser
                rename: #addition
                to: #add).
        self assert: self changes size = 3.
        self assert: self changes first class = RenameInstanceVariableChange.
        self assert: self changes first oldName = 'addition'.
        self assert: self changes first newName = 'add'.
        self assert: self changes second class = AddMethodChange.
        self assert: self changes second parseTree = (RBParser parseMethod: 'add ^ (factors separatedBy: ($+ asParser / $- asParser) trim) foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]').
        self assert: self changes last class = RemoveMethodChange.
        self assert: self changes last selector = #addition
! !

!PPGrammarRefactoringTest methodsFor:'utilities'!

performRefactoring: aRefactoring
	refactoring := aRefactoring.
	aRefactoring primitiveExecute
! !

!PPGrammarRefactoringTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/tests/PPGrammarRefactoringTest.st,v 1.2 2014-03-04 23:33:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/tests/PPGrammarRefactoringTest.st,v 1.2 2014-03-04 23:33:40 cg Exp $'
! !

