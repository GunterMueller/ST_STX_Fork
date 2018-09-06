"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCMergingTest
	instanceVariableNames:'conflictBlock conflicts'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCMergingTest methodsFor:'asserting'!

assert: aCollection hasElements: anArray
	self assert: (aCollection collect: [:ea | ea token]) asSet = anArray asSet
!

assertMerge: local with: remote base: ancestor gives: result conflicts: conflictResult
	| merger |
	conflicts _ #().
	merger _ MCThreeWayMerger
				base: (self snapshotWithElements: local)
				target: (self snapshotWithElements: remote)
				ancestor: (self snapshotWithElements: ancestor).
	merger conflicts do: [:ea | self handleConflict: ea].
	self assert: merger mergedSnapshot definitions hasElements: result.
	self assert: conflicts asSet = conflictResult asSet.
! !

!MCMergingTest methodsFor:'emulating'!

handleConflict: aConflict	
	|l r|
	l _ #removed.
	r _ #removed.
	aConflict localDefinition ifNotNilDo: [:d | l _ d token].
	aConflict remoteDefinition ifNotNilDo: [:d | r _ d token].	
	conflicts _ conflicts copyWith: (Array with: r with: l).
	(l = #removed or: [r = #removed])
		ifTrue: [aConflict chooseRemote]
		ifFalse:
			[l > r
				ifTrue: [aConflict chooseLocal]
				ifFalse: [aConflict chooseRemote]]
		
!

snapshotWithElements: anArray
	^ MCSnapshot
		fromDefinitions: (anArray collect: [:t | self mockToken: t])
! !

!MCMergingTest methodsFor:'tests'!

testAdditiveConflictlessMerge
	self
		assertMerge: #(a1 b1)
				with: #(a1 c1)
				base: #(a1)
			
				gives: #(a1 b1 c1)
				conflicts: #()
!

testComplexConflictlessMerge
	self 
		assertMerge: #(a1 b1 d1)
				with: #(a2 c1)
				base: #(a1 c1 d1)
				
				gives: #(a2 b1)
				conflicts: #()
!

testIdenticalModification
	self
		assertMerge: #(a2 b1)
				with: #(a2 b1)
				base: #(a1 b1)
				
				gives: #(a2 b1)
				conflicts: #()
!

testLocalModifyRemoteRemove
	self assertMerge: #(a2 b1)
				with: #(b1)
				base: #(a1 b1)
				
				gives: #(b1)
				conflicts: #((removed a2)).
				
	self assertMerge: #(a1 b1)
				with: #(b1)
				base: #(a2 b1)
				
				gives: #(b1)
				conflicts: #((removed a1)).
!

testLocalRemoveRemoteModify
	self assertMerge: #(b1)
				with: #(a1 b1)
				base: #(a2 b1)
				
				gives: #(a1 b1)
				conflicts: #((a1 removed)).

	self assertMerge: #(b1)
				with: #(a2 b1)
				base: #(a1 b1)
				
				gives: #(a2 b1)
				conflicts: #((a2 removed)).
!

testMultiPackageMerge
	| merger |
	conflicts _ #().
	merger _ MCThreeWayMerger new.
	merger addBaseSnapshot: (self snapshotWithElements: #(a1 b1)).
	merger applyPatch: ((self snapshotWithElements: #()) patchRelativeToBase: (self snapshotWithElements: #(a1))).
	merger applyPatch: ((self snapshotWithElements: #(a2 b1)) patchRelativeToBase: (self snapshotWithElements: #(b1))).
	merger conflicts do: [:ea | self handleConflict: ea].
	self assert: merger mergedSnapshot definitions hasElements: #(a2 b1).
	self assert: conflicts isEmpty
!

testMultiPackageMerge2
	| merger |
	conflicts _ #().
	merger _ MCThreeWayMerger new.
	merger addBaseSnapshot: (self snapshotWithElements: #(a1 b1)).
	merger applyPatch: ((self snapshotWithElements: #()) patchRelativeToBase: (self snapshotWithElements: #(a1))).
	merger applyPatch: ((self snapshotWithElements: #(a1 b1)) patchRelativeToBase: (self snapshotWithElements: #(b1))).
	merger conflicts do: [:ea | self handleConflict: ea].
	self assert: merger mergedSnapshot definitions hasElements: #(a1 b1).
	self assert: conflicts isEmpty
!

testMultiPackageMerge3
	| merger |
	conflicts _ #().
	merger _ MCThreeWayMerger new.
	merger addBaseSnapshot: (self snapshotWithElements: #(a1 b1)).
	merger applyPatch: ((self snapshotWithElements: #(a1 b1)) patchRelativeToBase: (self snapshotWithElements: #(b1))).
	merger applyPatch: ((self snapshotWithElements: #()) patchRelativeToBase: (self snapshotWithElements: #(a1))).
	merger conflicts do: [:ea | self handleConflict: ea].
	self assert: merger mergedSnapshot definitions hasElements: #(a1 b1).
	self assert: conflicts isEmpty
!

testMultipleConflicts
	self assertMerge: #(a1 b3 c1)
				with: #(a1 b2 d1)
				base: #(a1 b1 c2)
				
				gives: #(a1 b3 d1)
				conflicts: #((removed c1) (b2 b3))
!

testSimultaneousModification
	self assertMerge: #(a2)
				with: #(a3)
				base: #(a1)
				
				gives: #(a3)
				conflicts: #((a3 a2)).
!

testSimultaneousRemove
	self assertMerge: #(a1)
				with: #(a1)
				base: #(a1 b1)
				
				gives: #(a1)
				conflicts: #()
!

testSubtractiveConflictlessMerge
	self assertMerge: #(a1 b1)
				with: #()
				base: #(a1)
				
				gives: #(b1)
				conflicts: #()
! !

!MCMergingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCMergingTest.st,v 1.2 2013-05-29 00:00:02 vrany Exp $'
! !

