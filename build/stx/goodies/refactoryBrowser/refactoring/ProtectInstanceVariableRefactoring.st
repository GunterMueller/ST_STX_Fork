"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#ProtectInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ProtectInstanceVariableRefactoring methodsFor:'performing'!

findGetterSetterMethods
        | matcher |
        matcher := ParseTreeSearcher new.
        matcher
                answer: Set new;
                matchesAnyMethodOf: (Array 
                                        with: '`method ^' , variableName
                                        with: ('`method: `arg <1s> := `arg' expandMacrosWith: variableName)
                                        with: ('`method: `arg ^<1s> := `arg' expandMacrosWith: variableName))
                        do: 
                                [:aNode :answer | 
                                (self subclassOf: class redefines: aNode selector) 
                                        ifFalse: [answer add: aNode selector].
                                answer].
        (class whichSelectorsAccess: variableName) do: 
                        [:each | 
                        self 
                                checkClass: class
                                selector: each
                                using: matcher].
        ^matcher answer
! !

!ProtectInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
	^RBCondition definesInstanceVariable: variableName in: class
! !

!ProtectInstanceVariableRefactoring methodsFor:'private-accessing'!

getterSetterMethods
	| matcher |
	matcher := ParseTreeSearcher new.
	matcher
		answer: Set new;
		matchesAnyMethodOf: (Array 
					with: '`method ^' , variableName
					with: ('`method: `arg <1s> := `arg' expandMacrosWith: variableName)
					with: ('`method: `arg ^<1s> := `arg' expandMacrosWith: variableName))
			do: 
				[:aNode :answer | 
				(class subclassRedefines: aNode selector) 
					ifFalse: [answer add: aNode selector].
				answer].
	(class whichSelectorsReferToInstanceVariable: variableName) do: 
			[:each | 
			self 
				checkClass: class
				selector: each
				using: matcher].
	^matcher answer
! !

!ProtectInstanceVariableRefactoring methodsFor:'transforming'!

inline: aSelector 
        self onError: 
                        [self performComponentRefactoring: (InlineAllSelfSendersRefactoring 
                                                model: self model
                                                sendersOf: aSelector
                                                in: class)]
                do: []
!

transform
	self setOption: #inlineExpression toUse: [:ref :string | true].
	self getterSetterMethods do: [:each | self inline: each]
! !

!ProtectInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ProtectInstanceVariableRefactoring.st,v 1.10 2009-09-22 10:19:45 cg Exp $'
! !
