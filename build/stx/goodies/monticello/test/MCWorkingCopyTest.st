"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCWorkingCopyTest
	instanceVariableNames:'savedInitials workingCopy repositoryGroup versions versions2'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCWorkingCopyTest methodsFor:'accessing'!

description
	^ self class name
! !

!MCWorkingCopyTest methodsFor:'actions'!

basicMerge: aVersion
	aVersion merge
!

load: aVersion
	aVersion load
!

merge: aVersion
	[[self basicMerge: aVersion]
		on: MCMergeResolutionRequest do: [:n | n resume: true]]
			on: MCNoChangesException do: [:n | ]
!

snapshot
	| version |
	[version _ workingCopy newVersion]
		on: MCVersionNameAndMessageRequest
		do: [:n | n resume: (Array with: n suggestedName with: '')].
	versions at: version info put: version.
	^ version
! !

!MCWorkingCopyTest methodsFor:'asserting'!

assertNameWhenSavingTo: aRepository is: aString
	| name |
	name _ nil.
	[aRepository storeVersion: workingCopy newVersion]
		on: MCVersionNameAndMessageRequest
		do: [:n | name _ n suggestedName. n resume: (Array with: name with: '')].
	self assert: name = aString
!

assertNumberWhenSavingTo: aRepository is: aNumber
	| name |
	name _ nil.
	[aRepository storeVersion: workingCopy newVersion]
		on: MCVersionNameAndMessageRequest
		do: [:n | name _ n suggestedName. n resume: (Array with: name with: '')].
	self assert: name = (self packageName, '-', Utilities authorInitials, '.', aNumber asString)
! !

!MCWorkingCopyTest methodsFor:'private'!

packageName
	^ self mockPackage name
! !

!MCWorkingCopyTest methodsFor:'running'!

clearPackageCache
	| dir |
	dir _ MCCacheRepository default directory.
	(dir fileNamesMatching: 'MonticelloMocks*') do: [:ea | dir deleteFileNamed: ea].
	(dir fileNamesMatching: 'MonticelloTest*') do: [:ea | dir deleteFileNamed: ea].
	(dir fileNamesMatching: 'rev*') do: [:ea | dir deleteFileNamed: ea].
	(dir fileNamesMatching: 'foo-*') do: [:ea | dir deleteFileNamed: ea].
	(dir fileNamesMatching: 'foo2-*') do: [:ea | dir deleteFileNamed: ea].
!

setUp
	| repos1 repos2 |
	self clearPackageCache.
	repositoryGroup _ MCRepositoryGroup new.
	workingCopy _ MCWorkingCopy forPackage: self mockPackage.
	versions _ Dictionary new.
	versions2 _ Dictionary new.
	repos1 _ MCDictionaryRepository new dictionary: versions.
	repos2 _ MCDictionaryRepository new dictionary: versions2.
	repositoryGroup addRepository: repos1.
	repositoryGroup addRepository: repos2.
	MCRepositoryGroup default removeRepository: repos1; removeRepository: repos2.
	workingCopy repositoryGroup: repositoryGroup.
	savedInitials _ Utilities authorInitials.
	Utilities setAuthorInitials: 'abc'.
!

tearDown
	workingCopy unregister.
	self restoreMocks.
	self clearPackageCache.
	Utilities setAuthorInitials: savedInitials.
! !

!MCWorkingCopyTest methodsFor:'tests'!

testAncestorMerge
	| base revA revB revC |

	base _ self snapshot.
	self change: #a toReturn: 'a1'.
	revA _  self snapshot.
	self change: #b toReturn: 'b1'.
	revB _  self snapshot.	
	self change: #c toReturn: 'c1'.
	revC _  self snapshot.	

	self should: [self basicMerge: revA] raise: MCNoChangesException.
	
!

testBackport
	| inst base final backported |
	inst _ self mockInstanceA.
	base _  self snapshot.
	self assert: inst one = 1.
	self change: #one toReturn: 2.
	self change: #two toReturn: 3.
	final _ self snapshot.
	[workingCopy backportChangesTo: base info]
		on: MCChangeSelectionRequest
		do: [:e | e resume: e patch].
	self assert: inst one = 2.
	self assert: inst two = 3.
	self assert: workingCopy ancestry ancestors size = 1.
	self assert: workingCopy ancestry ancestors first = base info.
	self assert: workingCopy ancestry stepChildren size = 1.
	self assert: workingCopy ancestry stepChildren first = final info.
	backported _ self snapshot.
	[workingCopy backportChangesTo: base info]
		on: MCChangeSelectionRequest
		do: [:e | e resume: e patch].
	self assert: workingCopy ancestry ancestors size = 1.
	self assert: workingCopy ancestry ancestors first = base info.
	self assert: workingCopy ancestry stepChildren size = 1.
	self assert: workingCopy ancestry stepChildren first = backported info.
	
!

testDoubleRepeatedMerge
	| base motherA1 motherA2 motherB1 motherB2 inst |

	base _ self snapshot.
	self change: #a toReturn: 'a1'.
	motherA1 _  self snapshot.
	self change: #c toReturn: 'c1'.
	motherA2 _  self snapshot.	
	
	self load: base.
	self change: #b toReturn: 'b1'.
	motherB1 _  self snapshot.
	self change: #d toReturn: 'd1'.
	motherB2 _  self snapshot.
	
	self load: base.
	self merge: motherA1.
	self merge: motherB1.
	self change: #a toReturn: 'a2'.
	self change: #b toReturn: 'b2'.
	self snapshot.

	self shouldnt: [self merge: motherA2] raise: Error.
	self shouldnt: [self merge: motherB2] raise: Error.
	
	inst _ self mockInstanceA.
	self assert: inst a = 'a2'.
	self assert: inst b = 'b2'.
	self assert: inst c = 'c1'.
	self assert: inst d = 'd1'.
	
