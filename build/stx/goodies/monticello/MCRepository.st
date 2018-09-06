"{ Package: 'stx:goodies/monticello' }""{ NameSpace: Smalltalk }"Object subclass:#MCRepository	instanceVariableNames:'creationTemplate storeDiffs'	classVariableNames:'Settings'	poolDictionaries:''	category:'SCM-Monticello-Repositories'!


!MCRepository class methodsFor:'initialization'!

initialize
        "self initialize"
    "
        ExternalSettings registerClient: self.
    "

    "Modified: / 13-10-2010 / 14:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepository class methodsFor:'as yet unclassified'!

fillInTheBlankRequest
	self subclassResponsibility.
!

morphicConfigure
	^ self new
! !

!MCRepository class methodsFor:'external settings'!

fetchExternalSettingsIn: aDirectory
	"Scan for settings file"
	"MCRepository fetchExternalSettingsIn: ExternalSettings preferenceDirectory"

	| stream |
	(aDirectory fileExists: self settingsFileName)
		ifFalse: [^self].
	stream := aDirectory readOnlyFileNamed: self settingsFileName.
	stream
		ifNotNil: [
			[Settings := ExternalSettings parseServerEntryArgsFrom: stream]
				ensure: [stream close]].

!

releaseExternalSettings
	Settings := nil.

!

settingsFileName
	^ 'mcSettings'
! !

!MCRepository class methodsFor:'queries'!

allConcreteSubclasses
	^ self withAllSubclasses reject: [:ea | ea isAbstract]
!

creationTemplate
	self subclassResponsibility.
!

description
	^ nil
!

isAbstract
	^ self description isNil
! !

!MCRepository methodsFor:'accessing'!

creationTemplate
	^ creationTemplate
!

creationTemplate: aString
	self creationTemplate ifNotNil: [ self error: 'Creation template already set for this MCRepository instance.' ].
	
	creationTemplate := aString.
!

description
	^ self class name
! !

!MCRepository methodsFor:'as yet unclassified'!

alwaysStoreDiffs
	^ storeDiffs ifNil: [false]
!

asCreationTemplate
	^ self creationTemplate
!

doAlwaysStoreDiffs
	storeDiffs := true
!

doNotAlwaysStoreDiffs
	storeDiffs := false
!

notificationForVersion: aVersion
	^ MCVersionNotification version: aVersion repository: self
!

notifyList
	^ #()
!

prepareVersionForStorage: aVersion
    self alwaysStoreDiffs ifTrue: [
        ^ aVersion 
            asDiffAgainst: (self closestAncestorVersionFor: aVersion info ifNone: [^ aVersion])
    ] ifFalse: [
        ^ aVersion
    ]
!

sendNotificationsForVersion: aVersion
	| notification notifyList |
	notifyList := self notifyList.
	notifyList isEmpty ifFalse:
		[notification := self notificationForVersion: aVersion.
		notifyList do: [:ea | notification notify: ea]]
! !

!MCRepository methodsFor:'comparing'!

= other
	^ other species = self species and: [other description = self description]
!

hash
	^ self description hash
! !

!MCRepository methodsFor:'interface'!

includesVersionNamed: aString
	self subclassResponsibility
!

versionWithInfo: aVersionInfo
	^ self versionWithInfo: aVersionInfo ifAbsent: [nil]
!

versionWithInfo: aVersionInfo ifAbsent: aBlock
	self subclassResponsibility 
! !

!MCRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	self subclassResponsibility
!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self description;
		nextPut: $).
!

storeVersion: aVersion
	self basicStoreVersion: (self prepareVersionForStorage: aVersion).
	self sendNotificationsForVersion: aVersion
! !

!MCRepository methodsFor:'queries'!

closestAncestorVersionFor: anAncestry ifNone: errorBlock
	| v | 
	anAncestry breadthFirstAncestorsDo:
		[:ancestorInfo |
		(v := self versionWithInfo: ancestorInfo) ifNotNil: [ ^ v]].
	^ errorBlock value
!

possiblyNewerVersionsOfAnyOf: someVersions
	^#()
! !

!MCRepository methodsFor:'testing'!

isValid
	^true
! !

!MCRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepository.st,v 1.8 2015-02-07 10:17:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepository.st,v 1.8 2015-02-07 10:17:20 cg Exp $'
!

version_SVN

    ^'$Id: MCRepository.st,v 1.8 2015-02-07 10:17:20 cg Exp $'
! !


MCRepository initialize!
