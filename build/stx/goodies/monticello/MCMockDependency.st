"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCMockDependency
	instanceVariableNames:'name children hasResolution'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCMockDependency class methodsFor:'instance creation'!

fromTree: anArray 
	^ self new initializeWithTree: anArray
! !

!MCMockDependency methodsFor:'accessing'!

children
	^ children collect: [:ea | self class fromTree: ea]
!

initializeWithTree: expr
	expr isSymbol
		ifTrue: [name := expr.
				children := Array new.
				hasResolution := true.]
		ifFalse: [name := expr first.
				expr second isSymbol
					ifTrue: [hasResolution := false.
							children := Array new]
					ifFalse: [hasResolution := true.
							children := expr second]]
!

name
	^ name
! !

!MCMockDependency methodsFor:'comparing'!

= other
	^ self name = other name
!

hash
	^ self name hash
! !

!MCMockDependency methodsFor:'mocks'!

mockVersionInfo
	^ MCVersionInfo
		name: self name
		id: (self uuidForName: name)
		message: ''
		date: nil
		time: nil
		author: ''
		ancestors: #()
!

uuidForName: aName 
	| nm id |
	nm := aName asString.
	id := '00000000-0000-0000-0000-0000000000' 
				, (nm size = 1 ifTrue: [nm , '0'] ifFalse: [nm]).
	^UUID fromString: id
! !

!MCMockDependency methodsFor:'resolving'!

hasResolution
	^ hasResolution
!

resolve
	^ self hasResolution
		ifTrue: [MCVersion new
					setPackage: MCSnapshotResource mockPackage
					info: self mockVersionInfo
					snapshot: MCSnapshotResource current snapshot
					dependencies: self children]
		ifFalse: [nil]
! !

!MCMockDependency class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDependency.st,v 1.4 2012-09-11 21:24:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDependency.st,v 1.4 2012-09-11 21:24:20 cg Exp $'
!

version_SVN
    ^ '§Id: MCMockDependency.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
