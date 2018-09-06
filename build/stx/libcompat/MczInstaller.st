"{ Encoding: utf8 }"

"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MczInstaller
	instanceVariableNames:'stream zip'
	classVariableNames:'Versions'
	poolDictionaries:''
	category:'System-Support'
!


!MczInstaller class methodsFor:'instance creation'!

on: aStream
	^ self new stream: aStream
! !

!MczInstaller class methodsFor:'*monticello'!

unloadMonticello

        "self unloadMonticello"
    "
        self breakDependents.
        Smalltalk globals
                at: #MCWorkingCopy
                ifPresent: [ :wc |
                        wc allInstances
                                do: [ :ea |
                                        Versions at: ea package name put: ea currentVersionInfo asDictionary.
                                        ea breakDependents.
                                        Smalltalk globals at: #SystemChangeNotifier ifPresent: [ :scn | scn uniqueInstance noMoreNotificationsFor: ea ] ]
                                displayingProgress: 'Saving version info...' ]. ""keep things simple and don't unload any class extensions""
        (ChangeSet superclassOrder: (PackageInfo named: 'Monticello') classes) reverseDo: [ :ea | ea removeFromSystem ].
        self registerForFileList
    "

    "Modified: / 29-08-2010 / 08:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MczInstaller class methodsFor:'installing'!

installFileNamed: aFileName
	self installStream: (FileStream readOnlyFileNamed: aFileName)
!

installStream: aStream
	(self on: aStream) install
! !

!MczInstaller class methodsFor:'services'!

extension
	^ 'mcz'
!

fileReaderServicesForFile: fileName suffix: suffix
	^({ self extension. '*' } includes: suffix)
		ifTrue: [ self services ]
		ifFalse: [#()].
!

initialize

    self clearVersionInfo.
    self registerForFileList.

    "Modified: / 29-08-2010 / 08:48:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadVersionFile: fileName
	self installFileNamed: fileName
!

registerForFileList

    "
        Smalltalk globals at: #MCReader ifAbsent: [ FileList registerFileReader: self ]
    "

    "Modified: / 29-08-2010 / 08:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

serviceLoadVersion
	^ SimpleServiceEntry
		provider: self
		label: 'load'
		selector: #loadVersionFile:
		description: 'load a package version'
!

services
	^ Array with: self serviceLoadVersion
! !

!MczInstaller class methodsFor:'versioninfo'!

clearVersionInfo
	Versions := Dictionary new
!

storeVersionInfo: aVersion
	Versions
		at: aVersion package name
		put: aVersion info asDictionary
!

versionInfo
	^ Versions
! !

!MczInstaller methodsFor:'accessing'!

extractPackageName
	^ (self parseMember: 'package') at: #name.
	
!

extractVersionInfo
	^ self extractInfoFrom: (self parseMember: 'version')
!

recordVersionInfo
	Versions
		at: self extractPackageName
		put: self extractVersionInfo
!

scanner
	^ Scanner new
!

stream: aStream
	stream := aStream
! !

!MczInstaller methodsFor:'installation'!

install
        | sources |
        zip := ZipArchive new.
        zip readingFrom: stream.
        self checkDependencies ifFalse: [^false].
        self recordVersionInfo.
        sources := (zip membersMatching: 'snapshot/*')
                                asSortedCollection: [:a :b | a fileName < b fileName].
        sources do: [:src | self installMember: src].
        ^ true

    "Modified: / 16-07-2017 / 13:50:24 / cg"
!

installMember: member
    self useNewChangeSetDuring:[ 
        | str |

        Smalltalk isSmalltalkX ifTrue:[
            "/ str := zip readStreamFor:member fileName.
            "/ str := zip upToEnd utf8Decoded.
            str := (zip extract:member fileName asString:true).
            str := [ str utf8Decoded ] on:Error do:[ str ].
            ActivityNotification notify:('loading ', member fileName).
            str readStream fileIn.
        ] ifFalse:[
            str := member contentStream text.
            str setConverterForCode.
            str fileInAnnouncing: 'loading ', member fileName
        ].
    ]
! !

!MczInstaller methodsFor:'utilities'!

associate: tokens
        | result |
        result := Dictionary new.
        tokens pairWiseDo: [:key :value |
                                        | tmp |
                                        tmp := value.
                                        value isString ifFalse: [tmp := value collect: [:ea | self associate: ea]].
                                        value = 'nil' ifTrue: [tmp := ''].
                                        result at: key put: tmp].
        ^ result
!

checkDependencies
	| dependencies unmet |
	dependencies := (zip membersMatching: 'dependencies/*')
			collect: [:member | self extractInfoFrom: (self parseMember: member)].
	unmet := dependencies reject: [:dep |
		self versions: Versions anySatisfy: (dep at: #id)].
	^ unmet isEmpty or: [
		self confirm: (String streamContents: [:s|
			s nextPutAll: 'The following dependencies seem to be missing:'; cr.
			unmet do: [:each | s nextPutAll: (each at: #name); cr].
			s nextPutAll: 'Do you still want to install this package?'])]
!

extractInfoFrom: dict
        dict at: #id put: (UUID readFrom: (dict at: #id)).
        dict at: #date ifPresent: [:d | d isEmpty ifFalse: [dict at: #date put: (Date readFrom: d)]].
        dict at: #time ifPresent: [:t | t isEmpty ifFalse: [dict at: #time put: (Time readFrom: t)]].
        dict at: #ancestors ifPresent: [:a | dict at: #ancestors put: (a collect: [:ea | self extractInfoFrom: ea])].
        ^ dict
!

parseMember: fileName
	| tokens |
	tokens := (self scanner scanTokens: (zip contentsOf: fileName)) first.
	^ self associate: tokens
!

useNewChangeSetDuring: aBlock
        | changeHolder oldChanges newChanges |

        changeHolder := (ChangeSet respondsTo: #newChanges:)
                                                ifTrue: [ChangeSet]
                                                ifFalse: [Smalltalk].
        oldChanges := (ChangeSet respondsTo: #current)
                                                ifTrue: [ChangeSet current]
                                                ifFalse: [Smalltalk changes].

        newChanges := ChangeSet new name: (ChangeSet uniqueNameLike: self extractPackageName).
        (ChangeSet respondsTo: #current:)
            ifTrue: [ChangeSet current:newChanges]
            ifFalse:[changeHolder newChanges: newChanges].
        [
            aBlock value
        ] ensure: [
            (ChangeSet respondsTo: #current:)
                ifTrue: [ChangeSet current:oldChanges]
                ifFalse:[changeHolder newChanges: oldChanges].
        ].
!

versions: aVersionList anySatisfy: aDependencyID
	^ aVersionList anySatisfy: [:version |
			aDependencyID = (version at: #id)
				or: [self versions: (version at: #ancestors) anySatisfy: aDependencyID]]
! !

!MczInstaller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/MczInstaller.st,v 1.5 2018-03-07 16:25:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/MczInstaller.st,v 1.5 2018-03-07 16:25:00 cg Exp $'
!

version_SVN
    ^ '$Id: MczInstaller.st,v 1.5 2018-03-07 16:25:00 cg Exp $'
! !


MczInstaller initialize!