!

testMergeIntoImageWithNoChanges
	| base revB revA1 |

	self change: #a toReturn: 'a'.
	base _ self snapshot.
	self change: #b toReturn: 'b'.
	revB _ self snapshot.
	
	self load: base.
	self change: #a toReturn: 'a1'.
	revA1 _ self snapshot.

	self change: #a toReturn: 'a'.
	self snapshot.
	self merge: revB.

	self assert: (workingCopy ancestors size = 2)
	
!

testMergeIntoUnmodifiedImage
	| base revA |

	base _ self snapshot.
	self change: #a toReturn: 'a1'.
	revA _ self snapshot.
	
	self load: base.

	self merge: revA.

	self assert: (workingCopy ancestors size = 1)
	
!

testNaming
	| repos version |

	repos := MCDictionaryRepository new.
	self assertNameWhenSavingTo: repos is: self packageName, '-abc.1'.
	self assertNameWhenSavingTo: repos is: self packageName, '-abc.2'.
	repos := MCDictionaryRepository new.
	self assertNameWhenSavingTo: repos is: self packageName, '-abc.3'.
	version := self snapshot.
	version info instVarNamed: 'name' put: 'foo-jf.32'.
	version load.
	self assertNameWhenSavingTo: repos is: 'foo-abc.33'.
	self assertNameWhenSavingTo: repos is: 'foo-abc.34'.
	version info instVarNamed: 'name' put: 'foo-abc.35'.
	repos storeVersion: version.
	self assertNameWhenSavingTo: repos is: 'foo-abc.36'.
	self assertNameWhenSavingTo: repos is: 'foo-abc.37'.
	version info instVarNamed: 'name' put: 'foo-abc.10'.
	repos storeVersion: version.
	self assertNameWhenSavingTo: repos is: 'foo-abc.38'.
	version info instVarNamed: 'name' put: 'foo2-ab.40'.
	version load.
	self assertNameWhenSavingTo: repos is: 'foo2-abc.41'.
!

testOptimizedLoad
	| inst base diffy |
	inst _ self mockInstanceA.
	base _ self snapshot.
	self change: #one toReturn: 2.
	self assert: inst one = 2.
	diffy _ self snapshot asDiffAgainst: base.
	self deny: diffy canOptimizeLoading.
	self load: base.
	self assert: inst one = 1.
	self assert: diffy canOptimizeLoading.
	self load: diffy.
	self assert: inst one = 2.
!

testRedundantMerge
	| base |
	base _  self snapshot.
	self merge: base.
	self shouldnt: [self merge: base] raise: Error.
!

testRepeatedMerge
	| base mother1 mother2 inst |

	base _  self snapshot.
	self change: #one toReturn: 2.
	mother1 _  self snapshot.
	self change: #two toReturn: 3.
	mother2 _  self snapshot.	
	
	self load: base.
	self change: #truth toReturn: false.
	self snapshot.

	inst _ self mockInstanceA.
	self assert: inst one = 1.
	self assert: inst two = 2.	

	self merge: mother1.
	self assert: inst one = 2.
	self assert: inst two = 2.	
	
	self change: #one toReturn: 7.
	self assert: inst one = 7.
	self assert: inst two = 2.
	
	self shouldnt: [self merge: mother2] raise: Error.
	self assert: inst one = 7.
	self assert: inst two = 3.
!

testRepositoryFallback
	| version |
	version _ self snapshot.
	self assert: (repositoryGroup versionWithInfo: version info) == version.
	versions removeKey: version info.
	versions2 at: version info put: version.
	self assert: ( repositoryGroup versionWithInfo: version info) == version.
	versions2 removeKey: version info.
	self should: [repositoryGroup versionWithInfo: version info] raise: Error.
!

testSelectiveBackport
	| inst base intermediate final patch selected |
	inst _ self mockInstanceA.
	base _  self snapshot.
	self assert: inst one = 1.
	self change: #one toReturn: 2.
	intermediate _ self snapshot.
	self change: #two toReturn: 3.
	final _ self snapshot.
	[workingCopy backportChangesTo: base info]
		on: MCChangeSelectionRequest
		do: [:e |
			patch _ e patch.
			selected _ patch operations select: [:ea | ea definition selector = #two].
			e resume: (MCPatch operations: selected)]. 
	self assert: inst one = 1.
	self assert: inst two = 3.
	self assert: workingCopy ancestry ancestors size = 1.
	self assert: workingCopy ancestry ancestors first = base info.
	self assert: workingCopy ancestry stepChildren size = 1.
	self assert: workingCopy ancestry stepChildren first = final info
!

testSimpleMerge
	| mother base inst |
	inst _ self mockInstanceA.
	base _  self snapshot.
	self change: #one toReturn: 2.
	mother _  self snapshot.
	self load: base.
	self change: #two toReturn: 3.
	self snapshot.
	self assert: inst one = 1.
	self assert: inst two = 3.
	
	self merge: mother.
	self assert: inst one = 2.
	self assert: inst two = 3.
!

testSnapshotAndLoad
	| base inst |
	inst _ self mockInstanceA.
	base _  self snapshot.
	self change: #one toReturn: 2.
	self assert: inst one = 2.
	self load: base.
	self assert: inst one = 1.
! !

!MCWorkingCopyTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCWorkingCopyTest.st,v 1.2 2013-05-29 00:01:14 vrany Exp $'
! !

