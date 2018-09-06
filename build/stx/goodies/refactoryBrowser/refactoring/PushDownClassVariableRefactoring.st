"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#PushDownClassVariableRefactoring
	instanceVariableNames:'destinationClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PushDownClassVariableRefactoring methodsFor:'preconditions'!

findDestinationClass
	| classVarName classes |
	classVarName := variableName asSymbol.
	classes := class withAllSubclasses reject: 
					[:each | 
					(each whichSelectorsReferToClassVariable: classVarName) isEmpty and: 
							[(each metaclass whichSelectorsReferToClassVariable: classVarName) isEmpty]].
	destinationClass := classes isEmpty ifTrue: [nil] ifFalse: [classes first].
	classes do: 
			[:each | 
			(destinationClass includesClass: each) 
				ifTrue: [destinationClass := each]
				ifFalse: 
					[(each includesClass: destinationClass) 
						ifFalse: [self signalMultipleReferenceError]]].
	destinationClass = class ifTrue: [self signalStillReferencedError].
	^destinationClass
!

preconditions
        "Preconditions are that only one subclass refers to the class variable."

        ^(RBCondition definesClassVariable: variableName in: class) 
                & (RBCondition withBlock: 
                                        [self findDestinationClass.
                                        true])
!

signalMultipleReferenceError
	self signalReferenceError: ('Multiple subclasses reference <1s>' 
				expandMacrosWith: variableName)
!

signalReferenceError: errorString 
	class realClass isNil 
		ifTrue: [self refactoringError: errorString]
		ifFalse: 
			[| classVarName error |
			error := '<1s><n>Browse references?' expandMacrosWith: errorString.
			classVarName := variableName asSymbol.
			self refactoringError: error
				with: 
					[self 
						openBrowserOn: (VariableEnvironment referencesToClassVariable: classVarName
								in: class realClass)]]
!

signalStillReferencedError
	self signalReferenceError: ('<1p> has references to <2s>' 
				expandMacrosWith: class
				with: variableName)
! !

!PushDownClassVariableRefactoring methodsFor:'transforming'!

transform
	class removeClassVariable: variableName.
	destinationClass isNil ifTrue: [^self].
	destinationClass addClassVariable: variableName
! !

!PushDownClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/PushDownClassVariableRefactoring.st,v 1.11 2004-06-18 08:15:08 ca Exp $'
! !
