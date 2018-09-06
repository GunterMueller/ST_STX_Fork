"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Object subclass:#VersionHistory
	instanceVariableNames:'versions'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

VersionHistory comment:'I am a version history.  A version history is a collection of VersionNumbers that together form a tree of versions.  I enforce rules about how versions are added and removed from the history.

To add a new version to a VersionHistory based on an existing version:

  VersionHistory startingAt1 addNewVersionBasedOn: ''1'' asVersion; yourself

If you add 2 new versions based on the same version, a branch will be started:

  VersionHistory startingAt1 
		addNewVersionBasedOn: ''1'' asVersion;
		addNewVersionBasedOn: ''1'' asVersion; 
		yourself

To remove a single version (note: only versions at the tip of a branch, or at the base of the trunk (if it has only one successor) can be individually removed):

  VersionHistory startingAt1 
		addNewVersionBasedOn: ''1'' asVersion;
		addNewVersionBasedOn: ''1'' asVersion; 
		remove: ''1.1'' asVersion;
		yourself

To remove an entire branch:

  VersionHistory startingAt1 
		addNewVersionBasedOn: ''1'' asVersion;
		addNewVersionBasedOn: ''1'' asVersion; 
		addNewVersionBasedOn: ''1.1'' asVersion; 
		addNewVersionBasedOn: ''1.2'' asVersion; 
		removeBranch: ''1.1'' asVersion;
		yourself

To remove a portion of the trunk:

  VersionHistory startingAt1 
		addNewVersionBasedOn: ''1'' asVersion;
		addNewVersionBasedOn: ''2'' asVersion; 
		addNewVersionBasedOn: ''3'' asVersion; 
		addNewVersionBasedOn: ''3'' asVersion; 
		removeTrunk: ''2'' asVersion;
		yourself

To get a string description of a version history:

  VersionHistory startingAt1 
		addNewVersionBasedOn: ''1'' asVersion;
		addNewVersionBasedOn: ''2'' asVersion; 
		addNewVersionBasedOn: ''3'' asVersion; 
		addNewVersionBasedOn: ''3'' asVersion; 
		treeString

Also, the following methods are useful for accessing the versions:

	#firstVersion
	#versionBefore:
	#versionsAfter:
	#mainLineStartingAt:
	#allVersionsAfter:
	#allVersionsBefore:
'
!

!VersionHistory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Taken from KomPackaging in squeak.

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 20.5.2003 / 08:28:06 / james"
! !

!VersionHistory class methodsFor:'as yet unclassified'!

fromCollection: aCollection
	"Note: this does not validate the continuity of version
	numbers passed in aCollection...need to add continuity
	checks in the future"

	^self new
		initializeVersionsFrom: aCollection;
		yourself
!

startingAt1

	^self startingAt: '1' asVersion
!

startingAt: aVersion

	^self new
		initializeVersionsAt: aVersion;
		yourself
! !

!VersionHistory methodsFor:'accessing'!

allVersionsAfter: aVersion
	"Answer all the versions based on aVersion."

	| answer |
	answer := Set new.
	versions do: [ :ea |
		((ea inSameBranchAs: aVersion) and: 
			[ea > aVersion]) ifTrue: [answer add: ea]].
	^answer
!

allVersionsBefore: aVersion
	"Answer all versions that came before aVersion"

	| answer |
	answer := Set new.
	versions do: [ :ea |
		((ea inSameBranchAs: aVersion) and: 
			[ea < aVersion]) ifTrue: [answer add: ea]].
	^answer
!

firstVersion
	"Answer the first version in the entire version history"

	^versions inject: versions anyOne into: [ :x :ea |
		(x inSameBranchAs: ea)
			ifTrue: [(x < ea) ifTrue: [x] ifFalse: [ea]]
			ifFalse: [ea]]
!

latestMainLineVersion

	^(self mainLineStartingAt: self firstVersion) last
!

mainLineStartingAt: aVersion
	"Answer all versions based on aVersion that are not branches (they have 
	the same number of digits with the same values, except the last value is
	greater than the last value of aVersion)."

	| answer tmp |
	answer := OrderedCollection new.
	tmp := aVersion.
	[versions includes: tmp] 
		whileTrue: 
			[answer add: tmp.
			tmp := tmp next].
	^answer
!

