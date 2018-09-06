"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

CompositeRefactoryChange subclass:#RenameVariableChange
	instanceVariableNames:'className isMeta oldName newName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RenameVariableChange class methodsFor:'instance creation'!

rename: oldName to: newName in: aClass 
	^(self new)
		oldName: oldName;
		newName: newName;
		changeClass: aClass;
		yourself
! !

!RenameVariableChange methodsFor:'accessing'!

changeClass
	| class |
	class := Smalltalk at: self changeClassName ifAbsent: [^nil].
	^isMeta ifTrue: [class class] ifFalse: [class]
!

changeClass: aBehavior 
	isMeta := aBehavior isMeta.
	className := isMeta 
				ifTrue: [aBehavior soleInstance name]
				ifFalse: [aBehavior name]
!

changeClassName
	^className
!

changeClassName: aSymbol 
	className := aSymbol.
	isMeta isNil ifTrue: [isMeta := false]
!

newName
	^newName
!

oldName
	^oldName
! !

!RenameVariableChange methodsFor:'comparing'!

= aRenameVariableChange 
	self class = aRenameVariableChange class ifFalse: [^false].
	^className = aRenameVariableChange changeClassName and: 
			[isMeta = aRenameVariableChange isMeta and: 
					[oldName = aRenameVariableChange oldName 
						and: [newName = aRenameVariableChange newName]]]
!

hash
	^(self changeClassName hash bitXor: self oldName hash) 
		bitXor: self newName hash
! !

!RenameVariableChange methodsFor:'printing'!

changeString
        ^'Rename ' , oldName , ' to ' , newName allBold
!

displayClassName
	^isMeta 
		ifTrue: [self changeClassName , ' class']
		ifFalse: [self changeClassName asString]
!

printOn: aStream
	aStream nextPutAll: self displayString
! !

!RenameVariableChange methodsFor:'private'!

addNewVariable
	self subclassResponsibility
!

copyOldValuesToNewVariable
	self subclassResponsibility
!

executeNotifying: aBlock 
	| undo |
	self addNewVariable.
	self copyOldValuesToNewVariable.
	undo := super executeNotifying: aBlock.
	undo
		oldName: newName;
		newName: oldName.
	self removeOldVariable.
	^undo
!

isMeta
	^isMeta
!

newName: aString 
	newName := aString
!

oldName: aString
	oldName := aString
!

removeOldVariable
	self subclassResponsibility
! !

!RenameVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RenameVariableChange.st,v 1.4 2004-03-19 14:49:11 cg Exp $'
! !
