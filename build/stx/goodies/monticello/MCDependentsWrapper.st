"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

ListItemWrapper subclass:#MCDependentsWrapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCDependentsWrapper methodsFor:'as yet unclassified'!

asString
	^item description
!

contents
	| list workingCopies |
	workingCopies := model unsortedWorkingCopies.
	list := item requiredPackages collect: 
					[:each | 
					workingCopies detect: [:wc | wc package = each] ifNone: [nil]]
				thenSelect: [:x | x notNil].
	^list collect: [:each | self class with: each model: model]
!

hasContents
	^item requiredPackages isEmpty not
!

item
	^item
! !

!MCDependentsWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDependentsWrapper.st,v 1.2 2012-09-11 21:21:24 cg Exp $'
! !

