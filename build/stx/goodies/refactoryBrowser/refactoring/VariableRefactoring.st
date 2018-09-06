"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#VariableRefactoring
	instanceVariableNames:'class variableName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!VariableRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk variable: aVarName class: aClass 
	^(self new)
		model: aRBSmalltalk;
		variable: aVarName class: aClass;
		yourself
!

variable: aVarName class: aClass
	^self new variable: aVarName class: aClass
! !

!VariableRefactoring methodsFor:'initialize-release'!

variable: aVarName class: aClass 
	class := self classObjectFor: aClass.
	variableName := aVarName
! !

!VariableRefactoring methodsFor:'printing'!

storeOn: aStream 
        aStream nextPut: $(.
        self class storeOn: aStream.
        aStream nextPutAll: ' variable: '.
        variableName storeOn: aStream.
        aStream nextPutAll: ' class: '.
        class storeOn: aStream.
        aStream nextPut: $)
! !

!VariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/VariableRefactoring.st,v 1.7 2003-09-23 10:40:50 cg Exp $'
! !
