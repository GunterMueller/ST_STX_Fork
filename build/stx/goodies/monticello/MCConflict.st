"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCConflict
	instanceVariableNames:'operation chooseRemote'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Merging'
!


!MCConflict class methodsFor:'as yet unclassified'!

operation: anOperation
	^ self new operation: anOperation	
! !

!MCConflict methodsFor:'as yet unclassified'!

annotations
	| op | 
	^(op := operation) ifNotNil: [ op annotations ]
!

applyTo: anObject
	self isResolved ifFalse: [self error: 'Cannot continue until this conflict has been resolved'].
	self remoteChosen ifTrue: [operation applyTo: anObject].
!

chooseLocal
	chooseRemote := false
!

chooseNewer
	self isLocalNewer ifTrue: [ self chooseLocal ]
		ifFalse: [ self isRemoteNewer ifTrue: [ self chooseRemote ]]
!

chooseOlder
	self isRemoteNewer ifTrue: [ self chooseLocal ]
		ifFalse: [ self isLocalNewer ifTrue: [ self chooseRemote ]]
!

chooseRemote
	chooseRemote := true
!

clearChoice
	chooseRemote := nil
!

definition
	| op | 
	^(op := operation) ifNotNil: [ op definition ]
!

isConflict
	^true
!

isLocalNewer
	^ self localDefinition fullTimeStamp > self remoteDefinition fullTimeStamp
!

isRemoteNewer
	^ self localDefinition fullTimeStamp < self remoteDefinition fullTimeStamp
!

isResolved
	^ chooseRemote notNil
!

localChosen
	^ chooseRemote notNil and: [chooseRemote not]
!

localDefinition
	^ operation baseDefinition
!

operation
	^ operation
!

operation: anOperation
	operation := anOperation
!

remoteChosen
	^ chooseRemote notNil and: [chooseRemote]
!

remoteDefinition
	^ operation targetDefinition
!

source
	^ self localChosen
		ifTrue: [operation fromSource]
		ifFalse: [operation source]
!

status
	^ self isResolved
		ifFalse: ['']
		ifTrue: [self remoteChosen
					ifFalse: ['L']
					ifTrue: ['R']]
!

summary
	| attribute |
	attribute := 
		self isResolved
			ifTrue: [self remoteChosen ifTrue: [#underlined] ifFalse: [#struckOut]]
			ifFalse: [#bold].
	^ Text string: operation summary attribute: (TextEmphasis perform: attribute)
! !

!MCConflict class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCConflict.st,v 1.4 2012-09-11 21:21:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCConflict.st,v 1.4 2012-09-11 21:21:04 cg Exp $'
!

version_SVN
    ^ '§Id: MCConflict.st 17 2010-10-13 12:07:52Z vranyj1 §'
! !
