"{ Package: 'stx:goodies/monticello' }"

MCPackageManager subclass:#MCWorkingCopy
	instanceVariableNames:'versionInfo ancestry counter repositoryGroup requiredPackages'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCWorkingCopy class methodsFor:'as yet unclassified'!

adoptVersionInfoFrom: anInstaller
	|viCache|
	viCache := Dictionary new.
	anInstaller versionInfo keysAndValuesDo: [:packageName :info |
		(self forPackage: (MCPackage named: packageName))
			versionInfo: (self infoFromDictionary:  info cache: viCache)].
	[anInstaller clearVersionInfo] on: Error do: ["backwards compat"].
!

ancestorsFromArray: anArray cache: aDictionary
	^ anArray ifNotNil: [anArray collect: [:dict | self infoFromDictionary: dict cache: aDictionary]]
!

infoFromDictionary: aDictionary cache: cache
	| id |
	id _ aDictionary at: #id.
	^ cache at: id ifAbsentPut:
		[MCVersionInfo
			name: (aDictionary at: #name)
			id: (aDictionary at: #id)
			message: (aDictionary at: #message)
			date: (aDictionary at: #date)
			time: (aDictionary at: #time)
			author: (aDictionary at: #author)
			ancestors: (self ancestorsFromArray: (aDictionary at: #ancestors) cache: cache)]
!

initialize
	Smalltalk 
		at: #MczInstaller
		ifPresent: [:installer | self adoptVersionInfoFrom: installer].
	self updateInstVars.
	"Temporary conversion code -- remove later"
	registry ifNotNil:[registry rehash]. "changed #="
	self allInstancesDo:[:each| "moved notifications"
		Smalltalk at: #SystemChangeNotifier ifPresent:[:cls|
			cls uniqueInstance noMoreNotificationsFor: each.
		].
	].
	self registerForNotifications.
!

updateInstVars
	self allInstances do: [:ea | ea updateInstVars]
! !


!MCWorkingCopy methodsFor:'accessing'!

ancestors
	^ ancestry ancestors
!

ancestry
	^ ancestry
!

clearRequiredPackages
	requiredPackages _ nil
!

currentVersionInfo
	^ (self needsSaving or: [ancestry ancestors isEmpty])
		ifTrue: [self newVersion info]
		ifFalse: [ancestry ancestors first]
!

description
	^ self packageNameWithStar, ' (', ancestry ancestorString, ')'
!

needsSaving
	^ self modified or: [self requiredPackages anySatisfy: [:ea | ea workingCopy needsSaving]]
!

requirePackage: aPackage
	(self requiredPackages includes: aPackage) ifFalse: [requiredPackages add: aPackage]
!

requiredPackages
	^ requiredPackages ifNil: [requiredPackages _ OrderedCollection new]
!

versionInfo: aVersionInfo
	ancestry _ MCWorkingAncestry new addAncestor: aVersionInfo
! !

!MCWorkingCopy methodsFor:'migration'!

updateInstVars
	ancestry ifNil:
		[ancestry _ MCWorkingAncestry new.
		versionInfo ifNotNil:
			[versionInfo ancestors do: [:ea | ancestry addAncestor: ea].
			versionInfo _ nil]]
! !

!MCWorkingCopy methodsFor:'operations'!

adopt: aVersion
	ancestry addAncestor: aVersion info.
	self changed.
!

backportChangesTo: aVersionInfo
        | baseVersion fullPatch currentVersionInfo currentVersion newSnapshot newAncestry |
        currentVersionInfo := self currentVersionInfo.
        baseVersion := self repositoryGroup versionWithInfo: aVersionInfo.
        currentVersion := self repositoryGroup versionWithInfo: currentVersionInfo.
        fullPatch := currentVersion snapshot patchRelativeToBase: baseVersion snapshot.
        (MCChangeSelectionRequest new
                patch: fullPatch;
                label: 'Changes to Backport';
                raiseSignal "signal" ) ifNotNilDo:
                [:partialPatch |
                newSnapshot := MCPatcher apply: partialPatch to: baseVersion snapshot.
                newAncestry := MCWorkingAncestry new
                                                        addAncestor: aVersionInfo;
                                                        addStepChild: currentVersionInfo;
                                                        yourself.
                MCPackageLoader updatePackage: package withSnapshot: newSnapshot.
                ancestry := newAncestry.
                self modified: false; modified: true]
!

changesRelativeToRepository: aRepository
	| ancestorVersion ancestorSnapshot |
	ancestorVersion _ aRepository closestAncestorVersionFor: ancestry ifNone: [].
	ancestorSnapshot _ ancestorVersion ifNil: [MCSnapshot empty] ifNotNil: [ancestorVersion snapshot].
	^ package snapshot patchRelativeToBase: ancestorSnapshot
!

loaded: aVersion
	ancestry _ MCWorkingAncestry new addAncestor: aVersion info.
	requiredPackages _ OrderedCollection withAll: (aVersion dependencies collect: [:ea | ea package]).
	self modified: false.
	self changed
!

merge: targetVersion
	| ancestorInfo merger ancestorSnapshot packageSnapshot |
	targetVersion dependencies do: [:ea | ea resolve merge].
	ancestorInfo _ targetVersion info commonAncestorWith: ancestry.
	
	ancestorInfo = targetVersion info ifTrue: [^ MCNoChangesException signal].
	
	packageSnapshot _ package snapshot.
	ancestorSnapshot _ ancestorInfo
							ifNotNil: [(self findSnapshotWithVersionInfo: ancestorInfo)]
							ifNil: [self notifyNoCommonAncestorWith: targetVersion.  MCSnapshot empty].
	
	(ancestry ancestors size = 1
		and: [ancestry ancestors first = ancestorInfo]
		and: [(packageSnapshot patchRelativeToBase: ancestorSnapshot) isEmpty])
				ifTrue: [^ targetVersion load].
	
	merger _ MCThreeWayMerger 
				base: packageSnapshot
				target: targetVersion snapshot
				ancestor: ancestorSnapshot.
	((MCMergeResolutionRequest new merger: merger)
		signal: 'Merging ', targetVersion info name) = true ifTrue:
			[merger loadWithNameLike: targetVersion info name.
			ancestry addAncestor: targetVersion info].
	self changed
!

merged: aVersion
	ancestry addAncestor: aVersion info.
	self changed
!

newVersion
	^ (self requestVersionNameAndMessageWithSuggestion: self uniqueVersionName) ifNotNilDo:
		[:pair |
		self newVersionWithName: pair first message: pair last].
!

newVersionWithName: nameString message: messageString
	| info deps |
	info _ ancestry infoWithName: nameString message: messageString.
	ancestry _ MCWorkingAncestry new addAncestor: info.
	self modified: true; modified: false.
	
	deps _ self requiredPackages collect:
		[:ea | 
		MCVersionDependency
			package: ea
			info: ea workingCopy currentVersionInfo].

	^ MCVersion
		package: package
		info: info
		snapshot: package snapshot
		dependencies: deps
!

notifyNoCommonAncestorWith: aVersion
	self notify:
'Could not find a common ancestor between (',
aVersion info name,
') and (',
ancestry ancestorString, ').
Proceeding with this merge may cause spurious conflicts.'
!

unload
	MCPackageLoader unloadPackage: self package.
	self unregister.
! !

!MCWorkingCopy methodsFor:'private'!

findSnapshotWithVersionInfo: aVersionInfo
	^ aVersionInfo
		ifNil: [MCSnapshot empty]
		ifNotNil: [(self repositoryGroup versionWithInfo: aVersionInfo) snapshot]
!

initialize
	super initialize.
	ancestry _ MCWorkingAncestry new
!

nextVersionName
    ^self nextVersionNameWithTemplate: '%(PACKAGE)-%(AUTHOR).%(REVISION_NUMBER)'

    "Modified: / 06-06-2013 / 20:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextVersionNameWithTemplate: template
    "Return next version name based on given template.
     Following parameters are expanded:
        REVISION_NUMBER ... sequential version number (the higher, the newer, basically)
        PACKAGE ........... package name
        AUTHOR ............ author of the version
    "

        | branch oldName |
        ancestry ancestors isEmpty
                ifTrue: [counter ifNil: [counter := 0]. branch := package monticelloName asString copy replaceAll: $/ with: $_; replaceAll: $: with: $_]
                ifFalse:
                        [oldName := ancestry ancestors first name.
                        oldName last isDigit
                                ifFalse: [branch := oldName]
                                ifTrue: [branch := oldName copyUpToLast: $-].
                        counter ifNil: [
                                counter := (ancestry ancestors collect: [:each |
                                        each name last isDigit
                                                ifFalse: [0]
                                                ifTrue: [(each name copyAfterLast: $-) extractNumber]]) max]].

        counter := counter + 1.
        ^template expandPlaceholdersWith:
            (Dictionary new
                at: 'REVISION_NUMBER' put: counter;
                at: 'PACKAGE' put: branch;
                at: 'AUTHOR' put: ((OperatingSystem getFullUserNameFromID: OperatingSystem getUserID) reject:[:c|c isSeparator]);
                yourself)

    "Created: / 06-06-2013 / 20:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

possiblyNewerVersions

	^Array streamContents: [:strm |
		self repositoryGroup repositories do: [:repo |
			strm nextPutAll: (self possiblyNewerVersionsIn: repo)]]
!

possiblyNewerVersionsIn: aRepository

	^aRepository possiblyNewerVersionsOfAnyOf: self ancestors
!

requestVersionNameAndMessageWithSuggestion: aString
        ^ (MCVersionNameAndMessageRequest new suggestedName: aString) raiseRequest

    "Modified: / 23-08-2011 / 07:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

uniqueVersionName
	|versionName|
	counter _ nil.
	[versionName _ self nextVersionName.
	self repositoryGroup includesVersionNamed: versionName] whileTrue.
	^ versionName
!

versionSeparator
	^ $_
! !

!MCWorkingCopy methodsFor:'repositories'!

repositoryGroup
	^ repositoryGroup ifNil: [repositoryGroup _ MCRepositoryGroup new]
!

repositoryGroup: aRepositoryGroup
	repositoryGroup _ aRepositoryGroup
! !

!MCWorkingCopy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWorkingCopy.st,v 1.7 2014-02-25 13:39:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWorkingCopy.st,v 1.7 2014-02-25 13:39:03 cg Exp $'
! !


MCWorkingCopy initialize!
