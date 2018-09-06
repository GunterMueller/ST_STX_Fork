"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RenameVariableChange subclass:#RenameClassVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RenameClassVariableChange methodsFor:'private'!

addNewVariable
	(AddClassVariableChange add: newName to: self changeClass) execute
!

copyOldValuesToNewVariable
	| oldValue |
	oldValue := self changeClass classPool at: oldName ifAbsent: [].
	self changeClass classPool at: newName asSymbol put: oldValue
!

removeOldVariable
	(RemoveClassVariableChange remove: oldName from: self changeClass) execute
! !

!RenameClassVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RenameClassVariableChange.st,v 1.3 2003-09-23 10:44:59 cg Exp $'
! !
