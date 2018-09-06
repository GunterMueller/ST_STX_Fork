"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#ValueHolderRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ValueHolderRefactoring methodsFor:'performing'!

defineHolderMethodUsing: aBuilder 
	| methodName createAccessor|

	methodName := self safeMethodNameFor: class basedOn: variableName , 'Holder'.

	createAccessor := AddMethodRefactoring
			 addMethod:('<1s><n><t><2s> isNil ifTrue:[<2s> := nil asValue].<n><t>^ <2s>.'
				expandMacrosWith: methodName
				with: variableName)
			 toClass: class 
			 inProtocols:(Array with:#aspects).
	self performComponentRefactoring:createAccessor.

	^methodName asSymbol
!

preconditions
        ^(RBCondition definesInstVar: variableName in: class)
                & ((RBCondition withBlock: [self
                                        usesAssignmentOf: variableName
                                        in: class
                                        classVariable: false])
                                errorMacro: 'This refactoring currently works only if the value of a variable assignment is not used.') not
!

transform
    | selector builder replacer |

    builder := RefactoryBuilder new.
    selector := self defineHolderMethodUsing: builder.

    "Convert all references to the variable to its getter and setter method"
    replacer := ParseTreeRewriter valueHolderForVariable: variableName holderMethod: selector.

    self
	    convertClasses: class withAllSubclasses
	    select: [:aClass | 
			    (aClass whichSelectorsReferTo: variableName)
				reject: [:each | aClass == class and: [each == selector]]]
	    using: replacer.
! !

!ValueHolderRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ValueHolderRefactoring.st,v 1.10 2004-06-18 08:15:26 ca Exp $'
! !
