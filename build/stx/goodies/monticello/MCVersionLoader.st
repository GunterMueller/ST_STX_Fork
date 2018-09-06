"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersionLoader
	instanceVariableNames:'versions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Loading'
!


!MCVersionLoader class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCVersionLoader class methodsFor:'as yet unclassified'!

loadVersion: aVersion
	self new
		addVersion: aVersion;
		load
! !


!MCVersionLoader methodsFor:'*metacello-mc'!

versions

	^versions
! !

!MCVersionLoader methodsFor:'checking'!

checkForModifications
	| modifications |
	modifications := versions select: [:ea | ea package workingCopy modified].
	modifications isEmpty ifFalse: [self warnAboutLosingChangesTo: modifications].
!

checkIfDepIsOlder: aDependency
	^ aDependency isOlder not 
		or: [self confirm: 'load older dependency ', aDependency versionInfo name , '?']
!

confirmMissingDependency: aDependency
	| name |
	name := aDependency versionInfo name.
	(self confirm: 'Can''t find dependency ', name, '. ignore?')
		ifFalse: [self error: 'Can''t find dependency ', name]
!

depAgeIsOk: aDependency
	^ aDependency isOlder not 
		or: [self confirm: 'load older dependency ', aDependency versionInfo name , '?']
!

warnAboutLosingChangesTo: versionCollection
	self notify: (String streamContents: [:s |
		s nextPutAll: 'You are about to load new versions of the following packages that have unsaved changes in the image.  If you continue, you will lose these changes.'; cr.
		versionCollection do:
			[:ea |
			s cr; space; space; nextPutAll: ea package name]])
! !

!MCVersionLoader methodsFor:'initialization'!

initialize
	super initialize.
	versions := OrderedCollection new
! !

!MCVersionLoader methodsFor:'loading'!

addDependency: aDependency
	| dep |
	aDependency isCurrent ifTrue: [^ self].
	(self depAgeIsOk: aDependency) ifFalse: [^ self].
	dep := aDependency resolve.
	dep
		ifNil: [self confirmMissingDependency: aDependency]
		ifNotNil: [(versions includes: dep) ifFalse: [self addVersion: dep]]
!

addVersion: aVersion
	aVersion dependencies do: [ :ea | self addDependency: ea].
	versions add: aVersion.

!

load
	self loadWithNameLike: versions first info name.

!

loadWithNameLike: aString
        | loader |
        self checkForModifications.
        loader := versions size > 1
                ifTrue: [MCMultiPackageLoader new]
                ifFalse: [MCPackageLoader new].
        versions do: [:ea |
                ea canOptimizeLoading
                        ifTrue: [ea patch applyTo: loader]
                        ifFalse: [loader updatePackage: ea package withSnapshot: ea snapshot]].
        "/MCStXPackageQuery answer: versions first package name do: [
            loader loadWithNameLike: aString.
        "/].
        versions do: [:ea | ea workingCopy loaded: ea]

    "Modified: / 09-11-2010 / 17:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionLoader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionLoader.st,v 1.5 2012-09-11 21:30:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionLoader.st,v 1.5 2012-09-11 21:30:44 cg Exp $'
!

version_SVN
    ^ '§Id: MCVersionLoader.st 25 2010-11-09 18:50:31Z vranyj1 §'
! !
