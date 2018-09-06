"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCRepositoryGroup
	instanceVariableNames:'repositories'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!

MCRepositoryGroup class instanceVariableNames:'default'

"
 No other class instance variables are inherited by this class.
"
!

MCRepositoryGroup comment:'A singleton class, holds the list of repositories. Can look for a requested VersionInfo among its repositories.'
!


!MCRepositoryGroup class methodsFor:'as yet unclassified'!

default
    default isNil ifTrue: [default := self new].
    ^default

    "Modified: / 04-04-2012 / 11:04:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
	^ self basicNew initialize
! !

!MCRepositoryGroup methodsFor:'as yet unclassified'!

addRepository: aRepository
    ((repositories includes: aRepository) or: [aRepository == MCCacheRepository default])
	ifFalse: [
	    repositories add: aRepository.
	    self class default addRepository: aRepository.
	    self changed: #repositories
    ].

    "Modified: / 04-12-2011 / 09:04:24 / cg"
!

flushRepositories
    "/ cg: mhmh - what should we do here ?
    "/ called by UserPreferences >> mcRepositories:

    self initializeRepositoriesFromUserSettings

    "Created: / 01-12-2011 / 20:35:13 / cg"
    "Modified (comment): / 24-01-2012 / 09:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includes: aRepository
	^ self repositories includes: aRepository
!

includesVersionNamed: aString
	self repositoriesDo: [:ea | (ea includesVersionNamed: aString) ifTrue: [^ true]].
	^ false
!

initialize
    "/ repositories _ OrderedCollection new
    self initializeRepositoriesFromUserSettings

    "Modified: / 04-12-2011 / 09:07:23 / cg"
!

initializeRepositoriesFromUserSettings
    |litArray reps|

    litArray := UserPreferences current mcRepositories.
    litArray == false ifTrue:[
        "there is no entry in the UserPreferneces, so false - the default value - is returned"
        reps := #().
    ] ifFalse:[
        reps := litArray decodeAsLiteralArray.
    ].
    repositories := reps asOrderedCollection.

    "Created: / 04-12-2011 / 09:06:53 / cg"
    "Modified: / 04-04-2012 / 11:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeRepository: aRepository
	repositories remove: aRepository ifAbsent: [].
	self changed: #repositories
!

repositories
    ^ ((OrderedSet with:MCCacheRepository default)
                addAll:repositories;
                yourself)
            asOrderedCollection
        select: [ :ea | ea isValid ]

    "Modified: / 04-12-2011 / 09:04:42 / cg"
!

repositories: anOrderedCollection

    repositories := anOrderedCollection copy.
    "Ensure, that repositories contain cache as first"
    repositories remove: MCCacheRepository default ifAbsent:[].
    repositories addFirst: MCCacheRepository default.
    self == self class default ifTrue:[
        UserPreferences current mcRepositories: repositories asArray literalArrayEncoding
    ].

    "Created: / 04-04-2012 / 11:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoriesDo: aBlock
	self repositories do: [:ea | [aBlock value: ea] on: Error do: []]
! !

!MCRepositoryGroup methodsFor:'searching'!

versionWithInfo: aVersionInfo
	^self versionWithInfo: aVersionInfo ifNone: [ self error: 'Could not find version ', aVersionInfo name printString,'. Maybe you need to add a repository?' ]
!

versionWithInfo: aVersionInfo ifNone: aBlock
	self repositoriesDo: [:ea | (ea versionWithInfo: aVersionInfo) ifNotNilDo: [:v | ^ v]].
	^aBlock value
! !

!MCRepositoryGroup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryGroup.st,v 1.9 2013-04-18 23:51:57 cg Exp $'
! !

