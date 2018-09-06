"{ Package: 'stx:goodies/monticello' }"

MCScriptDefinition subclass:#MCRemovalPreambleDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCRemovalPreambleDefinition class methodsFor:'as yet unclassified'!

scriptSelector
	^ #preambleOfRemoval
! !

!MCRemovalPreambleDefinition methodsFor:'comparing'!

sortKey
	^ 'zzz' "force to the end so it gets unloaded early"
! !

!MCRemovalPreambleDefinition methodsFor:'installing'!

unload
	super unload.
	self evaluate
! !

!MCRemovalPreambleDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemovalPreambleDefinition.st,v 1.5 2013-01-18 13:02:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemovalPreambleDefinition.st,v 1.5 2013-01-18 13:02:40 cg Exp $'
!

version_SVN
    ^ '§Id: MCRemovalPreambleDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

