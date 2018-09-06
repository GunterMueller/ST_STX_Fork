"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCVersionReader subclass:#MCMczReader
	instanceVariableNames:'zip infoCache'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCMczReader class methodsFor:'accessing'!

extension
	^ 'mcz'
! !

!MCMczReader class methodsFor:'testing'!

canReadFileNamed: fileName
    "Hack to use MCStXMczReader on Smalltalk/X"

    ^ ((Smalltalk respondsTo: #isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) 
        ifTrue:[ self == MCStXMczReader and: [ super canReadFileNamed: fileName ] ]
        ifFalse:[ super canReadFileNamed: fileName ].

    "Created: / 10-05-2015 / 06:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsDependencies
	^ true
!

supportsVersions
	^ true
! !

!MCMczReader methodsFor:'as yet unclassified'!

associate: tokens

    ^MCLazyPropertyDictionary withTokens: tokens.        

        "
        | result |
        result := Dictionary new.
        tokens pairWiseDo: [:key :value | 
                                        | tmp |
                                        tmp := value.
                                        value isString ifFalse: [tmp := value collect: [:ea | self associate: ea]].
                                        value = 'nil' ifTrue: [tmp := ''].
                                        result at: key put: tmp].
        ^ result
        "

    "Modified: / 28-10-2010 / 15:25:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractDefinitionsFrom: member
        | reader rc |
        (rc := (MCSnapshotReader readerClassForFileNamed: member fileName))
                ifNotNil: 
                    [ reader := rc on: (self zip contentsOf: member fileName).
                    definitions addAll: reader definitions]

    "Modified: / 11-09-2010 / 21:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractDependencyFrom: zipMember
	^ MCVersionDependency
		package: (MCPackage named: (zipMember fileName copyAfterLast: $/))
		info: (self extractInfoFrom: (self parseMember: zipMember fileName))
!

extractInfoFrom: dict
        ^ self infoCache at: (dict at: #id) ifAbsentPut:
                [MCLazyVersionInfo withProperties: dict]
                "
                [MCVersionInfo
                        name: (dict at: #name ifAbsent: [''])
                        id: (UUID fromString: (dict at: #id))
                        message: (dict at: #message ifAbsent: [''])
                        date: ([Date fromString: (dict at: #date) ] on: Error do: [ :ex | ex return: nil ])
                        time: ([ Time fromString:(dict at: #time)] on: Error do: [ :ex | ex return: nil ])
                        author: (dict at: #author ifAbsent: [''])
                        ancestors: ((dict at: #ancestors ifAbsent:#()) collect: [:ea | self extractInfoFrom: ea])
                        stepChildren: ((dict at: #stepChildren ifAbsent: [#()]) collect: [:ea | self extractInfoFrom: ea])]
                "

    "Modified: / 28-10-2010 / 17:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoCache
	^ infoCache ifNil: [infoCache := Dictionary new]
!

loadDefinitions
        |doNotShowAgainHolder|

        doNotShowAgainHolder := false asValue.

        definitions := OrderedCollection new.
        (self zip isValidPath: 'snapshot.bin') ifTrue:[ 
            [
                ^ definitions := (DataStream on: (self zip contentsOf: 'snapshot.bin') 
                                    asByteArray readStream) next definitions
            ] on: Error do: [:fallThrough|
                doNotShowAgainHolder value ifTrue:[fallThrough proceed].

                "/ self halt:fallThrough description
                Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
                    ex box addCheckBoxAtBottom:'Do not show this dialog again.' on:doNotShowAgainHolder.
                ] do:[
                    |answer|

                    answer := Dialog confirmWithCancel:(fallThrough description,'\\Try proceeding with binary? (if NO, source is loaded)') withCRs. 
                    answer isNil ifTrue:[AbortOperationRequest raise].
                    answer ifTrue:[
                        fallThrough proceed
                    ].
                ].
            ]
        ].
        "otherwise (binay broken), try source"

        self breakPoint:#jv.
        (self zip membersMatching: 'snapshot/*')
                do: [:m | self extractDefinitionsFrom: m].

    "Modified: / 14-09-2010 / 21:22:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2011 / 16:55:00 / cg"
!

loadDependencies
	dependencies := (self zip membersMatching: 'dependencies/*') collect: [:m | self extractDependencyFrom: m].
	dependencies := dependencies asArray.

!

loadPackage
	| dict |
	dict := self parseMember: 'package'.
	package := MCPackage named: (dict at: #name)
!

loadVersionInfo
	info := self extractInfoFrom: (self parseMember: 'version')
!

parseMember: fileName
	| tokens |
	tokens := (self scanner scanTokens: (self zip contentsOf: fileName)) first.
	^ self associate: tokens
!

scanner
	^ MCScanner
!

zip
        (zip isNil or:[zip fileSize == 0]) ifTrue:[
            zip := ZipArchive readingFrom:stream
        ].
        ^ zip

    "Modified: / 07-09-2011 / 14:55:18 / cg"
! !

!MCMczReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMczReader.st,v 1.8 2014-02-12 17:30:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMczReader.st,v 1.8 2014-02-12 17:30:06 cg Exp $'
!

version_SVN
    ^ '$Id: MCMczReader.st,v 1.8 2014-02-12 17:30:06 cg Exp $'
! !

