"{ Package: 'stx:goodies/monticello/test' }"

TestCase subclass:#MCTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCTestCase class methodsFor:'as yet unclassified'!

isAbstract
	^ self = MCTestCase
!

resources
	^ Array with: MCSnapshotResource
! !

!MCTestCase methodsFor:'asserting'!

assertPackage: actual matches: expected
	self assert: actual = expected
!

assertSnapshot: actual matches: expected
	| diff |
	diff _ actual patchRelativeToBase: expected.
	self assert: diff isEmpty
!

assertVersion: actual matches: expected
	self assertPackage: actual package matches: expected package.	
	self assertVersionInfo: actual info matches: expected info.
	self assertSnapshot: actual snapshot matches: expected snapshot.
!

assertVersionInfo: actual matches: expected
	self assert: actual name = expected name.
	self assert: actual message = expected message.
	self assert: actual ancestors size = expected ancestors size.
	actual ancestors with: expected ancestors do: [:a :e | self assertVersionInfo: a matches: e]
	
! !

!MCTestCase methodsFor:'compiling'!

change: aSelector toReturn: anObject
	self 
		compileClass: self mockClassA 
		source: aSelector, ' ^ ', anObject printString 
		category: 'numeric'
!

compileClass: aClass source: source category: category
    Smalltalk isSmalltalkX ifTrue:[
        Class withoutUpdatingChangesDo:[
            aClass compile: source classified: category
        ].
        ^ self.
    ].
    aClass compileInobtrusively: source classified: category
!

restoreMocks
	self mockSnapshot updatePackage: self mockPackage
! !

!MCTestCase methodsFor:'mocks'!

commentForClass: name
	^ 'This is a comment for ', name
!

commentStampForClass: name
	^ 'tester-', name,  ' 1/1/2000 00:00'
!

mockCategoryName
	^ 'Monticello-Mocks'
!

mockClass: className super: superclassName
	^ MCClassDefinition
		name:  className
		superclassName:  superclassName
		category: self mockCategoryName
		instVarNames: #()
		classVarNames: #()
		poolDictionaryNames: #()
		classInstVarNames: #()
		type: #normal
		comment: (self commentForClass: className)
		commentStamp: (self commentStampForClass: className)
!

mockClassA
	^ Smalltalk at: #MCMockClassA
!

mockClassB
	^ Smalltalk at: #MCMockClassB
!

mockDependencies
	^ Array with: (MCVersionDependency package: self mockEmptyPackage info: (self mockVersionInfo: 'x'))
!

mockEmptyPackage
	^ MCPackage named: (MCEmptyPackageInfo new packageName)
!

mockExtensionMethodCategory
	^ MCMockPackageInfo new methodCategoryPrefix.
!

mockInstanceA
	^ self mockClassA new
!

mockMessageString
	^ 'A version generated for testing purposes.'
!

mockMethod: aSymbol class: className source: sourceString meta: aBoolean
	^ MCMethodDefinition
		className: className
		classIsMeta: aBoolean
		selector:  aSymbol
		category: 'as yet unclassified'
		timeStamp: ''
		source: sourceString
!

mockOverrideMethodCategory
	^ self mockExtensionMethodCategory, '-override'
!

mockPackage
	^ MCSnapshotResource mockPackage
!

mockSnapshot
	^ MCSnapshotResource current snapshot
!

mockToken: aSymbol
	^ MCMockDefinition token: aSymbol
!

mockVersion
	^ MCVersion 
		package: self mockPackage
		info: self mockVersionInfo
		snapshot: self mockSnapshot
!

mockVersionInfo
	^ self treeFrom: #(d ((b ((a))) (c)))
!

mockVersionInfo: tag 
	^ MCVersionInfo
		name: self mockVersionName, '-', tag asString
		id: UUID new
		message: self mockMessageString, '-', tag asString
		date: Date today
		time: Time now
		author: Utilities authorInitials 
		ancestors: #()
!

mockVersionInfoWithAncestor: aVersionInfo 
	^ MCVersionInfo
		name: aVersionInfo name, '-child'
		id: UUID new
		message: self mockMessageString
		date: Date today
		time: Time now
		author: Utilities authorInitials 
		ancestors: {aVersionInfo}
!

mockVersionName
	^ 'MonticelloTest-xxx.1'
!

mockVersionWithAncestor: aMCVersion 
	^ MCVersion
		package: self mockPackage
		info: (self mockVersionInfoWithAncestor: aMCVersion info)
		snapshot: self mockSnapshot
!

mockVersionWithDependencies
	^ MCVersion 
		package: self mockPackage
		info: self mockVersionInfo
		snapshot: self mockSnapshot
		dependencies: self mockDependencies
!

treeFrom: anArray
	| name id |
	name _ anArray first.
	id _ '00000000-0000-0000-0000-0000000000', (name asString size = 1 ifTrue: [name asString, '0'] ifFalse: [name asString]).
	^ MCVersionInfo
		name: name
		id: (UUID fromString: id)
		message: ''
		date: nil
		time: nil
		author: ''
		ancestors: (anArray size > 1 ifTrue: [(anArray second collect: [:ea | self treeFrom: ea])] ifFalse: [#()])
! !

!MCTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCTestCase.st,v 1.3 2013-05-29 00:01:28 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCTestCase.st,v 1.3 2013-05-29 00:01:28 vrany Exp $'
! !

