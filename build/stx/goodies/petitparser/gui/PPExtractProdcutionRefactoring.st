"{ Package: 'stx:goodies/petitparser/gui' }"

ExtractMethodRefactoring subclass:#PPExtractProdcutionRefactoring
	instanceVariableNames:'targetProduction'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPExtractProdcutionRefactoring class methodsFor:'instance creation'!

onClass: aClass production: aSelector interval: anInterval to: aTargetSelector
	^ (self extract: anInterval from: aSelector in: aClass)
		setTargetProduction: aTargetSelector;
		yourself
! !

!PPExtractProdcutionRefactoring methodsFor:'initialization'!

setTargetProduction: aSymbol
	targetProduction := aSymbol
! !

!PPExtractProdcutionRefactoring methodsFor:'preconditions'!

preconditions
	^ (self checkCompositeParser: class)
		& super preconditions		
		& (RBCondition definesSelector: targetProduction asSymbol in: class) not
		& (RBCondition definesInstanceVariable: targetProduction asString in: class) not
! !

!PPExtractProdcutionRefactoring methodsFor:'requests'!

shouldExtractAssignmentTo: aString
	^ false
! !

!PPExtractProdcutionRefactoring methodsFor:'transforming'!

existingSelector
	^ nil
!

getNewMethodName
	parameters isEmpty
		ifFalse: [ self refactoringError: 'Cannot extract production since it contains references.' ].
	targetProduction asSymbol isUnary
		ifFalse: [ self refactoringError: 'Invalid production name.' ].
	^ targetProduction asSymbol
!

nameNewMethod: aSymbol 
        class addInstanceVariable: aSymbol asString.
        extractedParseTree renameSelector: aSymbol andArguments: #().
        modifiedParseTree := ParseTreeRewriter 
                replace: self methodDelimiter
                with: aSymbol asString
                in: modifiedParseTree
! !

!PPExtractProdcutionRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPExtractProdcutionRefactoring.st,v 1.2 2014-03-04 23:34:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPExtractProdcutionRefactoring.st,v 1.2 2014-03-04 23:34:06 cg Exp $'
! !

