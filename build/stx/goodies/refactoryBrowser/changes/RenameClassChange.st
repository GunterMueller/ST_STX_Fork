"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

CompositeRefactoryChange subclass:#RenameClassChange
	instanceVariableNames:'oldName newName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RenameClassChange class methodsFor:'instance creation'!

rename: oldString to: newString 
	^(self new)
		rename: oldString to: newString;
		yourself
! !

!RenameClassChange methodsFor:'accessing'!

changeClass
	^Smalltalk at: oldName asSymbol ifAbsent: [Smalltalk at: newName asSymbol]
!

renameChangesForClass: aClassName to: newClassName 
	| change |
	change := super renameChangesForClass: aClassName to: newClassName.
	oldName asSymbol == aClassName 
		ifTrue: [change rename: newClassName to: newName].
	^change
! !

!RenameClassChange methodsFor:'comparing'!

= aRenameClassChange 
	super = aRenameClassChange ifFalse: [^false].
	^oldName = aRenameClassChange oldName 
		and: [newName = aRenameClassChange newName]
! !

!RenameClassChange methodsFor:'initialize-release'!

rename: oldString to: newString 
	oldName := oldString.
	newName := newString
! !

!RenameClassChange methodsFor:'private'!

executeNotifying: aBlock 
        | undos |
        self changeClass rename: newName.
        undos := changes collect:[:each | 
                    (each renameChangesForClass: oldName asSymbol to: newName asSymbol) 
                            executeNotifying: aBlock
                 ].
        ^(self copy)
                changes: undos reverse;
                rename: newName to: oldName;
                yourself
!

flattenOnto: aCollection 
	aCollection 
		add: (self copy changes: (changes inject: OrderedCollection new
						into: 
							[:sum :each | 
							each flattenOnto: sum.
							sum]))
!

newName
	^newName
!

oldName
	^oldName
! !

!RenameClassChange methodsFor:'queries'!

shouldBeConfirmed
    "Return true, if the refactoring change should be confirmed
     before applying - makes sense only if UserPreferences current confirmRefactorings
     is on."

    ^true

    "Created: / 04-04-2012 / 14:11:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RenameClassChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RenameClassChange.st,v 1.6 2015-03-25 14:13:36 cg Exp $'
! !

