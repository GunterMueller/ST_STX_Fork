"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCPackage
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Base'
!


!MCPackage class methodsFor:'as yet unclassified'!

named: aString
	^ self new name: aString
! !

!MCPackage methodsFor:'accessing'!

monticelloName
    ^ self isStXPackage 
        ifTrue:[ self packageInfo projectDefinition monticelloName ]
        ifFalse:[ name ].

    "Created: / 29-05-2013 / 02:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^name

    "Modified: / 29-05-2013 / 02:09:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name: aString
        name := aString
! !

!MCPackage methodsFor:'comparing'!

= other
	^ other species = self species and: [other name sameAs: name]
!

hash
	^ name asLowercase hash
! !

!MCPackage methodsFor:'operations'!

snapshot
        | packageInfo definitions categories |
        packageInfo := self packageInfo.
	packageInfo classes do:[:cls|cls autoload].
        definitions := OrderedCollection new.
        categories := packageInfo systemCategories.
        categories isEmpty ifFalse: [ definitions add: (MCOrganizationDefinition categories: categories) ].
        packageInfo methods do: [:ea | definitions add: ea asMethodDefinition] displayingProgress: 'Snapshotting methods...'.
        (packageInfo respondsTo: #overriddenMethods) ifTrue:
                [packageInfo overriddenMethods
                        do: [:ea | definitions add:
                                        (packageInfo changeRecordForOverriddenMethod: ea) asMethodDefinition]
                        displayingProgress: 'Searching for overrides...'].
        packageInfo classes do: [:ea | definitions addAll: ea classDefinitions] displayingProgress: 'Snapshotting classes...'.
        (packageInfo respondsTo: #hasPreamble) ifTrue: [
                packageInfo hasPreamble ifTrue: [definitions add: (MCPreambleDefinition from: packageInfo)].
                packageInfo hasPostscript ifTrue: [definitions add: (MCPostscriptDefinition from: packageInfo)].
                packageInfo hasPreambleOfRemoval ifTrue: [definitions add: (MCRemovalPreambleDefinition from: packageInfo)].
                packageInfo hasPostscriptOfRemoval ifTrue: [definitions add: (MCRemovalPostscriptDefinition from: packageInfo)]]. 
        ^ (MCSnapshot fromDefinitions: definitions)

    "Modified: / 31-05-2013 / 00:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unload
	^ self workingCopy unload
! !

!MCPackage methodsFor:'printing & storing'!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
!

storeOn: aStream
	aStream
		nextPutAll: 'MCPackage';
		space; nextPutAll: 'named: '; store: name.
! !

!MCPackage methodsFor:'queries'!

hasWorkingCopy
	^ MCWorkingCopy registry includesKey: self
!

packageInfo

    (Smalltalk allPackageIDs includes: name) ifTrue:[
        ^ MCStXPackageInfo named: name
    ] ifFalse:[
        ^ PackageInfo named: name
    ]

    "Modified: / 23-08-2011 / 13:31:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2011 / 15:53:22 / cg"
!

workingCopy
	^ MCWorkingCopy forPackage: self.
! !

!MCPackage methodsFor:'testing'!

isStXPackage
    |c|

    ^(c := ProjectDefinition definitionClassForPackage: name) notNil
      and:[c isProjectDefinition].

    "Created: / 29-05-2013 / 01:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCPackage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

