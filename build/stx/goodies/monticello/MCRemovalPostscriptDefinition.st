"{ Package: 'stx:goodies/monticello' }"

MCScriptDefinition subclass:#MCRemovalPostscriptDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCRemovalPostscriptDefinition class methodsFor:'as yet unclassified'!

scriptSelector
	^ #postscriptOfRemoval 
! !

!MCRemovalPostscriptDefinition methodsFor:'installing'!

unload
	super unload.
	self evaluate
! !

!MCRemovalPostscriptDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemovalPostscriptDefinition.st,v 1.5 2013-01-18 13:02:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemovalPostscriptDefinition.st,v 1.5 2013-01-18 13:02:38 cg Exp $'
!

version_SVN
    ^ '§Id: MCRemovalPostscriptDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