versionBefore: aVersion

	"Answer the version immediately preceeding aVersion."

	| tmp |
	(aVersion > '1' asVersion) ifFalse: [^nil].
	(versions includes: (tmp := aVersion previous)) ifFalse: [^nil].
	^tmp
!

versionsAfter: aVersion
	"Answer all the versions immediately following aVersion."

	| answer tmp |
	answer := Set new.
	tmp := aVersion next.
	(versions includes: aVersion next) ifTrue: [answer add: tmp].

	tmp := aVersion.
	[versions includes: (tmp := tmp branchNext)] whileTrue:
		[answer add: tmp].
	^answer
! !

!VersionHistory methodsFor:'adding'!

addNewVersionBasedOn: aVersion

	| tmp |
	(versions includes: aVersion) ifFalse: [^self error: 'Version is not in this history'].

	tmp := aVersion next.
	(versions includes: tmp) ifFalse: 
		[versions add: tmp.
		^tmp].

	tmp := aVersion.
	[versions includes: (tmp := tmp branchNext)] whileTrue.
	versions add: tmp.
	^tmp
	
! !

!VersionHistory methodsFor:'initialization'!

initializeVersionsAt: aVersion

	versions := Set new.
	versions add: aVersion.
!

initializeVersionsFrom: aCollection

	versions := Set new.
	aCollection do: [ :ea | versions add: ea ].
! !

!VersionHistory methodsFor:'printing'!

treeString
	"Answer a string that show the entire version history with
	each branch starting on a new line"

	^self treeStringStartingAt: self firstVersion
!

treeStringOn: strm startingAt: aVersion

	| tmp |
	tmp := self mainLineStartingAt: aVersion.
	tmp do: [ :ea | ea versionStringOn: strm. strm space; space ].
	strm cr.
	tmp do: 
		[ :ea | 
		(versions includes: ea branchNext)
			ifTrue: [self treeStringOn: strm startingAt: ea branchNext]].
!

treeStringStartingAt: aVersion

	| strm |
	strm := WriteStream on: ''.
	self treeStringOn: strm startingAt: aVersion.
	^strm contents
! !

!VersionHistory methodsFor:'removing'!

remove: aVersion
	"Remove aVersion from this version history."

	^self remove: aVersion ifAbsent: [self error: 'version not found'].
!

remove: aVersion ifAbsent: aBlock
	"Remove aVersion from this version history."

	(versions includes: aVersion) ifFalse: [^aBlock value].

	(self canRemove: aVersion) ifFalse:
		[^self error: 'Only versions at the beginning or end with no more than one follower may be removed'].

	versions remove: aVersion.
!

removeBranch: aVersion
	"Remove aVersion and all of it's successors, providing that
	aVersion is not the first version."

	(self versionBefore: aVersion)
		ifNil: [^self error: 'version is the first version in the history'].

	versions removeAll: (self allVersionsAfter: aVersion).
	versions remove: aVersion.
!

removeTrunk: aVersion
	"Remove aVersion and all of it's predecessors, providing there
	are no other branches stemming from the trunk.  Note, a trunk is defined
	as all versions, starting with the first version, that have only one successor."

	| tmp |
	(self versionsAfter: aVersion) size > 1 
		ifTrue: [^self error: 'version is at a fork'].

	tmp := self allVersionsBefore: aVersion.
	(tmp detect: [ :ea | (self versionsAfter: ea) size > 1 ] ifNone: [nil])
		ifNotNil: [^self error: 'not a trunk, other branches detected'].

	versions removeAll: tmp.
	versions remove: aVersion.
! !

!VersionHistory methodsFor:'testing'!

canRemove: aVersion

	| hasPriors followers |
	(versions includes: aVersion) ifFalse: [^false].
	hasPriors := (self versionBefore: aVersion) notNil.
	followers := self versionsAfter: aVersion.		

	"Don't allow versions in the middle to be extracted"
	(hasPriors and: [followers size > 0]) ifTrue: [^false].
	
	"Don't allow versions with more than one follower to be extracted"
	(hasPriors not and: [followers size > 1]) ifTrue: [^false].
	^true

!

includesVersion: aVersion

	^versions includes: aVersion
! !

!VersionHistory class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/VersionHistory.st,v 1.2 2006-01-10 09:31:46 cg Exp $'
! !
