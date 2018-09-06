"{ Package: 'stx:goodies/monticello' }"

MCReader subclass:#MCSnapshotReader
	instanceVariableNames:'definitions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!

!MCSnapshotReader class methodsFor:'documentation'!

documentation
"
    I'm useless and can be safely removed. 
    I'm only referenced in MCMczReader>>extractDefinitionsFrom: and it can be replaced by MCReader.
"
! !

!MCSnapshotReader class methodsFor:'as yet unclassified'!

snapshotFromStream: aStream
	^ (self on: aStream) snapshot
! !

!MCSnapshotReader methodsFor:'as yet unclassified'!

definitions
	definitions ifNil: [self loadDefinitions].
	^ definitions
!

snapshot
	^ MCSnapshot fromDefinitions: self definitions
! !

!MCSnapshotReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSnapshotReader.st,v 1.5 2013-05-15 12:03:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSnapshotReader.st,v 1.5 2013-05-15 12:03:46 cg Exp $'
!

version_SVN
    ^ '$Id: MCSnapshotReader.st,v 1.5 2013-05-15 12:03:46 cg Exp $'
! !

