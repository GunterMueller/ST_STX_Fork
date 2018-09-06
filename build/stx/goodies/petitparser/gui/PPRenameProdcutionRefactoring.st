"{ Package: 'stx:goodies/petitparser/gui' }"

Refactoring subclass:#PPRenameProdcutionRefactoring
	instanceVariableNames:'oldProduction newProduction class'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPRenameProdcutionRefactoring class methodsFor:'instance creation'!

onClass: aClass rename: anOldSelector to: aNewSelector
	^ self new
		setClass: aClass;
		setOldProduction: anOldSelector;
		setNewProduction: aNewSelector;
		yourself
! !

!PPRenameProdcutionRefactoring methodsFor:'initialization'!

setClass: aClass
	class := self classObjectFor: aClass
!

setNewProduction: aSymbol
	newProduction := aSymbol
!

setOldProduction: aSymbol
	oldProduction := aSymbol
! !

!PPRenameProdcutionRefactoring methodsFor:'preconditions'!

preconditions
	^ self checkCompositeParser: class
! !

!PPRenameProdcutionRefactoring methodsFor:'transforming'!

transform
        | baseClass oldEnvironment |
        baseClass := class whoDefinesInstanceVariable: oldProduction asString.
        self performComponentRefactoring: (RenameInstanceVariableRefactoring
                model: model
                rename: oldProduction asString
                to: newProduction asString
                in: baseClass).
        oldEnvironment := model environment.
        model environment: (model environment
                forClasses: baseClass realClass withAllSubclasses).
        [ self performComponentRefactoring: (RenameMethodRefactoring
                model: model
                renameMethod: oldProduction asSymbol
                in: baseClass
                to: newProduction asSymbol 
                permutation: #()) ]
                        ensure: [ model environment: oldEnvironment ]
! !

!PPRenameProdcutionRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRenameProdcutionRefactoring.st,v 1.3 2014-03-04 23:33:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRenameProdcutionRefactoring.st,v 1.3 2014-03-04 23:33:51 cg Exp $'
! !

