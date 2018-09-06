"{ Package: 'stx:goodies/monticello' }"

MCMczReader subclass:#MCMcdReader
	instanceVariableNames:'baseInfo patch'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCMcdReader class methodsFor:'as yet unclassified'!

extension
	^ 'mcd'
! !

!MCMcdReader methodsFor:'as yet unclassified'!

baseInfo
	^ baseInfo ifNil: [self loadBaseInfo]
!

basicVersion
	^ MCDiffyVersion
		package: self package
		info: self info
		dependencies: self dependencies
		baseInfo: self baseInfo
		patch: self patch
!

buildPatchFrom: oldDefinitions to: newDefinitions
	^ MCPatch
		fromBase: (MCSnapshot fromDefinitions: oldDefinitions)
		target: (MCSnapshot fromDefinitions: newDefinitions)
!

loadBaseInfo
	^ baseInfo := self extractInfoFrom: (self parseMember: 'base')
!

loadPatch
	| old new m |
	(m := self zip memberNamed: 'patch.bin') ifNotNil:
		[[^ patch := (DataStream on: m contentStream) next ]
			on: Error do: [:fallThrough ]].
	definitions := OrderedCollection new.
	(self zip membersMatching: 'old/*')
		do: [:m | self extractDefinitionsFrom: m].
	old := definitions asArray.
	definitions := OrderedCollection new.
	(self zip membersMatching: 'new/*')
		do: [:m | self extractDefinitionsFrom: m].
	new := definitions asArray.
	^ patch := self buildPatchFrom: old to: new.
	
!

patch
	^ patch ifNil: [self loadPatch]
! !

!MCMcdReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMcdReader.st,v 1.4 2012-09-11 21:22:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMcdReader.st,v 1.4 2012-09-11 21:22:45 cg Exp $'
!

version_SVN
    ^ '§Id: MCMcdReader.st 17 2010-10-13 12:07:52Z vranyj1 §'
! !
