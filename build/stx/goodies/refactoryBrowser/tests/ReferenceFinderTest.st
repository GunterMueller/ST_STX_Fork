"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#ReferenceFinderTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ReferenceFinderTest methodsFor:'tests'!

testAllPaths

	self needsWork. "slows, then hangs (100% CPU) on or after level 5 - 4551 objects to search.
		is this because Squeak can't handle large collections efficiently?"

"       | paths |
	paths _ ReferenceFinder findAllPathsTo: RefactoringManager instance.
	self deny: paths isEmpty.
	paths do: 
		[:each | 
		self assert: each last == RefactoringManager instance.
		self assert: each first == Smalltalk]"
!

testAllPathsToInstance
	self needsWork. "slows, then hangs (100% CPU) on or after level 5 - 4551 objects to search.
		is this because Squeak can't handle large collections efficiently?"

"       | paths |     
	paths _ ReferenceFinder findAllPathsToInstanceOf: RefactoringManager. 
	    self deny: paths isEmpty.     
	paths do:      
	[:each |      
	self assert: each last class == RefactoringManager.     
	self assert: each first == Smalltalk]"
!

testFound

	self needsWork. "slows, then hangs (100% CPU) on or after level 5 - 4551 objects to search.
		is this because Squeak can't handle large collections efficiently?"

"       | path |
	path _ ReferenceFinder findPathTo: RefactoringManager instance.
	self assert: path last == RefactoringManager instance.
	self assert: (path at: path size - 1) isVariableBinding.
	self assert: (path at: path size - 1) key == #Instance.
	self assert: path first == Smalltalk"

!

testNotFound

	self needsWork. "slows, then hangs (100% CPU) on or after level 5 - 4551 objects to search.
		is this because Squeak can't handle large collections efficiently?"

"       | path |
	path _ ReferenceFinder findPathTo: Object new.
	self assert: path isNil"
!

testPathToInstance
	self needsWork. "slows, then hangs (100% CPU) on or after level 5 - 4551 objects to search.
		is this because Squeak can't handle large collections efficiently?"

"       | path |
	path _ ReferenceFinder findPathToInstanceOf: RefactoringManager.
	self assert: path last class == RefactoringManager.
	self assert: path first == Smalltalk"
! !

!ReferenceFinderTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ReferenceFinderTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
