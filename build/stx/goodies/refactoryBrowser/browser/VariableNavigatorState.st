"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

NavigatorState subclass:#VariableNavigatorState
	instanceVariableNames:'instanceVariable classVariable variableClassName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!


!VariableNavigatorState methodsFor:'accessing'!

classVariable
	^classVariable
!

classVariable: aSymbol 
	classVariable := aSymbol
!

instanceVariable
	^instanceVariable
!

instanceVariable: aString 
	instanceVariable := aString
!

variableClassName
	^variableClassName
!

variableClassName: aSymbol 
	variableClassName := aSymbol
! !

!VariableNavigatorState class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/VariableNavigatorState.st,v 1.2 2003-09-23 10:44:42 cg Exp $'
! !
